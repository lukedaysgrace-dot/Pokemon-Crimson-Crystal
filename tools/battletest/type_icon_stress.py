#!/usr/bin/env python3
"""CGB type-icon content, move-animation, and multi-turn regression audit.

The native renderer matrix is counted separately from full battles. The oracle
decodes source icon art/colors independently, including current typing rules and
Illusion's displayed party member. Tests inspect WRAM, both VRAM map banks,
actual icon tile art, palette buffers, and (at stable checkpoints) screen pixels.
"""

import argparse
import hashlib
import io
import json
import re
import time
from pathlib import Path

import numpy as np

from runner import Harness
from state import Request
from symbols import ROOT, STATE_WAIT, STATE_DONE, STATE_ERROR, _parse_constants
from probability_checks import call
from type_icon_checks import read_cells, hidden_errors, CELLS, mon
from ui_checks import tile_text

TYPES = _parse_constants(ROOT / 'constants/type_constants.asm')
ACTIVE_TYPES = [TYPES[name] for name in ('NORMAL', 'FIGHTING', 'FLYING', 'POISON',
    'GROUND', 'ROCK', 'BUG', 'GHOST', 'STEEL', 'FIRE', 'WATER', 'GRASS', 'ELECTRIC',
    'PSYCHIC', 'ICE', 'DRAGON', 'DARK', 'FAIRY')]


class Oracle:
    def __init__(self, h):
        self.h = h
        self.art = {value: (ROOT / f'gfx/battle_type_icons/{name.lower()}.1bpp').read_bytes()
                    for name, value in TYPES.items() if value in ACTIVE_TYPES}
        self.art[TYPES['BIRD']] = bytes(8)
        colors = []
        for line in (ROOT / 'gfx/battle_type_icons/colors.pal').read_text().splitlines():
            match = re.match(r'\s*RGB\s+(\d+),\s*(\d+),\s*(\d+)', line)
            if match:
                r, g, b = map(int, match.groups())
                colors.append(r | g << 5 | b << 10)
        # The source has one REPT row for the ten reserved type slots.
        self.colors = dict(zip(ACTIVE_TYPES, colors[:6] + colors[7:10] + colors[11:]))
        self.colors[TYPES['BIRD']] = 0x7fff
        self.base = {}
        species_by_file = {}
        for line in (ROOT / 'data/pokemon/base_stats.asm').read_text().splitlines():
            match = re.search(r'"data/pokemon/base_stats/([^"]+)"\s*;\s*(\w+)', line)
            if match:
                species_by_file[match[1]] = match[2]
        for path in (ROOT / 'data/pokemon/base_stats').glob('*.asm'):
            body = path.read_text()
            match = re.search(r'^\s*db\s+(\w+),\s*(\w+)\s*; type', body, re.M)
            ability = re.search(r'^\s*abilities_for\s+(\w+)', body, re.M)
            species = ability[1] if ability else species_by_file.get(path.name, path.stem.upper())
            if match and match[1] in TYPES and match[2] in TYPES:
                self.base[species] = (TYPES[match[1]], TYPES[match[2]])
        self.tables = {}
        rules = (ROOT / 'engine/pokemon/gameplay_rules.asm').read_text()
        for name in ('OriginalPokemonTypes', 'RevampedPokemonTypes'):
            section = rules.split(name + ':', 1)[1]
            section = re.split(r'(?m)^[A-Za-z_][A-Za-z_0-9]*::?\s*$', section, maxsplit=1)[0]
            entries = {}
            for match in re.finditer(r'^\s*dw\s+(\w+)\s*\n\s*db\s+(\w+),\s*(\w+)', section, re.M):
                if match[2] in TYPES and match[3] in TYPES:
                    entries[match[1]] = (TYPES[match[2]], TYPES[match[3]])
            self.tables[name] = entries

    def pair(self, side):
        h, m = self.h, self.h.battle.mem
        slot = m.read('wPlayerIllusionSlot' if side == 'player' else 'wEnemyIllusionSlot')
        if slot:
            prefix = f'wPartyMon{slot}' if side == 'player' else f'wOTPartyMon{slot}'
            species = h.con.species_by_index[m.species_index_of(m.read(prefix + 'Species'))]
            table = self.tables['OriginalPokemonTypes' if m.read('wGameplayRules') & 1 else 'RevampedPokemonTypes']
            return table.get(species, self.base[species])
        prefix = 'wBattleMon' if side == 'player' else 'wEnemyMon'
        return tuple(m.read_bytes(prefix + 'Type1', 2))

    def check(self, *, pixels=False, pairs=None, shiny=None):
        h, m = self.h, self.h.battle.mem
        errors = []
        for side in ('player', 'enemy'):
            if shiny is not None:
                star = 8*20+12 if side=='player' else 1*20+4
                if (m.read('wTileMap',star)==0x70) != shiny:
                    errors.append(f'{side}: shiny star visibility != {shiny}')
            pair = pairs[side] if pairs else self.pair(side)
            x, y, first, attrs, _ = CELLS[side]
            expected = dict(tiles=[first, first+1], attrs=attrs,
                            vram_tiles=[first, first+1], vram_attrs=attrs)
            cells = read_cells(h, side)
            if cells != expected:
                errors.append(f'{side} cells: {cells} != {expected}')
            color_indexes = (3, 1) if side == 'player' else (1, 2)
            for slot, (kind, pixel_color) in enumerate(zip(pair, color_indexes)):
                blank = slot == 1 and pair[0] == pair[1]
                glyph = bytes(8) if blank else self.art.get(kind, bytes(8))
                expected_art = bytes(value for row in glyph for value in
                    (row if pixel_color & 1 else 0, row if pixel_color & 2 else 0))
                address = 0x9000 + (first + slot) * 16
                actual_art = bytes(h.pb.memory[1, address+i] for i in range(16))
                if actual_art != expected_art:
                    errors.append(f'{side} slot {slot} type {kind}: wrong icon bitmap {actual_art.hex()} != {expected_art.hex()}')
                palette, color = ((5, 3) if slot == 0 else (4, 1)) if side == 'player' else (5, slot+1)
                expected_color = self.colors.get(kind, 0x7fff)
                for buffer in ('wBGPals1', 'wBGPals2'):
                    data = m.read_bytes(buffer, 2, palette*8+color*2)
                    actual_color = int.from_bytes(data, 'little')
                    if actual_color != expected_color:
                        errors.append(f'{side} slot {slot} {buffer}: color {actual_color:04x} != {expected_color:04x}')
                if pixels:
                    data = m.read_bytes('wBGPals2', 2, palette*8)
                    background = int.from_bytes(data, 'little')
                    rgb = lambda value: ((value & 31) << 3, ((value >> 5) & 31) << 3, ((value >> 10) & 31) << 3)
                    wanted = np.empty((8,8,3), dtype=np.uint8)
                    for row in range(8):
                        for col in range(8):
                            wanted[row,col] = rgb(expected_color if glyph[row] & (128>>col) else background)
                    shown = h.pb.screen.ndarray[y*8:y*8+8, (x+slot)*8:(x+slot+1)*8, :3]
                    if not np.array_equal(shown, wanted):
                        errors.append(f'{side} slot {slot}: rendered pixels do not match type {kind}')
        return errors


class Monitor:
    def __init__(self, h):
        self.h = h
        self.hooks = []
        self.errors = []
        self.pending = []
        self.clears = self.faints = 0
        self.enabled = True
        self.shiny = None
        self.install('ClearBattleTypeIconCellsForSide', self.begin)
        self.install('ReturnFarCall', self.end)
        self.install('StdBattleTextbox', self.text)
        self.install('DrawPlayerHUD', self.stage_shiny)
        self.install('DrawEnemyHUD', self.stage_shiny)

    def install(self, name, callback):
        bank, address = self.h.sym[name]
        self.h.pb.hook_register(bank, address, callback, None)
        self.hooks.append((bank,address))

    def begin(self, _):
        if self.enabled:
            self.pending.append('player' if self.h.pb.register_file.A == 0 else 'enemy')

    def end(self, _):
        if self.pending:
            side = self.pending.pop()
            self.clears += 1
            self.errors.extend(hidden_errors(self.h, side))

    def text(self, _):
        if not self.enabled:
            return
        for side, name in [('player','BattleText_MonFainted'),('enemy','BattleText_EnemyMonFainted')]:
            if self.h.pb.register_file.HL == self.h.sym.addr(name):
                self.faints += 1
                self.errors.extend(hidden_errors(self.h, side))

    def stage_shiny(self, _):
        if self.shiny is None:return
        # Shininess is an explicit flag in this fork, independent of DVs.
        # Stage legal party flags before the normal HUD and palette routines,
        # then the oracle verifies that the star really appeared/disappeared.
        m=self.h.battle.mem
        for prefix,count in [('wPartyMon',m.read('wPartyCount')),
                             ('wOTPartyMon',m.read('wOTPartyCount'))]:
            for slot in range(1,min(count,6)+1):
                name=f'{prefix}{slot}Unused'
                flags=m.read(name)&0x7f
                m.write(name,flags|(0x80 if self.shiny else 0))
        flags=m.read('wEnemyMonShinyGenderFlags')&0x7f
        m.write('wEnemyMonShinyGenderFlags',flags|(0x80 if self.shiny else 0))

    def reset(self):
        self.pending.clear();self.errors.clear()
        self.clears = self.faints = 0
        self.shiny = None

    def close(self):
        for bank,address in reversed(self.hooks):
            self.h.pb.hook_deregister(bank,address)


def native_matrix(h, oracle, output):
    h.load_fixture()
    request = dict(player=mon('FERALIGATR'), enemy=mon('HOUNDOOM'), turns=0, rng='seeded')
    assert h.run_battle(request) == STATE_WAIT
    state=io.BytesIO();h.pb.save_state(state)
    results=[]
    pairs=[(a,b) for a in ACTIVE_TYPES for b in ACTIVE_TYPES]
    pairs += [(255,255),(29,255),(6,6),(10,19)]
    for index,pair in enumerate(pairs):
        state.seek(0);h.pb.load_state(state)
        other=(pair[1],pair[0])
        h.battle.mem.write_bytes('wBattleMonType1',pair)
        h.battle.mem.write_bytes('wEnemyMonType1',other)
        call(h,'DrawPlayerHUDBorderWithTypes')
        call(h,'DrawEnemyHUDBorderWithTypes')
        # The routine-call harness normally parks with interrupts disabled.
        # Let the real VBlank upload these colors before checking screen pixels.
        h.pb.memory[0xc0f0]=0xfb
        h.pb.register_file.PC=0xc0f0
        h.tick(2)
        errors=oracle.check(pixels=True,pairs={'player':pair,'enemy':other})
        for side in ('player','enemy'):
            # Deliberately use the other turn: side selection must be explicit.
            h.battle.mem.write('hBattleTurn',1 if side=='player' else 0)
            call(h,'ClearPlayerBattleHUD' if side=='player' else 'ClearEnemyBattleHUD')
            errors.extend(hidden_errors(h,side))
        if errors:
            h.pb.screen.image.save(str(output/f'renderer-{index:03d}.png'))
        results.append(dict(group='renderer',name=f'type pair {pair} / {other}',errors=errors))
        if (index+1)%50==0:print(f'Renderer {index+1}/{len(pairs)}; failures {sum(bool(r["errors"]) for r in results)}',flush=True)
    return results


def battle_cases(h):
    # All move IDs, on both sides, with the actual authored animations enabled.
    for side in ('player','enemy'):
        for index in range(1,h.con.num_attacks+1):
            move=h.con.moves_by_index[index]
            player=mon('MEW',level=60)
            enemy=mon('LUGIA',level=100)
            (player if side=='player' else enemy)['moves']=[move]
            yield dict(name=f'{side} move {index:03d} {move}',group='move',
                request=dict(player=player,player2=mon('SNORLAX',level=60),enemy=enemy,
                             enemy2=mon('PORYGON',level=100) if side=='enemy' else None,
                             rng='seeded',rng_value=(0x14+index*23)&255,turns=1))

    # Identity, palette/banner and multi-turn transitions not covered by a
    # one-turn generic move execution. The primary move is actually selected.
    for side in ('player','enemy'):
        for move in ('CONVERSION','CONVERSION2','TRANSFORM','SUBSTITUTE','FLY','DIG',
                     'DIVE','BOUNCE','SKULL_BASH','SOLARBEAM','SKY_ATTACK','RAZOR_WIND',
                     'GEOMANCY','PHANTOM_FORCE','COSMIC_POWER','CURSE','PERISH_SONG',
                     'DESTINY_BOND','EXPLOSION','SELFDESTRUCT'):
            if move not in h.con.moves:continue
            p=mon('MEW',level=80);e=mon('SNORLAX',level=80)
            actor=p if side=='player' else e
            actor['moves']=[move,'THUNDERBOLT']
            if move=='CURSE':actor['species']='GENGAR'
            yield dict(name=f'{side} multi-turn {move}',group='multi',
                request=dict(player=p,player2=mon('PORYGON',level=80),enemy=e,
                    enemy2=mon('HOUNDOOM',level=80),rng='seeded',turns=4),checkpoints=True)
        for ability,species in [('ILLUSION','ZOROARK'),('DISGUISE','MIMIKYU'),
            ('IMPOSTER','DITTO'),('STANCE_CHANGE','AEGISLASH'),('TRACE','PORYGON'),
            ('INTIMIDATE','ARCANINE'),('DRIZZLE','POLITOED'),('DROUGHT','NINETALES'),
            ('SAND_STREAM','TYRANITAR'),('SNOW_WARNING','ABOMASNOW'),
            ('NEUTRALIZING_GAS','WEEZING'),('MUMMY','COFAGRIGUS')]:
            if ability not in h.con.abilities or species not in h.con.species:continue
            p=mon('FERALIGATR','TACKLE',level=60);e=mon('SNORLAX','TACKLE',level=60)
            actor=p if side=='player' else e
            actor.update(species=species,ability=ability)
            yield dict(name=f'{side} ability {ability}',group='ability',
                request=dict(player=p,player2=mon('AMPHAROS',level=60),enemy=e,
                    enemy2=mon('HOUNDOOM',level=60),rng='seeded',turns=3),checkpoints=True)
    for rules in (0,1,2,3,4,5,6,7):
        for disabled in (False,True):
            for pair in [('FERALIGATR','AMPHAROS'),('ARBOK','CHARIZARD'),('LEDIAN','NINETALES')]:
                yield dict(name=f'rules {rules} animations {not disabled} repeated {pair}',group='repeat',
                    rules=rules,disabled=disabled,checkpoints=True,
                    request=dict(player=mon(pair[0],level=80),player2=mon(pair[1],level=80),
                        enemy=mon('SNORLAX',level=80),enemy2=mon('PORYGON',level=80),
                        move_script=['switch:2','switch:1']*4,rng='seeded',turns=8))
    for status in (8,16,32,64,2):
        for side in ('player','enemy'):
            p=mon('FERALIGATR',level=60);e=mon('HOUNDOOM',level=60)
            (p if side=='player' else e).update(status_byte=status,hp=1)
            yield dict(name=f'{side} status {status} low HP',group='status',checkpoints=True,
                request=dict(player=p,player2=mon('PORYGON',level=60),enemy=e,
                    enemy2=mon('AMPHAROS',level=60),rng='seeded',turns=3))
    for weather in ('rain','sun','sandstorm','hail'):
        yield dict(name=f'{weather} palette and weather damage',group='weather',checkpoints=True,
            request=dict(player=mon('FERALIGATR',level=60),player2=mon('PORYGON',level=60),
                enemy=mon('HOUNDOOM',level=60),enemy2=mon('AMPHAROS',level=60),
                weather=weather,rng='seeded',turns=5))

    for side in ('player','enemy'):
        for ability,number in h.con.abilities.items():
            if not number:continue
            species=next((name for name,slots in h.con.species_abilities.items()
                          if ability in slots and name in h.con.species),None)
            p=mon('FERALIGATR','TACKLE',level=80);e=mon('SNORLAX','TACKLE',level=80)
            actor=p if side=='player' else e
            actor.update(species=species or 'MEW',ability=ability)
            yield dict(name=f'{side} all-ability {ability} ({species or "override"})',group='ability_all',
                request=dict(player=p,player2=mon('AMPHAROS',level=80),enemy=e,
                    enemy2=mon('HOUNDOOM',level=80),rng='seeded',turns=2),checkpoints=True)

    for rules in (0,1):
        for disabled in (False,True):
            for side in ('player','enemy'):
                for move in ('CONVERSION','CONVERSION2','TRANSFORM'):
                    p=mon('MEW',level=80);e=mon('SNORLAX',level=80)
                    (p if side=='player' else e)['moves']=[move,'THUNDERBOLT']
                    yield dict(name=f'{side} {move} rules={rules} animations={not disabled}',
                        group='identity',rules=rules,disabled=disabled,checkpoints=True,
                        request=dict(player=p,player2=mon('PORYGON',level=80),enemy=e,
                            enemy2=mon('HOUNDOOM',level=80),rng='seeded',turns=3))
                for species,ability in [('ZOROARK','ILLUSION'),('MIMIKYU','DISGUISE'),('DITTO','IMPOSTER')]:
                    p=mon('FERALIGATR','TACKLE',level=80);e=mon('SNORLAX','TACKLE',level=80)
                    (p if side=='player' else e).update(species=species,ability=ability,dvs=0x2aaa)
                    yield dict(name=f'{side} shiny {ability} rules={rules} animations={not disabled}',
                        group='identity',rules=rules,disabled=disabled,checkpoints=True,shiny=True,
                        request=dict(player=p,player2=mon('AMPHAROS',level=80),enemy=e,
                            enemy2=mon('HOUNDOOM',level=80),rng='seeded',turns=3))

    for side in ('player','enemy'):
        for disabled in (False,True):
            for ability in ('NO_ABILITY','INTIMIDATE','DRIZZLE','DROUGHT','SAND_STREAM',
                'SNOW_WARNING','TRACE','NEUTRALIZING_GAS','ILLUSION','DISGUISE',
                'DOWNLOAD','MUMMY','STANCE_CHANGE'):
                if ability not in h.con.abilities:continue
                target_species=next((name for name,slots in h.con.species_abilities.items()
                    if ability in slots and name in h.con.species),'FERALIGATR')
                p=mon('DITTO',level=80,ability='IMPOSTER')
                e=mon(target_species,level=80,ability=ability)
                if side=='enemy':p,e=e,p
                yield dict(name=f'{side} IMPOSTER copies {ability} animations={not disabled}',
                    group='copy',disabled=disabled,checkpoints=True,
                    request=dict(player=p,player2=mon('AMPHAROS',level=80),enemy=e,
                        enemy2=mon('HOUNDOOM',level=80),rng='seeded',turns=2))


def exit_matrix(h,monitor,output):
    constants=_parse_constants(ROOT/'constants/battle_constants.asm')
    results=[]
    for disabled in (False,True):
        for kind in ('wild win','trainer win','wild loss','trainer loss','canlose trainer loss','double KO loss'):
            h.load_fixture();monitor.reset();m=h.battle.mem
            m.write('wOptions',0x41|(0x80 if disabled else 0))
            win=kind.endswith('win')
            p=mon('FERALIGATR','WATERFALL' if win else 'SPLASH',level=80 if win else 20,
                  hp=100 if win else 1)
            e=mon('HOUNDOOM','SPLASH' if win else 'THUNDERBOLT',level=20 if win else 100,
                  hp=1 if win else 100)
            p2=None if kind.startswith('wild') else mon('PORYGON','SPLASH',level=20,hp=1)
            e2=None if kind.startswith('wild') else mon('PORYGON','THUNDERBOLT',level=100,hp=1 if win else 100)
            if kind=='double KO loss':
                p.update(moves=['EXPLOSION'],level=100)
                p2=None;e.update(hp=1,moves=['SPLASH'],level=20);e2=None
            request=dict(player=p,player2=p2,enemy=e,enemy2=e2,rng='seeded',turns=0)
            errors=[];slides=[]
            bank,address=h.sym['BattleWinSlideInEnemyTrainerFrontpic']

            def slide(_):
                slides.append(True)
                errors.extend(hidden_errors(h,'enemy'))

            h.pb.hook_register(bank,address,slide,None)
            try:
                state=h.run_battle(request)
                if state!=STATE_WAIT:raise RuntimeError(f'Exit setup state {state}')
                if kind=='canlose trainer loss':m.write('wBattleType',constants['BATTLETYPE_CANLOSE'])
                m.write('wDebugTurnTarget',50);m.write('wDebugControl',1)
                for frame in range(0,24000,4):
                    state=h.state()
                    if state==STATE_DONE:break
                    h.pb.button('a',2);h.tick(4)
                else:raise RuntimeError(f'Exit timeout: {h.control_state()}')
                errors.extend(monitor.errors)
                if kind in ('trainer win','canlose trainer loss') and not slides:
                    errors.append('Trainer-result portrait checkpoint was not reached')
                if not monitor.faints:errors.append('No fainting event occurred')
            except Exception as exc:errors.append(str(exc))
            finally:h.pb.hook_deregister(bank,address)
            name=f'{kind} animations={not disabled}'
            if errors:
                h.pb.screen.image.save(str(output/f'exit-{len(results):02d}.png'))
                with (output/f'exit-{len(results):02d}.state').open('wb') as f:h.pb.save_state(f)
            results.append(dict(group='exit',name=name,errors=errors,clears=monitor.clears,
                                faints=monitor.faints,portrait_checkpoints=len(slides)))
            print(('FAIL ' if errors else 'PASS ')+name+(f': {errors[:2]}' if errors else ''),flush=True)
    return results


def menu_matrix(h,oracle,monitor,output):
    results=[]
    for rules in (0,1):
        for shiny in (False,True):
            for kind in ('moves','party','summary','pack'):
                h.load_fixture();monitor.reset()
                monitor.shiny=shiny
                m=h.battle.mem
                m.write('wOptions',0x41);m.write('wGameplayRules',rules)
                request=dict(player=mon('FERALIGATR',moves=['WATERFALL','CRUNCH','ICE_PUNCH','AQUA_JET'],
                                 dvs=0x2aaa if shiny else 0xffff),
                    player2=mon('PORYGON'),enemy=mon('HOUNDOOM',dvs=0x2aaa if shiny else 0xffff),
                    enemy2=mon('AMPHAROS'),rng='seeded',turns=10)
                Request(h.battle).write(request);m.write('wDebugBattleFlags',0)
                errors=[];checks=0

                def field():
                    t=tile_text(h)
                    return 'FIGHT' in t and 'PACK' in t and 'RUN' in t

                def await_field():
                    for frame in range(0,12000,4):
                        if field():h.tick(60);return
                        if frame%24==0:h.pb.button('a',2)
                        h.tick(4)
                    raise RuntimeError('Menu return timeout: '+tile_text(h))

                def select(row,col):
                    if m.read('wMenuCursorY')!=row:h.press('down' if row==2 else 'up',hold=4,wait=20)
                    if m.read('wMenuCursorX')!=col:h.press('right' if col==2 else 'left',hold=4,wait=20)
                    h.press('a',hold=4,wait=100)

                try:
                    await_field();errors.extend(oracle.check(pixels=True,shiny=shiny));checks+=1
                    for repeat in range(5):
                        if kind=='moves':
                            select(1,1)
                            for _ in range(4):h.press('down',hold=4,wait=20)
                            h.press('b',hold=4,wait=100)
                        elif kind=='party':
                            select(1,2);h.press('down',hold=4,wait=20)
                            h.press('b',hold=4,wait=100)
                        elif kind=='pack':
                            select(2,1)
                            h.press('right',hold=4,wait=30)
                            h.press('left',hold=4,wait=30)
                            h.press('b',hold=4,wait=120)
                        else:
                            select(1,2)
                            while m.read('wMenuCursorY')!=1:h.press('up',hold=4,wait=20)
                            h.press('a',hold=4,wait=40)
                            h.press('down',hold=4,wait=20)
                            h.press('a',hold=4,wait=160)
                            for _ in range(4):h.press('right',hold=4,wait=90)
                            h.press('down',hold=4,wait=100)
                            h.press('up',hold=4,wait=100)
                            h.press('b',hold=4,wait=120)
                            for _ in range(3):
                                if field():break
                                h.press('b',hold=4,wait=120)
                        await_field();errors.extend(oracle.check(pixels=True,shiny=shiny));checks+=1
                    errors.extend(monitor.errors)
                except Exception as exc:errors.append(str(exc))
                name=f'{kind} five round-trips rules={rules} shiny={shiny}'
                if errors:
                    h.pb.screen.image.save(str(output/f'menu-{len(results):02d}.png'))
                    with (output/f'menu-{len(results):02d}.state').open('wb') as f:h.pb.save_state(f)
                results.append(dict(group='menu',name=name,errors=errors,checkpoints=checks,
                    clears=monitor.clears,faints=monitor.faints))
                print(('FAIL ' if errors else 'PASS ')+name+(f': {errors[:2]}' if errors else ''),flush=True)
    return results


def battle_matrix(h,oracle,monitor,output,groups=None):
    results=[]
    for index,spec in enumerate(battle_cases(h),1):
        if groups and spec['group'] not in groups:continue
        h.load_fixture();monitor.reset()
        monitor.shiny=spec.get('shiny')
        h.battle.mem.write('wOptions',0x41|(0x80 if spec.get('disabled') else 0))
        h.battle.mem.write('wGameplayRules',spec.get('rules',0))
        request=dict(spec['request'])
        limit=request['turns']
        if spec.get('checkpoints'):request['turns']=0
        state=h.run_battle(request)
        errors=[];checks=0
        try:
            if state not in (STATE_WAIT,STATE_DONE):raise RuntimeError(f'Battle state {state}; {h.control_state()}')
            if state==STATE_WAIT and h.battle.player.hp and h.battle.enemy.hp:
                h.tick(3);errors.extend(oracle.check(pixels=True,shiny=monitor.shiny));checks+=1
            if spec.get('checkpoints'):
                for turn in range(1,limit+1):
                    if state==STATE_DONE:break
                    h.battle.mem.write('wDebugTurnTarget',turn)
                    h.battle.mem.write('wDebugControl',1)
                    for frame in range(0,18000,4):
                        state=h.state()
                        if state==STATE_DONE or state==STATE_WAIT and h.battle.turns_done>=turn:break
                        h.pb.button('a',2);h.tick(4)
                    else:raise RuntimeError(f'Turn {turn} timeout; {h.control_state()}')
                    if state==STATE_WAIT and h.battle.player.hp and h.battle.enemy.hp:
                        h.tick(3);errors.extend(oracle.check(pixels=True,shiny=monitor.shiny));checks+=1
            errors.extend(monitor.errors)
        except Exception as exc:errors.append(str(exc))
        if errors:
            h.pb.screen.image.save(str(output/f'battle-{index:04d}.png'))
            with (output/f'battle-{index:04d}.state').open('wb') as f:h.pb.save_state(f)
            print(f'FAIL {spec["name"]}: {errors[:3]}',flush=True)
        results.append(dict(group=spec['group'],name=spec['name'],errors=errors,
                            clears=monitor.clears,faints=monitor.faints,checkpoints=checks))
        if len(results)%25==0:
            print(f'Battles {len(results)}; failures {sum(bool(r["errors"]) for r in results)}; '
                  f'clears {sum(r["clears"] for r in results)}',flush=True)
        # Diagnose a broken oracle/driver before producing hundreds of repeats.
        if len(results)>=10 and sum(bool(r['errors']) for r in results[-10:])==10:
            print('Stopping for diagnosis: ten consecutive cases failed',flush=True);break
    return results


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--groups',help='comma-separated renderer,move,multi,ability,ability_all,repeat,status,weather,menu,identity,exit,copy')
    parser.add_argument('--output',type=Path,default=ROOT/'.venv/type-icon-stress')
    args=parser.parse_args()
    groups=set(args.groups.split(',')) if args.groups else None
    valid_groups={'renderer','move','multi','ability','ability_all','repeat','status',
                  'weather','menu','identity','exit','copy'}
    if groups and groups-valid_groups:
        parser.error('unknown groups: '+', '.join(sorted(groups-valid_groups)))
    args.output.mkdir(parents=True,exist_ok=True)
    harness_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    h=Harness();h.ensure_fixture();oracle=Oracle(h);results=[];monitor=None
    planned={}
    if not groups or 'renderer' in groups:planned['renderer']=len(ACTIVE_TYPES)**2+4
    for spec in battle_cases(h):
        if not groups or spec['group'] in groups:
            planned[spec['group']]=planned.get(spec['group'],0)+1
    if not groups or 'menu' in groups:planned['menu']=16
    if not groups or 'exit' in groups:planned['exit']=12
    start=time.monotonic()
    try:
        if not groups or 'renderer' in groups:results.extend(native_matrix(h,oracle,args.output))
        monitor=Monitor(h)
        results.extend(battle_matrix(h,oracle,monitor,args.output,groups))
        if not groups or 'menu' in groups:results.extend(menu_matrix(h,oracle,monitor,args.output))
        if not groups or 'exit' in groups:results.extend(exit_matrix(h,monitor,args.output))
    finally:
        if monitor:monitor.close()
        h.pb.stop(save=False)
    summary={group:dict(cases=sum(r['group']==group for r in results),
        failures=sum(r['group']==group and bool(r['errors']) for r in results))
        for group in sorted({r['group'] for r in results})}
    complete=all(summary.get(group,{}).get('cases',0)==count for group,count in planned.items())
    report=dict(rom_sha256=h.rom_sha256,harness_sha256=harness_sha256,
                cartridge=h.cartridge,planned=planned,
                coverage_complete=complete,seconds=time.monotonic()-start,summary=summary,results=results)
    (args.output/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(summary,indent=2),flush=True)
    if not complete:print(f'INCOMPLETE: planned {planned}',flush=True)
    print(f'Finished {len(results)} cases in {time.monotonic()-start:.1f}s; '
          f'{sum(bool(r["errors"]) for r in results)} failures',flush=True)
    return int(not complete or any(r['errors'] for r in results))


if __name__=='__main__':raise SystemExit(main())

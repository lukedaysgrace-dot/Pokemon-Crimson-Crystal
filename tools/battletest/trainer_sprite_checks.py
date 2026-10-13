#!/usr/bin/env python3
"""Render every trainer introduction and overworld sheet in private PyBoy sessions.

Native battle input is enabled. Teams and isolated overworld objects are staged
in test memory; actual map loading, sprite uploads, OAM, palettes and battle
introductions run in the game. No player save is read or written.
"""
import argparse
import io
import json
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw

from runner import Harness, ROOT
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from ui_checks import tile_text

sys.path.insert(0, str(ROOT / 'tools'))
from audit_npc_walking import catalog
from audit_trainer_sprites import parse_map, trainer_sprite_expectations


def native_call(h, symbol):
    """Use a completion marker: frame sampling can land in an interrupt forever."""
    pb, m = h.pb, h.battle.mem
    bank, address = h.sym[symbol]
    if bank:
        pb.memory[0x2000] = bank
        m.write('hROMBank', bank)
    pb.memory[0xff70] = 1
    pb.memory[0xc0ff] = 0
    pb.memory[0xc0ec:0xc0ee] = [0xf0, 0xc0]
    pb.memory[0xc0f0:0xc0f8] = [0xfb, 0x3e, 1, 0xea, 0xff, 0xc0, 0x18, 0xfe]
    pb.memory[0xc0f9:0xc0fd] = [0xfb, 0xc3, address & 255, address >> 8]
    pb.register_file.SP, pb.register_file.PC = 0xc0ec, 0xc0f9
    for _ in range(1800):
        h.tick(4)
        if pb.memory[0xc0ff] == 1:
            return
    raise RuntimeError(symbol + ' did not return: ' + h.where())


def sprite_asset(row):
    if row['file']:
        return (ROOT / row['file']).read_bytes()
    # Snorlax intentionally assembles slices and hand-corrected bytes.
    source = (ROOT / 'gfx/sprites.asm').read_text().split(row['label'] + '::', 1)[1]
    source = re.split(r'^\w+::', source, maxsplit=1, flags=re.M)[0]
    asset = bytearray()
    for line in source.splitlines():
        line = line.split(';')[0].strip()
        incbin = re.fullmatch(r'INCBIN "([^"]+)"(?:,\s*(\d+),\s*(\d+))?', line)
        if incbin:
            path, start, length = incbin.groups()
            raw = (ROOT / path).read_bytes()
            asset.extend(raw[int(start):int(start) + int(length)] if start else raw)
        elif line.startswith('db '):
            asset.extend(int(v.strip().removeprefix('$'), 16) for v in line[3:].split(','))
        elif line:
            raise ValueError('unsupported assembled sprite directive: ' + line)
    return bytes(asset)


def map_ids():
    out = {}
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),\s*(\d+),\s*(\d+)', line)
        if match:
            number += 1
            out[match[1]] = (group, number, int(match[2]) * 2, int(match[3]) * 2)
    return out


def enter_map(h, location, x, y):
    h.load_fixture()
    m = h.battle.mem
    group, number, _, _ = location
    for key, value in dict(hDebugActive=0, wDebugState=0, wDefaultSpawnpoint=255,
                           wMapGroup=group, wMapNumber=number, wXCoord=x,
                           wYCoord=y, hMapEntryMethod=0xf1).items():
        m.write(key, value)
    native_call(h, 'EnterMap')
    h.tick(2)


def contact_pages(output, entries, stem, columns=4, rows=6):
    paths = []
    for start in range(0, len(entries), columns * rows):
        chunk = entries[start:start + columns * rows]
        width = max(im.width for _, im in chunk)
        height = max(im.height for _, im in chunk) + 22
        canvas = Image.new('RGB', (width * columns, height * ((len(chunk) + columns - 1) // columns)), 'white')
        draw = ImageDraw.Draw(canvas)
        for i, (name, im) in enumerate(chunk):
            x, y = (i % columns) * width, (i // columns) * height
            draw.text((x + 3, y + 3), name, fill='black')
            canvas.paste(im.convert('RGB'), (x, y + 22))
        path = output / f'{stem}-{len(paths) + 1:02d}.png'
        canvas.save(path)
        paths.append(path.name)
    return paths


class Sweep:
    def __init__(self, h, output):
        self.h, self.output = h, output
        self.result = dict(rom=h.rom_key(), checks=0, failures=[], battles=[], overworld=[], maps=[], encounters=[])

    def check(self, condition, label):
        self.result['checks'] += 1
        if not condition:
            self.result['failures'].append(label)
            print('FAIL SPRITE ' + label, flush=True)

    def battles(self, selected):
        h, m = self.h, self.h.battle.mem
        classes = {k: v for k, v in h.con.trainer_classes.items() if v and (not selected or k in selected)}
        pics = re.findall(r'^\s*dba\s+(\w+)', (ROOT / 'data/trainers/pic_pointers.asm').read_text(), re.M)
        files = dict(re.findall(r'^(\w+):\s+INCBIN "([^"]+)"', (ROOT / 'gfx/pics.asm').read_text(), re.M))
        palettes = re.findall(r'^INCBIN "([^"]+)"', (ROOT / 'data/trainers/palettes.asm').read_text(), re.M)
        self.check(len(pics) == len(h.con.trainer_classes) - 1, 'all trainer classes have a picture entry')
        captured = []
        ready = []

        def text_done(context):
            if h.text_context and 'WantsToBattleText' in h.text_context:
                ready.append(True)
            h._end_text(context)

        bank, address = h.sym['PrintTextboxText.done']
        h.pb.hook_deregister(bank, address)
        h.pb.hook_register(bank, address, text_done, None)
        for name, klass in classes.items():
            try:
                h.load_fixture()
                ready.clear()
                mon = dict(species='MAGIKARP', level=5, ability='SWIFT_SWIM', moves=['SPLASH'])
                Request(h.battle).write(dict(player=dict(species='MEW', level=100, ability='SYNCHRONIZE',
                                                        moves=['AERIAL_ACE']), enemy=mon, enemy2=mon,
                                            enemy_class=name, rng='off', turns=1))
                m.write('wDebugBattleFlags', 0)
                m.write('wOptions', 0x41)
                call(h, 'DebugBattleSetup')
                self.check(m.read('wOtherTrainerClass') == klass, name + ': requested class reached game')
                begin_native_call(h, 'StartBattle')
                shown = False
                for frame in range(2400):
                    h.tick()
                    if ready and not shown:
                        shown = True
                        image = h.pb.screen.image.copy()
                        image.save(self.output / f'battle-{name.lower()}.png')
                        captured.append((name, image))
                        raw = bytes(h.pb.memory[0, 0x9000:0x9310])
                        asset = (ROOT / files[pics[klass - 1]].removesuffix('.lz')).read_bytes()
                        self.check(len(asset) == 49 * 16 and raw == asset, name + ': all 49 trainer tiles match asset')
                        bank, address = h.sym['wBGPals2']
                        active = bytes(h.pb.memory[bank, address + 10:address + 14])
                        expected = (ROOT / palettes[klass]).read_bytes()[2:6]
                        self.check(active == expected, name + ': visible trainer colors match class palette')
                        self.check(len(image.crop((96, 0, 152, 56)).getcolors() or []) > 2, name + ': trainer is visible')
                        self.check(m.read('hDebugActive') == 0, name + ': native battle input enabled')
                    if shown and 'FIGHT' in tile_text(h):
                        h.tick(8)
                        h.pb.screen.image.save(self.output / f'battle-{name.lower()}-fight.png')
                        self.check(m.read('wBattleMode') == 2, name + ': reached trainer Fight menu')
                        self.check(not h.text_overflows, name + ': trainer introduction fits textbox')
                        self.result['battles'].append(name)
                        print(f'PASS BATTLE SPRITE {name} ({klass})', flush=True)
                        break
                    if frame % 12 == 0:
                        h.pb.button('a', 2)
                else:
                    raise RuntimeError('battle introduction did not reach Fight: ' + h.where())
            except Exception as error:
                self.check(False, f'{name}: {error}')
                h.pb.screen.image.save(self.output / f'battle-{name.lower()}-error.png')
        self.result['battle_contact_sheets'] = contact_pages(self.output, captured, 'battle-sheet')
        h.pb.hook_deregister(*h.sym['PrintTextboxText.done'])
        h.pb.hook_register(*h.sym['PrintTextboxText.done'], h._end_text, None)

    def overworld(self, selected):
        h, m = self.h, self.h.battle.mem
        ids, rows, _ = catalog()
        if selected:
            wanted = {trainer_sprite_expectations()[name] for name in selected}
            rows = [row for row in rows if row['name'] in wanted]
        # A genuine indoor map supplies the background, palettes and player.
        enter_map(h, map_ids()['CHERRYGROVE_EVOLUTION_SPEECH_HOUSE'], 3, 6)
        base = io.BytesIO()
        h.pb.save_state(base)
        captures = []
        table = (ROOT / 'data/sprites/sprites.asm').read_text()
        palette_names = re.findall(r'^\s*overworld_sprite\s+\w+,\s*\d+,\s*\w+,\s*(\w+)', table, re.M)
        ow_pals = {name: i for i, name in enumerate(re.findall(r'^\s*const\s+(PAL_OW_\w+)',
                        (ROOT / 'constants/sprite_data_constants.asm').read_text(), re.M))}
        ow_pals['PAL_OW_PURPLE'] = ow_pals['PAL_OW_PINK']
        for row in rows:
            try:
                base.seek(0)
                h.pb.load_state(base)
                obj = h.sym.addr('wObjectStructs') + 40
                # Keep one staged NPC; use its compiled sheet's normal palette.
                for slot in range(2, 16):
                    m.write(f'wMap{slot}ObjectSprite', 0)
                h.pb.memory[obj + 40:obj + 40 * 12] = bytes(40 * 11)
                sid = row['id']
                pal = ow_pals[palette_names[sid - 1]]
                m.write('wMap1ObjectSprite', sid)
                m.write('wMap1ObjectColor', (8 | pal) << 4)
                h.pb.memory[obj] = sid
                h.pb.memory[obj + 6] = pal
                h.pb.memory[obj + 23] = 80
                h.pb.memory[obj + 24] = 40
                native_call(h, 'RefreshSprites')
                raw = m.read_bytes('wUsedSprites', 64)
                allocated = dict(zip(raw[::2], raw[1::2]))
                self.check(sid in allocated and allocated[sid] not in range(1, 7), row['name'] + ': allocated in live map')
                tile = allocated[sid]
                bank = 0 if tile & 128 else 1
                address = 0x8000 + (tile & 127) * 16
                asset = sprite_asset(row)
                length = row['tiles'] * 16
                self.check(bytes(h.pb.memory[bank, address:address + length]) == asset[:length], row['name'] + ': standing tiles uploaded')
                if row['kind'] in ('WALKING_SPRITE', 'STANDING_SPRITE'):
                    second = asset[length:length * 2] if row['kind'] == 'WALKING_SPRITE' else asset[:length]
                    self.check(bytes(h.pb.memory[bank, address + 0x800:address + 0x800 + length]) == second,
                               row['name'] + ': walking/icon tiles uploaded')
                phases = []
                if row['kind'] == 'WALKING_SPRITE':
                    phases = [(d, p) for d in (0, 4, 8, 12) for p in range(4)]
                elif row['kind'] == 'STANDING_SPRITE':
                    phases = [(d, 0) for d in (0, 4, 8, 12)]
                elif row['kind'] in ('MON_ICON_SPRITE', 'BOAT_SPRITE'):
                    phases = [(0, p) for p in range(2)]
                elif row['name'] == 'SPRITE_BIG_SNORLAX':
                    phases = [(0, p) for p in range(4)]
                else:
                    phases = [(0, 0)]
                strip = Image.new('RGB', (32 * len(phases), 64), 'white')
                seen_facings = set()
                for index, (direction, phase) in enumerate(phases):
                    h.pb.memory[obj + 8] = direction
                    action, step = 'SetFacingStepAction', phase * 8
                    if row['kind'] == 'MON_ICON_SPRITE':
                        step = phase * 16
                    elif row['kind'] == 'STILL_SPRITE':
                        action = 'SetFacingCurrent'
                    elif row['kind'] == 'BOAT_SPRITE':
                        action, step = 'SetFacingFishingBoat', phase * 32
                    elif row['kind'] == 'BIG_SPRITE':
                        action = ('SetFacingSnorlaxSleep' if row['name'] == 'SPRITE_BIG_SNORLAX' else
                                  'SetFacingBigDollSym' if row['name'] == 'SPRITE_BIG_LAPRAS' else 'SetFacingBigDollAsym')
                        step = phase * 32
                    h.pb.memory[obj + 12] = step
                    call(h, action, B=obj >> 8, C=obj & 255)
                    seen_facings.add(h.pb.memory[obj + 13])
                    native_call(h, 'UpdateSprites')
                    h.tick(2)
                    image = h.pb.screen.image.copy()
                    image.save(self.output / f'overworld-{row["name"].lower()}-{direction}-{phase}.png')
                    # The screenshot is from the rendered game, including its background.
                    # Wider sprites use a wider crop; all captures retain the full screen.
                    bounds = (80, 36, 112, 68) if row['kind'] in ('BIG_SPRITE', 'BOAT_SPRITE') else (80, 36, 96, 52)
                    crop = image.crop(bounds).resize((32, 32), Image.Resampling.NEAREST)
                    strip.paste(crop, (32 * index, 16))
                    raw_oam = m.read_bytes('wVirtualOAM', 160)
                    npc_oam = [raw_oam[i:i + 4] for i in range(0, 160, 4)
                               if 88 <= raw_oam[i + 1] <= 120 and 52 <= raw_oam[i] <= 84]
                    self.check(bool(npc_oam), row['name'] + ': NPC OAM emitted')
                    self.check(all((entry[3] & 7) == pal and bool(entry[3] & 8) == bool(bank)
                                   for entry in npc_oam), row['name'] + ': OAM palette and VRAM bank')
                self.check(len(seen_facings) == len(phases), row['name'] + ': every intended facing/frame exercised')
                self.result['overworld'].append(dict(name=row['name'], kind=row['kind'], phases=len(phases)))
                captures.append((row['name'].removeprefix('SPRITE_'), strip))
                print(f'PASS OVERWORLD SPRITE {row["name"]}: {len(phases)} rendered phases', flush=True)
            except Exception as error:
                self.check(False, f'{row["name"]}: {error}')
        self.result['overworld_contact_sheets'] = contact_pages(self.output, captures, 'overworld-sheet', columns=1, rows=14)

    def maps(self, selected):
        h, m = self.h, self.h.battle.mem
        ids, _, _ = catalog()
        locations = map_ids()
        for path in sorted((ROOT / 'maps').glob('*.asm')):
            objects = parse_map(path)
            trainers = [o for o in objects if o['trainer_class'] and (not selected or o['trainer_class'] in selected)]
            if not trainers:
                continue
            try:
                # Center the first trainer using the real event coordinates.
                lines = path.read_text().splitlines()
                target = trainers[0]
                parts = lines[target['line'] - 1].split(',')
                x = int(parts[0].split()[-1])
                y = int(parts[1])
                # Map names with acronym boundaries use declarations rather than guesses.
                map_name = next(name for name in locations if name.replace('_', '') == path.stem.replace('_', '').upper())
                enter_map(h, locations[map_name], x, y)
                raw = m.read_bytes('wUsedSprites', 64)
                used = dict(zip(raw[::2], raw[1::2]))
                for obj in trainers:
                    sprite = ids.get(obj['sprite'])
                    self.check(sprite in used and used[sprite] not in range(1, 7),
                               f'{path.stem}:{obj["line"]} {obj["sprite"]}: real map allocated trainer sprite')
                native_call(h, 'UpdateSprites')
                h.tick(2)
                h.pb.screen.image.save(self.output / f'map-{path.stem}.png')
                self.result['maps'].append(dict(map=path.stem, trainers=len(trainers)))
                print(f'PASS MAP SPRITES {path.stem}: {len(trainers)} trainer placements', flush=True)
            except Exception as error:
                self.check(False, f'{path.stem}: {error}')

    def encounters(self, selected):
        """Finish actual map encounters for classes using the newer NPC sheets."""
        h, m = self.h, self.h.battle.mem
        ids, _, _ = catalog()
        expected = trainer_sprite_expectations()
        locations = map_ids()
        tested = set()
        completed = []
        captures = []
        h.pb.hook_register(*h.sym['ExitBattle'], lambda _: completed.append(True), None)
        try:
            for path in sorted((ROOT / 'maps').glob('*.asm')):
                source = path.read_text()
                objects = parse_map(path)
                for slot, obj in enumerate(objects, 1):
                    klass = obj['trainer_class']
                    if not klass or (selected and klass not in selected):
                        continue
                    if klass != 'ELDER' and ids[expected[klass]] < ids['SPRITE_COOLTRAINER_M_NEW']:
                        continue
                    if klass in tested and klass != 'AROMA_LADY':
                        continue
                    header = bool(re.search(r'^' + re.escape(obj['script']) + r':\s*\n\s*trainer\b', source, re.M))
                    # Also exercise the live Ninja disguise replacement and
                    # Elder's scripted encounter. Other boss prerequisites are
                    # covered separately from the all-class graphics sweep.
                    if not header and klass not in ('NINJA', 'ELDER'):
                        continue
                    if klass == 'ELDER' and klass in tested:
                        continue
                    label = path.stem + '-' + obj['script']
                    try:
                        parts = source.splitlines()[obj['line'] - 1].split(',')
                        x, y = int(parts[0].split()[-1]), int(parts[1])
                        map_name = next(name for name in locations if name.replace('_', '') == path.stem.replace('_', '').upper())
                        enter_map(h, locations[map_name], x, min(y + 1, locations[map_name][3] - 1))
                        Request(h.battle).write(dict(player=dict(species='MEW', level=100, ability='SYNCHRONIZE',
                                                                moves=['AERIAL_ACE']),
                                                    enemy=dict(species='MAGIKARP', level=5, moves=['SPLASH'])))
                        m.write('wPartyCount', 0)
                        m.write('wMonType', 0)
                        address = h.sym.addr('wDebugPlayer1')
                        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
                        # These are rendering/flow checks, including late-game
                        # teams. Give the private test mon enough HP and stats
                        # to finish each battle without a tactical dependency.
                        for stat in ('HP', 'MaxHP', 'Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef'):
                            m.write_bytes('wPartyMon1' + stat, [0x03, 0xe7])
                        for key, value in dict(wDebugMagic=0, wDebugState=0, hDebugActive=0,
                                               hDebugRNGMode=0, wOptions=0x41, hLastTalked=slot,
                                               wMapEventStatus=0).items():
                            m.write(key, value)
                        trainer_id = 0
                        if header:
                            native_call(h, 'TalkToTrainer')
                            bank, address = h.sym['TalkToTrainerScript']
                        else:
                            bank, address = h.sym[obj['script']]
                        call(h, 'CallScript', A=bank, HL=address)
                        completed.clear()
                        begin_native_call(h, 'OverworldLoop.loop')
                        moves = 0
                        pictured = False
                        for frame in range(24000):
                            h.tick()
                            if h.text_context and 'WantsToBattleText' in h.text_context and not pictured:
                                self.check(m.read('wOtherTrainerClass') == h.con.trainer_classes[klass], label + ': real map trainer class')
                                trainer_id = m.read('wOtherTrainerID')
                                self.check(trainer_id > 0, label + ': real map trainer party ID')
                                h.tick(30)
                                im = h.pb.screen.image.copy()
                                im.save(self.output / f'encounter-{label}-intro.png')
                                captures.append((klass + ' - ' + obj['script'].removeprefix('Trainer')[:18], im))
                                pictured = True
                            if 'FIGHT' in tile_text(h):
                                h.press('a', hold=8, wait=45)
                                if 'AERIAL ACE' in tile_text(h):
                                    h.press('a', hold=8, wait=20)
                                    moves += 1
                            elif frame % 8 == 0:
                                h.pb.button('a', 2)
                            if completed and not m.read('wScriptRunning') and not m.read('wBattleMode'):
                                h.tick(30)
                                h.pb.screen.image.save(self.output / f'encounter-{label}-returned.png')
                                self.check(pictured and moves > 0, label + ': native introduction and moves')
                                self.check(m.read('wBattleResult') & 15 == 0, label + ': won real trainer battle')
                                self.check(not h.text_overflows, label + ': all dialogue fits textbox')
                                self.check(m.read('wMapGroup') == locations[map_name][0] and
                                           m.read('wMapNumber') == locations[map_name][1], label + ': returned to same map')
                                self.result['encounters'].append(dict(map=path.stem, trainer=obj['script'],
                                                                     klass=klass, trainer_id=trainer_id, moves=moves))
                                tested.add(klass)
                                print(f'PASS NATIVE MAP BATTLE {label}: {moves} moves, returned to overworld', flush=True)
                                break
                        else:
                            raise RuntimeError('native map encounter timed out: ' + h.where())
                    except Exception as error:
                        self.check(False, f'{label}: {error}')
                        h.pb.screen.image.save(self.output / f'encounter-{label}-error.png')
        finally:
            h.pb.hook_deregister(*h.sym['ExitBattle'])
        self.result['encounter_contact_sheets'] = contact_pages(self.output, captures, 'encounter-sheet')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--classes', nargs='+', help='optional class names for focused reruns')
    parser.add_argument('--section', choices=['all', 'battles', 'overworld', 'maps', 'encounters'], default='all')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    h = Harness()
    h.ensure_fixture()
    selected = set(args.classes or [])
    unknown = selected - h.con.trainer_classes.keys()
    if unknown:
        parser.error('unknown classes: ' + ', '.join(sorted(unknown)))
    output = args.output or ROOT / '.tmpbuild' / ('trainer-sprites-' + h.rom_key())
    output.mkdir(parents=True, exist_ok=True)
    sweep = Sweep(h, output)
    try:
        for section in ('battles', 'overworld', 'maps', 'encounters'):
            if args.section in ('all', section):
                getattr(sweep, section)(selected)
    finally:
        h.pb.stop(save=False)
        (output / 'results.json').write_text(json.dumps(sweep.result, indent=2) + '\n')
    print(f'{len(sweep.result["battles"])} trainer introductions; {len(sweep.result["overworld"])} overworld sheets; '
          f'{len(sweep.result["maps"])} real maps; {sweep.result["checks"]} checks; '
          f'{len(sweep.result["encounters"])} completed native map battles; '
          f'{len(sweep.result["failures"])} failures', flush=True)
    return int(bool(sweep.result['failures']))


if __name__ == '__main__':
    raise SystemExit(main())

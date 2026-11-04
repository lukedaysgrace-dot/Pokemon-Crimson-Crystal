#!/usr/bin/env python3
"""Native release/debug HUD checks and previews; uses private emulator saves.

Checks every supplied symbol in every HUD slot, palette coexistence, single
types, Original/Enhanced typing, menu returns, animations and ability banners.
"""
import io
import json

from PIL import Image, ImageDraw, ImageFont

from gameplay_rules_checks import new_game
from probability_checks import call
from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text, wait

OUT = ROOT / '_artifacts/battle-type-icons'
TYPES = _parse_constants(ROOT / 'constants/type_constants.asm')
NAMES = ('normal fire fighting water flying grass poison electric ground '
         'psychic rock ice bug dragon ghost dark steel fairy').split()
CELLS = [(2, 1, 0x60, 5, 1), (3, 1, 0x61, 5, 2),
         (10, 8, 0x62, 5, 3), (11, 8, 0x63, 4, 1)]


def run(rom):
    h = Harness(rom_path=rom)
    pb, m = h.pb, h.battle.mem
    out = OUT / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    checks = 0
    captures = []
    watch_names = None
    live_frames = 0
    original_tick = h.tick
    art_cache = {}
    for name in NAMES:
        source = (ROOT / 'gfx/battle_type_icons' / (name + '.1bpp')).read_bytes()
        art_cache[name] = source

    def tick(frames=1):
        nonlocal live_frames
        for _ in range(frames):
            original_tick(1)
            if watch_names is None or not pb.memory[0xff40] & 0x80:
                continue
            visible = 0
            for slot, ((x, y, tile, palette, color), name) in enumerate(zip(CELLS, watch_names)):
                if (m.read('wTileMap', y*20+x) != tile or
                        pb.memory[0, 0x9800+y*32+x] != tile):
                    continue
                mask = art_cache[name]
                if slot in (1, 3) and watch_names[slot] == watch_names[slot-1]: mask = bytes(8)
                expected = bytes(v for row in mask for v in
                                 (row if color & 1 else 0, row if color & 2 else 0))
                check(bytes(pb.memory[1, 0x9600+slot*16:0x9610+slot*16]) == expected,
                      f'live animation: exact icon art in slot {slot}')
                check(pb.memory[1, 0x9800+y*32+x] == palette | 8,
                      f'live animation: hardware icon attribute in slot {slot}')
                visible += 1
            live_frames += bool(visible)

    h.tick = tick

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(message + '\n' + tile_text(h))

    def snapshot():
        state = io.BytesIO()
        pb.save_state(state)
        return state

    def restore(state):
        state.seek(0)
        pb.load_state(state)

    def native(symbol, **registers):
        begin_native_call(h, symbol)
        for key, value in registers.items():
            setattr(pb.register_file, key, value)
        for _ in range(180):
            h.tick()
            if pb.register_file.PC in (0xC0F1, 0xC0F3):
                h.tick(8)
                return
        raise RuntimeError(symbol + ' did not return: ' + h.where())

    def read_palette(buffer, palette, color):
        return bytes(m.read_bytes(buffer, 2, palette * 8 + color * 2))

    def verify(types, message):
        for slot, ((x, y, tile, palette, color), typ) in enumerate(zip(CELLS, types)):
            raw = (ROOT / 'gfx/battle_type_icons' / (typ + '.png'))
            image = Image.open(raw).convert('RGB')
            mask = [sum((image.getpixel((x, y)) == (0, 0, 0)) << (7-x)
                        for x in range(8)) for y in range(8)]
            if slot in (1, 3) and types[slot] == types[slot-1]:
                mask = [0] * 8
            expected = bytes(v for row in mask for v in
                             (row if color & 1 else 0, row if color & 2 else 0))
            check(bytes(pb.memory[1, 0x9600 + slot*16:0x9610 + slot*16]) == expected,
                  message + f': exact art in slot {slot}')
            check(m.read('wTileMap', y * 20 + x) == tile,
                  message + f': tile position {slot}')
            attr = palette | 8
            check(m.read('wAttrMap', y * 20 + x) == attr and
                  pb.memory[1, 0x9800 + y*32+x] == attr,
                  message + f': WRAM/VRAM attributes {slot}')
            bank, address = h.sym['BattleHUDTypeColors']
            expected_color = bytes(pb.memory[bank, address + TYPES[typ.upper()]*2:
                                            address + TYPES[typ.upper()]*2 + 2])
            check(read_palette('wBGPals1', palette, color) == expected_color and
                  read_palette('wBGPals2', palette, color) == expected_color,
                  message + f': color {slot}')
        check(pb.memory[0xff4f] & 1 == 0, message + ': VRAM bank restored')

    def capture(name):
        image = pb.screen.image.convert('RGB')
        image.save(out / (name + '.png'))
        captures.append((name, image))

    def encounter(player, enemy, rules=0, bench=None):
        restore(overworld)
        m.write('wGameplayRules', rules)
        for key, value in dict(wPartyCount=0, wMonType=0, wBattleMode=0,
                               wOptions=0x41).items():
            m.write(key, value)
        for species in [player] + ([bench] if bench else []):
            sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index(species))
            m.write('wCurPartySpecies', sid)
            m.write('wCurPartyLevel', 50)
            call(h, 'TryAddMonToParty')
        m.write('wPartyMon1Personality', m.read('wPartyMon1Personality') & ~0x60)
        move_ids = [call(h, 'GetMoveIDFromIndex', HL=h.con.moves[name])
                    for name in ('SPLASH', 'TACKLE', 'SWAGGER', 'RAIN_DANCE')]
        m.write_bytes('wPartyMon1Moves', move_ids)
        m.write_bytes('wPartyMon1PP', [30] * 4)
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index(enemy))
        for key, value in dict(wTempWildMonSpecies=sid, wCurPartyLevel=50,
                               wOtherTrainerClass=0, wBattleType=0, wBattleMode=0,
                               hCurWeather=0).items():
            m.write(key, value)
        begin_native_call(h, 'StartBattle')
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        # Keep real subsequent turns harmless without patching game code.
        m.write_bytes('wEnemyMonMoves', [move_ids[0], 0, 0, 0])
        m.write_bytes('wEnemyMonPP', [40, 0, 0, 0])
        m.write('wPlayerSubStatus5', m.read('wPlayerSubStatus5') | 0x80)
        return snapshot()

    try:
        new_game(h, 0)
        overworld = snapshot()
        baseline = encounter('MEW', 'SNORLAX')
        original = bytes(m.read_bytes('wBGPals1', 128))
        # Every type must be independently colored in all four possible slots.
        for i, name in enumerate(NAMES):
            restore(baseline)
            names = [name, NAMES[(i+1) % 18], NAMES[(i+2) % 18], NAMES[(i+3) % 18]]
            for symbol, typ in zip(('wEnemyMonType1', 'wEnemyMonType2',
                                    'wBattleMonType1', 'wBattleMonType2'), names):
                m.write(symbol, TYPES[typ.upper()])
            native('RefreshBattleTypeIcons')
            verify(names, name)
            # Six other BG palettes and all eight OBJ palettes stay exact.
            colors = bytes(m.read_bytes('wBGPals1', 128))
            touched = {5*8 + j for j in range(2, 8)} | {4*8+2, 4*8+3}
            check(all(a == b for j, (a, b) in enumerate(zip(original, colors))
                      if j not in touched), name + ': other colors preserved')
        restore(baseline)
        native('RefreshBattleTypeIcons')
        verify(['normal', 'normal', 'psychic', 'psychic'], 'single types')
        for symbol in ('BattleScreenLayoutWithTypes', 'ReloadBattleAnimColors',
                       'RestoreBattleAttrMapNoPalettes'):
            native(symbol)
            verify(['normal', 'normal', 'psychic', 'psychic'], symbol)
        for side in (0, 1):
            restore(baseline)
            m.write('hBattleTurn', side)
            native('PerformAbilityGFX', B=h.con.ability_id('NEUTRALIZING_GAS'))
            native('DismissAbilityOverlays')
            verify(['normal', 'normal', 'psychic', 'psychic'], f'ability banner {side}')

        # A legal Illusion entry uses its partner's selected typings while the
        # real battle types remain untouched. Clearing the disguise restores them.
        for rules, second in ((0, 'dragon'), (1, 'flying')):
            encounter('TOTODILE', 'SNORLAX', rules, bench='CHARIZARD')
            verify(['normal', 'normal', 'fire', second], f'Illusion rule {rules}')
            check(m.read('wBattleMonType1') == TYPES['WATER'], 'Illusion retains real types')
            m.write('wPlayerIllusionSlot', 0)
            native('RefreshBattleTypeIcons')
            verify(['normal', 'normal', 'water', 'water'], 'Illusion reveal')

        # Real species entries demonstrate both rule choices and all 18 colors.
        cases = [
            ('original-charizard-meganium', 'CHARIZARD', 'MEGANIUM', 1,
             ['grass', 'grass', 'fire', 'flying']),
            ('enhanced-charizard-meganium', 'CHARIZARD', 'MEGANIUM', 0,
             ['grass', 'fairy', 'fire', 'dragon']),
            ('water-fighting-rock-ground', 'POLIWRATH', 'GOLEM', 0,
             ['rock', 'ground', 'water', 'fighting']),
            ('bug-steel-ghost-poison', 'SCIZOR', 'GENGAR', 0,
             ['ghost', 'poison', 'bug', 'steel']),
            ('electric-normal', 'JOLTEON', 'SNORLAX', 0,
             ['normal', 'normal', 'electric', 'electric']),
            ('ice-dark-psychic', 'LAPRAS', 'UMBREON', 0,
             ['dark', 'dark', 'water', 'ice']),
            ('psychic-fairy', 'MEW', 'CLEFABLE', 0,
             ['fairy', 'fairy', 'psychic', 'psychic']),
            ('forest-seviper', 'MEWTWO', 'SEVIPER', 0,
             ['poison', 'dark', 'psychic', 'psychic']),
            ('forest-zangoose', 'MEWTWO', 'ZANGOOSE_SCARRED', 0,
             ['normal', 'poison', 'psychic', 'psychic']),
        ]
        for name, player, enemy, rules, names in cases:
            watch_names = None
            state = encounter(player, enemy, rules)
            verify(names, name)
            capture(name)
            h.press('a', hold=4, wait=60)
            wait(h, lambda: 'SPLASH' in tile_text(h))
            verify(names, name + ': move menu')
            if name.startswith('enhanced'):
                capture('enhanced-move-menu')
            h.press('b', hold=4, wait=60)
            wait(h, lambda: 'FIGHT' in tile_text(h))
            verify(names, name + ': move menu return')
            # A real attack runs the animation and end-of-turn palette restore.
            watch_names = names
            h.press('a', hold=4, wait=60)
            h.press('down', hold=4, wait=20)
            pp = m.read('wBattleMonPP', 1)
            h.press('a', hold=4, wait=20)
            wait(h, lambda: m.read('wBattleMonPP', 1) < pp and
                 'FIGHT' in tile_text(h), advance=True)
            verify(names, name + ': animation return')
            # The Pack replaces VRAM and palettes; its ordinary return rebuilds.
            watch_names = None
            restore(state)
            h.press('down', hold=4, wait=20)
            h.press('a', hold=4, wait=100)
            h.press('b', hold=4, wait=100)
            wait(h, lambda: 'FIGHT' in tile_text(h))
            verify(names, name + ': Pack return')
            if name.startswith('forest-'):
                watch_names = names
                native('GetEnemyMonFrontpic')
                verify(names, name + ': enemy picture reload')

        check(live_frames > 0, 'live animation frames were inspected')
        (out / 'checks.json').write_text(json.dumps({'checks': checks, 'live_frames': live_frames, 'rom': rom.name}, indent=2))
        print(f'{rom.name}: {checks} type-icon checks passed across {live_frames} live frames', flush=True)
        return captures
    finally:
        pb.stop(save=False)


def previews(captures):
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 18)
    small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 14)
    # A readable color chart uses the exact supplied pixels and ROM RGB values.
    h = Harness(rom_path=ROOT / 'pokecrystal.gbc')
    try:
        bank, address = h.sym['BattleHUDTypeColors']
        sheet = Image.new('RGB', (780, 414), '#f5f5f7')
        draw = ImageDraw.Draw(sheet)
        draw.text((20, 12), 'All 18 battle type icons', fill='#202028', font=font)
        for i, name in enumerate(NAMES):
            col, row = i % 3, i // 3
            x, y = 20 + col*256, 50 + row*60
            typ = TYPES[name.upper()]
            raw = bytes(h.pb.memory[bank, address+typ*2:address+typ*2+2])
            rgb = int.from_bytes(raw, 'little')
            color = tuple(round(((rgb >> shift) & 31)*255/31) for shift in (0, 5, 10))
            icon = Image.open(ROOT / 'gfx/battle_type_icons' / (name+'.png')).convert('RGB')
            for yy in range(8):
                for xx in range(8):
                    if icon.getpixel((xx, yy)) == (0, 0, 0):
                        icon.putpixel((xx, yy), color)
            draw.rounded_rectangle((x-5, y-4, x+235, y+49), radius=8, fill='white')
            sheet.paste(icon.resize((40, 40), Image.Resampling.NEAREST), (x, y))
            draw.text((x+54, y+10), name.title(), font=font, fill='#202028')
        sheet.save(OUT / 'all-types.png')
        selected = captures[:2]
        pairs = Image.new('RGB', (680, 350), '#f5f5f7')
        draw = ImageDraw.Draw(pairs)
        for i, (name, img) in enumerate(selected):
            x = 10+i*340
            draw.text((x, 12), 'Original typings' if i == 0 else 'Enhanced typings',
                      font=font, fill='#202028')
            pairs.paste(img.resize((320, 288), Image.Resampling.NEAREST), (x, 45))
        pairs.save(OUT / 'original-enhanced.png')
        grid = Image.new('RGB', (1020, 690), '#f5f5f7')
        draw = ImageDraw.Draw(grid)
        for i, (name, img) in enumerate(captures[2:8]):
            x, y = 10+(i%3)*340, 10+(i//3)*340
            draw.text((x, y), name.replace('-', ' ').title(), font=small, fill='#202028')
            grid.paste(img.resize((320, 288), Image.Resampling.NEAREST), (x, y+30))
        grid.save(OUT / 'battle-gallery.png')
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    for name in ('pokecrystal', 'pokecrystal_debug'):
        captures = run(ROOT / (name + '.gbc'))
        if name == 'pokecrystal':
            previews(captures)

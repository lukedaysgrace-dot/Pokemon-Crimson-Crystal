#!/usr/bin/env python3
"""Rendered walking/transition checks with independent BG/attribute oracles.

Initial party/location/weather are staged in private emulator memory. Native
buttons drive movement, map connections, warps, menus and a wild battle. Hooks
observe queue publication and actual VBlank timing; no game code is patched.
"""
from collections import Counter
import json
from pathlib import Path

from PIL import Image, ImageDraw

from runner import Harness, ROOT
from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from ui_checks import tile_text, wait


def run(rom):
    h = Harness(rom_path=rom)
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    out = ROOT / '.tmpbuild/streamed-map' / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    checks = 0
    captures, screens, queues, endpoints = [], [], [], []
    maps = map_ids()
    active = [False]

    def check(ok, description):
        nonlocal checks
        checks += 1
        assert ok, f'{rom.name}: {description}: {h.where()}\n{tile_text(h)}'

    def word(name):
        return int.from_bytes(m.read_bytes(name, 2), 'little')

    def expected_screen():
        anchor = word('wOverworldMapAnchor')
        stride = m.read('wMapWidth') + 6
        mx, my = m.read('wMetatileStandingX') * 2, m.read('wMetatileStandingY') * 2
        tables = [(m.read('wTilesetBlocksBank'), word('wTilesetBlocksAddress')),
                  (m.read('wTilesetAttributesBank'), word('wTilesetAttributesAddress'))]
        result = [bytearray(), bytearray()]
        for y in range(18):
            for x in range(20):
                block = pb.memory[anchor + (y + my) // 4 * stride + (x + mx) // 4]
                block = block or m.read('wMapBorderBlock')
                offset = block * 16 + (y + my) % 4 * 4 + (x + mx) % 4
                for plane, (bank, base) in enumerate(tables):
                    result[plane].append(pb.memory[bank, base + offset])
        return [bytes(data) for data in result]

    def screen_check(label, capture=False):
        expected = expected_screen()
        anchor = word('wBGMapAnchor') - 0x9800
        top, left = divmod(anchor, 32)
        for plane in range(2):
            actual = bytes(pb.memory[plane, 0x9800 + (top + y) % 32 * 32 + (left + x) % 32]
                           for y in range(18) for x in range(20))
            if actual != expected[plane]:
                mismatch = [(i % 20, i // 20, a, e) for i, (a, e) in enumerate(zip(actual, expected[plane])) if a != e]
                pb.screen.image.save(out / 'failure.png')
                (out / 'failure.json').write_text(json.dumps(dict(label=label, plane=plane, anchor=anchor,
                        position=c.position(), mismatch=mismatch, map=c.map_id()), indent=2))
                check(False, f'{label} BG plane {plane}: {mismatch[:12]}')
            check(True, f'{label} complete BG plane {plane}')
        screens.append(dict(label=label, map=c.map_id(), position=c.position(), anchor=anchor))
        if capture:
            image = pb.screen.image.convert('RGB')
            image.save(out / (label + '.png'))
            captures.append((label, image))

    def queue_published(_):
        if not active[0]:
            return
        direction = m.read('wPlayerStepDirection')
        expected = expected_screen()
        for plane, name in enumerate(('wBGMapBuffer', 'wBGMapPalBuffer')):
            if direction < 2:
                start = 320 if direction == 0 else 0
                data = expected[plane][start:start + 40]
            else:
                x = 18 if direction == 3 else 0
                data = b''.join(expected[plane][y * 20 + x:y * 20 + x + 2] for y in range(18))
            check(bytes(m.read_bytes(name, len(data))) == data, f'native direction {direction} queue plane {plane}')
        check(m.read('hBGMapMode') == 0, 'native queue disables stale full-map upload')
        queues.append(dict(direction=direction, map=c.map_id(), anchor=word('wBGMapAnchor')))

    def enter(name, x, y):
        print('ENTER', name, flush=True)
        group, number = maps[name]
        active[0] = False
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                               wXCoord=x, wYCoord=y, hMapEntryMethod=0xf1, hOAMUpdate=0).items():
            m.write(key, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(c.map_id() == (group, number) and m.read('wMapStatus') == 2, name + ' entered')
        active[0] = True
        screen_check(name.lower() + '-entry', capture=True)

    def walk_to(goal, label):
        origin = c.map_id()
        avoid = [(x, y) for y in range(m.read('wMapHeight') * 2)
                 for x in range(m.read('wMapWidth') * 2) if c.collision(x, y) >> 4 in (6, 7)]
        for _ in range(180):
            if c.position() == tuple(goal):
                break
            check(c.map_id() == origin and not m.read('wBattleMode') and not m.read('wScriptMode'), label + ' remains in walking mode')
            path = c.path(goal, avoid=avoid)
            c.press(path[0], hold=4, wait=36)
            screen_check(label)
        else:
            raise RuntimeError(label + ' walking did not reach ' + str(goal))
        check(c.position() == tuple(goal), label + ' reached destination')

    def walk_loop(label):
        origin = c.position()
        # Far reachable floor tiles exercise both axes and wrap the 32x32 BG.
        candidates = []
        for y in range(1, m.read('wMapHeight') * 2 - 1):
            for x in range(1, m.read('wMapWidth') * 2 - 1):
                if not c.passable(c.collision(x, y)) or c.collision(x, y) >> 4 in (6, 7):
                    continue
                try:
                    path = c.path((x, y))
                except (RuntimeError, IndexError):
                    continue
                if 6 <= len(path) <= 45:
                    candidates.append((len(path), (x, y)))
        check(bool(candidates), label + ' has a walkable route')
        goal = max(candidates)[1]
        walk_to(goal, label + '-out')
        screen_check(label + '-far', capture=True)
        walk_to(origin, label + '-back')

    def small_walk(label):
        origin = c.position()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            goal = origin[0] + dx, origin[1] + dy
            try:
                if len(c.path(goal)) == 1:
                    walk_to(goal, label)
                    return
            except (RuntimeError, IndexError):
                continue
        raise RuntimeError(label + ': no adjacent walkable floor at ' + str(origin))

    def menu(label):
        origin = c.position()
        c.press('start', hold=4, wait=60)
        check('SAVE' in tile_text(h), label + ' Start menu opens after streaming')
        for _ in range(12):
            if m.read('wMenuSelection') == 2:
                break
            c.press('down', hold=4, wait=20)
        check(m.read('wMenuSelection') == 2, label + ' Pack selected')
        c.press('a', hold=4, wait=110)
        check('CANCEL' in tile_text(h), label + ' Pack opens')
        c.press('b', hold=4, wait=100)
        c.press('b', hold=4, wait=100)
        check(c.position() == origin and m.read('hOAMUpdate') == 0, label + ' menu restores overworld')
        screen_check(label + '-menu-return', capture=True)
        # Ensure the first step after a full redraw re-disables background mode.
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            goal = origin[0] + dx, origin[1] + dy
            try:
                if len(c.path(goal)) == 1:
                    walk_to(goal, label + '-after-menu')
                    walk_to(origin, label + '-after-menu-back')
                    break
            except (RuntimeError, IndexError):
                pass

    def invoke(name):
        begin_native_call(h, name)
        for _ in range(500):
            h.tick(4)
            if pb.register_file.PC in (0xc0f1, 0xc0f3):
                return
        raise RuntimeError(name + ' did not return: ' + h.where())

    def resume():
        begin_native_call(h, 'OverworldLoop.loop')
        m.write('wMapStatus', 2)
        h.tick(100)

    pending = [False]
    def oam_done(_):
        if pending[0]:
            endpoints.append((pb.memory[0xff44], bool(pb.memory[0xff40] & 0x80)))
            pending[0] = False

    try:
        new_game(h, 0)
        sid = call(h, 'GetPokemonIDFromIndex', HL=157)
        for key, value in dict(wPartyCount=0, wMonType=0, wCurPartySpecies=sid, wCurPartyLevel=50,
                               wBattleMode=0, wOptions=0x41).items():
            m.write(key, value)
        call(h, 'TryAddMonToParty')
        # Keep navigation deterministic; the explicit wild-battle script below
        # separately exercises a real fight and the normal map-return flow.
        m.write('wStatusFlags', m.read('wStatusFlags') | 1 << 5)
        pb.hook_register(*h.sym['PublishMapEdge'], queue_published, None)
        pb.hook_register(*h.sym['VBlank0.done'], lambda _: pending.__setitem__(0, True), None)
        pb.hook_register(*h.sym['VBlank0.done_oam'], oam_done, None)

        enter('GOLDENROD_CITY', 15, 28)
        walk_loop('goldenrod')
        menu('goldenrod')
        invoke('OpenText')
        invoke('CloseText')
        resume()
        screen_check('text-return', capture=True)
        # Simulate a script's block edit in private memory, then execute the
        # existing reloadmappart command and verify both planes are rebuilt.
        edited = word('wOverworldMapAnchor') + m.read('wMapWidth') + 8
        original = pb.memory[edited]
        for value in (1, original):
            pb.memory[edited] = value
            invoke('Script_reloadmappart')
            resume()
            screen_check('scripted-block-refresh')

        enter('AZALEA_TOWN', 15, 10)
        m.write('wCurDay', 0)
        begin_native_call(h, '_SetCurrentWeather')
        for _ in range(400):
            h.tick(4)
            if pb.register_file.PC in (0xc0f1, 0xc0f3):
                break
        else:
            raise RuntimeError('weather loader did not return')
        begin_native_call(h, 'OverworldLoop.loop')
        m.write('wMapStatus', 2)
        h.tick(100)
        check(m.read('hCurWeather') == 3, 'rain remains active')
        walk_loop('rain')
        menu('rain')

        enter('SILVER_CAVE_ROOM_3', 8, 10)
        check(m.read('hCurWeather') == 5, 'snow remains active')
        walk_loop('snow')
        menu('snow')

        # Walk through the native east/west map connection in both directions.
        enter('CHERRYGROVE_CITY', 38, 7)
        for _ in range(8):
            c.press('right', hold=4, wait=40)
            if c.map_id() == maps['ROUTE_29']:
                break
        check(c.map_id() == maps['ROUTE_29'], 'native east connection')
        h.tick(120)
        screen_check('connection-east', capture=True)
        for _ in range(8):
            c.press('left', hold=4, wait=40)
            if c.map_id() == maps['CHERRYGROVE_CITY']:
                break
        check(c.map_id() == maps['CHERRYGROVE_CITY'], 'native west connection')
        h.tick(120)
        screen_check('connection-west', capture=True)

        # A native door warp rebuilds the screen after streamed indoor steps.
        enter('PLAYERS_HOUSE_1F', 6, 6)
        for _ in range(4):
            c.press('down', hold=4, wait=180)
            if c.map_id() == maps['NEW_BARK_TOWN']:
                break
        check(c.map_id() == maps['NEW_BARK_TOWN'], 'native door warp at ' + str(c.position()))
        screen_check('door-return', capture=True)

        # Queue the real wild-battle script, including its native reload command.
        enter('ROUTE_29', 20, 10)
        small_walk('before-battle')
        sid = call(h, 'GetPokemonIDFromIndex', HL=19)
        for key, value in dict(wTempWildMonSpecies=sid, wCurPartyLevel=3, wOtherTrainerClass=0,
                               wBattleType=0, wBattleMode=0).items():
            m.write(key, value)
        active[0] = False
        bank, address = h.sym['WildBattleScript']
        call(h, 'CallScript', A=bank, HL=address)
        call(h, 'EnableScriptMode')
        begin_native_call(h, 'OverworldLoop.loop')
        m.write('wMapStatus', 2)
        m.write('wMapEventStatus', 0)
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        c.battle()
        check(m.read('wBattleMode') == 0, 'native wild battle completed')
        active[0] = True
        h.tick(100)
        screen_check('battle-return', capture=True)
        small_walk('after-battle')

        directions = Counter(q['direction'] for q in queues)
        check(set(directions) == {0, 1, 2, 3}, 'all four directions observed natively')
        check(len(queues) > 80, 'many native walking updates observed')
        check(any((q['anchor'] & 31) == 0 for q in queues) and
              any((q['anchor'] & 31) == 30 for q in queues), 'horizontal BG wrap observed')
        check(any((q['anchor'] - 0x9800) // 32 == 30 for q in queues), 'vertical BG wrap observed')
        check(not [(ly, lcd) for ly, lcd in endpoints if lcd and not 144 <= ly <= 153], 'OAM completes in VBlank')
        canvas = Image.new('RGB', (160 * 4, 166 * ((len(captures) + 3) // 4)), 'white')
        draw = ImageDraw.Draw(canvas)
        for i, (label, image) in enumerate(captures):
            x, y = i % 4 * 160, i // 4 * 166
            draw.text((x + 2, y + 2), label, fill='black')
            canvas.paste(image, (x, y + 22))
        canvas.save(out / 'contact.png')
        result = dict(rom=rom.name, checks=checks, verified_screens=len(screens),
                      native_queues=len(queues), directions=dict(directions), screenshots=len(captures),
                      observed_vblanks=len(endpoints), latest_oam_scanline=max(ly for ly, lcd in endpoints if lcd))
        (out / 'native-results.json').write_text(json.dumps(result, indent=2))
        print(json.dumps(result), flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    import sys
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        run(rom)

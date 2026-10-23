#!/usr/bin/env python3
"""Rendered engine smoke session: New Game, maps, weather, menus, battle.

Uses private SRAM, stages a party and map locations, then drives normal input.
No ROM patches or debug automatic battle actions; works on release and debug.
"""
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
    out = ROOT / '.tmpbuild/engine-optimizations-ui' / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    captures, observations = [], []
    endpoints = []
    checks = 0

    def check(ok, description):
        nonlocal checks
        checks += 1
        assert ok, description + ': ' + h.where() + '\n' + tile_text(h)

    def capture(label):
        image = pb.screen.image.convert('RGB')
        image.save(out / (label + '.png'))
        captures.append((label, image))
        observations.append(dict(label=label, map=c.map_id(), position=c.position(),
                                 weather=m.read('hCurWeather'), text=tile_text(h)))

    def enter(name, x, y):
        group, number = map_ids()[name]
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                               wMapNumber=number, wXCoord=x, wYCoord=y,
                               hMapEntryMethod=0xf1, hOAMUpdate=0).items():
            m.write(key, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(c.map_id() == (group, number) and m.read('wMapStatus') == 2, name + ' entered')

    def menu(label, entry=None):
        original = c.position()
        c.press('start', hold=4, wait=60)
        check('SAVE' in tile_text(h), label + ' Start menu')
        capture(label + '-start')
        if entry:
            for _ in range(15):
                if m.read('wMenuSelection') == entry:
                    break
                c.press('down', hold=4, wait=20)
            check(m.read('wMenuSelection') == entry, label + ' menu selection')
            c.press('a', hold=4, wait=120)
            capture(label + '-pack')
            c.press('b', hold=4, wait=100)
        c.press('b', hold=4, wait=80)
        check(c.position() == original and m.read('hOAMUpdate') == 0, label + ' returned to map')
        capture(label + '-returned')

    def walk_loop(label):
        origin = c.position()
        goals = []
        # Pick reachable floor tiles from the actual loaded collision map.
        for dy in range(-4, 5):
            for dx in range(-4, 5):
                if abs(dx) + abs(dy) < 3:
                    continue
                goal = origin[0] + dx, origin[1] + dy
                try:
                    steps = c.path(goal)
                except (RuntimeError, IndexError):
                    continue
                if 3 <= len(steps) <= 12:
                    goals.append(goal)
        check(bool(goals), label + ' has a walkable route')
        for goal in (goals[0], origin):
            c.go(goal)
            check(c.position() == goal, label + ' button walking to ' + str(goal))

    try:
        new_game(h, 0)
        check(c.map_id() == (24, 7), 'native New Game reached bedroom')
        check(m.read('wGameplayRules') == 0, 'chosen gameplay rules preserved')
        capture('new-game')
        # Generate an ordinary level-50 starter using the release game's code.
        sid = call(h, 'GetPokemonIDFromIndex', HL=157)  # Typhlosion
        for key, value in dict(wPartyCount=0, wMonType=0, wCurPartySpecies=sid,
                               wCurPartyLevel=50, wBattleMode=0, wOptions=0x41).items():
            m.write(key, value)
        call(h, 'TryAddMonToParty')
        check(m.read('wPartyCount') == 1 and m.read_u16_be('wPartyMon1HP') > 0, 'native party generated')

        # Observe actual interrupt completion during gameplay, not a stubbed ISR.
        oam_pending = [False]
        def oam_done(_):
            if oam_pending[0]:
                endpoints.append((pb.memory[0xff44], bool(pb.memory[0xff40] & 0x80)))
                oam_pending[0] = False
        pb.hook_register(*h.sym['VBlank0.done'], lambda _: oam_pending.__setitem__(0, True), None)
        pb.hook_register(*h.sym['VBlank0.done_oam'], oam_done, None)
        enter('GOLDENROD_CITY', 15, 28)
        capture('goldenrod')
        walk_loop('Goldenrod')
        menu('goldenrod', entry=2)  # PACK

        enter('AZALEA_TOWN', 15, 10)
        m.write('wCurDay', 0)  # Sunday's existing Azalea rain schedule.
        # Refresh via the actual weather selector/graphics loader.
        begin_native_call(h, '_SetCurrentWeather')
        for _ in range(400):
            h.tick(4)
            if pb.register_file.PC in (0xc0f1, 0xc0f3):
                break
        else:
            raise RuntimeError('weather graphics loader did not return')
        # Return to the map loop after the controlled weather refresh.
        begin_native_call(h, 'OverworldLoop')
        m.write('wMapStatus', 2)
        h.tick(90)
        check(m.read('hCurWeather') == 3, 'Azalea rain active')
        capture('azalea-rain')
        before = bytes(m.read_bytes('wVirtualOAM', 160))
        h.tick(12)
        check(bytes(m.read_bytes('wVirtualOAM', 160)) != before, 'rain particles animate')
        walk_loop('rain')
        menu('rain')

        enter('SILVER_CAVE_ROOM_3', 8, 10)
        check(m.read('hCurWeather') == 5, 'cave snow active')
        capture('cave-snow')
        menu('snow')

        # Stage one ordinary wild encounter; fight it using the native menus.
        enter('ROUTE_29', 20, 10)
        sid = call(h, 'GetPokemonIDFromIndex', HL=19)
        for key, value in dict(wTempWildMonSpecies=sid, wCurPartyLevel=3,
                               wOtherTrainerClass=0, wBattleType=0, wBattleMode=0).items():
            m.write(key, value)
        begin_native_call(h, 'StartBattle')
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        check(m.read('wBattleMode') == 1, 'native wild battle reached Fight menu')
        capture('battle-menu')
        c.battle()
        check(m.read('wBattleMode') == 0 and m.read_u16_be('wPartyMon1HP') > 0, 'battle completed')
        enter('ROUTE_29', 20, 10)
        capture('battle-return')

        check(len(endpoints) > 300, 'normal VBlank observed throughout native play')
        late = [(ly, lcd) for ly, lcd in endpoints if lcd and not 144 <= ly <= 153]
        check(not late, 'OAM always completed within VBlank ' + str(late[:20]))
        canvas = Image.new('RGB', (160 * 4, 166 * ((len(captures) + 3) // 4)), 'white')
        draw = ImageDraw.Draw(canvas)
        for i, (label, image) in enumerate(captures):
            x, y = i % 4 * 160, i // 4 * 166
            draw.text((x + 2, y + 2), label, fill='black')
            canvas.paste(image, (x, y + 22))
        canvas.save(out / 'contact.png')
        result = dict(rom=rom.name, checks=checks, screenshots=len(captures),
                      observed_vblanks=len(endpoints), last_oam_scanline=max(ly for ly, lcd in endpoints if lcd),
                      observations=observations)
        (out / 'results.json').write_text(json.dumps(result, indent=2))
        print(json.dumps({k: v for k, v in result.items() if k != 'observations'}), flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    import sys
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        run(rom)

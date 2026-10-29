#!/usr/bin/env python3
"""Exercise Route 31's native Wimpod movement, field move and battle scripts.

Initial location/party are staged in private PyBoy state. Buttons trigger the
coordinate scripts and interaction; no player save is opened or changed.
"""
import json
import sys
from collections import Counter

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants
from ui_checks import tile_text


def main():
    h = Harness()
    pb, m = h.pb, h.battle.mem
    controls = Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    flags.update(EVENT_ROUTE_31_WIMPOD_HIDDEN=0,
                 EVENT_ROUTE_31_WIMPOD_SWEET_SCENT=1,
                 EVENT_ROUTE_31_WIMPOD_WAITING=2)
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    menus = _parse_constants(ROOT / 'constants/menu_constants.asm')
    output = ROOT / '.tmpbuild/wimpod'
    output.mkdir(parents=True, exist_ok=True)
    checks, entries, disappearances, emotes, battles = [], [], [], [], []
    frames = []

    def check(ok, message):
        if not ok:
            pb.screen.image.save(output / 'failure.png')
            raise AssertionError(message + '\n' + tile_text(h))
        checks.append(message)
        print('PASS', message, flush=True)

    def event(name, value=None):
        bit = flags[name]
        byte = m.read('wEventFlags', bit // 8)
        mask = 1 << (bit % 8)
        if value is not None:
            m.write('wEventFlags', byte | mask if value else byte & ~mask, bit // 8)
        return bool(m.read('wEventFlags', bit // 8) & mask)

    def obj():
        base = h.sym.addr('wObjectStructs')
        for slot in range(1, 13):
            address = base + slot * 40
            if pb.memory[address] == sprites['SPRITE_WIMPOD'] and pb.memory[address + 1] == 8:
                return address
        return None

    def snapshot():
        address = obj()
        return dict(x=pb.memory[address + 18]-4, y=pb.memory[address + 19]-4,
                    next_x=pb.memory[address + 16]-4, next_y=pb.memory[address + 17]-4,
                    duration=pb.memory[address + 10], pixel_y=pb.memory[address + 24],
                    facing=pb.memory[address + 8], movement=pb.memory[address + 3],
                    flags2=pb.memory[address + 5], step_type=pb.memory[address + 9],
                    movement_object=m.read('wMovementObject'),
                    movement_bank=m.read('wMovementDataBank'),
                    movement_address=int.from_bytes(m.read_bytes('wMovementDataAddress', 2), 'little')) if address else None

    for name, callback in (
            ('Route31WimpodStartEnteringDen', lambda _: entries.append(snapshot())),
            ('Script_disappear', lambda _: disappearances.append(snapshot())),
            ('Script_showemote', lambda _: emotes.append(snapshot())),
            ('Script_startbattle', lambda _: battles.append(snapshot()))):
        pb.hook_register(*h.sym[name], callback, None)

    def stage(x, y, finished=False):
        h.load_fixture()
        entries.clear()
        disappearances.clear()
        emotes.clear()
        battles.clear()
        event('EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST', True)
        event('EVENT_ROUTE_31_WIMPOD_FINISHED', finished)
        m.write('wEventFlags', 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', Request(h.battle)._side_bytes(dict(
            species='MEW', level=100, moves=['PSYCHIC_M', 'SWEET_SCENT', 'SURF', 'RECOVER'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for field in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode',
                      'wStatusFlags2', 'wInBattleTowerBattle'):
            m.write(field, 0)
        group, number = map_ids()['ROUTE_31']
        for field, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                                 wMapNumber=number, wXCoord=x, wYCoord=y,
                                 hMapEntryMethod=0xf1, hOAMUpdate=0,
                                 wOptions=0xc1, wRepelEffect=255).items():
            m.write(field, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(120)

    def finish_dialogue(record=False):
        for frame in range(2400):
            if record and frame % 3 == 0:
                frames.append(pb.screen.image.copy())
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                if h.text_overflows:
                    raise AssertionError('Textbox overflow: ' + str(h.text_overflows))
                return
            if frame % 24 == 23:
                pb.button('a', 4)
            h.tick()
        raise AssertionError('Wimpod script did not finish: ' + tile_text(h))

    def sweet_scent():
        controls.press('start', hold=4, wait=60)
        for _ in range(12):
            if m.read('wMenuSelection') == 1:  # POKEMON
                break
            controls.press('up', hold=4, wait=20)
        check(m.read('wMenuSelection') == 1, 'the party menu is selected')
        controls.press('a', hold=4, wait=80)
        controls.press('a', hold=4, wait=80)
        options = list(m.read_bytes('wBuffer2', m.read('wBuffer1')))
        item = menus['MONMENUITEM_SWEETSCENT']
        check(item in options, 'Sweet Scent is offered as a field move')
        target = options.index(item) + 1
        for _ in range(8):
            if m.read('wMenuCursorY') == target:
                break
            controls.press('down', hold=4, wait=20)
        controls.press('a', hold=4, wait=60)
        finish_dialogue()
        check(event('EVENT_ROUTE_31_WIMPOD_SWEET_SCENT') and not m.read('wBattleMode'),
              'using Sweet Scent on bare ground prepares Wimpod without a random battle')

    approaches = [((19, 6), 'right', (20, 6)), ((19, 7), 'right', (20, 7)),
                  ((19, 8), 'right', (20, 8)), ((21, 9), 'up', (21, 8)),
                  ((22, 9), 'up', (22, 8)), ((23, 9), 'up', (23, 8)),
                  ((25, 8), 'left', (24, 8)), ((25, 7), 'left', (24, 7)),
                  ((25, 6), 'left', (24, 6))]
    try:
        h.ensure_fixture()
        stage(22, 9)
        check(snapshot()['x'] == 22 and snapshot()['y'] == 6 and snapshot()['facing'] == 0,
              'Wimpod spawns at (22,6), facing down')
        palette = bytes.fromhex('ff7f186392480000')
        check(m.read_bytes('wOBPals1', 8, 7*8) == palette,
              'Wimpod has opaque neutral gray and purple in its dedicated OBJ palette')
        used = m.read_bytes('wUsedSprites', 64)
        check(sprites['SPRITE_WIMPOD'] in used[::2], 'Wimpod graphics are allocated on the actual outdoor map')
        raw = (ROOT / 'gfx/sprites/wimpod.2bpp').read_bytes()
        counts = Counter(((raw[i] >> bit) & 1) | (((raw[i+1] >> bit) & 1) << 1)
                         for i in range(0, len(raw), 2) for bit in range(8))
        check(counts == {0: 785, 1: 194, 2: 231, 3: 326},
              'all gray and purple source pixels compile as opaque colors')
        pb.screen.image.save(output / '01-wimpod.png')

        for start, direction, trigger in approaches:
            stage(*start)
            controls.press(direction, hold=8, wait=48)
            check(controls.position() == trigger, f'{trigger}: the player reaches the proximity tile')
            finish_dialogue(record=trigger == (20, 6))
            den = 18 if trigger == (20, 6) else 19
            check(event('EVENT_ROUTE_31_WIMPOD_HIDDEN') and obj() is None and not battles,
                  f'{trigger}: proximity causes escape, with no battle')
            check(bool(emotes) and entries[-1]['x'] == den and entries[-1]['y'] == 6,
                  f'{trigger}: startled Wimpod reaches the correct den entrance')
            disappearing = [entry for entry in disappearances if entry][-1]
            check(disappearing['y'] == 6 and disappearing['next_y'] == 5
                  and 0 < disappearing['duration'] < 16
                  and disappearing['pixel_y'] < entries[-1]['pixel_y'],
                  f'{trigger}: Wimpod disappears during its step into ({den},5)')
            check(not event('EVENT_ROUTE_31_WIMPOD_FINISHED') and not m.read('wVramState') & 128,
                  f'{trigger}: fleeing leaves the encounter repeatable and movement unlocked')
            check(any('Route31WimpodFledText' in text for text in h.battle.textbox_contexts),
                  f'{trigger}: escape dialogue is displayed')

        # Reload through another map without clearing event flags in the test.
        for map_name, x, y in [('ROUTE_31_VIOLET_GATE', 4, 4), ('ROUTE_31', 22, 9)]:
            group, number = map_ids()[map_name]
            for field, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                                     wMapNumber=number, wXCoord=x, wYCoord=y,
                                     hMapEntryMethod=0xf1).items():
                m.write(field, value)
            begin_native_call(h, 'OverworldLoop')
            h.tick(120)
        check(obj() is not None and not event('EVENT_ROUTE_31_WIMPOD_HIDDEN'),
              'Wimpod returns when Route 31 is reloaded after an escape')

        for start, direction, trigger in approaches:
            stage(*start)
            sweet_scent()
            controls.press(direction, hold=8, wait=48)
            check(controls.position() == trigger, f'{trigger}: the scented player reaches the same proximity tile')
            finish_dialogue()
            state = snapshot()
            check(state is not None and abs(state['x']-trigger[0]) + abs(state['y']-trigger[1]) == 1,
                  f'{trigger}: scented Wimpod walks to an adjacent tile')
            check(event('EVENT_ROUTE_31_WIMPOD_WAITING') and not battles and not emotes,
                  f'{trigger}: Wimpod waits for A without fleeing or battling early')
            check(any('Route31WimpodLikesScentText' in text for text in h.battle.textbox_contexts),
                  f'{trigger}: peculiar glance and smell dialogue is displayed')
            if trigger == (22, 8):
                pb.screen.image.save(output / '02-wimpod-approached.png')
                # The approach leaves both characters facing one another.
                controls.press('a', hold=4, wait=12)
                for frame in range(2400):
                    if battles and m.read('wBattleMode') == 1:
                        break
                    if frame % 24 == 23:
                        pb.button('a', 4)
                    h.tick()
                check(len(emotes) == 1 and bool(battles) and battles[-1]['facing'] == 4,
                      'pressing A startles Wimpod and turns it away before the battle')
                for _ in range(100):
                    if m.read('wEnemyMonSpecies'):
                        break
                    h.tick()
                check(m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species['WIMPOD']
                      and m.read('wEnemyMonLevel') == 8, 'the interaction starts a level 8 wild Wimpod encounter')
                controls.battle(limit=18000)
                finish_dialogue()
                check(event('EVENT_ROUTE_31_WIMPOD_FINISHED') and obj() is None,
                      'the completed battle removes Wimpod and records completion')

        stage(22, 9, finished=True)
        check(obj() is None, 'completed Wimpod encounter stays hidden on map re-entry')
        check(not h.text_overflows, 'Wimpod dialogue fits the textbox')
        if frames:
            frames[0].save(output / 'wimpod-escape.gif', save_all=True,
                           append_images=frames[1:], duration=50, loop=0)
        (output / 'checks.json').write_text(json.dumps(checks, indent=2) + '\n')
        print(f'{len(checks)} native Wimpod checks passed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()

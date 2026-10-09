#!/usr/bin/env python3
"""Exercise both toll entrances, payment, two native battles, and losses.

Only the party/map in private emulator memory is staged. Gate entry, choices,
battles, escape movements, and subsequent gate visits use the real game.
"""

import io
import re

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness
from save_menu_checks import begin_native_call
from state import Request
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    h = Harness(cartridge='native')
    pb, m = h.pb, h.battle.mem
    output = ROOT / '.tmpbuild/rocket-toll'
    output.mkdir(parents=True, exist_ok=True)
    try:
        new_game(h, 0)
        flags = _parse_constants(ROOT / 'constants/event_flags.asm')
        maps = {}
        group = number = 0
        for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
            if re.match(r'\s+newgroup\b', line):
                group += 1
                number = 0
            match = re.match(r'\s+map_const\s+(\w+),', line)
            if match:
                number += 1
                maps[match[1]] = (group, number)
        c = Controls(h)
        request = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
            species='MEWTWO', level=100, ability='MOLD_BREAKER', item='CHOICE_SPECS',
            moves=['SURF', 'DRAGON_PULSE', 'THUNDERBOLT', 'PSYCHIC_M'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wOptions', 0xC1)  # fast text, battle effects off, Set battle style
        m.write('wDefaultSpawnpoint', 255)

        def event(name, value=None):
            flag = flags[name]
            old = m.read('wEventFlags', flag // 8)
            mask = 1 << (flag % 8)
            if value is None:
                return bool(old & mask)
            m.write('wEventFlags', old | mask if value else old & ~mask, flag // 8)

        event('EVENT_ROUTE_43_GATE_ROCKETS', False)
        event('EVENT_CLEARED_ROCKET_HIDEOUT', False)
        event('EVENT_LAKE_OF_RAGE_CIVILIANS', True)
        baseline = io.BytesIO()
        pb.save_state(baseline)
        battles = []
        lose_at = [None]
        escape_paths = []
        departures = []

        def script_bytes(count):
            bank = m.read('wScriptBank')
            pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
            return [pb.memory[bank, pos + i] for i in range(count)]

        def applying_movement(_):
            obj, lo, hi = script_bytes(3)
            if lo | hi << 8 == h.sym.addr('RocketRunsAway'):
                obj -= 1  # GetScriptObject converts script IDs to map-object slots.
                position = next(o['position'] for o in c.objects() if o['map_object'] == obj)
                escape_paths.append(dict(object=obj, positions=[position]))

        def disappearing(_):
            obj = script_bytes(1)[0] - 1
            if obj in (2, 3):
                positions = [o['position'] for o in c.objects() if o['map_object'] == obj]
                departures.append(dict(object=obj, position=positions[0] if positions else None))

        for name, callback in (('Script_applymovement', applying_movement), ('Script_disappear', disappearing)):
            bank, pointer = h.sym[name]
            pb.hook_register(bank, pointer, callback, None)
        original_tick = h.tick

        def track_tick(n=1):
            for _ in range(n):
                original_tick(1)
                if escape_paths:
                    for path in escape_paths:
                        for obj in c.objects():
                            if obj['map_object'] == path['object'] and (not path['positions'] or obj['position'] != path['positions'][-1]):
                                path['positions'].append(obj['position'])
        h.tick = track_tick

        def starting_battle(_):
            battles.append(dict(trainer=m.read('wOtherTrainerID'),
                                hp=m.read_u16_be('wPartyMon1HP'),
                                pp=list(m.read_bytes('wPartyMon1PP', 4))))
            if lose_at[0] == len(battles):
                m.write('wPartyMon1Level', 1)
                for stat in ('HP', 'Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef'):
                    m.write_bytes('wPartyMon1' + stat, bytes([0, 1]))
        bank, pointer = h.sym['Script_startbattle']
        pb.hook_register(bank, pointer, starting_battle, None)

        def restore(money=5000, loss=None):
            baseline.seek(0)
            pb.load_state(baseline)
            battles.clear()
            escape_paths.clear()
            departures.clear()
            lose_at[0] = loss
            m.write_bytes('wMoney', money.to_bytes(3, 'big'))

        def enter_gate(direction):
            group, number = maps['ROUTE_43']
            m.write('wMapGroup', group)
            m.write('wMapNumber', number)
            m.write('wXCoord', 17)
            m.write('wYCoord', 36 if direction == 'north' else 30)
            m.write('hMapEntryMethod', 0xF1)
            begin_native_call(h, 'OverworldLoop')
            h.tick(180)
            c.press('up' if direction == 'north' else 'down', hold=12, wait=140)
            for _ in range(3):
                if c.map_id() == maps['ROUTE_43_GATE']:
                    break
                c.press('up' if direction == 'north' else 'down', hold=12, wait=100)
            assert c.map_id() == maps['ROUTE_43_GATE'], (direction, c.map_id(), c.position())

        def prompt():
            for _ in range(30):
                text = tile_text(h)
                if 'YES' in text and 'NO' in text:
                    return
                c.press('a', hold=4, wait=40)
            raise AssertionError('No Yes/No toll prompt: ' + tile_text(h))

        def finish(limit=1200):
            for _ in range(limit):
                if m.read('wBattleMode'):
                    c.battle()
                else:
                    if not m.read('wScriptRunning') and not m.read('wScriptMode'):
                        return
                    c.press('a', hold=4, wait=40)
            raise AssertionError('Gate script did not finish: ' + tile_text(h))

        for direction in ('north', 'south'):
            for money in (5000, 500):
                restore(money)
                enter_gate(direction)
                prompt()
                pb.screen.image.save(str(output / f'{direction}-prompt.png'))
                c.press('a', hold=4, wait=60)
                finish()
                remaining = int.from_bytes(m.read_bytes('wMoney', 3), 'big')
                assert remaining == max(0, money - 1000), (direction, remaining)
                assert not battles and not event('EVENT_ROUTE_43_GATE_ROCKETS')
                assert not escape_paths and not departures
                assert {o['map_object']: o['position'] for o in c.objects()} == {2: [2, 4], 3: [7, 4]}
                print(f'PASS {direction}: Yes pays {min(1000, money)}, no battles', flush=True)

            restore()
            enter_gate(direction)
            prompt()
            c.press('down', hold=4, wait=20)
            c.press('a', hold=4, wait=60)
            finish()
            assert [b['trainer'] for b in battles] == [17, 18], battles
            assert battles[1]['pp'][0] < battles[0]['pp'][0], battles
            assert event('EVENT_ROUTE_43_GATE_ROCKETS')
            assert not event('EVENT_CLEARED_ROCKET_HIDEOUT')
            assert not ({2, 3} & {o['map_object'] for o in c.objects()}), c.objects()
            assert int.from_bytes(m.read_bytes('wMoney', 3), 'big') >= 5000
            assert [p['object'] for p in escape_paths] == [2, 3], escape_paths
            for path, departure in zip(escape_paths, departures):
                x, y = path['positions'][0]
                assert path['positions'] == [[x, y - step] for step in range(7)], path
                assert departure == dict(object=path['object'], position=[x, y - 6]), departure
            print(f'PASS {direction}: each Rocket moves exactly six tiles straight up from confrontation, then disappears', flush=True)
            pb.screen.image.save(str(output / f'{direction}-rockets-gone.png'))
            print(f'PASS {direction}: No fights both Rockets consecutively, no toll, both run away', flush=True)
            enter_gate(direction)
            h.tick(180)
            assert 'gonna pay up' not in tile_text(h)
            assert len(battles) == 2 and not ({2, 3} & {o['map_object'] for o in c.objects()})
            print(f'PASS {direction}: re-entry stays free with Rockets gone', flush=True)

        for loss in (1, 2):
            restore(loss=loss)
            enter_gate('north')
            prompt()
            c.press('down', hold=4, wait=20)
            c.press('a', hold=4, wait=60)
            finish()
            assert len(battles) == loss, battles
            assert not event('EVENT_ROUTE_43_GATE_ROCKETS')
            print(f'PASS: losing fight {loss} does not clear the toll Rockets', flush=True)
        return 0
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())

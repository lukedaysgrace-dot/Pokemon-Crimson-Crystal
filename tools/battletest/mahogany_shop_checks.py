#!/usr/bin/env python3
"""Check hideout shop visibility, both menus, prices, and all ten purchases.

Uses a private native-cartridge New Game; player saves are never opened.
"""

import io
import re

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from runner import Harness
from save_menu_checks import begin_native_call
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


GEAR = ('EVIOLITE', 'ROCKY_HELMET', 'AIR_BALLOON', 'MUSCLE_BAND',
        'WISE_GLASSES', 'EXPERT_BELT', 'FLAME_ORB', 'TOXIC_ORB',
        'ASSAULT_VEST', 'LIFE_ORB')
EXPENSIVE = {'ROCKY_HELMET', 'ASSAULT_VEST', 'LIFE_ORB'}
SUPPLIES = ('RAGECANDYBAR', 'GREAT_BALL', 'SUPER_POTION', 'HYPER_POTION',
            'ANTIDOTE', 'PARLYZ_HEAL', 'SUPER_REPEL', 'REVIVE', 'FLOWER_MAIL')


def main():
    h = Harness(cartridge='native')
    pb, m = h.pb, h.battle.mem
    output = ROOT / '.tmpbuild/mahogany-shop'
    output.mkdir(parents=True, exist_ok=True)
    try:
        new_game(h, 0)
        flags = _parse_constants(ROOT / 'constants/event_flags.asm')

        def event(name, value):
            flag = flags[name]
            old = m.read('wEventFlags', flag // 8)
            mask = 1 << (flag % 8)
            m.write('wEventFlags', old | mask if value else old & ~mask, flag // 8)

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
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wOptions', 0x41)
        m.write('wDefaultSpawnpoint', 255)
        c = Controls(h)

        def enter(name, x, y):
            group, number = maps[name]
            m.write('wMapGroup', group)
            m.write('wMapNumber', number)
            m.write('wXCoord', x)
            m.write('wYCoord', y)
            m.write('hMapEntryMethod', 0xF1)
            begin_native_call(h, 'OverworldLoop')
            h.tick(180)
            assert c.map_id() == (group, number)

        def stock_menu():
            for _ in range(10):
                text = tile_text(h)
                if all(label in text for label in ('SUPPLIES', 'HELD ITEMS', 'CANCEL')):
                    return
                c.press('a', hold=4, wait=50)
            raise AssertionError('Grandma stock selector did not open: ' + tile_text(h))

        event('EVENT_BEAT_PRYCE', False)
        event('EVENT_TEAM_ROCKET_BASE_POPULATION', False)
        event('EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE', True)
        event('EVENT_CLEARED_ROCKET_HIDEOUT', False)
        enter('MAHOGANY_MART_1F', 1, 4)
        assert {o['map_object'] for o in c.objects()} == {1, 2}
        print('PASS: original shopkeepers before clearing hideout', flush=True)

        event('EVENT_CLEARED_ROCKET_HIDEOUT', True)
        event('EVENT_MAHOGANY_MART_OWNERS', True)  # old save still hiding grandma
        enter('MAHOGANY_MART_1F', 1, 4)
        assert {o['map_object'] for o in c.objects()} == {5}, c.objects()
        flag = flags['EVENT_TEAM_ROCKET_BASE_POPULATION']
        assert not m.read('wEventFlags', flag // 8) & (1 << (flag % 8))
        print('PASS: grandma appears on old saves with Pryce unbeaten', flush=True)
        c.press('up', hold=4, wait=24)
        c.press('a', hold=4, wait=90)
        stock_menu()
        pb.screen.image.save(str(output / 'selector.png'))
        selector = io.BytesIO()
        pb.save_state(selector)
        c.press('down', hold=4, wait=20)
        c.press('a', hold=4, wait=80)
        expected = bytes([10, *(h.con.items[name] for name in GEAR), 255])
        assert m.read_bytes('wCurMart', len(expected)) == expected
        for index, item in enumerate(GEAR, 1):
            bcd = m.read_bytes(f'wMartItem{index}BCD', 3).hex()
            assert int(bcd) == (30000 if item in EXPENSIVE else 20000), (item, bcd)
        pb.screen.image.save(str(output / 'held-items.png'))
        m.write_bytes('wMoney', (999999).to_bytes(3, 'big'))
        gear_menu = io.BytesIO()
        pb.save_state(gear_menu)
        for index, item in enumerate(GEAR):
            gear_menu.seek(0)
            pb.load_state(gear_menu)
            for _ in range(index):
                c.press('down', hold=4, wait=36)
            # Long item names can push confirmation text onto another page.
            # Advance the native prompts until the first purchase completes.
            for _ in range(10):
                if int.from_bytes(m.read_bytes('wMoney', 3), 'big') != 999999:
                    break
                c.press('a', hold=4, wait=90)
            price = 30000 if item in EXPENSIVE else 20000
            assert int.from_bytes(m.read_bytes('wMoney', 3), 'big') == 999999 - price, (item, m.read_bytes('wMoney', 3), tile_text(h))
            assert m.read_bytes('wNumItems', 4) == bytes([1, h.con.items[item], 1, 255]), item
            print(f'PASS: purchase {item} for {price}', flush=True)

        gear_menu.seek(0)
        pb.load_state(gear_menu)
        c.press('b', hold=4, wait=80)
        stock_menu()
        print('PASS: leaving held-item shop returns to stock selector', flush=True)

        selector.seek(0)
        pb.load_state(selector)
        c.press('a', hold=4, wait=80)
        for _ in range(10):
            if 'BUY' in tile_text(h) and 'SELL' in tile_text(h):
                break
            c.press('a', hold=4, wait=50)
        assert 'BUY' in tile_text(h) and 'SELL' in tile_text(h), tile_text(h)
        c.press('a', hold=4, wait=80)
        expected = bytes([9, *(h.con.items[name] for name in SUPPLIES), 255])
        assert m.read_bytes('wCurMart', len(expected)) == expected, (m.read_bytes('wCurMart', len(expected)), tile_text(h))
        pb.screen.image.save(str(output / 'supplies.png'))
        print('PASS: all nine original supplies remain available', flush=True)
        c.press('b', hold=4, wait=80)
        c.press('b', hold=4, wait=80)
        stock_menu()
        print('PASS: leaving supplies shop returns to stock selector', flush=True)

        selector.seek(0)
        pb.load_state(selector)
        c.press('b', hold=4, wait=80)
        assert 'SUPPLIES' not in tile_text(h)
        assert c.position() == (1, 4)
        print('PASS: cancel returns to overworld', flush=True)

        event('EVENT_MAHOGANY_MART_ROCKETS', False)
        event('EVENT_GOLDENROD_DEPT_STORE_ROOF_GRANNY', False)
        enter('GOLDENROD_DEPT_STORE_ROOF', 4, 2)
        assert all(o['map_object'] < 9 for o in c.objects())
        assert all(o['position'] not in ([4, 0], [5, 0]) for o in c.objects())
        pb.screen.image.save(str(output / 'rooftop.png'))
        print('PASS: both rooftop sellers removed even with old visibility flags', flush=True)
        return 0
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())

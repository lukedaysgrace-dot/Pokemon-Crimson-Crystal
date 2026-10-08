#!/usr/bin/env python3
"""Compiled bag/PC item transfers at stack and capacity boundaries.

Uses private in-memory SRAM. Tests item IDs 1-254 through the native pocket
dispatcher, plus the PC pocket, with byte guards around each pocket. The
fixtures intentionally fill pockets; they do not claim campaign availability.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants

ROOT = Path(ROOT)


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    limits = {name: int(value) for name, value in re.findall(
        r'^(MAX_\w+)\s+EQU\s+(\d+)',
        (ROOT / 'constants/item_data_constants.asm').read_text(), re.MULTILINE)}
    checks, failures = 0, []

    def check(condition, label):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(label)
            if len(failures) <= 30:
                print('FAIL:', label, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    items = {}
    for item in range(1, 255):
        write('wCurItem', item)
        h.call('CheckItemPocket')
        items[item] = h.rd(h.s('wItemAttributeParamBuffer'))

    def action(routine, item, quantity=1, pocket='wNumItems', slot=255):
        write('wCurItem', item)
        write('wItemQuantityChangeBuffer', quantity)
        write('wCurItemQuantity', slot)
        return h.call(routine, hl=h.s(pocket))['c_flag']

    def seed(pocket, capacity, rows, key=False, guards=True):
        width = 1 if key else 2
        span = width * capacity + 2  # count, entries, terminator
        h.wr(h.s(pocket), [0xCC] * span)
        if guards:
            h.wr(h.s(pocket) - 1, 0xA5)
            h.wr(h.s(pocket) + span, 0x5A)
        payload = [len(rows)]
        for row in rows:
            payload.extend([row] if key else row)
        h.wr(h.s(pocket), payload + [255])
        return span

    def verify(pocket, span, rows, label, key=False):
        expected = [len(rows)]
        for row in rows:
            expected.extend([row] if key else row)
        expected.append(255)
        check(h.rd(h.s(pocket), len(expected)) == bytes(expected), label + ': count/entries/terminator')
        check(h.rd(h.s(pocket) - 1) == 0xA5 and h.rd(h.s(pocket) + span) == 0x5A, label + ': adjacent bytes')

    def stack_checks(item, pocket, capacity):
        label = f'{pocket}: {con.items_by_id.get(item, item)}'
        filler = next(i for i in items if i != item and (pocket == 'wNumPCItems' or items[i] == items[item]))
        for rows, quantity, expected in (
            ([], 1, [(item, 1)]),
            ([(item, 98)], 1, [(item, 99)]),
            ([(item, 99)], 1, [(item, 99), (item, 1)]),
            ([(filler, 99)] * (capacity - 1), 99, [(filler, 99)] * (capacity - 1) + [(item, 99)]),
            ([(item, 98)] + [(filler, 99)] * (capacity - 1), 1, [(item, 99)] + [(filler, 99)] * (capacity - 1)),
            ([(item, 98), (item, 98)] + [(filler, 99)] * (capacity - 2), 2, [(item, 99), (item, 99)] + [(filler, 99)] * (capacity - 2)),
        ):
            span = seed(pocket, capacity, rows)
            check(action('_ReceiveItem', item, quantity, pocket), label + ': valid receive failed')
            verify(pocket, span, expected, label)
            check(action('_CheckItem', item, pocket=pocket), label + ': received item missing')

        for rows, quantity in (
            ([(filler, 99)] * capacity, 1),
            ([(item, 99)] + [(filler, 99)] * (capacity - 1), 1),
            ([(item, 98)] + [(filler, 99)] * (capacity - 1), 2),
            ([(item, 98), (item, 98)] + [(filler, 99)] * (capacity - 2), 3),
        ):
            span = seed(pocket, capacity, rows)
            before = h.rd(h.s(pocket) - 1, span + 2)
            check(not action('_ReceiveItem', item, quantity, pocket), label + ': over-capacity receive accepted')
            check(h.rd(h.s(pocket) - 1, span + 2) == before, label + ': failed receive mutated pocket')

        for slot in (0, capacity // 2, capacity - 1):
            rows = [(filler, 99)] * capacity
            rows[slot] = (item, 2)
            span = seed(pocket, capacity, rows)
            check(action('_TossItem', item, 1, pocket, slot), label + ': partial toss failed')
            rows[slot] = (item, 1)
            verify(pocket, span, rows, label + ': partial toss')
            before = h.rd(h.s(pocket) - 1, span + 2)
            check(not action('_TossItem', item, 2, pocket, slot), label + ': excess toss accepted')
            check(h.rd(h.s(pocket) - 1, span + 2) == before, label + ': failed toss mutated pocket')
            check(action('_TossItem', item, 1, pocket, slot), label + ': final toss failed')
            rows.pop(slot)
            verify(pocket, span, rows, label + ': removal compaction')
            check(not action('_CheckItem', item, pocket=pocket), label + ': removed item remains')

    print('[native bag dispatch: every item ID, all four pockets]', flush=True)
    for item, kind in items.items():
        if kind in (1, 3):
            stack_checks(item, 'wNumItems' if kind == 1 else 'wNumBalls', limits['MAX_ITEMS' if kind == 1 else 'MAX_BALLS'])
        elif kind == 2:
            pocket, capacity = 'wNumKeyItems', limits['MAX_KEY_ITEMS']
            others = [i for i in items if items[i] == 2 and i != item]
            for count in (0, capacity - 1):
                rows = others[:count]
                span = seed(pocket, capacity, rows, key=True)
                check(action('_ReceiveItem', item), f'key {item}: receive')
                verify(pocket, span, rows + [item], f'key {item}', key=True)
                check(action('_CheckItem', item), f'key {item}: check')
                check(action('_TossItem', item), f'key {item}: script removal')
                verify(pocket, span, rows, f'key {item}: removal', key=True)
            span = seed(pocket, capacity, others + [item], key=True)
            before = h.rd(h.s(pocket) - 1, span + 2)
            check(not action('_ReceiveItem', item), f'key {item}: full pocket accepted')
            check(h.rd(h.s(pocket) - 1, span + 2) == before, f'key {item}: failure changed pocket')
        elif kind == 4:
            offset = item - min(i for i in items if items[i] == 4)
            size = h.s('wTMsHMsEnd') - h.s('wTMsHMs')
            for initial, quantity in ((0, 1), (98, 1), (98, 2), (99, 1)):
                write('wTMsHMs', bytes(size))
                h.wr(h.s('wTMsHMs') + offset, initial)
                before = h.rd(h.s('wTMsHMs'), size)
                expected = initial + quantity <= 99
                check(action('_ReceiveItem', item, quantity) == expected, f'TM/HM {item}: stack cap')
                after = bytearray(before)
                if expected:
                    after[offset] += quantity
                check(h.rd(h.s('wTMsHMs'), size) == bytes(after), f'TM/HM {item}: receive isolation')
            for initial, quantity in ((99, 98), (1, 1), (1, 2)):
                write('wTMsHMs', bytes(size))
                write('wTMHMPocketScrollPosition', 0)
                h.wr(h.s('wTMsHMs') + offset, initial)
                expected = initial >= quantity
                check(action('_TossItem', item, quantity) == expected, f'TM/HM {item}: toss bounds')
                actual = h.rd(h.s('wTMsHMs') + offset)
                check(actual == (initial - quantity if expected else initial), f'TM/HM {item}: toss quantity')
                check(action('_CheckItem', item) == bool(actual), f'TM/HM {item}: check after toss')
        else:
            check(False, f'item {item}: invalid pocket {kind}')

    print('[PC pocket: every item ID, stack/capacity/removal boundaries]', flush=True)
    for item in items:
        stack_checks(item, 'wNumPCItems', limits['MAX_PC_ITEMS'])

    print('[native Save/load: all pocket formats]', flush=True)
    start, end = h.s('wTMsHMs'), h.s('wPCItemsEnd')
    h.wr(start, bytes(end - start))
    for pocket, capacity, kind in (('wNumItems', limits['MAX_ITEMS'], 1), ('wNumBalls', limits['MAX_BALLS'], 3), ('wNumPCItems', limits['MAX_PC_ITEMS'], 1)):
        choices = [i for i in items if items[i] == kind]
        rows = [(choices[i % len(choices)], 99 if i % 2 else 1) for i in range(capacity)]
        seed(pocket, capacity, rows, guards=False)
    keys = [i for i in items if items[i] == 2]
    write('wNumKeyItems', len(keys))
    write('wKeyItems', keys + [255])
    size = h.s('wTMsHMsEnd') - start
    write('wTMsHMs', [99 if i % 2 else 1 for i in range(size)])
    expected = h.rd(start, end - start)
    write('wPartyCount', 0)
    write('wPartySpecies', [255])
    write('wCurBox', 0)
    h.call('InitializeBoxes')
    h.call('ClearBackupBoxes')
    write('wSavedAtLeastOnce', 1)
    h.call('SaveGameData', max_frames=600)
    h.wr(start, bytes(end - start))
    check(not h.call('TryLoadSaveFile', max_frames=600)['c_flag'], 'inventory Save/load failed')
    check(h.rd(start, end - start) == expected, 'inventory Save/load changed pocket bytes')
    h.pyboy.stop(save=False)
    print(f'INVENTORY BOUNDARIES: {len(items)} item IDs; {checks} checks; {len(failures)} failures', flush=True)
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())

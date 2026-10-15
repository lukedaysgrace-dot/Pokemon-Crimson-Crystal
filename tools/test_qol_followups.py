#!/usr/bin/env python3
"""Compiled reminder, Repel, and repeat-item tests, using private emulator RAM."""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, enc, dec
from battletest.symbols import Constants
from audit_learnset_variety import load_sources
from generate_pre_evolutions import generate
from test_overworld_state import patches

ROOT = Path(__file__).resolve().parents[1]


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    assert (ROOT / 'data/pokemon/pre_evolutions.asm').read_text() == generate()
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def bag(rows):
        write('wNumItems', [len(rows)] + [v for item, qty in rows for v in (con.item_id(item), qty)] + [255])
        write('wCurItemQuantity', 255)

    def party(species='MEW', level=50, known=('TACKLE',)):
        info = h.build_temp_mon(con.species_index(species), [con.move_index(m) for m in known] + [0] * (4 - len(known)),
                                level=level, happiness=100, statexp=[0] * 10)
        write('wPartyCount', 1)
        write('wPartySpecies', [info['sid'], 255])
        write('wPartyMon1', h.rd(h.s('wTempMon'), 50))
        write('wPartyMonNicknames', enc('TESTMON@@@@'))
        write('wCurPartyMon', 0)
        write('wPartyMenuCursor', 1)
        write('wCurPartySpecies', info['sid'])
        write('wBattleMode', 0)
        write('wLinkMode', 0)
        return info

    try:
        print('[Repel: every availability combination and saved preference]', flush=True)
        repels = ['REPEL', 'SUPER_REPEL', 'MAX_REPEL']
        duration = dict(zip(repels, [100, 200, 250]))
        for quantities in product((0, 1, 99), repeat=3):
            for previous in repels + ['POTION']:
                rows = [('POTION', 7)] + [(item, qty) for item, qty in zip(repels, quantities) if qty]
                bag(rows)
                previous_id = con.item_id(previous)
                write('wLastRepelUsed', previous_id)
                write('wRepelEffect', 0)
                before = h.rd(h.s('wNumItems'), 82)
                h.call('RepelWoreOffScript.CheckForAnotherRepel')
                available = dict(zip(repels, quantities))
                expected = previous if available.get(previous) else next((r for r in reversed(repels) if available[r]), None)
                check(bool(read('wScriptVar')) == bool(expected), f'Repel offer {quantities}/{previous}')
                check(read('wLastRepelUsed') == previous_id and h.rd(h.s('wNumItems'), 82) == before,
                      'offering/declining a Repel changed the bag or preference')
                if expected:
                    check(read('wCurItem') == con.item_id(expected), 'wrong replacement Repel')
                    check(h.rd(h.s('wStringBuffer4'), 2) == bytes([0, available[expected]]), 'wrong offered count')
                    check(dec(h.rd(h.s('wStringBuffer3'), 18)).split('@')[0] == expected.replace('_', ' '), 'wrong offered name')
                    h.call('RepelWoreOffScript.UseAnotherRepel')
                    check(read('wRepelEffect') == duration[expected], 'wrong renewal duration')
                    check(read('wLastRepelUsed') == con.item_id(expected), 'replacement not remembered')
                    result = h.call('GetBagItemQuantity')
                    check(result['bc'] == available[expected] - 1, 'renewal did not consume exactly one')
        bag([('REPEL', 99), ('POTION', 3), ('REPEL', 1)])
        write('wLastRepelUsed', con.item_id('REPEL'))
        h.call('RepelWoreOffScript.CheckForAnotherRepel')
        check(h.rd(h.s('wStringBuffer4'), 2) == bytes([0, 100]), 'Repel count omitted another stack')

        print('[reminder: all species, actual ancestors, level limits and known moves]', flush=True)
        order, levels, _, _, parents, _ = load_sources()

        def expected_moves(species, level, known=()):
            moves = []
            while True:
                for learned, move in levels[species]:
                    if learned <= level and move not in moves and move not in known:
                        moves.append(move)
                if not parents[species]:
                    return moves
                species = parents[species][0]

        for species in order:
            for level in (1, 10, 30, 50, 100):
                sid = h.species_id(con.species_index(species))
                write('wPartyCount', 1)
                write('wPartySpecies', [sid, 255])
                write('wCurPartyMon', 0)
                write('wPartyMon1Species', sid)
                write('wPartyMon1Level', level)
                write('wPartyMon1Moves', [0] * 4)
                # Guard the first byte after the reminder's scratch area.
                write('wBattleMenuCursorBuffer', 0xA5)
                result = h.call('MoveReminder_GetRemindableMoves')
                count = read('wMoveReminderMoveList')
                data = h.rd(h.s('wMoveReminderMoveList') + 1, 2 * count + 2)
                actual = [con.moves_by_index[data[i] << 8 | data[i + 1]] for i in range(0, 2 * count, 2)]
                expected = expected_moves(species, level)
                check(actual == expected, f'{species} level {level}: reminder list mismatch: {actual} != {expected}')
                check(data[-2:] == bytes([255, 0]) and read('wBattleMenuCursorBuffer') == 0xA5, 'reminder list overflow')
                check(result['z'] == (not expected) and read('wCurPartySpecies') == sid, 'reminder changed selected species or empty flag')
            # Exclude four known moves using actual 16-bit -> transient-ID conversion.
            known = expected_moves(species, 50)[:4]
            sid = h.species_id(con.species_index(species))
            write('wPartyMon1Species', sid)
            write('wPartyMon1Level', 50)
            write('wPartyMon1Moves', [0] * 4)
            # Pin each transient ID in the party before allocating another.
            # The eviction table can otherwise recycle an earlier fixture ID.
            for slot, move in enumerate(known):
                h.wr(h.s('wPartyMon1Moves') + slot, h.move_id(con.move_index(move)))
            h.call('MoveReminder_GetRemindableMoves')
            count = read('wMoveReminderMoveList')
            data = h.rd(h.s('wMoveReminderMoveList') + 1, 2 * count + 2)
            actual = [con.moves_by_index[data[i] << 8 | data[i + 1]] for i in range(0, 2 * count, 2)]
            check(actual == expected_moves(species, 50, known), f'{species}: known={known}, actual={actual}, expected={expected_moves(species, 50, known)}')

        print('[consumables: effect whitelist, stack totals, real repeated healing and cancellation]', flush=True)
        party()
        eligible = ['HP_UP', 'PROTEIN', 'IRON', 'CARBOS', 'CALCIUM', 'RARE_CANDY', 'PP_UP', 'ETHER',
                    'MAX_ETHER', 'ELIXER', 'MAX_ELIXER', 'MYSTERYBERRY', 'POTION', 'FULL_RESTORE',
                    'FULL_HEAL', 'ANTIDOTE', 'REVIVE', 'MAX_REVIVE', 'ENERGYPOWDER', 'ENERGY_ROOT',
                    'HEAL_POWDER', 'REVIVAL_HERB', 'BERRY', 'GOLD_BERRY']
        for item in eligible + ['FIRE_STONE', 'ABILITY_CAP', 'REPEL', 'POKE_BALL']:
            bag([(item, 2)])
            write('wCurItem', con.item_id(item))
            result = h.call('GetRepeatableConsumableQuantity')
            check(result['c_flag'] == (item in eligible), f'{item}: repeat eligibility')
            if item in eligible:
                check(result['bc'] == 2, f'{item}: quantity')
        bag([('POTION', 99)] * 40)
        write('wCurItem', con.item_id('POTION'))
        check(h.call('GetRepeatableConsumableQuantity')['bc'] == 3960, 'quantity overflow over 255')
        write('wBattleMode', 1)
        check(not h.call('GetRepeatableConsumableQuantity')['c_flag'], 'battle allowed repeated consumables')
        write('wBattleMode', 0)
        # Only presentation and target-picking are substituted: healing,
        # inventory removal, no-effect checks and wrapper logic remain native.
        presentation = {name: [0xC9] for name in ['PrintText', 'ItemActionTextWaitButton', 'HealHP_SFX_GFX', 'ClearPalettes']}
        presentation['UseItem_SelectMon'] = [0xAF, 0xC9]
        for rows, hp, expected_hp, remaining in [([('POTION', 3)], 1, 61, 0),
                                                ([('POTION', 1), ('ANTIDOTE', 7), ('POTION', 2)], 1, 61, 0),
                                                ([('POTION', 4)], 180, 200, 3),
                                                ([('POTION', 4)], 200, 200, 4),
                                                ([('POTION', 4)], 0, 0, 4)]:
            party()
            write('wPartyMon1HP', [hp >> 8, hp & 255])
            write('wPartyMon1MaxHP', [0, 200])
            bag(rows)
            write('wCurItem', con.item_id('POTION'))
            with patches(h, presentation):
                h.call('UsePartyItemRepeatedly')
            check(h.rd(h.s('wPartyMon1HP'), 2) == bytes([expected_hp >> 8, expected_hp & 255]), 'repeated healing amount')
            check(h.call('GetBagItemQuantity')['bc'] == remaining, 'repeat consumed wrong quantity')
        party()
        bag([('POTION', 3)])
        write('wCurItem', con.item_id('POTION'))
        with patches(h, {'UseItem_SelectMon': [0x37, 0xC9], 'ClearPalettes': [0xC9]}):
            h.call('UsePartyItemRepeatedly')
        check(h.call('GetBagItemQuantity')['bc'] == 3, 'cancel consumed an item')
        print(f'FOLLOWUP QOL ROM TESTS PASSED: {checks} checks, {h.calls} calls.', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

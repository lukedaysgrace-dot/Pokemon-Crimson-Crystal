#!/usr/bin/env python3
"""Native retired-item/save cleanup and full-roster wild held-item checks.

Only private emulator SRAM is used. Does not open the player's save.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT, SENTINEL, enc
from battletest.symbols import Constants

REMOVED = {'BRIGHTPOWDER': 0x003, 'HEAVY_DUTY_BOOTS': 0x120,
           'RED_CARD': 0x121, 'EJECT_BUTTON': 0x122, 'BLACK_SLUDGE': 0x125,
           'BLUNDER_POLICY': 0x12c, 'CUSTAP_BERRY': 0x12e, 'SALAC_BERRY': 0x12f}


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def index(item):
        return h.call('GetItemIndexFromID', a=item)['hl']

    def rows(pocket, values):
        write(pocket, [len(values)] + [v for item, qty in values
                                      for v in (item >> 8, item & 255, qty)] + [255])

    def old_runtime(item, tag=220):
        h.mem[0xff70] = 2
        h.wr(h.s('wItemIndexTableEntries') + 2 * (tag - 1), item.to_bytes(2, 'little'))
        h.mem[0xff70] = 1
        return tag

    try:
        h.call('InitializeItemIndexTable')
        for name, value in REMOVED.items():
            check(name not in con.items and con.items['RETIRED_' + name] == value,
                  name + ': saved index changed or active constant remains')
            result = h.call('NormalizeRetiredBerryIndex', hl=value, bc=0x1234, de=0x5678)
            check(result['hl'] == 0 and result['bc'] == 0x1234 and result['de'] == 0x5678,
                  name + ': canonicalization or register preservation')
            check(h.call('GetItemIDFromIndex', hl=value)['a'] == 0, name + ': creates runtime item')
            check(index(old_runtime(value)) == 0, name + ': old held index remains active')
        # Adjacent live IDs must retain their identity.
        for name, value in con.items.items():
            if name == 'NO_ITEM' or name.startswith('RETIRED_'):
                continue
            check(h.call('NormalizeRetiredBerryIndex', hl=value)['hl'] == value,
                  name + ': unrelated saved index changed')

        potion, powder = con.item_id('POTION'), con.item_id('QUICK_POWDER')
        cases = [[], [(v, 1 + n) for n, v in enumerate(REMOVED.values())],
                 [(potion, 99), (0x003, 2), (powder, 7), (0x12f, 99), (potion, 3)],
                 [(0x12d, 7), (potion, 2)]]
        for capacity, pocket in ((40, 'wNumItems'), (50, 'wNumPCItems')):
            for values in cases + [[(0x120 if n % 2 else potion, n % 99 + 1)
                                    for n in range(capacity)]]:
                rows(pocket, values)
                expected = [(con.item_id('GOLD_BERRY') if item == 0x12d else item, qty)
                            for item, qty in values if item not in REMOVED.values()]
                h.call('NormalizeRetiredBerryInventories')
                encoded = bytes([len(expected)] + [v for item, qty in expected
                                for v in (item >> 8, item & 255, qty)] + [255])
                check(h.rd(h.s(pocket), len(encoded)) == encoded, pocket + ': compaction or quantity changed')
                h.call('NormalizeRetiredBerryInventories')
                check(h.rd(h.s(pocket), len(encoded)) == encoded, pocket + ': cleanup is not idempotent')

        held = ['wPartyMon' + str(n) + 'Item' for n in range(1, 7)] + ['wBreedMon1Item', 'wBreedMon2Item']
        for offset, (field, value) in enumerate(zip(held, REMOVED.values())):
            write(field, old_runtime(value, 220 + offset))
        h.call('NormalizeLoadedRetiredItems')
        check(all(h.rd(h.s(field)) == 0 for field in held), 'party/daycare items not cleared')

        # Compare the native GetBaseData result for every slot with the authored
        # item indexes; this catches byte truncation of expanded held items.
        includes = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^"]+)"',
                              (Path(ROOT) / 'data/pokemon/base_stats.asm').read_text())
        for species, path in zip(con.species, includes):
            text = (Path(ROOT) / path).read_text()
            item_tokens = re.search(r'^\s*db\s+(.+?)\s*; items', text, re.M)[1].split(',')
            expected = [con.item_id(re.sub(r'^LOW\((\w+)\)$', r'\1', item.strip())) for item in item_tokens]
            sid = h.species_id(con.species_index(species))
            write('wCurSpecies', sid)
            h.call('GetBaseData')
            check([index(h.rd(h.s('wBaseItem1'))), index(h.rd(h.s('wBaseItem2')))] == expected,
                  species + ': native held items do not match source')
            if any(item in (con.item_id('METAL_POWDER'), powder) for item in expected):
                check(species == 'DITTO', species + ': extra powder source')

        # Execute the real wild-item selection branch, controlling its two RNG
        # calls independently and observing the selected runtime item at update.
        write('wCurSpecies', h.species_id(con.species_index('DITTO')))
        h.call('GetBaseData')
        write('wBattleType', 0)
        rolls, selected = [], []

        def random_hook(_):
            check(bool(rolls), 'unexpected RNG call')
            h.reg.A = rolls.pop(0)
            sp = h.reg.SP
            h.reg.PC = h.rd16(sp)
            h.reg.SP = sp + 2

        def selected_hook(_):
            selected.append(h.reg.A)
            h.reg.PC = SENTINEL

        h.pyboy.hook_register(*h.sym['BattleRandom'], random_hook, None)
        h.pyboy.hook_register(*h.sym['LoadEnemyMon.UpdateItem'], selected_hook, None)
        try:
            for first in range(256):
                for second in (0, 50, 51, 255):
                    rolls[:] = [first, second]
                    selected.clear()
                    h.call('LoadEnemyMon.WildItem')
                    expected = 0 if first < 192 else powder if second < 51 else con.item_id('METAL_POWDER')
                    check(len(selected) == 1 and index(selected[0]) == expected,
                          f'wild Ditto roll {first}/{second}: {selected} != {expected}')
        finally:
            h.pyboy.hook_deregister(*h.sym['BattleRandom'])
            h.pyboy.hook_deregister(*h.sym['LoadEnemyMon.UpdateItem'])

        # Actual format-5 save ingress, including fallback to the backup copy.
        h.wr(h.s('wGameData'), bytes(h.s('wGameDataEnd') - h.s('wGameData')))
        h.call('InitializeItemIndexTable')
        h.call('InitializeBoxes')
        h.call('ClearBackupBoxes')
        sid = h.species_id(con.species_index('MEW'))
        write('wPartyCount', 6)
        write('wPartySpecies', [sid] * 6 + [255])
        for number in range(1, 7):
            write(f'wPartyMon{number}Species', sid)
        for offset, (field, value) in enumerate(zip(held, REMOVED.values())):
            write(field, old_runtime(value, 220 + offset))
        values = [(potion, 99)] + [(v, n + 1) for n, v in enumerate(REMOVED.values())] + [(powder, 7)]
        for pocket in ('wNumItems', 'wNumPCItems'):
            rows(pocket, values)
        write('wPlayerName', enc('PLAYER@@@@@'))
        write('wSavedAtLeastOnce', 1)
        h.call('SaveGameData', max_frames=600)
        for fallback in (False, True):
            if fallback:
                bank, address = h.sym['sCheckValue1']
                h.sram_wr(bank, address, 0)
            check(not h.call('TryLoadSaveFile', max_frames=600)['c_flag'], 'retired-item save rejected')
            for pocket in ('wNumItems', 'wNumPCItems'):
                expected = bytes([2, 0, potion, 99, powder >> 8, powder & 255, 7, 255])
                check(h.rd(h.s(pocket), 8) == expected, pocket + ': saved stack cleanup')
            check(all(h.rd(h.s(field)) == 0 for field in held), 'saved party/daycare cleanup')

        # Old boxed records must validate their original raw-item checksum before
        # decoding the retired index as NO_ITEM (rather than becoming Bad Eggs).
        h.build_temp_mon(con.species_index('MEW'), [1, 0, 0, 0])
        h.call('AddTempMonToStorage')
        pool, entry = h.box_pointer(1, 1)
        address = h.call('OpenPokeDB', de=(pool << 8) | entry)['hl']
        bank = h.rd(h.s('hSRAMBank'))
        record = bytearray(h.sram(bank, address, 57))
        high_bank, high_address = h.sym['sPokeDBItemHigh']
        high_address += (pool - 1) * 254 + entry - 1
        for value in REMOVED.values():
            record[2] = value & 255
            checksum = (0x7f + sum(v * (55 - n) for n, v in enumerate(record[:55]))
                        + (value >> 8) * 257) & 65535
            record[55:57] = checksum.to_bytes(2, 'little')
            h.sram_wr(bank, address, record)
            h.sram_wr(high_bank, high_address, value >> 8)
            check(not h.call('GetStorageBoxMon', bc=0x101)['c_flag'], 'retired boxed item rejected')
            check(h.rd(h.s('wTempMonItem')) == 0, 'retired boxed item not cleared')
        print(f'ITEM RETIREMENTS: {checks} native checks passed in {rom.name}')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

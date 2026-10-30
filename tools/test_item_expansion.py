#!/usr/bin/env python3
"""Compiled 16-bit item, legacy-save migration and PokeDB regressions.

Uses fresh private emulator SRAM, including corruption and backup cases.
Never opens the player's save file.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT, dec, enc
from battletest.symbols import Constants, _parse_constants


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    h.call('InitializeItemIndexTable')
    con = Constants()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, data):
        h.wr(h.s(name), data)

    def put(name, data):
        bank, address = h.sym[name]
        h.sram_wr(bank, address, data)

    def get(name, size=1):
        return h.sym_sram(name, size)

    def runtime(index):
        return h.call('GetItemIDFromIndex', hl=index)['a']

    def index(item):
        return h.call('GetItemIndexFromID', a=item)['hl']

    def entries(name, rows):
        write(name, [len(rows)] + [v for i, n in rows for v in (i >> 8, i & 255, n)] + [255])

    legacy = {name: int(value, 16) for name, value in re.findall(
        r'LEGACY_(\w+) EQU \$([0-9a-f]+)',
        (root / 'constants/legacy_item_save_constants.asm').read_text())}

    def old_offset(name):
        return legacy[name] - legacy['wPlayerData']

    def new_offset(name):
        return h.s(name) - h.s('wPlayerData')

    def stage(prefix, seed, bad=False, version=4):
        start = h.s(prefix + 'SaveData')
        size = h.s(prefix + 'SaveDataEnd') - start
        original = bytearray((i * 37 + seed) & 255 for i in range(size))
        # Distinguish adjacent item indexes and quantities, plus full pockets.
        for name, capacity in [('wItems', 40), ('wPCItems', 50)]:
            offset = old_offset(name)
            original[offset - 1] = capacity
            original[offset:offset + capacity * 2 + 1] = bytes(
                [v for i in range(capacity) for v in (1 + i * 3, 1 + i % 99)] + [255])
        # These are legal legacy held TMs, including the eight IDs that are
        # now fixed Mail tags. Boxed records still store true low-byte indices.
        pokemon_offset = h.s(prefix + 'PokemonData') - start
        for slot, item in enumerate((194, 201, 202, 231, 254, 0)):
            offset = pokemon_offset + h.s('wPartyMon1Item') - h.s('wPokemonData') + slot * (h.s('wPartyMon2') - h.s('wPartyMon1'))
            original[offset] = item
        for name, item in [('wBreedMon1Item', 195), ('wBreedMon2Item', 250)]:
            original[pokemon_offset + h.s(name) - h.s('wPokemonData')] = item
        moves_size = h.s('wMoveIndexTableEnd') - h.s('wMoveIndexTable')
        moves = bytes((i * 13 + seed) & 255 for i in range(moves_size))
        put(prefix + 'MoveIndexTable', moves)
        offset = h.s(prefix + 'ConversionTableChecksum') - start
        original[offset:offset + 2] = (sum(moves) & 65535).to_bytes(2, 'little')
        expected = bytes(original)
        if version == 3:
            caught_end = h.s(prefix + 'PokemonData') + h.s('wEndPokedexCaught') - h.s('wPokemonData') - start
            seen_end = h.s(prefix + 'PokemonData') + h.s('wEndPokedexSeen') - h.s('wPokemonData') - start
            original[caught_end - 1] = 0
            original[seen_end - 1] = 0
            expected = bytes(original)
            del original[seen_end - 1]
            del original[caught_end - 1]
        put(prefix + 'SaveData', original)
        put(prefix + 'Checksum', ((sum(original) + int(bad)) & 65535).to_bytes(2, 'little'))
        put(prefix + 'CheckValue1', 99)
        put(prefix + 'CheckValue2', 127)
        put(prefix + 'ItemIndexMagic', [0, 0])
        return expected

    print('[v3/v4 migration: inventory, progress, party, boxes and backup]', flush=True)
    in_progress = []
    def at_migration_copy(_):
        bank = h.rd(h.s('hSRAMBank'))
        name = 'sCheckValue1' if bank == h.sym['sCheckValue1'][0] else 'sBackupCheckValue1'
        in_progress.append(h.rd(h.s(name)))
    h.pyboy.hook_register(*h.sym['MoveItemSaveBack'], at_migration_copy, None)
    for version in (3, 4):
        for bad_main, bad_backup in ((False, False), (True, False), (False, True)):
            expected = {p: stage(p, seed, bad, version) for p, seed, bad in (
                ('s', 17, bad_main), ('sBackup', 83, bad_backup))}
            put('sSaveVersion', version)
            h.call('UpgradeItemSave', max_frames=600)
            check(get('sSaveVersion') == 5, 'save version did not advance')
            for prefix, bad in [('s', bad_main), ('sBackup', bad_backup)]:
                if bad:
                    check(get(prefix + 'CheckValue1') == 0, 'corrupt source accepted')
                    continue
                check(get(prefix + 'CheckValue1') == 99, f'{prefix} v{version}: valid source rejected')
                before = expected[prefix]
                after = get(prefix + 'SaveData', len(before))
                check(after[:old_offset('wItems') - 1] == before[:old_offset('wItems') - 1], 'pre-inventory progress changed')
                for name, capacity in [('wItems', 40), ('wPCItems', 50)]:
                    old, new = old_offset(name), new_offset(name)
                    check(after[new - 1] == capacity, name + ': count changed')
                    for slot in range(capacity):
                        check(after[new + slot * 3:new + slot * 3 + 3] ==
                              bytes([0]) + before[old + slot * 2:old + slot * 2 + 2],
                              f'{prefix} v{version} {name} slot {slot}: {after[new + slot * 3:new + slot * 3 + 3].hex()} != 00{before[old + slot * 2:old + slot * 2 + 2].hex()}')
                    check(after[new + capacity * 3] == 255, name + ': terminator lost')
                # Key/Ball pockets between the two word inventories.
                old_a, old_b = old_offset('wItems') + 81, old_offset('wPCItems')
                new_a, new_b = new_offset('wItems') + 121, new_offset('wPCItems')
                check(after[new_a:new_b] == before[old_a:old_b], 'Key/Ball pockets changed')
                for first, last in [('wPokegearFlags', 'wFinizenPosition'),
                                    ('wPokecenter2FSceneID', 'wOlivineFishingCoveGateSceneID')]:
                    length = legacy[last] - legacy[first] + 1
                    check(after[new_offset(first):new_offset(first) + length] ==
                          before[old_offset(first):old_offset(first) + length], first + ': progress changed')
                old, new = old_offset('wJackFightCount'), new_offset('wJackFightCount')
                length = h.s('wEventFlags') - h.s('wJackFightCount')
                check(after[new:new + length] == before[old:old + length], 'rematch/contest progress changed')
                # Everything after reclaimed padding includes event flags,
                # party, Pokedex, daycare, roamers and conversion tables.
                preserved = bytearray(before)
                pokemon_offset = h.s(prefix + 'PokemonData') - h.s(prefix + 'SaveData')
                held_offsets = [pokemon_offset + h.s('wPartyMon1Item') - h.s('wPokemonData') +
                                slot * (h.s('wPartyMon2') - h.s('wPartyMon1')) for slot in range(6)]
                held_offsets += [pokemon_offset + h.s(name) - h.s('wPokemonData')
                                 for name in ('wBreedMon1Item', 'wBreedMon2Item')]
                saved_table = get(prefix + 'ItemIndexTable', h.s('wItemIndexTableEnd') - h.s('wItemIndexTable'))
                for position in held_offsets:
                    item = after[position]
                    true_index = int.from_bytes(saved_table[item * 2:item * 2 + 2], 'little') if item else 0
                    check(true_index == before[position], 'legacy party/daycare held TM changed identity')
                    preserved[position] = item
                offset = new_offset('wEventFlags')
                check(after[offset:] == preserved[offset:], 'events/party/Dex/daycare/index tables changed')
                verify = 'VerifyChecksum' if prefix == 's' else 'VerifyBackupChecksum'
                check(h.call(verify)['z'], prefix + ': upgraded checksum rejected')
            snapshot = (get('sSaveData', len(expected['s'])), get('sBackupSaveData', len(expected['sBackup'])))
            h.call('UpgradeItemSave')
            check(snapshot == (get('sSaveData', len(expected['s'])), get('sBackupSaveData', len(expected['sBackup']))), 'upgrade ran twice')
    h.pyboy.hook_deregister(*h.sym['MoveItemSaveBack'])
    check(in_progress and not any(in_progress), 'partially upgraded copy retained a valid signature')
    stage('s', 17)
    stage('sBackup', 83)
    put('sSaveVersion', 4)
    put('sCheckValue1', 0)  # reset midway through the primary migration
    put('sSaveData', [0xCC] * 64)
    h.call('UpgradeItemSave', max_frames=600)
    check(get('sCheckValue1') == 0, 'interrupted primary was promoted to a valid save')
    check(h.call('VerifyBackupChecksum')['z'], 'interrupted primary prevented backup migration/recovery')

    # Clear staged garbage before testing live runtime roots.
    h.wr(h.s('wGameData'), bytes(h.s('wGameDataEnd') - h.s('wGameData')))
    h.call('InitializeItemIndexTable')
    write('wPartyCount', 0)
    write('wPartySpecies', 255)
    write('wPlayerName', enc('PLAYER@@@@@'))
    h.call('InitializeBoxes')
    h.call('ClearBackupBoxes')

    print('[restored/expanded names, attributes and runtime-ID collection]', flush=True)
    names = re.findall(r'\tdb "([^"@]+)@"', (root / 'data/items/names.asm').read_text())
    expanded = [(name, value) for name, value in con.items.items() if value >= 257]
    rom_bytes = rom.read_bytes()
    desc_bank, desc_address = h.sym['ItemDescriptions']
    check(len(expanded) == 28, 'expanded catalogue size')
    for name, value in expanded:
        item = runtime(value)
        check(item != 0 and index(item) == value, name + ': round-trip conversion')
        write('wNamedObjectIndexBuffer', item)
        h.call('GetItemName')
        check(dec(h.rd(h.s('wStringBuffer1'), 13)).split('@')[0] == names[value - 1], name + ': displayed name')
        pointer_offset = desc_bank * 0x4000 + desc_address - 0x4000 + 2 * (value - 1)
        check(int.from_bytes(rom_bytes[pointer_offset:pointer_offset + 2], 'little') ==
              h.s(name + 'Desc'), name + ': description pointer')
        write('wCurItem', item)
        h.call('CheckItemPocket')
        check(h.rd(h.s('wItemAttributeParamBuffer')) == 1, name + ': wrong pocket')
        is_mail = name.endswith('MAIL')
        check(h.call('StorageItemIsMail', a=item)['c_flag'] == is_mail, name + ': Mail classification')
        write('wPartyMon1Item', item)
        for candidate in range(194, 285):
            if candidate not in (255, 256):
                runtime(candidate)
        h.call('ForceGarbageCollection')
        check(index(h.rd(h.s('wPartyMon1Item'))) == value, name + ': held item evicted')
        write('wPartyMon1Item', 0)

    print('[four word-index marts: names, stock and BCD prices]', flush=True)
    for number in range(4):
        bank, address = h.sym['MartExpanded' + str(number)]
        write('wMartPointerBank', bank)
        h.wr16(h.s('wMartPointer'), address)
        write('wCurMart', bytes(16))
        h.call('FarReadMart')
        check(h.rd(h.s('wCurMart')) == 7, 'mart count')
        check([index(h.rd(h.s('wCurMart') + 1 + i)) for i in range(7)] ==
              list(range(257 + number * 7, 264 + number * 7)), 'mart stock indexes')

    print('[word-index bag sorting: same low byte, embedded $ff, stack merging]', flush=True)
    write('wMenuData_ScrollingMenuItemFormat', 3)
    h.wr16(h.s('wMenuData_ItemsPointerAddr'), h.s('wNumItems'))
    for rows, source, dest, expected in (
        ([(0x101, 2), (0x201, 3), (0x1ff, 4)], 0, 2, [(0x201, 3), (0x1ff, 4), (0x101, 2)]),
        ([(0x101, 2), (0x201, 3), (0x1ff, 4)], 2, 0, [(0x1ff, 4), (0x101, 2), (0x201, 3)]),
        ([(0x101, 2), (0x1ff, 4), (0x101, 3)], 0, 2, [(0x1ff, 4), (0x101, 5)]),
    ):
        entries('wNumItems', rows)
        write('wSwitchItem', source + 1)
        write('wScrollingMenuCursorPosition', dest)
        h.call('SwitchItemsInBag')
        count = h.rd(h.s('wNumItems'))
        raw = h.rd(h.s('wItems'), count * 3 + 1)
        check(raw == bytes([v for i, n in expected for v in (i >> 8, i & 255, n)] + [255]), 'sort/merge corrupted word rows')

    print('[boxed held indexes survive collection, snapshots and save/reload]', flush=True)
    for slot, name in enumerate(('TINYMUSHROOM', 'POLKADOT_BOW', 'NORMAL_BOX', 'LUM_BERRY'), 1):
        h.build_temp_mon(25, [1, 0, 0, 0], level=10, item=runtime(con.item_id(name)))
        h.call('AddTempMonToStorage')
    for candidate in range(194, 285):
        if candidate not in (255, 256):
            runtime(candidate)
    h.call('ForceGarbageCollection')
    for slot, name in enumerate(('TINYMUSHROOM', 'POLKADOT_BOW', 'NORMAL_BOX', 'LUM_BERRY'), 1):
        h.call('GetStorageBoxMon', bc=0x100 | slot)
        check(index(h.rd(h.s('wTempMonItem'))) == con.item_id(name), name + ': boxed item changed')
    entries('wNumItems', [(257, 99), (284, 1)])
    entries('wNumPCItems', [(258, 45), (283, 99)])
    party = h.build_temp_mon(25, [1, 0, 0, 0], level=10, item=runtime(con.item_id('LUM_BERRY')))
    write('wPartyCount', 1)
    write('wPartySpecies', [party['sid'], 255])
    write('wPartyMon1', h.rd(h.s('wTempMon'), h.s('wPartyMon2') - h.s('wPartyMon1')))
    write('wPartyMonNicknames', enc('TESTMON@@@@'))
    write('wSavedAtLeastOnce', 1)
    h.call('SaveGameData', max_frames=600)
    expected_bag = h.rd(h.s('wNumItems'), 8)
    write('wNumItems', [0, 255])
    write('wPartyMon1Item', 0)
    h.call('TryLoadSaveFile', max_frames=600)
    check(h.rd(h.s('wNumItems'), 8) == expected_bag, 'word bag did not survive save/load')
    check(index(h.rd(h.s('wPartyMon1Item'))) == con.item_id('LUM_BERRY'), 'expanded party held item did not survive save/load')
    # Sidecar corruption participates in each record's checksum.
    pool, entry = h.box_pointer(1, 1)
    high_bank, high_address = h.sym['sPokeDBItemHigh']
    address = high_address + (pool - 1) * 254 + entry - 1
    previous = h.sram(high_bank, address)
    h.sram_wr(high_bank, address, previous ^ 1)
    check(h.call('GetStorageBoxMon', bc=0x101)['c_flag'], 'corrupt boxed item high byte was accepted')
    h.sram_wr(high_bank, address, previous)

    print('[native Normal/Gorgeous Box effects: consume item and award trophy]', flush=True)
    events = _parse_constants(root / 'constants/event_flags.asm')
    pictures = root / '.tmpbuild/item16/ui' / rom.stem
    pictures.mkdir(parents=True, exist_ok=True)
    h.call('LoadStandardFont')
    h.call('LoadFontsExtra')
    for name, flag in [('NORMAL_BOX', 'EVENT_DECO_SILVER_TROPHY'),
                       ('GORGEOUS_BOX', 'EVENT_DECO_GOLD_TROPHY')]:
        bit = events[flag]
        flag_addr = h.s('wEventFlags') + bit // 8
        h.wr(flag_addr, h.rd(flag_addr) & ~(1 << (bit % 8)))
        value = con.item_id(name)
        entries('wNumItems', [(value, 1)])
        write('wCurItem', runtime(value))
        write('wCurItemQuantity', 0)
        write('wBattleMode', 0)
        write('wOptions', 1)
        write('wTextboxFlags', 1)
        write('wTextboxFrame', 0)
        bank, address = h.sym['DoItemEffect']
        if bank:
            h.set_rom_bank(bank)
        h.wr(0xC0EC, [0xF0, 0xC0])
        h.wr(0xC0F0, [0xF3, 0x18, 0xFE])
        h.wr(0xC0F6, [0xFB, 0xC3, address & 255, address >> 8])
        h.reg.SP, h.reg.PC = 0xC0EC, 0xC0F6
        for frame in range(1800):
            if frame % 16 == 0:
                h.pyboy.button('a', 2)
            h.pyboy.tick(1, True)
            if h.reg.PC in (0xC0F1, 0xC0F3):
                break
        else:
            h.pyboy.screen.image.save(pictures / (name.lower() + '-failure.png'))
            tiles = h.rd(h.s('wTileMap'), 360)
            text = '\n'.join(dec(tiles[i:i + 20]) for i in range(0, 360, 20))
            raise AssertionError(f'{name}: native effect did not finish: PC={h.reg.PC:04x}, bank={h.rd(h.s("hROMBank"))}, IE={h.rd(0xffff):02x}\n{text}')
        h.pyboy.screen.image.save(pictures / (name.lower() + '.png'))
        check(h.rd(h.s('wNumItems')) == 0, name + ': box was not consumed')
        check(h.rd(flag_addr) & (1 << (bit % 8)), name + ': trophy not awarded')

    print('[link item serialization with different runtime tables]', flush=True)
    receiver = Harness(str(rom), str(rom.with_suffix('.sym')))
    receiver.boot()
    receiver.call('InitializeItemIndexTable')
    for candidate in reversed(range(257, 285)):
        receiver.call('GetItemIDFromIndex', hl=candidate)
    held = ['TINYMUSHROOM', 'NORMAL_BOX', 'GORGEOUS_BOX', 'LUM_BERRY', 'PEARL_STRING', 'SURF_MAIL']
    stride = h.s('wPartyMon2') - h.s('wPartyMon1')
    for slot, name in enumerate(held):
        info = h.build_temp_mon(25, [1, 0, 0, 0], item=runtime(con.item_id(name)))
        write('wPartyMon' + str(slot + 1), h.rd(h.s('wTempMon'), stride))
    write('wPartyCount', 6)
    write('wPartySpecies', [info['sid']] * 6 + [255])
    h.call('Link_BuildIndexList', de=h.s('wOTPartyMons'))
    packet = h.rd(h.s('wOTPartyMons'), 81)
    receiver.wr(receiver.s('wStringBuffer1'), packet)
    receiver.wr(receiver.s('wOTPartySpecies'), [1] * 6 + [255])
    check(not receiver.call('Link_FixOTParty_Gen2')['c_flag'], 'link packet rejected')
    for slot, name in enumerate(held):
        item = receiver.rd(receiver.s('wOTPartyMon1Item') + stride * slot)
        check(receiver.call('GetItemIndexFromID', a=item)['hl'] == con.item_id(name), name + ': link held item changed')
    receiver.wr(receiver.s('wStringBuffer1'), bytes([packet[0] ^ 1]) + packet[1:])
    check(receiver.call('Link_FixOTParty_Gen2')['c_flag'], 'corrupt item packet accepted')
    receiver.pyboy.stop(save=False)

    print('[exhausted runtime table refuses allocation without hanging or corrupting inventory]', flush=True)
    h.call('InitializeItemIndexTable')
    roots = []
    def root(name, offset=0):
        bank, address = h.sym[name]
        location = (bank, address + offset)
        if location not in roots:
            roots.append(location)
    for offset in range(16):
        root('wItemIndexTableLockedEntries', offset)
    for name in ('wPartyMon1Item', 'wOTPartyMon1Item'):
        for slot in range(6):
            root(name, stride * slot)
    for name in ('wBreedMon1Item', 'wBreedMon2Item', 'wCurItem', 'wNamedObjectIndexBuffer',
                 'wMenuSelection', 'wPackUsedItem', 'wTempMonItem', 'wBufferMonItem',
                 'wBattleMonItem', 'wEnemyMonItem', 'wContestMonItem', 'wCurEnemyItem',
                 'wEnemyTrainerItem1', 'wEnemyTrainerItem2', 'wScriptVar', 'wMartItemID',
                 'wBillsPC_CursorItem'):
        root(name)
    for offset in range(14):
        root('wCurMart', offset + 1)
    check(len(roots) >= 53, 'not enough distinct root fixtures')
    table_bank, table_address = h.sym['wItemIndexTableEntries']
    for slot, (bank, address) in zip(range(202, 255), roots):
        h.mem[bank, address] = slot
        value = 0x200 + slot
        h.mem[table_bank, table_address + 2 * (slot - 1)] = value & 255
        h.mem[table_bank, table_address + 2 * (slot - 1) + 1] = value >> 8
    check(runtime(0x1234) == 0, 'saturated table did not refuse allocation')
    entries('wNumItems', [])
    write('wCurItem', 0)
    write('wItemQuantityChangeBuffer', 1)
    before = h.rd(h.s('wNumItems'), 122)
    check(not h.call('_ReceiveItem', hl=h.s('wNumItems'))['c_flag'], 'missing runtime ID accepted')
    check(h.rd(h.s('wNumItems'), 122) == before, 'refused allocation changed bag bytes')
    h.pyboy.stop(save=False)
    print(f'ITEM EXPANSION PASSED: {checks} checks in {rom.name}', flush=True)


if __name__ == '__main__':
    main()

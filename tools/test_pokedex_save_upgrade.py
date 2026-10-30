#!/usr/bin/env python3
"""Exercise the 496 -> 498 species save upgrade in private emulator SRAM."""
from pathlib import Path
import sys
from pc_harness import Harness, ROOT


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT)/'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def put(name, data):
        bank, address = h.sym[name]
        h.sram_wr(bank, address, data)

    def get(name, n=1):
        return h.sym_sram(name, n)

    def stage(prefix, seed, corrupt=False, corrupt_moves=False):
        start = h.s(prefix+'SaveData')
        size = h.s(prefix+'SaveDataEnd')-start-2
        original = bytearray((i*37+seed)&255 for i in range(size))
        moves_size = h.s('wMoveIndexTableEnd')-h.s('wMoveIndexTable')
        moves = bytes((i*13+seed)&255 for i in range(moves_size))
        put(prefix+'MoveIndexTable', moves)
        move_checksum = sum(moves)&65535
        offset = h.s(prefix+'ConversionTableChecksum')-start-2
        original[offset:offset+2] = move_checksum.to_bytes(2,'little')
        put(prefix+'SaveData', original)
        put(prefix+'Checksum', ((sum(original)+int(corrupt))&65535).to_bytes(2,'little'))
        # Constants are stable validation signatures, also checked by the native loader.
        put(prefix+'CheckValue1', 99)
        put(prefix+'CheckValue2', 127)
        if corrupt_moves:
            put(prefix+'MoveIndexTable', bytes([moves[0]^1])+moves[1:])
        caught = h.s(prefix+'PokemonData')+h.s('wPokedexCaught')-h.s('wPokemonData')-start
        expected = original[:caught+62]+b'\0'+original[caught+62:caught+124]+b'\0'+original[caught+124:]
        return bytes(expected), bytes(original)

    try:
        for bad_main, bad_backup, bad_moves in [(False,False,False),(True,False,False),(False,True,False),(True,True,False),(False,False,True)]:
            expected_main, old_main = stage('s', 17, bad_main, bad_moves)
            expected_backup, old_backup = stage('sBackup', 83, bad_backup)
            put('sSaveVersion', 3)
            h.wr(h.s('wSaveFileExists'), 0)
            h.call('UpgradePokedexSave')
            check(get('sSaveVersion') == 4, 'Save format did not advance')
            check(get('sCheckValue1') == (0 if bad_main or bad_moves else 99), 'Primary validator accepted invalid data')
            if bad_main or bad_moves:
                h.call('UpgradePokedexSave')
                check(get('sBackupCheckValue1') == (0 if bad_backup else 99), 'Backup validator accepted invalid data')
            for prefix, expected, original, bad in [('s',expected_main,old_main,bad_main or bad_moves),('sBackup',expected_backup,old_backup,bad_backup)]:
                if bad:
                    check(get(prefix+'CheckValue1') == 0, prefix+': invalid source was accepted')
                    check(get(prefix+'SaveData',len(original)) == original, prefix+': corrupt source was shifted')
                else:
                    check(get(prefix+'SaveData',len(expected)) == expected, prefix+': saved progress/index tables changed')
                    verify = 'VerifyChecksum' if prefix=='s' else 'VerifyBackupChecksum'
                    check(sum(get(prefix+'SaveData',len(expected))) & 65535 == int.from_bytes(get(prefix+'Checksum',2),'little'), prefix+': upgraded checksum failed')
            snapshot = (get('sSaveData',len(expected_main)),get('sBackupSaveData',len(expected_backup)))
            h.call('UpgradePokedexSave')
            check(snapshot == (get('sSaveData',len(expected_main)),get('sBackupSaveData',len(expected_backup))), 'Upgrade ran twice')
        for version in (0,1,2,4,255):
            put('sSaveVersion',version)
            before=get('sSaveData',len(expected_main))
            h.call('UpgradePokedexSave')
            check(get('sSaveVersion')==version and get('sSaveData',len(expected_main))==before, 'Unrelated save version modified')
        print(f'POKEDEX SAVE UPGRADE PASSED: {checks} checks in {rom.name}',flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

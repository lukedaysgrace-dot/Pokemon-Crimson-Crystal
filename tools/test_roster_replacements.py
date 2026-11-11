#!/usr/bin/env python3
"""Native replacement data, Dex, evolution and saved-index integration checks."""
import hashlib
import json
from pathlib import Path
import sys

from pc_harness import Harness, ROOT, enc
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    types = _parse_constants(root / 'constants/type_constants.asm')
    items = _parse_constants(root / 'constants/item_constants.asm')
    receipt = json.loads((root / 'tools/testdata/roster_replacements.json').read_text())
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def party(species, level, stone=None):
        info = h.build_temp_mon(con.species_index(species), [con.move_index('TACKLE'), 0, 0, 0],
                                level=level, statexp=bytes(10), nick='TESTMON@@@@')
        write('wTempMonHP', [0, 100])
        write('wTempMonMaxHP', [0, 100])
        write('wPartyCount', 1)
        write('wPartySpecies', [info['sid'], 255])
        write('wPartyMon1', h.rd(h.s('wTempMon'), 50))
        write('wPartyMonNicknames', h.rd(h.s('wTempMonNickname'), 11))
        write('wPartyMonOT', h.rd(h.s('wTempMonOT'), 11))
        write('wCurPartyMon', 0)
        write('wCurPartyLevel', level)
        write('wCurPartySpecies', info['sid'])
        write('wTempSpecies', info['sid'])
        write('wForceEvolution', int(stone is not None))
        write('wCurItem', items[stone] if stone else 0)
        write('wLinkMode', 0)
        write('wBattleMode', 0)

    try:
        mid = h.move_id(con.move_index('KINGS_SHIELD'))
        write('wNamedObjectIndexBuffer', mid)
        h.call('GetMoveName')
        check(h.rd(h.s('wStringBuffer1'), 12) == enc('KING SHIELD@'), 'King Shield: compiled display name')
        bank, address = h.sym['BattleAnimations']
        offset = bank * 0x4000 + (address & 0x3fff)
        raw_rom = rom.read_bytes()
        def animation(move):
            start = offset + con.move_index(move) * 3
            return raw_rom[start:start+3]
        check(animation('KINGS_SHIELD') == animation('DETECT'), 'King Shield: exact compiled Detect animation pointer')
        for species, row in receipt['species'].items():
            sid = h.species_id(con.species_index(species))
            check(con.species_index(species) == row['internal_index'], species + ': internal slot')
            for rules in range(8):
                write('wGameplayRules', rules)
                write('wCurSpecies', sid)
                h.call('GetBaseData')
                expected = row['stats'] if rules & 2 else row['enhanced_stats']
                check(list(h.rd(h.s('wBaseStats'), 6)) == expected, species + ': rules stats')
                check(list(h.rd(h.s('wBaseType1'), 2)) == [types[t] for t in row['types']], species + ': typing')
                check(list(h.rd(h.s('wBaseAbilities'), 3)) == [con.abilities[a] for a in row['abilities']], species + ': ability slots')
            check(h.call('GetRegionalDexNumber_DE', de=con.species_index(species))['hl'] == row['regional_dex'], species + ': regional position')
            check(h.call('GetSpeciesWeightHG', a=sid)['hl'] == row['weight_hg'], species + ': weight lookup')
            check(h.call('NormalizeRetiredRosterIndexDE', de=con.species_index(species))['de'] ==
                  con.species_index('SABLEYE' if species == 'AEGISLASH_BLADE' else species), species + ': save ingress')
            check(h.call('ValidateTempWildMonSpecies', hl=con.species_index(species))['c_flag'] ==
                  (species == 'AEGISLASH_BLADE'), species + ': wild species gate')
            icon = 'aegislash' if species == 'AEGISLASH_BLADE' else species.lower()
            payload = (root / f'gfx/menu_icons/{icon}.2bpp').read_bytes()
            check(len(payload) == 128, species + ': two complete menu frames')
            for routine in ['GetMenuIconPointer', 'GetIconPointer']:
                pointer = h.call(routine, a=sid)
                actual = bytes(h.mem[pointer['b'], pointer['hl']:pointer['hl'] + 128])
                check(actual == payload, species + ': supplied icon linked through ' + routine)

        # The complete visible regional and alphabetical tables each contain
        # unique visible entries; the extra internal record is not an extra catch.
        # AEGISLASH_BLADE and ZANGOOSE_SCARRED are internal forms without
        # Dex entries of their own.
        hidden_forms = ['AEGISLASH_BLADE', 'ZANGOOSE_SCARRED']
        visible_count = con.species['NUM_POKEMON'] - len(hidden_forms)
        for table in ['NewPokedexOrder', 'AlphabeticalPokedexOrder']:
            bank, address = h.sym[table]
            offset = bank * 0x4000 + (address & 0x3fff)
            raw = rom.read_bytes()[offset:offset + visible_count * 2]
            indexes = [int.from_bytes(raw[i:i+2], 'little') for i in range(0, len(raw), 2)]
            check(len(set(indexes)) == visible_count, table + ': unique entries')
            for form in hidden_forms:
                check(con.species_index(form) not in indexes, table + ': hidden form ' + form)

        # Normalize old Espathra seen/caught flags without losing Sableye's.
        for table in ['wPokedexSeen', 'wPokedexCaught']:
            write(table, bytes(63))
        index = con.species_index('AEGISLASH_BLADE') - 1
        for table in ['wPokedexSeen', 'wPokedexCaught']:
            write(table, bytes([0] * (index // 8) + [1 << (index % 8)] + [0] * (62-index//8)))
        write('wPartyCount', 0)
        h.call('NormalizeLoadedRoster')
        for table in ['wPokedexSeen', 'wPokedexCaught']:
            raw = h.rd(h.s(table), 63)
            new = con.species_index('SABLEYE') - 1
            check(not raw[index//8] & (1 << (index%8)), table + ': retired hidden bit cleared')
            check(bool(raw[new//8] & (1 << (new%8))), table + ': replacement bit preserved')

        party('AEGISLASH_BLADE', 50)
        write('wPartyMon1HP', [3, 231])
        before_moves = h.rd(h.s('wPartyMon1Moves'), 4)
        h.call('NormalizeLoadedRoster')
        check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == con.species_index('SABLEYE'), 'saved Espathra runtime slot normalized')
        hp = int.from_bytes(h.rd(h.s('wPartyMon1HP'), 2), 'big')
        maximum = int.from_bytes(h.rd(h.s('wPartyMon1MaxHP'), 2), 'big')
        check(0 < hp == maximum < 999, 'replacement party stats recalculated and HP clamped')
        check(h.rd(h.s('wPartyMon1Moves'), 4) == before_moves, 'saved move slots preserved during normalization')

        presentation = {name: b'\xc9' for name in (
            'PrintText', 'PrintTextboxText', 'DelayFrames', 'ClearSprites', 'ClearTileMap',
            'PlayMusic', 'PlaySFX', 'WaitSFX', 'RestartMapMusic', 'LearnLevelMoves')}
        presentation['EvolutionAnimation'] = b'\xaf\xc9'
        with patches(h, presentation):
            for source, evolved, level in [('SEEDOT', 'NUZLEAF', 14), ('ZORUA', 'ZOROARK', 30),
                                            ('HONEDGE', 'DOUBLADE', 35)]:
                for value in [level - 1, level]:
                    party(source, value)
                    h.call('EvolvePokemon', max_frames=300)
                    check(h.species_index(h.rd(h.s('wPartyMon1Species'))) ==
                          con.species_index(evolved if value == level else source), f'{source}: level boundary {value}')
                    if value == level and source in {'SEEDOT', 'ZORUA'}:
                        learned = [h.move_index(m) for m in h.rd(h.s('wPartyMon1Moves'), 4) if m]
                        move = 'RAZOR_LEAF' if source == 'SEEDOT' else 'SHADOW_CLAW'
                        check(con.move_index(move) in learned, evolved + ': native evolution move ' + move)
            for source, evolved, stone in [('NUZLEAF', 'SHIFTRY', 'LEAF_STONE'), ('DOUBLADE', 'AEGISLASH', 'DUSK_STONE')]:
                party(source, 50, stone)
                h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == con.species_index(evolved), source + ': stone evolution')
                if evolved == 'AEGISLASH':
                    learned = [h.move_index(m) for m in h.rd(h.s('wPartyMon1Moves'), 4) if m]
                    check(con.move_index('KINGS_SHIELD') in learned, 'Aegislash learns Kings Shield on evolution')

        archive = root / 'no longer implemented'
        for row in json.loads((archive / 'manifest.json').read_text()):
            check(hashlib.sha256((archive / row['path']).read_bytes()).hexdigest() == row['sha256'], 'archive changed: ' + row['path'])
        print(f'ROSTER REPLACEMENTS PASSED: {checks} native/archive checks in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

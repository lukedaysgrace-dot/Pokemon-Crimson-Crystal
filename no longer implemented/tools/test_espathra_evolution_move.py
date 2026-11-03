#!/usr/bin/env python3
"""Exercise Flittle's evolution move through the native evolution/learning code.

Presentation and menu choices are suppressed in private emulator memory;
evolution eligibility, move insertion/replacement and PP use the compiled ROM.
"""
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches

ROOT = Path(ROOT)


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    constants = Constants()
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        assert condition, message

    def write(name, value):
        h.wr(h.s(name), value)

    def party(level=35, known=('TACKLE',), slot=0, item=0, species='FLITTLE'):
        info = h.build_temp_mon(constants.species_index(species),
                                [constants.move_index(m) for m in known] + [0] * (4 - len(known)),
                                level=level, item=item, statexp=bytes(10), nick='TESTMON@@@@')
        # Give the fixture valid pre-evolution HP; native CalcMonStats supplies
        # its evolved stats and preserves the amount of HP missing.
        write('wTempMonHP', [0, 100])
        write('wTempMonMaxHP', [0, 100])
        write('wPartyCount', slot + 1)
        write('wPartySpecies', [info['sid']] * (slot + 1) + [255])
        start = h.s('wPartyMon1') + slot * 50
        h.wr(start, h.rd(h.s('wTempMon'), 50))
        h.wr(h.s('wPartyMonNicknames') + slot * 11, h.rd(h.s('wTempMonNickname'), 11))
        h.wr(h.s('wPartyMonOT') + slot * 11, h.rd(h.s('wTempMonOT'), 11))
        write('wCurPartyMon', slot)
        write('wCurPartyLevel', level)
        write('wCurPartySpecies', info['sid'])
        write('wTempSpecies', info['sid'])
        write('wLinkMode', 0)
        write('wForceEvolution', 0)
        write('wBattleMode', 0)
        return start

    def moves(start):
        return [constants.moves_by_index[h.move_index(mid)] for mid in h.rd(start + 2, 4) if mid]

    presentation = {name: b'\xc9' for name in (
        'PrintText', 'PrintTextboxText', 'DelayFrames', 'ClearSprites',
        'ClearTileMap', 'PlayMusic', 'PlaySFX', 'WaitSFX', 'RestartMapMusic', 'LearnLevelMoves')}
    presentation['EvolutionAnimation'] = b'\xaf\xc9'
    try:
        with patches(h, presentation):
            for level, slot in [(35, 0), (50, 0), (35, 2), (100, 0)]:
                start = party(level=level, slot=slot)
                h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(start)) == constants.species_index('ESPATHRA'), 'Flittle did not evolve')
                check(moves(start) == ['TACKLE', 'LUMINA_CRASH'], f'level {level}, party slot {slot}: missing evolution move')
                check(h.rd(start + 24) > 0, 'Lumina Crash did not receive PP')

            start = party(known=('TACKLE', 'LUMINA_CRASH'))
            h.call('EvolvePokemon', max_frames=300)
            check(moves(start) == ['TACKLE', 'LUMINA_CRASH'], 'Already-known evolution move duplicated')

            full = ('TACKLE', 'GROWL', 'CONFUSION', 'PECK')
            start = party(known=full)
            selected = start + 3  # Replace Growl in the second move slot.
            choose = bytes([0x21, selected & 255, selected >> 8, 0x7e, 0xa7, 0xc9])
            with patches(h, {'ForgetMove': choose}):
                h.call('EvolvePokemon', max_frames=300)
            check(moves(start) == ['TACKLE', 'LUMINA_CRASH', 'CONFUSION', 'PECK'], 'Full moveset did not offer replacement')

            start = party(known=full)
            with patches(h, {'ForgetMove': b'\x37\xc9', 'YesNoBox': b'\xa7\xc9'}):
                h.call('EvolvePokemon', max_frames=300)
            check(moves(start) == list(full), 'Declining Lumina Crash changed the moveset')

            for level, item, cancelled in [(34, 0, False), (35, items['EVERSTONE'], False), (35, 0, True)]:
                start = party(level=level, item=item)
                cancellation = {'EvolutionAnimation': b'\x37\xc9'} if cancelled else {}
                with patches(h, cancellation):
                    h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(start)) == constants.species_index('FLITTLE'), 'Blocked evolution changed species')
                check(moves(start) == ['TACKLE'], 'Blocked evolution taught Lumina Crash')

            # An unrelated evolution must never acquire Espathra's move.
            start = party(level=18, species='PIDGEY')
            h.call('EvolvePokemon', max_frames=300)
            check(h.species_index(h.rd(start)) == constants.species_index('PIDGEOTTO'), 'Pidgey failed to evolve')
            check(moves(start) == ['TACKLE'], 'Evolution move leaked to another species')

        # Ordinary level-up at the erroneous old level teaches neither move.
        start = party(level=62, species='ESPATHRA')
        with patches(h, {k: v for k, v in presentation.items() if k != 'LearnLevelMoves'}):
            h.call('LearnLevelMoves')
        check(moves(start) == ['TACKLE'], 'Old level-62 Psystrike entry remains')
        print(f'ESPATHRA EVOLUTION MOVE PASSED: {checks} checks in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

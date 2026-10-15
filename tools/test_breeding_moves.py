#!/usr/bin/env python3
"""Exercise modern hatch-move rules in the compiled ROM, without player saves."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from pc_harness import Harness
from symbols import Constants
from audit_breeding_moves import breeding_data, audit


def main():
    audit()
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    constants = Constants()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def inherit(baby, species1, species2, moves1=(), moves2=(), initial=(), mother=0):
        # Resolve IDs afresh: the ROM uses an evictable 8-bit ID table for
        # its 16-bit move and species indices.
        species = [h.species_id(constants.species_index(c)) for c in (baby, species1, species2)]
        names = set(initial) | set(moves1) | set(moves2)
        mids = {m: h.move_id(constants.move_index(m)) for m in names if m}
        def packed(moves):
            return [mids.get(m, 0) for m in moves] + [0] * (4 - len(moves))
        h.wr(h.s('wEggMonSpecies'), species[0])
        h.wr(h.s('wCurPartySpecies'), species[0])
        h.wr(h.s('wBreedMon1Species'), species[1])
        h.wr(h.s('wBreedMon2Species'), species[2])
        h.wr(h.s('wBreedMotherOrNonDitto'), mother)
        h.wr(h.s('wBreedMon1Moves'), packed(moves1))
        h.wr(h.s('wBreedMon2Moves'), packed(moves2))
        h.wr(h.s('wEggMonMoves'), packed(initial))
        h.wr(h.s('wEggMonPP'), [0] * 4)
        h.call('InitEggMoves')
        result = [constants.moves_by_index[h.move_index(mid)]
                  for mid in h.rd(h.s('wEggMonMoves'), 4) if mid]
        check(len(result) == len(set(result)), f'{baby}: duplicate hatch move')
        if result and result != list(initial):
            check(all(h.rd(h.s('wEggMonPP') + i) for i in range(len(result))), f'{baby}: inherited move PP')
        return result

    try:
        # Every table entry, including indices >255, must work from either
        # parent's slot and in both deposit orders with Ditto.
        data = breeding_data()
        order, _, _, eggs, _, _, _, _, roots = data
        count = 0
        for baby in sorted(set(roots.values())):
            for move in eggs[baby]:
                for side in (0, 1):
                    result = inherit(baby, baby if side == 0 else 'DITTO',
                                     'DITTO' if side == 0 else baby,
                                     (move,) if side == 0 else (),
                                     (move,) if side == 1 else (), mother=side)
                    check(result == [move], f'{baby}: parent {side + 1} egg move {move}')
                count += 1
        print(f'Egg lists: {count} entries inherited in both parent slots.', flush=True)

        # Real compatible parents, maternal-only eggs, and shared level moves.
        for mother in (0, 1):
            p1, p2 = ('ARCANINE', 'ESPEON') if mother == 0 else ('ESPEON', 'ARCANINE')
            m1, m2 = (('MORNING_SUN',), ()) if mother == 0 else ((), ('MORNING_SUN',))
            check(inherit('GROWLITHE', p1, p2, m1, m2, mother=mother) == ['MORNING_SUN'],
                  'maternal egg move / deposit order')
        check(inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', ('SOLARBEAM',), ('SOLARBEAM',)) == ['SOLARBEAM'],
              'both parents share a later level-up move')
        check(inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', (), ('SOLARBEAM',)) == [],
              'one parent cannot pass an ordinary level-up move')
        check(inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', (), ('PROTECT',)) == [],
              'TM compatibility alone is not inherited')
        for side in (0, 1):
            check(inherit('GROWLITHE', 'DITTO' if side == 0 else 'ARCANINE',
                          'ARCANINE' if side == 0 else 'DITTO',
                          ('MORNING_SUN',) if side == 0 else (),
                          ('MORNING_SUN',) if side == 1 else (), mother=1-side) == [],
                  'Ditto does not supply egg moves')
            check(inherit('BULBASAUR', 'DITTO' if side == 0 else 'VENUSAUR',
                          'VENUSAUR' if side == 0 else 'DITTO',
                          ('SOLARBEAM',), ('SOLARBEAM',), mother=1-side) == [],
                  'Ditto does not count toward shared level moves')

        # More than four legal moves: egg moves beat shared level-up moves,
        # maternal egg moves beat paternal ones, without duplicating defaults.
        for mother in (0, 1):
            mom = ('LIGHT_SCREEN', 'SKULL_BASH', 'PETAL_DANCE')
            dad = ('SOLARBEAM', 'RAZOR_WIND', 'SAFEGUARD')
            p1, p2 = (mom, dad) if mother == 0 else (dad, mom)
            result = inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', p1, p2,
                             initial=('TACKLE', 'GROWL', 'VINE_WHIP', 'LEECH_SEED'), mother=mother)
            check(result == ['SAFEGUARD', 'LIGHT_SCREEN', 'SKULL_BASH', 'PETAL_DANCE'],
                  'egg move overflow uses maternal priority')
            mom = ('SOLARBEAM', 'SKULL_BASH', 'PETAL_DANCE')
            dad = ('SOLARBEAM', 'SAFEGUARD', 'RAZOR_WIND')
            p1, p2 = (mom, dad) if mother == 0 else (dad, mom)
            result = inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', p1, p2,
                             initial=('TACKLE', 'GROWL', 'VINE_WHIP', 'LEECH_SEED'), mother=mother)
            check(result == ['SAFEGUARD', 'RAZOR_WIND', 'SKULL_BASH', 'PETAL_DANCE'],
                  'egg moves displace a shared level-up move')
            mom = ('LIGHT_SCREEN', 'SKULL_BASH', 'SAFEGUARD', 'PETAL_DANCE')
            dad = ('LIGHT_SCREEN', 'SKULL_BASH', 'SAFEGUARD', 'RAZOR_WIND')
            p1, p2 = (mom, dad) if mother == 0 else (dad, mom)
            result = inherit('BULBASAUR', 'VENUSAUR', 'VENUSAUR', p1, p2, mother=mother)
            check(result == list(mom), 'duplicate egg moves retain maternal overflow priority')
        check(inherit('GROWLITHE', 'ARCANINE', 'ESPEON', ('MORNING_SUN',), ('MORNING_SUN',),
                      initial=('MORNING_SUN',)) == ['MORNING_SUN'], 'duplicate parent/default move')
        check(inherit('GROWLITHE', 'ARCANINE', 'ESPEON', (), (None, 'MORNING_SUN')) == ['MORNING_SUN'],
              'empty slot does not hide a later inherited move')
        print(f'BREEDING ROM TESTS PASSED: {checks} checks, {h.calls} routine calls.', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

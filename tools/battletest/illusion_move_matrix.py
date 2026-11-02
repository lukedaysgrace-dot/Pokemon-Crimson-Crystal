#!/usr/bin/env python3
"""Generate every real move executing against a legally disguised Totodile.

Execution coverage complements 96-illusion.yaml's behavioral assertions.
Both parties have a bench so phazing and pivot effects can finish natively.
"""
import argparse
import sys
import yaml
from move_sweep import generate_move_smoke_tests
from symbols import Constants


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--abilities-only', action='store_true',
                        help='Every opposing ability against an active legal Illusion holder')
    args = parser.parse_args()
    if args.abilities_only:
        con = Constants()
        tests = []
        for ability in con.abilities_by_id.values():
            if ability in ('NO_ABILITY', 'NUM_ABILITIES'):
                continue
            species = next(species for species, slots in con.species_abilities.items()
                           if ability in slots and species in con.species)
            gas = ability == 'NEUTRALIZING_GAS'
            tests.append({
                'name': f'Active Illusion versus {ability}',
                'player': {'species': 'TOTODILE', 'level': 100, 'ability': 'ILLUSION', 'moves': ['SPLASH']},
                'player2': {'species': 'GENGAR', 'level': 100, 'moves': ['SPLASH']},
                'enemy': {'species': species, 'level': 30, 'ability': ability, 'moves': ['TACKLE']},
                'enemy2': {'species': 'GENGAR', 'level': 100, 'moves': ['SPLASH']},
                'rng': 'forced_low', 'turns': 1,
                'before_action': [{'side': 'enemy', 'assert': [f"wram('wPlayerIllusionSlot') == {0 if gas else 2}"]}],
                'assert': ["wram('wPlayerIllusionSlot') == 0", "player.hp < player.start_hp",
                           f"player.stat_levels[2] == {7 if gas else 8}", "wram('wInAbility') == 0"],
            })
        yaml.safe_dump(tests, sys.stdout, sort_keys=False)
        return
    tests = generate_move_smoke_tests()
    for test in tests:
        test['name'] = test['name'].replace('Move smoke', 'Illusion move')
        test['enemy'] = {'species': 'TOTODILE', 'level': 100,
                         'ability': 'ILLUSION', 'moves': ['SPLASH']}
        test['enemy2'] = {'species': 'GENGAR', 'level': 100, 'moves': ['SPLASH']}
        test['assert'] = ["wram('wInAbility') == 0",
                          "0 <= enemy.hp <= enemy.maxhp",
                          "1 <= enemy.stat_levels[2] <= 13"]
    yaml.safe_dump(tests, sys.stdout, sort_keys=False)


if __name__ == '__main__':
    main()

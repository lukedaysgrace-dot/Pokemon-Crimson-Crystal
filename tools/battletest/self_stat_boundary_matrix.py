"""Generate mixed-cap tests for every implemented damaging self-stat effect.

The move catalog selects cases; the independent expected stage deltas below
describe the mechanics. Each affected stat is capped alone as well as together,
so one failure cannot silently cancel a separate change.
"""
from copy import deepcopy
from itertools import product
import sys

import yaml

from exhaustive_battle_audit import mirror
from outcome_matrix import move_records


DELTAS = {
    'EFFECT_DEFENSE_UP_HIT': {1: 1},
    'EFFECT_ATTACK_UP_HIT': {0: 1},
    'EFFECT_SPEED_UP_HIT': {2: 1},
    'EFFECT_SP_ATK_UP_HIT': {3: 1},
    'EFFECT_ALL_UP_HIT': dict.fromkeys(range(5), 1),
    'EFFECT_DRACO_METEOR': {3: -2},
    'EFFECT_CLOSE_COMBAT': {1: -1, 4: -1},
    'EFFECT_HEADLONG_RUSH': {1: -1, 4: -1},
    'EFFECT_SUPERPOWER': {0: -1, 1: -1},
    'EFFECT_HAMMER_ARM': {2: -1},
    'EFFECT_SCALE_SHOT': {1: -1, 2: 1},
}
STATS = ('atk', 'def', 'spd', 'satk', 'sdef', 'acc', 'eva')


def generate_self_stat_boundary_matrix():
    tests = []
    for move in move_records():
        changes = DELTAS.get(move['effect'])
        if not changes:
            continue
        initial_states = [{i: stage for i in changes} for stage in (-6, 0, 6)]
        for i in changes:
            for stage in (-6, 6):
                state = {j: stage if i == j else 0 for j in changes}
                if state not in initial_states:
                    initial_states.append(state)
        for ability, initial, reverse in product(('NO_ABILITY', 'CONTRARY'), initial_states, (False, True)):
            expected = [7] * 7
            for i, delta in changes.items():
                direction = -1 if ability == 'CONTRARY' else 1
                expected[i] = min(13, max(1, initial[i] + 7 + delta * direction))
            test = {
                'player': {'species': 'MEW', 'level': 50, 'ability': ability,
                           'moves': [move['name']], 'stages': {STATS[i]: stage for i, stage in initial.items()}},
                'enemy': {'species': 'SHUCKLE', 'level': 100, 'ability': 'NO_ABILITY', 'moves': ['SPLASH']},
                'rng': 'forced_low', 'turns': 1,
                'assert': ['enemy.hp < enemy.start_hp', f'player.stat_levels == {expected}',
                           "wram('wInAbility') == 0"],
            }
            if reverse:
                test = mirror(test)
            test['name'] = f"Self-stat boundary: {move['name']} {'enemy' if reverse else 'player'} {ability} {initial}"
            tests.append(deepcopy(test))
    return tests


if __name__ == '__main__':
    yaml.safe_dump(generate_self_stat_boundary_matrix(), sys.stdout, sort_keys=False)

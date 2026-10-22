#!/usr/bin/env python3
"""Validate the focused review, especially unchanged L1/evolution behavior."""
from copy import deepcopy
import hashlib

from attacking_learnsets import review, check_level
from audit_breeding_moves import breeding_data, routes
from audit_canonical_learnsets import available
from audit_learnset_variety import ROOT, read, load_technical_tutors
from review_attacking_learnsets import digest, profiles, apply_overlay, UTILITY_ATTACKS


def audit():
    receipt = review()
    data = breeding_data()
    order, levels, _, _, parents, *_ = data
    assert receipt['reviewed'] == order, 'Incomplete roster review'
    for c in order:
        assert digest([row for row in levels[c] if row[0] == 1]) == receipt['unchanged_level_one'][c], (c, 'level-one moves changed')
    for path, value in receipt['unchanged_runtime'].items():
        assert hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == value, (path, 'unrequested runtime change')
    evo = [line.strip() for name in ['kanto', 'johto', 'clones']
           for line in read(f'data/pokemon/evos_attacks_{name}.asm').splitlines() if 'EVOLVE_' in line]
    assert digest(evo) == receipt['unchanged_evolutions'], 'Evolution methods changed'
    info = profiles(data)
    before = deepcopy(data)
    independent = routes(data)
    trims = delays = 0
    for c, moves in receipt['changes'].items():
        for move, e in moves.items():
            assert e['before'] >= 20 and e['reason'], (c, move, 'early ladder changed')
            check_level(c, move, e['before'], levels)
            if e['after'] is None:
                assert info[c]['role'] != 'mixed/support', (c, move, 'mixed attacker trimmed')
                assert move not in UTILITY_ATTACKS, (c, move, 'tactical move lost')
                assert move in independent[c], (c, move, 'no independent teaching/breeding route')
                trims += 1
            else:
                assert e['after'] > e['before'], (c, move, 'delay became early access')
                delays += 1
            before[1][c] = [(lv, m) for lv, m in before[1][c] if m != move] + [(e['before'], move)]
    known = available(data)
    baseline = available(before, technical={})
    for c in order:
        assert baseline[c] <= known[c], (c, 'lost previous move access', baseline[c] - known[c])
        if c.endswith('_CLONE'):
            assert levels[c] == levels[c[:-6]], (c, 'clone learnset mismatch')
    for c in ['REMORAID', 'OCTILLERY', 'NIDOKING', 'SALAMENCE', 'DRAGAPULT',
              'HYDREIGON', 'LUCARIO', 'BLASTOISE', 'KINGDRA', 'CARRACOSTA']:
        assert info[c]['role'] == 'mixed/support', (c, 'mixed build misclassified')
        assert all(e['after'] is not None for e in receipt['changes'].get(c, {}).values()), c
    assert (32, 'SCALD') in levels['QUAGSIRE'], 'Unaware burn-support option removed'
    assert (37, 'AIR_SLASH') in levels['DUNSPARCE'], 'Serene Grace flinch option removed'
    assert (25, 'DRAGONBREATH') in levels['DUNSPARCE'], 'Serene Grace paralysis option removed'

    def earliest(c, move):
        return min([lv for lv, m in levels[c] if m == move] + [earliest(p, move) for p in parents[c]] + [101])
    for c, move, level in [('FERALIGATR', 'SWORDS_DANCE', 38), ('FERALIGATR', 'LIQUIDATION', 40),
                           ('BLASTOISE', 'SHELL_SMASH', 36), ('CARRACOSTA', 'SHELL_SMASH', 38),
                           ('FLAREON', 'CLOSE_COMBAT', 44), ('FLAREON', 'SUPERPOWER', 48)]:
        assert earliest(c, move) == level, (c, move, 'ancestor reminder bypasses the delay')
    replay = deepcopy(levels)
    apply_overlay(replay, receipt['changes'])
    assert replay == levels, 'Applying the review twice changes the result'
    technical = load_technical_tutors()
    for c, moves in receipt['tutor_additions'].items():
        assert set(moves) <= set(technical[c]), (c, 'missing recorded tutor route')
    print(f'ATTACKING LEARNSET AUDIT PASSED: {len(order)} reviewed; {trims} trims; {delays} delays; '
          'mixed attackers, level-one moves, evolution behavior and original access preserved.')


if __name__ == '__main__':
    audit()

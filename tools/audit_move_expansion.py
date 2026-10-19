#!/usr/bin/env python3
"""Audit the approved October move values, recipients and acquisition receipts."""
import json
import re
from pathlib import Path
from audit_breeding_moves import breeding_data
from audit_canonical_learnsets import available
from audit_learnset_variety import load_technical_tutors

ROOT = Path(__file__).resolve().parents[1]
RECEIPT = ROOT / 'tools/testdata/move_expansion_20261019.json'


def main():
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = breeding_data()
    order, levels, _, eggs, *_ = data
    known = available(data)
    technical = load_technical_tutors()
    rows = {}
    for line in (ROOT / 'data/moves/moves.asm').read_text().splitlines():
        match = re.match(r'\s*move (.*?);(\w+)$', line)
        if match:
            rows[match[2]] = [token.strip() for token in match[1].split(',')]
    assert len(rows) == 439
    expected = {
        'PSYSHOCK': (80, 100), 'VACUUM_WAVE': (40, 100),
        'DISCHARGE': (80, 100), 'LAVA_PLUME': (80, 100),
        'METEOR_MASH': (90, 100), 'DRAGON_HAMMER': (120, 100),
        'COTTON_GUARD': (0, 100), 'COSMIC_POWER': (0, 100),
        'ERUPTION': (150, 100), 'WATER_SPOUT': (150, 100),
        'DOOM_DESIRE': (160, 100), 'TAIL_GLOW': (0, 100),
        'RECYCLE': (0, 100), 'PETAL_BLIZZARD': (90, 100),
        'BLAZE_KICK': (90, 95), 'SKY_UPPERCUT': (85, 100),
        'POISON_TAIL': (90, 100), 'OMINOUS_WIND': (60, 100),
    }
    assert set(receipt['moves']) == set(expected)
    for move, (power, accuracy) in expected.items():
        assert int(rows[move][1]) == power, (move, 'power')
        assert int(rows[move][4]) == accuracy, (move, 'accuracy')
    assert rows['DOOM_DESIRE'][0] == 'EFFECT_GIGA_HAMMER'
    assert rows['DOOM_DESIRE'][3] == 'CATEGORIZE_SPECIAL'
    assert rows['PSYSHOCK'][0] == 'EFFECT_PSYSTRIKE'
    for c, moves in receipt['required'].items():
        assert set(moves) <= known[c], (c, 'approved recipient lacks access')
        for move in moves:
            assert receipt['evidence'][c][move], (c, move, 'source proof missing')
    for kind in ('level_up', 'donor_fallbacks'):
        for c, moves in receipt.get(kind, {}).items():
            for move, level in moves.items():
                assert (level, move) in levels[c], (c, move, 'recorded natural placement')
    for c, moves in receipt['new_egg_moves'].items():
        assert set(moves) <= set(eggs[c]), (c, 'recorded egg placement')
    assert (1, 'TAIL_GLOW') in levels['AMPHAROS']
    assert (40, 'TAIL_GLOW') in levels['LANTURN']
    for level, move in [(26, 'COSMIC_POWER'), (49, 'METEOR_MASH'), (50, 'DOOM_DESIRE')]:
        assert (level, move) in levels['JIRACHI']
    assert {'PSYSHOCK', 'RECYCLE'} <= set(technical['JIRACHI'])
    assert all(known[c] == known[c[:-6]] for c in order if c.endswith('_CLONE'))
    print(f'OCTOBER MOVE AUDIT PASSED: {len(expected)} moves; '
          f'{sum(map(len, receipt["required"].values()))} approved recipient pairs; '
          'values, placements, Tail Glow, Jirachi and clone parity verified.')


if __name__ == '__main__':
    main()


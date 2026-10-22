#!/usr/bin/env python3
"""Prove egg-move donor routes using this ROM's species, genders and moves.

No network or external Pokédex is needed. The checked-in receipt records the
modern natural level-up overlaps and the intentional fallback placements.
The egg tutor is deliberately NOT a source: it would make every proof circular.
"""
from collections import deque
from pathlib import Path
import json
import re
from attacking_learnsets import check_level, removed

from audit_learnset_variety import ROOT, load_sources, load_technical_tutors, read

RECEIPT = ROOT / 'tools/testdata/breeding_moves.json'
UTILITY = ['SUBSTITUTE', 'SLEEP_TALK', 'REFLECT', 'LIGHT_SCREEN', 'THUNDER_WAVE']


def breeding_data():
    order, levels, tms, eggs, parents, utility = load_sources()
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"',
                       read('data/pokemon/base_stats.asm'))
    groups, genders = {}, {}
    for species, path in zip(order, files):
        text = read(path)
        groups[species] = set(re.search(r'\bdn (EGG_\w+), (EGG_\w+)', text).groups())
        genders[species] = re.search(r'\bdb (GENDER_\w+)\s*;', text)[1]
    roots = dict(zip(order, re.findall(r'^\s*dw\s+(\w+)',
                                     read('data/pokemon/first_stages.asm'), re.M)))
    return order, levels, tms, eggs, parents, utility, groups, genders, roots


def routes(data, excluded=None, technical=None):
    """Least fixed point, seeded only by non-breeding sources.

    A proof is a list of natural acquisition, evolution and breeding steps.
    Female-only and genderless donors cannot send moves to another family.
    Male-only families can retain a known egg move with Ditto, but cannot
    import one from an unrelated father. Babies use their mature parents'
    groups. Every evolution edge preserves known moves.
    """
    order, levels, tms, eggs, parents, utility, groups, genders, roots = data
    excluded = excluded or {}
    children = {c: [] for c in order}
    for child, ps in parents.items():
        for p in ps:
            children[p].append(child)
    breedable = lambda c: c != 'DITTO' and 'EGG_NONE' not in groups[c]
    female = lambda c: genders[c] not in {'GENDER_F0', 'GENDER_UNKNOWN'}
    male = lambda c: genders[c] not in {'GENDER_F100', 'GENDER_UNKNOWN'}
    targets = {}
    for donor in order:
        destinations = set()
        if breedable(donor):
            # The non-Ditto parent can pass its own species' egg moves.
            destinations.add(roots[donor])
            if male(donor):
                destinations.update(roots[mother] for mother in order
                                    if breedable(mother) and female(mother)
                                    and groups[donor] & groups[mother])
        if 'NIDORAN_F' in destinations:
            destinations.add('NIDORAN_M')
        targets[donor] = destinations
    known = {c: {} for c in order}
    queue = deque()

    def learn(c, move, proof):
        if move not in known[c]:
            known[c][move] = proof
            queue.append((c, move))

    technical = load_technical_tutors() if technical is None else technical
    for c in order:
        for level, move in levels[c]:
            if move not in excluded.get(c, []):
                learn(c, move, [f'{c}: level {level}'])
        for move in tms[c]:
            learn(c, move, [f'{c}: TM/HM/elemental tutor'])
        for bit, move in enumerate(UTILITY):
            if utility[c] & (1 << bit):
                learn(c, move, [f'{c}: utility tutor'])
        for move in technical.get(c, []):
            learn(c, move, [f'{c}: Blackthorn move tutor'])
    # Sketch is a real Field-group bridge, but cannot invent an unavailable
    # move. Only moves with an independent source somewhere in the roster seed it.
    if 'SMEARGLE' in known:
        for move in sorted({m for ms in known.values() for m in ms} - {'STRUGGLE', 'SKETCH'}):
            learn('SMEARGLE', move, [f'SMEARGLE: Sketch {move} from an available learner'])
    while queue:
        c, move = queue.popleft()
        proof = known[c][move]
        for child in children[c]:
            learn(child, move, proof + [f'{c} -> {child}: evolution'])
        for baby in sorted(targets[c]):
            if move in eggs[baby]:
                learn(baby, move, proof + [f'{c} -> {baby}: egg move'])
    return known


def audit():
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = breeding_data()
    order, levels, _, eggs, _, _, _, _, roots = data
    known = routes(data)
    # Recheck each removal with every removed row excluded, even if someone
    # accidentally reintroduces it into a generated level-up table.
    independent = routes(data, receipt['level_up_removals'])
    for c, moves in receipt['level_up_removals'].items():
        for move in moves:
            assert move not in dict((m, lv) for lv, m in levels[c]), (c, move, 'restored egg-only row')
            assert move in independent[roots[c]], (c, move, 'no independent breeding route')
    for c, moves in receipt['fallbacks'].items():
        for move, level in moves.items():
            check_level(c, move, level, levels)
            assert move in known[c], (c, move, 'lost independent donor access')
    for c, moves in receipt['natural_level_up'].items():
        for move in moves:
            if move in removed(c):
                assert move in known[c], (c, move, 'lost alternate acquisition')
            else:
                assert any(m == move for _, m in levels[c]), (c, move, 'lost natural level-up move')
    families = sorted(set(roots.values()))
    missing = [(c, m) for c in families for m in eggs[c] if m not in known[c]]
    assert not missing, ('egg moves without breeding or level-up access', missing)
    print(f'BREEDING MOVE AUDIT PASSED: {len(order)} species, '
          f'{sum(len(eggs[c]) for c in families)} family egg moves; '
          f'{sum(map(len, receipt["level_up_removals"].values()))} egg-only rows, '
          f'{sum(map(len, receipt["fallbacks"].values()))} fallback rows.')


if __name__ == '__main__':
    audit()

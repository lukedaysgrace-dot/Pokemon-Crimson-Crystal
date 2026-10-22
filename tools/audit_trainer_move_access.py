#!/usr/bin/env python3
"""Validate the project's deliberately expanded trainer move compatibility."""
import json

from audit_breeding_moves import breeding_data, routes
from audit_canonical_learnsets import available
from audit_learnset_variety import ROOT, load_technical_tutors
import audit_trainers as trainers
from attacking_learnsets import check_level

RECEIPT = ROOT / 'tools/testdata/trainer_move_access.json'


def audit():
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = breeding_data()
    order, levels, _, eggs, _, _, groups, genders, roots = data
    technical = load_technical_tutors()
    known = available(data)
    for c, moves in receipt['requested'].items():
        assert set(moves) <= known[c], (c, 'requested trainer move unavailable', set(moves)-known[c])
    for c, moves in receipt['level_up'].items():
        for move, level in moves.items():
            check_level(c, move, level, levels)
    # A father's natural move is an independent source; neither the egg list
    # nor its tutor presentation may serve as its own breeding proof.
    independent = routes(data, technical={})
    for baby, moves in receipt['egg_moves'].items():
        for move, donor in moves.items():
            mother, father = donor['mother'], donor['father']
            assert roots[mother] == baby, (baby, 'wrong mother family')
            assert 'EGG_NONE' not in groups[mother] | groups[father], (baby, 'baby or sterile parent')
            assert groups[mother] & groups[father], (baby, 'incompatible egg groups')
            assert genders[mother] not in {'GENDER_F0', 'GENDER_UNKNOWN'}, (baby, 'mother cannot be female')
            assert genders[father] not in {'GENDER_F100', 'GENDER_UNKNOWN'}, (baby, 'father cannot be male')
            assert (donor['donor_level'], move) in levels[father], (father, move, 'natural donor move missing')
            assert move in eggs[baby] and move in independent[baby], (baby, move, 'no independent egg route')
    for c, moves in receipt['technical_tutor'].items():
        assert set(moves) <= set(technical[c]), (c, 'custom Blackthorn assignment missing')

    # All authored NPC combinations should now have a player acquisition route.
    # Smeargle's intentional custom sets use Sketch instead of ordinary lists.
    parties = trainers.parse_parties(set(order), set(trainers.constant_list(
        'constants/move_constants.asm', 'NUM_ATTACKS')), set(trainers.constant_list(
        'constants/item_constants.asm', 'NUM_ITEMS')))
    assert not trainers.ERRORS, trainers.ERRORS
    slots = 0
    for entries in parties.values():
        for entry in entries:
            for mon in entry['mons']:
                slots += 1
                if mon['species'] == 'SMEARGLE':
                    continue
                moves = set(mon['moves']) - {'NO_MOVE'}
                assert moves <= known[mon['species']], (entry['declared_class'], entry['declared_number'],
                    mon['species'], sorted(moves-known[mon['species']]), 'NPC-only move combination')
    print(f'TRAINER MOVE ACCESS AUDIT PASSED: {sum(map(len, receipt["requested"].values()))} requested '
          f'combinations available; {slots} trainer slots checked; independent egg donors verified.')
    return receipt


if __name__ == '__main__':
    audit()

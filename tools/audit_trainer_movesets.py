#!/usr/bin/env python3
"""Check fixed trainer sets against local move effects, categories and abilities.

This complements audit_trainers.py's structural checks. It resolves automatic
level-up moves and class-default abilities; it does not judge competitive power
or enforce monotype teams. JSON output supports review and future regression
checks. CAL2's stored placeholder is scanned, but its live Mystery Gift team is
external save data. Battle Tower builds have a separate structural audit.
"""
from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
import re

import audit_learnset_variety as learn
import audit_trainers as audit
import generate_trainer_party_reference as reference

ROOT = Path(__file__).resolve().parents[1]
SLEEP_MOVES = {'HYPNOSIS', 'SING', 'SLEEP_POWDER', 'SPORE', 'LOVELY_KISS', 'YAWN'}
SLOT_INDEX = {'ABILITY_1': 0, 'ABILITY_2': 1, 'HIDDEN_ABILITY': 2}
BORROWED_MOVES = {'METRONOME', 'MIRROR_MOVE', 'MIMIC', 'SKETCH', 'TRANSFORM'}
CONSUMABLES = {
    'BERRY', 'GOLD_BERRY', 'MIRACLEBERRY', 'MINT_BERRY', 'PRZCUREBERRY',
    'PSNCUREBERRY', 'BITTER_BERRY', 'BURNT_BERRY', 'ICE_BERRY', 'MYSTERYBERRY',
    'BERRY_JUICE', 'FOCUS_SASH', 'WEAK_POLICY', 'AIR_BALLOON', 'BERSERK_GENE',
}


def load_tables():
    species, levels, *_ = learn.load_sources()
    paths = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"',
                       (ROOT / 'data/pokemon/base_stats.asm').read_text())
    if len(paths) != len(species):
        raise ValueError('Base-stat include count does not match species constants')
    metadata = {}
    for name, path in zip(species, paths):
        raw = (ROOT / path).read_text()
        metadata[name] = {
            'abilities': re.search(r'abilities_for\s+\w+,\s*(\w+),\s*(\w+),\s*(\w+)', raw).groups(),
            'types': set(re.search(r'db\s+(\w+),\s*(\w+)\s*;\s*type', raw).groups()),
            'gender': re.search(r'db\s+(GENDER_\w+)\s*;', raw)[1],
        }
    moves = {}
    for line in (ROOT / 'data/moves/moves.asm').read_text().splitlines():
        match = re.match(r'\s*move\s+(\w+),\s*(\d+),\s*(\w+),\s*(CATEGORIZE_\w+),\s*(\d+),\s*(\d+),\s*(\d+)\s*;\s*(\w+)', line)
        if match:
            moves[match[8]] = dict(effect=match[1], power=int(match[2]), type=match[3],
                                   category=match[4], accuracy=int(match[5]))
    constants = set(audit.constant_list('constants/move_constants.asm', 'NUM_ATTACKS'))
    if set(moves) != constants - {'NO_MOVE'}:
        raise ValueError('Not all move definitions were parsed')
    groups = audit.parse_parties(set(species), constants,
                                set(audit.constant_list('constants/item_constants.asm', 'NUM_ITEMS')))
    if audit.ERRORS:
        raise ValueError('\n'.join(audit.ERRORS))
    classes, *_ = audit.parse_trainer_constants()
    defaults = reference.trainer_default_ability_slots(classes)
    return groups, levels, metadata, moves, defaults


def inspect(mon, selected, ability, metadata, moves):
    """Return actionable failures/dependencies, excluding ordinary tradeoffs."""
    found = []

    def add(code, reason, severity='error'):
        found.append(dict(code=code, reason=reason, severity=severity))

    chosen = set(selected)
    physical_damage = [m for m in selected if moves[m]['category'] == 'CATEGORIZE_PHYSICAL'
                       and moves[m]['power'] > 0]
    physical = [m for m in physical_damage if m not in {'BODY_PRESS', 'FOUL_PLAY'}]
    special = [m for m in selected if moves[m]['category'] == 'CATEGORIZE_SPECIAL'
               and moves[m]['power'] > 0]
    statuses = [m for m in selected if moves[m]['category'] == 'CATEGORIZE_STATUS']
    transfers = chosen & {'BATON_PASS', 'STORED_POWER', 'POWER_TRIP'}
    borrowed = bool(chosen & BORROWED_MOVES) or ability == 'IMPOSTER'
    attack_setup = [m for m in selected if moves[m]['effect'] in {
        'EFFECT_ATTACK_UP', 'EFFECT_ATTACK_UP_2', 'EFFECT_BELLY_DRUM'}]
    special_setup = [m for m in selected if moves[m]['effect'] in {
        'EFFECT_SP_ATK_UP', 'EFFECT_SP_ATK_UP_2', 'EFFECT_SP_ATK_UP_3'}]
    # Body Press and Foul Play do damage but do not use the user's Attack.
    # Mixed defensive/Speed boosts remain useful without matching offense.
    if attack_setup and not physical and not transfers and not borrowed:
        add('unused-attack-boost', '/'.join(attack_setup) + ' has no selected attack using the user\'s Attack')
    if special_setup and not special and not transfers and not borrowed:
        add('unused-special-boost', '/'.join(special_setup) + ' has no selected special attack')
    if 'TELEPORT' in chosen:
        add('trainer-teleport', 'Teleport fails in trainer battles in this engine')
    for move in ['DREAM_EATER', 'NIGHTMARE']:
        if move in chosen and not chosen & SLEEP_MOVES:
            add('target-sleep-dependency', move + ' lacks its own sleep move; inspect team support', 'warning')
    for move in ['SNORE', 'SLEEP_TALK']:
        if move in chosen and 'REST' not in chosen and ability != 'COMATOSE':
            add('user-sleep-dependency', move + ' depends on enemy-induced sleep', 'warning')
    if 'REST' in chosen and ability in {'INSOMNIA', 'VITAL_SPIRIT', 'COMATOSE', 'SWEET_VEIL'}:
        add('rest-blocked', 'The selected ability prevents Rest sleep')
    if 'RECYCLE' in chosen and mon['item'] not in CONSUMABLES:
        add('recycle-dependency', 'Recycle has no starting held consumable; requires outside item help', 'warning')
    if 'ATTRACT' in chosen and metadata['gender'] == 'GENDER_UNKNOWN':
        add('genderless-attract', 'A genderless user cannot use Attract successfully')
    if chosen & {'SPIT_UP', 'SWALLOW'} and 'STOCKPILE' not in chosen:
        add('stockpile-dependency', 'Spit Up/Swallow lacks Stockpile')
    if 'FLING' in chosen and mon['item'] == 'NO_ITEM':
        add('fling-dependency', 'Fling starts without an item', 'warning')
    if chosen & {'NATURAL_GIFT', 'BELCH'} and mon['item'] not in CONSUMABLES - {'FOCUS_SASH', 'WEAK_POLICY', 'AIR_BALLOON', 'BERSERK_GENE'}:
        add('berry-dependency', 'The selected berry-dependent attack starts without a berry', 'warning')
    item = mon['item']
    if item == 'ASSAULT_VEST' and statuses:
        add('vest-status', 'Assault Vest blocks ' + '/'.join(statuses))
    if item == 'BLACK_SLUDGE' and 'POISON' not in metadata['types']:
        add('black-sludge-type', 'Black Sludge damages its non-Poison holder')
    can_trade = chosen & {'TRICK', 'SWITCHEROO'}
    if item == 'TOXIC_ORB' and (metadata['types'] & {'POISON', 'STEEL'} or ability in {'IMMUNITY', 'COMATOSE'}) and not can_trade:
        add('poison-orb-immunity', 'Toxic Orb cannot poison this holder')
    if item == 'FLAME_ORB' and ('FIRE' in metadata['types'] or ability in {'WATER_VEIL', 'WATER_BUBBLE', 'COMATOSE'}) and not can_trade:
        add('burn-orb-immunity', 'Flame Orb cannot burn this holder')
    # This engine applies both Bands as category-based damage multipliers,
    # including Body Press/Foul Play; they differ from an Attack-stage boost.
    if item in {'CHOICE_BAND', 'MUSCLE_BAND'} and not physical_damage and not borrowed:
        add('physical-item', 'Physical damage boost item lacks matching offense', 'warning')
    if item in {'CHOICE_SPECS', 'WISE_GLASSES'} and not special and not borrowed:
        add('special-item', 'Special boost item lacks matching offense', 'warning')
    if item == 'THICK_CLUB' and mon['species'] not in {'CUBONE', 'MAROWAK', 'MAROWAK_ALOLAN'}:
        add('club-species', 'Thick Club does not boost this species')
    if item == 'LIGHT_BALL' and mon['species'] != 'PIKACHU':
        add('light-ball-species', 'Light Ball does not boost this species')
    if item in {'CHOICE_BAND', 'CHOICE_SPECS', 'CHOICE_SCARF'} and statuses and not can_trade and not borrowed:
        add('choice-status', 'Inspect choice-locked status moves: ' + '/'.join(statuses), 'warning')
    if ability == 'DAMP' and chosen & {'EXPLOSION', 'SELFDESTRUCT'}:
        add('damp-explosion', 'Damp blocks the user\'s selected explosion')
    if ability == 'KLUTZ' and item != 'NO_ITEM' and not can_trade and 'FLING' not in chosen:
        add('klutz-item', 'Klutz suppresses the held item', 'warning')
    if ability == 'CONTRARY' and (attack_setup or special_setup or chosen & {
            'BULK_UP', 'CALM_MIND', 'DRAGON_DANCE', 'QUIVER_DANCE', 'SHELL_SMASH', 'HONE_CLAWS', 'WORK_UP'}):
        add('contrary-setup', 'Contrary reverses the selected setup', 'warning')
    return found


def run():
    groups, levels, metadata, moves, defaults = load_tables()
    source = (ROOT / 'data/trainers/parties.asm').read_text().splitlines()
    findings = []
    used_moves = Counter()
    count = slots = 0
    for entries in groups.values():
        for entry in entries:
            count += 1
            tid = re.search(r'\(\d+\)\s+(\w+)', source[entry['line'] - 1])[1]
            for index, mon in enumerate(entry['mons'], 1):
                slots += 1
                selected = [m for m in (mon['moves'] or reference.automatic_moves(
                    levels[mon['species']], mon['level'])) if m != 'NO_MOVE']
                used_moves.update(selected)
                meta = metadata[mon['species']]
                slot = mon['ability'] or defaults[entry['declared_class']]
                ability = meta['abilities'][SLOT_INDEX[slot]]
                if ability == 'NO_ABILITY':
                    ability = meta['abilities'][0]
                issues = inspect(mon, selected, ability, meta, moves)
                if issues:
                    findings.append(dict(trainer=tid, group=entry['group'], line=entry['line'], slot=index,
                                         species=mon['species'], level=mon['level'], ability=ability,
                                         item=mon['item'], moves=selected, issues=issues))
    return dict(parties=count, pokemon=slots, species_definitions=len(metadata), move_definitions=len(moves),
                distinct_selected_moves=len(used_moves), selected_move_slots=sum(used_moves.values()), findings=findings)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--json', action='store_true', help='Print structured results')
    args = parser.parse_args()
    result = run()
    errors = sum(i['severity'] == 'error' for r in result['findings'] for i in r['issues'])
    warnings = sum(i['severity'] == 'warning' for r in result['findings'] for i in r['issues'])
    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print(f"Checked {result['parties']} parties / {result['pokemon']} Pokemon; "
              f"{result['distinct_selected_moves']} distinct selected moves.")
        for row in result['findings']:
            print(f"{row['trainer']} slot {row['slot']}: {row['species']} {row['level']} "
                  f"(data/trainers/parties.asm:{row['line']})")
            for issue in row['issues']:
                print(f"  {issue['severity']}: {issue['reason']}")
        print(f'{errors} errors; {warnings} dependency/design warnings.')
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())

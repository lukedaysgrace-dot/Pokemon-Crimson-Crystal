#!/usr/bin/env python3
"""Review attacking categories; preserve level-one moves and evolution data.

Without --apply, write a proposed receipt under _artifacts. With --apply,
save and replay the small, explicit final layer after the existing imports.
No new moves, compatibility, evolution rewards, or battle-engine changes.
"""
import argparse
from copy import deepcopy
import hashlib
import json
import re

from attacking_learnsets import PATH
from audit_breeding_moves import breeding_data, routes
from audit_canonical_learnsets import available
from audit_learnset_variety import ROOT, read, load_technical_tutors

# Keep effects useful independently of the attacking stat. Damage-only moves
# with incidental secondary effects do not automatically qualify as utility.
UTILITY_ATTACKS = set('''U_TURN FLIP_TURN VOLT_SWITCH FLAME_CHARGE SCALE_SHOT
 RAPID_SPIN MORTAL_SPIN KNOCK_OFF PURSUIT PAY_DAY NUZZLE ACID_SPRAY CLEAR_SMOG SNARL STRUGGLE_BUG
 ICY_WIND MUD_SLAP MUD_SHOT ROCK_TOMB LOW_SWEEP BULLDOZE DRAGON_TAIL CIRCLE_THROW
 FAKE_OUT FIRST_IMPRESSION QUICK_ATTACK EXTREMESPEED AQUA_JET MACH_PUNCH
 VACUUM_WAVE BULLET_PUNCH ICE_SHARD SHADOW_SNEAK SUCKER_PUNCH ACCELROCK
 SEISMIC_TOSS NIGHT_SHADE DRAGON_RAGE SONICBOOM PSYWAVE SUPER_FANG ENDEAVOR
 FOUL_PLAY BODY_PRESS COUNTER MIRROR_COAT METAL_BURST FINAL_GAMBIT BIDE
 FISSURE HORN_DRILL GUILLOTINE SHEER_COLD FALSE_SWIPE
 WRAP BIND CLAMP WHIRLPOOL FIRE_SPIN INFESTATION SELFDESTRUCT EXPLOSION
 FLAIL REVERSAL SNORE'''.split())
SPECIAL_SETUP = {'CALM_MIND', 'NASTY_PLOT', 'QUIVER_DANCE', 'TAIL_GLOW'}
PHYSICAL_SETUP = {'SWORDS_DANCE', 'BULK_UP', 'BELLY_DRUM', 'HONE_CLAWS',
                  'HOWL', 'SHARPEN', 'MEDITATE', 'DRAGON_DANCE'}
RESTRICTED = {'DITTO', 'SMEARGLE', 'UNOWN', 'WOBBUFFET', 'WYNAUT',
              'MAGIKARP', 'FEEBAS', 'CATERPIE', 'WEEDLE', 'METAPOD', 'KAKUNA'}

# Only delays, addressing strong combinations available to mid-game teams.
# Include pre-evolutions because the reminder can recover ancestor moves.
DELAYS = {
    'SQUIRTLE': {'SHELL_SMASH': (36, 'Delay +2 offensive/Speed setup beyond the early-midgame; ancestor reminder must respect the same unlock.')},
    'WARTORTLE': {'SHELL_SMASH': (36, 'Separate Shell Smash from pre-final-evolution progression.')},
    'BLASTOISE': {'SHELL_SMASH': (36, 'Align the family unlock with final evolution without adding an evolution reward.')},
    'CROCONAW': {'SWORDS_DANCE': (38, 'Avoid immediate +2 Attack on the route into Feraligatr; preserve the ancestor reminder gate.')},
    'FERALIGATR': {
        'SWORDS_DANCE': (38, 'Space +2 Attack after evolution and existing Aqua Tail/Crunch access.'),
        'LIQUIDATION': (40, 'Separate reliable Water STAB with a Sheer Force interaction from the setup unlock.')},
    'FLAREON': {
        'CLOSE_COMBAT': (44, 'Keep powerful Fighting coverage after level-40 Flare Blitz.'),
        'SUPERPOWER': (48, 'Separate the second high-power Fighting option from Flare Blitz and Close Combat.')},
    'TIRTOUGA': {'SHELL_SMASH': (38, 'Keep +2 setup out of the level-30 cluster and prevent an ancestor reminder shortcut.')},
    'CARRACOSTA': {'SHELL_SMASH': (38, 'Spread setup beyond the level-30 cluster, after evolution at level 37.')},
}


def digest(rows):
    return hashlib.sha256(json.dumps(rows, separators=(',', ':')).encode()).hexdigest()


def profiles(data):
    order, levels, _, _, parents, *_ = data
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    enhanced = read('engine/pokemon/gameplay_rules.asm').split('RevampedPokemonTypes:', 1)[1].split('\tdw 0', 1)[0]
    typing = {c: [v.strip() for v in pair.split(',')] for c, pair in
              re.findall(r'dw\s+(\w+)\s+db\s+([A-Z_]+\s*,\s*[A-Z_]+)', enhanced)}
    result = {}
    for c, path in zip(order, files):
        text = read(path)
        stats = list(map(int, re.search(r'^\s*db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)', text, re.M).groups()))
        abilities = [v.strip() for v in re.search(r'abilities_for\s+[^,]+,\s*([^\n]+)', text)[1].split(',')]
        atk, spa = stats[1], stats[4]
        base_atk = atk
        # Ability-supported physical sets must not be mistaken for weak ones.
        if set(abilities) & {'HUGE_POWER', 'PURE_POWER'}:
            atk *= 2
        weaker, stronger = min(atk, spa), max(atk, spa)
        specialist = (stronger >= 75 and weaker <= 80 and
                      (stronger - weaker >= 30 and stronger >= weaker * 1.35 or
                       stronger - weaker >= 25 and stronger >= weaker * 1.4))
        role = ('physical' if atk > spa else 'special') if specialist else 'mixed/support'
        # An optional ability can make a second attacking route viable; it
        # must not erase a mixed/special path supported by the base stats.
        if role == 'special' and set(abilities) & {'HUSTLE', 'GUTS'} and base_atk * 1.5 >= spa * 0.8:
            role = 'mixed/support'
        if min(base_atk, spa) >= 75 and any(m == 'SHELL_SMASH' for _, m in levels[c]):
            role = 'mixed/support'
        types = typing.get(c, re.search(r'db\s+(\w+),\s*(\w+)\s*;\s*type', text).groups())
        result[c] = {'stats': stats, 'types': list(dict.fromkeys(types)),
                     'abilities': abilities, 'role': role}
    # Unevolved relatives can share the family's clearly dominant category,
    # while families with mixed adult attackers retain both paths.
    children = {c: [] for c in order}
    for c, ps in parents.items():
        for p in ps:
            children[p].append(c)
    def finals(c):
        return {r for child in children[c] for r in finals(child)} if children[c] else {result[c]['role']}
    for c in order:
        if result[c]['role'] != 'mixed/support' or not children[c]:
            continue
        roles = finals(c)
        atk, spa = result[c]['stats'][1], result[c]['stats'][4]
        if roles == {'physical'} and atk >= spa * 1.25:
            result[c]['role'] = 'physical'
        elif roles == {'special'} and spa >= atk * 1.25:
            result[c]['role'] = 'special'
    return result


def plan():
    original = breeding_data()
    data = deepcopy(original)
    order, levels, _, _, parents, *_ = data
    info = profiles(data)
    categories = {m[2]: m[1] for m in re.finditer(
        r'^\s*move\s+[^\n;]*?,\s*(CATEGORIZE_\w+),[^\n;]*;\s*(\w+)\s*$', read('data/moves/moves.asm'), re.M)}
    trainer = json.loads(read('tools/testdata/trainer_move_access.json'))
    protected = {c: set() for c in order}
    for ms in trainer['egg_moves'].values():
        for move, donor in ms.items():
            protected[donor['father']].add(move)
    # Keep every move-based evolution requirement intact.
    for name in ['kanto', 'johto', 'clones']:
        for label, body in re.findall(r'^(\w+)EvosAttacks:\n(.*?)(?=^\w|^SECTION|\Z)', read(f'data/pokemon/evos_attacks_{name}.asm'), re.M | re.S):
            required = re.findall(r'EVOLVE_MOVE,\s*(\w+),', body)
            for c in order:
                if re.sub('[^a-z0-9]', '', c.lower()) == label.lower():
                    protected[c].update(required)
    edits = {}
    for c in order:
        if c in RESTRICTED or c.endswith('_CLONE'):
            continue
        role = info[c]['role']
        for lv, move in list(levels[c]):
            # Preserve the entire early-game ladder and all existing L1 rows.
            if lv < 20 or move in protected[c] or move in UTILITY_ATTACKS:
                continue
            if 'SERENE_GRACE' in info[c]['abilities'] and move in {'ANCIENTPOWER', 'SILVER_WIND', 'OMINOUS_WIND', 'DRAGONBREATH', 'AIR_SLASH', 'HEADBUTT', 'DISCHARGE'}:
                continue
            if move == 'SCALD' and c == 'QUAGSIRE':
                continue  # Burn support is valuable on the bulky Unaware set.
            # Hex remains a supported status-based alternative when the weaker
            # special stat is still usable and a status enabler is natural.
            if move == 'HEX' and info[c]['stats'][4] >= 65 and any(
                    m in {'WILL_O_WISP', 'THUNDER_WAVE', 'TOXIC', 'POISON_GAS'} for _, m in levels[c]):
                continue
            category = categories[move]
            wrong_attack = (role == 'physical' and category == 'CATEGORIZE_SPECIAL' or
                            role == 'special' and category == 'CATEGORIZE_PHYSICAL')
            wrong_setup = (role == 'physical' and move in SPECIAL_SETUP or
                           role == 'special' and move in PHYSICAL_SETUP)
            if wrong_attack or wrong_setup:
                edits.setdefault(c, {})[move] = {'before': lv, 'after': None,
                    'reason': f'Optional alternate-stat {"setup" if wrong_setup else "attack"}; natural progression favors the {role} role.'}
        for move, (after, reason) in DELAYS.get(c, {}).items():
            before = next((lv for lv, m in levels[c] if m == move), None)
            if before is not None and before > 1 and after > before:
                edits.setdefault(c, {})[move] = {'before': before, 'after': after, 'reason': reason}
    for c in order:
        if c.endswith('_CLONE') and c[:-6] in edits:
            edits[c] = deepcopy(edits[c[:-6]])
    apply_overlay(levels, edits)
    # Preserve both ordinary acquisition and non-circular breeding proofs.
    before_known, after_known = available(original), available(data)
    before_routes, after_routes = routes(original), routes(data)
    tutors = {}
    for c in order:
        missing = (before_known[c] - after_known[c]) | (set(before_routes[c]) - set(after_routes[c]))
        if missing:
            tutors[c] = sorted(missing)
    runtime = ['engine/pokemon/evolve.asm', 'engine/events/move_deleter.asm', 'main.asm']
    return {'policy': 'Trim unsuitable opposite-stat attacks and setup from level 20 onward. Keep viable mixed attackers, useful move/ability interactions, early progression, all level-1 moves and evolution behavior. Delay only selected powerful combinations, including ancestor reminder access. Preserve optional move access through existing routes and Blackthorn.',
            'reviewed': order, 'changes': edits, 'tutor_additions': tutors,
            'unchanged_evolutions': digest([line.strip() for name in ['kanto', 'johto', 'clones']
                                            for line in read(f'data/pokemon/evos_attacks_{name}.asm').splitlines() if 'EVOLVE_' in line]),
            'unchanged_level_one': {c: digest([row for row in original[1][c] if row[0] == 1]) for c in order},
            'unchanged_runtime': {f: hashlib.sha256((ROOT / f).read_bytes()).hexdigest() for f in runtime}}, data


def apply_overlay(levels, changes):
    for c, moves in changes.items():
        for move, edit in moves.items():
            levels[c] = [(lv, m) for lv, m in levels[c] if m != move]
            if edit['after'] is not None:
                levels[c].append((edit['after'], move))
        levels[c].sort(key=lambda row: row[0])


def write_levels(order, levels):
    paths = [ROOT / f'data/pokemon/evos_attacks_{s}.asm' for s in ['kanto', 'johto', 'clones']]
    tables = {}
    for path in paths:
        for match in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)', path.read_text(encoding='utf-8'), re.M):
            tables[match[1]] = re.findall(r'^\s*dw\s+(\w+)', match[2], re.M)
    keys = ['EvosAttacksPointers1', 'EvosAttacksPointers1C', 'EvosAttacksPointers1B', 'EvosAttacksPointers2', 'EvosAttacksPointers2D', 'EvosAttacksPointers2E', 'EvosAttacksPointers2B', 'EvosAttacksPointers2C']
    sequence = sum((tables[k] for k in keys), [])
    by_label = {label: levels[c] for c, label in zip(order, sequence)}
    for path in paths:
        text = path.read_text(encoding='utf-8')
        def replace(match):
            label, body = match.groups()
            old = [(int(lv), m) for lv, m in re.findall(r'^\s*dbw\s+(\d+),\s*(\w+)', body, re.M)]
            if old == by_label[label]:
                return match[0]
            body = re.sub(r'^\tdbw\s+\d+,\s*\w+[^\n]*\n', '', body, flags=re.M)
            rows = ''.join(f'\tdbw {lv}, {m}\n' for lv, m in by_label[label])
            return label + ':\n' + body.replace('\tdb 0 ; no more level-up moves', rows + '\tdb 0 ; no more level-up moves')
        updated = re.sub(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)', replace, text, flags=re.M | re.S)
        if updated != text:
            path.write_text(updated, encoding='utf-8')


def report(receipt, data):
    info = profiles(data)
    changes = receipt['changes']
    cut = sum(e['after'] is None for ms in changes.values() for e in ms.values())
    delayed = sum(e['after'] is not None for ms in changes.values() for e in ms.values())
    lines = ['# Attacking learnset review', '', f'{len(receipt["reviewed"])} roster entries reviewed. '
             f'{len(changes)} have edits: {cut} attacks/setup options moved out of natural progression; {delayed} delayed moves.', '',
             'All original level-1 moves, evolution methods and evolution rewards are unchanged. '
             'Viable mixed attackers retain both categories. Early moves and useful priority, pivoting, debuffs, '
             'fixed damage, Body Press and ability interactions are preserved. Optional acquisition routes remain available.', '',
             'These are level-up changes. TM/HM compatibility and family egg lists are retained.', '']
    for c, ms in changes.items():
        p = info[c]
        lines += [f'## {c}', '', f'{"/".join(p["types"])}; Attack {p["stats"][1]}, Special Attack {p["stats"][4]}; '
                  f'{", ".join(p["abilities"])}. Review: {p["role"]}.', '']
        for move, e in ms.items():
            route = 'optional teaching/breeding routes' if e['after'] is None else f'Lv. {e["after"]}'
            lines.append(f'- {move}: Lv. {e["before"]} → {route}. {e["reason"]}')
        lines.append('')
    lines += ['## Reviewed without changes', '', ', '.join(c for c in receipt['reviewed'] if c not in changes), '']
    (ROOT / 'docs/attacking-learnset-review.md').write_text('\n'.join(lines), encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if PATH.exists():
        receipt = json.loads(PATH.read_text(encoding='utf-8'))
        data = breeding_data()
        apply_overlay(data[1], receipt['changes'])
    else:
        receipt, data = plan()
    cuts = sum(e['after'] is None for ms in receipt['changes'].values() for e in ms.values())
    delays = sum(e['after'] is not None for ms in receipt['changes'].values() for e in ms.values())
    print(f'Reviewed {len(data[0])}; changed {len(receipt["changes"])}; trims {cuts}; delays {delays}.')
    if args.apply:
        PATH.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
        write_levels(data[0], data[1])
        from restore_blackthorn_move_access import main as restore
        restore()
        report(receipt, data)
    else:
        output = ROOT / '_artifacts/attacking-learnset-plan.json'
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
        for c, ms in receipt['changes'].items():
            if not c.endswith('_CLONE'):
                print(c, ', '.join(f'{m} {e["before"]}->{e["after"]}' for m, e in ms.items()))


if __name__ == '__main__':
    main()

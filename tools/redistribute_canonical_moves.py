#!/usr/bin/env python3
"""Replace the rejected catch-all tutor with sourced and thematic learnsets.

Official egg eligibility is retained. Natural level sources take priority.
Machine/tutor candidates require a documented theme and are limited to eight
scored extra moves per species, plus named family fixes. The remaining
historical possibilities stay reviewable.
"""
import argparse
from collections import Counter
from copy import deepcopy
import json
import re

from audit_breeding_moves import breeding_data, routes, UTILITY
from audit_learnset_variety import ROOT, read
from audit_canonical_learnsets import RECEIPT, reference, canonical_pools, species_key
from lumi_learnsets.gen_learnsets import MOVE_MAP

FORCED_LEVELS = {'ARON': {'BODY_PRESS': 32}, 'LAIRON': {'BODY_PRESS': 38},
                 'AGGRON': {'BODY_PRESS': 44}}
# These are broad historical compatibility or low-value legacy options, not
# automatic natural additions. Existing authored access is never removed.
REVIEW_ONLY = {'MIMIC', 'FRUSTRATION', 'DOUBLE_TEAM', 'SNORE', 'MEGA_PUNCH',
               'MEGA_KICK', 'DYNAMICPUNCH', 'BIDE', 'RAGE', 'HEADBUTT',
               'DEFENSE_CURL', 'SWIFT', 'AERIAL_ACE', 'CUT', 'FURY_CUTTER',
               'ENDURE', 'ATTRACT', 'RETURN', 'HIDDEN_POWER', 'RAZOR_WIND',
               'AIR_CUTTER', 'BUBBLEBEAM'}
THEMES = {
    'BODY_PRESS': ({'Fighting', 'Rock', 'Steel'}, 'defensive body/armor'),
    'IRON_DEFENSE': ({'Rock', 'Steel'}, 'armor and defensive typing'),
    'ROCK_POLISH': ({'Rock', 'Steel'}, 'stone or metal body'),
    'STEALTH_ROCK': ({'Rock', 'Ground'}, 'rock/ground hazards'),
    'SPIKES': ({'Ground', 'Rock', 'Steel'}, 'spined or rocky hazards'),
    'TOXIC_SPIKES': ({'Poison'}, 'poison hazards'),
    'STICKY_WEB': ({'Bug'}, 'web-spinning bug'),
    'ROOST': ({'Flying'}, 'flying recovery'),
    'TAILWIND': ({'Flying'}, 'wing and wind support'),
    'DEFOG': ({'Flying'}, 'wing and wind support'),
    'TRICK': ({'Psychic', 'Ghost'}, 'psychic/ghost manipulation'),
    'TRICK_ROOM': ({'Psychic', 'Ghost'}, 'psychic/ghost manipulation'),
    'SKILL_SWAP': ({'Psychic'}, 'psychic manipulation'),
    'NASTY_PLOT': ({'Dark', 'Psychic', 'Ghost'}, 'cunning special-attacker setup'),
    'CALM_MIND': ({'Psychic', 'Fairy'}, 'mental special-attacker setup'),
    'WILL_O_WISP': ({'Fire', 'Ghost'}, 'fire or spectral status'),
    'SPITE': ({'Dark', 'Ghost'}, 'spiteful or spectral status'),
    'HEAT_WAVE': ({'Fire', 'Flying'}, 'fire or wing-driven heat'),
    'EARTH_POWER': ({'Rock', 'Ground', 'Steel', 'Fire'}, 'earth/rock/metal force'),
    'BULLDOZE': ({'Ground', 'Rock', 'Steel'}, 'grounded heavy-body attack'),
    'ROCK_BLAST': ({'Rock'}, 'rock projectile attack'),
    'STONE_EDGE': ({'Rock'}, 'strong rock attack'),
    'DRAGON_TAIL': ({'Dragon'}, 'dragon tail attack'),
    'DRAGON_DANCE': ({'Dragon'}, 'physical dragon setup'),
    'DARK_PULSE': ({'Dark', 'Ghost'}, 'dark or spectral special attack'),
    'FOUL_PLAY': ({'Dark'}, 'dark trickery'),
    'GUNK_SHOT': ({'Poison'}, 'concentrated poison attack'),
    'SEED_BOMB': ({'Grass'}, 'plant projectile attack'),
    'POWER_WHIP': ({'Grass'}, 'vine or plant attack'),
    'SOLAR_BLADE': ({'Grass'}, 'plant blade attack'),
    'WATER_PULSE': ({'Water'}, 'water pulse attack'),
    'SCALD': ({'Water'}, 'heated water attack'),
    'SIGNAL_BEAM': ({'Bug', 'Electric', 'Psychic'}, 'bug/light/psychic beam'),
    'AURA_SPHERE': ({'Fighting', 'Psychic'}, 'fighting or psychic aura'),
}


def metadata(data):
    order, levels, *_ = data
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    result = {}
    for c, file in zip(order, files):
        text = read(file)
        stats = list(map(int, re.search(r'^\s*db\s+(\d+(?:\s*,\s*\d+){5})', text, re.M)[1].replace(' ', '').split(',')))
        types = set(re.search(r'^\s*db\s+(\w+),\s*(\w+)\s*;\s*type', text, re.M).groups())
        result[c] = {'types': {s.title() for s in types}, 'stats': stats,
                     'moves': {m for _, m in levels[c]},
                     'monster': 'EGG_MONSTER' in text}
    move_data = {m['const']: m for m in json.loads((ROOT/'docs/data/moves.json').read_text(encoding='utf-8'))}
    return result, move_data


def theme(c, move, info, m):
    p = info[c]
    hp, atk, defense, speed, spa, spd = p['stats']
    types = p['types']
    category = m['category']
    if move in REVIEW_ONLY:
        return None
    if category == 'Physical' and move not in {'BODY_PRESS', 'FOUL_PLAY'} and atk < spa * .72:
        return None
    if category == 'Special' and spa < atk * .65:
        return None
    if move == 'BODY_PRESS' and c == 'MEW':
        return None
    if move == 'BODY_PRESS' and defense >= 80:
        return 150, 'canonical Body Press compatibility and defensive build'
    if move in THEMES and types & THEMES[move][0]:
        if move == 'NASTY_PLOT' and spa < atk * .8:
            return None
        if move == 'CALM_MIND' and spa < atk * .8:
            return None
        return 115, THEMES[move][1]
    if move in {'AQUA_TAIL', 'DRAGON_TAIL'} and p['moves'] & {'IRON_TAIL', 'TAIL_WHIP', 'AQUA_TAIL', 'DRAGON_TAIL'}:
        return 100, 'established natural tail attacks'
    if move == 'SWORDS_DANCE' and atk >= 70 and any(
            any(part in known for part in ['SLASH', 'CLAW', 'CUT', 'BLADE']) for known in p['moves']):
        return 120, 'physical blade/claw setup'
    if move == 'BULK_UP' and atk >= 75 and (types & {'Fighting'} or defense >= 90):
        return 110, 'bulky physical-attacker setup'
    if move in {'SUPERPOWER', 'BRICK_BREAK', 'CLOSE_COMBAT', 'LOW_KICK'} and atk >= 90 and (
            types & {'Fighting'} or (p['monster'] and defense >= 75)):
        return 100 + (10 if move == 'SUPERPOWER' else 0), 'canonical coverage for a powerful physical brawler'
    if move == 'ZEN_HEADBUTT' and atk >= 70 and p['moves'] & {'HEADBUTT', 'ZEN_HEADBUTT'}:
        return 95, 'established natural headbutt attacks'
    if move == 'OUTRAGE' and atk >= 100 and p['moves'] & {'THRASH', 'DRAGON_CLAW', 'DRAGON_RUSH'}:
        return 100, 'established rampage or dragon attacks'
    if m['type'] in types and category != 'Status' and (m.get('power') or 0) >= 60:
        return 90 + min(20, (m.get('power') or 0) // 6), 'matching type and attacking role'
    return None


def custom_level(move, m, rows):
    # Custom placements are explicitly design choices, not canonical levels.
    power = m.get('power') or 0
    if move in {'ROCK_POLISH', 'BULK_UP', 'SWORDS_DANCE', 'NASTY_PLOT', 'CALM_MIND'}:
        start = 30
    elif move in {'ROOST', 'TAILWIND', 'DEFOG', 'TRICK', 'SKILL_SWAP', 'SPIKES', 'STEALTH_ROCK', 'TOXIC_SPIKES'}:
        start = 34
    elif move in {'BODY_PRESS', 'FOUL_PLAY', 'VOLT_SWITCH'}:
        start = 38
    elif power >= 120:
        start = 56
    elif power >= 100:
        start = 50
    elif power >= 80:
        start = 42
    elif move == 'ROCK_BLAST':
        start = 34
    elif power > 0:
        start = 18 if power <= 65 else 26
    else:
        start = 34
    occupied = Counter(lv for lv, _ in rows)
    # Allow at most two moves at one new level, and avoid adjacent unlock spam.
    for lv in range(start, 76, 2):
        if occupied[lv] == 0:
            return lv
    return min(range(start, 81), key=lambda lv: (occupied[lv], lv))


def make_plan():
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = deepcopy(breeding_data())
    order, levels, tms, eggs, parents, utility, groups, genders, roots = data
    info, moves = metadata(data)
    learnsets, dex, _ = reference()
    canonical = canonical_pools(order, learnsets, dex)
    mapping = {re.sub('[^a-z0-9]', '', m.lower()): m for m in moves}
    mapping.update({k: v for k, v in MOVE_MAP.items() if v in moves})
    archive = receipt.get('retired_technical_tutor', receipt['changes']['technical_tutor'])
    natural, themed, reasons = {}, {}, {}
    breeding = json.loads((ROOT/'tools/testdata/breeding_moves.json').read_text(encoding='utf-8'))
    forbidden = deepcopy(breeding['level_up_removals'])
    authored = json.loads((ROOT/'tools/testdata/learnset_variety_implementation.json').read_text(encoding='utf-8'))
    for c, ms in authored.get('level_up_removals', {}).items():
        forbidden.setdefault(c, []).extend(ms)
    # Restore true modern natural sources, even when a TM/egg route also exists.
    for c, pool in canonical.items():
        if c.endswith('_CLONE'):
            continue
        own = {m for _, m in levels[c]}
        for key, sources in pool.items():
            move = mapping.get(key)
            if not move or move in own or move in forbidden.get(c, []):
                continue
            sources = [s['source'] for s in sources if s['species'] == species_key(c)
                       and re.match(r'^[6-9]L\d+$', s['source'])]
            if not sources:
                continue
            generation = max(int(s[0]) for s in sources)
            lv = max(1, min(int(s[2:]) for s in sources if int(s[0]) == generation))
            levels[c].append((lv, move)); own.add(move)
            natural.setdefault(c, {})[move] = lv
            reasons.setdefault(c, {})[move] = 'canonical natural level-up: ' + ', '.join(s for s in sources if int(s[0]) == generation)
    # Prefer existing breeding/TM access. Select at most eight extra thematic
    # lessons per species, rather than transplanting every historical TM.
    for c, candidates in archive.items():
        if c.endswith('_CLONE'):
            continue
        own = {m for _, m in levels[c]}
        direct = own | set(tms[c]) | set(eggs[c]) | {m for i, m in enumerate(UTILITY) if utility[c] & (1 << i)}
        scored = []
        for move in candidates:
            if move in direct or move in forbidden.get(c, []):
                continue
            sources = [s for key, ss in canonical[c].items() if mapping.get(key) == move
                       for s in ss if s['species'] == species_key(c)]
            if not any(s['source'][1] in 'MTV' for s in sources):
                continue # pure gifts/events are not silently made natural
            result = theme(c, move, info, moves[move])
            if result:
                score, reason = result
                recent = max(int(s['source'][0]) for s in sources)
                scored.append((score, recent, move, reason))
        for _, _, move, reason in sorted(scored, key=lambda row: (-row[0], -row[1], row[2]))[:8]:
            lv = custom_level(move, moves[move], levels[c])
            levels[c].append((lv, move))
            themed.setdefault(c, {})[move] = lv
            reasons.setdefault(c, {})[move] = reason
    for c, placements in FORCED_LEVELS.items():
        for move, lv in placements.items():
            if not any(m == move for _, m in levels[c]):
                levels[c].append((lv, move))
                themed.setdefault(c, {})[move] = lv
                reasons.setdefault(c, {})[move] = 'armored defensive family; Body Press follows Iron Defense'
    # Mirror the actual clone learnsets after every placement layer.
    for c in order:
        if c.endswith('_CLONE'):
            original = c[:-6]
            levels[c][:] = levels[original]
            for dest in [natural, themed, reasons]:
                if original in dest:
                    dest[c] = deepcopy(dest[original])
        levels[c].sort(key=lambda row: row[0])
    # Repair missing donors without a tutor seed. Prefer a real canonical
    # natural donor in the roster before falling back on the hatchling.
    known = routes(data, technical={})
    fallbacks = {}
    missing_eggs = [(c, m) for c in sorted(set(roots.values())) for m in eggs[c] if m not in known[c]]
    for c, move in missing_eggs:
        if not any(m == move for _, m in levels[c]):
            levels[c].append((30, move)); levels[c].sort(key=lambda row: row[0])
            fallbacks.setdefault(c, {})[move] = 30
            reasons.setdefault(c, {})[move] = 'canonical egg move with no compatible independent donor in this roster'
    for c in order:
        if c.endswith('_CLONE'):
            levels[c][:] = levels[c[:-6]]
            if c[:-6] in fallbacks:
                fallbacks[c] = deepcopy(fallbacks[c[:-6]])
    return data, receipt, natural, themed, fallbacks, reasons, archive


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    existing = json.loads(RECEIPT.read_text(encoding='utf-8'))
    if existing.get('distribution_revision'):
        if args.apply:
            parser.error('Redistribution is already applied; recorded placements are preserved by the learnset generator.')
        print('Thematic/breeding redistribution is already applied.')
        print('Recorded additions:', {k: sum(map(len, ms.values())) for k, ms in existing['changes'].items()})
        print('Historical review candidates:', sum(map(len, existing.get('deferred_moves', {}).values())))
        return
    data, receipt, natural, themed, fallbacks, reasons, archive = make_plan()
    print('Canonical natural additions:', sum(map(len, natural.values())))
    print('Thematic level-up additions:', sum(map(len, themed.values())))
    print('New independent breeding fallbacks:', sum(map(len, fallbacks.values())))
    print('Largest level-up list:', max((len(ms), c) for c, ms in data[1].items()))
    for c in ['ARON', 'LAIRON', 'AGGRON', 'MEW', 'BLASTOISE', 'GENGAR', 'TYRANITAR']:
        print(c, 'natural:', natural.get(c, {}), 'themed:', themed.get(c, {}))
    result = {'natural': natural, 'thematic': themed, 'donor_fallbacks': fallbacks, 'reasons': reasons}
    out = ROOT/'_ai_artifacts/canonical-redistribution-plan.json'
    out.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    if args.apply:
        apply_plan(data, receipt, natural, themed, fallbacks, reasons, archive)


def apply_plan(data, receipt, natural, themed, fallbacks, reasons, archive):
    order, levels, *_ = data
    assert not receipt.get('distribution_revision'), 'Redistribution already applied; edit the recorded placements instead.'
    paths = [ROOT/'data/pokemon'/f'evos_attacks_{s}.asm' for s in ['kanto', 'johto', 'clones']]
    tables = {}
    for path in paths:
        for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)', path.read_text(encoding='utf-8'), re.M):
            tables[m[1]] = re.findall(r'^\s*dw\s+(\w+)', m[2], re.M)
    sequence = sum((tables[name] for name in ['EvosAttacksPointers1','EvosAttacksPointers1C','EvosAttacksPointers1B','EvosAttacksPointers2','EvosAttacksPointers2D','EvosAttacksPointers2E','EvosAttacksPointers2B','EvosAttacksPointers2C']), [])
    rows = {label: levels[c] for c, label in zip(order, sequence)}
    for path in paths:
        text = path.read_text(encoding='utf-8')
        def update(match):
            label, body = match.groups()
            if label not in rows:
                return match[0]
            old = [(int(lv), m) for lv, m in re.findall(r'^\s*dbw\s+(\d+),\s*(\w+)', body, re.M)]
            if old == rows[label]:
                return match[0]
            body = re.sub(r'^\tdbw[^\n]*\n', '', body, flags=re.M)
            insert = ''.join(f'\tdbw {lv}, {m}\n' for lv, m in rows[label])
            body, count = re.subn(r'(^\s*db 0 ; no more level-up moves)', lambda m: insert+m[1], body, count=1, flags=re.M)
            assert count == 1, label
            return label+':\n'+body
        updated = re.sub(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)', update, text, flags=re.M|re.S)
        if updated != text:
            path.write_text(updated, encoding='utf-8')
    breeding_path = ROOT/'tools/testdata/breeding_moves.json'
    breeding = json.loads(breeding_path.read_text(encoding='utf-8'))
    for c, ms in fallbacks.items():
        breeding['fallbacks'].setdefault(c, {}).update(ms)
    # The user explicitly allows thematic level-up/egg overlaps. Keep an
    # audit trail when that overrides the previous egg-only curation.
    for c, ms in themed.items():
        previous = breeding['level_up_removals'].get(c, [])
        promoted = {m: ms[m] for m in previous if m in ms}
        if promoted:
            breeding.setdefault('thematic_level_up_overrides', {}).setdefault(c, {}).update(promoted)
            breeding['level_up_removals'][c] = [m for m in previous if m not in promoted]
    breeding_path.write_text(json.dumps(breeding, indent=2)+'\n', encoding='utf-8')
    receipt['retired_technical_tutor'] = archive
    receipt['changes']['technical_tutor'] = {}
    for c, ms in natural.items():
        receipt['changes']['level_up'].setdefault(c, {}).update(ms)
    receipt['changes']['thematic_level_up'] = themed
    for c, ms in fallbacks.items():
        receipt['changes']['donor_fallbacks'].setdefault(c, {}).update(ms)
    receipt['distribution_revision'] = 'thematic-level-up-and-canonical-breeding'
    receipt['placement_reasons'] = reasons
    receipt['policy'] = ('User-directed curation: no catch-all Goldenrod tutor. Keep official egg lists and existing machine compatibility. '
                         'Restore sourced natural moves, add a limited number of theme-appropriate level moves, and prove independent egg donors. '
                         'Custom levels are design choices. Historical/event compatibility without a suitable route remains explicitly deferred.')
    # The runtime no longer sees this table. Keeping its contents in the JSON
    # preserves the original findings without enabling a universal NPC.
    (ROOT/'data/pokemon/technical_tutor.asm').unlink()
    known = {c: set(ms) | set(data[3][c]) for c, ms in routes(data, technical={}).items()}
    for c in ['DRATINI','DRAGONAIR','DRAGONITE']:
        known[c].add('EXTREMESPEED')
    for _ in order:
        changed = False
        for c in order:
            before = len(known[c])
            for p in data[4][c]:
                known[c].update(known[p])
            changed |= before != len(known[c])
        if not changed:
            break
    receipt['deferred_moves'] = {c: sorted(set(ms)-known[c]) for c, ms in receipt['expected'].items() if set(ms)-known[c]}
    RECEIPT.write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8')
    print('Applied redistribution. Deferred historical candidates:', sum(map(len, receipt['deferred_moves'].values())))


if __name__ == '__main__':
    main()

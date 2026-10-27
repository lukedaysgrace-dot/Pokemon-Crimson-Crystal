#!/usr/bin/env python3
"""Distribute Grass Knot and Heavy Slam to their modern learners, and audit it.

Default: audit the checked-in receipt against the ROM sources (offline).
--apply: plan from the pinned Smogon reference (tools/lumi_learnsets/cache/
smogon-sv, the same pre-Z-A revision as tools/testdata/canonical_learnsets.json)
plus the cached Luminescent 3.0 level-up tables, then write the placements.

Policy (the October 2026 move-expansion rules):
- Recipients are exactly the roster entries whose canonical pool (own form
  plus pre-evolutions, Gen I-IX through the SV DLC) contains the move.
- Lumi direct level-up schedules take priority; the species' own most recent
  Smogon level-up source fills gaps. Level 0/1 (reminder) sources are taught
  by the tutor, because the attacking-learnset review freezes level-1 rows.
- A root species with a canonical egg source gets the move in its family egg
  list when a real breeding donor exists in this ROM.
- Everything else is taught by the existing Blackthorn fallback tutor
  (regenerate with tools/restore_blackthorn_move_access.py afterwards).
Lumi-only placements that are not canonical modern learners are not added.
"""
import argparse
import json
import re
import sys
from pathlib import Path

from audit_breeding_moves import breeding_data, routes
from audit_canonical_learnsets import RECEIPT as CANONICAL, available, species_key
from audit_learnset_variety import ROOT, load_technical_tutors

RECEIPT = ROOT / 'tools/testdata/weight_moves_20261022.json'
MOVES = {'GRASS_KNOT': 'Grass Knot', 'HEAVY_SLAM': 'Heavy Slam'}
SMOGON_ID = {'GRASS_KNOT': 'grassknot', 'HEAVY_SLAM': 'heavyslam'}
EVOS = ['data/pokemon/evos_attacks_kanto.asm', 'data/pokemon/evos_attacks_johto.asm',
        'data/pokemon/evos_attacks_clones.asm']
EGGS = ['data/pokemon/egg_moves_kanto.asm', 'data/pokemon/egg_moves_johto.asm']


def lumi_dexid(lumi, g, c):
    base = c.removesuffix('_CLONE')
    match = re.match(r'(\w+?)_(ALOLAN|GALARIAN|HISUIAN|PALDEAN_FIRE|PALDEAN_WATER|PALDEAN)$', base)
    tag = None
    if match:
        base = match[1]
        tag = {'ALOLAN': 'alola', 'GALARIAN': 'galar', 'HISUIAN': 'hisui'}.get(match[2], 'paldea')
    monsno = lumi.name_to_monsno.get(g.norm_name(base.replace('_', '')))
    if monsno is None:
        return None
    if tag is None:
        return lumi.form_map.get(monsno, [monsno])[0]
    return lumi.form_index.get((monsno, tag))


def evos_label(c):
    """EvosAttacks label for species constant c, following the pointer tables."""
    order = breeding_data()[0]
    sequence = []
    tables = {}
    for f in EVOS:
        text = (ROOT / f).read_text(encoding='utf-8')
        for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)', text, re.M):
            tables[m[1]] = re.findall(r'^\s*dw\s+(\w+)', m[2], re.M)
    for name in ['EvosAttacksPointers1', 'EvosAttacksPointers1C', 'EvosAttacksPointers1B',
                 'EvosAttacksPointers2', 'EvosAttacksPointers2D', 'EvosAttacksPointers2E',
                 'EvosAttacksPointers2B', 'EvosAttacksPointers2C']:
        sequence += tables[name]
    return dict(zip(order, sequence))[c]


def insert_level(c, move, level):
    label = evos_label(c)
    for f in EVOS:
        path = ROOT / f
        text = path.read_text(encoding='utf-8')
        m = re.search(rf'^{label}:\n(.*?)^\tdb 0 ; no more level-up moves\n', text, re.M | re.S)
        if not m:
            continue
        body = m[1]
        assert not re.search(rf'dbw \d+, {move}\s*$', body, re.M), (c, move, 'already learned')
        lines = body.split('\n')
        index = len(lines) - 1  # before the trailing '' left by the split
        for i, line in enumerate(lines):
            lm = re.match(r'\tdbw (\d+), ', line)
            if lm and int(lm[1]) > level:
                index = i
                break
        lines.insert(index, f'\tdbw {level}, {move}')
        text = text[:m.start(1)] + '\n'.join(lines) + text[m.end(1):]
        path.write_text(text, encoding='utf-8')
        return
    raise AssertionError((c, label, 'learnset block not found'))


def add_egg(c, move):
    for f in EGGS:
        path = ROOT / f
        text = path.read_text(encoding='utf-8')
        pointer = re.search(rf'^\s*dw\s+(\w+)\s*;\s*{c}\s*$', text, re.M)
        if not pointer:
            continue
        label = pointer[1]
        assert not label.startswith('NoEggMoves'), (c, 'no egg list to extend')
        uses = len(re.findall(rf'^\s*dw\s+{label}\s*;', text, re.M))
        assert uses == 1, (c, label, 'shared egg list')
        m = re.search(rf'^{label}:\n(.*?)^\tdw -1 ; end\n', text, re.M | re.S)
        assert m and f'\tdw {move}\n' not in m[1], (c, move)
        text = text[:m.end(1)] + f'\tdw {move}\n' + text[m.end(1):]
        path.write_text(text, encoding='utf-8')
        return
    raise AssertionError((c, 'egg pointer not found'))


def plan():
    sys.path.insert(0, str(ROOT / 'tools/lumi_learnsets'))
    import gen_learnsets as g
    from audit_canonical_learnsets import analyze
    data, canonical, mapping, names, missing, unsupported = analyze()
    order, levels, *_ = data
    roots = data[-1]
    lumi = g.Lumi()
    lumi.load()
    required, level_up, eggs, evidence = {}, {}, {}, {}
    for c in order:
        for move, name in MOVES.items():
            if move not in missing.get(c, {}):
                continue
            sources = missing[c][move]
            required.setdefault(c, []).append(move)
            evidence.setdefault(c, {})[move] = [
                {'reference': 'Smogon', 'species': s['species'], 'source': s['source']}
                for s in sorted(sources, key=lambda s: (s['species'], s['source']), reverse=True)]
            if c.endswith('_CLONE'):
                continue  # clones mirror their base species below
            dexid = lumi_dexid(lumi, g, c)
            lumi_levels = [lv for lv, m in (lumi.learnset_by_dexid(dexid) if dexid is not None else [])
                           if m == name]
            own = [s['source'] for s in sources if s['species'] == species_key(c)]
            smogon_levels = sorted(((int(s[0]), int(s[2:])) for s in own if s[1] == 'L'), reverse=True)
            # The attacking-learnset review freezes every level-1 row
            # (tools/audit_attacking_learnsets.py), so a level-0/1 (move
            # reminder) source is taught by the Blackthorn tutor instead.
            lumi_levels = [lv for lv in lumi_levels if lv > 1]
            smogon_levels = [(gen, lv) for gen, lv in smogon_levels if lv > 1][:1] if smogon_levels and smogon_levels[0][1] > 1 else []
            if lumi_levels:
                level_up.setdefault(c, {})[move] = lumi_levels[0]
                evidence[c][move].append({'reference': 'Lumi', 'species': c, 'source': f'L{lumi_levels[0]}',
                                          'dexid': dexid})
            elif smogon_levels:
                level_up.setdefault(c, {})[move] = smogon_levels[0][1]
            elif roots[c] == c and any(s[1] == 'E' for s in own):
                eggs.setdefault(c, []).append(move)
    for c in order:
        if c.endswith('_CLONE'):
            base = c[:-6]
            if base in level_up:
                level_up[c] = dict(level_up[base])
    return data, required, level_up, eggs, evidence


def apply():
    data, required, level_up, eggs, evidence = plan()
    for c, moves in level_up.items():
        for move, level in moves.items():
            insert_level(c, move, level)
    # Keep only egg placements with a real donor proof (the egg tutor is not a
    # donor). The Blackthorn fallback teaches any recipient without one.
    proven = {}
    for c, moves in eggs.items():
        for move in moves:
            add_egg(c, move)
    fresh = breeding_data()
    known = routes(fresh)
    for c, moves in eggs.items():
        for move in moves:
            if move in known[c]:
                proven.setdefault(c, []).append(move)
    unproven = {c: [m for m in ms if m not in proven.get(c, [])] for c, ms in eggs.items()}
    for c, moves in unproven.items():
        for move in moves:
            for f in EGGS:
                path = ROOT / f
                text = path.read_text(encoding='utf-8')
                label = re.search(rf'^\s*dw\s+(\w+)\s*;\s*{c}\s*$', text, re.M)
                if label:
                    m = re.search(rf'^{label[1]}:\n(.*?)^\tdw -1 ; end\n', text, re.M | re.S)
                    body = m[1].replace(f'\tdw {move}\n', '', 1)
                    path.write_text(text[:m.start(1)] + body + text[m.end(1):], encoding='utf-8')
    receipt = {
        'moves': list(MOVES),
        'smogon_revision': json.loads(CANONICAL.read_text(encoding='utf-8'))['source']['revision'],
        'lumi_revision': '45319ae889acf8b83ea012f65a2aa2a519693524',
        'policy': __doc__.split('Policy', 1)[1].strip(),
        'required': required,
        'level_up': level_up,
        'new_egg_moves': proven,
        'egg_sources_taught_by_tutor': {c: ms for c, ms in unproven.items() if ms},
        'evidence': evidence,
        'mechanics': {
            'LOW_KICK': 'Power 20/40/60/80/100/120 from target weight (<10/25/50/100/200 kg); no flinch',
            'GRASS_KNOT': 'Special Grass, contact; power from target weight like Low Kick',
            'HEAVY_SLAM': 'Physical Steel, contact; power 40/60/80/100/120 when user >= 2x/3x/4x/5x target weight; '
                          'double damage and no accuracy check against a minimized target',
            'HEAT_CRASH': 'Physical Fire, contact; Heavy Slam formula and Minimize interaction; no burn chance',
        },
    }
    RECEIPT.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
    canonical = json.loads(CANONICAL.read_text(encoding='utf-8'))
    for c, moves in required.items():
        canonical['expected'][c] = sorted(set(canonical['expected'].get(c, [])) | set(moves))
        for move in moves:
            selected = {}
            for s in sorted((e for e in evidence[c][move] if e['reference'] == 'Smogon'),
                            key=lambda e: e['source'], reverse=True):
                selected.setdefault(s['source'][1], f"Smogon:{s['species']}:{s['source']}")
            canonical['provenance'].setdefault(c, {})[move] = list(selected.values())
    for c in list(canonical['unimplemented_moves']):
        canonical['unimplemented_moves'][c] = [m for m in canonical['unimplemented_moves'][c]
                                               if m not in MOVES.values()]
    canonical['supplemental_sources']['WEIGHT_MOVES_2026'] = {
        'name': 'Grass Knot and Heavy Slam (weight-based moves)',
        'receipt': 'tools/testdata/weight_moves_20261022.json',
        'smogon_revision': receipt['smogon_revision'],
        'lumi_revision': receipt['lumi_revision'],
    }
    CANONICAL.write_text(json.dumps(canonical, indent=2) + '\n', encoding='utf-8')
    print('Recipients:', sum(map(len, required.values())), 'pairs;',
          'level-up:', sum(map(len, level_up.values())), ';',
          'egg:', sum(map(len, proven.values())), ';',
          'egg sources left to the tutor:', {c: ms for c, ms in unproven.items() if ms})


def audit():
    from historical_move_access import review as historical_review, removed
    from attacking_learnsets import check_level
    history = historical_review()
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = breeding_data()
    order, levels, _, eggs, parents, *_ = data
    known = available(data)
    technical = load_technical_tutors()
    canonical = json.loads(CANONICAL.read_text(encoding='utf-8'))
    rows = {}
    for line in (ROOT / 'data/moves/moves.asm').read_text(encoding='utf-8').splitlines():
        match = re.match(r'\s*move (.*?);(\w+)$', line)
        if match:
            rows[match[2]] = [token.strip() for token in match[1].split(',')]
    expected_rows = {
        'LOW_KICK': ['EFFECT_LOW_KICK', '1', 'FIGHTING', 'CATEGORIZE_PHYSICAL', '100', '20', '0'],
        'GRASS_KNOT': ['EFFECT_LOW_KICK', '1', 'GRASS', 'CATEGORIZE_SPECIAL', '100', '20', '0'],
        'HEAVY_SLAM': ['EFFECT_HEAVY_SLAM', '1', 'STEEL', 'CATEGORIZE_PHYSICAL', '100', '10', '0'],
        'HEAT_CRASH': ['EFFECT_HEAVY_SLAM', '1', 'FIRE', 'CATEGORIZE_PHYSICAL', '100', '10', '0'],
    }
    for move, row in expected_rows.items():
        assert rows[move] == row, (move, rows[move])
    pairs = 0
    for c in order:
        for move in MOVES:
            should = move in (history['expected'].get(c, []) if history else receipt['required'].get(c, []))
            if should:
                assert move in known[c], (c, move, 'modern learner lacks access')
            elif move in known[c]:
                # Only Sketch or a move kept through evolution (custom
                # evolutions such as Jynx -> Mesmeria) may add other holders.
                assert c == 'SMEARGLE' or any(move in known[p] for p in parents[c]), \
                    (c, move, 'access beyond the modern learner list')
            reference = history if history else canonical
            assert (move in reference['expected'].get(c, [])) == should, (c, move, 'canonical receipt')
            pairs += should
    for c, moves in receipt['level_up'].items():
        for move, level in moves.items():
            check_level(c, move, level, levels)
    for c, moves in receipt['new_egg_moves'].items():
        assert set(moves) - removed(c, 'egg') <= set(eggs[c]), (c, 'egg placement')
    natural = {c: {m for _, m in levels[c]} for c in order}
    for c in order:
        for move in MOVES:
            if move in technical.get(c, []):
                assert move not in natural[c], (c, move, 'tutor duplicates a level-up move')
    print(f'WEIGHT MOVE AUDIT PASSED: {pairs} sourced learner pairs; '
          f'{sum(map(len, receipt["level_up"].values()))} level-up, '
          f'{sum(map(len, receipt["new_egg_moves"].values()))} breeding placements; '
          'move data and canonical receipt agree.')


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if args.apply:
        assert not RECEIPT.exists(), 'Already applied; run without --apply to audit.'
        apply()
    else:
        audit()


if __name__ == '__main__':
    main()

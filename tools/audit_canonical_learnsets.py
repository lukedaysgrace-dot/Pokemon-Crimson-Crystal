#!/usr/bin/env python3
"""Compare ROM acquisition routes with a pinned, pre-Z-A Smogon reference.

The reference is deliberately frozen after the SV DLC and before Z-A. Read
TypeScript data as text, never execute downloaded source. No third-party modules.
"""
import argparse
from collections import Counter
from copy import deepcopy
import json
from pathlib import Path
import re

from audit_breeding_moves import breeding_data, routes, UTILITY
from audit_learnset_variety import ROOT, read, load_technical_tutors
from lumi_learnsets.gen_learnsets import MOVE_MAP
from attacking_learnsets import check_level, review as attacking_review

CACHE = ROOT / 'tools/lumi_learnsets/cache/smogon-sv'
RECEIPT = ROOT / 'tools/testdata/canonical_learnsets.json'
CUSTOM = {'WATU', 'MESMERIA', 'KOTORA', 'RAITORA', 'GOROTORA', 'GOROCHU'}
ALIASES = {
    'TEDDIURSABM': 'teddiursa', 'URSARINGBM': 'ursaring',
    'URSALUNABM': 'ursalunabloodmoon',
    'TAUROS_PALDEAN_FIRE': 'taurospaldeablaze',
    'TAUROS_PALDEAN_WATER': 'taurospaldeaaqua',
}
norm = lambda s: re.sub('[^a-z0-9]', '', s.lower())


def blocks(text):
    return {(m[1] or m[2]): m[3] for m in re.finditer(
        r'^\t(?:"([a-z0-9]+)"|([a-z0-9]+)): \{\n(.*?)^\t\},?$',
        text, re.M | re.S)}


def reference():
    learnsets, dex, moves = {}, {}, {}
    for key, body in blocks((CACHE / 'learnsets.ts').read_text(encoding='utf-8')).items():
        match = re.search(r'^\t\tlearnset: \{\n(.*?)^\t\t\}', body, re.M | re.S)
        if match:
            learnsets[key] = {m[1]: json.loads(m[2]) for m in re.finditer(
                r'^\t\t\t([a-z0-9]+): (\[[^\n]+\]),', match[1], re.M)}
    for key, body in blocks((CACHE / 'pokedex.ts').read_text(encoding='utf-8')).items():
        dex[key] = dict(re.findall(r'^\t\t(name|prevo|baseSpecies|changesFrom): "([^"]+)"', body, re.M))
    for key, body in blocks((CACHE / 'moves.ts').read_text(encoding='utf-8')).items():
        name = re.search(r'^\t\tname: "([^"]+)"', body, re.M)
        if name:
            moves[key] = name[1]
    assert len(learnsets) > 1000 and len(dex) > 1000 and len(moves) > 800
    return learnsets, dex, moves


def species_key(c):
    c = c.removesuffix('_CLONE')
    key = ALIASES.get(c, norm(c))
    for a, b in [('alolan', 'alola'), ('galarian', 'galar'), ('hisuian', 'hisui'), ('paldean', 'paldea')]:
        key = key.replace(a, b)
    return key


def canonical_pools(order, learnsets, dex):
    result = {}
    for c in order:
        if c in CUSTOM:
            continue
        key = species_key(c)
        assert key in dex and key in learnsets, (c, key, 'unmapped official species')
        result[c] = {}
        seen = set()
        while key and key not in seen:
            seen.add(key)
            for move, sources in learnsets.get(key, {}).items():
                sources = [s for s in sources if re.match(r'^[1-9][LMTESVDR]', s)]
                if sources:
                    result[c].setdefault(move, []).extend({'species': key, 'source': s} for s in sources)
            key = norm(dex.get(key, {}).get('prevo', ''))
    return result


def available(data, technical=None):
    """Natural breeding/evolution plus family tutor, utility and shrine tutor."""
    order, levels, tms, eggs, parents, utility, *_ = data
    known = {c: set(ms) for c, ms in routes(data, technical=technical).items()}
    for c in order:
        known[c].update(eggs[c])
        if c in {'DRATINI', 'DRAGONAIR', 'DRAGONITE'}:
            known[c].add('EXTREMESPEED')
    for _ in order:
        changed = False
        for c in order:
            before = len(known[c])
            for p in parents[c]:
                known[c].update(known[p])
            changed |= len(known[c]) != before
        if not changed:
            break
    return known


def analyze():
    data = breeding_data()
    order = data[0]
    learnsets, dex, names = reference()
    canonical = canonical_pools(order, learnsets, dex)
    implemented = set(re.findall(r'^\s*move\s+.*?;\s*(\w+)\s*$', read('data/moves/moves.asm'), re.M))
    mapping = {norm(c): c for c in implemented}
    mapping.update({k: v for k, v in MOVE_MAP.items() if v in implemented})
    mapping.update({'vicegrip': 'VICEGRIP', 'visegrip': 'VICEGRIP', 'psychic': 'PSYCHIC_M', 'feintattack': 'FAINT_ATTACK'})
    known = available(data)
    missing, unsupported = {}, {}
    for c, pool in canonical.items():
        for move, sources in pool.items():
            if move not in mapping:
                unsupported.setdefault(c, []).append(names.get(move, move))
            elif mapping[move] not in known[c]:
                missing.setdefault(c, {})[mapping[move]] = sources
    return data, canonical, mapping, names, missing, unsupported


def plan(data, canonical, mapping):
    """Keep natural, breeding, current machines and supplemental teaching separate."""
    data = deepcopy(data)
    order, levels, tms, eggs, parents, utility, groups, genders, roots = data
    changes = {'level_up': {}, 'egg_moves': {}, 'tmhm': {}, 'technical_tutor': {}, 'donor_fallbacks': {}}
    # Each family has one real root egg list. Union historical breeding sources
    # without ever treating a move of an unrelated regional form as a source.
    for c, pool in canonical.items():
        for key, sources in pool.items():
            move = mapping.get(key)
            if move and any(s['source'][1] == 'E' for s in sources):
                root = roots[c]
                if move not in eggs[root]:
                    changes['egg_moves'].setdefault(root, []).append(move)
                    # load_sources returns distinct list objects for some aliases.
                    for member in order:
                        if roots[member] == root and move not in eggs[member]:
                            eggs[member].append(move)
    valid_tm = set(re.findall(r'^\s*add_(?:tm|hm|mt)\s+(\w+)', read('constants/item_constants.asm'), re.M))
    for c, pool in canonical.items():
        key = species_key(c)
        for m, sources in pool.items():
            move = mapping.get(m)
            if move in valid_tm and move not in tms[c] and any(
                    s['species'] == key and s['source'][1] in 'MTV' for s in sources):
                tms[c].append(move)
                changes['tmhm'].setdefault(c, []).append(move)
    # Add genuinely absent natural moves at the most recent documented level.
    # Evolution moves (L0) use level 1, as in the project's existing data format.
    known = available(data)
    for c, pool in canonical.items():
        for m, sources in pool.items():
            move = mapping.get(m)
            natural = [s['source'] for s in sources if s['species'] == species_key(c)
                       and s['source'][1] == 'L']
            if move and move not in known[c] and natural:
                generation = max(int(s[0]) for s in natural)
                level = max(1, min(int(s[2:]) for s in natural if int(s[0]) == generation))
                levels[c].append((level, move))
                levels[c].sort(key=lambda row: row[0])
                changes['level_up'].setdefault(c, {})[move] = level
    # Canonical machine/tutor/gift moves without a corresponding ROM machine
    # go to the existing teaching NPC, not into invented level-up/egg entries.
    technical = {c: [] for c in order}
    for c, pool in canonical.items():
        natural = {m for _, m in levels[c]} | set(tms[c])
        natural |= {m for i, m in enumerate(UTILITY) if utility[c] & (1 << i)}
        if c in {'DRATINI', 'DRAGONAIR', 'DRAGONITE'}:
            natural.add('EXTREMESPEED')
        for m, sources in pool.items():
            move = mapping.get(m)
            direct = [s for s in sources if s['species'] == species_key(c)]
            nonbreeding = any(s['source'][1] in 'MTVSDR' for s in direct)
            if move and nonbreeding and move not in natural:
                technical[c].append(move)
    # Preserve pre-evolution-only moves even where this ROM's custom evolution
    # tree differs from the official tree. Only reference-backed moves qualify.
    for c in order:
        if c.endswith('_CLONE'):
            original = c[:-6]
            levels[c][:] = levels[original]
            tms[c][:] = tms[original]
            technical[c] = list(technical[original])
            for field in ['level_up', 'tmhm']:
                if original in changes[field]:
                    changes[field][c] = deepcopy(changes[field][original])
    # The native breeding audit requires an independent donor. Supplemental
    # tutors are real acquisition seeds, unlike the egg tutor itself.
    known = available(data)
    for c in order:
        known[c].update(technical[c])
    for _ in order:
        changed = False
        for c in order:
            before = len(known[c])
            for p in parents[c]:
                known[c].update(known[p])
            changed |= len(known[c]) != before
        if not changed:
            break
    for c, pool in canonical.items():
        for m in pool:
            move = mapping.get(m)
            if move and move not in known[c]:
                technical[c].append(move)
    for c, ms in technical.items():
        if ms:
            changes['technical_tutor'][c] = sorted(set(ms))
    # Prove egg access without using the egg tutor as a circular seed. Where
    # the restricted roster has no donor, retain the project's level-30 policy.
    independent = routes(data, technical=technical)
    for c in sorted(set(roots.values())):
        for move in eggs[c]:
            if move not in independent[c]:
                levels[c].append((30, move))
                levels[c].sort(key=lambda row: row[0])
                changes['donor_fallbacks'].setdefault(c, {})[move] = 30
    return data, changes


def apply(data, canonical, mapping, changes, unsupported):
    order, levels, tms, eggs, *_ = data
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    for c, file in zip(order, files):
        if c not in changes['tmhm']:
            continue
        path = ROOT / file
        text = path.read_text(encoding='utf-8')
        text = re.sub(r'^\ttmhm[^\n]*', '\ttmhm ' + ', '.join(tms[c]), text, flags=re.M)
        path.write_text(text, encoding='utf-8')
    # Resolve species through the real pointer order, including nine clones.
    paths = [ROOT / ('data/pokemon/evos_attacks_' + s + '.asm') for s in ['kanto', 'johto', 'clones']]
    tables = {}
    for path in paths:
        for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)', path.read_text(encoding='utf-8'), re.M):
            tables[m[1]] = re.findall(r'^\s*dw\s+(\w+)', m[2], re.M)
    sequence = sum((tables[name] for name in ['EvosAttacksPointers1', 'EvosAttacksPointers1C', 'EvosAttacksPointers1B', 'EvosAttacksPointers2', 'EvosAttacksPointers2D', 'EvosAttacksPointers2E', 'EvosAttacksPointers2B', 'EvosAttacksPointers2C']), [])
    rows = {label: levels[c] for c, label in zip(order, sequence)
            if c in changes['level_up'] or c in changes['donor_fallbacks']}
    for path in paths:
        text = path.read_text(encoding='utf-8')
        def update(m):
            label, body = m.groups()
            if label not in rows:
                return m[0]
            old = re.findall(r'^\t(?:dbw\s+\d+,\s*\w+[^\n]*\n)', body, re.M)
            assert old, label
            body = re.sub(r'^\t(?:dbw\s+\d+,\s*\w+[^\n]*\n)', '', body, flags=re.M)
            insert = ''.join(f'\tdbw {lv}, {move}\n' for lv, move in rows[label])
            body, count = re.subn(r'(^\s*db 0 ; no more level-up moves)', lambda n: insert + n[1], body, count=1, flags=re.M)
            assert count == 1, label
            return label + ':\n' + body
        updated = re.sub(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)', update, text, flags=re.M | re.S)
        if updated != text:
            path.write_text(updated, encoding='utf-8')
    # Do not mutate shared NoEggMoves labels: give each newly fertile root an
    # independent list. Existing deliberate project moves are always retained.
    for path in [ROOT / 'data/pokemon/egg_moves_kanto.asm', ROOT / 'data/pokemon/egg_moves_johto.asm']:
        text = path.read_text(encoding='utf-8')
        additions = []
        for root in changes['egg_moves']:
            pattern = r'^(\s*dw\s+)(\w+)(\s*;\s*' + root + r'\s*)$'
            match = re.search(pattern, text, re.M)
            if not match:
                continue
            label = 'Canonical' + root + 'EggMoves'
            text = text[:match.start(2)] + label + text[match.end(2):]
            additions.append(label + ':\n' + ''.join(f'\tdw {m}\n' for m in eggs[root]) + '\tdw -1 ; end\n')
        if additions:
            path.write_text(text.rstrip() + '\n\n; Historical canonical breeding additions through SV.\n' + '\n'.join(additions), encoding='utf-8')
    technical = changes['technical_tutor']
    lines = ['; Generated by tools/audit_canonical_learnsets.py --apply.',
             '; Canonical machine/tutor/gift moves through Scarlet/Violet.',
             'SECTION "Technical Tutor Pointers", ROMX', 'TechnicalTutorPointers::']
    dedup, labels, groups = {}, {}, []
    for c in order:
        key = tuple(technical.get(c, []))
        if key not in dedup:
            label = 'TechnicalTutor_' + (c if key else 'None')
            dedup[key] = label
            groups.append((label, key))
        labels[c] = dedup[key]
        lines.append(f'\tdba {labels[c]} ; {c}')
    lines.append('assert (@ - TechnicalTutorPointers) == NUM_POKEMON * 3')
    for i, (label, moves) in enumerate(groups):
        if i % 100 == 0:
            lines += ['', f'SECTION "Technical Tutor Moves {i // 100 + 1}", ROMX']
        lines += ['', label + ':'] + [f'\tdw {m}' for m in moves] + ['\tdw 0']
    (ROOT / 'data/pokemon/technical_tutor.asm').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    breeding_path = ROOT / 'tools/testdata/breeding_moves.json'
    breeding = json.loads(breeding_path.read_text(encoding='utf-8'))
    for c, moves in changes['donor_fallbacks'].items():
        breeding['fallbacks'].setdefault(c, {}).update(moves)
    breeding_path.write_text(json.dumps(breeding, indent=2) + '\n', encoding='utf-8')
    source = json.loads((CACHE / 'source.json').read_text(encoding='utf-8-sig'))
    expected = {c: sorted({mapping[m] for m in pool if m in mapping}) for c, pool in canonical.items()}
    provenance = {}
    for kind, entries in changes.items():
        for c, moves in entries.items():
            for move in moves:
                sources = [s for m, ss in canonical.get(c, {}).items() if mapping.get(m) == move for s in ss]
                if not sources:
                    sources = [s for member in canonical if data[-1][member] == c
                               for m, ss in canonical[member].items() if mapping.get(m) == move for s in ss]
                # One most recent receipt per acquisition method is sufficient.
                selected = {}
                for s in sorted(sources, key=lambda s: s['source'], reverse=True):
                    selected.setdefault(s['source'][1], s['species'] + ':' + s['source'])
                provenance.setdefault(c, {})[move] = list(selected.values())
    receipt = {'source': source, 'custom_entries': sorted(CUSTOM),
               'proxy_forms': {'TEDDIURSABM': 'Teddiursa', 'URSARINGBM': 'Ursaring'},
               'policy': 'Union historical acquisition sources through SV DLC, filtered to ROM moves. Preserve project additions. Add real family egg moves and machine compatibility; natural gaps retain canonical levels; unsupported machines/tutors/gifts use Goldenrod teaching. Proxy pre-evolutions follow their base species. Individual historical moves, not simultaneous cartridge transfer legality.',
               'changes': changes, 'provenance': provenance, 'expected': expected,
               'unimplemented_moves': unsupported}
    RECEIPT.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
    print('Applied canonical learnset additions; receipt:', RECEIPT)


def verify_receipt():
    receipt = json.loads(RECEIPT.read_text(encoding='utf-8'))
    data = breeding_data()
    order, levels, tms, eggs, parents, utility, *_ = data
    technical = load_technical_tutors()
    known = available(data)
    # Deliberate project compatibility is recorded separately; never inflate
    # the pinned historical reference with a custom trainer-move decision.
    project = json.loads(read('tools/testdata/trainer_move_access.json'))
    revision = receipt.get('distribution_revision')
    curated = revision in {'thematic-level-up-and-canonical-breeding', 'full-access-with-blackthorn-fallback'}
    blackthorn = revision == 'full-access-with-blackthorn-fallback'
    if blackthorn:
        assert set(technical) == set(order), 'Incomplete Blackthorn pointer table'
        assert not receipt.get('deferred_moves'), 'Verified moves were deferred again'
        assert 'jp BlackthornMoveTutor_AddTeachableMoves' in read('engine/events/move_deleter.asm')
        assert 'data/pokemon/technical_tutor.asm' in read('main.asm')
        assert 'TechnicalTutor' not in read('engine/events/utility_tutor.asm'), 'Fallback moves leaked into Goldenrod'
        assert 'BlackthornMoveTutor' not in read('engine/events/utility_tutor.asm'), 'Fallback moves leaked into Goldenrod'
    elif curated:
        assert not technical and not receipt['changes']['technical_tutor'], 'Catch-all tutor restored'
        assert 'TechnicalMoveTutor_AddTeachableMoves' not in read('engine/events/utility_tutor.asm')
        assert 'data/pokemon/technical_tutor.asm' not in read('main.asm')
    else:
        assert set(technical) == set(order), 'Incomplete technical tutor pointer table'
    capacity = int(re.search(r'MOVE_TUTOR_LIST_CAPACITY EQU (\d+)', read('constants/wram_constants.asm'))[1])
    for c in order:
        expected = set(receipt['expected'].get(c, []))
        protected = set(receipt.get('protected_move_access', {}).get(c, []))
        assert protected <= known[c], (c, sorted(protected-known[c]), 'previously expanded movepool trimmed')
        deferred = set(receipt.get('deferred_moves', {}).get(c, []))
        assert expected - known[c] == deferred, (c, sorted((expected-known[c]) ^ deferred), 'unrecorded coverage change')
        approved = set(project['technical_tutor'].get(c, []))
        approved.update(attacking_review().get('tutor_additions', {}).get(c, []))
        assert set(technical.get(c, [])) <= expected | approved, (c, 'tutor move without canonical or project support')
        assert len(technical.get(c, [])) == len(set(technical.get(c, []))), (c, 'duplicate tutor move')
        assert len(set(technical.get(c, [])) | {m for i, m in enumerate(UTILITY) if utility[c] & (1 << i)}) <= capacity, (c, 'tutor capacity')
        assert len(set(eggs[c]) | set(technical.get(c, []))) <= capacity, (c, 'Blackthorn combined-menu capacity')
        if c.endswith('_CLONE'):
            assert technical.get(c) == technical.get(c[:-6]), (c, 'clone tutor mismatch')
    for c, ms in receipt['changes']['level_up'].items():
        for move, level in ms.items():
            check_level(c, move, level, levels)
    for c, ms in receipt['changes']['donor_fallbacks'].items():
        for move, level in ms.items():
            check_level(c, move, level, levels)
    for c, ms in receipt['changes'].get('thematic_level_up', {}).items():
        for move, level in ms.items():
            check_level(c, move, level, levels)
            assert move in receipt['expected'][c], (c, move, 'thematic move without canonical compatibility')
    for c, ms in receipt['changes']['egg_moves'].items():
        assert set(ms) <= set(eggs[c]), (c, 'missing canonical egg moves')
    for c, ms in receipt['changes']['tmhm'].items():
        assert set(ms) <= set(tms[c]), (c, 'missing machine compatibility')
    for c, ms in receipt['changes']['technical_tutor'].items():
        assert set(ms) == set(technical.get(c, [])), (c, 'technical tutor receipt mismatch')
    for c, lv in [('ARON', 32), ('LAIRON', 38), ('AGGRON', 44)]:
        if curated:
            assert (lv, 'BODY_PRESS') in levels[c], (c, 'Body Press level-up route')
        else:
            assert 'BODY_PRESS' in technical[c], (c, 'Body Press direct teaching route')
    deferred_count = sum(map(len, receipt.get('deferred_moves', {}).values()))
    print(f'CANONICAL LEARNSET AUDIT PASSED: {len(order)} roster entries; '
          f'{sum(map(len, receipt["expected"].values()))} reference pairs accounted for; '
          f'{deferred_count} historical candidates deferred; all recorded placements and protected movepools present.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report', type=Path, default=ROOT / '_artifacts/canonical-learnsets-audit.json')
    parser.add_argument('--plan', action='store_true')
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--reference', action='store_true', help='Recompare against downloaded pinned source instead of the offline receipt')
    args = parser.parse_args()
    if args.apply or args.plan:
        parser.error('The catch-all tutor import is retired. Use curated placements in the receipt and tools/redistribute_canonical_moves.py.')
    if RECEIPT.exists() and not (args.plan or args.apply or args.reference):
        verify_receipt()
        return
    data, canonical, mapping, names, missing, unsupported = analyze()
    counts = Counter()
    for c, moves in missing.items():
        for move, sources in moves.items():
            kinds = {s['source'][1] for s in sources}
            counts['egg' if 'E' in kinds else 'level' if 'L' in kinds else 'machine/tutor/event'] += 1
    report = {'source': json.loads((CACHE / 'source.json').read_text(encoding='utf-8-sig')),
              'roster_entries': len(data[0]), 'canonical_entries': len(canonical),
              'custom_entries': sorted(CUSTOM), 'missing_pairs': sum(map(len, missing.values())),
              'species_with_gaps': len(missing), 'categories': dict(counts),
              'missing': missing, 'unimplemented_moves': unsupported}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({k: v for k, v in report.items() if k not in {'missing', 'unimplemented_moves'}}, indent=2))
    print('Largest gaps:', sorted(((c, len(ms)) for c, ms in missing.items()), key=lambda x: -x[1])[:12])
    print('Aggron missing:', ', '.join(missing.get('AGGRON', {})))
    if args.plan or args.apply:
        updated, changes = plan(data, canonical, mapping)
        print('Planned additions:', {k: sum(map(len, v.values())) for k, v in changes.items()})
        print('Largest technical list:', max((len(ms) + 5, c) for c, ms in changes['technical_tutor'].items()))
        print('Largest natural list:', max((len(ms), c) for c, ms in updated[1].items()))
        print('Largest egg list:', max((len(ms), c) for c, ms in updated[3].items()))
        (ROOT / '_artifacts/canonical-learnsets-plan.json').write_text(json.dumps(changes, indent=2) + '\n')
        if args.apply:
            assert not RECEIPT.exists(), 'Already applied; use the checked-in receipt audit instead.'
            apply(updated, canonical, mapping, changes, unsupported)


if __name__ == '__main__':
    main()

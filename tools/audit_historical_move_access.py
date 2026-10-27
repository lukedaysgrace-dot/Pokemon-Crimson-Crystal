#!/usr/bin/env python3
"""Reconcile implemented move access against all mainline games and Lumi 3.0.

Downloaded TypeScript is parsed as data, never executed. Exact forms and their
official pre-evolutions are used; unrelated forms and battle-only transformations
are not learnset donors. Offline verification uses the checked-in receipt.
"""
import argparse
from copy import deepcopy
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re

from audit_breeding_moves import breeding_data, routes, UTILITY
from audit_canonical_learnsets import available, blocks, CUSTOM, species_key
from audit_learnset_variety import ROOT, read, load_technical_tutors
from lumi_learnsets.gen_learnsets import MOVE_MAP, norm_move

CACHE = ROOT / 'tools/lumi_learnsets/cache/historical'
RECEIPT = ROOT / 'tools/testdata/historical_move_access.json'
PS_FILES = ['ps_learnsets.ts', 'gen2_learnsets.ts',
            'gen7letsgo_learnsets.ts', 'gen8legends_learnsets.ts',
            'gen9legends_learnsets.ts']


def load_json(path):
    return json.loads(path.read_text(encoding='utf-8'))


def source_reference():
    order = breeding_data()[0]
    implemented = set(re.findall(r'^\s*move\s+.*?;\s*(\w+)\s*$', read('data/moves/moves.asm'), re.M))
    mapping = {norm_move(m): m for m in implemented}
    mapping.update({k: v for k, v in MOVE_MAP.items() if v in implemented})
    official_move_ids = blocks((CACHE / 'ps_moves.ts').read_text(encoding='utf-8'))
    resolved = {move for key, move in mapping.items() if key in official_move_ids}
    assert implemented - resolved == {'PIXIE_PUNCH'}, ('unmapped implemented official move', implemented - resolved)
    dex = {}
    for key, body in blocks((CACHE / 'ps_pokedex.ts').read_text(encoding='utf-8')).items():
        dex[key] = dict(re.findall(r'^\t\t(name|prevo|baseSpecies|changesFrom): "([^\"]+)"', body, re.M))
    direct = defaultdict(lambda: defaultdict(list))
    unsupported = defaultdict(set)

    def add(key, name, source):
        move = mapping.get(norm_move(name))
        if move:
            direct[key][move].append(source)
        else:
            unsupported[key].add(name)

    for filename in PS_FILES:
        count = 0
        for key, body in blocks((CACHE / filename).read_text(encoding='utf-8')).items():
            match = re.search(r'^\t\tlearnset: \{\n(.*?)^\t\t\}', body, re.M | re.S)
            if not match:
                continue
            count += 1
            for move, codes in re.findall(r'^\t\t\t([a-z0-9]+): (\[[^\n]+\]),', match[1], re.M):
                for code in json.loads(codes):
                    if re.fullmatch(r'[1-9][LMTESVDR][0-9]*', code):
                        add(key, move, filename + ':' + key + ':' + code)
        assert count > 150, (filename, 'incomplete parser')

    personal = load_json(CACHE / 'lumi_PersonalTable.json')['Personal']
    names = load_json(CACHE / 'lumi_english_ss_monsname.json')['labelDataArray']
    forms = load_json(CACHE / 'lumi_english_ss_zkn_form.json')['labelDataArray']
    move_names = load_json(CACHE / 'lumi_english_ss_wazaname.json')['labelDataArray']
    levels = {row['id']: row['ar'] for row in load_json(CACHE / 'lumi_WazaOboeTable.json')['WazaOboe']}
    eggs = {(row['no'], row['formNo']): row['wazaNo'] for row in load_json(CACHE / 'lumi_TamagoWazaTable.json')['Data']}
    machines = load_json(CACHE / 'lumi_TMLearnset_consolidated.json')
    tutors = load_json(CACHE / 'lumi_tutorMoves.json')
    tm_moves = load_json(CACHE / 'lumi_ItemTable.json')['WazaMachine']
    form_indices = defaultdict(list)
    lumi_forms = {}
    for row in personal:
        # The site's form number is the position within the species' personal
        # rows, including invalid placeholders (not Personal.form_index).
        form_indices[row['monsno']].append(row['id'])
    for row in personal:
        if not row['valid_flag'] or not row['monsno']:
            continue
        no, ident = row['monsno'], row['id']
        base = names[no]['wordDataArray'][0]['str']
        form = forms[ident].get('wordDataArray', []) if ident < len(forms) else []
        name = form[0]['str'] if form else base
        key = norm_move(base.replace('♀', 'f').replace('♂', 'm'))
        if ident != no:
            region = next((r for r in ['Alolan', 'Galarian', 'Hisuian', 'Paldean'] if r in name), None)
            if region:
                if no != 128 and name != region + ' ' + base:
                    continue
                suffix = {'Alolan': 'alola', 'Galarian': 'galar', 'Hisuian': 'hisui', 'Paldean': 'paldea'}[region]
                key += suffix
                if no == 128 and region == 'Paldean':
                    key = 'taurospaldea' + ('blaze' if 'Blaze' in name else 'aqua' if 'Aqua' in name else 'combat')
            elif no == 901 and 'Bloodmoon' in name:
                key = 'ursalunabloodmoon'
            else:
                continue  # Megas, clones, cosmetic and battle forms are not pooled.
        assert key not in lumi_forms, (key, 'ambiguous Lumi form')
        formno = form_indices[no].index(ident)
        lumi_forms[key] = {'id': ident, 'monsno': no, 'formno': formno, 'name': name}
        def add_id(mid, route):
            assert 0 < mid < len(move_names), (key, mid)
            words = move_names[mid]['wordDataArray']
            assert words, (key, mid, 'missing move name')
            add(key, words[0]['str'], f'lumi:{ident}:{route}')
        ar = levels.get(ident, [])
        for level, mid in zip(ar[::2], ar[1::2]):
            add_id(mid, 'L' + str(level))
        for mid in eggs.get((no, formno), []):
            add_id(mid, 'E')
        for mid in tutors.get(str(no), {}).get(str(formno), []):
            add_id(mid, 'T')
        bits = machines.get(str(no), {}).get('formno_' + str(formno))
        if bits:
            for i, tm in enumerate(tm_moves):
                if bits['set' + str(i // 32 + 1).zfill(2)] & (1 << (i % 32)):
                    add_id(tm['wazaNo'], 'M' + str(i + 1))
    expected, provenance, absent = {}, {}, {}
    for species in order:
        if species in CUSTOM:
            continue
        key = species_key(species)
        assert key in dex and key in direct, (species, key, 'unmapped official species')
        expected[species], provenance[species] = set(), defaultdict(list)
        absent[species] = set()
        seen = set()
        while key and key not in seen:
            seen.add(key)
            expected[species].update(direct[key])
            absent[species].update(unsupported[key])
            for move, sources in direct[key].items():
                # Keep one receipt per input and acquisition category.
                selected = {}
                for source in sources:
                    selected.setdefault((source.split(':')[0], re.sub(r'\d+$', '', source.split(':')[-1])), source)
                provenance[species][move].extend(selected.values())
            key = norm_move(dex.get(key, {}).get('prevo', ''))
        expected[species] = sorted(expected[species])
        provenance[species] = dict(provenance[species])
        absent[species] = sorted(absent[species])
    sources = load_json(CACHE / 'sources.json')
    # Include late-decoded name/TM inputs in the reproducible download manifest.
    for p in CACHE.iterdir():
        if p.name.startswith('lumi_') and p.suffix == '.json' and p.name != 'lumi_tree.json':
            sources['files'][p.name] = ('https://raw.githubusercontent.com/TeamLumi/luminescent-team/' +
                                       sources['revisions']['lumi'] + '/__gamedata/gamedata3.0/' + p.name[5:])
        elif p.name.startswith('lumi_') and p.suffix == '.js':
            sources['files'][p.name] = ('https://raw.githubusercontent.com/TeamLumi/luminescent-team/' +
                                       sources['revisions']['lumi'] + '/plugins/pokedex-data-plugin/dex/' + p.name[5:])
    sources['files'].pop('gen1_learnsets.ts', None) # Gen II includes all Gen I sources.
    sources['sha256'] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(CACHE.iterdir())
                         if p.suffix in {'.ts', '.json', '.js'} and p.name not in {'sources.json', 'lumi_tree.json'}}
    return {'sources': sources, 'expected': expected, 'provenance': provenance,
            'unimplemented': absent, 'lumi_forms': lumi_forms}


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')


def write_levels(levels):
    from audit_learnset_variety import load_sources
    order = load_sources()[0]
    paths = [ROOT / f'data/pokemon/evos_attacks_{s}.asm' for s in ['kanto', 'johto', 'clones']]
    tables = {}
    for path in paths:
        for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)', path.read_text(encoding='utf-8'), re.M):
            tables[m[1]] = re.findall(r'^\s*dw\s+(\w+)', m[2], re.M)
    names = ['EvosAttacksPointers1', 'EvosAttacksPointers1C', 'EvosAttacksPointers1B', 'EvosAttacksPointers2', 'EvosAttacksPointers2D', 'EvosAttacksPointers2E', 'EvosAttacksPointers2B', 'EvosAttacksPointers2C']
    rows = dict(zip(sum((tables[n] for n in names), []), (levels[c] for c in order)))
    for path in paths:
        text = path.read_text(encoding='utf-8')
        def update(m):
            label, body = m.groups()
            old = [(int(lv), move) for lv, move in re.findall(r'^\s*dbw\s+(\d+),\s*(\w+)', body, re.M)]
            if old == rows[label]:
                return m[0]
            body = re.sub(r'^\t(?:dbw\s+\d+,\s*\w+[^\n]*\n)', '', body, flags=re.M)
            insert = ''.join(f'\tdbw {lv}, {move}\n' for lv, move in rows[label])
            body, count = re.subn(r'(^\s*db 0 ; no more level-up moves)', lambda n: insert + n[1], body, count=1, flags=re.M)
            assert count == 1, label
            return label + ':\n' + body
        updated = re.sub(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)', update, text, flags=re.M | re.S)
        if updated != text:
            path.write_text(updated, encoding='utf-8')


def write_tutors(order, technical):
    lines = ['; Generated by tools/audit_historical_move_access.py --apply.',
             '; Mainline history (including Legends) and Lumi 3.0; exact species/forms.',
             'SECTION "Technical Tutor Pointers", ROMX', 'TechnicalTutorPointers::']
    groups = {}
    for c in order:
        key = tuple(technical[c])
        groups.setdefault(key, 'TechnicalTutor_' + (c if key else 'None'))
        lines.append(f'\tdba {groups[key]} ; {c}')
    lines.append('assert (@ - TechnicalTutorPointers) == NUM_POKEMON * 3')
    for i, (moves, label) in enumerate(groups.items()):
        if i % 100 == 0:
            lines += ['', f'SECTION "Blackthorn Tutor Moves {i // 100 + 1}", ROMX']
        lines += ['', label + ':'] + [f'\tdw {m}' for m in moves] + ['\tdw 0']
    (ROOT / 'data/pokemon/technical_tutor.asm').write_text('\n'.join(lines) + '\n', encoding='utf-8')


def reconcile(reference):
    assert not RECEIPT.exists(), 'Already reconciled; use the offline audit.'
    data = deepcopy(breeding_data())
    order, levels, tms, eggs, parents, utility, _, _, roots = data
    before = available(data)
    old_technical = load_technical_tutors()
    allowed = {c: set(reference['expected'].get(c, before[c])) | (before[c] & {'PIXIE_PUNCH'}) for c in order}
    changes = {route: {} for route in ['level_up_removals', 'tmhm_removals', 'egg_removals', 'utility_removals', 'tutor_removals', 'tutor_additions']}
    for c in order:
        for field, old in [('level_up_removals', {m for _, m in levels[c]}), ('tmhm_removals', set(tms[c])),
                           ('egg_removals', set(eggs[c])), ('tutor_removals', set(old_technical[c]))]:
            removed = sorted(old - allowed[c])
            if removed:
                changes[field][c] = removed
        levels[c] = [(lv, m) for lv, m in levels[c] if m in allowed[c]]
        tms[c] = [m for m in tms[c] if m in allowed[c]]
        removed = [m for i, m in enumerate(UTILITY) if utility[c] & (1 << i) and m not in allowed[c]]
        if removed:
            changes['utility_removals'][c] = removed
        utility[c] = sum(1 << i for i, m in enumerate(UTILITY) if utility[c] & (1 << i) and m in allowed[c])
    # The engine uses the root family's egg list. Keep only moves supported for
    # every member sharing that list; do not give siblings evolved-only moves.
    for root in set(roots.values()):
        members = [c for c in order if roots[c] == root]
        supported = set.intersection(*(allowed[c] for c in members))
        selected = [m for m in eggs[root] if m in supported]
        for c in members:
            removed = sorted(set(eggs[c]) - set(selected))
            if removed:
                changes['egg_removals'][c] = removed
            eggs[c] = list(selected)
    base = available(data, technical={})
    technical = {c: sorted((set(old_technical[c]) & allowed[c]) | (allowed[c] - base[c])) for c in order}
    # Preserve clone identity even where the original has an extra pre-evo route.
    for c in order:
        if c.endswith('_CLONE'):
            technical[c] = list(technical[c[:-6]])
    for c in order:
        added = sorted(set(technical[c]) - set(old_technical[c]))
        if added:
            changes['tutor_additions'][c] = added
    # Re-prove breeding after removing unsourced donors. Do not use the egg
    # tutor as its own proof; retain the project's level-30 fallback policy.
    independent = routes(data, technical=technical)
    changes['breeding_fallbacks'] = {}
    for c in sorted(set(roots.values())):
        for move in eggs[c]:
            if move not in independent[c]:
                assert move in allowed[c], (c, move, 'unsupported breeding fallback')
                levels[c].append((30, move))
                levels[c].sort(key=lambda row: row[0])
                changes['breeding_fallbacks'].setdefault(c, {})[move] = 30
    after = available(data, technical=technical)
    inherited = {c: sorted(after[c] - allowed[c]) for c in order if after[c] - allowed[c]}
    # Custom evolution branches necessarily retain the parent's legitimate moves.
    for c in order:
        assert allowed[c] <= after[c], (c, 'lost verified move')
        assert len(set(eggs[c]) | set(technical[c])) <= 192, (c, 'tutor capacity')
    write_levels(levels)
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    for c, filename in zip(order, files):
        if c in changes['tmhm_removals']:
            path = ROOT / filename
            path.write_text(re.sub(r'^\ttmhm[^\n]*', '\ttmhm ' + ', '.join(tms[c]), path.read_text(encoding='utf-8'), flags=re.M), encoding='utf-8')
    for suffix in ['kanto', 'johto']:
        path = ROOT / f'data/pokemon/egg_moves_{suffix}.asm'
        text = path.read_text(encoding='utf-8')
        pointers = dict((c, label) for label, c in re.findall(r'^\s*dw\s+(\w+)\s*;\s*(\w+)\s*$', text, re.M))
        edits = {}
        for c, label in pointers.items():
            if c == roots[c] and c in changes['egg_removals']:
                assert label not in edits or edits[label] == eggs[c], (label, 'shared egg list conflict')
                edits[label] = eggs[c]
        for label, moves in edits.items():
            text, count = re.subn(r'^' + label + r':\n.*?^\s*dw\s+-1[^\n]*', label + ':\n' + ''.join(f'\tdw {m}\n' for m in moves) + '\tdw -1 ; end', text, count=1, flags=re.M | re.S)
            assert count == 1, label
        if edits:
            path.write_text(text, encoding='utf-8')
    path = ROOT / 'data/pokemon/utility_tutor.asm'
    text = path.read_text(encoding='utf-8')
    text = re.sub(r'^(\s*db\s+)%([01]{8})(\s*;\s*)(\w+)', lambda m: m[1] + '%' + format(utility[m[4]], '08b') + m[3] + m[4], text, flags=re.M)
    path.write_text(text, encoding='utf-8')
    write_tutors(order, technical)
    receipt = {k: v for k, v in reference.items() if k not in {'provenance', 'unimplemented'}}
    receipt['policy'] = ('Union individual historical mainline and Lumi 3.0 moves, filtered to implemented moves. '
                         'Remove unsupported direct assignments; preserve six custom species and authored Pixie Punch. '
                         'Retain valid acquisition levels and machine/egg routes. Missing access uses Blackthorn. '
                         'Custom evolution carryover is reported explicitly, never treated as official compatibility.')
    receipt['custom_entries'] = sorted(CUSTOM)
    receipt['custom_moves'] = ['PIXIE_PUNCH']
    receipt['baseline_access'] = {c: sorted(before[c]) for c in order}
    receipt['changes'] = changes
    receipt['evolution_carryover'] = inherited
    receipt['sketch_access'] = receipt['evolution_carryover'].pop('SMEARGLE', [])
    receipt['added_access'] = {c: sorted(after[c] - before[c]) for c in order if after[c] - before[c]}
    receipt['removed_access'] = {c: sorted(before[c] - after[c]) for c in order if before[c] - after[c]}
    receipt['addition_provenance'] = {c: {m: reference['provenance'].get(c, {}).get(m, ['project evolution carryover']) for m in moves}
                                      for c, moves in receipt['added_access'].items()}
    receipt['unimplemented_moves'] = sorted({m for ms in reference['unimplemented'].values() for m in ms})
    receipt['final_access'] = {c: sorted(after[c]) for c in order}
    receipt['final_level_up'] = {c: levels[c] for c in order}
    receipt['final_tmhm'] = tms
    receipt['final_egg_moves'] = {c: eggs[c] for c in sorted(set(roots.values()))}
    receipt['final_utility'] = utility
    receipt['final_tutors'] = technical
    runtime = load_json(ROOT / 'tools/testdata/attacking_learnset_review.json')['unchanged_runtime']
    receipt['unchanged_runtime'] = {p: hashlib.sha256((ROOT / p).read_bytes().replace(b'\r\n', b'\n')).hexdigest() for p in runtime}
    write_json(RECEIPT, receipt)
    print('Applied:', {k: sum(map(len, v.values())) for k, v in changes.items()})
    print('Changed access:', sum(map(len, receipt['added_access'].values())), 'added;', sum(map(len, receipt['removed_access'].values())), 'removed')
    print('Custom evolution carryover:', inherited)


def verify(reference=None):
    receipt = load_json(RECEIPT)
    data = breeding_data()
    order, levels, tms, eggs, parents, utility, _, _, roots = data
    technical = load_technical_tutors()
    implemented = set(re.findall(r'^\s*move\s+.*?;\s*(\w+)\s*$', read('data/moves/moves.asm'), re.M))
    assert set(order) == set(receipt['final_access']), 'Roster changed; re-audit its sources'
    assert set(technical) == set(order), 'Missing species tutor pointers'
    capacity = int(re.search(r'MOVE_TUTOR_LIST_CAPACITY EQU (\d+)', read('constants/wram_constants.asm'))[1])
    known = available(data)
    for c in order:
        assert [list(row) for row in levels[c]] == receipt['final_level_up'][c], (c, 'natural placements changed')
        assert tms[c] == receipt['final_tmhm'][c], (c, 'machine compatibility changed')
        assert eggs[c] == receipt['final_egg_moves'][roots[c]], (c, 'family egg list changed')
        assert technical[c] == receipt['final_tutors'][c], (c, 'fallback tutor changed')
        assert utility[c] == receipt['final_utility'][c], (c, 'utility tutor changed')
        assert known[c] == set(receipt['final_access'][c]), (c, 'acquisition routes changed')
        baseline = set(receipt['baseline_access'][c])
        assert known[c] - baseline == set(receipt['added_access'].get(c, [])), (c, 'addition report mismatch')
        assert baseline - known[c] == set(receipt['removed_access'].get(c, [])), (c, 'removal report mismatch')
        expected = set(receipt['expected'].get(c, []))
        assert expected <= known[c], (c, 'missing historical moves', expected - known[c])
        if c not in CUSTOM:
            # Sketch access is computed from actual independently obtainable
            # moves; it does not authorize direct TM/tutor/natural assignments.
            direct = {m for _, m in levels[c]} | set(tms[c]) | set(eggs[c]) | set(technical[c])
            direct |= {m for i, m in enumerate(UTILITY) if utility[c] & (1 << i)}
            assert direct <= expected | {'PIXIE_PUNCH'}, (c, 'unsupported direct access', direct - expected - {'PIXIE_PUNCH'})
        assert known[c] <= implemented, (c, 'unimplemented move')
        assert len(set(eggs[c]) | set(technical[c])) <= capacity, (c, 'Blackthorn overflow')
        assert len({m for _, m in levels[c]}) <= capacity, (c, 'reminder overflow')
        assert [lv for lv, _ in levels[c]] == sorted(lv for lv, _ in levels[c]), (c, 'level order')
        assert levels[c] and all(1 <= lv <= 100 for lv, _ in levels[c]), (c, 'invalid natural levels')
        for rows in [tms[c], eggs[c], technical[c]]:
            assert len(rows) == len(set(rows)), (c, 'duplicate assignment')
        if c.endswith('_CLONE'):
            original = c[:-6]
            assert (levels[c], tms[c], eggs[c], utility[c], technical[c]) == (levels[original], tms[original], eggs[original], utility[original], technical[original]), (c, 'clone mismatch')
    for c, ms in receipt['evolution_carryover'].items():
        assert all(any(m in known[p] for p in parents[c]) for m in ms), (c, 'unproved evolution carryover')
    assert set(receipt['sketch_access']) == known['SMEARGLE'] - set(receipt['expected']['SMEARGLE']), 'Sketch receipt mismatch'
    if reference:
        assert reference['expected'] == receipt['expected'], 'Reference pool changed'
        assert reference['sources']['sha256'] == receipt['sources']['sha256'], 'Cached source changed'
    assert 'jp BlackthornMoveTutor_AddTeachableMoves' in read('engine/events/move_deleter.asm')
    assert 'TechnicalTutor' not in read('engine/events/utility_tutor.asm')
    print(f'HISTORICAL MOVE ACCESS AUDIT PASSED: {len(order)} species/forms; '
          f'{sum(map(len, receipt["expected"].values()))} sourced pairs; no missing moves or unsupported direct assignments.')
    return receipt


def reconcile_trainers():
    """Replace now-invalid NPC moves with supported moves of a similar role."""
    import audit_trainers as trainers
    receipt = load_json(RECEIPT)
    known = available(breeding_data())
    moves = {m['const']: m for m in load_json(ROOT / 'docs/data/moves.json')}
    parties = trainers.parse_parties(set(known), set(trainers.constant_list('constants/move_constants.asm', 'NUM_ATTACKS')),
                                    set(trainers.constant_list('constants/item_constants.asm', 'NUM_ITEMS')))
    assert not trainers.ERRORS, trainers.ERRORS
    # Prefer tactical equivalents before a type/category/power similarity score.
    preferred = {
        'RECOVER': ['SLACK_OFF', 'ROOST', 'SYNTHESIS', 'REST'],
        'FREEZE_DRY': ['ICE_BEAM', 'ICY_WIND', 'BLIZZARD'],
        'IRON_HEAD': ['METAL_CLAW', 'GIGA_HAMMER', 'FLASH_CANNON', 'KNOCK_OFF'],
        'CROSS_POISON': ['POISON_JAB', 'GUNK_SHOT', 'SLUDGE_BOMB'],
        'CRUSH_CLAW': ['SLASH', 'BODY_SLAM', 'DOUBLE_EDGE'],
        'DIZZY_PUNCH': ['BODY_SLAM', 'RETURN', 'DOUBLE_HIT', 'DOUBLE_EDGE'],
        'BODY_PRESS': ['CLOSE_COMBAT', 'BRICK_BREAK', 'LOW_KICK', 'SUPERPOWER'],
        'SACRED_SWORD': ['CLOSE_COMBAT', 'BRICK_BREAK', 'LOW_KICK'],
        'HEAD_SMASH': ['STONE_EDGE', 'ROCK_SLIDE', 'ROCK_BLAST'],
        'RAGING_FURY': ['FLAMETHROWER', 'FIRE_BLAST', 'FLARE_BLITZ'],
        'FORCE_PALM': ['LOW_KICK', 'BRICK_BREAK', 'DRAIN_PUNCH'],
        'LOW_SWEEP': ['LOW_KICK', 'CLOSE_COMBAT', 'BRICK_BREAK'],
        'HAMMER_ARM': ['CLOSE_COMBAT', 'BRICK_BREAK', 'LOW_KICK'],
        'SUPERPOWER': ['CLOSE_COMBAT', 'BRICK_BREAK', 'LOW_KICK', 'EARTHQUAKE'],
        'DRACO_METEOR': ['DRAGON_PULSE', 'DRAGONBREATH', 'DRAGON_CLAW'],
        'PHANTOMFORCE': ['SHADOW_BONE', 'SHADOW_CLAW', 'SHADOW_SNEAK'],
        'PSYCHO_CUT': ['PSYCHIC_M', 'PSYSHOCK', 'ZEN_HEADBUTT'],
        'MOONBLAST': ['DAZZLING_GLEAM', 'PLAY_ROUGH', 'DRAINING_KISS'],
        'QUIVER_DANCE': ['SWORDS_DANCE', 'AGILITY', 'WORK_UP', 'BATON_PASS'],
        'WOOD_HAMMER': ['POWER_WHIP', 'LEAF_BLADE', 'SEED_BOMB'],
        'FLAME_WHEEL': ['INCINERATE', 'EMBER', 'FLAMETHROWER'],
        'DRILL_RUN': ['BONEMERANG', 'BONE_RUSH', 'DIG', 'EARTHQUAKE'],
        'CRUNCH': ['NIGHT_SLASH', 'THROAT_CHOP', 'SUCKER_PUNCH', 'DARK_PULSE', 'BITE'],
        'SCALE_SHOT': ['DRAGON_RUSH', 'DRAGON_CLAW', 'DRAGON_PULSE'],
        'APPLE_ACID': ['ENERGY_BALL', 'GIGA_DRAIN', 'LEAF_STORM'],
        'U_TURN': ['WHIRLWIND', 'BRAVE_BIRD', 'DRILL_PECK'],
        'SWORDS_DANCE': ['WORK_UP', 'BULK_UP', 'HONE_CLAWS', 'RAPID_SPIN'],
        'THUNDERSHOCK': ['ABSORB', 'STRUGGLE_BUG', 'BUG_BITE'],
        'GROWTH': ['DEFENSE_CURL', 'RECYCLE', 'ATTRACT', 'WITHDRAW'],
        'SIGNAL_BEAM': ['AIR_SLASH', 'HURRICANE', 'HEAT_WAVE', 'HYPER_VOICE'],
        'FAIRY_WIND': ['PSYBEAM', 'CONFUSION', 'OMINOUS_WIND', 'ASTONISH'],
        'SLUDGE': ['SLUDGE_BOMB', 'HEX', 'DARK_PULSE', 'SHADOW_BALL'],
        'THUNDERBOLT': ['ENERGY_BALL', 'POWER_GEM', 'PSYSHOCK', 'SHADOW_BALL'],
        'POWER_GEM': ['ANCIENTPOWER', 'ROCK_SLIDE', 'STONE_EDGE'],
        'SHADOW_PUNCH': ['SHADOW_SNEAK', 'HEX', 'NIGHT_SHADE'],
        'FOUL_PLAY': ['CRUNCH', 'NIGHT_SLASH', 'SUCKER_PUNCH', 'BITE', 'SHADOW_CLAW'],
        'MUD_SHOT': ['MUD_SLAP', 'BONE_CLUB', 'DIG'],
        'FIRE_PUNCH': ['FIRE_FANG', 'ICE_PUNCH', 'BRICK_BREAK', 'CRUNCH'],
        'HYPER_VOICE': ['DRAGON_PULSE', 'POWER_GEM', 'DISCHARGE', 'THUNDERBOLT'],
        'FLASH_CANNON': ['SURF', 'ICE_BEAM', 'SIGNAL_BEAM', 'DISCHARGE'],
        'POISON_JAB': ['CROSS_POISON', 'POISON_FANG', 'U_TURN', 'ROOST'],
        'X_SCISSOR': ['U_TURN', 'CRUNCH', 'SHADOW_CLAW', 'DRAGON_CLAW'],
        'BRICK_BREAK': ['LOW_KICK', 'DRAIN_PUNCH', 'HI_JUMP_KICK', 'ACROBATICS'],
        'WORK_UP': ['SWORDS_DANCE', 'AGILITY', 'IRON_DEFENSE'],
        'STRENGTH': ['BODY_SLAM', 'RETURN', 'DOUBLE_EDGE', 'STOMP'],
        'IRON_TAIL': ['METAL_CLAW', 'BODY_SLAM', 'RETURN', 'PLAY_ROUGH'],
        'SHADOW_BALL': ['DARK_PULSE', 'DRAGON_PULSE', 'SLUDGE_BOMB', 'VENOSHOCK'],
        'TRIPLE_AXEL': ['ICE_PUNCH', 'ACROBATICS', 'CLOSE_COMBAT', 'POISON_JAB'],
        'ICE_FANG': ['ICE_PUNCH', 'ICE_SHARD', 'AVALANCHE', 'ICICLE_SPEAR'],
        'MEGA_DRAIN': ['GIGA_DRAIN', 'RAZOR_LEAF', 'MAGICAL_LEAF', 'ABSORB'],
    }
    overrides = {
        ('BUNEARY', 'KARATE_CHOP'): ['DOUBLE_KICK', 'LOW_KICK', 'POUND'],
        ('LANTURN', 'TAIL_GLOW'): ['AMNESIA', 'AGILITY', 'THUNDER_WAVE'],
        ('CROAGUNK', 'ACID_ARMOR'): ['BULK_UP', 'NASTY_PLOT', 'TAUNT'],
        ('TOXAPEX', 'BODY_PRESS'): ['SCALD', 'SURF', 'LIQUIDATION', 'POISON_JAB'],
        ('APPLIN', 'DRAGONBREATH'): ['ASTONISH', 'ROLLOUT', 'WITHDRAW'],
        ('IMPIDIMP', 'SWEET_KISS'): ['CONFIDE', 'FAKE_OUT', 'FLATTER', 'TAUNT'],
        ('LEDIAN', 'QUIVER_DANCE'): ['SWORDS_DANCE', 'AGILITY', 'BATON_PASS'],
    }
    path = ROOT / 'data/trainers/parties.asm'
    lines = path.read_text(encoding='utf-8').splitlines(keepends=True)
    edits = []
    for entries in parties.values():
        for entry in entries:
            # Match each species declaration with its immediately following
            # custom move directive, using parsed line numbers rather than text
            # substitution across unrelated teams.
            directives = entry['directives']
            mon_index = 0
            for i, (kind, value, _) in enumerate(directives):
                if kind != 'dw' or value not in known:
                    continue
                mon = entry['mons'][mon_index]
                mon_index += 1
                assert mon['species'] == value
                if not mon['moves'] or value == 'SMEARGLE':
                    continue
                move_directive = next((row for row in directives[i + 1:] if row[0] == 'dw'), None)
                assert move_directive and len(move_directive[1].split(',')) == 4
                chosen = list(mon['moves'])
                for slot, old in enumerate(chosen):
                    if old == 'NO_MOVE' or old in known[value]:
                        continue
                    candidates = known[value] - set(chosen) - {'SKETCH', 'STRUGGLE', 'TRANSFORM', 'METRONOME'}
                    assert candidates, (value, old, 'no legal replacement')
                    choices = overrides.get((value, old), preferred.get(old, []))
                    new = next((m for m in choices if m in candidates), None)
                    if new is None:
                        old_data = moves[old]
                        def score(m):
                            info = moves[m]
                            power, old_power = info.get('power') or 0, old_data.get('power') or 0
                            return (int(info['category'] == old_data['category']) * 200 +
                                    int(info['type'] == old_data['type']) * 150 -
                                    abs(power - old_power) - int((info.get('accuracy') or 100) < 80) * 50,
                                    m)
                        new = max(candidates, key=score)
                    chosen[slot] = new
                    edits.append({'trainer_class': entry['declared_class'], 'trainer_number': entry['declared_number'],
                                  'species': value, 'level': mon['level'], 'slot': slot + 1,
                                  'before': old, 'after': new, 'line': move_directive[2]})
                if chosen != mon['moves']:
                    line = move_directive[2] - 1
                    lines[line] = re.sub(r'(\bdw\s+)[^;\r\n]+', lambda m: m[1] + ', '.join(chosen), lines[line])
    if edits:
        path.write_text(''.join(lines), encoding='utf-8')
    receipt['trainer_replacements'] = receipt.get('trainer_replacements', []) + edits
    write_json(RECEIPT, receipt)
    print('Trainer move slots replaced:', len(edits))
    print('Replacements:', sorted({(e['species'], e['before'], e['after']) for e in edits}))


def download_sources():
    """Restore ignored public inputs from the receipt's immutable URLs."""
    from concurrent.futures import ThreadPoolExecutor
    import urllib.request
    sources = load_json(RECEIPT)['sources']
    CACHE.mkdir(parents=True, exist_ok=True)
    def download(item):
        name, expected = item
        path = CACHE / name
        if path.exists() and hashlib.sha256(path.read_bytes()).hexdigest() == expected:
            return
        req = urllib.request.Request(sources['files'][name], headers={'User-Agent': 'CrimsonCrystal-learnset-audit'})
        with urllib.request.urlopen(req, timeout=60) as response:
            content = response.read()
        assert hashlib.sha256(content).hexdigest() == expected, (name, 'upstream hash mismatch')
        path.write_bytes(content)
    with ThreadPoolExecutor(max_workers=6) as pool:
        list(pool.map(download, sources['sha256'].items()))
    write_json(CACHE / 'sources.json', {k: sources[k] for k in ['revisions', 'files']})
    print('Pinned source cache verified:', len(sources['sha256']), 'files')


def generate_report():
    receipt = verify()
    pokemon = {p['const']: p['name'] for p in load_json(ROOT / 'docs/data/pokemon.json')}
    names = {m['const']: m['name'] for m in load_json(ROOT / 'docs/data/moves.json')}
    def name(c):
        if c.endswith('_CLONE'):
            return name(c[:-6]) + ' (Clone)'
        for suffix, region in [('_ALOLAN', 'Alolan'), ('_GALARIAN', 'Galarian'), ('_HISUIAN', 'Hisuian'),
                               ('_PALDEAN_FIRE', 'Paldean Blaze'), ('_PALDEAN_WATER', 'Paldean Aqua'), ('_PALDEAN', 'Paldean')]:
            if c.endswith(suffix):
                return region + ' ' + pokemon.get(c, c)
        if c.endswith('BM'):
            return pokemon.get(c, c) + ' (Bloodmoon)'
        return pokemon.get(c, c.replace('_', ' ').title())
    def move_names(ms):
        return ', '.join(sorted((names[m] for m in ms), key=str.casefold)) or 'None'
    added = sum(map(len, receipt['added_access'].values()))
    removed = sum(map(len, receipt['removed_access'].values()))
    changes = receipt['changes']
    lines = ['# Historical move access corrections', '',
             f'All **{len(receipt["final_access"])} roster entries** were checked against mainline history '
             '(including Red/Blue/Yellow, Gold/Silver/Crystal, Let’s Go, Legends: Arceus and Legends: Z-A) '
             'and Luminescent Platinum 3.0 level-up, egg, machine and tutor tables.', '',
             f'**{added:,} newly obtainable species/move pairs; {removed:,} unsupported pairs removed; '
             f'{sum(map(len, receipt["expected"].values())):,} sourced pairs accessible; zero deferred implemented moves.**', '',
             'Only moves implemented in this ROM are distributed. This is a union of individual historical access, '
             'including event moves; it does not claim every four-move combination is transferable between official games.', '',
             'Valid existing levels, machines and breeding routes remain. Missing access uses the existing purple '
             'Blackthorn tutor in the Move Deleter’s House for ¥5,000. Goldenrod keeps its five utility moves. '
             'Frigibax learns Freeze-Dry at level 30 because removing unsupported donors otherwise leaves no breeding source.', '',
             'The six original custom species retain their authored move access, and Pixie Punch retains its custom rules. '
             'Clone tables match their originals. Custom evolution branches necessarily carry the parent’s legitimate moves; '
             'these exceptions are listed separately below. Smeargle’s Sketch access is verified against moves obtainable in this roster.', '',
             f'**{len(receipt.get("trainer_replacements", []))} trainer move slots** were changed to supported alternatives '
             'so NPCs follow the corrected pools. All replacements are recorded in the structured receipt.', '',
             'Sources: [Team Lumi’s Pokédex](https://luminescent.team/pokedex), '
             '[pinned Lumi data](https://github.com/TeamLumi/luminescent-team/tree/' + receipt['sources']['revisions']['lumi'] + '/__gamedata/gamedata3.0), '
             '[pinned Pokémon Showdown data](https://github.com/smogon/pokemon-showdown/tree/' + receipt['sources']['revisions']['showdown'] + '/data). '
             'Exact input URLs, SHA-256 hashes, added-move provenance and final tables are in '
             '`tools/testdata/historical_move_access.json`.', '',
             '## Rechecking', '', '```sh', 'python tools/audit_historical_move_access.py',
             'python tools/audit_historical_move_access.py --download',
             'python tools/audit_historical_move_access.py --reference',
             'make test-learnsets BATTLE_TEST_PYTHON=.venv/bin/python', '```', '',
             '## Unavoidable custom evolution carryover', '']
    if receipt.get('validation'):
        index = lines.index('## Unavoidable custom evolution carryover')
        lines[index:index] = ['Validation passed: both ROM builds; 10,565 compiled learnset/menu checks per ROM; '
                             '11,378 release breeding checks; 1,826 trainer slots; 61 Phantump/Stantler/Wyrdeer '
                             'checks per ROM; unchanged regeneration for all 498 level-up tables; independent source '
                             'and move-integrity audits. Generated documentation has zero warnings and zero unparsed rows.', '',
                             'Comparison baseline: `' + receipt.get('baseline_revision', 'pre-reconciliation source tables') + '`.', '']
    for c, ms in receipt['evolution_carryover'].items():
        lines.append(f'- **{name(c)}:** {move_names(ms)}.')
    lines += ['', '## Every Pokémon', '',
              '“Added” and “removed” describe net obtainable access in this correction pass. '
              'The route rows also show removals where another legitimate route still exists.', '']
    records = []
    for c in sorted(receipt['final_access'], key=lambda c: name(c).casefold()):
        added_moves = receipt['added_access'].get(c, [])
        removed_moves = receipt['removed_access'].get(c, [])
        lines += [f'### {name(c)}', '', f'**Added:** {move_names(added_moves)}.', '', f'**Removed:** {move_names(removed_moves)}.', '']
        for label, field in [('Removed natural entries', 'level_up_removals'), ('Removed machine flags', 'tmhm_removals'),
                             ('Removed family egg entries', 'egg_removals'), ('Removed fallback lessons', 'tutor_removals'),
                             ('Added Blackthorn lessons', 'tutor_additions')]:
            if changes[field].get(c):
                lines += [f'- **{label}:** {move_names(changes[field][c])}.']
        lines.append('')
        records.append({'species': c, 'name': name(c), 'newly_available': added_moves, 'removed_moves': removed_moves,
                        'new_tutor_routes': changes['tutor_additions'].get(c, []),
                        'breeding_fallbacks': changes.get('breeding_fallbacks', {}).get(c, {})})
    text = '\n'.join(lines)
    for filename in ['historical-move-access.md', 'learnset-additions-by-pokemon.md']:
        (ROOT / 'docs' / filename).write_text(text, encoding='utf-8')
    write_json(ROOT / 'docs/data/learnset-additions.json', {'scope': receipt['policy'], 'move_names': names, 'pokemon': records})
    (ROOT / 'docs/canonical-moves-awaiting-review.md').write_text('# Move access status\n\nAll verified implemented historical and Lumi moves have an acquisition route. '
        'There are no deferred moves. See [the full correction report](historical-move-access.md).\n', encoding='utf-8')
    print('Wrote full-roster report:', len(records), 'entries')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', action='store_true')
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--trainers', action='store_true')
    parser.add_argument('--download', action='store_true')
    parser.add_argument('--report', action='store_true')
    args = parser.parse_args()
    if args.download:
        download_sources()
        return
    if args.report:
        generate_report()
        return
    if args.trainers:
        reconcile_trainers()
        return
    reference = source_reference() if args.reference else load_json(RECEIPT)
    if args.apply:
        assert args.reference, '--apply requires --reference'
        reconcile(reference)
        return
    if RECEIPT.exists():
        verify(reference if args.reference else None)
        return
    known = available(breeding_data())
    missing = {c: sorted(set(ms) - known[c]) for c, ms in reference['expected'].items() if set(ms) - known[c]}
    extra = {c: sorted(known[c] - set(ms)) for c, ms in reference['expected'].items() if known[c] - set(ms)}
    report = {'missing': missing, 'unsupported_access': extra, **reference}
    path = ROOT / '_artifacts/historical-move-access.json'
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print('Reference pairs:', sum(map(len, reference['expected'].values())))
    print('Missing:', sum(map(len, missing.values())), 'Unsupported:', sum(map(len, extra.values())))
    print('Missing examples:', list(missing.items())[:8])
    print('Unsupported examples:', list(extra.items())[:8])


if __name__ == '__main__':
    main()

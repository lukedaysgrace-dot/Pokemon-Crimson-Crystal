import sys, re, json
from pathlib import Path
from collections import Counter, defaultdict

root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(root / 'tools'))
import audit_trainers as audit
import generate_trainer_party_reference as reference

classes, ids, aliases, owners = audit.parse_trainer_constants()
groups = audit.parse_parties(
    set(audit.constant_list('constants/pokemon_constants.asm', 'NUM_POKEMON')),
    set(audit.constant_list('constants/move_constants.asm', 'NUM_ATTACKS')),
    set(audit.constant_list('constants/item_constants.asm', 'NUM_ITEMS')))
pointers = audit.validate_group_pointers(classes, ids, aliases, owners, groups)
reference.party_comments(groups)
assert not audit.ERRORS, audit.ERRORS
prior = json.loads((root / '_ai_artifacts/reports/regular_trainer_class_counts.json').read_text())
regular = {row['class'] for row in prior['rows']}
entries = {(c, e['trainer_id']): e for c in regular for e in groups[pointers[c]]}
families = {}
for c in regular:
    candidates = defaultdict(list)
    for tid in ids[c]:
        m = re.fullmatch(r'(.+[A-Z])(\d+)', tid)
        if m:
            candidates[(m[1], entries[c, tid]['name'])].append(tid)
    for (prefix, name), tids in candidates.items():
        if len(tids) > 1:
            families.update({(c, tid): prefix for tid in tids})

included = set(re.findall(r'INCLUDE "(maps/[^\"]+\.asm)"', (root / 'data/maps/scripts.asm').read_text()))
selected = defaultdict(list)
unreferenced = []
for path in sorted((root / 'maps').glob('*.asm')):
    text = path.read_text(encoding='utf-8')
    code = '\n'.join(line.split(';')[0] for line in text.splitlines())
    label = None
    for line in code.splitlines():
        lm = re.match(r'^([\w.]+):', line)
        if lm:
            label = lm[1]
        m = re.match(r'\s*(trainer|generictrainer|loadtrainer)\s+(\w+)\s*,\s*(\w+)', line)
        if not m or m[2] not in regular:
            continue
        assert path.relative_to(root).as_posix() in included, path
        c, tid = m[2], m[3]
        tid = aliases[c].get(tid, tid)
        assert (c, tid) in entries, (c, tid)
        if m[1] == 'trainer' and label and len(re.findall(r'\b' + re.escape(label) + r'\b', code)) < 2:
            unreferenced.append((str(path), label, c, tid))
            continue
        selected[c, families.get((c, tid), tid)].append(entries[c, tid])

counts = Counter(c for c, _ in selected)
expected = Counter({r['class']: r['trainers'] for r in prior['rows']})
assert counts == expected, counts
types = {}
species_order = audit.constant_list('constants/pokemon_constants.asm', 'NUM_POKEMON')
includes = re.findall(r'INCLUDE "([^"]+\.asm)"', (root / 'data/pokemon/base_stats.asm').read_text())
assert len(includes) == len(species_order), (len(includes), len(species_order))
for species, filename in zip(species_order, includes):
    path = root / filename
    text = path.read_text()
    pair = re.search(r'\bdb\s+(\w+),\s*(\w+)\s*;\s*type\b', text)
    assert pair, path
    types[species] = set(pair.groups())
type_counts = Counter()
pokemon_count = 0
details = []
for (c, family), versions in sorted(selected.items()):
    entry = min(versions, key=lambda e: e['declared_number'])
    for mon in entry['mons']:
        type_counts.update(types[mon['species']])
        pokemon_count += 1
    details.append({'class': c, 'trainer': family, 'party_id': entry['trainer_id'], 'pokemon': [m['species'] for m in entry['mons']]})
output = {'method': 'Map-referenced regular trainers; one earliest referenced party per trainer; rematches merged and Twins counted as one pair. Each Pokemon contributes once to each of its distinct species types.',
          'trainer_count': len(selected), 'pokemon_count': pokemon_count,
          'unplaced_scripts_excluded': unreferenced,
          'class_counts': [{'class': reference.display_class(c), 'count': n} for c, n in sorted(counts.items(), key=lambda x: (-x[1], reference.display_class(x[0])))],
          'type_counts': [{'type': t.title(), 'count': n} for t, n in sorted(type_counts.items(), key=lambda x: (-x[1], x[0]))],
          'trainers': details}
(root / '_ai_artifacts/reports/regular_trainer_usage.json').write_text(json.dumps(output, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: v for k, v in output.items() if k != 'trainers'}, indent=2))

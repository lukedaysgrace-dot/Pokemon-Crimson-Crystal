"""Check requested stat edits, compiled records and documentation metadata."""
import copy
import hashlib
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'tools/battle-simulator'))
from lab.data import check_rom_data, extract

data = extract()
baseline = json.loads((OUT / 'baseline-data.json').read_text())
expected = {
    'HITMONLEE': [65, 130, 63, 92, 35, 100],
    'HITMONTOP': [70, 105, 95, 80, 35, 100],
    'HITMONCHAN': [75, 115, 79, 81, 35, 100],
    'PERSIAN': [70, 100, 60, 115, 80, 65],
    'PERSIAN_ALOLAN': [70, 70, 60, 115, 100, 65],
    'PERRSERKER': [85, 110, 100, 50, 50, 95],
}
changed = {}
for species, record in data['species'].items():
    before = list(baseline['species'][species]['stats'].values())
    after = list(record['stats'].values())
    if before != after:
        changed[species] = {'before': before, 'after': after,
                            'bst_before': sum(before), 'bst_after': sum(after)}
assert set(changed) == set(expected), changed
for species, stats in expected.items():
    assert list(data['species'][species]['stats'].values()) == stats
for species in ('HITMONLEE', 'HITMONTOP', 'HITMONCHAN'):
    assert changed[species]['bst_before'] == changed[species]['bst_after']
# Ensure no extracted moves, abilities, typing, legality or other stats changed.
restored = json.loads(json.dumps(data))  # Normalize tuple/list representation to the saved JSON baseline.
for species in expected:
    restored['species'][species]['stats'] = baseline['species'][species]['stats']
restored.pop('data_sha256')
old = copy.deepcopy(baseline)
old.pop('data_sha256')
assert restored == old
compiled = {name: check_rom_data(data, ROOT / name)
            for name in ('pokecrystal.gbc', 'pokecrystal_debug.gbc')}
sys.path.insert(0, str(ROOT / 'crimson-crystal-docs'))
import generate_docs
builder = generate_docs.Builder(ROOT)
builder.tm_index = builder.tm_table()
builder.ability_desc = builder.ability_descriptions()
builder._items = builder.item_names()
order, names = builder.species()
mons = builder.base_stats(order, names)
builder.learnsets(mons)
builder.egg_moves(mons)
builder.finish_evolutions(mons)
builder.gameplay_rules(mons)
receipt = {'status': 'passed', 'changes': changed, 'compiled_checks': compiled,
           'scope_check': 'Only the six requested species stat records differ from the saved source-data baseline',
           'balance_metadata': 'All entries validated; no website generated',
           'rom_sha256': {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in compiled},
           'historical_league': 'October 24 build; no updated league rankings claimed'}
(OUT / 'verification.json').write_text(json.dumps(receipt, indent=2))
(OUT / 'source-data.json').write_text(json.dumps(data))
shutil.copy2('/tmp/crimson-stat-redistribution-20261027-build.log', OUT / 'build.log')
print(json.dumps(receipt))

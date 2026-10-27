"""Check complete focused results and retain a portable native battle database."""
import csv
import gzip
import hashlib
import json
import shutil
import sqlite3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DEST = Path(__file__).resolve().parent
OUT = ROOT / 'tools/battle-simulator/output/focused-review-20261027'
DB = Path('/tmp/crimson-focused-review-20261027.sqlite')
sys.path.insert(0, str(ROOT / 'tools/battle-simulator'))
from lab.data import canonical, digest, extract
from lab.policy import choose

data = extract()
plan = json.loads((OUT / 'plan.json').read_text())
expected_lab = digest(canonical({p.name: digest(p.read_bytes()) for p in
                                 sorted((ROOT / 'tools/battle-simulator/lab').glob('*.py'))
                                 + [ROOT / 'tools/battle-simulator/simulator.py']}).encode())
connection = sqlite3.connect(DB)
assert connection.execute('PRAGMA quick_check').fetchall() == [('ok',)]
assert connection.execute('SELECT COUNT(*),COUNT(DISTINCT id) FROM battles').fetchone() == (3456, 3456)
assert connection.execute("SELECT COUNT(*) FROM battles WHERE status='pending'").fetchone()[0] == 0
cases, actions, items, unresolved = 0, 0, set(), 0
for spec, result in connection.execute('SELECT spec,result FROM battles'):
    spec, result = json.loads(spec), json.loads(result)
    assert result['status'] != 'error' and not result['failures']
    assert result['metadata']['data_sha256'] == data['data_sha256'] == plan['data_sha256']
    assert result['metadata']['laboratory_sha256'] == expected_lab
    assert result['metadata']['rom_sha256'] == plan['source']['rom_sha256']
    assert all(spec[side][0]['item'] == 'NO_ITEM' for side in ('player', 'enemy'))
    for side in ('player', 'enemy'):
        build = spec[side][0]
        expected_happiness = 0 if 'FRUSTRATION' in build['moves'] and 'RETURN' not in build['moves'] else 255
        assert build['happiness'] == expected_happiness
        assert result['log'][0][side]['happiness'] == expected_happiness
    cases += 1
    unresolved += result['winner'] == 'unresolved'
    for state in result['log']:
        items.update(state[side]['item'] for side in ('player', 'enemy'))
    for turn, state in enumerate(result['log'][1:], 1):
        before = result['log'][turn - 1]
        for index, side in enumerate(('player', 'enemy')):
            script = spec.get('scripts', {}).get(side, [])
            expected = script[turn - 1] if turn <= len(script) else choose(
                data, before[side], before['enemy' if side == 'player' else 'player'],
                spec['policies'][index], spec['seed'] + turn*17 + index)
            assert state['requested_actions'][side] == expected
            actions += 1
assert items == {'NO_ITEM'}
assert connection.execute('PRAGMA wal_checkpoint(TRUNCATE)').fetchone()[0] == 0
connection.close()
with (DEST / 'focused-results.csv').open() as f:
    rows = list(csv.DictReader(f))
assert len(rows) == 108 and len({r['species'] for r in rows}) == 12
assert all(int(r['games']) == 32 for r in rows)
for species in {r['species'] for r in rows}:
    abilities = {a for a in data['species'][species]['abilities'] if a != 'NO_ABILITY'}
    own = [r for r in rows if r['species'] == species]
    assert {r['ability'] for r in own} == abilities
    assert all(len([r for r in own if r['ability'] == a]) == 3 for a in abilities)
archive = OUT / 'battles.sqlite.gz'
with DB.open('rb') as source, gzip.open(archive, 'wb') as target:
    shutil.copyfileobj(source, target)
def sha(stream):
    h = hashlib.sha256()
    for block in iter(lambda: stream.read(1024*1024), b''):
        h.update(block)
    return h.hexdigest()
with DB.open('rb') as f:
    database_sha = sha(f)
with gzip.open(archive, 'rb') as f:
    assert sha(f) == database_sha
with archive.open('rb') as f:
    archive_sha = sha(f)
receipt = {'status': 'passed', 'battles_checked': cases, 'action_requests_checked': actions,
           'species': 12, 'builds': 108, 'games_per_build': 32, 'native_items': sorted(items),
           'unresolved': unresolved, 'friendship_check': 'Every declared build and initial native state matched the Frustration/Return friendship rule',
           'database_sha256': database_sha,
           'archive': str(archive.relative_to(ROOT)), 'archive_sha256': archive_sha,
           'archive_bytes': archive.stat().st_size, 'gzip_roundtrip': 'passed',
           'data_sha256': data['data_sha256'], 'laboratory_sha256': expected_lab,
           'rom_sha256': plan['source']['rom_sha256']}
(DEST / 'focused-verification.json').write_text(json.dumps(receipt, indent=2))
shutil.copy2(OUT / 'plan.json', DEST / 'focused-plan.json')
shutil.copy2('/tmp/crimson-focused-review-final-20261027.log', DEST / 'focused-run.log')
print(json.dumps(receipt))

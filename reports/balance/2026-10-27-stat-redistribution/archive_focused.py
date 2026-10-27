"""Retain the exact tested ROM/source and all focused-review evidence locally."""
import hashlib
import json
import time
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DEST = Path(__file__).resolve().parent
OUT = ROOT / 'tools/battle-simulator/output/focused-review-20261027'
plan = json.loads((OUT / 'plan.json').read_text())
paths = {ROOT / name for name in plan['source']['files']}
for name, expected in plan['source']['files'].items():
    assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == expected, name
driver = ROOT / 'tools/battle-simulator/focused_balance_review.py'
assert hashlib.sha256(driver.read_bytes()).hexdigest() == plan['driver_sha256']
paths.update([driver, ROOT / 'tools/audit_trainer_sprites.py', ROOT / 'crimson-crystal-docs/balance_changes.json'])
paths.update(ROOT / name for name in ('pokecrystal.gbc', 'pokecrystal.sym', 'pokecrystal_debug.gbc', 'pokecrystal_debug.sym'))
key = hashlib.md5((ROOT / 'pokecrystal_debug.gbc').read_bytes()).hexdigest()[:12]
paths.add(ROOT / f'tools/battletest/fixtures/menu-rules-v2-{key}.state')
paths.update(p for p in DEST.iterdir() if p.is_file() and p.name != 'backup.json')
paths.update(OUT / name for name in ('plan.json', 'candidates.json', 'progress.json', 'battles.sqlite.gz'))
archive = OUT / 'reproducibility.zip'
temporary = OUT / 'reproducibility.zip.tmp'
manifest = {}
with zipfile.ZipFile(temporary, 'w', zipfile.ZIP_DEFLATED, compresslevel=1) as z:
    for path in sorted(paths):
        relative = path.relative_to(ROOT).as_posix()
        z.write(path, relative)
        manifest[relative] = {'bytes': path.stat().st_size, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
    z.writestr('manifest.json', json.dumps(manifest, indent=2))
with zipfile.ZipFile(temporary) as z:
    assert z.testzip() is None
temporary.replace(archive)
receipt = {'status': 'verified', 'archive': str(archive.relative_to(ROOT)), 'bytes': archive.stat().st_size,
           'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), 'entries': len(manifest) + 1,
           'crc_check': 'passed', 'includes': 'exact game/source/driver/fixture; complete database and review evidence'}
(DEST / 'backup.json').write_text(json.dumps(receipt, indent=2))
print(json.dumps(receipt))

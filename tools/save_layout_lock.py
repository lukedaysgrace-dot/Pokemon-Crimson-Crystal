#!/usr/bin/env python3
"""Guard generated save-layout changes; reuse the linked SRAM audit."""
import argparse
import json
from pathlib import Path
from audit_save import Audit, audit_layout, parse_symbols

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
parser.add_argument('--profile', type=Path)
parser.add_argument('--sym', type=Path, default=ROOT / 'pokecrystal.sym')
parser.add_argument('--write', action='store_true')
args = parser.parse_args()
audit = Audit()
audit_layout(audit, parse_symbols(args.sym, audit))
if audit.finish():
    raise SystemExit(1)
if args.profile is None:
    manifest = json.loads((ROOT / 'crimson-editor/static/gamedata/manifest.json').read_text(encoding='utf-8'))
    args.profile = ROOT / 'crimson-editor/static/gamedata' / (manifest[0]['id'] + '.json')
profile = json.loads(args.profile.read_text(encoding='utf-8'))['layout']
current = {'saveFormatVersion': profile['constants']['SAVE_FORMAT_VERSION'], 'layoutHash': profile['layoutHash'], 'symbols': {k: v for k, v in profile['sram'].items() if k.startswith(('sSave', 'sBackupSave', 'sNewBox', 'sBoxMons'))}}
path = ROOT / 'save_layout.lock'
previous = json.loads(path.read_text()) if path.exists() else None
if previous and previous['layoutHash'] != current['layoutHash'] and previous['saveFormatVersion'] == current['saveFormatVersion']:
    raise SystemExit('Save layout changed without a SAVE_FORMAT_VERSION bump. Bump the version, build, regenerate and update the lock.')
if args.write:
    path.write_text(json.dumps(current, indent=2, sort_keys=True) + '\n')
elif previous != current:
    raise SystemExit('Save layout lock is out of date. Run tools/save_layout_lock.py --write with the generated profile.')
print('SAVE LAYOUT LOCK PASSED')

#!/usr/bin/env python3
"""Audit all roster heights/weights, source mappings, and compiled dex records.

--reference compares downloaded PokeAPI pokemon.csv and Showdown pokedex.ts
in _audit_tmp. Default mode uses the checked-in independently reviewed receipt.
"""
import argparse
import csv
import hashlib
import json
import re
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RECEIPT = ROOT / 'tools/testdata/species_dimensions.json'


def rounded(value):
    return int(Decimal(str(value)).quantize(Decimal(1), rounding=ROUND_HALF_UP))


def height_word(meters):
    inches = rounded(Decimal(str(meters)) / Decimal('0.0254'))
    feet, inches = divmod(inches, 12)
    return feet * 100 + inches


def layout():
    constants = re.findall(r'^\s*const\s+(\w+)', (ROOT / 'constants/pokemon_constants.asm').read_text(), re.M)
    pointers = re.findall(r'^\s*dba\s+(\w+)', (ROOT / 'data/pokemon/dex_entry_pointers.asm').read_text(), re.M)
    includes = dict(re.findall(r'(\w+)::\s+INCLUDE "([^"]+)"', (ROOT / 'data/pokemon/dex_entries.asm').read_text()))
    assert len(pointers) == 502
    return {name: (label, includes[label]) for name, label in zip(constants, pointers)}


def reference():
    weights = json.loads((ROOT / 'tools/testdata/species_weights.json').read_text())['species']
    csv_path = ROOT / '_audit_tmp/modern-pokemon.csv'
    ts_path = ROOT / '_audit_tmp/modern-pokedex.ts'
    api = {r['identifier']: r for r in csv.DictReader(csv_path.read_text().splitlines())}
    ps = {}
    for name, body in re.findall(r'^\t(\w+): \{\n(.*?)^\t\},', ts_path.read_text(), re.M | re.S):
        h = re.search(r'\bheightm: ([\d.]+)', body)
        w = re.search(r'\bweightkg: ([\d.]+)', body)
        if h and w:
            ps[name] = (Decimal(h[1]), Decimal(w[1]))
    aliases = {'dudunsparce-two-segment': 'dudunsparce', 'aegislash': 'aegislash',
               'mimikyu-disguised': 'mimikyu',
               'tauros-paldea-blaze-breed': 'taurospaldeablaze',
               'tauros-paldea-aqua-breed': 'taurospaldeaaqua'}
    rows, disagreements, missing = {}, [], []
    for name, (label, path) in layout().items():
        info = weights[name]
        old = list(map(int, re.search(r'^\s*dw\s+(\d+),\s*(\d+)', (ROOT / path).read_text(), re.M).groups()))
        slug = info['source']
        row = {'source': slug, 'dex_path': path, 'dex_label': label}
        if slug == 'custom':
            row.update(height_m=None, weight_kg=None, dex_height=old[0], dex_lbs_x10=old[1])
        else:
            a = api['aegislash-shield' if slug == 'aegislash' else slug]
            ah, aw = Decimal(a['height']) / 10, Decimal(a['weight']) / 10
            key = aliases.get(slug, re.sub(r'[^a-z0-9]', '', slug))
            if key not in ps:
                missing.append([name, slug, key])
                continue
            h, w = ps[key]
            if (h, w) != (ah, aw):
                disagreements.append({'species': name, 'source': slug,
                                      'pokeapi': [float(ah), float(aw)], 'showdown': [float(h), float(w)]})
            row.update(height_m=float(h), weight_kg=float(w), dex_height=height_word(h),
                       dex_lbs_x10=rounded(w * 10 * Decimal('2.20462')))
        rows[name] = row
    resolutions = json.loads(RECEIPT.read_text())['resolutions']
    for disagreement in disagreements:
        resolution = resolutions[disagreement['species']]
        assert disagreement['showdown'] == [resolution['height_m'], resolution['weight_kg']], disagreement
    return {'sources': [{'url': url, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                        for url, p in [('https://raw.githubusercontent.com/PokeAPI/pokeapi/master/data/v2/csv/pokemon.csv', csv_path),
                                       ('https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/pokedex.ts', ts_path)]],
            'disagreements': disagreements, 'missing': missing, 'species': rows}


def audit(receipt, roms):
    failures, changes = [], []
    weights = json.loads((ROOT / 'tools/testdata/species_weights.json').read_text())['species']
    roster = layout()
    assert set(receipt['species']) == set(roster) == set(weights)
    for name, row in receipt['species'].items():
        label, path = roster[name]
        assert (label, path) == (row['dex_label'], row['dex_path']), name
        old = list(map(int, re.search(r'^\s*dw\s+(\d+),\s*(\d+)', (ROOT / path).read_text(), re.M).groups()))
        expected = [row['dex_height'], row['dex_lbs_x10']]
        if old != expected:
            changes.append({'species': name, 'path': path, 'old': old, 'expected': expected})
        if row['weight_kg'] is not None:
            if height_word(row['height_m']) != expected[0] or rounded(
                    Decimal(str(row['weight_kg'])) * 10 * Decimal('2.20462')) != expected[1]:
                failures.append(f'{name}: dimension receipt conversion mismatch')
            hg = rounded(Decimal(str(row['weight_kg'])) * 10)
            if weights[name]['weight_hg'] != hg or weights[name]['dex_lbs_x10'] != expected[1]:
                failures.append(f'{name}: weight receipt mismatch')
            if (expected[1] * 29727 + 32768) >> 16 != hg:
                failures.append(f'{name}: battle conversion mismatch')
        for rom_path, symbols in roms:
            bank, addr = symbols[label]
            offset = (bank * 0x4000 + (addr & 0x3fff)) if bank else addr
            offset = rom_path.index(b'\x50', offset) + 1
            compiled = [int.from_bytes(rom_path[offset:offset + 2], 'little'),
                        int.from_bytes(rom_path[offset + 2:offset + 4], 'little')]
            if compiled != expected:
                failures.append(f'{name}: compiled dex mismatch {compiled} != {expected}')
    return changes, failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', action='store_true')
    parser.add_argument('--json', action='store_true')
    parser.add_argument('--rom', type=Path, action='append', default=[])
    args = parser.parse_args()
    receipt = reference() if args.reference else json.loads(RECEIPT.read_text())
    roms = []
    for path in args.rom:
        symbols = {label: (int(bank, 16), int(addr, 16)) for bank, addr, label in
                   re.findall(r'^(\w+):(\w+) (\w+)$', path.with_suffix('.sym').read_text(), re.M)}
        roms.append((path.read_bytes(), symbols))
    changes, failures = ([], ['Unmapped reference species']) if receipt.get('missing') else audit(receipt, roms)
    if args.json:
        print(json.dumps({'receipt': receipt, 'changes': changes, 'failures': failures}, indent=2))
    else:
        for row in changes:
            print(row)
        for failure in failures:
            print('FAIL', failure)
        print(f'{len(receipt["species"])} roster slots; {len(changes)} dimension mismatches; '
              f'{len(failures)} other errors; {len(roms)} ROMs checked')
    raise SystemExit(bool(changes or failures or receipt.get('missing')))


if __name__ == '__main__':
    main()

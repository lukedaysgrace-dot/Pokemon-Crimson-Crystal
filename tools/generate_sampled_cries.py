#!/usr/bin/env python3
"""Import missing real cries; encode deterministic, GB-compatible DED samples.

Run with scipy/soundfile installed (or under .tmpbuild/cry-deps). Normal builds
use the checked-in .ded files and never download or encode audio.
"""
import argparse
import concurrent.futures
import csv
from fractions import Fraction
import hashlib
import io
import json
from pathlib import Path
import random
import re
import sys
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / '.tmpbuild/cry-deps'))
RATE = 16384
CACHE = ROOT / '_artifacts/sampled-cries/sources'
MANIFEST = ROOT / 'tools/testdata/sampled_cries.json'


def fetch(url):
    return urllib.request.urlopen(urllib.request.Request(url, headers={
        'User-Agent': 'CrimsonCrystalCryImporter/1.0'}), timeout=90).read()


def encode_ded(values):
    """Coral's delta/Huffman format, with deterministic nearest-level dither.

    The decoder starts at level 8; all 32-sample blocks must be complete.
    Tree jump offsets describe generated LR35902 instructions, not file bytes.
    """
    import numpy as np
    rng = random.Random(3490487757541254948)
    # TPDF, half-LSB peak: decorrelates quantization without obscuring quiet tails.
    levels = np.clip(np.floor((values + 1) * 7.5 + .5 + np.array([
        (rng.random() - rng.random()) * .5 for _ in values])), 0, 15).astype(int)
    levels = np.pad(levels, (0, (-len(levels)) % 32), constant_values=8)
    delta = (levels - np.r_[8, levels[:-1]]) % 16
    frequency = np.bincount(delta, minlength=16)
    # A leaf is an int; an internal node is a pair.
    queue = [(int(frequency[i]), i) for i in range(16) if frequency[i]]
    if len(queue) == 1:
        queue.append((0, (queue[0][1] + 1) % 16))
    while len(queue) > 1:
        queue.sort(key=lambda x: x[0])
        (lf, left), (rf, right) = queue[:2]
        del queue[:2]
        if isinstance(left, int) and isinstance(right, tuple):
            left, right = right, left
        queue.append((lf + rf, (left, right)))
    codes = {}

    def tree(node, prefix=''):
        left, right = node
        if isinstance(left, tuple) and isinstance(right, tuple):
            a, size = tree(left, prefix + '0')
            b, rsize = tree(right, prefix + '1')
            if size > 127:
                return bytes([0xe0 + (size >> 8), size & 255]) + a + b, 10 + size + rsize
            return bytes([size]) + a + b, 9 + size + rsize
        codes[right] = prefix + '1'
        if isinstance(left, tuple):
            a, size = tree(left, prefix + '0')
            return bytes([0x80 + right]) + a, 10 + size
        codes[left] = prefix + '0'
        return bytes([0xc0 + right, left]), 13

    header, _ = tree(queue[0][1])
    bits = ''.join(codes[int(x)] for x in delta)
    bits += '1' * ((-len(bits)) % 8)
    blocks = len(levels) // 32
    return header + b'\xff' + blocks.to_bytes(2, 'little') + bytes(
        int(bits[i:i+8], 2) for i in range(0, len(bits), 8))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--coral', type=Path, default=ROOT.parent / 'polishedcoral')
    args = parser.parse_args()
    CACHE.mkdir(parents=True, exist_ok=True)
    if MANIFEST.exists():
        manifest = json.loads(MANIFEST.read_text())
    else:
        source = (ROOT / 'data/pokemon/cries.asm').read_text()
        rows = re.findall(r'^\s*mon_cry\s+([^;\n]+);\s*(\w+)', source, re.M)
        dimensions = json.loads((ROOT / 'tools/testdata/species_dimensions.json').read_text())['species']
        manifest = dict(sample_rate=RATE, format='Coral DED (4-bit delta + Huffman)',
                        protected={}, replacements={}, samples={}, asset_hashes={})
        for i, (params, species) in enumerate(rows, 1):
            cry = params.split(',')[0].strip()[4:]
            original = i <= 251 or '_CLONE' in species or species in ('TEDDIURSABM', 'URSARINGBM')
            custom = dimensions[species]['source'] == 'custom'
            own = cry == species.replace('_', '') or cry == species
            if original or custom or (own and species not in ('HIPPOPOTAS', 'HIPPOWDON')):
                manifest['protected'][species] = params.strip()
                continue
            if species == 'AEGISLASH_BLADE':
                slug = 'aegislash'
            elif species == 'ZANGOOSE_SCARRED':
                slug = 'zangoose'
            else:
                slug = dimensions[species]['source']
            manifest['replacements'][species] = dict(source=slug, previous=params.strip(), index=i)
        for p in (ROOT / 'audio').glob('cries*.asm'):
            manifest['asset_hashes'][str(p.relative_to(ROOT))] = hashlib.sha256(p.read_bytes()).hexdigest()
    # Public Pokemon CSV provides stable form-specific cry IDs.
    manifest['sample_rate'] = RATE
    csv_path = CACHE / 'pokemon.csv'
    if not csv_path.exists():
        csv_path.write_bytes(fetch('https://raw.githubusercontent.com/PokeAPI/pokeapi/master/data/v2/csv/pokemon.csv'))
    ids = {r['identifier']: r['id'] for r in csv.DictReader(io.StringIO(csv_path.read_text()))}
    # These battle forms share the ordinary species cry in the mainline games.
    aliases = {'aegislash': 'aegislash-shield',
               'palafin-hero': 'palafin-zero', 'minior-red-meteor': 'minior-red-meteor'}
    # Keep sampled IDs stable when the user opts a species back into its old cry.
    slugs = manifest.get('sample_order', sorted({r['source'] for r in manifest['replacements'].values()}))

    def import_one(slug):
        import numpy as np
        import soundfile as sf
        from scipy.signal import resample_poly
        target = ROOT / f'audio/ded/{slug}.ded'
        target.parent.mkdir(exist_ok=True)
        coral = args.coral / f'audio/ded/{slug.replace("-", "_")}.ded'
        if coral.exists():
            target.write_bytes(coral.read_bytes())
            return slug, dict(source='polishedcoral', path=str(coral.relative_to(args.coral)),
                sha256=hashlib.sha256(target.read_bytes()).hexdigest(), bytes=target.stat().st_size,
                sample_rate=10485.76, timer_ticks=100)
        ident = ids[aliases.get(slug, slug)]
        url = f'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/{ident}.ogg'
        local = CACHE / f'{slug}.ogg'
        if not local.exists():
            local.write_bytes(fetch(url))
        samples, rate = sf.read(local, always_2d=True)
        samples = samples.mean(axis=1)
        # Band-limited resampling; retain pitch, complete duration and quiet tails.
        # New encodes use 16.384 kHz; existing Coral samples retain 10.48576 kHz.
        ratio = Fraction(RATE / rate).limit_denominator(10000)
        samples = resample_poly(samples, ratio.numerator, ratio.denominator)
        samples -= np.mean(samples)
        peak = float(np.max(np.abs(samples)))
        gain = .92 / peak if peak else 1
        samples *= gain
        data = encode_ded(samples)
        if len(data) > 16384:
            raise ValueError(f'{slug}: sample exceeds one ROM bank ({len(data)})')
        target.write_bytes(data)
        return slug, dict(source=url, source_sha256=hashlib.sha256(local.read_bytes()).hexdigest(),
            sha256=hashlib.sha256(data).hexdigest(), bytes=len(data), duration=len(samples)/RATE,
            sample_rate=RATE, timer_ticks=64, gain=gain,
            processing='mono; band-limited resample; DC removal; 92% peak; half-LSB TPDF')

    failures = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        futures = {pool.submit(import_one, s): s for s in slugs}
        for future in concurrent.futures.as_completed(futures):
            try:
                slug, info = future.result()
                manifest['samples'][slug] = info
                print(f'{slug}: {info["bytes"]} bytes ({info["source"]})', flush=True)
            except Exception as exc:
                failures.append((futures[future], str(exc)))
                print(f'FAIL {futures[future]}: {exc}', flush=True)
    MANIFEST.write_text(json.dumps(manifest, indent=2) + '\n')
    if failures:
        raise SystemExit(failures)
    lines = ['; Generated by tools/generate_sampled_cries.py. Existing cry IDs stay stable.',
             'SampledCryPointers::']
    for slug in slugs:
        lines.append(f'\tdba SampledCry_{slug.replace("-", "_")}')
        lines.append(f'\tdb {manifest["samples"][slug]["timer_ticks"]}')
    lines.append('SampledCryPointersEnd::')
    lines.append(f'\tassert SampledCryPointersEnd - SampledCryPointers == {len(slugs)} * 4')
    for slug in slugs:
        lines.extend([f'\nSECTION "Sampled cry {slug}", ROMX',
                      f'SampledCry_{slug.replace("-", "_")}:: INCBIN "audio/ded/{slug}.ded"'])
    (ROOT / 'audio/sampled_cry_data.asm').write_text('\n'.join(lines) + '\n')
    cry_path = ROOT / 'data/pokemon/cries.asm'
    lines = cry_path.read_text().splitlines()
    for i, line in enumerate(lines):
        match = re.match(r'\s*mon_cry\s+[^;]+;\s*(\w+)', line)
        if match and match[1] in manifest['replacements']:
            slug = manifest['replacements'][match[1]]['source']
            lines[i] = f'\tmon_cry $8000 | {slugs.index(slug)}, 0, $100 ; {match[1]} (sampled)'
    cry_path.write_text('\n'.join(lines) + '\n')
    print(f'{len(manifest["replacements"])} assignments; {len(slugs)} unique samples; '
          f'{sum(x["bytes"] for x in manifest["samples"].values())} compressed bytes')


if __name__ == '__main__':
    main()

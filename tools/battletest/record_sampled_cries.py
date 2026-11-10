#!/usr/bin/env python3
"""Record real ROM output with SameBoy's band-limited, hardware-filtered APU.

PyBoy remains useful for CPU/decoded-block tests, but its wave-channel sample
order and retrigger phase make it unsuitable for streamed-cry listening files.
Run under Linux/WSL; an isolated pinned SameBoy core is built in .tmpbuild.
"""
import argparse
import ast
import ctypes as C
from fractions import Fraction
import hashlib
import html
import json
from pathlib import Path
import subprocess
import sys
import wave

ROOT = Path(__file__).resolve().parents[2]
REVISION = 'ea667ad79aa28409f034b1fd6da7304e1844750d'
sys.path.insert(0, str(ROOT / '.tmpbuild/cry-deps'))
import numpy as np
from scipy.signal import correlate, resample_poly, butter, sosfiltfilt
from symbols import Symbols, Constants


def prepare():
    source = ROOT / '.tmpbuild/sameboy-audio'
    core = ROOT / '.tmpbuild/libsameboy-audio.so'
    bridge = ROOT / '.tmpbuild/sameboy-bridge.so'
    bridge_source = ROOT / 'tools/battletest/sameboy_cry_capture.c'
    if not source.exists():
        subprocess.run(['git', 'clone', '--no-checkout', 'https://github.com/LIJI32/SameBoy.git', str(source)], check=True)
        subprocess.run(['git', '-C', str(source), 'checkout', REVISION], check=True)
    revision = subprocess.check_output(['git', '-C', str(source), 'rev-parse', 'HEAD'], text=True).strip()
    if revision != REVISION:
        raise RuntimeError(f'Unexpected SameBoy revision: {revision}')
    if not core.exists():
        subprocess.run(['cc', '-shared', '-fPIC', '-O2', '-D_GNU_SOURCE', '-DGB_INTERNAL',
                        '-DGB_VERSION="audio-check"', '-DGB_COPYRIGHT_YEAR="2026"',
                        *map(str, sorted((source/'Core').glob('*.c'))), '-lm', '-o', str(core)], check=True)
    if not bridge.exists() or bridge.stat().st_mtime < bridge_source.stat().st_mtime:
        subprocess.run(['cc', '-shared', '-fPIC', '-O2', '-I'+str(source/'Core'), str(bridge_source),
                        '-L'+str(core.parent), '-lsameboy-audio', '-Wl,-rpath,$ORIGIN', '-o', str(bridge)], check=True)
    return bridge


def reference(slug, rate):
    # Reuse only the independent DED decoder, without importing the PyBoy APU.
    module = ast.parse((ROOT/'tools/battletest/sampled_cry_checks.py').read_text())
    node = next(n for n in module.body if isinstance(n, ast.FunctionDef) and n.name == 'decode_ded')
    scope = {}
    exec(compile(ast.Module(body=[node], type_ignores=[]), 'decode', 'exec'), scope)
    packed = np.frombuffer(scope['decode_ded']((ROOT/f'audio/ded/{slug}.ded').read_bytes()), dtype=np.uint8)
    values = np.column_stack((packed >> 4, packed & 15)).reshape(-1).astype(float)-7.5
    ratio = Fraction(48000/rate).limit_denominator(10000)
    return resample_poly(values, ratio.numerator, ratio.denominator)


def similarity(raw, expected, source_rate):
    actual = np.frombuffer(raw, dtype='<i2').reshape(-1, 2).mean(axis=1).astype(float)
    actual -= actual.mean()
    expected -= expected.mean()
    # Compare the intended source band. A real stepped DAC also emits sampling
    # images above it; those are absent from an ideal sinc-resampled reference.
    # This analysis filter never touches the listening WAVs.
    band = butter(6, [100, source_rate*.4], btype='bandpass', fs=48000, output='sos')
    actual = sosfiltfilt(band, actual)
    expected = sosfiltfilt(band, expected)
    lags = correlate(actual, expected, method='fft')
    lag = int(np.argmax(np.abs(lags))) - len(expected) + 1
    a, b = max(0, lag), max(0, -lag)
    length = min(len(actual)-a, len(expected)-b)
    # Real CGB DAC polarity is inverted; absolute correlation is intentional.
    return float(abs(np.corrcoef(actual[a:a+length], expected[b:b+length])[0, 1]))


def gallery(output, records):
    cards = ''.join(f'<article><h2>{html.escape(r["species"].replace("_", " ").title())}</h2>'
        f'<audio controls preload="none" src="{r["file"]}"></audio></article>' for r in records)
    page = '''<!doctype html><meta charset="utf-8"><title>Crimson Crystal — Corrected Cry Recordings</title>
<style>body{background:#101622;color:#edf2fa;font:16px system-ui;max-width:1150px;margin:40px auto;padding:0 22px}
h1{font-size:36px}p{color:#afbdcf}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:14px}
article{padding:18px;background:#1b2637;border-radius:12px}h2{font-size:18px;margin:0 0 12px}audio{width:100%}
button,input{font:inherit;padding:10px;border-radius:7px;margin:0 12px 25px 0}</style>
<h1>Crimson Crystal · Corrected Cry Recordings</h1>
<p>Unchanged game ROM, recorded through SameBoy’s accurate Game Boy Color audio hardware emulation.
These replace the distorted PyBoy previews. No desktop noise removal or equalization was applied.</p>
<input id="search" placeholder="Find a Pokémon"><button id="play">Play all</button><button id="stop">Stop</button><main>''' + cards + '''</main>
<script>const tracks=[...document.querySelectorAll('audio')];let playing=false,idx=0;
function next(){if(playing&&idx<tracks.length){tracks[idx].currentTime=0;tracks[idx].onended=()=>{idx++;next()};tracks[idx].play()}else playing=false}
document.querySelector('#play').onclick=()=>{tracks.forEach(x=>x.pause());playing=true;idx=0;next()};
document.querySelector('#stop').onclick=()=>{playing=false;tracks.forEach(x=>x.pause())};
document.querySelector('#search').oninput=e=>document.querySelectorAll('article').forEach(x=>x.hidden=!x.textContent.toLowerCase().includes(e.target.value.toLowerCase()));
</script>'''
    (output/'listen.html').write_text(page)
    (output/'listen-corrected.html').write_text(page)
    combined, timeline, position = [], [], 0.0
    for record in records:
        with wave.open(str(output/record['file']), 'rb') as stream:
            raw = stream.readframes(stream.getnframes())
        timeline.append(dict(species=record['species'], start_seconds=round(position, 3)))
        combined.extend((raw, bytes(48000)))
        position += len(raw)/192000 + .25
    for name in ('all-replacement-cries.wav', 'all-replacement-cries-corrected.wav'):
        with wave.open(str(output/name), 'wb') as stream:
            stream.setnchannels(2); stream.setsampwidth(2); stream.setframerate(48000)
            stream.writeframes(b''.join(combined))
    (output/'listening-order.json').write_text(json.dumps(timeline, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/sampled-cries')
    parser.add_argument('--species', nargs='*')
    args = parser.parse_args()
    manifest = json.loads((ROOT/'tools/testdata/sampled_cries.json').read_text())
    sym, con = Symbols(args.rom.with_suffix('.sym')), Constants()
    lib = C.CDLL(str(prepare()))
    lib.cry_new.argtypes = [C.c_char_p]; lib.cry_new.restype = C.c_void_p
    lib.cry_invoke.argtypes = [C.c_void_p, C.c_uint, C.c_uint, C.c_uint, C.c_uint]
    lib.cry_invoke.restype = C.c_int
    lib.cry_pcm.argtypes = [C.c_void_p]; lib.cry_pcm.restype = C.c_void_p
    lib.cry_free.argtypes = [C.c_void_p]
    gb = lib.cry_new(str(args.rom.resolve()).encode())
    if not gb: raise RuntimeError('SameBoy ROM loading failed')
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output/'sameboy').mkdir(exist_ok=True)
    records, failures = [], []

    def invoke(name, de=0):
        bank, address = sym[name]
        count = lib.cry_invoke(gb, bank, address, sym.addr('hROMBank'), de)
        if count < 0: raise RuntimeError(f'{name} timed out at {-count:04x}')
        return C.string_at(lib.cry_pcm(gb), count*4)

    try:
        invoke('PlayMusic', 0)
        for name in args.species or manifest['replacements']:
            raw = invoke('PlayCry', con.species_index(name)-1) + invoke('WaitSFX')
            slug = manifest['replacements'][name]['source']
            expected = reference(slug, manifest['samples'][slug]['sample_rate'])
            score = similarity(raw, expected, manifest['samples'][slug]['sample_rate'])
            relative = f'sameboy/{name.lower()}.wav'
            with wave.open(str(args.output/relative), 'wb') as stream:
                stream.setnchannels(2); stream.setsampwidth(2); stream.setframerate(48000); stream.writeframes(raw)
            records.append(dict(species=name, file=relative, waveform_correlation=score, seconds=len(raw)/192000))
            if score < .85: failures.append(name)
            print(f'{name}: waveform correlation {score:.4f}', flush=True)
        report = dict(engine='SameBoy', revision=REVISION, rom_sha256=hashlib.sha256(args.rom.read_bytes()).hexdigest(),
                      hardware='CGB-E; band-limited APU; accurate hardware highpass',
                      comparison='absolute aligned correlation; 100 Hz to 0.4 * source sample rate; analysis only, WAVs unchanged',
                      postprocessing='none', failures=failures, recordings=records)
        (args.output/'sameboy-results.json').write_text(json.dumps(report, indent=2))
        if failures: raise RuntimeError(f'Unexpected waveform disagreement: {failures}')
        gallery(args.output, records)
        print(f'{len(records)} faithful captures; minimum correlation {min(x["waveform_correlation"] for x in records):.4f}', flush=True)
    finally:
        lib.cry_free(gb)


if __name__ == '__main__':
    main()

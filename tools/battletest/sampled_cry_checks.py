#!/usr/bin/env python3
"""Verify cry preservation, every decoded native wave block, and sound cleanup.

All emulator states are private. --record builds a listening gallery of real
ROM captures, with every replacement and the protected cries clearly marked.
"""
import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import sys
import subprocess

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from symbols import _parse_constants


def decode_ded(data):
    pos = 0

    def tree():
        nonlocal pos
        tag = data[pos]
        pos += 1
        if tag < 0x80:
            return tree(), tree()
        if tag < 0xc0:
            return tree(), tag & 15
        if tag < 0xe0:
            left = data[pos]
            pos += 1
            return left, tag & 15
        if tag < 0xf0:
            pos += 1
            return tree(), tree()
        raise ValueError(f'invalid DED tree tag {tag:02x}')

    root = tree()
    assert data[pos] == 255
    pos += 1
    blocks = int.from_bytes(data[pos:pos+2], 'little')
    pos += 2
    bit = pos * 8
    values, last = [], 8
    for _ in range(blocks * 32):
        node = root
        while isinstance(node, tuple):
            node = node[(data[bit // 8] >> (7 - bit % 8)) & 1]
            bit += 1
        last = (last + node) % 16
        values.append(last)
    return bytes((a << 4) | b for a, b in zip(values[::2], values[1::2]))


def static_checks(manifest):
    rows = dict((species, params.strip()) for params, species in re.findall(
        r'^\s*mon_cry\s+([^;\n]+);\s*(\w+)', (ROOT / 'data/pokemon/cries.asm').read_text(), re.M))
    assert len(rows) == 503
    for species, previous in manifest['protected'].items():
        assert rows[species] == previous, f'protected cry changed: {species}'
    if manifest.get('restored_regionals'):
        assert rows['CLODSIRE'] == rows['QUAGSIRE'], 'Clodsire must retain Quagsire\'s cry'
        for species, receipt in manifest['restored_regionals'].items():
            assert rows[species] == receipt['previous'], f'regional cry changed: {species}'
    for path, expected in manifest['asset_hashes'].items():
        assert hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected, path
    for slug, info in manifest['samples'].items():
        data = (ROOT / f'audio/ded/{slug}.ded').read_bytes()
        assert hashlib.sha256(data).hexdigest() == info['sha256'], slug
        assert 0 < len(data) <= 16384
        decode_ded(data)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--record', action='store_true')
    parser.add_argument('--species', nargs='*')
    parser.add_argument('--normal-speed', action='store_true')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/sampled-cries')
    args = parser.parse_args()
    args.rom = args.rom.resolve()
    manifest = json.loads((ROOT / 'tools/testdata/sampled_cries.json').read_text())
    static_checks(manifest)
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=True)
    pb, m = h.pb, h.battle.mem
    checks, failures, records = 0, [], []
    decoded_blocks = []
    block_keys = []

    def capture_block(_):
        addr = h.sym.addr('wDEDTempSamp')
        block = bytes(pb.memory[addr:addr+16])
        # Hooks can repeat at interrupt boundaries; the native playback counter
        # identifies each complete hardware upload independently of decode-ahead.
        cursor = m.read('wDEDPlayedBlocks') | m.read('wDEDPlayedBlocks', 1) << 8
        if block_keys and cursor == block_keys[-1]:
            assert block == decoded_blocks[-1], 'same source cursor yielded different audio'
            return
        block_keys.append(cursor)
        decoded_blocks.append(block)

    def check(ok, name):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(name)
            print('FAIL ' + name, flush=True)

    def invoke(symbol, **registers):
        begin_native_call(h, symbol)
        for name, value in registers.items():
            setattr(pb.register_file, name, value)
        samples = []
        for _ in range(600):
            pb.tick(1, False, True)
            samples.append(pb.sound.ndarray.copy())
            if pb.register_file.PC in (0xc0f1, 0xc0f3):
                return np.concatenate(samples)
        raise RuntimeError(f'{symbol} did not return: PC={pb.register_file.PC:04x}')

    try:
        new_game(h, 0)
        invoke('PlayMusic', D=0, E=0)
        if args.normal_speed:
            invoke('NormalSpeed')
        # Check the linked bytes too: every protected species keeps its complete
        # original six-byte cry header, even though the dispatch code moved banks.
        rom = args.rom.read_bytes()
        bank, address = h.sym['PokemonCries']
        base = bank * 0x4000 + (address & 0x3fff)
        constants = _parse_constants(ROOT / 'constants/cry_constants.asm')
        for species, params in manifest['protected'].items():
            fields = params.split(',')
            values = [constants[fields[0].strip()]] + [int(x.strip().replace('$', '0x'), 0)
                                                       for x in fields[1:]]
            wanted = b''.join((value & 65535).to_bytes(2, 'little') for value in values)
            offset = base + (h.con.species_index(species) - 1) * 6
            check(rom[offset:offset+6] == wanted, species + ': protected linked cry header unchanged')
        fixture = io.BytesIO()
        pb.save_state(fixture)
        pb.hook_register(*h.sym['Timer.sampled_uploaded'], capture_block, None)
        replacements = manifest['replacements']
        selected = args.species or list(replacements)
        timer_registers = (0xff07, 0xff06, 0xffff)
        for species in selected:
            fixture.seek(0)
            pb.load_state(fixture)
            decoded_blocks.clear()
            block_keys.clear()
            before = tuple(pb.memory[r] for r in timer_registers)
            index = h.con.species_index(species) - 1
            samples = invoke('PlayCry', D=index >> 8, E=index & 255)
            samples = np.concatenate((samples, invoke('WaitSFX')))
            expected = decode_ded((ROOT / f'audio/ded/{replacements[species]["source"]}.ded').read_bytes())
            actual = b''.join(decoded_blocks)
            check(actual == expected, species + ': every native decoded wave block matches')
            check(len(decoded_blocks) == len(expected)//16, species + ': exact decoded block count')
            check(m.read('wDEDUnderruns') == 0, species + ': stream never underruns')
            check(np.any(samples), species + ': audible native samples')
            check(tuple(pb.memory[r] for r in timer_registers) == before, species + ': timer and IE restored')
            check(m.read('hSoundKeepaliveOn') == 0 and pb.memory[0xff70] & 7 == 1,
                  species + ': HRAM and WRAM bank restored')
            check(not any(m.read(f'wChannel{i}Flags1') & 1 for i in range(5, 9)),
                  species + ': no stuck cry channels')
            rate = manifest['samples'][replacements[species]['source']]['sample_rate']
            duration = len(expected) * 2 / rate
            check(abs(len(samples)/pb.sound.sample_rate - duration) < .08,
                  species + ': original pitch/duration')
            print(f'CHECK {species}: {len(decoded_blocks)} wave blocks; {duration:.3f}s', flush=True)
        # Prove music and SFX recover after borrowing the hardware wave channel.
        if args.normal_speed:
            report = dict(rom=args.rom.name, checks=checks, failures=failures)
            (args.output / 'normal-speed-results.json').write_text(json.dumps(report, indent=2))
            print(f'{checks} checks; {len(failures)} failures', flush=True)
            return bool(failures)
        music = _parse_constants(ROOT / 'constants/music_constants.asm')['MUSIC_NEW_BARK_TOWN']
        invoke('PlayMusic', D=music >> 8, E=music & 255)
        for species in ('ZORUA', 'ZANGOOSE', 'TINKATON'):
            index = h.con.species_index(species) - 1
            invoke('PlayCry', D=index >> 8, E=index & 255)
            pb.tick(60, False, True)
            check(np.any(pb.sound.ndarray), species + ': music resumes after sample')
        effects = _parse_constants(ROOT / 'constants/sfx_constants.asm')
        effect = effects['SFX_SAVE']
        audio = invoke('PlaySFX', D=effect >> 8, E=effect & 255)
        audio = np.concatenate((audio, invoke('WaitSFX')))
        check(np.any(audio), 'native save SFX works after sampled cries')
        # The same player also works at normal CPU speed, without changing pitch.
        for species in ('HIPPOWDON', 'MAMOSWINE'):
            fixture.seek(0)
            pb.load_state(fixture)
            invoke('NormalSpeed')
            decoded_blocks.clear()
            block_keys.clear()
            index = h.con.species_index(species) - 1
            audio = invoke('PlayCry', D=index >> 8, E=index & 255)
            slug = replacements[species]['source']
            expected = decode_ded((ROOT / f'audio/ded/{slug}.ded').read_bytes())
            duration = len(expected)*2/manifest['samples'][slug]['sample_rate']
            check(b''.join(decoded_blocks) == expected, species + ': exact normal-speed decode')
            check(abs(len(audio)/pb.sound.sample_rate-duration) < .08, species + ': normal-speed pitch/duration')
            print(f'NORMAL {species}: {len(audio)/pb.sound.sample_rate:.3f}s; expected {duration:.3f}s', flush=True)
        report = dict(rom=args.rom.name, rom_sha256=hashlib.sha256(rom).hexdigest(),
                      checks=checks, failures=failures, recordings=records)
        (args.output / f'{args.rom.stem}-results.json').write_text(json.dumps(report, indent=2))
        if args.record and not failures:
            subprocess.run([sys.executable, str(ROOT / 'tools/battletest/record_sampled_cries.py'),
                            '--rom', str(args.rom), '--output', str(args.output),
                            *(['--species', *args.species] if args.species else [])], check=True)
        print(f'{checks} checks; {len(failures)} failures', flush=True)
        return bool(failures)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())

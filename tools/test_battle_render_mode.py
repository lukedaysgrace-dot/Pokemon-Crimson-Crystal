#!/usr/bin/env python3
"""Check automatic battle RAM and text monitoring with pixel rendering on/off."""
import hashlib
from pathlib import Path
import sys
from tempfile import TemporaryDirectory

import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness


def main():
    tests = yaml.safe_load((ROOT / 'tools/battletest/tests/00-smoke.yaml').read_text())
    harnesses = [Harness(render=True), Harness(render=False)]
    try:
        # An explicit alternate ROM must not share the default fixture key.
        source = ROOT / 'pokecrystal_debug.gbc'
        with TemporaryDirectory() as directory:
            path = Path(directory) / 'alternate.gbc'
            data = bytearray(source.read_bytes())
            data[-1] ^= 1  # unused ROM padding: distinct bytes, identical code
            path.write_bytes(data)
            path.with_suffix('.sym').write_bytes(source.with_suffix('.sym').read_bytes())
            alternate = Harness(rom_path=path, render=False)
            try:
                expected = hashlib.md5(data).hexdigest()[:12]
                assert alternate.rom_key() == expected
                assert alternate.fixture_path() != harnesses[0].fixture_path()
                # Simulate a rebuild of the file, without changing player ROMs.
                replacement = bytearray(data)
                replacement[0] ^= 1
                path.write_bytes(replacement)
                assert alternate.rom_key() == expected
            finally:
                alternate.pb.stop(save=False)
        for h in harnesses:
            h.ensure_fixture()
        for test in tests:
            results = []
            for h in harnesses:
                h.load_fixture()
                state = h.run_battle(test)
                results.append((state, h.pb.register_file.PC,
                                bytes(h.pb.memory[0xc000:0xd000]),
                                bytes(h.pb.memory[1, addr] for addr in range(0xd000, 0xe000)),
                                bytes(h.pb.memory[2, addr] for addr in range(0xd000, 0xe000)),
                                bytes(h.pb.memory[0xff80:0xffff]),
                                list(h.text_overflows), set(h.battle.textbox_contexts)))
            assert results[0] == results[1], f'render mode changed CPU/RAM/text: {test["name"]}'
        print(f'BATTLE RENDER MODE: {len(tests)} battles have identical CPU/RAM/text observations; alternate-ROM fixture keys passed')
    finally:
        for h in harnesses:
            h.pb.stop(save=False)


if __name__ == '__main__':
    main()

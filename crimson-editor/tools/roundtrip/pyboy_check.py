#!/usr/bin/env python3
"""Use the ROM's own load/ID/box decoder routines as an independent oracle."""
import argparse
import json
import sys
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--crimson', type=Path, default=Path(__file__).resolve().parents[3])
parser.add_argument('--save', type=Path, default=Path('tests/output/edited.sav'))
parser.add_argument('--expected', type=Path, default=Path('tests/output/edited.json'))
args = parser.parse_args()
sys.path.insert(0, str(args.crimson / 'tools'))
from pc_harness import Harness

h = Harness(str(args.crimson / 'pokecrystal.gbc'), str(args.crimson / 'pokecrystal.sym'))
try:
    h.boot()
    save = args.save.read_bytes()
    assert len(save) >= 65536
    for bank in range(8):
        h.sram_wr(bank, 0xa000, save[bank * 8192:(bank + 1) * 8192])
    result = h.call('TryLoadSaveFile')
    assert not result['c_flag'], 'ROM rejected edited save as corrupt'
    expected = json.loads(args.expected.read_text())
    assert h.rd(h.s('wPartyCount')) == len(expected['party'])
    stride = h.s('wPartyMon2') - h.s('wPartyMon1')
    for i, mon in enumerate(expected['party']):
        start = h.s('wPartyMon1') + i * stride
        assert h.species_index(h.rd(start)) == mon['species'], f'party species {i}'
        assert h.rd(start + h.s('wPartyMon1Level') - h.s('wPartyMon1')) == mon['level']
        assert bool(h.rd(h.s('wPartySpecies') + i) == 253) == mon['egg']
        for j, move in enumerate(mon['moves']):
            assert h.move_index(h.rd(start + h.s('wPartyMon1Moves') - h.s('wPartyMon1') + j)) == move
    for mon in expected['boxes']:
        result = h.call('GetStorageBoxMon', bc=(mon['box'] << 8) | mon['slot'])
        assert not result['c_flag'] and not result['z'], f'Bad Egg/empty: {mon}'
        assert h.rd16(h.s('wTempMonSpeciesIndex')) == mon['species']
        assert bool(h.rd(h.s('wTempMonUnused')) & 128) == mon['shiny']
        for j, move in enumerate(mon['moves']):
            assert h.move_index(h.rd(h.s('wTempMonMoves') + j)) == move
    print(f"ROM accepted save: {len(expected['party'])} party mons and {len(expected['boxes'])} boxed mons; IDs, moves, eggs and checksums verified.")
finally:
    h.pyboy.stop(save=False)

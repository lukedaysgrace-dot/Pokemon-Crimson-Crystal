#!/usr/bin/env python3
"""Native checks for Goldenrod's neon Shuckle sign (SHUCKS bar).

* LoadGoldenrodShuckleSignPalette puts the switched-off colours in the rock
  OBJ slot for each time of day, only in Goldenrod City.
* AnimateShucksNeonSign fades the hardware rock palette through the generated
  pulse table at night (rising then falling with hVBlankCounter) and leaves it
  alone by day, on other maps and while object palettes are faded.
* The object exists, uses the sign sprite and the rock palette.

Uses private emulator memory; no player saves are opened.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import _parse_constants

ROOT = Path(ROOT)


def rgb_rows(path):
    rows = []
    for line in path.read_text().splitlines():
        m = re.match(r'\s*RGB\s+(.*)', line)
        if m:
            values = [int(v) for v in m.group(1).split(',')]
            rows.append(b''.join((r | g << 5 | b << 10).to_bytes(2, 'little')
                                 for r, g, b in zip(values[::3], values[1::3], values[2::3])))
    return rows


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    sprite_pals = _parse_constants(ROOT / 'constants/sprite_data_constants.asm')
    rock = sprite_pals['PAL_OW_ROCK']
    statics = rgb_rows(ROOT / 'gfx/overworld/shuckle_sign.pal')
    pulse = rgb_rows(ROOT / 'gfx/overworld/shuckle_sign_pulse.pal')
    checks = 0

    def check(condition, label):
        nonlocal checks
        checks += 1
        assert condition, label

    maps = {}
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s*newgroup\s*(;|$)', line):
            group += 1
            number = 0
        match = re.match(r'\s*map_const (\w+),', line)
        if match:
            number += 1
            maps[match[1]] = group, number
    goldenrod, other = maps['GOLDENROD_CITY'], maps['ROUTE_34']

    def set_map(location):
        h.wr(h.s('wMapGroup'), location[0])
        h.wr(h.s('wMapNumber'), location[1])

    def read_obj_colours():
        h.mem[0xff6a] = rock * 8 + 2
        data = []
        for i in range(6):
            h.mem[0xff6a] = rock * 8 + 2 + i
            data.append(h.mem[0xff6b])
        return bytes(data)

    def write_obj_colours(data):
        h.mem[0xff6a] = 0x80 | (rock * 8 + 2)
        for value in data:
            h.mem[0xff6b] = value

    def read_wram(bank, address, size):
        previous = h.mem[0xff70]
        h.mem[0xff70] = bank
        data = bytes(h.mem[address:address + size])
        h.mem[0xff70] = previous
        return data

    try:
        check(len(statics) == 4 and len(pulse) == 16, 'generated palette tables have the wrong size')
        check(pulse[0] == statics[2][2:], 'the pulse does not start from the dark night colours')
        bank = h.sym.bank('wOBPals1')
        slot = h.s('wOBPals1') + rock * 8
        for location in (goldenrod, other):
            set_map(location)
            for daytime in range(4):
                h.wr(h.s('wTimeOfDayPal'), daytime)
                h.mem[0xff70] = bank
                h.mem[slot:slot + 8] = bytes([0x5a] * 8)
                h.mem[0xff70] = 1
                h.call('LoadGoldenrodShuckleSignPalette')
                expected = statics[daytime] if location == goldenrod else bytes([0x5a] * 8)
                check(read_wram(bank, slot, 8) == expected, f'sign palette: map={location}, time={daytime}')

        sentinel = bytes([0x11, 0x22, 0x33, 0x44, 0x55, 0x66])
        h.wr(h.s('hCGB'), 1)
        for location in (goldenrod, other):
            set_map(location)
            for daytime in range(4):
                h.wr(h.s('wTimeOfDayPal'), daytime)
                for faded in (False, True):
                    h.mem[0xff48] = 0b11010000 if faded else 0b11100100  # rOBP0
                    for counter in range(0, 256, 4):
                        h.wr(h.s('hVBlankCounter'), counter)
                        write_obj_colours(sentinel)
                        h.call('AnimateShucksNeonSign')
                        step = (counter >> 2) & 31
                        step = step if step < 16 else 31 - step
                        active = location == goldenrod and daytime >= 2 and not faded
                        expected = pulse[step] if active else sentinel
                        check(read_obj_colours() == expected,
                              f'pulse: map={location}, time={daytime}, faded={faded}, counter={counter}')

        source = (ROOT / 'maps/GoldenrodCity.asm').read_text()
        check(re.search(r'object_event 10, 20, SPRITE_SHUCKLE_SIGN, SPRITEMOVEDATA_STILL,.*PAL_NPC_ROCK', source),
              'Goldenrod is missing the neon Shuckle sign object')
        print(f'GOLDENROD SHUCKS NEON: {checks} checks passed in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()

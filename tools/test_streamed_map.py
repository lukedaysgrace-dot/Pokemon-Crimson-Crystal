#!/usr/bin/env python3
"""Compare compiled edge rendering against the unchanged full-map decoder.

Uses private PyBoy memory, never player saves. Covers every tileset, synthetic
independent upper-ROM-bank tables, all metatile quarters, borders, BG wrapping,
queue bounds, stale RAM buffers, bank restoration, and hardware-clock timing.
"""
import itertools
import json
from pathlib import Path
import random
import re
import sys

from pc_harness import Harness, ROOT

ROOT = Path(ROOT)


def check_rom(rom):
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    m = h.mem
    checks = cases = 0
    out = ROOT / '.tmpbuild/streamed-map' / rom.stem
    out.mkdir(parents=True, exist_ok=True)

    def check(ok, label):
        nonlocal checks
        checks += 1
        assert ok, f'{rom.name}: {label}'

    def put(name, value):
        h.wr(h.s(name), value)

    def word(name, value):
        h.wr16(h.s(name), value)

    def edge(data, direction):
        if direction < 2:
            start = 320 if direction == 0 else 0
            return data[start:start + 40]
        column = 18 if direction == 3 else 0
        return b''.join(data[y * 20 + column:y * 20 + column + 2] for y in range(18))

    def pointers(anchor, direction):
        row, col = divmod(anchor - 0x9800, 32)
        if direction < 2:
            row = (row + (16 if direction == 0 else 0)) % 32
            coords = [(row + y, col + x) for y in range(2) for x in range(0, 20, 2)]
        else:
            col = (col + (18 if direction == 3 else 0)) % 32
            coords = [(row + y, col) for y in range(18)]
        return b''.join((0x9800 + (y % 32) * 32 + x % 32).to_bytes(2, 'little') for y, x in coords)

    def prepare(direction, mx, my, width, anchor, table, blocks):
        m[0xffff] = 0
        m[0xff40] = 0
        m[0xff4f] = direction & 1
        for key, value in [('wPlayerStepDirection', direction), ('wMetatileStandingX', mx),
                           ('wMetatileStandingY', my), ('wMapWidth', width),
                           ('wMapBorderBlock', 1), ('hBGMapMode', 4), ('hBGMapUpdate', 0),
                           ('wTilesetBlocksBank', table[0]), ('wTilesetAttributesBank', table[3])]:
            put(key, value)
        word('wOverworldMapAnchor', h.s('wOverworldMapBlocks') + 7)
        word('wBGMapAnchor', anchor)
        word('wTilesetBlocksAddress', int.from_bytes(table[1:3], 'little'))
        word('wTilesetAttributesAddress', int.from_bytes(table[4:6], 'little'))
        put('wOverworldMapBlocks', blocks)

    def compare(direction, mx, my, width, anchor, table, blocks, label):
        nonlocal cases
        prepare(direction, mx, my, width, anchor, table, blocks)
        h.call('LoadMapPart')
        expected_tiles = edge(h.rd(h.s('wTileMap'), 360), direction)
        expected_attrs = edge(h.rd(h.s('wAttrMap'), 360), direction)
        # A walking update must not depend on or rebuild these stale buffers.
        put('wTileMap', bytes([0xa5]) * 360)
        put('wAttrMap', bytes([0x5a]) * 360)
        old_surrounding = bytes(m[h.sym.bank('wSurroundingTiles'),
                                  h.s('wSurroundingTiles'):h.s('wSurroundingAttributes') + 480])
        put('wBGMapBuffer', bytes([0xcc]) * 120)
        put('hBGMapMode', 4)
        put('hBGMapUpdate', 0)
        entry = ('ScrollMapDown', 'ScrollMapUp', 'ScrollMapLeft', 'ScrollMapRight')[direction]
        h.call(entry)
        count = 40 if direction < 2 else 36
        check(h.rd(h.s('wBGMapBuffer'), 40) == expected_tiles + bytes([0xcc]) * (40 - count), label + ' tiles/bounds')
        check(h.rd(h.s('wBGMapPalBuffer'), 40) == expected_attrs + bytes([0xcc]) * (40 - count), label + ' attributes/bounds')
        check(h.rd(h.s('wBGMapBufferPtrs'), 40) == pointers(anchor, direction) + bytes([0xcc]) * (40 - count), label + ' wrapped pointers/bounds')
        check(h.rd(h.s('hBGMapTileCount')) == count // 2 and h.rd(h.s('hBGMapUpdate')) == 1, label + ' complete queue published')
        check(h.rd(h.s('hBGMapMode')) == 0, label + ' stale full-screen upload disabled')
        check(h.rd(h.s('wTileMap'), 360) == bytes([0xa5]) * 360 and
              h.rd(h.s('wAttrMap'), 360) == bytes([0x5a]) * 360, label + ' no RAM screen rebuild')
        check(bytes(m[h.sym.bank('wSurroundingTiles'), h.s('wSurroundingTiles'):h.s('wSurroundingAttributes') + 480]) == old_surrounding,
              label + ' no surrounding-data rebuild')
        check(m[0xff70] & 7 == 1 and m[0xff4f] & 1 == direction & 1 and
              h.rd(h.s('hROMBank')) == h.sym.bank(entry), label + ' ROM/WRAM/VRAM banks restored')
        cases += 1

    try:
        # Real linked table locations, including independent attribute banks.
        names = re.findall(r'^\s*tileset (\w+)', (ROOT / 'data/tilesets.asm').read_text(), re.M)
        bank, address = h.sym['Tilesets']
        for index, name in enumerate(names):
            row = bytes(m[bank, address + index * 15:address + index * 15 + 15])
            table = row[3:6] + row[9:12]
            for direction, mx, my in itertools.product(range(4), range(2), range(2)):
                compare(direction, mx, my, 20, 0x9bde, table, bytes([1]) * 1300,
                        f'{name} direction={direction} quarter={mx},{my}')

        # Every byte-sized block ID, zero-border substitution, non-page-aligned
        # tables and ROM banks above $7f. ROM writes affect this emulator only.
        rng = random.Random(0x5354524d)
        for bank, base in [(0x80, 0x4003), (0xfe, 0x4ffb)]:
            data = bytes(rng.randrange(256) for _ in range(4096))
            for i, byte in enumerate(data):
                m[bank, base + i] = byte
        table = bytes([0x80, 3, 0x40, 0xfe, 0xfb, 0x4f])
        blocks = bytes(rng.randrange(256) for _ in range(1300))
        for direction, mx, my, width, anchor in itertools.product(
                range(4), range(2), range(2), (1, 7, 20, 59, 101), (0x9800, 0x981e, 0x9bc0, 0x9bde)):
            compare(direction, mx, my, width, anchor, table, blocks,
                    f'synthetic {direction}/{mx}/{my}/{width}/${anchor:04x}')

        # Exact full-width bank selection must also survive the full redraw.
        h.set_rom_bank(0xfe)
        h.call('LoadMapPart')
        check(h.rd(h.s('hROMBank')) == 0xfe, 'full redraw preserves upper source/caller banks')

        # Hardware DIV clock comparison with the old full decoder. The old
        # path also copied its edge afterward, so this is a conservative control.
        h.sym.by_name['TimedMap'] = (0, 0xc680)
        timing = {}
        for direction in range(4):
            values = []
            for target in ['LoadMapPart', ('ScrollMapDown', 'ScrollMapUp', 'ScrollMapLeft', 'ScrollMapRight')[direction]]:
                prepare(direction, 1, 1, 20, 0x9800, table, blocks)
                h.set_rom_bank(h.sym.bank('ScrollMapDown'))
                addr = h.s(target)
                h.wr(0xc680, [0xaf, 0xe0, 4, 0xcd, addr & 255, addr >> 8,
                             0xf0, 4, 0xea, 0xf0, 0xc6, 0xc9])
                h.call('TimedMap')
                values.append(m[0xc6f0])
            check(values[1] < values[0] * .7, f'direction {direction} runtime improvement: {values}')
            timing[str(direction)] = dict(full_redraw_div_ticks=values[0], streamed_edge_div_ticks=values[1])
        result = dict(rom=rom.name, checks=checks, cases=cases, tilesets=len(names), timing=timing)
        (out / 'routine-results.json').write_text(json.dumps(result, indent=2))
        print(json.dumps(result), flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        check_rom(rom)

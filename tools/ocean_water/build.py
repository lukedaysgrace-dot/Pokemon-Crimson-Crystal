#!/usr/bin/env python3
"""Build the open-sea water data (run by the Makefile).

Sources:
  gfx/tilesets/ocean/water.png   8 frames, 16x8 each, left to right: open sea
                                 (Polished Coral's Sunset Bay water).
  gfx/tilesets/ocean/shore.png   8 frames, 16x8 each, left to right: the water
                                 creeping up the sand and back (Coral's
                                 shoreline; sand on top). It goes on the sand
                                 row right above the sea, as in Coral.
                                 Magenta is see-through: it is filled with the
                                 sea as it is at that moment, so the swell
                                 runs right up into the crash.
                                 tools/ocean_water/import_coral.py draws both.
                                 Turned on its side (sand on the left), it is
                                 also the shoreline for beaches facing east,
                                 with the water crashing in to the left (see
                                 EAST_SHORE_MAPS).
  gfx/tilesets/ocean/rock.png    16x16 rocks standing in the sea. Magenta is
                                 see-through here too: the sea moves around
                                 the rocks.
  Sea and shore step together: frame N of each shows at step N.
  engine/tilesets/ocean_water.asm  the `ocean_map` list of open-sea maps
  the normal tileset metatiles/attributes/collision and map .ablk files

The shoreline only appears where the sea runs into land: beach directly
above water (the Olivine coast, the south shores of islands), and, on the
maps in EAST_SHORE_MAPS, beach directly left of water (the Cianwood coast).
Anywhere else, water beside or above land just flows past it.

Writes to data/ocean/ (generated, not committed):
  frames.2bpp                      OCEAN_ANIM_STEPS steps x 8 tiles
  <tileset>_metatiles.bin / _attributes.bin / _collision.bin
  <Map>.ablk                       the map with surf blocks along its coasts

Nothing in the normal tilesets or maps is changed: edit those as usual and
the sea follows on the next build.
"""
import os
import re
import sys
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, 'data', 'ocean')

SEA_FRAMES = 8
SURF_FRAMES = 8
STEPS = 8             # OCEAN_ANIM_STEPS: a multiple of both, and of 4 (whirlpools)
# Tiles in each animation step, in this order (see OceanTileSlots in
# engine/tilesets/ocean_water.asm for where each tileset keeps them in VRAM).
# S_E is the shoreline on its side, for beaches with the sea to their right.
W_L, W_R, S_L, S_R, R_TL, R_TR, R_BL, R_BR, S_E = range(9)
FRAME_TILES = 9       # OCEAN_FRAME_TILES

# Maps whose beaches facing east (sea to the right of the sand) also get the
# shoreline, crashing in to the left. Only maps whose whole coast faces that
# way: an island here would get surf on its east side but not its west.
EAST_SHORE_MAPS = {'CianwoodCity'}

CALM_WATER = (0x14, 0)   # (tile, VRAM bank)

# Per tileset: VRAM bank 1 tile for each of the 9 ocean tiles, the ground
# tiles that count as land for the surf, and the rock-in-water tile.
# Must match OceanTileSlots in engine/tilesets/ocean_water.asm.
TILESETS = {
    'TILESET_KANTO': dict(
        name='kanto',
        slots=[0x49, 0x4a, 0x4b, 0x4c, 0x54, 0x55, 0x56, 0x57, 0x4d],
        land={(0x39, 0)},
        rock=None),
    'TILESET_JOHTO': dict(
        name='johto',
        slots=[0x49, 0x4a, 0x4b, 0x4c, 0x58, 0x59, 0x5a, 0x5b, 0x26],
        land={(0x06, 0)},
        rock=(0x58, 0)),
    'TILESET_JOHTO_MODERN': dict(
        name='johto_modern',
        slots=[0x49, 0x4a, 0x4b, 0x4c, 0x1c, 0x1d, 0x1e, 0x1f, 0x4d],
        land={(0x06, 0)},
        rock=(0x58, 0)),
}

ATTR_BANK, ATTR_XFLIP, ATTR_YFLIP, ATTR_PAL = 0x08, 0x20, 0x40, 0x07
PAL_BG_WATER = 3
SEE_THROUGH = (255, 0, 255)   # in shore.png: show the sea underneath


def fail(msg):
    sys.exit(f'tools/ocean_water/build.py: {msg}')


def read(path, mode='r'):
    with open(os.path.join(ROOT, path), mode) as f:
        return f.read()


# ---------------------------------------------------------------- graphics

def load_shades(path):
    im = Image.open(os.path.join(ROOT, path)).convert('RGB')
    w, h = im.size
    px = im.load()

    def shade(rgb):
        if rgb == SEE_THROUGH:
            return -1
        lum = 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]
        return 0 if lum >= 230 else 1 if lum >= 150 else 2 if lum >= 60 else 3
    return [[shade(px[x, y]) for x in range(w)] for y in range(h)], w, h


def tile_2bpp(rows):
    out = bytearray()
    for row in rows:
        lo = hi = 0
        for c in row:
            lo = (lo << 1) | (c & 1)
            hi = (hi << 1) | (c >> 1)
        out += bytes((lo, hi))
    return bytes(out)


def cut(grid, x0, y0):
    return [row[x0:x0 + 8] for row in grid[y0:y0 + 8]]


def build_frames():
    strips = {}
    for name, frames in (('water', SEA_FRAMES), ('shore', SURF_FRAMES)):
        grid, w, h = load_shades(f'gfx/tilesets/ocean/{name}.png')
        if (w, h) != (16 * frames, 8):
            fail(f'{name}.png must be {16 * frames}x8 ({frames} 16x8 frames side by side)')
        strips[name] = grid
    if any(c < 0 for row in strips['water'] for c in row):
        fail('water.png cannot have see-through (magenta) pixels')
    rock, w, h = load_shades('gfx/tilesets/ocean/rock.png')
    if (w, h) != (16, 16):
        fail('rock.png must be 16x16')

    def see_through(art, sea):
        # magenta pixels show the sea under them (it repeats every 8 rows)
        return [[sea[y % 8][x] if c < 0 else c for x, c in enumerate(row)]
                for y, row in enumerate(art)]

    data = bytearray()
    for t in range(STEPS):
        f = t % SEA_FRAMES
        sea = [row[f * 16:f * 16 + 16] for row in strips['water']]
        f = t % SURF_FRAMES
        shore = [row[f * 16:f * 16 + 16] for row in strips['shore']]
        surf = see_through(shore, sea)
        rocks = see_through(rock, sea)
        # On its side: the right half of the shoreline flipped across its
        # diagonal, so the sand is on the left and the water comes in from
        # the right. East-facing beaches end on odd tile columns (blocks are
        # 2x2 aligned), so the water under it is the right half of the sea.
        east = [[shore[x][8 + y] for x in range(8)] for y in range(8)]
        east = [[sea[y][8 + x] if c < 0 else c for x, c in enumerate(row)]
                for y, row in enumerate(east)]
        for tile in (cut(sea, 0, 0), cut(sea, 8, 0), cut(surf, 0, 0), cut(surf, 8, 0),
                     cut(rocks, 0, 0), cut(rocks, 8, 0), cut(rocks, 0, 8), cut(rocks, 8, 8),
                     east):
            data += tile_2bpp(tile)
    assert len(data) == STEPS * FRAME_TILES * 16
    return bytes(data)


# ---------------------------------------------------------------- map data

def collision_values():
    vals = {}
    for line in read('constants/collision_constants.asm').splitlines():
        m = re.match(r'\s*(COLL_\w+)\s+EQU\s+\$([0-9a-fA-F]+)', line)
        if m:
            vals[m.group(1)] = int(m.group(2), 16)
    return vals


def collision_bin(name, coll):
    out = bytearray()
    for line in read(f'data/tilesets/{name}_collision.asm').splitlines():
        line = line.split(';')[0].strip()
        if not line:
            continue
        m = re.match(r'tilecoll\s+(.*)', line)
        if not m:
            fail(f'{name}_collision.asm: unexpected line "{line}"')
        for arg in m.group(1).split(','):
            key = 'COLL_' + arg.strip()
            if key not in coll:
                fail(f'{name}_collision.asm: unknown collision {arg.strip()}')
            out.append(coll[key])
    return out


def ocean_maps():
    src = read('engine/tilesets/ocean_water.asm')
    maps = re.findall(r'^\s*ocean_map\s+(\w+)\s*,\s*(\w+)', src, re.M)
    if not maps:
        fail('no ocean_map entries found in engine/tilesets/ocean_water.asm')
    dims = {}
    for m in re.finditer(r'^\s*map_const\s+(\w+)\s*,\s*(\d+)\s*,\s*(\d+)',
                         read('constants/map_constants.asm'), re.M):
        dims[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    tilesets = {}
    for m in re.finditer(r'^\s*map\s+(\w+)\s*,\s*(TILESET_\w+)', read('data/maps/maps.asm'), re.M):
        tilesets[m.group(1)] = m.group(2)
    out = []
    for const, name in maps:
        if const not in dims:
            fail(f'unknown map constant {const}')
        ts = tilesets.get(name)
        if ts not in TILESETS:
            fail(f'{name} uses {ts}; open sea only supports {", ".join(TILESETS)}')
        out.append((const, name, ts, dims[const]))
    return out


class Tileset:
    def __init__(self, ts, coll):
        cfg = TILESETS[ts]
        self.name = cfg['name']
        self.slots = cfg['slots']
        self.land = cfg['land']
        self.rock = cfg['rock']
        self.meta = bytearray(read(f'data/tilesets/{self.name}_metatiles.bin', 'rb'))
        self.attr = bytearray(read(f'data/tilesets/{self.name}_attributes.bin', 'rb'))
        self.coll = collision_bin(self.name, coll)
        self.count = len(self.meta) // 16
        if len(self.attr) != len(self.meta) or len(self.coll) != self.count * 4:
            fail(f'{self.name}: metatiles, attributes and collision disagree on block count')
        for i, (t, a) in enumerate(zip(self.meta, self.attr)):
            if a & ATTR_BANK and t in self.slots:
                fail(f'{self.name}: block ${i // 16:02x} uses VRAM bank 1 tile ${t:02x}, '
                     'which the open sea animation overwrites')
        self.new_blocks = {}       # (tiles, attrs) -> block id
        self.extra = []            # [(tiles, attrs, collision)]

    def tile(self, block, i):
        return self.meta[block * 16 + i], (self.attr[block * 16 + i] >> 3) & 1

    def convert(self, block, surf=None):
        """Ocean version of a block; tiles in surf (index -> 'S' for beach
        right above the sea, 'E' for beach right left of it) get the
        shoreline, in the water palette."""
        surf = surf or {}
        tiles = bytearray(self.meta[block * 16:block * 16 + 16])
        attrs = bytearray(self.attr[block * 16:block * 16 + 16])
        for i in range(16):
            row, col = i // 4, i % 4
            key = (tiles[i], (attrs[i] >> 3) & 1)
            if i in surf:
                if surf[i] == 'E':
                    logical = S_E
                else:
                    logical = S_R if col % 2 else S_L
                attrs[i] = (attrs[i] & ~ATTR_PAL) | PAL_BG_WATER
            elif key == CALM_WATER:
                logical = W_R if col % 2 else W_L
            elif self.rock and key == self.rock:
                logical = (R_BL if row % 2 else R_TL) + col % 2
            else:
                continue
            tiles[i] = self.slots[logical]
            attrs[i] = (attrs[i] & ~(ATTR_XFLIP | ATTR_YFLIP)) | ATTR_BANK
        return bytes(tiles), bytes(attrs)

    def block_id(self, block, surf):
        base = self.convert(block)
        conv = self.convert(block, surf)
        if conv == base:
            return block
        if conv not in self.new_blocks:
            new_id = self.count + len(self.extra)
            if new_id > 0xff:
                fail(f'{self.name}: too many shore blocks (no block ids left)')
            self.new_blocks[conv] = new_id
            self.extra.append((conv[0], conv[1], self.coll[block * 4:block * 4 + 4]))
        return self.new_blocks[conv]

    def tables(self):
        meta, attr, coll = bytearray(), bytearray(), bytearray(self.coll)
        for b in range(self.count):
            t, a = self.convert(b)
            meta += t
            attr += a
        for t, a, c in self.extra:
            meta += t
            attr += a
            coll += c
        return bytes(meta), bytes(attr), bytes(coll)


def build_map(ts, name, w, h, east_shore=False):
    blocks = read(f'maps/{name}.ablk', 'rb')
    if len(blocks) != w * h:
        fail(f'maps/{name}.ablk is {len(blocks)} bytes, expected {w}x{h}')
    W, H = w * 4, h * 4

    def tile_at(x, y):
        if not (0 <= x < W and 0 <= y < H):
            return None
        return ts.tile(blocks[(y // 4) * w + x // 4], (y % 4) * 4 + x % 4)

    # the shoreline goes on beach tiles with the sea right below them
    shore = {(x, y - 1): 'S' for y in range(1, H) for x in range(W)
             if tile_at(x, y) == CALM_WATER and tile_at(x, y - 1) in ts.land}
    if east_shore:
        # and on beach tiles with the sea right of them, crashing in to the
        # left (a corner with the sea below too keeps the normal shoreline)
        for y in range(H):
            for x in range(W - 1):
                if (x, y) not in shore and tile_at(x, y) in ts.land \
                        and tile_at(x + 1, y) == CALM_WATER:
                    shore[x, y] = 'E'
    out = bytearray()
    for by in range(h):
        for bx in range(w):
            surf = {}
            for i in range(16):
                pos = (bx * 4 + i % 4, by * 4 + i // 4)
                if pos in shore:
                    surf[i] = shore[pos]
            out.append(ts.block_id(blocks[by * w + bx], surf))
    return bytes(out), len(shore)


def write(path, data):
    full = os.path.join(OUT, path)
    try:
        with open(full, 'rb') as f:
            if f.read() == data:
                os.utime(full)   # keep make happy without changing contents
                return
    except FileNotFoundError:
        pass
    with open(full, 'wb') as f:
        f.write(data)


def main():
    os.makedirs(OUT, exist_ok=True)
    # frames.2bpp is the Makefile's target, so write it first: the other
    # files then end up newer than it and make leaves them alone.
    write('frames.2bpp', build_frames())
    coll = collision_values()
    tilesets = {}
    report = []
    maps = []
    maps_found = ocean_maps()
    for name in EAST_SHORE_MAPS - {m[1] for m in maps_found}:
        fail(f'EAST_SHORE_MAPS: {name} is not in the ocean_map list')
    for const, name, ts_const, (w, h) in maps_found:
        ts = tilesets.setdefault(ts_const, Tileset(ts_const, coll))
        data, count = build_map(ts, name, w, h, name in EAST_SHORE_MAPS)
        maps.append((name, data))
        report.append(f'{name}: {count} shore tiles')
    for name, data in maps:
        write(f'{name}.ablk', data)
    # every supported tileset gets tables, even if no map uses it yet
    for ts_const in TILESETS:
        ts = tilesets.get(ts_const) or Tileset(ts_const, coll)
        meta, attr, col = ts.tables()
        write(f'{ts.name}_metatiles.bin', meta)
        write(f'{ts.name}_attributes.bin', attr)
        write(f'{ts.name}_collision.bin', col)
        report.append(f'{ts.name}: {len(ts.extra)} shore blocks added')
    print('ocean water: ' + '; '.join(report))


if __name__ == '__main__':
    main()

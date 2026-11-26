"""Pixel-art kit for the Beast Triad card clubs and the Shucks card table.

A room is painted at native resolution on an RGB canvas (5-bit GBC colours),
together with a collision value for every 16x16 step.  `encode_room` then
splits the canvas into 8x8 tiles, gives each tile the first palette that holds
all of its colours (after `flatten`, which folds floor shading into the base
floor colour inside furniture tiles), deduplicates tiles (with flips) and
32x32 blocks, and returns everything a tileset and a map need.

`TilesetPatch` does the same for an existing tileset: it decodes the current
graphics with their palettes so new art can be painted over a map, and adds
only the tiles and blocks that changed.
"""

from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]

WALL, FLOOR, COUNTER = 'WALL', 'FLOOR', 'COUNTER'
WARP_DOWN, DOOR = 'WARP_CARPET_DOWN', 'DOOR'

# Image tile 127 is never loaded (see _CopyTilesetGFX): skip it.
TILE_SLOTS = [i for i in range(255) if i != 127]


class Canvas:
    def __init__(self, wsteps, hsteps, fill=(0, 0, 0)):
        self.w, self.h = wsteps * 16, hsteps * 16
        self.ws, self.hs = wsteps, hsteps
        self.px = [[fill] * self.w for _ in range(self.h)]
        self.coll = [[FLOOR] * wsteps for _ in range(hsteps)]
        self.prio = [[False] * (self.w // 8) for _ in range(self.h // 8)]

    # -- drawing -------------------------------------------------------------
    def set(self, x, y, c):
        if c is not None and 0 <= x < self.w and 0 <= y < self.h:
            self.px[y][x] = c

    def get(self, x, y):
        return self.px[y][x]

    def rect(self, x, y, w, h, c):
        for yy in range(y, y + h):
            for xx in range(x, x + w):
                self.set(xx, yy, c)

    def frame(self, x, y, w, h, c):
        self.rect(x, y, w, 1, c)
        self.rect(x, y + h - 1, w, 1, c)
        self.rect(x, y, 1, h, c)
        self.rect(x + w - 1, y, 1, h, c)

    def hline(self, x, y, w, c):
        self.rect(x, y, w, 1, c)

    def vline(self, x, y, h, c):
        self.rect(x, y, 1, h, c)

    def stamp(self, x, y, rows, key, flip=False):
        """Paint ASCII art: each character maps through `key` (None = skip)."""
        for dy, row in enumerate(rows):
            if flip:
                row = row[::-1]
            for dx, ch in enumerate(row):
                if ch in key:
                    self.set(x + dx, y + dy, key[ch])

    def paste(self, x, y, pixels, flip=False):
        """pixels: list of rows of colours or None (transparent)."""
        for dy, row in enumerate(pixels):
            if flip:
                row = row[::-1]
            for dx, c in enumerate(row):
                self.set(x + dx, y + dy, c)

    def block_coll(self, sx, sy, w, h, value):
        for yy in range(sy, sy + h):
            for xx in range(sx, sx + w):
                self.coll[yy][xx] = value

    def save_preview(self, path, scale=3, grid=False):
        im = Image.new('RGB', (self.w, self.h))
        im.putdata([rgb8(c) for row in self.px for c in row])
        im = im.resize((self.w * scale, self.h * scale), Image.NEAREST)
        if grid:
            from PIL import ImageDraw
            d = ImageDraw.Draw(im)
            for sy in range(self.hs):
                for sx in range(self.ws):
                    if self.coll[sy][sx] != FLOOR:
                        x0, y0 = sx * 16 * scale, sy * 16 * scale
                        d.rectangle([x0 + 2, y0 + 2, x0 + 16 * scale - 3, y0 + 16 * scale - 3],
                                    outline=(255, 60, 60) if self.coll[sy][sx] == WALL else (60, 160, 255))
        Path(path).parent.mkdir(parents=True, exist_ok=True)
        im.save(path)


def rgb8(c):
    return tuple(v * 255 // 31 for v in c)


# -- encoding -----------------------------------------------------------------

def tile_at(canvas, tx, ty):
    return [canvas.px[ty * 8 + y][tx * 8:tx * 8 + 8] for y in range(8)]


def choose_palette(tile, palettes, flatten, where):
    colours = {c for row in tile for c in row}
    for attempt in (tile, [[flatten.get(c, c) for c in row] for row in tile]):
        colours = {c for row in attempt for c in row}
        for i, pal in enumerate(palettes):
            if pal is not None and colours <= set(pal):
                return i, [[pal.index(c) for c in row] for row in attempt]
    raise ValueError(f'no palette holds the colours {sorted(colours)} of tile {where}')


def variants(idx):
    t = tuple(tuple(r) for r in idx)
    xf = tuple(tuple(r[::-1]) for r in idx)
    yf = tuple(reversed(t))
    xyf = tuple(reversed(xf))
    return [(t, 0), (xf, 0x20), (yf, 0x40), (xyf, 0x60)]


class TileStore:
    def __init__(self, existing=None, free_slots=None):
        self.slots = {}   # slot -> pixel tuple
        self.lookup = {}  # pixel tuple -> (slot, flip attr)
        for slot, pix in (existing or {}).items():
            self.add_at(slot, pix)
        self.free = list(free_slots if free_slots is not None else TILE_SLOTS)
        self.free = [s for s in self.free if s not in self.slots]

    def add_at(self, slot, pix):
        self.slots[slot] = pix
        for v, flip in variants(pix):
            self.lookup.setdefault(v, (slot, flip))

    def get(self, idx):
        t = tuple(tuple(r) for r in idx)
        if t in self.lookup:
            return self.lookup[t]
        if not self.free:
            raise ValueError('out of tile slots')
        slot = self.free.pop(0)
        self.add_at(slot, t)
        return slot, 0


def encode_block(canvas, bx, by, palettes, flatten, store):
    tiles, attrs = [], []
    for ty in range(4):
        for tx in range(4):
            gx, gy = bx * 4 + tx, by * 4 + ty
            pal, idx = choose_palette(tile_at(canvas, gx, gy), palettes, flatten, (gx, gy))
            slot, flip = store.get(idx)
            bank = 0x08 if slot >= 128 else 0
            prio = 0x80 if canvas.prio[gy][gx] else 0
            tiles.append(slot & 0x7f)
            attrs.append(pal | bank | flip | prio)
    coll = tuple(canvas.coll[by * 2 + qy][bx * 2 + qx] for qy in range(2) for qx in range(2))
    return bytes(tiles), bytes(attrs), coll


def encode_room(canvas, palettes, flatten, store=None, blocks=None):
    """Returns (store, blocks list[(tiles, attrs, coll)], blk bytes)."""
    store = store or TileStore()
    blocks = blocks if blocks is not None else []
    index = {b: i for i, b in enumerate(blocks)}
    blk = []
    for by in range(canvas.hs // 2):
        for bx in range(canvas.ws // 2):
            b = encode_block(canvas, bx, by, palettes, flatten, store)
            if b not in index:
                index[b] = len(blocks)
                blocks.append(b)
            blk.append(index[b])
    assert len(blocks) <= 256, len(blocks)
    return store, blocks, bytes(blk)


def write_tileset(name, store, blocks):
    n = max(store.slots) + 1
    rows = (n + 15) // 16
    im = Image.new('L', (128, rows * 8), 255)
    for slot, pix in store.slots.items():
        for y in range(8):
            for x in range(8):
                im.putpixel(((slot % 16) * 8 + x, (slot // 16) * 8 + y), 255 - pix[y][x] * 85)
    im.save(ROOT / f'gfx/tilesets/{name}.png')
    (ROOT / f'data/tilesets/{name}_metatiles.bin').write_bytes(b''.join(b[0] for b in blocks))
    (ROOT / f'data/tilesets/{name}_attributes.bin').write_bytes(b''.join(b[1] for b in blocks))
    lines = [f'\ttilecoll {", ".join(b[2])} ; {i:02x}' for i, b in enumerate(blocks)]
    (ROOT / f'data/tilesets/{name}_collision.asm').write_text('\n'.join(lines) + '\n')


def write_palette(name, palettes, comment):
    lines = [f'; {comment}']
    for pal in palettes:
        lines.append('\tRGB ' + ', '.join(f'{c[0]:02d}, {c[1]:02d}, {c[2]:02d}' for c in pal))
    (ROOT / f'gfx/tilesets/{name}.pal').write_text('\n'.join(lines) + '\n')


# -- existing tilesets -----------------------------------------------------------

def load_png_tiles(path):
    im = Image.open(path).convert('L')
    out = {}
    for ty in range(im.height // 8):
        for tx in range(im.width // 8):
            out[ty * 16 + tx] = tuple(tuple(3 - im.getpixel((tx * 8 + x, ty * 8 + y)) // 85
                                            for x in range(8)) for y in range(8))
    return out


class TilesetPatch:
    """Paint over maps that use an existing tileset; only new art is added."""

    def __init__(self, name, palettes, coll_names):
        self.name = name
        self.palettes = palettes
        self.png = ROOT / f'gfx/tilesets/{name}.png'
        self.tiles = load_png_tiles(self.png)
        meta = (ROOT / f'data/tilesets/{name}_metatiles.bin').read_bytes()
        attr = (ROOT / f'data/tilesets/{name}_attributes.bin').read_bytes()
        self.coll_lines = (ROOT / f'data/tilesets/{name}_collision.asm').read_text().splitlines()
        self.coll_lines = [l for l in self.coll_lines if 'tilecoll' in l]
        self.blocks = []
        for i in range(len(meta) // 16):
            coll = tuple(x.strip() for x in self.coll_lines[i].split('tilecoll')[1].split(';')[0].split(','))
            self.blocks.append((meta[i * 16:i * 16 + 16], attr[i * 16:i * 16 + 16], coll))
        used = {(m & 0x7f) | (0x80 if a & 8 else 0) for b in self.blocks for m, a in zip(b[0], b[1])}
        existing = {s: t for s, t in self.tiles.items() if s in used}
        free = [s for s in TILE_SLOTS if s not in used]
        self.store = TileStore(existing, free)

    def tile_pixels(self, t, a):
        pix = self.tiles[(t & 0x7f) | (0x80 if a & 8 else 0)]
        if a & 0x20:
            pix = tuple(tuple(r[::-1]) for r in pix)
        if a & 0x40:
            pix = tuple(reversed(pix))
        pal = self.palettes[a & 7]
        return [[pal[i] for i in r] for r in pix]

    def canvas_for(self, blk, wblocks):
        hblocks = len(blk) // wblocks
        cv = Canvas(wblocks * 2, hblocks * 2)
        for by in range(hblocks):
            for bx in range(wblocks):
                t, a, coll = self.blocks[blk[by * wblocks + bx]]
                for i in range(16):
                    pix = self.tile_pixels(t[i], a[i])
                    for y in range(8):
                        for x in range(8):
                            cv.px[by * 32 + (i // 4) * 8 + y][bx * 32 + (i % 4) * 8 + x] = pix[y][x]
                    cv.prio[by * 4 + i // 4][bx * 4 + i % 4] = bool(a[i] & 0x80)
                for q in range(4):
                    cv.coll[by * 2 + q // 2][bx * 2 + q % 2] = coll[q]
        return cv

    def block_id(self, canvas, bx, by, flatten, fixed_palette=None):
        pals = self.palettes
        if fixed_palette is not None:
            pals = [p if i in fixed_palette else None for i, p in enumerate(self.palettes)]
        b = encode_block(canvas, bx, by, pals, flatten, self.store)
        if b in self.blocks:
            return self.blocks.index(b)
        self.blocks.append(b)
        return len(self.blocks) - 1

    def write(self):
        n = max(max(self.store.slots) + 1, len(self.tiles))
        rows = (n + 15) // 16
        im = Image.new('L', (128, rows * 8), 255)
        for slot, pix in {**self.tiles, **self.store.slots}.items():
            for y in range(8):
                for x in range(8):
                    im.putpixel(((slot % 16) * 8 + x, (slot // 16) * 8 + y), 255 - pix[y][x] * 85)
        im.save(self.png)
        (ROOT / f'data/tilesets/{self.name}_metatiles.bin').write_bytes(b''.join(b[0] for b in self.blocks))
        (ROOT / f'data/tilesets/{self.name}_attributes.bin').write_bytes(b''.join(b[1] for b in self.blocks))
        lines = [f'\ttilecoll {", ".join(b[2])} ; {i:02x}' for i, b in enumerate(self.blocks)]
        (ROOT / f'data/tilesets/{self.name}_collision.asm').write_text('\n'.join(lines) + '\n')


def parse_pal(path, start=0):
    import re
    pals = []
    for line in Path(path).read_text().splitlines():
        line = line.split(';')[0]
        if 'RGB' in line:
            v = [int(x) for x in re.findall(r'\d+', line)]
            pals.append([tuple(v[i:i + 3]) for i in range(0, 12, 3)])
    return pals[start:start + 8]

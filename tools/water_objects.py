#!/usr/bin/env python3
"""Animate the water behind objects that sit in water (rocks, port posts).

Each object tile is copied into VRAM bank 1 slots, once per water quadrant it
sits on. For every one of the 8 water2.png frames, the object's water pixels
are replaced with that frame's water, so the water around the object moves
with the rest of the water. AnimateWaterTile (engine/tilesets/tileset_anims.asm)
copies the current frame of these tiles along with the water.

Writes, for each tileset in OBJECTS:
  gfx/tilesets/water/<tileset>_objects.png   8 frames (rows) x N tiles
  gfx/tilesets/<tileset>.png                 frame 0 into the bank 1 slots
  data/tilesets/<tileset>_metatiles.bin/_attributes.bin
                                             object tiles -> their new slots
                                             (only the first time it's run)

Re-run from the repo root after editing water2.png or an object tile:
    python3 tools/water_objects.py
The object's original tile stays in the tileset image, so edit that one.
Pixels outside the object's dark (darkest shade) outline count as water.
"""
from PIL import Image

WATER = 'gfx/tilesets/water/water2.png'
BANK1 = 0x08
SHADE = {255: 0, 170: 1, 85: 2, 0: 3}
GRAY = [255, 170, 85, 0]

# tileset: list of objects. Each object is a grid of bank 0 tile ids (rows of
# tiles) and the bank 1 slot of its first variant. A 1x1 object gets one
# variant per water quadrant (top-left, top-right, bottom-left, bottom-right);
# a 2x2 object gets one variant per tile.
OBJECTS = {
    'johto': [
        ([[0x58]], 0x02),  # rock
    ],
    'johto_modern': [
        ([[0x58]], 0x00),  # rock
    ],
    'port': [
        ([[0x13]], 0x00),  # rock
        ([[0x01, 0x02], [0x11, 0x12]], 0x04),  # post
    ],
}


def load_tiles(path):
    im = Image.open(path).convert('L')
    px = im.load()
    w, h = im.size
    return im, [[[SHADE[px[(i % (w // 8)) * 8 + x, (i // (w // 8)) * 8 + y]]
                  for x in range(8)] for y in range(8)]
                for i in range((w // 8) * (h // 8))]


def hull(pts):
    pts = sorted(set(pts))
    if len(pts) < 3:
        return pts
    def cross(o, a, b):
        return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
    lo, hi = [], []
    for p in pts:
        while len(lo) >= 2 and cross(lo[-2], lo[-1], p) <= 0:
            lo.pop()
        lo.append(p)
    for p in reversed(pts):
        while len(hi) >= 2 and cross(hi[-2], hi[-1], p) <= 0:
            hi.pop()
        hi.append(p)
    return lo[:-1] + hi[:-1]


def water_mask(img, w, h):
    """True where the pixel is water: outside the convex hull of the
    object's darkest-shade pixels."""
    H = hull([(x, y) for y in range(h) for x in range(w) if img[y][x] == 3])
    def inside(x, y):
        if len(H) < 3:
            return (x, y) in H
        for i in range(len(H)):
            a, b = H[i], H[(i + 1) % len(H)]
            if (b[0] - a[0]) * (y - a[1]) - (b[1] - a[1]) * (x - a[0]) < 0:
                return False
        return True
    return [[not inside(x, y) for x in range(w)] for y in range(h)]


def main():
    _, water = load_tiles(WATER)  # 8 frames x 4 tiles (TL, TR, BL, BR)
    assert len(water) == 32, 'water2.png must be 16x128'

    for ts, objects in OBJECTS.items():
        tpath = f'gfx/tilesets/{ts}.png'
        tim, tiles = load_tiles(tpath)
        mpath = f'data/tilesets/{ts}_metatiles.bin'
        apath = f'data/tilesets/{ts}_attributes.bin'
        m = bytearray(open(mpath, 'rb').read())
        a = bytearray(open(apath, 'rb').read())

        # variants: (source tile, quadrant, slot, mask)
        variants = []
        for grid, slot in objects:
            gh, gw = len(grid), len(grid[0])
            if gh == 1 and gw == 1:
                t = grid[0][0]
                mask = water_mask(tiles[t], 8, 8)
                for q in range(4):
                    variants.append((t, q, slot + q, mask))
            else:
                assert (gh, gw) == (2, 2), 'objects must be 1x1 or 2x2 tiles'
                img = [[tiles[grid[y // 8][x // 8]][y % 8][x % 8]
                        for x in range(16)] for y in range(16)]
                big = water_mask(img, 16, 16)
                for ty in range(2):
                    for tx in range(2):
                        mask = [[big[ty * 8 + y][tx * 8 + x] for x in range(8)]
                                for y in range(8)]
                        variants.append((grid[ty][tx], ty * 2 + tx,
                                         slot + ty * 2 + tx, mask))

        slots = [v[2] for v in variants]
        assert slots == list(range(slots[0], slots[0] + len(slots))), \
            f'{ts}: object slots must be consecutive'

        # First run (blocks still use the original tiles): the bank 1 slots
        # must not be used by anything else yet.
        sources = {v[0] for v in variants}
        first_run = any(t in sources and not (at & BANK1) for t, at in zip(m, a))
        if first_run:
            for tile, attr in zip(m, a):
                assert not (attr & BANK1 and tile in slots), \
                    f'{ts}: bank 1 tile ${tile:02x} is already used by a block'
        n = len(variants)

        # frames image: row f = frame f, N tiles across
        fim = Image.new('L', (8 * n, 8 * 8), 255)
        fpx = fim.load()
        for i, (t, q, slot, mask) in enumerate(variants):
            for f in range(8):
                wtile = water[f * 4 + q]
                for y in range(8):
                    for x in range(8):
                        s = wtile[y][x] if mask[y][x] else tiles[t][y][x]
                        fpx[i * 8 + x, f * 8 + y] = GRAY[s]
                        if f == 0:
                            idx = 0x80 + slot
                            tim.putpixel(((idx % 16) * 8 + x, (idx // 16) * 8 + y), GRAY[s])
        fim.save(f'gfx/tilesets/water/{ts}_objects.png')
        tim.save(tpath)

        # point the object tiles at their variants (bank 0 references only)
        lookup = {(t, q): slot for t, q, slot, _ in variants}
        changed = 0
        for k in range(len(m)):
            if a[k] & BANK1:
                continue
            pos = k % 16
            q = (pos // 4 % 2) * 2 + (pos % 2)
            if (m[k], q) in lookup:
                assert not (a[k] & 0x60), f'{ts}: flipped object tile at {k}'
                m[k] = lookup[(m[k], q)]
                a[k] |= BANK1
                changed += 1
        open(mpath, 'wb').write(m)
        open(apath, 'wb').write(a)
        print(f'{ts}: {n} animated object tiles (bank 1 ${slots[0]:02x}-${slots[-1]:02x}), '
              f'{changed} block tiles repointed')


if __name__ == '__main__':
    main()

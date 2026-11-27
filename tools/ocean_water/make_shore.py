#!/usr/bin/env python3
"""Draw gfx/tilesets/ocean/shore.png, the surf crashing into land.

    python3 tools/ocean_water/make_shore.py

The PNG is what the build uses, so you can also just edit it by hand; this
script is a starting point. Layout: 8 frames of 16x8 side by side, land at
the top. The wave rolls in, crashes onto the sand, then pulls back and
uncovers a little of the beach (drawn in the sand's own pattern).

Magenta pixels are see-through: the build fills them with the open sea from
water.png as it is at that moment, so the surf sits on the same moving water
as the tiles around it and joins up with them seamlessly.
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SEA = -1   # see-through: the open sea shows here
COLOURS = {0: (248, 248, 232), 1: (80, 224, 248), 2: (0, 152, 232), 3: (0, 0, 0),
           SEA: (255, 0, 255)}

FRAMES = 8
LINE = [4, 3, 2, 1, 0, 0, 2, 3]      # waterline distance from the beach, per frame
STAGE = ['in', 'in', 'in', 'in', 'crash', 'spread', 'out', 'out']
WOBBLE = [0, 0, 1, 1, 1, 0, 0, -1, -1, -1, 0, 0, 1, 0, 0, 0]
BUBBLES = [0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0]
# The beach ground tile (Johto/Kanto sand): where the wave pulls back, the
# sand it uncovers carries on this pattern. Colour 0 of the water palette is
# set to the map's sand colour on open-sea maps, and the speckles use SPECKLE.
GROUND = ['00000000', '01000001', '00001000', '00000000',
          '10000000', '00000001', '00000000', '01000000']
SPECKLE = 2   # mid-blue: wet sand right at the water's edge


def sea_frames():
    im = Image.open(os.path.join(ROOT, 'gfx/tilesets/ocean/water.png')).convert('RGB')
    px = im.load()
    inv = {v: k for k, v in COLOURS.items()}
    frames = im.width // 16
    return [[[inv.get(px[f * 16 + x, y], 1) for x in range(16)] for y in range(8)]
            for f in range(frames)]


def paint(k, w, h, dist, along, sea):
    """dist(x, y): px from the beach; along(x, y): position along the shore."""
    grid = [[1] * w for _ in range(h)]
    for y in range(h):
        for x in range(w):
            a = along(x, y)
            rel = dist(x, y) - LINE[k]
            if rel < 0:                                 # the beach, uncovered
                c = SPECKLE if GROUND[y % 8][x % 8] == '1' else 0
            elif rel == 0:
                c = 0 if (STAGE[k] in ('crash', 'spread') or BUBBLES[(a * 3 + k) % 16]) else 2
            elif rel == 1:
                c = 0 if BUBBLES[(a + k * 5) % 16] else SEA      # froth on the sea
            elif rel == 2:
                c = 0 if (STAGE[k] == 'crash' and BUBBLES[(a + 3) % 16]) else SEA
            else:
                c = SEA
            if STAGE[k] == 'out' and rel == -1 and BUBBLES[(a * 7 + k) % 16] and (a + k) % 3 == 0:
                c = 1                                      # a little water left on the sand
            grid[y][x] = c
    return grid


def main():
    sea = sea_frames()
    im = Image.new('RGB', (16 * FRAMES, 8))
    px = im.load()
    for k in range(FRAMES):
        s = sea[k % len(sea)]
        frame = paint(k, 16, 8, lambda x, y: y - WOBBLE[(x + k) % 16], lambda x, y: x, s)
        for y in range(8):
            for x in range(16):
                px[k * 16 + x, y] = COLOURS[frame[y][x]]
    out = os.path.join(ROOT, 'gfx/tilesets/ocean/shore.png')
    im.save(out)
    print('wrote', out)


if __name__ == '__main__':
    main()

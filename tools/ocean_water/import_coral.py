#!/usr/bin/env python3
"""Draw the open-sea art from Polished Coral's Sunset Bay water and shoreline.

    python3 tools/ocean_water/import_coral.py <path to polishedcoral>

Writes gfx/tilesets/ocean/water.png and shore.png (the build uses those PNGs,
so you can also edit them by hand afterwards). Both are 8 frames of 16x8 side
by side, the same tile twice per frame, and they step together, as in Coral:

  water.png  Coral's water tile (gfx/tilesets/water/water.2bpp, the 2nd of
             each frame's 4 tiles): the diagonal swell.
  shore.png  Coral's shoreline tile (gfx/tilesets/shoreline/shore.2bpp, the
             2nd of each frame's 4 tiles): the water creeping up the sand and
             back. It goes on the sand row right above the sea. The flat dark
             water under Coral's foam lines is made see-through (magenta), so
             the moving swell from water.png runs right up into the crash
             instead of a plain block of blue.

rock.png is not touched: its open water (the dark blue joined to the tile's
edges) is already magenta, so the swell moves around the rocks too.
"""
import os
import sys
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
# the water palette's daytime colours: the build picks shades by brightness
COLOURS = [(216, 248, 216), (144, 152, 248), (104, 96, 248), (56, 56, 56)]
SEE_THROUGH = (255, 0, 255)
FRAMES = 8


def tiles(path):
    d = open(path, 'rb').read()
    return [[[((d[o + 2 * y] >> (7 - x)) & 1) | (((d[o + 2 * y + 1] >> (7 - x)) & 1) << 1)
              for x in range(8)] for y in range(8)] for o in range(0, len(d), 16)]


def strip(frames, see_through=()):
    im = Image.new('RGB', (16 * FRAMES, 8))
    px = im.load()
    for f, t in enumerate(frames):
        for y in range(8):
            for x in range(16):
                c = t[y][x % 8]
                px[f * 16 + x, y] = SEE_THROUGH if c in see_through else COLOURS[c]
    return im


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    coral = sys.argv[1]
    water = tiles(os.path.join(coral, 'gfx/tilesets/water/water.2bpp'))
    shore = tiles(os.path.join(coral, 'gfx/tilesets/shoreline/shore.2bpp'))
    # each frame is 4 tiles; the open water / straight shoreline is the 2nd
    out = os.path.join(ROOT, 'gfx/tilesets/ocean')
    strip([water[f * 4 + 1] for f in range(FRAMES)]).save(os.path.join(out, 'water.png'))
    strip([shore[f * 4 + 1] for f in range(FRAMES)], see_through=(2,)).save(os.path.join(out, 'shore.png'))
    print('wrote water.png and shore.png from', coral)


if __name__ == '__main__':
    main()

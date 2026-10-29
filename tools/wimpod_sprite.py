#!/usr/bin/env python3
"""Compile Wimpod's six walking poses with explicit opaque gray/purple slots."""
from pathlib import Path
import sys

from pokemontools import png


def convert(source, target):
    width, height, rows, _ = png.Reader(filename=str(source)).asRGBA8()
    if (width, height) != (16, 96):
        raise ValueError('Wimpod needs six stacked 16x16 down/up/left poses')
    # Preserve the editable colored PNG; only true white/alpha is transparent.
    palette = {(255, 255, 255): 0, (198, 188, 180): 1,
               (148, 33, 148): 2, (0, 0, 0): 3}
    pixels = []
    for row in rows:
        pixels.append([0 if row[x+3] < 128 else palette[tuple(row[x:x+3])]
                       for x in range(0, width * 4, 4)])
    data = bytearray()
    for y in range(0, height, 8):
        for x in range(0, width, 8):
            for row in pixels[y:y+8]:
                low = high = 0
                for value in row[x:x+8]:
                    low = (low << 1) | (value & 1)
                    high = (high << 1) | (value >> 1)
                data.extend((low, high))
    Path(target).write_bytes(data)


if __name__ == '__main__':
    convert(*sys.argv[1:])

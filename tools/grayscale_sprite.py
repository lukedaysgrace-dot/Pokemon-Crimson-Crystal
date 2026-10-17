#!/usr/bin/env python3
"""Compile grayscale PNG sprites to GB 2bpp, snapping export noise to 4 shades.

White is transparent color 0, followed by light gray, dark gray and black.
The source PNG remains the editable art; tiles use normal row-major ordering.
"""
import sys
from pathlib import Path

from pokemontools import png


def convert(source, target):
    width, height, rows, _ = png.Reader(filename=str(source)).asRGBA8()
    if width % 8 or height % 8:
        raise ValueError('Sprite dimensions must be multiples of eight')
    shades = (255, 170, 85, 0)
    pixels = []
    for row in rows:
        indices = []
        for x in range(width):
            red, green, blue, alpha = row[x*4:x*4+4]
            if alpha < 128:
                indices.append(0)
            elif red != green or red != blue:
                raise ValueError('This converter requires grayscale sprite art')
            else:
                indices.append(min(range(4), key=lambda i: abs(red-shades[i])))
        pixels.append(indices)
    data = bytearray()
    for y in range(0, height, 8):
        for x in range(0, width, 8):
            for row in pixels[y:y+8]:
                low = high = 0
                for value in row[x:x+8]:
                    low = (low << 1) | (value & 1)
                    high = (high << 1) | (value >> 1)
                data.extend((low,high))
    Path(target).write_bytes(data)


if __name__ == '__main__':
    convert(*sys.argv[1:])

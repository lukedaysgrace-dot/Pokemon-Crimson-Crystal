#!/usr/bin/env python3
"""
Bootstrap gfx/overworld/rain.png with the original overworld raindrop art.

The Makefile runs this only when the PNG does not exist, so once it has been
generated (or committed) it is safe to edit freely in any image editor. The
PNG is a 4-shade grayscale image; white is color 0 (transparent).

With --normalize, instead rewrite the given .2bpp files in place so that
every non-transparent pixel becomes color 2 - the silver palette slot that
ApplyWeatherTint recolors to rain blue. This lets rain.png and
rain_splash.png be drawn in any shade and still read as rain-colored.

Usage: python3 tools/rain_png.py gfx/overworld/rain.png
       python3 tools/rain_png.py --normalize file.2bpp [...]
"""

import struct
import sys
import zlib

# Original streak art, GB 2bpp format (per row: low bitplane byte, high
# bitplane byte). All lit pixels are color 2.
TILE = bytes([
    0x00, 0x00,
    0x00, 0x08,
    0x00, 0x08,
    0x00, 0x10,
    0x00, 0x10,
    0x00, 0x20,
    0x00, 0x00,
    0x00, 0x00,
])

SHADES = (0xFF, 0xAA, 0x55, 0x00)  # color index 0..3 -> gray value


def chunk(tag, data):
    return (
        struct.pack(">I", len(data))
        + tag
        + data
        + struct.pack(">I", zlib.crc32(tag + data))
    )


def normalize(paths):
    for path in paths:
        with open(path, "rb") as f:
            data = f.read()
        out = bytearray()
        for i in range(0, len(data) - 1, 2):
            lit = data[i] | data[i + 1]  # any non-zero color index
            out += bytes((0, lit))  # low plane 0, high plane set -> color 2
        with open(path, "wb") as f:
            f.write(out)


def main():
    if sys.argv[1] == "--normalize":
        normalize(sys.argv[2:])
        return
    out_path = sys.argv[1]

    raw = bytearray()
    for y in range(8):
        lo = TILE[2 * y]
        hi = TILE[2 * y + 1]
        raw.append(0)  # PNG filter type: None
        for bit in range(7, -1, -1):
            idx = (((hi >> bit) & 1) << 1) | ((lo >> bit) & 1)
            raw.append(SHADES[idx])

    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", 8, 8, 8, 0, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + chunk(b"IEND", b"")
    )

    with open(out_path, "wb") as f:
        f.write(png)


if __name__ == "__main__":
    main()

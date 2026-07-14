#!/usr/bin/env python3
"""Apply reproducible fixes for documented legacy graphics defects.

The assertions intentionally make this script stop if an asset no longer has
the expected pre-fix pixels/bytes.  This avoids silently modifying the wrong
part of an asset after later artwork changes.
"""

from pathlib import Path

from PIL import Image


def patch_pixels(path, changes):
    image = Image.open(path)
    pixels = image.load()
    for (x, y), old, new in changes:
        actual = pixels[x, y]
        if actual == new:
            continue
        if actual != old:
            raise ValueError(
                f"{path}: expected pixel {(x, y)} to be {old}, got {actual}"
            )
        pixels[x, y] = new
    image.save(path)
    print(f"{path}: verified/applied {len(changes)} pixel corrections")


def patch_metatile(path):
    data = bytearray(Path(path).read_bytes())
    # Block $5b: the bottom-left corners of its three stones accidentally use
    # tile $4b.  Block $5c demonstrates the intended matching tile, $47.
    offsets = [0x5B * 16 + index for index in (4, 6, 12)]
    for offset in offsets:
        actual = data[offset]
        if actual == 0x47:
            continue
        if actual != 0x4B:
            raise ValueError(
                f"{path}: expected byte ${offset:04x} to be $4b, got ${actual:02x}"
            )
        data[offset] = 0x47
    Path(path).write_bytes(data)
    print(f"{path}: verified/applied {len(offsets)} metatile corrections")


if __name__ == "__main__":
    patch_pixels(
        "gfx/battle/hp_exp_bar_border.png",
        [
            ((16, 4), 0, 255),
            ((19, 4), 0, 255),
            ((22, 4), 0, 255),
            ((16, 6), 255, 0),
            ((19, 6), 255, 0),
            ((22, 6), 255, 0),
        ],
    )

    port_changes = [
        ((96, 0), 255, 85),
        ((96, 1), 170, 85),
        ((97, 1), 255, 170),
    ]
    for y in range(2, 14):
        port_changes.extend(
            [
                ((96, y), 255, 85),
                ((97, y), 85, 255),
            ]
        )
    port_changes.extend(
        [
            ((96, 14), 170, 85),
            ((97, 14), 255, 170),
            ((96, 15), 255, 85),
        ]
    )
    patch_pixels("gfx/tilesets/port.png", port_changes)
    patch_metatile("data/tilesets/johto_modern_metatiles.bin")

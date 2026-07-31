#!/usr/bin/env python3
"""Emit maps/GoldenrodPowerPlantB1F.ablk from the inline block data.

The B1F layout currently lives as `db` statements in data/maps/blocks.asm so
it stays plain text. Run this if you'd rather edit the map in Polished Map,
then replace the db block in data/maps/blocks.asm with:

    GoldenrodPowerPlantB1F_Blocks:
        INCBIN "maps/GoldenrodPowerPlantB1F.ablk"

Keep the two in sync, or drop whichever one you stop using.
"""

import os

WIDTH, HEIGHT = 10, 9

BLACK = 0x00   # border block used by every TILESET_FACILITY map
LADDER = 0x40  # ladder, top-left quadrant

blocks = [[BLACK] * WIDTH for _ in range(HEIGHT)]

# Warp 1 sits at tile 18,0 -> block column 9, row 0, top-left quadrant.
blocks[0][9] = LADDER

out = os.path.join(os.path.dirname(__file__), "..", "maps",
                   "GoldenrodPowerPlantB1F.ablk")
out = os.path.normpath(out)
with open(out, "wb") as f:
    f.write(bytes(b for row in blocks for b in row))

print("wrote", out)

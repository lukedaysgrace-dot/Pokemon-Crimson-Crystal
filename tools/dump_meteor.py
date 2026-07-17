#!/usr/bin/env python3
"""Dump gfx/battle_anims/meteor.2bpp as ASCII art so we can see the real
tile order. Writes meteor_dump.txt in the repo root. No dependencies.
Run from the repo root:  python3 tools/dump_meteor.py
"""
import os, sys

repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
path = os.path.join(repo, "gfx", "battle_anims", "meteor.2bpp")
out_path = os.path.join(repo, "meteor_dump.txt")

CHARS = " .o#"  # color 0..3

def decode_tile(data):
    rows = []
    for y in range(8):
        lo = data[y * 2]
        hi = data[y * 2 + 1]
        row = ""
        for x in range(7, -1, -1):
            c = ((hi >> x) & 1) * 2 + ((lo >> x) & 1)
            row += CHARS[c]
        rows.append(row)
    return rows

with open(path, "rb") as f:
    data = f.read()

ntiles = len(data) // 16
tiles = [decode_tile(data[i * 16:(i + 1) * 16]) for i in range(ntiles)]

def grid(tile_ids, width, title, out):
    out.append("== %s ==" % title)
    for row_start in range(0, len(tile_ids), width):
        chunk = tile_ids[row_start:row_start + width]
        header = "  ".join(
            ("[%02d]" % t).ljust(8) if t is not None and t < ntiles else "[--]    "
            for t in chunk)
        out.append(header)
        for y in range(8):
            line = "  ".join(
                tiles[t][y] if t is not None and t < ntiles else " " * 8
                for t in chunk)
            out.append(line)
    out.append("")

out = []
out.append("meteor.2bpp: %d bytes = %d tiles" % (len(data), ntiles))
out.append("")
grid(list(range(ntiles)), 3, "SHEET as stored (3 tiles per row, 24px wide)", out)
grid([0, 1, 2, 3, 4, 5, 6, 7, 8], 3, "BIG meteor as the game draws it (tiles 0-8)", out)
grid([9, 10, 12, 13], 2, "SMALL meteor as the game draws it (tiles 9,10 / 12,13)", out)

text = "\n".join(out)
with open(out_path, "w") as f:
    f.write(text + "\n")
print(text)
print("\nwrote %s" % out_path)

#!/usr/bin/env python3
"""Paint the Beast Triad additions into existing tilesets.

* Game Corner: a doorway block for the back wall (Goldenrod 9,0 always open;
  Celadon 15,0 once the poster switch at 9,0 is pressed).
* Shucks: a poker-rail card table at 2,13-3,14 with empty chairs on both
  sides. The people at Shucks are all object_events in maps/Shucks.asm. The people at Shucks are all object_events in maps/Shucks.asm.

Re-running is safe: every changed block is re-derived from the HEAD art plus
these paint steps, and new tiles/blocks are only appended when they differ.
Writes the block IDs the map scripts need to tools/triad_club/block_ids.txt.

    python3 tools/triad_club/shucks_and_corners.py
"""

import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from kit import ROOT, Canvas, TilesetPatch, parse_pal, WALL, FLOOR, DOOR  # noqa: E402
from PIL import Image  # noqa: E402

OUT = ROOT / '_artifacts/triad_club'


def git_head(path):
    return subprocess.run(['git', 'show', f'HEAD:{path}'], cwd=ROOT, capture_output=True, check=True).stdout


def restore_head(*paths):
    """Start from the committed tileset so re-runs do not stack changes."""
    for p in paths:
        (ROOT / p).write_bytes(git_head(p))


# -- Game Corner ----------------------------------------------------------------

def game_corner_door():
    restore_head('gfx/tilesets/game_corner.png', 'data/tilesets/game_corner_metatiles.bin',
                 'data/tilesets/game_corner_attributes.bin', 'data/tilesets/game_corner_collision.asm')
    day = parse_pal(ROOT / 'gfx/tilesets/bg_tiles.pal', 8)
    patch = TilesetPatch('game_corner', day, None)
    # Block $02 is the plain back wall over floor; the door replaces its
    # top-right step (x 9 of Goldenrod's block 4, x 15 of Celadon's block 7).
    cv = patch.canvas_for(bytes([0x02]), 1)
    L, M, D, K = day[5]  # brown: light, wood, dark wood, black
    # A recessed doorway seen from above: the lintel's lit face and dark
    # underside, the lit inner left jamb, darkness beyond and the passage
    # floor running in from the threshold.
    door = [
        'KKKKKKKKKKKKKKKK',
        'KLLLLLLLLLLLLLMK',
        'KLMMMMMMMMMMMMDK',
        'KLMKKKKKKKKKKKDK',
        'KLMDKKKKKKKKKKDK',
        'KLMDKKKKKKKKKKDK',
        'KLMDDKKKKKKKKKDK',
        'KLMDDKKKKKKKKKDK',
        'KLMDDKKKKKKKKKDK',
        'KLMDDKDKDKDKDKDK',
        'KLMDDDKDKDKDKDDK',
        'KLMDDDDDDDDDDDDK',
        'KLMDMDMDMDMDMDDK',
        'KLMMMMMMMMMMMMDK',
        'KLLLLLLLLLLLLLDK',
        'KLMMMMMMMMMMMMDK',
    ]
    cv.stamp(16, 0, door, {'K': K, 'L': L, 'M': M, 'D': D})
    cv.coll[0][1] = DOOR
    door_block = patch.block_id(cv, 0, 0, {})
    patch.write()
    # Goldenrod's doorway is always open: block 4 of the top row (steps 8-9).
    restore_head('maps/GoldenrodGameCorner.ablk')
    blk = bytearray((ROOT / 'maps/GoldenrodGameCorner.ablk').read_bytes())
    assert blk[4] == 0x02
    blk[4] = door_block
    (ROOT / 'maps/GoldenrodGameCorner.ablk').write_bytes(bytes(blk))
    return {'GAME_CORNER_DOORWAY_BLOCK': door_block}


# -- Shucks ---------------------------------------------------------------------

def shucks():
    restore_head('gfx/tilesets/shucks.png', 'data/tilesets/shucks_metatiles.bin',
                 'data/tilesets/shucks_attributes.bin', 'data/tilesets/shucks_collision.asm',
                 'maps/Shucks.ablk')
    pals = parse_pal(ROOT / 'gfx/tilesets/shucks.pal')
    patch = TilesetPatch('shucks', pals, None)
    blk = bytearray((ROOT / 'maps/Shucks.ablk').read_bytes())
    orig_blk = bytes(blk)
    cv = patch.canvas_for(blk, 10)
    floor_l, floor_m, floor_d, K = pals[5]
    red = pals[1][2]
    felt_l, felt_d, wood, _ = pals[3]
    flatten = {floor_d: floor_m}

    def copy_step(src, dst, flip=False):
        sx, sy = src
        dx, dy = dst
        cell = [cv.px[sy * 16 + y][sx * 16:sx * 16 + 16] for y in range(16)]
        if flip:
            cell = [r[::-1] for r in cell]
        for y in range(16):
            cv.px[dy * 16 + y][dx * 16:dx * 16 + 16] = list(cell[y])

    plain_floor = (0, 12)
    chair_right = [[cv.px[14 * 16 + y][1 * 16 + x] for x in range(16)] for y in range(16)]  # faces right
    chair_left = [[cv.px[14 * 16 + y][4 * 16 + x] for x in range(16)] for y in range(16)]   # faces left

    # Clear the round cafe table (steps 2-3, rows 13-14) and its chairs' row.
    for sx in range(1, 5):
        for sy in (13, 14):
            copy_step(plain_floor, (sx, sy))

    # Poker-rail card table, 32x32 at step (2,13). The far rail is flush with
    # the step edge so the felt can start in the top tile row.
    x0, y0 = 32, 13 * 16
    W, F, Fl, k = wood, felt_d, felt_l, K
    cream, yellow, orange, _ = pals[4]
    cv.rect(x0, y0, 32, 26, W)
    cv.hline(x0, y0, 32, k)
    cv.vline(x0, y0 + 1, 24, k)
    cv.vline(x0 + 31, y0 + 1, 24, k)
    # felt well with a black lip
    cv.rect(x0 + 3, y0 + 3, 26, 19, k)
    cv.rect(x0 + 4, y0 + 4, 24, 17, F)
    # lamp-lit centre of the felt
    for y in range(6, 19):
        for x in range(6, 26):
            if (x + y) % 2 == 0 and 8 <= x <= 23 and 7 <= y <= 17:
                cv.set(x0 + x, y0 + y, Fl)
    cv.rect(x0 + 8, y0 + 8, 16, 8, Fl)

    def card_back(cx, cy):
        cv.rect(x0 + cx, y0 + cy, 4, 5, k)
        cv.rect(x0 + cx + 1, y0 + cy + 1, 2, 3, Fl)
    # each side holds a small fanned hand
    for i in range(3):
        card_back(4 + i * 2 if False else 5, 5 + i * 4)
        card_back(23, 5 + i * 4)
    # two cards played face up in the middle (whole tiles in the cream palette)
    for cx, suit in ((8, orange), (16, k)):
        cv.rect(x0 + cx, y0 + 8, 8, 8, k)
        cv.rect(x0 + cx + 1, y0 + 9, 6, 6, cream)
        cv.stamp(x0 + cx + 1, y0 + 9, ['Y.....', '..SS..', '.SSSS.', '..SS..', '......', '.....Y'],
                 {'Y': yellow if suit == orange else orange, 'S': suit})
    # chips beside the pot
    for cx, cy in ((13, 18), (18, 18), (15, 5)):
        cv.set(x0 + cx, y0 + cy, Fl)
        cv.set(x0 + cx + 1, y0 + cy, k)
    # near rail and legs
    cv.hline(x0 + 1, y0 + 25, 30, k)
    for lx in (3, 26):
        cv.rect(x0 + lx, y0 + 26, 3, 4, k)
        cv.rect(x0 + lx + 1, y0 + 26, 1, 3, W)
    cv.block_coll(2, 13, 2, 2, WALL)

    # Empty chairs on both sides of the card table.
    for (sx, sy), chair in (((1, 13), chair_right), ((1, 14), chair_right),
                            ((4, 13), chair_left), ((4, 14), chair_left)):
        cv.paste(sx * 16, sy * 16, chair)
        cv.coll[sy][sx] = WALL

    ids = {}
    before = patch.canvas_for(orig_blk, 10)
    for by in range(8):
        for bx in range(10):
            rows = slice(by * 32, by * 32 + 32)
            same = all(a[bx * 32:bx * 32 + 32] == b[bx * 32:bx * 32 + 32]
                       for a, b in zip(cv.px[rows], before.px[rows]))
            same = same and all(cv.coll[by * 2 + q // 2][bx * 2 + q % 2] ==
                                before.coll[by * 2 + q // 2][bx * 2 + q % 2] for q in range(4))
            if not same:
                blk[by * 10 + bx] = patch.block_id(cv, bx, by, flatten)
    (ROOT / 'maps/Shucks.ablk').write_bytes(bytes(blk))
    patch.write()
    cv.save_preview(OUT / 'shucks.png', scale=3, grid=True)
    print('shucks blocks:', len(patch.blocks), 'tiles used:', len(patch.store.slots))
    return ids


if __name__ == '__main__':
    ids = {}
    ids.update(game_corner_door())
    ids.update(shucks())
    for k, v in ids.items():
        print(f'{k} EQU ${v:02x}')

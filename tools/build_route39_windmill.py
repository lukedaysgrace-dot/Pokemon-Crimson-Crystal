#!/usr/bin/env python3
"""Draw the Moomoo Farm windmill on Route 39 and its turning sails.

The windmill covers Route 39 squares (10,2)-(13,5), i.e. blocks (5,1)-(6,2).
It is drawn procedurally in Gen 2 style with the Johto tileset palettes:

- gray : ground, plaster tower, sails (sails use only colours 0 and 3, so they
         look the same in every palette they cross)
- red  : the cap (tile rows 1-2, columns 2-5 of the 8x8-tile windmill)
- brown: the wooden door (tile rows 6-7, columns 3-4)

The 32 tiles the sails sweep through are animated. Their eight frames
(11.25 degrees apart; the four sails repeat every 90 degrees) go to
gfx/tilesets/route39_windmill.png, in the VRAM order of WINDMILL_RUNS.
AnimateRoute39Windmill (engine/tilesets/league_room_anims.asm) GDMAs one
frame into VRAM bank 1 whenever wTileAnimationTimer moves on.

Frame 0 and the static tiles are written into free VRAM-bank-1 slots of
gfx/tilesets/johto.png (slots no Johto block references). The four blocks
are WINDMILL_BLOCKS of the Johto tileset. Re-running is idempotent.

Run from the repository root: python3 tools/build_route39_windmill.py
"""
import math
import re
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
JOHTO_PNG = ROOT / 'gfx/tilesets/johto.png'
FRAMES_PNG = ROOT / 'gfx/tilesets/route39_windmill.png'
META = ROOT / 'data/tilesets/johto_metatiles.bin'
ATTR = ROOT / 'data/tilesets/johto_attributes.bin'
COLL = ROOT / 'data/tilesets/johto_collision.asm'
RUNS_ASM = ROOT / 'data/tilesets/route39_windmill_runs.asm'
ROUTE39 = ROOT / 'maps/Route39.ablk'

ROUTE39_WIDTH = 10
WINDMILL_BLOCK_X, WINDMILL_BLOCK_Y = 5, 1
WINDMILL_BLOCKS = [0xc7, 0xc8, 0xc9, 0xca]  # top-left, top-right, bottom-left, bottom-right
NUM_FRAMES = 8

# VRAM bank 1 tile runs for the animated tiles (start, count); each run is one GDMA.
WINDMILL_RUNS = [(0x02, 18), (0x64, 12), (0x19, 2)]
# VRAM bank 1 slots for static tiles.
STATIC_SLOTS = [0x00, 0x1c, 0x1d, 0x1e, 0x1f, 0x2b, 0x2c, 0x2e, 0x35, 0x3a, 0x3b,
                0x3c, 0x43, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4f, 0x58, 0x59, 0x5a,
                0x5b, 0x5c, 0x5f]

GROUND_TILE = 0x06  # bank 0, gray: Route 39's dotted ground
PAL_GRAY, PAL_RED, PAL_BROWN = 0, 1, 5
BANK1 = 0x08

SHADES = (255, 170, 85, 0)

# Sail geometry, centred on the pixel corner (HUB_X, HUB_Y).
HUB_X, HUB_Y = 32, 24
SAIL_TIP = 21.5      # end of the stock (spar)
SAIL_START = 5.5     # sail cloth begins here along the stock
SAIL_WIDTH = 6.0     # cloth width, on the trailing side of the stock
SWEEP = 22.0         # nothing of the sails lies farther than this from the hub


def tile_palette(tx, ty):
    if 1 <= ty <= 2 and 2 <= tx <= 5:
        return PAL_RED
    if 6 <= ty <= 7 and 3 <= tx <= 4:
        return PAL_BROWN
    return PAL_GRAY


def is_animated(tx, ty):
    """A tile is animated if any of its pixel centres lies within SWEEP of the hub."""
    for y in range(ty * 8, ty * 8 + 8):
        for x in range(tx * 8, tx * 8 + 8):
            if math.hypot(x + 0.5 - HUB_X, y + 0.5 - HUB_Y) <= SWEEP + 0.75:
                return True
    return False


def load_png_tiles(path):
    im = Image.open(path).convert('L')
    w, h = im.size
    px = im.load()
    tiles = []
    for ty in range(h // 8):
        for tx in range(w // 8):
            tiles.append([[min(range(4), key=lambda k: abs(px[tx * 8 + x, ty * 8 + y] - SHADES[k]))
                           for x in range(8)] for y in range(8)])
    return im, tiles


# ---------------------------------------------------------------------------
# Drawing

def tower_edges(y):
    """Left and right outline x of the tapered tower at row y (24..63)."""
    t = (y - 24) / 39
    left = round(19 - 6 * t)
    right = round(44 + 6 * t)
    return left, right


def draw_base(ground):
    """64x64 colour-index picture of everything except the sails."""
    img = [[ground[y % 8][x % 8] for x in range(64)] for y in range(64)]

    def put(x, y, c):
        if 0 <= x < 64 and 0 <= y < 64:
            img[y][x] = c

    # Clean ground under the cap tiles (red palette: colour 1 would be pink dots).
    for ty in (1, 2):
        for tx in range(2, 6):
            for y in range(ty * 8, ty * 8 + 8):
                for x in range(tx * 8, tx * 8 + 8):
                    img[y][x] = 0

    # Tower body, rows 24-63.
    for y in range(24, 64):
        left, right = tower_edges(y)
        shade_from = right - 8
        if y >= 48:
            shade_from = max(shade_from, 40)  # keep shading out of the brown door tiles
        for x in range(left, right + 1):
            if x in (left, right) or y == 63:
                c = 3
            elif x >= shade_from:
                c = 1
            else:
                c = 0
            put(x, y, c)
    # plaster texture: a few short dark lines on the shaded side
    for (x, y) in [(42, 30), (43, 30), (41, 44), (42, 44), (45, 56), (46, 56), (43, 50)]:
        if img[y][x] == 1:
            img[y][x] = 2
    for (x, y) in [(22, 34), (23, 34), (21, 52), (22, 52)]:
        img[y][x] = 1

    # A small window above the door.
    for y in range(33, 40):
        for x in range(29, 35):
            edge = x in (29, 34) or y in (33, 39)
            put(x, y, 3 if edge else 2)
    put(30, 34, 0)
    put(31, 34, 0)
    put(30, 35, 0)

    # Door (brown tiles: x 24-39, y 48-63). Arched, planked.
    for y in range(49, 63):
        for x in range(27, 37):
            top = 49
            if y == top and x in (27, 28, 35, 36):
                continue
            if y == top + 1 and x in (27, 36):
                continue
            edge = (x in (27, 36)) or (y == top and 29 <= x <= 34) or \
                (y == top + 1 and x in (28, 35)) or (y == top + 2 and x in (27, 36))
            if edge:
                c = 3
            elif x in (30, 33):
                c = 1
            else:
                c = 2
            put(x, y, c)
    put(34, 56, 3)  # handle
    # door step
    for x in range(26, 38):
        put(x, 62, 3 if x in (26, 37) else 1)

    # Cap: half-dome over x 16-47, y 8-23 (red tiles).
    cx, cy, rx, ry = 31.5, 23.5, 15.5, 15.0
    inside = [[False] * 64 for _ in range(64)]
    for y in range(8, 24):
        for x in range(16, 48):
            if ((x + 0.5 - cx) / (rx + 0.5)) ** 2 + ((y + 0.5 - cy) / (ry + 0.5)) ** 2 <= 1:
                inside[y][x] = True
    for y in range(8, 24):
        for x in range(16, 48):
            if not inside[y][x]:
                continue
            edge = y == 23 or not all(
                0 <= x + dx < 64 and inside[y + dy][x + dx]
                for dx, dy in ((1, 0), (-1, 0), (0, -1)))
            if edge:
                c = 3
            else:
                # boards: horizontal bands, lighter on the upper left
                band = (y - 8) % 4 == 3
                light = (x + 0.5 - cx) < -2 and y < 20 and (x + 0.5 - cx) > -12
                c = 2
                if light:
                    c = 1
                if band:
                    c = 3 if not light else 2
            img[y][x] = c
    # eave overhang line
    for x in range(16, 48):
        img[23][x] = 3
    # finial
    for y in (6, 7):
        img[y][31] = 3
        img[y][32] = 3
    return img


def sail_pixel(px, py, angle):
    """Colour of the sails at pixel (px, py) for rotation angle, or None."""
    dx = px + 0.5 - HUB_X
    dy = py + 0.5 - HUB_Y
    r = math.hypot(dx, dy)
    if r > SWEEP:
        return None
    # hub boss
    if r <= 2.2:
        return 3
    if r <= 3.3:
        return 3 if r > 2.6 else 0
    best = None
    for k in range(4):
        a = angle + k * math.pi / 2
        ux, uy = math.cos(a), -math.sin(a)      # along the stock (screen y is down)
        vx, vy = -uy, ux                         # trailing side
        u = dx * ux + dy * uy
        v = dx * vx + dy * vy
        if u < 0 or u > SAIL_TIP:
            continue
        # stock
        if abs(v) <= 0.75:
            return 3
        # cloth with a lattice
        if SAIL_START <= u <= SAIL_TIP and 0 < v <= SAIL_WIDTH:
            border = v > SAIL_WIDTH - 1.0 or u < SAIL_START + 1.0 or u > SAIL_TIP - 1.0
            lattice = abs(((u - SAIL_START) % 4.0) - 2.0) > 1.45
            best = 3 if (border or lattice) else 0
    return best


def draw_frame(base, angle):
    img = [row[:] for row in base]
    for y in range(64):
        for x in range(64):
            c = sail_pixel(x, y, angle)
            if c is not None:
                img[y][x] = c
    return img


def tile_of(img, tx, ty):
    return [img[ty * 8 + y][tx * 8:tx * 8 + 8] for y in range(8)]


# ---------------------------------------------------------------------------

def main():
    johto_im, tiles = load_png_tiles(JOHTO_PNG)
    ground = tiles[GROUND_TILE]
    base = draw_base(ground)
    frames = [draw_frame(base, i * (math.pi / 2) / NUM_FRAMES) for i in range(NUM_FRAMES)]

    anim_positions = [(tx, ty) for ty in range(8) for tx in range(8) if is_animated(tx, ty)]
    anim_slots = [s + i for s, n in WINDMILL_RUNS for i in range(n)]
    if len(anim_positions) != len(anim_slots):
        sys.exit(f'{len(anim_positions)} animated tiles but {len(anim_slots)} animation slots')

    # Assign tiles: (tile index, attribute) for each of the 64 positions.
    layout = {}
    for (tx, ty), slot in zip(anim_positions, anim_slots):
        layout[(tx, ty)] = (slot, tile_palette(tx, ty) | BANK1)
    static_pixels = {}
    free = list(STATIC_SLOTS)
    new_tiles = {}
    for ty in range(8):
        for tx in range(8):
            if (tx, ty) in layout:
                continue
            pal = tile_palette(tx, ty)
            t = tile_of(base, tx, ty)
            if t == ground and pal == PAL_GRAY:
                layout[(tx, ty)] = (GROUND_TILE, PAL_GRAY)
                continue
            key = (tuple(map(tuple, t)))
            if key not in static_pixels:
                if not free:
                    sys.exit('out of static tile slots')
                slot = free.pop(0)
                static_pixels[key] = slot
                new_tiles[slot] = t
            layout[(tx, ty)] = (static_pixels[key], pal | BANK1)

    # Write tiles into johto.png (bank 1 slot s = png tile $80 + s).
    px = johto_im.load()
    def write_png_tile(index, t):
        bx, by = (index % 16) * 8, (index // 16) * 8
        for y in range(8):
            for x in range(8):
                px[bx + x, by + y] = SHADES[t[y][x]]
    for slot, t in new_tiles.items():
        write_png_tile(0x80 + slot, t)
    for (tx, ty), slot in zip(anim_positions, anim_slots):
        write_png_tile(0x80 + slot, tile_of(frames[0], tx, ty))
    johto_im.save(JOHTO_PNG)

    # Frame sheet: 16 tiles per row, each frame is 32 tiles in slot order.
    sheet = Image.new('L', (128, NUM_FRAMES * len(anim_slots) // 16 * 8), 255)
    sp = sheet.load()
    for f, img in enumerate(frames):
        for i, (tx, ty) in enumerate(anim_positions):
            n = f * len(anim_slots) + i
            bx, by = (n % 16) * 8, (n // 16) * 8
            t = tile_of(img, tx, ty)
            for y in range(8):
                for x in range(8):
                    sp[bx + x, by + y] = SHADES[t[y][x]]
    sheet.save(FRAMES_PNG)

    # Blocks.
    meta = bytearray(META.read_bytes())
    attr = bytearray(ATTR.read_bytes())
    need = (max(WINDMILL_BLOCKS) + 1) * 16
    if len(meta) < WINDMILL_BLOCKS[0] * 16:
        sys.exit('Johto metatiles are shorter than expected')
    meta = meta[:WINDMILL_BLOCKS[0] * 16] + bytes(need - WINDMILL_BLOCKS[0] * 16) if len(meta) < need else meta
    attr = attr[:WINDMILL_BLOCKS[0] * 16] + bytes(need - WINDMILL_BLOCKS[0] * 16) if len(attr) < need else attr
    for i, block in enumerate(WINDMILL_BLOCKS):
        ox, oy = (i % 2) * 4, (i // 2) * 4
        for j in range(16):
            t, a = layout[(ox + j % 4, oy + j // 4)]
            meta[block * 16 + j] = t
            attr[block * 16 + j] = a
    META.write_bytes(bytes(meta))
    ATTR.write_bytes(bytes(attr))

    # Collision: the whole windmill is solid.
    lines = COLL.read_text().splitlines()
    lines = [l for l in lines if not re.search(r';\s*(%s)\s*$' % '|'.join('%02x' % b for b in WINDMILL_BLOCKS), l)]
    last = max(int(m.group(1), 16) for l in lines for m in [re.search(r';\s*([0-9a-f]{2})\s*$', l)] if m)
    if last != WINDMILL_BLOCKS[0] - 1:
        sys.exit(f'collision file ends at block {last:02x}, expected {WINDMILL_BLOCKS[0] - 1:02x}')
    for b in WINDMILL_BLOCKS:
        lines.append(f'\ttilecoll WALL, WALL, WALL, WALL ; {b:02x}')
    COLL.write_text('\n'.join(lines) + '\n')

    # Map.
    blk = bytearray(ROUTE39.read_bytes())
    for i, block in enumerate(WINDMILL_BLOCKS):
        x, y = WINDMILL_BLOCK_X + i % 2, WINDMILL_BLOCK_Y + i // 2
        blk[y * ROUTE39_WIDTH + x] = block
    ROUTE39.write_bytes(bytes(blk))

    # GDMA run table.
    out = ['; Generated by tools/build_route39_windmill.py - do not edit.',
           '; VRAM bank 1 runs (first tile, tile count) that receive one windmill frame.',
           'Route39WindmillRuns:']
    for s, n in WINDMILL_RUNS:
        out.append(f'\tdb ${s:02x}, {n}')
    out.append('\tdb -1')
    out.append('')
    out.append(f'ROUTE39_WINDMILL_FRAMES EQU {NUM_FRAMES}')
    out.append(f'ROUTE39_WINDMILL_FRAME_TILES EQU {len(anim_slots)}')
    RUNS_ASM.write_text('\n'.join(out) + '\n')

    print(f'{len(anim_positions)} animated tiles, {len(new_tiles)} static tiles, '
          f'{NUM_FRAMES} frames')


if __name__ == '__main__':
    main()

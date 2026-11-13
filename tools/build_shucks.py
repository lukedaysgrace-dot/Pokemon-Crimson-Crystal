"""Build the unregistered Shucks bar map in Gold/Silver/Crystal style.

Run with Python 3 + Pillow:  python3 tools/build_shucks.py

Layout: 10 x 8 blocks (20 x 16 movement cells), the same footprint class as
Goldenrod's Game Corner or a Department Store floor.

Art direction follows the original Crystal interiors:
  * The room is composed in "true colour" from a small set of shared colours,
    then every 8x8 tile is assigned whichever of the eight palettes holds all of
    its colours. Like Crystal, every palette that can touch the floor shares the
    floor's two colours and black, so furniture sits cleanly on the boards.
  * Wall panels, floorboards, the back-bar grill/sink, fridge, radio, potted
    palms, the stage boards and the exit rug are copied from vanilla Crystal
    tiles (pinned copies in gfx/tilesets/shucks_sources/crystal_*).
  * The bar-specific fixtures (bottle shelves, taps, counter, curtain, speaker
    stacks, marquee footlights, dance floor, pool table, cue rack, cafe tables
    and signage) are hand-pixelled here in the same 4-shade, black-outlined style.

No existing project tileset is modified, and the map stays out of every map
table until it is given an entrance.
"""
from collections import deque
from pathlib import Path
import hashlib
import json
import re

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'gfx/tilesets/shucks_sources'
WIDTH, HEIGHT = 20, 16           # 16-pixel movement cells
BW, BH = WIDTH // 2, HEIGHT // 2  # 32-pixel map blocks
ENTRANCE = [(9, 15), (10, 15)]    # rug cells reserved for the future exit warps

# ---------------------------------------------------------------- colours ---
C = {
    'L': (27, 24, 18),  # floor light / cream highlight
    'd': (21, 17, 10),  # floorboard seam / light wood
    'w': (14, 10, 5),   # dark wood
    'k': (6, 4, 4),     # outline black
    'W': (30, 29, 27),  # appliance white
    'g': (20, 20, 21),  # light grey
    'G': (11, 11, 13),  # dark grey
    'r': (28, 8, 8),    # red
    'n': (8, 19, 6),    # bottle / leaf green
    'f': (16, 26, 11),  # felt highlight
    'm': (7, 18, 9),    # felt
    'y': (31, 27, 8),   # yellow
    'o': (29, 14, 3),   # orange
    'p': (29, 16, 25),  # curtain pink
    'u': (15, 7, 21),   # curtain purple
}
PALETTES = [
    'WgGk',  # 0 grey: fridge, stove, radio, speakers
    'Ldrk',  # 1 red: stools, rug, red bottles, cafe tables
    'Ldnk',  # 2 green: palms, green bottles
    'fmwk',  # 3 felt: pool table
    'Lyok',  # 4 yellow: dance floor, marquee lights
    'Ldwk',  # 5 brown: floor, walls, woodwork (preferred for shared tiles)
    'Lpuk',  # 6 purple: stage curtain
]
PREFERENCE = [5, 1, 2, 0, 3, 4, 6]
TEXT_PALETTE = [(31, 31, 16), (31, 31, 16), (14, 9, 0), (0, 0, 0)]

# ---------------------------------------------------------------- canvas ----
canvas = [['L'] * (WIDTH * 16) for _ in range(HEIGHT * 16)]
collision = [['FLOOR'] * WIDTH for _ in range(HEIGHT)]


def setcoll(x, y, w, h, kind):
    for cy in range(y, y + h):
        for cx in range(x, x + w):
            collision[cy][cx] = kind


def art(rows, x, y, solid=None, cells=None):
    """Draw ASCII art (colour letters, '.' = transparent) at pixel x, y."""
    width = len(rows[0])
    for dy, row in enumerate(rows):
        assert len(row) == width, ('ragged art row', row)
        for dx, ch in enumerate(row):
            if ch != '.':
                assert ch in C, ('unknown colour', ch)
                canvas[y + dy][x + dx] = ch
    if solid:
        cx, cy = x // 16, y // 16
        w, h = cells if cells else (width // 16, len(rows) // 16)
        setcoll(cx, cy, w, h, solid)


def cell(rows, cx, cy, solid=None):
    art(rows, cx * 16, cy * 16, solid, (1, len(rows) // 16 or 1))


# ------------------------------------------------------ vanilla imports ----
_sources = {}


def source_block(name, block):
    """Return a 32x32 grid of (palette, shade) from a pinned Crystal tileset."""
    if name not in _sources:
        _sources[name] = (
            Image.open(SOURCES / f'crystal_{name}.png').convert('L'),
            (SOURCES / f'crystal_{name}_metatiles.bin').read_bytes(),
            (SOURCES / f'crystal_{name}_attributes.bin').read_bytes(),
        )
    atlas, meta, attr = _sources[name]
    grid = [[None] * 32 for _ in range(32)]
    for i in range(16):
        tile, a = meta[block * 16 + i], attr[block * 16 + i]
        index = tile + 128 if a & 8 else tile
        part = atlas.crop((index % 16 * 8, index // 16 * 8, index % 16 * 8 + 8, index // 16 * 8 + 8))
        if a & 32:
            part = part.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if a & 64:
            part = part.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        for py in range(8):
            for px in range(8):
                shade = (255 - part.getpixel((px, py))) // 85
                grid[i // 4 * 8 + py][i % 4 * 8 + px] = (a & 7, shade)
    return grid


def vanilla(name, block, sx, sy, w, h, colours, mask_floor=None):
    """Convert part of a Crystal block to colour-letter rows.

    colours maps source palette -> 4-letter string (shade 0..3).
    mask_floor = (name, block) of a plain-floor block in the same tileset;
    floor pixels connected to the region's border become transparent.
    """
    grid = source_block(name, block)
    rows = [[colours[grid[sy + y][sx + x][0]][grid[sy + y][sx + x][1]] for x in range(w)] for y in range(h)]
    if mask_floor:
        floor = source_block(*mask_floor)
        same = [[grid[sy + y][sx + x][1] == floor[sy + y][sx + x][1] for x in range(w)] for y in range(h)]
        seen, queue = set(), deque()
        for y in range(h):
            for x in range(w):
                if (x in (0, w - 1) or y in (0, h - 1)) and same[y][x]:
                    seen.add((x, y))
                    queue.append((x, y))
        while queue:
            x, y = queue.popleft()
            for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                if 0 <= nx < w and 0 <= ny < h and same[ny][nx] and (nx, ny) not in seen:
                    seen.add((nx, ny))
                    queue.append((nx, ny))
        for x, y in seen:
            rows[y][x] = '.'
    return [''.join(r) for r in rows]


WOOD = {5: 'Ldwk'}  # Crystal brown -> Shucks brown
# Goldenrod Game Corner's inset floor tiles, in the bar's cream and tan.
FLOOR = vanilla('game_corner', 0x01, 0, 0, 16, 16, {0: 'Lddk'})
WALL = vanilla('players_house', 0x05, 0, 0, 16, 16, WOOD)           # wood panelling
STAGE = vanilla('traditional_house', 0x20, 0, 0, 16, 16, {5: 'Ldwk'})  # dance-theatre boards

for cy in range(HEIGHT):
    for cx in range(WIDTH):
        cell(WALL if cy == 0 else FLOOR, cx, cy, 'WALL' if cy == 0 else None)

# ------------------------------------------------------------ back bar -----
# Fridge, radio and the stove/sink unit are Crystal's own kitchen furniture.
APPLIANCE = {0: 'WgGk', 5: 'Ldwk'}
fridge = vanilla('players_house', 0x0f, 0, 0, 16, 32, APPLIANCE)
grill = vanilla('players_house', 0x07, 0, 0, 32, 32, APPLIANCE)
radio = vanilla('players_house', 0x1a, 0, 0, 16, 32, APPLIANCE)


def bottle_shelf(colours, layout):
    """16x32 liquor shelf on a Crystal bookshelf frame.

    colours: bottle colour per shelf, as (left tile, right tile). Each 8x8 tile
    holds one bottle colour so it can take the matching red or green palette.
    layout: bottle x-offsets per shelf (3 pixels wide, kept inside the frame).
    """
    rows = []
    for shelf in range(3):
        body = [list('kdkkkkkkkkkkkkdk') for _ in range(6)]
        for x in layout[shelf]:
            assert 2 <= x and x + 2 <= 13 and (x + 2 < 8 or x >= 8), ('bottle crosses a tile', x)
            colour = colours[shelf][0 if x < 8 else 1]
            body[1][x + 1] = colour
            body[2][x:x + 3] = [colour] * 3
            body[3][x:x + 3] = [colour, 'L', colour]
            body[4][x:x + 3] = [colour, 'L', colour]
            body[5][x:x + 3] = [colour] * 3
        rows += [list('kkkkkkkkkkkkkkkk')] + body + [list('kddddddddddddddk')]
    rows += [list(r) for r in (  # cupboard base standing on the boards
        'kkkkkkkkkkkkkkkk',
        'kddddddkkddddddk',
        'kdwwwwdkkdwwwwdk',
        'kdwwkwdkkdwkwwdk',
        'kdwwwwdkkdwwwwdk',
        'kddddddkkddddddk',
        'kkkkkkkkkkkkkkkk',
        'dddddddddddddddd',
    )]
    assert len(rows) == 32
    return [''.join(r) for r in rows]


shelves = [
    bottle_shelf((('n', 'r'), ('r', 'n'), ('n', 'r')), ([2, 5, 8, 11], [3, 10], [2, 5, 8, 11])),
    bottle_shelf((('r', 'n'), ('n', 'r'), ('r', 'n')), ([3, 10], [2, 5, 8, 11], [3, 10])),
    bottle_shelf((('n', 'n'), ('r', 'r'), ('n', 'r')), ([2, 5, 8, 11], [2, 5, 10], [3, 8, 11])),
]
art(fridge, 0 * 16, 0, 'WALL', (1, 2))
for i, shelf in enumerate(shelves):
    art(shelf, (1 + i) * 16, 0, 'WALL', (1, 2))

SHELL_SIGN = [  # scallop-shell emblem hung on the panelling
    '.kkkkkkkkkkkkkk.',
    'kwwwwwwwwwwwwwwk',
    'kwkkkkkkkkkkkkwk',
    'kwkkkkLLLLkkkkwk',
    'kwkkkLLdLdLkkkwk',
    'kwkkLdLdLdLdkkwk',
    'kwkLLdLdLdLdLkwk',
    'kwkLdLdLdLdLdkwk',
    'kwkkdLdLdLdLkkwk',
    'kwkkkdddddddkkwk',
    'kwkkkkkLLkkkkkwk',
    'kwkkkkLddLkkkkwk',
    'kwkkkkkkkkkkkkwk',
    'kwwwwwwwwwwwwwwk',
    '.kkkkkkkkkkkkkk.',
    '................',
]
cell(SHELL_SIGN, 4, 0)
art(grill, 5 * 16, 0, 'WALL', (2, 2))
art(radio, 7 * 16, 0, 'WALL', (1, 2))

# ------------------------------------------------------------ bar counter ---
COUNTER = [
    'kkkkkkkkkkkkkkkk',
    'LLLLLLLLLLLLLLLL',
    'dddddddddddddddd',
    'dddddddddddddddd',
    'dddddddddddddddd',
    'dddddddddddddddd',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'wwwwwwwwwwwwwwww',
    'wdwwwwwdwdwwwwwd',
    'wdwwwwwdwdwwwwwd',
    'wdwwwwwdwdwwwwwd',
    'wkwwwwwkwkwwwwwk',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'dddddddddddddddd',
]


def left_capped(rows):
    """Close the west end of the counter (outline plus a lit edge)."""
    out = []
    for y, row in enumerate(rows):
        row = list(row)
        if y < 15:
            row[0] = 'k'
            if 0 < y < 6:
                row[1] = 'L'
        out.append(''.join(row))
    return out


COUNTER_END = [  # the counter returns north to close off the staff side
    'kkkkkkkkkkkkkkkk',
    'kLLLLLLLLLLLLLdk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
    'kLddddddddddddwk',
]
COUNTER_CORNER = [
    'kLddddddddddddwk',
    'LLddddddddddddwk',
    'dddddddddddddddk',
    'dddddddddddddddk',
    'dddddddddddddddk',
    'dddddddddddddddk',
    'wwwwwwwwwwwwwwwk',
    'kkkkkkkkkkkkkkkk',
    'wwwwwwwwwwwwwwwk',
    'wdwwwwwdwdwwwwdk',
    'wdwwwwwdwdwwwwdk',
    'wdwwwwwdwdwwwwdk',
    'wkwwwwwkwkwwwwkk',
    'wwwwwwwwwwwwwwwk',
    'kkkkkkkkkkkkkkkk',
    'dddddddddddddddd',
]
for x in range(0, 8):
    cell(left_capped(COUNTER) if x == 0 else COUNTER, x, 3, 'COUNTER')
cell(COUNTER_CORNER, 8, 3, 'COUNTER')
cell(COUNTER_END, 8, 2, 'COUNTER')

TAP = [  # beer tower: knob, handle, spout and drip tray
    '......kk........',
    '.....kLLk.......',
    '.....kddk.......',
    '.....kddk.......',
    '......kk........',
    '....kkkkkkk.....',
    '....kLLLLLkk....',
    '....kkkkkkLk....',
    '..........kk....',
]
MUGS = [
    '..kkkk....kkkk..',
    '..kLLkk...kLLkk.',
    '..kLLkLk..kLLkLk',
    '..kddkk...kddkk.',
    '..kkkk....kkkk..',
]
for x in (2, 5):
    art(TAP, x * 16, 2 * 16 + 7)
art(MUGS, 7 * 16, 3 * 16 + 1)

BAR_STOOL = [
    '................',
    '................',
    '................',
    '.....kkkkkk.....',
    '....krrrrrrk....',
    '...krrLLLrrrk...',
    '...krrrrrrrrk...',
    '...kkrrrrrrkk...',
    '....kkkkkkkk....',
    '......kddk......',
    '......kddk......',
    '......kddk......',
    '....kkkddkkk....',
    '....kddddddk....',
    '.....kkkkkk.....',
    '................',
]
for x in (1, 3, 5, 7):
    cell(BAR_STOOL, x, 4)

# Crystal's potted palm, re-potted in terracotta.
PALM = vanilla('house', 0x06, 0, 0, 16, 16, {2: 'Lnnk', 6: 'Lrdk', 1: 'Ldrk'}, mask_floor=('house', 0x0f)) + [
    '......kdLk......',
    '......kdLk......',
    '...kkkkkkkkkk...',
    '..kLLLLLLLLLLk..',
    '..kdrrrrrrrrdk..',
    '..kkkkkkkkkkkk..',
    '...krLrrrrrdk...',
    '...krLrrrrrdk...',
    '...krrrrrrrdk...',
    '....krrrrrdk....',
    '....krrrrrdk....',
    '....kkkkkkkk....',
    '................',
    '................',
    '................',
    '................',
]
art(PALM, 9 * 16, 1 * 16, 'WALL', (1, 2))

# ----------------------------------------------------------------- stage ----
for cy in range(2, 4):
    for cx in range(11, 20):
        cell(STAGE, cx, cy)

CURTAIN = [  # velvet stage curtain with a scalloped valance
    'kkkkkkkkkkkkkkkk',
    'LpLpLpLpLpLpLpLp',
    'pppppppppppppppp',
    'uuuuuuuuuuuuuuuu',
    'pppppppppppppppp',
    'uuuuuuuuuuuuuuuu',
    'kuuuuuukkuuuuuuk',
    'pkuuuukppkuuuukp',
    'upkkkkpuupkkkkpu',
    'uupLpuuuuupLpuuu',
    'uupLpuuuuupLpuuu',
    'kupLpuukkupLpuuk',
    'kupLpuukkupLpuuk',
    'kupLpuukkupLpuuk',
    'kuppLuukkuppLuuk',
    'kuppLuukkuppLuuk',
    'kuppLuukkuppLuuk',
    'kupppuukkupppuuk',
    'kupppuukkupppuuk',
    'kupppuukkupppuuk',
    'kuppuuukkuppuuuk',
    'kuppuuukkuppuuuk',
    'kuppuuukkuppuuuk',
    'kupuuuukkupuuuuk',
    'kupuuuukkupuuuuk',
    'kupuuuukkupuuuuk',
    'kuuuuuukkuuuuuuk',
    'kuuuuuukkuuuuuuk',
    'kpuuuupkkpuuuupk',
    'kuppppukkuppppuk',
    'kkuuuukkkkuuuukk',
    'kkkkkkkkkkkkkkkk',
]
for cx in range(11, 20):
    art(CURTAIN, cx * 16, 0, 'WALL', (1, 2))

SPEAKER = [
    'kkkkkkkkkkkkkkkk',
    'kWggggggggggggGk',
    'kgGGGGGGGGGGGGGk',
    'kgGGGGkkkkGGGGGk',
    'kgGGGkggGGkGGGGk',
    'kgGGGkgWGGkGGGGk',
    'kgGGGkGGGGkGGGGk',
    'kgGGGGkkkkGGGGGk',
    'kgGGGGGGGGGGGGGk',
    'kgGGkkkkkkkkGGGk',
    'kgGkgggggggGkGGk',
    'kgkgGGGGGGGGGkGk',
    'kgkgGGkkkkGGGkGk',
    'kgkgGkgWgGkGGkGk',
    'kgkgGkWgGGkGGkGk',
    'kgkgGkgGGGkGGkGk',
    'kgkgGGkkkkGGGkGk',
    'kgkGGGGGGGGGGkGk',
    'kgGkGGGGGGGGkGGk',
    'kgGGkkkkkkkkGGGk',
    'kgGGGGGGGGGGGGGk',
    'kgGGkkkkkkkkGGGk',
    'kgGkgggggggGkGGk',
    'kgkgGGkkkkGGGkGk',
    'kgkgGkgWgGkGGkGk',
    'kgkgGkGGGGkGGkGk',
    'kgkgGGkkkkGGGkGk',
    'kgGkGGGGGGGGkGGk',
    'kgGGkkkkkkkkGGGk',
    'kgGGGGGGGGGGGGGk',
    'kGGGGGGGGGGGGGGk',
    'kkkkkkkkkkkkkkkk',
]
for cx in (11, 19):
    art(SPEAKER, cx * 16, 2 * 16, 'WALL', (1, 2))

MARQUEE = [  # stage lip with a run of marquee bulbs
    'dddddddddddddddd',
    'kkkkkkkkkkkkkkkk',
    'LLLLLLLLLLLLLLLL',
    'dddddddddddddddd',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'kkkkkkkkkkkkkkkk',
    'kkkkkkkkkkkkkkkk',
    'kokkkkokkokkkkok',
    'oyokkoyooyokkoyo',
    'yLyookoyyLyookoy',
    'oyokkoyooyokkoyo',
    'kokkkkokkokkkkok',
    'kkkkkkkkkkkkkkkk',
    'oooooooooooooooo',
    'kkkkkkkkkkkkkkkk',
]
STEPS = [
    'dddddddddddddddd',
    'kkkkkkkkkkkkkkkk',
    'LLLLLLLLLLLLLLLL',
    'dddddddddddddddd',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'LLLLLLLLLLLLLLLL',
    'dddddddddddddddd',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'LLLLLLLLLLLLLLLL',
    'dddddddddddddddd',
    'wwwwwwwwwwwwwwww',
    'kkkkkkkkkkkkkkkk',
    'dddddddddddddddd',
    'dddddddddddddddd',
]
for cx in range(11, 20):
    cell(STEPS if cx == 15 else MARQUEE, cx, 4, None if cx == 15 else 'WALL')

DANCE = [  # bevelled light-up tiles: yellow and cream
    'LLLLLLLoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'LyyyyyyoLLLLLLLy',
    'ooooooooyyyyyyyo',
    'LLLLLLLyLLLLLLLo',
    'LLLLLLLyLyyyyyyo',
    'LLLLLLLyLyyyyyyo',
    'LLLLLLLyLyyyyyyo',
    'LLLLLLLyLyyyyyyo',
    'LLLLLLLyLyyyyyyo',
    'LLLLLLLyLyyyyyyo',
    'yyyyyyyooooooooo',
]
DANCE_EDGE = [  # front edge of the dance floor
    'kkkkkkkkkkkkkkkk',
    'dddddddddddddddd',
]
for cy in range(5, 7):
    for cx in range(12, 19):
        cell(DANCE, cx, cy)
for cx in range(12, 19):
    art(DANCE_EDGE, cx * 16, 7 * 16)

for x in (11, 19):  # palms bracket the dance floor
    art(PALM, x * 16, 5 * 16, 'WALL', (1, 2))

# --------------------------------------------------------- billiards -------
def pool_table():
    """64x48 six-pocket table: felt and rails in the felt palette, the
    skirt and legs in brown so they sit on the floorboards."""
    w = 64
    g = [['m'] * w for _ in range(40)]
    for y in range(40):
        for x in range(w):
            if x in (0, w - 1) or y in (0, 39):
                g[y][x] = 'k'
            elif x < 6 or x > w - 7 or y < 6 or y > 33:
                g[y][x] = 'w'
            elif x in (6, w - 7) or y in (6, 33):
                g[y][x] = 'k'          # cushion edge
            elif x == 7 or y == 7:
                g[y][x] = 'f'          # felt catching the light
    pocket = ['.kkk.', 'kkkkk', 'kkkkk', 'kkkkk', '.kkk.']
    for px, py in ((1, 1), (29, 0), (58, 1), (1, 34), (29, 35), (58, 34)):
        for dy, row in enumerate(pocket):
            for dx, ch in enumerate(row):
                if ch == 'k':
                    g[py + dy][px + dx] = 'k'
    for x in (16, 44):     # rail sights
        g[3][x] = g[36][x] = 'f'
    for y in (19,):
        g[y][3] = g[y][60] = 'f'
    # racked balls (triangle) and the cue ball
    for bx, by in ((40, 19), (43, 17), (43, 21), (46, 15), (46, 19), (46, 23)):
        g[by][bx:bx + 2] = ['f', 'w']
        g[by + 1][bx:bx + 2] = ['w', 'k']
    g[19][17:19] = ['f', 'f']
    g[20][17:19] = ['f', 'w']
    for i in range(14):      # cue lying along the felt
        g[27 - i // 2][12 + i] = 'w' if i < 12 else 'f'
    skirt = [
        'k' + 'd' * 62 + 'k',
        'k' + 'w' * 62 + 'k',
        'k' * 64,
        '..kwwk' + '.' * 52 + 'kwwk..',
        '..kwwk' + '.' * 52 + 'kwwk..',
        '..kddk' + '.' * 52 + 'kddk..',
        '..kkkk' + '.' * 52 + 'kkkk..',
        '.' * 64,
    ]
    return [''.join(r) for r in g] + skirt


art(pool_table(), 3 * 16, 8 * 16, 'WALL', (4, 3))

CUE_RACK = [  # floor-standing cue rack
    '................',
    '...kk..kk..kk...',
    '..kLLkkLLkkLLk..',
    '..kddkkddkkddk..',
    '.kkkkkkkkkkkkkk.',
    '.kLddddddddddwk.',
    '.kkkkkkkkkkkkkk.',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kdk.kdk.kdk..',
    '...kwk.kwk.kwk..',
    '...kwk.kwk.kwk..',
    '...kwk.kwk.kwk..',
    '..kwwwkwwwkwwwk.',
    '..kwwwkwwwkwwwk.',
    '.kkkkkkkkkkkkkk.',
    '.kLddddddddddwk.',
    '.kdwwwwwwwwwwwk.',
    '.kdwwwwwwwwwwwk.',
    '.kwwwwwwwwwwwwk.',
    '.kkkkkkkkkkkkkk.',
    '..kk........kk..',
    '..kk........kk..',
    '................',
    '................',
    '................',
]
art(CUE_RACK, 1 * 16, 8 * 16, 'WALL', (1, 2))

# -------------------------------------------------------------- cafe -------
def cafe_table():
    """32x32 round cloth-topped table with a wooden pedestal and a flower vase."""
    g = [['.'] * 32 for _ in range(32)]
    cx, cy, rx, ry = 15.5, 17.5, 14.5, 5.5   # low, flat top

    def inside(x, y):
        return ((x - cx) / rx) ** 2 + ((y - cy) / ry) ** 2 <= 1.0
    for y in range(32):
        for x in range(32):
            if inside(x, y):
                edge = not all(inside(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
                g[y][x] = 'k' if edge else 'L'
    for y in range(32):     # cloth hem: a tan ring just inside the near rim
        for x in range(32):
            if g[y][x] == 'L' and y > cy and not inside(x, y + 2):
                g[y][x] = 'd'
    for x in range(32):     # visible thickness of the near edge
        bottom = max((y for y in range(32) if inside(x, y)), default=None)
        if bottom is not None and x not in (0, 31):
            g[bottom + 1][x] = 'w'
            g[bottom + 2][x] = 'w'
            g[bottom + 3][x] = 'k'
    pedestal = [  # short stem from the underside of the top to the foot
        '............kddwwk..............',
        '............kddwwk..............',
        '...........kkddwwkk.............',
        '.........kkddddddwwwkk..........',
        '.........kkkkkkkkkkkkk..........',
    ]
    top_bottom = max(y for y in range(32) for x in range(32) if g[y][x] != '.')
    for dy, row in enumerate(pedestal):
        for dx, ch in enumerate(row):
            if ch != '.':
                g[top_bottom + 1 + dy][dx + 1] = ch
    vase = [  # red flowers in a little vase, centre of the table
        '..k.k..',
        '.krkrk.',
        'krkrkrk',
        '.kkrkk.',
        '..kdk..',
        '..kdk..',
        '..kkk..',
    ]
    for dy, row in enumerate(vase):
        for dx, ch in enumerate(row):
            if ch != '.':
                g[int(cy) - 6 + dy][13 + dx] = ch
    return [''.join(r) for r in g]


CHAIR = [  # side-on chair facing east; an NPC standing here reads as seated
    '................',
    '.kkk............',
    '.kLdk...........',
    '.kdrk...........',
    '.krrk...........',
    '.krrk...........',
    '.krrk...........',
    '.krrkkkkkkkkkk..',
    '.krrrLLLLLLLLrk.',
    '.krrrrrrrrrrrrk.',
    '.kkkkkkkkkkkkkk.',
    '.kddddddddddddk.',
    '.kkkkkkkkkkkkkk.',
    '..kdk......kdk..',
    '..kdk......kdk..',
    '..kkk......kkk..',
]
CHAIR_WEST = [row[::-1] for row in CHAIR]
CAFE_SETS = [(11, 9), (17, 9), (17, 12), (2, 13)]   # table's top-left cell
TABLE = cafe_table()
for tx, ty in CAFE_SETS:
    art(TABLE, tx * 16, ty * 16, 'WALL', (2, 2))
    cell(CHAIR, tx - 1, ty + 1)       # faces the table from the west
    cell(CHAIR_WEST, tx + 2, ty + 1)  # faces the table from the east

# Potted palms flank the doorway, as in Crystal's larger interiors.
for x in (7, 12):
    art(PALM, x * 16, 14 * 16, 'WALL', (1, 2))

# Crystal's red exit rug; warp-free until the map is given an entrance.
RUG = vanilla('house', 0x0b, 0, 16, 32, 16, {1: 'Ldrk'})
art(RUG, 9 * 16, 15 * 16)

MENU = [
    'kkkkkkkkkkkkkkkk',
    'kwwwwwwwwwwwwwwk',
    'kwkkkkkkkkkkkkwk',
    'kwkLLkLLLkLLkkwk',
    'kwkkkkkkkkkkkkwk',
    'kwkLkLLkkLLLkkwk',
    'kwkkkkkkkkkkkkwk',
    'kwkLLLkkLLkLkkwk',
    'kwkkkkkkkkkkkkwk',
    'kwkLLkkLLLLkkkwk',
    'kwkkkkkkkkkkkkwk',
    'kwwwwwwwwwwwwwwk',
    'kkkkkkkkkkkkkkkk',
    '................',
    '................',
    '................',
]
cell(MENU, 10, 0)

# ------------------------------------------------------ tile packing -------
# Shucks is always lit for night, whatever the clock says. The art above is
# authored in daylight colours; this pass applies Crystal's own night grading
# (about half brightness, shadows pushed toward blue-violet, outlines to pure
# black, fitted to the day/nite pairs in gfx/tilesets/bg_tiles.pal). Light
# sources are exempt, so the stage stays the brightest thing in the room.
NIGHT_LIGHTING = {
    4: None,   # marquee bulbs and the light-up dance floor: full brightness
    6: 0.75,   # stage curtain: caught in the stage lights
}


def to_night(rgb, strength=0.5):
    if strength is None:
        return rgb
    r, g, b = rgb
    lum = (r + g + b) / 93
    return (round(r * strength), round(g * (strength - 0.03)),
            min(31, round(b * strength + 9 * lum)))


pal_rgb = [[(0, 0, 0) if ch == 'k' else to_night(C[ch], NIGHT_LIGHTING.get(i, 0.5))
            for ch in p] for i, p in enumerate(PALETTES)]


def tile_palette(tx, ty):
    letters = {canvas[ty * 8 + y][tx * 8 + x] for y in range(8) for x in range(8)}
    for p in PREFERENCE:
        if letters <= set(PALETTES[p]):
            return p
    raise SystemExit(f'tile ({tx},{ty}) at cell ({tx//2},{ty//2}) needs colours {sorted(letters)}; '
                     'no Shucks palette holds them all')


def flips(data):
    rows = [data[i:i + 8] for i in range(0, 64, 8)]
    h = b''.join(r[::-1] for r in rows)
    v = b''.join(rows[::-1])
    hv = b''.join(r[::-1] for r in rows[::-1])
    return ((data, 0), (h, 0x20), (v, 0x40), (hv, 0x60))


tiles = [bytes(64)]          # tile 0: blank (colour 0), border uses it
lookup = {tiles[0]: (0, 0)}
tile_meta = [[0] * (WIDTH * 2) for _ in range(HEIGHT * 2)]
tile_attr = [[0] * (WIDTH * 2) for _ in range(HEIGHT * 2)]
for ty in range(HEIGHT * 2):
    for tx in range(WIDTH * 2):
        p = tile_palette(tx, ty)
        data = bytes(PALETTES[p].index(canvas[ty * 8 + y][tx * 8 + x]) for y in range(8) for x in range(8))
        found = None
        for variant, bits in flips(data):
            if variant in lookup:
                index, base = lookup[variant]
                found = (index, base ^ bits)
                break
        if not found:
            index = len(tiles)
            tiles.append(data)
            lookup[data] = (index, 0)
            found = (index, 0)
        index, bits = found
        bank = 0
        if index >= 0x7f:          # $7f stays free; overflow goes to VRAM bank 1
            bank, index = 8, index - 0x7f
        tile_meta[ty][tx] = index
        tile_attr[ty][tx] = p | bank | bits
assert len(tiles) <= 0x7f + 0x60, f'{len(tiles)} tiles'

# Blocks: block 0 is the all-black border.
BORDER_TILE = len(tiles)  # appended black tile for the border block
tiles.append(bytes([3]) * 64)
bt_index, bt_bank = (BORDER_TILE, 0) if BORDER_TILE < 0x7f else (BORDER_TILE - 0x7f, 8)
blocks = [(bytes([bt_index]) * 16, bytes([5 | bt_bank]) * 16, ('WALL',) * 4)]
map_data = bytearray()
for by in range(BH):
    for bx in range(BW):
        meta = bytes(tile_meta[by * 4 + i // 4][bx * 4 + i % 4] for i in range(16))
        attr = bytes(tile_attr[by * 4 + i // 4][bx * 4 + i % 4] for i in range(16))
        coll = tuple(collision[by * 2 + dy][bx * 2 + dx] for dy, dx in ((0, 0), (0, 1), (1, 0), (1, 1)))
        entry = (meta, attr, coll)
        if entry not in blocks:
            blocks.append(entry)
        map_data.append(blocks.index(entry))
assert len(blocks) < 256

# Export ---------------------------------------------------------------------
(ROOT / 'data/tilesets/shucks_metatiles.bin').write_bytes(b''.join(b[0] for b in blocks))
(ROOT / 'data/tilesets/shucks_attributes.bin').write_bytes(b''.join(b[1] for b in blocks))
(ROOT / 'data/tilesets/shucks_collision.asm').write_text(''.join(
    '\ttilecoll ' + ', '.join(b[2]) + f' ; {i:02x}\n' for i, b in enumerate(blocks)))
(ROOT / 'maps/Shucks.ablk').write_bytes(bytes(map_data))
(ROOT / 'gfx/tilesets/shucks.pal').write_text(
    '; Shucks interior palettes, always night-lit (gray, red, green, felt, yellow, brown, purple, text).\n'
    + ''.join('\tRGB ' + ', '.join(f'{v:02d}' for c in p for v in c) + '\n'
              for p in pal_rgb + [TEXT_PALETTE]))

# Atlas: VRAM bank 0 tiles in slots $00-$7e, bank 1 tiles from slot $80.
atlas = Image.new('L', (128, 128), 255)
SHADE = [255, 170, 85, 0]
for n, data in enumerate(tiles):
    slot = n if n < 0x7f else n - 0x7f + 0x80
    img = Image.new('L', (8, 8))
    img.putdata([SHADE[v] for v in data])
    atlas.paste(img, (slot % 16 * 8, slot // 16 * 8))
atlas.save(ROOT / 'gfx/tilesets/shucks.png')
raw = bytearray()
for slot in range(256):
    for y in range(8):
        a = b = 0
        for x in range(8):
            v = (255 - atlas.getpixel((slot % 16 * 8 + x, slot // 16 * 8 + y))) // 85
            a |= (v & 1) << (7 - x)
            b |= (v >> 1) << (7 - x)
        raw.extend((a, b))
(ROOT / 'gfx/tilesets/shucks.2bpp').write_bytes(raw)
# Valid Crystal LZ literal commands; the normal make rule can optimise later.
(ROOT / 'gfx/tilesets/shucks.2bpp.lz').write_bytes(
    b''.join(bytes([len(raw[i:i + 32]) - 1]) + raw[i:i + 32] for i in range(0, len(raw), 32)) + b'\xff')

# Re-render from the exported files so the preview also verifies packing.
map_bin = (ROOT / 'maps/Shucks.ablk').read_bytes()
meta_bin = (ROOT / 'data/tilesets/shucks_metatiles.bin').read_bytes()
attr_bin = (ROOT / 'data/tilesets/shucks_attributes.bin').read_bytes()
all_pals = [[tuple(round(v * 255 / 31) for v in c) for c in p] for p in pal_rgb + [TEXT_PALETTE]]
render = Image.new('RGB', (WIDTH * 16 + 64, HEIGHT * 16 + 64))
for by in range(-1, BH + 1):
    for bx in range(-1, BW + 1):
        block = map_bin[by * BW + bx] if 0 <= bx < BW and 0 <= by < BH else 0
        for i in range(16):
            t, a = meta_bin[block * 16 + i], attr_bin[block * 16 + i]
            slot = t + 0x80 if a & 8 else t
            tile = atlas.crop((slot % 16 * 8, slot // 16 * 8, slot % 16 * 8 + 8, slot // 16 * 8 + 8))
            if a & 0x20:
                tile = tile.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
            if a & 0x40:
                tile = tile.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
            img = Image.new('RGB', (8, 8))
            img.putdata([all_pals[a & 7][(255 - v) // 85] for v in tile.get_flattened_data()])
            render.paste(img, ((bx + 1) * 32 + i % 4 * 8, (by + 1) * 32 + i // 4 * 8))
PREVIEW = ROOT / '_artifacts/shucks'
PREVIEW.mkdir(parents=True, exist_ok=True)
render.save(PREVIEW / 'Shucks.preview.png')
render.resize((render.width * 3, render.height * 3), Image.Resampling.NEAREST).save(PREVIEW / 'Shucks.preview-3x.png')

# Validation -----------------------------------------------------------------
STAFF = {(x, y) for x in range(0, 9) for y in (1, 2)}  # behind the bar
seen = set(ENTRANCE)
queue = deque(seen)
while queue:
    x, y = queue.popleft()
    for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
        if 0 <= nx < WIDTH and 0 <= ny < HEIGHT and collision[ny][nx] == 'FLOOR' and (nx, ny) not in seen:
            seen.add((nx, ny))
            queue.append((nx, ny))
floors = {(x, y) for y in range(HEIGHT) for x in range(WIDTH) if collision[y][x] == 'FLOOR'}
assert floors - seen <= STAFF, ('disconnected public floor', sorted(floors - seen - STAFF))
assert not (seen & STAFF), 'the staff side of the bar is reachable'
asm = (ROOT / 'maps/Shucks.asm').read_text()
objects = [(int(x), int(y)) for x, y in re.findall(r'object_event\s+(\d+),\s*(\d+)', asm)]
assert len(objects) == len(set(objects))
for x, y in objects:
    assert (x, y) in floors, ('object not on floor', x, y)
for x, y in re.findall(r'bg_event\s+(\d+),\s*(\d+)', asm):
    x, y = int(x), int(y)
    assert any((x + dx, y + dy) in seen for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1))), ('unreachable bg event', x, y)
for text in re.findall(r'^\s*(?:text|line|cont|para) "([^"]*)"', asm, re.M):
    assert len(text) <= 18, ('text exceeds Crystal textbox width', text)
assert 'warp_event' not in re.sub(r';[^\n]*', '', asm)
for table in ('constants/map_constants.asm', 'constants/tileset_constants.asm',
              'data/maps/maps.asm', 'data/maps/scripts.asm', 'data/maps/blocks.asm',
              'data/maps/attributes.asm', 'data/tilesets.asm', 'gfx/tilesets.asm'):
    assert not re.search(r'Shucks|SHUCKS', (ROOT / table).read_text()), ('draft accidentally registered', table)
receipt = {
    'map': 'Shucks', 'blocks': [BW, BH], 'movement_cells': [WIDTH, HEIGHT],
    'unique_graphic_tiles': len(tiles), 'unique_blocks': len(blocks),
    'reachable_floor_cells': len(seen), 'objects': len(objects), 'warps': 0,
    'entrance_cells': ENTRANCE,
    'source_sha256': {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                      for p in sorted(SOURCES.glob('crystal_*'))},
}
(ROOT / 'maps/Shucks.validation.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt, indent=2))

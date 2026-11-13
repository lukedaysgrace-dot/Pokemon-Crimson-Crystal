"""Give Goldenrod City its SHUCKS bar facade (cells 6,18 - 11,21).

Run with Python 3 + Pillow:  python3 tools/build_goldenrod_shucks.py

The building left of the Game Corner keeps its Goldenrod roof (blocks $18 $1f
$19 are untouched) and gets a new street front on the block row below:

  * a SHUCKS marquee board over the door, with neon letters and bulbs,
  * a black sign board beside it for the neon Shuckle,
  * a red-and-white awning, dark plank walls, lit windows and Crystal's door.

The SHUCKS letters and bulbs use the YELLOW slot's colour 0. In the
johto_modern palette that is near-white by day and the glowing (30,30,11) at
night - the same trick Crystal uses for lit windows.

The neon Shuckle itself is an object (SPRITE_SHUCKLE_SIGN at 10,20) drawn
from Shuckle's 16x16 menu icon, so it keeps true yellow and red at night in
Goldenrod's otherwise unused rock OBJ palette. This script also writes:
  * gfx/sprites/shuckle_sign.png - the sprite (eyes and seams transparent so
    the black board shows through),
  * gfx/overworld/shuckle_sign.pal - its colours for morn/day/nite/dark:
    switched off by day, dark at night until animated,
  * gfx/overworld/shuckle_sign_pulse.pal - 16 brightness steps from dark to
    fully lit, which AnimateShucksNeonSign (tileset_anims.asm) walks up and
    down at night.

Only previously unused tile slots of gfx/tilesets/johto_modern.png are written
(slots no johto_modern or battle_tower_outside block references), and the three
new metatiles are appended to the end of johto_modern. Re-running is safe: the
facade blocks from an earlier run are removed first, so their tile slots are
reused rather than leaked.
"""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PNG = ROOT / 'gfx/tilesets/johto_modern.png'
META = ROOT / 'data/tilesets/johto_modern_metatiles.bin'
ATTR = ROOT / 'data/tilesets/johto_modern_attributes.bin'
COLL = ROOT / 'data/tilesets/johto_modern_collision.asm'
SHARED = [ROOT / 'data/tilesets/battle_tower_outside_metatiles.bin',
          ROOT / 'data/tilesets/battle_tower_outside_attributes.bin']
MAP = ROOT / 'maps/GoldenrodCity.ablk'
MAP_WIDTH = 20
BUILDING_BLOCKS = [(3, 10), (4, 10), (5, 10)]   # street-front row of the building
SPRITE_PNG = ROOT / 'gfx/sprites/shuckle_sign.png'
SIGN_PAL = ROOT / 'gfx/overworld/shuckle_sign.pal'
PULSE_PAL = ROOT / 'gfx/overworld/shuckle_sign_pulse.pal'
STALE = [ROOT / 'data/tilesets/shucks_neon.asm']   # output of the old BG-tile animation
VANILLA_BLOCKS = 0x99    # johto_modern metatiles before the SHUCKS facade
RED, YELLOW, BROWN = 1, 4, 5
FLIP_X = 0x20

# --------------------------------------------------------------- new art ---
# Shades: 0 = light (glows at night in YELLOW), 1, 2, 3 = darkest.
FONT = {  # 5x6 marquee letters
    'S': [' ####', '#    ', ' ### ', '    #', '    #', '#### '],
    'H': ['#   #', '#   #', '#####', '#   #', '#   #', '#   #'],
    'U': ['#   #', '#   #', '#   #', '#   #', '#   #', ' ### '],
    'C': [' ####', '#    ', '#    ', '#    ', '#    ', ' ####'],
    'K': ['#   #', '#  # ', '###  ', '#  # ', '#   #', '#   #'],
}


def letter(ch):
    rows = ['22222222']
    for r in FONT[ch]:
        rows.append('3' + ''.join('0' if c == '#' else '3' for c in r) + '33')
    rows.append('22222222')
    return rows


SIGN_CAP = [  # left end of the marquee; the right end is its mirror
    '32222222',
    '32333333',
    '32330333',
    '32300033',
    '32330333',
    '32333333',
    '32333333',
    '32222222',
]
ICON = [  # gfx/icons/shuckle.png, frame 1: 1 = yellow body, 2 = red shell, 3 = ink
    '0000003333000000',
    '0000031111300000',
    '0000313113130000',
    '0000313113130000',
    '0000311111130000',
    '0000031111300000',
    '0000033311300000',
    '0003313113133000',
    '0003213113123000',
    '0332221331222330',
    '3132112112112313',
    '3331331221331333',
    '0033131221313300',
    '0311312222131130',
    '0333033333303330',
    '0000000000000000',
]


def shuckle_sprite():
    """The menu icon as sprite shades, one row lower to sit on its board.

    Body (icon shade 1) -> 1 yellow, shell (2) -> 2 red, outer outline -> 3
    (the neon tube), inner ink such as eyes and shell seams -> 0, transparent,
    so the black board behind shows through.
    """
    def clear(x, y):
        return not (0 <= x < 16 and 0 <= y < 16) or ICON[y][x] == '0'
    rows = ['0' * 16]
    for y in range(15):
        row = ''
        for x in range(16):
            c = ICON[y][x]
            if c == '3':
                outer = any(clear(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
                row += '3' if outer else '0'
            else:
                row += c
        rows.append(row)
    assert ICON[15] == '0' * 16
    return rows


# Sprite colours 1-3: body, shell, tube (colour 0 is transparent).
LIT = [(31, 28, 6), (31, 4, 3), (31, 31, 24)]
DARK = [(8, 7, 3), (9, 2, 2), (7, 7, 9)]         # switched off, at night
UNLIT = [(22, 20, 9), (21, 8, 6), (18, 18, 17)]  # switched off, in daylight
PULSE_STEPS = 16

BOARD = [  # black sign board with an orange rim (top-left quarter)
    '22222222',
    '23333333',
    '23333333',
    '23333333',
    '23333333',
    '23333333',
    '23333333',
    '23333333',
]


AWNING = [  # red and white stripes with a scalloped hem and shadow
    '33333333',
    '00220022',
    '00220022',
    '00220022',
    '00220022',
    '00220022',
    '30033003',
    '33333333',
]
PLANKS = [
    '31223122',
    '31223122',
    '31223122',
    '31203122',
    '31223122',
    '31223122',
    '31223120',
    '31223122',
]


NEW_TILES = {
    'cap': (YELLOW, SIGN_CAP),
    **{f'letter_{c}': (YELLOW, letter(c)) for c in 'SHUCK'},
    'board_top': (YELLOW, BOARD),
    'board_bottom': (YELLOW, BOARD[::-1]),
    'awning': (RED, AWNING),
    'planks': (BROWN, PLANKS),
}

# ---------------------------------------------------------- tileset state --
atlas = Image.open(PNG).convert('L')
assert atlas.mode == 'L' and atlas.size == (128, 128)
meta = bytearray(META.read_bytes())
attr = bytearray(ATTR.read_bytes())
coll_lines = COLL.read_text().splitlines(keepends=True)
assert len(meta) == len(attr) and len(meta) % 16 == 0
assert sum('tilecoll' in l for l in coll_lines) == len(meta) // 16
assert len(meta) // 16 >= VANILLA_BLOCKS
world = bytearray(MAP.read_bytes())
reclaimed = set()
previous = [world[by * MAP_WIDTH + bx] for bx, by in BUILDING_BLOCKS]
if all(b >= VANILLA_BLOCKS for b in previous) and len(meta) // 16 == VANILLA_BLOCKS + 3:
    # Drop this script's own facade blocks; their tiles become free again.
    reclaimed = {(t + 0x80 if a & 8 else t) for t, a in
                 zip(meta[VANILLA_BLOCKS * 16:], attr[VANILLA_BLOCKS * 16:])}
    del meta[VANILLA_BLOCKS * 16:], attr[VANILLA_BLOCKS * 16:]
    kept, seen = [], 0
    for line in coll_lines:
        if 'tilecoll' in line:
            seen += 1
            if seen > VANILLA_BLOCKS:
                continue
        kept.append(line)
    coll_lines = kept
blocks_before = len(meta) // 16


def slot_of(t, a):
    return t + 0x80 if a & 8 else t


referenced = {slot_of(t, a) for t, a in zip(meta, attr)}
shared_meta, shared_attr = (p.read_bytes() for p in SHARED)
referenced |= {slot_of(t, a) for t, a in zip(shared_meta, shared_attr)}
RESERVED = {0x03, 0x14, 0x7f, *range(0x0a, 0x13)}  # flower, water, $7f, roofs

SHADE = [255, 170, 85, 0]


def tile_bytes(rows):
    return bytes(SHADE[int(c)] for r in rows for c in r)


def slot_bytes(slot):
    return atlas.crop((slot % 16 * 8, slot // 16 * 8, slot % 16 * 8 + 8, slot // 16 * 8 + 8)).tobytes()


free = [s for s in range(0x80, 0x100) if s not in referenced and s not in RESERVED]
placed = {}
for name, (pal, rows) in NEW_TILES.items():
    assert len(rows) == 8 and all(len(r) == 8 for r in rows), name
    data = tile_bytes(rows)
    home = next((s for s in range(256) if s not in RESERVED and slot_bytes(s) == data
                 and (s in referenced or s in free)), None)
    if home is None:
        assert free, 'johto_modern has no unused tile slots left'
        home = free.pop(0)
        img = Image.new('L', (8, 8))
        img.putdata(list(data))
        atlas.paste(img, (home % 16 * 8, home // 16 * 8))
    elif home in free:
        free.remove(home)
    placed[name] = (home - 0x80, pal | 8) if home >= 0x80 else (home, pal)


def new(name, flip=0):
    t, a = placed[name]
    return (t, a | flip)


def old(block, row, col):
    i = block * 16 + row * 4 + col
    return (meta[i], attr[i])


EDGE_L, EDGE_R = old(0x10, 0, 0), old(0x11, 0, 3)
CORNER_L, CORNER_R = old(0x10, 3, 0), old(0x11, 3, 3)
BASE = old(0x10, 3, 1)
WINDOW = old(0x10, 1, 1)                       # Crystal's lit window
DOOR = [old(0x17, 2, 0), old(0x17, 2, 1), old(0x17, 3, 0), old(0x17, 3, 1)]

front = [  # 12 x 4 tiles: the three street-front blocks side by side
    [EDGE_L, new('cap'), *(new(f'letter_{c}') for c in 'SHUCKS'),
     new('board_top'), new('board_top', FLIP_X), new('planks'), EDGE_R],
    [EDGE_L, *[new('awning')] * 7, new('board_bottom'), new('board_bottom', FLIP_X),
     new('planks', FLIP_X), EDGE_R],
    [EDGE_L, WINDOW, WINDOW, new('planks'), DOOR[0], DOOR[1], new('planks'),
     WINDOW, WINDOW, new('planks'), new('planks', FLIP_X), EDGE_R],
    [CORNER_L, BASE, BASE, BASE, DOOR[2], DOOR[3], BASE, BASE, BASE, BASE, BASE, CORNER_R],
]
assert all(len(r) == 12 for r in front)
COLLISIONS = ['WALL, WALL, WALL, WALL', 'WALL, WALL, DOOR, WALL', 'WALL, WALL, WALL, WALL']

new_ids = []
for b in range(3):
    m = bytes(front[r][b * 4 + c][0] for r in range(4) for c in range(4))
    a = bytes(front[r][b * 4 + c][1] for r in range(4) for c in range(4))
    existing = next((i for i in range(len(meta) // 16)
                     if meta[i * 16:i * 16 + 16] == m and attr[i * 16:i * 16 + 16] == a), None)
    if existing is None:
        existing = len(meta) // 16
        assert existing < 0x100, 'johto_modern is out of metatiles'
        meta += m
        attr += a
        coll_lines.append(f'\ttilecoll {COLLISIONS[b]} ; {existing:02x}\n')
    new_ids.append(existing)

for (bx, by), block in zip(BUILDING_BLOCKS, new_ids):
    world[by * MAP_WIDTH + bx] = block

for slot in free:   # blank anything an earlier run used but this one doesn't
    if slot in reclaimed:
        atlas.paste(255, (slot % 16 * 8, slot // 16 * 8, slot % 16 * 8 + 8, slot // 16 * 8 + 8))
atlas.save(PNG)
META.write_bytes(bytes(meta))
ATTR.write_bytes(bytes(attr))
COLL.write_text(''.join(coll_lines))
MAP.write_bytes(bytes(world))

# The neon Shuckle object: sprite and palettes.
sprite = Image.new('L', (16, 16))
sprite.putdata([SHADE[int(c)] for r in shuckle_sprite() for c in r])
sprite.save(SPRITE_PNG)


def rgb(colours):
    return ', '.join(f'{v:02d}' for c in colours for v in c)


TRANSPARENT = [(31, 31, 31)]
SIGN_PAL.write_text(
    '; Generated by tools/build_goldenrod_shucks.py - do not edit.\n'
    '; Goldenrod neon Shuckle sign (rock OBJ slot): morn, day, nite, dark.\n'
    + ''.join(f'\tRGB {rgb(TRANSPARENT + colours)}\n' for colours in (UNLIT, UNLIT, DARK, DARK)))
steps = []
for n in range(PULSE_STEPS):
    t = n / (PULSE_STEPS - 1)
    steps.append([tuple(round(d + (l - d) * t) for d, l in zip(dark, lit)) for dark, lit in zip(DARK, LIT)])
PULSE_PAL.write_text(
    '; Generated by tools/build_goldenrod_shucks.py - do not edit.\n'
    f'; Goldenrod neon Shuckle sign colours 1-3, {PULSE_STEPS} steps from dark to lit.\n'
    + ''.join(f'\tRGB {rgb(colours)}\n' for colours in steps))
for path in STALE:
    if path.exists():
        path.unlink()
print('tile slots:', {k: hex(v[0] + (0x80 if v[1] & 8 else 0)) for k, v in placed.items()})
print('blocks:', [hex(b) for b in new_ids], f'({blocks_before} before)')
print('free tile slots left:', len(free))

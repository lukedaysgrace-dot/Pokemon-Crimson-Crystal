"""KOGA - Shadow Dojo."""
import numpy as np
from e4kit import *

PALS = [
    [(26, 24, 17), (21, 17, 7), (16, 13, 3), K2],     # 0 floor planks (Gen 2 brown)
    [W2, (25, 15, 31), (16, 7, 25), K2],              # 1 lanterns / purple cloth
    [W2, (23, 22, 21), (16, 13, 3), K2],              # 2 shoji paper + wood frame
    [W2, (19, 19, 19), (13, 13, 13), K2],             # 3 stone (Gen 2 gray)
    [W2, (29, 19, 31), (21, 8, 29), (9, 3, 14)],      # 4 poison: Blaine-gym lava colours in purple
    [W2, (23, 9, 7), (15, 5, 4), K2],                 # 5 red lacquer
    [(28, 28, 17), (24, 23, 9), (18, 8, 24), K2],     # 6 tatami + purple paint
]
FLOOR, CLOTH, SHOJI, STONE, POISON, WOOD, TATAMI = range(7)

W, H = 20, 36
cv = Canvas(W, H)
S = full(cv)

PLANK = [
    "0000000200000000",
    "1111111211111111",
    "1111111211111111",
    "2222222222222222",
    "0000000000000002",
    "1111111111111112",
    "1111111111111112",
    "2222222222222222",
]
PLANK_LIT = [
    "0111111301111111",
    "1121111311112111",
    "1111111311111111",
    "2333333323333333",
    "1111111101111113",
    "1111211111111113",
    "1111111112111113",
    "3333333233333333",
]

# ---------------------------------------------------------------- back wall
# ceiling beam
cv.setpal(0, 0, W, 1, WOOD)
cv.rect(0, 0, 160, 8, 2)
cv.hline(0, 0, 160, 3)
cv.hline(0, 1, 160, 1)
cv.hline(0, 6, 160, 3)
cv.hline(0, 7, 160, 3)
for x in range(0, 160, 16):
    cv.rect(x + 7, 2, 2, 4, 3)          # beam joints
    cv.pset(x + 6, 2, 1)

# shoji screens across the wall (rows 1-5 of tiles = y 8..47)
cv.setpal(0, 1, W, 5, SHOJI)
cv.rect(0, 8, 160, 40, 0)
# paper grid: kumiko lattice every 8px horizontally and 8px vertically
for y in range(8, 48):
    for x in range(160):
        if x % 8 == 0 or y % 8 == 0:
            cv.px[y, x] = 2
        elif x % 8 == 7 or y % 8 == 1:
            cv.px[y, x] = 1          # paper shading near the bars
# heavy frame posts every 32px and rails
for x in range(0, 161, 32):
    cv.rect(x - 2, 8, 4, 40, 2)
    cv.vline(x - 2, 8, 40, 3)
cv.rect(0, 8, 160, 2, 3)
cv.rect(0, 40, 160, 8, 2)           # wainscot (koshi-ita)
cv.hline(0, 40, 160, 3)
cv.hline(0, 41, 160, 1)
cv.hline(0, 47, 160, 3)
for x in range(4, 160, 8):
    cv.vline(x, 42, 5, 3)
# dim lower paper (shadowy): dither bottom rows of paper
for y in range(30, 40):
    for x in range(160):
        if cv.px[y, x] == 0 and (x + y) % 2 == 0 and y > 33:
            cv.px[y, x] = 1

# hanging scrolls either side of the doorway
SCROLL = [
    "3333333333",
    "3222222223",
    "3333333333",
    ".30000003.",
    ".30111103.",
    ".30133103.",
    ".30013003.",
    ".30333303.",
    ".30003003.",
    ".30030303.",
    ".30333003.",
    ".30003003.",
    ".30030303.",
    ".30303003.",
    ".30033003.",
    ".30300303.",
    ".30003003.",
    ".30111103.",
    ".30133103.",
    ".30000003.",
    "3333333333",
    "3222222223",
    "3333333333",
    "...3..3...",
]
for sx in (36, 114):
    cv.rect(sx + 2, 11, 6, 22, 1)    # cast shadow onto paper
    cv.stamp(sx, 10, SCROLL)

# ---------------------------------------------------------------- doorway
# Purple noren curtain over the door, rows 1-3 (y 8..31), static.
cv.setpal(8, 1, 4, 3, CLOTH)
cv.rect(64, 8, 32, 24, 3)
cv.rect(64, 8, 32, 3, 3)
cv.hline(64, 9, 32, 2)                # rod
for x in range(64, 96):
    for y in range(11, 31):
        cv.px[y, x] = 1 if (x - 64) % 11 not in (0,) else 2
# two slits
for sx in (74, 85):
    cv.vline(sx, 18, 13, 3)
    cv.vline(sx + 1, 18, 13, 2)
# folds
for x in (67, 70, 78, 81, 89, 92):
    cv.vline(x, 12, 18, 2)
cv.hline(64, 30, 32, 2)
cv.hline(64, 31, 32, 3)
# crest (diamond shuriken) in the centre panel, white
CREST = [
    "....3....",
    "...303...",
    "...303...",
    "3330303333",
    "3000000003",
    "3330303333",
    "...303...",
    "...303...",
    "....3....",
]
CREST = [
    "....33....",
    "...3003...",
    "..300003..",
    ".30011003.",
    "3001331003",
    "3001331003",
    ".30011003.",
    "..300003..",
    "...3003...",
    "....33....",
]
cv.stamp(75, 13, CREST)
for x in range(64, 96):
    if cv.px[11, x] != 3:
        cv.px[11, x] = 0

# door panels (closed) rows 4-5 (y32..47): dark lacquered sliding doors
def draw_door(c, open_=False):
    c.setpal(8, 4, 4, 2, WOOD)
    if open_:
        c.rect(64, 32, 32, 16, 3)
        # faint floorboards receding into darkness
        for y in range(40, 48):
            for x in range(66, 94):
                if (x + y) % 2 == 0 and y >= 44:
                    c.px[y, x] = 2
        c.rect(64, 32, 2, 16, 2)
        c.rect(94, 32, 2, 16, 2)
        c.vline(64, 32, 16, 1)
        c.vline(95, 32, 16, 1)
        return
    c.rect(64, 32, 32, 16, 1)
    for x0 in (64, 80):
        c.frame(x0, 32, 16, 16, 3)
        c.rect(x0 + 2, 34, 12, 12, 2)
        for yy in range(35, 45, 3):
            c.hline(x0 + 3, yy, 10, 1)
        c.vline(x0 + 7, 34, 12, 3)
        c.vline(x0 + 8, 34, 12, 1)
    c.rect(78, 38, 4, 4, 0)  # metal pulls
    c.pset(79, 39, 3); c.pset(80, 40, 3)

draw_door(cv)

# ---------------------------------------------------------------- floor strip (row 3, y48..63)
cv.setpal(0, 6, W, 2, FLOOR)
cv.tex(0, 48, 160, 16, PLANK)
cv.hline(0, 48, 160, 3)  # wall shadow
for x in range(0, 160, 2):
    cv.pset(x, 49, 2)

# ---------------------------------------------------------------- guardian statues in alcoves
NINJA = [
    "......3333......",
    "....33001133....",
    "...3001111123...",
    "..300111111123..",
    "..333333333333..",
    "..330033330033..",
    "..333333333333..",
    "..311111111123..",
    "...3111111123...",
    "..33311111233...",
    ".3011322223112 3",
    "3011113223111123",
    "3111111331111123",
    "3113331111333123",
    "3130013333100323",
    "3131113003111323",
    ".31333133133313.",
    ".31111111111123.",
    ".33333333333333.",
    "311123....311123",
    "301123....301123",
    "311223....311223",
    "333333....333333",
]
NINJA = [r.replace(' ', '') for r in NINJA]
NINJA = [r if len(r) == 16 else r[:16].ljust(16, '.') for r in NINJA]
PEDESTAL = [
    "3333333333333333",
    "3000000000000013",
    "3011111111111123",
    "3222222222222223",
    ".31111111111113.",
    ".31033333333013.",
    ".31031111112013.",
    ".31033333333013.",
    ".31111111111123.",
    ".32222222222223.",
    "3333333333333333",
]
BLOCK = [
    "0000000000000001",
    "0111111111111112",
    "0111111111111112",
    "0112111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111112112",
    "0111111111111112",
    "0111111111111112",
    "1222222222222222",
    "3333333333333333",
]


def statue(cv, x0):
    """Stone shrine corner: gray block wall with a ninja guardian statue on
    a pedestal (Gen 2 statue proportions, 16x34)."""
    cv.setpal(x0 // 8, 1, 4, 7, STONE)
    cv.tex(x0, 8, 32, 56, BLOCK, oy=-8)
    cv.hline(x0, 8, 32, 3)
    cv.stamp(x0 + 8, 29, NINJA)
    cv.stamp(x0 + 8, 52, PEDESTAL)
    # soft shadow on the blocks beside the statue
    for y in range(32, 63):
        if cv.px[y, x0 + 24] != 3:
            cv.px[y, x0 + 24] = 2


statue(cv, 0)

# ---------------------------------------------------------------- poison moats (rows 4-13, x 0..31 & 128..159)
# bubbling poison: the very lava tiles of Blaine's gym (gfx/tilesets/lava),
# recoloured purple. Like the cave lava, the pool is a checkerboard of two
# copies of the bubble cycle running at different speeds and phases.
def _lava(i):
    from PIL import Image
    im = Image.open(ROOT + 'gfx/tilesets/lava/%d.png' % i).convert('L')
    return np.array([[3 - round(im.getpixel((x, y)) / 85) for x in range(8)] for y in range(8)], np.uint8)


LAVA = [_lava(i) for i in range(1, 5)]
# Eight independently timed bubble tiles, all upright Blaine-gym lava frames.
# They are private animated tiles (not shared by picture), so tiles showing
# the same frame still bubble on their own schedules: a bubble rises (0),
# bursts (1), leaves ripples (2), then the surface rests (3) for an
# irregular time. Half of them run at half speed.
LAVA_VARIANTS = [
    (LAVA, [0, 1, 2, 3, 3, 3, 3, 3, 3, 0, 1, 2, 3, 3, 3, 3], 3),
    (LAVA, [1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 2, 3, 3], 4),
    (LAVA, [2, 3, 3, 3, 0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 0, 1], 3),
    (LAVA, [3, 3, 3, 3, 3, 3, 0, 1, 2, 3, 3, 3, 0, 1, 2, 3], 4),
    (LAVA, [3, 0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 3),
    (LAVA, [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 2, 3, 3], 3),
    (LAVA, [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 4),
    (LAVA, [3, 3, 3, 0, 1, 2, 3, 3, 3, 3, 3, 3, 0, 1, 2, 3], 4),
]


def _lava_grid():
    """Fixed random scatter of the eight tiles over the moat cells (4 x 20),
    with no two touching cells (including diagonals) sharing a tile."""
    rng = np.random.default_rng(1957)
    grid = {}
    for cy in range(8, 28):
        for cx in range(4):
            taken = {grid.get((cx + dx, cy + dy)) for dx in (-1, 0, 1) for dy in (-1, 0)}
            choices = [v for v in range(8) if v not in taken]
            grid[cx, cy] = int(rng.choice(choices))
    return grid


LAVA_GRID = _lava_grid()


def lava_variant(cx, cy):
    return LAVA_GRID[cx % 16 if cx < 16 else 19 - cx, cy]


def moat(x0):
    cv.setpal(x0 // 8, 8, 4, 20, POISON)
    for cy in range(8, 28):
        for cx in range(x0 // 8, x0 // 8 + 4):
            frames, seq, _ = LAVA_VARIANTS[lava_variant(cx, cy)]
            stamp_array(cv, cx * 8, cy * 8, frames[seq[0]])
    # stone curb top and bottom
    cv.setpal(x0 // 8, 8, 4, 1, STONE)
    shade(cv, rmask(S, x0, 64, 32, 8), base=1, light=0, dark=2)
    for x in range(x0 + 7, x0 + 32, 8):
        cv.vline(x, 65, 6, 2)
    cv.setpal(x0 // 8, 27, 4, 1, STONE)
    shade(cv, rmask(S, x0, 216, 32, 8), base=1, light=0, dark=2)
    for x in range(x0 + 3, x0 + 32, 8):
        cv.vline(x, 217, 6, 2)

moat(0)
moat(128)

# ---------------------------------------------------------------- pillars standing in the moat
def pillar(px, top):
    """32px tall dark wood post standing in the moat, with a purple paper
    lantern hung on it (lantern cells use the cloth palette)."""
    cv.setpal(px // 8, top // 8, 2, 4, WOOD)
    cv.setpal(px // 8, top // 8 + 1, 2, 2, CLOTH)
    # shaft: wood rows (palette WOOD) and lantern rows (palette CLOTH, purple-lit wood)
    for y in range(top, top + 32):
        for x in range(px + 3, px + 13):
            k = x - (px + 3)
            v = [3, 0, 0, 1, 1, 1, 1, 2, 2, 3][k]
            if top + 8 <= y < top + 24:
                v = [3, 2, 2, 2, 3, 3, 2, 3, 3, 3][k]
            cv.px[y, x] = v
    # cap beam
    shade(cv, rmask(S, px + 1, top, 14, 5), base=2, light=1, dark=3)
    cv.hline(px + 1, top + 5, 14, 3)
    # footing stone (wood palette darks)
    shade(cv, rmask(S, px + 1, top + 24, 14, 8), base=2, light=1, dark=3)
    cv.hline(px + 3, top + 27, 10, 3)
    # lantern
    m = emask(S, px + 7.5, top + 15.5, 6, 7)
    shade(cv, m, base=1, light=0, dark=2)
    for yy in (top + 12, top + 15, top + 18):
        for xx in range(px + 2, px + 14):
            if m[yy, xx] and cv.px[yy, xx] == 1:
                cv.px[yy, xx] = 2
    cv.rect(px + 4, top + 8, 8, 2, 3)
    cv.rect(px + 4, top + 22, 8, 2, 3)
    cv.rect(px + 6, top + 13, 3, 4, 0)

for top in (96, 160):
    pillar(16, top)

# ---------------------------------------------------------------- Koga's raised platform (rows 4-7 x2-7) + face row 8
cv.setpal(4, 8, 12, 8, WOOD)
# vertical polished boards
for x in range(32, 128):
    for y in range(64, 128):
        k = x % 8
        v = 1
        if k == 0:
            v = 2
        elif k == 1:
            v = 0
        elif k == 5 and (y % 16) in (9, 10):
            v = 2
        cv.px[y, x] = v
# polished sheen band
for y in range(64, 128):
    for x in range(32, 128):
        pass
# edging rim
cv.rect(32, 64, 96, 3, 2); cv.hline(32, 64, 96, 3); cv.hline(32, 66, 96, 1)
cv.rect(32, 64, 3, 64, 2); cv.vline(32, 64, 64, 3)
cv.rect(125, 64, 3, 64, 2); cv.vline(127, 64, 64, 3)
# purple runner cloth on the platform leading to the door (x 64..95)
cv.setpal(8, 8, 4, 8, CLOTH)
for y in range(64, 128):
    for x in range(64, 96):
        e = min(x - 64, 95 - x)
        cv.px[y, x] = 3 if e in (0, 3) else (1 if e == 2 else (0 if e == 1 and y % 4 == 0 else 2))
for y in range(64, 128, 16):
    for x in range(64, 96):
        e = min(x - 64, 95 - x)
        if e > 4 and abs((x - 79.5)) + abs(((y + 8) % 16) - 8) < 5:
            cv.px[y + (8 - abs(int(x - 79.5)) if False else 0), x] = cv.px[y, x]
for y0 in range(68, 128, 16):
    cv.stamp(76, y0, ["...33...", "..3113..", ".311113.", "31100113", "31100113", ".311113.", "..3113..", "...33..."])
# standing andon lanterns at back corners of the platform (steps (2,4) and (7,4))
for lx in (32, 112):
    cv.setpal(lx // 8, 8, 2, 2, CLOTH)
    cv.rect(lx, 64, 16, 16, 3)
    m = rmask(S, lx + 3, 65, 10, 12)
    shade(cv, m, base=1, light=0, dark=2)
    cv.rect(lx + 5, 68, 6, 6, 0)
    cv.vline(lx + 8, 66, 10, 2)
    cv.hline(lx + 4, 71, 8, 2)
    cv.rect(lx + 2, 77, 12, 2, 3)
    cv.rect(lx + 4, 79, 2, 1, 3); cv.rect(lx + 10, 79, 2, 1, 3)
# front face of the platform (row 8, y 128..143) with stairs in centre
cv.setpal(4, 16, 12, 2, WOOD)
cv.rect(32, 128, 96, 16, 2)
cv.hline(32, 128, 96, 0)
cv.hline(32, 129, 96, 1)
for x in range(34, 128, 6):
    cv.vline(x, 131, 12, 3)
cv.hline(32, 142, 96, 3); cv.hline(32, 143, 96, 3)
# stairs x 64..95
cv.setpal(8, 16, 4, 2, CLOTH)
for i, y in enumerate(range(128, 144, 5)):
    cv.rect(64, y, 32, 5, 2)
    cv.hline(64, y, 32, 1)
    cv.hline(64, y + 1, 32, 1)
    cv.hline(64, y + 4, 32, 3)
cv.vline(64, 128, 16, 3); cv.vline(95, 128, 16, 3)
cv.vline(65, 128, 16, 2); cv.vline(94, 128, 16, 2)

# ---------------------------------------------------------------- tatami battlefield rows 9-13 (y 144..223), x 32..127
cv.setpal(4, 18, 12, 10, TATAMI)
def tatami_mat(x, y, w, h):
    cv.rect(x, y, w, h, 1)
    pat = [1, 0, 0, 1, 1, 0, 0, 1]
    for yy in range(y, y + h):
        for xx in range(x, x + w):
            k = yy % 8 if w > h else xx % 8
            cv.px[yy, xx] = pat[k]
    cv.frame(x, y, w, h, 3)
for my in (144, 208):
    for mx in (32, 64, 96):
        tatami_mat(mx, my, 32, 16)
for mx in (32, 112):
    for my in (160, 184):
        tatami_mat(mx, my, 16, 24)
for my in (160, 176, 192):
    for mx in (48, 80):
        tatami_mat(mx, my, 32, 16)
# dark rim around battlefield
cv.frame(32, 144, 96, 80, 3)
# painted Koga crest in purple: four-bladed shuriken in a ring
cx, cy = 79.5, 183.5
ring = band(emask(S, cx, cy, 30, 30), 3)
cv.px[ring & (cv.px != 3) | ring] = 2
yy, xx = np.mgrid[0:S[0], 0:S[1]]
dx, dy = xx - cx, yy - cy
blade = np.zeros(S, bool)
for (ax, ay) in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
    # each blade: thin triangle along axis with a curved hook
    along = dx * ax + dy * ay
    perp = -dx * ay + dy * ax
    blade |= (along > 2) & (along < 24) & (abs(perp) < 0.5 + 5.0 * (1 - along / 24.0))
core = emask(S, cx, cy, 6, 6)
paint = blade | core
outline = paint & ~(shift(paint, 1, 0) & shift(paint, -1, 0) & shift(paint, 0, 1) & shift(paint, 0, -1))
region = rmask(S, 40, 150, 80, 68)
cv.px[paint & region] = 2
cv.px[outline & region] = 3
hole = emask(S, cx, cy, 2.2, 2.2)
cv.px[hole] = 1
ringo = ring & ~(shift(ring, 1, 0) & shift(ring, -1, 0) & shift(ring, 0, 1) & shift(ring, 0, -1))
cv.px[ringo] = 3

# ---------------------------------------------------------------- dividing wall with entrance gate (rows 14-15, y 224..255)
cv.setpal(0, 28, W, 4, SHOJI)
cv.rect(0, 224, 160, 32, 0)
for y in range(230, 256):
    for x in range(160):
        if x % 8 == 4 or y % 8 == 6:
            cv.px[y, x] = 2
        elif x % 8 == 3 or y % 8 == 7:
            cv.px[y, x] = 1
cv.setpal(0, 28, W, 1, WOOD)
cv.rect(0, 224, 160, 8, 2); cv.hline(0, 224, 160, 1); cv.hline(0, 225, 160, 0); cv.hline(0, 231, 160, 3)
for x in range(0, 160, 16):
    cv.vline(x + 15, 226, 5, 3)
cv.rect(0, 248, 160, 8, 2)
cv.hline(0, 248, 160, 3)
for x in range(2, 160, 6):
    cv.vline(x, 250, 5, 3)
cv.hline(0, 255, 160, 3)
for x in range(0, 161, 32):
    cv.rect(x - 2, 232, 4, 16, 2)
    cv.vline(x - 2, 232, 16, 3)

def draw_gate(c, closed=False):
    c.setpal(8, 28, 4, 4, WOOD)
    c.prio[28, 8:12] = not closed   # lintel drawn over the player in the doorway
    if not closed:
        c.rect(64, 224, 32, 32, 3)
        # passage floor visible through the opening
        c.setpal(8, 29, 4, 3, FLOOR)
        c.tex(64, 232, 32, 24, PLANK)
        c.setpal(9, 29, 2, 3, CLOTH)
        for y in range(232, 256):
            for x in range(72, 88):
                e = min(x - 72, 87 - x)
                c.px[y, x] = 3 if e == 0 else (1 if e == 1 else 2)
        # lintel beam stays
        c.setpal(8, 28, 4, 1, WOOD)
        c.rect(64, 224, 32, 8, 2); c.hline(64, 224, 32, 1); c.hline(64, 225, 32, 0); c.hline(64, 231, 32, 3)
        c.vline(79, 226, 5, 3)
        # posts
        c.setpal(8, 29, 1, 3, WOOD); c.setpal(11, 29, 1, 3, WOOD)
        for px in (64, 92):
            c.rect(px, 232, 4, 24, 1)
            c.vline(px + (3 if px == 64 else 0), 232, 24, 3)
            c.vline(px + (0 if px == 64 else 3), 232, 24, 0)
        c.rect(68, 232, 4, 24, 3)
        c.rect(88, 232, 4, 24, 3)
        for y in range(232, 256, 2):
            c.pset(69, y, 2); c.pset(90, y + 1, 2)
        return
    # closed: heavy sliding doors with crest, plus lintel
    c.rect(64, 224, 32, 8, 2); c.hline(64, 224, 32, 1); c.hline(64, 225, 32, 0); c.hline(64, 231, 32, 3)
    c.rect(64, 232, 32, 24, 1)
    for x0 in (64, 80):
        c.frame(x0, 232, 16, 24, 3)
        c.rect(x0 + 2, 234, 12, 20, 2)
        for yy in range(236, 252, 4):
            c.hline(x0 + 3, yy, 10, 3)
    c.rect(77, 240, 6, 8, 0)
    c.frame(77, 240, 6, 8, 3)

draw_gate(cv)

# ---------------------------------------------------------------- antechamber rows 16-17 (y 256..287)
cv.setpal(0, 32, W, 4, FLOOR)
cv.tex(0, 256, 160, 32, PLANK)
cv.hline(0, 256, 160, 3)
for x in range(0, 160, 2):
    cv.pset(x, 257, 2)
# side walls (dark vertical boards)
cv.setpal(0, 32, 2, 4, WOOD); cv.setpal(18, 32, 2, 4, WOOD)
for x0 in (0, 144):
    for x in range(x0, x0 + 16):
        for y in range(256, 288):
            k = (x - x0) % 5
            cv.px[y, x] = 3 if k == 0 else (2 if k in (1, 4) else 1)
# purple runner to the warp
cv.setpal(8, 32, 4, 4, CLOTH)
for y in range(256, 288):
    for x in range(64, 96):
        e = min(x - 64, 95 - x)
        cv.px[y, x] = 3 if e in (0, 3) else (1 if e == 2 else (0 if e == 1 and y % 4 == 0 else 2))
for y0 in (268,):
    cv.stamp(76, y0, ["...33...", "..3113..", ".311113.", "31100113", "31100113", ".311113.", "..3113..", "...33..."])
# stone lanterns (toro) in the antechamber, steps (1..2,16..17)
def toro(x0):
    """stone lantern on a raked-gravel bed, 32x32 at x0 (cells in STONE)."""
    cv.setpal(x0 // 8, 32, 4, 4, STONE)
    # gravel bed with raked lines
    for y in range(256, 288):
        for x in range(x0, x0 + 32):
            cv.px[y, x] = 0 if (y % 4 == 0) else (1 if (y % 4) in (1, 3) else 0)
            if y % 4 == 2 and (x * 5 + y) % 7 == 0:
                cv.px[y, x] = 2
    cv.frame(x0, 256, 32, 32, 3)
    cv.rect(x0 + 1, 257, 30, 2, 2)
    cv.vline(x0 + 1, 257, 30, 2); cv.vline(x0 + 30, 257, 30, 2)
    # concentric raking around the lantern foot
    ring = band(emask(S, x0 + 15.5, 282, 12, 6), 2)
    cv.px[ring & rmask(S, x0 + 2, 258, 28, 30)] = 1
    tx = x0 + 4
    # roof cap
    shade(cv, pmask(S, [(tx, 265), (tx + 10, 260), (tx + 13, 260), (tx + 23, 265), (tx + 23, 269), (tx, 269)]), base=1, light=0, dark=2)
    cv.pset(tx + 11, 258, 3); cv.pset(tx + 12, 258, 3)
    # fire box with violet glow
    shade(cv, rmask(S, tx + 5, 269, 14, 8), base=2, light=1, dark=3)
    cv.rect(tx + 8, 271, 8, 4, 0)
    cv.vline(tx + 11, 271, 4, 1); cv.vline(tx + 12, 271, 4, 1)
    shade(cv, rmask(S, tx + 3, 276, 18, 3), base=1, light=0, dark=2)
    # shaft and base
    shade(cv, rmask(S, tx + 8, 278, 8, 6), base=1, light=0, dark=2)
    shade(cv, rmask(S, tx + 4, 283, 16, 4), base=1, light=0, dark=2)
toro(16)

# ---------------------------------------------------------------- collision
for y in range(18):
    for x in range(10):
        cv.coll[y][x] = 'WALL'
cv.walk(2, 3, 6, 1)
cv.walk(2, 4, 6, 4)
cv.walk(2, 4, 1, 1, 'WALL'); cv.walk(7, 4, 1, 1, 'WALL')
cv.walk(4, 8, 2, 1)
cv.walk(2, 9, 6, 5)
cv.walk(4, 14, 2, 2)
cv.walk(4, 16, 2, 1)
cv.walk(3, 16, 1, 2); cv.walk(6, 16, 1, 2)
cv.walk(4, 17, 2, 1, 'WARP_CARPET_DOWN')
cv.walk(4, 2, 2, 1, 'WALL')

# ---------------------------------------------------------------- symmetry
cv.mirror_x(0, 160); cv.mirror_pal_x(); cv.mirror_coll_x()
# the right moat shows the lava upright too (the mirror flipped it)
for (cx, cy), v in LAVA_GRID.items():
    frames, seq, _ = LAVA_VARIANTS[v]
    rx = 19 - cx
    if (cv.px[cy * 8:cy * 8 + 8, rx * 8:rx * 8 + 8] == frames[seq[0]][:, ::-1]).all():
        cv.px[cy * 8:cy * 8 + 8, rx * 8:rx * 8 + 8] = frames[seq[0]]

# ---------------------------------------------------------------- variants
door_open = cv.copy(); draw_door(door_open, open_=True); door_open.mirror_all()
door_open.walk(4, 2, 2, 1, 'LADDER')
gate_closed = cv.copy(); draw_gate(gate_closed, closed=True); gate_closed.mirror_all()
gate_closed.walk(4, 14, 2, 2, 'WALL')

border = Canvas(4, 4)
border.setpal(0, 0, 4, 4, WOOD)
border.rect(0, 0, 32, 32, 3)

# the moat cells each bubble tile covers (left moat and its mirror image;
# posts and curbs hide some of the moat)
LAVA_CELLS = {v: [] for v in range(8)}
for (cx, cy), v in LAVA_GRID.items():
    frames, seq, _ = LAVA_VARIANTS[v]
    if (cv.px[cy * 8:cy * 8 + 8, cx * 8:cx * 8 + 8] == frames[seq[0]]).all():
        LAVA_CELLS[v] += [(cx, cy), (19 - cx, cy)]
assert all(LAVA_CELLS.values()), LAVA_CELLS

if __name__ == '__main__':
    info = build_room('kogas_room', 'KogasRoom', cv, PALS, border,
                      {'door_open': (door_open, 2, 1), 'gate_closed': (gate_closed, 2, 7)},
                      out_preview=OUT + 'koga_preview.png',
                      anims=[dict(name='Poison%d' % v, cells=LAVA_CELLS[v], frames=LAVA_VARIANTS[v][0],
                                  seq=LAVA_VARIANTS[v][1], shift=LAVA_VARIANTS[v][2]) for v in range(8)])
    preview(cv, PALS, OUT + 'koga_coll.png', coll=True)
    preview(door_open, PALS, OUT + 'koga_open.png')
    preview(gate_closed, PALS, OUT + 'koga_closed.png')

"""KAREN - Midnight Manor."""
import numpy as np
from e4kit import *

DK2 = (8, 6, 14)
DK3 = K2
PALS = [
    [W2, (13, 11, 21), DK2, DK3],                        # 0 black marble + starlight
    [W2, (22, 17, 31), (14, 9, 24), DK3],                # 1 violet stone (arches, columns)
    [(31, 31, 7), (30, 10, 6), (9, 9, 31), DK3],         # 2 stained glass (Gen 2 yellow/red/blue)
    [(31, 26, 8), (30, 10, 6), (19, 4, 4), DK3],         # 3 crimson carpet, gold trim
    [(17, 13, 24), (12, 9, 18), DK2, DK3],               # 4 damask walls
    [W2, (31, 26, 7), DK2, DK3],                         # 5 candle flame + gilt (flicker)
    [(27, 20, 31), (17, 8, 27), DK2, DK3],               # 6 dark fire braziers (pulsing)
]
CAND = [
 "...1....1....1..",
 "..111..111..111.",
 "..101..101..101.",
 "..101..101..101.",
 "...1....1....1..",
 "..303..303..303.",
 "..303..303..303.",
 "..303..303..303.",
 "..333..333..333.",
 ".31113311133111.",
 "..333..313..333.",
 "..31....1....13.",
 "...31...1...13..",
 "....3113113113..",
 ".....3311133....",
 ".......313......",
 "......31013.....",
 ".......313......",
 ".......313......",
 ".......313......",
 "......31113.....",
 ".......313......",
 ".......313......",
 ".......313......",
 ".......313......",
 "......31013.....",
 ".....3111113....",
 "....311111113...",
 "...31111111113..",
 "...33333333333..",
]
CHAN = [
 "...............33...............",
 "...............13...............",
 "..............3113..............",
 "................................",
 "...1.....1.....1.....1.....1....",
 "..111...111...111...111...111...",
 "..101...101...101...101...101...",
 "..101...101...101...101...101...",
 "...1.....1.....1.....1.....1....",
 "..303...303...303...303...303...",
 "..303...303...303...303...303...",
 ".31113.31113.31113.31113.31113..",
 "..3113111311131113111311131113..",
 "...31111111111111111111111113...",
 "....33111111110001111111113 3...",
 "......333111111111111113333.....",
 ".........3331111111113 3........",
 "............33111113 3..........",
 "..............31113.............",
 "...............313..............",
 "..............31013.............",
 "...............313..............",
 "................................",
]
CHAN = [r.replace(' ', '').ljust(32, '.')[:32] for r in CHAN]
CAND = [r.ljust(16, '.')[:16] for r in CAND]
MARBLE, VIOLET, GLASS, CARPET, WALL, GILT, GARG = range(7)
DARKFIRE = GARG
W, H = 20, 36
cv = Canvas(W, H)
S = full(cv)
yy, xx = np.mgrid[0:S[0], 0:S[1]]


def gothic_arch(x0, x1, ytop, yspring):
    """Pointed-arch mask: opening between x0..x1 (exclusive), apex at ytop,
    springing line at yspring; everything below the springing is open."""
    w = x1 - x0
    r = w * 0.8
    c1 = x0 + r          # centre of the left arc (on the springing line)
    c2 = x1 - r
    left = ((xx - c2) ** 2 + ((yy - yspring) * (r / max(yspring - ytop, 1)) * 0.6) ** 2 <= r * r)
    right = ((xx - c1) ** 2 + ((yy - yspring) * (r / max(yspring - ytop, 1)) * 0.6) ** 2 <= r * r)
    m = left & right & (yy <= yspring) & (xx >= x0) & (xx < x1)
    m |= (yy > yspring) & (xx >= x0) & (xx < x1)
    # exactly symmetric about the arch centre, then evenly stepped
    mirror = np.zeros_like(m)
    for x in range(max(x0, 0), min(x1, m.shape[1])):
        xm = x0 + x1 - 1 - x
        if 0 <= xm < m.shape[1]:
            mirror[:, x] = m[:, xm]
    return convexify(m & mirror)


DAMASK = [
    "1111111211111111",
    "1111112321111111",
    "1111123032111111",
    "1111230003211111",
    "1111123032111111",
    "1111112321111111",
    "1111111211111111",
    "1111111111111111",
    "2111111111111112",
    "3211111111111123",
    "0321111111111230",
    "0032111111112300",
    "0321111111111230",
    "3211111111111123",
    "2111111111111112",
    "1111111111111111",
]
# black marble: 16x16 slabs, alternating veining
MARB_A = [
    "1111111111111112",
    "1011111111111112",
    "1101111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "2222222222222223",
]
MARB_B = [
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222122223",
    "2222222221012223",
    "2222222222122223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "2222222222222223",
    "3333333333333333",
]

# ------------------------------------------------------------ back wall (rows 0-2)
cv.setpal(0, 0, 10, 6, WALL)
cv.tex(0, 0, 80, 48, DAMASK)
cv.rect(0, 0, 80, 2, 3)
cv.hline(0, 2, 80, 2)
cv.rect(0, 40, 80, 8, 2)            # wainscot
cv.hline(0, 40, 80, 0)
cv.hline(0, 41, 80, 1)
cv.hline(0, 47, 80, 3)
for x in range(0, 80, 8):
    cv.vline(x + 3, 42, 5, 3)
    cv.vline(x + 4, 42, 5, 1)

# tall stained-glass window (x 4..27) in each corner
cv.setpal(0, 0, 4, 6, GLASS)
cv.px[rmask(S, 0, 0, 32, 48)] = 3
win = gothic_arch(6, 26, 3, 15) & (yy < 41)
cv.px[win] = 2
pane = win & ~(shift(win, 2, 0) & shift(win, -2, 0) & shift(win, 0, 2) & shift(win, 0, -2))
cv.px[pane] = 1
cv.px[edge_of(win)] = 3
for y in range(3, 41):
    for x in range(6, 26):
        if win[y, x] and (y in (17, 29)):
            cv.px[y, x] = 3
# hand-set crescent moon (thick, evenly curved)
MOON_ROWS = ["...0000", ".0000..", ".000...", "000....", "000....", "000....",
             "000....", "000....", ".000...", ".0000..", "...0000"]
MOON = np.zeros(S, bool)
for j, row in enumerate(MOON_ROWS):
    for i, ch in enumerate(row):
        MOON[5 + j, 9 + i] = ch == '0'
MOON &= win
cv.px[MOON] = 0
for (sx, sy) in [(20, 8), (21, 13), (9, 19), (22, 25)]:
    cv.pset(sx, sy, 0)
WINDOW_BARE = cv.px[0:48, 0:32].copy()       # glass without bats, moon stays
# two bat silhouettes flying across the moonlit band between the leading
# lines (glide / wings up / glide / wings down); see bat_band() below
BIG_BAT = {
    'glide': ["...3.3...", "33.333.33", "333333333", "3...3...3"],
    'up':    ["3..3.3..3", "33.333.33", ".3333333.", "....3...."],
    'down':  ["...3.3...", "..33333..", ".3333333.", "33..3..33", "3.......3"],
}
SMALL_BAT = {
    'glide': ["..3.3..", "3.333.3", "3333333", "3..3..3"],
    'up':    ["3.3.3.3", "3333333", "..333..", "...3..."],
    'down':  ["..3.3..", ".33333.", "3333333", "3.....3"],
}
BIG_HOME, SMALL_HOME = (8, 21), (17, 18)
WINDOW_NO_CAT = cv.px[0:48, 0:32].copy()
cv.stamp(8, 33, ["3.3...", "333...", "3333..", ".33333", ".33333", "333333"])  # sitting cat
cv.stamp(13, 37, ["3333333333"])
# stone sill (glass palette: lit edge in moon-gold reads as moonlit stone)
cv.hline(4, 41, 24, 0)
cv.hline(4, 42, 24, 3)

# ------------------------------------------------------------ grand gothic archway (x 32..127, y 0..63)
cv.setpal(4, 0, 6, 8, VIOLET)
outer = gothic_arch(32, 128, -10, 26)
opening = gothic_arch(48, 112, 2, 30)
left = xx < 80
cv.px[rmask(S, 32, 0, 48, 64) & ~outer] = 3       # placeholder, wall shown in violet darks
# masonry of the arch ring
cv.px[outer & ~opening & left] = 1
ang = np.arctan2(yy - 30, xx - 80)
seg = ((ang + np.pi) / np.pi * 14).astype(int)
ringm = outer & ~opening & (yy <= 30)
# (no radial joints: on a curve they come out as ragged dotted lines)
cv.px[edge_of(outer) & left] = 3
cv.px[edge_of(opening) & left] = 3
cv.px[shift(edge_of(opening), 0, 1) & ringm & left] = 0
# wall behind the arch outside its ring: damask in violet darks
for y in range(0, 48):
    for x in range(32, 80):
        if not outer[y, x]:
            v = DAMASK[y % 16][x % 16]
            cv.px[y, x] = 3 if v == '3' else (2 if v in '01' else 3)
# the spandrel above the columns is plain dark violet, so the arch edge
# reads as one clean line (a damask cut by the curve left ragged bits)
cv.px[~outer & left & (xx >= 32) & (yy < 22)] = 2
cv.px[edge_of(outer) & left] = 3
cv.rect(32, 40, 48, 8, 2); cv.hline(32, 40, 48, 0); cv.hline(32, 47, 48, 3)
# columns (x 32..47) from y 26 to 63
for y in range(26, 64):
    for x in range(32, 48):
        cv.px[y, x] = [3, 1, 0, 0, 1, 2, 3, 0, 0, 1, 1, 2, 3, 1, 2, 3][x - 32]
shade(cv, rmask(S, 31, 22, 18, 7), base=1, light=0, dark=2)
cv.hline(32, 25, 16, 2)
shade(cv, rmask(S, 31, 56, 18, 8), base=1, light=0, dark=2)
cv.hline(32, 59, 16, 2)
# keystone with a crescent
cv.rect(76, 0, 4, 9, 0)
cv.vline(76, 0, 9, 3)
cv.hline(76, 9, 4, 3)
# dark recess inside the arch above the door with a gilt chandelier hanging
cv.px[opening & left & (yy < 64)] = 3
cv.setpal(6, 0, 4, 4, GILT)
cv.px[rmask(S, 48, 0, 32, 32) & ~opening] = 2
# re-draw arch ring pixels in those cells with gilt darks so the edge stays crisp
for y in range(0, 32):
    for x in range(48, 80):
        if not opening[y, x]:
            cv.px[y, x] = 3 if (edge_of(opening)[y, x] or edge_of(outer)[y, x]) else 2
def chandelier(c, cx_, y0):
    c.stamp(cx_ - 16, y0, CHAN)
chandelier(cv, 80, 4)

# door (rows 4-5, y 32..47)
def draw_door(c, open_=False):
    c.setpal(8, 4, 2, 2, VIOLET)
    if open_:
        c.rect(64, 32, 16, 16, 3)
        for y in range(40, 48):
            for x in range(64, 80):
                if (x + y) % 2 == 0 and y > 43:
                    c.px[y, x] = 2
        c.vline(64, 32, 16, 2)
        return
    c.rect(64, 32, 16, 16, 2)
    c.vline(64, 32, 16, 3)
    c.vline(79, 32, 16, 3)
    c.vline(78, 32, 16, 1)
    for y in (34, 41):
        c.frame(67, y, 9, 6, 3)
        c.hline(68, y + 1, 7, 1)
        c.vline(71, y + 1, 4, 0)
    c.rect(76, 39, 2, 3, 0)
draw_door(cv)
# floor in the arch mouth (y 48..63, x 48..79): dais stone
DAIS = [
    "2222222112222222",
    "2222221001222222",
    "2222210110122222",
    "2222101111012222",
    "2221011111101222",
    "2210111111110122",
    "2101111111111012",
    "1011111111111101",
    "1011111111111101",
    "2101111111111012",
    "2210111111110122",
    "2221011111101222",
    "2222101111012222",
    "2222210110122222",
    "2222221001222222",
    "2222222112222222",
]
cv.setpal(6, 6, 4, 2, VIOLET)
cv.tex(48, 48, 32, 16, DAIS)
cv.hline(48, 48, 32, 3)

# ------------------------------------------------------------ dais rows 4-7 (x 32..127)
cv.setpal(4, 8, 6, 8, VIOLET)
cv.tex(32, 64, 48, 64, DAIS)
cv.frame(32, 64, 49, 64, 3)
cv.vline(33, 65, 62, 0)
# front face (row 8) and stairs
cv.setpal(4, 16, 6, 2, VIOLET)
for y in range(128, 144):
    for x in range(32, 80):
        cv.px[y, x] = 2
cv.hline(32, 128, 48, 0); cv.hline(32, 129, 48, 1); cv.hline(32, 143, 48, 3)
for x in range(36, 64, 9):
    shade(cv, gothic_arch(x, x + 6, 131, 135) & (yy < 141), base=3, light=None, dark=None, do_outline=False)
cv.vline(32, 128, 16, 3)

def carpet(c, y0, y1, x0=64):
    c.setpal(x0 // 8, y0 // 8, 2, (y1 - y0) // 8, CARPET)
    for y in range(y0, y1):
        for x in range(x0, x0 + 16):
            e = x - x0
            v = 3 if e == 0 else (0 if e == 2 else (2 if e in (1, 3) else 1))
            k = y % 16
            if e >= 6 and abs(k - 8) + (79 - x) < 5:
                v = 2 if abs(k - 8) + (79 - x) < 4 else 0
            c.px[y, x] = v
carpet(cv, 48, 128)
carpet(cv, 128, 144)
for y in range(128, 144, 4):
    cv.hline(65, y + 3, 15, 3)
    cv.hline(66, y, 14, 0)

# ------------------------------------------------------------ black marble hall (rows 9-13, y 144..223)
cv.setpal(0, 18, 10, 10, MARBLE)
for y in range(144, 224, 16):
    for x in range(0, 80, 16):
        light = ((x // 16) + (y // 16)) % 2 == 0
        cv.tex(x, y, 16, 16, MARB_A if light else MARB_B, ox=-x, oy=-y)
# moon medallion inlaid at the centre of the hall
cx, cy = 79.5, 183.5
ring1 = band(emask(S, cx, cy, 44, 36), 2)
ring2 = band(emask(S, cx, cy, 38, 30), 1)
inner = emask(S, cx, cy, 37, 29)
cv.px[emask(S, cx, cy, 44, 36) & left & ~ring1] = 3
cv.px[inner & left] = 2
cv.px[ring1 & left] = 0
cv.px[edge_of(emask(S, cx, cy, 44, 36)) & left] = 3
cv.px[ring2 & left] = 1
# 8 moon phases between the rings
for k in range(8):
    a = (k + 0.5) * np.pi / 4
    px_, py_ = cx + 40.5 * np.cos(a), cy + 32.5 * np.sin(a)
    if px_ > 80:
        continue
    disc = emask(S, px_, py_, 2.6, 2.6)
    cv.px[disc] = 0
# big crescent moon in the middle (silver), mirrored to a full ring so it
# stays symmetric: two crescents back to back form an eclipse-like emblem
full_moon = emask(S, cx, cy, 16, 14)
cv.px[full_moon & left] = 0
cv.px[edge_of(full_moon) & left] = 1
# hand-set craters (left half; the mirror completes the face)
cv.stamp(69, 176, [".11.", "1111", "1111", ".11."])
cv.stamp(74, 188, ["11", "11"])
cv.stamp(67, 186, ["11", "11"])
# halo: one clean ring around the moon
cv.px[edge_of(emask(S, cx, cy, 20, 18)) & left] = 1
stars = [(54, 172), (60, 196), (66, 160), (70, 204)]
for (sx, sy) in stars:
    cv.pset(sx, sy, 0); cv.pset(sx - 1, sy, 1); cv.pset(sx + 1, sy, 1); cv.pset(sx, sy - 1, 1); cv.pset(sx, sy + 1, 1)

cv.setpal(2, 6, 2, 12, MARBLE)
for y in range(48, 144, 16):
    for x in range(16, 32, 16):
        light = ((x // 16) + (y // 16)) % 2 == 0
        cv.tex(x, y, 16, 16, MARB_A if light else MARB_B, ox=-x, oy=-y)
cv.hline(16, 48, 16, 3)
# ------------------------------------------------------------ side galleries (x 0..15): columns + gargoyle niches
def column(c, x0, y0, y1):
    c.setpal(x0 // 8, y0 // 8, 2, (y1 - y0) // 8, VIOLET)
    for y in range(y0, y1):
        for x in range(x0, x0 + 16):
            c.px[y, x] = [3, 1, 0, 0, 1, 2, 3, 0, 0, 1, 1, 2, 3, 1, 2, 3][x - x0]
    shade(c, rmask(S, x0, y0, 16, 6), base=1, light=0, dark=2)
    c.hline(x0 + 1, y0 + 3, 14, 2)
    shade(c, rmask(S, x0, y1 - 8, 16, 8), base=1, light=0, dark=2)
    c.hline(x0 + 1, y1 - 5, 14, 2)
def niche(c, x0, y0, flame=None):
    """16x32 pointed niche holding a brazier of black fire (dark-fire palette)."""
    c.setpal(x0 // 8, y0 // 8, 2, 4, DARKFIRE)
    c.px[rmask(S, x0, y0, 16, 32)] = 2
    shape = gothic_arch(x0 + 1, x0 + 15, y0 + 1, y0 + 9) & (yy < y0 + 31)
    c.px[shape] = 3
    hole = shape & ~edge_of(shape)
    c.hline(x0, y0 + 31, 16, 3)
    # bowl, stem and foot
    bowl = pmask(S, [(x0 + 1, y0 + 16), (x0 + 14, y0 + 16), (x0 + 10, y0 + 20), (x0 + 5, y0 + 20)])
    shade(c, bowl, base=1, light=0, dark=2)
    shade(c, rmask(S, x0 + 6, y0 + 20, 4, 6), base=1, light=0, dark=2)
    shade(c, rmask(S, x0 + 3, y0 + 25, 10, 5), base=1, light=0, dark=2)
    if flame is not None:
        for j in range(flame.shape[0]):
            for i in range(flame.shape[1]):
                v = int(flame[j, i])
                if v != 3 and hole[y0 + 1 + j, x0 + 2 + i]:
                    c.px[y0 + 1 + j, x0 + 2 + i] = v


# black fire: bright violet rim, violet body, near-black heart
DARK_FLAMES = flame_frames(12, 15, 4, seed=5, outer=0, mid=1, core=2, bg=3, height=0.95)


def niche_flame_frames():
    frames = []
    for f in DARK_FLAMES:
        t = Canvas(2, 4)
        t.px[:] = 0
        frames.append(f)
    return frames


column(cv, 0, 48, 96)
niche(cv, 0, 96, DARK_FLAMES[0])
column(cv, 0, 128, 176)
niche(cv, 0, 176, DARK_FLAMES[0])
cv.setpal(0, 26, 2, 2, VIOLET)
column(cv, 0, 208, 224)
cv.setpal(0, 16, 2, 2, VIOLET)
for y in range(128, 144):
    pass

# candelabra in the hall at step 1 rows 9-10 (x 16..31, y 144..175)
def candelabra(c, x0, y0):
    c.setpal(x0 // 8, y0 // 8, 2, 4, GILT)
    for y in range(y0, y0 + 32):
        for x in range(x0, x0 + 16):
            c.px[y, x] = 3 if (y % 16 == 15 or x % 16 == 15) else 2
    c.stamp(x0, y0 + 2, CAND)


candelabra(cv, 16, 144)

# ------------------------------------------------------------ dividing wall + iron gate (rows 14-15)
cv.setpal(0, 28, 10, 4, VIOLET)
for y in range(224, 256):
    for x in range(0, 80):
        r = (y - 224) % 8
        cv.px[y, x] = 1
        if r == 0:
            cv.px[y, x] = 2
        elif r == 1:
            cv.px[y, x] = 0
        elif ((x + (8 if ((y - 224) // 8) % 2 else 0)) % 16) == 0:
            cv.px[y, x] = 2
cv.hline(0, 224, 80, 3)
cv.rect(0, 225, 80, 2, 0)
cv.hline(0, 227, 80, 2)
for nx in (24, 44):
    hole = gothic_arch(nx + 2, nx + 10, 231, 238) & (yy < 252)
    cv.px[hole] = 3
    cv.px[edge_of(gothic_arch(nx, nx + 12, 229, 238) & (yy < 253))] = 2
def draw_gate(c, closed=False):
    c.setpal(8, 28, 2, 4, VIOLET)
    arch = gothic_arch(64, 96, 232, 240)
    c.px[rmask(S, 64, 224, 16, 32) & ~arch] = 1
    for y in range(224, 256):
        for x in range(64, 80):
            if not arch[y, x] and (y - 224) % 8 == 0:
                c.px[y, x] = 2
    c.hline(64, 224, 16, 3)
    c.px[edge_of(gothic_arch(62, 98, 230, 240)) & (xx < 80) & (xx >= 64) & (yy > 230)] = 3
    c.px[arch & (xx < 80)] = 3
    c.prio[28, 8:12] = not closed   # arch top drawn over the player
    if not closed:
        c.setpal(8, 30, 2, 2, CARPET)
        for y in range(240, 256):
            for x in range(64, 80):
                e = x - 64
                c.px[y, x] = 3 if e == 0 else (0 if e == 2 else (2 if e in (1, 3) else 1))
        return
    for x in range(67, 80, 4):
        c.vline(x, 233, 23, 0)
        c.vline(x + 1, 233, 23, 2)
        c.pset(x, 232, 0)
    for y in (238, 249):
        c.hline(64, y, 16, 0)
        c.hline(64, y + 1, 16, 2)
draw_gate(cv)

# ------------------------------------------------------------ antechamber (rows 16-17)
cv.setpal(0, 32, 10, 4, MARBLE)
for y in range(256, 288, 16):
    for x in range(0, 80, 16):
        light = ((x // 16) + (y // 16)) % 2 == 0
        cv.tex(x, y, 16, 16, MARB_A if light else MARB_B, ox=-x, oy=-y)
cv.hline(0, 256, 80, 3)
carpet(cv, 256, 288)
niche(cv, 32, 256, DARK_FLAMES[0])
column(cv, 0, 256, 288)
cv.setpal(2, 32, 2, 4, MARBLE)
cv.rect(16, 256, 16, 32, 3)
for y in range(256, 288):
    for x in range(16, 32):
        if (x + y) % 2 == 0 and x > 20:
            cv.px[y, x] = 2

# ------------------------------------------------------------ symmetry + collision
cv.mirror_x(0, 160); cv.mirror_pal_x()
# there is only one moon: the right-hand window shows plain night sky there
cv.px[:48, 128:160][MOON[:48, :32][:, ::-1]] = 2
for (sx, sy) in [(20, 8), (21, 13)]:
    cv.pset(159 - sx, sy, 0)
# ...and no cat on its sill
cv.px[32:41, 128:160] = WINDOW_NO_CAT[32:41, ::-1]
cv.walk(3, 3, 4, 1)            # arch mouth
cv.walk(2, 4, 6, 4)            # dais
cv.walk(4, 8, 2, 1)            # stairs
cv.walk(1, 9, 8, 5)            # hall
cv.walk(1, 9, 1, 2, 'WALL'); cv.walk(8, 9, 1, 2, 'WALL')    # candelabra
cv.walk(4, 14, 2, 2)
cv.walk(3, 16, 4, 1)
cv.walk(4, 17, 2, 1, 'WARP_CARPET_DOWN')

door_open = cv.copy(); draw_door(door_open, open_=True); door_open.mirror_all()
door_open.walk(4, 2, 2, 1, 'LADDER')
gate_closed = cv.copy(); draw_gate(gate_closed, closed=True); gate_closed.mirror_all()
gate_closed.walk(4, 14, 2, 2, 'WALL')

border = Canvas(4, 4)
border.setpal(0, 0, 4, 4, WALL)
border.rect(0, 0, 32, 32, 3)

# ------------------------------------------------------------ animation frames
SMALL_FLAMES = [
    [".1.", "111", "101", "101", ".1."],
    ["1..", "11.", "101", "101", ".1."],
    ["...", ".1.", "111", "101", ".1."],
    ["..1", ".11", "101", "101", ".1."],
]


def candle_strip(canvas, x0, y0, cols, frow, k, bg):
    """16x8 strip at (x0, y0) with flames (3x5) at the given columns,
    starting at strip row frow; each candle uses its own flicker phase."""
    a = cell(canvas, x0 // 8, y0 // 8)
    b = cell(canvas, x0 // 8 + 1, y0 // 8)
    strip = np.concatenate([a, b], axis=1)
    for n, cx_ in enumerate(cols):
        for j in range(5):
            for i in range(3):
                if 0 <= cx_ + i < 16:
                    strip[frow + j, cx_ + i] = bg[j][cx_ + i] if isinstance(bg, list) else bg
        pat = SMALL_FLAMES[(k + n) % 4]
        for j, row in enumerate(pat):
            for i, ch in enumerate(row):
                if ch != '.' and 0 <= cx_ + i < 16:
                    strip[frow + j, cx_ + i] = int(ch)
    return strip


def bg_rows(canvas, x0, y0, frow):
    """background colours behind a flame row (seams kept)."""
    rows = []
    for j in range(5):
        r = []
        for i in range(16):
            x, y = x0 + i, y0 + frow + j
            r.append(3 if (y % 16 == 15 or x % 16 == 15) else 2)
        rows.append(r)
    return rows


# candelabra (x 16..31, flames on y 146..150 = tile row 144..151)
CANDLE_FRAMES = [candle_strip(cv, 16, 144, [2, 7, 12], 2, k, bg_rows(cv, 16, 144, 2)) for k in range(4)]
# chandelier (x 64..79, flames on y 8..12 = tile row 8..15), recess background 3
CHAN_FRAMES = [candle_strip(cv, 64, 8, [2, 8, 14], 0, k, 3) for k in range(4)]


def put_strip(canvas, x0, y0, strip):
    """show the first animation frame on the canvas (and its mirror image)."""
    h, w = strip.shape
    canvas.px[y0:y0 + h, x0:x0 + w] = strip
    canvas.px[y0:y0 + h, 160 - x0 - w:160 - x0] = strip[:, ::-1]


put_strip(cv, 16, 144, CANDLE_FRAMES[0])
put_strip(cv, 64, 8, CHAN_FRAMES[0])

# dark-fire braziers: the niche's top two tile rows
def niche_frames():
    out = []
    for f in DARK_FLAMES:
        t = cv.copy()
        niche(t, 0, 96, f)
        out.append(t.px[96:112, 0:16].copy())
    return out


NICHE = niche_frames()

# Bats: each bat flies left to right through the left window, then (after a
# moment behind the wall) through the right window, then back into the left
# one - it is never in both windows at once. One loop is 128 steps of 8
# frames (about 17 s). Bats are only drawn on the glass inside the light
# frame ring (x 8..23), so they slip in and out from behind the frame.
BAT_STEPS = 128
BAT_RIGHT_AT = 64        # travel distance at which a bat enters the right window
FLAP = ['glide', 'up', 'glide', 'down']
BAT_GLASS = np.zeros((16, 32), bool)
BAT_GLASS[:, 8:24] = win[16:32, 8:24] & (WINDOW_BARE[16:32, 8:24] != 3)
BAND_LEFT = WINDOW_BARE[16:32, 0:32].copy()
BAND_RIGHT = BAND_LEFT[:, ::-1].copy()


def bat_band(step, side):
    a = (BAND_LEFT if side == 'L' else BAND_RIGHT).copy()
    for (home, spr, bob) in ((BIG_HOME, BIG_BAT, (0, 0, -1, -1, 0, 0, 1, 1)), (SMALL_HOME, SMALL_BAT, (0, 0, 0, 1, 1, 1, 0, 0))):
        p = (step + home[0] + 7) % BAT_STEPS          # distance travelled since entering the left window
        if side == 'L':
            x = p - 7
        else:
            x = p - BAT_RIGHT_AT - 7
        if not -12 < x < 32:
            continue
        y = home[1] - 16 + bob[(step // 4) % 8]
        rows = spr[FLAP[(step // 2) % 4] if step % BAT_STEPS else 'glide']
        for j, row in enumerate(rows):
            for i, ch in enumerate(row):
                px_, py_ = x + i, y + j
                if ch == '3' and 0 <= px_ < 32 and 0 <= py_ < 16 and BAT_GLASS[py_, px_]:
                    a[py_, px_] = 3
    return a


BANDS = {side: [bat_band(st, side) for st in range(BAT_STEPS)] for side in 'LR'}
assert (BANDS['R'][0] == BAND_RIGHT).all()       # no bats in the right window at first
cv.px[16:32, 0:32] = BANDS['L'][0]
cv.px[16:32, 128:160] = BANDS['R'][0]


def bat_tile_anim(side, tx, ty):
    frames, seq = [], []
    for band in BANDS[side]:
        t = band[(ty - 2) * 8:(ty - 2) * 8 + 8, tx * 8:tx * 8 + 8]
        for i, f in enumerate(frames):
            if (f == t).all():
                seq.append(i)
                break
        else:
            frames.append(t.copy())
            seq.append(len(frames) - 1)
    col = tx if side == 'L' else 16 + tx
    return dict(name='Bats%s%d%d' % (side, tx, ty), cells=[(col, ty)], frames=frames, seq=seq, shift=3)


ANIMS = (
    [bat_tile_anim(side, tx, ty) for side in 'LR' for ty in (2, 3) for tx in (1, 2)] + [
     dict(name='CandlesL', cell=(2, 18), frames=[f[:, 0:8] for f in CANDLE_FRAMES], seq=[0, 1, 2, 3], shift=2),
     dict(name='CandlesR', cell=(3, 18), frames=[f[:, 8:16] for f in CANDLE_FRAMES], seq=[0, 1, 2, 3], shift=2),
     dict(name='ChandelierL', cell=(8, 1), frames=[f[:, 0:8] for f in CHAN_FRAMES], seq=[0, 1, 2, 3], shift=2),
     dict(name='ChandelierR', cell=(9, 1), frames=[f[:, 8:16] for f in CHAN_FRAMES], seq=[0, 1, 2, 3], shift=2)]
    + [dict(name='DarkFire%d' % i, cell=(i % 2, 12 + i // 2),
            frames=[f[(i // 2) * 8:(i // 2) * 8 + 8, (i % 2) * 8:(i % 2) * 8 + 8] for f in NICHE],
            seq=[0, 1, 2, 3], shift=2) for i in range(4)])

if __name__ == '__main__':
    build_room('karens_room', 'KarensRoom', cv, PALS, border,
               {'door_open': (door_open, 2, 1), 'gate_closed': (gate_closed, 2, 7)},
               out_preview=OUT + 'karen_preview.png', anims=ANIMS, pal_anims=[(DARKFIRE, 'PULSE')])
    preview(cv, PALS, OUT + 'karen_coll.png', coll=True)

"""BRUNO - Mountain Temple."""
import numpy as np
from e4kit import *

PALS = [
    [W2, (27, 23, 14), (21, 16, 7), K2],                 # 0 sandstone floor / arena / dais
    [(26, 24, 17), (21, 17, 7), (16, 13, 3), K2],        # 1 boulder cliff (Gen 2 cave brown)
    [W2, (15, 16, 31), (9, 9, 31), K2],                  # 2 water (Gen 2 water blue)
    [(24, 28, 12), (15, 20, 1), (16, 13, 3), K2],        # 3 mossy rock
    [W2, (31, 31, 7), (31, 16, 1), K2],                  # 4 fire (flicker)
    [W2, (28, 26, 14), (21, 17, 7), K2],                 # 5 straw rope
    [W2, (19, 19, 19), (13, 13, 13), K2],                # 6 carved granite
]
SAND, ROCK, WATER, MOSS, FIRE, STRAW, GRANITE = range(7)
W, H = 20, 36
cv = Canvas(W, H)
S = full(cv)

ROCKTEX = lump_pattern([(5, 4, 5.8, 4.4), (16, 3, 4.6, 3.6), (26, 5, 5.6, 4.6), (0, 12, 4.2, 3.8), (10, 12.5, 5.6, 4.2), (21, 12, 4.4, 4.2), (30, 13, 3.4, 3.2)], w=32)
ROCKTEX2 = ROCKTEX
SANDTEX = [
    "1111111111111111",
    "1111111111111111",
    "1101111111111111",
    "1122111111111111",
    "1111111111111111",
    "1111111111011111",
    "1111111111221111",
    "1111111111111111",
    "1111111111111111",
    "1111101111111111",
    "1111122111111111",
    "1111111111111111",
    "1111111111111101",
    "1111111111111122",
    "1111111111111111",
    "1111111111111111",
]
FLAG = [  # 16x16 dressed flagstones for the dais
    "0000000000000002",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111211112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0112111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "2222222222222222",
]
FLAG2 = [r[8:] + r[:8] for r in FLAG]

# ------------------------------------------------------------ cliff (rows 0-2) and left rock edges
cv.setpal(0, 0, 10, 6, ROCK)
cv.tex(0, 0, 80, 48, ROCKTEX)

# ------------------------------------------------------------ waterfall left corner (cells 0..3, y 0..111)
cv.setpal(1, 1, 2, 9, WATER)
# both waterfall columns use the dark falling-water tile (Polished Crystal)
WF_FRAMES = [waterfall_frame(k)[:, 0:8] for k in range(4)]
for y in range(8, 80):
    cv.px[y, 8:16] = WF_FRAMES[0][y % 8]
    cv.px[y, 16:24] = WF_FRAMES[0][y % 8]
# rock lip above the fall
cv.setpal(0, 0, 4, 1, ROCK)
# (kept inside the top tile row so every water tile below it is animated)
shade(cv, pmask(S, [(4, 0), (27, 0), (27, 4), (24, 7), (7, 7), (4, 4)]), base=1, light=0, dark=2)
# pool (cells 0..3, y 80..103)
cv.setpal(0, 10, 4, 3, WATER)
cv.setpal(3, 10, 1, 3, ROCK)
cv.tex(24, 80, 8, 24, ROCKTEX)
POOLTEX = [
    "1111111111111111",
    "1111111111111111",
    "1211112111111111",
    "1122221111111111",
    "1111111111111111",
    "1111111111101111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111112111121",
    "1111111111222211",
    "1111111111111111",
    "1101111111111111",
    "1111111111111111",
    "1111111111111111",
]
cv.tex(0, 80, 24, 24, POOLTEX)
for y in range(80, 104):
    cv.px[y, 23] = 3
# foam where the fall hits the pool
def pool_strip(y0):
    a = np.zeros((8, 16), np.uint8)
    for j in range(8):
        for i in range(16):
            a[j, i] = int(POOLTEX[(y0 + j) % 16][(8 + i) % 16])
    return a


def splash_frame(k):
    """churning white water where the fall lands (16x8 under the falls)."""
    a = pool_strip(80)
    for x in range(16):
        fh = 3 + int(round(1.4 * np.sin(x * 1.1 + k * 1.57) + 0.6 * np.sin(x * 2.3 - k * 3.14)))
        for y in range(8):
            if y < fh:
                a[y, x] = 0 if (x + y + k) % 3 else 1
            elif y == fh and (x + k) % 2 == 0:
                a[y, x] = 1
    rng = np.random.RandomState(k + 7)
    for _ in range(3):
        x, y = rng.randint(0, 16), rng.randint(5, 8)
        a[y, x] = 0
    return a


def ripple_frame(k):
    """rings spreading from the impact (16x8 below the splash)."""
    a = pool_strip(88)
    for y in range(8):
        for x in range(16):
            for r in (2.5 + 2.5 * k, 2.5 + 2.5 * ((k + 2) % 4)):
                d = ((x - 7.5) / (r * 1.3)) ** 2 + ((y + 1.5) / r) ** 2
                if abs(d - 1) < 0.18 and r < 10:
                    a[y, x] = 0 if r < 7 else 2
    return a


SPLASH = [splash_frame(k) for k in range(4)]
RIPPLE = [ripple_frame(k) for k in range(4)]
cv.px[80:88, 8:24] = SPLASH[0]
cv.px[88:96, 8:24] = RIPPLE[0]
cv.stamp(0, 80, ["10100101", "01..10.1", ".1...1.."])
# rocky rim below the pool
cv.setpal(0, 13, 4, 1, ROCK)
for x in range(0, 32):
    for y in range(104, 112):
        cv.px[y, x] = 1
    cv.px[104, x] = 0
    cv.px[105, x] = 0 if x % 4 else 1
    cv.px[110, x] = 2
    cv.px[111, x] = 3
    if x % 8 == 7:
        cv.vline(x, 106, 4, 3)
        cv.vline(x - 1, 106, 4, 2)
# rock column at x 0..7 beside the falls and cliff x 24..31 down to the pool
cv.setpal(0, 1, 1, 9, ROCK)
cv.tex(0, 8, 8, 72, ROCKTEX)
cv.setpal(3, 6, 1, 4, ROCK)
cv.tex(24, 48, 8, 32, ROCKTEX)
# rubble with moss (rows 7-8, y 112..143) under the pool
cv.setpal(0, 14, 4, 4, ROCK)
cv.tex(0, 112, 32, 32, ROCKTEX)
# moss creeping over the rocks at the pool's foot
cv.setpal(0, 14, 3, 1, MOSS)
cv.setpal(0, 15, 1, 1, MOSS)
for y in range(112, 128):
    for x in range(0, 24):
        if y >= 120 and x >= 8:
            continue
        v = cv.px[y, x]
        moss = ((x * 5 + y * 3) % 7 < 3) and (y - 112) < 10 - (x % 8) // 2 + (3 if x < 8 else 0)
        cv.px[y, x] = (0 if (x + y) % 3 == 0 else 1) if moss and v != 3 else (2 if v in (0, 1, 2) else 3)

# ------------------------------------------------------------ carved temple facade around the door (x 48..111, y 0..47)
cv.setpal(6, 0, 4, 6, GRANITE)
# side columns x 48..63
shade(cv, rmask(S, 49, 6, 14, 42), base=1, light=0, dark=2)
for y in range(12, 46, 9):
    cv.hline(50, y, 12, 2)
    cv.hline(50, y + 1, 12, 0)
shade(cv, rmask(S, 48, 0, 16, 7), base=2, light=1, dark=3)
# lintel x 48..79 y 6..15 (mirrored later)
shade(cv, rmask(S, 48, 6, 32, 10), base=1, light=0, dark=2)
cv.hline(52, 10, 28, 2)
cv.hline(52, 11, 28, 0)
# archway recess above the door y 16..31
cv.rect(64, 16, 16, 16, 3)
for y in range(16, 32):
    for x in range(64, 80):
        if (x + y) % 2 == 0 and y < 22:
            cv.px[y, x] = 2
cv.vline(64, 16, 16, 2)
# shimenawa rope across the lintel (straw palette cells x 56..79, y 8..23)
cv.setpal(7, 1, 3, 2, STRAW)
for x in range(56, 80):
    for y in range(8, 24):
        cv.px[y, x] = cv.px[y, x]  # keep geometry, recolour below
# redraw that region in straw palette: background lintel / recess approximated with straw darks
for y in range(8, 24):
    for x in range(56, 80):
        v = cv.px[y, x]
        cv.px[y, x] = 3 if v == 3 else (2 if v in (2, 1) else 1)
rope = emask(S, 80, 4, 30, 14) & ~emask(S, 80, 4, 30, 9) & rmask(S, 56, 8, 24, 12)
for y in range(8, 24):
    for x in range(56, 80):
        if rope[y, x]:
            cv.px[y, x] = 0 if (x + y) % 4 in (0, 1) else (1 if (x + y) % 4 == 2 else 2)
# outline of rope
ro = edge_of(rope)
cv.px[ro & rmask(S, 56, 8, 24, 16)] = 3
# shide paper zigzags hanging from the rope
SHIDE = ["0303", "3003", ".300", ".303", "3003", "300.", ".33."]
cv.setpal(9, 2, 1, 2, STRAW)
cv.stamp(73, 17, SHIDE)
cv.setpal(7, 2, 1, 2, STRAW)
cv.stamp(59, 15, SHIDE)
# carved plaque left of door (fist relief) - column face carving
FIST = [
    ".3333.",
    "300003",
    "301103",
    "300003",
    "311113",
    ".3333.",
]

# door rows 4-5 (y 32..47)
def draw_door(c, open_=False):
    c.setpal(8, 4, 2, 2, GRANITE)
    if open_:
        c.rect(64, 32, 16, 16, 3)
        for y in range(32, 48):
            for x in range(64, 80):
                if (x + y) % 2 == 0 and y > 41:
                    c.px[y, x] = 2
        c.vline(64, 32, 16, 2)
        return
    # sealed stone slab with a carved ring
    shade(c, rmask(S, 64, 32, 16, 16), base=1, light=0, dark=2)
    c.vline(79, 32, 16, 3)
    ring = band(emask(S, 80, 40, 10, 7), 3)
    c.px[ring & rmask(S, 64, 32, 16, 16)] = 2
    c.px[shift(ring, 0, 1) & rmask(S, 64, 32, 16, 16) & ~ring] = 0
draw_door(cv)

# ------------------------------------------------------------ giant cracked pillars (x 32..47, y 40..143)
def pillar(c):
    c.setpal(4, 5, 2, 13, GRANITE)
    c.setpal(4, 0, 2, 5, ROCK)
    # shaft
    for y in range(52, 132):
        for x in range(33, 47):
            k = x - 33
            c.px[y, x] = [3, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 3][k]
        if y % 18 == 0:
            c.hline(34, y, 12, 2); c.hline(34, y + 1, 12, 0)
    # capital
    shade(c, rmask(S, 32, 40, 16, 12), base=1, light=0, dark=2)
    c.hline(33, 45, 14, 2); c.hline(33, 46, 14, 0)
    # base
    shade(c, rmask(S, 32, 130, 16, 14), base=1, light=0, dark=2)
    c.hline(33, 135, 14, 2); c.hline(33, 136, 14, 0)
    # cracks
    crack = [(40, 52), (39, 55), (41, 58), (40, 61), (38, 64), (39, 67), (37, 70), (38, 73),
             (42, 92), (43, 95), (41, 98), (42, 101), (44, 104), (43, 107),
             (36, 112), (37, 115), (35, 118)]
    for i in range(len(crack) - 1):
        (x0, y0), (x1, y1) = crack[i], crack[i + 1]
        if abs(y1 - y0) > 4:
            continue
        for t in range(0, 4):
            xx = round(x0 + (x1 - x0) * t / 3); yy = round(y0 + (y1 - y0) * t / 3)
            c.pset(xx, yy, 3)
            if c.px[yy, xx + 1] != 3:
                c.pset(xx + 1, yy, 0)
    # chipped chunk out of the capital
    c.rect(43, 40, 4, 3, 3)
    c.pset(42, 41, 2)
pillar(cv)

# ------------------------------------------------------------ dais (rows 3-7, x 48..111) + face row 8
cv.setpal(6, 6, 4, 10, SAND)
for y in range(48, 128, 16):
    cv.tex(48, y, 32, 16, FLAG if (y // 16) % 2 else FLAG2, oy=-y)
cv.hline(48, 48, 32, 3)
for x in range(48, 80, 2):
    cv.pset(x, 49, 2)
# front face of the dais (y 128..143) and central steps
cv.setpal(6, 16, 4, 2, SAND)
for y in range(128, 144):
    for x in range(48, 80):
        cv.px[y, x] = 2 if (y - 128) % 8 else 0
        if (x - 48) % 16 == 15 and (y - 128) % 8:
            cv.px[y, x] = 3
cv.hline(48, 143, 32, 3)
cv.hline(48, 128, 32, 0)
for i, y in enumerate(range(128, 144, 4)):
    cv.rect(64, y, 16, 4, 1)
    cv.hline(64, y, 16, 0)
    cv.hline(64, y + 3, 16, 3)
cv.vline(64, 128, 16, 3)
# stone weights (chikara-ishi) beside Bruno's spot, on the dais
def weight(c, x, y):
    m = emask(S, x + 5.5, y + 5, 6, 5)
    shade(c, m, base=1, light=0, dark=2)
    c.pset(x + 3, y + 2, 0)
weight(cv, 50, 66)
weight(cv, 52, 72)

# ------------------------------------------------------------ arena floor rows 9-13 (y 144..223)
cv.setpal(0, 18, 10, 10, SAND)
cv.tex(0, 144, 80, 80, SANDTEX)
cx, cy = 79.5, 183.5
outer = emask(S, cx, cy, 62, 39)
ringb = band(outer, 5)
inner = outer & ~ringb
# carved ring of fitted stones
yy, xx = np.mgrid[0:S[0], 0:S[1]]
ang = np.arctan2((yy - cy) * 1.6, xx - cx)
seg = ((ang + np.pi) / (2 * np.pi) * 28).astype(int)
cv.px[ringb] = 0
# one-pixel joints: compare across the ring's direction of travel only
topbot = abs((yy - cy) * 1.6) > abs(xx - cx)
segedge = ringb & np.where(topbot, seg != shift(seg, 1, 0), seg != shift(seg, 0, 1))
cv.px[segedge] = 3
cv.px[edge_of(outer)] = 3
cv.px[shift(edge_of(outer), 0, -1) & ringb] = 0
cv.px[shift(edge_of(outer), 0, 1) & ringb] = 0
cv.px[edge_of(inner) & ~edge_of(outer)] = 2
# inner packed floor: lighter with concentric carved lines
cv.px[inner & ~edge_of(inner)] = 1
for r in (24, 12):
    e = edge_of(emask(S, cx, cy, r * 1.6, r))
    cv.px[e & inner] = 2
    cv.px[shift(e, 0, 1) & inner & ~e] = 0
# cross-shaped carved sigil in the centre
cv.px[rmask(S, 76, 176, 8, 16)] = 1
cv.px[rmask(S, 72, 180, 16, 8)] = 1
cv.px[rmask(S, 78, 178, 4, 12)] = 2
cv.px[rmask(S, 74, 182, 12, 4)] = 2
# enforce vertical symmetry of the arena so its quadrants share tiles
cv.px[184:224, 0:80] = cv.px[143:183, 0:80][::-1]
cv.px[184:224, 0:80] = cv.px[144:184, 0:80][::-1]

# left wall rock x 0..15 rows 9-13 with jagged inner edge
cv.setpal(0, 18, 2, 10, ROCK)
cv.tex(0, 144, 16, 80, ROCKTEX)
for (tx, ty) in [(2, 18), (2, 19), (3, 18), (2, 26), (2, 27), (3, 27)]:
    cv.setpal(tx, ty, 1, 1, ROCK)
    cv.tex(tx * 8, ty * 8, 8, 8, ROCKTEX)
# outline where rock meets the floor (drawn on the sand side as shadow)
for y in range(144, 224):
    for x in range(16, 40):
        if cv.pal[y // 8, x // 8] == SAND and cv.pal[y // 8, (x - 1) // 8] == ROCK and x % 8 == 0:
            cv.px[y, x] = 3; cv.px[y, x + 1] = 2 if y % 2 else cv.px[y, x + 1]
        if cv.pal[y // 8, x // 8] == SAND and y % 8 == 0 and cv.pal[(y - 1) // 8, x // 8] == ROCK:
            cv.px[y, x] = 3
            if (x + y) % 2: cv.px[y + 1, x] = 2
# boulders and training posts in the arena corners
def boulder(c, x, y, w=14, h=11):
    m = emask(S, x + w / 2, y + h / 2, w / 2, h / 2)
    shade(c, m, base=1, light=0, dark=2)
    c.pset(x + w // 2 + 1, y + h // 2 + 1, 3)
    c.pset(x + w // 2 + 2, y + h // 2, 3)
    c.hline(x + 1, y + h, w - 2, 2)
boulder(cv, 17, 162, 13, 11)
boulder(cv, 30, 150, 9, 7)
def post(c, x, y):
    # wooden makiwara post wrapped in rope, drawn in sandstone shades
    c.rect(x + 3, y, 6, 26, 2)
    c.vline(x + 3, y, 26, 3); c.vline(x + 8, y, 26, 3)
    c.vline(x + 4, y, 26, 1)
    for yy in range(y + 6, y + 14, 2):
        c.hline(x + 3, yy, 6, 0)
        c.hline(x + 3, yy + 1, 6, 1)
    c.hline(x + 3, y, 6, 3)
    c.rect(x + 1, y + 25, 10, 3, 3)
    c.hline(x + 2, y + 25, 8, 1)
post(cv, 18, 188)
weight(cv, 30, 208)

# ------------------------------------------------------------ dividing rock wall with tunnel (rows 14-15, y 224..255)
cv.setpal(0, 28, 10, 4, ROCK)
cv.tex(0, 224, 80, 32, ROCKTEX)
# top edge of the ridge (lit)
for x in range(0, 80):
    cv.px[224, x] = 3
    cv.px[225, x] = 0 if x % 3 else 1
def draw_gate(c, closed=False):
    c.setpal(8, 28, 2, 4, ROCK)
    c.tex(64, 224, 16, 32, ROCKTEX)
    for x in range(64, 80):
        c.px[224, x] = 3
        c.px[225, x] = 0 if x % 3 else 1
    c.prio[28, 8:12] = not closed   # rock overhang drawn over the player
    if not closed:
        # tunnel opening showing sand floor, under a solid rock overhang
        c.hline(64, 231, 16, 3)
        c.setpal(8, 29, 2, 3, SAND)
        c.tex(64, 232, 16, 24, SANDTEX)
        c.rect(64, 232, 16, 3, 3)
        for y in range(232, 256):
            c.px[y, 64] = 3
            c.px[y, 65] = 2
        for x in range(64, 80):
            c.px[235, x] = 2 if x % 2 else 3
        return
    # rolled boulder sealing the tunnel
    c.setpal(8, 28, 2, 4, ROCK)
    m = emask(S, 80, 241, 15, 15)
    c.px[rmask(S, 64, 226, 16, 30) & ~m] = 3
    shade(c, m, base=1, light=0, dark=2, hl=2)
    for (px_, py_) in [(72, 236), (74, 237), (75, 239), (70, 246), (71, 248)]:
        c.pset(px_, py_, 3)
draw_gate(cv)

# ------------------------------------------------------------ antechamber rows 16-17 (y 256..287)
cv.setpal(0, 32, 10, 4, ROCK)
cv.tex(0, 256, 80, 32, ROCKTEX2)
cv.setpal(6, 32, 4, 4, SAND)
cv.tex(48, 256, 32, 32, SANDTEX)
cv.hline(48, 256, 32, 3)
for x in range(48, 80, 2):
    cv.pset(x, 257, 2)
cv.vline(48, 256, 32, 3)
# fire bowl on a stone stand at step (3, 16)
FLAMES = flame_frames(16, 16, 4, seed=3, height=0.9)


def brazier(c, x, y):
    c.setpal(x // 8, y // 8, 2, 2, FIRE)
    c.setpal(x // 8, y // 8 + 2, 2, 2, SAND)
    # flame (fire palette, upper cells)
    c.px[y:y + 16, x:x + 16] = FLAMES[0]
    # bowl & stand (sand palette, lower cells)
    shade(c, rmask(S, x, y + 16, 16, 5), base=1, light=0, dark=2)
    c.rect(x, y + 16, 16, 1, 3)
    c.rect(x + 1, y + 17, 14, 1, 2)
    shade(c, rmask(S, x + 5, y + 21, 6, 8), base=1, light=0, dark=2)
    shade(c, rmask(S, x + 2, y + 28, 12, 4), base=1, light=0, dark=2)
brazier(cv, 48, 256)
# corner moss tufts at the arena-side rock edge
for (mx, my) in [(8, 150), (10, 196)]:
    pass

# ------------------------------------------------------------ symmetry
cv.mirror_x(0, 160); cv.mirror_pal_x()

# ------------------------------------------------------------ collision
cv.walk(3, 3, 4, 5)           # dais
cv.walk(4, 8, 2, 1)           # steps
cv.walk(1, 9, 8, 5)           # arena
cv.walk(1, 9, 1, 1, 'WALL'); cv.walk(8, 9, 1, 1, 'WALL')     # boulders
cv.walk(1, 12, 1, 2, 'WALL'); cv.walk(8, 12, 1, 2, 'WALL')   # posts + weights
cv.walk(3, 4, 1, 1, 'WALL'); cv.walk(6, 4, 1, 1, 'WALL')     # weights on dais
cv.walk(4, 14, 2, 2)
cv.walk(4, 16, 2, 1)
cv.walk(4, 17, 2, 1, 'WARP_CARPET_DOWN')

door_open = cv.copy(); draw_door(door_open, open_=True); door_open.mirror_all()
door_open.walk(4, 2, 2, 1, 'LADDER')
gate_closed = cv.copy(); draw_gate(gate_closed, closed=True); gate_closed.mirror_all()
gate_closed.walk(4, 14, 2, 2, 'WALL')

border = Canvas(4, 4)
border.setpal(0, 0, 4, 4, ROCK)
border.tex(0, 0, 32, 32, ROCKTEX)

def quads(frames):
    return [[f[0:8, 0:8] for f in frames], [f[0:8, 8:16] for f in frames],
            [f[8:16, 0:8] for f in frames], [f[8:16, 8:16] for f in frames]]


FQ = quads(FLAMES)
ANIMS = [
    dict(name='Waterfall', cell=(1, 2), frames=WF_FRAMES, seq=[0, 1, 2, 3], shift=3),
    dict(name='SplashL', cell=(1, 10), frames=[f[:, 0:8] for f in SPLASH], seq=[0, 1, 2, 3], shift=3),
    dict(name='SplashR', cell=(2, 10), frames=[f[:, 8:16] for f in SPLASH], seq=[0, 1, 2, 3], shift=3),
    dict(name='RippleL', cell=(1, 11), frames=[f[:, 0:8] for f in RIPPLE], seq=[0, 1, 2, 3], shift=3),
    dict(name='RippleR', cell=(2, 11), frames=[f[:, 8:16] for f in RIPPLE], seq=[0, 1, 2, 3], shift=3),
] + [dict(name='Fire%d' % i, cell=(6 + i % 2, 32 + i // 2), frames=FQ[i], seq=[0, 1, 2, 3], shift=2)
     for i in range(4)]

if __name__ == '__main__':
    build_room('brunos_room', 'BrunosRoom', cv, PALS, border,
               {'door_open': (door_open, 2, 1), 'gate_closed': (gate_closed, 2, 7)},
               anims=ANIMS, pal_anims=[(FIRE, 'FLICKER')],
               out_preview=OUT + 'bruno_preview.png')
    preview(cv, PALS, OUT + 'bruno_coll.png', coll=True)
    preview(door_open, PALS, OUT + 'bruno_open.png')
    preview(gate_closed, PALS, OUT + 'bruno_closed.png')

"""LORELEI - Frozen Palace."""
import numpy as np
from e4kit import *

PALS = [
    [W2, (20, 28, 31), (10, 20, 30), K2],    # 0 Ice Path ice floor
    [W2, (16, 26, 31), (7, 14, 28), K2],     # 1 crystals
    [W2, (13, 21, 31), (6, 11, 27), K2],     # 2 frozen pools (deep ice blue)
    [W2, (18, 21, 25), (11, 13, 18), K2],    # 3 slate ice-brick walls / pillars
    [W2, (19, 19, 19), (13, 13, 13), K2],    # 4 stone dais (Gen 2 gray)
    [W2, (26, 28, 31), (17, 20, 27), K2],    # 5 snow
    [W2, (21, 12, 29), (12, 5, 20), K2],     # 6 violet carpet / door arch
]
ICE, CRYS, POOL, BRICK, DAIS, SNOW, AUR = range(7)
W, H = 20, 36
cv = Canvas(W, H)
S = full(cv)
yy, xx = np.mgrid[0:S[0], 0:S[1]]
left = xx < 80

ICEBRICK = [
    "0000000000000003",
    "0111111111111123",
    "0111111111111123",
    "0112111111111123",
    "0111111111111123",
    "0222222222222223",
    "3333333333333333",
    "0000000300000000",
    "1111112301111111",
    "1111112301111111",
    "1111112301111211",
    "1111112301111111",
    "2222222302222222",
    "3333333333333333",
    "0000000000000003",
    "0111111111111123",
]
ICEFLOOR = [
    "0000000000000001",
    "0111111111111112",
    "0100111111111112",
    "0101111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111001112",
    "0111111111011112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "0111111111111112",
    "1222222222222222",
]


def crystal(c, x, ybase, w, h, lean=0):
    """Hexagonal ice-crystal prism with a pointed tip (palette CRYS)."""
    # straight prism with an evenly stepped 1:2 point
    hw = w // 2
    tip = (x + hw, ybase - h)
    body = pmask(S, [(x, ybase), (x, ybase - h + 2 * hw), tip, (x + 2 * hw, ybase - h + 2 * hw), (x + 2 * hw, ybase)])
    w = 2 * hw
    lean = 0
    c.px[body] = 1
    mid = x + w / 2 + lean * 0.4
    rightf = body & (xx > mid)
    c.px[rightf] = 2
    c.px[body & (xx > x + w - 2)] = 2
    hl = body & (abs(xx - (x + w * 0.3)) < 0.8) & (yy < ybase - 2) & (yy > ybase - h + w * 0.7 + 2)
    c.px[hl] = 0
    c.px[edge_of(body)] = 3
    c.pset(int(x + w * 0.3), ybase - h + int(w * 0.7) + 1, 0)


def snowflake(cx_, cy_, R, thick=1.2):
    """Six-armed snowflake drawn only in clean pixel directions: vertical
    arms and 2:1 diagonals (runs of two), with branches at 60 degrees that
    reuse the same two directions, so every line steps evenly. Draws the
    upper-left quarter (centre between columns 79 and 80) and mirrors it
    down; the room's left/right mirror completes it."""
    m = np.zeros(S, bool)
    yu = int(np.floor(cy_))
    yd = int(np.ceil(cy_))
    fat = thick >= 1.2

    def put(x, y):
        if 0 <= y <= yu and 0 <= x <= 79:
            m[y, x] = True

    def vline_(x, y, n):                      # upwards
        for i in range(n):
            put(x, y - i)

    def diag(x, y, n, up, thick_=False):      # 2:1 to the left, n steps
        for i in range(n):
            for k in (0, 1):
                yy_ = y - i if up else y + i
                put(x - 2 * i - k, yy_)
                if thick_:
                    put(x - 2 * i - k, yy_ + 1)

    nd = int(round(R / 2.236))                # steps along a diagonal arm
    vline_(79, yu, R + 1)
    diag(79, yu, nd + 1, True, fat)
    for f, L in ((0.45, 0.30), (0.75, 0.20)):
        bl = max(2, int(round(R * L)))
        d = int(round(R * f))
        diag(79, yu - d, max(2, bl // 2 + 1), True)            # off the vertical arm
        k = int(round(nd * f))
        vline_(79 - 2 * k, yu - k, bl)                          # off the diagonal arm
        diag(79 - 2 * k, yu - k, max(2, bl // 2 + 1), False)
    for j in range(0, yu + 1):                                  # mirror the top half down
        if yd + j < S[0] and yu - j >= 0:
            m[yd + j] |= m[yu - j]
    return m


# ------------------------------------------------------------ back wall (rows 0-2): ice brick with crystal arches
cv.setpal(0, 0, 10, 6, BRICK)
cv.tex(0, 0, 80, 48, ICEBRICK)
cv.rect(0, 0, 80, 2, 3)
# crystalline arches: faceted pointed bays (two per half)
def bay(c, x0):
    w = 16
    arch = pmask(S, [(x0 + 1, 46), (x0 + 1, 20), (x0 + 8, 6), (x0 + 15, 20), (x0 + 15, 46)])
    c.px[arch] = 2
    inner = pmask(S, [(x0 + 3, 46), (x0 + 3, 20), (x0 + 8, 10), (x0 + 13, 20), (x0 + 13, 46)])
    c.px[inner] = 3
    # frost tracery inside
    for y in range(14, 46, 6):
        for x in range(x0 + 4, x0 + 13):
            if inner[y, x] and (x + y) % 3 == 0:
                c.px[y, x] = 2
    c.px[edge_of(arch)] = 0
    c.px[shift(edge_of(arch), 1, 0) & arch & ~inner] = 1
bay(cv, 32)
bay(cv, 48)
cv.hline(0, 46, 80, 0)
cv.hline(0, 47, 80, 3)

# enormous crystal cluster in the corner (x 0..31, y 0..63), crystal palette
cv.setpal(0, 0, 4, 8, CRYS)
cv.px[rmask(S, 0, 0, 32, 64)] = 3
for y in range(0, 64):
    for x in range(0, 32):
        if (x % 8 == 3 and y % 8 == 5) or (x % 8 == 6 and y % 8 == 1):
            cv.px[y, x] = 2
crystal(cv, 1, 62, 10, 50, lean=-1)
crystal(cv, 18, 62, 11, 58, lean=1)
crystal(cv, 9, 63, 12, 38, lean=0)
crystal(cv, 25, 63, 7, 22, lean=2)
for (sx, sy) in [(6, 18), (21, 10), (14, 34), (27, 44)]:
    cv.pset(sx, sy, 0)

# door (rows 4-5) under a grand crystal arch (x 64..95, y 0..47)
cv.setpal(8, 0, 2, 4, AUR)
cv.px[rmask(S, 64, 0, 16, 32)] = 3
garch = pmask(S, [(64, 32), (64, 17), (79, 2), (80, 2), (80, 32)])
cv.px[garch] = 2
gin = pmask(S, [(68, 32), (68, 18), (79, 7), (80, 7), (80, 32)])
cv.px[gin] = 3
cv.px[edge_of(garch) & (xx < 80)] = 0
cv.px[shift(edge_of(garch), 1, 1) & garch & ~gin & (xx < 80)] = 1
# snowflake ornament in the tympanum
# hand-set small snowflake (vertical arm + 2:1 arms with forked tips),
# left half only: the room mirror completes it
SMALL_FLAKE = [
    "......#",
    "....#.#",
    ".....##",
    ".#....#",
    "##....#",
    "..##..#",
    "....###",
    "....###",
    "..##..#",
    "##....#",
    ".#....#",
    ".....##",
    "....#.#",
    "......#",
]
for j, row in enumerate(SMALL_FLAKE):
    for i, ch in enumerate(row):
        if ch == '#':
            cv.pset(73 + i, 13 + j, 0)
def draw_door(c, open_=False):
    c.setpal(8, 4, 2, 2, AUR)
    if open_:
        c.rect(64, 32, 16, 16, 3)
        c.vline(64, 32, 16, 2); c.vline(65, 32, 16, 1)
        for y in range(42, 48):
            for x in range(66, 80):
                if (x + y) % 2 == 0:
                    c.px[y, x] = 2
        return
    # thick sheet of ice with frost ferns
    c.rect(64, 32, 16, 16, 1)
    c.vline(64, 32, 16, 3); c.vline(65, 32, 16, 0)
    for k in range(5):
        x0, y0 = 67 + k * 3, 34 + (k * 5) % 11
        for t in range(5):
            c.pset(x0 + t // 2, y0 + t, 0)
            c.pset(x0 - 1 + t // 2, y0 + t + 1, 2)
    c.hline(64, 47, 16, 2)
draw_door(cv)

# ------------------------------------------------------------ silver dais rows 3-7 (x 32..127) + face row 8
DAISTEX = [
    "1111111111111112",
    "1000000000000012",
    "1011111111111012",
    "1011111111111012",
    "1011122222111012",
    "1011121112111012",
    "1011121012111012",
    "1011121112111012",
    "1011122222111012",
    "1011111111111012",
    "1011111111111012",
    "1000000000000012",
    "1111111111111112",
    "1111111111111112",
    "1111111111111112",
    "2222222222222222",
]
DAISTEX = [
    "0000000000000002",
    "0111111111111123",
    "0111111111111123",
    "0111111111111123",
    "0111111111111123",
    "0111111111111123",
    "0111111111111123",
    "0222222222222223",
    "0000000200000000",
    "1111112301111111",
    "1111112301111111",
    "1111112301111111",
    "1111112301111111",
    "1111112301111111",
    "1111112301111111",
    "2222222322222222",
]
cv.setpal(4, 6, 6, 10, DAIS)
cv.tex(32, 48, 48, 80, DAISTEX)
cv.hline(32, 48, 48, 3)
cv.vline(32, 48, 80, 3)
cv.vline(33, 49, 79, 0)
# snowflake mosaic on the dais centre under Lorelei
def carpet(c, y0, y1):
    """Violet runner (left half, x 64..79; the room mirror completes it):
    white edging and a chunky snowflake-diamond every 16 rows."""
    c.setpal(8, y0 // 8, 2, (y1 - y0) // 8, AUR)
    for y in range(y0, y1):
        for x in range(64, 80):
            e = x - 64
            v = 3 if e == 0 else (0 if e == 1 else (2 if e == 2 else 1))
            k = (y - y0) % 16
            d = abs(k - 8) + (79 - x)
            if d in (5, 6):
                v = 0
            elif d < 5:
                v = 2
            if d == 0 or (d == 1 and k == 8):
                v = 0
            c.px[y, x] = v
carpet(cv, 48, 128)
# face of the dais with steps
cv.setpal(4, 16, 6, 2, DAIS)
for y in range(128, 144):
    for x in range(32, 80):
        cv.px[y, x] = 2 if (y - 128) < 14 else 3
cv.hline(32, 128, 48, 0)
for x in range(34, 64, 4):
    for k in range(5):
        cv.pset(x + (k % 2), 130 + k * 2, 1)    # icicle drips on the face
for x in range(36, 64, 6):
    cv.vline(x, 129, 3 + (x // 6) % 3, 0)
cv.hline(32, 143, 48, 3)
for y in range(128, 144, 4):
    cv.rect(64, y, 16, 4, 1)
    cv.hline(64, y, 16, 0)
    cv.hline(64, y + 3, 16, 3)
cv.vline(64, 128, 16, 3)
# enormous framing crystals on the dais flanks (x 32..47, y 48..127) - crystal palette
cv.setpal(4, 6, 2, 10, CRYS)
cv.px[rmask(S, 32, 48, 16, 80)] = 3
for y in range(48, 128):
    for x in range(32, 48):
        if (x % 8 == 3 and y % 8 == 5) or (x % 8 == 6 and y % 8 == 1):
            cv.px[y, x] = 2
crystal(cv, 33, 126, 13, 76, lean=1)
crystal(cv, 40, 127, 7, 30, lean=1)
crystal(cv, 32, 127, 6, 20, lean=-1)
cv.pset(37, 70, 0); cv.pset(41, 96, 0)

# ------------------------------------------------------------ hall floor rows 9-13 (polished ice + giant snowflake)
cv.setpal(0, 18, 10, 10, ICE)
cv.tex(0, 144, 80, 80, ICEFLOOR)
cxh, cyh = 79.5, 183.5
big = snowflake(cxh, cyh, 38, 1.6)
disc = emask(S, cxh, cyh, 44, 38)
cv.px[disc & left & ~edge_of(disc)] = 1
cv.px[edge_of(disc) & left] = 2
cv.px[edge_of(emask(S, cxh, cyh, 41, 35)) & left] = 0
# thicken the arms to three pixels and outline them, Gen 2 style
fat = big | shift(big, 1, 0) | shift(big, -1, 0) | shift(big, 0, 1) | shift(big, 0, -1)
fat &= emask(S, cxh, cyh, 40, 34)
cv.px[fat & left] = 0
cv.px[edge_of(fat) & left] = 2
hub = emask(S, cxh, cyh, 5, 5)
cv.px[hub & left] = 0
cv.px[edge_of(hub) & left] = 2

# ------------------------------------------------------------ frozen pools on the sides (x 0..31, rows 4-13)
def pool(c, y0, y1):
    c.setpal(0, y0 // 8, 4, (y1 - y0) // 8, POOL)
    FROZEN = [
        "1111111111111111",
        "1001111111111111",
        "1011111111111111",
        "1111111111111111",
        "1111111111211111",
        "1111111112211111",
        "1111111121111111",
        "1111111111111111",
        "1111111111111111",
        "1111111111110011",
        "1111111111110111",
        "1111111111111111",
        "1112111111111111",
        "1122111111111111",
        "1211111111111111",
        "1111111111111111",
    ]
    c.tex(0, y0, 32, y1 - y0, FROZEN)
    # rim of packed ice (light) on the inner side and top
    c.rect(0, y0, 32, 2, 0)
    c.hline(0, y0 + 2, 32, 1)
    for x in range(0, 32, 3):
        c.vline(x, y0 + 2, 2 + (x * 7) % 5, 0)        # icicles hanging into the pool
    c.rect(30, y0, 2, y1 - y0, 0)
    c.vline(29, y0, y1 - y0, 1)
pool(cv, 64, 224)
# ice pillars standing in the pools (brick palette), x 8..23
def pillar(c, y0, y1):
    c.setpal(1, y0 // 8, 2, (y1 - y0) // 8, BRICK)
    for y in range(y0, y1):
        for x in range(8, 24):
            c.px[y, x] = [3, 0, 0, 1, 1, 1, 0, 1, 1, 1, 2, 1, 2, 2, 2, 3][x - 8]
    shade(c, rmask(S, 8, y0, 16, 7), base=1, light=0, dark=2)
    shade(c, rmask(S, 8, y1 - 6, 16, 6), base=1, light=0, dark=2)
    for y in range(y0 + 12, y1 - 8, 10):
        c.hline(9, y, 14, 2)
        c.hline(9, y + 1, 14, 0)
pillar(cv, 88, 136)
pillar(cv, 160, 208)
# snow drifts along the pool rims (snow palette cells x 24..31 at a few rows)
def drift(c, x0, y0):
    c.setpal(x0 // 8, y0 // 8, 2, 1, SNOW)
    c.px[rmask(S, x0, y0, 16, 8)] = 2
    m = emask(S, x0 + 7.5, y0 + 7, 8, 6)
    shade(c, m, base=1, light=0, dark=2)
    c.hline(x0, y0 + 7, 16, 2)
# packed snow strip at row 3 sides (x 0..31 y 48..63) above the pools - crystal cluster foot
# ------------------------------------------------------------ dividing wall (rows 14-15) with crystal arch passage
cv.setpal(0, 28, 10, 4, BRICK)
cv.tex(0, 224, 80, 32, ICEBRICK)
cv.hline(0, 224, 80, 3)
for x in range(0, 80, 5):
    cv.vline(x, 225, 2 + (x * 3) % 4, 0)    # frosted top edge
def draw_gate(c, closed=False):
    c.setpal(8, 28, 2, 4, AUR)
    c.tex(64, 224, 16, 32, ICEBRICK)
    c.hline(64, 224, 16, 3)
    arch = pmask(S, [(64, 256), (64, 242), (73, 233), (80, 233), (80, 256)])
    inner = pmask(S, [(67, 256), (67, 244), (75, 236), (80, 236), (80, 256)])
    c.prio[28, 8:12] = not closed   # brickwork above the arch drawn over the player
    c.px[arch] = 2
    c.px[edge_of(arch) & (xx < 80)] = 0
    if not closed:
        c.px[inner] = 3
        c.setpal(8, 30, 2, 2, ICE)
        c.tex(64, 240, 16, 16, ICEFLOOR)
        c.vline(64, 240, 16, 3); c.vline(65, 240, 16, 2)
        c.hline(64, 240, 16, 3)
        return
    # a wall of ice seals the passage
    c.px[inner] = 1
    for k in range(6):
        x0 = 68 + k * 2
        c.vline(x0, 243 - k, 13 + k, 0 if k % 2 else 2)
    c.px[edge_of(inner) & (xx < 80)] = 3
draw_gate(cv)

# ------------------------------------------------------------ antechamber rows 16-17: snow floor + ice lamps
cv.setpal(0, 32, 10, 4, SNOW)
for y in range(256, 288):
    for x in range(0, 80):
        cv.px[y, x] = 1
        if (x % 16, y % 16) in ((3, 2), (11, 6), (6, 11), (14, 14), (8, 1)):
            cv.px[y, x] = 2
        if (x % 16, y % 16) in ((4, 2), (12, 6), (7, 11)):
            cv.px[y, x] = 0
cv.hline(0, 256, 80, 3)
cv.hline(0, 257, 80, 2)
# path of ice through the snow (x 64..79)
cv.setpal(8, 32, 2, 4, ICE)
cv.tex(64, 256, 16, 32, ICEFLOOR)
cv.vline(64, 256, 32, 2)
cv.hline(64, 256, 16, 3)
# crystal lamps (x 32..47)
cv.setpal(4, 32, 2, 4, CRYS)
cv.px[rmask(S, 32, 256, 16, 32)] = 3
for y in range(256, 288):
    for x in range(32, 48):
        if (x % 8 == 3 and y % 8 == 5) or (x % 8 == 6 and y % 8 == 1):
            cv.px[y, x] = 2
crystal(cv, 35, 284, 10, 24)
shade(cv, rmask(S, 33, 282, 14, 6), base=1, light=0, dark=2)
cv.pset(39, 268, 0); cv.pset(40, 267, 0)
# side walls
cv.setpal(0, 32, 2, 4, BRICK)
cv.tex(0, 256, 16, 32, ICEBRICK)
cv.vline(15, 256, 32, 3)

# ------------------------------------------------------------ symmetry + collision
cv.mirror_x(0, 160); cv.mirror_pal_x()
cv.walk(3, 3, 4, 1)             # in front of the door
cv.walk(3, 4, 4, 4)             # dais (between the framing crystals)
cv.walk(4, 8, 2, 1)             # steps
cv.walk(2, 9, 6, 5)             # hall
cv.walk(4, 14, 2, 2)
cv.walk(3, 16, 4, 1)
cv.walk(4, 17, 2, 1, 'WARP_CARPET_DOWN')

door_open = cv.copy(); draw_door(door_open, open_=True); door_open.mirror_all()
door_open.walk(4, 2, 2, 1, 'LADDER')
gate_closed = cv.copy(); draw_gate(gate_closed, closed=True); gate_closed.mirror_all()
gate_closed.walk(4, 14, 2, 2, 'WALL')

border = Canvas(4, 4)
border.setpal(0, 0, 4, 4, BRICK)
border.tex(0, 0, 32, 32, ICEBRICK)

if __name__ == '__main__':
    build_room('loreleis_room', 'LoreleisRoom', cv, PALS, border,
               {'door_open': (door_open, 2, 1), 'gate_closed': (gate_closed, 2, 7)},
               out_preview=OUT + 'lorelei_preview.png')   # the ice is still: no shimmer
    preview(cv, PALS, OUT + 'lorelei_coll.png', coll=True)

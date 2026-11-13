#!/usr/bin/env python3
"""Author Crimson Crystal's tile-native boss VS animation.

No raster reference or external font is required. Generated frames fit one
WRAM6 scratch page and are committed atomically during CGB double-speed VBlank.

The ruby is drawn in seven logical colours (see LOGICAL). Every 8x8 tile that
contains ruby or effect pixels is then assigned one of five BG palettes: the
shared arena palette 0 or one of four ruby palettes (2, 3, 6, 7) that this
script solves for, writing them to gfx/battle_vs/palettes.asm. Palettes 1
(gunmetal rails/names) and 4/5 (portraits) are never used for the ruby.
"""
from pathlib import Path
import itertools
import json
import math
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'gfx/battle_vs'
TILES = 112
FRAME_BYTES = TILES * 16 + 32 * 18 * 2
LENIENT = False  # design previews only: report over-budget frames instead of failing
# Arena palettes 0/1, as indexed by the background painter (values 0-7).
COLORS = [(16, 8, 24), (88, 16, 40), (208, 32, 64), (255, 255, 255),
          (16, 8, 24), (40, 40, 64), (104, 112, 136), (224, 224, 240)]
ARENA_RGB5 = [(2, 1, 3), (11, 2, 5), (26, 4, 8), (31, 31, 31),
              (2, 1, 3), (5, 5, 8), (13, 14, 17), (28, 28, 30)]

# ---------------------------------------------------------------- ruby colours
# Logical ruby colours (RGB5). The deepest shade is available to the solver
# but the finished art leans on the five middle tones plus white.
LOGICAL = [(2, 1, 3), (7, 1, 4), (11, 2, 5), (18, 3, 7), (26, 4, 8),
           (31, 14, 16), (31, 31, 31)]
K, D, R2, R3, R4, P, W = range(7)
BASE = 32                       # logical pixels are stored as BASE + colour
EMPTY = 255                     # transparent pixel in a drawing layer
ARENA_TO_LOGICAL = {0: K, 1: R2, 2: R4, 3: W}
RUBY_SLOTS = (2, 3, 6, 7)       # BG palettes free for the ruby on this screen
ARENA_PALETTE = (K, R2, R4, W)  # palette 0, shared with the streak arena

# ---------------------------------------------------------------- ruby shape
CX, CY = 80, 66
LIGHT = (-0.55, -0.83)          # key light from the upper left


def octagon(hw, hh, c):
    """Octagon with exact 45-degree clipped corners, centred on the ruby."""
    return [(CX-hw+c, CY-hh), (CX+hw-c, CY-hh), (CX+hw, CY-hh+c), (CX+hw, CY+hh-c),
            (CX+hw-c, CY+hh), (CX-hw+c, CY+hh), (CX-hw, CY+hh-c), (CX-hw, CY-hh+c)]


# A step-cut ruby: girdle, two crown steps and a table, all sharing the same
# octagonal corner diagonals. Two pixels of side clearance let the whole gem
# jolt without clipping either portrait (portraits start at x=104 / end at 55).
CRYSTAL_OUTER = octagon(21, 36, 12)
STEP_1 = octagon(17, 32, 10)
STEP_2 = octagon(13, 28, 8)
TABLE = octagon(10, 25, 6)

# Lock frames jolt only the ruby layer; portraits, names and rails never move.
IMPACT_SHAKE = [(1, -2), (-1, 2), (1, -1), (-1, 1)]


def _mid(a, b):
    return ((a[0]+b[0])/2, (a[1]+b[1])/2)


def _lit(x, y):
    """Light term for a direction from the ruby centre (-1 dark .. 1 lit)."""
    y *= 0.6                    # the ruby is tall; flatten for even shading
    n = math.hypot(x, y) or 1
    return (x*LIGHT[0] + y*LIGHT[1]) / n


def _side_light(poly, i):
    x, y = _mid(poly[i], poly[(i+1) % 8])
    return _lit(x-CX, y-CY)


def _facets():
    """(polygon, tone, layer) back to front. Tone 0=D, 1=R2, 2=R3, 3=R4, 4=P.

    layer 0 = table, 1 = inner step, 2 = crown step, 3 = girdle; formation
    assembles them from the inside out.
    """
    out = []
    for i in range(8):
        tri = [(CX, CY), TABLE[i], TABLE[(i+1) % 8]]
        x = sum(p[0] for p in tri)/3-CX
        y = sum(p[1] for p in tri)/3-CY
        # Pavilion reflections seen through the table invert the key light.
        out.append((tri, 1.3-1.1*_lit(x, y)+(0.6 if i % 2 else -0.3), 0))
    for layer, (outer, inner, base, gain) in enumerate(
            [(STEP_2, TABLE, 1.6, -1.0), (STEP_1, STEP_2, 2.0, 1.5),
             (CRYSTAL_OUTER, STEP_1, 2.5, 1.9)], 1):
        for i in range(8):
            j = (i+1) % 8
            quad = [outer[i], outer[j], inner[j], inner[i]]
            out.append((quad, base+gain*_side_light(outer, i), layer))
    return out


FACETS = _facets()


def _tone(t):
    return BASE+[D, R2, R3, R4, P][max(0, min(4, int(round(t))))]


def sparkle(d, x, y, size):
    """Four-point twinkle: white core, pink arms; size 0 draws nothing."""
    if size <= 0:
        return
    d.point((x, y), fill=BASE+W)
    for k in range(1, size+1):
        colour = BASE+(W if size > 2 and k <= size//2 else P)
        for p in [(x+k, y), (x-k, y), (x, y+k), (x, y-k)]:
            d.point(p, fill=colour)
    if size >= 3:
        for p in [(x+1, y+1), (x-1, y-1), (x+1, y-1), (x-1, y+1)]:
            d.point(p, fill=BASE+P)


def vs_letters():
    """A matched italic pair: identical grid, stroke weight and baseline."""
    letters = Image.new('L', (160, 144))
    d = ImageDraw.Draw(letters)
    d.polygon([(61, 53), (65, 53), (72, 79), (68, 79)], fill=255)
    d.polygon([(68, 79), (72, 79), (81, 53), (77, 53)], fill=255)
    shapes = [(81, ['0111110', '1111111', '1100000', '1100000', '0111110',
                    '0000011', '0000011', '1111111', '0111110'])]
    for origin, rows in shapes:
        for y, row in enumerate(rows):
            lean = (8-y)//3
            for x, bit in enumerate(row):
                if bit == '1':
                    xx, yy = origin+x*2+lean, 53+y*3
                    d.rectangle((xx, yy, xx+1, yy+2), fill=255)
    return letters


LETTERS = vs_letters()
LETTER_OUTLINE = LETTERS.filter(ImageFilter.MaxFilter(3))


def ruby(layer, dx=0, dy=0, lift=0.0, shine=None, glints=(3, 0, 0, 0)):
    """Draw the finished ruby. lift brightens every facet (white-hot impact);
    shine is the position of a diagonal highlight sweeping across the face;
    glints are twinkle sizes at the four sparkle points."""
    d = ImageDraw.Draw(layer)

    def sh(points):
        return [(x+dx, y+dy) for x, y in points]
    silhouette = Image.new('L', layer.size)
    ImageDraw.Draw(silhouette).polygon(sh(CRYSTAL_OUTER), fill=255)
    layer.paste(BASE+K, (0, 0), silhouette.filter(ImageFilter.MaxFilter(3)))
    for points, tone, _ in FACETS:
        d.polygon(sh(points), fill=_tone(tone+lift))
    top = W if lift >= 1.5 else P
    # Lit step edges catch a one-pixel highlight on the sides facing the light.
    for poly, colour in ((STEP_1, P), (STEP_2, R4)):
        for i in range(8):
            if _side_light(poly, i) > 0.3:
                d.line(sh([poly[i], poly[(i+1) % 8]]), fill=BASE+(top if colour == P else colour))
    # Refracted fire pools in the lower right of the pavilion.
    for i in (3, 4):
        d.line(sh([TABLE[i], TABLE[(i+1) % 8]]), fill=BASE+(P if lift >= 1 else R4))
    # Rim light: bright on the lit outline, deepest shade on the far side.
    for i in range(8):
        light = _side_light(CRYSTAL_OUTER, i)
        if abs(light) > 0.35:
            d.line(sh([CRYSTAL_OUTER[i], CRYSTAL_OUTER[(i+1) % 8]]),
                   fill=BASE+((W if lift >= 1 else P) if light > 0 else D))
    if shine is not None:
        px = layer.load()
        for y in range(CY-40+dy, CY+41+dy):
            for x in range(CX-24+dx, CX+25+dx):
                value = px[x, y]
                if not silhouette.getpixel((x, y)) or not BASE+D <= value <= BASE+P:
                    continue
                u = abs((x-dx) + (y-dy)*0.55 - shine)
                if u <= 1:
                    px[x, y] = BASE+W
                elif u <= 3:
                    px[x, y] = BASE+P
                elif u <= 6:
                    px[x, y] = min(BASE+P, value+1)
    for (x, y), size in zip(SPARKLE_POINTS, glints):
        sparkle(d, x+dx, y+dy, size)
    # The complete V and S stay pure white with a dark keyline.
    layer.paste(BASE+K, (0, 0), LETTER_OUTLINE)
    layer.paste(BASE+W, (0, 0), LETTERS)


SPARKLE_POINTS = [(CRYSTAL_OUTER[0][0]+1, CRYSTAL_OUTER[0][1]+3),
                  (CRYSTAL_OUTER[3][0]-3, CRYSTAL_OUTER[3][1]-6),
                  (CRYSTAL_OUTER[5][0]+3, CRYSTAL_OUTER[5][1]-4),
                  (CRYSTAL_OUTER[1][0]+2, CRYSTAL_OUTER[1][1]+5)]


def _ease(p):
    p = max(0.0, min(1.0, p))
    return 1-(1-p)**3


def formation(layer, fx, p, seed):
    """Shards gather from the arena edges around a growing core of light.

    p runs 0..1; the table settles first and the girdle locks last."""
    d = ImageDraw.Draw(layer)
    e = ImageDraw.Draw(fx)
    # Converging sparks, drawn behind the shards on the effects layer.
    for i in range(12):
        angle = i*math.tau/12 + 0.25*(i % 2) + seed*0.05
        r0 = 78*(1-_ease(p*1.25+(i % 3)*0.06))+6
        if r0 <= 8:
            continue
        r1 = r0 + 5 + 4*(1-p)
        a = (CX+math.cos(angle)*r0, CY+math.sin(angle)*r0*1.25)
        b = (CX+math.cos(angle)*r1, CY+math.sin(angle)*r1*1.25)
        e.line([a, b], fill=BASE+(W if i % 3 == 0 else R4))
    # Core of light, shown until the table closes over it.
    core = int(2 + 10*_ease(p*1.6))
    e.ellipse((CX-core, CY-core*1.4, CX+core, CY+core*1.4), fill=BASE+R4)
    e.ellipse((CX-core*0.6, CY-core*0.85, CX+core*0.6, CY+core*0.85), fill=BASE+P)
    e.ellipse((CX-core*0.25, CY-core*0.4, CX+core*0.25, CY+core*0.4), fill=BASE+W)
    for index, (points, tone, depth) in enumerate(FACETS):
        if depth == 3:
            continue
        # The table and steps gather softly around the core.
        start = 0.1*depth + 0.02*(index % 8)
        q = _ease((p-start)/(0.78-start+0.05*depth))
        if q <= 0:
            continue
        x = sum(pt[0] for pt in points)/len(points)
        y = sum(pt[1] for pt in points)/len(points)
        angle = math.atan2(y-CY, x-CX)
        radius = (1-q) * (58 + (index % 3)*9)
        spin = (1-q) * (0.9 if index % 2 else -0.9)
        ox, oy = math.cos(angle)*radius, math.sin(angle)*radius*1.2
        moved = []
        for px_, py_ in points:
            rx, ry = px_-x, py_-y
            moved.append((round(x+ox+rx*math.cos(spin)-ry*math.sin(spin)),
                          round(y+oy+rx*math.sin(spin)+ry*math.cos(spin))))
        # Settled facets charge up, glowing brighter until the lock flash.
        charge = 1.1*max(0.0, (p-0.6)/0.4)
        d.polygon(moved, fill=_tone(tone+1.2*(1-q)+charge))
        if q < 0.6:
            # Distant shards glint along their edges; settled ones are clean.
            d.line(moved+[moved[0]], fill=BASE+P)
    # The girdle is a bright octagonal frame that closes in, accelerating
    # into the lock, where it seals around the charged facets.
    q = max(0.0, min(1.0, (p-0.45)/0.55))**2
    if q > 0:
        scale = 1 + 1.1*(1-q)
        ring = [(round(CX+(x-CX)*scale), round(CY+(y-CY)*scale)) for x, y in CRYSTAL_OUTER]
        inner = [(round(CX+(x-CX)*scale), round(CY+(y-CY)*scale)) for x, y in STEP_1]
        for i in range(8):
            j = (i+1) % 8
            d.polygon([ring[i], ring[j], inner[j], inner[i]],
                      fill=_tone(2.6+1.9*_side_light(CRYSTAL_OUTER, i)+1.5*(1-q)))
        d.line(ring+[ring[0]], fill=BASE+(W if q > 0.5 else P))


def impact(fx, stage):
    """Shock ring and light burst behind the ruby on lock (stage 0..3)."""
    d = ImageDraw.Draw(fx)
    if stage < 3:
        length = [70, 52, 36][stage]
        colours = [(W, P), (P, R4), (R4, R2)][stage]
        for i in range(12):
            angle = i*math.tau/12 + math.tau/24
            reach = length*(1.0 if i % 2 else 0.62)
            spread = 0.11 if i % 2 else 0.07
            tip = (CX+math.cos(angle)*reach, CY+math.sin(angle)*reach*1.3)
            left = (CX+math.cos(angle-spread)*24, CY+math.sin(angle-spread)*24*1.3)
            right = (CX+math.cos(angle+spread)*24, CY+math.sin(angle+spread)*24*1.3)
            d.polygon([left, tip, right], fill=BASE+colours[i % 2])
    rx, ry = [(27, 42), (35, 52), (45, 62), (56, 74)][stage]
    colour = [W, P, R4, R2][stage]
    for grow in range(2 if stage < 2 else 1):
        d.ellipse((CX-rx-grow, CY-ry-grow, CX+rx+grow, CY+ry+grow), outline=BASE+colour)


# ---------------------------------------------------------------- arena
def background(step, phase=None):
    """Arena at a streak phase (pixels travelled); step*7 unless given."""
    if phase is None:
        phase = step * 7
    im = Image.new('L', (160, 144), 0)
    d = ImageDraw.Draw(im)
    # Machined gunmetal title rails frame a blood-red arena.
    d.rectangle((0, 0, 159, 23), fill=4)
    d.line((0, 23, 159, 23), fill=6)
    d.line((0, 0, 159, 0), fill=5)
    # Keep the framing purely graphic; the matchup is the only title.
    d.line((24, 11, 66, 11), fill=5)
    d.line((94, 11, 136, 11), fill=5)
    d.polygon([(80, 5), (86, 12), (80, 19), (74, 12)], fill=6)
    d.line((80, 6, 80, 18), fill=7)
    d.rectangle((0, 120, 159, 143), fill=4)
    d.line((0, 120, 159, 120), fill=6)
    d.line((24, 132, 136, 132), fill=5)
    for x in (72, 80, 88):
        d.polygon([(x, 128), (x+3, 132), (x, 136), (x-3, 132)], fill=6)
    # Parallel speed streaks travel toward the central crystal.
    for y in range(27, 118, 6):
        d.line((0, y, 159, y), fill=1)
        offset = int(phase + y * 3) % 32
        for x in range(-32 + offset, 160, 32):
            d.line((x, y, x+10, y), fill=2)
    # White portrait stages, with straight crimson trim.
    for left, right in [(0, 55), (104, 159)]:
        d.rectangle((left, 38, right, 97), fill=2)
        d.rectangle((left, 40, right, 95), fill=3)
        d.line((left, 98, right, 98), fill=1)
    return im


def overlay(im, layer, top=24, bottom=120):
    """Paste a logical layer over the arena between the rails.

    Effects pass behind the portrait stages, so their crimson trim stays clean."""
    ImageDraw.Draw(layer).rectangle((0, 38, 55, 98), fill=EMPTY)
    ImageDraw.Draw(layer).rectangle((104, 38, 159, 98), fill=EMPTY)
    region = layer.crop((0, top, 160, bottom))
    im.paste(region, (0, top), region.point(lambda v: 0 if v == EMPTY else 255))


# ---------------------------------------------------------------- palettes
def _rgb8(c):
    return tuple(v*255//31 for v in c)


def _distance(a, b):
    a, b = _rgb8(LOGICAL[a]), _rgb8(LOGICAL[b])
    return 2*(a[0]-b[0])**2 + 4*(a[1]-b[1])**2 + 3*(a[2]-b[2])**2


def _logical(value):
    return value-BASE if value >= BASE else ARENA_TO_LOGICAL[value]


def _tile_histogram(im, tx, ty):
    """Colour counts for a tile containing ruby pixels, else None."""
    data = list(im.crop((tx*8, ty*8, tx*8+8, ty*8+8)).getdata())
    if not any(v >= BASE for v in data):
        return None
    assert all(v >= BASE or v < 4 for v in data), ('ruby over the rails', tx, ty)
    histogram = {}
    for v in data:
        histogram[_logical(v)] = histogram.get(_logical(v), 0) + 1
    return histogram


def _cost(histogram, palette):
    total = 0
    for colour, count in histogram.items():
        if colour in palette:
            continue
        if colour in (K, W):
            return math.inf     # letters and keylines must stay exact
        total += count*min(_distance(colour, q) for q in palette)
    return total


def solve_palettes(images):
    """Pick the four ruby palettes that minimise remapping error."""
    histograms = {}
    for im in images:
        for ty in range(18):
            for tx in range(20):
                h = _tile_histogram(im, tx, ty)
                if h:
                    histograms[tuple(sorted(h.items()))] = h
    keys = list(histograms.values())
    candidates = [c for c in itertools.combinations(range(7), 4) if K in c]
    shared = [_cost(h, ARENA_PALETTE) for h in keys]
    table = [[_cost(h, c) for h in keys] for c in candidates]
    best = None
    for combo in itertools.combinations(range(len(candidates)), len(RUBY_SLOTS)):
        total = 0
        for i in range(len(keys)):
            total += min([shared[i]]+[table[c][i] for c in combo])
            if best and total >= best[0]:
                break
        if best is None or total < best[0]:
            best = (total, [candidates[c] for c in combo])
    assert best[0] < math.inf, 'no palette set keeps the letters exact'
    return best[1]


def quantize(im, palettes):
    """Assign each ruby tile one palette and rewrite its pixels as slot*4+i."""
    options = [(0, ARENA_PALETTE)] + list(zip(RUBY_SLOTS, palettes))
    px = im.load()
    for ty in range(18):
        for tx in range(20):
            h = _tile_histogram(im, tx, ty)
            if not h:
                continue
            slot, palette = min(options, key=lambda o: _cost(h, o[1]))
            for y in range(ty*8, ty*8+8):
                for x in range(tx*8, tx*8+8):
                    colour = _logical(px[x, y])
                    nearest = min(palette, key=lambda q: _distance(colour, q))
                    px[x, y] = slot*4 + palette.index(nearest)
    return im


# ---------------------------------------------------------------- packing
FONT = {
 'A':['01110','10001','10001','11111','10001','10001','10001'],
 'B':['11110','10001','10001','11110','10001','10001','11110'],
 'C':['01111','10000','10000','10000','10000','10000','01111'],
 'D':['11110','10001','10001','10001','10001','10001','11110'],
 'E':['11111','10000','10000','11110','10000','10000','11111'],
 'F':['11111','10000','10000','11110','10000','10000','10000'],
 'G':['01111','10000','10000','10111','10001','10001','01111'],
 'H':['10001','10001','10001','11111','10001','10001','10001'],
 'I':['111','010','010','010','010','010','111'],
 'J':['00111','00010','00010','00010','10010','10010','01100'],
 'K':['10001','10010','10100','11000','10100','10010','10001'],
 'L':['10000','10000','10000','10000','10000','10000','11111'],
 'M':['10001','11011','10101','10101','10001','10001','10001'],
 'N':['10001','11001','11001','10101','10011','10011','10001'],
 'O':['01110','10001','10001','10001','10001','10001','01110'],
 'P':['11110','10001','10001','11110','10000','10000','10000'],
 'Q':['01110','10001','10001','10001','10101','10010','01101'],
 'R':['11110','10001','10001','11110','10100','10010','10001'],
 'S':['01111','10000','10000','01110','00001','00001','11110'],
 'T':['11111','00100','00100','00100','00100','00100','00100'],
 'U':['10001','10001','10001','10001','10001','10001','01110'],
 'V':['10001','10001','10001','10001','10001','01010','00100'],
 'W':['10001','10001','10001','10101','10101','11011','10001'],
 'X':['10001','10001','01010','00100','01010','10001','10001'],
 'Y':['10001','10001','01010','00100','00100','00100','00100'],
 'Z':['11111','00001','00010','00100','01000','10000','11111'],
 ' ':['000']*7,
}


def text(draw, xy, value, color=3, spacing=1):
    x, y = xy
    for ch in value:
        rows = FONT[ch]
        for yy, row in enumerate(rows):
            for xx, bit in enumerate(row):
                if bit == '1':
                    draw.point((x + xx, y + yy), fill=color)
        x += len(rows[0]) + spacing


def encode(tile):
    result = bytearray()
    for y in range(8):
        lo = hi = 0
        for x in range(8):
            value = tile.getpixel((x, y)) & 3
            lo = lo * 2 + (value & 1)
            hi = hi * 2 + (value >> 1)
        result.extend((lo, hi))
    return bytes(result)


def pack(im, portrait_offset=None, names=False):
    tiles = [bytes(16)]
    lookup = {tiles[0]: 0}
    tilemap, attrs = bytearray(576), bytearray(576)
    covered = {}
    if portrait_offset is not None:
        # rgbgfx -h / GetTrainerPic both use seven-tile columns.
        for side, origin in [(0, -portrait_offset), (1, 13+portrait_offset)]:
            for x in range(7):
                for y in range(7):
                    xx = origin+x
                    if not (0 <= xx < 7 if side == 0 else 13 <= xx < 20):
                        continue
                    # Mirror only this screen's player via reversed columns
                    # plus CGB tile X-flip; source graphics stay untouched.
                    column = 6-x if side == 0 else x
                    covered[(5+y)*32+xx] = (side*49+column*7+y,
                                            (8+4+side) | (0x20 if side == 0 else 0))
    if names:
        # Patched from the actual player/trainer names in the private scratch map.
        for x in range(20):
            covered[14*32+x] = (0x76, 8+1)
    for ty in range(18):
        for tx in range(20):
            pos = ty*32+tx
            if pos in covered:
                # Portrait and name cells never show the arena underneath, so
                # they do not spend any of the frame's background tiles.
                tilemap[pos], attrs[pos] = covered[pos]
                continue
            tile = im.crop((tx*8, ty*8, tx*8+8, ty*8+8))
            groups = {p//4 for p in tile.getdata() if p % 4}
            assert len(groups) <= 1, (tx, ty, groups)
            key = encode(tile)
            if key not in lookup:
                lookup[key] = len(tiles)
                tiles.append(key)
            tilemap[pos] = (lookup[key]+128) & 255
            attrs[pos] = next(iter(groups), 0)
    if len(tiles) > TILES and not LENIENT:
        raise AssertionError(f'{len(tiles)} background tiles exceed {TILES}')
    return b''.join(tiles[:TILES]).ljust(TILES*16, b'\0')+tilemap+attrs, len(tiles)


# ---------------------------------------------------------------- timeline
# Hold times are DelayFrames counts; each commit adds ~2.5 frames of upload.
COMMIT_FRAMES = 2.5
FORMATION_FRAMES = 15
SHINE_FRAMES = 8
# The settled screen ends on a seamless streak loop. CrimsonVSIntro cycles it
# for the final hold and then through the whole white fade, so the streaks
# keep travelling until the screen is completely white. LOOP_FRAMES frames
# cover one 32-pixel streak period; the engine's hold count and fade steps
# (CRIMSON_VS_LOOP_HOLD / CRIMSON_VS_FADE_STEPS) assume LOOP_HOLD.
LOOP_FRAMES = 7
LOOP_HOLD = 2   # two free VBlanks per loop frame: one fade step on each


def timeline():
    """One dict per packed frame, in playback order."""
    plan = []
    for k in range(4):
        plan.append(dict(kind='aperture', step=k, hold=4))
    for k in range(FORMATION_FRAMES):
        plan.append(dict(kind='form', p=(k+1)/(FORMATION_FRAMES+1), hold=1,
                         sound=4 if k == 0 else 0))
    for k, offset in enumerate(IMPACT_SHAKE + [(0, 0)]):
        plan.append(dict(kind='lock', stage=k, offset=offset, hold=1,
                         sound=2 if k == 0 else 0))
    for k in range(SHINE_FRAMES):
        plan.append(dict(kind='shine', shine=64+k*14, hold=1))
    twinkles = [(3, 1, 0, 0), (2, 3, 1, 0), (1, 2, 3, 1), (2, 1, 2, 3), (3, 0, 1, 2), (3, 1, 0, 1)]
    for glints in twinkles:
        plan.append(dict(kind='hold', glints=glints, hold=3))
    t = 0.0
    for row in plan:
        row['time'] = t
        t += row['hold'] + COMMIT_FRAMES
    # Continue the streaks from the last twinkle at their original speed.
    start = round((t - COMMIT_FRAMES) * 7 / 6.5) + 5
    for k in range(LOOP_FRAMES):
        plan.append(dict(kind='loop', glints=(3, 0, 0, 0), hold=LOOP_HOLD, time=t,
                         phase=start + round(k * 32 / LOOP_FRAMES)))
    return plan


def render(row):
    """Logical image (arena values 0-7 plus BASE+colour) for one frame."""
    t = row['time']
    im = background(t/6.5, row.get('phase'))  # streaks keep their original speed
    kind = row['kind']
    if kind == 'aperture':
        # Red aperture opens from the center.
        d = ImageDraw.Draw(im)
        opening = (row['step']+1)*12
        if opening < 48:
            d.rectangle((0, 24, 159, 71-opening), fill=0)
            d.rectangle((0, 72+opening, 159, 119), fill=0)
    fx = Image.new('L', im.size, EMPTY)
    gem = Image.new('L', im.size, EMPTY)
    if kind == 'form':
        formation(gem, fx, row['p'], round(t))
    elif kind == 'lock':
        stage = row['stage']
        if stage < 4:
            impact(fx, stage)
        dx, dy = row['offset']
        ruby(gem, dx, dy, lift=[2.2, 1.4, 0.7, 0.2, 0][stage], glints=(0, 0, 0, 0) if stage < 3 else (2, 0, 0, 0))
    elif kind == 'shine':
        ruby(gem, shine=row['shine'])
    elif kind in ('hold', 'loop'):
        ruby(gem, glints=row['glints'])
    overlay(im, fx)
    overlay(im, gem)
    # Portraits slide in from the screen edges during the opening.
    offset = None
    if kind != 'aperture' or row['step'] >= 2:
        offset = max(0, min(7, round(6-(t-13)/6.5)))
    return im, offset


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    preview = ROOT/'_artifacts/vs-intro/design'
    preview.mkdir(parents=True, exist_ok=True)
    plan = timeline()
    frames = [render(row) for row in plan]
    palettes = solve_palettes([im for im, _ in frames])
    for stale in OUT.glob('frame*.bin'):
        stale.unlink()
    records = []
    for k, (row, (im, offset)) in enumerate(zip(plan, frames)):
        logical_preview = im.copy()
        quantize(im, palettes)
        names = offset == 0
        raw, count = pack(im, offset, names=names)
        (OUT/f'frame{k:02d}.bin').write_bytes(raw)
        table = {0: ARENA_PALETTE}
        table.update(zip(RUBY_SLOTS, palettes))
        rgb = Image.new('RGB', im.size)
        rgb.putdata([COLORS[v] if v//4 == 1 else _rgb8(LOGICAL[table[v//4][v % 4]]) for v in im.getdata()])
        rgb.resize((640, 576), Image.Resampling.NEAREST).save(preview/f'frame{k:02d}.png')
        records.append(dict(frame=k, kind=row['kind'], tiles=count, duration=row['hold'],
                            names=names, sound=row.get('sound', 0),
                            crystal_offset=list(row.get('offset', (0, 0))),
                            loop=row['kind'] == 'loop',
                            still=row['kind'] in ('shine', 'hold', 'loop') or (row['kind'] == 'lock' and row['stage'] == 4)))
    # All legal name characters, including lowercase, digits and punctuation.
    # Native glyphs are converted to 2bpp; uppercase uses this intro's clean font.
    native = Image.open(ROOT/'gfx/font/font.png').convert('RGB')
    font = bytearray()
    for index in range(128):
        tile = Image.new('L', (8, 8))
        if index < 26:
            text(ImageDraw.Draw(tile), (1, 0), chr(ord('A')+index), 3)
        else:
            for y in range(8):
                for x in range(8):
                    pixel = native.getpixel(((index % 16)*8+x, (index//16)*8+y))
                    if sum(pixel) < 384:
                        tile.putpixel((x, y), 3)
        font.extend(encode(tile))
    (OUT/'font.bin').write_bytes(font)
    source = ['; Generated by tools/vs_intro/build.py; do not edit.']
    for label, loop in (('CrimsonVSFrames', False), ('CrimsonVSLoopFrames', True)):
        source.append(label + ':')
        for r in records:
            if r['loop'] != loop:
                continue
            source += [f'\tdba CrimsonVSFrame{r["frame"]:02d}',
                       f'\tdb {r["duration"]}, {int(r["names"])|r["sound"]}']
        source.append('\tdb -1')
    source.append('')
    (OUT/'frames.asm').write_text('\n'.join(source))
    source = ['; Generated by tools/vs_intro/build.py; do not edit.']
    for r in records:
        k = r['frame']
        if k % 4 == 0:
            source += [f'SECTION "Crimson VS frames {k//4}", ROMX, ALIGN[4]']
        source += [f'CrimsonVSFrame{k:02d}: INCBIN "gfx/battle_vs/frame{k:02d}.bin"',
                   f'\tassert @ - CrimsonVSFrame{k:02d} == {FRAME_BYTES}']
    (OUT/'data.asm').write_text('\n'.join(source)+'\n')
    # BG palettes: 0 arena, 1 gunmetal, 2/3/6/7 ruby, 4/5 portraits (colours
    # 1/2 are replaced at runtime with the canonical player/trainer palettes).
    rows = {0: ARENA_RGB5[:4], 1: ARENA_RGB5[4:],
            4: [(31, 31, 31), (0, 0, 0), (0, 0, 0), (0, 0, 0)],
            5: [(31, 31, 31), (0, 0, 0), (0, 0, 0), (0, 0, 0)]}
    for slot, palette in zip(RUBY_SLOTS, palettes):
        rows[slot] = [LOGICAL[c] for c in palette]
    source = ['; Generated by tools/vs_intro/build.py; do not edit.', 'CrimsonVSPalettes:']
    for slot in range(8):
        source.append('\tRGB ' + ', '.join('%d,%d,%d' % c for c in rows[slot]))
    source += ['\tassert @ - CrimsonVSPalettes == 8 palettes', '']
    (OUT/'palettes.asm').write_text('\n'.join(source))
    manifest = dict(frame_bytes=FRAME_BYTES, palettes={str(s): list(p) for s, p in zip(RUBY_SLOTS, palettes)},
                    frames=records)
    (OUT/'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')
    print('Generated', len(records), 'frames; max tiles', max(r['tiles'] for r in records))


if __name__ == '__main__':
    main()

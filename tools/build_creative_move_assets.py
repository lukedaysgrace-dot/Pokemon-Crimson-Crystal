#!/usr/bin/env python3
"""Build the native apple, steel hammer and two-frame swarm sprites."""
import math
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]


def tiles(image):
    image = image.convert('L')
    out = Image.new('L', (8, image.width*image.height//8), 255)
    for n, (y, x) in enumerate((y, x) for y in range(0, image.height, 8)
                               for x in range(0, image.width, 8)):
        out.paste(image.crop((x, y, x+8, y+8)), (0, n*8))
    return out


BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]
# Leaf and stem layers, drawn with the next object palette (green slot).
# o = brown outline/stem, g = light leaf, G = dark leaf half.
BIG_LEAF = [
    "..........ooo...",
    "....oo..oogggo..",
    "....oo.ogggggGo.",
    "....oooggggGGGo.",
    "...oo.oggGGGGo..",
    "...oo.oGGGGoo...",
    "...oo..oooo.....",
    "...oo...........",
]
SMALL_LEAF = [
    "........",
    "....ooo.",
    "..o.oggo",
    "..ooggGo",
    "..o.ooo.",
    "..o.....",
    "........",
    "........",
]
SHADE = {0: 255, 1: 170, 2: 85, 3: 0}


def apple_body(size, r):
    """A round apple with a top dimple and gentle taper, lit from the upper
    left: dark outline, red body, a soft highlight and a dithered shadow."""
    cx, cy = size / 2, size / 2 + 1.5

    def inside(x, y):
        nx, ny = x / r, y / r
        w = 1.0 - 0.12 * max(0.0, ny) ** 2
        if (nx / w) ** 2 + (ny * 1.06) ** 2 > 1.0:
            return False
        top = -0.94 + 0.24 * math.exp(-(nx / 0.26) ** 2)
        bottom = 0.93 - 0.06 * math.exp(-(nx / 0.25) ** 2)
        return top <= ny <= bottom

    pts = {(x, y) for y in range(size) for x in range(size) if inside(x + .5 - cx, y + .5 - cy)}
    for _ in range(2):
        pts = {p for p in pts if sum((p[0] + dx, p[1] + dy) in pts
                                     for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))) >= 2}
    px = {}
    for x, y in pts:
        if any((x + dx, y + dy) not in pts for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = 3
            continue
        nx, ny = (x + .5 - cx) / r, (y + .5 - cy) / r
        nz = math.sqrt(max(0.0, 1 - nx * nx - ny * ny))
        light = -0.5 * nx - 0.55 * ny + 0.67 * nz
        spot = ((nx + 0.38) / 0.20) ** 2 + ((ny + 0.40) / 0.15) ** 2
        if spot <= 1.0 or (spot <= 2.2 and (x + y) % 2 == 0):
            px[x, y] = 1
        elif light < 0.02 + 0.30 * BAYER[y % 4][x % 4] / 16:
            px[x, y] = 3
        else:
            px[x, y] = 2
    image = Image.new('L', (size, size), 255)
    for (x, y), v in px.items():
        image.putpixel((x, y), SHADE[v])
    return image


def leaf(rows):
    image = Image.new('L', (len(rows[0]), len(rows)), 255)
    for y, row in enumerate(rows):
        for x, c in enumerate(row):
            if c != '.':
                image.putpixel((x, y), SHADE[{'g': 1, 'G': 2, 'o': 3}[c]])
    return image


ACID_SMALL = [
    "........",
    "........",
    "...ooo..",
    "..ohggo.",
    "..oggoo.",
    "...ooo..",
    "........",
    "........",
]
ACID_MEDIUM = [
    "........",
    "..ooo...",
    ".ohhgo..",
    "ohhgggo.",
    "ogggggo.",
    "oggggoo.",
    ".oggoo..",
    "..ooo...",
]


def grid(rows):
    image = Image.new('L', (len(rows[0]), len(rows)), 255)
    for y, row in enumerate(rows):
        for x, c in enumerate(row):
            if c != '.':
                image.putpixel((x, y), SHADE[{'h': 1, 'g': 2, 'o': 3}[c]])
    return image


def acid_bubble(size=16, r=5.3):
    """Filled, glossy acid bubble: highlight upper left, dithered rim shadow."""
    c = size / 2
    pts = {(x, y) for y in range(size) for x in range(size)
           if (x + .5 - c) ** 2 + (y + .5 - c) ** 2 <= r * r}
    image = Image.new('L', (size, size), 255)
    for x, y in pts:
        dx, dy = (x + .5 - c) / r, (y + .5 - c) / r
        if any((x + a, y + b) not in pts for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            v = 3
        elif ((dx + .36) / .26) ** 2 + ((dy + .40) / .22) ** 2 <= 1:
            v = 1
        elif dx + dy > 0.8 and (x + y) % 2 == 0:
            v = 3
        else:
            v = 2
        image.putpixel((x, y), SHADE[v])
    return image


def acid_pop(size=16):
    """Eight droplets thrown out in a ring as the bubble bursts."""
    image = Image.new('L', (size, size), 255)
    for k in range(8):
        a = k * math.pi / 4 + 0.3
        x, y = int(size / 2 + math.cos(a) * 5.5), int(size / 2 + math.sin(a) * 5.5)
        for (u, v), shade in {(0, 0): 1, (1, 0): 2, (0, 1): 2, (1, 1): 3}.items():
            image.putpixel((x + u, y + v), SHADE[shade])
    return image


def main():
    # Apple Acid bubbles: small, medium, large (2x2) and burst (2x2) frames.
    parts = [tiles(grid(ACID_SMALL)), tiles(grid(ACID_MEDIUM)), tiles(acid_bubble()), tiles(acid_pop())]
    sheet = Image.new('L', (8, sum(i.height for i in parts)), 255)
    y = 0
    for art in parts:
        sheet.paste(art, (0, y)); y += art.height
    sheet.save(ROOT/'gfx/battle_anims/acid_bubble.png')
    # Apple sheet: 24px body (9 tiles), its leaf (1), 32px body (16), its leaf (2).
    # The leaf tiles are drawn on top of the body with the next palette;
    # see .OAMData_APPLE_SMALL/LARGE.
    parts = [apple_body(24, 9.0), leaf(SMALL_LEAF), apple_body(32, 12.5), leaf(BIG_LEAF)]
    parts = [tiles(part) for part in parts]
    sheet = Image.new('L', (8, sum(i.height for i in parts)), 255)
    y = 0
    for art in parts:
        sheet.paste(art, (0, y)); y += art.height
    sheet.save(ROOT/'gfx/battle_anims/creative_apple.png')
    # A real oversized mallet, with a beveled head, rivets and wrapped grip.
    # Draw at native resolution: every line here is an intentional game pixel.
    hammer = Image.new('L', (48, 48), 255); d = ImageDraw.Draw(hammer)
    d.polygon([(18, 25), (25, 30), (13, 46), (6, 41)], fill=85, outline=0)
    for y in (32, 36, 40): d.line((20-(y-32)//2, y, 24-(y-32)//2, y+3), fill=0, width=2)
    d.polygon([(11, 5), (38, 5), (45, 11), (45, 27), (38, 33), (11, 33), (4, 27), (4, 11)], fill=85, outline=0)
    d.polygon([(11, 5), (38, 5), (41, 9), (14, 9), (8, 14), (4, 11)], fill=170, outline=0)
    d.rectangle((12, 10, 38, 27), fill=170, outline=0)
    d.line((14, 12, 35, 12), fill=255)
    d.line((14, 25, 36, 25), fill=85, width=2)
    for x in (15, 34):
        for y in (14, 23): d.rectangle((x, y, x+1, y+1), fill=0)
    d.line((7, 16, 7, 25), fill=170, width=2)
    d.line((41, 13, 41, 25), fill=0, width=2)
    tiles(hammer).save(ROOT/'gfx/battle_anims/gigaton_hammer.png')
    bugs = []
    for phase in range(2):
        bug = Image.new('L', (16, 16), 255); d = ImageDraw.Draw(bug)
        d.ellipse((5, 4, 10, 12), fill=0)
        d.line((7, 5, 7, 11), fill=85)
        d.point((6, 5), fill=170); d.point((9, 5), fill=170)
        for y in (5, 8, 11):
            dy = -2 if phase else 2
            d.line((5, y, 2, y+dy), fill=0)
            d.line((10, y, 13, y-dy), fill=0)
        d.line((6, 4, 4, 1), fill=0); d.line((9, 4, 11, 1), fill=0)
        bugs.append(tiles(bug))
    sheet = Image.new('L', (8, 64), 255)
    for i, art in enumerate(bugs): sheet.paste(art, (0, i*32))
    sheet.save(ROOT/'gfx/battle_anims/infestation_bug.png')


if __name__ == '__main__':
    main()

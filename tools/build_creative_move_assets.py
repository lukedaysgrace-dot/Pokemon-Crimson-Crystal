#!/usr/bin/env python3
"""Build the tile-native apple, steel hammer and two-frame swarm sprites."""
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


def main():
    source = Image.open(ROOT/'tools/testdata/creative_moves/tart-apple.png').convert('RGBA')
    source = source.crop(source.getbbox())
    apple = Image.new('L', source.size, 255)
    for y in range(source.height):
        for x in range(source.width):
            r, g, b, a = source.getpixel((x, y))
            if a < 128:
                continue
            color = 85 if g > r*.85 and g > b*1.4 else 170 if r > 110 and r > g*1.2 else 0
            apple.putpixel((x, y), color)
    sheets = []
    for size in (24, 32):
        canvas = Image.new('L', (size, size), 255)
        art = apple.resize((size-4, size-4), Image.Resampling.NEAREST)
        canvas.paste(art, (2, 2))
        sheets.append(tiles(canvas))
    sheet = Image.new('L', (8, sum(i.height for i in sheets)), 255)
    y = 0
    for art in sheets:
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

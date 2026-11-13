#!/usr/bin/env python3
"""Author Crimson Crystal's tile-native, four-color boss VS animation.

No raster reference or external font is required. Generated frames fit one
WRAM6 scratch page and are committed atomically during CGB double-speed VBlank.
"""
from pathlib import Path
import json
import math
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'gfx/battle_vs'
TILES = 112
FRAME_BYTES = TILES * 16 + 32 * 18 * 2
IMPACT_SHAKE={12:(1,-2),13:(-1,2),14:(1,-1),15:(-1,1)}
CRYSTAL_OUTER=[(71,34),(89,34),(101,46),(101,86),(89,98),(71,98),(59,86),(59,46)]
CRYSTAL_INNER=[(71,43),(89,43),(96,50),(96,82),(89,89),(71,89),(64,82),(64,50)]
COLORS = [(16, 8, 24), (88, 16, 40), (208, 32, 64), (255, 255, 255),
          (16, 8, 24), (40, 40, 64), (104, 112, 136), (224, 224, 240)]
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
                if bit == '1': draw.point((x + xx, y + yy), fill=color)
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


def background(step):
    im = Image.new('L', (160, 144), 0)
    d = ImageDraw.Draw(im)
    # Machined gunmetal title rails frame a blood-red arena.
    d.rectangle((0, 0, 159, 23), fill=4)
    d.line((0, 23, 159, 23), fill=6)
    d.line((0, 0, 159, 0), fill=5)
    # Keep the framing purely graphic; the matchup is the only title.
    d.line((24,11,66,11),fill=5)
    d.line((94,11,136,11),fill=5)
    d.polygon([(80,5),(86,12),(80,19),(74,12)],fill=6)
    d.line((80,6,80,18),fill=7)
    d.rectangle((0, 120, 159, 143), fill=4)
    d.line((0, 120, 159, 120), fill=6)
    d.line((24,132,136,132),fill=5)
    for x in (72,80,88):
        d.polygon([(x,128),(x+3,132),(x,136),(x-3,132)],fill=6)
    # Parallel speed streaks travel toward the central crystal.
    for y in range(27, 118, 6):
        d.line((0, y, 159, y), fill=1)
        offset = (step * 7 + y * 3) % 32
        for x in range(-32 + offset, 160, 32):
            d.line((x, y, x+10, y), fill=2)
    # White portrait stages, with straight crimson trim.
    for left, right in [(0,55),(104,159)]:
        d.rectangle((left, 38, right, 97), fill=2)
        d.rectangle((left, 40, right, 95), fill=3)
        d.line((left, 98, right, 98), fill=1)
    return im


def vs_letters():
    """A matched italic pair: identical grid, stroke weight and baseline."""
    letters=Image.new('L',(160,144))
    d=ImageDraw.Draw(letters)
    d.polygon([(61,53),(65,53),(72,79),(68,79)],fill=255)
    d.polygon([(68,79),(72,79),(81,53),(77,53)],fill=255)
    shapes=[(81,['0111110','1111111','1100000','1100000','0111110',
                 '0000011','0000011','1111111','0111110'])]
    for origin,rows in shapes:
        for y,row in enumerate(rows):
            lean=(8-y)//3
            for x,bit in enumerate(row):
                if bit=='1':
                    xx,yy=origin+x*2+lean,53+y*3
                    d.rectangle((xx,yy,xx+1,yy+2),fill=255)
    return letters


def emblem(im, formation=1):
    d = ImageDraw.Draw(im)
    # A new radiant-cut ruby: flat crown, eight bevels, and exact 45-degree
    # clipped corners. The face and every adjoining facet share their edges.
    # Two pixels of side clearance let the whole gem jolt without clipping
    # against either portrait. All clipped corners remain exact 45-degree cuts.
    outer,inner=CRYSTAL_OUTER,CRYSTAL_INNER
    if formation == 1:
        silhouette = Image.new('L',im.size)
        ImageDraw.Draw(silhouette).polygon(outer,fill=255)
        im.paste(0,(0,0),silhouette.filter(ImageFilter.MaxFilter(3)))
    facets=[]
    for i in range(8):
        j=(i+1)%8
        facets.append(([outer[i],outer[j],inner[j],inner[i]],2 if i in (0,1,6,7) else 1))
    center=(80,66)
    for i in (0,2,4,6):
        facets.append(([center,inner[i],inner[i+1],inner[(i+2)%8]],1))
    for i, (points, color) in enumerate(facets):
        cx=sum(p[0] for p in points)/len(points)
        cy=sum(p[1] for p in points)/len(points)
        angle=math.atan2(cy-66,cx-80)
        radius = (1-formation) * (52 + i%3*8)
        dx, dy = round(math.cos(angle)*radius), round(math.sin(angle)*radius)
        moved = [(x+dx, y+dy) for x,y in points]
        d.polygon(moved, fill=color)
        if formation < 1:
            d.line(moved+[moved[0]], fill=2)
    if formation < 1:
        return
    d.line(outer+[outer[0]],fill=2)
    d.line(outer[6:]+outer[:2],fill=3)
    d.line(inner+[inner[0]],fill=2)
    letters=vs_letters()
    # The complete V and S stay pure white; only the ruby has shaded facets.
    im.paste(0,(0,0),letters.filter(ImageFilter.MaxFilter(3)))
    im.paste(3,(0,0),letters)


def pack(im, portrait_offset=None, names=False):
    tiles = [bytes(16)]
    lookup = {tiles[0]:0}
    tilemap, attrs = bytearray(576), bytearray(576)
    for ty in range(18):
        for tx in range(20):
            tile = im.crop((tx*8,ty*8,tx*8+8,ty*8+8))
            groups = {p//4 for p in tile.getdata() if p%4}
            assert len(groups)<=1, (tx,ty,groups)
            key = encode(tile)
            if key not in lookup:
                lookup[key]=len(tiles); tiles.append(key)
            tilemap[ty*32+tx]=(lookup[key]+128)&255
            attrs[ty*32+tx]=next(iter(groups),0)
    if portrait_offset is not None:
        # rgbgfx -h / GetTrainerPic both use seven-tile columns.
        for side, origin in [(0,-portrait_offset),(1,13+portrait_offset)]:
            for x in range(7):
                for y in range(7):
                    xx = origin+x
                    if not (0<=xx<7 if side==0 else 13<=xx<20): continue
                    pos=(5+y)*32+xx
                    # Mirror only this screen's player via reversed columns
                    # plus CGB tile X-flip; source graphics stay untouched.
                    column=6-x if side==0 else x
                    tilemap[pos]=side*49+column*7+y
                    attrs[pos]=(8+4+side)|(0x20 if side==0 else 0)
    if names:
        # Patched from the actual player/trainer names in the private scratch map.
        for x in range(20):
            attrs[14*32+x]=8+1
            tilemap[14*32+x]=0x76
    assert len(tiles)<=TILES, f'{len(tiles)} background tiles exceed {TILES}'
    return b''.join(tiles).ljust(TILES*16,b'\0')+tilemap+attrs, len(tiles)


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    preview=ROOT/'_artifacts/vs-intro/design';preview.mkdir(parents=True,exist_ok=True)
    records=[]
    # Each packed frame is prepared off screen, then committed in one VBlank.
    for k in range(26):
        im=background(k)
        if k<4:
            # Red aperture opens from the center.
            d=ImageDraw.Draw(im)
            opening=(k+1)*12
            if opening < 48:
                d.rectangle((0,24,159,71-opening),fill=0)
                d.rectangle((0,72+opening,159,119),fill=0)
        if k>=4:
            # Keep the shake local to the crystal; portraits, names and rails
            # never move. Palette index 255 is this temporary layer's mask.
            layer=Image.new('L',im.size,255)
            emblem(layer,min(1,(k-4)/8))
            dx,dy=IMPACT_SHAKE.get(k,(0,0))
            shifted=Image.new('L',im.size,255)
            shifted.paste(layer,(dx,dy))
            region=shifted.crop((0,24,160,120))
            im.paste(region,(0,24),region.point(lambda value:255 if value!=255 else 0))
        offset=max(0,7-max(0,k-1)) if k<9 else 0
        raw,count=pack(im,offset if k>=2 else None,names=k>=9)
        (OUT/f'frame{k:02d}.bin').write_bytes(raw)
        rgb=Image.new('RGB',im.size)
        rgb.putdata([COLORS[p] for p in im.getdata()])
        rgb.resize((640,576),Image.Resampling.NEAREST).save(preview/f'frame{k:02d}.png')
        records.append(dict(frame=k,tiles=count,
                            duration=1 if k in IMPACT_SHAKE else (4 if k<13 else (35 if k==25 else 3)),
                            names=k>=9,sound=4 if k==4 else (2 if k==12 else 0),
                            crystal_offset=IMPACT_SHAKE.get(k,(0,0))))
    # All legal name characters, including lowercase, digits and punctuation.
    # Native glyphs are converted to 2bpp; uppercase uses this intro's clean font.
    native=Image.open(ROOT/'gfx/font/font.png').convert('RGB')
    font=bytearray()
    for index in range(128):
        tile=Image.new('L',(8,8))
        if index<26:
            text(ImageDraw.Draw(tile),(1,0),chr(ord('A')+index),3)
        else:
            for y in range(8):
                for x in range(8):
                    pixel=native.getpixel(((index%16)*8+x,(index//16)*8+y))
                    if sum(pixel)<384: tile.putpixel((x,y),3)
        font.extend(encode(tile))
    (OUT/'font.bin').write_bytes(font)
    source=['; Generated by tools/vs_intro/build.py; do not edit.','CrimsonVSFrames:']
    for r in records:
        source += [f'\tdba CrimsonVSFrame{r["frame"]:02d}',
                   f'\tdb {r["duration"]}, {int(r["names"])|r["sound"]}']
    source += ['\tdb -1','']
    (OUT/'frames.asm').write_text('\n'.join(source))
    source=['; Generated by tools/vs_intro/build.py; do not edit.']
    for r in records:
        k=r['frame']
        if k%4==0: source += [f'SECTION "Crimson VS frames {k//4}", ROMX, ALIGN[4]']
        source += [f'CrimsonVSFrame{k:02d}: INCBIN "gfx/battle_vs/frame{k:02d}.bin"',
                   f'\tassert @ - CrimsonVSFrame{k:02d} == {FRAME_BYTES}']
    (OUT/'data.asm').write_text('\n'.join(source)+'\n')
    (OUT/'manifest.json').write_text(json.dumps(dict(frame_bytes=FRAME_BYTES,frames=records),indent=2)+'\n')
    print('Generated',len(records),'frames; max tiles',max(r['tiles'] for r in records))


if __name__=='__main__': main()

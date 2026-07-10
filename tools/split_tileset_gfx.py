#!/usr/bin/env python3
"""
Regenerate the vram0/vram1/vram2 chunk PNGs for a tileset after editing its
master PNG (gfx/tilesets/<name>.png) in Polished Map++.

The master PNG layout ("512 tiles" option in Polished Map++):
  tiles   0-127 : VRAM $0:00-7F  (only $00-$5F are loaded in-game; $60-$7F must stay blank)
  tiles 128-255 : VRAM $1:00-7F  (GFX1)
  tiles 256-383 : VRAM $1:80-FF  (GFX2)

Usage:  python3 tools/split_tileset_gfx.py <tileset_name> [more names...]
        python3 tools/split_tileset_gfx.py --all
Then run `make` (the Makefile rebuilds the .2bpp.lz files from the chunk PNGs).

NOTE: if a tileset previously had no GFX1/GFX2 chunk and you add tiles there,
you must also add the INCBIN for the new chunk in gfx/tilesets.asm and point
the tileset's entry in data/tilesets.asm at it (instead of TilesetEmpty*GFX).
"""
import sys, os, glob
from PIL import Image

def tiles_of(im):
    im=im.convert('L')
    im=im.point(lambda v: 255 if v>212 else (170 if v>127 else (85 if v>42 else 0)))
    w,h=im.size
    return [im.crop((x*8,y*8,x*8+8,y*8+8)) for y in range(h//8) for x in range(w//8)]

def is_blank(t): return t.getextrema()==(255,255)

def save_tiles(tiles,path):
    if not tiles: return False
    w=16; rows=(len(tiles)+w-1)//w
    im=Image.new('L',(w*8,rows*8),255)
    for i,t in enumerate(tiles): im.paste(t,((i%w)*8,(i//w)*8))
    im.save(path)
    return True

def split(name):
    src=f'gfx/tilesets/{name}.png'
    if not os.path.exists(src): print(f'skip {name}: no {src}'); return
    tiles=tiles_of(Image.open(src))
    tiles+= [Image.new('L',(8,8),255)]*(384-len(tiles))
    def trim(ts):
        ts=list(ts)
        while len(ts)>1 and is_blank(ts[-1]): ts.pop()
        return ts
    c0=trim(tiles[0:96]); c1=trim(tiles[128:256]); c2=trim(tiles[256:384])
    save_tiles(c0,f'gfx/tilesets/{name}.vram0.png')
    if len(c1)>1 or not is_blank(c1[0]) or os.path.exists(f'gfx/tilesets/{name}.vram1.png'):
        save_tiles(c1,f'gfx/tilesets/{name}.vram1.png')
    if len(c2)>1 or not is_blank(c2[0]) or os.path.exists(f'gfx/tilesets/{name}.vram2.png'):
        save_tiles(c2,f'gfx/tilesets/{name}.vram2.png')
    # remove stale 2bpp so make rebuilds them
    for cn in ('vram0','vram1','vram2'):
        for ext in ('.2bpp','.2bpp.lz'):
            p=f'gfx/tilesets/{name}.{cn}{ext}'
            if os.path.exists(p) and os.path.exists(f'gfx/tilesets/{name}.{cn}.png'):
                os.remove(p)
    print('split',name)

args=sys.argv[1:]
if not args:
    print(__doc__); sys.exit(1)
if args==['--all']:
    args=sorted(set(os.path.basename(p)[:-4] for p in glob.glob('gfx/tilesets/*.png')
                if '.vram' not in p and '_palette_map' not in p and 'anim' not in p))
for n in args: split(n)

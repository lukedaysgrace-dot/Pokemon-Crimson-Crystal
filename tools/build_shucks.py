"""Build the unregistered Shucks map from pinned online Gen 2 tiles.

Run with Python 3 + Pillow. No existing project tileset is read or modified.
The source inputs and their provenance live in gfx/tilesets/shucks_sources/.
"""
from collections import deque
from pathlib import Path
import hashlib
import json
import re

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'gfx/tilesets/shucks_sources'
WIDTH, HEIGHT = 24, 18  # 16-pixel movement cells; 12 x 9 map blocks.
PALETTES = [
    [(30,28,26),(21,20,20),(13,12,13),(4,3,5)],
    [(30,28,26),(27,14,18),(15,5,9),(4,3,5)],
    [(27,29,22),(16,23,14),(7,14,9),(4,3,5)],
    [(29,29,31),(18,20,28),(9,11,19),(4,3,5)],
    [(31,29,23),(28,23,13),(19,13,7),(4,3,5)],
    [(30,28,24),(25,20,14),(15,10,8),(4,3,5)],
    [(30,27,30),(23,17,24),(13,8,15),(4,3,5)],
    [(31,31,16),(31,31,16),(14,9,0),(0,0,0)],
]
source_data = {}
for name in ('game_corner', 'hotel', 'traditional_house'):
    source_data[name] = (
        Image.open(SOURCES / f'{name}.png').convert('L'),
        (SOURCES / f'{name}_metatiles.bin').read_bytes(),
        (SOURCES / f'{name}_attributes.bin').read_bytes(),
    )


def source(name, block, quadrant=None, palette=None):
    """Bake upstream CGB flips into pixels, preserving all original pixel art."""
    atlas, meta, attr = source_data[name]
    gray, pals = Image.new('L', (32,32)), Image.new('L', (4,4))
    for i in range(16):
        tile, a = meta[block*16+i], attr[block*16+i]
        assert not a & 8, 'This importer expects bank-zero upstream art'
        x, y = tile%16*8, tile//16*8
        part = atlas.crop((x,y,x+8,y+8))
        if a & 32:
            part = part.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if a & 64:
            part = part.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        gray.paste(part, (i%4*8, i//4*8))
        pals.putpixel((i%4,i//4), (a&7) if palette is None else palette)
    if quadrant is not None:
        x,y = quadrant%2*16, quadrant//2*16
        return gray.crop((x,y,x+16,y+16)), pals.crop((x//8,y//8,x//8+2,y//8+2))
    return gray,pals


def custom(width, height, palette, draw):
    art = Image.new('L', (width,height), 255)
    draw(ImageDraw.Draw(art))
    return art, Image.new('L', (width//8,height//8), palette)


floor = source('traditional_house', 0x08, 0, 5)
void = custom(16,16,0,lambda d:d.rectangle((0,0,15,15),fill=0))
wall = source('hotel',0x04,0,5)
stool = source('game_corner',0x0d,1,1)
counter = source('game_corner',0x0b,0,5)
gray = Image.new('L',(WIDTH*16,HEIGHT*16),0)
attrs = Image.new('L',(WIDTH*2,HEIGHT*2),0)
collision = [['WALL']*WIDTH for _ in range(HEIGHT)]


def put(x,y,asset,solid='FLOOR'):
    art,pals = asset
    gray.paste(art,(x*16,y*16))
    attrs.paste(pals,(x*2,y*2))
    for cy in range(y,y+art.height//16):
        for cx in range(x,x+art.width//16):
            collision[cy][cx] = solid


for y in range(1,17):
    for x in range(1,23):
        put(x,y,floor)
for x in range(1,23):
    put(x,1,wall,'WALL')
    put(x,2,wall,'WALL')

# A bottle wall, spirits cabinet, and chalk menu above the working bar.
# The shelves come from the online Gen 2 set; bottles are matching additions.
def bottles(d):
    d.rectangle((0,0,31,31), fill=85)
    for row in (0,16):
        d.rectangle((0,row+13,31,row+15), fill=0)
        d.line((0,row+12,31,row+12),fill=170)
        for x in (2,10,18,26):
            d.rectangle((x+1,row+1,x+2,row+3),fill=0)
            d.rectangle((x,row+4,x+3,row+11),fill=0)
            d.rectangle((x+1,row+4,x+2,row+10),fill=170)
            d.line((x+1,row+7,x+2,row+7),fill=255)
bottle_art,bottle_pal=custom(32,32,5,bottles)
for y in range(4):
    for x in range(4):
        bottle_pal.putpixel((x,y),2 if x%2==0 else 5)
for x in (2,4,6):
    put(x,1,(bottle_art,bottle_pal),'WALL')
put(8,1,source('game_corner',0x1e,palette=5),'WALL')

def menu(d):
    d.rectangle((0,0,15,31),fill=0)
    d.rectangle((1,1,14,30),fill=170)
    d.rectangle((3,3,12,28),fill=0)
    for y,length in ((5,7),(9,5),(13,7),(17,4),(21,6),(25,5)):
        d.line((4,y,4+length,y),fill=255)
put(10,1,custom(16,32,5,menu),'WALL')
for x in range(2,11):
    put(x,5,counter,'COUNTER')
for x in (3,5,7,9):
    put(x,6,stool,'WALL')

# Beer taps and tankards on the counter, kept at four shades per 8px tile.
def tap(d):
    d.rectangle((3,2,5,5),fill=0)
    d.rectangle((4,5,6,11),fill=0)
    d.rectangle((5,5,10,6),fill=0)
    d.rectangle((9,6,10,8),fill=0)
    d.rectangle((2,12,11,13),fill=0)
    d.line((4,7,4,10),fill=255)
tap_art,tap_pal = counter[0].copy(),counter[1].copy()
tap(ImageDraw.Draw(tap_art))
put(4,5,(tap_art,tap_pal),'COUNTER')
put(8,5,(tap_art,tap_pal),'COUNTER')

# Raised performance stage: burgundy curtain, wood floor, front fascia,
# a central two-cell stair, and two freestanding speaker stacks.
def curtain(d):
    d.rectangle((0,0,15,31),fill=85)
    for x in (0,7,14):
        d.line((x,2,x,29),fill=0)
    for x in (3,10):
        d.line((x,2,x,27),fill=170)
    d.rectangle((0,0,15,2),fill=0)
    d.line((0,3,15,3),fill=255)
    d.line((0,30,15,30),fill=170)
    d.line((0,31,15,31),fill=0)
for x in range(15,22):
    put(x,1,custom(16,32,1,curtain),'WALL')
for y in range(3,7):
    for x in range(15,22):
        put(x,y,(floor[0],Image.new('L',(2,2),4)))

def speaker(d):
    d.rectangle((1,0,14,30),fill=0)
    d.rectangle((2,1,13,29),fill=85)
    for y in (8,22):
        d.ellipse((3,y-5,12,y+4),fill=0)
        d.ellipse((5,y-3,10,y+2),fill=170)
        d.rectangle((7,y-1,8,y),fill=0)
    d.point((3,2),fill=255)
for x in (14,22):
    put(x,3,custom(16,32,0,speaker),'WALL')
    for y in (5,6):
        put(x,y,custom(16,16,5,lambda d:(d.rectangle((0,0,15,15),fill=85),d.line((0,1,15,1),fill=255))),'WALL')

def fascia(d):
    d.rectangle((0,0,15,7),fill=85)
    d.line((0,0,15,0),fill=255)
    d.line((0,7,15,7),fill=0)
    d.rectangle((1,2,14,5),outline=170)
    d.rectangle((0,8,15,15),fill=170)
    d.line((0,8,15,8),fill=0)
for x in range(15,22):
    put(x,7,custom(16,16,5,fascia),'WALL')
def stairs(d):
    d.rectangle((0,0,15,15),fill=170)
    for y in (0,5,10):
        d.line((0,y,15,y),fill=255)
        d.line((0,y+3,15,y+3),fill=0)
for x in (18,19):
    put(x,7,custom(16,16,5,stairs))

# Small checker dance floor below the stage.
def dance(d):
    d.rectangle((0,0,15,15),fill=170)
    d.rectangle((0,0,7,7),fill=255)
    d.rectangle((8,8,15,15),fill=255)
    d.line((0,15,15,15),fill=85)
for y in range(8,11):
    for x in range(15,22):
        put(x,y,custom(16,16,6,dance))

# A six-pocket billiards table with a cue ball, object balls, and a cue.
def pool(d):
    d.rectangle((0,2,63,44),fill=0)
    d.rectangle((1,1,62,42),fill=170)
    d.rectangle((2,2,61,40),outline=255,width=2)
    d.rectangle((5,5,58,36),fill=85)
    d.rectangle((7,7,56,34),fill=170)
    d.line((1,43,62,43),fill=85)
    d.rectangle((4,44,10,47),fill=0)
    d.rectangle((53,44,59,47),fill=0)
    for x,y in ((6,6),(31,5),(57,6),(6,35),(31,36),(57,35)):
        d.ellipse((x-2,y-2,x+2,y+2),fill=0)
    for x,y in ((20,20),(40,17),(43,20),(37,20),(40,23)):
        d.rectangle((x,y,x+1,y+1),fill=255)
        d.point((x+2,y+1),fill=0)
    d.line((13,28,27,14),fill=255)
pool_art,pool_pal=custom(64,48,5,pool)
for y in range(1,4):
    for x in range(1,7):
        pool_pal.putpixel((x,y),2)
put(3,10,(pool_art,pool_pal),'WALL')
def cues(d):
    d.rectangle((1,0,14,31),fill=85)
    for x in (3,7,11):
        d.line((x,1,x,28),fill=255)
        d.line((x+1,12,x+1,28),fill=170)
    for y in (8,25):
        d.rectangle((1,y,14,y+2),fill=0)
put(1,10,custom(16,32,5,cues),'WALL')

# Two cafe seating islands, using the online set's round tables and stools.
for x in (16,20):
    put(x,12,source('game_corner',0x26,palette=5),'WALL')
    put(x,11,stool,'WALL')
    put(x+1,14,stool,'WALL')
put(2,15,source('hotel',0x1c,palette=5),'WALL')

# Entrance mat is only artwork: no warp or exit collision until connected.
def carpet(d):
    d.rectangle((0,0,31,47),fill=85)
    d.rectangle((1,1,30,46),outline=255)
    d.rectangle((3,3,28,44),outline=170)
put(11,15,custom(32,48,1,carpet))

# Package only tiles actually used; no flips or second-bank dependencies.
tiles = [bytes(64)]  # Tile zero is solid black; block zero is the border.
lookup = {tiles[0]: 0}
meta, attributes, collisions = bytearray(), bytearray(), []
blocks = [(bytes(16),bytes(16),('WALL',)*4)]
for by in range(HEIGHT//2):
    for bx in range(WIDTH//2):
        block_meta, block_attr = bytearray(), bytearray()
        for ty in range(4):
            for tx in range(4):
                x,y = bx*32+tx*8, by*32+ty*8
                tile = gray.crop((x,y,x+8,y+8)).tobytes()
                if tile not in lookup:
                    lookup[tile]=len(tiles)
                    tiles.append(tile)
                block_meta.append(lookup[tile])
                block_attr.append(attrs.getpixel((x//8,y//8)))
        coll = tuple(collision[by*2+dy][bx*2+dx] for dy,dx in ((0,0),(0,1),(1,0),(1,1)))
        entry=(bytes(block_meta),bytes(block_attr),coll)
        if entry not in blocks:
            blocks.append(entry)
        collisions.append(coll)
        meta.extend(block_meta)
        attributes.extend(block_attr)
assert len(tiles)<=127, f'{len(tiles)} tiles overlaps the engine-reserved tile $7f'
assert len(blocks)<256
map_data=bytes(blocks.index((bytes(meta[i:i+16]),bytes(attributes[i:i+16]),collisions[i//16])) for i in range(0,len(meta),16))
atlas=Image.new('L',(128,128),255)
for n,tile in enumerate(tiles):
    atlas.paste(Image.frombytes('L',(8,8),tile),(n%16*8,n//16*8))
atlas.save(ROOT/'gfx/tilesets/shucks.png')
(ROOT/'data/tilesets/shucks_metatiles.bin').write_bytes(b''.join(b[0] for b in blocks))
(ROOT/'data/tilesets/shucks_attributes.bin').write_bytes(b''.join(b[1] for b in blocks))
(ROOT/'data/tilesets/shucks_collision.asm').write_text(''.join(
    '\ttilecoll '+', '.join(b[2])+f' ; {i:02x}\n' for i,b in enumerate(blocks)))
(ROOT/'maps/Shucks.ablk').write_bytes(map_data)
(ROOT/'gfx/tilesets/shucks.pal').write_text('; Dedicated interior palettes, eight palettes of four CGB colors.\n'+''.join(
    '\tRGB '+', '.join(f'{v:02d}' for c in palette for v in c)+'\n' for palette in PALETTES))

# RGBDS source PNG convention: white=0, light gray=1, dark gray=2, black=3.
raw=bytearray()
for n in range(256):
    tile=atlas.crop((n%16*8,n//16*8,n%16*8+8,n//16*8+8))
    for y in range(8):
        a=b=0
        for x in range(8):
            v=(255-tile.getpixel((x,y)))//85
            a|=(v&1)<<(7-x);b|=(v>>1)<<(7-x)
        raw.extend((a,b))
(ROOT/'gfx/tilesets/shucks.2bpp').write_bytes(raw)
# Valid Crystal LZ literal commands; the normal make rule can optimize later.
(ROOT/'gfx/tilesets/shucks.2bpp.lz').write_bytes(b''.join(bytes([len(raw[i:i+32])-1])+raw[i:i+32] for i in range(0,len(raw),32))+b'\xff')

# Re-render from the exported binary files, so preview also verifies packing.
map_data=(ROOT/'maps/Shucks.ablk').read_bytes()
export_meta=(ROOT/'data/tilesets/shucks_metatiles.bin').read_bytes()
export_attr=(ROOT/'data/tilesets/shucks_attributes.bin').read_bytes()
assert len(map_data)==108 and len(export_meta)==len(export_attr)==len(blocks)*16
assert set(atlas.get_flattened_data()) <= {0,85,170,255}
render=Image.new('RGB',gray.size)
for bi,block in enumerate(map_data):
    bm=export_meta[block*16:block*16+16]
    ba=export_attr[block*16:block*16+16]
    for i,(tile,pal) in enumerate(zip(bm,ba)):
        art=Image.frombytes('L',(8,8),tiles[tile]).convert('RGB')
        art.putdata([tuple(round(v*255/31) for v in PALETTES[pal][(255-c[0])//85]) for c in art.get_flattened_data()])
        render.paste(art,((bi%(WIDTH//2))*32+i%4*8,(bi//(WIDTH//2))*32+i//4*8))
render.save(ROOT/'maps/Shucks.preview.png')
render.resize((WIDTH*48,HEIGHT*48),Image.Resampling.NEAREST).save(ROOT/'maps/Shucks.preview-3x.png')

# Every floor tile, stage step, and point of interest must be reachable.
seen={(11,17)};queue=deque(seen)
while queue:
    x,y=queue.popleft()
    for nx,ny in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
        if 0<=nx<WIDTH and 0<=ny<HEIGHT and collision[ny][nx]=='FLOOR' and (nx,ny) not in seen:
            seen.add((nx,ny));queue.append((nx,ny))
floors={(x,y) for y in range(HEIGHT) for x in range(WIDTH) if collision[y][x]=='FLOOR'}
assert seen==floors, ('disconnected floor',floors-seen)
asm=(ROOT/'maps/Shucks.asm').read_text()
objects=[(int(x),int(y)) for x,y in re.findall(r'object_event\s+(\d+),\s*(\d+)',asm)]
assert len(objects)==len(set(objects))
for x,y in objects:
    assert (x,y) in seen, ('object not on accessible floor',x,y)
for x,y in re.findall(r'bg_event\s+(\d+),\s*(\d+)',asm):
    x,y=int(x),int(y)
    assert any((x+dx,y+dy) in seen for dx,dy in ((-1,0),(1,0),(0,-1),(0,1))), ('unreachable background event',x,y)
for text in re.findall(r'^\s*(?:text|line|cont) "([^"]*)"',asm,re.M):
    assert len(text)<=18, ('text exceeds Crystal textbox width',text)
for x,y in ((4,5),(8,5),(3,10),(6,12),(10,2)):
    assert any((x+dx,y+dy) in seen for dx,dy in ((-1,0),(1,0),(0,-1),(0,1))), ('unreachable fixture',x,y)
assert 'warp_event' not in re.sub(r';[^\n]*','',asm)
for table in ('constants/map_constants.asm','constants/tileset_constants.asm',
              'data/maps/maps.asm','data/maps/scripts.asm','data/maps/blocks.asm',
              'data/maps/attributes.asm','data/tilesets.asm','gfx/tilesets.asm'):
    assert not re.search(r'Shucks|SHUCKS', (ROOT/table).read_text()), ('draft accidentally registered',table)
receipt={'map':'Shucks','blocks':[12,9],'movement_cells':[WIDTH,HEIGHT],
         'unique_graphic_tiles':len(tiles),'unique_blocks':len(blocks),
         'reachable_floor_cells':len(seen),'objects':len(objects),'warps':0,
         'upstream_commit':(SOURCES/'commit.txt').read_text().strip(),
         'source_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(SOURCES.glob('*')) if p.suffix in ('.png','.bin')}}
(ROOT/'maps/Shucks.validation.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt,indent=2))

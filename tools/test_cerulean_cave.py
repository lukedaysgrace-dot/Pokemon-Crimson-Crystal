#!/usr/bin/env python3
"""Check Red/Blue fidelity, retained rewards and complete cave reachability."""
import argparse
from collections import deque
import hashlib
from pathlib import Path
import re

from PIL import Image

from import_cerulean_cave import ROOT, FLOORS, assets, score

MAP_HASHES = (
    '54e67c4ce734655c16943b3c15393e3c934308b88c5aa09f1b4aa3f02967c2ad',
    '97ce6be0a1e0e3469c7386fbf13861df4324b58e0fd575b31e2451f0234957f9',
    '91008aa637d0bd049efe05ee583d554122669fe9538aec25af7462fb3c2dec16',
)
REWARDS = {
    '1F': ('NUGGET', 'FULL_RESTORE', 'MAX_REVIVE', 'HIDDEN_ULTRA_BALL',
           'HIDDEN_PP_UP', 'HIDDEN_RARE_CANDY'),
    '2F': ('FULL_RESTORE', 'PP_UP', 'ULTRA_BALL', 'DUSK_STONE',
           'HIDDEN_PROTEIN', 'HIDDEN_NUGGET', 'HIDDEN_HYPER_POTION'),
    'B1F': ('MAX_ELIXER', 'ULTRA_BALL', 'HIDDEN_MAX_REVIVE', 'HIDDEN_ULTRA_BALL'),
}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', type=Path, help='Also compare against a local pret/pokered checkout')
    args = parser.parse_args()
    meta = (ROOT / 'data/tilesets/cerulean_cave_metatiles.bin').read_bytes()
    assert digest(meta) == 'a097f4128798fa5a35c58a42b699a776b7c27ae284e2a0d0a68dc446145a0f7a'
    image = Image.open(ROOT / 'gfx/tilesets/cerulean_cave.png').convert('L')
    assert image.size == (128, 128)
    assert digest(image.crop((0, 0, 128, 40)).tobytes()) == (
        '58ac012a9c32a4f64c113c5f013743c82dbedd526767e1edcd34d7b324352ddd')
    assert set(image.crop((0, 40, 128, 128)).tobytes()) == {255}
    coll = (ROOT / 'data/tilesets/cerulean_cave_collision.bin').read_bytes()
    maps = {}
    for floor, expected in zip(FLOORS, MAP_HASHES):
        name = 'CERULEAN_CAVE_' + floor
        text = (ROOT / f'maps/CeruleanCave{floor}.asm').read_text()
        blocks = (ROOT / f'maps/CeruleanCave{floor}.ablk').read_bytes()
        assert len(blocks) == 135 and digest(blocks) == expected, floor
        assert re.search(rf'map_const {name},\s+15,\s+9\b',
                         (ROOT / 'constants/map_constants.asm').read_text())
        assert re.search(rf'map CeruleanCave{floor},[^\n]*MUSIC_CERULEAN_CAVE_RBY',
                         (ROOT / 'data/maps/maps.asm').read_text())
        cells = {(x,y): coll[blocks[y//2*15+x//2]*4+(y%2)*2+x%2]
                 for y in range(18) for x in range(30)}
        warps = [(int(x),int(y),target,int(n)) for x,y,target,n in
                 re.findall(r'warp_event (\d+), (\d+), (\w+), (\d+)', text)]
        events = [(int(x),int(y),label) for x,y,label in re.findall(
            r'(?:bg_event|object_event) (\d+), (\d+), [^\n]*?, (CeruleanCave\w+)(?:,|\n)', text)]
        flags = re.findall(r'EVENT_CERULEAN_CAVE_' + floor + r'_(\w+)', text)
        assert sorted(flags) == sorted(REWARDS[floor]), (floor, flags)
        scripts = dict(re.findall(r'^(CeruleanCave\w+):\n\s+itemball (\w+)\n', text, re.M))
        for label,item in scripts.items():
            event = re.search(rf'{label}, EVENT_CERULEAN_CAVE_{floor}_(\w+)', text)
            assert event and event[1] == item, (label, item)
        hidden = re.findall(r'hiddenitem (\w+), EVENT_CERULEAN_CAVE_' + floor + r'_HIDDEN_(\w+)',text)
        assert all(item == flag for item,flag in hidden)
        maps[name] = cells,warps,events

    queue = deque([('CERULEAN_CAVE_1F',24,17)])
    seen = set(queue)
    while queue:
        name,x,y = queue.popleft()
        cells,warps,_ = maps[name]
        neighbors = []
        for nx,ny in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
            a,b = cells[x,y],cells.get((nx,ny),7)
            if b == 7 or (3 in (a,b) and (b if a == 3 else a) in (0,1,0x29,0x70)):
                continue
            neighbors.append((name,nx,ny))
        for wx,wy,target,n in warps:
            if (x,y) == (wx,wy) and target in maps:
                tx,ty,back,number = maps[target][1][n-1]
                assert back == name and warps[number-1][:2] == (wx,wy)
                neighbors.append((target,tx,ty))
        for state in neighbors:
            if state not in seen:
                seen.add(state)
                queue.append(state)
    for name,(cells,warps,events) in maps.items():
        for x,y,_,_ in warps:
            assert cells[x,y] >> 4 == 7 and (name,x,y) in seen, (name,x,y)
        for x,y,label in events:
            adjacent = ((x+1,y),(x-1,y),(x,y+1),(x,y-1))
            assert any((name,*p) in seen for p in adjacent), (name,label,'unreachable')
            if 'Hidden' not in label:
                assert cells[x,y] in (0,1,3,4), (name,label,'not on land')
    mewtwo = (ROOT / 'maps/CeruleanCaveB1F.asm').read_text()
    assert re.search(r'object_event 27, 13, SPRITE_MEWTWO,[^\n]*EVENT_SILVER_CAVE_ROOM_2_MEWTWO', mewtwo)
    assert 'loadwildmon MEWTWO, 70' in mewtwo
    assert 'BATTLETYPE_FORCEITEM' in mewtwo
    if args.reference:
        for path, expected in assets(args.reference).items():
            assert (ROOT / path).read_bytes() == expected, path
        assert (ROOT / 'audio/music/ceruleancaverby.asm').read_text() == score(args.reference)
    print('CERULEAN CAVE: exact Red/Blue maps/tiles, 17 retained rewards, all ladders, items and Mewtwo reachable')


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Import the Red/Blue cave assets from a local pret/pokered checkout.

Usage: python3 tools/import_cerulean_cave.py /path/to/pokered
Only graphics, blocks, collision/attributes and the Dungeon1 score are imported;
Crimson Crystal's item scripts and event flags are never read from pokered.
"""
import argparse
from pathlib import Path
import re

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
FLOORS = ('1F', '2F', 'B1F')
# Gen 1 tests the bottom-left graphic of each 16x16 quadrant.
# $03 distinguishes raised floor from ground for the original tile-pair rules.
COLLISION = {0x05: 0x03, 0x15: 0x04, 0x18: 0x72, 0x1a: 0x72,
             0x20: 0, 0x21: 0x70, 0x22: 0, 0x2a: 0x01, 0x2d: 0,
             0x30: 0, 0x14: 0x29}


def assets(reference):
    result = {}
    for floor in FLOORS:
        result[f'maps/CeruleanCave{floor}.ablk'] = (
            reference / f'maps/CeruleanCave{floor}.blk').read_bytes()
    meta = (reference / 'gfx/blocksets/cavern.bst').read_bytes()
    result['data/tilesets/cerulean_cave_metatiles.bin'] = meta
    result['data/tilesets/cerulean_cave_collision.bin'] = bytes(
        COLLISION.get(meta[i + q], 7)
        for i in range(0, len(meta), 16) for q in (4, 6, 12, 14))
    result['data/tilesets/cerulean_cave_attributes.bin'] = bytes(
        3 if tile == 0x14 else 5 for tile in meta)
    return result


def score(reference):
    text = (reference / 'audio/music/dungeon1.asm').read_text()
    text = text.replace('Music_Dungeon1', 'Music_CeruleanCaveRBY')
    # Red's perfect-pitch flag adds one to channel 1's hardware frequency.
    text = text.replace('toggle_perfect_pitch', 'pitch_offset 1')
    text = re.sub(r'stereo_panning %([01]+), %([01]+)',
                  lambda m: f'panning ${(int(m[1], 2) << 4) | int(m[2], 2):02x}', text)
    # Identical Gen 1 percussion already exists in Crystal's kits. Remap the
    # source instrument IDs 9..14 to kit 1's matching noise register sequences.
    drums = {9: 2, 10: 3, 11: 4, 12: 5, 13: 6, 14: 7}
    text = re.sub(r'drum_note (\d+),', lambda m: f'drum_note {drums[int(m[1])]},', text)
    text = text.replace('Music_CeruleanCaveRBY_Ch4::\n',
                        'Music_CeruleanCaveRBY_Ch4::\n\ttoggle_noise 1\n')
    header = '; Original Red/Blue Dungeon1 score: pret/pokered audio/music/dungeon1.asm.\n'
    header += 'Music_CeruleanCaveRBY:\n\tchannel_count 4\n'
    header += ''.join(f'\tchannel {i}, Music_CeruleanCaveRBY_Ch{i}\n' for i in range(1, 5))
    return header + '\n' + text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('reference', type=Path)
    args = parser.parse_args()
    for path, data in assets(args.reference).items():
        (ROOT / path).write_bytes(data)
    source = Image.open(args.reference / 'gfx/tilesets/cavern.png').convert('L')
    # The engine loads 128 tiles into each VRAM bank. Red uses only 80 tiles.
    image = Image.new('L', (128, 128), 255)
    image.paste(source, (0, 0))
    image.save(ROOT / 'gfx/tilesets/cerulean_cave.png')
    (ROOT / 'audio/music/ceruleancaverby.asm').write_text(score(args.reference))
    print('Imported original Red/Blue cave layouts, tiles and Dungeon1 music.')


if __name__ == '__main__':
    main()

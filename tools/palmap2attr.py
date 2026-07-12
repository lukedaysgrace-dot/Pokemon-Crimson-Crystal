#!/usr/bin/env python3
"""
One-time converter to the Polished Map++ per-block attributes format.
Adapted from the pret wiki tutorial:
"Allow tiles to have different attributes in different blocks (including X and Y flip)"

What it does:
 1. For each tileset, correlates gfx/tilesets/*_palette_map.asm with
    data/tilesets/*_metatiles.bin to generate data/tilesets/*_attributes.bin.
 2. Rewrites each *_metatiles.bin so tile IDs only use $00-$7F
    (the VRAM bank bit moves into the attributes).
 3. Renames maps/*.blk (and maps/unused/*.blk) to *.ablk.
 4. Creates editor-only dark_cave_metatiles.bin / dark_cave_attributes.bin
    copies of the cave files so Polished Map++ can open dark cave maps.

Run it ONCE from the project root:  python3 tools/palmap2attr.py
Running it again is safe: tilesets whose *_attributes.bin already exists
are skipped, so your Polished Map++ edits won't be overwritten.
"""

import os
import glob
import shutil

COLOR_ATTRS = {
	'GRAY': 0, 'RED': 1, 'GREEN': 2, 'WATER': 3,
	'YELLOW': 4, 'BROWN': 5, 'ROOF': 6, 'TEXT': 7,
	'PRIORITY_GRAY': 0x80, 'PRIORITY_RED': 0x81,
	'PRIORITY_GREEN': 0x82, 'PRIORITY_WATER': 0x83,
	'PRIORITY_YELLOW': 0x84, 'PRIORITY_BROWN': 0x85,
	'PRIORITY_ROOF': 0x86, 'PRIORITY_TEXT': 0x87,
}

# tileset (metatiles basename) -> palette map basename
# (some tilesets share a palette map)
TILESETS = {
	'johto': 'johto',
	'johto_modern': 'johto_modern',
	'kanto': 'kanto',
	'battle_tower_outside': 'battle_tower_outside',
	'house': 'house',
	'players_house': 'players_house',
	'pokecenter': 'pokecenter',
	'gate': 'gate',
	'port': 'port',
	'lab': 'lab',
	'facility': 'facility',
	'mart': 'mart',
	'mansion': 'mansion',
	'game_corner': 'game_corner',
	'elite_four_room': 'elite_four_room',
	'traditional_house': 'traditional_house',
	'train_station': 'train_station',
	'champions_room': 'champions_room',
	'lighthouse': 'lighthouse',
	'players_room': 'players_room',
	'pokecom_center': 'pokecom_center',
	'battle_tower': 'battle_tower',
	'tower': 'tower',
	'cave': 'cave',  # shared by cave and dark_cave
	'park': 'park',
	'ruins_of_alph': 'ruins_of_alph',
	'radio_tower': 'radio_tower',
	'underground': 'underground',
	'ice_path': 'ice_path',
	'forest': 'forest',
	'beta_word_room': 'ruins_of_alph',
	'ho_oh_word_room': 'ruins_of_alph',
	'kabuto_word_room': 'ruins_of_alph',
	'omanyte_word_room': 'ruins_of_alph',
	'aerodactyl_word_room': 'ruins_of_alph',
}


def parse_palette_map(path):
	"""Return {tile_id: attribute_byte} from a *_palette_map.asm file."""
	tile_attrs = {}
	reached_vram1 = False
	tile_index = 0
	with open(path, 'r', encoding='utf8') as f:
		for line in f:
			line = line.strip()
			if not line.startswith('tilepal'):
				continue
			line = line[len('tilepal'):]
			parts = [p.strip() for p in line.split(',')]
			bank = parts[0]
			if not reached_vram1 and bank == '1':
				reached_vram1 = True
				tile_index = 0x80
			for color in parts[1:]:
				attr = COLOR_ATTRS.get(color, 0)
				attr |= (tile_index >= 0x80) << 3
				tile_attrs[tile_index] = attr
				tile_index += 1
	return tile_attrs


def convert_tileset(name, palmap_name):
	palmap_path = 'gfx/tilesets/%s_palette_map.asm' % palmap_name
	meta_path = 'data/tilesets/%s_metatiles.bin' % name
	attr_path = 'data/tilesets/%s_attributes.bin' % name

	if os.path.exists(attr_path):
		print('Skip %s (%s already exists)' % (name, attr_path))
		return

	if not os.path.exists(palmap_path):
		print('!! Missing %s -- skipped %s' % (palmap_path, name))
		return
	if not os.path.exists(meta_path):
		print('!! Missing %s -- skipped %s' % (meta_path, name))
		return

	tile_attrs = parse_palette_map(palmap_path)

	with open(meta_path, 'rb') as f:
		metatile_bytes = f.read()

	attrs = bytes(
		tile_attrs.get(t, ((t >= 0x80) << 3))
		for t in metatile_bytes
	)
	with open(attr_path, 'wb') as f:
		f.write(attrs)

	# Mask tile IDs to $00-$7F; the bank bit now lives in the attributes.
	with open(meta_path, 'wb') as f:
		f.write(bytes(t & 0x7F for t in metatile_bytes))

	print('Converted %s (%d blocks)' % (name, len(metatile_bytes) // 16))


def main():
	if not os.path.exists('data/tilesets'):
		raise SystemExit('Run this from the project root: python3 tools/palmap2attr.py')

	for name, palmap in TILESETS.items():
		convert_tileset(name, palmap)

	# Editor-only copies so Polished Map++ can open TILESET_DARK_CAVE maps.
	# (The ROM itself shares the cave data; these files are never INCBIN'd.)
	for kind in ('metatiles', 'attributes'):
		src = 'data/tilesets/cave_%s.bin' % kind
		dst = 'data/tilesets/dark_cave_%s.bin' % kind
		if os.path.exists(src) and not os.path.exists(dst):
			shutil.copyfile(src, dst)
			print('Created editor-only copy %s' % dst)

	# Rename map block files: .blk -> .ablk
	renamed = 0
	for blk in glob.glob('maps/**/*.blk', recursive=True):
		os.rename(blk, blk[:-len('.blk')] + '.ablk')
		renamed += 1
	print('Renamed %d .blk files to .ablk' % renamed)

	print('Done! Now run: make')


if __name__ == '__main__':
	main()

SECTION "Shucks Tileset", ROMX
TilesetShucksGFX:
	INCBIN "gfx/tilesets/shucks.2bpp.lz"
TilesetShucksMeta:
	INCBIN "data/tilesets/shucks_metatiles.bin"
TilesetShucksColl:
	INCLUDE "data/tilesets/shucks_collision.asm"
TilesetShucksAttr:
	INCBIN "data/tilesets/shucks_attributes.bin"

LoadShucksPalette:
	ld hl, TilesetShucksPalette
	ld de, wBGPals1
	ld bc, 8 palettes
	ld a, BANK(wBGPals1)
	jp FarCopyWRAM

TilesetShucksPalette:
	INCLUDE "gfx/tilesets/shucks.pal"

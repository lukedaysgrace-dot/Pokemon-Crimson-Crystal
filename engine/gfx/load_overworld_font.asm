LoadOverworldFont::
	ld de, MapNameFontGFX
	ld hl, vTiles1 tile (MAP_NAME_FONT_TILE_START - $80)
	lb bc, BANK(MapNameFontGFX), MAP_NAME_FONT_NUM_TILES
	call Get2bpp

	ld de, OverworldFontSpaceGFX
	ld hl, vTiles2 tile " "
	lb bc, BANK(OverworldFontSpaceGFX), 1
	jp Get2bpp

MapNameFontGFX::
	INCBIN "gfx/font/overworld.2bpp", $00 * LEN_2BPP_TILE, 16 * LEN_2BPP_TILE
	INCBIN "gfx/font/overworld.2bpp", $60 * LEN_2BPP_TILE, 1 * LEN_2BPP_TILE
	INCBIN "gfx/font/overworld.2bpp", $11 * LEN_2BPP_TILE, 9 * LEN_2BPP_TILE
	INCBIN "gfx/font/overworld.2bpp", $76 * LEN_2BPP_TILE, 10 * LEN_2BPP_TILE

OverworldFontSpaceGFX::
	ds LEN_2BPP_TILE, 0

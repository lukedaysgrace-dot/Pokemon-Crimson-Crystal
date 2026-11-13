; Standalone asset labels, intentionally not included by gfx/tilesets.asm.
; Registration, palette loading, and map placement are deferred.
; Reuse TilesetHouseAnim in the eventual tileset table entry. Animation
; tables belong in the engine's animation bank, not in this asset bank.
; Regenerate all graphics/blocks with: python tools/build_shucks.py
; The palette is night-graded at build time: Shucks is always lit for night.
; Register the map with PALETTE_NITE and load TilesetShucksPalette for it.

SECTION "Shucks Tileset", ROMX
TilesetShucksGFX:
	INCBIN "gfx/tilesets/shucks.2bpp.lz"
TilesetShucksMeta:
	INCBIN "data/tilesets/shucks_metatiles.bin"
TilesetShucksColl:
	INCLUDE "data/tilesets/shucks_collision.asm"
TilesetShucksAttr:
	INCBIN "data/tilesets/shucks_attributes.bin"
TilesetShucksPalette:
	INCLUDE "gfx/tilesets/shucks.pal"

SECTION "Shucks Map Blocks", ROMX
Shucks_Blocks:
	INCBIN "maps/Shucks.ablk"

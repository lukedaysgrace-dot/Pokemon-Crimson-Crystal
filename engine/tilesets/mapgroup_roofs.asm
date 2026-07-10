LoadMapGroupRoofIfNeeded::
; Load roof tiles if [wMapTileset] is a roof-capable tileset.
	ld hl, .RoofTilesets
	ld a, [wMapTileset]
	ld b, a
.loop
	ld a, [hli]
	and a
	ret z
	cp b
	jr nz, .loop
	jr LoadMapGroupRoof

.RoofTilesets:
	db TILESET_JOHTO, TILESET_JOHTO_MODERN, TILESET_BATTLE_TOWER_OUTSIDE
	db TILESET_POLISHED_BATTLE_TOWER_OUTSIDE, TILESET_POLISHED_ECRUTEAK_SHRINE
	db TILESET_POLISHED_JOHTO_ANCIENT
	db TILESET_POLISHED_JOHTO_COAST_A, TILESET_POLISHED_JOHTO_COAST_B
	db TILESET_POLISHED_JOHTO_MODERN_A, TILESET_POLISHED_JOHTO_OUTLANDS_A
	db TILESET_POLISHED_JOHTO_TRADITIONAL_A, TILESET_POLISHED_JOHTO_TRADITIONAL_B
	db 0

LoadMapGroupRoof::
	ld a, [wMapGroup]
	ld e, a
	ld d, 0
	ld hl, MapGroupRoofs
	add hl, de
	ld a, [hl]
	cp -1
	ret z
	ld hl, Roofs
	ld bc, 9 tiles
	call AddNTimes
	ld de, vTiles2 tile $0a
	ld bc, 9 tiles
	call CopyBytes
	ret

INCLUDE "data/maps/roofs.asm"

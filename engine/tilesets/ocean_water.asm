; Open-sea water for the big stretches of ocean.
;
; Art: gfx/tilesets/ocean/water.png (open sea), shore.png (surf rolling in,
; crashing into land and pulling back to uncover a little sand) and rock.png
; (rocks in the sea). tools/ocean_water/build.py turns
; them, plus the normal tilesets and maps, into data/ocean/ at build time.
; The sea flows north, so the surf only appears where it runs into land
; directly above it (the Olivine coast, the south shores of islands).
;
; Maps listed below keep their normal tileset (Kanto, Johto or Johto Modern)
; but swap in, when they load:
;   - their own block data with surf blocks wherever the sea runs into land
;   - metatiles/attributes/collision where calm water and rocks use the ocean
;     tiles (in VRAM, see OceanTileSlots), plus those surf blocks
;   - an animation table that plays the ocean frames
;   - the water palette from water.png's colours
; Neighbouring maps keep reading the original map files, and nothing in the
; normal tilesets or maps is modified, so edit those as usual.
;
; To add or remove a map: edit the ocean_map list and the matching
; Ocean<Map>Blocks INCBIN further down. The map must use one of the three
; tilesets.


SECTION "Ocean Water Trampoline", ROM0

OceanWaterAnimTrampoline::
; Jumped to from _AnimateTileset with e = OCEAN_ANIM_* (see the ocean
; animation tables in engine/tilesets/tileset_anims.asm). Stack-based bank
; switch, as for LeagueRoomAnimTrampoline: safe inside VBlank.
	ldh a, [hROMBank]
	push af
	ld a, BANK(_AnimateOceanWater)
	rst Bankswitch
	call _AnimateOceanWater
	pop af
	rst Bankswitch
	ret


SECTION "Ocean Water", ROMX

ocean_map: MACRO
; map constant, map name (its blocks come from data/ocean/<name>.ablk)
	map_id \1
	dba Ocean\2Blocks
ENDM

OceanMaps:
	ocean_map PALLET_TOWN,     PalletTown
	ocean_map ROUTE_21,        Route21
	ocean_map CINNABAR_ISLAND, CinnabarIsland
	ocean_map ROUTE_20,        Route20
	ocean_map ROUTE_19,        Route19
	ocean_map OLIVINE_CITY,    OlivineCity
	ocean_map ROUTE_40,        Route40
	ocean_map ROUTE_41,        Route41
	ocean_map CIANWOOD_CITY,   CianwoodCity
	db -1

IsOceanMap:
; Return carry and hl = the map's ocean block pointer if it is open sea.
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	ld hl, OceanMaps
.loop
	ld a, [hli]
	cp -1
	ret z ; nc
	cp b
	ld a, [hli]
	jr nz, .next
	cp c
	jr z, .found
.next
	inc hl
	inc hl
	inc hl
	jr .loop
.found
	scf
	ret

ApplyOceanBlocks::
; Called from CopyMapPartialAndAttributes, before the blocks are loaded.
	call IsOceanMap
	ret nc
	ld a, [hli]
	ld [wMapBlocksBank], a
	ld a, [hli]
	ld [wMapBlocksPointer], a
	ld a, [hl]
	ld [wMapBlocksPointer + 1], a
	ret

; tileset, ocean metatiles, collision, attributes, animation table
ocean_tileset: MACRO
	db \1
	dba \2Meta, \2Coll, \2Attr
	dw \3
ENDM

OceanTilesets:
	ocean_tileset TILESET_KANTO,        TilesetKantoOcean,       TilesetKantoOceanAnim
	ocean_tileset TILESET_JOHTO,        TilesetJohtoOcean,       TilesetJohtoOceanAnim
	ocean_tileset TILESET_JOHTO_MODERN, TilesetJohtoModernOcean, TilesetJohtoModernOceanAnim
	db -1

	assert wTilesetCollisionBank == wTilesetBlocksBank + 3
	assert wTilesetAttributesBank == wTilesetBlocksBank + 6
	assert wTilesetAnim == wTilesetBlocksBank + 9

ApplyOceanTileset::
; Called from LoadTileset after the tileset header is copied.
; The animation table may change length here, so always restart it.
	xor a
	ldh [hTileAnimFrame], a
	call IsOceanMap
	ret nc
	ld a, [wMapTileset]
	ld c, a
	ld hl, OceanTilesets
.find
	ld a, [hli]
	cp -1
	ret z
	cp c
	jr z, .found
	ld de, 11
	add hl, de
	jr .find
.found
	ld de, wTilesetBlocksBank
	ld c, 11
.copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy
	ret

ApplyOceanPalette::
; Called after an outdoor tileset palette is loaded into wBGPals1.
	call IsOceanMap
	ret nc
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	cp DARKNESS_F
	ret z
	ld hl, OceanPaletteDay
	cp NITE_F
	jr nz, .got_palette
	ld hl, OceanPaletteNite
.got_palette
	ld de, wBGPals1 palette PAL_BG_WATER
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
; Colour 0 (foam, and the beach the surf uncovers as it pulls back) is the
; map's own sand colour, so the uncovered sand matches the ground exactly at
; every time of day.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, wBGPals1 palette PAL_BG_GRAY color 0
	ld de, wBGPals1 palette PAL_BG_WATER color 0
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop af
	ldh [rSVBK], a
	ret

OceanPaletteDay:
; the colours of gfx/tilesets/ocean/*.png (colour 0 is replaced by the sand)
	RGB 31, 31, 29,  10, 28, 31,  00, 19, 29,  00, 00, 00
OceanPaletteNite:
	RGB 14, 15, 22,  04, 11, 19,  01, 06, 15,  00, 00, 00

; Where each tileset keeps the 8 ocean tiles in VRAM. Each segment: number
; of tiles, VRAM bank, first VRAM tile, first tile of the step it starts at.
; Step order: sea left/right, surf left/right,
; rock top-left/top-right/bottom-left/bottom-right.
; These must match TILESETS in tools/ocean_water/build.py.
OceanTileSlots:
	db TILESET_KANTO
	db 4, 1, $49, 0
	db 4, 1, $54, 4
	db 0
	db TILESET_JOHTO
	db 4, 1, $49, 0
	db 4, 1, $58, 4
	db 0
	db TILESET_JOHTO_MODERN
	db 4, 1, $49, 0
	db 4, 1, $1c, 4
	db 0
	db -1

_AnimateOceanWater:
; e = OCEAN_ANIM_SEA:  copy this frame's ocean tiles into VRAM, and its sea
;                      tile to calm water tile $14 too (rows still on screen
;                      from a calm map you just walked from).
; e = OCEAN_ANIM_CALM: copy the calm water frame to the first four ocean
;                      tiles (rows still on screen from the sea you just left).
; Uses general-purpose DMA so each group of tiles changes in one go.

; Don't interrupt an HBlank DMA the main thread may have running.
	ldh a, [rHDMA5]
	bit 7, a
	ret z

	ldh a, [rVBK]
	push af
	call .animate
	pop af
	ldh [rVBK], a
	ret

.animate
	ld a, e
	and a
	jr nz, .calm

; step = timer (0 to OCEAN_ANIM_STEPS - 1)
	ld a, [wTileAnimationTimer]
	cp OCEAN_ANIM_STEPS
	jr c, .got_step
	xor a ; just arrived from a calm map: its timer may be past the end
.got_step
	add a
	ld e, a
	ld d, 0
	ld hl, OceanFramePointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl

; sea tile -> bank 0 tile $14
	xor a
	ldh [rVBK], a
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, HIGH(vTiles2 tile $14)
	ldh [rHDMA3], a
	ld a, LOW(vTiles2 tile $14)
	ldh [rHDMA4], a
	xor a ; 1 tile
	ldh [rHDMA5], a

; find this tileset's slots
	ld a, [wMapTileset]
	ld c, a
	ld hl, OceanTileSlots
.find
	ld a, [hli]
	cp -1
	jr z, .done
	cp c
	jr z, .segments
.skip
	ld a, [hli]
	and a
	jr z, .find
	inc hl
	inc hl
	inc hl
	jr .skip

.segments
.segment
	ld a, [hli]
	and a
	jr z, .done
	dec a
	ld b, a ; GDMA length - 1
	ld a, [hli]
	ldh [rVBK], a
	ld a, [hli]
	call .set_dest
	ld a, [hli]
	pop de ; frame
	push de
	push hl
	; source = frame + tile * 16
	swap a
	ld l, a
	and $0f
	ld h, a
	ld a, l
	and $f0
	ld l, a
	add hl, de
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, b
	ldh [rHDMA5], a
	pop hl
	jr .segment

.done
	pop hl
	ret

.calm
; same frame order as AnimateWaterTile
	ld a, [wTileAnimationTimer]
	and %110
	swap a ; * 16
	add a ; * 32 -> frame * 64
	ld l, a
	ld h, 0
	ld de, OceanCalmFrames
	add hl, de
	ld a, 1
	ldh [rVBK], a
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, $49
	call .set_dest
	ld a, 4 - 1 ; 4 tiles
	ldh [rHDMA5], a
	ret

.set_dest
; a = VRAM tile in vTiles2
	swap a
	ld c, a
	and $0f
	add HIGH(vTiles2)
	ldh [rHDMA3], a
	ld a, c
	and $f0
	ldh [rHDMA4], a
	ret

OceanFramePointers:
for f, OCEAN_ANIM_STEPS
	dw OceanWaterFrames + f * OCEAN_FRAME_TILES tiles
endr

	ALIGN 4 ; GDMA sources must be 16-byte aligned

OceanWaterFrames:
	INCBIN "data/ocean/frames.2bpp"
	assert @ - OceanWaterFrames == OCEAN_ANIM_STEPS * OCEAN_FRAME_TILES tiles

OceanCalmFrames:
; each calm water frame (gfx/tilesets/water/water.2bpp) four times over
for f, 4
rept 4
	INCBIN "gfx/tilesets/water/water.2bpp", f tiles, 1 tiles
endr
endr


SECTION "Ocean Map Blocks", ROMX

OceanPalletTownBlocks:
	INCBIN "data/ocean/PalletTown.ablk"
OceanRoute21Blocks:
	INCBIN "data/ocean/Route21.ablk"
OceanCinnabarIslandBlocks:
	INCBIN "data/ocean/CinnabarIsland.ablk"
OceanRoute20Blocks:
	INCBIN "data/ocean/Route20.ablk"
OceanRoute19Blocks:
	INCBIN "data/ocean/Route19.ablk"
OceanOlivineCityBlocks:
	INCBIN "data/ocean/OlivineCity.ablk"
OceanRoute40Blocks:
	INCBIN "data/ocean/Route40.ablk"
OceanRoute41Blocks:
	INCBIN "data/ocean/Route41.ablk"
OceanCianwoodCityBlocks:
	INCBIN "data/ocean/CianwoodCity.ablk"


SECTION "Ocean Tileset Data 1", ROMX

TilesetKantoOceanMeta:
INCBIN "data/ocean/kanto_metatiles.bin"

TilesetKantoOceanAttr:
INCBIN "data/ocean/kanto_attributes.bin"

TilesetKantoOceanColl:
INCBIN "data/ocean/kanto_collision.bin"


SECTION "Ocean Tileset Data 2", ROMX

TilesetJohtoOceanMeta:
INCBIN "data/ocean/johto_metatiles.bin"

TilesetJohtoOceanAttr:
INCBIN "data/ocean/johto_attributes.bin"

TilesetJohtoOceanColl:
INCBIN "data/ocean/johto_collision.bin"


SECTION "Ocean Tileset Data 3", ROMX

TilesetJohtoModernOceanMeta:
INCBIN "data/ocean/johto_modern_metatiles.bin"

TilesetJohtoModernOceanAttr:
INCBIN "data/ocean/johto_modern_attributes.bin"

TilesetJohtoModernOceanColl:
INCBIN "data/ocean/johto_modern_collision.bin"

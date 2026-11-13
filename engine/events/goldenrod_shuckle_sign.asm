LoadGoldenrodShuckleSignPalette::
; Goldenrod has no rock-paletted objects or effects. Its neon Shuckle sign
; (SHUCKS bar) uses the slot: switched off by day, dark at night until
; AnimateShucksNeonSign (tileset_anims.asm) fades it up and down.
	ld a, [wMapGroup]
	cp GROUP_GOLDENROD_CITY
	ret nz
	ld a, [wMapNumber]
	cp MAP_GOLDENROD_CITY
	ret nz
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	ld hl, GoldenrodShuckleSignPalettes
	ld bc, 1 palettes
	call AddNTimes
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

GoldenrodShuckleSignPalettes:
INCLUDE "gfx/overworld/shuckle_sign.pal"

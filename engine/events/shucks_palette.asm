LoadShucksObjectPalette::
; Shucks has no rock-paletted objects, so its OBJ rock slot holds Elektra's
; dark yellow (see ShucksStageHostessAsElektra), matching her battle pic
; (HostessElektraPalette, from hostess_yellow.png).
	ld a, [wMapGroup]
	cp GROUP_SHUCKS
	ret nz
	ld a, [wMapNumber]
	cp MAP_SHUCKS
	ret nz
	ld hl, .ElektraYellow
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

.ElektraYellow:
	RGB 31,31,31, 31,19,10, 21,16,03, 00,00,00 ; yellow from hostess_yellow.png

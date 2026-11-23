LoadShucksObjectPalette::
; Shucks' hostesses wear the exact colours of their battle pics: skin plus
; hair/outfit from hostess.png (Nami), hostess_red.png (Scarlet) and
; hostess_purple.png (Elektra). The bar has no tree or rock objects, so those
; slots hold Nami and Scarlet; Elektra takes over the purple slot (which the
; FAT_GUY dancer and a Friday COOLTRAINER_F share). See PAL_NPC_NAMI etc.
	ld a, [wMapGroup]
	cp GROUP_SHUCKS
	jr nz, LoadKarensRoomObjectPalette
	ld a, [wMapNumber]
	cp MAP_SHUCKS
	jr nz, LoadKarensRoomObjectPalette
	ld hl, ShucksHostessPalettes ; Nami, Scarlet
	ld de, wOBPals1 palette PAL_OW_TREE
	ld bc, 2 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld hl, ShucksHostessPalettes palette 2 ; Elektra
	ld de, wOBPals1 palette PAL_OW_PURPLE
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

ShucksHostessPalettes:
; Keep in sync with hostess.png / HostessScarletPalette / HostessElektraPalette.
	RGB 31,31,31, 30,21,18, 09,15,21, 00,00,00 ; Nami:    PAL_OW_TREE
	RGB 31,31,31, 30,21,18, 22,08,08, 00,00,00 ; Scarlet: PAL_OW_ROCK
	RGB 31,31,31, 30,21,18, 20,01,19, 00,00,00 ; Elektra: PAL_OW_PURPLE

LoadKarensRoomObjectPalette:
; Karen's Room has no rock-paletted objects, so its OBJ rock slot holds
; Karen's own palette: light blue hair (color 1), skin (color 2), black.
	ld a, [wMapGroup]
	cp GROUP_KARENS_ROOM
	ret nz
	ld a, [wMapNumber]
	cp MAP_KARENS_ROOM
	ret nz
	ld hl, .KarenLightBlueHair
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

.KarenLightBlueHair:
	RGB 31,31,31, 23,24,31, 31,19,10, 00,00,00 ; light blue hair, skin

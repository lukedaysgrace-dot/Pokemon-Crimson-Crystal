LoadBurnedTowerAshesPalette:
; Dick used G/S's gray emote palette. This hack's regular silver palette
; is nearly white, so restore the original shading only inside his tower.
	ld a, [wMapGroup]
	cp GROUP_BURNED_TOWER_1F
	ret nz
	ld a, [wMapNumber]
	cp MAP_BURNED_TOWER_1F
	ret nz
	ld hl, .Ashes
	ld de, wOBPals1 palette PAL_OW_SILVER
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM
.Ashes:
	RGB 31,31,31, 31,31,31, 13,13,13, 00,00,00

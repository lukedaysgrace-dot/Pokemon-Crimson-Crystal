SECTION "Cerulean Cave Barrier Effect", ROMX

CeruleanCaveMewPinkFlash::
; Route 4 assigns the temporary Mew to its otherwise unused rock OBJ palette.
; Save and restore that palette so the effect cannot recolor other maps.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK
rept 8
	ld a, [hli]
	push af
endr
	ld a, 1
	ldh [rSVBK], a
	ld b, 3
.pulse
	push bc
	ld hl, .BrightPink
	call .ShowPalette
	ld c, 8
	call DelayFrames
	ld hl, .SoftPink
	call .ShowPalette
	ld c, 8
	call DelayFrames
	pop bc
	dec b
	jr nz, .pulse
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK + 7
rept 8
	pop af
	ld [hld], a
endr
	pop af
	ldh [rSVBK], a
	jp .UpdateObjects

.ShowPalette
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
.UpdateObjects
	ldh a, [rOBP0]
	ld e, a
	ldh a, [rOBP1]
	ld d, a
	jp DmgToCgbObjPals

.BrightPink
	RGB 31, 31, 31, 31, 15, 27, 31, 5, 20, 22, 0, 13
.SoftPink
	RGB 31, 31, 31, 31, 26, 30, 31, 17, 26, 18, 4, 13

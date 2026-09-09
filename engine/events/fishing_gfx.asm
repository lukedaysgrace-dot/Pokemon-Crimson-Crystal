LoadFishingGFX:
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a

	ld de, FishingGFX
	ld a, [wPlayerGender]
	cp PLAYERGENDER_MINT
	jr nz, .check_indigo
	ld de, MintFishingGFX
	jr .got_gender
.check_indigo
	cp PLAYERGENDER_INDIGO
	jr nz, .check_female
	ld de, IndigoFishingGFX
	jr .got_gender
.check_female
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_gender
	ld de, LyraFishingGFX
.got_gender

	ld hl, vTiles0 tile $02
	call .LoadGFX
	ld hl, vTiles0 tile $06
	call .LoadGFX
	ld hl, vTiles0 tile $0a
	call .LoadGFX
	ld hl, vTiles0 tile $fc
	call .LoadGFX

	pop af
	ldh [rVBK], a
	ret

.LoadGFX:
	lb bc, BANK(FishingGFX), 2
	push de
	call Get2bpp
	pop de
	ld hl, 2 tiles
	add hl, de
	ld d, h
	ld e, l
	ret

FishingGFX:
INCBIN "gfx/overworld/gold_fish.2bpp"

LyraFishingGFX:
INCBIN "gfx/overworld/lyra_fish.2bpp"

IndigoFishingGFX:
INCBIN "gfx/overworld/indigo_fish.2bpp"

MintFishingGFX:
INCBIN "gfx/overworld/mint_fish.2bpp"

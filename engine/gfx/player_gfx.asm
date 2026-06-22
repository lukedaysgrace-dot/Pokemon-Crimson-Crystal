Unreferenced_Function88248:
	ld c, CAL
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .okay
	ld c, KAREN

.okay
	ld a, c
	ld [wTrainerClass], a
	ret

MovePlayerPicRight:
	hlcoord 6, 4
	ld de, 1
	jr MovePlayerPic

MovePlayerPicLeft:
	hlcoord 13, 4
	ld de, -1
	; fallthrough

MovePlayerPic:
; Move player pic at hl by de * 7 tiles.
	ld c, $8
.loop
	push bc
	push hl
	push de
	xor a
	ldh [hBGMapMode], a
	lb bc, 7, 7
	predef PlaceGraphic
	xor a
	ldh [hBGMapThird], a
	call WaitBGMap
	call DelayFrame
	pop de
	pop hl
	add hl, de
	pop bc
	dec c
	ret z
	push hl
	push bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	lb bc, 7, 7
	call ClearBox
	pop bc
	pop hl
	jr .loop

ShowPlayerNamingChoices:
	ld hl, GoldNameMenuHeader
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotGender
	ld hl, LyraNameMenuHeader
.GotGender:
	call LoadMenuHeader
	call VerticalMenu
	ld a, [wMenuCursorY]
	dec a
	call CopyNameFromMenu
	call CloseWindow
	ret

INCLUDE "data/player_names.asm"

Unreferenced_GetPlayerNameArray:
	ld hl, wPlayerName
	ld de, MalePlayerNameArray
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .done
	ld de, FemalePlayerNameArray

.done
	call InitName
	ret

GetPlayerIcon:
; Get the player icon corresponding to gender

; Male
	ld de, GoldSpriteGFX
	ld b, BANK(GoldSpriteGFX)

	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .done

; Female
	ld de, LyraSpriteGFX
	ld b, BANK(LyraSpriteGFX)

.done
	ret

GetCardPic:
	ld hl, GoldCardPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotClass
	ld hl, LyraCardPic
.GotClass:
	ld de, vTiles2 tile $00
	ld bc, $23 tiles
	ld a, BANK(GoldCardPic) ; aka BANK(LyraCardPic)
	call FarCopyBytes
	ld hl, CardGFX
	ld de, vTiles2 tile $23
	ld bc, 6 tiles
	ld a, BANK(CardGFX)
	call FarCopyBytes
	ret

GoldCardPic:
INCBIN "gfx/trainer_card/gold_card.2bpp"

LyraCardPic:
INCBIN "gfx/trainer_card/lyra_card.2bpp"

CardGFX:
INCBIN "gfx/trainer_card/trainer_card.2bpp"

GetPlayerBackpic:
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, GetGoldBackpic
	call GetLyraBackpic
	ret

GetGoldBackpic:
	ld hl, GoldBackpic
	ld b, BANK(GoldBackpic)
	ld de, vTiles2 tile $31
	ld c, 7 * 7
	predef DecompressGet2bpp
	ret

HOF_LoadTrainerFrontpic:
	call WaitBGMap
	xor a
	ldh [hBGMapMode], a
	ld e, 0
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotClass
	ld e, 1

.GotClass:
	ld a, e
	ld [wTrainerClass], a
	ld de, GoldPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotPic
	ld de, LyraPic

.GotPic:
	ld hl, vTiles2
	ld b, BANK(GoldPic) ; aka BANK(LyraPic)
	ld c, 7 * 7
	call Get2bpp
	call WaitBGMap
	ld a, $1
	ldh [hBGMapMode], a
	ret

DrawIntroPlayerPic:
; Draw the player pic at (6,4).

; Get class
	ld e, GOLD
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotClass
	ld e, LYRA
.GotClass:
	ld a, e
	ld [wTrainerClass], a

; Load pic
	ld de, GoldPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .GotPic
	ld de, LyraPic
.GotPic:
	ld hl, vTiles2
	ld b, BANK(GoldPic) ; aka BANK(LyraPic)
	ld c, 7 * 7 ; dimensions
	call Get2bpp

; Draw
	xor a
	ldh [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef PlaceGraphic
	ret

GoldPic:
INCBIN "gfx/player/gold.2bpp"

LyraPic:
INCBIN "gfx/player/lyra.2bpp"

GetLyraBackpic:
; Lyra's backpic is uncompressed.
	ld de, LyraBackpic
	ld hl, vTiles2 tile $31
	lb bc, BANK(LyraBackpic), 7 * 7 ; dimensions
	call Get2bpp
	ret

LyraBackpic:
INCBIN "gfx/player/lyra_back.2bpp"

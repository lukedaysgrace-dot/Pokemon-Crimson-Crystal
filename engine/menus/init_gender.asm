InitCrystalData:
	ld a, $1
	ld [wd474], a
	xor a
	ld [wd473], a
	ld [wPlayerGender], a
	ld [wd475], a
	ld [wd476], a
	ld [wd477], a
	ld [wd478], a
	ld [wd002], a
	ld [wd003], a
	; could have done "ld a, [wd479] \ and %11111100", saved four operations
	ld a, [wd479]
	res 0, a
	ld [wd479], a
	ld a, [wd479]
	res 1, a
	ld [wd479], a
	ret

INCLUDE "mobile/mobile_12.asm"

; Character select screen, in the style of Polished Crystal: all four player
; trainer pics are drawn side by side and a ▼ cursor picks between them.
;
; Each pic is 7x7 tiles, but four of those would need 196 tiles and only 128
; are addressable for the BG. The middle five columns of each pic are used
; instead (5 * 7 = 35 tiles each, 20 tiles wide on screen, exactly the width
; of the screen). Three of them fit in VRAM bank 0; the fourth is loaded into
; VRAM bank 1 and reached through the bank bit in the attribute map.
;
; Each character gets its own BG palette so everyone keeps their own colors.
; The three that are not selected have their colors blended halfway to white,
; which is how Polished Crystal dims the choices you are not on.

NUM_CHARSELECT_CHOICES     EQU 4
CHARSELECT_PIC_WIDTH       EQU 5 ; tiles
CHARSELECT_PIC_HEIGHT      EQU 7 ; tiles
CHARSELECT_PIC_TILES       EQU CHARSELECT_PIC_WIDTH * CHARSELECT_PIC_HEIGHT
CHARSELECT_PIC_LEFT_COLUMN EQU 7 ; tiles skipped: the pic's blank left column
CHARSELECT_PIC_ROW         EQU 4
CHARSELECT_ARROW_ROW       EQU CHARSELECT_PIC_ROW - 1

CHARSELECT_TILE_0 EQU $01 ; tile $00 is left alone for the other setup screens
CHARSELECT_TILE_1 EQU CHARSELECT_TILE_0 + CHARSELECT_PIC_TILES
CHARSELECT_TILE_2 EQU CHARSELECT_TILE_1 + CHARSELECT_PIC_TILES
CHARSELECT_TILE_3 EQU $01 ; in VRAM bank 1

; This screen uses a plain white background, so every character palette shares
; white as its color 0 and the pics sit flush on it with no box around them.
; The background is drawn with the blank textbox tile, which is solid color 0.
CHARSELECT_BG_COLOR EQU palred 31 + palgreen 31 + palblue 31

InitGender:
; keep the current choice across a "no" at the confirmation prompt
	ld a, [wPlayerGender]
	push af
	call InitGenderScreen ; this zeroes wPlayerGender
	pop af
	cp NUM_CHARSELECT_CHOICES
	jr c, .valid
	xor a
.valid
	ld [wPlayerGender], a

	call LoadGenderScreenPal
	call CharSelect_LoadTextPalette
	call CharSelect_FillBackground
	call CharSelect_LoadPics
	call CharSelect_PlacePics
	call CharSelect_PlaceArrow
	call CharSelect_LoadCharPals
	call WaitBGMap2
	call SetPalettes
	ld hl, TextJump_AreYouABoyOrAreYouAGirl
	call PrintText
	call CharSelect_Loop
	call CharSelect_ClearAttrMap
	ld c, 10
	call DelayFrames
	ret

CharSelect_Loop:
	ld a, 1
	ldh [hBGMapMode], a
.loop
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON
	ret nz
	ldh a, [hJoyPressed]
	bit D_RIGHT_F, a
	jr nz, .right
	bit D_LEFT_F, a
	jr z, .loop

; left
	ld a, [wPlayerGender]
	call CharSelectOrderLookup
	and a
	jr z, .loop ; already on the leftmost choice
	dec a
	jr .move

.right
	ld a, [wPlayerGender]
	call CharSelectOrderLookup
	cp NUM_CHARSELECT_CHOICES - 1
	jr z, .loop ; already on the rightmost choice
	inc a

.move
	call CharSelectOrderLookup ; index back to a wPlayerGender value
	ld [wPlayerGender], a
	call CharSelect_PlaceArrow
	call CharSelect_LoadCharPals
	ld a, %11100100
	call DmgToCgbBGPals
	jr .loop

CharSelect_LoadPics:
; VRAM is written directly with the LCD off, so the fourth pic can go into
; VRAM bank 1 (the vblank tile-request handler always writes to bank 0).
	call DisableLCD

	ld c, 0
	ld hl, vTiles2 tile CHARSELECT_TILE_0
	call .LoadOne
	ld c, 1
	ld hl, vTiles2 tile CHARSELECT_TILE_1
	call .LoadOne
	ld c, 2
	ld hl, vTiles2 tile CHARSELECT_TILE_2
	call .LoadOne

	ld a, 1
	ldh [rVBK], a
	ld c, 3
	ld hl, vTiles2 tile CHARSELECT_TILE_3
	call .LoadOne
	xor a
	ldh [rVBK], a

	call EnableLCD
	ret

.LoadOne:
; c = choice index, hl = destination in VRAM
	push hl
	ld a, c
	call CharSelectPicLookup ; de = pic data, b = its bank
	pop hl
	ld c, CHARSELECT_PIC_TILES
	jp Get2bpp

CharSelect_PlacePics:
	xor a
	ld [wBoxAlignment], a

	ld a, CHARSELECT_TILE_0
	ldh [hGraphicStartTile], a
	hlcoord 0, CHARSELECT_PIC_ROW
	lb bc, CHARSELECT_PIC_WIDTH, CHARSELECT_PIC_HEIGHT
	predef PlaceGraphic

	ld a, CHARSELECT_TILE_1
	ldh [hGraphicStartTile], a
	hlcoord 5, CHARSELECT_PIC_ROW
	lb bc, CHARSELECT_PIC_WIDTH, CHARSELECT_PIC_HEIGHT
	predef PlaceGraphic

	ld a, CHARSELECT_TILE_2
	ldh [hGraphicStartTile], a
	hlcoord 10, CHARSELECT_PIC_ROW
	lb bc, CHARSELECT_PIC_WIDTH, CHARSELECT_PIC_HEIGHT
	predef PlaceGraphic

	ld a, CHARSELECT_TILE_3
	ldh [hGraphicStartTile], a
	hlcoord 15, CHARSELECT_PIC_ROW
	lb bc, CHARSELECT_PIC_WIDTH, CHARSELECT_PIC_HEIGHT
	predef PlaceGraphic

; One BG palette per character. The fourth pic's tiles are in VRAM bank 1,
; so its cells set the bank bit as well.
	hlcoord 0, CHARSELECT_PIC_ROW, wAttrMap
	ld a, 1
	call CharSelect_FillPicAttrs
	hlcoord 5, CHARSELECT_PIC_ROW, wAttrMap
	ld a, 2
	call CharSelect_FillPicAttrs
	hlcoord 10, CHARSELECT_PIC_ROW, wAttrMap
	ld a, 3
	call CharSelect_FillPicAttrs
	hlcoord 15, CHARSELECT_PIC_ROW, wAttrMap
	ld a, 4 | (1 << 3) ; palette 4, VRAM bank 1
	call CharSelect_FillPicAttrs

; The cursor row keeps palette 0, which is white through black: a black arrow
; on the white background, and nothing showing in the slots that are empty.
	ret

CharSelect_FillPicAttrs:
; fill one pic-sized box of wAttrMap at hl with a
	ld b, CHARSELECT_PIC_HEIGHT
.row
	push hl
	ld c, CHARSELECT_PIC_WIDTH
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .row
	ret

CharSelect_PlaceArrow:
; erase every cursor slot, then place one over the current choice
	ld a, " "
	ldcoord_a 2, CHARSELECT_ARROW_ROW
	ldcoord_a 7, CHARSELECT_ARROW_ROW
	ldcoord_a 12, CHARSELECT_ARROW_ROW
	ldcoord_a 17, CHARSELECT_ARROW_ROW

	ld a, [wPlayerGender]
	call CharSelectOrderLookup
	ld e, a
	add a
	add a
	add e ; index * 5, one pic width apart
	add 2 ; centred over the pic
	ld e, a
	ld d, 0
	hlcoord 0, CHARSELECT_ARROW_ROW
	add hl, de
	ld [hl], "▼"
	ret

CharSelect_FillBackground:
; InitGenderScreen fills the screen with the light blue tile; this screen wants
; plain white instead.
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " " ; the blank textbox tile: solid color 0, i.e. white
	call ByteFill
	ret

CharSelect_ClearAttrMap:
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	ret

CharSelect_LoadTextPalette:
; The textbox draws itself with PAL_BG_TEXT, so give that palette something
; readable rather than leaving whatever the last screen happened to have.
	ld hl, .Palette
	ld de, wBGPals1 palette PAL_BG_TEXT
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	ret

.Palette:
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 00, 00, 00

CharSelect_LoadCharPals:
; Rebuild BG palettes 1-4, dimming everyone except the current choice.
; wPlayerGender is read here, before rSVBK is switched to the palette bank.
	ld a, [wPlayerGender]
	call CharSelectOrderLookup
	ld b, a
	ld c, 0
.loop
	push bc
	call CharSelect_LoadOneCharPal
	pop bc
	inc c
	ld a, c
	cp NUM_CHARSELECT_CHOICES
	jr nz, .loop
	ret

CharSelect_LoadOneCharPal:
; b = the selected choice, c = the choice being loaded
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a

; hl = wBGPals1 palette (c + 1)
	ld a, c
	inc a
	add a
	add a
	add a ; * PALETTE_SIZE
	ld l, a
	ld h, 0
	ld de, wBGPals1
	add hl, de

; color 0 is the screen background rather than white
	ld a, LOW(CHARSELECT_BG_COLOR)
	ld [hli], a
	ld a, HIGH(CHARSELECT_BG_COLOR)
	ld [hli], a

; colors 1 and 2 come from the character's own palette, in another bank
	push hl
	ld d, h
	ld e, l
	ld a, c
	push bc
	call CharSelectCharPaletteLookup
	ld bc, 2 * PAL_COLOR_SIZE
	ld a, BANK(TrainerPalettes)
	call FarCopyBytes
	pop bc
; color 3 is black
	xor a
	ld [de], a
	inc de
	ld [de], a
	pop hl ; back to color 1

	ld a, b
	cp c
	jr z, .selected
	ld a, NUM_PAL_COLORS - 1
	call CharSelect_LightenColors
.selected
	pop af
	ldh [rSVBK], a
	ret

CharSelect_LightenColors:
; Blend a colors at hl halfway to white: every 5-bit channel becomes
; channel / 2 + 16, which is one masked shift and one or on the whole word.
	push bc
	ld b, a
.loop
	ld a, [hli]
	ld c, a
	ld a, [hl]
	srl a
	rr c
	and $3d
	or $42
	ld [hld], a
	ld a, c
	and $ef
	or $10
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	pop bc
	ret

CharSelectOrderLookup:
; Maps a choice index to its wPlayerGender value and back again: swapping
; Indigo and Lyra is its own inverse, so one table serves both directions.
	push hl
	push de
	ld l, a
	ld h, 0
	ld de, CharSelectOrder
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret

CharSelectCharPaletteLookup:
; a = choice index; returns hl = that character's two middle colors
	push de
	ld l, a
	ld h, 0
	add hl, hl
	ld de, CharSelectPalettes
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret

CharSelectPicLookup:
; a = choice index; returns de = pic data, b = its bank
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, CharSelectPicPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld b, [hl]
	ret

CharSelectOrder:
	db 0                          ; Gold
	db PLAYERGENDER_INDIGO        ; Indigo
	db 1 << PLAYERGENDER_FEMALE_F ; Lyra
	db PLAYERGENDER_MINT          ; Mint

CharSelectPalettes:
	dw PlayerPalette       ; Gold
	dw IndigoPlayerPalette ; Indigo
	dw PlayerPalette       ; Lyra, who shares Gold's colors everywhere else
	dw MintPlayerPalette   ; Mint

CharSelectPicPointers:
; pointer to the pic's second tile column, then the bank it lives in
	dw GoldPic tile CHARSELECT_PIC_LEFT_COLUMN
	db BANK(GoldPic)
	db 0
	dw IndigoPic tile CHARSELECT_PIC_LEFT_COLUMN
	db BANK(IndigoPic)
	db 0
	dw LyraPic tile CHARSELECT_PIC_LEFT_COLUMN
	db BANK(LyraPic)
	db 0
	dw MintPic tile CHARSELECT_PIC_LEFT_COLUMN
	db BANK(MintPic)
	db 0

TextJump_AreYouABoyOrAreYouAGirl:
	; Which trainer are you?
	text_far Text_AreYouABoyOrAreYouAGirl
	text_end

InitDifficulty:
	call InitGenderScreen
	call LoadGenderScreenPal
	call LoadGenderScreenLightBlueTile
	call WaitBGMap2
	call SetPalettes
	ld hl, TextJump_SelectDifficulty
	call PrintText
	ld hl, .MenuHeader
	call LoadMenuHeader
	call WaitBGMap2
	call VerticalMenu
	call CloseWindow
	ld a, [wMenuCursorY]
	dec a
	jr nz, .confirm_hard
	ld hl, TextJump_SelectDifficultyNormal
	call PrintText
	call YesNoBox
	jr c, InitDifficulty
	ld de, ENGINE_HARD_MODE
	ld b, RESET_FLAG
	farcall EngineFlagAction
	jr .done

.confirm_hard
	ld hl, TextJump_SelectDifficultyHard
	call PrintText
	call YesNoBox
	jr c, InitDifficulty
	ld de, ENGINE_HARD_MODE
	ld b, SET_FLAG
	farcall EngineFlagAction

.done
	ld c, 10
	call DelayFrames
	ret

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 5, 4, 14, 9
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP | STATICMENU_DISABLE_B ; flags
	db 2 ; items
	db "Normal@"
	db "Hard@"

TextJump_SelectDifficulty:
	text_far Text_SelectDifficulty
	text_end

TextJump_SelectDifficultyNormal:
	text_far Text_SelectDifficultyNormal
	text_end

TextJump_SelectDifficultyHard:
	text_far Text_SelectDifficultyHard
	text_end

InitPokemonTyping:
	call InitGenderScreen
	call LoadGenderScreenPal
	call LoadGenderScreenLightBlueTile
	call WaitBGMap2
	call SetPalettes
	ld hl, TextJump_SelectPokemonTyping
	call PrintText
	ld hl, .MenuHeader
	call LoadMenuHeader
	call WaitBGMap2
	call VerticalMenu
	call CloseWindow
	ld hl, wGameplayRules
	ld a, [wMenuCursorY]
	dec a
	jr nz, .revamped
	set GAMEPLAYRULES_ORIGINAL_TYPES_F, [hl]
	jr .done

.revamped
	res GAMEPLAYRULES_ORIGINAL_TYPES_F, [hl]

.done
	ld c, 10
	call DelayFrames
	ret

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 4, 4, 15, 9
	dw .MenuData
	db 2 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP | STATICMENU_DISABLE_B ; flags
	db 2 ; items
	db "Original@"
	db "Revamped@"

TextJump_SelectPokemonTyping:
	text_far Text_SelectPokemonTyping
	text_end

InitPokemonStats:
	call InitGenderScreen
	call LoadGenderScreenPal
	call LoadGenderScreenLightBlueTile
	call WaitBGMap2
	call SetPalettes
	ld hl, TextJump_SelectPokemonStats
	call PrintText
	ld hl, .MenuHeader
	call LoadMenuHeader
	call WaitBGMap2
	call VerticalMenu
	call CloseWindow
	ld hl, wGameplayRules
	ld a, [wMenuCursorY]
	dec a
	jr nz, .updated
	set GAMEPLAYRULES_ORIGINAL_STATS_F, [hl]
	jr .done

.updated
	res GAMEPLAYRULES_ORIGINAL_STATS_F, [hl]

.done
	ld c, 10
	call DelayFrames
	ret

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 4, 4, 15, 9
	dw .MenuData
	db 2 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP | STATICMENU_DISABLE_B ; flags
	db 2 ; items
	db "Original@"
	db "Updated@"

TextJump_SelectPokemonStats:
	text_far Text_SelectPokemonStats
	text_end

InitGenderScreen:
	ld a, $10
	ld [wMusicFade], a
	ld a, MUSIC_NONE
	ld [wMusicFadeID], a
	ld a, $0
	ld [wMusicFadeID + 1], a
	ld c, 8
	call DelayFrames
	call ClearBGPalettes
	call InitCrystalData
	call LoadFontsExtra
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $0
	call ByteFill
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	ret

LoadGenderScreenPal:
	ld hl, .Palette
	ld de, wBGPals1
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	farcall ApplyPals
	ret

.Palette:
INCLUDE "gfx/new_game/gender_screen.pal"

LoadGenderScreenLightBlueTile:
	ld de, .LightBlueTile
	ld hl, vTiles2 tile $00
	lb bc, BANK(.LightBlueTile), 1
	call Get2bpp
	ret

.LightBlueTile:
INCBIN "gfx/new_game/gender_screen.2bpp"

; Polished-style summary screen palettes and attribute map.
; Reached via farcall from the stats screen.
;
; BG palette usage on the stats screen:
;   0: HP bar palette (also plain white/black text)
;   1: mon frontpic palette
;   2: exp / friendship bar palette (original bar colors)
;   3: side panel palette   (panel fill, accent, white, black)
;   4: bottom panel palette (accent, panel fill, white, black)
;   5: type badge 1 / caught ball palette
;   6: type badge 2 palette
;   7: shiny star palette / type badge 3 on the green page
; OBJ palettes 0-3: the four page squares (pink, blue, green, orange).

LoadSummaryScreenPals::
; c = current page (PINK_PAGE to ORANGE_PAGE)
	ldh a, [hCGB]
	and a
	ret z
	ld a, c
	dec a
	ld [wBuffer6], a ; zero-based page

	; build BG palettes 2-7 in wSGBPals (used as scratch here)
	ld hl, SummaryBarPalette
	ld de, wSGBPals
	ld bc, 8
	call CopyBytes
	ld a, [wBuffer6]
	ld hl, SummaryPagePals
	ld bc, 24
	call AddNTimes
	ld de, wSGBPals + 8
	ld bc, 16
	call CopyBytes ; side + bottom panel palettes
	ld de, wSGBPals + 40
	ld bc, 8
	call CopyBytes ; shiny star palette
	ld hl, wSGBPals + 8
	ld de, wSGBPals + 24
	ld bc, 8
	call CopyBytes ; palette 5 default: same as side panel
	ld hl, wSGBPals + 8
	ld de, wSGBPals + 32
	ld bc, 8
	call CopyBytes ; palette 6 default: same as side panel

	call .BaseAttrs

	ld a, [wBuffer6]
	call .PageSetup

	; commit BG palettes 2-7
	ld hl, wSGBPals
	ld de, wBGPals1 palette 2
	ld bc, 6 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	ld hl, wSGBPals
	ld de, wBGPals2 palette 2
	ld bc, 6 palettes
	ld a, BANK(wBGPals2)
	call FarCopyWRAM

	; OBJ palettes for the page squares
	ld hl, SummarySquareOBPals
	ld de, wOBPals1
	ld bc, 4 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld hl, SummarySquareOBPals
	ld de, wOBPals2
	ld bc, 4 palettes
	ld a, BANK(wOBPals2)
	call FarCopyWRAM

	farcall ApplyAttrMap
	ld a, $1
	ldh [hCGBPalUpdate], a
	ret

.PageSetup:
	ld hl, .SetupJumptable
	rst JumpTable
	ret

.SetupJumptable:
	dw .PinkSetup
	dw .BlueSetup
	dw .GreenSetup
	dw .OrangeSetup

.BaseAttrs:
	; everything defaults to palette 0
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	; pokepic area keeps the mon palette
	hlcoord 0, 0, wAttrMap
	lb bc, 7, 7
	ld a, $1
	call .FillAttrBox
	; side panel
	hlcoord 7, 1, wAttrMap
	lb bc, 11, 13
	ld a, $3
	call .FillAttrBox
	; bottom panel
	hlcoord 0, 12, wAttrMap
	lb bc, 6, 20
	ld a, $4
	call .FillAttrBox
	; bottom tab hump
	ld a, [wBuffer6]
	ld hl, .TabLengths
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	add 2
	ld c, a
	ld b, 1
	hlcoord 1, 11, wAttrMap
	ld a, $4
	call .FillAttrBox
	ret

.TabLengths:
; label lengths: "Exp.", "Ability", "Item", "Friend"
	db 4, 7, 4, 6

.PinkSetup:
	; type badge palettes
	ld a, [wBaseType1]
	ld de, wSGBPals + 24
	call .SetBadgePal
	ld a, [wBaseType2]
	ld de, wSGBPals + 32
	call .SetBadgePal
	; badge attributes
	hlcoord 8, 4, wAttrMap
	lb bc, 1, 4
	ld a, $5
	call .FillAttrBox
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	jr z, .pink_one_type
	hlcoord 13, 4, wAttrMap
	lb bc, 1, 4
	ld a, $6
	call .FillAttrBox
.pink_one_type
	; shiny star cell
	hlcoord 18, 1, wAttrMap
	ld [hl], $7
	; exp bar row
	hlcoord 1, 17, wAttrMap
	lb bc, 1, 10
	ld a, $2
	call .FillAttrBox
	ret

.BlueSetup:
	; the HP bar keeps its original palette (slot 0)
	hlcoord 10, 2, wAttrMap
	lb bc, 1, 9
	xor a
	call .FillAttrBox
	ret

.GreenSetup:
	; assign badge palettes 5-7 to up to three distinct move types
	ld a, $ff
	ld [wBuffer1], a
	ld [wBuffer2], a
	ld [wBuffer3], a
	ld c, 0
.green_loop
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	and a
	ret z
	push bc
	ld de, wStringBuffer2
	call GetMoveData
	ld a, [wStringBuffer2 + MOVE_TYPE]
	ld e, a
	ld a, [wBuffer1]
	cp e
	ld d, $5
	jr z, .green_got_pal
	ld a, [wBuffer2]
	cp e
	ld d, $6
	jr z, .green_got_pal
	ld a, [wBuffer3]
	cp e
	ld d, $7
	jr z, .green_got_pal
	; new type: assign a free palette, if any
	ld a, [wBuffer1]
	inc a ; was it $ff?
	jr nz, .green_try_2
	ld a, e
	ld [wBuffer1], a
	push de
	ld de, wSGBPals + 24
	call .SetBadgePal_e
	pop de
	ld d, $5
	jr .green_got_pal
.green_try_2
	ld a, [wBuffer2]
	inc a
	jr nz, .green_try_3
	ld a, e
	ld [wBuffer2], a
	push de
	ld de, wSGBPals + 32
	call .SetBadgePal_e
	pop de
	ld d, $6
	jr .green_got_pal
.green_try_3
	ld a, [wBuffer3]
	inc a
	ld d, $3 ; no palette left: keep panel colors
	jr nz, .green_got_pal
	ld a, e
	ld [wBuffer3], a
	push de
	ld de, wSGBPals + 40
	call .SetBadgePal_e
	pop de
	ld d, $7
.green_got_pal
	; color the badge cells for move c with palette d
	pop bc
	push bc
	push de
	hlcoord 8, 2, wAttrMap
	ld a, c
	and a
	jr z, .green_got_row
	ld de, 2 * SCREEN_WIDTH
.green_row_loop
	add hl, de
	dec a
	jr nz, .green_row_loop
.green_got_row
	pop de
	ld a, d
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jp nz, .green_loop
	ret

.OrangeSetup:
	; caught ball palette (slot 5): panel fill, white, ball color, black
	ld hl, wSGBPals + 8 ; side panel color 0
	ld a, [hli]
	ld [wSGBPals + 24], a
	ld a, [hl]
	ld [wSGBPals + 25], a
	ld a, $ff ; white
	ld [wSGBPals + 26], a
	ld a, $7f
	ld [wSGBPals + 27], a
	ld a, [wTempMonPersonality]
	and CAUGHT_BALL_MASK
	cp NUM_CAUGHT_BALLS
	jr c, .ball_ok
	xor a
.ball_ok
	ld l, a
	ld h, 0
	add hl, hl
	ld de, SummaryBallColors
	add hl, de
	ld a, [hli]
	ld [wSGBPals + 28], a
	ld a, [hl]
	ld [wSGBPals + 29], a
	xor a ; black
	ld [wSGBPals + 30], a
	ld [wSGBPals + 31], a
	; attributes
	hlcoord 8, 8, wAttrMap
	ld [hl], $5
	hlcoord 1, 15, wAttrMap
	lb bc, 1, 8
	ld a, $2
	call .FillAttrBox
	ret

.SetBadgePal_e:
	ld a, e
	; fallthrough
.SetBadgePal:
; Build a type badge palette at de: badge color x3, then white text.
; a = type constant
	cp TYPES_END
	jr c, .type_ok
	xor a
.type_ok
	ld l, a
	ld h, 0
	add hl, hl
	ld bc, TypeBadgeColors
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld h, d
	ld l, e
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, $ff ; white
	ld [hli], a
	ld a, $7f
	ld [hl], a
	ret

.FillAttrBox:
; a = palette, hl = attr map address, b = rows, c = columns
	ld de, SCREEN_WIDTH
.attr_row
	push bc
	push hl
.attr_col
	ld [hli], a
	dec c
	jr nz, .attr_col
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .attr_row
	ret

SummaryBarPalette:
; the original exp bar colors
	RGB 31, 31, 31
	RGB 21, 25, 31
	RGB 6, 13, 31
	RGB 0, 0, 0

SummaryPagePals:
; per page: side panel palette, bottom panel palette, shiny star palette
	; pink page
	RGB 31, 26, 30 ; side: pale pink
	RGB 31, 15, 26 ; accent
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 31, 15, 26 ; bottom: vivid pink
	RGB 31, 26, 30
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 31, 26, 30 ; star: pale pink bg
	RGB 31, 31, 31
	RGB 31, 27, 6  ; yellow star
	RGB 0, 0, 0
	; blue (cyan) page
	RGB 24, 31, 31
	RGB 12, 27, 30
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 12, 27, 30
	RGB 24, 31, 31
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 24, 31, 31
	RGB 31, 31, 31
	RGB 31, 27, 6
	RGB 0, 0, 0
	; green page
	RGB 27, 31, 23
	RGB 16, 28, 10
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 16, 28, 10
	RGB 27, 31, 23
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 27, 31, 23
	RGB 31, 31, 31
	RGB 31, 27, 6
	RGB 0, 0, 0
	; orange page
	RGB 31, 28, 21
	RGB 31, 21, 9
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 31, 21, 9
	RGB 31, 28, 21
	RGB 31, 31, 31
	RGB 0, 0, 0
	RGB 31, 28, 21
	RGB 31, 31, 31
	RGB 31, 27, 6
	RGB 0, 0, 0

SummarySquareOBPals:
; page squares: transparent, white, page color, black
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 15, 26 ; pink
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 12, 27, 30 ; cyan
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 16, 28, 10 ; green
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 21, 9  ; orange
	RGB 0, 0, 0

TypeBadgeColors:
; one color per type constant, used as the badge background
	RGB 21, 21, 16 ; NORMAL
	RGB 25, 9, 8   ; FIGHTING
	RGB 17, 17, 29 ; FLYING
	RGB 20, 8, 20  ; POISON
	RGB 27, 21, 11 ; GROUND
	RGB 22, 18, 10 ; ROCK
	RGB 17, 17, 25 ; BIRD
	RGB 20, 22, 6  ; BUG
	RGB 13, 10, 18 ; GHOST
	RGB 21, 21, 24 ; STEEL
	RGB 15, 15, 15 ; TYPE_10
	RGB 15, 15, 15 ; TYPE_11
	RGB 15, 15, 15 ; TYPE_12
	RGB 15, 15, 15 ; TYPE_13
	RGB 15, 15, 15 ; TYPE_14
	RGB 15, 15, 15 ; TYPE_15
	RGB 15, 15, 15 ; TYPE_16
	RGB 15, 15, 15 ; TYPE_17
	RGB 15, 15, 15 ; TYPE_18
	RGB 13, 12, 13 ; CURSE_T
	RGB 30, 13, 5  ; FIRE
	RGB 10, 15, 30 ; WATER
	RGB 12, 25, 10 ; GRASS
	RGB 30, 25, 4  ; ELECTRIC
	RGB 30, 10, 16 ; PSYCHIC
	RGB 14, 26, 28 ; ICE
	RGB 13, 10, 28 ; DRAGON
	RGB 11, 9, 9   ; DARK
	RGB 29, 17, 24 ; FAIRY

SummaryBallColors:
; one color per CAUGHTBALL_* constant
	RGB 30, 7, 7   ; POKE (red)
	RGB 8, 12, 29  ; GREAT (blue)
	RGB 30, 25, 5  ; ULTRA (yellow)
	RGB 17, 9, 25  ; MASTER (purple)
	RGB 13, 14, 16 ; HEAVY (gray)
	RGB 22, 14, 6  ; LEVEL (brown)
	RGB 9, 18, 28  ; LURE (blue)
	RGB 30, 15, 5  ; FAST (orange)
	RGB 13, 26, 7  ; FRIEND (green)
	RGB 9, 10, 22  ; MOON (dark blue)
	RGB 30, 12, 20 ; LOVE (pink)
	RGB 24, 20, 12 ; PARK (tan)

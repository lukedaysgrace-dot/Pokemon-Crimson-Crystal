; Polished-style summary screen palettes and attribute map.
; Reached via farcall from the stats screen.
;
; BG palette usage on the stats screen:
;   0: HP bar palette (also plain white/black text)
;   1: mon frontpic palette
;   2: exp / friendship bar palette (original bar colors);
;      type icon 4 on the green page (no exp bar there)
;   3: side panel palette   (panel fill, accent, white, black)
;   4: bottom panel palette (accent, panel fill, white, black)
;   5: type icon 1 / caught ball palette
;   6: type icon 2 palette
;   7: Pokérus + shiny palette / type icon 3 on the green page
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

	; caught ball OBJ palette (slot 4). The party menu ball graphic
	; keeps its white areas in color 0 (transparent here, so the panel
	; shows through) and its fill in colors 1-2, matching the layout of
	; gfx/stats/caught_balls.pal. Built in wSGBPals, which is free again
	; now that the BG palettes have been committed.
	ld a, $ff ; white (unused color 0)
	ld [wSGBPals], a
	ld a, $7f
	ld [wSGBPals + 1], a
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
	ld [wSGBPals + 2], a
	ld [wSGBPals + 4], a
	ld a, [hl]
	ld [wSGBPals + 3], a
	ld [wSGBPals + 5], a
	xor a ; black
	ld [wSGBPals + 6], a
	ld [wSGBPals + 7], a
	ld hl, wSGBPals
	ld de, wOBPals1 palette 4
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld hl, wSGBPals
	ld de, wOBPals2 palette 4
	ld bc, 1 palettes
	ld a, BANK(wOBPals2)
	call FarCopyWRAM

	; The attribute map is pushed together with the tilemap by
	; HDMATransferAttrMapAndTileMapToWRAMBank3 (see StatsScreen_WaitAnim),
	; so pages switch in a single clean frame.
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
	; While a mon animation is running, its frames live in VRAM bank 1
	; and PokeAnim_SetVBank1 has flagged the pokepic cells accordingly
	; (attribute bit 3). Rebuilding the attribute map from scratch would
	; drop that flag, so the tilemap would keep pointing at animation
	; frames while the PPU fetched them from bank 0 -- which is what
	; corrupted the sprite when a page was switched mid-animation.
	; Carry the flag over, but only if the animation both owns the pic
	; (wcf64 bit 6) and has actually switched banks already.
	hlcoord 0, 0, wAttrMap
	ld a, [hl]
	ld e, a
	ld a, [wcf64]
	rrca ; bit 6 -> bit 5
	rrca ; -> bit 4
	rrca ; -> bit 3
	and e
	and 1 << 3
	or $1 ; pokepic palette
	ld e, a
	; everything defaults to palette 0
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	; pokepic area keeps the mon palette (and the VRAM bank flag)
	hlcoord 0, 0, wAttrMap
	lb bc, 7, 7
	ld a, e
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
	; bottom tab hump (fixed 6 cells, columns 1-6)
	hlcoord 1, 11, wAttrMap
	lb bc, 1, 6
	ld a, $4
	call .FillAttrBox
	ret

.PinkSetup:
	; type badge palettes
	ld a, [wBaseType1]
	ld de, wSGBPals + 24
	call .SetBadgePal
	ld a, [wBaseType2]
	ld de, wSGBPals + 32
	call .SetBadgePal
	; badge attributes
	hlcoord 8, 5, wAttrMap
	lb bc, 1, 4
	ld a, $5
	call .FillAttrBox
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	jr z, .pink_one_type
	hlcoord 13, 5, wAttrMap
	lb bc, 1, 4
	ld a, $6
	call .FillAttrBox
.pink_one_type
	; Pokérus and shiny sparkles cells
	hlcoord 16, 2, wAttrMap
	ld [hl], $7
	hlcoord 17, 2, wAttrMap
	ld [hl], $7
	hlcoord 18, 2, wAttrMap
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
	; count moves to pick the same layout rows as the stats screen
	; (keep these tables in sync with StatsScreen_GreenPage!)
	ld hl, wTempMonMoves
	ld b, 0
.green_count
	ld a, [hli]
	and a
	jr z, .green_counted
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .green_count
.green_counted
	; assign icon palettes 5/6/7/2 to up to four distinct move types
	ld a, $ff
	ld [wBuffer1], a
	ld [wBuffer2], a
	ld [wBuffer3], a
	ld [wBuffer4], a
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
	call .GetDisplayType
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
	ld a, [wBuffer4]
	cp e
	ld d, $2
	jr z, .green_got_pal
	; new type: assign a free palette, if any
	ld a, [wBuffer1]
	inc a ; was it $ff?
	jr nz, .green_try_2
	ld a, e
	ld [wBuffer1], a
	push de
	ld de, wSGBPals + 24
	call .SetBadgePal
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
	call .SetBadgePal
	pop de
	ld d, $6
	jr .green_got_pal
.green_try_3
	ld a, [wBuffer3]
	inc a
	jr nz, .green_try_4
	ld a, e
	ld [wBuffer3], a
	push de
	ld de, wSGBPals + 40
	call .SetBadgePal
	pop de
	ld d, $7
	jr .green_got_pal
.green_try_4
	ld a, [wBuffer4]
	inc a
	ld d, $3 ; no palette left (can't happen: 4 moves, 4 slots)
	jr nz, .green_got_pal
	ld a, e
	ld [wBuffer4], a
	push de
	ld de, wSGBPals + 0 ; palette 2: free on the green page (no exp bar)
	call .SetBadgePal
	pop de
	ld d, $2
.green_got_pal
	; color the icon cells for move c with palette d
	pop bc
	push bc
	push de
	; icon row = name row (2 + 2 * move index) + 1
	ld a, c
	add a
	add 3
	; hl = wAttrMap + row * SCREEN_WIDTH + column 8
	ld l, a
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de ; x5
	add hl, hl
	add hl, hl ; x20
	ld de, wAttrMap + 8
	add hl, de
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

.GetDisplayType:
; Return the display type (in a) for the move struct in wStringBuffer2;
; Hidden Power shows its computed type. Must match
; StatsScreen_GetMoveDisplayType in engine/pokemon/stats_screen.asm.
	ld a, [wStringBuffer2 + MOVE_EFFECT]
	cp EFFECT_HIDDEN_POWER
	ld a, [wStringBuffer2 + MOVE_TYPE]
	ret nz
	ld de, wTempMonHiddenPowerType
	ld bc, wTempMonAttack
	farcall GetHiddenPowerDisplayStats ; c = type
	ld a, c
	ret

.OrangeSetup:
	; friendship bar row (the shiny indicator is pink-page only)
	hlcoord 1, 15, wAttrMap
	lb bc, 1, 8
	ld a, $2
	call .FillAttrBox
	ret

.SetBadgePal:
; Build a type icon palette at de to match SummaryTypeIconGFX (2bpp):
;   color 0 = side panel fill, so the rounded padding around the pill
;             blends into the page instead of showing as a white block
;   color 1 = white (the pill's lettering)
;   color 3 = the type color (the pill body)
; The side panel palette is already staged at wSGBPals + 8 by the caller.
; a = type constant
	cp TYPES_END
	jr c, .type_ok
	xor a
.type_ok
	push af
	ld h, d
	ld l, e
	; color 0: panel fill
	ld a, [wSGBPals + 8]
	ld [hli], a
	ld a, [wSGBPals + 9]
	ld [hli], a
	; colors 1-2: white
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	; color 3: the type color
	pop af
	ld c, a
	ld b, 0
	push hl
	ld hl, TypeBadgeColors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	pop hl
	ld [hli], a
	ld a, b
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
	RGB 31, 26, 30 ; symbols: pale pink bg
	RGB 29, 07, 22 ; Pokérus
	RGB 4, 15, 31  ; blue shiny sparkles
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
	RGB 4, 15, 31
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
	RGB 4, 15, 31
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
	RGB 4, 15, 31
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

SetMasterBallOBPal::
; If wCurItem is a Master Ball, tint the battle ball palette
; (PAL_BATTLE_OB_GREEN, which BallColors assigns to it) purple.
; Called from GetBallAnimPal, so it handles rSVBK for wCurItem.
; Clobbers a, hl, de, bc.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wCurItem)
	ldh [rSVBK], a
	ld a, [wCurItem]
	ld e, a
	pop af
	ldh [rSVBK], a
	ld a, e
	cp MASTER_BALL
	ret nz
	ld hl, MasterBallPurplePal
	jr LoadBallAnimOBPal

RestoreBallOBPal::
; Restore the standard green battle object palette after a ball
; animation is done. Harmless if it was never tinted purple.
; Clobbers a, hl, de, bc.
	ld hl, BallAnimGreenPal
	; fallthrough

LoadBallAnimOBPal:
	push hl
	ld de, wOBPals1 palette PAL_BATTLE_OB_GREEN
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	pop hl
	ld de, wOBPals2 palette PAL_BATTLE_OB_GREEN
	ld bc, 1 palettes
	ld a, BANK(wOBPals2)
	call FarCopyWRAM
	ld a, $1
	ldh [hCGBPalUpdate], a
	ret

MasterBallPurplePal:
	RGB 31, 31, 31
	RGB 24, 14, 31
	RGB 14, 6, 22
	RGB 0, 0, 0

BallAnimGreenPal:
; must match the green entry in gfx/battle_anims/battle_anims.pal
	RGB 31, 31, 31
	RGB 12, 25, 1
	RGB 5, 14, 0
	RGB 0, 0, 0

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

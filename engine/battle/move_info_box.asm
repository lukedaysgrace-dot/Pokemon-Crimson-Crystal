BattleMoveInfoStats::
; Second half of the battle move info box (see MoveInfoBox in
; engine/battle/core.asm, which lives in a packed bank): prints the
; base power / accuracy line and draws the category icon + type
; colorbox, Polished Crystal-style.
	hlcoord 1, 10
	ld de, .PowAcc
	call PlaceString

; Get the displayed category (b), type (c) and power (d);
; Hidden Power shows its computed values instead of the base ones.
	ld a, [wPlayerMoveStructCategory]
	ld b, a
	ld a, [wPlayerMoveStructType]
	ld c, a
	ld a, [wPlayerMoveStructPower]
	ld d, a
	ld a, [wPlayerMoveStructEffect]
	cp EFFECT_HIDDEN_POWER
	jr nz, .got_display_stats
	ld hl, wBattleMonDVs
	call GetHiddenPowerDisplayStats
.got_display_stats
	ld a, b
	ld [wStringBuffer2], a     ; category
	ld a, c
	ld [wStringBuffer2 + 1], a ; type

; Base power ("---" for status moves and other powerless moves)
	ld a, d
	hlcoord 1, 10
	cp 2
	jr c, .no_power
	ld [wStringBuffer1], a
	ld de, wStringBuffer1
	lb bc, 1, 3
	call PrintNum
	jr .accuracy
.no_power
	ld de, .NA
	call PlaceString

.accuracy
	call PrintMoveAccuracyPercent

; Category icon (2 tiles, 2bpp) and type colorbox (4 tiles, 1bpp)
	farcall LoadBattleCategoryAndTypePals
	ld a, [wStringBuffer2]
	ld hl, CategoryIconGFX
	ld bc, 2 tiles
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $79
	lb bc, BANK(CategoryIconGFX), 2
	call Get2bpp_2
	ld a, [wStringBuffer2 + 1]
	ld hl, TypeIconGFX
	ld bc, 4 * LEN_1BPP_TILE
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $7b
	lb bc, BANK(TypeIconGFX), 4
	call Get1bpp_2
	hlcoord 1, 9
	ld b, 6
	ld a, $79
.icon_loop
	ld [hli], a
	inc a
	dec b
	jr nz, .icon_loop

; Point the icon row at the category/type palette. The Textbox call above
; reset the box's attributes to the text palette (and battle attr copies can
; do the same), so fix up both the wram attrmap and VRAM directly.
	hlcoord 1, 9, wAttrMap
	ld a, PAL_BATTLE_BG_TYPE_CAT
	ld b, 6
.attr_wram_loop
	ld [hli], a
	dec b
	jr nz, .attr_wram_loop
	ld a, $1
	ldh [rVBK], a
	ld hl, vBGMap0 + 9 * BG_MAP_WIDTH + 1
	ld de, 6 ; d = 0: loop counter guard, e = count
	ld b, 1 << 1 ; not in v/hblank
	ld c, LOW(rSTAT)
.attr_vram_loop
	di
.attr_vram_wait
	ldh a, [c]
	and b
	jr nz, .attr_vram_wait
	ld a, PAL_BATTLE_BG_TYPE_CAT
	ld [hli], a
	ei
	dec e
	jr nz, .attr_vram_loop
	xor a
	ldh [rVBK], a
	ret

.PowAcc:
	db "   <BOLD_P>/   <PCT>@"
.NA:
	db "---@"

; Battle anim engine functions that read the anim data tables.
; They live in the same bank as those tables ("Battle Anim Data") and are
; farcalled from the anim engine bank.

BattleAnimOAMUpdate:
	call InitBattleAnimBuffer
	call GetBattleAnimFrame
	ld a, h
	cp HIGH(OAMDOWAIT_COMMAND)
	jp z, .done
	cp HIGH(OAMDELANIM_COMMAND)
	jp z, .delete

	push hl
	ld hl, wBattleAnimTempOAMFlags
	ld a, [wBattleAnimTempFrameOAMFlags]
	xor [hl]
	and PRIORITY | Y_FLIP | X_FLIP
	ld [hl], a
	call .SetDynamicTileData
	pop hl

	push bc
	call GetBattleAnimOAMPointer
	ld a, [wBattleAnimTempTileID]
	add [hl] ; tile offset
	ld [wBattleAnimTempTileID], a
	inc hl
	ld a, [hli] ; oam data length
	ld c, a
	ld a, [hli] ; oam data pointer
	ld h, [hl]
	ld l, a
	ld a, [wBattleAnimOAMPointerLo]
	ld e, a
	ld d, HIGH(wVirtualOAM)

.loop
	; Y Coord
	ld a, [wBattleAnimTempYCoord]
	ld b, a
	ld a, [wBattleAnimTempYOffset]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, wBattleAnimTempOAMFlags
	bit OAM_Y_FLIP, [hl]
	jr z, .no_yflip
	add $8
	xor $ff
	inc a
.no_yflip
	pop hl
	add b
	ld [de], a

	; X Coord
	inc hl
	inc de
	ld a, [wBattleAnimTempXCoord]
	ld b, a
	ld a, [wBattleAnimTempXOffset]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, wBattleAnimTempOAMFlags
	bit OAM_X_FLIP, [hl]
	jr z, .no_xflip
	add $8
	xor $ff
	inc a
.no_xflip
	pop hl
	add b
	ld [de], a

	; Tile ID
	inc hl
	inc de
	ld a, [wBattleAnimTempTileID]
	add BATTLEANIM_BASE_TILE
	add [hl]
	ld [de], a

	; Attributes
	inc hl
	inc de
	ld a, [wBattleAnimTempOAMFlags]
	ld b, a
	ld a, [hl]
	xor b
	and PRIORITY | Y_FLIP | X_FLIP
	ld b, a
	ld a, [hl]
	and OBP_NUM
	or b
	ld b, a
	ld a, [wBattleAnimTempPalette]
	and PALETTE_MASK | VRAM_BANK_1
	or b
	ld [de], a

	inc hl
	inc de
	ld a, e
	ld [wBattleAnimOAMPointerLo], a
	cp LOW(wVirtualOAMEnd)
	jr nc, .exit_set_carry
	dec c
	jr nz, .loop
	pop bc
	jr .done

.delete
	call DeinitBattleAnimation_DataBank

.done
	and a
	ret

.exit_set_carry
	pop bc
	scf
	ret

.SetDynamicTileData:
; Ported from polishedcrystal (core.asm .SetDynamicTileData).
; A few framesets ("dynamic" framesets in PC) pick their orientation at
; runtime from BATTLEANIMSTRUCT_11 (PC's VAR3): bits 0-2 = direction octant,
; bit 3 = BG priority. Their GFX contain three base orientations ordered
; E (+$0 tiles), S (+$4), NE (+$8); the other five directions are produced
; by x/y-flipping one of those. STRUCT_11 is written by RadialInit,
; RadialMoveIn, DarkPulse and NightSlash. Without this hook Poison Jab /
; Dark Pulse needles all render as the unflipped E sprite and Bug Buzz's
; growing waves index the wrong tiles (offsets $fc/$f8 assume the NE +$8
; base), so the waves never appear.
; PC's dynamic framesets are a contiguous high range; CC's equivalents are
; scattered, so match them explicitly. All four are object-referenced and
; therefore < $100 (see POLISHED_ANIM_PORT_HANDOFF.md).
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID_HI
	add hl, bc
	ld a, [hl]
	and a
	ret nz
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	cp BATTLEANIMFRAMESET_PC_BUG_BUZZ
	jr z, .dynamic
	cp BATTLEANIMFRAMESET_PC_POISON_JAB
	jr z, .dynamic
	cp BATTLEANIMFRAMESET_PC_CUT_HORIZONTAL
	jr z, .dynamic
	cp BATTLEANIMFRAMESET_PC_SUCKER_PUNCH
	ret nz

.dynamic
	; Graphics are ordered in E S NE order.
	ld hl, BATTLEANIMSTRUCT_11
	add hl, bc
	ld a, [hl]

	; Perhaps set priority
	bit 3, a
	push af
	and $7
	add a
	add LOW(.dynamic_tile_data)
	ld l, a
	adc HIGH(.dynamic_tile_data)
	sub l
	ld h, a
	pop af

	; First, set XY flip.
	ld a, [hli]
	jr z, .no_priority
	or PRIORITY
.no_priority
	push hl
	ld hl, wBattleAnimTempOAMFlags
	xor [hl]
	ld [hl], a
	pop hl
	ld a, [hl]

	; Then, adjust tile ID
	ld hl, wBattleAnimTempTileID
	add [hl]
	ld [hl], a
	ret

.dynamic_tile_data
	db X_FLIP, $00 ; W
	db X_FLIP, $08 ; NW
	db Y_FLIP, $04 ; N
	db 0, $08 ; NE
	db Y_FLIP, $00 ; E
	db Y_FLIP, $08 ; SE
	db X_FLIP, $04 ; S
	db X_FLIP | Y_FLIP, $08 ; SW

InitBattleAnimBuffer:
	ld hl, BATTLEANIMSTRUCT_01
	add hl, bc
	ld a, [hl]

	and PRIORITY
	ld [wBattleAnimTempOAMFlags], a
	xor a
	ld [wBattleAnimTempFrameOAMFlags], a
	ld hl, BATTLEANIMSTRUCT_PALETTE
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTempPalette], a
	ld hl, BATTLEANIMSTRUCT_02
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTempField02], a
	ld hl, BATTLEANIMSTRUCT_TILEID
	add hl, bc
	ld a, [hli]
	ld [wBattleAnimTempTileID], a
	ld a, [hli]
	ld [wBattleAnimTempXCoord], a
	ld a, [hli]
	ld [wBattleAnimTempYCoord], a
	ld a, [hli]
	ld [wBattleAnimTempXOffset], a
	ld a, [hli]
	ld [wBattleAnimTempYOffset], a

	ldh a, [hBattleTurn]
	and a
	ret z

	ld hl, BATTLEANIMSTRUCT_01
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTempOAMFlags], a
	bit 0, [hl]
	ret z

	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hli]
	ld d, a
	ld a, (-10 * 8) + 4
	sub d
	ld [wBattleAnimTempXCoord], a
	ld a, [hli]
	ld d, a
	ld a, [wBattleAnimTempField02]
	cp $ff
	jr nz, .vertical_flip
	ld a, 5 * 8
	jr .done

.vertical_flip
	sub d
	push af
	push hl
	push bc
	ld hl, wFXAnimID
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld de, 2
	ld hl, .extra_offset_moves
	call IsInHalfwordArray
	pop bc
	pop hl
	pop de
	sbc a
	and -(1 * 8)
.done
	add a, d
	ld [wBattleAnimTempYCoord], a
	ld a, [hli]
	xor $ff
	inc a
	ld [wBattleAnimTempXOffset], a
	ret

.extra_offset_moves
	dw KINESIS
	dw SOFTBOILED
	dw MILK_DRINK
	dw -1

DeinitBattleAnimation_DataBank:
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld [hl], $0
	ret

GetBattleAnimFrame:
; Returns the current frame's OAM set id (16-bit) in hl.
; Special values (see framesets.asm): $fcff delanim, $fdff dowait,
; $feff restart, $ffff endanim.
.loop
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_frame
	dec [hl]
	call .GetPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	call .GetPointer
	inc hl
	inc hl
	jr .okay

.next_frame
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	inc [hl]
	call .GetPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp HIGH(OAMRESTART_COMMAND)
	jr z, .restart
	cp HIGH(OAMENDANIM_COMMAND)
	jr z, .repeat_last
	push hl
	call .GetPointer
	inc hl
	inc hl
	ld a, [hl]
	push hl
	and $ff ^ (Y_FLIP << 1 | X_FLIP << 1)
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	pop hl
.okay
	ld a, [hl]
	and Y_FLIP << 1 | X_FLIP << 1 ; The << 1 is compensated in the "oamframe" macro
	srl a
	ld [wBattleAnimTempFrameOAMFlags], a
	pop hl
	ret

.repeat_last
	xor a
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a

	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	dec [hl]
	dec [hl]
	jr .loop

.restart
	xor a
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	dec a
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], a
	jr .loop

.GetPointer:
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld e, [hl]
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID_HI
	add hl, bc
	ld d, [hl]
	ld hl, BattleAnimFrameData
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	; frame entries are 3 bytes wide
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld a, [hl]
	ld l, a
	add a
	add l
	ld l, a
	ld h, $0
	add hl, de
	ret

GetBattleAnimOAMPointer:
; hl = 16-bit OAM set id
	ld de, BattleAnimOAMData
	add hl, hl
	add hl, hl
	add hl, de
	ret

InitBattleAnimation:
	ld a, [wBattleObjectTempID]
	ld e, a
	ld a, [wBattleObjectTempIDHi]
	ld d, a
	ld hl, BattleAnimObjects
rept 7
	add hl, de
endr
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld a, [wLastAnimObjectIndex]
	ld [hli], a ; Index
	ld a, [de]
	inc de
	ld [hli], a ; 01
	ld a, [de]
	inc de
	ld [hli], a ; 02
	ld a, [de]
	inc de
	ld [hli], a ; Frameset ID (low)
	ld a, [de]
	inc de
	push af ; Frameset ID (high); stored at the end since the struct slot is last
	ld a, [de]
	inc de
	ld [hli], a ; Function
	ld a, [de]
	inc de
	ld [hli], a ; 05
	ld a, [de]
	call GetBattleAnimTileOffset
	ld [hli], a ; Tile ID
	ld a, [wBattleObjectTempXCoord]
	ld [hli], a ; X Coord
	ld a, [wBattleObjectTempYCoord]
	ld [hli], a ; Y Coord
	xor a
	ld [hli], a ; X Offset
	ld [hli], a ; Y Offset
	ld a, [wBattleObjectTempParam]
	ld [hli], a ; Param
	xor a
	ld [hli], a ; 0c
	dec a
	ld [hli], a ; 0d
	xor a
	ld [hli], a ; 0e
	ld [hli], a ; 0f
	ld [hl], a  ; 10
	pop af
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID_HI
	add hl, bc
	ld [hl], a ; Frameset ID (high)
	ret

GetBattleAnimTileOffset:
	push hl
	push bc
	ld hl, wBattleAnimTileDict
	ld b, a
	ld c, 10 / 2
.loop
	ld a, [hli]
	cp b
	jr z, .load
	inc hl
	dec c
	jr nz, .loop
	xor a
	jr .done

.load
	ld a, [hl]
.done
	pop bc
	pop hl
	ret

LoadBattleAnimGFX:
; Loads GFX set [wBattleAnimByte] to tile [wBattleAnimTemp0] of the anim
; VRAM region. Returns the set's tile count in c.
	; dest = vTiles0 tile (BATTLEANIM_BASE_TILE + [wBattleAnimTemp0])
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld de, vTiles0 tile BATTLEANIM_BASE_TILE
	add hl, de
	push hl
	ld a, [wBattleAnimByte] ; gfx id
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, AnimObjGFX
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	; vTiles0 from BATTLEANIM_BASE_TILE through tile $7f is the entire
	; animation-GFX region. Refuse a set that would spill into vTiles1, where
	; the battle font lives. Return carry so the command handler can discard
	; the corresponding tile-dictionary entry.
	ld a, [wBattleAnimTemp0]
	add c
	cp (vTiles1 - vTiles0) / LEN_2BPP_TILE - BATTLEANIM_BASE_TILE + 1
	jr nc, .overflow
	push bc
	call DecompressRequest2bpp
	pop bc
	and a
	ret

.overflow
	scf
	ret

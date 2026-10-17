; Object initialization and GFX loading share the object-table bank.

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

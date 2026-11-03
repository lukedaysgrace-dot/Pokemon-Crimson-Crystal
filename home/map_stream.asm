; Adapted from Polished Crystal's stream_map_part.asm (68ee7ee4412c5381).
; Unlike its decompressed WRAM tables, Crimson's metatiles and attributes
; live in independently banked ROM tables at arbitrary addresses. Read them
; here in ROM0, retaining the existing 40-byte queues and full-redraw path.
; No WRAM bank is changed and no surrounding/screen buffers are maintained.

StreamMapEdge::
	assert wTilesetBlocksAddress == wTilesetBlocksBank + 1
	assert wTilesetAttributesAddress == wTilesetAttributesBank + 1
	xor a
	ldh [hBGMapMode], a ; stale RAM tilemaps must not overwrite the VRAM cache
	ldh [hBGMapUpdate], a ; publish only after both planes and pointers are ready
	ldh a, [hROMBank]
	push af
	ld hl, wTilesetBlocksBank
	ld a, [hli]
	ld de, wBGMapBuffer
	call .plane
	ld hl, wTilesetAttributesBank
	ld a, [hli]
	ld de, wBGMapPalBuffer
	call .plane
	pop af
	rst Bankswitch
	ret

.plane
	rst Bankswitch
	ld a, [hli]
	ld [wTilesetDataAddress], a
	ld a, [hl]
	ld [wTilesetDataAddress + 1], a
	ld h, d
	ld l, e
	ld a, [wPlayerStepDirection]
	and a
	jr z, .down
	dec a
	jr z, .up
	dec a
	jr z, .left
	lb bc, 0, (SCREEN_WIDTH - 2) / 2
	jr .column
.left
	lb bc, 0, 0
.column
	ld a, SCREEN_HEIGHT / 2
	call StreamMapSetup
	jp StreamMapColumn
.down
	lb bc, (SCREEN_HEIGHT - 2) / 2, 0
	jr .row
.up
	lb bc, 0, 0
.row
	ld a, SCREEN_WIDTH / 2
	call StreamMapSetup
	jp StreamMapRow

StreamMapSetup:
; hl: destination, b/c: y/x in 2x2 units, a: quarter count.
; Return de: map block, c: quarter offset, b: quarter count.
	push af
	push hl
	ld a, [wMetatileStandingX]
	add c
	ld c, a
	ld a, [wMetatileStandingY]
	add b
	ld b, a
	and 1
	add a
	add a
	add a
	ld h, a
	ld a, c
	and 1
	add a
	or h
	push af
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	ld e, c
	ld d, 0
	add hl, de
	srl b
	jr z, .got_block
	ld a, [wMapWidth]
	add 6
	ld e, a
.block_row
	add hl, de
	dec b
	jr nz, .block_row
.got_block
	ld d, h
	ld e, l
	pop af
	ld c, a
	pop hl
	pop af
	ld b, a
	ret

StreamMapQuarter:
; Read the top row of one quarter; leave hl at its bottom row and de at
; the second destination byte. Shared by row/column loops to fit ROM0.
	ld a, [de]
	and a
	jr nz, .not_border
	ld a, [wMapBorderBlock]
.not_border
	push hl
	swap a
	ld l, a
	and $f
	ld h, a
	ld a, l
	and $f0
	or c
	ld l, a
	ld a, [wTilesetDataAddress]
	add l
	ld l, a
	ld a, [wTilesetDataAddress + 1]
	adc h
	ld h, a
	pop de ; destination; the source table is visible throughout this ROM0 loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc hl
	inc hl
	ret

stream_map_quarters: MACRO
.quarter
	push de
	call StreamMapQuarter
if !strcmp("\1", "column")
	inc de
else
	ld a, SCREEN_WIDTH - 1
	add e
	ld e, a
	adc d
	sub e
	ld d, a
endc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld h, d
	ld l, e
	pop de ; map block pointer
if !strcmp("\1", "column")
	inc hl
	ld a, c
	xor 8
	ld c, a
	and 8
	jr nz, .same_block
	ld a, [wMapWidth]
	add 6
	add e
	ld e, a
	adc d
	sub e
	ld d, a
else
	ld a, l
	sub SCREEN_WIDTH - 1
	ld l, a
	jr nc, .same_page
	dec h
.same_page
	ld a, c
	xor 2
	ld c, a
	and 2
	jr nz, .same_block
	inc de
endc
.same_block
	dec b
	jr nz, .quarter
	ret
ENDM

StreamMapRow:
	stream_map_quarters row

StreamMapColumn:
	stream_map_quarters column

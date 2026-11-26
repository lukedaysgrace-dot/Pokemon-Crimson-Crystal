BeastTriadLoadFlipProps:
	assert BeastTriadFlipPropsEnd - BeastTriadFlipProps == 2 * BT_FLIP_CARD_TILES tiles
	assert BT_FLIP_PAPER_OBJ + BT_FLIP_CARD_TILES <= $100
	lb bc, BANK(BeastTriadFlipProps), 2 * BT_FLIP_CARD_TILES
	ld de, BeastTriadFlipProps
	ld hl, vTiles0 + BT_FLIP_BACK_OBJ tiles
	jp Get2bpp

BeastTriadLoadFlipCards:
	; Stage all widths while the captured cards still show their old faces.
	ld hl, wBTFlipPals
	ld bc, 4 palettes
	xor a
	call ByteFill
	xor a
	ld [wBTDrawIndex], a
	ld [wBTFlipSlot], a
.cell:
	ld a, [wBTDrawIndex]
	ld c, a
	ld b, 0
	ld hl, wBTCapturedCells
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
	ld hl, wBTBoard
	add hl, bc
	ld a, [hl]
	push af
	add a
	add a
	ld c, a
	ld hl, wBTFaceColors
	add hl, bc
	ld a, [wBTFlipSlot]
	add a
	add a
	add a
	ld e, a
	ld d, 0
	push hl
	ld hl, wBTFlipPals + PAL_COLOR_SIZE
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, 2 * PAL_COLOR_SIZE
	call CopyBytes
	pop af
	call BeastTriadDeckCard
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc
	ld bc, BeastTriadFlipArtPointers
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	inc hl
	ld d, [hl]
	push af
	push de
	ld a, [wBTFlipSlot]
	call BeastTriadFlipCardTile
	ld l, a
	ld h, 0
	rept 4
		add hl, hl
	endr
	ld de, vTiles0
	add hl, de
	pop de
	pop af
	ld b, a
	ld c, BT_FLIP_CARD_TILES
	call Get2bpp
	ld hl, wBTFlipSlot
	inc [hl]
.next:
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_CELLS
	jr c, .cell
	ret

BeastTriadFlipCardTile:
	; A: captured card ordinal. Each has three sets of eight tiles.
	ld b, a
	add a
	add b
	; fallthrough
BeastTriadFlipPoseTile:
	rept 3
		add a
	endr
	ret

BeastTriadDrawFlipCell:
	; Eight 8x16 objects per card at most. The foreground uses three
	; face colors, and a paper layer behind it supplies the fourth color.
	ld a, [wBTFlipSlot]
	and a
	call z, ClearSprites
	ld a, [wBTDrawIndex]
	call BeastTriadCellXY
	ld a, d
	add a
	add d
	rept 3
		add a
	endr
	add BT_BOARD_COL * 8 + 4 + 8 ; board x, centered within the card, OAM x bias
	ld d, a
	ld a, e
	swap a
	add a
	add BT_BOARD_ROW * 8 + 16 ; board y and OAM y bias
	ld e, a
	ld a, [wBTFlipSlot]
	swap a
	add a
	ld l, a
	ld h, HIGH(wVirtualOAM)
	assert LOW(wVirtualOAM) == 0
	ld a, [wBTFlipWidth]
	call BeastTriadFlipPoseTile
	ld c, a
	ld a, [wBTAnimPhase]
	cp BT_FLIP_BACK_NARROW
	jr z, .back
	ld a, [wBTFlipSlot]
	call BeastTriadFlipCardTile
	add c
	ld b, a
	ld a, [wBTFlipSlot]
	ld c, a
	push de
	call .layer
	pop de
	ld a, [wBTFlipWidth]
	call BeastTriadFlipPoseTile
	add BT_FLIP_PAPER_OBJ
	ld b, a
	ld a, [wBTProbeOwner]
	ld c, a
	ld a, [wBTAnimPhase]
	cp BT_FLIP_FACE_NARROW
	ld a, c
	jr nz, .paper
	xor 1
.paper:
	add 4
	ld c, a
	jr .finish
.back:
	ld a, c
	add BT_FLIP_BACK_OBJ
	lb bc, 0, 6
	ld b, a
.finish:
	call .layer
	ld hl, wBTFlipSlot
	inc [hl]
	ret

.layer:
	call .row
	ld a, e
	add 16
	ld e, a
.row:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	inc b
	inc b
	ld a, e
	ld [hli], a
	ld a, d
	add 8
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	inc b
	inc b
	ret

BeastTriadCommitCardSprites:
	; Tilemaps, face palettes and card objects commit in the same VBlank.
	ld a, [wBTMode]
	cp BT_FOE_MOVE
	jr z, .visible
	ld a, [wBTFlipSlot]
	and a
	jr z, .hidden
.visible:
	ld a, $80
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
	ld hl, wBTFlipPals
	ld b, 4
	call .palettes
	ld hl, .shared_palettes
	ld b, 3
	call .palettes
	call hTransferVirtualOAM
	ldh a, [rLCDC]
	or (1 << rLCDC_SPRITES_ENABLE) | (1 << rLCDC_SPRITE_SIZE)
	ldh [rLCDC], a
	ret
.hidden:
	ldh a, [rLCDC]
	res rLCDC_SPRITES_ENABLE, a
	ldh [rLCDC], a
	ret
.palettes:
	rept 1 palettes
		ld a, [hli]
		ldh [c], a
	endr
	dec b
	jr nz, .palettes
	ret
.shared_palettes:
	dw 0, BT_BOARD_BLUE, 0, 0
	dw 0, BT_BOARD_RED, 0, 0
	dw 0
	RGB 30, 28, 25
	RGB 21, 16, 9
	RGB 6, 5, 5

BT_FOE_MOVE_FRAMES EQU 16
BT_FOE_MOVE_OBJ EQU BT_FLIP_PAPER_OBJ + BT_FLIP_CARD_TILES
assert BT_FOE_MOVE_OBJ + BT_CARD_TILES <= $100
assert BT_FOE_MOVE_OBJ % 2 == 0
assert 2 * BT_CARD_COLS <= 10 ; two layers of objects per scanline

BeastTriadMoveFoeCard:
	call BeastTriadLoadFoeMoveArt
	call ClearSprites
	ld a, BT_FOE_MOVE
	ld [wBTMode], a
	; D holds twice the OAM x so the middle column can move 3.5 px/frame.
	; E holds OAM y. C and B are the signed steps for D and E.
	ld a, [wBTProbeCell]
	call BeastTriadCellXY
	ld a, d
	add a
	add d
	add BT_BOARD_COL - BT_FOE_HAND_COL
	ld c, a
	ld a, [wBTFoeCursor]
	ld d, a
	ld a, e
	add a
	sub d
	ld b, a
	ld a, d
	swap a
	add BT_BOARD_ROW * 8 + 16
	ld e, a
	ld d, 2 * (BT_FOE_HAND_COL * 8 + 8)
	push bc
	push de
	call BeastTriadDrawFoeMoveSprite
	call BeastTriadRender
	pop de
	pop bc
	ld a, BT_FOE_MOVE_FRAMES
.step:
	push af
	ld a, d
	add c
	ld d, a
	ld a, e
	add b
	ld e, a
	push bc
	push de
	call BeastTriadDrawFoeMoveSprite
	; Only the sprite moves after the first frame. Leave the map and its
	; raster palettes alone until placement takes over at the destination.
	call BeastTriadLockVBlank
	call hTransferVirtualOAM
	ld a, b
	ldh [rIE], a
	ei
	pop de
	pop bc
	pop af
	dec a
	jr nz, .step
	ld a, -1
	ld [wBTFoeCursor], a
	ld a, BT_HAND
	ld [wBTMode], a
	ret

BeastTriadLoadFoeMoveArt:
	ld a, [wBTProbeCard]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, wBTFaceColors
	add hl, bc
	ld de, wBTFlipPals + PAL_COLOR_SIZE
	ld bc, 2 * PAL_COLOR_SIZE
	call CopyBytes
	xor a
	ld [de], a
	inc de
	ld [de], a ; black outline, matching the BG card
	ld hl, .tile_offsets
	ld de, wBTArtBuffer
.tile:
	ld a, [hli]
	cp -1
	jr z, .upload
	push hl
	push de
	push af
	ld a, [wBTProbeCard]
	call BeastTriadCardArtAddress
	pop af
	ld e, a
	ld d, 0
	add hl, de
	pop de
	ld a, b
	ld bc, 1 tiles
	call FarCopyBytes
	pop hl
	jr .tile
.upload:
	lb bc, BANK(BeastTriadLoadFoeMoveArt), BT_CARD_TILES
	ld de, wBTArtBuffer
	ld hl, vTiles0 + BT_FOE_MOVE_OBJ tiles
	jp Get2bpp
.tile_offsets:
	; Each 8x16 object needs two vertically adjacent tiles.
FOR row, 0, BT_CARD_ROWS, 2
	FOR col, 0, BT_CARD_COLS
		db (row * BT_CARD_COLS + col) tiles
		db ((row + 1) * BT_CARD_COLS + col) tiles
	ENDR
ENDR
	db -1

BeastTriadDrawFoeMoveSprite:
	srl d
	ld hl, wVirtualOAM
	ld b, BT_FOE_MOVE_OBJ
	call .row
	ld a, e
	add 16
	ld e, a
.row:
	push de
	ld c, BT_CARD_COLS
.column:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a ; face uses object palette 0
	ld [hli], a
	; The higher-priority face leaves color 0 transparent over solid red paper.
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, BT_FLIP_PAPER_OBJ
	ld [hli], a
	ld a, 5 ; red paper palette shared with capture flips
	ld [hli], a
	inc b
	inc b
	ld a, d
	add 8
	ld d, a
	dec c
	jr nz, .column
	pop de
	ret

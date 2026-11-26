; Palettes 0-2 are the table. The other five belong to the three board
; columns and the two hands. Update their colors on each tile boundary.
BT_RASTER_FIRST_ROW EQU BT_BOARD_ROW
BT_RASTER_ROWS EQU BT_BOARD_ROWS
BT_RASTER_BYTES_PER_PAL EQU 3 * PAL_COLOR_SIZE
BT_RASTER_ROW_BYTES EQU 32 ; five palettes and two padding bytes
BT_RASTER_SIZE EQU BT_RASTER_ROWS * BT_RASTER_ROW_BYTES
BT_RASTER_FIRST_LYC EQU 8 * BT_RASTER_FIRST_ROW - 2
BT_RASTER_LAST_LYC EQU 8 * (BT_RASTER_FIRST_ROW + BT_RASTER_ROWS - 1) - 2
BT_PRELOAD_BOARD_LYC EQU 8 * (BT_BOARD_ROW + BT_BOARD_ROWS) + 2
; Recolor the hand palette for the type symbol after the last card scanline.
BT_LABEL_LYC EQU 8 * (BT_BOARD_ROW + BT_BOARD_ROWS) - 1
BT_PRELOAD_HAND_LYC EQU 8 * 17 + 1
BT_RASTER_BUFFER_SIZE EQU BT_RASTER_SIZE + 2 * PAL_COLOR_SIZE

assert wBTRasterRows1 - wBTRasterRows0 == BT_RASTER_BUFFER_SIZE
assert wBTRasterRowsEnd - wBTRasterRows1 == BT_RASTER_BUFFER_SIZE

BeastTriadInitRaster:
	xor a
	ld [wBTRasterBuffer], a
	ld hl, wBeastTriadLCDCode
	ld de, wBTMapBlockBackup
	ld bc, BeastTriadLCDCode.End - BeastTriadLCDCode
	call CopyBytes
	ld hl, BeastTriadLCDCode
	ld de, wBeastTriadLCDCode
	ld bc, BeastTriadLCDCode.End - BeastTriadLCDCode
	call CopyBytes
	ld a, LOW(wBeastTriadLCDCode)
	ldh [hLCDInterruptFunctionTargetLo], a
	ld a, HIGH(wBeastTriadLCDCode)
	ldh [hLCDInterruptFunctionTargetHi], a
	ret

BeastTriadRestoreMapBlocks:
	ld hl, wBTMapBlockBackup
	ld de, wBeastTriadLCDCode
	ld bc, BeastTriadLCDCode.End - BeastTriadLCDCode
	jp CopyBytes

BeastTriadCommitFrame:
	; The tilemap, attribute map and the palette schedule must change in the
	; same VBlank, and the schedule's interrupts must keep running until then.
	; The shared commit routines wait for VBlank with interrupts disabled, so
	; on hardware the rows after that point could keep the previous card's
	; colors for a frame. Hold back only the VBlank interrupt here, copy
	; both maps with general-purpose DMA, swap the schedule, then let the
	; VBlank handler run.
	call BeastTriadPrepareRaster
	call BeastTriadPadMaps
	call BeastTriadLockVBlank
	ldh a, [rSVBK]
	ld c, a
	ld a, BANK(wScratchTileMap)
	ldh [rSVBK], a
	xor a
	ldh [rVBK], a
	ld hl, wScratchTileMap
	call .dma
	ld a, 1
	ldh [rVBK], a
	ld hl, wScratchAttrMap
	call .dma
	xor a
	ldh [rVBK], a
	ld a, c
	ldh [rSVBK], a
	; A card whose ranks changed for a type matchup gets its new art in
	; the same VBlank.
	ld a, [wBTArtPatch]
	and a
	jr z, .no_patch
	dec a
	ld e, a
	add a
	add e
	ld l, a
	ld h, 0
	rept 6
		add hl, hl
	endr
	ld de, vTiles2
	add hl, de
	ld a, HIGH(wBTArtBuffer)
	ldh [rHDMA1], a
	ld a, LOW(wBTArtBuffer)
	ldh [rHDMA2], a
	ld a, h
	and $1f
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ld a, BT_CARD_TILES - 1
	ldh [rHDMA5], a
	xor a
	ld [wBTArtPatch], a
.no_patch:
	push bc
	call BeastTriadCommitCardSprites
	pop bc
	ld a, [wBTRasterBuffer]
	xor 1
	ld [wBTRasterBuffer], a
	call BeastTriadRasterBufferAddress
	ld a, l
	ld [wBTRasterActive], a
	ld a, h
	ld [wBTRasterActive + 1], a
	; Write the first card row's colors now, during VBlank. A slow VBlank
	; handler (a song starting, say) can delay that row's interrupt past
	; its line, which would otherwise leave the previous frame's colors.
	ld c, LOW(rBGPD)
	ld d, $80 | (BT_BOARD_PAL * 8)
	rept 4
		ld a, d
		ldh [rBGPI], a
		rept BT_RASTER_BYTES_PER_PAL
			ld a, [hli]
			ldh [c], a
		endr
		ld a, d
		add 8
		ld d, a
	endr
	ld a, $80 | (BT_FOE_HAND_PAL * 8)
	ldh [rBGPI], a
	rept BT_RASTER_BYTES_PER_PAL
		ld a, [hli]
		ldh [c], a
	endr
	ld a, BT_RASTER_FIRST_LYC
	ldh [rLYC], a
	ld a, 1 << 6 ; LYC-only STAT interrupt
	ldh [rSTAT], a
	ld a, LCD_CUSTOM_HANDLER
	ldh [hLCDCPointer], a
	ld a, b
	ldh [rIE], a
	ei
	ret

.dma:
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ldh a, [hBGMapAddress + 1]
	and $1f
	ldh [rHDMA3], a
	ldh a, [hBGMapAddress]
	ldh [rHDMA4], a
	ld a, (BG_MAP_WIDTH * SCREEN_HEIGHT) / 16 - 1
	ldh [rHDMA5], a
	ret

BeastTriadLockVBlank:
	; Keep STAT running until the visible frame ends. Return with the
	; original interrupt mask in B and interrupts disabled for VRAM access.
	ldh a, [rIE]
	ld b, a
.wait_visible:
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .wait_visible
	ld a, b
	res VBLANK, a
	ldh [rIE], a
.wait_vblank:
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .wait_vblank
	di
	ret

BeastTriadPadMaps:
	; Copy both screen maps to 32-tile rows for the DMA.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wScratchTileMap)
	ldh [rSVBK], a
	ld hl, wTileMap
	ld de, wScratchTileMap
	call .copy
	ld hl, wAttrMap
	ld de, wScratchAttrMap
	call .copy
	pop af
	ldh [rSVBK], a
	ret
.copy:
	ld b, SCREEN_HEIGHT
.row:
	ld c, SCREEN_WIDTH
.byte:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .byte
	ld a, e
	add BG_MAP_WIDTH - SCREEN_WIDTH
	ld e, a
	jr nc, .next
	inc d
.next:
	dec b
	jr nz, .row
	ret

BeastTriadRasterBufferAddress:
	ld hl, wBTRasterRows0
	and a
	ret z
	ld hl, wBTRasterRows1
	ret

BeastTriadPrepareRaster:
	ld a, [wBTRasterBuffer]
	xor 1
	call BeastTriadRasterBufferAddress
	ld d, h
	ld e, l
	ld hl, wTileMap + BT_RASTER_FIRST_ROW * SCREEN_WIDTH
	ld b, BT_RASTER_ROWS
.row:
	push bc
	ld bc, BT_BOARD_COL
	add hl, bc
	call BeastTriadStageFacePalette
	ld bc, 3
	add hl, bc
	call BeastTriadStageFacePalette
	ld bc, 3
	add hl, bc
	call BeastTriadStageFacePalette
	ld bc, 4
	add hl, bc
	call BeastTriadStageFacePalette
	ld bc, BT_FOE_HAND_COL - BT_PLAYER_HAND_COL
	add hl, bc
	call BeastTriadStageFacePalette
	inc de
	inc de
	ld bc, SCREEN_WIDTH - BT_FOE_HAND_COL
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	; The label row: table paper, then the symbol's color.
	ld hl, BeastTriadPalettes
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [wBTLabelType]
	cp -1
	jr z, .paper
	add a
	ld c, a
	ld b, 0
	ld hl, BeastTriadTypeColors
	add hl, bc
.paper:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

BeastTriadStageFacePalette:
	; The center tile also stays visible during the flip. The static map
	; uses VRAM bank 1. Each group of BT_CARD_TILES in bank 0 is one card.
	push hl
	inc hl
	ld a, [hl]
	ld bc, wAttrMap - wTileMap
	add hl, bc
	bit 3, [hl]
	jr nz, .empty
	ld b, [hl]
	ld c, 0
.divide:
	cp BT_CARD_TILES
	jr c, .card
	sub BT_CARD_TILES
	inc c
	jr .divide
.card:
	; The selected prize glows in the hand even if the same card is on
	; the board. Its board copy keeps its owner's paper color.
	ld a, b
	cp BT_HAND_PAL
	jr nz, .owner
	ld a, [wBTMode]
	cp BT_PICK
	jr nz, .owner
	ld a, [wBTPickCursor]
	add BT_HAND_SIZE
	cp c
	ld a, BT_PAPER_HELD
	jr z, .paper
.owner:
	ld b, 0
	ld hl, wBTFaceOwners
	add hl, bc
	ld a, [hl]
.paper:
	ld b, 0
	push bc
	add a
	ld c, a
	ld hl, BeastTriadPaperColors
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	ld a, c
	add a
	add a
	ld c, a
	ld hl, wBTFaceColors
	add hl, bc
	ld bc, 2 * PAL_COLOR_SIZE
	call CopyBytes
	pop hl
	ret
.empty:
	xor a
	rept BT_RASTER_BYTES_PER_PAL
		ld [de], a
		inc de
	endr
	pop hl
	ret

BeastTriadPaperColors:
	RGB 30, 30, 24 ; player
	RGB 29, 23, 18 ; foe
	dw BT_BOARD_BLUE ; held or player-owned board card
	dw BT_BOARD_RED ; opponent-owned board card

; WRAM0 code for the STAT interrupt. Run phase 1 during the blank before
; the old card's solid black final row, which needs only untouched color
; 3. Phase 2 starts one line later since either fan can show a partial card.
; If flip objects shorten HBlank, writes can continue in the next Mode 2.
MACRO beast_tri_palette_bytes
	rept BT_RASTER_BYTES_PER_PAL
		ld a, [hli]
		ldh [c], a
	endr
ENDM

BeastTriadLCDCode:
	push bc
	push de
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBTRasterActive)
	ldh [rSVBK], a
	ldh a, [rLYC]
	ld b, a
	ldh a, [rLY]
	cp b
	jr z, .on_line
	; If a higher-priority interrupt deferred this phase, resume at
	; the next tile boundary, or at the first row of the next frame.
	ld e, a
	and $f8
	add 6
	cp e
	jr c, .advance_late
	jr nz, .set_late
.advance_late:
	add 8
.set_late:
	cp BT_RASTER_LAST_LYC + 1
	jr c, .resume
	ld a, BT_RASTER_FIRST_LYC
.resume:
	ldh [rLYC], a
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop af
	reti
.label:
	ld a, BT_PRELOAD_BOARD_LYC
	ldh [rLYC], a
	ld a, [wBTRasterActive]
	ld l, a
	ld a, [wBTRasterActive + 1]
	ld h, a
	ld de, BT_RASTER_SIZE
	add hl, de
	ld c, LOW(rBGPD)
	ld a, $80 | (BT_HAND_PAL * 8)
	ldh [rBGPI], a
.wait_label:
	ldh a, [rSTAT]
	and 3
	jr nz, .wait_label
	rept 2 * PAL_COLOR_SIZE
		ld a, [hli]
		ldh [c], a
	endr
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop af
	reti
.on_line:
	cp BT_LABEL_LYC
	jr z, .label
	cp BT_PRELOAD_BOARD_LYC
	jr z, .first_row
	cp BT_PRELOAD_HAND_LYC
	jr z, .first_row
	add 2
	srl a
	srl a
	srl a
	sub BT_RASTER_FIRST_ROW
	jr .row_offset
.first_row:
	; Preload the first row after the last use of each palette. A long
	; VBlank audio update can run past the first LYC of the next frame.
	xor a
.row_offset:
	ld l, a
	ld h, 0
	assert BT_RASTER_ROW_BYTES == 1 << 5
	rept 5
		add hl, hl
	endr
	ld a, [wBTRasterActive]
	ld e, a
	ld a, [wBTRasterActive + 1]
	ld d, a
	add hl, de
	ld c, LOW(rBGPD)
	assert BT_PRELOAD_BOARD_LYC % 2 == 0 && BT_PRELOAD_HAND_LYC % 2 == 1
	bit 0, b
	jr nz, .hand
	ld a, b
	cp BT_PRELOAD_BOARD_LYC
	ld a, BT_PRELOAD_HAND_LYC
	jr z, .next_board
	ld a, b
	inc a
.next_board:
	ldh [rLYC], a
	ld a, $80 | (BT_BOARD_PAL * 8)
	ldh [rBGPI], a
.wait_board:
	ldh a, [rSTAT]
	and 3
	jr nz, .wait_board
	beast_tri_palette_bytes
	ld a, $80 | ((BT_BOARD_PAL + 1) * 8)
	ldh [rBGPI], a
	beast_tri_palette_bytes
	ld a, $80 | ((BT_BOARD_PAL + 2) * 8)
	ldh [rBGPI], a
	beast_tri_palette_bytes
	jr .done
.hand:
	ld de, 3 * BT_RASTER_BYTES_PER_PAL
	add hl, de
	ld a, b
	cp BT_PRELOAD_HAND_LYC
	ld a, BT_RASTER_FIRST_LYC
	jr z, .next_row
	ld a, b
	add 7
	cp BT_RASTER_LAST_LYC + 1
	jr c, .next_row
	ld a, BT_LABEL_LYC
.next_row:
	ldh [rLYC], a
	ld a, $80 | (BT_HAND_PAL * 8)
	ldh [rBGPI], a
.wait_hand:
	ldh a, [rSTAT]
	and 3
	jr nz, .wait_hand
	beast_tri_palette_bytes
	ld a, $80 | (BT_FOE_HAND_PAL * 8)
	ldh [rBGPI], a
	beast_tri_palette_bytes
.done:
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop af
	reti
.End:
	assert .End - BeastTriadLCDCode <= wBeastTriadLCDCodeEnd - wBeastTriadLCDCode

PURGE beast_tri_palette_bytes

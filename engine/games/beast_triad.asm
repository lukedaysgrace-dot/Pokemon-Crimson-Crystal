BT_CASE EQU 0
BT_HAND EQU 1
BT_HELD EQU 2
BT_RESULT EQU 3
BT_EXIT EQU 4
BT_ANIM EQU 5
BT_PICK EQU 6
BT_PLAYER EQU 0
BT_FOE EQU 1
BT_HAND_SIZE EQU BEAST_TRIAD_DECK_SIZE
BT_DECK_SIZE EQU 2 * BT_HAND_SIZE
BT_CELLS EQU 9
BT_CARD_COLS EQU 3
BT_CARD_ROWS EQU 4
BT_CARD_TILES EQU BT_CARD_COLS * BT_CARD_ROWS
assert BT_CARD_TILES * BT_DECK_SIZE <= $80
BT_FOE_HAND_PAL EQU 3
BT_BOARD_PAL EQU 4 ; one palette per board column
BT_HAND_PAL EQU 7
BT_PAPER_PLAYER EQU 0
BT_PAPER_FOE EQU 1
BT_PAPER_HELD EQU 2
BT_PAPER_BOARD_PLAYER EQU BT_PAPER_HELD
BT_PAPER_BOARD_FOE EQU 3
BT_BOARD_BLUE EQU 25 | (29 << 5) | (30 << 10)
BT_BOARD_RED EQU 31 | (20 << 5) | (19 << 10)
; Full faces use the tilemap. The narrow phases use transparent objects.
BT_FLIP_FACE EQU 1
BT_FLIP_FACE_NARROW EQU 2
BT_FLIP_BACK EQU 3
BT_FLIP_BACK_NARROW EQU 4
BT_FLIP_REVEAL EQU 5
BT_FLIP_REVEAL_NARROW EQU 6
BT_FLIP_TYPE EQU 7
BT_FLIP_WIDTHS EQU 3
BT_FLIP_POSE_TILES EQU 8
BT_FLIP_CARD_TILES EQU BT_FLIP_WIDTHS * BT_FLIP_POSE_TILES
BT_FLIP_BACK_OBJ EQU 4 * BT_FLIP_CARD_TILES
BT_FLIP_PAPER_OBJ EQU BT_FLIP_BACK_OBJ + BT_FLIP_CARD_TILES
; Card Case art slots. Each preview alternates between two slots so new
; art loads into a slot that is not on screen.
BT_PREVIEW_SLOT EQU 0
BT_HELD_PREVIEW_SLOT EQU 2
BT_CASE_DECK_ROW EQU 3
BT_CASE_TRUNK_ROW EQU 9
BT_TRUNK_ROWS EQU 6

_BeastTriadCase::
	xor a
	jr BeastTriadEnter

_BeastTriad::
	; The Game Corner host plays the regular theme without a character card.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBTFoeCard)
	ldh [rSVBK], a
	ld a, -1
	ld [wBTFoeCard], a
	ld [wBTFoeCard + 1], a
	ld a, MUSIC_BEAST_TRIAD_DUEL
	ld [wBTFoeMusic], a
	pop af
	ldh [rSVBK], a
	; fallthrough

BeastTriadMatch:
	; Set wBTFoeCard and wBTFoeMusic first: a character's own card joins
	; the foe's hand, and MUSIC_BEAST_TRIAD_BOSS is their theme.
	ld a, BT_HAND
BeastTriadEnter:
	push af
	ldh a, [rSVBK]
	ld b, a
	pop af
	push bc
	ld c, a
	ld a, BANK(wBTMode)
	ldh [rSVBK], a
	ld a, c
	ld [wBTMode], a
	ld [wBTEntry], a
	ldh a, [hMapAnims]
	push af
	ldh a, [hBGMapAddress + 1]
	push af
	ldh a, [hBGMapAddress]
	push af
	ldh a, [hSCX]
	push af
	ldh a, [hSCY]
	push af
	ldh a, [rLCDC]
	push af
	ldh a, [hLCDCPointer]
	push af
	ldh a, [rSTAT]
	and $78
	push af
	ldh a, [rLYC]
	push af
	ldh a, [hLCDInterruptFunctionTargetLo]
	push af
	ldh a, [hLCDInterruptFunctionTargetHi]
	push af
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	xor a
	ldh [hLCDCPointer], a
	ldh [hMapAnims], a
	ldh [hBGMapMode], a
	ldh [hBGMapAddress], a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, HIGH(vBGMap0)
	ldh [hBGMapAddress + 1], a
	call BeastTriadInitCollection
	xor a
	ld [wBTAnimPhase], a
	ld [wBTFlipSlot], a
	ld [wBTLastDirection], a
	call BeastTriadInitRaster
	call ClearSprites
	call DisableLCD
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rLCDC], a
	ld a, 1
	ldh [rVBK], a
	ld hl, BeastTriadStaticGFX
	ld de, vTiles1
	ld bc, BeastTriadStaticGFXEnd - BeastTriadStaticGFX
	ld a, BANK(BeastTriadStaticGFX)
	call FarCopyBytes
	xor a
	ldh [rVBK], a
	call BeastTriadLoadPalettes
	ld a, [wBTMode]
	cp BT_CASE
	jr z, .case
	call BeastTriadLoadFlipProps
	call BeastTriadStartMatch
	jr .show
.case:
	call BeastTriadInitCase
.show:
	ld a, 1 << rLCDC_BG_PRIORITY
	ldh [rLCDC], a
	call EnableLCD
	call BeastTriadRender
	; Don't accept the A press that opened the table or item.
	call GetJoypad
	; The Card Case keeps the map's music.
	ld a, [wBTEntry]
	and a
	call nz, BeastTriadPlayFoeMusic
	jr .turn
.loop:
	call DelayFrame
	call BeastTriadInput
	jr z, .loop
	ld a, [wBTMode]
	ld hl, .handlers
	rst JumpTable
	ld a, [wBTMode]
	cp BT_EXIT
	jr z, .quit
	call BeastTriadRender
.turn:
	ld a, [wBTMode]
	cp BT_HAND
	jr nz, .loop
	ld a, [wBTTurn]
	and a
	jr z, .loop
	call BeastTriadFoeTurn
	call BeastTriadRender
	jr .loop
.quit:
	; Finish the visible frame with its raster colors, then blank the table
	; before returning control to the map or pack.
	call BeastTriadLockVBlank
	push bc
	xor a
	ldh [hLCDCPointer], a
	ldh [rSTAT], a
	call ClearPalettes
	call ForceUpdateCGBPals
	pop bc
	ld a, b
	ldh [rIE], a
	ei
	call WaitBGMap
	call BeastTriadRestoreMapBlocks
	call ClearSprites
	ld a, [wBTEntry]
	ld d, a
	pop af
	ldh [hOAMUpdate], a
	pop af
	ldh [hLCDInterruptFunctionTargetHi], a
	pop af
	ldh [hLCDInterruptFunctionTargetLo], a
	pop af
	ldh [rLYC], a
	pop af
	ldh [rSTAT], a
	pop af
	ldh [hLCDCPointer], a
	pop af
	ldh [rLCDC], a
	pop af
	ldh [hSCY], a
	pop af
	ldh [hSCX], a
	pop af
	ldh [hBGMapAddress], a
	pop af
	ldh [hBGMapAddress + 1], a
	pop af
	ldh [hMapAnims], a
	pop bc
	ld a, b
	ldh [rSVBK], a
	ld a, d
	and a
	ret z
	ld a, [wMapMusic]
	ld e, a
	ld d, 0
	jp PlayMusic
.handlers:
	dw BeastTriadCaseInput
	dw BeastTriadHandInput
	dw BeastTriadHeldInput
	dw BeastTriadResultInput
	dw BeastTriadQuit ; BT_EXIT
	dw BeastTriadQuit ; BT_ANIM
	dw BeastTriadPickInput

BeastTriadPlayFoeMusic:
	ld a, [wBTFoeMusic]
	ld e, a
	ld d, 0
	jp PlayMusic

BeastTriadInput:
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON | B_BUTTON | START | SELECT
	jr nz, .done
	ldh a, [hJoyDown]
	and D_UP | D_DOWN | D_LEFT | D_RIGHT
	ld hl, wBTLastDirection
	cp [hl]
	ld [hl], a
	jr nz, .new_direction
	and a
	ret z
	ld hl, wBTRepeat
	dec [hl]
	jr nz, .none
	ld [hl], 5
	jr .done
.new_direction:
	ld hl, wBTRepeat
	ld [hl], 12
.done:
	ld b, a
	and a
	ret
.none:
	xor a
	ret

BeastTriadQuit:
	ld a, BT_EXIT
	ld [wBTMode], a
	ret

BeastTriadInvalid:
	ld de, SFX_WRONG
	jp PlaySFX

BeastTriadHandInput:
	ld a, b
	and B_BUTTON
	jp nz, BeastTriadQuit
	ld a, b
	and A_BUTTON
	jr nz, .hold
	ld a, b
	and SELECT
	jr nz, BeastTriadInspectFoe
	ld a, b
	and D_UP | D_LEFT
	jr nz, .prev
	ld a, b
	and D_DOWN | D_RIGHT
	ret z
	call .clear_inspection
	jp BeastTriadNextHand
.prev:
	call .clear_inspection
	ld de, -1
	jr BeastTriadStepHand
.hold:
	call .clear_inspection
	ld a, BT_HELD
	ld [wBTMode], a
	ld a, [wBTBoardCursor]
	call BeastTriadBoardCell
	cp -1
	ret z
	; The last cell played is taken. Start from the first free cell.
	ld hl, wBTBoard
	xor a
.free:
	inc a
	ld b, a
	ld a, [hli]
	cp -1
	ld a, b
	jr nz, .free
	dec a
	ld [wBTBoardCursor], a
	ret
.clear_inspection:
	ld a, -1
	ld [wBTFoeCursor], a
	ret

BeastTriadInspectFoe:
	ld a, [wBTFoeCursor]
.next:
	inc a
	cp BT_HAND_SIZE
	jr nc, .clear
	ld c, a
	ld b, 0
	ld hl, wBTUsed + BT_HAND_SIZE
	add hl, bc
	ld a, [hl]
	and a
	ld a, c
	jr nz, .next
	jr .store
.clear:
	ld a, -1
.store:
	ld [wBTFoeCursor], a
	ret

BeastTriadNextHand:
	ld de, 1
BeastTriadStepHand:
	ld a, [wBTPlayerHand]
	and a
	ret z
	ld a, [wBTHandCursor]
.loop:
	add e
	cp -1
	jr nz, .check_upper
	ld a, BT_HAND_SIZE - 1
.check_upper:
	cp BT_HAND_SIZE
	jr c, .check_used
	xor a
.check_used:
	ld hl, wBTUsed
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and a
	ld a, c
	jr nz, .loop
	ld [wBTHandCursor], a
	ret

BeastTriadHeldInput:
	ld a, b
	and B_BUTTON
	jr nz, .cancel
	ld a, b
	and A_BUTTON
	jr nz, .place
	ld a, b
	and D_UP
	ld c, 0
	jr nz, BeastTriadSeekFreeCell
	ld a, b
	and D_RIGHT
	ld c, 1
	jr nz, BeastTriadSeekFreeCell
	ld a, b
	and D_DOWN
	ld c, 2
	jr nz, BeastTriadSeekFreeCell
	ld a, b
	and D_LEFT
	ld c, 3
	ret z
	jr BeastTriadSeekFreeCell
.cancel:
	ld a, BT_HAND
	ld [wBTMode], a
	ret
.place:
	ld a, [wBTBoardCursor]
	ld [wBTProbeCell], a
	call BeastTriadBoardCell
	cp -1
	jp nz, BeastTriadInvalid
	ld a, [wBTHandCursor]
	ld [wBTProbeCard], a
	xor a
	ld [wBTProbeOwner], a
	call BeastTriadPlace
	call BeastTriadNextHand
	jp BeastTriadAfterMove

BeastTriadSeekFreeCell:
; C: direction (up, right, down, left). The held card only ever rests on an
; empty cell: move to the nearest empty cell that way, wrapping around the
; board, preferring the current row or column. Stay put if there is none.
	ld a, c
	ld [wBTDirection], a
	ld a, -1
	ld [wBTBestCell], a
	ld [wBTBestScore], a
	xor a
	ld [wBTLoopCell], a
.cell:
	ld a, [wBTLoopCell]
	call BeastTriadBoardCell
	cp -1
	jr nz, .next
	ld a, [wBTLoopCell]
	call BeastTriadCellXY
	push de
	ld a, [wBTBoardCursor]
	call BeastTriadCellXY
	pop hl
	; H, L: target column and row. D, E: cursor column and row.
	ld a, [wBTDirection]
	bit 0, a
	jr nz, .horizontal
	ld b, l
	ld c, e
	ld a, h
	sub d
	jr .side
.horizontal:
	ld b, h
	ld c, d
	ld a, l
	sub e
.side:
	bit 7, a
	jr z, .positive_side
	cpl
	inc a
.positive_side:
	ld e, a
	; Steps forward, counting around the edge of the board.
	ld a, [wBTDirection]
	dec a
	cp 2
	ld a, b
	jr c, .ahead
	ld a, c
	sub b
	jr .wrap
.ahead:
	sub c
.wrap:
	jr nc, .forward
	add 3
.forward:
	and a
	jr z, .next
	add a
	add a
	add e
	ld b, a
	ld a, [wBTBestScore]
	cp b
	jr c, .next
	jr z, .next
	ld a, b
	ld [wBTBestScore], a
	ld a, [wBTLoopCell]
	ld [wBTBestCell], a
.next:
	ld hl, wBTLoopCell
	inc [hl]
	ld a, [hl]
	cp BT_CELLS
	jr c, .cell
	ld a, [wBTBestCell]
	cp -1
	ret z
	ld [wBTBoardCursor], a
	ret

BeastTriadCellXY:
; A: cell. Returns D: column, E: row.
	ld e, 0
.row:
	cp 3
	jr c, .done
	sub 3
	inc e
	jr .row
.done:
	ld d, a
	ret

BeastTriadPickInput:
	ld a, b
	and A_BUTTON
	jp nz, BeastTriadTakePrize
	ld a, b
	and D_UP | D_LEFT
	ld c, -1
	jr nz, .move
	ld a, b
	and D_DOWN | D_RIGHT
	ret z
	ld c, 1
.move:
	ld a, [wBTPickCursor]
	add c
	cp -1
	jr nz, .upper
	ld a, BT_HAND_SIZE - 1
.upper:
	cp BT_HAND_SIZE
	jr c, .set
	xor a
.set:
	ld [wBTPickCursor], a
	ret

BeastTriadResultInput:
	ld a, b
	and B_BUTTON
	jp nz, BeastTriadQuit
	ld a, b
	and A_BUTTON | START
	ret z
	; Clear the cards off the table before their art is replaced.
	call BeastTriadDrawTable
	ld hl, BeastTriadShuffleText
	ld de, wTileMap + BT_COMMAND
	call BeastTriadPrint
	call BeastTriadCommitFrame
	call BeastTriadStartMatch
	jp BeastTriadPlayFoeMusic

INCLUDE "engine/games/beast_triad/collection.asm"
INCLUDE "engine/games/beast_triad/case.asm"
INCLUDE "engine/games/beast_triad/rules.asm"
INCLUDE "engine/games/beast_triad/screen.asm"
INCLUDE "engine/games/beast_triad/flip.asm"
INCLUDE "engine/games/beast_triad/raster.asm"

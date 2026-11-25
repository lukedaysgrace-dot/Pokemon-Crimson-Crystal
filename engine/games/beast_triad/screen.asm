BT_TOP_SCORE EQU SCREEN_WIDTH
BT_LABEL EQU 16 * SCREEN_WIDTH + 1
BT_COMMAND EQU 17 * SCREEN_WIDTH + 1
BT_BOARD_ROW EQU 3
BT_BOARD_ROWS EQU 3 * BT_CARD_ROWS
BT_FOE_HAND_COL EQU 1
BT_PLAYER_HAND_COL EQU 15
BT_CASE_PREVIEW EQU 3 * SCREEN_WIDTH + 15
BT_CASE_HELD_PREVIEW EQU 10 * SCREEN_WIDTH + 15
BT_TEXT_ATTR EQU $8 ; static tiles, table palette
BT_CURSOR_ATTR EQU $9 ; static tiles, gold palette
BT_HELD_ATTR EQU $a ; static tiles, blue palette

BeastTriadLoadPalettes:
	ld a, [wBTMode]
	ld b, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	push bc
	ld hl, BeastTriadPalettes
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	ld hl, BeastTriadPalettes
	ld de, wBGPals2
	ld bc, 8 palettes
	call CopyBytes
	; The Card Case has no table art. Its two highlight rows get clearer
	; paper: gold for the cursor, blue for the held card.
	pop bc
	ld a, b
	and a
	jr nz, .update
	ld hl, BeastTriadCaseHighlights
	ld de, wBGPals1 + 1 palettes
	call .highlight
	ld hl, BeastTriadCaseHighlights
	ld de, wBGPals2 + 1 palettes
	call .highlight
.update:
	call ForceUpdateCGBPals
	pop af
	ldh [rSVBK], a
	ret

.highlight:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add 1 palettes - 1
	ld e, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

BeastTriadCaseHighlights:
	RGB 31, 25, 10
	RGB 19, 26, 31

BeastTriadLoadSlotArt:
	; HL: catalogue index. A: art slot. Load its colors and art.
	push af
	push hl
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, wBTFaceColors
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	call BeastTriadReadFaceColors
	pop hl
	call BeastTriadGetRecord
	pop af
	call BeastTriadTileForCard
	jr BeastTriadLoadCardArt

BeastTriadLoadMatchArt:
	xor a
	ld [wBTDrawIndex], a
.next:
	ld a, [wBTDrawIndex]
	call BeastTriadDeckCard
	push hl
	ld a, [wBTDrawIndex]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, wBTFaceColors
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	call BeastTriadReadFaceColors
	pop hl
	push hl
	ld de, BeastTriadCardTypes
	add hl, de
	ld a, [wBTDrawIndex]
	ld e, a
	ld d, 0
	ld a, [hl]
	ld hl, wBTTypes
	add hl, de
	ld [hl], a
	pop hl
	call BeastTriadGetRecord
	push hl
	ld a, [wBTDrawIndex]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, wBTRanks
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	ld bc, 4
	call CopyBytes
	pop hl
	ld a, [wBTDrawIndex]
	call BeastTriadTileForCard
	call BeastTriadLoadCardArt
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_DECK_SIZE
	jr c, .next
	ret

BeastTriadLoadCardArt:
	; HL: catalogue record. A: first VRAM tile.
	push af
	ld de, 14
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop af
	ld l, a
	ld h, 0
	rept 4
		add hl, hl
	endr
	ld a, HIGH(vTiles2)
	add h
	ld h, a
	ld c, BT_CARD_TILES
	jp Get2bpp

BeastTriadReadFaceColors:
	; HL: catalogue index; DE: two colors. Use the same normal palettes
	; as the game's menu icons, including the special Jirachi index.
	ld a, h
	and a
	jr nz, .trainer
	ld a, l
	cp 251
	jr c, .pokemon
	jr nz, .trainer
	ld hl, JIRACHI - 1
.pokemon:
	inc hl
	rept 3
		add hl, hl
	endr
	ld bc, PokemonPalettes
	add hl, bc
	ld bc, 4
	ld a, BANK(PokemonPalettes)
	jp FarCopyBytes
.trainer:
	ld bc, -252
	add hl, bc
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc
	ld bc, BeastTriadTrainerColors
	add hl, bc
	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, 4
	pop af
	jp FarCopyBytes

BeastTriadDrawTable:
	ld a, -1
	ld [wBTLabelType], a
	ld hl, BeastTriadScreenTiles
	ld de, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyBytes
	ld hl, BeastTriadScreenAttrs
	ld de, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyBytes

BeastTriadRender:
	call BeastTriadDrawTable
	ld a, [wBTMode]
	cp BT_HAND
	jr nc, .match
	call BeastTriadDrawCase
	jp BeastTriadCommitFrame
.match:
	call BeastTriadDrawScore
	call BeastTriadDrawBoard
	ld a, [wBTMode]
	cp BT_PICK
	jp z, .pick
	call BeastTriadDrawFoeHand
	call BeastTriadDrawHand
	ld a, [wBTMode]
	cp BT_ANIM
	jr z, .capture
	cp BT_RESULT
	jp z, .result
	cp BT_HELD
	jr z, .held
	ld a, [wBTTurn]
	and a
	jr nz, .foe
	call BeastTriadDrawSelectionName
	ld hl, BeastTriadChooseText
	jp .command
.foe:
	ld a, [wBTFoeCursor]
	cp -1
	call nz, BeastTriadDrawFoeName
	ld hl, BeastTriadFoeTurnText
	jr .command
.capture:
	ld a, [wBTAnimPhase]
	cp BT_FLIP_TYPE
	jr nz, .captured
	; Show the attacking card and what its type did.
	ld a, [wBTProbeCard]
	call BeastTriadDeckCard
	ld de, wTileMap + BT_LABEL
	call BeastTriadPrintLabelName
	call BeastTriadMatchupText
	jr .command
.captured:
	ld hl, BeastTriadYouCaptureText
	ld a, [wBTProbeOwner]
	and a
	jr z, .count
	ld hl, BeastTriadFoeCapturesText
.count:
	ld de, wTileMap + BT_COMMAND
	call BeastTriadPrint
	inc de
	ld a, [wBTCaptures]
	add "0"
	ld [de], a
	jp BeastTriadCommitFrame
.held:
	call BeastTriadDrawHandName
	ld a, [wBTBoardCursor]
	call BeastTriadBoardCell
	cp -1
	ld hl, BeastTriadTakenText
	jr nz, .command
	ld a, [wBTBoardCursor]
	call BeastTriadBoardOffset
	ld a, [wBTBoardCursor]
	call BeastTriadBoardPalette
	ld c, a
	ld a, [wBTHandCursor]
	ld b, BT_PAPER_HELD
	call BeastTriadDrawTrackingColors
	ld hl, BeastTriadPlaceText
	jr .command
.pick:
	call BeastTriadDrawPickHand
	ld a, [wBTPickCursor]
	add BT_HAND_SIZE
	ld de, wTileMap + BT_LABEL
	call BeastTriadDrawCardLabel
	ld hl, BeastTriadPickText
	jr .command
.result:
	call BeastTriadDrawResult
	ld hl, BeastTriadAgainText
.command:
	ld de, wTileMap + BT_COMMAND
	call BeastTriadPrint
	jp BeastTriadCommitFrame

BeastTriadDrawCase:
	ld hl, wTileMap + BT_TOP_SCORE
	ld bc, 15 * SCREEN_WIDTH
	ld a, BEAST_BLANK_TILE
	call ByteFill
	ld hl, wAttrMap + BT_TOP_SCORE
	ld bc, 15 * SCREEN_WIDTH
	ld a, BT_TEXT_ATTR
	call ByteFill
	ld hl, BeastTriadCaseTitle
	ld de, wTileMap + BT_TOP_SCORE + 1
	call BeastTriadPrint
	ld hl, BeastTriadDeckTitle
	ld de, wTileMap + (BT_CASE_DECK_ROW - 1) * SCREEN_WIDTH + 2
	call BeastTriadPrint
	ld hl, BeastTriadTrunkTitle
	ld de, wTileMap + (BT_CASE_TRUNK_ROW - 1) * SCREEN_WIDTH + 2
	call BeastTriadPrint
	; The five deck rows.
	ld hl, 0
	ld de, wTileMap + BT_CASE_DECK_ROW * SCREEN_WIDTH
	ld b, BT_HAND_SIZE
.deck:
	push bc
	push hl
	push de
	call BeastTriadDrawCaseRow
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .deck
	; One page of the trunk.
	ld a, [wBTCaseTop]
	ld l, a
	ld a, [wBTCaseTop + 1]
	ld h, a
	ld de, BT_HAND_SIZE
	add hl, de
	ld de, wTileMap + BT_CASE_TRUNK_ROW * SCREEN_WIDTH
	ld b, BT_TRUNK_ROWS
.trunk:
	ld a, [wBTCaseCount + 1]
	cp h
	jr c, .previews
	jr nz, .trunk_row
	ld a, [wBTCaseCount]
	cp l
	jr c, .previews
	jr z, .previews
.trunk_row:
	push bc
	push hl
	push de
	call BeastTriadDrawCaseRow
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .trunk
.previews:
	ld a, [wBTPreviewSlot]
	lb bc, BT_PAPER_PLAYER, BT_HAND_PAL
	ld hl, BT_CASE_PREVIEW
	call BeastTriadDrawTrackingColors
	ld a, [wBTCaseHeld + 1]
	cp -1
	jr z, .label
	ld a, [wBTHeldSlot]
	lb bc, BT_PAPER_HELD, BT_HAND_PAL
	ld hl, BT_CASE_HELD_PREVIEW
	call BeastTriadDrawTrackingColors
.label:
	ld hl, wBTPreviewCard
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, wTileMap + BT_LABEL
	call BeastTriadPrintLabelName
	ld a, "X"
	ld [wTileMap + BT_LABEL + 14], a
	pop hl
	ld de, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	ld de, wTileMap + BT_LABEL + 15
	call BeastTriadPrintNumber
	ld hl, BeastTriadBrowseText
	ld a, [wBTCaseHeld + 1]
	cp -1
	jr z, .command
	ld hl, BeastTriadSwapText
.command:
	ld de, wTileMap + BT_COMMAND
	jp BeastTriadPrint

BeastTriadDrawCaseRow:
	; HL: case position. DE: tilemap address of the row.
	push de
	push hl
	call BeastTriadCaseCard
	ld a, l
	ld [wBTScan], a
	ld a, h
	ld [wBTScan + 1], a
	pop hl
	pop de
	; The cursor row is gold and the held card's row blue.
	lb bc, BEAST_BLANK_TILE, BT_TEXT_ATTR
	ld a, [wBTCaseHeld]
	cp l
	jr nz, .cursor
	ld a, [wBTCaseHeld + 1]
	cp h
	jr nz, .cursor
	lb bc, BEAST_HELD_TILE, BT_HELD_ATTR
.cursor:
	ld a, [wBTCasePos]
	cp l
	jr nz, .draw
	ld a, [wBTCasePos + 1]
	cp h
	jr nz, .draw
	ld b, BEAST_CURSOR_TILE
	ld a, c
	cp BT_HELD_ATTR
	jr z, .draw
	ld c, BT_CURSOR_ATTR
.draw:
	push hl
	ld hl, wAttrMap - wTileMap + 1
	add hl, de
	ld a, c
	rept 14
		ld [hli], a
	endr
	pop hl
	inc de
	ld a, b
	ld [de], a
	inc de
	push hl
	ld hl, wBTScan
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call BeastTriadPrintName
	pop hl
	; Trunk rows show how many spare copies there are.
	call BeastTriadInDeck
	ret c
	ld a, "X"
	ld [de], a
	inc de
	ld hl, wBTScan
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	call BeastTriadSpareCopies
	pop de
	jp BeastTriadPrintNumber

BeastTriadDrawScore:
	ld a, [wBTPlayerScore]
	ld de, wTileMap + BT_TOP_SCORE + 11
	call BeastTriadPrintNumber
	ld a, [wBTPlayerScore]
	ld b, a
	ld a, BT_DECK_SIZE
	sub b
	ld de, wTileMap + BT_TOP_SCORE + 7
	jp BeastTriadPrintNumber

BeastTriadDrawFoeHand:
	xor a
	ld [wBTDrawIndex], a
.card:
	ld a, [wBTDrawIndex]
	ld e, a
	ld d, 0
	ld hl, wBTUsed + BT_HAND_SIZE
	add hl, de
	ld a, [hl]
	and a
	jr nz, .next
	ld a, e
	ld b, BT_PAPER_FOE
	call .draw
.next:
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .card
	ld a, [wBTFoeCursor]
	cp -1
	ret z
	; The focused card covers whatever is behind its fixed slot.
	ld b, BT_PAPER_HELD
.draw:
	push af
	call BeastTriadHandOffset
	ld de, BT_FOE_HAND_COL - BT_PLAYER_HAND_COL
	add hl, de
	pop af
	add BT_HAND_SIZE
	ld c, BT_FOE_HAND_PAL
	jp BeastTriadDrawTrackingColors

BeastTriadDrawBoard:
	xor a
	ld [wBTDrawIndex], a
	ld [wBTFlipSlot], a
.cell:
	ld a, [wBTDrawIndex]
	call BeastTriadBoardCell
	cp -1
	jp z, .next
	ld e, a
	ld hl, wBTOwners
	add hl, bc
	ld b, [hl]
	ld a, [wBTAnimPhase]
	and a
	jr z, .draw
	push bc
	ld a, [wBTDrawIndex]
	ld c, a
	ld b, 0
	ld hl, wBTCapturedCells
	add hl, bc
	ld a, [hl]
	pop bc
	and a
	jr z, .draw
	; B is already the new owner.
	ld a, [wBTAnimPhase]
	cp BT_FLIP_REVEAL
	jr z, .draw
	cp BT_FLIP_BACK
	jr z, .back
	cp BT_FLIP_FACE
	jr z, .old
	cp BT_FLIP_TYPE
	jr z, .old
	call BeastTriadDrawFlipCell
	jr .next
.old:
	ld a, b
	xor 1
	ld b, a
.draw:
	ld a, b
	add BT_PAPER_BOARD_PLAYER
	ld b, a
	call .coordinates
	call BeastTriadDrawTrackingColors
	jr .next
.back:
	ld a, [wBTDrawIndex]
	call BeastTriadBoardOffset
	call BeastTriadDrawCardBack
.next:
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_CELLS
	jp c, .cell
	ret
.coordinates:
	push de
	ld a, [wBTDrawIndex]
	call BeastTriadBoardPalette
	ld c, a
	ld a, [wBTDrawIndex]
	call BeastTriadBoardOffset
	pop de
	ld a, e
	ret

BeastTriadDrawHand:
	xor a
	ld [wBTDrawIndex], a
.card:
	ld a, [wBTDrawIndex]
	ld e, a
	ld d, 0
	ld hl, wBTUsed
	add hl, de
	ld a, [hl]
	and a
	jr nz, .next
	ld a, [wBTMode]
	cp BT_HELD
	jr nz, .draw
	ld a, [wBTHandCursor]
	cp e
	jr z, .next
.draw:
	ld a, e
	ld b, BT_PAPER_PLAYER
	call BeastTriadDrawHandCard
.next:
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .card
	ld a, [wBTMode]
	cp BT_HAND
	ret nz
	ld a, [wBTTurn]
	and a
	ret nz
	ld a, [wBTPlayerHand]
	and a
	ret z
	ld a, [wBTFoeCursor]
	cp -1
	ret nz
	ld a, [wBTHandCursor]
	ld b, BT_PAPER_HELD
	jp BeastTriadDrawHandCard

BeastTriadDrawPickHand:
	; The foe's five cards fan out where the player's hand was. Cards still
	; on the board keep their color there. The card at the cursor glows.
	xor a
	ld [wBTDrawIndex], a
.card:
	ld a, [wBTDrawIndex]
	call .draw
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .card
	ld a, [wBTPickCursor]
.draw:
	push af
	call BeastTriadHandOffset
	pop af
	add BT_HAND_SIZE
	ld e, a
	ld d, 0
	push hl
	ld hl, wBTUsed
	add hl, de
	ld a, [hl]
	pop hl
	and a
	ld a, e
	lb bc, BT_PAPER_FOE, BT_HAND_PAL
	jr z, BeastTriadDrawTrackingColors
	ld b, c
	call BeastTriadTileForCard
	jp BeastTriadDrawCardAt

BeastTriadDrawHandCard:
	push af
	call BeastTriadHandOffset
	pop af
	ld c, BT_HAND_PAL
	jr BeastTriadDrawTrackingColors

BeastTriadBoardPalette:
	cp 3
	jr c, .column
	sub 3
	jr BeastTriadBoardPalette
.column:
	add BT_BOARD_PAL
	ret

BeastTriadDrawTrackingColors:
	call BeastTriadTrackColors
	jr BeastTriadDrawCardAt

BeastTriadTrackColors:
	; A: art slot; B: paper owner; C: BG palette; HL: tilemap offset.
	ld e, a
	ld d, 0
	push hl
	ld hl, wBTFaceOwners
	add hl, de
	ld [hl], b
	pop hl
	ld b, c
	; fallthrough

BeastTriadTileForCard:
	ld c, a
	add a
	add c
	add a
	add a
	ret

BeastTriadHandOffset:
	; Both hands use fixed slots. The focused card is drawn after the fan.
	ld hl, .offsets
	jr BeastTriadGetOffset
.offsets:
FOR row, BT_BOARD_ROW, BT_BOARD_ROW + 2 * BT_HAND_SIZE, 2
	dw row * SCREEN_WIDTH + BT_PLAYER_HAND_COL
ENDR

BeastTriadBoardOffset:
	ld hl, .offsets
	jr BeastTriadGetOffset
.offsets:
FOR row, BT_BOARD_ROW, BT_BOARD_ROW + BT_BOARD_ROWS, BT_CARD_ROWS
	dw row * SCREEN_WIDTH + 5, row * SCREEN_WIDTH + 8, row * SCREEN_WIDTH + 11
ENDR

BeastTriadGetOffset:
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

BeastTriadDrawCardAt:
	; A: first tile. B: palette. HL: screen tile offset.
	push hl
	ld de, wTileMap
	add hl, de
	ld de, SCREEN_WIDTH - BT_CARD_COLS
	rept BT_CARD_ROWS
		rept BT_CARD_COLS
			ld [hli], a
			inc a
		endr
		add hl, de
	endr
	pop hl
	ld de, wAttrMap
	add hl, de
	ld de, SCREEN_WIDTH - BT_CARD_COLS
	ld a, b
	rept BT_CARD_ROWS
		rept BT_CARD_COLS
			ld [hli], a
		endr
		add hl, de
	endr
	ret

BeastTriadDrawCardBack:
	; HL: screen tile offset. Midway through a flip, show the card's back.
	push hl
	ld de, wTileMap
	add hl, de
	ld de, BeastTriadCardBack
	ld bc, SCREEN_WIDTH - BT_CARD_COLS
	rept BT_CARD_ROWS
		rept BT_CARD_COLS
			ld a, [de]
			inc de
			ld [hli], a
		endr
		add hl, bc
	endr
	pop hl
	ld de, wAttrMap
	add hl, de
	ld a, BT_TEXT_ATTR
	rept BT_CARD_ROWS
		rept BT_CARD_COLS
			ld [hli], a
		endr
		add hl, bc
	endr
	ret

BeastTriadDrawSelectionName:
	ld a, [wBTFoeCursor]
	cp -1
	jr z, BeastTriadDrawHandName
BeastTriadDrawFoeName:
	ld hl, BeastTriadFoeLabel
	ld de, wTileMap + BT_LABEL
	call BeastTriadPrint
	ld a, [wBTFoeCursor]
	add BT_HAND_SIZE
	jr BeastTriadDrawCardLabel

BeastTriadDrawHandName:
	ld a, [wBTHandCursor]
	ld de, wTileMap + BT_LABEL
	; fallthrough

BeastTriadDrawCardLabel:
	; A: art slot. DE: name position.
	push de
	call BeastTriadDeckCard
	pop de
	; fallthrough

BeastTriadPrintLabelName:
	; HL: card. DE: label row. Print its name, then its type symbol.
	push hl
	call BeastTriadPrintName
	pop hl
	inc de
	ld bc, BeastTriadCardIcons
	add hl, bc
	ld a, [hl]
	cp -1
	ret z
	ld [wBTLabelType], a
	ld c, a
	ld b, 0
	ld hl, BeastTriadTypeIconTiles
	add hl, bc
	ld a, [hl]
	ld [de], a
	ld hl, wAttrMap - wTileMap
	add hl, de
	ld [hl], $8 | BT_HAND_PAL
	ret

BeastTriadMatchupText:
	; Returns HL: what the last placement's types did.
	ld hl, wBTEdgeBonus
	lb bc, 0, 4
.edge:
	ld a, [hli]
	and a
	jr z, .next
	inc a
	jr z, .weak
	set 0, b
	jr .next
.weak:
	set 1, b
.next:
	dec c
	jr nz, .edge
	ld a, b
	ld hl, BeastTriadSuperText
	cp 1
	ret z
	ld hl, BeastTriadWeakText
	cp 2
	ret z
	ld hl, BeastTriadMatchupsText
	ret

BeastTriadDrawResult:
	ld a, [wBTReward + 1]
	cp -1
	jr z, .no_prize
	ld hl, BeastTriadPrizeText
	ld de, wTileMap + BT_LABEL
	call BeastTriadPrint
	ld hl, wBTReward
	jr .name
.no_prize:
	ld a, [wBTLost + 1]
	cp -1
	jr z, .draw
	ld hl, BeastTriadLostText
	ld de, wTileMap + BT_LABEL
	call BeastTriadPrint
	ld hl, wBTLost
.name:
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp BeastTriadPrintLabelName
.draw:
	ld hl, BeastTriadDrawText
	ld de, wTileMap + BT_LABEL
	jr BeastTriadPrint

BeastTriadPrintName:
	push de
	call BeastTriadGetRecord
	ld de, 4
	add hl, de
	pop de
	ld b, 10
.next:
	ld a, [hli]
	call BeastTriadPrintChar
	dec b
	jr nz, .next
	ret

BeastTriadPrint:
	ld a, [hli]
	cp "@"
	ret z
	call BeastTriadPrintChar
	jr BeastTriadPrint

BeastTriadPrintChar:
	cp " "
	jr nz, .write
	ld a, BEAST_BLANK_TILE
.write:
	ld [de], a
	inc de
	ret

BeastTriadPrintNumber:
	ld b, "0"
.tens:
	cp 10
	jr c, .ones
	sub 10
	inc b
	jr .tens
.ones:
	ld c, a
	ld a, b
	ld [de], a
	inc de
	ld a, c
	add "0"
	ld [de], a
	inc de
	ret

BeastTriadCaseTitle:        db "CARD CASE@"
BeastTriadDeckTitle:        db "DECK@"
BeastTriadTrunkTitle:       db "TRUNK@"
BeastTriadBrowseText:       db "A PICK     B BACK@"
BeastTriadSwapText:         db "A SWAP     B DROP@"
BeastTriadChooseText:       db "A HOLD  SELECT FOE@"
BeastTriadFoeLabel:         db "FOE @"
BeastTriadFoeTurnText:      db "FOE IS PLAYING@"
BeastTriadYouCaptureText:   db "YOU CAPTURED@"
BeastTriadFoeCapturesText:  db "FOE CAPTURED@"
BeastTriadTakenText:        db "OCCUPIED   B BACK@"
BeastTriadPlaceText:        db "A PLAY     B BACK@"
BeastTriadPickText:         db "YOU WIN! TAKE ONE@"
BeastTriadAgainText:        db "A AGAIN    B QUIT@"
BeastTriadShuffleText:      db "SHUFFLING...@"
BeastTriadPrizeText:        db "WON@"
BeastTriadLostText:         db "LOST@"
BeastTriadDrawText:         db "DRAW - NO TRADE@"
BeastTriadSuperText:        db "SUPER EFFECTIVE +1@"
BeastTriadWeakText:         db "NOT VERY EFF. -1@"
BeastTriadMatchupsText:     db "TYPE MATCHUPS +1-1@"

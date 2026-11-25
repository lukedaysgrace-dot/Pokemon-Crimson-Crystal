; The Card Case is one list: the five deck cards, then the trunk (every
; spare copy). Pick a card with A, then press A on another to swap them.

BeastTriadInitCase:
	ld hl, 0
	call BeastTriadSetCasePos
	ld a, -1
	ld [wBTCaseHeld], a
	ld [wBTCaseHeld + 1], a
	ld [wBTPreviewCard + 1], a
	ld [wBTHeldCard + 1], a
	xor a
	ld [wBTCaseTop], a
	ld [wBTCaseTop + 1], a
	ld a, BT_PREVIEW_SLOT
	ld [wBTPreviewSlot], a
	ld a, BT_HELD_PREVIEW_SLOT
	ld [wBTHeldSlot], a
	call BeastTriadBuildTrunk
	jp BeastTriadCaseRefresh

BeastTriadCaseInput:
	ld a, b
	and B_BUTTON
	jp nz, .back
	ld a, b
	and A_BUTTON
	jp nz, BeastTriadCasePick
	ld a, b
	and D_UP
	jr nz, .up
	ld a, b
	and D_DOWN
	jr nz, .down
	ld a, b
	and D_RIGHT
	jr nz, .right
	ld a, b
	and D_LEFT
	ret z
	; Left: a page up the trunk, or back to the deck from its first page.
	call BeastTriadCaseInDeck
	ret c
	ld de, -(BT_HAND_SIZE + BT_TRUNK_ROWS)
	add hl, de
	jr nc, .to_deck
	ld de, BT_HAND_SIZE
	add hl, de
	jr .set
.to_deck:
	ld hl, 0
	jr .set
.right:
	; Right: from the deck to the trunk, then a page at a time.
	ld a, [wBTCaseCount + 1]
	and a
	jr nz, .trunk_full
	ld a, [wBTCaseCount]
	cp BT_HAND_SIZE + 1
	ret c
.trunk_full:
	call BeastTriadCasePos
	ld a, h
	and a
	jr nz, .page_down
	ld a, l
	cp BT_HAND_SIZE
	jr nc, .page_down
	ld hl, BT_HAND_SIZE
	jr .clamp
.page_down:
	ld de, BT_TRUNK_ROWS
	add hl, de
.clamp:
	call BeastTriadCaseLast
	ld a, h
	cp d
	jr c, .set
	jr nz, .last
	ld a, l
	cp e
	jr c, .set
	jr z, .set
.last:
	ld h, d
	ld l, e
	jr .set
.up:
	call BeastTriadCasePos
	ld a, h
	or l
	jr z, .wrap_up
	dec hl
	jr .set
.wrap_up:
	call BeastTriadCaseLast
	ld h, d
	ld l, e
	jr .set
.down:
	call BeastTriadCasePos
	call BeastTriadCaseLast
	ld a, h
	cp d
	jr nz, .next
	ld a, l
	cp e
	jr nz, .next
	ld hl, -1
.next:
	inc hl
.set:
	call BeastTriadSetCasePos
	jp BeastTriadCaseRefresh
.back:
	ld a, [wBTCaseHeld + 1]
	cp -1
	jp z, BeastTriadQuit
	ld a, -1
	ld [wBTCaseHeld], a
	ld [wBTCaseHeld + 1], a
	ret

BeastTriadCasePick:
	ld a, [wBTCaseHeld + 1]
	cp -1
	jr z, .hold
	; A on the held card puts it back down.
	call BeastTriadCasePos
	ld a, [wBTCaseHeld]
	cp l
	jr nz, .different
	ld a, [wBTCaseHeld + 1]
	cp h
	jr z, .drop
.different:
	; Two trunk cards don't swap: pick up the new one instead.
	call BeastTriadCaseInDeck
	jr c, .swap
	ld hl, wBTCaseHeld
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call BeastTriadInDeck
	jr c, .swap
.hold:
	call BeastTriadCasePos
	ld a, l
	ld [wBTCaseHeld], a
	ld a, h
	ld [wBTCaseHeld + 1], a
	call BeastTriadCaseCard
	ld de, wBTHeldCard
	ld bc, wBTHeldSlot
	call BeastTriadLoadPreview
	ld de, SFX_READ_TEXT_2
	jp PlaySFX
.drop:
	ld a, -1
	ld [wBTCaseHeld], a
	ld [wBTCaseHeld + 1], a
	ret

.swap:
	; At least one side is a deck slot. Each deck slot takes the other card;
	; a deck card swapped with a trunk card returns to the trunk.
	call BeastTriadCasePos
	push hl
	call BeastTriadCaseCard
	ld b, h
	ld c, l
	ld hl, wBTCaseHeld
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	push bc
	call BeastTriadCaseCard
	ld d, h
	ld e, l
	pop bc
	; BC: card under the cursor. DE: held card.
	pop hl
	push de
	call BeastTriadStoreDeckSlot
	pop bc
	pop hl
	push hl
	call BeastTriadStoreDeckSlot
	pop hl
	; Land on the deck slot that changed.
	call BeastTriadInDeck
	jr c, .cursor
	ld hl, wBTCaseHeld
	ld a, [hli]
	ld h, [hl]
	ld l, a
.cursor:
	call BeastTriadSetCasePos
	ld a, -1
	ld [wBTCaseHeld], a
	ld [wBTCaseHeld + 1], a
	call BeastTriadBuildTrunk
	call BeastTriadCaseRefresh
	ld de, SFX_BEAST_TRIAD_FLIP
	jp PlaySFX

BeastTriadStoreDeckSlot:
	; HL: case position. BC: card to put there if it is a deck slot.
	call BeastTriadInDeck
	ret nc
	ld a, l
	add a
	ld l, a
	ld de, wBeastTriadDeck
	add hl, de
	ld [hl], c
	inc hl
	ld [hl], b
	ret

BeastTriadCaseInDeck:
	call BeastTriadCasePos
BeastTriadInDeck:
	; HL: case position. Carry if it is one of the five deck rows.
	ld a, h
	and a
	ret nz
	ld a, l
	cp BT_HAND_SIZE
	ret

BeastTriadCasePos:
	ld hl, wBTCasePos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

BeastTriadSetCasePos:
	ld a, l
	ld [wBTCasePos], a
	ld a, h
	ld [wBTCasePos + 1], a
	ret

BeastTriadCaseLast:
	; Returns DE: the last case position. Preserves HL.
	ld a, [wBTCaseCount]
	ld e, a
	ld a, [wBTCaseCount + 1]
	ld d, a
	dec de
	ret

BeastTriadCaseRefresh:
	; Keep the cursor inside the list and on screen, then load its art.
	call BeastTriadCasePos
	call BeastTriadCaseLast
	ld a, d
	cp h
	jr c, .clamp
	jr nz, .scroll
	ld a, e
	cp l
	jr nc, .scroll
.clamp:
	ld h, d
	ld l, e
	call BeastTriadSetCasePos
.scroll:
	call BeastTriadInDeck
	jr c, .preview
	; T = position - deck rows. Show rows TOP .. TOP + BT_TRUNK_ROWS - 1.
	ld de, -BT_HAND_SIZE
	add hl, de
	ld a, [wBTCaseTop]
	ld e, a
	ld a, [wBTCaseTop + 1]
	ld d, a
	ld a, h
	cp d
	jr c, .top
	jr nz, .bottom
	ld a, l
	cp e
	jr c, .top
.bottom:
	push hl
	ld bc, BT_TRUNK_ROWS - 1
	ld a, e
	add c
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry:
	; DE: last visible trunk row.
	ld a, d
	cp h
	jr c, .move_bottom
	jr nz, .keep
	ld a, e
	cp l
	jr nc, .keep
.move_bottom:
	pop hl
	ld de, -(BT_TRUNK_ROWS - 1)
	add hl, de
	jr .top
.keep:
	pop hl
	jr .preview
.top:
	ld a, l
	ld [wBTCaseTop], a
	ld a, h
	ld [wBTCaseTop + 1], a
.preview:
	call BeastTriadCasePos
	call BeastTriadCaseCard
	ld de, wBTPreviewCard
	ld bc, wBTPreviewSlot
	; fallthrough

BeastTriadLoadPreview:
	; HL: card. DE: the preview's card. BC: its art slot, which alternates
	; between two slots so the art on screen is never overwritten.
	ld a, [de]
	cp l
	jr nz, .load
	inc de
	ld a, [de]
	dec de
	cp h
	ret z
.load:
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld a, [bc]
	xor 1
	ld [bc], a
	jp BeastTriadLoadSlotArt

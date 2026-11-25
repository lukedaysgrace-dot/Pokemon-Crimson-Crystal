BT_COLLECTION_READY EQU $be
BT_COLLECTION_SIZE EQU NUM_BEAST_CARDS + 1
BT_DECK_READY EQU $bd
BT_DECK_SAVE_SIZE EQU 2 * BT_HAND_SIZE + 1
assert wBeastTriadCollectionEnd - wBeastTriadCollection == BT_COLLECTION_SIZE
assert wBeastTriadDeckEnd - wBeastTriadDeck == BT_DECK_SAVE_SIZE
assert wBeastTriadDeck == wBeastTriadCollectionEnd
BT_MAX_COPIES EQU 99

BeastTriadGiveStarterCards::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBeastTriadCollection)
	ldh [rSVBK], a
	call BeastTriadInitCollection
	pop af
	ldh [rSVBK], a
	ret

BeastTriadInitCollection:
	ld a, [wBeastTriadCollectionReady]
	cp BT_COLLECTION_READY
	jr z, .deck
	call BeastTriadClearCollection
	ld a, BT_COLLECTION_READY
	ld [wBeastTriadCollectionReady], a
.deck:
	ld a, [wBeastTriadDeckReady]
	cp BT_DECK_READY
	jr nz, .starter_deck
	call BeastTriadValidateDeck
	ret nc
.starter_deck:
	ld de, wBeastTriadDeck
	ld hl, BeastTriadStarters
	ld bc, BT_HAND_SIZE * 2
	call CopyBytes
	; Older saves have a collection and no deck. Keep their cards and
	; fill in any missing starter copy needed for the default deck.
	ld hl, BeastTriadStarters
	ld b, BT_HAND_SIZE
.starter:
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	and a
	jr nz, .owned
	inc [hl]
.owned:
	pop hl
	dec b
	jr nz, .starter
	ld a, BT_DECK_READY
	ld [wBeastTriadDeckReady], a
	ret

BeastTriadClearCollection::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBeastTriadCollection)
	ldh [rSVBK], a
	xor a
	ld hl, wBeastTriadCollection
	ld bc, BT_COLLECTION_SIZE + BT_DECK_SAVE_SIZE
	call ByteFill
	pop af
	ldh [rSVBK], a
	ret

BeastTriadSaveCollection::
	ld de, sBeastTriadCollection
	ld hl, sBeastTriadDeck
	jr BeastTriadWriteSave

BeastTriadSaveBackup::
	ld de, sBackupBeastTriadCollection
	ld hl, sBackupBeastTriadDeck
BeastTriadWriteSave:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBeastTriadCollection)
	ldh [rSVBK], a
	ld a, BANK(sBeastTriadCollection)
	call GetSRAMBank
	push hl
	ld hl, wBeastTriadCollection
	ld bc, BT_COLLECTION_SIZE
	call BeastTriadWriteBlock
	pop de
	ld hl, wBeastTriadDeck
	ld bc, BT_DECK_SAVE_SIZE
	call BeastTriadWriteBlock
	call CloseSRAM
	pop af
	ldh [rSVBK], a
	ret

BeastTriadWriteBlock:
	push de
	push bc
	call CopyBytes
	pop bc
	pop hl
	call BeastTriadChecksum
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BeastTriadLoadCollection::
	ld hl, sBeastTriadCollection
	ld de, sBeastTriadDeck
	jr BeastTriadReadSave

BeastTriadLoadBackup::
	ld hl, sBackupBeastTriadCollection
	ld de, sBackupBeastTriadDeck
BeastTriadReadSave:
	push hl
	push de
	call BeastTriadClearCollection
	pop de
	pop hl
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBeastTriadCollection)
	ldh [rSVBK], a
	ld a, BANK(sBeastTriadCollection)
	call GetSRAMBank
	push de
	ld de, wBeastTriadCollection
	ld bc, BT_COLLECTION_SIZE
	call BeastTriadReadBlock
	pop hl
	ld de, wBeastTriadDeck
	ld bc, BT_DECK_SAVE_SIZE
	call BeastTriadReadBlock
	pop af
	ldh [rSVBK], a
	jp CloseSRAM

BeastTriadReadBlock:
	push bc
	push de
	push hl
	call BeastTriadChecksum
	ld a, [hli]
	cp e
	jr nz, .bad
	ld a, [hl]
	cp d
	jr nz, .bad
	pop hl
	pop de
	pop bc
	jp CopyBytes
.bad:
	pop hl
	pop de
	pop bc
	ret

BeastTriadChecksum:
	ld de, 0
.next:
	ld a, [hli]
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry:
	dec bc
	ld a, b
	or c
	jr nz, .next
	ret

BeastTriadValidateDeck:
	xor a
	ld [wBTDeckSlot], a
.next:
	call BeastTriadEditedSlot
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, -NUM_BEAST_CARDS
	add hl, de
	pop hl
	ret c
	call BeastTriadCountOtherCopies
	ret c
	ld hl, wBTDeckSlot
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .next
	ret

BeastTriadEditedSlot:
	ld a, [wBTDeckSlot]
	add a
	ld c, a
	ld b, 0
	ld hl, wBeastTriadDeck
	add hl, bc
	ret

BeastTriadCountOtherCopies:
	; HL is the card index. Return DE = card, carry if the other slots
	; use every owned copy, and HL = the matching slot (0 if unowned).
	push hl
	ld de, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	pop de
	and a
	jr z, .unowned
	ld b, a
	ld c, 0
	ld hl, wBeastTriadDeck
.count:
	ld a, [wBTDeckSlot]
	cp c
	jr z, .skip
	ld a, [hli]
	cp e
	ld a, [hli]
	jr nz, .next_slot
	cp d
	jr nz, .next_slot
	dec b
	jr z, .used
	jr .next_slot
.skip:
	inc hl
	inc hl
.next_slot:
	inc c
	ld a, c
	cp BT_HAND_SIZE
	jr c, .count
	ret
.used:
	dec hl
	dec hl
	scf
	ret
.unowned:
	ld hl, 0
	scf
	ret

BeastTriadTakePrize:
	; Like Triple Triad's One rule, the winner claims any one of the
	; loser's five cards.
	ld a, [wBTPickCursor]
	add BT_HAND_SIZE
	call BeastTriadDeckCard
	ld a, l
	ld [wBTReward], a
	ld a, h
	ld [wBTReward + 1], a
	ld de, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	cp BT_MAX_COPIES
	jr nc, .full
	inc [hl]
.full:
	ld a, BT_RESULT
	ld [wBTMode], a
	ld de, SFX_BEAST_TRIAD_TAKE
	jp PlaySFX

BeastTriadFoeTakesCard:
	; The foe claims the strongest of the five cards the player brought.
	lb bc, 0, 0
	xor a
	ld [wBTDrawIndex], a
.slot:
	ld a, [wBTDrawIndex]
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, wBTRanks
	add hl, de
	ld a, [hli]
	add [hl]
	inc hl
	add [hl]
	inc hl
	add [hl]
	cp c
	jr c, .next
	jr z, .next
	ld c, a
	ld a, [wBTDrawIndex]
	ld b, a
.next:
	ld hl, wBTDrawIndex
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .slot
	ld a, b
	call BeastTriadDeckCard
	ld a, l
	ld [wBTLost], a
	ld a, h
	ld [wBTLost + 1], a
	ld de, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	and a
	jr z, BeastTriadRepairDeck
	dec [hl]
	; fallthrough

BeastTriadRepairDeck:
	; Replace any deck card the player no longer has enough copies of with
	; their strongest spare card.
	xor a
	ld [wBTDeckSlot], a
.slot:
	call BeastTriadEditedSlot
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call BeastTriadCountOtherCopies
	jr nc, .next
	call BeastTriadBestSpare
	jr nc, .assign
	; Nothing is spare. Hand back a starter so there is always a deck.
	ld hl, BeastTriadStarters
	ld a, [wBTDeckSlot]
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, wBeastTriadCollection
	add hl, de
	inc [hl]
	pop hl
.assign:
	push hl
	call BeastTriadEditedSlot
	pop de
	ld [hl], e
	inc hl
	ld [hl], d
.next:
	ld hl, wBTDeckSlot
	inc [hl]
	ld a, [hl]
	cp BT_HAND_SIZE
	jr c, .slot
	ret

BeastTriadDeckUsage:
	; HL: card. Returns A: how many deck slots hold it. Preserves HL.
	push hl
	ld d, h
	ld e, l
	ld hl, wBeastTriadDeck
	lb bc, 0, BT_HAND_SIZE
.slot:
	ld a, [hli]
	cp e
	ld a, [hli]
	jr nz, .next
	cp d
	jr nz, .next
	inc b
.next:
	dec c
	jr nz, .slot
	ld a, b
	pop hl
	ret

BeastTriadSpareCopies:
	; HL: card. Returns A: copies not in the deck (0 if none). Preserves HL.
	call BeastTriadDeckUsage
	ld c, a
	push hl
	ld de, wBeastTriadCollection
	add hl, de
	ld a, [hl]
	pop hl
	sub c
	ret nc
	xor a
	ret

BeastTriadCardPower:
	; HL: card. Returns A: the sum of its ranks. Preserves HL.
	push hl
	call BeastTriadGetRecord
	ld a, [hli]
	add [hl]
	inc hl
	add [hl]
	inc hl
	add [hl]
	pop hl
	ret

BeastTriadBestSpare:
	; Returns HL: the strongest card with a copy outside the deck.
	; Carry if there is none.
	ld a, -1
	ld [wBTScan + 1], a
	xor a
	ld [wBTBestScore], a
	ld hl, 0
.card:
	call BeastTriadSpareCopies
	and a
	jr z, .next
	call BeastTriadCardPower
	ld b, a
	ld a, [wBTBestScore]
	cp b
	jr nc, .next
	ld a, b
	ld [wBTBestScore], a
	ld a, l
	ld [wBTScan], a
	ld a, h
	ld [wBTScan + 1], a
.next:
	inc hl
	ld a, h
	cp HIGH(NUM_BEAST_CARDS)
	jr nz, .card
	ld a, l
	cp LOW(NUM_BEAST_CARDS)
	jr nz, .card
	ld a, [wBTScan + 1]
	cp -1
	scf
	ret z
	ld h, a
	ld a, [wBTScan]
	ld l, a
	and a
	ret

BeastTriadBuildTrunk:
	; List every card with a copy outside the deck, in catalogue order.
	ld hl, BT_HAND_SIZE
	ld a, l
	ld [wBTCaseCount], a
	ld a, h
	ld [wBTCaseCount + 1], a
	ld hl, 0
.card:
	call BeastTriadSpareCopies
	and a
	jr z, .next
	push hl
	ld a, [wBTCaseCount]
	ld e, a
	ld a, [wBTCaseCount + 1]
	ld d, a
	inc de
	ld a, e
	ld [wBTCaseCount], a
	ld a, d
	ld [wBTCaseCount + 1], a
	call BeastTriadTrunkEntry
	pop de
	ld a, e
	ld [hli], a
	ld [hl], d
	ld h, d
	ld l, e
.next:
	inc hl
	ld a, h
	cp HIGH(NUM_BEAST_CARDS)
	jr nz, .card
	ld a, l
	cp LOW(NUM_BEAST_CARDS)
	jr nz, .card
	; Keep the trunk page inside the list when it gets shorter.
	ld a, [wBTCaseCount]
	sub BT_HAND_SIZE + BT_TRUNK_ROWS
	ld e, a
	ld a, [wBTCaseCount + 1]
	sbc 0
	ld d, a
	jr nc, .last_page
	ld de, 0
.last_page:
	ld a, [wBTCaseTop + 1]
	cp d
	jr c, .done
	jr nz, .clamp
	ld a, [wBTCaseTop]
	cp e
	jr c, .done
	jr z, .done
.clamp:
	ld a, e
	ld [wBTCaseTop], a
	ld a, d
	ld [wBTCaseTop + 1], a
.done:
	ret

BeastTriadTrunkEntry:
	; DE: case list position past the deck rows (1-based in the trunk).
	; Returns HL: its wBTTrunk entry.
	ld hl, -BT_HAND_SIZE - 1
	add hl, de
	add hl, hl
	ld de, wBTTrunk
	add hl, de
	ret

BeastTriadCaseCard:
	; HL: case list position. Returns HL: the card in that row.
	ld a, h
	and a
	jr nz, .trunk
	ld a, l
	cp BT_HAND_SIZE
	jr nc, .trunk
	add a
	ld l, a
	ld de, wBeastTriadDeck
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
.trunk:
	ld d, h
	ld e, l
	inc de
	call BeastTriadTrunkEntry
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

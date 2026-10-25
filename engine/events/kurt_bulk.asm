; Bulk Apricorn handoff and lossless collection, including multiple stacks.
; The existing color events identify the owed Ball type. No save offsets move.
DEF KURT_BULK_MARKER EQU $a7
	assert MAX_ITEMS * 99 < $10000

Kurt_CountAllApricorns::
; wCurItem = Apricorn; bc = full 16-bit total. Preserve de/hl for the menu.
	push de
	push hl
	ld a, [wCurItem]
	ld d, a
	ld a, [wNumItems]
	ld e, a
	ld hl, wItems
	ld bc, 0
.loop
	ld a, e
	and a
	jr z, .done
	ld a, [hli]
	cp d
	jr nz, .next
	ld a, c
	add [hl]
	ld c, a
	jr nc, .next
	inc b
.next
	inc hl
	dec e
	jr .loop
.done
	pop hl
	pop de
	ret

Kurt_TakeAllApricorns::
; Stable in-place compaction removes every matching stack, keeping all other
; items in order. Store the complete quantity before returning the color.
	xor a
	ld [wKurtApricornQuantity], a
	ld [wKurtApricornQuantityHi], a
	ld [wItemQuantityBuffer], a ; retained stack count
	ld a, KURT_BULK_MARKER
	ld [wKurtBatchMarker], a
	ld a, [wCurItem]
	ld b, a
	ld a, [wNumItems]
	ld c, a
	ld hl, wItems
	ld de, wItems
.loop
	ld a, c
	and a
	jr z, .done
	ld a, [hli]
	cp b
	jr z, .take
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [wItemQuantityBuffer]
	inc a
	ld [wItemQuantityBuffer], a
	jr .next
.take
	ld a, [hli]
	push hl
	ld hl, wKurtApricornQuantity
	add [hl]
	ld [hl], a
	jr nc, .no_carry
	ld hl, wKurtApricornQuantityHi
	inc [hl]
.no_carry
	pop hl
.next
	dec c
	jr .loop
.done
	ld a, -1
	ld [de], a
	ld a, [wItemQuantityBuffer]
	ld [wNumItems], a
	ld a, [wCurItem]
	ld [wScriptVar], a
	ret

Kurt_GetBatchQuantity::
; bc = pending count; old saves retain their ordinary one-byte quantity.
	ld a, [wKurtApricornQuantity]
	ld c, a
	ld b, 0
	ld a, [wKurtBatchMarker]
	cp KURT_BULK_MARKER
	ret nz
	ld a, [wKurtApricornQuantityHi]
	cp HIGH(MAX_ITEMS * 99) + 1
	ret nc ; ignore invalid legacy padding instead of inventing a huge batch
	ld b, a
	ret

Kurt_CollectCraftedBalls::
; wScriptVar = Ball item. Return FALSE if nothing fits, TRUE when the batch
; is exhausted, or 2 after partial collection. Uncollected Balls stay owed.
	ld a, [wScriptVar]
	ld [wCurItem], a
	call Kurt_GetBatchQuantity
	ld a, b
	ld [wKurtApricornQuantityHi], a
	ld a, KURT_BULK_MARKER
	ld [wKurtBatchMarker], a
	xor a
	ld [wScriptVar], a
.loop
	call Kurt_GetBatchQuantity
	ld a, b
	or c
	jr z, .finished
	push bc
	call Kurt_BallPocketSpace
	pop bc
	ld a, h
	or l
	ret z
	ld a, 99
	inc b
	dec b
	jr nz, .limited_by_space
	cp c
	jr c, .limited_by_space
	ld a, c
.limited_by_space
	inc h
	dec h
	jr nz, .give
	cp l
	jr c, .give
	ld a, l
.give
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	ret nc ; defensive: a refused transfer leaves the remaining count intact
	ld a, [wItemQuantityChangeBuffer]
	ld c, a
	ld a, [wKurtApricornQuantity]
	sub c
	ld [wKurtApricornQuantity], a
	ld a, [wKurtApricornQuantityHi]
	sbc 0
	ld [wKurtApricornQuantityHi], a
	ld a, 2
	ld [wScriptVar], a
	jr .loop
.finished
	xor a
	ld [wKurtBatchMarker], a
	ld [wKurtApricornQuantityHi], a
	ld a, TRUE
	ld [wScriptVar], a
	ret

Kurt_BallPocketSpace:
; hl = exact remaining capacity for wCurItem across existing and new stacks.
	ld a, [wNumBalls]
	ld e, a
	ld a, MAX_BALLS
	sub e
	jr nc, .valid_count
	xor a
.valid_count
	ld hl, 0
	ld bc, 99
	call AddNTimes
	ld a, [wCurItem]
	ld d, a
	ld bc, wBalls
.loop
	ld a, e
	and a
	ret z
	ld a, [bc]
	inc bc
	cp d
	jr nz, .next
	ld a, [bc]
	push bc
	ld b, a
	ld a, 99
	sub b
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
.next
	inc bc
	dec e
	jr .loop

; Dialogue helpers. Counts are stored big-endian for text_decimal:
; wStringBuffer5 = batch size / Balls handed over,
; wStringBuffer5 + 2 = Balls Kurt is still holding. wScriptVar is preserved.

Kurt_LoadBatchCountText::
	call Kurt_GetBatchQuantity
	ld a, b
	ld [wStringBuffer5], a
	ld a, c
	ld [wStringBuffer5 + 1], a
	xor a
	ld [wStringBuffer5 + 2], a
	ld [wStringBuffer5 + 3], a
	ret

Kurt_LoadCollectedCountText::
; Call after Kurt_CollectCraftedBalls, with the pre-collection size loaded.
	call Kurt_GetBatchQuantity
	ld a, b
	ld [wStringBuffer5 + 2], a
	ld a, c
	ld [wStringBuffer5 + 3], a
	ld a, [wStringBuffer5 + 1]
	sub c
	ld [wStringBuffer5 + 1], a
	ld a, [wStringBuffer5]
	sbc b
	ld [wStringBuffer5], a
	ret

Kurt_IsBatchCountOne::
; wScriptVar = TRUE if the count in wStringBuffer5 is exactly 1.
	ld a, [wStringBuffer5]
	and a
	jr nz, .no
	ld a, [wStringBuffer5 + 1]
	cp 1
	jr nz, .no
	ld a, TRUE
	jr .done
.no
	xor a ; FALSE
.done
	ld [wScriptVar], a
	ret

; Bag and PC rows are [index high, index low, quantity]. A single $ff
; terminates the list; valid indices are $0001..$feff. Quantities are 1..99.
; Ball/key pockets retain fixed legacy byte IDs and their existing layouts.

GetCurItemIndexBC:
	push hl
	ld a, [wCurItem]
	call GetItemIndexFromID
	ld b, h
	ld c, l
	pop hl
	ret

PutItemInPocket16:
	ld d, h
	ld e, l
	call GetPocketCapacity
	ld a, [hl]
	cp c
	jr c, .valid_count
	jp nz, .fail
.valid_count
	ld a, [wItemQuantityChangeBuffer]
	and a
	jp z, .fail
	cp 100
	jp nc, .fail
	push de
	push bc ; capacity in c
	call GetCurItemIndexBC
	ld a, b
	cp $ff
	jp z, .bad_index
	or c
	jp z, .bad_index
	ld a, [wItemQuantityChangeBuffer]
	ld d, a ; quantity still needing space
	ld a, [hli]
	ld e, a
.preflight
	ld a, e
	and a
	jr z, .checked
	ld a, [hli]
	cp b
	jr nz, .skip_low
	ld a, [hli]
	cp c
	jr nz, .skip_quantity
	ld a, 99
	sub [hl]
	jr c, .bad_index ; reject an invalid existing stack
	push bc
	ld b, a
	ld a, d
	sub b
	pop bc
	jr c, .space_found
	jr z, .space_found
	ld d, a
	jr .skip_quantity
.skip_low
	inc hl
.skip_quantity
	inc hl
	dec e
	jr .preflight
.checked
	pop bc
	pop hl
	ld a, [hl]
	cp c
	jp nc, .fail
	jr .insert
.space_found
	pop bc
	pop hl
.insert
	push hl
	call GetCurItemIndexBC
	ld a, [wItemQuantityChangeBuffer]
	ld d, a
	ld a, [hli]
	ld e, a
.fill
	ld a, e
	and a
	jr z, .append
	ld a, [hli]
	cp b
	jr nz, .fill_skip_low
	ld a, [hli]
	cp c
	jr nz, .fill_skip_quantity
	ld a, [hl]
	add d
	cp 100
	jr nc, .overflow
	ld [hl], a
	pop hl
	scf
	ret
.overflow
	ld [hl], 99
	sub 99
	ld d, a
	jr .fill_skip_quantity
.fill_skip_low
	inc hl
.fill_skip_quantity
	inc hl
	dec e
	jr .fill
.append
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], d
	inc hl
	ld [hl], -1
	pop hl
	inc [hl]
	scf
	ret
.bad_index
	pop bc
	pop hl
.fail
	and a
	ret

CheckTheItem16:
	call GetCurItemIndexBC
	ld a, [hli]
	ld e, a
.loop
	ld a, e
	and a
	ret z
	ld a, [hli]
	cp b
	jr nz, .skip_low
	ld a, [hli]
	cp c
	jr z, .found
	jr .next
.skip_low
	inc hl
.next
	inc hl
	dec e
	jr .loop
.found
	scf
	ret

RemoveItemFromPocket16:
	ld a, [wItemQuantityChangeBuffer]
	and a
	ret z
	cp 100
	jp nc, .fail
	push hl ; count address
	call GetCurItemIndexBC
	ld a, [hli]
	ld e, a
	ld a, [wCurItemQuantity]
	cp e
	jr nc, .search
	push hl
	push de
	ld d, a
.slot
	ld a, d
	and a
	jr z, .at_slot
	inc hl
	inc hl
	inc hl
	dec e
	dec d
	jr .slot
.at_slot
	ld a, [hli]
	cp b
	jr nz, .wrong_slot
	ld a, [hli]
	cp c
	jr nz, .wrong_slot
	pop bc ; discard saved remaining count
	pop bc ; discard saved first-entry pointer
	jr .take
.wrong_slot
	pop de
	pop hl
.search
	ld a, e
	and a
	jr z, .not_found
	ld a, [hli]
	cp b
	jr nz, .skip_low
	ld a, [hli]
	cp c
	jr z, .take
	jr .next
.skip_low
	inc hl
.next
	inc hl
	dec e
	jr .search
.take
	ld a, [wItemQuantityChangeBuffer]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .not_found
	ld [hl], a
	ld [wItemQuantityBuffer], a
	and a
	jr nz, .success
	; Copy a known number of rows: $ff is legal inside a word index.
	ld a, e
	dec a
	ld b, a
	add a
	add b
	inc a
	ld c, a
	ld b, 0
	ld d, h
	ld e, l
	dec de
	dec de
	inc hl
	call CopyBytes
	pop hl
	dec [hl]
	scf
	ret
.success
	pop hl
	scf
	ret
.not_found
	pop hl
.fail
	and a
	ret

; Parallel item-index high bytes, one per physical PokeDB record. Copy-on-write
; storage owns these bytes exactly as it owns the corresponding record. This
; preserves the 57-byte record layout and all old storage/snapshot pointers.

SavedItemHighAddress:
; hl = physical record address in the currently open bank. Returns carry if
; it is not a PokeDB record; otherwise opens the sidecar bank and returns hl.
	ldh a, [hSRAMBank]
	sub BANK(sBoxMons1A)
	cp 4
	jr nc, .invalid
	ld b, a
	ld a, h
	cp $a0
	jr c, .invalid
	cp $c0
	jr nc, .invalid
	ld de, -$a000
	add hl, de
	ld de, -SAVEMON_STRUCT_LENGTH
	ld c, -1
.divide
	inc c
	add hl, de
	jr c, .divide
	ld hl, sPokeDBItemHigh
	ld a, b
	bit 1, b
	jr z, .first_pool
	ld de, MONDB_ENTRIES
	add hl, de
.first_pool
	bit 0, b
	jr z, .first_section
	ld de, MONDB_ENTRIES_A
	add hl, de
.first_section
	ld b, 0
	add hl, bc
	ld a, BANK(sPokeDBItemHigh)
	call GetSRAMBank
	and a
	ret
.invalid
	scf
	ret

ReadSavedItemHigh::
; Preserves hl, bc, de and the open SRAM bank. ROM fallback records use zero.
	push bc
	push de
	push hl
	ldh a, [hSRAMBank]
	push af
	call SavedItemHighAddress
	ld b, 0
	jr c, .restore
	ld b, [hl]
.restore
	pop af
	call GetSRAMBank
	ld a, b
	pop hl
	pop de
	pop bc
	ret

WriteSavedItemHigh::
; a = high byte. Preserves hl, bc, de and the open SRAM bank.
	push bc
	push de
	push hl
	ld b, a
	ldh a, [hSRAMBank]
	push af
	push bc
	call SavedItemHighAddress
	pop bc
	jr c, .restore
	ld [hl], b
.restore
	pop af
	call GetSRAMBank
	pop hl
	pop de
	pop bc
	ret

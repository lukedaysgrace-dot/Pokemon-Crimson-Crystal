; Pointer-based, copy-on-write Pokémon storage backend.
; Design and register contracts: docs/pc_storage_design.md.
;
; Terminology:
;   box b, slot c  : logical location. b = 0 is the party (c = 1-6),
;                    b = 1..NUM_BOXES is a storage box (c = 1..MONS_PER_BOX).
;   pointer de     : physical PokeDB record. d = pool (1 or 2), e = entry
;                    (1..MONDB_ENTRIES); e = 0 is the null pointer.
;
; Invariant: a PokeDB record referenced by either the active or the backup
; box metadata is never overwritten. Changing a stored mon allocates a new
; record and repoints the active slot (UpdateStorageBoxMonFromTemp).
;
; All routines expect rSVBK = 1 and leave SRAM closed unless stated.

; ---------------------------------------------------------------------------
; Box metadata access
; ---------------------------------------------------------------------------

GetStorageBoxMetadataAddress:
; in: b = box (1-based); out: hl = sNewBox{b}, SRAM bank open. Clobbers a.
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	push bc
	ld a, b
	dec a
	ld hl, sNewBox1
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	pop bc
	ret

GetStorageBoxPointer::
; in: b = box (1..NUM_BOXES), c = slot (1..MONS_PER_BOX)
; out: de = PokeDB pointer (e = 0 if the slot is empty)
; preserves bc, hl
	push hl
	push bc
	ld a, b
	and a
	jr z, .null ; party has no pointers
	cp NUM_BOXES + 1
	jr nc, .null
	call GetStorageBoxMetadataAddress
	; entry
	ld a, c
	dec a
	push hl
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	pop hl
	and a
	jr z, .null_close
	cp MONDB_ENTRIES + 1
	jr nc, .null_close ; sanitize garbage
	push af
	; pool bit
	ld de, sNewBox1Banks - sNewBox1
	add hl, de
	ld a, c
	dec a
	ld e, a
	ld d, 0
	ld b, CHECK_FLAG
	call FlagAction
	pop af
	ld e, a
	ld d, 1
	ld a, c
	and a
	jr z, .got_pointer
	inc d
.got_pointer
	call CloseSRAM
	pop bc
	pop hl
	ret

.null_close
	call CloseSRAM
.null
	ld de, 0
	pop bc
	pop hl
	ret

RemoveStorageBoxMon::
; Erases box b slot c (a box slot: sets the null pointer; a party slot: removes
; the mon from the party, shifting later members up).
	ld de, 0
	; fallthrough
SetStorageBoxPointer::
; Sets box b slot c to PokeDB pointer de. If b is 0 (party), de is loaded from
; storage and written into party slot c (appended if c is past the end), or the
; party slot is deleted if e is 0.
; Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld a, b
	and a
	jp z, .party
	cp NUM_BOXES + 1
	jp nc, .done
	call GetStorageBoxMetadataAddress
	ld a, c
	dec a
	push hl
	push de
	ld e, a
	ld d, 0
	add hl, de
	pop de
	ld [hl], e
	pop hl
	push de
	ld de, sNewBox1Banks - sNewBox1
	add hl, de
	pop de
	ld a, c
	dec a
	ld e, a
	ld b, RESET_FLAG
	dec d
	jr z, .got_flag_action
	ld b, SET_FLAG
.got_flag_action
	ld d, 0
	call FlagAction
	call CloseSRAM
	jr .done

.party
	ld a, e
	and a
	jr z, .delete_party_mon
	; load the record into wTempMon (wTempMonBox/Slot are not touched)
	call GetStorageMon
	jr z, .done ; empty entry: nothing to add
	ld a, [wPartyCount]
	cp c
	jr nc, .party_slot_exists
	; appending past the end: make it the last slot
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nc, .done
	inc a
	ld c, a
	ld [wPartyCount], a
	; terminate the species list
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], -1
.party_slot_exists
	call CopyTempToParty
	jr .done

.delete_party_mon
	ld a, [wPartyCount]
	cp c
	jr c, .done
	; shift the slot to the end, then drop it
	call ShiftPartySlotToEnd
	ld hl, wPartyCount
	dec [hl]
	ld a, [hl]
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], -1
	; clear the vacated party mail
	ld a, [wPartyCount]
	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	call AddNTimes
	ld a, BANK(sPartyMail)
	call GetSRAMBank
	ld bc, MAIL_STRUCT_LENGTH
	xor a
	call ByteFill
	call CloseSRAM
.done
	pop bc
	pop de
	pop hl
	ret

ShiftPartySlotToEnd:
; Shifts party slot c (1-based) to the end of the party by successive swaps.
; Preserves bc, de, hl.
	push hl
	push de
	push bc
.loop
	ld a, [wPartyCount]
	cp c
	jr z, .done
	jr c, .done
	ld e, c
	inc e
	call SwapPartyMons
	inc c
	jr .loop
.done
	pop bc
	pop de
	pop hl
	ret

SwapPartyMons::
; Swaps 1-based party slots c and e (structs, species list, nicknames, OT
; names and mail). Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld a, c
	cp e
	jr z, .done
	dec c
	dec e
	ld d, c
	; species list
	ld hl, wPartySpecies
	ld bc, 1
	call .Swap
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call .Swap
	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	call .Swap
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call .Swap
	ld a, BANK(sPartyMail)
	call GetSRAMBank
	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	call .Swap
	call CloseSRAM
.done
	pop bc
	pop de
	pop hl
	ret

.Swap:
; Swaps bc bytes between hl + d * bc and hl + e * bc, byte by byte
; (no scratch buffer: the d002 union may be live, e.g. Bug Contest results).
; Preserves de.
	push de
	ld a, e
	push af
	push hl
	ld a, d
	call AddNTimes ; hl = slot d
	pop de ; de = base
	pop af ; a = e
	push hl
	ld h, d
	ld l, e
	call AddNTimes ; hl = slot e
	pop de ; de = slot d
.swap_loop
	ld a, [de]
	push af
	ld a, [hl]
	ld [de], a
	pop af
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .swap_loop
	pop de
	ret

; ---------------------------------------------------------------------------
; Party <-> wTempMon
; ---------------------------------------------------------------------------

CopyPartyToTemp:
; Copies party slot c (1-based) into wTempMon and its extension.
	push hl
	push de
	push bc
	ld a, c
	dec a
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, wTempMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	dec a
	ld hl, wPartyMonOT
	call SkipNames
	ld de, wTempMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	pop bc
	push bc
	; egg flag from the species list
	ld a, c
	dec a
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	cp EGG
	ld a, 0
	jr nz, .not_egg
	inc a
.not_egg
	ld [wTempMonIsEgg], a
	ld a, [wTempMonSpecies]
	call GetPokemonIndexFromID
	ld a, l
	ld [wTempMonSpeciesIndex], a
	ld a, h
	ld [wTempMonSpeciesIndex + 1], a
	pop bc
	pop de
	pop hl
	ret

CopyTempToParty:
; Copies wTempMon and its extension into party slot c (1-based). Does not
; change wPartyCount.
	push hl
	push de
	push bc
	ld a, c
	dec a
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wTempMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	dec a
	ld hl, wPartyMonOT
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wTempMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	dec a
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [wTempMonIsEgg]
	and a
	ld a, EGG
	jr nz, .egg
	ld a, [wTempMonSpecies]
.egg
	ld [hl], a
	pop bc
	pop de
	pop hl
	ret

; ---------------------------------------------------------------------------
; Reading mons
; ---------------------------------------------------------------------------

GetStorageBoxMon::
; Loads box b slot c into wTempMon (+extension). Sets wTempMonBox/wTempMonSlot
; (slot 0 if the requested slot is empty).
; Returns z if the slot is empty, c if the record was corrupt (Bad Egg loaded),
; nz|nc otherwise. Preserves bc, de, hl.
	push hl
	push de
	push bc
	xor a
	ld [wTempMonSlot], a
	ld a, b
	ld [wTempMonBox], a
	and a
	jr z, .party
	call GetStorageBoxPointer
	call GetStorageMon
	jr z, .done
	ld a, c
	ld [wTempMonSlot], a
	jr .done

.party
	ld a, [wPartyCount]
	cp c
	jr c, .empty
	ld a, c
	and a
	jr z, .empty
	ld [wTempMonSlot], a
	call CopyPartyToTemp
	; make sure base data matches the loaded mon, like a decode would
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wTempMonIsEgg]
	and a
	ld a, EGG
	jr nz, .got_cur_species
	ld a, [wTempMonSpecies]
.got_cur_species
	ld [wCurPartySpecies], a
	or 1
	jr .done

.empty
	xor a
.done
	pop bc
	pop de
	pop hl
	ret

GetStorageMon::
; Loads PokeDB record de into wTempMon (+extension).
; Returns z if the entry is unallocated/null, c if it was corrupt (Bad Egg),
; nz|nc otherwise. Preserves bc, de, hl.
	push hl
	push de
	push bc
	call IsStorageUsed
	jr z, .done
	call OpenPokeDB
	call DecodeSavedMon ; closes SRAM; returns nz, c if Bad Egg
.done
	pop bc
	pop de
	pop hl
	ret

GetStorageBoxSpecies::
; Cheap read for icon drawing. in: b = box, c = slot.
; out: hl = species index (0 if empty), a = SAVEMON flags with bit 7 = shiny
;      (copied from the record's pokerus byte), bit 6 = male flag. z if empty.
; Party slots are read from the party list. Preserves bc, de.
	push de
	push bc
	ld a, b
	and a
	jr z, .party
	call GetStorageBoxPointer
	ld a, e
	and a
	jr z, .empty
	call IsStorageUsed
	jr z, .empty
	call OpenPokeDB
	push hl
	call VerifySavedMonChecksum
	pop hl
	jr nc, .valid
	; corrupt: report the Bad Egg
	call CloseSRAM
	ld hl, BadEggRecord
.valid
	; hl = record
	push hl
	ld bc, SAVEMON_FLAGS
	add hl, bc
	ld a, [hl]
	and 1 << SAVEMON_IS_EGG_F
	ld c, a
	pop hl
	push hl
	push bc
	ld bc, SAVEMON_PKRUS
	add hl, bc
	ld a, [hl]
	and MON_SHINY_FLAG | MON_MALE_FLAG
	pop bc
	or c
	ld c, a ; c = combined flags
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = species index
	ld a, c
	push af
	call CloseSRAM
	pop af
	ld b, a
	ld a, h
	or l ; z if empty
	ld a, b
	jr .done

.party
	ld a, [wPartyCount]
	cp c
	jr c, .empty
	ld a, c
	and a
	jr z, .empty
	dec a
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	cp EGG
	ld b, 0
	jr nz, .party_not_egg
	ld b, 1 << SAVEMON_IS_EGG_F
.party_not_egg
	ld a, c
	dec a
	ld hl, wPartyMon1Species
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	ld a, [hl]
	push hl
	call GetPokemonIndexFromID
	pop de
	push hl
	ld hl, MON_UNUSED
	add hl, de
	ld a, [hl]
	and MON_SHINY_FLAG | MON_MALE_FLAG
	or b
	pop hl
	ld b, a
	ld a, h
	or l
	ld a, b
	jr .done

.empty
	ld hl, 0
	xor a
.done
	pop bc
	pop de
	ret

; ---------------------------------------------------------------------------
; Allocation
; ---------------------------------------------------------------------------

NewStorageBoxPointer::
; Finds an empty logical slot, checking the current box first and then the
; following boxes with wraparound. Returns bc = box/slot and de = a free
; PokeDB pointer to place the mon at, plus:
;   nc|z : space in the current box
;   nc|nz: current box full, space found elsewhere
;   c|z  : every box is full
;   c|nz : logical space exists but the database is full until the game is saved
; Preserves wTempMon.
	ld a, [wCurBox]
	inc a
	ld b, a
	ld d, NUM_BOXES
.outer_loop
	ld c, 1
.inner_loop
	push de
	call GetStorageBoxPointer
	ld a, e
	pop de
	and a
	jr z, .found_free_space
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr nz, .inner_loop
	ld a, b
	inc b
	cp NUM_BOXES
	jr nz, .dont_wrap_box
	ld b, 1
.dont_wrap_box
	dec d
	jr nz, .outer_loop
	; storage completely full
	xor a
	scf
	ret

.found_free_space
	call NewStoragePointer
	jr nc, .storage_ok
	or 1
	scf
	ret

.storage_ok
	ld a, [wCurBox]
	inc a
	cp b
	ret z
	or 1
	ret

NewStoragePointer::
; Sets de to an unallocated PokeDB entry. Returns carry if none is free even
; after flushing. Preserves bc, hl and wTempMon.
	push hl
	push bc
	call .GetStorage
	jr nc, .done
	call FlushStorageSystem
	call .GetStorage
.done
	pop bc
	pop hl
	ret

.GetStorage:
	ld d, 1
.outer_loop
	ld e, 1
.inner_loop
	call IsStorageUsed
	jr z, .found_free_space
	inc e
	ld a, e
	cp MONDB_ENTRIES + 1
	jr nz, .inner_loop
	inc d
	ld a, d
	cp 3
	jr nz, .outer_loop
	scf
	ret
.found_free_space
	and a
	ret

FlushStorageSystem::
; Rebuilds the allocation bitmaps from the active and backup box metadata.
; Orphaned records (referenced by neither snapshot) become free.
	push hl
	push de
	push bc
	xor a
	ld hl, wPokeDB1UsedEntries
	ld bc, wPokeDB2UsedEntriesEnd - wPokeDB1UsedEntries
	call ByteFill
	ld b, 1
.outer_loop
	ld c, 1
.inner_loop
	call .GetAnySnapshotPointer
	call SetStorageAllocationFlag ; no-op for e = 0
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr nz, .inner_loop
	ld a, b
	inc b
	cp NUM_BOXES * 2 ; active then backup
	jr nz, .outer_loop
	pop bc
	pop de
	pop hl
	ret

.GetAnySnapshotPointer:
; Like GetStorageBoxPointer but b may also address backup boxes
; (NUM_BOXES + 1 .. NUM_BOXES * 2). Entry numbers are sanitized.
	push hl
	push bc
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	ld a, b
	dec a
	ld hl, sNewBox1
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	pop bc
	push bc
	ld a, c
	dec a
	push hl
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	pop hl
	and a
	jr z, .null
	cp MONDB_ENTRIES + 1
	jr nc, .null
	push af
	ld de, sNewBox1Banks - sNewBox1
	add hl, de
	ld a, c
	dec a
	ld e, a
	ld d, 0
	ld b, CHECK_FLAG
	call FlagAction
	pop af
	ld e, a
	ld d, 1
	ld a, c
	and a
	jr z, .got
	inc d
.got
	call CloseSRAM
	pop bc
	pop hl
	ret
.null
	call CloseSRAM
	ld de, 0
	pop bc
	pop hl
	ret

CheckFreeDatabaseEntries::
; Flushes, then returns the number of unallocated PokeDB entries in a
; (capped at 255). Clobbers bc, hl.
	call FlushStorageSystem
	; fallthrough
_CheckFreeDatabaseEntries:
	ld hl, wPokeDB1UsedEntries
	call .CountFree
	push bc
	ld hl, wPokeDB2UsedEntries
	call .CountFree
	pop bc
	add c
	ret nc
	ld a, 255
	ret

.CountFree:
	ld b, (MONDB_ENTRIES + 7) / 8
	call CountSetBits
	cpl
	add MONDB_ENTRIES + 1
	ld c, a
	ret

EnsureStorageSpace::
; in: a = required free entries. Returns z if at least that many are free,
; flushing only if the quick count is insufficient.
	ld b, a
	push bc
	call _CheckFreeDatabaseEntries
	pop bc
	cp b
	sbc a
	ret z
	push bc
	call CheckFreeDatabaseEntries
	pop bc
	cp b
	sbc a
	ret

AllocateStorageFlag:
; Marks pointer de as used. Returns nz if it was already in use.
	call IsStorageUsed
	ret nz
	call SetStorageAllocationFlag
	xor a
	ret

IsStorageUsed::
; Returns z if PokeDB pointer de is unused (or null). Preserves bc, de, hl.
	ld a, CHECK_FLAG
	jr StorageFlagAction
SetStorageAllocationFlag:
	ld a, SET_FLAG
	; fallthrough
StorageFlagAction:
; Performs flag action a on the allocation bit of pointer de.
	inc e
	dec e
	jr nz, .not_null
	xor a
	ret
.not_null
	push hl
	push de
	push bc
	ld b, a
	ld a, d
	dec a
	ld hl, wPokeDB1UsedEntries
	jr z, .got_bitmap
	ld hl, wPokeDB2UsedEntries
.got_bitmap
	dec e
	ld d, 0
	call FlagAction
	ld a, c
	and a
	pop bc
	pop de
	pop hl
	ret

OpenPokeDB::
; Opens the SRAM bank holding PokeDB pointer de and returns its address in hl.
; Clobbers a, bc.
	ld a, d
	dec a
	ld hl, .Pool1Sections
	jr z, .got_pool
	ld hl, .Pool2Sections
.got_pool
	ld a, e
	dec a ; 0-based entry
	cp MONDB_ENTRIES_A
	jr c, .got_section
	inc hl
	inc hl
	inc hl
	cp MONDB_ENTRIES_A + MONDB_ENTRIES_B
	jr c, .got_section
	inc hl
	inc hl
	inc hl
.got_section
	push af
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld bc, SAVEMON_STRUCT_LENGTH
	jp AddNTimes

pokedb_section: MACRO
; bank, base address such that base + entry * SAVEMON_STRUCT_LENGTH addresses the record
	db BANK(\1)
	dw (\1) - (\2) * SAVEMON_STRUCT_LENGTH
ENDM

.Pool1Sections:
	pokedb_section sBoxMons1A, 0
	pokedb_section sBoxMons1B, MONDB_ENTRIES_A
if MONDB_ENTRIES_C > 0
	pokedb_section sBoxMons1C, MONDB_ENTRIES_A + MONDB_ENTRIES_B
else
	pokedb_section sBoxMons1B, MONDB_ENTRIES_A ; never selected
endc
.Pool2Sections:
	pokedb_section sBoxMons2A, 0
	pokedb_section sBoxMons2B, MONDB_ENTRIES_A
if MONDB_ENTRIES_C > 0
	pokedb_section sBoxMons2C, MONDB_ENTRIES_A + MONDB_ENTRIES_B
else
	pokedb_section sBoxMons2B, MONDB_ENTRIES_A
endc

; ---------------------------------------------------------------------------
; Writing mons
; ---------------------------------------------------------------------------

AddStorageMon::
; Encodes wTempMon into PokeDB entry de and marks it allocated. Does nothing
; if e = 0. Returns carry if the entry was already allocated (bug guard: the
; record is left untouched). Preserves bc, de, hl.
	ld a, e
	and a
	ret z
	push hl
	push de
	push bc
	call AllocateStorageFlag
	jr nz, .collision
	call OpenPokeDB
	call EncodeSavedMon ; closes SRAM
	and a
	jr .done
.collision
	scf
.done
	pop bc
	pop de
	pop hl
	ret

UpdateStorageBoxMonFromTemp::
; Writes wTempMon back to the location it was loaded from (wTempMonBox /
; wTempMonSlot). Party slots are overwritten in place; box slots get a fresh
; record (copy on write). Returns z on success, nz if no record could be
; allocated (the old record stays in place; save the game and retry).
	ld a, [wTempMonSlot]
	ld c, a
	and a
	ret z ; nothing loaded: report failure (nz)
	ld a, [wTempMonBox]
	ld b, a
	and a
	jr nz, .box
	call CopyTempToParty
	xor a
	ret

.box
	; Release the current pointer first so that repeated updates of the same
	; mon within one session can recycle its own (active-only) record.
	call GetStorageBoxPointer
	push de
	ld e, 0
	call SetStorageBoxPointer
	call NewStoragePointer
	jr nc, .found_entry
	; nothing free: restore the old pointer
	pop de
	call SetStorageBoxPointer
	or 1
	ret

.found_entry
	call AddStorageMon
	jr c, .restore
	call SetStorageBoxPointer
	pop de
	xor a
	ret
.restore
	pop de
	call SetStorageBoxPointer
	or 1
	ret

; ---------------------------------------------------------------------------
; Swapping
; ---------------------------------------------------------------------------

SwapStorageBoxSlots::
; Moves/swaps the mon at de (box d, slot e) with bc (box b, slot c). If c is
; 0 the first free slot of box b is used. Returns in a:
;   PCSWAP_OK, PCSWAP_SAVE_REQUIRED, PCSWAP_PARTY_FULL, PCSWAP_BOX_FULL,
;   PCSWAP_LAST_HEALTHY, PCSWAP_HOLDING_MAIL
; Preserves de; bc is updated to the effective slot when c was 0.
	ld h, -1
	ld a, b
	cp d
	ld a, c
	jr nz, .not_equal
	ld h, e
	cp e
	jr nz, .not_equal
.done_ok
	xor a ; PCSWAP_OK
	ret
.not_equal
	push de
	and a
	jr nz, .got_dest
	ld e, PARTY_LENGTH
	ld a, b
	and a
	jr z, .dest_loop
	ld e, MONS_PER_BOX
.dest_loop
	inc c
	push hl
	call .IsSlotEmpty
	pop hl
	jr z, .got_dest
	ld a, c
	cp h
	jr nz, .dest_next
	; ran into ourselves while looking for a blank: no-op
	pop de
	jr .done_ok
.dest_next
	cp e
	jr nz, .dest_loop
	pop de
	cp MONS_PER_BOX
	ld a, PCSWAP_PARTY_FULL
	ret c
	inc a ; PCSWAP_BOX_FULL
	ret

.got_dest
	pop de
	push de
	push bc
	call .do_it
	pop bc
	pop de
	ret

.IsSlotEmpty:
; z if box b slot c is empty
	ld a, b
	and a
	jr z, .party_slot
	push de
	call GetStorageBoxPointer
	ld a, e
	pop de
	and a
	ret
.party_slot
	ld a, [wPartyCount]
	cp c
	ccf
	sbc a ; -1 if slot occupied
	and a
	ret

.do_it
	; ensure b <= d so party->box and box->party are handled alike
	ld a, d
	cp b
	jr nc, .dont_swap
	push bc
	ld b, d
	ld c, e
	pop de
.dont_swap
	ld a, d
	and a
	jr z, .party_swap
	ld a, b
	and a
	jr nz, .box_swap

	; party slot bc <-> box slot de
	push de
	push bc
	ld a, c
	dec a
	ld [wCurPartyMon], a
	call GetStorageBoxMon ; loads party mon (if any) into wTempMon
	jr z, .not_last_healthy
	ld a, [wTempMonItem]
	call StorageItemIsMail
	ld a, PCSWAP_HOLDING_MAIL
	jr c, .pop_bcde_and_return
	call CheckCurPartyMonFainted
	jr nc, .not_last_healthy
	; the box mon must be healthy (it always is: stored mons are fully healed)
	; unless it is an Egg or there is no box mon at all
	pop bc
	pop de
	push de
	push bc
	push bc
	ld b, d
	ld c, e
	call GetStorageBoxMon
	jr z, .no_boxmon
	ld a, [wTempMonIsEgg]
	and a
	jr nz, .no_boxmon
	ld hl, wTempMonHP
	ld a, [hli]
	or [hl]
.no_boxmon
	pop bc
	push af
	call GetStorageBoxMon ; wTempMon = party mon again
	pop af
	jr nz, .not_last_healthy
	ld a, PCSWAP_LAST_HEALTHY
.pop_bcde_and_return
	pop bc
	pop de
	ret

.not_last_healthy
	pop bc
	ld de, 0
	ld a, [wTempMonSlot]
	and a
	jr z, .found_new_pokedb ; party slot was empty: box slot just gets nulled
	call NewStoragePointer
	jr nc, .found_new_pokedb
	pop de
	ld a, PCSWAP_SAVE_REQUIRED
	ret

.found_new_pokedb
	call AddStorageMon
	pop hl ; box slot
	push bc ; party slot
	ld b, h
	ld c, l
	push de ; new pointer
	call GetStorageBoxPointer ; de = old box pointer
	ld h, d
	ld l, e
	pop de
	push hl
	call SetStorageBoxPointer ; box slot <- new record (or null)
	pop de
	pop bc
	call SetStorageBoxPointer ; party slot <- old box record (or removed)
	xor a
	ret

.party_swap
	ld a, [wPartyCount]
	cp c
	jr c, .shift
	call SwapPartyMons
	xor a
	ret
.shift
	ld c, e
	call ShiftPartySlotToEnd
	xor a
	ret

.box_swap
	push de
	call GetStorageBoxPointer ; de = A's pointer
	pop hl ; slot B
	push bc ; slot A
	ld b, h
	ld c, l
	push de ; A's pointer
	call GetStorageBoxPointer ; de = B's pointer
	ld h, d
	ld l, e
	pop de
	push hl
	call SetStorageBoxPointer ; slot B <- A's pointer
	pop de
	pop bc
	call SetStorageBoxPointer ; slot A <- B's pointer
	xor a
	ret

CheckCurPartyMonFainted::
; Returns carry if every party mon other than [wCurPartyMon] has 0 HP.
	ld hl, wPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, 0
.loop
	ld a, [wCurPartyMon]
	cp b
	jr z, .skip
	ld a, [hli]
	or [hl]
	jr nz, .notfainted
	dec hl
.skip
	inc b
	ld a, [wPartyCount]
	cp b
	jr z, .done
	add hl, de
	jr .loop
.done
	scf
	ret
.notfainted
	and a
	ret

; ---------------------------------------------------------------------------
; Placing a new mon (catch, gift, egg, ...)
; ---------------------------------------------------------------------------

AddTempMonToStorage::
; Stores wTempMon (+extension) in the first free box slot, current box first.
; Returns a = PCSTORE_* (see constants/pc_constants.asm). On PCSTORE_CUR_BOX
; and PCSTORE_OTHER_BOX the mon was stored and wTempMonBox/Slot point at it;
; wCurBox is NOT changed here (see CurBoxFullCheck).
	call NewStorageBoxPointer
	jr c, .failed
	push af
	call AddStorageMon
	call SetStorageBoxPointer
	ld a, b
	ld [wTempMonBox], a
	ld a, c
	ld [wTempMonSlot], a
	pop af
	ld a, PCSTORE_CUR_BOX
	ret z
	inc a ; PCSTORE_OTHER_BOX
	ret
.failed
	ld a, PCSTORE_FULL
	ret z
	inc a ; PCSTORE_SAVE_REQUIRED
	ret

CurBoxFullCheck::
; After AddTempMonToStorage: returns z if the mon went into the current box
; (or nowhere). Otherwise copies the old current box's name to wStringBuffer1,
; switches wCurBox to the box that received the mon and returns nz.
	ld a, [wTempMonBox]
	and a
	ret z
	dec a
	ld b, a
	ld a, [wCurBox]
	cp b
	ret z
	push bc
	call GetCurBoxName
	pop bc
	ld a, b
	ld [wCurBox], a
	or 1
	ret

; ---------------------------------------------------------------------------
; Names and themes
; ---------------------------------------------------------------------------

GetCurBoxName::
; Writes the current box's name to wStringBuffer1 (terminated).
	ld a, [wCurBox]
	inc a
	ld b, a
	; fallthrough
GetBoxName::
; Writes the name of box b (1-based) to wStringBuffer1 (terminated).
	ld c, 0
	call CopyBoxName
	ld a, "@"
	ld [wStringBuffer1 + BOX_NAME_LENGTH], a
	ret

SetBoxName::
; Copies wStringBuffer1 (BOX_NAME_LENGTH bytes) into box b's name.
	ld c, 1
	; fallthrough
CopyBoxName:
	push bc
	call GetStorageBoxMetadataAddress
	ld de, sNewBox1Name - sNewBox1
	add hl, de
	ld de, wStringBuffer1
	pop bc
	dec c
	jr nz, .copy
	; swap hl and de
	ld a, h
	ld h, d
	ld d, a
	ld a, l
	ld l, e
	ld e, a
.copy
	ld bc, BOX_NAME_LENGTH
	call CopyBytes
	jp CloseSRAM

GetBoxTheme::
; Returns [wCurBox]'s theme in a. Preserves bc, de, hl.
	push hl
	push bc
	call PointCurBoxTheme
	ld a, [hl]
	call CloseSRAM
	pop bc
	pop hl
	ret

SetBoxTheme::
; Sets [wCurBox]'s theme to a. Preserves bc, de, hl.
	push hl
	push bc
	push af
	call PointCurBoxTheme
	pop af
	ld [hl], a
	call CloseSRAM
	pop bc
	pop hl
	ret

PointCurBoxTheme:
	ld a, [wCurBox]
	inc a
	ld b, a
	call GetStorageBoxMetadataAddress
	ld bc, sNewBox1Theme - sNewBox1
	add hl, bc
	ret

; ---------------------------------------------------------------------------
; Initialization, save and load
; ---------------------------------------------------------------------------

InitializeBoxes::
; New game: empties the active boxes, names them "BOX 1".., assigns default
; themes, sanitizes the backup snapshot and rebuilds allocations.
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	; clear all active metadata
	ld hl, sNewBox1
	ld bc, sNewBoxEnd - sNewBox1
	xor a
	call ByteFill
	; names: "BOX 1".."BOX 25", "@"-padded
	ld hl, sNewBox1Name
	ld c, 1
.name_loop
	push bc
	push hl
	ld a, "@"
	ld bc, BOX_NAME_LENGTH
	call ByteFill
	pop hl
	push hl
	ld d, h
	ld e, l
	ld hl, .BoxStr
	ld bc, .BoxStrEnd - .BoxStr
	call CopyBytes ; de = after "BOX "
	pop hl
	pop bc
	push bc
	push hl
	ld h, d
	ld l, e
	ld a, c
	ld b, "0"
.tens_loop
	sub 10
	jr c, .ones
	inc b
	jr .tens_loop
.ones
	add 10
	add "0"
	ld c, a
	ld a, b
	cp "0"
	jr z, .no_tens
	ld [hli], a
.no_tens
	ld [hl], c
	pop hl
	pop bc
	ld de, sNewBox2 - sNewBox1
	add hl, de
	inc c
	ld a, c
	cp NUM_BOXES + 1
	jr nz, .name_loop
	; themes
	ld hl, sNewBox1Theme
	ld de, BillsPC_DefaultBoxThemes
	ld b, NUM_BOXES
.theme_loop
	ld a, [de]
	inc de
	cp -1
	jr nz, .got_theme
	dec de
	ld a, THEME_STANDARD
.got_theme
	ld [hl], a
	push de
	ld de, sNewBox2 - sNewBox1
	add hl, de
	pop de
	dec b
	jr nz, .theme_loop
	; sanitize backup entries (may be garbage on a fresh cartridge)
	ld hl, sBackupNewBox1Entries
	ld b, NUM_BOXES
.outer_backup_loop
	ld c, MONS_PER_BOX
.inner_backup_loop
	ld a, [hl]
	cp MONDB_ENTRIES + 1
	jr c, .valid_entry
	xor a
.valid_entry
	ld [hli], a
	dec c
	jr nz, .inner_backup_loop
	ld de, sBackupNewBox2 - sBackupNewBox1 - MONS_PER_BOX
	add hl, de
	dec b
	jr nz, .outer_backup_loop
	call CloseSRAM
	jp FlushStorageSystem

.BoxStr:
	db "BOX "
.BoxStrEnd:

INCLUDE "data/pc/default_box_themes.asm"

ClearBackupBoxes::
; Called when a save file is erased for a new game: invalidates the backup
; snapshot so old records can be reclaimed.
	ld a, BANK(sBackupNewBox1)
	call GetSRAMBank
	ld hl, sBackupNewBox1
	ld bc, sBackupNewBoxEnd - sBackupNewBox1
	xor a
	call ByteFill
	jp CloseSRAM

SaveStorageSystem::
; Copies the active box metadata to the backup snapshot.
	ld hl, sNewBox1
	ld de, sBackupNewBox1
	jr CopyStorageSystem

LoadStorageSystem::
; Copies the backup snapshot to the active metadata and rebuilds allocations.
	ld hl, sBackupNewBox1
	ld de, sNewBox1
	call CopyStorageSystem
	jp FlushStorageSystem

CopyStorageSystem:
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	ld bc, sNewBoxEnd - sNewBox1
	call CopyBytes
	jp CloseSRAM

; ---------------------------------------------------------------------------
; Navigation helpers for the summary screen
; ---------------------------------------------------------------------------

PrevStorageBoxMon::
; Loads the previous occupied slot before wTempMonBox/wTempMonSlot.
; Returns nz on success (wTempMon updated); z and unchanged otherwise.
	push bc
	ld a, [wTempMonSlot]
	ld b, a
	ld c, a
.loop
	dec c
	jr z, .restore_slot
	push bc
	ld a, [wTempMonBox]
	ld b, a
	call GetStorageBoxMon
	pop bc
	jr nz, .done
	jr .loop
.restore_slot
	ld a, b
	ld [wTempMonSlot], a
	xor a
.done
	pop bc
	ret

NextStorageBoxMon::
; Loads the next occupied slot after wTempMonBox/wTempMonSlot.
; Returns nz on success; z and unchanged otherwise.
	push bc
	ld a, [wTempMonSlot]
	ld b, a
	ld c, a
.loop
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr z, .restore_slot
	push bc
	ld a, [wTempMonBox]
	ld b, a
	call GetStorageBoxMon
	pop bc
	jr nz, .done
	ld a, [wTempMonBox]
	and a
	jr nz, .loop
	; party: past the end
.restore_slot
	ld a, b
	ld [wTempMonSlot], a
	xor a
.done
	pop bc
	ret

; ---------------------------------------------------------------------------
; Codec
; ---------------------------------------------------------------------------

INCLUDE "engine/pc/storage_codec.asm"

CheckStorageSpaceForCapture::
; Returns nc if a newly caught mon can be stored (a free logical slot and at
; least two free records: one to store, one to commit caught data/nickname).
; Otherwise returns carry with a = PCSTORE_FULL or PCSTORE_SAVE_REQUIRED.
	call NewStorageBoxPointer
	jr c, .failed
	ld a, 2
	call EnsureStorageSpace
	ret z ; z: enough (nc, since EnsureStorageSpace leaves carry clear on z)
	ld a, PCSTORE_SAVE_REQUIRED
	scf
	ret
.failed
	ld a, PCSTORE_FULL
	ret z ; c|z
	ld a, PCSTORE_SAVE_REQUIRED
	scf
	ret

GetStorageBoxMonID::
; Cheap read of box b slot c's OT ID (de) and egg flag (a, nonzero = Egg)
; without decoding. Returns z if the slot is empty. Preserves bc, hl.
	push hl
	push bc
	call GetStorageBoxPointer
	ld a, e
	and a
	jr z, .empty
	call IsStorageUsed
	jr z, .empty
	call OpenPokeDB
	push hl
	ld bc, SAVEMON_ID
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	ld bc, SAVEMON_FLAGS
	add hl, bc
	ld a, [hl]
	and 1 << SAVEMON_IS_EGG_F
	ld b, a
	call CloseSRAM
	ld a, b
	or 1
	ld a, b
	jr .done
.empty
	ld de, 0
	xor a
.done
	pop bc
	pop hl
	ret

StorageItemIsMail::
; Returns carry if item a is Mail. Same-bank copy of ItemIsMail (mail_2.asm)
; so the backend never crosses a bank with a plain call. Preserves bc, de.
	push hl
	push de
	push bc
	ld hl, .MailItems
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl
	ret

.MailItems:
	db FLOWER_MAIL
	db SURF_MAIL
	db LITEBLUEMAIL
	db PORTRAITMAIL
	db LOVELY_MAIL
	db EON_MAIL
	db MORPH_MAIL
	db BLUESKY_MAIL
	db MUSIC_MAIL
	db MIRAGE_MAIL
	db -1

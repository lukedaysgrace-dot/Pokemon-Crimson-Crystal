CheckCurPartyMonFainted:
	ld hl, wPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, $0
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

SwapStorageBoxSlots:
; Swaps slots from de to bc. Preserves de, while bc is changed to a proper slot
; if c is 0, otherwise preserved. Equivalent to bc->de except c may be 0 to mean
; "put anywhere in the party/box". Returns the following in a:
; 0: Successful swap
; 1: Save is required to perform the swap
; 2: The party is full
; 3: The box is full
; 4: Doing this would remove the last healthy mon in party
; 5: Can't move partymon to Box, because they're holding Mail.
	; Compare source->dest to see if we're "moving" something with itself.
	ld h, -1
	ld a, b
	cp d
	ld a, c
	jr nz, .not_equal
	ld h, e
	cp e
	jr nz, .not_equal
.done
	xor a ; PCSWAP_OK
	ret
.not_equal
	; Convert destination slot 0 to a real destination, if we can.
	push de
	and a ; a is c from beforehand.
	jr nz, .got_dest

	ld e, PARTY_LENGTH
	ld a, b
	and a
	jr z, .dest_loop
	ld e, MONS_PER_BOX
.dest_loop
	inc c
	call GetStorageBoxMon
	jr z, .got_dest
	ld a, c
	cp h
	jr nz, .dest_next

	; We encountered our current entry while seeking for blank entries. This
	; basically makes this a no-op (since there's no earlier blank entry), so
	; return early.
	pop de
	jr .done

.dest_next
	cp e
	jr nz, .dest_loop

	; Party (or Box) is full
	pop de
	cp MONS_PER_BOX
	ld a, PCSWAP_PARTY_FULL
	ret c
	inc a ; PCSWAP_BOX_FULL
	ret

.got_dest
	pop de

	; Now that we have proper slots, preserve bcde from this point.
	push de
	push bc
	call .do_it
	pop bc
	pop de
	ret

.do_it
	; If d<b, swap bc and de. The reason for this is that we want to handle
	; party->box movement the same way as box->party.
	ld a, d
	cp b
	jr nc, .dont_swap
	push bc
	ld b, d
	ld c, e
	pop de
.dont_swap
	; At this point, b<=d. So if d is party, we're swapping party members, and
	; if b is nonparty (i.e. >0), we're swapping between box slots.
	; Otherwise, we're swapping a party slot bc to box slot de.
	ld a, d
	and a
	jr z, .party_swap
	ld a, b
	and a
	jr nz, .box_swap

	; We're swapping a party and box slot. First, verify that we're not losing
	; our last healthy mon and that the partymon isn't holding Mail.
	push de
	push bc
	ld a, c

	; This is required for CheckCurPartyMonFainted
	dec a
	ld [wCurPartyMon], a

	; Is the party slot occupied? Also writes the partymon to wTempMon.
	call GetStorageBoxMon
	jr z, .not_last_healthy

	; Check if the partymon is holding Mail. We can't store Mail in a Box.
	ld a, [wTempMonItem]
	call ItemIsMail_a
	ld a, PCSWAP_HOLDING_MAIL
	jr c, .pop_bcde_and_return

	; Otherwise, check if it is our last healthy mon.
	call CheckCurPartyMonFainted
	jr nc, .not_last_healthy

	; Check if the box mon is healthy.
	pop bc
	pop de
	push de
	push bc
	push bc
	ld b, d
	ld c, e
	call GetStorageBoxMon
	jr z, .no_boxmon
	ld hl, wTempMonHP
	ld a, [hli]
	or [hl]
.no_boxmon
	pop bc

	; Ensure that we return with wTempMon pointing towards the partymon.
	push af
	call GetStorageBoxMon
	pop af
	jr nz, .not_last_healthy

	; Doing this would lose us our last healthy mon, so abort.
	ld a, PCSWAP_LAST_HEALTHY
.pop_bcde_and_return
	pop bc
	pop de
	ret

.not_last_healthy
	pop bc

	; Try to allocate a new pokedb pointer, unless the party slot was empty.
	ld de, 0 ; in case we're blanking the box slot
	ld a, [wTempMonSlot]
	and a
	call nz, NewStoragePointer
	jr nc, .found_new_pokedb

	; The pokedb is full, we need to save first.
	pop de
	ld a, PCSWAP_SAVE_REQUIRED
	ret

.found_new_pokedb
	call AddStorageMon

	; Get the current pokedb pointer in the box slot for writing to party.
	pop hl ; Box slot
	push bc ; Party slot
	ld b, h
	ld c, l
	push de ; New pokedb pointer
	call GetStorageBoxPointer
	ld h, d
	ld l, e
	pop de
	push hl ; Previous pokedb pointer
	call SetStorageBoxPointer

	; Now, write previous pointer to party, then we're done.
	pop de
	pop bc
	call SetStorageBoxPointer
	xor a ; PCSWAP_OK
	ret

.party_swap
	; Check if we're placing a mon in a blank party slot. This means we're
	; shifting every other party member upwards, placing the held mon last.
	ld a, [wPartyCount]
	cp c
	jr c, .shift
	call SwapPartyMons
	xor a
	ret

.shift
	; Shift the held mon until it's last in the party.
	ld c, e
	call ShiftPartySlotToEnd
	xor a
	ret

.box_swap
	; Swaps 2 box pointers between box slot A in bc and slot B in de

	push de ; Slot B
	call GetStorageBoxPointer ; de = A's pointer
	pop hl ; hl = Slot B

	push bc ; Slot A
	ld b, h
	ld c, l ; bc = Slot B
	push de ; A's pointer
	call GetStorageBoxPointer ; de = B's pointer
	ld h, d
	ld l, e ; hl = B's pointer
	pop de ; de = A's pointer
	push hl
	call SetStorageBoxPointer ; Set Slot B (bc) to have A's pointer (de)
	pop de ; de = B's pointer
	pop bc ; bc = Slot A
	call SetStorageBoxPointer ; Set Slot A (bc) to have B's pointer (de)

	; We're done
	xor a
	ret

SwapPartyMonMail:
	push hl
	push de
	push bc
	dec c
	dec e
	ld d, c
	jr DoMailSwap

SwapPartyMons:
; Swap 1-indexed partymon c and e. Preserves bc, de, hl.
; TODO: this is more efficient than SwitchPartyMons, maybe make it use this.
	push hl
	push de
	push bc
	dec c
	dec e
	ld d, c

	; Swap partymon struct
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call DoPartySwap

	; Swap nickname
	ld hl, wPartyMonNicknames
	ld c, MON_NAME_LENGTH
	call DoPartySwap

	; Swap OT name
	ld hl, wPartyMonOT
	ld c, NAME_LENGTH
	call DoPartySwap

	; fallthrough
DoMailSwap:
	; Swap Mail
	ld a, BANK(sPartyMon1Mail)
	call GetSRAMBank
	ld hl, sPartyMon1Mail
	ld bc, MAIL_STRUCT_LENGTH
	call DoPartySwap
	call CloseSRAM
	jp PopBCDEHL

DoPartySwap:
; Swaps bc bytes between hl+d*bc and hl+e*bc
	; Get pointers to swap
	push de
	push hl
	ld a, d
	call AddNTimes
	ld a, e
	ld d, h
	ld e, l
	pop hl
	call AddNTimes
	; Now hl and de points to which bytes to swap

	push de
	ld de, wSwitchMonBuffer
	push bc
	push hl
	call CopyBytes
	pop de
	pop bc
	pop hl
	push hl
	push bc
	call CopyBytes
	pop bc
	pop de
	ld hl, wSwitchMonBuffer
	call CopyBytes
	pop de
	ret

NewStorageBoxPointer:
; Sets bcde to an unused box storage location. Preserves wTempMon. Returns:
; nc|z: Active box has free space
; nc|nz: Active box full, space found elsewhere
; c|z: Storage System filled completely.
; c|nz: Storage System has space, but the database is full. Save to free space.
	; Figure out if we have space in the storage system. Check active box first,
	; then other boxes in sequence until we loop back to the active box. We loop
	; upwards, despite downwards generally being more efficient for UI benefit,
	; since we want to place mons starting at the beginning of a box, rather
	; than the end).
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

	; Storage system completely filled.
	scf
	ret

.found_free_space
	; Check if there's a free database entry.
	call NewStoragePointer
	jr nc, .storage_ok

	; If we still have no space left, we need to save.
	or 1
	scf
	ret

.storage_ok
	; Returns z if the new storage was found in our active box, nz otherwise.
	; Always return nc.
	ld a, [wCurBox]
	inc a
	cp b
	ret z
	or 1
	ret

NewStoragePointer:
; Sets de to an unused pokedb entry. Returns c if none was found.
; Preserves wTempMon.
	; Try twice, flushing the database if the first one failed.
	call .GetStorage
	ret nc
	call FlushStorageSystem
	; fallthrough
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
	ccf
	jr nc, .outer_loop
	ret
.found_free_space
	xor a
	ret

FlushStorageSystem:
; Frees up orphaned pokedb entries and reallocates used entries. Beware of soft-
; resets and make sure this process completes before loading up a game.
	ld a, BANK(wPokeDB1UsedEntries)
	call StackCallInWRAMBankA
.Function:
	push hl
	push de
	push bc

	; Clear used pokedb entries.
	xor a
	ld hl, wPokeDB1UsedEntries
	ld bc, wPokeDB2UsedEntriesEnd - wPokeDB1UsedEntries
	call ByteFill

	; Now, set flags as per box usage.
	ld b, 1
.outer_loop
	ld c, 1
.inner_loop
	call GetStorageBoxPointer
	; If e==0 (null entry), this will not set any flag.
	call SetStorageAllocationFlag
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr nz, .inner_loop
	ld a, b
	inc b
	cp NUM_BOXES * 2 ; current + backup
	jr nz, .outer_loop
	jp PopBCDEHL

GetStorageBoxPointer:
; Returns the pokedb bank+entry in de for box b, slot c.
	; Ensure that we're dealing with an actual box and not a partymon.
	ld a, b
	and a
	ld a, ERR_PC_BOX_ZERO
	jp z, Crash

	ld a, BANK(sNewBox1)
	call GetSRAMBank

	push hl
	push bc
	ld a, b
	ld hl, sNewBox1Entries - (sNewBox2 - sNewBox1)
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	pop bc
	push bc
	dec c
	ld b, 0
	push hl
	add hl, bc
	ld e, [hl]
	pop hl
	ld c, sNewBox1Banks - sNewBox1Entries
	add hl, bc
	pop bc
	push bc
	dec c
	ld d, 1 ; will cause a useless bankswitch in flag checking, but that's OK
	ld b, CHECK_FLAG
	call SmallFlagAction
	pop bc
	jr z, .got_bank
	inc d
.got_bank
	pop hl
	jp CloseSRAM

UpdateStorageBoxMonFromTemp:
; Updates storage pointed to by wTempMonBox+wTempMonSlot with content in
; wTempMon. If this is part of a Box, this allocates a new entry.
; Returns z if successful.
	; Just run a simple copy if we're updating the party.
	ld a, [wTempMonSlot]
	ld c, a
	ld a, [wTempMonBox]
	ld b, a
	and a
	jp z, CopyBetweenPartyAndTemp

	; Otherwise, we need to allocate a new box entry.
	; Erase the current entry before trying to find a new one.
	; This code exists to gurantee that should the storage commit work once,
	; it will always continue to work for the same tempmon session without an
	; enforced save inbetween. Without it, the code could use up the last entry
	; the first write, then fail to reuse the same entry later.
	call GetStorageBoxPointer
	push de
	ld e, 0
	call SetStorageBoxPointer
	push bc
	call NewStoragePointer
	pop bc
	jr nc, .found_entry
	pop de

	; We failed to find a new entry. Restore the current box pointer.
	call SetStorageBoxPointer
	or 1
	ret

.found_entry
	call AddStorageMon
	call SetStorageBoxPointer
	pop de
	xor a
	ret

RemoveStorageBoxMon:
; Erases box b slot c. Done by simply just setting it to a null entry.
	ld e, 0
	; fallthrough
SetStorageBoxPointer:
; Sets box b slot c to have storage pointer de. If bc is a party slot, will
; fill it with the pokedb entry in de, or empty the slot (potentially shifting
; later party members upwards) if de is a null slot.
	push hl
	push de
	push bc

	; Are we dealing with a party slot?
	ld a, b
	and a
	jr z, .party

	; We're dealing with a box, so set box pointer appropriately.
	ld a, BANK(sNewBox1)
	call GetSRAMBank

	; Get the correct box.
	ld a, b
	ld hl, sNewBox1Entries - (sNewBox2 - sNewBox1)
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	pop bc
	push bc

	; Get the corret slot and write the db entry to it.
	dec c
	ld b, 0
	push hl
	add hl, bc
	ld [hl], e
	pop hl

	; Write the db bank.
	ld a, c
	ld c, sNewBox1Banks - sNewBox1Entries
	add hl, bc
	ld c, a
	ld b, RESET_FLAG
	dec d
	jr z, .got_flag_action
	ld b, SET_FLAG
.got_flag_action
	call SmallFlagAction
	jr .done

.party
	; Get the mon from the pokedb for party writing.
	call GetStorageMon
	jr nz, .not_empty

	; First, shift this partymon to the end, effectively shifting everything
	; past it upwards.
	call ShiftPartySlotToEnd

	; Then delete the partymon.
	ld hl, wPartyCount
	dec [hl]
	jr .done

.not_empty
	; If this slot was previously empty, we'll append it to the party end.
	ld a, [wPartyCount]
	cp c
	jr nc, .partyslot_not_empty
	inc a
	ld c, a
	ld [wPartyCount], a

.partyslot_not_empty
	; b is 0 from earlier, from referencing the party.
	call CopyBetweenPartyAndTemp
.done
	call CloseSRAM
	jp PopBCDEHL

ShiftPartySlotToEnd:
; Shift party slot c until the end.
	ld a, [wPartyCount]
	cp c
	ret z
	ld e, c
	inc c
	call SwapPartyMons
	jr ShiftPartySlotToEnd

CopyBetweenPartyAndTemp:
; Copies between partymon c (1-indexed) and temp. Doesn't preserve registers.
; Note that this will not update the party count if adding a new mon.
; If bit 7 of b is set, copies between wOTPartyMons instead of wPartyMons.
; If bit 0 of b is set, copies from party to temp, otherwise the reverse.
	dec c
	ld hl, wPartyMon1
	ld de, wTempMon
	ld a, PARTYMON_STRUCT_LENGTH
	call .Copy

	ld hl, wPartyMonNicknames
	ld de, wTempMonNickname
	ld a, MON_NAME_LENGTH
	call .Copy

	ld hl, wPartyMonOT
	ld de, wTempMonOT
	ld a, NAME_LENGTH
	; fallthrough

.Copy:
; Copies c bytes from hl+c*a to de if b is 1, otherwise the reverse.
	push bc
	bit 7, b
	jr z, .got_party

	; Copies from OT party instead.
	push bc
	ld bc, wOTPartyMons - wPartyMons
	add hl, bc
	pop bc
.got_party
	ld b, 0
	push af
	call AddNTimes
	pop af
	pop bc
	push bc
	ld c, a
	bit 0, b
	call z, SwapHLDE
	ld b, 0
	call CopyBytes
	pop bc
	ret

AddStorageMon:
; Adds wTempMon to storage pointed to with de. Does nothing if e is 0, meaning
; a null entry. Returns a fatal error (crash) if the entry is occupied.
	; Do nothing if we're pointing towards null storage.
	ld a, e
	and a
	ret z

	; Allocate the entry. Return a fatal error if the entry was already set.
	call AllocateStorageFlag
	ld a, ERR_PC_BOX_COLLISION
	jp nz, Crash
	push hl
	push de
	push bc

	; Encode the tempmon for adding, but decode it afterwards to leave it in
	; the same state.
	push de
	call EncodeTempMon
	pop de
	call OpenPokeDB

	ld d, h
	ld e, l
	ld hl, wEncodedTempMon
	ld bc, SAVEMON_STRUCT_LENGTH
	call CopyBytes

	call DecodeTempMon
	call CloseSRAM
	jp PopBCDEHL

OpenPokeDB:
; Opens pokedb bank and sets hl to relevant entry in de.
	ld a, d
	dec a
	ld hl, .Bank1Pointers
	jr z, .got_bank
	ld hl, .Bank2Pointers
.got_bank
	ld a, e
	dec a
	sub MONDB_ENTRIES_A
	call nc, .NextPointer
	; for optimization purposes, pointer list is A -> C -> B
	sub MONDB_ENTRIES_B
	call c, .NextPointer

	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, SAVEMON_STRUCT_LENGTH
	ld a, e
	dec a
	call AddNTimes
	ret

.NextPointer:
	inc hl
	inc hl
	inc hl
	ret

pokedb_section: MACRO
	db BANK(\1)
	dw (\1) - (\2) * SAVEMON_STRUCT_LENGTH
ENDM

.Bank1Pointers:
	; Because we want to point starting from entry 0, and e ends up being above
	; MONDB_ENTRIES_A (and beyond) for section C and B, include the offset.
	; This means that for example e=len(A)+1 points to the first entry in
	; pokedb section B.
	pokedb_section sBoxMons1AMons, 0
	pokedb_section sBoxMons1CMons, MONDB_ENTRIES_A + MONDB_ENTRIES_B
	pokedb_section sBoxMons1BMons, MONDB_ENTRIES_A
.Bank2Pointers:
	pokedb_section sBoxMons2AMons, 0
	pokedb_section sBoxMons2CMons, MONDB_ENTRIES_A + MONDB_ENTRIES_B
	pokedb_section sBoxMons2BMons, MONDB_ENTRIES_A

EncodeTempMon:
; Encodes party_struct wTempMon (+ wTempMonNickname/wTempMonOT/wTempMonIsEgg)
; to savemon_struct wEncodedTempMon.

	; Species: 8-bit session ID -> 16-bit index.
	ld a, [wTempMonSpecies]
	call GetPokemonIndexFromID
	ld a, l
	ld [wEncodedTempMonSpecies], a
	ld a, h
	ld [wEncodedTempMonSpecies + 1], a

	; Item through Personality: identical layout to box_struct bytes 1-33.
	ld hl, wTempMonItem
	ld de, wEncodedTempMonItem
	ld bc, wTempMonEnd - wTempMonItem
	call CopyBytes

	; Flags byte (egg flag).
	ld a, [wTempMonIsEgg]
	and 1 << SAVEMON_IS_EGG_F
	ld [wEncodedTempMonFlags], a

	; Shiny/gender flags live in the Unused byte for party mons, but in
	; the top bits of the PokerusStatus byte for stored mons.
	ld a, [wTempMonPokerusStatus]
	and $3f
	ld b, a
	ld a, [wTempMonUnused]
	and $c0
	or b
	ld [wEncodedTempMonPokerusStatus], a

	; Convert the moves from 8-bit session IDs to 14-bit indexes.
	; The low 8 bits go in the move bytes; the high 6 bits go in the low
	; bits of the PP bytes (the PP Up bits in 7-6 are preserved; the
	; current PP count is not stored, and is restored upon withdrawal).
	ld bc, wEncodedTempMonMoves
	ld de, wEncodedTempMonPP
	ld a, NUM_MOVES
	ldh [hTemp], a
.move_loop
	ld a, [bc]
	call GetMoveIndexFromID
	ld a, l
	ld [bc], a
	inc bc
	ld a, [de]
	and $c0
	or h
	ld [de], a
	inc de
	ld hl, hTemp
	dec [hl]
	jr nz, .move_loop

	; Nickname and OT, without terminators.
	ld hl, wTempMonNickname
	ld de, wEncodedTempMonNickname
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld hl, wTempMonOT
	ld de, wEncodedTempMonOT
	ld bc, NAME_LENGTH - 1
	call CopyBytes
	; fallthrough
ChecksumTempMon:
; Calculate and write a checksum to wEncodedTempMon. Uses a nonzero baseline
; so that all-zero content does not have a zero checksum.
; Returns z if an existing checksum is identical to the written checksum.
	ld bc, wEncodedTempMon
	ld hl, 127
	ld e, 0
.checksum_loop
	inc e
	ld a, [bc]
	inc bc
	push bc
	ld b, 0
	ld c, a
	ld a, e
	call AddNTimes ; hl += byte * position
	pop bc
	ld a, e
	cp wEncodedTempMonChecksum - wEncodedTempMon
	jr nz, .checksum_loop

	; Compare and write the result.
	ld a, [wEncodedTempMonChecksum]
	cp l
	jr nz, .mismatch
	ld a, [wEncodedTempMonChecksum + 1]
	cp h
	jr nz, .mismatch
	; Checksum already valid; write it anyway and return z.
	ld a, l
	ld [wEncodedTempMonChecksum], a
	ld a, h
	ld [wEncodedTempMonChecksum + 1], a
	xor a
	ret

.mismatch
	ld a, l
	ld [wEncodedTempMonChecksum], a
	ld a, h
	ld [wEncodedTempMonChecksum + 1], a
	or 1
	ret

DecodeTempMon:
; Decodes wEncodedTempMon into wTempMon. Returns nz.
; Sets carry in case of an invalid checksum (and loads Bad Egg data).
	; First, verify the checksum.
	call ChecksumTempMon
	push af

	; Species: 16-bit index -> 8-bit session ID (allocating one if needed).
	; Also record the index for direct use (icons, base data, names).
	ld a, [wEncodedTempMonSpecies]
	ld l, a
	ld a, [wEncodedTempMonSpecies + 1]
	ld h, a
	ld a, l
	ld [wTempMonIndex], a
	ld a, h
	ld [wTempMonIndex + 1], a
	call GetPokemonIDFromIndex
	ld [wTempMonSpecies], a

	; Item through Personality.
	ld hl, wEncodedTempMonItem
	ld de, wTempMonItem
	ld bc, wTempMonEnd - wTempMonItem
	call CopyBytes

	; Egg flag.
	ld a, [wEncodedTempMonFlags]
	and 1 << SAVEMON_IS_EGG_F
	ld [wTempMonIsEgg], a

	; Restore the shiny/gender flags to the party-format Unused byte.
	ld a, [wEncodedTempMonPokerusStatus]
	and $c0
	ld [wTempMonUnused], a

	; Convert moves back from 14-bit indexes to 8-bit session IDs, and
	; restore full PP based on the move's base PP and PP Ups.
	ld bc, wTempMonMoves
	ld de, wTempMonPP
	ld a, NUM_MOVES
	ldh [hTemp], a
.move_loop
	ld a, [bc]
	ld l, a
	ld a, [de]
	and $3f
	ld h, a
	cp $3f
	jr nz, .move_ok
	ld h, $ff
.move_ok
	call GetMoveIDFromIndex
	ld [bc], a
	inc bc
	and a
	jr z, .got_pp
	ld l, a
	ld a, MOVE_PP
	call GetMoveAttribute
	; max PP = base PP + min(7, base PP / 5) * PP Ups
	ld h, a
	ld l, -1
.pp_up_size_loop
	inc l
	sub 5
	jr nc, .pp_up_size_loop
	ld a, l
	cp 8
	jr c, .pp_up_size_ok
	ld l, 7
.pp_up_size_ok
	ld a, [de]
	and $c0
	or h
	ld h, a
	bit 6, h
	jr z, .skip_add_one
	add a, l
.skip_add_one
	add hl, hl ; if the top bit is set, it sets carry; it will also double l
	jr nc, .got_pp
	add a, l
.got_pp
	ld [de], a
	inc de
	ld hl, hTemp
	dec [hl]
	jr nz, .move_loop

	; Nickname and OT, restoring terminators.
	ld hl, wEncodedTempMonNickname
	ld de, wTempMonNickname
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [wTempMonNickname + MON_NAME_LENGTH - 1], a
	ld hl, wEncodedTempMonOT
	ld de, wTempMonOT
	ld bc, NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [wTempMonOT + NAME_LENGTH - 1], a

	pop af
	jr z, SetTempPartyMonData

	; Checksum failure: return a Bad Egg.
	call MakeBadEgg
	call SetTempPartyMonData
	scf
	ret

MakeBadEgg:
; Fills wTempMon with Bad Egg data.
	xor a
	ld hl, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call ByteFill
	ld a, 1
	ld [wTempMonSpecies], a
	ld [wTempMonIndex], a
	ld [wTempMonMoves], a
	ld [wTempMonPP], a
	ld [wTempMonLevel], a
	xor a
	ld [wTempMonIndex + 1], a
	ld a, 1 << SAVEMON_IS_EGG_F
	ld [wTempMonIsEgg], a
	ld hl, .BadEggName
	ld de, wTempMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld hl, .BadEggName
	ld de, wTempMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	ret

.BadEggName:
	db "BAD EGG@@@@"

SetTempPartyMonData:
	; Calculate stats from base data + level + stat exp + DVs.
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	ld a, [wTempMonIndex]
	ld l, a
	ld a, [wTempMonIndex + 1]
	ld h, a
	call GetBaseDataFromIndex
	ld a, [wTempMonLevel]
	ld [wCurPartyLevel], a
	ld de, wTempMonMaxHP
	ld hl, wTempMonStatExp - 1
	ld b, TRUE
	predef CalcMonStats

	; Reset status condition.
	xor a
	ld [wTempMonStatus], a

	; Set HP to full.
	ld hl, wTempMonMaxHP
	ld de, wTempMonHP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	; Eggs have 0 current HP.
	ld a, [wTempMonIsEgg]
	bit SAVEMON_IS_EGG_F, a
	jr z, .not_egg
	xor a
	ld [de], a
	dec de
	ld [de], a

.not_egg
	or 1
	ret

EnsureStorageSpace:
; Returns z if we have at least a unallocated pokedb entries left. This exists
; because flushing incurs a significant performance penalty, so this function
; avoids it when checking storage if we can get away with it.
	ld b, a

	; First, check if we have enough entries without flushing.
	push bc
	call _CheckFreeDatabaseEntries
	pop bc
	cp b
	sbc a
	ret z

	; Try again, this time with flushing.
	push bc
	call CheckFreeDatabaseEntries
	pop bc
	cp b
	sbc a
	ret

CheckFreeDatabaseEntries:
; Returns amount of unused database entries left, or 255 if 255+. We don't
; really care if we have 255 or 314 entries left, only if we're running low.
	; Flush the storage system of duplicate entries.
	call FlushStorageSystem
	; fallthrough
_CheckFreeDatabaseEntries:
	; Now, count used entries.
	ld a, BANK(wPokeDB1UsedEntries)
	call StackCallInWRAMBankA
.Function:
	ld hl, wPokeDB1UsedEntries
	call .CountEntries
	push bc
	ld hl, wPokeDB2UsedEntries
	call .CountEntries
	pop bc
	add c
	ret nc
	ld a, 255
	ret

.CountEntries:
	ld b, (MONDB_ENTRIES + 7) / 8
	call CountSetBits
	cpl
	add MONDB_ENTRIES + 1
	ld c, a
	ret

InitializeBoxes:
; Initializes the Storage System boxes as empty with default names and themes.
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	ld b, NUM_BOXES
	ld hl, sNewBox1
.name_loop
	push bc
	ld e, b
	ld bc, sNewBox1Name - sNewBox1
	xor a
	call ByteFill
	push hl
	push de
	ld de, .Box
	call CopyName2
	dec hl
	pop de
	ld a, NUM_BOXES + 1
	sub e
	; Write the box number (1-20) as text, left-aligned, at hl.
	cp 10
	jr c, .ones
	push af
	ld [hl], "1"
	inc hl
	pop af
	sub 10
.ones
	add "0"
	ld [hli], a
	ld [hl], "@"
	pop hl
	ld c, sNewBox2 - sNewBox1Name
	add hl, bc
	pop bc
	dec b
	jr nz, .name_loop

	; Clear the backup boxes. On a new game they have never held a valid save,
	; so any non-zero entry is leftover SRAM garbage. FlushStorageSystem (below)
	; allocates a pokedb entry for every non-zero box slot in BOTH the active and
	; backup boxes, so in-range garbage here makes the database read as full -
	; every deposit then demands a save that can never free space, looping
	; forever. Merely clamping out-of-range values (the old behaviour) is not
	; enough: in-range garbage ($01..MONDB_ENTRIES) survives and still fills the
	; database. Zero each backup box's entry list and bank flags outright so only
	; real, saved data ever consumes database entries.
	ld b, NUM_BOXES
	ld hl, sBackupNewBox1
.outer_backup_loop
	push bc
	ld bc, sBackupNewBox1Name - sBackupNewBox1 ; entry list + bank flags
	xor a
	call ByteFill
	pop bc
	ld de, sBackupNewBox2 - sBackupNewBox1Name
	add hl, de
	dec b
	jr nz, .outer_backup_loop

	ld de, BillsPC_DefaultBoxThemes
	ld hl, sNewBox1Theme
.theme_loop
	ld a, [de]
	inc de
	inc a
	jr z, .done
	dec a
	ld [hl], a
	ld bc, sNewBox2 - sNewBox1
	add hl, bc
	jr .theme_loop

.done
	call CloseSRAM

	; In case we reset the game mid-flush and then chose to start a new game,
	; ensure that all entries are allocated properly.
	jp FlushStorageSystem

.Box:
	db "Box @"

INCLUDE "data/pc/default_box_themes.asm"

_PointBoxTheme:
; Return's [wCurBox]'s theme pointer in hl.
; Also opens [wCurBox]'s SRAM bank.
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	ld hl, sNewBox1Theme
	ld a, [wCurBox]
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	ret

GetBoxTheme:
; Returns [wCurBox]'s theme in a.
	call _PointBoxTheme
	ld a, [hl]
	jp CloseSRAM

SetBoxTheme:
; Sets [wCurBox]'s theme to a.
	push af
	call _PointBoxTheme
	pop af
	ld [hl], a
	jp CloseSRAM

GetCurBoxName:
; Writes name of current box to string buffer 1.
	ld a, [wCurBox]
	inc a
	ld b, a
	; fallthrough
GetBoxName:
; Writes name of box b to string buffer 1.
	ld c, 0
	call CopyBoxName

	; Ensure that there's a terminator at the end. This isn't included as part
	; of saved box name.
	ld a, "@"
	ld [wStringBuffer1 + BOX_NAME_LENGTH], a
	ret

SetBoxName:
; Writes name from string buffer 1 to box b.
	ld c, 1
	; fallthrough
CopyBoxName:
; Copies between box b and string buffer 1 depending on value of c.
; c=0: Copy from box b to string buffer 1.
; c=1: Copy from string buffer 1 to box b.
	ld a, BANK(sNewBox1)
	call GetSRAMBank
	ld hl, sNewBox1Name
	ld a, b
	dec a
	push bc
	ld bc, sNewBox2 - sNewBox1
	call AddNTimes
	pop bc
	ld de, wStringBuffer1
	dec c
	call z, SwapHLDE
	ld bc, BOX_NAME_LENGTH
	call CopyBytes
	jp CloseSRAM

PrevStorageBoxMon:
; Reads wTempMonBox+wTempMonSlot and attempts to load a previous mon.
; Returns nz upon success, otherwise z. If there is no previous mon,
; wTempMonBox+wTempMonSlot is unchanged.
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
.done
	pop bc
	ret

NextStorageBoxMon:
; Reads wTempMonBox+wTempMonSlot and attempts to load the next mon.
; Returns nz upon success, otherwise z. If there is no next mon,
; wTempMonBox+wTempMonSlot is unchanged.
	push bc
	ld a, [wTempMonSlot]
	ld b, a
	ld c, a
.loop
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr z, .restore_slot
.get_storage
	push bc
	ld a, [wTempMonBox]
	ld b, a
	call GetStorageBoxMon
	pop bc
	jr nz, .done

	; If we're dealing with a party, we ran past the amount of mons we have.
	ld a, [wTempMonBox]
	and $7f
	jr nz, .loop
	; fallthrough
.restore_slot
	ld a, b
	ld [wTempMonSlot], a
.done
	pop bc
	ret

GetStorageBoxMon:
; Reads storage bank+entry from box b slot c and put it in wTempMon.
; This function supports handling the OT party by setting b to $80.
; If there is a checksum error, put Bad Egg data in wTempMon instead.
; Returns c in case of a Bad Egg, z if the requested mon doesn't exist,
; nz|nc otherwise. If b==0, read from party list. c is 1-indexed.
	xor a
	ld [wTempMonSlot], a

	; Check if we're reading party or box data.
	ld a, b
	ld [wTempMonBox], a
	and $7f
	jr z, .read_party
	push de
	call GetStorageBoxPointer
	call GetStorageMon
	pop de
	ret z
	ld a, c
	ld [wTempMonSlot], a
	ret

.read_party
	and a
	ld a, [wPartyCount]
	jr z, .got_partycount
	ld a, [wOTPartyCount]
.got_partycount
	cp c
	jr nc, .party_not_empty
	xor a
	ret
.party_not_empty
	ld a, c
	ld [wTempMonSlot], a
	push hl
	push de
	push bc
	inc b
	call CopyBetweenPartyAndTemp

	; Egg flag comes from the party species list.
	push bc
	ld a, [wTempMonBox]
	and a ; 0 = player party, $80 = OT party
	ld hl, wPartySpecies
	jr z, .got_species_list
	ld hl, wOTPartySpecies
.got_species_list
	ld a, [wTempMonSlot]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	xor a
	ld [wTempMonIsEgg], a
	ld a, [hl]
	cp EGG
	jr nz, .not_egg
	ld a, 1 << SAVEMON_IS_EGG_F
	ld [wTempMonIsEgg], a
.not_egg

	; Record the 16-bit species index, and load base data.
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	call GetPokemonIndexFromID
	ld a, l
	ld [wTempMonIndex], a
	ld a, h
	ld [wTempMonIndex + 1], a
	call GetBaseData
	or 1
	jp PopBCDEHL

GetStorageMon:
; Reads storage bank d, entry e and put it in wTempMon.
; If there is a checksum error, put Bad Egg data in wTempMon instead.
; Returns c in case of a Bad Egg, z if the requested mon doesn't exist,
; nz|nc otherwise.
	push hl
	push de
	push bc
	call IsStorageUsed
	jr z, .done ; entry not found

	call OpenPokeDB

	; Write to wEncodedTempMon and then decode it.
	ld de, wEncodedTempMon
	ld bc, SAVEMON_STRUCT_LENGTH
	call CopyBytes

	; Decode the result. This also returns a Bad Egg failsafe on a checksum
	; error.
	call DecodeTempMon
.done
	call CloseSRAM
	jp PopBCDEHL

AllocateStorageFlag:
; Allocates the given storage flag. Returns nz if storage is already in use.
	call IsStorageUsed
	ret nz
	call SetStorageAllocationFlag
	xor a
	ret

IsStorageUsed:
; Returns z if the given storage slot is unused. Preserves wTempMon.
	ld a, CHECK_FLAG
	jr StorageFlagAction
SetStorageAllocationFlag:
	ld a, SET_FLAG
	; fallthrough
StorageFlagAction:
; Performs flag action a on storage entry in de.
	; If we're dealing with a null entry (e=0), do nothing but pretend the
	; entry is unused if asked. Don't optimize away the xor a, since we
	; want to mimic the normal behaviour of the function.
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

	call .do_it
	jp PopBCDEHL

.do_it
	ld a, BANK(wPokeDB1UsedEntries)
	call StackCallInWRAMBankA
.Function:
	ld a, d
	dec a
	ld hl, wPokeDB1UsedEntries
	jr z, .got_entries
	ld hl, wPokeDB2UsedEntries
.got_entries
	ld c, e
	dec c
	ld d, 0
	jp SmallFlagAction

Special_CurBoxFullCheck:
; Returns [wScriptVar] = zero if wTempMonBox == wCurBox
; Returns [wScriptVar] = nonzero if wTempMonBox != wCurBox
	call CurBoxFullCheck
	jr nz, .not_equal
	xor a
.not_equal
	ld [wScriptVar], a
	ret

CurBoxFullCheck:
; Requires wTempMonBox to have sent mon box (returned in b)
; Returns z if wTempMonBox == wCurBox (or wTempMonBox = 0)
; Returns nz if wTempMonBox != wCurBox
;   Also returns name of old wCurBox in wStringBuffer1
;   and sets wCurBox to wTempMonBox in this case
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

BeastsCheck:
; Check if the player owns all three legendary beasts.
; They must exist in either party or PC, and have the player's OT and ID.
; Return the result in wScriptVar.

	ld hl, RAIKOU
	call GetPokemonIDFromIndex
	ld [wScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	ld hl, ENTEI
	call GetPokemonIDFromIndex
	ld [wScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	ld hl, SUICUNE
	call GetPokemonIDFromIndex
	ld [wScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	; they exist
	ld a, 1
	ld [wScriptVar], a
	ret

.notexist
	xor a
	ld [wScriptVar], a
	ret

MonCheck:
; Check if the player owns any Pokémon of the species in wScriptVar.
; Return the result in wScriptVar.

	call CheckOwnMonAnywhere
	jr c, .exists

	; doesn't exist
	xor a
	ld [wScriptVar], a
	ret

.exists
	ld a, 1
	ld [wScriptVar], a
	ret

CheckOwnMonAnywhere:
; Check if the player owns any monsters of the species in wScriptVar.
; It must exist in the Day-Care, party, or PC, and have the player's OT and ID.

	ld a, [wDayCareMan]
	bit DAYCAREMAN_HAS_MON_F, a
	jr z, .check_day_care_lady
	ld hl, wBreedMon1Species
	ld bc, wBreedMon1OT
	and a
	call CheckOwnMon
	ret c ; found!

.check_day_care_lady
	ld a, [wDayCareLady]
	bit DAYCARELADY_HAS_MON_F, a
	jr z, .party
	ld hl, wBreedMon2Species
	ld bc, wBreedMon2OT
	and a
	call CheckOwnMon
	ret c ; found!

.party
	; A zero-member party can occur in corrupted or externally edited saves.
	; The PC still has to be searched in that case.
	ld a, [wPartyCount]
	and a
	jr z, .boxes

	ld d, a
	ld e, 0
	ld hl, wPartyMon1Species
	ld bc, wPartyMonOT

	; Run CheckOwnMon on each Pokémon in the party.
.partymon
	and a
	call CheckOwnMon
	ret c ; found!

	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .partymon

	; Run CheckOwnMon on each Pokémon in the PC storage system.
.boxes
	ld a, [wSavedAtLeastOnce]
	and a
	ret z

	ld b, 1
.box
	ld c, 1
.slot
	push bc
	farcall GetStorageBoxMon
	pop bc
	jr z, .next_slot
	push bc
	ld hl, wTempMonSpecies
	ld bc, wTempMonOT
	and a
	call CheckOwnMon
	pop bc
	ret c ; found!
.next_slot
	inc c
	ld a, c
	cp MONS_PER_BOX + 1
	jr nz, .slot
	inc b
	ld a, b
	cp NUM_BOXES + 1
	jr nz, .box

	; not found
	and a
	ret

CheckOwnMon:
; Check if a Pokémon belongs to the player and is of a specific species.

; inputs:
; hl, pointer to PartyMonNSpecies
; bc, pointer to PartyMonNOT
; wScriptVar should contain the species we're looking for
; carry flag: if set, skip species check

; outputs:
; sets carry if monster matches species, ID, and OT name.

	push bc
	push hl
	push de
	ld d, b
	ld e, c

; check species
	jr c, .no_species_check
	ld a, [wScriptVar] ; species we're looking for
	ld b, [hl] ; species we have
	cp b
	jr nz, .notfound ; species doesn't match
.no_species_check

; check ID number
	ld bc, MON_ID
	add hl, bc ; now hl points to ID number
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .notfound ; ID doesn't match
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jr nz, .notfound ; ID doesn't match

; check OT

	ld hl, wPlayerName

rept PLAYER_NAME_LENGTH + -2
	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp "@"
	jr z, .found ; reached end of string
	inc hl
	inc de
endr

	ld a, [de]
	cp [hl]
	jr z, .found

.notfound
	pop de
	pop hl
	pop bc
	and a
	ret

.found
	pop de
	pop hl
	pop bc
	scf
	ret

GetBoxMonPointers::
	; in: b = slot, c = box
	; out: hl = pointer to mon struct, de = pointer to nickname, bc = pointer to OT
	; also loads the corresponding box bank in SRAM and sets wTempSpecies to the party ID (or 0 for an empty slot)
	ld e, b
	ld b, 0
	ld hl, BoxAddressTable1
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	ld d, h
	ld e, l
	cp [hl]
	ld c, a
	ld a, b ;b = 0
	jr nc, .got_ID
	inc hl
	add hl, bc
	ld a, [hl]
.got_ID
	ld [wTempSpecies], a
	ld a, c
	ld hl, sBoxMonOT - sBox
	add hl, de
	ld c, NAME_LENGTH
	push af
	call AddNTimes
	pop af
	push hl
	ld hl, sBoxMonNicknames - sBox
	add hl, de
	if MON_NAME_LENGTH != NAME_LENGTH
		ld c, MON_NAME_LENGTH
	endc
	push af
	call AddNTimes
	pop af
	push hl
	ld hl, sBoxMons - sBox
	add hl, de
	pop de
	ld c, BOXMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	ret

GetBoxMonPokemonIndexPointer::
	; in: b = slot, c = box
	; out: b = bank, hl = pointer
	; preserves de
	ld a, b
	ld b, 0
	ld hl, BoxPokemonIndexesAddressTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, a
	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	add hl, bc
	add hl, bc
	pop bc
	ret

BoxAddressTable1:
	dba sBox1
	dba sBox2
	dba sBox3
	dba sBox4
	dba sBox5
	dba sBox6
	dba sBox7
	dba sBox8
	dba sBox9
	dba sBox10
	dba sBox11
	dba sBox12
	dba sBox13
	dba sBox14

BoxPokemonIndexesAddressTable:
	dba sBox1PokemonIndexes
	dba sBox2PokemonIndexes
	dba sBox3PokemonIndexes
	dba sBox4PokemonIndexes
	dba sBox5PokemonIndexes
	dba sBox6PokemonIndexes
	dba sBox7PokemonIndexes
	dba sBox8PokemonIndexes
	dba sBox9PokemonIndexes
	dba sBox10PokemonIndexes
	dba sBox11PokemonIndexes
	dba sBox12PokemonIndexes
	dba sBox13PokemonIndexes
	dba sBox14PokemonIndexes

UpdateOTPointer:
	push hl
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ret

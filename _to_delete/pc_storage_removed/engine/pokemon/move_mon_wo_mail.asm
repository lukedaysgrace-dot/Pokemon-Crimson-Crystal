InsertPokemonIntoBox:
	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	call InsertSpeciesIntoBoxOrParty
	ld a, [sBoxCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, sBoxMonNicknames
	ld bc, MON_NAME_LENGTH
	ld de, wBufferMonNick
	call InsertDataIntoBoxOrParty
	ld a, [sBoxCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, sBoxMonOT
	ld bc, NAME_LENGTH
	ld de, wBufferMonOT
	call InsertDataIntoBoxOrParty
	ld a, [sBoxCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, sBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	ld de, wBufferMon
	call InsertDataIntoBoxOrParty
	call SyncBufferMonShinyGenderToBox
	ld hl, wBufferMonMoves
	ld de, wTempMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	ld hl, wBufferMonPP
	ld de, wTempMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	ld a, [wCurPartyMon]
	ld b, a
	farcall RestorePPOfDepositedPokemon
	jp CloseSRAM

InsertPokemonIntoParty:
	ld hl, wPartyCount
	call InsertSpeciesIntoBoxOrParty
	ld a, [wPartyCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	ld de, wBufferMonNick
	call InsertDataIntoBoxOrParty
	ld a, [wPartyCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld de, wBufferMonOT
	call InsertDataIntoBoxOrParty
	ld a, [wPartyCount]
	dec a
	ld [wNextBoxOrPartyIndex], a
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wBufferMon
	call InsertDataIntoBoxOrParty
	call SyncBufferMonShinyGenderToParty
	ret

GetBufferMonShinyGenderFlags:
	ld a, [wPokemonWithdrawDepositParameter]
	cp REMOVE_BOX
	jr z, .box
	ld a, [wBufferMonUnused]
	and $c0
	ret

.box
	ld a, [wBufferMonPokerusStatus]
	and $c0
	ret

SyncBufferMonShinyGenderToBox:
	call GetBufferMonShinyGenderFlags
	push af
	ld a, [sBoxCount]
	dec a
	ld hl, sBoxMon1PokerusStatus
	ld bc, BOXMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	and $3f
	ld b, a
	pop af
	or b
	ld [hl], a
	ret

SyncBufferMonShinyGenderToParty:
	call GetBufferMonShinyGenderFlags
	push af
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1PokerusStatus
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	and $3f
	ld [hl], a
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Unused
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop af
	ld [hl], a
	ret

InsertSpeciesIntoBoxOrParty:
	inc [hl]
	inc hl
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartySpecies]
	ld c, a
.loop
	ld a, [hl]
	ld [hl], c
	inc hl
	inc c
	ld c, a
	jr nz, .loop
	ret

InsertDataIntoBoxOrParty:
	push de
	push hl
	push bc
	ld a, [wNextBoxOrPartyIndex]
	dec a
	call AddNTimes
	push hl
	add hl, bc
	ld d, h
	ld e, l
	pop hl
.loop
	push bc
	ld a, [wNextBoxOrPartyIndex]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	pop bc
	jr z, .insert
	push hl
	push de
	push bc
	call CopyBytes
	pop bc
	pop de
	pop hl
	push hl
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	pop de
	ld a, [wNextBoxOrPartyIndex]
	dec a
	ld [wNextBoxOrPartyIndex], a
	jr .loop

.insert
	pop bc
	pop hl
	ld a, [wCurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	call CopyBytes
	ret

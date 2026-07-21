InsertPokemonIntoBox:
; Deposits wBufferMon (+ wBufferMonOT/wBufferMonNick) into the storage system.
	farcall NewStorageBoxPointer
	ret c
	ld a, b
	ld [wTempMonBox], a
	ld a, c
	ld [wTempMonSlot], a
	ld hl, wBufferMon
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	ld hl, wBufferMonNick
	ld de, wTempMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld hl, wBufferMonOT
	ld de, wTempMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	xor a
	ld [wTempMonIsEgg], a
	ld a, [wTempMonSpecies]
	call GetPokemonIndexFromID
	ld a, l
	ld [wTempMonIndex], a
	ld a, h
	ld [wTempMonIndex + 1], a
	farcall UpdateStorageBoxMonFromTemp
	ret

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

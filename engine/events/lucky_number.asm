CheckForLuckyNumberWinners:
	xor a
	ld [wScriptVar], a
	ld [wTempByteValue], a
	ld a, [wPartyCount]
	and a
	ret z
	ld d, a
	ld hl, wPartyMon1ID
	ld bc, wPartySpecies
.PartyLoop:
	ld a, [bc]
	inc bc
	cp EGG
	call nz, .CompareLuckyNumberToMonID
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec d
	jr nz, .PartyLoop
	; Scan the storage system.
	ld b, 1
.BoxesLoop:
	ld c, 1
.SlotLoop:
	push bc
	farcall GetStorageBoxMon
	pop bc
	jr z, .NextSlot
	ld a, [wTempMonIsEgg]
	and a
	jr nz, .NextSlot
	push bc
	ld hl, wTempMonID
	call .CompareLuckyNumberToMonID
	pop bc
	jr nc, .NextSlot
	ld a, TRUE
	ld [wTempByteValue], a
.NextSlot:
	inc c
	ld a, c
	cp MONS_PER_BOX + 1
	jr nz, .SlotLoop
	inc b
	ld a, b
	cp NUM_BOXES + 1
	jr nz, .BoxesLoop

	ld a, [wScriptVar]
	and a
	ret z ; found nothing
	farcall StubbedTrainerRankings_LuckyNumberShow
	ld a, [wTempByteValue]
	ld hl, .FoundPartymonText
	and a
	jr z, .print
	ld hl, .FoundBoxmonText
.print
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	jp PrintText

.CompareLuckyNumberToMonID:
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, wBuffer1
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ld hl, wLuckyNumberDigitsBuffer
	ld de, wLuckyIDNumber
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ld b, 5
	ld c, 0
	ld hl, wLuckyNumberDigitsBuffer + 4
	ld de, wBuffer1 + 4
.loop
	ld a, [de]
	cp [hl]
	jr nz, .done
	dec de
	dec hl
	inc c
	dec b
	jr nz, .loop

.done
	pop hl
	push hl
	ld de, -6
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	push af
	ld a, c
	ld b, 1
	cp 5
	jr z, .okay
	ld b, 2
	cp 3
	jr nc, .okay
	ld b, 3
	cp 2
	jr nz, .nomatch

.okay
	inc b
	ld a, [wScriptVar]
	and a
	jr z, .bettermatch
	cp b
	jr c, .nomatch

.bettermatch
	dec b
	ld a, b
	ld [wScriptVar], a
	pop bc
	ld a, b
	ld [wCurPartySpecies], a
	pop bc
	scf
	ret

.nomatch
	pop bc
	pop bc
	and a
	ret

.FoundPartymonText:
	; Congratulations! We have a match with the ID number of @  in your party.
	text_far UnknownText_0x1c1261
	text_end

.FoundBoxmonText:
	; Congratulations! We have a match with the ID number of @  in your PC BOX.
	text_far UnknownText_0x1c12ae
	text_end

PrintTodaysLuckyNumber:
	ld hl, wStringBuffer3
	ld de, wLuckyIDNumber
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	ld a, "@"
	ld [wStringBuffer3 + 5], a
	ret

GetBaseData::
	push hl
	farcall _GetBaseData
	pop hl
	ret

GetCurNick::
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames

GetNick::
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, wStringBuffer1

	push de
	; nickname lists are STORED_MON_NAME_LENGTH wide; copying the wider
	; display length would read a byte of the next entry
	ld bc, STORED_MON_NAME_LENGTH
	call CopyBytes
	pop de

	callfar CorrectNickErrors

	pop bc
	pop hl
	ret

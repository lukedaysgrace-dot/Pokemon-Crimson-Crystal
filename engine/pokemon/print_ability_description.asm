PrintAbilityDescriptionStats::
; Print the description for ability b at hl.
; Lives in the same bank as AbilityDescriptions; reached via farcall.
	push hl
	ld hl, AbilityDescriptions
	ld e, b
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString

PrintItemDescription:
; Print the description for item [wCurSpecies] at de.

	ld a, [wCurSpecies]
	call CompareItemWithTM01
	jr c, .not_a_tm

	ld [wCurItem], a
	push de
	farcall GetTMHMItemMove
	pop hl
	ld a, [wTempTMHM]
	ld [wCurSpecies], a
	predef PrintMoveDesc
	ret

.not_a_tm
	push de
	ld a, [wCurSpecies]
	call GetValidItemIndexFromID
	dec hl
	add hl, hl
	ld bc, ItemDescriptions
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceString

INCLUDE "data/items/descriptions.asm"

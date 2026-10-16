; Append only species-specific fallback moves to Blackthorn's egg-move menu.
; Read the selected party species again: the egg scan temporarily used its root.
BlackthornMoveTutor_AddTeachableMoves:
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	call GetPokemonIndexFromID
	dec hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	ld de, TechnicalTutorPointers
	add hl, de
	ld a, BANK(TechnicalTutorPointers)
	call GetFarByte
	push af
	inc hl
	ld a, BANK(TechnicalTutorPointers)
	call GetFarHalfword
	pop af
	ldh [hTemp], a

.loop_moves
	ldh a, [hTemp]
	push hl
	call GetFarHalfword
	ld b, h
	ld c, l
	pop hl
	ld a, b
	or c
	jr z, .done_moves
	inc hl
	inc hl
	call MoveTutorShared_CheckAlreadyInList
	jr c, .loop_moves
	call MoveTutorShared_CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	push hl
	call MoveTutorShared_AddMoveToList
	pop hl
	jr .loop_moves

.done_moves
	ld a, [wMoveReminderMoveList]
	and a
	ret

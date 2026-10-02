; Shares the family tutor's party/menu/learning flow, with explicit compatibility.
UtilityMoveTutor:
	ld hl, UtilityMoveTutorIntroText
	call MoveTutorShared_RemindStart
	jp c, EggMoveTutorCancelNoText
	ld hl, MoveTutorShared_WhichMonText
	call MoveTutorShared_SelectMon
	jp c, EggMoveTutorCancelNoText
	call UtilityMoveTutor_GetTeachableMoves
	jr z, .no_moves
	ld hl, MoveReminder_WhichMoveText
	call PrintText
	call JoyWaitAorB
	call MoveTutorShared_ChooseMoveToLearn
	jp c, EggMoveTutorSkipLearn
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	ld a, b
	and a
	jp z, EggMoveTutorSkipLearn
	call ReturnToMapWithSpeechTextbox
	xor a ; FALSE: the map script charges only after a successful lesson.
	ld [wScriptVar], a
	ret

.no_moves
	ld hl, MoveReminder_NoMovesText
	call PrintText
	jp EggMoveTutorCancelNoText

UtilityMoveTutor_GetTeachableMoves:
	ld hl, wMoveReminderMoveList
	xor a
	ld [hli], a
	dec a
	ld [hli], a
	xor a
	ld [hl], a

	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	; Convert the runtime ID before indexing the complete 495-species table.
	call GetPokemonIndexFromID
	dec hl
	ld de, UtilityTutorCompatibility
	add hl, de
	ld a, [hl]
	ld hl, UtilityTutorMoves

.loop_moves
	push af ; compatibility bits; helper calls may overwrite all scratch registers
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .done_moves
	pop af
	push af
	bit 0, a
	jr z, .next_move
	push hl
	call MoveTutorShared_CheckAlreadyInList
	jr c, .skip_move
	call MoveTutorShared_CheckPokemonAlreadyKnowsMove
	jr c, .skip_move
	call MoveTutorShared_AddMoveToList
.skip_move
	pop hl
.next_move
	pop af
	srl a
	jr .loop_moves

.done_moves
	pop af
	ld a, [wMoveReminderMoveList]
	and a
	ret

UtilityTutorMoves:
	dw SUBSTITUTE, SLEEP_TALK, REFLECT, LIGHT_SCREEN, THUNDER_WAVE
	dw 0

INCLUDE "data/pokemon/utility_tutor.asm"

UtilityMoveTutorIntroText:
	text "I teach useful"
	line "battle moves!"

	para "Try SUBSTITUTE or"
	line "SLEEP TALK, or"
	cont "support your team."

	para "My fee is ¥1000."
	line "Interested?"
	done

MoveDeletion:
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jr c, .declined
	ld hl, .AskWhichMonText
	call PrintText
	farcall SelectMonFromParty
	jr c, .declined
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Moves + 1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	and a
	jr z, .onlyonemove
	ld hl, .AskWhichMoveText
	call PrintText
	call LoadStandardMenuHeader
	farcall ChooseMoveToDelete
	push af
	call ReturnToMapWithSpeechTextbox
	pop af
	jr c, .declined
	ld a, [wMenuCursorY]
	push af
	ld a, [wCurSpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	ld hl, .ConfirmDeleteText
	call PrintText
	call YesNoBox
	pop bc
	jr c, .declined
	call .DeleteMove
	call WaitSFX
	ld de, SFX_MOVE_DELETED
	call PlaySFX
	call WaitSFX
	ld hl, .MoveDeletedText
	call PrintText
	ret

.egg
	ld hl, .EggText
	call PrintText
	ret

.declined
	ld hl, .DeclinedDeletionText
	call PrintText
	ret

.onlyonemove
	ld hl, .OnlyOneMoveText
	call PrintText
	ret

.OnlyOneMoveText:
	; That #MON knows only one move.
	text_far UnknownText_0x1c5eba
	text_end

.ConfirmDeleteText:
	; Oh, make it forget @ ?
	text_far UnknownText_0x1c5eda
	text_end

.MoveDeletedText:
	; Done! Your #MON forgot the move.
	text_far UnknownText_0x1c5ef5
	text_end

.EggText:
	; An EGG doesn't know any moves!
	text_far UnknownText_0x1c5f17
	text_end

.DeclinedDeletionText:
	; No? Come visit me again.
	text_far UnknownText_0x1c5f36
	text_end

.AskWhichMoveText:
	; Which move should it forget, then?
	text_far UnknownText_0x1c5f50
	text_end

.IntroText:
	; Um… Oh, yes, I'm the MOVE DELETER. I can make #MON forget moves. Shall I make a #MON forget?
	text_far UnknownText_0x1c5f74
	text_end

.AskWhichMonText:
	; Which #MON?
	text_far UnknownText_0x1c5fd1
	text_end

.DeleteMove:
	ld a, b
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, wPartyMon1Moves
	add hl, bc
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	push bc
	inc b
.loop
	ld a, b
	cp NUM_MOVES + 1
	jr z, .okay
	inc hl
	ld a, [hld]
	ld [hl], a
	inc hl
	inc b
	jr .loop

.okay
	xor a
	ld [hl], a
	pop bc

	ld a, b
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, wPartyMon1PP
	add hl, bc
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	inc b
.loop2
	ld a, b
	cp NUM_MOVES + 1
	jr z, .done
	inc hl
	ld a, [hld]
	ld [hl], a
	inc hl
	inc b
	jr .loop2

.done
	xor a
	ld [hl], a
	ret

MoveReminder:
	ld hl, MoveReminder_IntroText
	call MoveTutorShared_RemindStart
	jr c, MoveReminder_CancelNoText
	ld hl, MoveReminder_WhichMonText
	call MoveTutorShared_SelectMon
	jr c, MoveReminder_CancelNoText
	call MoveReminder_GetRemindableMoves
	jr z, MoveReminder_NoMoves
	ld hl, MoveReminder_WhichMoveText
	call PrintText
	call JoyWaitAorB
	call MoveTutorShared_ChooseMoveToLearn
	jr c, MoveReminder_SkipLearn
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	ld a, b
	and a
	jr z, MoveReminder_SkipLearn
	call ReturnToMapWithSpeechTextbox
	xor a ; FALSE
	ld [wScriptVar], a
	ret

MoveReminder_SkipLearn:
	call ReturnToMapWithSpeechTextbox
	ld hl, MoveReminder_CancelText
	call PrintText
	jr MoveReminder_CancelNoText

MoveReminder_NoMoves:
	ld hl, MoveReminder_NoMovesText
	call PrintText
	jr MoveReminder_CancelNoText

MoveReminder_CancelNoText:
	ld a, -1
	ld [wScriptVar], a
	ret

MoveReminder_GetRemindableMoves:
	ld hl, wMoveReminderMoveList
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a

	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a

	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld hl, EvosAttacksPointers
	ld a, BANK(EvosAttacksPointers)
	call LoadDoubleIndirectPointer
	ldh [hTemp], a
	call FarSkipEvolutions

.loop_moves
	call MoveReminder_GetNextEvoAttackByte
	and a
	jr z, .done_moves
	ld b, a
	ld a, [wCurPartyLevel]
	cp b
	jr c, .done_moves

	push hl
	ldh a, [hTemp]
	call GetFarHalfword
	call GetMoveIDFromIndex
	ld c, a
	pop hl
	inc hl
	inc hl
	call MoveTutorShared_CheckAlreadyInList
	jr c, .loop_moves
	call MoveTutorShared_CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	ld a, c
	push hl
	call MoveTutorShared_AddMoveToList
	pop hl
	jr .loop_moves

.done_moves
	ld a, [wMoveReminderMoveList]
	and a
	ret

MoveReminder_GetNextEvoAttackByte:
	ldh a, [hTemp]
	call GetFarByte
	inc hl
	ret

MoveTutorShared_RemindStart:
	call PrintText
	call YesNoBox
	jp c, MoveTutorShared_RemindCancel
	ret

MoveTutorShared_SelectMon:
	call PrintText
	call JoyWaitAorB
	farcall SelectMonFromParty
	jr c, MoveTutorShared_RemindCancel
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, MoveTutorShared_RemindEgg
	call IsAPokemon
	jr c, MoveTutorShared_RemindNoMon
	and a
	ret

MoveTutorShared_RemindCancel:
	ld hl, MoveTutorShared_CancelText
	jr MoveTutorShared_RemindDone

MoveTutorShared_RemindEgg:
	ld hl, MoveTutorShared_EggText
	jr MoveTutorShared_RemindDone

MoveTutorShared_RemindNoMon:
	ld hl, MoveTutorShared_NoMonText

MoveTutorShared_RemindDone:
	call PrintText
	scf
	ret

MoveTutorShared_CheckAlreadyInList:
	push hl
	ld hl, wMoveReminderMoveList + 1

.check_list_loop
	ld a, [hli]
	inc a
	jr z, .not_in_list
	dec a
	cp c
	jr nz, .check_list_loop
	pop hl
	scf
	ret

.not_in_list
	pop hl
	and a
	ret

MoveTutorShared_CheckPokemonAlreadyKnowsMove:
	push hl
	push bc
	ld a, MON_MOVES
	call GetPartyParamLocation
	ld b, NUM_MOVES

.check_known_loop
	ld a, [hli]
	cp c
	jr z, .knows_move
	dec b
	jr nz, .check_known_loop
	pop bc
	pop hl
	and a
	ret

.knows_move
	pop bc
	pop hl
	scf
	ret

MoveTutorShared_AddMoveToList:
	push af
	ld hl, wMoveReminderMoveList
	ld a, [hl]
	cp 53
	jr nc, .full
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	pop af
	ld [hli], a
	ld [hl], -1
	ret

.full
	pop af
	ret

MoveTutorShared_ChooseMoveToLearn:
	call FadeToMenu
	call ClearBGPalettes
	ld b, SCGB_PACKPALS
	call GetSGBLayout
	farcall LoadOW_BGPal7
	ld a, %11100100
	call DmgToCgbBGPals
	call ClearScreen
	call WaitBGMap2
	ld hl, MoveTutorShared_MenuHeader
	call CopyMenuHeader
	xor a
	ld [wMenuScrollPosition], a
	inc a
	ld [wMenuCursorBuffer], a
	call InitScrollingMenu
	call ScrollingMenu
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .carry
	ld a, [wMenuSelection]
	cp -1
	jr z, .carry
	ld [wPutativeTMHMMove], a
	and a
	ret

.carry
	scf
	ret

MoveTutorShared_MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 1, 2, SCREEN_WIDTH - 2, 10
	dw MoveTutorShared_MenuData
	db 1 ; default option

MoveTutorShared_MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 4, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dbw 0, wMoveReminderMoveList
	dba MoveTutorShared_PrintMoveName
	dba NULL
	dba NULL

MoveTutorShared_PrintMoveName:
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	ld de, wStringBuffer1
	pop hl
	jp PlaceString

MoveReminder_IntroText:
	text "Hiya, I'm the"
	line "MOVE REMINDER!"

	para "I can make #MON"
	line "remember moves"

	para "that they learned"
	line "while growing up."

	para "My fee is ¥1000."
	line "Interested?"
	done

MoveReminder_WhichMonText:
	text "Which #MON"
	line "would you like"

	para "to make remember"
	line "a move?"
	done

MoveTutorShared_WhichMonText:
	text "Which #MON should"
	line "learn an egg move?"
	done

MoveReminder_WhichMoveText:
	text "Which move should"
	line "it learn?"
	done

MoveReminder_CancelText:
	text "Come back anytime."
	done

MoveTutorShared_CancelText:
	text "Come back anytime."
	done

.EggText:
	text "Hey! What am I"
	line "supposed to teach"
	cont "an EGG?"
	done

MoveTutorShared_EggText:
	text "Hey! What am I"
	line "supposed to teach"
	cont "an EGG?"
	done

.NoMonText:
	text "You don't have a"
	line "#MON that can"
	cont "remember a move."
	done

MoveTutorShared_NoMonText:
	text "You don't have a"
	line "#MON that can"
	cont "learn a move."
	done

MoveReminder_NoMovesText:
	text "There are no moves"
	line "for this #MON"
	cont "to learn."
	done

EggMoveTutor:
	ld hl, EggMoveTutorIntroText
	call MoveTutorShared_RemindStart
	jr c, EggMoveTutorCancelNoText
	ld hl, MoveTutorShared_WhichMonText
	call MoveTutorShared_SelectMon
	jr c, EggMoveTutorCancelNoText
	call EggMoveTutor_GetTeachableMoves
	jr z, EggMoveTutorNoMoves
	ld hl, EggMoveTutorWhichMoveText
	call PrintText
	call JoyWaitAorB
	call MoveTutorShared_ChooseMoveToLearn
	jr c, EggMoveTutorSkipLearn
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	ld a, b
	and a
	jr z, EggMoveTutorSkipLearn
	call ReturnToMapWithSpeechTextbox
	xor a ; FALSE
	ld [wScriptVar], a
	ret

EggMoveTutorSkipLearn:
	call ReturnToMapWithSpeechTextbox
	ld hl, EggMoveTutorCancelText
	call PrintText

EggMoveTutorCancelNoText:
	ld a, -1
	ld [wScriptVar], a
	ret

EggMoveTutorNoMoves:
	ld hl, EggMoveTutorNoMovesText
	call PrintText
	jr EggMoveTutorCancelNoText

EggMoveTutor_GetTeachableMoves:
	ld hl, wMoveReminderMoveList
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a

	callfar GetLowestEvolutionStage

	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld hl, EggMovePointers
	ld a, BANK(EggMovePointers)
	call LoadDoubleIndirectPointer
	ldh [hTemp], a

.loop_moves
	ldh a, [hTemp]
	push hl
	call GetFarHalfword
	ld d, h
	ld e, l
	ld a, d
	cp HIGH(-1)
	jr nz, .check_move
	ld a, e
	cp LOW(-1)
	jr nz, .check_move
	pop hl
	jr .done_moves
.check_move
	push de
	ld h, d
	ld l, e
	call GetMoveIDFromIndex
	ld c, a
	pop de
	pop hl
	inc hl
	inc hl
	call MoveTutorShared_CheckAlreadyInList
	jr c, .loop_moves
	call MoveTutorShared_CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	ld a, c
	push hl
	call MoveTutorShared_AddMoveToList
	pop hl
	jr .loop_moves

.done_moves
	ld a, [wMoveReminderMoveList]
	and a
	ret

EggMoveTutorIntroText:
	text "I'm an EGG MOVE"
	line "TUTOR!"

	para "I teach moves that"
	line "#MON normally"

	para "only get from"
	line "breeding."

	para "My fee is ¥5000."
	line "Interested?"
	done

EggMoveTutorWhichMoveText:
	text "Which egg move"
	line "should it learn?"
	done

EggMoveTutorCancelText:
	text "Come back anytime."
	done

EggMoveTutorNoMovesText:
	text "That #MON has no"
	line "egg moves to learn."
	done

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
	ld hl, .IntroText
	call .RemindStart
	jr c, .cancel_no_text
	call .GetRemindableMoves
	jr z, .no_moves
	ld hl, .WhichMoveText
	call PrintText
	call JoyWaitAorB
	call .ChooseMoveToLearn
	jr c, .skip_learn
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	ld a, b
	and a
	jr z, .skip_learn
	call ReturnToMapWithSpeechTextbox
	xor a ; FALSE
	ld [wScriptVar], a
	ret

.skip_learn
	call ReturnToMapWithSpeechTextbox
	ld hl, .CancelText
	call PrintText
	jr .cancel_no_text

.no_moves
	ld hl, .NoMovesText
	call PrintText
	jr .cancel_no_text

.cancel_no_text
	ld a, -1
	ld [wScriptVar], a
	ret

.RemindStart:
	call PrintText
	call YesNoBox
	jp c, .cancel
	ld hl, .WhichMonText
	call PrintText
	call JoyWaitAorB
	farcall SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call IsAPokemon
	jr c, .no_mon
	and a
	ret

.cancel
	ld hl, .CancelText
	jr .done

.egg
	ld hl, .EggText
	jr .done

.no_mon
	ld hl, .NoMonText

.done
	call PrintText
	scf
	ret

.GetRemindableMoves:
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
	call .GetNextEvoAttackByte
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
	call .CheckAlreadyInList
	jr c, .loop_moves
	call .CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	ld a, c
	push hl
	call .AddMoveToList
	pop hl
	jr .loop_moves

.done_moves
	ld a, [wMoveReminderMoveList]
	and a
	ret

.GetNextEvoAttackByte:
	ldh a, [hTemp]
	call GetFarByte
	inc hl
	ret

.CheckAlreadyInList:
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

.CheckPokemonAlreadyKnowsMove:
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

.AddMoveToList:
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

.ChooseMoveToLearn:
	call FadeToMenu
	call ClearBGPalettes
	ld b, SCGB_PACKPALS
	call GetSGBLayout
	farcall LoadOW_BGPal7
	ld a, %11100100
	call DmgToCgbBGPals
	call ClearScreen
	call WaitBGMap2
	ld hl, .MenuHeader
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

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 1, 2, SCREEN_WIDTH - 2, 10
	dw .MenuData
	db 1 ; default option

.MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 4, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dbw 0, wMoveReminderMoveList
	dba .PrintMoveName
	dba NULL
	dba NULL

.PrintMoveName:
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	ld de, wStringBuffer1
	pop hl
	jp PlaceString

.IntroText:
	text "Hiya, I'm the"
	line "MOVE REMINDER!"

	para "I can make #MON"
	line "remember moves"

	para "that they learned"
	line "while growing up."

	para "My fee is ¥1000."
	line "Interested?"
	done

.WhichMonText:
	text "Which #MON"
	line "would you like"

	para "to make remember"
	line "a move?"
	done

.WhichMoveText:
	text "Which move should"
	line "it learn?"
	done

.CancelText:
	text "Come back anytime."
	done

.EggText:
	text "Hey! What am I"
	line "supposed to teach"
	cont "an EGG?"
	done

.NoMonText:
	text "You don't have a"
	line "#MON that can"
	cont "remember a move."
	done

.NoMovesText:
	text "There are no moves"
	line "for this #MON"
	cont "to learn."
	done

MoveTutor:
	call FadeToMenu
	call ClearBGPalettes
	call ClearScreen
	call DelayFrame
	ld b, SCGB_PACKPALS
	call GetSGBLayout
	xor a
	ld [wItemAttributeParamBuffer], a
	call .GetMoveTutorMove
	ld [wNamedObjectIndexBuffer], a
	ld [wPutativeTMHMMove], a
	call GetMoveName
	call CopyName1
	farcall ChooseMonToLearnTMHM
	jr c, .cancel
	jr .enter_loop

.loop
	farcall ChooseMonToLearnTMHM_NoRefresh
	jr c, .cancel
.enter_loop
	call CheckCanLearnMoveTutorMove
	jr nc, .loop
	xor a ; FALSE
	ld [wScriptVar], a
	jr .quit

.cancel
	ld a, -1
	ld [wScriptVar], a
.quit
	call CloseSubmenu
	ret

.GetMoveTutorMove:
	ld a, [wScriptVar]
	cp MOVETUTOR_FLAMETHROWER
	ld hl, FLAMETHROWER
	jr z, .ok
	cp MOVETUTOR_THUNDERBOLT
	ld hl, THUNDERBOLT
	jr z, .ok
	cp MOVETUTOR_ICE_BEAM
	ld hl, ICE_BEAM
	jr z, .ok
	; MOVETUTOR_EXTREMESPEED
	ld hl, EXTREMESPEED
.ok
	jp GetMoveIDFromIndex

CheckCanLearnMoveTutorMove:
	ld hl, .MenuHeader
	call LoadMenuHeader

	call .CheckCompatibility

	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	pop bc

	ld a, c
	and a
	jr nz, .can_learn
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld a, BANK(Text_TMHMNotCompatible)
	ld hl, Text_TMHMNotCompatible
	call FarPrintText
	jr .didnt_learn

.can_learn
	callfar KnowsMove
	jr c, .didnt_learn

	predef LearnMove
	ld a, b
	and a
	jr z, .didnt_learn

	ld c, HAPPINESS_LEARNMOVE
	callfar ChangeHappiness
	jr .learned

.didnt_learn
	call ExitMenu
	and a
	ret

.learned
	call ExitMenu
	scf
	ret

.CheckCompatibility:
; Returns compatibility in c, the same way CanLearnTMHMMove does.
; EXTREMESPEED is not a TM or HM, so it has no learnset flag to check against:
; the Dragon Shrine elder only offers it for the Dratini line ("Shall I teach
; it EXTREMESPEED?"), so only Dratini, Dragonair and Dragonite can learn it.
	ld a, [wPutativeTMHMMove]
	call GetMoveIndexFromID ; out: hl = 16-bit move index
	ld a, l
	cp LOW(EXTREMESPEED)
	jr nz, .use_tmhm_learnset
	ld a, h
	cp HIGH(EXTREMESPEED)
	jr nz, .use_tmhm_learnset
	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID ; out: hl = 16-bit species index
	ld c, TRUE
	ld de, DRATINI
	call .HLIsDE
	ret z
	ld de, DRAGONAIR
	call .HLIsDE
	ret z
	ld de, DRAGONITE
	call .HLIsDE
	ret z
	ld c, FALSE
	ret

.HLIsDE:
	ld a, h
	cp d
	ret nz
	ld a, l
	cp e
	ret

.use_tmhm_learnset
	predef CanLearnTMHMMove
	ret

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1

; The SAFARI ZONE game, rebuilt to work like Red/Blue's: pay at the gate,
; get a fixed handful of SAFARI BALLs and a step allowance, and get
; announced out of the preserve the moment either one runs out.

SAFARI_ZONE_BALL_COUNT EQU 30
SAFARI_ZONE_STEP_COUNT EQU 300

StartSafariGame::
; special. Called from the SAFARI ZONE's new-map callback. Does nothing
; if a game is already running, so saving and reloading inside the
; preserve cannot refill the timer.
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_SAFARI_GAME_F, [hl]
	ret nz
	set STATUSFLAGS2_SAFARI_GAME_F, [hl]
	ld a, SAFARI_ZONE_BALL_COUNT
	ld [wSafariBallsRemaining], a
	; big endian, so PrintNum can read it straight out of WRAM
	ld a, HIGH(SAFARI_ZONE_STEP_COUNT)
	ld [wSafariStepsRemaining], a
	ld a, LOW(SAFARI_ZONE_STEP_COUNT)
	ld [wSafariStepsRemaining + 1], a
	ret

EndSafariGame::
; special. The officer takes back whatever balls are left over.
	ld hl, wStatusFlags2
	res STATUSFLAGS2_SAFARI_GAME_F, [hl]
	xor a
	ld [wSafariBallsRemaining], a
	ld [wSafariStepsRemaining], a
	ld [wSafariStepsRemaining + 1], a
	ret

DoSafariStep::
; Called from CountStep. Returns carry (and queues the announcement
; script) on the step that uses up the allowance.
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_SAFARI_GAME_F, [hl]
	jr z, .not_counting

	; Only steps taken inside the preserve itself count. Getting out any
	; other way - ESCAPE ROPE, DIG, FLY, TELEPORT - ends the game on the
	; first step somewhere else, so the flag can never get stranded.
	ld a, [wMapGroup]
	cp GROUP_SAFARI_ZONE
	jr nz, .left_the_zone
	ld a, [wMapNumber]
	cp MAP_SAFARI_ZONE
	jr nz, .left_the_zone

	; Out of balls is game over too, wherever they were spent.
	ld a, [wSafariBallsRemaining]
	and a
	jr z, .out_of_balls

	ld hl, wSafariStepsRemaining
	ld a, [hli]
	or [hl]
	jr z, .not_counting ; already spent; the script is on its way

	ld a, [hl] ; low byte
	sub 1
	ld [hld], a
	jr nc, .no_borrow
	dec [hl]
.no_borrow

	ld a, [hli]
	or [hl]
	jr nz, .not_counting

	ld a, BANK(SafariZoneTimesUpScript)
	ld hl, SafariZoneTimesUpScript
	call CallScript
	scf
	ret

.left_the_zone
	call EndSafariGame

.not_counting
	and a
	ret

.out_of_balls
	ld a, BANK(SafariZoneOutOfBallsScript)
	ld hl, SafariZoneOutOfBallsScript
	call CallScript
	scf
	ret

SafariZoneBattleScript::
	loadvar VAR_BATTLETYPE, BATTLETYPE_SAFARI
	randomwildmon
	startbattle
	reloadmapafterbattle
	readmem wSafariBallsRemaining
	iffalse SafariZoneOutOfBallsScript
	end

SafariZoneTimesUpScript::
	playsound SFX_ELEVATOR_END
	opentext
	writetext SafariZoneTimesUpText
	waitbutton
	sjump SafariZoneReturnToGateScript

SafariZoneOutOfBallsScript::
	playsound SFX_ELEVATOR_END
	opentext
	writetext SafariZoneOutOfBallsText
	waitbutton

SafariZoneReturnToGateScript:
	closetext
	special EndSafariGame
	warpfacing DOWN, SAFARI_ZONE_LOBBY, 9, 2
	end

SafariZoneTimesUpText:
	text "PA: Ding-dong!"

	para "Time's up!"

	para "PA: Your SAFARI"
	line "GAME is over!"
	done

SafariZoneOutOfBallsText:
	text "PA: Ding-dong!"

	para "You are out of"
	line "SAFARI BALLS!"

	para "PA: Your SAFARI"
	line "GAME is over!"
	done

FishingContestCheckRod::
; Queue an explanatory script when fishing in the cove is not allowed.
; Carry means the rod request was handled here. Preserve the rod in de.
	push de
	call FishingContestAccess
	pop de
	cp 1
	jr z, .allowed
	ld hl, FishingContestFridayOnlyScript
	and a
	jr z, .blocked
	ld hl, FishingContestEnterFirstScript
.blocked
	call QueueScript
	ld a, 1
	ld [wFieldMoveSucceeded], a
	scf
	ret
.allowed
	and a
	ret

FishingContestAccess::
; a=1 allowed, a=0 wrong weekday, a=2 enter the contest first.
; Other maps keep their usual fishing rules.
	ld a, [wMapGroup]
	cp GROUP_OLIVINE_FISHING_COVE
	jr nz, .allowed
	ld a, [wMapNumber]
	cp MAP_OLIVINE_FISHING_COVE
	jr nz, .allowed
	ld a, [wCurDay]
	cp FRIDAY
	jr nz, .closed
	ld a, [wStatusFlags2]
	and (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	cp (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	jr nz, .enter_first
	ld a, [wParkBallsRemaining]
	and a
	jr z, .enter_first
.allowed
	ld a, 1
	ret
.closed
	xor a
	ret
.enter_first
	ld a, 2
	ret

FishingContestFish::
; 75% bite rate, identical species/level pool for Old, Good, and Super Rods.
	call Random
	cp 75 percent
	jr nc, .no_bite
	call ChooseFishingContestEncounter
	ld a, [wTempWildMonSpecies]
	ld d, a
	ld a, [wCurPartyLevel]
	ld e, a
	ret
.no_bite
	ld de, 0
	ret

ChooseFishingContestEncounter::
.roll
	call Random
	cp 200
	jr nc, .roll
	srl a
	ld hl, FishingContestMons
	ld de, 5
.species
	sub [hl]
	jr c, .found
	add hl, de
	jr .species
.found
	inc hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call GetPokemonIDFromIndex
	pop hl
	inc hl
	ld [wTempWildMonSpecies], a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	sub d
	inc a
	ld c, a
.level
	call Random
	cp 252 ; unbiased modulo 21 for the level 10-30 range
	jr nc, .level
	call SimpleDivide
	add d
	ld [wCurPartyLevel], a
	xor a
	ld [wContestBallsThisMon], a
	ret

INCLUDE "data/wild/fishing_contest_mons.asm"

GiveFishingContestBalls::
	farcall GiveParkBalls
	ld hl, wStatusFlags2
	set STATUSFLAGS2_FISHING_CONTEST_F, [hl]
	ret

FishingContestCanUseItem::
; Outside battle, open the Pack for rods while retaining contest item rules.
	ld a, [wStatusFlags2]
	bit STATUSFLAGS2_FISHING_CONTEST_F, a
	jr z, .allowed
	ld a, [wBattleMode]
	and a
	jr nz, .allowed
	ld a, [wCurItem]
	cp OLD_ROD
	jr z, .allowed
	cp GOOD_ROD
	jr z, .allowed
	cp SUPER_ROD
	jr z, .allowed
	scf
	ret
.allowed
	and a
	ret

FishingContestCheckDay::
; Finish a running Friday contest if the calendar rolls into Saturday.
	ld a, [wStatusFlags2]
	bit STATUSFLAGS2_FISHING_CONTEST_F, a
	jr z, .ok
	ld a, [wCurDay]
	cp FRIDAY
	jr nz, .over
.ok
	and a
	ret
.over
	scf
	ret

FishingContestPreparePrize::
; ScriptVar is the player's placement (0 means consolation).
	ld a, [wScriptVar]
	ld e, a
	ld d, 0
	ld hl, FishingContestPrizes
	add hl, de
	ld a, [hl]
	ld [wFishingContestPrize], a
	ret

FishingContestPrizes:
	db LURE_BALL, WATER_STONE, MYSTIC_WATER, NUGGET

FishingContestFridayOnlyScript:
	opentext
	writetext FishingContestFridayOnlyText
	waitbutton
	closetext
	end

FishingContestEnterFirstScript:
	opentext
	writetext FishingContestEnterFirstText
	waitbutton
	closetext
	end

FishingContestFridayOnlyText:
	text "Fishing here is"
	line "only permitted on"
	cont "Fridays."
	done

FishingContestEnterFirstText:
	text "Please enter the"
	line "Fishing Contest"
	cont "at the gate first."
	done

FishingContestOutOfBallsScript::
	playsound SFX_ELEVATOR_END
	opentext
	writetext FishingContestOutOfBallsText
	waitbutton
	closetext
	sjump FishingContestResultsWarpScript

FishingContestOutOfBallsText:
	text "ANNOUNCER: You're"
	line "out of LURE BALLS!"

	para "The Fishing"
	line "Contest is over!"
	done

FishingContestResultsWarpScript::
	clearflag ENGINE_BUG_CONTEST_TIMER
	setflag ENGINE_FISHING_CONTEST_RESULTS
	special ClearBGPalettes
	warpfacing UP, OLIVINE_FISHING_COVE_GATE, 3, 4
	opentext
	farwritetext ContestResults_ReadyToJudgeText
	waitbutton
	special BugContestJudging
	getnum STRING_BUFFER_3
	callasm FishingContestPreparePrize
	readmem wFishingContestPrize
	getitemname STRING_BUFFER_4, USE_SCRIPT_VAR
	farwritetext FishingContestPrizeText
	waitbutton
	readmem wFishingContestPrize
	verbosegiveitem ITEM_FROM_MEM, 1
	iftrue .received
	farwritetext FishingContestPrizeHeldText
	waitbutton
	sjump .return_party
.received
	loadmem wFishingContestPrize, 0
.return_party
	checkevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	iffalse .caught_mon
	farwritetext ContestResults_ReturnPartyText
	waitbutton
	special ContestReturnMons
.caught_mon
	clearevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	special CheckPartyFullAfterContest
	ifequal BUGCONTEST_BOXED_MON, .boxed
	sjump .finish
.boxed
	farwritetext ContestResults_PartyFullText
	waitbutton
.finish
	clearflag ENGINE_FISHING_CONTEST
	clearflag ENGINE_FISHING_CONTEST_RESULTS
	setflag ENGINE_DAILY_FISHING_CONTEST
	loadmem wParkBallsRemaining, 0
	farwritetext ContestResults_JoinUsNextTimeText
	waitbutton
	closetext
	special PlayMapMusic
	end

FishingContestPrizeText:
	text "Your prize is"
	line "@"
	text_ram wStringBuffer4
	text "!"
	done

FishingContestPrizeHeldText::
	text "Your BAG is full."
	line "I'll hold your"
	cont "prize for you."

	para "Make room, then"
	line "come talk to me."
	done

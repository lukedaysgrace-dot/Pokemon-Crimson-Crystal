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
	call ChooseFishingContestRoster
	ret

ChooseFishingContestRoster::
; Choose two distinct fishers, then three distinct guests. Select the rank
; among unused candidates instead of retrying duplicate random identities.
	ld e, 0
.slot
	ld c, NUM_FISHING_CONTEST_FISHERS
	ld d, 0
	ld a, e
	and a
	jr z, .pick
	dec c
	cp 2
	jr c, .pick
	ld d, NUM_FISHING_CONTEST_FISHERS
	ld a, NUM_FISHING_CONTEST_CANDIDATES - NUM_FISHING_CONTEST_FISHERS + 2
	sub e
	ld c, a
.pick
	call .unused_candidate
	ld hl, wFishingContestRoster
	push de
	ld d, 0
	add hl, de
	pop de
	ld [hl], a
	inc e
	ld a, e
	cp NUM_FISHING_CONTESTANTS
	jr nz, .slot
	ret
.unused_candidate
	call Random
	cp 240 ; divisible by all remaining pool sizes: 4, 5, and 6
	jr nc, .unused_candidate
	call SimpleDivide
	ld b, a
	inc b
.candidate
	ld hl, wFishingContestRoster
	ld c, e
	ld a, c
	and a
	jr z, .available
.scan
	ld a, [hli]
	cp d
	jr z, .used
	dec c
	jr nz, .scan
.available
	dec b
	jr z, .found
.used
	inc d
	jr .candidate
.found
	ld a, d
	ret

FishingContestSetMapSprites::
; Called before the sprite allocator reads map objects. The same saved roster
; supplies the shore and the judging lineup; regular visitors use fixed IDs.
	ld a, [wMapGroup]
	cp GROUP_OLIVINE_FISHING_COVE
	ret nz
	ld de, wFishingContestRoster
	ld hl, wMap2ObjectSprite
	ld a, [wMapNumber]
	cp MAP_OLIVINE_FISHING_COVE_GATE
	jr z, .set_sprites
	cp MAP_OLIVINE_FISHING_COVE
	ret nz
	ld hl, wMap4ObjectSprite
	ld a, [wStatusFlags2]
	and (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	cp (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	jr z, .set_sprites
	ld de, FishingCoveVisitorRoster
.set_sprites
	ld b, NUM_FISHING_CONTESTANTS
.loop
	push bc
	push hl
	ld a, [de]
	inc de
	push de
	ld c, a
	ld b, 0
	ld hl, FishingContestantSprites
	add hl, bc
	add hl, bc
	ld c, [hl]
	inc hl
	ld a, [hl]
	pop de
	pop hl
	ld [hl], c
	push hl
	ld bc, MAPOBJECT_COLOR - MAPOBJECT_SPRITE
	add hl, bc
	swap a
	ld c, a
	ld a, [hl]
	and $f
	or c
	ld [hl], a
	pop hl
	ld bc, OBJECT_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

FishingContestantSprites:
; Candidate order matches FishingContestantPointers, excluding unused index 0.
	db SPRITE_FISHER, PAL_NPC_RED
	db SPRITE_FISHER, PAL_NPC_BLUE
	db SPRITE_FISHER, PAL_NPC_GREEN
	db SPRITE_FISHER, PAL_NPC_BROWN
	db SPRITE_FISHER, PAL_NPC_RED
	db SPRITE_YOUNGSTER, PAL_NPC_BLUE
	db SPRITE_COOLTRAINER_M, PAL_NPC_BLUE
	db SPRITE_COOLTRAINER_F, PAL_NPC_RED
	db SPRITE_CAMPER_NEW, PAL_NPC_GREEN
	db SPRITE_PICNICKER_NEW, PAL_NPC_GREEN
	db SPRITE_POKEFAN_M, PAL_NPC_BROWN
	assert (@ - FishingContestantSprites) / 2 == NUM_FISHING_CONTEST_CANDIDATES
; Regular visitors, after the contest candidates.
	db SPRITE_LASS, PAL_NPC_RED
	db SPRITE_COOLTRAINER_F, PAL_NPC_BLUE
	db SPRITE_TEACHER, PAL_NPC_GREEN
	db SPRITE_COOLTRAINER_M, PAL_NPC_BLUE
FishingCoveVisitorRoster:
	db NUM_FISHING_CONTEST_CANDIDATES + 0
	db NUM_FISHING_CONTEST_CANDIDATES + 1
	db NUM_FISHING_CONTEST_CANDIDATES + 2
	db NUM_FISHING_CONTEST_CANDIDATES + 3
	db NUM_FISHING_CONTEST_CANDIDATES + 0

FishingCoveSelectDialogue::
; hLastTalked uses map-object IDs: shore visitors are objects 4 through 11.
	ldh a, [hLastTalked]
	sub 4
	ld c, a
	ld hl, FishingCoveVisitorTextPointers
	ld a, [wStatusFlags2]
	and (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	cp (1 << STATUSFLAGS2_FISHING_CONTEST_F) | (1 << STATUSFLAGS2_BUG_CONTEST_TIMER_F)
	jr nz, FishingCoveSetDialoguePointer
	ld a, c
	cp NUM_FISHING_CONTESTANTS
	jr nc, FishingCoveSetDialoguePointer
	ld hl, FishingContestTextPointers
	jr FishingContestSelectRosterDialogue

FishingContestSelectResultDialogue::
; The gate's five contestants are map objects 2 through 6.
	ldh a, [hLastTalked]
	sub 2
	ld c, a
	ld hl, FishingContestResultTextPointers
FishingContestSelectRosterDialogue:
	push hl
	ld hl, wFishingContestRoster
	ld b, 0
	add hl, bc
	ld c, [hl]
	pop hl
FishingCoveSetDialoguePointer:
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wScriptTextAddr], a
	ld a, [hl]
	ld [wScriptTextAddr + 1], a
	ld a, BANK(FishingCoveVisitorTextPointers)
	ld [wScriptTextBank], a
	ret

INCLUDE "data/text/fishing_cove.asm"

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

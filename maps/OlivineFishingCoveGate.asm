	object_const_def
	const OLIVINEFISHINGCOVEGATE_OFFICER
	const OLIVINEFISHINGCOVEGATE_JUSTIN
	const OLIVINEFISHINGCOVEGATE_RALPH
	const OLIVINEFISHINGCOVEGATE_ARNOLD
	const OLIVINEFISHINGCOVEGATE_KYLE
	const OLIVINEFISHINGCOVEGATE_WILTON

OlivineFishingCoveGate_MapScripts:
	db 1 ; scene scripts
	scene_script .CheckArrival
	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .ResetScene
	callback MAPCALLBACK_OBJECTS, .SetUpRoom
.ResetScene:
	setscene SCENE_DEFAULT
	return
.SetUpRoom:
	checkflag ENGINE_FISHING_CONTEST_RESULTS
	iftrue .Results
	disappear OLIVINEFISHINGCOVEGATE_JUSTIN
	disappear OLIVINEFISHINGCOVEGATE_RALPH
	disappear OLIVINEFISHINGCOVEGATE_ARNOLD
	disappear OLIVINEFISHINGCOVEGATE_KYLE
	disappear OLIVINEFISHINGCOVEGATE_WILTON
	moveobject OLIVINEFISHINGCOVEGATE_OFFICER, 2, 1
	return
.Results:
	appear OLIVINEFISHINGCOVEGATE_JUSTIN
	appear OLIVINEFISHINGCOVEGATE_RALPH
	appear OLIVINEFISHINGCOVEGATE_ARNOLD
	appear OLIVINEFISHINGCOVEGATE_KYLE
	appear OLIVINEFISHINGCOVEGATE_WILTON
	moveobject OLIVINEFISHINGCOVEGATE_OFFICER, 3, 2
	return
.CheckArrival:
	checkflag ENGINE_FISHING_CONTEST
	iffalse .Done
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .Done
	prioritysjump OlivineFishingCoveGateLeaveEarly
.Done:
	end

OlivineFishingCoveGateFridayDoor:
	readvar VAR_WEEKDAY
	ifnotequal FRIDAY, .Done
	checkflag ENGINE_DAILY_FISHING_CONTEST
	iftrue .Done
	setlasttalked OLIVINEFISHINGCOVEGATE_OFFICER
	sjump OlivineFishingCoveGateOfficerScript
.Done:
	end

OlivineFishingCoveGateOfficerScript:
	faceplayer
	opentext
	readmem wFishingContestPrize
	iftrue OlivineFishingCoveGateClaimPrize
	checkflag ENGINE_FISHING_CONTEST
	iftrue OlivineFishingCoveGateFinishPrompt
	readvar VAR_WEEKDAY
	ifnotequal FRIDAY, .NotFriday
	checkflag ENGINE_DAILY_FISHING_CONTEST
	iftrue .FinishedToday
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue .OtherContest
	writetext OlivineFishingCoveGateOfferText
	yesorno
	iffalse .Declined
	special CheckFirstMonIsEgg
	iftrue .Egg
	readvar VAR_PARTYCOUNT
	ifless 2, .OneMon
	writetext OlivineFishingCoveGateFirstMonText
	yesorno
	iffalse .Declined
	special ContestDropOffMons
	iftrue .Fainted
	setevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	sjump .Start
.OneMon:
	special ContestDropOffMons
	iftrue .Fainted
	clearevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
.Start:
	clearflag ENGINE_FISHING_CONTEST_RESULTS
	setflag ENGINE_BUG_CONTEST_TIMER
	callasm GiveFishingContestBalls
	writetext OlivineFishingCoveGateBallsText
	playsound SFX_ITEM
	waitsfx
	buttonsound
	writetext OlivineFishingCoveGateRulesText
	waitbutton
	closetext
	warpfacing UP, OLIVINE_FISHING_COVE, 19, 32
	end
.Egg:
	writetext OlivineFishingCoveGateEggText
	sjump .DeclineFinish
.Fainted:
	writetext OlivineFishingCoveGateFaintedText
	sjump .DeclineFinish
.Declined:
	writetext OlivineFishingCoveGateDeclinedText
.DeclineFinish:
	waitbutton
	closetext
	readvar VAR_YCOORD
	ifnotequal 1, .Done
	applymovement PLAYER, .StepBack
.Done:
	end
.NotFriday:
	writetext OlivineFishingCoveGateFridayText
	waitbutton
	closetext
	end
.FinishedToday:
	writetext OlivineFishingCoveGateFinishedText
	waitbutton
	closetext
	end
.OtherContest:
	writetext OlivineFishingCoveGateOtherContestText
	sjump .DeclineFinish
.StepBack:
	step DOWN
	step_end

OlivineFishingCoveGateLeaveEarly:
	opentext
OlivineFishingCoveGateFinishPrompt:
	readvar VAR_CONTESTMINUTES
	addval 1
	getnum STRING_BUFFER_3
	writetext OlivineFishingCoveGateFinishText
	yesorno
	iffalse .Continue
	closetext
	farsjump FishingContestResultsWarpScript
.Continue:
	writetext OlivineFishingCoveGateContinueText
	waitbutton
	closetext
	warpfacing UP, OLIVINE_FISHING_COVE, 19, 32
	end

OlivineFishingCoveGateClaimPrize:
	getitemname STRING_BUFFER_4, USE_SCRIPT_VAR
	writetext OlivineFishingCoveGatePrizeText
	waitbutton
	readmem wFishingContestPrize
	verbosegiveitem ITEM_FROM_MEM, 1
	iffalse .Full
	loadmem wFishingContestPrize, 0
	writetext OlivineFishingCoveGateThanksText
	waitbutton
	closetext
	end
.Full:
	farwritetext FishingContestPrizeHeldText
	waitbutton
	closetext
	end

OlivineFishingCoveGateSign:
	jumptext OlivineFishingCoveGateSignText
OlivineFishingCoveGateFisherScript:
	faceplayer
	opentext
	callasm FishingContestSelectResultDialogue
	repeattext -1, -1
	waitbutton
	closetext
	end

OlivineFishingCoveGateOfferText:
	text "It's Friday! The"
	line "Fishing Contest"
	cont "is on today."
	para "We use a special"
	line "rod here to keep"
	cont "things fair."
	para "Would you like to"
	line "take part?"
	done
OlivineFishingCoveGateFirstMonText:
	text "Use the first"
	line "#MON in your"
	cont "party?"
	para "We'll hold your"
	line "other #MON"
	cont "until judging."
	done
OlivineFishingCoveGateBallsText:
	text "<PLAYER> received"
	line "20 LURE BALLS!"
	done
OlivineFishingCoveGateRulesText:
	text "You have 20 min."
	line "and 20 LURE BALLS."
	para "Everyone uses the"
	line "same special rod."
	para "Face the water and"
	line "press A to fish."
	para "No need to carry"
	line "or register a rod."
	para "Keep your best"
	line "catch for judging."
	para "Rarity, size and"
	line "balls used all"
	cont "count for points."
	para "Return here or"
	line "choose QUIT to"
	cont "finish early."
	para "You'll keep the"
	line "last fish you"
	cont "choose to keep."
	done
OlivineFishingCoveGateFridayText:
	text "Welcome to OLIVINE"
	line "FISHING COVE!"
	para "We hold a Fishing"
	line "Contest on Friday."
	para "Fishing here is"
	line "only allowed then."
	done
OlivineFishingCoveGateSignText:
	text "OLIVINE"
	line "FISHING COVE"
	para "Fishing Contest:"
	line "Fridays only!"
	para "1st: WATER STONE"
	line "2nd: MYSTIC WATER"
	cont "3rd: NUGGET"
	para "All others receive"
	line "a LURE BALL."
	done
OlivineFishingCoveGateFinishText:
	text "You have @"
	text_ram wStringBuffer3
	text " min."
	line "left. Finish now?"
	done
OlivineFishingCoveGateContinueText:
	text "Then go back and"
	line "land a great fish!"
	done
OlivineFishingCoveGateFinishedText:
	text "You've entered"
	line "today's Contest."
	para "Come back next"
	line "Friday to compete!"
	done
OlivineFishingCoveGateDeclinedText:
	text "OK. Come see me"
	line "if you change"
	cont "your mind."
	done
OlivineFishingCoveGateEggText:
	text "An EGG can't"
	line "compete. Put a"
	cont "#MON first in"
	cont "your party."
	done
OlivineFishingCoveGateFaintedText:
	text "Your first #MON"
	line "has fainted. Heal"
	cont "it before entry."
	done
OlivineFishingCoveGateOtherContestText:
	text "Please finish your"
	line "other Contest"
	cont "before entering."
	done
OlivineFishingCoveGatePrizeText:
	text "Here's your"
	line "@"
	text_ram wStringBuffer4
	text "!"
	done
OlivineFishingCoveGateThanksText:
	text "Thanks for taking"
	line "part in the"
	cont "Fishing Contest!"
	done
OlivineFishingCoveGate_MapEvents:
	db 0, 0
	db 4 ; warp events
	warp_event 3, 0, OLIVINE_FISHING_COVE, 1
	warp_event 4, 0, OLIVINE_FISHING_COVE, 2
	warp_event 3, 7, OLIVINE_CITY, 12
	warp_event 4, 7, OLIVINE_CITY, 12
	db 2 ; coord events
	coord_event 3, 1, SCENE_DEFAULT, OlivineFishingCoveGateFridayDoor
	coord_event 4, 1, SCENE_DEFAULT, OlivineFishingCoveGateFridayDoor
	db 1 ; bg events
	bg_event 5, 0, BGEVENT_READ, OlivineFishingCoveGateSign
	db 6 ; object events
	object_event 2, 1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateOfficerScript, -1
; The callback sets this shared temporary flag so object loading keeps them hidden.
	object_event 2, 5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateFisherScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 3, 5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateFisherScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 4, 5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateFisherScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 5, 5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateFisherScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 6, 5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateFisherScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2

SAFARIZONELOBBY_FEE EQU 500

	object_const_def ; object_event constants
	const SAFARIZONELOBBY_OFFICER
	const SAFARIZONELOBBY_YOUNGSTER
	const SAFARIZONELOBBY_LASS
	const SAFARIZONELOBBY_POKEFAN_M
	const SAFARIZONELOBBY_OFFICER2
	const SAFARIZONELOBBY_TEACHER
	const SAFARIZONELOBBY_COOLTRAINER_F
	const SAFARIZONELOBBY_BUG_CATCHER

SafariZoneLobby_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene ; SCENE_DEFAULT

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .ResetFee

.DummyScene:
	end

; The fee is per visit, just like GEN 1 - it resets every time the map loads.
.ResetFee:
	clearevent EVENT_PAID_SAFARI_ZONE_FEE
	return

; Left officer (at 6,3): triggers at 8,3 and 9,3.
; Player ends up at 8,3 - two tiles in front of him - facing him.
SafariZoneLobbyGateTrigger1:
	checkevent EVENT_PAID_SAFARI_ZONE_FEE
	iftrue .Skip
	readvar VAR_FACING
	ifnotequal UP, .Skip ; only stop people heading for the back exit
	applymovement PLAYER, SafariZoneLobbyTurnLeftMovement
	sjump SafariZoneLobbyFeeScript

.Skip:
	end

SafariZoneLobbyGateTrigger1Approach:
	checkevent EVENT_PAID_SAFARI_ZONE_FEE
	iftrue .Skip
	readvar VAR_FACING
	ifnotequal UP, .Skip
	applymovement PLAYER, SafariZoneLobbyStepLeftMovement
	sjump SafariZoneLobbyFeeScript

.Skip:
	end

; Right officer (at 13,3): triggers at 10,3 and 11,3.
; Player ends up at 11,3 - two tiles in front of him - facing him.
SafariZoneLobbyGateTrigger2Approach:
	checkevent EVENT_PAID_SAFARI_ZONE_FEE
	iftrue .Skip
	readvar VAR_FACING
	ifnotequal UP, .Skip
	applymovement PLAYER, SafariZoneLobbyStepRightMovement
	sjump SafariZoneLobbyFeeScript

.Skip:
	end

SafariZoneLobbyGateTrigger2:
	checkevent EVENT_PAID_SAFARI_ZONE_FEE
	iftrue .Skip
	readvar VAR_FACING
	ifnotequal UP, .Skip
	applymovement PLAYER, SafariZoneLobbyTurnRightMovement
	sjump SafariZoneLobbyFeeScript

.Skip:
	end

SafariZoneLobbyFeeScript:
	opentext
	writetext SafariZoneLobbyOfficerStopText
	yesorno
	iffalse .Declined
	checkmoney YOUR_MONEY, SAFARIZONELOBBY_FEE - 1
	ifequal HAVE_MORE, .PayFee
	writetext SafariZoneLobbyNotEnoughMoneyText
	waitbutton
	closetext
	applymovement PLAYER, SafariZoneLobbyStepBackMovement
	end

.PayFee:
	takemoney YOUR_MONEY, SAFARIZONELOBBY_FEE
	playsound SFX_TRANSACTION
	waitsfx
	writetext SafariZoneLobbyPaidText
	waitbutton
	closetext
	setevent EVENT_PAID_SAFARI_ZONE_FEE
	end

.Declined:
	writetext SafariZoneLobbyDeclinedText
	waitbutton
	closetext
	applymovement PLAYER, SafariZoneLobbyStepBackMovement
	end

SafariZoneLobbyOfficerScript:
	faceplayer
	opentext
	checkevent EVENT_PAID_SAFARI_ZONE_FEE
	iftrue .Paid
	writetext SafariZoneLobbyOfficerInfoText
	waitbutton
	closetext
	end

.Paid:
	writetext SafariZoneLobbyOfficerEnjoyText
	waitbutton
	closetext
	end

SafariZoneLobbyYoungsterScript:
	jumptextfaceplayer SafariZoneLobbyYoungsterText

SafariZoneLobbyLassScript:
	jumptextfaceplayer SafariZoneLobbyLassText

SafariZoneLobbyPokefanMScript:
	jumptextfaceplayer SafariZoneLobbyPokefanMText

SafariZoneLobbyTeacherScript:
	jumptextfaceplayer SafariZoneLobbyTeacherText

SafariZoneLobbyCooltrainerFScript:
	jumptextfaceplayer SafariZoneLobbyCooltrainerFText

SafariZoneLobbyBugCatcherScript:
	jumptextfaceplayer SafariZoneLobbyBugCatcherText

SafariZoneLobbyStepBackMovement:
	step DOWN
	step_end

SafariZoneLobbyStepLeftMovement:
	step LEFT
	step_end

SafariZoneLobbyStepRightMovement:
	step RIGHT
	step_end

SafariZoneLobbyTurnLeftMovement:
	turn_head LEFT
	step_end

SafariZoneLobbyTurnRightMovement:
	turn_head RIGHT
	step_end

SafariZoneLobbyOfficerStopText:
	text "OFFICER: Halt!"

	para "Beyond this gate"
	line "lies the SAFARI"
	cont "ZONE."

	para "Entry costs ¥500."

	para "Would you like to"
	line "pay the fee?"
	done

SafariZoneLobbyPaidText:
	text "OFFICER: Thank"
	line "you very much!"

	para "Watch your step"
	line "out there, and"
	cont "have fun!"
	done

SafariZoneLobbyNotEnoughMoneyText:
	text "OFFICER: Sorry,"
	line "kiddo. You don't"

	para "have enough"
	line "money."
	done

SafariZoneLobbyDeclinedText:
	text "OFFICER: No pay,"
	line "no play. Come"

	para "back if you"
	line "change your mind."
	done

SafariZoneLobbyOfficerInfoText:
	text "OFFICER: This is"
	line "the SAFARI ZONE"
	cont "reception."

	para "Rare #MON from"
	line "faraway regions"

	para "roam the preserve"
	line "out back."

	para "Entry costs ¥500."
	line "Pay at the gate"
	cont "if you want in."
	done

SafariZoneLobbyOfficerEnjoyText:
	text "OFFICER: You're"
	line "all paid up."

	para "Go on through and"
	line "enjoy yourself!"
	done

SafariZoneLobbyYoungsterText:
	text "I saw a GROWLITHE"
	line "with fluffy fur"
	cont "and a stone hat!"

	para "They say that's"
	line "how they looked"

	para "in the SINNOH of"
	line "long ago."
	done

SafariZoneLobbyLassText:
	text "The PONYTA in the"
	line "preserve have"

	para "curly purple"
	line "manes! So cute!"

	para "I want to take"
	line "one home so bad!"
	done

SafariZoneLobbyPokefanMText:
	text "Whoa! A TAUROS"
	line "out there charged"
	cont "me head-on!"

	para "It was jet black"
	line "with a fiery"
	cont "temper!"

	para "They come in an"
	line "aqua breed too,"
	cont "y'know."
	done

SafariZoneLobbyTeacherText:
	text "The SLOWPOKE here"
	line "laze by the pond,"
	cont "same as anywhere."

	para "But their heads"
	line "are gold! They"

	para "snack on GALARICA"
	line "seeds, they say."
	done

SafariZoneLobbyCooltrainerFText:
	text "I spotted a snow-"
	line "white VULPIX in"
	cont "the tall grass!"

	para "One puff of its"
	line "icy breath gave"
	cont "me the shivers!"
	done

SafariZoneLobbyBugCatcherText:
	text "The WOOPER in the"
	line "preserve live in"

	para "sticky mud, not"
	line "in the water."

	para "Careful! They're"
	line "poisonous!"
	done

SafariZoneLobby_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  9,  0, SAFARI_ZONE, 1
	warp_event 10,  0, SAFARI_ZONE, 1
	warp_event  9, 17, ROUTE_36, 5
	warp_event 10, 17, ROUTE_36, 5

	db 4 ; coord events
	coord_event  8,  3, -1, SafariZoneLobbyGateTrigger1
	coord_event  9,  3, -1, SafariZoneLobbyGateTrigger1Approach
	coord_event 10,  3, -1, SafariZoneLobbyGateTrigger2Approach
	coord_event 11,  3, -1, SafariZoneLobbyGateTrigger2

	db 0 ; bg events

	db 8 ; object events
	object_event  6,  3, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyOfficerScript, -1
	object_event  6, 15, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyYoungsterScript, -1
	object_event 15, 11, SPRITE_LASS, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyLassScript, -1
	object_event  4, 12, SPRITE_POKEFAN_M, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyPokefanMScript, -1
	object_event 13,  3, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyOfficerScript, -1
	object_event  5,  8, SPRITE_TEACHER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyTeacherScript, -1
	object_event 14,  7, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyCooltrainerFScript, -1
	object_event 10, 13, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SafariZoneLobbyBugCatcherScript, -1

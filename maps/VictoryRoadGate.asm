	object_const_def ; object_event constants
	const VICTORYROADGATE_OFFICER
	const VICTORYROADGATE_BLACK_BELT1
	const VICTORYROADGATE_RED_OFFICER
	const VICTORYROADGATE_BLUE_OFFICER
	const VICTORYROADGATE_RED_OFFICER_ASIDE
	const VICTORYROADGATE_BLUE_OFFICER_ASIDE

VictoryRoadGate_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene0 ; SCENE_DEFAULT
	scene_script .DummyScene1 ; SCENE_FINISHED

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .SetupObjects

.DummyScene0:
	end

.DummyScene1:
	end

.SetupObjects:
	checkevent EVENT_OPENED_MT_SILVER
	iftrue .MtSilverLockDone
	appear VICTORYROADGATE_BLACK_BELT1
.MtSilverLockDone:
; Once the Victory Road guards have stepped aside, show them beside the
; doorway instead of in front of it.
	checkevent EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED
	iftrue .GuardsMoved
	setevent EVENT_VICTORY_ROAD_GATE_SIDE_GUARDS_HIDDEN
	return

.GuardsMoved:
	clearevent EVENT_VICTORY_ROAD_GATE_SIDE_GUARDS_HIDDEN
	return

VictoryRoadGateBadgeCheckScene:
	turnobject PLAYER, LEFT
	sjump VictoryRoadGateBadgeCheckScript

VictoryRoadGateOfficerScript:
	faceplayer
VictoryRoadGateBadgeCheckScript:
	opentext
	writetext VictoryRoadGateOfficerText
	buttonsound
	readvar VAR_BADGES
	ifgreater NUM_JOHTO_BADGES - 1, .AllEightBadges
	writetext VictoryRoadGateNotEnoughBadgesText
	waitbutton
	closetext
	applymovement PLAYER, VictoryRoadGateStepDownMovement
	end

.AllEightBadges:
	writetext VictoryRoadGateEightBadgesText
	waitbutton
	closetext
	setscene SCENE_FINISHED
	end

VictoryRoadGateLeftBlackBeltScript:
	jumptextfaceplayer VictoryRoadGateLeftBlackBeltText

VictoryRoadGateGuardScript:
	faceplayer
	opentext
	checkevent EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED
	iftrue .AlreadyMoved
	readvar VAR_BADGES
	ifgreater NUM_BADGES - 1, .AllSixteenBadges
	writetext VictoryRoadGateGuardNotEnoughBadgesText
	waitbutton
	closetext
	turnobject LAST_TALKED, DOWN
	end

.AlreadyMoved:
	writetext VictoryRoadGateGuardGoAheadText
	waitbutton
	closetext
	end

.AllSixteenBadges:
	writetext VictoryRoadGateGuardAllBadgesText
	waitbutton
	closetext
; If the player is standing beside the doorway, step them out of the way.
	readvar VAR_FACING
	ifequal LEFT, .StepPlayerDown
	ifequal RIGHT, .StepPlayerDown
	sjump .GuardsStepAside

.StepPlayerDown:
	applymovement PLAYER, VictoryRoadGateStepDownMovement
.GuardsStepAside:
	turnobject VICTORYROADGATE_RED_OFFICER, DOWN
	turnobject VICTORYROADGATE_BLUE_OFFICER, DOWN
	applymovement VICTORYROADGATE_RED_OFFICER, VictoryRoadGateRedOfficerStepAsideMovement
	applymovement VICTORYROADGATE_BLUE_OFFICER, VictoryRoadGateBlueOfficerStepAsideMovement
	setevent EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED
	end

VictoryRoadGateGuardAsideScript:
	jumptextfaceplayer VictoryRoadGateGuardGoAheadText

VictoryRoadGateStepDownMovement:
	step DOWN
	step_end

VictoryRoadGateRedOfficerStepAsideMovement:
	step LEFT
	turn_head RIGHT
	step_end

VictoryRoadGateBlueOfficerStepAsideMovement:
	step RIGHT
	turn_head LEFT
	step_end

VictoryRoadGateOfficerText:
	text "Only trainers who"
	line "have proven them-"
	cont "selves may pass."
	done

VictoryRoadGateNotEnoughBadgesText:
	text "You don't have all"
	line "the GYM BADGES of"
	cont "JOHTO."

	para "I'm sorry, but I"
	line "can't let you go"
	cont "through."
	done

VictoryRoadGateEightBadgesText:
	text "Oh! The eight"
	line "BADGES of JOHTO!"

	para "Please, go right"
	line "on through!"

	para "Turn right for"
	line "KANTO."

	para "VICTORY ROAD needs"
	line "all 16 BADGES."
	done

VictoryRoadGateLeftBlackBeltText:
	text "This way leads to"
	line "MT.SILVER."

	para "You'll see scary-"
	line "strong #MON out"
	cont "there."
	done

VictoryRoadGateGuardNotEnoughBadgesText:
	text "VICTORY ROAD is"
	line "open only to"

	para "trainers with all"
	line "16 BADGES of JOHTO"
	cont "and KANTO."

	para "I'm sorry, but I"
	line "can't let you"
	cont "through."
	done

VictoryRoadGateGuardAllBadgesText:
	text "Oh! All 16 BADGES"
	line "of JOHTO and"
	cont "KANTO!"

	para "Please, go right"
	line "on through!"
	done

VictoryRoadGateGuardGoAheadText:
	text "VICTORY ROAD lies"
	line "ahead. Good luck!"
	done

VictoryRoadGate_MapEvents:
	db 0, 0 ; filler

	db 8 ; warp events
	warp_event 17,  7, ROUTE_22, 1
	warp_event 18,  7, ROUTE_22, 1
	warp_event  9, 17, ROUTE_26, 1
	warp_event 10, 17, ROUTE_26, 1
	warp_event  9,  0, VICTORY_ROAD, 1
	warp_event 10,  0, VICTORY_ROAD, 1
	warp_event  1,  7, ROUTE_28, 2
	warp_event  2,  7, ROUTE_28, 2

	db 1 ; coord events
	coord_event 10, 11, SCENE_DEFAULT, VictoryRoadGateBadgeCheckScene

	db 0 ; bg events

	db 6 ; object events
	object_event  8, 11, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateOfficerScript, -1
	object_event  7,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateLeftBlackBeltScript, EVENT_OPENED_MT_SILVER
	object_event  9,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateGuardScript, EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED
	object_event 10,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateGuardScript, EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED
	object_event  8,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateGuardAsideScript, EVENT_VICTORY_ROAD_GATE_SIDE_GUARDS_HIDDEN
	object_event 11,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateGuardAsideScript, EVENT_VICTORY_ROAD_GATE_SIDE_GUARDS_HIDDEN

	object_const_def ; object_event constants
	const ROUTE5SAFFRONGATE_OFFICER

Route5SaffronGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

Route5SaffronGateOfficerScript:
	jumptextfaceplayer Route5SaffronGateOfficerText

Route5SaffronGateOfficerText:
	text "You're from JOHTO,"
	line "aren't you?"

	para "How do you like"
	line "KANTO? It's nice,"
	cont "don't you agree?"
	done

Route5SaffronGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, ROUTE_5, 2
	warp_event  5,  0, ROUTE_5, 3
	warp_event  4,  7, SAFFRON_CITY, 9
	warp_event  5,  7, SAFFRON_CITY, 9

	db 6 ; coord events
; Cover the full corridor: a player can approach the carpet from either side.
	coord_event 2, 5, -1, Route5SaffronGateBadgeCheck
	coord_event 3, 5, -1, Route5SaffronGateBadgeCheck
	coord_event 4, 5, -1, Route5SaffronGateBadgeCheck
	coord_event 5, 5, -1, Route5SaffronGateBadgeCheck
	coord_event 6, 5, -1, Route5SaffronGateBadgeCheck
	coord_event 7, 5, -1, Route5SaffronGateBadgeCheck

	db 0 ; bg events

	db 1 ; object events
	object_event  0,  4, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route5SaffronGateOfficerScript, -1

Route5SaffronGateBadgeCheck:
	farscall CheckSurgeBadgeScript
	iftrue .Ready
	opentext
	writetext Route5SaffronGateNeedSurgeText
	waitbutton
	closetext
	applymovement PLAYER, Route5SaffronGateReturnMovement
.Ready:
	end

Route5SaffronGateReturnMovement:
	step UP
	step_end

Route5SaffronGateNeedSurgeText:
	text "SAFFRON's GYM"
	line "challenge comes"
	cont "after LT.SURGE."

	para "Earn his BADGE in"
	line "VERMILION first."
	done

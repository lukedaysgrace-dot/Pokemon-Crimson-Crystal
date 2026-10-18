	object_const_def ; object_event constants
	const ROUTE8SAFFRONGATE_OFFICER

Route8SaffronGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

Route8SaffronGateOfficerScript:
	faceplayer
	farscall SaffronGateGuardDrinkScript
	end

Route8SaffronGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  0,  4, SAFFRON_CITY, 14
	warp_event  0,  5, SAFFRON_CITY, 15
	warp_event  9,  4, ROUTE_8, 1
	warp_event  9,  5, ROUTE_8, 2

	db 3 ; coord events
; Cover both the main corridor and the narrow path beside the guard.
	coord_event 5, 2, -1, Route8SaffronGateDrinkCheck
	coord_event 5, 4, -1, Route8SaffronGateDrinkCheck
	coord_event 5, 5, -1, Route8SaffronGateDrinkCheck

	db 0 ; bg events

	db 1 ; object events
	object_event  5,  2, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route8SaffronGateOfficerScript, -1

Route8SaffronGateDrinkCheck:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .Ready
	turnobject PLAYER, UP
	farscall SaffronGateGuardDrinkScript
	iftrue .Ready
	applymovement PLAYER, Route8SaffronGateReturnMovement
.Ready:
	end

Route8SaffronGateReturnMovement:
	step RIGHT
	step_end

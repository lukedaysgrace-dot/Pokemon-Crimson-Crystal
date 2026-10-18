	object_const_def ; object_event constants
	const ROUTE7SAFFRONGATE_OFFICER

Route7SaffronGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

Route7SaffronGuardScript:
	faceplayer
	farscall SaffronGateGuardDrinkScript
	end

Route7SaffronGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  0,  4, ROUTE_7, 1
	warp_event  0,  5, ROUTE_7, 2
	warp_event  9,  4, SAFFRON_CITY, 10
	warp_event  9,  5, SAFFRON_CITY, 11

	db 3 ; coord events
; Cover both the main corridor and the narrow path beside the guard.
	coord_event 5, 2, -1, Route7SaffronGateDrinkCheck
	coord_event 5, 4, -1, Route7SaffronGateDrinkCheck
	coord_event 5, 5, -1, Route7SaffronGateDrinkCheck

	db 0 ; bg events

	db 1 ; object events
	object_event  5,  2, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route7SaffronGuardScript, -1

Route7SaffronGateDrinkCheck:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .Ready
	turnobject PLAYER, UP
	farscall SaffronGateGuardDrinkScript
	iftrue .Ready
	applymovement PLAYER, Route7SaffronGateReturnMovement
.Ready:
	end

Route7SaffronGateReturnMovement:
	step LEFT
	step_end

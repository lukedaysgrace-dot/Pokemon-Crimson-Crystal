	object_const_def ; object_event constants
	const ROUTE6SAFFRONGATE_OFFICER

Route6SaffronGate_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene

	db 0 ; callbacks

.DummyScene:
	end

Route6SaffronGuardScript:
	faceplayer
	farscall SaffronGateGuardDrinkScript
	end

Route6SaffronGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, SAFFRON_CITY, 12
	warp_event  5,  0, SAFFRON_CITY, 13
	warp_event  4,  7, ROUTE_6, 2
	warp_event  5,  7, ROUTE_6, 2

	db 2 ; coord events
	coord_event 4, 1, -1, Route6SaffronGateDrinkCheck
	coord_event 5, 1, -1, Route6SaffronGateDrinkCheck

	db 0 ; bg events

	db 1 ; object events
	object_event  0,  4, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route6SaffronGuardScript, -1

Route6SaffronGateDrinkCheck:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .Ready
	turnobject PLAYER, LEFT
	farscall SaffronGateGuardDrinkScript
	iftrue .Ready
	applymovement PLAYER, Route6SaffronGateReturnMovement
.Ready:
	end

Route6SaffronGateReturnMovement:
	step DOWN
	step_end

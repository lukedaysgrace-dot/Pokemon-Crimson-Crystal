	object_const_def ; object_event constants
	const VIRIDIANFORESTSOUTHGATE_LASS
	const VIRIDIANFORESTSOUTHGATE_TWIN

ViridianForestSouthGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianForestSouthGateLassScript:
	jumptext ViridianForestSouthGateLassText

ViridianForestSouthGateTwinScript:
	jumptext ViridianForestSouthGateTwinText

ViridianForestSouthGateLassText:
	text "Are you going to"
	line "VIRIDIAN FOREST?"
	cont "Be careful, it's"
	cont "a natural maze!"
	done

ViridianForestSouthGateTwinText:
	text "RATTATA may be"
	line "small, but its"
	cont "bite is wicked!"
	cont "Did you get one?"
	done

ViridianForestSouthGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, VIRIDIAN_FOREST, 4
	warp_event  5,  0, VIRIDIAN_FOREST, 5
	warp_event  4,  7, ROUTE_2, 6
	warp_event  5,  7, ROUTE_2, 6

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event  8,  4, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateLassScript, -1
	object_event  2,  4, SPRITE_TWIN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateTwinScript, -1

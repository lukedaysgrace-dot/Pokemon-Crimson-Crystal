	object_const_def ; object_event constants
	const VIRIDIANFORESTSOUTHGATE_LASS
	const VIRIDIANFORESTSOUTHGATE_TWIN

ViridianForestSouthGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianForestSouthGateLassScript:
	jumptextfaceplayer ViridianForestSouthGateLassText

ViridianForestSouthGateTwinScript:
	jumptextfaceplayer ViridianForestSouthGateTwinText

ViridianForestSouthGateLassText:
	text "Going through the"
	line "forest? Pick a"
	cont "landmark!"

	para "I followed a BUG"
	line "CATCHER once. He"
	cont "was lost, too!"
	done

ViridianForestSouthGateTwinText:
	text "Did you catch a"
	line "RATTATA?"

	para "Mine chewed right"
	line "through my bag!"
	cont "Small #MON,"
	cont "big teeth!"
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
	; Both walking lanes are floor, away from the counters and central doors.
	object_event  7,  3, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateLassScript, -1
	object_event  2,  4, SPRITE_TWIN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateTwinScript, -1

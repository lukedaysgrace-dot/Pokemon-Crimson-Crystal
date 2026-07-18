	object_const_def ; object_event constants
	const VIRIDIANFORESTNORTHGATE_SUPER_NERD
	const VIRIDIANFORESTNORTHGATE_GRAMPS

ViridianForestNorthGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianForestNorthGateSuperNerdScript:
	jumptext ViridianForestNorthGateSuperNerdText

ViridianForestNorthGateGrampsScript:
	jumptext ViridianForestNorthGateGrampsText

ViridianForestNorthGateSuperNerdText:
	text "Many #MON live"
	line "only in forests"
	cont "and caves."

	para "You need to look"
	line "everywhere to get"
	cont "different kinds!"
	done

ViridianForestNorthGateGrampsText:
	text "Have you noticed"
	line "the bushes on the"
	cont "roadside?"

	para "They can be cut"
	line "down by a special"
	cont "#MON move."
	done

ViridianForestNorthGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, ROUTE_2, 2
	warp_event  5,  0, ROUTE_2, 2
	warp_event  4,  7, VIRIDIAN_FOREST, 1
	warp_event  5,  7, VIRIDIAN_FOREST, 1

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event  3,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateSuperNerdScript, -1
	object_event  2,  5, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateGrampsScript, -1

	object_const_def ; object_event constants
	const VIRIDIANFORESTNORTHGATE_SUPER_NERD
	const VIRIDIANFORESTNORTHGATE_GRAMPS

ViridianForestNorthGate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianForestNorthGateSuperNerdScript:
	jumptextfaceplayer ViridianForestNorthGateSuperNerdText

ViridianForestNorthGateGrampsScript:
	jumptextfaceplayer ViridianForestNorthGateGrampsText

ViridianForestNorthGateSuperNerdText:
	text "You won't find"
	line "every #MON on"
	cont "the roadside!"

	para "Try the forest,"
	line "then poke around"
	cont "a cave or two."
	done

ViridianForestNorthGateGrampsText:
	text "Those little trees"
	line "blocking the road?"

	para "A #MON can CUT"
	line "through them!"

	para "I tried my walking"
	line "stick. No luck."
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
	; Pace on the side aisles, keeping the center and both exits clear.
	object_event  2,  3, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateSuperNerdScript, -1
	object_event  7,  4, SPRITE_GRAMPS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateGrampsScript, -1

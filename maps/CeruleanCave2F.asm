; Layout and item positions adapted from Polished Crystal v2.2.0.
	object_const_def ; object_event constants
	const CERULEANCAVE2F_POKE_BALL1
	const CERULEANCAVE2F_POKE_BALL2
	const CERULEANCAVE2F_POKE_BALL3
	const CERULEANCAVE2F_POKE_BALL4

CeruleanCave2F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

CeruleanCave2FFullRestore:
	itemball FULL_RESTORE

CeruleanCave2FPPUp:
	itemball PP_UP

CeruleanCave2FUltraBall:
	itemball ULTRA_BALL

CeruleanCave2FDuskStone:
	itemball DUSK_STONE

CeruleanCave2FHiddenProtein:
	hiddenitem PROTEIN, EVENT_CERULEAN_CAVE_2F_HIDDEN_PROTEIN

CeruleanCave2FHiddenNugget:
	hiddenitem NUGGET, EVENT_CERULEAN_CAVE_2F_HIDDEN_NUGGET

CeruleanCave2FHiddenHyperPotion:
	hiddenitem HYPER_POTION, EVENT_CERULEAN_CAVE_2F_HIDDEN_HYPER_POTION

CeruleanCave2F_MapEvents:
	; filler
	db 0, 0

	db 6 ; warp events
	warp_event 11, 3, CERULEAN_CAVE_1F, 2
	warp_event 31, 3, CERULEAN_CAVE_1F, 3
	warp_event 3, 5, CERULEAN_CAVE_1F, 4
	warp_event 24, 8, CERULEAN_CAVE_1F, 6
	warp_event 21, 9, CERULEAN_CAVE_1F, 7
	warp_event 5, 13, CERULEAN_CAVE_1F, 8

	db 0 ; coord events

	db 3 ; bg events
	bg_event 17, 19, BGEVENT_ITEM, CeruleanCave2FHiddenProtein
	bg_event 16, 4, BGEVENT_ITEM, CeruleanCave2FHiddenNugget
	bg_event 13, 17, BGEVENT_ITEM, CeruleanCave2FHiddenHyperPotion

	db 4 ; object events
	object_event 31, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FFullRestore, EVENT_CERULEAN_CAVE_2F_FULL_RESTORE
	object_event 7, 17, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FPPUp, EVENT_CERULEAN_CAVE_2F_PP_UP
	object_event 27, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FUltraBall, EVENT_CERULEAN_CAVE_2F_ULTRA_BALL
	object_event 2, 7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FDuskStone, EVENT_CERULEAN_CAVE_2F_DUSK_STONE

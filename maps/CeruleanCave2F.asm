; Original Red/Blue layout; Crimson Crystal items and save flags retained.
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
	warp_event 29, 1, CERULEAN_CAVE_1F, 3
	warp_event 22, 6, CERULEAN_CAVE_1F, 4
	warp_event 19, 7, CERULEAN_CAVE_1F, 5
	warp_event 9, 1, CERULEAN_CAVE_1F, 6
	warp_event 1, 3, CERULEAN_CAVE_1F, 7
	warp_event 3, 11, CERULEAN_CAVE_1F, 8

	db 0 ; coord events

	db 3 ; bg events
	bg_event 15, 17, BGEVENT_ITEM, CeruleanCave2FHiddenProtein
	bg_event 14, 3, BGEVENT_ITEM, CeruleanCave2FHiddenNugget
	bg_event 10, 15, BGEVENT_ITEM, CeruleanCave2FHiddenHyperPotion

	db 4 ; object events
	object_event 29, 9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FFullRestore, EVENT_CERULEAN_CAVE_2F_FULL_RESTORE
	object_event 5, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FPPUp, EVENT_CERULEAN_CAVE_2F_PP_UP
	object_event 24, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FUltraBall, EVENT_CERULEAN_CAVE_2F_ULTRA_BALL
	object_event 1, 5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FDuskStone, EVENT_CERULEAN_CAVE_2F_DUSK_STONE

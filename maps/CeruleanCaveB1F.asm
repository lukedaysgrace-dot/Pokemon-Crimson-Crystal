; Original Red/Blue layout; Crimson Crystal items and save flags retained.
	object_const_def ; object_event constants
	const CERULEANCAVEB1F_MEWTWO
	const CERULEANCAVEB1F_POKE_BALL1
	const CERULEANCAVEB1F_POKE_BALL2

CeruleanCaveB1F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

CeruleanCaveMewtwo:
	faceplayer
	opentext
	writetext CeruleanCaveMewtwoBeforeBattleText
	waitbutton
	writetext CeruleanCaveMewtwoText
	cry MEWTWO
	pause 15
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon MEWTWO, 70
	startbattle
	disappear CERULEANCAVEB1F_MEWTWO
	reloadmapafterbattle
	end

CeruleanCaveB1FMaxElixer:
	itemball MAX_ELIXER

CeruleanCaveB1FUltraBall:
	itemball ULTRA_BALL

CeruleanCaveB1FHiddenMaxRevive:
	hiddenitem MAX_REVIVE, EVENT_CERULEAN_CAVE_B1F_HIDDEN_MAX_REVIVE

CeruleanCaveB1FHiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_CERULEAN_CAVE_B1F_HIDDEN_ULTRA_BALL

CeruleanCaveMewtwoText:
	text "Myuu!"
	done

CeruleanCaveMewtwoBeforeBattleText:
	text "That power…"
	line "it is familiar."

	para "MEW…"

	para "You have brought"
	line "the one from which"
	cont "I was created."

	para "But we are not"
	line "the same."
	done

CeruleanCaveB1F_MapEvents:
	; filler
	db 0, 0

	db 1 ; warp events
	warp_event 3, 6, CERULEAN_CAVE_1F, 9

	db 0 ; coord events

	db 2 ; bg events
	bg_event 4, 3, BGEVENT_ITEM, CeruleanCaveB1FHiddenMaxRevive
	bg_event 20, 13, BGEVENT_ITEM, CeruleanCaveB1FHiddenUltraBall

	db 3 ; object events
	object_event 27, 13, SPRITE_MEWTWO, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanCaveMewtwo, EVENT_SILVER_CAVE_ROOM_2_MEWTWO
	object_event 16, 9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FMaxElixer, EVENT_CERULEAN_CAVE_B1F_MAX_ELIXER
	object_event 18, 1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FUltraBall, EVENT_CERULEAN_CAVE_B1F_ULTRA_BALL

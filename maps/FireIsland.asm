	object_const_def ; object_event constants
	const FIREISLAND_MOLTRES

FireIsland_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

FireIslandMoltres:
	faceplayer
	opentext
	writetext FireIslandMoltresText
	cry MOLTRES
	pause 15
	closetext
	setevent EVENT_FOUGHT_MOLTRES
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon MOLTRES, 60
	startbattle
	disappear FIREISLAND_MOLTRES
	reloadmapafterbattle
	end

FireIslandMoltresText:
	text "Gyaoo!"
	done

FireIsland_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 14, 14, ROUTE_19, 2

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event  4,  4, SPRITE_MOLTRES, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, FireIslandMoltres, EVENT_FOUGHT_MOLTRES

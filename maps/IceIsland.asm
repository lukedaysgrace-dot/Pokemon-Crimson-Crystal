	object_const_def ; object_event constants
	const ICEISLAND_ARTICUNO

IceIsland_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

IceIslandArticuno:
	faceplayer
	opentext
	writetext IceIslandArticunoText
	cry ARTICUNO
	pause 15
	closetext
	setevent EVENT_FOUGHT_ARTICUNO
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon ARTICUNO, 60
	startbattle
	disappear ICEISLAND_ARTICUNO
	reloadmapafterbattle
	end

IceIslandArticunoText:
	text "Gyaoo!"
	done

IceIsland_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  8, 19, ROUTE_19, 4
	warp_event  9, 19, ROUTE_19, 4

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event 10,  5, SPRITE_ARTICUNO, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, IceIslandArticuno, EVENT_FOUGHT_ARTICUNO

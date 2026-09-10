	object_const_def ; object_event constants
	const THUNDERISLAND_ZAPDOS

ThunderIsland_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ThunderIslandZapdos:
	faceplayer
	opentext
	writetext ThunderIslandZapdosText
	cry ZAPDOS
	pause 15
	closetext
	setevent EVENT_FOUGHT_ZAPDOS
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon ZAPDOS, 60
	startbattle
	disappear THUNDERISLAND_ZAPDOS
	reloadmapafterbattle
	end

ThunderIslandZapdosText:
	text "Kyaaa!"
	done

ThunderIsland_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  3, 17, ROUTE_19, 3

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event  3,  1, SPRITE_ZAPDOS, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ThunderIslandZapdos, EVENT_FOUGHT_ZAPDOS

	object_const_def ; object_event constants
	const ROUTE5_POKEFAN_M

Route5_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Pokefan

.Pokefan:
; Derive this blocker from both milestones, including saves where returning
; the MACHINE PART already set the shared Route 5/6 disappearance flag.
	checkevent EVENT_RETURNED_MACHINE_PART
	iffalse .KeepBlocking
	checkevent EVENT_BEAT_MISTY
	iffalse .KeepBlocking
	disappear ROUTE5_POKEFAN_M
	return

.KeepBlocking:
	appear ROUTE5_POKEFAN_M
	return

Route5PokefanMScript:
	jumptextfaceplayer Route5PokefanMText

Route5UndergroundPathSign:
	jumptext Route5UndergroundPathSignText

HouseForSaleSign:
	jumptext HouseForSaleSignText

Route5PokefanMText:
	text "The road is closed"
	line "until the problem"

	para "at the POWER PLANT"
	line "is solved."

	para "While you're stuck"
	line "in CERULEAN CITY,"

	para "you may as well"
	line "check out the GYM."

	para "MISTY's a real"
	line "challenge!"
	done

Route5UndergroundPathSignText:
	text "UNDERGROUND PATH"

	para "CERULEAN CITY -"
	line "VERMILION CITY"
	done

HouseForSaleSignText:
	text "What's this?"

	para "House for Sale…"
	line "Nobody lives here."
	done

Route5_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event 17, 15, ROUTE_5_UNDERGROUND_PATH_ENTRANCE, 1
	warp_event  8, 17, ROUTE_5_SAFFRON_GATE, 1
	warp_event  9, 17, ROUTE_5_SAFFRON_GATE, 2
	warp_event 10, 11, ROUTE_5_CLEANSE_TAG_HOUSE, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event 17, 17, BGEVENT_READ, Route5UndergroundPathSign
	bg_event 10, 11, BGEVENT_READ, HouseForSaleSign

	db 1 ; object events
	object_event 17, 16, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route5PokefanMScript, EVENT_ROUTE_5_POKEFAN_M_LEFT

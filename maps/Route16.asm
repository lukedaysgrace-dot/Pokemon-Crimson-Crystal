	object_const_def ; object_event constants
	const ROUTE16_SLEEPING_SNORLAX

Route16_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .AlwaysOnBike

.AlwaysOnBike:
	readvar VAR_YCOORD
	ifless 5, .CanWalk
	readvar VAR_XCOORD
	ifgreater 13, .CanWalk
	setflag ENGINE_ALWAYS_ON_BIKE
	return

.CanWalk:
	clearflag ENGINE_ALWAYS_ON_BIKE
	return

CyclingRoadSign:
	jumptext CyclingRoadSignText

Route16Snorlax:
	opentext
	special SnorlaxAwake
	iftrue .Awake
	writetext Route16SnorlaxSleepingText
	waitbutton
	closetext
	end

.Awake:
	writetext Route16SnorlaxAwokeText
	pause 15
	cry SNORLAX
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon SNORLAX, 50
	startbattle
	disappear ROUTE16_SLEEPING_SNORLAX
	setevent EVENT_ROUTE_16_SNORLAX
	reloadmapafterbattle
	end

CyclingRoadSignText:
	text "CYCLING ROAD"

	para "DOWNHILL COASTING"
	line "ALL THE WAY!"
	done

Route16SnorlaxSleepingText:
	text "SNORLAX is snoring"
	line "peacefully…"
	done

Route16SnorlaxAwokeText:
	text "The #GEAR was"
	line "placed near the"
	cont "sleeping SNORLAX…"

	para "…"

	para "SNORLAX woke up!"
	done

Route16_MapEvents:
	db 0, 0 ; filler

	db 5 ; warp events
	warp_event  3,  1, ROUTE_16_FUCHSIA_SPEECH_HOUSE, 1
	warp_event 14,  6, ROUTE_16_GATE, 3
	warp_event 14,  7, ROUTE_16_GATE, 4
	warp_event  9,  6, ROUTE_16_GATE, 1
	warp_event  9,  7, ROUTE_16_GATE, 2

	db 0 ; coord events

	db 1 ; bg events
	bg_event  5,  5, BGEVENT_READ, CyclingRoadSign

	db 1 ; object events
	object_event 15,  6, SPRITE_BIG_SNORLAX, SPRITEMOVEDATA_SNORLAX_SLEEP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route16Snorlax, EVENT_ROUTE_16_SNORLAX

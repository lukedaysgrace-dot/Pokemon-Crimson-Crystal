	object_const_def ; object_event constants
	const ROUTE16_BIKER_AXLE
	const ROUTE16_BIKER_RUSTY
	const ROUTE16_CUEBALL_CHOPPER

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

TrainerBikerAxle:
	trainer BIKER, ROUTE16_AXLE, EVENT_BEAT_ROUTE16_BIKER_AXLE, BikerAxleSeenText, BikerAxleBeatenText, 0, .Script
.Script:
	endifjustbattled
	jumptext BikerAxleAfterText

TrainerBikerRusty:
	trainer BIKER, ROUTE16_RUSTY, EVENT_BEAT_ROUTE16_BIKER_RUSTY, BikerRustySeenText, BikerRustyBeatenText, 0, .Script
.Script:
	endifjustbattled
	jumptext BikerRustyAfterText

TrainerCueballChopper:
	trainer CUEBALL, CHOPPER, EVENT_BEAT_CUEBALL_CHOPPER, CueballChopperSeenText, CueballChopperBeatenText, 0, .Script
.Script:
	opentext
	checkevent EVENT_GOT_ASSAULT_VEST_FROM_CHOPPER
	iftrue .AfterGift
	writetext CueballChopperSpunkText
	buttonsound
	verbosegiveitem ASSAULT_VEST
	iffalse .Done
	setevent EVENT_GOT_ASSAULT_VEST_FROM_CHOPPER
.AfterGift:
	writetext CueballChopperAfterText
	waitbutton
.Done:
	closetext
	end

BikerAxleSeenText:
	text "This stretch is"
	line "our gang's spot!"

	para "You can't just"
	line "roll through here!"
	done

BikerAxleBeatenText:
	text "You ran me down!"
	done

BikerAxleAfterText:
	text "CHOPPER's the boss"
	line "of our bike gang."

	para "He likes trainers"
	line "who don't scare"
	cont "easy."
	done

BikerRustySeenText:
	text "Hear that? That's"
	line "our road calling!"

	para "Turn back, or"
	line "we'll run you off"
	cont "it!"
	done

BikerRustyBeatenText:
	text "My team wiped out!"
	done

BikerRustyAfterText:
	text "All right, you can"
	line "ride with us."
	para "Just don't scratch"
	line "my bike!"
	done

CueballChopperSeenText:
	text "I'm CHOPPER, boss"
	line "of this bike gang!"
	para "This is our turf!"
	line "You don't just"
	cont "stroll through it!"
	para "Let's see if you"
	line "can stand your"
	cont "ground!"
	done

CueballChopperBeatenText:
	text "Ha! You've got"
	line "guts, kid!"
	done

CueballChopperSpunkText:
	text "Heh! I like your"
	line "spunk, kid!"
	para "You stood up to"
	line "our gang and won."
	para "Take this"
	line "ASSAULT VEST!"
	para "You've earned it!"
	done

CueballChopperAfterText:
	text "That vest boosts"
	line "SPCL.DEF, but the"
	cont "#MON holding it"
	cont "can only use"
	cont "attacking moves!"

	para "You've earned a"
	line "spot on this road!"
	done

CyclingRoadSignText:
	text "CYCLING ROAD"

	para "DOWNHILL COASTING"
	line "ALL THE WAY!"
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

	db 3 ; object events
	object_event  6, 12, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBikerAxle, -1
	object_event  9, 14, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBikerRusty, -1
	object_event  6, 17, SPRITE_CUEBALL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerCueballChopper, -1

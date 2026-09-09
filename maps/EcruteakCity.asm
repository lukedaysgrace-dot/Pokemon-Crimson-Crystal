	object_const_def ; object_event constants
	const ECRUTEAKCITY_GRAMPS1
	const ECRUTEAKCITY_GRAMPS2
	const ECRUTEAKCITY_LASS1
	const ECRUTEAKCITY_LASS2
	const ECRUTEAKCITY_FISHER
	const ECRUTEAKCITY_YOUNGSTER
	const ECRUTEAKCITY_GRAMPS3
	const ECRUTEAKCITY_EUSINE

EcruteakCity_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint
	callback MAPCALLBACK_OBJECTS, .Eusine

.FlyPoint:
	setflag ENGINE_FLYPOINT_ECRUTEAK
	return

.Eusine:
	checkevent EVENT_FOUGHT_SUICUNE
	iftrue .HideEusine
	checkevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	iffalse .HideEusine
	clearevent EVENT_ECRUTEAK_CITY_EUSINE
	return

.HideEusine:
	setevent EVENT_ECRUTEAK_CITY_EUSINE
	return

EcruteakCityEusineTrigger:
	checkevent EVENT_FOUGHT_SUICUNE
	iftrue .Done
	checkevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	iftrue .Done
	appear ECRUTEAKCITY_EUSINE
	turnobject PLAYER, LEFT
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15
	playmusic MUSIC_MYSTICALMAN_ENCOUNTER
	applymovement ECRUTEAKCITY_EUSINE, EcruteakCityEusineApproachMovement
	opentext
	writetext EcruteakCityEusineBeforeText
	waitbutton
	closetext
	winlosstext EcruteakCityEusineBeatenText, 0
	setlasttalked ECRUTEAKCITY_EUSINE
	loadtrainer MYSTICALMAN, EUSINE2
	startbattle
	ifequal LOSE, .Lost
	setevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_MYSTICALMAN_ENCOUNTER
	opentext
	writetext EcruteakCityEusineAfterText
	waitbutton
	closetext
	playmapmusic
.Done:
	end

.Lost:
	dontrestartmapmusic
	reloadmapafterbattle
	end

EcruteakCityEusineScript:
	jumptextfaceplayer EcruteakCityEusineWaitingText

EcruteakCityEusineApproachMovement:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step RIGHT
	step_end

EcruteakCityGramps1Script:
	jumptextfaceplayer EcruteakCityGramps1Text

EcruteakCityGramps2Script:
	jumptextfaceplayer EcruteakCityGramps2Text

EcruteakCityGramps3Script:
	jumptextfaceplayer EcruteakCityGramps3Text

EcruteakCityLass1Script:
	jumptextfaceplayer EcruteakCityLass1Text

EcruteakCityLass2Script:
	faceplayer
	opentext
	checkevent EVENT_RELEASED_THE_BEASTS
	iftrue .ReleasedBeasts
	writetext EcruteakCityLass2Text
	waitbutton
	closetext
	end

.ReleasedBeasts:
	writetext EcruteakCityLass2Text_ReleasedBeasts
	waitbutton
	closetext
	end

EcruteakCityFisherScript:
	faceplayer
	opentext
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .JasmineReturned
	writetext EcruteakCityFisherText
	waitbutton
	closetext
	end

.JasmineReturned:
	writetext EcruteakCityFisherText_JasmineReturned
	waitbutton
	closetext
	end

EcruteakCityYoungsterScript:
	jumptextfaceplayer EcruteakCityYoungsterText

EcruteakCitySign:
	jumptext EcruteakCitySignText

TinTowerSign:
	jumptext TinTowerSignText

EcruteakGymSign:
	jumptext EcruteakGymSignText

EcruteakDanceTheaterSign:
	jumptext EcruteakDanceTheaterSignText

BurnedTowerSign:
	jumptext BurnedTowerSignText

EcruteakCityPokecenterSign:
	jumpstd pokecentersign

EcruteakCityMartSign:
	jumpstd martsign

EcruteakCityHiddenHyperPotion:
	hiddenitem HYPER_POTION, EVENT_ECRUTEAK_CITY_HIDDEN_HYPER_POTION

UnusedMissingDaughterText:
; unused
	text "Oh, no. Oh, no…"

	para "My daughter is"
	line "missing."

	para "No… She couldn't"
	line "have gone to the"
	cont "BURNED TOWER."

	para "I told her not to"
	line "go near it…"

	para "People seem to"
	line "disappear there…"

	para "Oh, what should I"
	line "do…?"
	done

EcruteakCityGramps1Text:
	text "ECRUTEAK used to"
	line "have two towers:"

	para "one each in the"
	line "east and west."
	done

EcruteakCityGramps2Text:
	text "Ah, child."
	line "Have you learned"

	para "to dance like the"
	line "KIMONO GIRLS?"

	para "If you go to their"
	line "DANCE THEATER, an"

	para "odd old man will"
	line "give you something"
	cont "nice, I hear."
	done

EcruteakCityLass1Text:
	text "I'm going to prac-"
	line "tice at the DANCE"

	para "THEATER. Care to"
	line "join me?"
	done

EcruteakCityLass2Text:
	text "The tower that"
	line "used to be here…"

	para "My grandma told me"
	line "it used to be much"
	cont "taller."
	done

EcruteakCityLass2Text_ReleasedBeasts:
	text "Three big #MON"
	line "ran off in differ-"
	cont "ent directions."
	cont "What were they?"
	done

EcruteakCityFisherText:
	text "I heard a rumor"
	line "about OLIVINE"
	cont "LIGHTHOUSE."

	para "The #MON that"
	line "serves as the"

	para "beacon fell ill."
	line "Sounds like they"
	cont "are in trouble."
	done

EcruteakCityFisherText_JasmineReturned:
	text "The #MON at"
	line "OLIVINE LIGHTHOUSE"
	cont "has been cured."

	para "Boats can safely"
	line "sail out to sea at"
	cont "night again."
	done

EcruteakCityYoungsterText:
	text "I hear #MON are"
	line "rampaging at the"

	para "LAKE OF RAGE. I'd"
	line "like to see that."
	done

EcruteakCityGramps3Text:
	text "In the distant"
	line "past…"

	para "This tower burned"
	line "in a fire. Three"

	para "nameless #MON"
	line "perished in it."

	para "A rainbow-colored"
	line "#MON descended"

	para "from the sky and"
	line "resurrected them…"

	para "It's a legend that"
	line "has been passed"

	para "down by ECRUTEAK"
	line "GYM LEADERS."

	para "Me?"

	para "I was a trainer"
	line "way back when."
	cont "Hohoho!"
	done

EcruteakCitySignText:
	text "ECRUTEAK CITY"
	line "A Historical City"

	para "Where the Past"
	line "Meets the Present"
	done

TinTowerSignText:
	text "TIN TOWER"

	para "A legendary #-"
	line "MON is said to"
	cont "roost here."
	done

EcruteakGymSignText:
	text "ECRUTEAK CITY"
	line "#MON GYM"
	cont "LEADER: MORTY"

	para "The Mystic Seer of"
	line "the Future"
	done

EcruteakDanceTheaterSignText:
	text "ECRUTEAK DANCE"
	line "THEATER"
	done

BurnedTowerSignText:
	text "BURNED TOWER"

	para "It was destroyed"
	line "by a mysterious"
	cont "fire."

	para "Please stay away,"
	line "as it is unsafe."
	done

EcruteakCityEusineBeforeText:
	text "EUSINE: Wait,"
	line "<PLAYER>."

	para "I know that ENTEI"
	line "is waiting within"
	cont "the tower."

	para "Before you go in,"
	line "I need to know if"
	cont "you're ready to"
	cont "face its awesome"
	cont "power."

	para "Battle me and show"
	line "me your strength!"
	done

EcruteakCityEusineBeatenText:
	text "So this is your"
	line "true strength…"
	done

EcruteakCityEusineAfterText:
	text "EUSINE: Amazing!"

	para "ENTEI's power is"
	line "fierce and proud."

	para "But the bond with"
	line "your #MON is"
	cont "just as strong."

	para "Go on, <PLAYER>."
	line "ENTEI awaits you!"
	done

EcruteakCityEusineWaitingText:
	text "EUSINE: ENTEI is"
	line "waiting inside."

	para "Go on, <PLAYER>."
	line "Show ENTEI the"
	cont "bond you have with"
	cont "your #MON!"
	done

EcruteakCity_MapEvents:
	db 0, 0 ; filler

	db 15 ; warp events
	warp_event 35, 26, ROUTE_42_ECRUTEAK_GATE, 1
	warp_event 35, 27, ROUTE_42_ECRUTEAK_GATE, 2
	warp_event 18, 11, ECRUTEAK_TIN_TOWER_ENTRANCE, 1
	warp_event 20,  2, WISE_TRIOS_ROOM, 1
	warp_event 20,  3, WISE_TRIOS_ROOM, 2
	warp_event 23, 27, ECRUTEAK_POKECENTER_1F, 1
	warp_event  5, 21, ECRUTEAK_LUGIA_SPEECH_HOUSE, 1
	warp_event 23, 21, DANCE_THEATRE, 1
	warp_event 29, 21, ECRUTEAK_MART, 2
	warp_event  6, 27, ECRUTEAK_GYM, 1
	warp_event 13, 27, ECRUTEAK_ITEMFINDER_HOUSE, 1
	warp_event 37,  7, TIN_TOWER_1F, 1
	warp_event  5,  5, BURNED_TOWER_1F, 1
	warp_event  0, 18, ROUTE_38_ECRUTEAK_GATE, 3
	warp_event  0, 19, ROUTE_38_ECRUTEAK_GATE, 4

	db 1 ; coord events
	coord_event 36, 9, -1, EcruteakCityEusineTrigger

	db 8 ; bg events
	bg_event 15, 21, BGEVENT_READ, EcruteakCitySign
	bg_event 38, 10, BGEVENT_READ, TinTowerSign
	bg_event  8, 28, BGEVENT_READ, EcruteakGymSign
	bg_event 21, 21, BGEVENT_READ, EcruteakDanceTheaterSign
	bg_event  2, 10, BGEVENT_READ, BurnedTowerSign
	bg_event 24, 27, BGEVENT_READ, EcruteakCityPokecenterSign
	bg_event 30, 21, BGEVENT_READ, EcruteakCityMartSign
	bg_event 23, 14, BGEVENT_ITEM, EcruteakCityHiddenHyperPotion

	db 8 ; object events
	object_event 18, 15, SPRITE_GRAMPS, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps1Script, -1
	object_event 20, 21, SPRITE_GRAMPS, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps2Script, -1
	object_event 21, 29, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, EcruteakCityLass1Script, -1
	object_event  3,  9, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityLass2Script, -1
	object_event  9, 22, SPRITE_FAT_GUY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, EcruteakCityFisherScript, -1
	object_event 10, 14, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, EcruteakCityYoungsterScript, -1
	object_event  3,  7, SPRITE_GRAMPS, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps3Script, EVENT_ECRUTEAK_CITY_GRAMPS
	object_event 31,  5, SPRITE_MYSTICALMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, EcruteakCityEusineScript, EVENT_ECRUTEAK_CITY_EUSINE

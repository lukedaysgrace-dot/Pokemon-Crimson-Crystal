	object_const_def ; object_event constants
	const GRAVEKEEPERSHOUSE_ELDER

GravekeepersHouse_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene ; SCENE_DEFAULT

	db 0 ; callbacks

.DummyScene:
	end

GravekeepersHouseDoorScript:
; Fires on the two tiles just inside the door. Until both gravestones are
; clean, the old man throws the player straight back out into the crypt.
	checkevent EVENT_CLEANED_GRAVE_1
	iffalse .ThrowOut
	checkevent EVENT_CLEANED_GRAVE_2
	iffalse .ThrowOut
	end

.ThrowOut:
	turnobject GRAVEKEEPERSHOUSE_ELDER, DOWN
	showemote EMOTE_SHOCK, GRAVEKEEPERSHOUSE_ELDER, 15
	opentext
	checkevent EVENT_MET_GRAVEKEEPER
	iftrue .Again
	writetext GravekeeperAngryText
	waitbutton
	setevent EVENT_MET_GRAVEKEEPER
	sjump .Eject

.Again:
	writetext GravekeeperAngryAgainText
	waitbutton

.Eject:
	closetext
	applymovement PLAYER, GravekeeperEjectMovement
	playsound SFX_EXIT_BUILDING
	waitsfx
	warp SILENT_CRYPT, 9, 4
	end

GravekeeperEjectMovement:
; Both trigger tiles sit directly above a door tile, so one step down works
; for either of them.
	step DOWN
	step_end

GravekeeperScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SPELL_TAG_FROM_GRAVEKEEPER
	iftrue .Afterwards
	writetext GravekeeperApologyText
	buttonsound
	verbosegiveitem SPELL_TAG
	iffalse .Done
	setevent EVENT_GOT_SPELL_TAG_FROM_GRAVEKEEPER
	writetext GravekeeperGaveGiftText
	waitbutton
.Done:
	closetext
	end

.Afterwards:
	writetext GravekeeperAfterText
	waitbutton
	closetext
	end

GravekeepersHouseBookshelf:
	jumpstd difficultbookshelf

GravekeeperAngryText:
	text "Out."

	para "I know your sort."
	line "Young. Bored."

	para "Those stones are"
	line "older than your"
	cont "town, and a shovel"
	cont "is cheap."

	para "Touch one and I'll"
	line "know."
	done

GravekeeperAngryAgainText:
	text "Still here?"

	para "You have no"
	line "respect."

	para "OUT."
	done

GravekeeperApologyText:
	text "…"

	para "You cleaned them."

	para "Not a single"
	line "person in forty"
	cont "years has helped"
	cont "me clean them."

	para "They come to gawk,"
	line "or they come to"
	cont "dig."

	para "You came with a"
	line "rag."

	para "I was wrong about"
	line "you. Here."
	done

GravekeeperGaveGiftText:
	text "It was pinned to a"
	line "coat I buried."

	para "I've had it for"
	line "years."

	para "Maybe it will be"
	line "of some use to"
	cont "you."
	done

GravekeeperAfterText:
	text "To think there are"
	line "kids as good as"
	cont "you still out"
	cont "there."

	para "It gives an old"
	line "man hope."

	para "Be safe on your"
	line "journey."
	done

GravekeepersHouse_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  2,  7, SILENT_CRYPT, 2
	warp_event  3,  7, SILENT_CRYPT, 2

	db 2 ; coord events
	coord_event  2,  6, SCENE_DEFAULT, GravekeepersHouseDoorScript
	coord_event  3,  6, SCENE_DEFAULT, GravekeepersHouseDoorScript

	db 2 ; bg events
	bg_event  1,  1, BGEVENT_READ, GravekeepersHouseBookshelf
	bg_event  0,  1, BGEVENT_READ, GravekeepersHouseBookshelf

	db 1 ; object events
	object_event  2,  4, SPRITE_ELDER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, GravekeeperScript, -1

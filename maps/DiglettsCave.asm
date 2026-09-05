	object_const_def ; object_event constants
	const DIGLETTSCAVE_POKEFAN_M
	const DIGLETTSCAVE_LADDER_BLOCKER

DiglettsCave_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

DiglettsCavePokefanMScript:
	jumptextfaceplayer DiglettsCavePokefanMText

DiglettsCaveHiddenMaxRevive:
	hiddenitem MAX_REVIVE, EVENT_DIGLETTS_CAVE_HIDDEN_MAX_REVIVE

DiglettsCavePokefanMText:
	text "A bunch of DIGLETT"
	line "popped out of the"

	para "ground! That was"
	line "shocking."
	done

DiglettsCaveLadderBlockerScript:
	jumptextfaceplayer DiglettsCaveLadderBlockerText

DiglettsCaveLadderBlockerText:
	text "Hold it, kid."

	para "The DIGLETT are"
	line "in a frenzy."

	para "One wrong move"
	line "down there and"
	cont "there could be a"
	cont "cave in."

	para "Try MT.MOON if"
	line "you're heading"
	cont "to PEWTER."
	done

DiglettsCave_MapEvents:
	db 0, 0 ; filler

	db 6 ; warp events
	warp_event  3, 33, VERMILION_CITY, 10
	warp_event  5, 31, DIGLETTS_CAVE, 5
	warp_event 15,  5, ROUTE_2, 1
	warp_event 17,  3, DIGLETTS_CAVE, 6
	warp_event 17, 33, DIGLETTS_CAVE, 2
	warp_event  3,  3, DIGLETTS_CAVE, 4

	db 0 ; coord events

	db 1 ; bg events
	bg_event  6, 11, BGEVENT_ITEM, DiglettsCaveHiddenMaxRevive

	db 2 ; object events
	object_event  2, 31, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DiglettsCavePokefanMScript, -1
	object_event  4, 31, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DiglettsCaveLadderBlockerScript, EVENT_BEAT_RIVAL_IN_MT_MOON

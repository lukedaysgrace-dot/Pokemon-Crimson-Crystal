; Standalone draft: 12 x 9 blocks, 24 x 18 movement cells.
; Dedicated tileset: Shucks (see data/tilesets/shucks.asm).
; Border block: $00 (solid black, all WALL).
; Deliberately absent from all map tables; no warps or world connections.
; Future entrance anchors: (11,17), (12,17). Both are ordinary FLOOR now.

	object_const_def
	const SHUCKS_BARTENDER
	const SHUCKS_DANCER1
	const SHUCKS_DANCER2
	const SHUCKS_POOL_PLAYER
	const SHUCKS_SAILOR
	const SHUCKS_PATRON

Shucks_MapScripts:
	db 0 ; scene scripts
	db 0 ; callbacks

ShucksBartenderScript:
	jumptextfaceplayer ShucksBartenderText

ShucksDancerScript:
	jumptextfaceplayer ShucksDancerText

ShucksPoolPlayerScript:
	jumptextfaceplayer ShucksPoolPlayerText

ShucksSailorScript:
	jumptextfaceplayer ShucksSailorText

ShucksPatronScript:
	jumptextfaceplayer ShucksPatronText

ShucksMenuScript:
	jumptext ShucksMenuText

ShucksPoolTableScript:
	jumptext ShucksPoolTableText

ShucksCueRackScript:
	jumptext ShucksCueRackText

ShucksBartenderText:
	text "Welcome to"
	line "SHUCKS."
	para "Beer, wine, and"
	line "spirits on the"
	cont "shelf behind me."
	para "The stage show"
	line "starts at dusk."
	done

ShucksDancerText:
	text "We're rehearsing"
	line "for tonight's set."
	para "Find a seat and"
	line "enjoy the music!"
	done

ShucksPoolPlayerText:
	text "A clean break and"
	line "a little patience."
	para "That's my entire"
	line "pool strategy."
	done

ShucksSailorText:
	text "A cold beer after"
	line "a long voyage..."
	para "Now that's what I"
	line "call shore leave!"
	done

ShucksPatronText:
	text "The dancers have"
	line "a show tonight!"
	para "I've got the best"
	line "seat in the house."
	done

ShucksMenuText:
	text "SHUCKS"
	line "BEER - WINE"
	cont "SPIRITS - WATER"
	para "Pool tables and"
	line "live stage shows."
	done

ShucksPoolTableText:
	text "A green felt pool"
	line "table. The balls"
	cont "ready for a break."
	done

ShucksCueRackText:
	text "Pool cues, neatly"
	line "arranged by size."
	done

Shucks_MapEvents:
	db 0, 0 ; filler
	db 0 ; warp events -- reserved until the map is placed
	db 0 ; coord events
	db 6 ; bg events
	bg_event 10,  2, BGEVENT_READ, ShucksMenuScript
	bg_event  4, 10, BGEVENT_READ, ShucksPoolTableScript
	bg_event  4, 12, BGEVENT_READ, ShucksPoolTableScript
	bg_event  3, 11, BGEVENT_READ, ShucksPoolTableScript
	bg_event  6, 11, BGEVENT_READ, ShucksPoolTableScript
	bg_event  1, 10, BGEVENT_READ, ShucksCueRackScript
	db 6 ; object events
	object_event  6,  4, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksBartenderScript, -1
	object_event 16,  5, SPRITE_HOSTESS, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksDancerScript, -1
	object_event 20,  4, SPRITE_HOSTESS, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksDancerScript, -1
	object_event  8, 11, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksPoolPlayerScript, -1
	object_event  4,  7, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksSailorScript, -1
	object_event 19, 13, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksPatronScript, -1

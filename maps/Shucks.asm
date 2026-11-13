; Standalone draft: 10 x 8 blocks, 20 x 16 movement cells (GSC-style interior).
; Dedicated tileset: Shucks (see data/tilesets/shucks.asm).
; Border block: $00 (solid black, all WALL).
; Deliberately absent from all map tables; no warps or world connections.
; Future entrance: the red rug at (9,15), (10,15). Both are ordinary FLOOR now.
; Regenerate graphics/blocks with: python tools/build_shucks.py
; Always night: shucks.pal is night-graded at build time (stage lights stay
; bright), so the bar looks the same at every hour. When registering, give the
; map entry PALETTE_NITE too, e.g.
;	map Shucks, TILESET_SHUCKS, INDOOR, <landmark>, <music>, FALSE, PALETTE_NITE, FISHGROUP_NONE
; and load TilesetShucksPalette from LoadSpecialMapPalette for TILESET_SHUCKS.

	object_const_def
	const SHUCKS_BARTENDER
	const SHUCKS_DANCER1
	const SHUCKS_DANCER2
	const SHUCKS_POOL_PLAYER
	const SHUCKS_SAILOR
	const SHUCKS_PATRON
	const SHUCKS_REGULAR

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

ShucksRegularScript:
	jumptextfaceplayer ShucksRegularText

ShucksMenuScript:
	jumptext ShucksMenuText

ShucksPoolTableScript:
	jumptext ShucksPoolTableText

ShucksCueRackScript:
	jumptext ShucksCueRackText

ShucksBottleShelfScript:
	jumptext ShucksBottleShelfText

ShucksSpeakerScript:
	jumptext ShucksSpeakerText

ShucksBartenderText:
	text "Welcome to SHUCKS."

	para "Sodas, juices and"
	line "MOOMOO MILK on the"
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
	text "An ice-cold MOOMOO"
	line "MILK after a long"
	cont "voyage…"

	para "Now that's what I"
	line "call shore leave!"
	done

ShucksPatronText:
	text "The dancers have"
	line "a show tonight!"
	para "I've got the best"
	line "seat in the house."
	done

ShucksRegularText:
	text "Same table, same"
	line "drink every night."

	para "The bartender has"
	line "my order poured"
	cont "before I sit down!"
	done

ShucksMenuText:
	text "SHUCKS"

	para "SODA - JUICE -"
	line "MOOMOO MILK -"
	cont "WATER"

	para "Pool tables and"
	line "live stage shows."
	done

ShucksPoolTableText:
	text "A green felt pool"
	line "table. The balls"
	cont "are racked for a"
	cont "break."
	done

ShucksCueRackText:
	text "Pool cues, neatly"
	line "arranged by size."
	done

ShucksBottleShelfText:
	text "Rows of glass"
	line "bottles glint in"
	cont "the stage lights."
	done

ShucksSpeakerText:
	text "A huge speaker."
	line "It's thumping with"
	cont "a heavy bass line!"
	done

Shucks_MapEvents:
	db 0, 0 ; filler
	db 0 ; warp events -- reserved until the map is placed
	db 0 ; coord events
	db 9 ; bg events
	bg_event 10,  0, BGEVENT_UP, ShucksMenuScript
	bg_event  4,  8, BGEVENT_READ, ShucksPoolTableScript
	bg_event  5, 10, BGEVENT_READ, ShucksPoolTableScript
	bg_event  3,  9, BGEVENT_READ, ShucksPoolTableScript
	bg_event  6,  9, BGEVENT_READ, ShucksPoolTableScript
	bg_event  1,  9, BGEVENT_READ, ShucksCueRackScript
	bg_event  2,  3, BGEVENT_READ, ShucksBottleShelfScript
	bg_event 11,  3, BGEVENT_READ, ShucksSpeakerScript
	bg_event 19,  3, BGEVENT_READ, ShucksSpeakerScript
	db 7 ; object events
	object_event  4,  2, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksBartenderScript, -1
	object_event 14,  2, SPRITE_HOSTESS, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksDancerScript, -1
	object_event 16,  3, SPRITE_HOSTESS, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksDancerScript, -1
	object_event  7,  9, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksPoolPlayerScript, -1
	object_event  3,  4, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksSailorScript, -1
	object_event 10, 10, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksPatronScript, -1
	object_event 19, 13, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ShucksRegularScript, -1

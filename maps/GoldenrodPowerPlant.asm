	object_const_def ; object_event constants
	const GOLDENRODPOWERPLANT_ENGINEER1
	const GOLDENRODPOWERPLANT_ENGINEER2
	const GOLDENRODPOWERPLANT_ENGINEER3
	const GOLDENRODPOWERPLANT_CHIEF

GoldenrodPowerPlant_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

GoldenrodPowerPlantEngineer1Script:
	jumptextfaceplayer GoldenrodPowerPlantEngineer1Text

GoldenrodPowerPlantEngineer2Script:
	jumptextfaceplayer GoldenrodPowerPlantEngineer2Text

GoldenrodPowerPlantEngineer3Script:
	jumptextfaceplayer GoldenrodPowerPlantEngineer3Text

GoldenrodPowerPlantChiefScript:
	jumptextfaceplayer GoldenrodPowerPlantChiefText

GoldenrodPowerPlantBookshelf:
	jumpstd difficultbookshelf

GoldenrodPowerPlantEngineer1Text:
	text "This plant feeds"
	line "all of GOLDENROD."

	para "The DEPT.STORE,"
	line "the RADIO TOWER,"

	para "the MAGNET TRAIN…"
	line "all of it runs on"
	cont "our generators."
	done

GoldenrodPowerPlantEngineer2Text:
	text "Careful! Those"
	line "turbines put out"

	para "enough juice to"
	line "fry a MAGNEMITE."

	para "Don't touch any-"
	line "thing, please."
	done

GoldenrodPowerPlantEngineer3Text:
	text "Load's been spik-"
	line "ing all week."

	para "If we don't get a"
	line "second generator"

	para "online, the whole"
	line "city browns out."
	done

GoldenrodPowerPlantChiefText:
	text "CHIEF: So you're"
	line "the one poking"
	cont "around my plant?"

	para "Hmph. Long as you"
	line "keep your hands"

	para "off my switches,"
	line "look all you like."

	para "Electricity waits"
	line "for nobody!"
	done

GoldenrodPowerPlant_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  6, 17, GOLDENROD_CITY, 16
	warp_event  7, 17, GOLDENROD_CITY, 16
	warp_event 18,  2, GOLDENROD_POWER_PLANT_B1F, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event  0,  1, BGEVENT_READ, GoldenrodPowerPlantBookshelf
	bg_event  1,  1, BGEVENT_READ, GoldenrodPowerPlantBookshelf

	db 4 ; object events
	object_event  4,  5, SPRITE_ENGINEER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPowerPlantEngineer1Script, -1
	object_event 14, 10, SPRITE_ENGINEER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPowerPlantEngineer2Script, -1
	object_event 18,  8, SPRITE_ENGINEER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPowerPlantEngineer3Script, -1
	object_event  8, 10, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodPowerPlantChiefScript, -1

	object_const_def ; object_event constants
	const CELADONDEPTSTORE4F_CLERK
	const CELADONDEPTSTORE4F_SUPER_NERD
	const CELADONDEPTSTORE4F_YOUNGSTER
	const CELADONDEPTSTORE4F_FURNITURE_CLERK

CeladonDeptStore4F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

CeladonDeptStore4FClerkScript:
	faceplayer
	opentext
	writetext CeladonDeptStore4FExpandedStockText
	yesorno
	iffalse .OriginalStock
	pokemart MARTTYPE_STANDARD, MART_EXPANDED_3
	closetext
	end
.OriginalStock
	pokemart MARTTYPE_STANDARD, MART_CELADON_4F
	closetext
	end

CeladonDeptStore4FSuperNerdScript:
	jumptextfaceplayer CeladonDeptStore4FSuperNerdText

CeladonDeptStore4FYoungsterScript:
	jumptextfaceplayer CeladonDeptStore4FYoungsterText

CeladonDeptStore4FFurnitureClerkScript:
	faceplayer
	opentext
	writetext CeladonDeptStore4FFurnitureClerkText
	waitbutton
	callasm CeladonFurnitureShop
	closetext
	end

CeladonDeptStore4FDirectory:
	jumptext CeladonDeptStore4FDirectoryText

CeladonDeptStore4FElevatorButton:
	jumpstd elevatorbutton

CeladonDeptStore4FSuperNerdText:
	text "I'm here to buy"
	line "a nice poster for"
	cont "my girlfriend."
	done

CeladonDeptStore4FYoungsterText:
	text "Beds, carpets,"
	line "plants, consoles…"
	para "I could decorate"
	line "my whole room!"
	done

CeladonDeptStore4FFurnitureClerkText:
	text "Make your room"
	line "your own!"
	para "We sell furniture,"
	line "posters and game"
	cont "consoles."
	done

CeladonDeptStore4FDirectoryText:
	text "Express Yourself"
	line "With Gifts!"

	para "4F: WISEMAN GIFTS"
	done

CeladonDeptStore4F_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event 12,  0, CELADON_DEPT_STORE_5F, 1
	warp_event 15,  0, CELADON_DEPT_STORE_3F, 2
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore4FDirectory
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore4FElevatorButton

	db 4 ; object events
	object_event 13,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FClerkScript, -1
	object_event  7,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FSuperNerdScript, -1
	object_event  8,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FYoungsterScript, -1
	object_event 11,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FFurnitureClerkScript, -1

CeladonDeptStore4FExpandedStockText:
	text "Would you like to"
	line "see our new stock?"
	done

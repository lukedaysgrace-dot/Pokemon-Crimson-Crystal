	object_const_def ; object_event constants
	const GOLDENRODPPSPEECHHOUSE_FISHER
	const GOLDENRODPPSPEECHHOUSE_LASS
	const GOLDENRODPPSPEECHHOUSE_UTILITY_TUTOR

GoldenrodPPSpeechHouse_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

GoldenrodPPSpeechHouseFisherScript:
	jumptextfaceplayer GoldenrodPPSpeechHouseFisherText

GoldenrodPPSpeechHouseLassScript:
	jumptextfaceplayer GoldenrodPPSpeechHouseLassText

GoldenrodUtilityTutorScript:
	faceplayer
	opentext
	checkmoney YOUR_MONEY, 1000
	ifequal HAVE_LESS, .NotEnoughMoney
	special UtilityMoveTutor
	ifequal FALSE, .TeachMove
	waitbutton
	closetext
	end

.TeachMove:
	takemoney YOUR_MONEY, 1000
	waitsfx
	playsound SFX_TRANSACTION
	writetext GoldenrodUtilityTutorDoneText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext GoldenrodUtilityTutorNotEnoughMoneyText
	waitbutton
	closetext
	end

GoldenrodUtilityTutorDoneText:
	text "There we go!"
	line "That's ¥1000."
	done

GoldenrodUtilityTutorNotEnoughMoneyText:
	text "Sorry, you don't"
	line "have enough money."
	done

GoldenrodPPSpeechHouseBookshelf2:
	jumpstd difficultbookshelf

GoldenrodPPSpeechHouseBookshelf1:
	jumpstd magazinebookshelf

GoldenrodPPSpeechHouseRadio:
	jumpstd radio2

GoldenrodPPSpeechHouseFisherText:
	text "Once while I was"
	line "battling, my"

	para "#MON couldn't"
	line "make any moves."

	para "The POWER POINTS,"
	line "or PP, of its"

	para "moves were all"
	line "gone."
	done

GoldenrodPPSpeechHouseLassText:
	text "Sometimes, a"
	line "healthy #MON"

	para "may be unable to"
	line "use its moves."

	para "If that happens,"
	line "heal it at a #-"
	cont "MON CENTER or use"
	cont "an item."
	done

GoldenrodPPSpeechHouse_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  2,  7, GOLDENROD_CITY, 7
	warp_event  3,  7, GOLDENROD_CITY, 7

	db 0 ; coord events

	db 3 ; bg events
	bg_event  0,  1, BGEVENT_READ, GoldenrodPPSpeechHouseBookshelf1
	bg_event  1,  1, BGEVENT_READ, GoldenrodPPSpeechHouseBookshelf2
	bg_event  7,  1, BGEVENT_READ, GoldenrodPPSpeechHouseRadio

	db 3 ; object events
	object_event  2,  4, SPRITE_FAT_GUY, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodPPSpeechHouseFisherScript, -1
	object_event  5,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPPSpeechHouseLassScript, -1
	object_event  6,  5, SPRITE_MOVE_TUTOR, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, GoldenrodUtilityTutorScript, -1

	object_const_def ; object_event constants
	const MOVEDELETERSHOUSE_SUPER_NERD
	const MOVEDELETERSHOUSE_UNUSED_GUY

MoveDeletersHouse_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

MoveDeleter:
	faceplayer
	opentext
	special MoveDeletion
	waitbutton
	closetext
	end

MoveReminderScript:
	faceplayer
	opentext
	checkmoney YOUR_MONEY, 1000
	ifequal HAVE_LESS, .NotEnoughMoney
	special MoveReminder
	ifequal FALSE, .TeachMove
	waitbutton
	closetext
	end

.TeachMove:
	takemoney YOUR_MONEY, 1000
	waitsfx
	playsound SFX_TRANSACTION
	writetext MoveReminderDoneText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext MoveReminderNotEnoughMoneyText
	waitbutton
	closetext
	end

MoveDeletersHouseBookshelf:
	jumpstd difficultbookshelf

MoveReminderDoneText:
	text "There we go!"
	line "That's ¥1000."
	done

MoveReminderNotEnoughMoneyText:
	text "Sorry, you don't"
	line "have enough money."
	done

MoveDeletersHouse_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  2,  7, BLACKTHORN_CITY, 6
	warp_event  3,  7, BLACKTHORN_CITY, 6

	db 0 ; coord events

	db 2 ; bg events
	bg_event  0,  1, BGEVENT_READ, MoveDeletersHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, MoveDeletersHouseBookshelf

	db 2 ; object events
	object_event  2,  3, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MoveDeleter, -1
	object_event  5,  3, SPRITE_UNUSED_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, MoveReminderScript, -1

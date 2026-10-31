CELADONDEPTSTORE6F_FRESH_WATER_PRICE EQU 2000
CELADONDEPTSTORE6F_SODA_POP_PRICE    EQU 3000
CELADONDEPTSTORE6F_LEMONADE_PRICE    EQU 4000

	object_const_def ; object_event constants
	const CELADONDEPTSTORE6F_LITTLE_GIRL
	const CELADONDEPTSTORE6F_DAD

CeladonDeptStore6F_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_TILES, .HideRooftopStairs

.HideRooftopStairs:
	changeblock 12, 0, $03 ; wall
	return

CeladonDeptStore6FLittleGirlScript:
	faceplayer
	opentext
	checkevent EVENT_CELADON_GIRL_GOT_FRESH_WATER
	iffalse .Thirsty
	checkevent EVENT_CELADON_GIRL_GOT_SODA_POP
	iffalse .Thirsty
	checkevent EVENT_CELADON_GIRL_GOT_LEMONADE
	iftrue .HadAllDrinks
.Thirsty:
	writetext CeladonDeptStore6FLittleGirlThirstyText
	yesorno
	iffalse .Declined
	writetext CeladonDeptStore6FLittleGirlWhichDrinkText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .FreshWater
	ifequal 2, .SodaPop
	ifequal 3, .Lemonade
.Declined:
	writetext CeladonDeptStore6FLittleGirlDeclinedText
	waitbutton
	closetext
	end

.FreshWater:
	checkevent EVENT_CELADON_GIRL_GOT_FRESH_WATER
	iftrue .AlreadyHadDrink
	takeitem FRESH_WATER
	iffalse .NoDrink
	giveitem MAX_ELIXER
	iffalse .ReturnFreshWater
	setevent EVENT_CELADON_GIRL_GOT_FRESH_WATER
	getitemname STRING_BUFFER_4, MAX_ELIXER
	sjump .ReceivedReward

.SodaPop:
	checkevent EVENT_CELADON_GIRL_GOT_SODA_POP
	iftrue .AlreadyHadDrink
	takeitem SODA_POP
	iffalse .NoDrink
	giveitem RARE_CANDY
	iffalse .ReturnSodaPop
	setevent EVENT_CELADON_GIRL_GOT_SODA_POP
	getitemname STRING_BUFFER_4, RARE_CANDY
	sjump .ReceivedReward

.Lemonade:
	checkevent EVENT_CELADON_GIRL_GOT_LEMONADE
	iftrue .AlreadyHadDrink
	takeitem LEMONADE
	iffalse .NoDrink
	giveitem PP_MAX
	iffalse .ReturnLemonade
	setevent EVENT_CELADON_GIRL_GOT_LEMONADE
	getitemname STRING_BUFFER_4, PP_MAX

.ReceivedReward:
	writetext CeladonDeptStore6FLittleGirlThankYouText
	buttonsound
	writetext CeladonDeptStore6FLittleGirlRewardText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	itemnotify
	closetext
	end

; Removing the last drink can free a Bag slot for the reward. If the
; reward still won't fit, restore the drink and leave its gift unclaimed.
.ReturnFreshWater:
	giveitem FRESH_WATER
	sjump .NoRoom
.ReturnSodaPop:
	giveitem SODA_POP
	sjump .NoRoom
.ReturnLemonade:
	giveitem LEMONADE
.NoRoom:
	writetext CeladonDeptStore6FLittleGirlNoRoomText
	waitbutton
	closetext
	end

.NoDrink:
	writetext CeladonDeptStore6FLittleGirlNoDrinkText
	waitbutton
	closetext
	end

.AlreadyHadDrink:
	writetext CeladonDeptStore6FLittleGirlAlreadyHadDrinkText
	waitbutton
	closetext
	end

.HadAllDrinks:
	writetext CeladonDeptStore6FLittleGirlHadAllDrinksText
	waitbutton
	closetext
	end

.MenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 0, 13, 9
	dw .MenuData
	db 1

.MenuData:
	db STATICMENU_CURSOR
	db 4
	db "FRESH WATER@"
	db "SODA POP@"
	db "LEMONADE@"
	db "CANCEL@"

CeladonDeptStore6FDadScript:
	jumptextfaceplayer CeladonDeptStore6FDadText

CeladonDeptStore6FVendingMachine:
	opentext
	writetext CeladonVendingText
.Start:
	special PlaceMoneyTopRight
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .FreshWater
	ifequal 2, .SodaPop
	ifequal 3, .Lemonade
	closetext
	end

.FreshWater:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_FRESH_WATER_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem FRESH_WATER
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_FRESH_WATER_PRICE
	getitemname STRING_BUFFER_3, FRESH_WATER
	sjump .VendItem

.SodaPop:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_SODA_POP_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem SODA_POP
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_SODA_POP_PRICE
	getitemname STRING_BUFFER_3, SODA_POP
	sjump .VendItem

.Lemonade:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_LEMONADE_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem LEMONADE
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_LEMONADE_PRICE
	getitemname STRING_BUFFER_3, LEMONADE
	sjump .VendItem

.VendItem:
	pause 10
	playsound SFX_ENTER_DOOR
	writetext CeladonClangText
	buttonsound
	itemnotify
	sjump .Start

.NotEnoughMoney:
	writetext CeladonVendingNoMoneyText
	waitbutton
	sjump .Start

.NotEnoughSpace:
	writetext CeladonVendingNoSpaceText
	waitbutton
	sjump .Start

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "FRESH WATER ¥2000@"
	db "SODA POP    ¥3000@"
	db "LEMONADE    ¥4000@"
	db "CANCEL@"

CeladonDeptStore6FDirectory:
	jumptext CeladonDeptStore6FDirectoryText

CeladonDeptStore6FElevatorButton:
	jumpstd elevatorbutton

CeladonVendingText:
	text "The drinks are"
	line "really expensive!"
	done

CeladonClangText:
	text "Clang!"

	para "@"
	text_ram wStringBuffer3
	text_start
	line "popped out."
	done

CeladonVendingNoMoneyText:
	text "Oops, not enough"
	line "money…"
	done

CeladonVendingNoSpaceText:
	text "There's no more"
	line "room for stuff…"
	done

CeladonDeptStore6FLittleGirlThirstyText:
	text "I'm here with my"
	line "dad!"

	para "I'm thirsty! Will"
	line "you give me a"
	cont "drink?"
	done

CeladonDeptStore6FLittleGirlWhichDrinkText:
	text "Which drink will"
	line "you give me?"
	done

CeladonDeptStore6FLittleGirlDeclinedText:
	text "That's OK!"
	line "I'll ask my dad."
	done

CeladonDeptStore6FLittleGirlThankYouText:
	text "Yay! Thank you!"
	line "It's delicious!"

	para "You can have this"
	line "as a thank-you!"
	done

CeladonDeptStore6FLittleGirlRewardText:
	text "<PLAYER> received"
	line "@"
	text_ram wStringBuffer4
	text "!"
	done

CeladonDeptStore6FLittleGirlNoRoomText:
	text "Your BAG is full!"
	line "Keep your drink"
	cont "for now."

	para "Make room for my"
	line "present first!"
	done

CeladonDeptStore6FLittleGirlNoDrinkText:
	text "You don't have"
	line "that drink!"
	done

CeladonDeptStore6FLittleGirlAlreadyHadDrinkText:
	text "You gave me that"
	line "one already!"

	para "I'd like to try"
	line "a different one!"
	done

CeladonDeptStore6FLittleGirlHadAllDrinksText:
	text "Thanks for all the"
	line "yummy drinks!"

	para "I'm having fun"
	line "shopping with my"
	cont "dad!"
	done

CeladonDeptStore6FDadText:
	text "I'm taking my"
	line "daughter shopping."

	para "I work at SILPH"
	line "CO., so we don't"
	cont "get many days out."
	done

CeladonDeptStore6FDirectoryText:
	text "6F: ROOFTOP SQUARE"
	line "VENDING MACHINES"
	done

CeladonDeptStore6F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 15,  0, CELADON_DEPT_STORE_5F, 2
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	db 0 ; coord events

	db 6 ; bg events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore6FDirectory
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore6FElevatorButton
	bg_event  8,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event  9,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event 10,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event 11,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine

	db 2 ; object events
	object_event  9,  5, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore6FLittleGirlScript, -1
	object_event 11,  5, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore6FDadScript, -1

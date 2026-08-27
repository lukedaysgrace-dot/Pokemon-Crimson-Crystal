	object_const_def ; object_event constants
	const LAKEOFRAGEHIDDENPOWERHOUSE_FISHER

LakeOfRageHiddenPowerHouse_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

HiddenPowerGuy:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM10_HIDDEN_POWER
	iftrue .AlreadyGotItem
	writetext HiddenPowerGuyText1
	buttonsound
	verbosegiveitem TM_HIDDEN_POWER
	iffalse .Done
	setevent EVENT_GOT_TM10_HIDDEN_POWER
	writetext HiddenPowerGuyText2
	buttonsound
.ChooseType:
; Each Pokémon keeps its own Hidden Power type: pick one, hear its current
; type, then choose the new one (see engine/events/hidden_power_type.asm).
	writetext HiddenPowerGuyWhichMonText
	buttonsound
	special HiddenPowerSelectMon
	ifequal 0, .NoChange
	ifequal 2, .Egg
	writetext HiddenPowerGuyCurrentTypeText
	buttonsound
	special HiddenPowerTypeMenu
	iffalse .NoChange
	writetext HiddenPowerGuyChoseTypeText
	waitbutton
	closetext
	end
.NoChange:
	writetext HiddenPowerGuyNoChangeText
	waitbutton
	closetext
	end
.Egg:
	writetext HiddenPowerGuyEggText
	waitbutton
	closetext
	end
.AlreadyGotItem:
	writetext HiddenPowerGuyText3
	buttonsound
	writetext HiddenPowerGuyRetuneText
	yesorno
	iftrue .ChooseType
.Done:
	closetext
	end

HiddenPowerHouseBookshelf:
	jumpstd difficultbookshelf

HiddenPowerGuyText1:
	text "…You have strayed"
	line "far…"

	para "Here I have medi-"
	line "tated. Inside me,"

	para "a new power has"
	line "been awakened."

	para "Let me share my"
	line "power with your"

	para "#MON."
	line "Take this, child."
	done

HiddenPowerGuyText2:
	text "Do you see it? It"
	line "is HIDDEN POWER!"

	para "It draws out the"
	line "power of #MON"
	cont "for attacking."

	para "Through my medita-"
	line "tion, I may shape"
	cont "its type for you."
	done

HiddenPowerGuyText3:
	text "I am meditating…"
	done

HiddenPowerGuyWhichMonText:
	text "Which #MON's"
	line "HIDDEN POWER shall"
	cont "I reshape?"
	done

HiddenPowerGuyCurrentTypeText:
	text_ram wStringBuffer3
	text "…"
	line "Its HIDDEN POWER"
	cont "is @"
	text_ram wStringBuffer4
	text " type."

	para "What type shall"
	line "it take?"
	done

HiddenPowerGuyChoseTypeText:
	text_ram wStringBuffer4
	text " type…"

	para "It is done."
	line "@"
	text_ram wStringBuffer3
	text "'s"
	cont "HIDDEN POWER has"
	cont "been reshaped."
	done

HiddenPowerGuyEggText:
	text "An EGG holds no"
	line "power I can shape"
	cont "yet."
	done

HiddenPowerGuyNoChangeText:
	text "Hmm… You are not"
	line "yet ready. Return"
	cont "when you have"
	cont "decided."
	done

HiddenPowerGuyRetuneText:
	text "Shall I reshape a"
	line "#MON's HIDDEN"
	cont "POWER type?"
	done

LakeOfRageHiddenPowerHouse_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  2,  7, LAKE_OF_RAGE, 1
	warp_event  3,  7, LAKE_OF_RAGE, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event  0,  1, BGEVENT_READ, HiddenPowerHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, HiddenPowerHouseBookshelf

	db 1 ; object events
	object_event  2,  3, SPRITE_FISHER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, HiddenPowerGuy, -1

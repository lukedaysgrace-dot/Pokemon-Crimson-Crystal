	object_const_def ; object_event constants
	const RUINSOFALPHFOSSILLAB_SCIENTIST1
	const RUINSOFALPHFOSSILLAB_SCIENTIST2
	const RUINSOFALPHFOSSILLAB_SCIENTIST3

RuinsOfAlphFossilLab_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

RuinsOfAlphFossilLabScientist1Script:
	faceplayer
	opentext
	writetext RuinsOfAlphFossilLabScientist1Text
	waitbutton
	closetext
	end

RuinsOfAlphFossilLabScientist2Script:
	faceplayer
	opentext
	writetext RuinsOfAlphFossilLabScientist2Text
	waitbutton
	closetext
	end

; The fossil reviver. Takes one fossil, walks to the resurrection machine,
; runs it, and comes back with the restored POKeMON.
RuinsOfAlphFossilLabScientist3Script:
	faceplayer
	opentext
	writetext RuinsOfAlphFossilLabReviverIntroText
	waitbutton
	closetext
	checkitem DOME_FOSSIL
	iftrue .HasFossil
	checkitem HELIX_FOSSIL
	iftrue .HasFossil
	checkitem ROOT_FOSSIL
	iftrue .HasFossil
	checkitem CLAW_FOSSIL
	iftrue .HasFossil
	checkitem ARMOR_FOSSIL
	iftrue .HasFossil
	checkitem SAIL_FOSSIL
	iftrue .HasFossil
	checkitem SKULL_FOSSIL
	iftrue .HasFossil
	checkitem COVER_FOSSIL
	iftrue .HasFossil
	checkitem JAW_FOSSIL
	iftrue .HasFossil
	checkitem OLD_AMBER
	iftrue .HasFossil
	checkitem PLUME_FOSSIL
	iftrue .HasFossil
	opentext
	writetext RuinsOfAlphFossilLabNoFossilText
	waitbutton
	closetext
	end

.HasFossil:
	opentext
	writetext RuinsOfAlphFossilLabOfferText
	yesorno
	iffalse .Declined
	writetext RuinsOfAlphFossilLabAcceptText
	waitbutton
	closetext
	applymovement RUINSOFALPHFOSSILLAB_SCIENTIST3, RuinsOfAlphFossilLabToMachineMovement
	playsound SFX_BOOT_PC
	waitsfx
	pause 20
	playsound SFX_TWO_PC_BEEPS
	waitsfx
	pause 15
	playsound SFX_TWO_PC_BEEPS
	waitsfx
	pause 15
	playsound SFX_TWO_PC_BEEPS
	waitsfx
	pause 30
	playsound SFX_ELEVATOR_END
	waitsfx
	pause 20
	playsound SFX_SHUT_DOWN_PC
	waitsfx
	pause 20
	applymovement RUINSOFALPHFOSSILLAB_SCIENTIST3, RuinsOfAlphFossilLabFromMachineMovement
	faceplayer
	opentext
	writetext RuinsOfAlphFossilLabDoneText
	waitbutton
	closetext
; Whichever fossil came back first above is the one that goes in the machine.
	checkitem DOME_FOSSIL
	iftrue .Dome
	checkitem HELIX_FOSSIL
	iftrue .Helix
	checkitem ROOT_FOSSIL
	iftrue .Root
	checkitem CLAW_FOSSIL
	iftrue .Claw
	checkitem ARMOR_FOSSIL
	iftrue .Armor
	checkitem SAIL_FOSSIL
	iftrue .Sail
	checkitem SKULL_FOSSIL
	iftrue .Skull
	checkitem COVER_FOSSIL
	iftrue .Cover
	checkitem JAW_FOSSIL
	iftrue .Jaw
	checkitem OLD_AMBER
	iftrue .Amber
	checkitem PLUME_FOSSIL
	iftrue .Plume
	end

.Dome:
	takeitem DOME_FOSSIL
	givepoke KABUTO, 10
	sjump .Revived
.Helix:
	takeitem HELIX_FOSSIL
	givepoke OMANYTE, 10
	sjump .Revived
.Root:
	takeitem ROOT_FOSSIL
	givepoke LILEEP, 10
	sjump .Revived
.Claw:
	takeitem CLAW_FOSSIL
	givepoke ANORITH, 20
	sjump .Revived
.Armor:
	takeitem ARMOR_FOSSIL
	givepoke SHIELDON, 20
	sjump .Revived
.Sail:
	takeitem SAIL_FOSSIL
	givepoke AMAURA, 20
	sjump .Revived
.Skull:
	takeitem SKULL_FOSSIL
	givepoke CRANIDOS, 20
	sjump .Revived
.Cover:
	takeitem COVER_FOSSIL
	givepoke TIRTOUGA, 20
	sjump .Revived
.Jaw:
	takeitem JAW_FOSSIL
	givepoke TYRUNT, 20
	sjump .Revived
.Amber:
	takeitem OLD_AMBER
	givepoke AERODACTYL, 30
	sjump .Revived
.Plume:
	takeitem PLUME_FOSSIL
	givepoke ARCHEN, 30
	sjump .Revived

.Revived:
	opentext
	writetext RuinsOfAlphFossilLabRevivedText
	waitbutton
	closetext
	end

.Declined:
	writetext RuinsOfAlphFossilLabDeclinedText
	waitbutton
	closetext
	end

RuinsOfAlphFossilLabToMachineMovement:
	step UP
	step UP
	step_end

RuinsOfAlphFossilLabFromMachineMovement:
	step DOWN
	step DOWN
	step_end

RuinsOfAlphFossilLabMachine:
	jumptext RuinsOfAlphFossilLabMachineText

RuinsOfAlphFossilLabPrinter:
	jumptext RuinsOfAlphFossilLabPrinterText

RuinsOfAlphFossilLabBookshelf:
	jumpstd difficultbookshelf

RuinsOfAlphFossilLabScientist1Text:
	text "The RUINS are full"
	line "of fossils."

	para "Everything here is"
	line "older than any"
	cont "record we have."
	done

RuinsOfAlphFossilLabScientist2Text:
	text "That machine can"
	line "resurrect a #-"
	cont "MON from a fossil!"

	para "It reads the cell"
	line "structure and"
	cont "rebuilds it whole."
	done

RuinsOfAlphFossilLabReviverIntroText:
	text "Hi! I'm a FOSSIL"
	line "specialist."

	para "Bring me a fossil"
	line "and I'll restore"
	cont "the #MON in it!"
	done

RuinsOfAlphFossilLabNoFossilText:
	text "Oh? You don't have"
	line "a fossil on you."

	para "Try the walls deep"
	line "inside the RUINS."
	done

RuinsOfAlphFossilLabOfferText:
	text "Oh! That's a rare"
	line "fossil!"

	para "Shall I resurrect"
	line "the #MON in it?"
	done

RuinsOfAlphFossilLabAcceptText:
	text "Leave it to me!"
	line "Give me a minute…"
	done

RuinsOfAlphFossilLabDeclinedText:
	text "No? Come back any"
	line "time you like."
	done

RuinsOfAlphFossilLabDoneText:
	text "It's all done!"
	line "Here you go!"
	done

RuinsOfAlphFossilLabRevivedText:
	text "Amazing, isn't it?"

	para "That #MON was"
	line "asleep in stone"
	cont "for eons!"
	done

RuinsOfAlphFossilLabMachineText:
	text "It's the FOSSIL"
	line "resurrection"
	cont "machine."

	para "Something inside"
	line "is humming."
	done

RuinsOfAlphFossilLabPrinterText:
	text "A printout: #-"
	line "MON of the ancient"
	cont "RUINS OF ALPH."
	done

RuinsOfAlphFossilLab_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  4,  7, RUINS_OF_ALPH_OUTSIDE, 12
	warp_event  5,  7, RUINS_OF_ALPH_OUTSIDE, 12

	db 0 ; coord events

	db 4 ; bg events
	bg_event  0,  5, BGEVENT_READ, RuinsOfAlphFossilLabBookshelf
	bg_event  1,  5, BGEVENT_READ, RuinsOfAlphFossilLabBookshelf
	bg_event  6,  0, BGEVENT_READ, RuinsOfAlphFossilLabMachine
	bg_event  9,  1, BGEVENT_READ, RuinsOfAlphFossilLabPrinter

	db 3 ; object events
	object_event  2,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphFossilLabScientist1Script, -1
	object_event  8,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphFossilLabScientist2Script, -1
	object_event  6,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphFossilLabScientist3Script, -1

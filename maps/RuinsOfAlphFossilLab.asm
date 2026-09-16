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

; The fossil reviver. Lists the fossils the player is carrying, then runs
; the chosen one through the resurrection machine.
RuinsOfAlphFossilLabScientist3Script:
	faceplayer
	opentext
	writetext RuinsOfAlphFossilLabReviverIntroText
	waitbutton
	special FossilRevivalMenu
	ifequal DOME_FOSSIL, .Dome
	ifequal HELIX_FOSSIL, .Helix
	ifequal ROOT_FOSSIL, .Root
	ifequal CLAW_FOSSIL, .Claw
	ifequal ARMOR_FOSSIL, .Armor
	ifequal SAIL_FOSSIL, .Sail
	ifequal SKULL_FOSSIL, .Skull
	ifequal COVER_FOSSIL, .Cover
	ifequal JAW_FOSSIL, .Jaw
	ifequal OLD_AMBER, .Amber
	ifequal PLUME_FOSSIL, .Plume
	ifnotequal 0, .Declined
	writetext RuinsOfAlphFossilLabNoFossilText
	waitbutton
	closetext
	end

.Declined:
	writetext RuinsOfAlphFossilLabDeclinedText
	waitbutton
	closetext
	end

.NoRoom:
	writetext RuinsOfAlphFossilLabPartyFullText
	waitbutton
	closetext
	end

.Dome:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem DOME_FOSSIL
	givepoke KABUTO, 10
	sjump .Revived

.Helix:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem HELIX_FOSSIL
	givepoke OMANYTE, 10
	sjump .Revived

.Root:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem ROOT_FOSSIL
	givepoke LILEEP, 10
	sjump .Revived

.Claw:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem CLAW_FOSSIL
	givepoke ANORITH, 20
	sjump .Revived

.Armor:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem ARMOR_FOSSIL
	givepoke SHIELDON, 20
	sjump .Revived

.Sail:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem SAIL_FOSSIL
	givepoke AMAURA, 20
	sjump .Revived

.Skull:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem SKULL_FOSSIL
	givepoke CRANIDOS, 20
	sjump .Revived

.Cover:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem COVER_FOSSIL
	givepoke TIRTOUGA, 20
	sjump .Revived

.Jaw:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem JAW_FOSSIL
	givepoke TYRUNT, 20
	sjump .Revived

.Amber:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem OLD_AMBER
	givepoke AERODACTYL, 30
	sjump .Revived

.Plume:
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .NoRoom
	scall .RunMachine
	playsound SFX_CAUGHT_MON
	waitsfx
	takeitem PLUME_FOSSIL
	givepoke ARCHEN, 30
	sjump .Revived

.Revived:
	writetext RuinsOfAlphFossilLabRevivedText
	waitbutton
	closetext
	end

; Shared: walk to the resurrection machine, run it, come back. Returns with
; the text box open so givepoke can draw its nickname prompt over it.
.RunMachine:
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
	pause 15
	pause 15
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
	return

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

	para "Show me what you're"
	line "carrying and I'll"
	cont "restore it!"
	done

RuinsOfAlphFossilLabNoFossilText:
	text "Oh? You don't have"
	line "a fossil on you."

	para "Try the walls deep"
	line "inside the RUINS."
	done

RuinsOfAlphFossilLabDeclinedText:
	text "No? Come back any"
	line "time you like."
	done

RuinsOfAlphFossilLabPartyFullText:
	text "Hold on--your team"
	line "is full!"

	para "Make some room and"
	line "come see me again."
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

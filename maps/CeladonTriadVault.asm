; Behind the poster switch in the Celadon Game Corner. The Grand Masters
; play the strongest decks in the game (BEAST_TRIAD_TIER_GRAND_MASTER), and
; the room only ever plays the Grand Master duel theme. Art: tools/triad_club/rooms.py.

	object_const_def ; object_event constants
	const CELADONTRIADVAULT_DOORMAN
	const CELADONTRIADVAULT_DUELIST
	const CELADONTRIADVAULT_HEX_MANIAC
	const CELADONTRIADVAULT_MYSTICALMAN
	const CELADONTRIADVAULT_GRANNY

CeladonTriadVault_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

CeladonTriadVaultDoormanScript:
	jumptextfaceplayer CeladonTriadVaultDoormanText

CeladonTriadVaultDuelistScript:
	faceplayer
	opentext
	writetext CeladonTriadVaultDuelistText
	yesorno
	iffalse CeladonTriadVaultDeclined
	checkitem CARD_CASE
	iffalse CeladonTriadVaultNoCardCase
	scall CeladonTriadVaultMatch
	jumptext CeladonTriadVaultDuelistAfterText

CeladonTriadVaultHexManiacScript:
	faceplayer
	opentext
	writetext CeladonTriadVaultHexManiacText
	yesorno
	iffalse CeladonTriadVaultDeclined
	checkitem CARD_CASE
	iffalse CeladonTriadVaultNoCardCase
	scall CeladonTriadVaultMatch
	jumptext CeladonTriadVaultHexManiacAfterText

CeladonTriadVaultMysticalmanScript:
	faceplayer
	opentext
	writetext CeladonTriadVaultMysticalmanText
	yesorno
	iffalse CeladonTriadVaultDeclined
	checkitem CARD_CASE
	iffalse CeladonTriadVaultNoCardCase
	scall CeladonTriadVaultMatch
	jumptext CeladonTriadVaultMysticalmanAfterText

CeladonTriadVaultGrannyScript:
	faceplayer
	opentext
	writetext CeladonTriadVaultGrannyText
	yesorno
	iffalse CeladonTriadVaultDeclined
	checkitem CARD_CASE
	iffalse CeladonTriadVaultNoCardCase
	scall CeladonTriadVaultMatch
	jumptext CeladonTriadVaultGrannyAfterText

CeladonTriadVaultMatch:
	closetext
	refreshscreen
	setval BEAST_TRIAD_TIER_GRAND_MASTER
	special BeastTriadTiered
	closetext
	end

CeladonTriadVaultDeclined:
	writetext CeladonTriadVaultDeclinedText
	waitbutton
	closetext
	end

CeladonTriadVaultNoCardCase:
	writetext CeladonTriadVaultNoCardCaseText
	waitbutton
	closetext
	end

CeladonTriadVaultTrophyScript:
	jumptext CeladonTriadVaultTrophyText

CeladonTriadVaultPortraitScript:
	jumptext CeladonTriadVaultPortraitText

CeladonTriadVaultDoormanText:
	text "…So you found the"
	line "switch."

	para "Welcome to the"
	line "GRAND MASTER room."

	para "Only the finest"
	line "decks in the land"
	cont "are played here."

	para "Win, and you may"
	line "claim one of their"
	cont "cards."

	para "Lose, and they"
	line "will claim one of"
	cont "yours."
	done

CeladonTriadVaultDuelistText:
	text "Few find this"
	line "room. Fewer leave"
	cont "it with a win."

	para "I am a GRAND"
	line "MASTER. Shall we"
	cont "duel?"
	done

CeladonTriadVaultDuelistAfterText:
	text "Every card has a"
	line "weak edge. Find it"
	cont "before I do."
	done

CeladonTriadVaultHexManiacText:
	text "The cards whisper"
	line "to me…"

	para "They say you will"
	line "lose. Shall we see?"
	done

CeladonTriadVaultHexManiacAfterText:
	text "Fufu… The cards"
	line "are never wrong."
	cont "Only early."
	done

CeladonTriadVaultMysticalmanText:
	text "Legends sleep in"
	line "my deck."

	para "Do you dare wake"
	line "them?"
	done

CeladonTriadVaultMysticalmanAfterText:
	text "The beasts have"
	line "spoken. Return"
	cont "when you're ready."
	done

CeladonTriadVaultGrannyText:
	text "Heh heh. I've"
	line "played since long"

	para "before your folks"
	line "were born, dearie."

	para "One game?"
	done

CeladonTriadVaultGrannyAfterText:
	text "Not bad, not bad!"
	line "Come keep an old"
	cont "lady sharp."
	done

CeladonTriadVaultDeclinedText:
	text "Then watch, and"
	line "learn."
	done

CeladonTriadVaultNoCardCaseText:
	text "No CARD CASE?"

	para "The GOLDENROD GAME"
	line "CORNER hands them"
	cont "out to beginners."
	done

CeladonTriadVaultTrophyText:
	text "Gold cups from"
	line "decades of GRAND"
	cont "MASTER finals."
	done

CeladonTriadVaultPortraitText:
	text "Portraits of past"
	line "GRAND MASTERS."
	done

CeladonTriadVault_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  7, 11, CELADON_GAME_CORNER, 3
	warp_event  8, 11, CELADON_GAME_CORNER, 3

	db 0 ; coord events

	db 6 ; bg events
	bg_event  0,  2, BGEVENT_UP, CeladonTriadVaultTrophyScript
	bg_event  1,  2, BGEVENT_UP, CeladonTriadVaultTrophyScript
	bg_event 14,  2, BGEVENT_UP, CeladonTriadVaultTrophyScript
	bg_event 15,  2, BGEVENT_UP, CeladonTriadVaultTrophyScript
	bg_event  5,  1, BGEVENT_UP, CeladonTriadVaultPortraitScript
	bg_event 10,  1, BGEVENT_UP, CeladonTriadVaultPortraitScript

	db 5 ; object events
	object_event  9, 10, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonTriadVaultDoormanScript, -1
	object_event  5,  4, SPRITE_DUELIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonTriadVaultDuelistScript, -1
	object_event 10,  4, SPRITE_HEX_MANIAC, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, CeladonTriadVaultHexManiacScript, -1
	object_event  2,  6, SPRITE_MYSTICALMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonTriadVaultMysticalmanScript, -1
	object_event 13,  6, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonTriadVaultGrannyScript, -1

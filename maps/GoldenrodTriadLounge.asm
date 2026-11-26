; Through the always-open doorway at the back of the Goldenrod Game Corner.
; Friendly Beast Triad tables: standard decks on the left and at the small
; table, stronger (mid-tier) decks at the right-hand table. Art: tools/triad_club/rooms.py.

	object_const_def ; object_event constants
	const GOLDENRODTRIADLOUNGE_HOST
	const GOLDENRODTRIADLOUNGE_SUPER_NERD
	const GOLDENRODTRIADLOUNGE_LASS
	const GOLDENRODTRIADLOUNGE_YOUNGSTER
	const GOLDENRODTRIADLOUNGE_POKEFAN_M
	const GOLDENRODTRIADLOUNGE_COOLTRAINER_F

GoldenrodTriadLounge_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

GoldenrodTriadLoungeHostScript:
	jumptextfaceplayer GoldenrodTriadLoungeHostText

GoldenrodTriadLoungeSuperNerdScript:
	faceplayer
	opentext
	writetext GoldenrodTriadLoungeSuperNerdText
	yesorno
	iffalse GoldenrodTriadLoungeDeclined
	checkitem CARD_CASE
	iffalse GoldenrodTriadLoungeNoCardCase
	setval BEAST_TRIAD_TIER_STANDARD
	scall GoldenrodTriadLoungeMatch
	jumptext GoldenrodTriadLoungeSuperNerdAfterText

GoldenrodTriadLoungeLassScript:
	faceplayer
	opentext
	writetext GoldenrodTriadLoungeLassText
	yesorno
	iffalse GoldenrodTriadLoungeDeclined
	checkitem CARD_CASE
	iffalse GoldenrodTriadLoungeNoCardCase
	setval BEAST_TRIAD_TIER_STANDARD
	scall GoldenrodTriadLoungeMatch
	jumptext GoldenrodTriadLoungeLassAfterText

GoldenrodTriadLoungeYoungsterScript:
	faceplayer
	opentext
	writetext GoldenrodTriadLoungeYoungsterText
	yesorno
	iffalse GoldenrodTriadLoungeDeclined
	checkitem CARD_CASE
	iffalse GoldenrodTriadLoungeNoCardCase
	setval BEAST_TRIAD_TIER_STANDARD
	scall GoldenrodTriadLoungeMatch
	jumptext GoldenrodTriadLoungeYoungsterAfterText

GoldenrodTriadLoungePokefanMScript:
	faceplayer
	opentext
	writetext GoldenrodTriadLoungePokefanMText
	yesorno
	iffalse GoldenrodTriadLoungeDeclined
	checkitem CARD_CASE
	iffalse GoldenrodTriadLoungeNoCardCase
	setval BEAST_TRIAD_TIER_MID
	scall GoldenrodTriadLoungeMatch
	jumptext GoldenrodTriadLoungePokefanMAfterText

GoldenrodTriadLoungeCooltrainerFScript:
	faceplayer
	opentext
	writetext GoldenrodTriadLoungeCooltrainerFText
	yesorno
	iffalse GoldenrodTriadLoungeDeclined
	checkitem CARD_CASE
	iffalse GoldenrodTriadLoungeNoCardCase
	setval BEAST_TRIAD_TIER_MID
	scall GoldenrodTriadLoungeMatch
	jumptext GoldenrodTriadLoungeCooltrainerFAfterText

GoldenrodTriadLoungeMatch:
; wScriptVar: BEAST_TRIAD_TIER_*
	closetext
	refreshscreen
	special BeastTriadTiered
	closetext
	end

GoldenrodTriadLoungeDeclined:
	writetext GoldenrodTriadLoungeDeclinedText
	waitbutton
	closetext
	end

GoldenrodTriadLoungeNoCardCase:
	writetext GoldenrodTriadLoungeNoCardCaseText
	waitbutton
	closetext
	end

GoldenrodTriadLoungePosterScript:
	jumptext GoldenrodTriadLoungePosterText

GoldenrodTriadLoungeBindersScript:
	jumptext GoldenrodTriadLoungeBindersText

GoldenrodTriadLoungeBoosterRackScript:
	jumptext GoldenrodTriadLoungeBoosterRackText

GoldenrodTriadLoungeHostText:
	text "Welcome to the"
	line "TRIAD LOUNGE!"

	para "Pull up a chair."
	line "Everyone here"
	cont "plays BEAST TRIAD."

	para "The left tables"
	line "are friendly."

	para "The right table"
	line "plays tougher"
	cont "decks."

	para "And they say the"
	line "true GRAND MASTERS"

	para "play behind a"
	line "poster in CELADON…"
	done

GoldenrodTriadLoungeSuperNerdText:
	text "I've memorized the"
	line "ranks of every"
	cont "single card."

	para "Doesn't mean I win."
	line "Play a round?"
	done

GoldenrodTriadLoungeSuperNerdAfterText:
	text "Hmm… I should have"
	line "led with my left"
	cont "corner card."
	done

GoldenrodTriadLoungeLassText:
	text "This lounge is my"
	line "favorite place in"
	cont "GOLDENROD."

	para "Quiet, cozy and"
	line "full of cards!"

	para "Want to play?"
	done

GoldenrodTriadLoungeLassAfterText:
	text "That was fun!"
	line "Come back soon!"
	done

GoldenrodTriadLoungeYoungsterText:
	text "I just pulled a"
	line "shiny new card!"

	para "Let me try it out"
	line "on you. Deal?"
	done

GoldenrodTriadLoungeYoungsterAfterText:
	text "I need more packs."
	line "Way more packs."
	done

GoldenrodTriadLoungePokefanMText:
	text "My deck's been"
	line "tuned over many"
	cont "long nights here."

	para "Think you can keep"
	line "up?"
	done

GoldenrodTriadLoungePokefanMAfterText:
	text "Not bad. You've"
	line "got the makings of"
	cont "a real player."
	done

GoldenrodTriadLoungeCooltrainerFText:
	text "Type matchups"
	line "matter at this"
	cont "table."

	para "Ready to test your"
	line "deck?"
	done

GoldenrodTriadLoungeCooltrainerFAfterText:
	text "Keep that edge."
	line "You'll need it in"
	cont "CELADON."
	done

GoldenrodTriadLoungeDeclinedText:
	text "No? The seat will"
	line "be here when you"
	cont "change your mind."
	done

GoldenrodTriadLoungeNoCardCaseText:
	text "You'll need a CARD"
	line "CASE first."

	para "The card table out"
	line "in the GAME CORNER"
	cont "hands them out."
	done

GoldenrodTriadLoungePosterText:
	text "A framed pair of"
	line "first-print cards."

	para "BEAST TRIAD: open"
	line "tables nightly!"
	done

GoldenrodTriadLoungeBindersText:
	text "Binders full of"
	line "traded cards."

	para "Some pages are"
	line "worn soft."
	done

GoldenrodTriadLoungeBoosterRackText:
	text "Booster boxes,"
	line "sealed tight."

	para "Someone has"
	line "written SOLD OUT"
	cont "on the shelf."
	done

GoldenrodTriadLounge_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  7, 11, GOLDENROD_GAME_CORNER, 3
	warp_event  8, 11, GOLDENROD_GAME_CORNER, 3

	db 0 ; coord events

	db 6 ; bg events
	bg_event  0,  2, BGEVENT_UP, GoldenrodTriadLoungeBindersScript
	bg_event  1,  2, BGEVENT_UP, GoldenrodTriadLoungeBindersScript
	bg_event 14,  2, BGEVENT_UP, GoldenrodTriadLoungeBoosterRackScript
	bg_event 15,  2, BGEVENT_UP, GoldenrodTriadLoungeBoosterRackScript
	bg_event  3,  1, BGEVENT_UP, GoldenrodTriadLoungePosterScript
	bg_event 12,  1, BGEVENT_UP, GoldenrodTriadLoungePosterScript

	db 6 ; object events
	object_event 10, 10, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungeHostScript, -1
	object_event  2,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungeSuperNerdScript, -1
	object_event  4,  6, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungeLassScript, -1
	object_event  6,  8, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungeYoungsterScript, -1
	object_event 13,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungePokefanMScript, -1
	object_event 11,  6, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodTriadLoungeCooltrainerFScript, -1

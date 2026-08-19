	object_const_def ; object_event constants
	const ROUTE20_SWIMMER_GIRL1
	const ROUTE20_SWIMMER_GIRL2
	const ROUTE20_SWIMMER_GUY
	const ROUTE20_GREEN

Route20_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .ClearRocks

.ClearRocks:
	setevent EVENT_CINNABAR_ROCKS_CLEARED
	return

TrainerSwimmerfNicole:
	trainer SWIMMERF, NICOLE, EVENT_BEAT_SWIMMERF_NICOLE, SwimmerfNicoleSeenText, SwimmerfNicoleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfNicoleAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerfLori:
	trainer SWIMMERF, LORI, EVENT_BEAT_SWIMMERF_LORI, SwimmerfLoriSeenText, SwimmerfLoriBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfLoriAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermCameron:
	trainer SWIMMERM, CAMERON, EVENT_BEAT_SWIMMERM_CAMERON, SwimmermCameronSeenText, SwimmermCameronBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermCameronAfterBattleText
	waitbutton
	closetext
	end

Route20GreenScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_GREEN
	iftrue .Beaten
	writetext Route20GreenBeforeText
	waitbutton
	closetext
	winlosstext Route20GreenBeatenText, 0
	loadtrainer GREEN, GREEN1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_GREEN
	clearevent EVENT_BLUE_CLOAK_IN_CINNABAR
	opentext
	writetext Route20GreenAfterText
	waitbutton
	closetext
	end

.Beaten:
	writetext Route20GreenAfterText
	waitbutton
	closetext
	end

CinnabarGymSign:
	jumptext CinnabarGymSignText

SwimmerfNicoleSeenText:
	text "I feel so much"
	line "lighter in water."
	done

SwimmerfNicoleBeatenText:
	text "Oh, no!"
	done

SwimmerfNicoleAfterBattleText:
	text "Swimming exercises"
	line "your full body."

	para "It's really good"
	line "for you."
	done

SwimmerfLoriSeenText:
	text "What an impressive"
	line "collection of GYM"

	para "BADGES. We should"
	line "battle!"
	done

SwimmerfLoriBeatenText:
	text "No!"
	done

SwimmerfLoriAfterBattleText:
	text "SURF is no longer"
	line "the only HM move"
	cont "you use in water."
	done

SwimmermCameronSeenText:
	text "I guess it's im-"
	line "possible to swim"

	para "all the way to"
	line "JOHTO."
	done

SwimmermCameronBeatenText:
	text "Aiyah!"
	done

SwimmermCameronAfterBattleText:
	text "Besides the sea, I"
	line "can also swim in"
	cont "ponds and rivers."
	done

Route20GreenBeforeText:
	text "GREEN: There you"
	line "are!"

	para "I've been hearing"
	line "about you all"
	cont "over KANTO."

	para "Then you went and"
	line "beat RED."

	para "That REALLY got"
	line "my attention."

	para "I know what it"
	line "takes to stand"
	cont "against him."

	para "So I wanted to"
	line "meet you myself,"

	para "and see what all"
	line "the fuss was"
	cont "about."

	para "Let's see how"
	line "good you really"
	cont "are."
	done

Route20GreenBeatenText:
	text "GREEN: Hehehe…"
	line "Now I understand."
	done

Route20GreenAfterText:
	text "GREEN: You're"
	line "good. REALLY"
	cont "good."

	para "RED doesn't lose"
	line "very often."

	para "Now I know why"
	line "he lost to you."

	para "But there's some-"
	line "one else who"
	cont "won't like"
	cont "hearing that."

	para "BLUE's been"
	line "waiting for"
	cont "another battle"
	cont "with you."

	para "I'd go find him."
	line "He hates waiting."

	para "Last I heard, he"
	line "was hanging"
	cont "around CINNABAR."

	para "It was great"
	line "meeting you!"

	para "Thanks for a"
	line "great battle!"
	done

CinnabarGymSignText:
	text "What does this"
	line "sign say?"

	para "CINNABAR GYM"
	line "LEADER: BLAINE"
	done

Route20_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 38,  7, SEAFOAM_GYM, 1

	db 0 ; coord events

	db 1 ; bg events
	bg_event 37, 11, BGEVENT_READ, CinnabarGymSign

	db 4 ; object events
	object_event 52,  8, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerSwimmerfNicole, -1
	object_event 45, 13, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerSwimmerfLori, -1
	object_event 12, 13, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermCameron, -1
	object_event 34,  2, SPRITE_GREEN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route20GreenScript, EVENT_GREEN_IN_ROUTE20

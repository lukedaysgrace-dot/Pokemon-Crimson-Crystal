	object_const_def ; object_event constants
	const ROUTE18_YOUNGSTER1
	const ROUTE18_YOUNGSTER2
	const ROUTE18_TAMER1
	const ROUTE18_TAMER2
	const ROUTE18_TAMER3

Route18_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TrainerBirdKeeperBoris:
	trainer BIRD_KEEPER, BORIS, EVENT_BEAT_BIRD_KEEPER_BORIS, BirdKeeperBorisSeenText, BirdKeeperBorisBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperBorisAfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeperBob:
	trainer BIRD_KEEPER, BOB, EVENT_BEAT_BIRD_KEEPER_BOB, BirdKeeperBobSeenText, BirdKeeperBobBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperBobAfterBattleText
	waitbutton
	closetext
	end

TrainerTamerCole:
	trainer TAMER, TAMER1, EVENT_BEAT_TAMER_COLE, TamerColeSeenText, TamerColeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext TamerColeAfterBattleText
	waitbutton
	closetext
	end

TrainerTamerJax:
	trainer TAMER, TAMER2, EVENT_BEAT_TAMER_JAX, TamerJaxSeenText, TamerJaxBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext TamerJaxAfterBattleText
	waitbutton
	closetext
	end

TrainerTamerRigby:
	trainer TAMER, TAMER3, EVENT_BEAT_TAMER_RIGBY, TamerRigbySeenText, TamerRigbyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext TamerRigbyAfterBattleText
	waitbutton
	closetext
	end

Route18Sign:
	jumptext Route18SignText

BirdKeeperBorisSeenText:
	text "If you're looking"
	line "for #MON, you"

	para "have to look in"
	line "the tall grass."
	done

BirdKeeperBorisBeatenText:
	text "Ayieee!"
	done

BirdKeeperBorisAfterBattleText:
	text "Since you're so"
	line "strong, it must be"
	cont "fun to battle."
	done

BirdKeeperBobSeenText:
	text "CYCLING ROAD is a"
	line "quick shortcut to"
	cont "CELADON."
	done

BirdKeeperBobBeatenText:
	text "…Whew!"
	done

BirdKeeperBobAfterBattleText:
	text "If you don't have"
	line "a BICYCLE, you're"

	para "not allowed to use"
	line "the shortcut."
	done

TamerColeSeenText:
	text "My #MON don't"
	line "take orders. They"
	cont "take dares."
	done

TamerColeBeatenText:
	text "Down, boy! Down!"
	done

TamerColeAfterBattleText:
	text "A beast worth"
	line "taming is a beast"

	para "that would sooner"
	line "tame you."
	done

TamerJaxSeenText:
	text "You don't raise a"
	line "TAUROS. You just"
	cont "hold on."
	done

TamerJaxBeatenText:
	text "Threw me off…"
	done

TamerJaxAfterBattleText:
	text "The wild ones hit"
	line "hardest. That's"
	cont "the whole point."
	done

TamerRigbySeenText:
	text "CYCLING ROAD's a"
	line "fine place to run"

	para "something big and"
	line "mean."
	done

TamerRigbyBeatenText:
	text "Whoa! Easy!"
	done

TamerRigbyAfterBattleText:
	text "You've got a grip"
	line "on your #MON."

	para "That's more than"
	line "most can say."
	done

Route18SignText:
	text "ROUTE 18"

	para "CELADON CITY -"
	line "FUCHSIA CITY"
	done

Route18_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  2,  6, ROUTE_17_ROUTE_18_GATE, 3
	warp_event  2,  7, ROUTE_17_ROUTE_18_GATE, 4

	db 0 ; coord events

	db 1 ; bg events
	bg_event  9,  5, BGEVENT_READ, Route18Sign

	db 5 ; object events
	object_event  7, 11, SPRITE_BIRD_KEEPER_NEW, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperBoris, -1
	object_event 13,  6, SPRITE_BIRD_KEEPER_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperBob, -1
; Coordinates below are estimates - nudge in a map editor if any land on collision.
	object_event  4,  6, SPRITE_TAMER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerTamerCole, -1
	object_event 11,  9, SPRITE_TAMER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerTamerJax, -1
	object_event  8,  7, SPRITE_TAMER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerTamerRigby, -1

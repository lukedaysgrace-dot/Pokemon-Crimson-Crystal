	object_const_def ; object_event constants
	const ROUTE7_BATTLE_GIRL1
	const ROUTE7_BATTLE_GIRL2

Route7_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TrainerBattleGirlMiho:
	trainer BATTLE_GIRL, BATTLE_GIRL1, EVENT_BEAT_BATTLE_GIRL_MIHO, BattleGirlMihoSeenText, BattleGirlMihoBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BattleGirlMihoAfterBattleText
	waitbutton
	closetext
	end

TrainerBattleGirlAya:
	trainer BATTLE_GIRL, BATTLE_GIRL2, EVENT_BEAT_BATTLE_GIRL_AYA, BattleGirlAyaSeenText, BattleGirlAyaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BattleGirlAyaAfterBattleText
	waitbutton
	closetext
	end

Route7UndergroundPathSign:
	jumptext Route7UndergroundPathSignText

Route7LockedDoor:
	jumptext Route7LockedDoorText

Route7UndergroundPathSignText:
	text "What's this flyer?"

	para "… Uncouth trainers"
	line "have been holding"

	para "battles in the"
	line "UNDERGROUND PATH."

	para "Because of rising"
	line "complaints by lo-"
	cont "cal residents, the"
	cont "UNDERGROUND PATH"
	cont "has been sealed"
	cont "indefinitely."

	para "CELADON POLICE"
	done

Route7LockedDoorText:
	text "It's locked…"
	done

BattleGirlMihoSeenText:
	text "The DOJO in"
	line "SAFFRON is shut"

	para "while the master's"
	line "away training."

	para "So we train out"
	line "here instead."
	done

BattleGirlMihoBeatenText:
	text "You hit harder"
	line "than you look!"
	done

BattleGirlMihoAfterBattleText:
	text "A closed door is"
	line "no excuse to stop"
	cont "training."
	done

BattleGirlAyaSeenText:
	text "No BADGES needed"
	line "out here. Just"
	cont "stand and fight!"
	done

BattleGirlAyaBeatenText:
	text "I lost… but my"
	line "form was good."
	done

BattleGirlAyaAfterBattleText:
	text "MIHO and I will be"
	line "here every day."

	para "Come back when you"
	line "want a rematch."
	done

Route7_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 15,  6, ROUTE_7_SAFFRON_GATE, 1
	warp_event 15,  7, ROUTE_7_SAFFRON_GATE, 2

	db 0 ; coord events

	db 2 ; bg events
	bg_event  5, 11, BGEVENT_READ, Route7UndergroundPathSign
	bg_event  6,  9, BGEVENT_READ, Route7LockedDoor

	db 2 ; object events
; Coordinates below are estimates - nudge in a map editor if either lands on collision.
	object_event 11,  6, SPRITE_BATTLE_GIRL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBattleGirlMiho, -1
	object_event  9,  0, SPRITE_BATTLE_GIRL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBattleGirlAya, -1

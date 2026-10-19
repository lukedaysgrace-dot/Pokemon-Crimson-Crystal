	object_const_def ; object_event constants
	const VIRIDIANFOREST_BUG_CATCHER_ROB
	const VIRIDIANFOREST_BUG_CATCHER_ED
	const VIRIDIANFOREST_BUG_CATCHER_DOUG
	const VIRIDIANFOREST_POKE_BALL1
	const VIRIDIANFOREST_POKE_BALL2
	const VIRIDIANFOREST_POKE_BALL3
	const VIRIDIANFOREST_YOUNGSTER1
	const VIRIDIANFOREST_YOUNGSTER2

ViridianForest_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TrainerBugCatcherRob:
	trainer BUG_CATCHER, ROB, EVENT_BEAT_BUG_CATCHER_ROB, BugCatcherRobSeenText, BugCatcherRobBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherRobAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherEd:
	trainer BUG_CATCHER, ED, EVENT_BEAT_BUG_CATCHER_ED, BugCatcherEdSeenText, BugCatcherEdBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherEdAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherDoug:
	trainer BUG_CATCHER, DOUG, EVENT_BEAT_BUG_CATCHER_DOUG, BugCatcherDougSeenText, BugCatcherDougBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherDougAfterBattleText
	waitbutton
	closetext
	end

ViridianForestYoungster1Script:
	jumptextfaceplayer ViridianForestYoungster1Text

ViridianForestYoungster2Script:
	jumptextfaceplayer ViridianForestYoungster2Text

ViridianForestTrainerTips1Sign:
	jumptext ViridianForestTrainerTips1Text

ViridianForestUseAntidoteSign:
	jumptext ViridianForestUseAntidoteSignText

ViridianForestTrainerTips2Sign:
	jumptext ViridianForestTrainerTips2Text

ViridianForestTrainerTips3Sign:
	jumptext ViridianForestTrainerTips3Text

ViridianForestTrainerTips4Sign:
	jumptext ViridianForestTrainerTips4Text

ViridianForestLeavingSign:
	jumptext ViridianForestLeavingSignText

ViridianForestAntidote:
	itemball ANTIDOTE

ViridianForestPotion:
	itemball POTION

ViridianForestPokeBall:
	itemball POKE_BALL

ViridianForestHiddenAntidote:
	hiddenitem ANTIDOTE, EVENT_VIRIDIAN_FOREST_HIDDEN_ANTIDOTE

ViridianForestHiddenPotion:
	hiddenitem POTION, EVENT_VIRIDIAN_FOREST_HIDDEN_POTION

BugCatcherRobSeenText:
	text "Hey! Those #MON"
	line "look ready to go!"
	cont "Let's battle 'em!"
	done

BugCatcherRobBeatenText:
	text "My bugs got"
	line "squashed!"
	done

BugCatcherRobAfterBattleText:
	text "Shh! Keep it down!"
	line "You'll scare off"
	cont "the bugs!"

	para "I just saw a big"
	line "one over there!"
	done

BugCatcherEdSeenText:
	text "Trying to slip by?"
	line "Not while I'm"
	cont "looking!"
	done

BugCatcherEdBeatenText:
	text "What? That's my"
	line "last #MON!"
	done

BugCatcherEdAfterBattleText:
	text "I was so busy"
	line "catching #MON,"
	cont "I forgot to train"
	cont "them!"

	para "I'll get you next"
	line "time!"
	done

BugCatcherDougSeenText:
	text "Hey! Slow down!"
	line "Got time for one"
	cont "more battle?"
	done

BugCatcherDougBeatenText:
	text "All right, all"
	line "right! You win!"
	done

BugCatcherDougAfterBattleText:
	text "I dropped a POTION"
	line "somewhere in here."

	para "If you find it,"
	line "let's call it your"
	cont "prize for winning!"
	done

ViridianForestYoungster1Text:
	text "My friends came"
	line "to catch #MON."

	para "Now they just want"
	line "to battle anyone"
	cont "who walks past!"
	done

ViridianForestYoungster2Text:
	text "I used my last"
	line "# BALL on a"
	cont "WEEDLE!"

	para "Then a PIKACHU"
	line "showed up..."
	cont "Bring extras!"
	done

ViridianForestTrainerTips1Text:
	text "TRAINER TIPS"

	para "If you want to"
	line "avoid battles,"
	cont "stay away from"
	cont "grassy areas!"
	done

ViridianForestUseAntidoteSignText:
	text "For poison, use"
	line "ANTIDOTE! Get it"
	cont "at #MON MARTs!"
	done

ViridianForestTrainerTips2Text:
	text "TRAINER TIPS"

	para "Contact PROF.OAK"
	line "via PC to get"
	cont "your #DEX"
	cont "evaluated!"
	done

ViridianForestTrainerTips3Text:
	text "TRAINER TIPS"

	para "No stealing of"
	line "#MON from"
	cont "other trainers!"
	cont "Catch only wild"
	cont "#MON!"
	done

ViridianForestTrainerTips4Text:
	text "TRAINER TIPS"

	para "Weaken #MON"
	line "before attempting"
	cont "capture!"

	para "When healthy,"
	line "they may escape!"
	done

ViridianForestLeavingSignText:
	text "LEAVING"
	line "VIRIDIAN FOREST"
	cont "PEWTER CITY AHEAD"
	done

ViridianForest_MapEvents:
	db 0, 0 ; filler

	db 6 ; warp events
	warp_event  1,  0, VIRIDIAN_FOREST_NORTH_GATE, 3
	warp_event  2,  0, VIRIDIAN_FOREST_NORTH_GATE, 4
	warp_event 15, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2
	warp_event 16, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2
	warp_event 17, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2
	warp_event 18, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2

	db 0 ; coord events

	db 8 ; bg events
	bg_event 24, 40, BGEVENT_READ, ViridianForestTrainerTips1Sign
	bg_event 16, 32, BGEVENT_READ, ViridianForestUseAntidoteSign
	bg_event 26, 17, BGEVENT_READ, ViridianForestTrainerTips2Sign
	bg_event  4, 24, BGEVENT_READ, ViridianForestTrainerTips3Sign
	bg_event 18, 44, BGEVENT_READ, ViridianForestTrainerTips4Sign
	bg_event  2,  1, BGEVENT_READ, ViridianForestLeavingSign
	bg_event  1, 18, BGEVENT_ITEM, ViridianForestHiddenAntidote
	bg_event 16, 42, BGEVENT_ITEM, ViridianForestHiddenPotion

	db 8 ; object events
	object_event 30, 33, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 5, TrainerBugCatcherRob, -1
	object_event 30, 19, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherEd, -1
	object_event  2, 18, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherDoug, -1
	object_event 25,  8, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestAntidote, EVENT_VIRIDIAN_FOREST_ANTIDOTE
	object_event 12, 29, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestPotion, EVENT_VIRIDIAN_FOREST_POTION
	object_event  1, 31, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestPokeBall, EVENT_VIRIDIAN_FOREST_POKE_BALL
	object_event 14, 43, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ViridianForestYoungster1Script, -1
	object_event 29, 41, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ViridianForestYoungster2Script, -1

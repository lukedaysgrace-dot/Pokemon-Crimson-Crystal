	object_const_def ; object_event constants
	const VICTORYROAD_SILVER
	const VICTORYROAD_POKE_BALL1
	const VICTORYROAD_POKE_BALL2
	const VICTORYROAD_POKE_BALL3
	const VICTORYROAD_POKE_BALL4
	const VICTORYROAD_POKE_BALL5
	const VICTORYROAD_TAMER_DEVIN
	const VICTORYROAD_TAMER_ROLF
	const VICTORYROAD_BATTLE_GIRL_KIRA
	const VICTORYROAD_BATTLE_GIRL_MINA
	const VICTORYROAD_COOLTRAINER_M_ADRIAN
	const VICTORYROAD_COOLTRAINER_F_SELENE

VictoryRoad_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene0 ; SCENE_DEFAULT
	scene_script .DummyScene1 ; SCENE_FINISHED

	db 0 ; callbacks

.DummyScene0:
	end

.DummyScene1:
	end

VictoryRoadRivalLeft:
	moveobject VICTORYROAD_SILVER, 18, 11
	turnobject PLAYER, DOWN
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15
	appear VICTORYROAD_SILVER
	applymovement VICTORYROAD_SILVER, MovementData_0x74539
	scall VictoryRoadRivalNext
	applymovement VICTORYROAD_SILVER, MovementData_0x7454c
	disappear VICTORYROAD_SILVER
	setscene SCENE_FINISHED
	playmapmusic
	end

VictoryRoadRivalRight:
	turnobject PLAYER, DOWN
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15
	appear VICTORYROAD_SILVER
	applymovement VICTORYROAD_SILVER, MovementData_0x74542
	scall VictoryRoadRivalNext
	applymovement VICTORYROAD_SILVER, MovementData_0x74555
	disappear VICTORYROAD_SILVER
	setscene SCENE_FINISHED
	playmapmusic
	end

VictoryRoadRivalNext:
	turnobject PLAYER, DOWN
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext VictoryRoadRivalBeforeText
	waitbutton
	closetext
	setevent EVENT_RIVAL_VICTORY_ROAD
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .GotTotodile
	checkevent EVENT_GOT_SQUIRTLE_FROM_ELM
	iftrue .GotTotodile
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .GotChikorita
	checkevent EVENT_GOT_BULBASAUR_FROM_ELM
	iftrue .GotChikorita
	winlosstext VictoryRoadRivalDefeatText, VictoryRoadRivalVictoryText
	setlasttalked VICTORYROAD_SILVER
	loadtrainer RIVAL1, RIVAL1_5_TOTODILE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .AfterBattle

.GotTotodile:
	winlosstext VictoryRoadRivalDefeatText, VictoryRoadRivalVictoryText
	setlasttalked VICTORYROAD_SILVER
	loadtrainer RIVAL1, RIVAL1_5_CHIKORITA
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .AfterBattle

.GotChikorita:
	winlosstext VictoryRoadRivalDefeatText, VictoryRoadRivalVictoryText
	setlasttalked VICTORYROAD_SILVER
	loadtrainer RIVAL1, RIVAL1_5_CYNDAQUIL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .AfterBattle

.AfterBattle:
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext VictoryRoadRivalAfterText
	waitbutton
	closetext
	end

TrainerTamerDevin:
	trainer TAMER, DEVIN, EVENT_BEAT_TAMER_DEVIN, TamerDevinSeenText, TamerDevinBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer TamerDevinAfterBattleText

TrainerTamerRolf:
	trainer TAMER, ROLF, EVENT_BEAT_TAMER_ROLF, TamerRolfSeenText, TamerRolfBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer TamerRolfAfterBattleText

TrainerBattleGirlKira:
	trainer BATTLE_GIRL, KIRA, EVENT_BEAT_BATTLE_GIRL_KIRA, BattleGirlKiraSeenText, BattleGirlKiraBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer BattleGirlKiraAfterBattleText

TrainerBattleGirlMina:
	trainer BATTLE_GIRL, MINA, EVENT_BEAT_BATTLE_GIRL_MINA, BattleGirlMinaSeenText, BattleGirlMinaBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer BattleGirlMinaAfterBattleText

TrainerCooltrainerMAdrian:
	trainer COOLTRAINERM, ADRIAN, EVENT_BEAT_COOLTRAINERM_ADRIAN, CooltrainerMAdrianSeenText, CooltrainerMAdrianBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer CooltrainerMAdrianAfterBattleText

TrainerCooltrainerFSelene:
	trainer COOLTRAINERF, SELENE, EVENT_BEAT_COOLTRAINERF_SELENE, CooltrainerFSeleneSeenText, CooltrainerFSeleneBeatenText, 0, .Script

.Script:
	endifjustbattled
	jumptextfaceplayer CooltrainerFSeleneAfterBattleText

VictoryRoadTMEarthquake:
	itemball TM_EARTHQUAKE

VictoryRoadMaxRevive:
	itemball MAX_REVIVE

VictoryRoadFullRestore:
	itemball FULL_RESTORE

VictoryRoadFullHeal:
	itemball FULL_HEAL

VictoryRoadHPUp:
	itemball HP_UP

VictoryRoadHiddenMaxPotion:
	hiddenitem MAX_POTION, EVENT_VICTORY_ROAD_HIDDEN_MAX_POTION

VictoryRoadHiddenFullHeal:
	hiddenitem FULL_HEAL, EVENT_VICTORY_ROAD_HIDDEN_FULL_HEAL

MovementData_0x74539:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step UP
	step UP
	step_end

MovementData_0x74542:
	step UP
	step UP
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step UP
	step UP
	step_end

MovementData_0x7454c:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

MovementData_0x74555:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step_end

TamerDevinSeenText:
	text "I've raised fierce"
	line "#MON to face"
	cont "any danger!"
	done

TamerDevinBeatenText:
	text "They respect your"
	line "strength!"
	done

TamerDevinAfterBattleText:
	text "A strong #MON"
	line "needs trust too."
	cont "as discipline."
	done

TamerRolfSeenText:
	text "Ancient beasts are"
	line "the true rulers of"
	cont "these caves!"
	done

TamerRolfBeatenText:
	text "Even giants can"
	line "be brought down!"
	done

TamerRolfAfterBattleText:
	text "Power means little"
	line "without control."
	done

BattleGirlKiraSeenText:
	text "Every step through"
	line "this cave honed"
	cont "my technique!"
	done

BattleGirlKiraBeatenText:
	text "You broke through"
	line "my guard!"
	done

BattleGirlKiraAfterBattleText:
	text "Training never"
	line "ends. The LEAGUE"
	cont "is only the start!"
	done

BattleGirlMinaSeenText:
	text "No shortcuts!"

	para "Fight with spirit!"
	done

BattleGirlMinaBeatenText:
	text "Your form is"
	line "incredible!"
	done

BattleGirlMinaAfterBattleText:
	text "A clear mind makes"
	line "each strike count."
	done

CooltrainerMAdrianSeenText:
	text "My team has an"
	line "answer for every"
	cont "challenge!"
	done

CooltrainerMAdrianBeatenText:
	text "I couldn't find"
	line "your weak point!"
	done

CooltrainerMAdrianAfterBattleText:
	text "Coverage matters,"
	line "but so does trust."
	done

CooltrainerFSeleneSeenText:
	text "The LEAGUE tests"
	line "more than power."
	done

CooltrainerFSeleneBeatenText:
	text "You've passed!"
	done

CooltrainerFSeleneAfterBattleText:
	text "Keep that focus."
	line "The exit is near."
	done

VictoryRoadRivalBeforeText:
	text "Hold it."

	para "…Are you going to"
	line "take the #MON"
	cont "LEAGUE challenge?"

	para "…Don't make me"
	line "laugh."

	para "You're so much"
	line "weaker than I am."

	para "I'm not like I was"
	line "before."

	para "I now have the"
	line "best and strongest"

	para "#MON with me."
	line "I'm invincible!"

	para "<PLAYER>!"
	line "I challenge you!"
	done

VictoryRoadRivalDefeatText:
	text "…I couldn't win…"

	para "I gave it every-"
	line "thing I had…"

	para "What you possess,"
	line "and what I lack…"

	para "I'm beginning to"
	line "understand what"

	para "that dragon master"
	line "said to me…"
	done

VictoryRoadRivalAfterText:
	text "…I haven't given up"
	line "on becoming the"
	cont "greatest trainer…"

	para "I'm going to find"
	line "out why I can't"

	para "win and become"
	line "stronger…"

	para "When I do, I will"
	line "challenge you."

	para "And I'll beat you"
	line "down with all my"
	cont "power."

	para "…Humph! You keep"
	line "at it until then."
	done

VictoryRoadRivalVictoryText:
	text "…Humph!"

	para "When it comes down"
	line "to it, nothing can"
	cont "beat power."

	para "I don't need any-"
	line "thing else."
	done

VictoryRoad_MapEvents:
	db 0, 0 ; filler

	db 10 ; warp events
	warp_event  9, 67, VICTORY_ROAD_GATE, 5
	warp_event  1, 49, VICTORY_ROAD, 3
	warp_event  1, 35, VICTORY_ROAD, 2
	warp_event 13, 31, VICTORY_ROAD, 5
	warp_event 13, 17, VICTORY_ROAD, 4
	warp_event 17, 33, VICTORY_ROAD, 7
	warp_event 17, 19, VICTORY_ROAD, 6
	warp_event  0, 11, VICTORY_ROAD, 9
	warp_event  0, 27, VICTORY_ROAD, 8
	warp_event 13,  5, ROUTE_23, 3

	db 2 ; coord events
	coord_event 12,  8, SCENE_DEFAULT, VictoryRoadRivalLeft
	coord_event 13,  8, SCENE_DEFAULT, VictoryRoadRivalRight

	db 2 ; bg events
	bg_event  3, 29, BGEVENT_ITEM, VictoryRoadHiddenMaxPotion
	bg_event  3, 65, BGEVENT_ITEM, VictoryRoadHiddenFullHeal

	db 12 ; object events
	object_event 18, 13, SPRITE_SILVER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_RIVAL_VICTORY_ROAD
	object_event  3, 28, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoadTMEarthquake, EVENT_VICTORY_ROAD_TM_EARTHQUAKE
	object_event 12, 48, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoadMaxRevive, EVENT_VICTORY_ROAD_MAX_REVIVE
	object_event 18, 29, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoadFullRestore, EVENT_VICTORY_ROAD_FULL_RESTORE
	object_event 15, 48, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoadFullHeal, EVENT_VICTORY_ROAD_FULL_HEAL
	object_event  7, 38, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoadHPUp, EVENT_VICTORY_ROAD_HP_UP
	object_event  9, 60, SPRITE_TAMER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerTamerDevin, -1
	object_event  2, 48, SPRITE_TAMER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 5, TrainerTamerRolf, -1
	object_event 14, 34, SPRITE_BATTLE_GIRL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBattleGirlKira, -1
	object_event 16, 42, SPRITE_BATTLE_GIRL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBattleGirlMina, -1
	object_event 12, 12, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerCooltrainerMAdrian, -1
	object_event  4, 14, SPRITE_COOLTRAINER_F_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerCooltrainerFSelene, -1

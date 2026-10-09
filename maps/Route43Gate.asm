ROUTE43GATE_TOLL EQU 1000

	object_const_def ; object_event constants
	const ROUTE43GATE_OFFICER
	const ROUTE43GATE_ROCKET1
	const ROUTE43GATE_ROCKET2

Route43Gate_MapScripts:
	db 2 ; scene scripts
	scene_script .RocketShakedown ; SCENE_DEFAULT
	scene_script .DummyScene ; SCENE_FINISHED

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .CheckIfRockets

.RocketShakedown:
	prioritysjump .RocketTakeover
	end

.DummyScene:
	end

.CheckIfRockets:
	checkevent EVENT_ROUTE_43_GATE_ROCKETS
	iftrue .NoRockets
	checkevent EVENT_CLEARED_ROCKET_HIDEOUT
	iftrue .NoRockets
	setscene SCENE_DEFAULT
	return

.NoRockets:
	setscene SCENE_FINISHED
	return

.RocketTakeover:
	playmusic MUSIC_ROCKET_ENCOUNTER
	readvar VAR_FACING
	ifequal DOWN, RocketScript_Southbound
	ifequal UP, RocketScript_Northbound
	setscene SCENE_FINISHED
	end

RocketScript_Southbound:
	applymovement PLAYER, PlayerStepsIn
	showemote EMOTE_SHOCK, ROUTE43GATE_ROCKET2, 15
	applymovement ROUTE43GATE_ROCKET2, Rocket2Script_BlocksYouSouth
	turnobject ROUTE43GATE_ROCKET1, UP
	showemote EMOTE_SHOCK, ROUTE43GATE_ROCKET1, 15
	applymovement ROUTE43GATE_ROCKET1, Rocket1Script_BlocksYouSouth
	opentext
	writetext RocketText_TollFee
	yesorno
	iffalse RocketScript_RefuseToll
	checkmoney YOUR_MONEY, ROUTE43GATE_TOLL - 1
	ifequal HAVE_MORE, RocketScript_TollSouth
	sjump RocketScript_YoureBrokeSouth

RocketScript_TollSouth:
	takemoney YOUR_MONEY, ROUTE43GATE_TOLL
	writetext RocketText_ThankYou
	sjump RocketScript_ShakeDownSouth

RocketScript_YoureBrokeSouth:
	takemoney YOUR_MONEY, ROUTE43GATE_TOLL
	writetext RocketText_AllYouGot
	sjump RocketScript_ShakeDownSouth

RocketScript_ShakeDownSouth:
	buttonsound
	closetext
	applymovement ROUTE43GATE_ROCKET1, Rocket1Script_LetsYouPassSouth
	applymovement ROUTE43GATE_ROCKET2, Rocket2Script_LetsYouPassSouth
	setscene SCENE_FINISHED
	special RestartMapMusic
	end

RocketScript_Northbound:
	showemote EMOTE_SHOCK, ROUTE43GATE_ROCKET1, 15
	applymovement ROUTE43GATE_ROCKET1, Rocket1Script_BlocksYouNorth
	turnobject ROUTE43GATE_ROCKET2, DOWN
	showemote EMOTE_SHOCK, ROUTE43GATE_ROCKET2, 15
	applymovement ROUTE43GATE_ROCKET2, Rocket2Script_BlocksYouNorth
	opentext
	writetext RocketText_TollFee
	yesorno
	iffalse RocketScript_RefuseToll
	checkmoney YOUR_MONEY, ROUTE43GATE_TOLL - 1
	ifequal HAVE_MORE, RocketScript_TollNorth
	sjump RocketScript_YoureBrokeNorth

RocketScript_TollNorth:
	takemoney YOUR_MONEY, ROUTE43GATE_TOLL
	writetext RocketText_ThankYou
	sjump RocketScript_ShakeDownNorth

RocketScript_YoureBrokeNorth:
	takemoney YOUR_MONEY, ROUTE43GATE_TOLL
	writetext RocketText_AllYouGot
	sjump RocketScript_ShakeDownNorth

RocketScript_ShakeDownNorth:
	buttonsound
	closetext
	applymovement ROUTE43GATE_ROCKET2, Rocket2Script_LetsYouPassNorth
	applymovement ROUTE43GATE_ROCKET1, Rocket1Script_LetsYouPassNorth
	setscene SCENE_FINISHED
	special RestartMapMusic
	end

RocketScript_RefuseToll:
	writetext RocketText_RefusedToll
	waitbutton
	closetext
	setscene SCENE_FINISHED
	setlasttalked ROUTE43GATE_ROCKET1
	winlosstext RocketText_FirstRocketBeaten, 0
	loadtrainer GRUNTM, GRUNTM_ROUTE43_TOLL1
	startbattle
	reloadmapafterbattle
	opentext
	writetext RocketText_SecondRocketChallenge
	waitbutton
	closetext
	setlasttalked ROUTE43GATE_ROCKET2
	winlosstext RocketText_SecondRocketBeaten, 0
	loadtrainer GRUNTM, GRUNTM_ROUTE43_TOLL2
	startbattle
	reloadmapafterbattle
	opentext
	writetext RocketText_RunningAway
	waitbutton
	closetext
	applymovement ROUTE43GATE_ROCKET1, RocketRunsAway
	playsound SFX_EXIT_BUILDING
	disappear ROUTE43GATE_ROCKET1
	applymovement ROUTE43GATE_ROCKET2, RocketRunsAway
	playsound SFX_EXIT_BUILDING
	disappear ROUTE43GATE_ROCKET2
	setevent EVENT_ROUTE_43_GATE_ROCKETS
	waitsfx
	special RestartMapMusic
	end

RocketScript_MakingABundle:
	jumptextfaceplayer RocketText_MakingABundle

OfficerScript_GuardWithSludgeBomb:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM36_SLUDGE_BOMB
	iftrue .GotSludgeBomb
	writetext OfficerText_FoundTM
	buttonsound
	verbosegiveitem TM_SLUDGE_BOMB
	iffalse .NoRoomForSludgeBomb
	setevent EVENT_GOT_TM36_SLUDGE_BOMB
	closetext
	end

.GotSludgeBomb:
	writetext OfficerText_AvoidGrass
	waitbutton
.NoRoomForSludgeBomb:
	closetext
	end

PlayerStepsIn:
	step DOWN
	step_end

Rocket1Script_BlocksYouSouth:
	big_step UP
	big_step UP
	big_step RIGHT
	big_step RIGHT
	turn_head UP
	step_end

Rocket1Script_LetsYouPassSouth:
	big_step LEFT
	big_step LEFT
	big_step DOWN
	big_step DOWN
	step_end

Rocket1Script_BlocksYouNorth:
	big_step DOWN
	big_step DOWN
	big_step RIGHT
	big_step RIGHT
	turn_head DOWN
	step_end

Rocket1Script_LetsYouPassNorth:
	big_step LEFT
	big_step LEFT
	big_step UP
	big_step UP
	turn_head DOWN
	step_end

Rocket2Script_BlocksYouSouth:
	big_step UP
	big_step UP
	big_step LEFT
	big_step LEFT
	turn_head UP
	step_end

Rocket2Script_LetsYouPassSouth:
	big_step RIGHT
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	turn_head UP
	step_end

Rocket2Script_BlocksYouNorth:
	big_step DOWN
	big_step DOWN
	big_step LEFT
	big_step LEFT
	turn_head DOWN
	step_end

Rocket2Script_LetsYouPassNorth:
	big_step RIGHT
	big_step RIGHT
	big_step UP
	big_step UP
	step_end

RocketRunsAway:
	rept 6
	big_step UP
	endr
	step_end

RocketText_TollFee:
	text "Hold it there,"
	line "kiddo!"

	para "The toll is ¥1000"
	line "to go through."

	para "you gonna pay up?"
	done

RocketText_RefusedToll:
	text "Wrong answer."

	para "We'll crush your"
	line "team, then empty"
	cont "your pockets."
	done

RocketText_FirstRocketBeaten:
	text "Tch… Lucky hit."
	line "You're not clear"
	cont "of us yet."
	done

RocketText_SecondRocketChallenge:
	text "He was going easy."

	para "I'll leave your"
	line "#MON crawling."

	para "You should have"
	line "paid while you"
	cont "had the chance."
	done

RocketText_SecondRocketBeaten:
	text "No… Both of us?"
	line "Beaten by a kid?"
	done

RocketText_RunningAway:
	text "Keep your money."

	para "But TEAM ROCKET"
	line "remembers faces."

	para "Come on! Move!"
	done

RocketText_ThankYou:
	text "Thank you very"
	line "much!"
	done

RocketText_AllYouGot:
	text "Then pay what you"
	line "have, please."
	done

RocketText_MakingABundle:
	text "He-he-he. We're"
	line "making a bundle."

	para "Everyone wants to"
	line "see what's going"

	para "on up at LAKE OF"
	line "RAGE."
	done

OfficerText_FoundTM:
	text "I got chased from"
	line "my post by these"
	cont "thugs in black."

	para "They left this"
	line "behind."

	para "It makes me uncom-"
	line "fortable. Could"
	cont "you take it away?"
	done

Text_ReceivedTM30:
	text "<PLAYER> received"
	line "TM30."
	done

OfficerText_AvoidGrass:
	text "Use this gate to"
	line "avoid walking in"
	cont "the grass."
	done

Route43Gate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, ROUTE_43, 4
	warp_event  5,  0, ROUTE_43, 5
	warp_event  4,  7, ROUTE_43, 3
	warp_event  5,  7, ROUTE_43, 3

	db 0 ; coord events

	db 0 ; bg events

	db 3 ; object events
	object_event  0,  4, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OfficerScript_GuardWithSludgeBomb, EVENT_LAKE_OF_RAGE_CIVILIANS
	object_event  2,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RocketScript_MakingABundle, EVENT_ROUTE_43_GATE_ROCKETS
	object_event  7,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RocketScript_MakingABundle, EVENT_ROUTE_43_GATE_ROCKETS

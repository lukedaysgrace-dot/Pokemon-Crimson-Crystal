	object_const_def ; object_event constants
	const ROUTE25_MISTY
	const ROUTE25_COOLTRAINER_M1
	const ROUTE25_PICNICKER
	const ROUTE25_POKEFAN_M
	const ROUTE25_COSPLAYER
	const ROUTE25_LASS
	const ROUTE25_JUGGLER
	const ROUTE25_SUPER_NERD
	const ROUTE25_COOLTRAINER_M2
	const ROUTE25_POKE_BALL
	const ROUTE25_CRYSTAL
	const ROUTE25_MEW

Route25_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene0 ; SCENE_ROUTE25_NOTHING
	scene_script .DummyScene1 ; SCENE_ROUTE25_MISTYS_DATE

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Objects

.DummyScene0:
	end

.DummyScene1:
	end

.Objects:
; An object event flag reads as VISIBLE until something sets it, so both cape
; objects have to be hidden explicitly on a fresh save. Rather than trust the
; flags, derive both objects' visibility from the event state on every map
; load. Clear the old loss flag as a save migration so players who lost under
; the previous permanent-loss behavior can retry the battle too.
	clearevent EVENT_CRYSTAL_CAUGHT_MEW
	checkevent EVENT_ROUTE_25_CAUGHT_MEW
	iftrue .MewIsGone
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iffalse .MewIsGone
	appear ROUTE25_MEW
	sjump .CheckCrystal

.MewIsGone:
	disappear ROUTE25_MEW

.CheckCrystal:
	checkevent EVENT_ROUTE_25_CRYSTAL_LEFT
	iftrue .NoCrystal
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iffalse .NoCrystal
	appear ROUTE25_CRYSTAL
	return

.NoCrystal:
	disappear ROUTE25_CRYSTAL
	return

Route25MistyDate1Script:
	showemote EMOTE_HEART, ROUTE25_MISTY, 15
	pause 30
	showemote EMOTE_SHOCK, ROUTE25_COOLTRAINER_M1, 10
	turnobject ROUTE25_MISTY, DOWN
	applymovement ROUTE25_COOLTRAINER_M1, MovementData_0x19efe8
	disappear ROUTE25_COOLTRAINER_M1
	pause 15
	playmusic MUSIC_BEAUTY_ENCOUNTER
	turnobject ROUTE25_MISTY, UP
	pause 10
	applymovement ROUTE25_MISTY, MovementData_0x19efed
	opentext
	writetext Route25MistyDateText
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	applymovement ROUTE25_MISTY, MovementData_0x19effa
	turnobject PLAYER, LEFT
	applymovement ROUTE25_MISTY, MovementData_0x19f000
	disappear ROUTE25_MISTY
	clearevent EVENT_TRAINERS_IN_CERULEAN_GYM
	setscene SCENE_ROUTE25_NOTHING
	special RestartMapMusic
	end

Route25MistyDate2Script:
	showemote EMOTE_HEART, ROUTE25_MISTY, 15
	pause 30
	showemote EMOTE_SHOCK, ROUTE25_COOLTRAINER_M1, 10
	turnobject ROUTE25_MISTY, DOWN
	applymovement ROUTE25_COOLTRAINER_M1, MovementData_0x19efea
	disappear ROUTE25_COOLTRAINER_M1
	pause 15
	playmusic MUSIC_BEAUTY_ENCOUNTER
	turnobject ROUTE25_MISTY, UP
	pause 10
	applymovement ROUTE25_MISTY, MovementData_0x19eff4
	opentext
	writetext Route25MistyDateText
	waitbutton
	closetext
	turnobject PLAYER, UP
	applymovement ROUTE25_MISTY, MovementData_0x19effd
	turnobject PLAYER, LEFT
	applymovement ROUTE25_MISTY, MovementData_0x19f000
	disappear ROUTE25_MISTY
	clearevent EVENT_TRAINERS_IN_CERULEAN_GYM
	setscene SCENE_ROUTE25_NOTHING
	special RestartMapMusic
	end

Route25MewAppearsScript:
; MEW drifts out over the cape the first time the player comes this way after
; taking BLUE's EARTHBADGE.
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iftrue .Done
	checkflag ENGINE_EARTHBADGE
	iffalse .Done
	setevent EVENT_ROUTE_25_MEW_APPEARED
	special FadeOutMusic
	pause 20
	appear ROUTE25_MEW
	cry MEW
	pause 20
	showemote EMOTE_SHOCK, PLAYER, 20
	applymovement ROUTE25_MEW, Route25MewDriftMovement
	pause 15
	cry MEW
	pause 20
	special RestartMapMusic
.Done:
	end

; Stepping onto the top of the jetty while MEW is still out there brings
; CRYSTAL running in from the west. One guard per trigger tile, so she can
; walk up to the exact tile the player stopped on.

Route25CrystalApproachScript46:
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .Done
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iffalse .Done
	sjump Route25CrystalMewScene46
.Done:
	end

Route25CrystalApproachScript47:
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .Done
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iffalse .Done
	sjump Route25CrystalMewScene47
.Done:
	end

Route25CrystalApproachScript48:
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .Done
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iffalse .Done
	sjump Route25CrystalMewScene48
.Done:
	end

Route25CrystalApproachScript49:
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .Done
	checkevent EVENT_ROUTE_25_MEW_APPEARED
	iffalse .Done
	sjump Route25CrystalMewScene49
.Done:
	end

Route25CrystalRunsIn:
; Common opening for every approach: MEW cries, then CRYSTAL enters at
; (39, 7) - off-screen left of all four trigger tiles - so she walks in
; instead of materializing mid-cape. scall'd; returns to the caller at `end`.
	special FadeOutMusic
	pause 10
	cry MEW
	pause 20
	moveobject ROUTE25_CRYSTAL, 39, 7
	appear ROUTE25_CRYSTAL
	end

Route25CrystalMewScene46:
; Player stopped on (46, 8), the west end of the jetty's top step. (45, 8) is
; the cliff corner over the water, so there is no tile beside them - CRYSTAL
; stops directly above on (46, 7) and faces down at them instead.
	scall Route25CrystalRunsIn
	turnobject PLAYER, UP
	applymovement ROUTE25_CRYSTAL, Route25CrystalApproachTo46Movement
	turnobject ROUTE25_CRYSTAL, DOWN
	sjump Route25CrystalMewSceneFinish

Route25CrystalMewScene47:
; Player on (47, 8): CRYSTAL stops beside them on (46, 8) and faces right.
	scall Route25CrystalRunsIn
	turnobject PLAYER, LEFT
	applymovement ROUTE25_CRYSTAL, Route25CrystalApproachTo47Movement
	turnobject ROUTE25_CRYSTAL, RIGHT
	sjump Route25CrystalMewSceneFinish

Route25CrystalMewScene48:
; Player on (48, 8): CRYSTAL stops beside them on (47, 8) and faces right.
	scall Route25CrystalRunsIn
	turnobject PLAYER, LEFT
	applymovement ROUTE25_CRYSTAL, Route25CrystalApproachTo48Movement
	turnobject ROUTE25_CRYSTAL, RIGHT
	sjump Route25CrystalMewSceneFinish

Route25CrystalMewScene49:
; Player on (49, 8): CRYSTAL stops beside them on (48, 8) and faces right.
	scall Route25CrystalRunsIn
	turnobject PLAYER, LEFT
	applymovement ROUTE25_CRYSTAL, Route25CrystalApproachTo49Movement
	turnobject ROUTE25_CRYSTAL, RIGHT
	sjump Route25CrystalMewSceneFinish

Route25CrystalMewScene:
; Fallback: the player reached MEW without crossing the approach row (climbed
; the jetty from the shore and talked to MEW straight away). They could be
; anywhere around MEW, so CRYSTAL stops at the top of the steps and the two
; face each other from there.
	scall Route25CrystalRunsIn
	applymovement ROUTE25_CRYSTAL, Route25CrystalApproachTo46Movement
	faceobject ROUTE25_CRYSTAL, PLAYER
	faceobject PLAYER, ROUTE25_CRYSTAL
	sjump Route25CrystalMewSceneFinish

Route25CrystalMewSceneFinish:
	showemote EMOTE_SHOCK, ROUTE25_CRYSTAL, 20
	pause 10
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	sjump Route25CrystalBattle

Route25CrystalScript:
	faceplayer
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .GoCatchIt
	special FadeOutMusic
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	sjump Route25CrystalBattle

.GoCatchIt:
	opentext
	writetext Route25CrystalGoCatchItText
	waitbutton
	closetext
	end

Route25CrystalBattle:
	opentext
	writetext Route25CrystalBeforeText
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .Cyndaquil
	checkevent EVENT_GOT_SQUIRTLE_FROM_ELM
	iftrue .Cyndaquil
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .Totodile
	checkevent EVENT_GOT_BULBASAUR_FROM_ELM
	iftrue .Totodile
	loadtrainer CRYSTAL2, CRYSTAL2_CHIKORITA
	sjump .StartBattle

.Cyndaquil:
	loadtrainer CRYSTAL2, CRYSTAL2_CYNDAQUIL
	sjump .StartBattle

.Totodile:
	loadtrainer CRYSTAL2, CRYSTAL2_TOTODILE

.StartBattle:
	winlosstext Route25CrystalWinText, Route25CrystalLossText
	setlasttalked ROUTE25_CRYSTAL
	startbattle
	ifequal LOSE, .Lost
	setevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
.Lost:
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	opentext
	writetext Route25CrystalAfterText
	waitbutton
	closetext
	turnobject ROUTE25_CRYSTAL, DOWN
	playmapmusic
	end

Route25MewScript:
	faceplayer
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iffalse Route25CrystalMewScene
	opentext
	writetext Route25MewText
	cry MEW
	pause 15
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon MEW, 60
	startbattle
; MEW only leaves the cape if it was actually caught - a KO or a run just
; leaves it drifting around for another try. This has to be settled before
; reloadmapafterbattle, because that reload re-runs .Objects.
	special CheckCaughtMew
	iffalse .StillOutThere
	setevent EVENT_ROUTE_25_CAUGHT_MEW
	disappear ROUTE25_MEW
.StillOutThere:
	reloadmapafterbattle
	checkevent EVENT_ROUTE_25_CAUGHT_MEW
	iffalse .Done
	pause 20
	special FadeOutMusic
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	opentext
	writetext Route25CrystalMewCaughtText
	waitbutton
	closetext
	applymovement ROUTE25_CRYSTAL, Route25CrystalLeavesMovement
	setevent EVENT_ROUTE_25_CRYSTAL_LEFT
	disappear ROUTE25_CRYSTAL
	special RestartMapMusic
.Done:
	end

TrainerCosplayerNoelle:
	trainer COSPLAYER, COSPLAYER6, EVENT_BEAT_COSPLAYER_NOELLE, CosplayerNoelleSeenText, CosplayerNoelleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CosplayerNoelleAfterBattleText
	waitbutton
	closetext
	end

TrainerJugglerSilas:
	trainer JUGGLER, SILAS, EVENT_BEAT_JUGGLER_SILAS, JugglerSilasSeenText, JugglerSilasBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext JugglerSilasAfterBattleText
	waitbutton
	closetext
	end

TrainerAromaLadyNadia:
	trainer AROMA_LADY, NADIA, EVENT_BEAT_AROMA_LADY_NADIA, AromaLadyNadiaSeenText, AromaLadyNadiaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext AromaLadyNadiaAfterBattleText
	waitbutton
	closetext
	end

TrainerLassPaige:
	trainer LASS, PAIGE, EVENT_BEAT_LASS_PAIGE, LassPaigeSeenText, LassPaigeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassPaigeAfterBattleText
	waitbutton
	closetext
	end

TrainerPokefanmDustin:
	trainer POKEFANM, DUSTIN, EVENT_BEAT_POKEFANM_DUSTIN, PokefanmDustinSeenText, PokefanmDustinBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokefanmDustinAfterBattleText
	waitbutton
	closetext
	end

TrainerSupernerdPat:
	trainer SUPER_NERD, PAT, EVENT_BEAT_SUPER_NERD_PAT, SupernerdPatSeenText, SupernerdPatBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdPatAfterBattleText
	waitbutton
	closetext
	end

TrainerCooltrainermKevin:
	faceplayer
	opentext
	checkevent EVENT_BEAT_COOLTRAINERM_KEVIN
	iftrue .AfterBattle
	checkevent EVENT_CLEARED_NUGGET_BRIDGE
	iftrue .AfterNuggetBridge
	writetext CooltrainermKevinRewardText
	buttonsound
	verbosegiveitem SCOPE_LENS
	iffalse .NoRoomForPrize
	verbosegiveitem RARE_CANDY
	iffalse .NoRoomForPrize
	setevent EVENT_CLEARED_NUGGET_BRIDGE
.AfterNuggetBridge:
	writetext CooltrainermKevinSeenText
	waitbutton
	closetext
	winlosstext CooltrainermKevinBeatenText, 0
	loadtrainer COOLTRAINERM, KEVIN
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_COOLTRAINERM_KEVIN
	opentext
.AfterBattle:
	writetext CooltrainermKevinAfterBattleText
	waitbutton
.NoRoomForPrize:
	closetext
	end

BillsHouseSign:
	jumptext BillsHouseSignText

Route25Protein:
	itemball PROTEIN

Route25HiddenPotion:
	hiddenitem POTION, EVENT_ROUTE_25_HIDDEN_POTION

Route25MewDriftMovement:
	slow_step RIGHT
	slow_step DOWN
	slow_step LEFT
	slow_step UP
	step_end

Route25CrystalLeavesMovement:
; She can be on the jetty's top step ((46-48, 8)), above it ((46, 7)), or back
; at her home spot ((48, 7)) after a map re-entry. Row 8 west of the jetty is
; the cliff edge, so she steps up onto solid ground first, then heads off west
; through the gap in the cliff line.
	step UP
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

; CRYSTAL's approach paths. All start from (39, 7): east along the clearing,
; then down onto the jetty's top step next to the player.

Route25CrystalApproachTo46Movement:
; (39, 7) -> (46, 7), the tile directly above the player
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

Route25CrystalApproachTo47Movement:
; (39, 7) -> (46, 7) -> (46, 8), beside the player
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step_end

Route25CrystalApproachTo48Movement:
; (39, 7) -> (47, 7) -> (47, 8), beside the player
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step_end

Route25CrystalApproachTo49Movement:
; (39, 7) -> (48, 7) -> (48, 8), beside the player
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step_end

MovementData_0x19efe8:
	big_step DOWN
	step_end

MovementData_0x19efea:
	big_step DOWN
	big_step DOWN
	step_end

MovementData_0x19efed:
	step UP
	step UP
	step UP
	step LEFT
	step LEFT
	step LEFT
	step_end

MovementData_0x19eff4:
	step UP
	step UP
	step LEFT
	step LEFT
	step LEFT
	step_end

MovementData_0x19effa:
	step DOWN
	step LEFT
	step_end

MovementData_0x19effd:
	step UP
	step LEFT
	step_end

MovementData_0x19f000:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

Route25CrystalBeforeText:
	text "CRYSTAL: Don't"
	line "move."

	para "…Do you see it?"

	para "Do you actually"
	line "see it?"

	para "I have read every"
	line "paper ever writ-"
	cont "ten about that"

	para "#MON. All of"
	line "them say the same"
	cont "thing."

	para "MEW does not"
	line "exist."

	para "And it is right"
	line "there."

	para "…<PLAYER>."

	para "I have chased the"
	line "#DEX since we"
	cont "left NEW BARK."

	para "That is the last"
	line "page of it,"
	cont "floating over the"

	para "water."

	para "I'm not going to"
	line "let it simply be"
	cont "handed to me."

	para "So we settle it"
	line "the way we always"
	cont "have."

	para "The winner earns"
	line "the right to"
	cont "catch MEW."

	para "Everything you"
	line "have, <PLAYER>."
	done

Route25CrystalWinText:
	text "…Then it's yours."
	done

Route25CrystalLossText:
	text "We'll settle this"
	line "another time."
	done

Route25CrystalAfterText:
	text "CRYSTAL: …Of"
	line "course."

	para "Of course it's"
	line "you."

	para "I kept searching"
	line "for the differ-"
	cont "ence between us."

	para "I thought it was"
	line "experience. Or"
	cont "knowledge."

	para "But it wasn't."

	para "Your #MON trust"
	line "you completely."

	para "And you trust"
	line "them."

	para "That's something"
	line "no #DEX can"
	cont "measure."

	para "Go on, then."

	para "It's out there,"
	line "and it's yours to"
	cont "catch."

	para "I'll wait right"
	line "here. I want to"
	cont "see it happen."
	done

Route25CrystalGoCatchItText:
	text "CRYSTAL: It's"
	line "still out there."

	para "Go on. Walk up to"
	line "it and see what"
	cont "it does."

	para "I'm not going any-"
	line "where until I've"
	cont "watched you catch"

	para "it."
	done

Route25CrystalMewCaughtText:
	text "CRYSTAL: …You"
	line "actually did it."

	para "The last page."

	para "I spent this whole"
	line "journey chasing"
	cont "the #DEX."

	para "I thought that"
	line "was the point."

	para "Watching you just"
	line "now, I don't"
	cont "think it ever was."

	para "Take care of it,"
	line "<PLAYER>."

	para "…I'll see you"
	line "again."
	done

Route25MewText:
	text "Myuu?"
	done

Route25MistyDateText:
	text "MISTY: Aww! Why"
	line "did you have to"

	para "show up and bug us"
	line "now?"

	para "Do you know what"
	line "they call people"
	cont "like you?"

	para "Pests! You heard"
	line "me right, pest!"

	para "…"

	para "…Oh? Those BADGES"
	line "you have… Are they"
	cont "JOHTO GYM BADGES?"

	para "If you have eight,"
	line "you must be good."

	para "OK, then. Come to"
	line "CERULEAN GYM."

	para "I'll be happy to"
	line "take you on."

	para "I'm MISTY, the"
	line "GYM LEADER in"
	cont "CERULEAN."
	done

AromaLadyNadiaSeenText:
	text "Beat the five of"
	line "us to win a"
	cont "fabulous prize!"

	para "Think you've got"
	line "what it takes?"
	done

AromaLadyNadiaBeatenText:
	text "Ow! Stomped flat!"
	done

AromaLadyNadiaAfterBattleText:
	text "I did my best."
	line "I have no regrets."
	done

PokefanmDustinSeenText:
	text "I'm second!"
	line "Now it's serious!"
	done

PokefanmDustinBeatenText:
	text "How could I lose?"
	done

PokefanmDustinAfterBattleText:
	text "I did my best."
	line "I have no regrets."
	done

CosplayerNoelleSeenText:
	text "Here's No. 3!"
	line "I won't be easy."
	done

CosplayerNoelleBeatenText:
	text "Whoo! Good stuff."
	done

CosplayerNoelleAfterBattleText:
	text "I did my best."
	line "I have no regrets."
	done

LassPaigeSeenText:
	text "I'm No. 4!"
	line "Getting tired?"
	done

LassPaigeBeatenText:
	text "I lost too…"
	done

LassPaigeAfterBattleText:
	text "I did my best."
	line "I have no regrets."
	done

JugglerSilasSeenText:
	text "I'm the last in"
	line "line, but I tell"
	cont "you, I'm tough!"
	done

JugglerSilasBeatenText:
	text "How could I drop"
	line "the ball?"
	done

JugglerSilasAfterBattleText:
	text "I did my best."
	line "I have no regrets."
	done

SupernerdPatSeenText:
	text "Mufufufu…"

	para "I have nothing to"
	line "do with the five"
	cont "other trainers."

	para "I waited here to"
	line "beat you when you"

	para "were tired out by"
	line "all the battles."
	done

SupernerdPatBeatenText:
	text "Aren't you tired"
	line "at all?"
	done

SupernerdPatAfterBattleText:
	text "I'm sorry… I won't"
	line "cheat anymore…"
	done

CooltrainermKevinRewardText:
	text "You took on one"
	line "more battle than"

	para "you expected, but"
	line "you won anyway."

	para "As promised, you"
	line "win a prize!"
	done

CooltrainermKevinSeenText:
	text "But after seeing"
	line "how you battle, I"

	para "want to see how"
	line "I'll fare."

	para "How about it? Let"
	line "me take you on."
	done

CooltrainermKevinBeatenText:
	text "I've never had a"
	line "battle this good!"
	done

CooltrainermKevinAfterBattleText:
	text "That was a great"
	line "battle!"

	para "You and your #-"
	line "MON are truly out-"
	cont "standing!"
	done

BillsHouseSignText:
	text "SEA COTTAGE"
	line "BILL'S HOUSE"
	done

; unused
	text "BILL'S HOUSE"
	done

Route25_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 47,  5, BILLS_HOUSE, 1

	db 8 ; coord events
	coord_event 42,  6, SCENE_ROUTE25_MISTYS_DATE, Route25MistyDate1Script
	coord_event 42,  7, SCENE_ROUTE25_MISTYS_DATE, Route25MistyDate2Script
; x=44 is the only gap in the cliff line, so the player has to cross one of
; these two tiles to reach the cape at all.
	coord_event 44,  6, -1, Route25MewAppearsScript
	coord_event 44,  7, -1, Route25MewAppearsScript
; Top row of the stone jetty only - one guard per tile so CRYSTAL can walk to
; whichever tile the player stopped on. A player who climbs the jetty from the
; shore also crosses this row before reaching the clearing; if they talk to
; MEW while still on the steps, the Route25MewScript fallback covers it.
	coord_event 46,  8, -1, Route25CrystalApproachScript46
	coord_event 47,  8, -1, Route25CrystalApproachScript47
	coord_event 48,  8, -1, Route25CrystalApproachScript48
	coord_event 49,  8, -1, Route25CrystalApproachScript49

	db 2 ; bg events
	bg_event 45,  5, BGEVENT_READ, BillsHouseSign
	bg_event  4,  5, BGEVENT_ITEM, Route25HiddenPotion

	db 12 ; object events
	object_event 46,  9, SPRITE_MISTY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_25_MISTY_BOYFRIEND
	object_event 46, 10, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_25_MISTY_BOYFRIEND
	object_event 12,  8, SPRITE_AROMA_LADY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerAromaLadyNadia, -1
	object_event 16, 11, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokefanmDustin, -1
	object_event 21,  8, SPRITE_COSPLAYER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerCosplayerNoelle, -1
	object_event 26,  8, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerLassPaige, -1
	object_event 28,  4, SPRITE_JUGGLER_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerJugglerSilas, -1
	object_event 31,  7, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 1, TrainerSupernerdPat, -1
	object_event 37,  8, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, TrainerCooltrainermKevin, -1
	object_event 32,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route25Protein, EVENT_ROUTE_25_PROTEIN
	object_event 48,  7, SPRITE_CRYSTAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route25CrystalScript, EVENT_ROUTE_25_CRYSTAL
	object_event 47, 10, SPRITE_MEW, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_PINK, OBJECTTYPE_SCRIPT, 0, Route25MewScript, EVENT_ROUTE_25_MEW

	object_const_def ; object_event constants
	const OLIVINEGYM_JASMINE
	const OLIVINEGYM_GYM_GUY
	const OLIVINEGYM_DANIELLE
	const OLIVINEGYM_KATHRYN

OlivineGym_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .LassesCallback

.LassesCallback:
; The gym trainers only appear once Jasmine has returned to the gym
; from the lighthouse (after the sick Ampharos event).
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .ShowLasses
	disappear OLIVINEGYM_DANIELLE
	disappear OLIVINEGYM_KATHRYN
	return

.ShowLasses:
	appear OLIVINEGYM_DANIELLE
	appear OLIVINEGYM_KATHRYN
	return

OlivineGymJasmineScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_JASMINE
	iftrue .FightDone
	writetext Jasmine_SteelTypeIntro
	waitbutton
	closetext
	winlosstext Jasmine_BetterTrainer, 0
	loadtrainer JASMINE, JASMINE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_JASMINE
	opentext
	writetext Text_ReceivedMineralBadge
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_MINERALBADGE
	readvar VAR_BADGES
	scall OlivineGymActivateRockets
.FightDone:
	checkevent EVENT_GOT_TM23_IRON_TAIL
	iftrue .GotIronTail
	writetext Jasmine_BadgeSpeech
	buttonsound
	verbosegiveitem TM_IRON_TAIL
	iffalse .NoRoomForIronTail
	setevent EVENT_GOT_TM23_IRON_TAIL
	writetext Jasmine_IronTailSpeech
	waitbutton
	closetext
	end

.GotIronTail:
	checkevent EVENT_BEAT_JASMINE_REMATCH
	iftrue .RematchDone
	checkevent EVENT_BEAT_CHUCK_REMATCH
	iffalse .RematchDone
	writetext JasmineRematchChallengeText
	yesorno
	iffalse .RematchDone
	closetext
	winlosstext JasmineRematchWinText, 0
	loadtrainer JASMINE, JASMINE2
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_JASMINE_REMATCH
	end

.RematchDone:
	writetext Jasmine_GoodLuck
	waitbutton
.NoRoomForIronTail:
	closetext
	end

OlivineGymActivateRockets:
	ifequal 7, .RadioTowerRockets
	ifequal 6, .GoldenrodRockets
	end

.GoldenrodRockets:
	jumpstd goldenrodrockets

.RadioTowerRockets:
	jumpstd radiotowerrockets

OlivineGymGuyScript:
	faceplayer
	checkevent EVENT_BEAT_JASMINE
	iftrue .OlivineGymGuyWinScript
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iffalse .OlivineGymGuyPreScript
	opentext
	writetext OlivineGymGuyText
	waitbutton
	closetext
	end

.OlivineGymGuyWinScript:
	opentext
	writetext OlivineGymGuyWinText
	waitbutton
	closetext
	end

.OlivineGymGuyPreScript:
	opentext
	writetext OlivineGymGuyPreText
	waitbutton
	closetext
	end

TrainerLassDanielle:
	trainer LASS, DANIELLE, EVENT_BEAT_LASS_DANIELLE, LassDanielleSeenText, LassDanielleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassDanielleAfterBattleText
	waitbutton
	closetext
	end

TrainerLassKathryn:
	trainer LASS, KATHRYN, EVENT_BEAT_LASS_KATHRYN, LassKathrynSeenText, LassKathrynBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassKathrynAfterBattleText
	waitbutton
	closetext
	end

OlivineGymStatue:
	checkflag ENGINE_MINERALBADGE
	iftrue .Beaten
	jumpstd gymstatue1
.Beaten:
	gettrainername STRING_BUFFER_4, JASMINE, JASMINE1
	jumpstd gymstatue2

Jasmine_SteelTypeIntro:
	text "…Thank you for"
	line "your help at the"
	cont "LIGHTHOUSE…"

	para "But this is dif-"
	line "ferent. Please"

	para "allow me to intro-"
	line "duce myself."

	para "I am JASMINE, a"
	line "GYM LEADER. I use"
	cont "the steel-type."

	para "…Do you know about"
	line "the steel-type?"

	para "It's a type that"
	line "was only recently"
	cont "discovered."

	para "…Um… May I begin?"
	done

Jasmine_BetterTrainer:
	text "…You are a better"
	line "trainer than me,"

	para "in both skill and"
	line "kindness."

	para "In accordance with"
	line "LEAGUE rules, I"

	para "confer upon you"
	line "this BADGE."
	done

Text_ReceivedMineralBadge:
	text "<PLAYER> received"
	line "MINERALBADGE."
	done

Jasmine_BadgeSpeech:
	text "MINERALBADGE"
	line "raises #MON's"
	cont "DEFENSE."

	para "…Um… Please take"
	line "this too…"
	done

Text_ReceivedTM09:
	text "<PLAYER> received"
	line "TM09."
	done

Jasmine_IronTailSpeech:
	text "…You could use"
	line "that TM to teach"
	cont "IRON TAIL."
	done

Jasmine_GoodLuck:
	text "Um… I don't know"
	line "how to say this,"
	cont "but good luck…"
	done

OlivineGymGuyText:
	text "JASMINE uses the"
	line "newly discovered"
	cont "steel-type."

	para "I don't know very"
	line "much about it."
	done

OlivineGymGuyWinText:
	text "That was awesome."

	para "The steel-type,"
	line "huh?"

	para "That was a close"
	line "encounter of an"
	cont "unknown kind!"
	done

OlivineGymGuyPreText:
	text "JASMINE, the GYM"
	line "LEADER, is at the"
	cont "LIGHTHOUSE."

	para "She's been tending"
	line "to a sick #MON."

	para "A strong trainer"
	line "has to be compas-"
	cont "sionate."
	done

JasmineRematchChallengeText:
	text "…Congratulations,"
	line "JOHTO CHAMPION."

	para "You have become"
	line "so strong…"

	para "I wonder if I"
	line "have improved."

	para "Would you like"
	line "to test that?"

	para "Want to have a"
	line "rematch with me?"
	done

JasmineRematchWinText:
	text "…You are a better"
	line "trainer than me,"

	para "in both skill and"
	line "kindness."

	para "PRYCE will test"
	line "you next."
	done

LassDanielleSeenText:
	text "Now that JASMINE"
	line "is back, us GYM"
	cont "TRAINERS are on"
	cont "duty again!"

	para "Let's see if you"
	line "can get past my"
	cont "steel-types!"
	done

LassDanielleBeatenText:
	text "Ohh, my #MON"
	line "got all scuffed"
	cont "up!"
	done

LassDanielleAfterBattleText:
	text "Steel-types have"
	line "so few weak-"
	cont "nesses."

	para "That's why we love"
	line "training them for"
	cont "JASMINE!"
	done

LassKathrynSeenText:
	text "Welcome back to"
	line "the GYM! JASMINE"
	cont "returned, so the"
	cont "challenge is on!"

	para "My steel-types"
	line "won't rust so"
	cont "easily!"
	done

LassKathrynBeatenText:
	text "You polished right"
	line "through my de-"
	cont "fenses!"
	done

LassKathrynAfterBattleText:
	text "JASMINE is waiting"
	line "at the back of"
	cont "the GYM."

	para "You've earned your"
	line "shot at her now."
	done

OlivineGym_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  4, 15, OLIVINE_CITY, 2
	warp_event  5, 15, OLIVINE_CITY, 2

	db 0 ; coord events

	db 2 ; bg events
	bg_event  3, 13, BGEVENT_READ, OlivineGymStatue
	bg_event  6, 13, BGEVENT_READ, OlivineGymStatue

	db 4 ; object events
	object_event  5,  3, SPRITE_JASMINE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineGymJasmineScript, EVENT_OLIVINE_GYM_JASMINE
	object_event  7, 13, SPRITE_GYM_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineGymGuyScript, -1
	object_event  6,  8, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerLassDanielle, EVENT_OLIVINE_GYM_LASS_DANIELLE
	object_event  3, 11, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerLassKathryn, EVENT_OLIVINE_GYM_LASS_KATHRYN

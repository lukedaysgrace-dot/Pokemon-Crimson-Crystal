	object_const_def ; object_event constants
	const VIRIDIANGYM_BLUE
	const VIRIDIANGYM_LARRY
	const VIRIDIANGYM_SNOW
	const VIRIDIANGYM_CYANIDE
	const VIRIDIANGYM_GYM_GUY

ViridianGym_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianGymBlueScript:
	faceplayer
	opentext
	checkflag ENGINE_EARTHBADGE
	iftrue .FightDone
	writetext LeaderBlueBeforeText
	waitbutton
	closetext
	winlosstext LeaderBlueWinText, 0
	loadtrainer BLUE, BLUE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLUE
	opentext
	writetext Text_ReceivedEarthBadge
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_EARTHBADGE
	writetext LeaderBlueAfterText
	waitbutton
	closetext
	setevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	specialphonecall SPECIALCALL_CRYSTAL_CAPE
	end

.FightDone:
	writetext LeaderBlueEpilogueText
	waitbutton
	closetext
	end

TrainerCooltrainermLarry:
	trainer COOLTRAINERM, LARRY2, EVENT_BEAT_COOLTRAINERM_LARRY, CooltrainermLarrySeenText, CooltrainermLarryBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CooltrainermLarryAfterBattleText
	waitbutton
	closetext
	end

TrainerCooltrainermSnow:
	trainer COOLTRAINERM, SNOW, EVENT_BEAT_COOLTRAINERM_SNOW, CooltrainermSnowSeenText, CooltrainermSnowBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CooltrainermSnowAfterBattleText
	waitbutton
	closetext
	end

TrainerCooltrainermCyanide:
	trainer COOLTRAINERM, CYANIDE, EVENT_BEAT_COOLTRAINERM_CYANIDE, CooltrainermCyanideSeenText, CooltrainermCyanideBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CooltrainermCyanideAfterBattleText
	waitbutton
	closetext
	end

ViridianGymGuyScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BLUE
	iftrue .ViridianGymGuyWinScript
	writetext ViridianGymGuyText
	waitbutton
	closetext
	end

.ViridianGymGuyWinScript:
	writetext ViridianGymGuyWinText
	waitbutton
	closetext
	end

ViridianGymStatue:
	checkflag ENGINE_EARTHBADGE
	iftrue .Beaten
	jumpstd gymstatue1

.Beaten:
	gettrainername STRING_BUFFER_4, BLUE, BLUE1
	jumpstd gymstatue2

LeaderBlueBeforeText:
	text "BLUE: Yo! Finally"
	line "got here, huh?"

	para "I wasn't in the"
	line "mood at CINNABAR,"

	para "but now I'm ready"
	line "to battle you."

	para "…"

	para "You're telling me"
	line "you conquered all"
	cont "the GYMS in JOHTO?"

	para "Heh! JOHTO's GYMS"
	line "must be pretty"
	cont "pathetic then."

	para "Hey, don't worry"
	line "about it."

	para "I'll know if you"
	line "are good or not by"

	para "battling you right"
	line "now."

	para "Ready, JOHTO"
	line "CHAMP?"
	done

LeaderBlueWinText:
	text "BLUE: What?"

	para "How the heck did I"
	line "lose to you?"

	para "…"

	para "Tch, all right…"
	line "Here, take this--"
	cont "it's EARTHBADGE."
	done

Text_ReceivedEarthBadge:
	text "<PLAYER> received"
	line "EARTHBADGE."
	done

LeaderBlueAfterText:
	text "BLUE: …"

	para "All right, I was"
	line "wrong. You're the"

	para "real deal. You are"
	line "a good trainer."

	para "But I'm going to"
	line "beat you someday."

	para "Don't you forget"
	line "it!"

	para "The JOHTO LEADERS"
	line "want rematches."

	para "Start with FALKNER"
	line "in VIOLET CITY."
	done

LeaderBlueEpilogueText:
	text "BLUE: Listen, you."

	para "You'd better not"
	line "lose until I beat"
	cont "you. Got it?"
	done

CooltrainermLarrySeenText:
	text "A trainer's real"
	line "strength shows in"
	cont "a long battle."
	done

CooltrainermLarryBeatenText:
	text "You didn't slow"
	line "down at all."
	done

CooltrainermLarryAfterBattleText:
	text "I keep my team's"
	line "stamina up with"
	cont "steady training."
	done

CooltrainermSnowSeenText:
	text "I train here every"
	line "day to sharpen my"
	cont "battling skills."
	done

CooltrainermSnowBeatenText:
	text "You're sharper"
	line "than I am."
	done

CooltrainermSnowAfterBattleText:
	text "Raw power isn't"
	line "enough at this"
	cont "level."

	para "You have to know"
	line "your #MON."
	done

CooltrainermCyanideSeenText:
	text "I've battled every"
	line "trainer who came"
	cont "through this GYM."
	done

CooltrainermCyanideBeatenText:
	text "That's a first."
	done

CooltrainermCyanideAfterBattleText:
	text "You're the first"
	line "one to get by me"
	cont "in a long time."

	para "Our LEADER is"
	line "waiting."
	done

ViridianGymGuyText:
	text "Yo, CHAMP in"
	line "making!"

	para "How's it going?"
	line "Looks like you're"
	cont "on a roll."

	para "The GYM LEADER is"
	line "a guy who battled"

	para "the CHAMPION three"
	line "years ago."

	para "He's no pushover."

	para "Give it everything"
	line "you've got!"
	done

ViridianGymGuyWinText:
	text "Man, you are truly"
	line "tough…"

	para "That was a heck of"
	line "an inspirational"

	para "battle. It brought"
	line "tears to my eyes."
	done

ViridianGym_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  4, 17, VIRIDIAN_CITY, 1
	warp_event  5, 17, VIRIDIAN_CITY, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event  3, 13, BGEVENT_READ, ViridianGymStatue
	bg_event  6, 13, BGEVENT_READ, ViridianGymStatue

; BLUE, his three COOLTRAINERs and the gym guy all share EVENT_VIRIDIAN_GYM_BLUE,
; so the whole gym stays empty until BLUE teleports here from CINNABAR (the same
; way CERULEAN GYM gates MISTY and her swimmers behind one flag). Each
; COOLTRAINER keeps its own EVENT_BEAT_ flag, so none can be re-challenged.
	db 5 ; object events
	object_event  5,  3, SPRITE_BLUE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianGymBlueScript, EVENT_VIRIDIAN_GYM_BLUE
	object_event  7,  9, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 7, TrainerCooltrainermLarry, EVENT_VIRIDIAN_GYM_BLUE
	object_event  2, 11, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 7, TrainerCooltrainermSnow, EVENT_VIRIDIAN_GYM_BLUE
	object_event  2,  7, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 7, TrainerCooltrainermCyanide, EVENT_VIRIDIAN_GYM_BLUE
	object_event  7, 13, SPRITE_GYM_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianGymGuyScript, EVENT_VIRIDIAN_GYM_BLUE

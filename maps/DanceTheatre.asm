	object_const_def ; object_event constants
	const DANCETHEATRE_KIMONO_GIRL1
	const DANCETHEATRE_KIMONO_GIRL2
	const DANCETHEATRE_KIMONO_GIRL3
	const DANCETHEATRE_KIMONO_GIRL4
	const DANCETHEATRE_KIMONO_GIRL5
	const DANCETHEATRE_KIMONO_GIRL6
	const DANCETHEATRE_KIMONO_GIRL7
	const DANCETHEATRE_KIMONO_GIRL8
	const DANCETHEATRE_GENTLEMAN
	const DANCETHEATRE_RHYDON
	const DANCETHEATRE_COOLTRAINER_M
	const DANCETHEATRE_GRANNY

DanceTheatre_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, KimonoChallengeLeaveTheatre

TrainerKimonoGirlNaoko2:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_NAOKO
	iftrue .AfterBattle
	writetext KimonoGirlNaoko2SeenText
	waitbutton
	closetext
	winlosstext KimonoGirlNaoko2BeatenText, 0
	loadtrainer KIMONO_GIRL, NAOKO2
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_NAOKO
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_NAOKO
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_NAOKO
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlNaoko2AfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlSayo:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_SAYO
	iftrue .AfterBattle
	writetext KimonoGirlSayoSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlSayoBeatenText, 0
	loadtrainer KIMONO_GIRL, SAYO
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_SAYO
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_SAYO
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_SAYO
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlSayoAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlZuki:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_ZUKI
	iftrue .AfterBattle
	writetext KimonoGirlZukiSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlZukiBeatenText, 0
	loadtrainer KIMONO_GIRL, ZUKI
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_ZUKI
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_ZUKI
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_ZUKI
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlZukiAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlKuni:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_KUNI
	iftrue .AfterBattle
	writetext KimonoGirlKuniSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlKuniBeatenText, 0
	loadtrainer KIMONO_GIRL, KUNI
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_KUNI
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_KUNI
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_KUNI
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlKuniAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlMiki:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_MIKI
	iftrue .AfterBattle
	writetext KimonoGirlMikiSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlMikiBeatenText, 0
	loadtrainer KIMONO_GIRL, MIKI
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_MIKI
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_MIKI
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_MIKI
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlMikiAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlFuyu:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_FUYU
	iftrue .AfterBattle
	writetext KimonoGirlFuyuSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlFuyuBeatenText, 0
	loadtrainer KIMONO_GIRL, FUYU
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_FUYU
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_FUYU
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_FUYU
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlFuyuAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlHana:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_HANA
	iftrue .AfterBattle
	writetext KimonoGirlHanaSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlHanaBeatenText, 0
	loadtrainer KIMONO_GIRL, HANA
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_HANA
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_HANA
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_HANA
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlHanaAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

TrainerKimonoGirlYumi:
	faceplayer
	scall KimonoChallengeIntroduction
	checkevent EVENT_BEAT_KIMONO_GIRL_YUMI
	iftrue .AfterBattle
	writetext KimonoGirlYumiSeenText
	waitbutton
	closetext
	winlosstext KimonoGirlYumiBeatenText, 0
	loadtrainer KIMONO_GIRL, YUMI
	startbattle
	iftrue .Lost
	setevent EVENT_BEAT_KIMONO_GIRL_YUMI
	reloadmapafterbattle
	opentext
	scall KimonoChallengeCheckComplete
	iffalse .AfterBattle
	setevent EVENT_KIMONO_METRONOME_YUMI
.AfterBattle:
	checkevent EVENT_KIMONO_METRONOME_YUMI
	iftrue KimonoChallengeGiveMetronome
	writetext KimonoGirlYumiAfterBattleText
	waitbutton
	closetext
	end
.Lost:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	reloadmapafterbattle
	end

; A genuine map entry after starting is a forfeiture. Battle/menu reloads
; and Continue use other setup paths and do not run MAPCALLBACK_NEWMAP.
; Ecruteak City's entry callback also calls this as soon as the player exits.
KimonoChallengeLeaveTheatre:
	checkevent EVENT_KIMONO_CHALLENGE_STARTED
	iffalse .Done
	checkevent EVENT_KIMONO_CHALLENGE_COMPLETE
	iftrue .Done
	setevent EVENT_KIMONO_CHALLENGE_FAILED
.Done:
	return

KimonoChallengeIntroduction:
	opentext
	checkevent EVENT_KIMONO_CHALLENGE_STARTED
	iftrue .Done
	setevent EVENT_KIMONO_CHALLENGE_STARTED
; Previously beaten girls on existing saves cannot count toward a new run.
	checkevent EVENT_BEAT_KIMONO_GIRL_NAOKO
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_SAYO
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_ZUKI
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_KUNI
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_MIKI
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_FUYU
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_HANA
	iftrue .AlreadyBattled
	checkevent EVENT_BEAT_KIMONO_GIRL_YUMI
	iftrue .AlreadyBattled
	writetext KimonoChallengeInvitationText
	buttonsound
.Done:
	return
.AlreadyBattled:
	setevent EVENT_KIMONO_CHALLENGE_FAILED
	return

KimonoChallengeCheckComplete:
	checkevent EVENT_KIMONO_CHALLENGE_FAILED
	iftrue .NoPrize
	checkevent EVENT_KIMONO_CHALLENGE_COMPLETE
	iftrue .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_NAOKO
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_SAYO
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_ZUKI
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_KUNI
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_MIKI
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_FUYU
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_HANA
	iffalse .NoPrize
	checkevent EVENT_BEAT_KIMONO_GIRL_YUMI
	iffalse .NoPrize
	setevent EVENT_KIMONO_CHALLENGE_COMPLETE
	return
.NoPrize:
	setval FALSE
	return

KimonoChallengeGiveMetronome:
	checkevent EVENT_GOT_KIMONO_METRONOME
	iftrue .Thanks
	writetext KimonoChallengeWonText
	buttonsound
	verbosegiveitem METRONOME_ITEM
	iffalse .Done
	setevent EVENT_GOT_KIMONO_METRONOME
.Thanks:
	writetext KimonoChallengeMetronomeText
	waitbutton
.Done:
	closetext
	end

KimonoChallengeInvitationText:
	text "We KIMONO GIRLS"
	line "have a special"
	cont "challenge for"
	cont "skilled trainers."

	para "Defeat all eight"
	line "of us without"
	cont "healing your"
	cont "#MON or leaving"
	cont "this hall."

	para "Succeed, and a"
	line "special gift shall"
	cont "be yours."

	para "Shall we begin?"
	done

KimonoChallengeWonText:
	text "How splendid!"

	para "You have defeated"
	line "all eight of us"
	cont "without resting!"

	para "Such discipline"
	line "deserves"
	cont "recognition."

	para "Please accept this"
	line "gift from us all!"
	done

KimonoChallengeMetronomeText:
	text "The METRONOME"
	line "rewards patience"
	cont "and rhythm."

	para "A #MON that"
	line "repeats the same"
	cont "move will find its"
	cont "power growing with"
	cont "each use."
	done

DanceTheaterSurfGuy:
	faceplayer
	opentext
	writetext SurfGuyNeverLeftAScratchText
	buttonsound
	checkevent EVENT_GOT_HM03_SURF
	iftrue SurfGuyAlreadyGaveSurf
	checkevent EVENT_BEAT_KIMONO_GIRL_NAOKO
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_SAYO
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_ZUKI
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_KUNI
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_MIKI
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_FUYU
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_HANA
	iffalse .KimonoGirlsUndefeated
	checkevent EVENT_BEAT_KIMONO_GIRL_YUMI
	iffalse .KimonoGirlsUndefeated
	sjump .GetSurf

.KimonoGirlsUndefeated:
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .PlayerIsFemale
	writetext SurfGuyLadGiftText
	waitbutton
	closetext
	end

.PlayerIsFemale:
	writetext SurfGuyLassieGiftText
	waitbutton
	closetext
	end

.GetSurf:
	writetext SurfGuyLikeADanceText
	buttonsound
	verbosegiveitem HM_SURF
	setevent EVENT_GOT_HM03_SURF
	writetext SurfGuySurfExplanationText
	waitbutton
	closetext
	end

SurfGuyAlreadyGaveSurf:
	writetext SurfGuyElegantKimonoGirlsText
	waitbutton
	closetext
	end

DanceTheaterRhydon:
	opentext
	writetext RhydonText
	cry RHYDON
	waitbutton
	closetext
	end

DanceTheatreCooltrainerMScript:
	jumptextfaceplayer DanceTheatreCooltrainerMText

DanceTheatreGrannyScript:
	jumptextfaceplayer DanceTheatreGrannyText

DanceTheatreFancyPanel:
	jumptext DanceTheatreFancyPanelText

KimonoGirlNaoko2SeenText:
	text "You have lovely"
	line "#MON. May I see"
	cont "them in battle?"
	done

KimonoGirlNaoko2BeatenText:
	text "Oh, you are very"
	line "strong."
	done

KimonoGirlNaoko2AfterBattleText:
	text "I enjoyed that"
	line "bout. I would like"
	cont "to see you again."
	done

KimonoGirlSayoSeenText:
	text "I always dance"
	line "with my #MON."

	para "Of course, I also"
	line "train them."
	done

KimonoGirlSayoBeatenText:
	text "Oh, so close!"
	line "I almost had you."
	done

KimonoGirlSayoAfterBattleText:
	text "Rhythm is impor-"
	line "tant for both"

	para "dancing and #-"
	line "MON."
	done

KimonoGirlZukiSeenText:
	text "Isn't my barrette"
	line "pretty?"

	para "Oh. A #MON"
	line "battle?"
	done

KimonoGirlZukiBeatenText:
	text "I don't have any"
	line "#MON left…"
	done

KimonoGirlZukiAfterBattleText:
	text "I put a different"
	line "flower in my bar-"
	cont "rette every month."
	done

KimonoGirlKuniSeenText:
	text "Oh, you're a cute"
	line "trainer. Would you"
	cont "like to battle?"
	done

KimonoGirlKuniBeatenText:
	text "You're stronger"
	line "than you look."
	done

KimonoGirlKuniAfterBattleText:
	text "I trained a lot,"
	line "so I thought I was"

	para "a capable trainer."
	line "I guess I'm not."
	done

KimonoGirlMikiSeenText:
	text "Do you like my"
	line "dancing? I'm good"
	cont "at #MON too."
	done

KimonoGirlMikiBeatenText:
	text "Ooh, you're good"
	line "at #MON too."
	done

KimonoGirlMikiAfterBattleText:
	text "I can keep dancing"
	line "because there are"

	para "people who enjoy"
	line "what I do."

	para "My #MON keep my"
	line "spirits up too."
	done

KimonoGirlFuyuSeenText:
	text "I practice dancing"
	line "every day with my"
	cont "#MON."

	para "Would you care for"
	line "a battle?"
	done

KimonoGirlFuyuBeatenText:
	text "Your rhythm never"
	line "faltered."
	done

KimonoGirlFuyuAfterBattleText:
	text "A graceful dance"
	line "takes patience and"
	cont "trust in your"
	cont "#MON."
	done

KimonoGirlHanaSeenText:
	text "Do you feel the"
	line "rhythm in the air?"

	para "My #MON and I"
	line "dance to it."

	para "Would you like to"
	line "battle?"
	done

KimonoGirlHanaBeatenText:
	text "You swept me away!"
	done

KimonoGirlHanaAfterBattleText:
	text "Dancing with my"
	line "#MON always"
	cont "makes me smile."
	done

KimonoGirlYumiSeenText:
	text "Ribbons make every"
	line "dance look lovely."

	para "Oh! Would you like"
	line "to battle?"
	done

KimonoGirlYumiBeatenText:
	text "A lovely dance!"
	done

KimonoGirlYumiAfterBattleText:
	text "I express myself"
	line "through dance and"
	cont "#MON battles."
	done

SurfGuyNeverLeftAScratchText:
	text "Not only are the"
	line "KIMONO GIRLS great"

	para "dancers, they're"
	line "also skilled at"
	cont "#MON."

	para "I always challenge"
	line "them, but I've"

	para "never even left a"
	line "scratch…"
	done

SurfGuyLadGiftText:
	text "Lad! If you can"
	line "defeat all the"

	para "KIMONO GIRLS, I'll"
	line "give you a gift."
	done

SurfGuyLassieGiftText:
	text "Lassie, if you can"
	line "defeat all the"

	para "KIMONO GIRLS, I'll"
	line "give you a gift."
	done

SurfGuyLikeADanceText:
	text "The way you bat-"
	line "tled, it was like"
	cont "watching a dance."

	para "It was a rare"
	line "treat to see!"

	para "I want you to have"
	line "this. Don't worry"
	cont "--take it!"
	done

SurfGuySurfExplanationText:
	text "That's SURF."

	para "It's a move that"
	line "lets #MON swim"
	cont "across water."
	done

SurfGuyElegantKimonoGirlsText:
	text "I wish my #MON"
	line "were as elegant as"
	cont "the KIMONO GIRLS…"
	done

RhydonText:
	text "RHYDON: Gugooh"
	line "gugogooh!"
	done

DanceTheatreCooltrainerMText:
	text "That man's always"
	line "with his RHYDON."

	para "Says he wants a"
	line "#MON that can"
	cont "SURF and dance."

	para "Is he trying to"
	line "make a synchro-"
	cont "nized swimming"
	cont "#MON?"
	done

DanceTheatreGrannyText:
	text "The KIMONO GIRLS"
	line "are so beautiful…"

	para "But they have to"
	line "go through rigor-"
	cont "ous training."

	para "And they have to"
	line "learn to follow"

	para "customs before ap-"
	line "pearing in public."

	para "But if you love"
	line "something, any-"
	cont "thing is possible."
	done

DanceTheatreFancyPanelText:
	text "It's a fancy panel"
	line "that's decorated"
	cont "with flowers."
	done

DanceTheatre_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  5, 13, ECRUTEAK_CITY, 8
	warp_event  6, 13, ECRUTEAK_CITY, 8

	db 0 ; coord events

	db 2 ; bg events
	bg_event  5,  6, BGEVENT_UP, DanceTheatreFancyPanel
	bg_event  6,  6, BGEVENT_UP, DanceTheatreFancyPanel

	db 12 ; object events
	object_event  1,  2, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlNaoko2, -1
	object_event  2,  1, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlSayo, -1
	object_event  6,  2, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlZuki, -1
	object_event  9,  1, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlKuni, -1
	object_event 10,  2, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlMiki, -1
	object_event  4,  1, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlFuyu, -1
	object_event  3,  2, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlHana, -1
	; This map replaces the otherwise-unused rock OBJ slot with pink.
	object_event  7,  1, SPRITE_KIMONO_GIRL, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, PAL_NPC_ROCK, OBJECTTYPE_SCRIPT, 0, TrainerKimonoGirlYumi, -1
	object_event  7, 11, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DanceTheaterSurfGuy, -1
	object_event  6,  8, SPRITE_RHYDON, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, DanceTheaterRhydon, -1
	object_event 10, 11, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, DanceTheatreCooltrainerMScript, -1
	object_event  3, 11, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DanceTheatreGrannyScript, -1

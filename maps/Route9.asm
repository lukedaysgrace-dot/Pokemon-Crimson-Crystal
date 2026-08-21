	object_const_def ; object_event constants
	const ROUTE9_YOUNGSTER1
	const ROUTE9_LASS1
	const ROUTE9_YOUNGSTER2
	const ROUTE9_LASS2
	const ROUTE9_POKEFAN_M1
	const ROUTE9_POKEFAN_M2
	const ROUTE9_JUGGLER1
	const ROUTE9_JUGGLER2

Route9_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TrainerCamperDean:
	trainer CAMPER, DEAN, EVENT_BEAT_CAMPER_DEAN, CamperDeanSeenText, CamperDeanBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperDeanAfterBattleText
	waitbutton
	closetext
	end

TrainerAromaLadyHeidi:
	trainer AROMA_LADY, HEIDI, EVENT_BEAT_AROMA_LADY_HEIDI, AromaLadyHeidiSeenText, AromaLadyHeidiBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext AromaLadyHeidiAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperSid:
	trainer CAMPER, SID, EVENT_BEAT_CAMPER_SID, CamperSidSeenText, CamperSidBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperSidAfterBattleText
	waitbutton
	closetext
	end

TrainerAromaLadyEdna:
	trainer AROMA_LADY, EDNA, EVENT_BEAT_AROMA_LADY_EDNA, AromaLadyEdnaSeenText, AromaLadyEdnaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext AromaLadyEdnaAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerTim:
	trainer HIKER, TIM, EVENT_BEAT_HIKER_TIM, HikerTimSeenText, HikerTimBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerTimAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerSidney:
	trainer HIKER, SIDNEY, EVENT_BEAT_HIKER_SIDNEY, HikerSidneySeenText, HikerSidneyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerSidneyAfterBattleText
	waitbutton
	closetext
	end

TrainerJugglerMarco:
	trainer JUGGLER, MARCO, EVENT_BEAT_JUGGLER_MARCO, JugglerMarcoSeenText, JugglerMarcoBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext JugglerMarcoAfterBattleText
	waitbutton
	closetext
	end

TrainerJugglerLeon:
	trainer JUGGLER, LEON, EVENT_BEAT_JUGGLER_LEON, JugglerLeonSeenText, JugglerLeonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext JugglerLeonAfterBattleText
	waitbutton
	closetext
	end

Route9Sign:
	jumptext Route9SignText

Route9HiddenEther:
	hiddenitem ETHER, EVENT_ROUTE_9_HIDDEN_ETHER

CamperDeanSeenText:
	text "I came to explore"
	line "ROCK TUNNEL."
	done

CamperDeanBeatenText:
	text "Whoa! Danger, man."
	done

CamperDeanAfterBattleText:
	text "My #MON were"
	line "hurt before even"

	para "entering ROCK"
	line "TUNNEL."

	para "I'd better take"
	line "them to a #MON"
	cont "CENTER right away."
	done

AromaLadyHeidiSeenText:
	text "Do you like the"
	line "scent of fresh"
	cont "herbs?"

	para "It calms #MON"
	line "right down!"
	done

AromaLadyHeidiBeatenText:
	text "Ohhhh!"
	done

AromaLadyHeidiAfterBattleText:
	text "I dry petals and"
	line "leaves to make"

	para "oils. The aroma"
	line "soothes any"
	cont "#MON."
	done

CamperSidSeenText:
	text "Hey, you!"
	line "Don't litter!"
	done

CamperSidBeatenText:
	text "I was just point-"
	line "ing out…"
	done

CamperSidAfterBattleText:
	text "Sorry. You weren't"
	line "littering. It was"
	cont "my mistake."
	done

AromaLadyEdnaSeenText:
	text "People shouldn't"
	line "leave any litter"
	cont "behind."
	done

AromaLadyEdnaBeatenText:
	text "Ohh… I lost…"
	done

AromaLadyEdnaAfterBattleText:
	text "Conserving energy"
	line "is important, but"

	para "the environment is"
	line "even more vital."
	done

HikerTimSeenText:
	text "She'll be coming"
	line "'round MT.SILVER"
	cont "when she comes…"

	para "MT.SILVER is in"
	line "JOHTO, right?"
	done

HikerTimBeatenText:
	text "I was too busy"
	line "singing…"
	done

HikerTimAfterBattleText:
	text "Battles are about"
	line "concentration."
	done

HikerSidneySeenText:
	text "I'll tell you a"
	line "secret."

	para "But first, we"
	line "battle!"
	done

HikerSidneyBeatenText:
	text "Oh, dang!"
	line "I lost that…"
	done

HikerSidneyAfterBattleText:
	text "The POWER PLANT is"
	line "across a small"
	cont "river."
	done

JugglerMarcoSeenText:
	text "Keep your eyes on"
	line "my hands… and my"
	cont "#MON!"
	done

JugglerMarcoBeatenText:
	text "I dropped the"
	line "ball!"
	done

JugglerMarcoAfterBattleText:
	text "A JUGGLER never"
	line "loses focus!"
	done

JugglerLeonSeenText:
	text "Round and round"
	line "my #MON go!"
	done

JugglerLeonBeatenText:
	text "You broke my"
	line "rhythm!"
	done

JugglerLeonAfterBattleText:
	text "Timing is every-"
	line "thing in battle."
	done

Route9SignText:
	text "ROUTE 9"

	para "CERULEAN CITY -"
	line "ROCK TUNNEL"
	done

Route9_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 48, 15, ROCK_TUNNEL_1F, 1

	db 0 ; coord events

	db 2 ; bg events
	bg_event 15,  7, BGEVENT_READ, Route9Sign
	bg_event 41, 15, BGEVENT_ITEM, Route9HiddenEther

	db 8 ; object events
	object_event 23, 11, SPRITE_CAMPER_NEW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerCamperDean, -1
	object_event 39,  8, SPRITE_AROMA_LADY, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerAromaLadyHeidi, -1
	object_event 11,  4, SPRITE_CAMPER_NEW, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 5, TrainerCamperSid, -1
	object_event 12, 15, SPRITE_AROMA_LADY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 1, TrainerAromaLadyEdna, -1
	object_event 28,  3, SPRITE_HIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerTim, -1
	object_event 36, 15, SPRITE_HIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerHikerSidney, -1
	object_event 31,  6, SPRITE_JUGGLER_NEW, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerJugglerMarco, -1
	object_event 14, 10, SPRITE_JUGGLER_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerJugglerLeon, -1

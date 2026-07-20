	object_const_def ; object_event constants
	const SEAFOAMGYM_BLAINE
	const SEAFOAMGYM_GYM_GUY
	const SEAFOAMGYM_BURGLAR1
	const SEAFOAMGYM_BURGLAR2
	const SEAFOAMGYM_FIREBREATHER1
	const SEAFOAMGYM_FIREBREATHER2

SeafoamGym_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene

	db 0 ; callbacks

.DummyScene:
	end

SeafoamGymBlaineScript:
	faceplayer
	opentext
	checkflag ENGINE_VOLCANOBADGE
	iftrue .FightDone
	writetext BlaineIntroText
	waitbutton
	closetext
	winlosstext BlaineWinLossText, 0
	loadtrainer BLAINE, BLAINE1
	startbattle
	iftrue .ReturnAfterBattle
	appear SEAFOAMGYM_GYM_GUY
.ReturnAfterBattle:
	reloadmapafterbattle
	setevent EVENT_BEAT_BLAINE
	opentext
	writetext ReceivedVolcanoBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_VOLCANOBADGE
	writetext BlaineAfterBattleText
	waitbutton
	closetext
	end

.FightDone:
	writetext BlaineFightDoneText
	waitbutton
	closetext
	end

SeafoamGymGuyScript:
	faceplayer
	opentext
	checkevent EVENT_TALKED_TO_SEAFOAM_GYM_GUY_ONCE
	iftrue .TalkedToSeafoamGymGuyScript
	writetext SeafoamGymGuyWinText
	waitbutton
	closetext
	setevent EVENT_TALKED_TO_SEAFOAM_GYM_GUY_ONCE
	end

.TalkedToSeafoamGymGuyScript:
	writetext SeafoamGymGuyWinText2
	waitbutton
	closetext
	end

TrainerBurglarMorton:
	trainer BURGLAR, MORTON, EVENT_BEAT_BURGLAR_MORTON, BurglarMortonSeenText, BurglarMortonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BurglarMortonAfterBattleText
	waitbutton
	closetext
	end

TrainerBurglarVance:
	trainer BURGLAR, VANCE, EVENT_BEAT_BURGLAR_VANCE, BurglarVanceSeenText, BurglarVanceBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BurglarVanceAfterBattleText
	waitbutton
	closetext
	end

TrainerFirebreatherScorch:
	trainer FIREBREATHER, SCORCH, EVENT_BEAT_FIREBREATHER_SCORCH, FirebreatherScorchSeenText, FirebreatherScorchBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FirebreatherScorchAfterBattleText
	waitbutton
	closetext
	end

TrainerFirebreatherBlaze:
	trainer FIREBREATHER, TORCH, EVENT_BEAT_FIREBREATHER_TORCH, FirebreatherBlazeSeenText, FirebreatherBlazeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FirebreatherBlazeAfterBattleText
	waitbutton
	closetext
	end

BlaineIntroText:
	text "BLAINE: Waaah!"

	para "My GYM in CINNABAR"
	line "burned down."

	para "My fire-breathing"
	line "#MON and I are"

	para "homeless because"
	line "of the volcano."

	para "Waaah!"

	para "But I'm back in"
	line "business as a GYM"

	para "LEADER here in"
	line "this cave."

	para "If you can beat"
	line "me, I'll give you"
	cont "a BADGE."

	para "Ha! You'd better"
	line "have BURN HEAL!"
	done

BlaineWinLossText:
	text "BLAINE: Awesome."
	line "I've burned out…"

	para "You've earned"
	line "VOLCANOBADGE!"
	done

ReceivedVolcanoBadgeText:
	text "<PLAYER> received"
	line "VOLCANOBADGE."
	done

BlaineAfterBattleText:
	text "BLAINE: I did lose"
	line "this time, but I'm"

	para "going to win the"
	line "next time."

	para "When I rebuild my"
	line "CINNABAR GYM,"

	para "we'll have to have"
	line "a rematch."
	done

BlaineFightDoneText:
	text "BLAINE: My fire"
	line "#MON will be"

	para "even stronger."
	line "Just you watch!"
	done

SeafoamGymGuyWinText:
	text "Yo!"

	para "… Huh? It's over"
	line "already?"

	para "Sorry, sorry!"

	para "CINNABAR GYM was"
	line "gone, so I didn't"

	para "know where to find"
	line "you."

	para "But, hey, you're"
	line "plenty strong even"

	para "without my advice."
	line "I knew you'd win!"
	done

SeafoamGymGuyWinText2:
	text "A #MON GYM can"
	line "be anywhere as"

	para "long as the GYM"
	line "LEADER is there."

	para "There's no need"
	line "for a building."
	done

BurglarMortonSeenText:
	text "The heat in here"
	line "keeps my #MON"
	cont "fired up!"
	done

BurglarMortonBeatenText:
	text "You put out my"
	line "flames!"
	done

BurglarMortonAfterBattleText:
	text "BLAINE trains us"
	line "hard. Only the"

	para "hottest #MON"
	line "survive here."
	done

BurglarVanceSeenText:
	text "Think you can walk"
	line "through this GYM"
	cont "unburned?"
	done

BurglarVanceBeatenText:
	text "Argh! Too hot to"
	line "handle!"
	done

BurglarVanceAfterBattleText:
	text "You've got the"
	line "spark to face"
	cont "BLAINE."
	done

FirebreatherScorchSeenText:
	text "Feel the burn!"
	line "My #MON breathe"
	cont "fire!"
	done

FirebreatherScorchBeatenText:
	text "I'm all burned"
	line "out…"
	done

FirebreatherScorchAfterBattleText:
	text "A true fire"
	line "trainer never"

	para "lets the flame"
	line "die down."
	done

FirebreatherBlazeSeenText:
	text "You'll be roasted"
	line "before you reach"
	cont "the LEADER!"
	done

FirebreatherBlazeBeatenText:
	text "Snuffed out!"
	done

FirebreatherBlazeAfterBattleText:
	text "BLAINE's fire is"
	line "even fiercer than"

	para "mine. Good luck"
	line "in there!"
	done

SeafoamGym_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 14, 14, ROUTE_20, 1

	db 0 ; coord events

	db 0 ; bg events

	db 6 ; object events
	object_event  8,  6, SPRITE_BLAINE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SeafoamGymBlaineScript, -1
	object_event 11, 13, SPRITE_GYM_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SeafoamGymGuyScript, EVENT_SEAFOAM_GYM_GYM_GUY
	object_event 13, 11, SPRITE_PHARMACIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerBurglarMorton, -1
	object_event  8,  2, SPRITE_PHARMACIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerBurglarVance, -1
	object_event  0,  5, SPRITE_FIREBREATHER_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerFirebreatherScorch, -1
	object_event  4, 15, SPRITE_FIREBREATHER_NEW, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerFirebreatherBlaze, -1

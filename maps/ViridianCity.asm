	object_const_def ; object_event constants
	const VIRIDIANCITY_GRAMPS1
	const VIRIDIANCITY_GRAMPS2
	const VIRIDIANCITY_FISHER
	const VIRIDIANCITY_YOUNGSTER
	const VIRIDIANCITY_BATTLING_COOLTRAINER_M
	const VIRIDIANCITY_DRAGOON
	const VIRIDIANCITY_BIRD
	const VIRIDIANCITY_BATTLING_COOLTRAINER_F

ViridianCity_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint
	callback MAPCALLBACK_OBJECTS, .SouthernRoad

.FlyPoint:
	farscall UpdateBlueReturnScript
	setflag ENGINE_FLYPOINT_VIRIDIAN
	return

.SouthernRoad:
	farscall CheckSouthernKantoAccessScript
	iftrue .OpenSouthernRoad
; Reuse the retired coastline bit for derived visibility, preserving save IDs.
	clearevent EVENT_CINNABAR_ROCKS_CLEARED
	return
.OpenSouthernRoad:
	setevent EVENT_CINNABAR_ROCKS_CLEARED
	return

ViridianCityCrystalCapeCallScript:
; The tile the player lands on stepping out of VIRIDIAN GYM. Beating BLUE
; queues SPECIALCALL_CRYSTAL_CAPE, so CRYSTAL's call lands the instant the
; door closes rather than on the next step. If this tile is somehow skipped
; the usual CountStep handler still catches the queued call.
	checkevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	iffalse .Done
	farsjump Script_SpecialCrystalCall

.Done:
	end

ViridianCityCoffeeGramps:
	faceplayer
	opentext
	writetext ViridianCityCoffeeGrampsQuestionText
	yesorno
	iffalse .no
	writetext ViridianCityCoffeeGrampsBelievedText
	waitbutton
	closetext
	end

.no:
	writetext ViridianCityCoffeeGrampsDoubtedText
	waitbutton
	closetext
	end

ViridianCityGrampsNearGym:
	faceplayer
	opentext
	checkevent EVENT_BLUE_IN_CINNABAR
	iftrue .BlueReturned
	writetext ViridianCityGrampsNearGymText
	waitbutton
	closetext
	end

.BlueReturned:
	writetext ViridianCityGrampsNearGymBlueReturnedText
	waitbutton
	closetext
	end

ViridianCityNastyPlotFisher:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM42_NASTY_PLOT
	iftrue .GotNastyPlot
	writetext ViridianCityNastyPlotFisherText
	buttonsound
	verbosegiveitem TM_NASTY_PLOT
	iffalse .NoRoomForNastyPlot
	setevent EVENT_GOT_TM42_NASTY_PLOT
.GotNastyPlot:
	writetext ViridianCityNastyPlotFisherGotNastyPlotText
	waitbutton
.NoRoomForNastyPlot:
	closetext
	end

ViridianCityYoungsterScript:
	jumptextfaceplayer ViridianCityYoungsterText

ViridianCityBattlingCooltrainerMScript:
	set_object_priority VIRIDIANCITY_BIRD, LOW_PRIORITY
	waitsfx
	playmusic MUSIC_JOHTO_TRAINER_BATTLE
	opentext
	writetext ViridianCityDragoonAttackText
	pause 30
	closetext
	playsound SFX_TACKLE
	applymovement VIRIDIANCITY_DRAGOON, ViridianCityDragoonAttacksMovement
	opentext
	writetext ViridianCityBattleInterruptedMText
	waitbutton
	closetext
	set_object_priority VIRIDIANCITY_BIRD, 0
	set_object_priority VIRIDIANCITY_DRAGOON, LOW_PRIORITY
	playsound SFX_TACKLE
	applymovement VIRIDIANCITY_BIRD, ViridianCityBirdAttacksMovement
	sjump ViridianCityBattleFinishedScript

ViridianCityBattlingCooltrainerFScript:
	set_object_priority VIRIDIANCITY_DRAGOON, LOW_PRIORITY
	waitsfx
	playmusic MUSIC_JOHTO_TRAINER_BATTLE
	opentext
	writetext ViridianCityBirdAttackText
	pause 30
	closetext
	playsound SFX_TACKLE
	applymovement VIRIDIANCITY_BIRD, ViridianCityBirdAttacksMovement
	opentext
	writetext ViridianCityBattleInterruptedFText
	waitbutton
	closetext
	set_object_priority VIRIDIANCITY_DRAGOON, 0
	set_object_priority VIRIDIANCITY_BIRD, LOW_PRIORITY
	playsound SFX_TACKLE
	applymovement VIRIDIANCITY_DRAGOON, ViridianCityDragoonAttacksMovement

ViridianCityBattleFinishedScript:
	set_object_priority VIRIDIANCITY_DRAGOON, 0
	set_object_priority VIRIDIANCITY_BIRD, 0
	special RestartMapMusic
	end

ViridianCityBattlePokemonScript:
	jumptext ViridianCityBattlePokemonText

ViridianCityDragoonAttacksMovement:
	fix_facing
	big_step RIGHT
	big_step LEFT
	step_end

ViridianCityBirdAttacksMovement:
	fix_facing
	big_step LEFT
	big_step RIGHT
	step_end

ViridianCitySign:
	jumptext ViridianCitySignText

ViridianGymSign:
	jumptext ViridianGymSignText

ViridianCityWelcomeSign:
	jumptext ViridianCityWelcomeSignText

TrainerHouseSign:
	jumptext TrainerHouseSignText

ViridianCityPokecenterSign:
	jumpstd pokecentersign

ViridianCityMartSign:
	jumpstd martsign

ViridianCityCoffeeGrampsQuestionText:
	text "Hey, kid! I just"
	line "had a double shot"

	para "of espresso, and"
	line "I am wired!"

	para "I need to talk to"
	line "someone, so you'll"
	cont "have to do!"

	para "I might not look"
	line "like much now, but"

	para "I was an expert at"
	line "catching #MON."

	para "Do you believe me?"
	done

ViridianCityCoffeeGrampsBelievedText:
	text "Good, good. Yes, I"
	line "was something out"

	para "of the ordinary,"
	line "let me tell you!"
	done

ViridianCityCoffeeGrampsDoubtedText:
	text "What? You little"
	line "whelp!"

	para "If I were just a"
	line "bit younger, I'd"

	para "show you a thing"
	line "or two. Humph!"
	done

ViridianCityGrampsNearGymText:
	text "This GYM didn't"
	line "have a LEADER"
	cont "until recently."

	para "A young man from"
	line "PALLET became the"

	para "LEADER, but he's"
	line "often away."
	done

ViridianCityGrampsNearGymBlueReturnedText:
	text "Are you going to"
	line "battle the LEADER?"

	para "Good luck to you."
	line "You'll need it."
	done

ViridianCityNastyPlotFisherText:
	text "Yawn!"

	para "I must have dozed"
	line "off in the sun."

	para "…I had this dream"
	line "where somebody was"

	para "whispering, cook-"
	line "ing up some nasty"
	cont "little scheme."

	para "Gave me chills, it"
	line "did."

	para "Huh?"
	line "What's this?"

	para "Where did this TM"
	line "come from?"

	para "This is spooky!"
	line "Here, you can have"
	cont "this TM."
	done

ViridianCityNastyPlotFisherGotNastyPlotText:
	text "TM42 contains"
	line "NASTY PLOT…"

	para "…Zzzzz…"
	done

ViridianCityYoungsterText:
	text "I heard that there"
	line "are many items on"

	para "the ground in"
	line "VIRIDIAN FOREST."
	done

ViridianCitySignText:
	text "VIRIDIAN CITY"

	para "The Eternally"
	line "Green Paradise"
	done

ViridianCityDragoonAttackText:
	text "Go, CHARIZARD!"
	para "TACKLE!"
	done

ViridianCityBirdAttackText:
	text "Go, PIDGEOT!"
	para "TACKLE!"
	done

ViridianCityBattleInterruptedMText:
	text "Hey! You made me"
	line "mess up my attack!"
	para "This is an intense"
	line "battle! Earn the"
	cont "BADGES of ERIKA,"
	cont "SABRINA and JANINE"
	cont "while we finish."
	done

ViridianCityBattleInterruptedFText:
	text "Look what you did!"
	line "I lost my focus!"
	para "This is an intense"
	line "battle! Earn the"
	cont "BADGES of ERIKA,"
	cont "SABRINA and JANINE"
	cont "while we finish."
	done

ViridianCityBattlePokemonText:
	text "CHARIZARD and"
	line "PIDGEOT are in an"
	cont "intense battle!"
	para "Better stay out"
	line "of their way!"
	done

ViridianGymSignText:
	text "VIRIDIAN CITY"
	line "#MON GYM"
	cont "LEADER: …"

	para "The rest of the"
	line "text is illegible…"
	done

ViridianCityWelcomeSignText:
	text "WELCOME TO"
	line "VIRIDIAN CITY,"

	para "THE GATEWAY TO"
	line "INDIGO PLATEAU"
	done

TrainerHouseSignText:
	text "TRAINER HOUSE"

	para "The Club for Top"
	line "Trainer Battles"
	done

ViridianCity_MapEvents:
	db 0, 0 ; filler

	db 5 ; warp events
	warp_event 32,  7, VIRIDIAN_GYM, 1
	warp_event 21,  9, VIRIDIAN_NICKNAME_SPEECH_HOUSE, 1
	warp_event 23, 15, TRAINER_HOUSE_1F, 1
	warp_event 29, 19, VIRIDIAN_MART, 2
	warp_event 23, 25, VIRIDIAN_POKECENTER_1F, 1

	db 1 ; coord events
	coord_event 32,  7, -1, ViridianCityCrystalCapeCallScript

	db 6 ; bg events
	bg_event 17, 17, BGEVENT_READ, ViridianCitySign
	bg_event 27,  7, BGEVENT_READ, ViridianGymSign
	bg_event 19,  1, BGEVENT_READ, ViridianCityWelcomeSign
	bg_event 21, 15, BGEVENT_READ, TrainerHouseSign
	bg_event 24, 25, BGEVENT_READ, ViridianCityPokecenterSign
	bg_event 30, 19, BGEVENT_READ, ViridianCityMartSign

	db 8 ; object events
	object_event 18,  5, SPRITE_GRAMPS, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityCoffeeGramps, -1
	object_event 30,  8, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianCityGrampsNearGym, -1
	object_event  6, 23, SPRITE_FAT_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityNastyPlotFisher, -1
	object_event 17, 21, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungsterScript, -1
	object_event 27, 30, SPRITE_COOLTRAINER_M_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianCityBattlingCooltrainerMScript, EVENT_CINNABAR_ROCKS_CLEARED
	object_event 28, 30, SPRITE_DRAGOON, SPRITEMOVEDATA_POKEMON_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityBattlePokemonScript, EVENT_CINNABAR_ROCKS_CLEARED
	object_event 29, 30, SPRITE_BIRD, SPRITEMOVEDATA_POKEMON_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityBattlePokemonScript, EVENT_CINNABAR_ROCKS_CLEARED
	object_event 30, 30, SPRITE_COOLTRAINER_F_NEW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, ViridianCityBattlingCooltrainerFScript, EVENT_CINNABAR_ROCKS_CLEARED

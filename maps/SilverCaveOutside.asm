	object_const_def ; object_event constants
	const SILVERCAVEOUTSIDE_AGATHA
	const SILVERCAVEOUTSIDE_LORELEI

SilverCaveOutside_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene0 ; SCENE_DEFAULT
	scene_script .DummyScene1 ; SCENE_FINISHED

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint

.DummyScene0:
	end

.DummyScene1:
	end

.FlyPoint:
	setflag ENGINE_FLYPOINT_SILVER_CAVE
	return

SilverCaveOutsideAgathaLoreleiScript:
	checkevent EVENT_BEAT_AGATHA
	iftrue .SkipAgatha
	applymovement SILVERCAVEOUTSIDE_AGATHA, SilverCaveOutsideAgathaApproachMovement
	turnobject PLAYER, UP
	opentext
	writetext SilverCaveOutsideAgathaBeforeText
	waitbutton
	closetext
	winlosstext SilverCaveOutsideAgathaBeatenText, 0
	setlasttalked SILVERCAVEOUTSIDE_AGATHA
	loadtrainer AGATHA, AGATHA1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_AGATHA
	opentext
	writetext SilverCaveOutsideAgathaAfterText
	waitbutton
	closetext
	moveobject SILVERCAVEOUTSIDE_AGATHA, 18, 12
	disappear SILVERCAVEOUTSIDE_AGATHA
	appear SILVERCAVEOUTSIDE_AGATHA
	applymovement SILVERCAVEOUTSIDE_AGATHA, SilverCaveOutsideAgathaReturnMovement
	moveobject SILVERCAVEOUTSIDE_AGATHA, 17, 12
.SkipAgatha:
	checkevent EVENT_BEAT_LORELEI
	iftrue .Done
	applymovement SILVERCAVEOUTSIDE_LORELEI, SilverCaveOutsideLoreleiApproachMovement
	turnobject PLAYER, UP
	opentext
	writetext SilverCaveOutsideLoreleiBeforeText
	waitbutton
	closetext
	special FadeBlackQuickly
	special ReloadSpritesNoPalettes
	special StubbedTrainerRankings_Healings
	playmusic MUSIC_HEAL
	special HealParty
	pause 60
	special FadeInQuickly
	special RestartMapMusic
	opentext
	writetext SilverCaveOutsideLoreleiBeginText
	waitbutton
	closetext
	winlosstext SilverCaveOutsideLoreleiBeatenText, 0
	setlasttalked SILVERCAVEOUTSIDE_LORELEI
	loadtrainer LORELEI, LORELEI1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_LORELEI
	opentext
	writetext SilverCaveOutsideLoreleiAfterText
	waitbutton
	closetext
	moveobject SILVERCAVEOUTSIDE_LORELEI, 18, 12
	disappear SILVERCAVEOUTSIDE_LORELEI
	appear SILVERCAVEOUTSIDE_LORELEI
	applymovement SILVERCAVEOUTSIDE_LORELEI, SilverCaveOutsideLoreleiReturnMovement
	moveobject SILVERCAVEOUTSIDE_LORELEI, 19, 12
	setscene SCENE_FINISHED
.Done:
	end

SilverCaveOutsideAgathaScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_AGATHA
	iftrue .Beaten
	writetext SilverCaveOutsideAgathaBeforeText
	waitbutton
	closetext
	end

.Beaten:
	writetext SilverCaveOutsideAgathaAfterText
	waitbutton
	closetext
	end

SilverCaveOutsideLoreleiScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_LORELEI
	iftrue .Beaten
	writetext SilverCaveOutsideLoreleiBeforeText
	waitbutton
	closetext
	end

.Beaten:
	writetext SilverCaveOutsideLoreleiAfterText
	waitbutton
	closetext
	end

MtSilverPokecenterSign:
	jumpstd pokecentersign

MtSilverSign:
	jumptext MtSilverSignText

SilverCaveOutsideHiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_SILVER_CAVE_OUTSIDE_HIDDEN_FULL_RESTORE

SilverCaveOutsideAgathaApproachMovement:
	slow_step RIGHT
	turn_head DOWN
	step_end

SilverCaveOutsideAgathaReturnMovement:
	slow_step LEFT
	turn_head DOWN
	step_end

SilverCaveOutsideLoreleiApproachMovement:
	slow_step LEFT
	turn_head DOWN
	step_end

SilverCaveOutsideLoreleiReturnMovement:
	slow_step RIGHT
	turn_head DOWN
	step_end

SilverCaveOutsideAgathaBeforeText:
	text "AGATHA: My my,"
	line "LORELEI, who do"

	para "you think we"
	line "have here?"

	para "Could it be the"
	line "JOHTO CHAMPION"

	para "we've been"
	line "hearing so much"
	cont "about?"

	para "We train here"
	line "regularly, but"

	para "if it's not"
	line "obvious enough,"

	para "not many trainers"
	line "dare to tread"
	cont "here."

	para "I'm curious to"
	line "see what all the"

	para "fuss is about."
	line "Let's see what"

	para "you've got,"
	line "child."
	done

SilverCaveOutsideAgathaBeatenText:
	text "Humph. Not bad."
	done

SilverCaveOutsideAgathaAfterText:
	text "AGATHA: You've"
	line "got spirit,"
	cont "child."
	done

SilverCaveOutsideLoreleiBeforeText:
	text "LORELEI: I can't"
	line "say I'm not"

	para "impressed that"
	line "you were able to"
	cont "defeat AGATHA."

	para "Maybe there is"
	line "more to you than"
	cont "meets the eye."

	para "Let's see how"
	line "well your #MON"

	para "do against the"
	line "power of ice."

	para "But before we"
	line "begin, I want a"
	cont "fair fight."

	para "It wouldn't be"
	line "much of a"

	para "challenge to face"
	line "you while your"

	para "#MON are licking"
	line "their wounds from"

	para "your previous"
	line "fight."
	done

SilverCaveOutsideLoreleiBeginText:
	text "LORELEI: Let's"
	line "begin."
	done

SilverCaveOutsideLoreleiBeatenText:
	text "How…?"
	done

SilverCaveOutsideLoreleiAfterText:
	text "LORELEI: You're"
	line "stronger than I"

	para "expected. Go on,"
	line "then."
	done

MtSilverSignText:
	text "MT.SILVER"
	done

SilverCaveOutside_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 23, 19, SILVER_CAVE_POKECENTER_1F, 1
	warp_event 18, 11, SILVER_CAVE_ROOM_1, 1

	db 1 ; coord events
	coord_event 18, 13, SCENE_DEFAULT, SilverCaveOutsideAgathaLoreleiScript

	db 3 ; bg events
	bg_event 24, 19, BGEVENT_READ, MtSilverPokecenterSign
	bg_event 17, 13, BGEVENT_READ, MtSilverSign
	bg_event  9, 25, BGEVENT_ITEM, SilverCaveOutsideHiddenFullRestore

	db 2 ; object events
	object_event 17, 12, SPRITE_AGATHA, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SilverCaveOutsideAgathaScript, EVENT_SILVER_CAVE_OUTSIDE_AGATHA
	object_event 19, 12, SPRITE_LORELEI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilverCaveOutsideLoreleiScript, EVENT_SILVER_CAVE_OUTSIDE_LORELEI

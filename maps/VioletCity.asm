	object_const_def ; object_event constants
	const VIOLETCITY_EARL
	const VIOLETCITY_LASS
	const VIOLETCITY_SUPER_NERD
	const VIOLETCITY_GRAMPS
	const VIOLETCITY_YOUNGSTER
	const VIOLETCITY_FRUIT_TREE
	const VIOLETCITY_POKE_BALL1
	const VIOLETCITY_POKE_BALL2
	const VIOLETCITY_CRYSTAL
	const VIOLETCITY_CRYSTAL_GFX_LOADER

VioletCity_MapScripts:
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
	setflag ENGINE_FLYPOINT_VIOLET
	setevent EVENT_VIOLET_CITY_CRYSTAL
	checkevent EVENT_CRYSTAL_VIOLET_INITIALIZED
	iftrue .InitializedCrystal
	clearevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	setevent EVENT_CRYSTAL_VIOLET_INITIALIZED

.InitializedCrystal:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue .AlreadyBeatCrystal
	setscene SCENE_DEFAULT
	return

.AlreadyBeatCrystal:
	setscene SCENE_FINISHED
	return

VioletCityCrystalSceneFarLeft:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachFarLeftMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalScene:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneTop:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachTopMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneTopFarLeft:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachTopFarLeftMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneLow:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachLowMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneLowFarLeft:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachLowFarLeftMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneTopRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachTopRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneLowRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachLowRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneTopFarRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachTopFarRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneFarRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachFarRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneLowFarRight:
	checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	iftrue VioletCityCrystalSceneDone
	special FadeOutMusic
	pause 15
	turnobject PLAYER, UP
	moveobject VIOLETCITY_CRYSTAL, 30, 17
	playsound SFX_EXIT_BUILDING
	appear VIOLETCITY_CRYSTAL
	special RefreshSprites
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalApproachLowFarRightMovement
	sjump VioletCityCrystalBattleScript

VioletCityCrystalSceneDone:
	end

VioletCityCrystalBattleScript:
	opentext
	writetext VioletCityCrystalBeforeText
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
	loadtrainer CRYSTAL, CRYSTAL_1_CHIKORITA
	sjump .StartBattle

.Cyndaquil:
	loadtrainer CRYSTAL, CRYSTAL_1_CYNDAQUIL
	sjump .StartBattle

.Totodile:
	loadtrainer CRYSTAL, CRYSTAL_1_TOTODILE

.StartBattle:
	winlosstext VioletCityCrystalWinText, VioletCityCrystalLossText
	setlasttalked VIOLETCITY_CRYSTAL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	opentext
	writetext VioletCityCrystalAfterText
	waitbutton
	closetext
	setevent EVENT_BEAT_CRYSTAL_VIOLET_CITY
	setscene SCENE_FINISHED
	applymovement VIOLETCITY_CRYSTAL, VioletCityCrystalLeavesMovement
	disappear VIOLETCITY_CRYSTAL
	setevent EVENT_VIOLET_CITY_CRYSTAL
	playmapmusic
	end

VioletCityEarlScript:
	applymovement VIOLETCITY_EARL, VioletCitySpinningEarl_MovementData
	faceplayer
	opentext
	writetext Text_EarlAsksIfYouBeatFalkner
	yesorno
	iffalse .FollowEarl
	sjump .PointlessJump

.PointlessJump:
	writetext Text_VeryNiceIndeed
	waitbutton
	closetext
	end

.FollowEarl:
	writetext Text_FollowEarl
	waitbutton
	closetext
	playmusic MUSIC_SHOW_ME_AROUND
	follow VIOLETCITY_EARL, PLAYER
	applymovement VIOLETCITY_EARL, VioletCityFollowEarl_MovementData
	turnobject PLAYER, UP
	applymovement VIOLETCITY_EARL, VioletCitySpinningEarl_MovementData
	stopfollow
	special RestartMapMusic
	opentext
	writetext Text_HereTeacherIAm
	waitbutton
	closetext
	applymovement VIOLETCITY_EARL, VioletCitySpinningEarl_MovementData
	applymovement VIOLETCITY_EARL, VioletCityFinishFollowEarl_MovementData
	playsound SFX_ENTER_DOOR
	disappear VIOLETCITY_EARL
	clearevent EVENT_EARLS_ACADEMY_EARL
	waitsfx
	end

VioletCityLassScript:
	jumptextfaceplayer VioletCityLassText

VioletCitySuperNerdScript:
	jumptextfaceplayer VioletCitySuperNerdText

VioletCityGrampsScript:
	jumptextfaceplayer VioletCityGrampsText

VioletCityYoungsterScript:
	jumptextfaceplayer VioletCityYoungsterText

VioletCitySign:
	jumptext VioletCitySignText

VioletGymSign:
	jumptext VioletGymSignText

SproutTowerSign:
	jumptext SproutTowerSignText

EarlsPokemonAcademySign:
	jumptext EarlsPokemonAcademySignText

VioletCityPokecenterSign:
	jumpstd pokecentersign

VioletCityMartSign:
	jumpstd martsign

VioletCityPPUp:
	itemball PP_UP

VioletCityRareCandy:
	itemball RARE_CANDY

VioletCityFruitTree:
	fruittree FRUITTREE_VIOLET_CITY

VioletCityHiddenHyperPotion:
	hiddenitem HYPER_POTION, EVENT_VIOLET_CITY_HIDDEN_HYPER_POTION

VioletCityCrystalApproachMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachFarLeftMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachTopMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	turn_head DOWN
	step_end

VioletCityCrystalApproachTopFarLeftMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	turn_head DOWN
	step_end

VioletCityCrystalApproachLowMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachLowFarLeftMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachTopRightMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	turn_head DOWN
	step_end

VioletCityCrystalApproachRightMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachLowRightMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	slow_step DOWN
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachTopFarRightMovement:
	slow_step DOWN
	slow_step LEFT
	turn_head DOWN
	step_end

VioletCityCrystalApproachFarRightMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalApproachLowFarRightMovement:
	slow_step DOWN
	slow_step LEFT
	slow_step DOWN
	slow_step DOWN
	turn_head DOWN
	step_end

VioletCityCrystalLeavesMovement:
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	step_end

VioletCityFollowEarl_MovementData:
	big_step DOWN
	big_step DOWN
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	big_step DOWN
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	big_step UP
	turn_head DOWN
	step_end

VioletCityFinishFollowEarl_MovementData:
	step UP
	step_end

VioletCitySpinningEarl_MovementData:
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	step_end

Text_EarlAsksIfYouBeatFalkner:
	text "Hello!"
	line "You are trainer?"

	para "Battle GYM LEADER,"
	line "win you did?"
	done

Text_VeryNiceIndeed:
	text "Ooh, la la!"
	line "Very indeed nice!"
	done

Text_FollowEarl:
	text "Is that so? Then"
	line "study shall you!"
	cont "Follow me!"
	done

Text_HereTeacherIAm:
	text "Here, teacher I"
	line "am. Good it is"
	cont "you study here!"
	done

VioletCityLassText:
	text "Ghosts are rumored"
	line "to appear in"
	cont "SPROUT TOWER."

	para "They said normal-"
	line "type #MON moves"

	para "had no effect on"
	line "ghosts."
	done

VioletCitySuperNerdText:
	text "Hey, you're a"
	line "#MON trainer?"

	para "If you beat the"
	line "GYM LEADER here,"

	para "you'll be ready"
	line "for prime time!"
	done

VioletCityGrampsText:
	text "FALKNER, from the"
	line "VIOLET #MON"

	para "GYM, is a fine"
	line "trainer!"

	para "He inherited his"
	line "father's gym and"

	para "has done a great"
	line "job with it."
	done

VioletCityYoungsterText:
	text "I saw a wiggly"
	line "tree up ahead!"

	para "If you touch it,"
	line "it squirms and"
	cont "dances! Cool!"
	done

VioletCitySignText:
	text "VIOLET CITY"

	para "The City of"
	line "Nostalgic Scents"
	done

VioletGymSignText:
	text "VIOLET CITY"
	line "#MON GYM"
	cont "LEADER: FALKNER"

	para "The Elegant Master"
	line "of Flying #MON"
	done

SproutTowerSignText:
	text "SPROUT TOWER"

	para "Experience the"
	line "Way of #MON"
	done

EarlsPokemonAcademySignText:
	text "EARL'S #MON"
	line "ACADEMY"
	done

VioletCityCrystalBeforeText:
	text "Oh, hey there."

	para "You're from NEW"
	line "BARK TOWN, aren't"
	cont "you?"

	para "I thought so."

	para "PROF.ELM mentioned"
	line "another TRAINER"
	cont "was helping with"
	cont "#DEX research."

	para "I've been hoping"
	line "we'd cross paths."

	para "I'm CRYSTAL."

	para "PROF.OAK asked me"
	line "to help complete"
	cont "the #DEX."

	para "Since we're both"
	line "working toward the"
	cont "same goal..."

	para "I'd like to see"
	line "how much progress"
	cont "you've made."

	para "A battle should"
	line "tell me everything"
	cont "I need to know."

	para "Let's see what"
	line "you've got."
	done

VioletCityCrystalWinText:
	text "I see..."

	para "Looks like I"
	line "still have some"
	cont "work to do."
	done

VioletCityCrystalLossText:
	text "That was a good"
	line "battle."
	done

VioletCityCrystalAfterText:
	text "So that's where"
	line "I stand."

	para "Good."

	para "Now I know what"
	line "I need to improve."

	para "We're both working"
	line "toward the same"
	cont "goal, after all."

	para "Next time, I won't"
	line "be as easy to"
	cont "beat."
	done

VioletCity_MapEvents:
	db 0, 0 ; filler

	db 9 ; warp events
	warp_event  9, 17, VIOLET_MART, 2
	warp_event 18, 17, VIOLET_GYM, 1
	warp_event 30, 17, EARLS_POKEMON_ACADEMY, 1
	warp_event  3, 15, VIOLET_NICKNAME_SPEECH_HOUSE, 1
	warp_event 31, 25, VIOLET_POKECENTER_1F, 1
	warp_event 21, 29, VIOLET_KYLES_HOUSE, 1
	warp_event 23,  5, SPROUT_TOWER_1F, 1
	warp_event 39, 24, ROUTE_31_VIOLET_GATE, 1
	warp_event 39, 25, ROUTE_31_VIOLET_GATE, 2

	db 12 ; coord events
	coord_event 26, 19, -1, VioletCityCrystalSceneTopFarLeft
	coord_event 27, 19, -1, VioletCityCrystalSceneTop
	coord_event 28, 19, -1, VioletCityCrystalSceneTopRight
	coord_event 29, 19, -1, VioletCityCrystalSceneTopFarRight
	coord_event 26, 20, -1, VioletCityCrystalSceneFarLeft
	coord_event 27, 20, -1, VioletCityCrystalScene
	coord_event 28, 20, -1, VioletCityCrystalSceneRight
	coord_event 29, 20, -1, VioletCityCrystalSceneFarRight
	coord_event 26, 21, -1, VioletCityCrystalSceneLowFarLeft
	coord_event 27, 21, -1, VioletCityCrystalSceneLow
	coord_event 28, 21, -1, VioletCityCrystalSceneLowRight
	coord_event 29, 21, -1, VioletCityCrystalSceneLowFarRight

	db 7 ; bg events
	bg_event 24, 20, BGEVENT_READ, VioletCitySign
	bg_event 15, 17, BGEVENT_READ, VioletGymSign
	bg_event 24,  8, BGEVENT_READ, SproutTowerSign
	bg_event 27, 17, BGEVENT_READ, EarlsPokemonAcademySign
	bg_event 32, 25, BGEVENT_READ, VioletCityPokecenterSign
	bg_event 10, 17, BGEVENT_READ, VioletCityMartSign
	bg_event 37, 14, BGEVENT_ITEM, VioletCityHiddenHyperPotion

	db 10 ; object events
	object_event 13, 16, SPRITE_FISHER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VioletCityEarlScript, EVENT_VIOLET_CITY_EARL
	object_event 28, 28, SPRITE_LASS, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VioletCityLassScript, -1
	object_event 24, 14, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WANDER, 1, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletCitySuperNerdScript, -1
	object_event 17, 20, SPRITE_GRAMPS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletCityGrampsScript, -1
	object_event  5, 18, SPRITE_YOUNGSTER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VioletCityYoungsterScript, -1
	object_event 14, 29, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletCityFruitTree, -1
	object_event  4,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VioletCityPPUp, EVENT_VIOLET_CITY_PP_UP
	object_event 35,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VioletCityRareCandy, EVENT_VIOLET_CITY_RARE_CANDY
	object_event 30, 17, SPRITE_CRYSTAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_VIOLET_CITY_CRYSTAL
	object_event  0,  0, SPRITE_CRYSTAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VioletCityCrystalSceneDone, EVENT_BEAT_CRYSTAL_VIOLET_CITY

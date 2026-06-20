	object_const_def ; object_event constants
	const ICEPATH1F_POKE_BALL1
	const ICEPATH1F_POKE_BALL2
	const ICEPATH1F_POKE_BALL3
	const ICEPATH1F_CRYSTAL

IcePath1F_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .InitializeCrystal

.InitializeCrystal:
	checkevent EVENT_CRYSTAL_ICE_PATH_INITIALIZED
	iftrue .Done
	setevent EVENT_ICE_PATH_CRYSTAL
	clearevent EVENT_BEAT_CRYSTAL_ICE_PATH
	setevent EVENT_CRYSTAL_ICE_PATH_INITIALIZED
.Done:
	return

IcePath1FHMWaterfall:
	itemball HM_WATERFALL

IcePath1FPPUp:
	itemball PP_UP

IcePath1FProtein:
	itemball PROTEIN

IcePath1FCrystalScene:
	checkevent EVENT_BEAT_CRYSTAL_ICE_PATH
	iftrue .Done
	clearevent EVENT_ICE_PATH_CRYSTAL
	appear ICEPATH1F_CRYSTAL
	special FadeOutMusic
	turnobject PLAYER, UP
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement ICEPATH1F_CRYSTAL, IcePath1FCrystalApproachMovement
	opentext
	writetext IcePath1FCrystalBeforeText
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .Cyndaquil
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .Totodile
	loadtrainer CRYSTAL, CRYSTAL_4_CHIKORITA
	sjump .StartBattle

.Cyndaquil:
	loadtrainer CRYSTAL, CRYSTAL_4_CYNDAQUIL
	sjump .StartBattle

.Totodile:
	loadtrainer CRYSTAL, CRYSTAL_4_TOTODILE

.StartBattle:
	winlosstext IcePath1FCrystalWinText, IcePath1FCrystalLossText
	setlasttalked ICEPATH1F_CRYSTAL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	opentext
	writetext IcePath1FCrystalAfterText
	waitbutton
	closetext
	setevent EVENT_BEAT_CRYSTAL_ICE_PATH
	applymovement ICEPATH1F_CRYSTAL, IcePath1FCrystalLeaveMovement
	disappear ICEPATH1F_CRYSTAL
	setevent EVENT_ICE_PATH_CRYSTAL
	playmapmusic
.Done:
	end

IcePath1FCrystalApproachMovement:
	set_sliding
	fast_slide_step DOWN
	fast_slide_step DOWN
	fast_slide_step DOWN
	remove_sliding
	step_end

IcePath1FCrystalLeaveMovement:
	step LEFT
	step LEFT
	step UP
	set_sliding
	fast_slide_step UP
	fast_slide_step UP
	remove_sliding
	step_end

IcePath1FCrystalBeforeText:
	text "Hey, <PLAYER>!"

	para "Perfect timing."
	line "Let's battle!"
	done

IcePath1FCrystalWinText:
	text "You're still one"
	line "step ahead!"
	done

IcePath1FCrystalLossText:
	text "I finally got"
	line "you!"
	done

IcePath1FCrystalAfterText:
	text "That was a great"
	line "battle!"

	para "I'll see you"
	line "again, <PLAYER>!"
	done

IcePath1F_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4, 19, ROUTE_44, 1
	warp_event 36, 27, BLACKTHORN_CITY, 7
	warp_event 37,  5, ICE_PATH_B1F, 1
	warp_event 37, 13, ICE_PATH_B1F, 7

	db 1 ; coord events
	coord_event 36, 23, -1, IcePath1FCrystalScene

	db 0 ; bg events

	db 4 ; object events
	object_event 31,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, IcePath1FHMWaterfall, EVENT_GOT_HM07_WATERFALL
	object_event 32, 23, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, IcePath1FPPUp, EVENT_ICE_PATH_1F_PP_UP
	object_event 35,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, IcePath1FProtein, EVENT_ICE_PATH_1F_PROTEIN
	object_event 36, 19, SPRITE_CRYSTAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ICE_PATH_CRYSTAL

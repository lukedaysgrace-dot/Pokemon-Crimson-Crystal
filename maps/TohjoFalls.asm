	object_const_def ; object_event constants
	const TOHJOFALLS_POKE_BALL
	const TOHJOFALLS_CRYSTAL

TohjoFalls_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .InitializeCrystal

.InitializeCrystal:
	checkevent EVENT_CRYSTAL_TOHJO_FALLS_INITIALIZED
	iftrue .Done
	setevent EVENT_TOHJO_FALLS_CRYSTAL
	clearevent EVENT_BEAT_CRYSTAL_TOHJO_FALLS
	setevent EVENT_CRYSTAL_TOHJO_FALLS_INITIALIZED
.Done:
	return

TohjoFallsMoonStone:
	itemball MOON_STONE

TohjoFallsCrystalTopTrigger:
	checkevent EVENT_BEAT_CRYSTAL_TOHJO_FALLS
	iftrue .Done
	clearevent EVENT_TOHJO_FALLS_CRYSTAL
	appear TOHJOFALLS_CRYSTAL
	special FadeOutMusic
	turnobject PLAYER, RIGHT
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement TOHJOFALLS_CRYSTAL, TohjoFallsCrystalApproachTopMovement
	sjump TohjoFallsCrystalBattle
.Done:
	end

TohjoFallsCrystalBottomTrigger:
	checkevent EVENT_BEAT_CRYSTAL_TOHJO_FALLS
	iftrue .Done
	clearevent EVENT_TOHJO_FALLS_CRYSTAL
	appear TOHJOFALLS_CRYSTAL
	special FadeOutMusic
	turnobject PLAYER, RIGHT
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	applymovement TOHJOFALLS_CRYSTAL, TohjoFallsCrystalApproachBottomMovement
	sjump TohjoFallsCrystalBattle
.Done:
	end

TohjoFallsCrystalBattle:
	opentext
	writetext TohjoFallsCrystalBeforeText
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .Cyndaquil
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .Totodile
	loadtrainer CRYSTAL2, CRYSTAL2_CHIKORITA
	sjump .StartBattle

.Cyndaquil:
	loadtrainer CRYSTAL2, CRYSTAL2_CYNDAQUIL
	sjump .StartBattle

.Totodile:
	loadtrainer CRYSTAL2, CRYSTAL2_TOTODILE

.StartBattle:
	winlosstext TohjoFallsCrystalWinText, TohjoFallsCrystalLossText
	setlasttalked TOHJOFALLS_CRYSTAL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_CRYSTAL_ENCOUNTER
	opentext
	writetext TohjoFallsCrystalAfterText
	waitbutton
	closetext
	setevent EVENT_BEAT_CRYSTAL_TOHJO_FALLS
	readvar VAR_YCOORD
	ifequal 14, .LeaveTop
	applymovement TOHJOFALLS_CRYSTAL, TohjoFallsCrystalLeaveBottomMovement
	sjump .Disappear

.LeaveTop:
	applymovement TOHJOFALLS_CRYSTAL, TohjoFallsCrystalLeaveTopMovement

.Disappear:
	disappear TOHJOFALLS_CRYSTAL
	setevent EVENT_TOHJO_FALLS_CRYSTAL
	playmapmusic
	end

TohjoFallsCrystalApproachTopMovement:
	slow_step UP
	slow_step UP
	slow_step LEFT
	slow_step LEFT
	step_end

TohjoFallsCrystalApproachBottomMovement:
	slow_step UP
	slow_step LEFT
	slow_step LEFT
	step_end

TohjoFallsCrystalLeaveTopMovement:
	slow_step RIGHT
	slow_step RIGHT
	slow_step DOWN
	slow_step DOWN
	step_end

TohjoFallsCrystalLeaveBottomMovement:
	slow_step RIGHT
	slow_step RIGHT
	slow_step DOWN
	step_end

TohjoFallsCrystalBeforeText:
	text "CRYSTAL:"
	line "I expected to find"
	cont "you here."

	para "When we first left"
	line "New Bark Town, I"
	cont "thought completing"

	para "the #DEX was"
	line "all that mattered."

	para "But this journey"
	line "has taught me"
	cont "otherwise."

	para "A Trainer can't"
	line "understand #MON"
	cont "by simply"

	para "observing them."

	para "They have to earn"
	line "that"
	cont "understanding."

	para "And every time"
	line "we've battled..."

	para "I've been forced"
	line "to confront that."

	para "We've both come"
	line "too far to hold"
	cont "anything back now."

	para "I want to see the"
	line "result of"
	cont "everything we've"

	para "learned."

	para "Show me your"
	line "strength."
	done

TohjoFallsCrystalWinText:
	text "....I understand"
	line "now."
	done

TohjoFallsCrystalLossText:
	text "My training paid"
	line "off!"
	done

TohjoFallsCrystalAfterText:
	text "CRYSTAL:"
	line "I kept searching"
	cont "for the difference"

	para "between us."

	para "I thought it was"
	line "experience."

	para "Or knowledge."

	para "But it wasn't."

	para "Your #MON"
	line "trust you"
	cont "completely."

	para "And you trust"
	line "them."

	para "That's why you"
	line "won."

	para "That's something"
	line "no #DEX can"
	cont "measure."

	para "I think I've found"
	line "the answer I was"
	cont "looking for."

	para "...the next time"
	line "we meet the"
	cont "outcome may be"

	para "different."

	para "Until then, take"
	line "care <PLAYER>."
	done
TohjoFalls_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 13, 15, ROUTE_27, 2
	warp_event 25, 15, ROUTE_27, 3

	db 2 ; coord events
	coord_event 22, 14, -1, TohjoFallsCrystalTopTrigger
	coord_event 22, 15, -1, TohjoFallsCrystalBottomTrigger

	db 0 ; bg events

	db 2 ; object events
	object_event  2,  6, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, TohjoFallsMoonStone, EVENT_TOHJO_FALLS_MOON_STONE
	object_event 25, 16, SPRITE_CRYSTAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_TOHJO_FALLS_CRYSTAL

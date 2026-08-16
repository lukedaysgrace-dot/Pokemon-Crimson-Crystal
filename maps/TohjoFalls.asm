	object_const_def ; object_event constants
	const TOHJOFALLS_POKE_BALL
	const TOHJOFALLS_SUICUNE

TohjoFalls_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Suicune

.Suicune:
; SUICUNE waits by the water once the eighth Badge has been earned.
	checkevent EVENT_FOUGHT_TOHJO_FALLS_SUICUNE
	iftrue .NoSuicune
	checkflag ENGINE_RISINGBADGE
	iffalse .NoSuicune
	appear TOHJOFALLS_SUICUNE
	return

.NoSuicune:
	disappear TOHJOFALLS_SUICUNE
	return

TohjoFallsMoonStone:
	itemball MOON_STONE

TohjoFallsSuicune:
	faceplayer
	opentext
	writetext TohjoFallsSuicuneText
	cry SUICUNE
	pause 15
	closetext
	playsound SFX_WHIRLWIND
	earthquake 30
	waitsfx
	setevent EVENT_FOUGHT_TOHJO_FALLS_SUICUNE
	loadvar VAR_BATTLETYPE, BATTLETYPE_SUICUNE
	loadwildmon SUICUNE, 40
	startbattle
	disappear TOHJOFALLS_SUICUNE
	reloadmapafterbattle
	end

TohjoFallsSuicuneText:
	text "Shuoooh!"
	done

TohjoFalls_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 13, 15, ROUTE_27, 2
	warp_event 25, 15, ROUTE_27, 3

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event  2,  6, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, TohjoFallsMoonStone, EVENT_TOHJO_FALLS_MOON_STONE
	object_event  6,  6, SPRITE_SUICUNE, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, TohjoFallsSuicune, EVENT_TOHJO_FALLS_SUICUNE

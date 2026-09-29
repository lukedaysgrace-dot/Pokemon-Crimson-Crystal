	object_const_def ; object_event constants
	const WHIRLISLANDLUGIACHAMBER_LUGIA

WhirlIslandLugiaChamber_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Lugia

.Lugia:
	checkevent EVENT_FOUGHT_LUGIA
	iftrue .NoAppear
	checkitem SILVER_WING
	iftrue .Appear
	sjump .NoAppear

.Appear:
	appear WHIRLISLANDLUGIACHAMBER_LUGIA
	return

.NoAppear:
	disappear WHIRLISLANDLUGIACHAMBER_LUGIA
	return

Lugia:
	faceplayer
	opentext
	writetext LugiaText
	cry LUGIA
	pause 15
	closetext
	setevent EVENT_FOUGHT_LUGIA
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon LUGIA, 60
	startbattle
	disappear WHIRLISLANDLUGIACHAMBER_LUGIA
	reloadmapafterbattle
	checkitem ELEMENTAL_SPHERE
	iftrue .Done
	verbosegiveitem ELEMENTAL_SPHERE
.Done:
	end

; The ELEMENTAL SPHERE is left where LUGIA stood, in case the player blacked
; out in the battle or had no room for it (it is the only one in the game).
WhirlIslandLugiaChamberSphereSpot:
	checkevent EVENT_FOUGHT_LUGIA
	iffalse .Nothing
	checkevent EVENT_ROUTE_19_ELEMENTAL_SPHERE_PLACED
	iftrue .Nothing
	checkitem ELEMENTAL_SPHERE
	iftrue .Nothing
	opentext
	writetext WhirlIslandLugiaChamberSphereText
	waitbutton
	verbosegiveitem ELEMENTAL_SPHERE
	closetext
.Nothing:
	end

LugiaText:
	text "Gyaaas!"
	done

WhirlIslandLugiaChamberSphereText:
	text "Something is"
	line "glittering where"
	cont "LUGIA stood…"
	done

WhirlIslandLugiaChamber_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  9, 13, WHIRL_ISLAND_B2F, 3

	db 0 ; coord events

	db 1 ; bg events
	bg_event  9,  5, BGEVENT_READ, WhirlIslandLugiaChamberSphereSpot

	db 1 ; object events
	object_event  9,  5, SPRITE_LUGIA, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Lugia, EVENT_WHIRL_ISLAND_LUGIA_CHAMBER_LUGIA

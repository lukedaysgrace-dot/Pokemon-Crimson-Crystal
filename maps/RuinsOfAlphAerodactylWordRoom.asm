	object_const_def
	const RUINSOFALPHAERODACTYLWORDROOM_CLAW_FOSSIL
	const RUINSOFALPHAERODACTYLWORDROOM_ARMOR_FOSSIL
	const RUINSOFALPHAERODACTYLWORDROOM_SAIL_FOSSIL

RuinsOfAlphAerodactylWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_AERODACTYL_WORD_ROOM_CLAW_WALL_OPEN
	iffalse .CheckArmorWall
	changeblock 2, 0, $41
.CheckArmorWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ARMOR_WALL_OPEN
	iffalse .CheckSailWall
	changeblock 8, 0, $41
.CheckSailWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_SAIL_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_AERODACTYL_WORD_ROOM_CLAW_WALL_OPEN
	iftrue .ClawWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_CLAW_FOSSIL
	sjump .CheckArmorObject
.ClawWallOpen:
	checkevent EVENT_PICKED_UP_CLAW_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .CheckArmorObject
	appear RUINSOFALPHAERODACTYLWORDROOM_CLAW_FOSSIL
.CheckArmorObject:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ARMOR_WALL_OPEN
	iftrue .ArmorWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_ARMOR_FOSSIL
	sjump .CheckSailObject
.ArmorWallOpen:
	checkevent EVENT_PICKED_UP_ARMOR_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .CheckSailObject
	appear RUINSOFALPHAERODACTYLWORDROOM_ARMOR_FOSSIL
.CheckSailObject:
	checkevent EVENT_AERODACTYL_WORD_ROOM_SAIL_WALL_OPEN
	iftrue .SailWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_SAIL_FOSSIL
	return
.SailWallOpen:
	checkevent EVENT_PICKED_UP_SAIL_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHAERODACTYLWORDROOM_SAIL_FOSSIL
.ObjectsDone:
	return

RuinsOfAlphAerodactylWordRoomClawWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_CLAW_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 2, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_CLAW_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_CLAW_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomArmorWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ARMOR_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 8, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_ARMOR_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_ARMOR_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomSailWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_SAIL_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_SAIL_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_SAIL_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomClawFossil:
	opentext
	giveitem CLAW_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_CLAW_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotClawFossilText
	sjump RuinsOfAlphAerodactylWordRoomFinishFossil

RuinsOfAlphAerodactylWordRoomArmorFossil:
	opentext
	giveitem ARMOR_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_ARMOR_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotArmorFossilText
	sjump RuinsOfAlphAerodactylWordRoomFinishFossil

RuinsOfAlphAerodactylWordRoomSailFossil:
	opentext
	giveitem SAIL_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_SAIL_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotSailFossilText

RuinsOfAlphAerodactylWordRoomFinishFossil:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	end

RuinsOfAlphAerodactylWordRoomFossilPocketFull:
	pocketisfull
	closetext
	end

RuinsOfAlphAerodactylWordRoomWallCrumblesText:
	text "The wall crumbles"
	line "away!"
	done

RuinsOfAlphAerodactylWordRoomGotClawFossilText:
	text "<PLAYER> got the"
	line "CLAW FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoomGotArmorFossilText:
	text "<PLAYER> got the"
	line "ARMOR FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoomGotSailFossilText:
	text "<PLAYER> got the"
	line "SAIL FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoom_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9,  5, RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, 3
	warp_event 10,  5, RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, 4
	warp_event 17, 11, RUINS_OF_ALPH_INNER_CHAMBER, 8

	db 0 ; coord events

	db 3 ; bg events
	bg_event  2,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomClawWall
	bg_event  8,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomArmorWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomSailWall

	db 3 ; object events
	object_event  2,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomClawFossil, EVENT_PICKED_UP_CLAW_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	object_event  8,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomArmorFossil, EVENT_PICKED_UP_ARMOR_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomSailFossil, EVENT_PICKED_UP_SAIL_FOSSIL_FROM_AERODACTYL_WORD_ROOM

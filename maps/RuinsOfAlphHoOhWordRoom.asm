	object_const_def
	const RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	const RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
	const RUINSOFALPHHOOHWORDROOM_SAIL_FOSSIL

RuinsOfAlphHoOhWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	iffalse .CheckJawWall
	changeblock 2, 0, $41
.CheckJawWall:
	checkevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	iffalse .CheckSailWall
	changeblock 8, 0, $41
.CheckSailWall:
	checkevent EVENT_HO_OH_WORD_ROOM_SAIL_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	iftrue .SkullWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	sjump .CheckJawObject
.SkullWallOpen:
	checkevent EVENT_PICKED_UP_SKULL_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .CheckJawObject
	appear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
.CheckJawObject:
	checkevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	iftrue .JawWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
	sjump .CheckSailObject
.JawWallOpen:
	checkevent EVENT_PICKED_UP_JAW_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .CheckSailObject
	appear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
.CheckSailObject:
	checkevent EVENT_HO_OH_WORD_ROOM_SAIL_WALL_OPEN
	iftrue .SailWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_SAIL_FOSSIL
	return
.SailWallOpen:
	checkevent EVENT_PICKED_UP_SAIL_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHHOOHWORDROOM_SAIL_FOSSIL
.ObjectsDone:
	return

RuinsOfAlphHoOhWordRoomSkullWall:
	checkevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphHoOhWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 2, 0, $41
	reloadmappart
	setevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	appear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
.Done:
	end

RuinsOfAlphHoOhWordRoomJawWall:
	checkevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphHoOhWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 8, 0, $41
	reloadmappart
	setevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	appear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
.Done:
	end

RuinsOfAlphHoOhWordRoomSailWall:
	checkevent EVENT_HO_OH_WORD_ROOM_SAIL_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphHoOhWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_HO_OH_WORD_ROOM_SAIL_WALL_OPEN
	appear RUINSOFALPHHOOHWORDROOM_SAIL_FOSSIL
.Done:
	end

RuinsOfAlphHoOhWordRoomSkullFossil:
	opentext
	giveitem SKULL_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotSkullFossilText
	sjump RuinsOfAlphHoOhWordRoomFinishFossil

RuinsOfAlphHoOhWordRoomJawFossil:
	opentext
	giveitem JAW_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotJawFossilText
	sjump RuinsOfAlphHoOhWordRoomFinishFossil

RuinsOfAlphHoOhWordRoomSailFossil:
	opentext
	giveitem SAIL_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_SAIL_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotSailFossilText

RuinsOfAlphHoOhWordRoomFinishFossil:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	end

RuinsOfAlphHoOhWordRoomFossilPocketFull:
	pocketisfull
	closetext
	end

RuinsOfAlphHoOhWordRoomWallCrumblesText:
	text "The wall crumbles"
	line "away!"
	done

RuinsOfAlphHoOhWordRoomGotSkullFossilText:
	text "<PLAYER> got the"
	line "SKULL FOSSIL!"
	done

RuinsOfAlphHoOhWordRoomGotJawFossilText:
	text "<PLAYER> got the"
	line "JAW FOSSIL!"
	done

RuinsOfAlphHoOhWordRoomGotSailFossilText:
	text "<PLAYER> got the"
	line "SAIL FOSSIL!"
	done

RuinsOfAlphHoOhWordRoom_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9,  9, RUINS_OF_ALPH_HO_OH_ITEM_ROOM, 3
	warp_event 10,  9, RUINS_OF_ALPH_HO_OH_ITEM_ROOM, 4
	warp_event 17, 21, RUINS_OF_ALPH_INNER_CHAMBER, 2

	db 0 ; coord events

	db 3 ; bg events
	bg_event  2,  0, BGEVENT_UP, RuinsOfAlphHoOhWordRoomSkullWall
	bg_event  8,  0, BGEVENT_UP, RuinsOfAlphHoOhWordRoomJawWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphHoOhWordRoomSailWall

	db 3 ; object events
	object_event  2,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomSkullFossil, EVENT_PICKED_UP_SKULL_FOSSIL_FROM_HO_OH_WORD_ROOM
	object_event  8,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomJawFossil, EVENT_PICKED_UP_JAW_FOSSIL_FROM_HO_OH_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomSailFossil, EVENT_PICKED_UP_SAIL_FOSSIL_FROM_HO_OH_WORD_ROOM

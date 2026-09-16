	object_const_def
	const RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	const RUINSOFALPHHOOHWORDROOM_COVER_FOSSIL
	const RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL

RuinsOfAlphHoOhWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	iffalse .CheckCoverWall
	changeblock 2, 0, $41
.CheckCoverWall:
	checkevent EVENT_HO_OH_WORD_ROOM_COVER_WALL_OPEN
	iffalse .CheckJawWall
	changeblock 8, 0, $41
.CheckJawWall:
	checkevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_HO_OH_WORD_ROOM_SKULL_WALL_OPEN
	iftrue .SkullWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	sjump .CheckCoverObject
.SkullWallOpen:
	checkevent EVENT_PICKED_UP_SKULL_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .CheckCoverObject
	appear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
.CheckCoverObject:
	checkevent EVENT_HO_OH_WORD_ROOM_COVER_WALL_OPEN
	iftrue .CoverWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_COVER_FOSSIL
	sjump .CheckJawObject
.CoverWallOpen:
	checkevent EVENT_PICKED_UP_COVER_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .CheckJawObject
	appear RUINSOFALPHHOOHWORDROOM_COVER_FOSSIL
.CheckJawObject:
	checkevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	iftrue .JawWallOpen
	disappear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
	return
.JawWallOpen:
	checkevent EVENT_PICKED_UP_JAW_FOSSIL_FROM_HO_OH_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
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

RuinsOfAlphHoOhWordRoomCoverWall:
	checkevent EVENT_HO_OH_WORD_ROOM_COVER_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphHoOhWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 8, 0, $41
	reloadmappart
	setevent EVENT_HO_OH_WORD_ROOM_COVER_WALL_OPEN
	appear RUINSOFALPHHOOHWORDROOM_COVER_FOSSIL
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
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_HO_OH_WORD_ROOM_JAW_WALL_OPEN
	appear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
.Done:
	end

RuinsOfAlphHoOhWordRoomSkullFossil:
	opentext
	giveitem SKULL_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_SKULL_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotSkullFossilText
	sjump RuinsOfAlphHoOhWordRoomFinishFossil

RuinsOfAlphHoOhWordRoomCoverFossil:
	opentext
	giveitem COVER_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_COVER_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotCoverFossilText
	sjump RuinsOfAlphHoOhWordRoomFinishFossil

RuinsOfAlphHoOhWordRoomJawFossil:
	opentext
	giveitem JAW_FOSSIL
	iffalse RuinsOfAlphHoOhWordRoomFossilPocketFull
	disappear RUINSOFALPHHOOHWORDROOM_JAW_FOSSIL
	writetext RuinsOfAlphHoOhWordRoomGotJawFossilText

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

RuinsOfAlphHoOhWordRoomGotCoverFossilText:
	text "<PLAYER> got the"
	line "COVER FOSSIL!"
	done

RuinsOfAlphHoOhWordRoomGotJawFossilText:
	text "<PLAYER> got the"
	line "JAW FOSSIL!"
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
	bg_event  8,  0, BGEVENT_UP, RuinsOfAlphHoOhWordRoomCoverWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphHoOhWordRoomJawWall

	db 3 ; object events
	object_event  2,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomSkullFossil, EVENT_PICKED_UP_SKULL_FOSSIL_FROM_HO_OH_WORD_ROOM
	object_event  8,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomCoverFossil, EVENT_PICKED_UP_COVER_FOSSIL_FROM_HO_OH_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphHoOhWordRoomJawFossil, EVENT_PICKED_UP_JAW_FOSSIL_FROM_HO_OH_WORD_ROOM

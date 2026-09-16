	object_const_def
	const RUINSOFALPHOMANYTEWORDROOM_OLD_AMBER
	const RUINSOFALPHOMANYTEWORDROOM_PLUME_FOSSIL

RuinsOfAlphOmanyteWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_OMANYTE_WORD_ROOM_AMBER_WALL_OPEN
	iffalse .CheckPlumeWall
	changeblock 4, 0, $41
.CheckPlumeWall:
	checkevent EVENT_OMANYTE_WORD_ROOM_PLUME_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_OMANYTE_WORD_ROOM_AMBER_WALL_OPEN
	iftrue .AmberWallOpen
	disappear RUINSOFALPHOMANYTEWORDROOM_OLD_AMBER
	sjump .CheckPlumeObject
.AmberWallOpen:
	checkevent EVENT_PICKED_UP_OLD_AMBER_FROM_OMANYTE_WORD_ROOM
	iftrue .CheckPlumeObject
	appear RUINSOFALPHOMANYTEWORDROOM_OLD_AMBER
.CheckPlumeObject:
	checkevent EVENT_OMANYTE_WORD_ROOM_PLUME_WALL_OPEN
	iftrue .PlumeWallOpen
	disappear RUINSOFALPHOMANYTEWORDROOM_PLUME_FOSSIL
	return
.PlumeWallOpen:
	checkevent EVENT_PICKED_UP_PLUME_FOSSIL_FROM_OMANYTE_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHOMANYTEWORDROOM_PLUME_FOSSIL
.ObjectsDone:
	return

RuinsOfAlphOmanyteWordRoomAmberWall:
	checkevent EVENT_OMANYTE_WORD_ROOM_AMBER_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphOmanyteWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 4, 0, $41
	reloadmappart
	setevent EVENT_OMANYTE_WORD_ROOM_AMBER_WALL_OPEN
	appear RUINSOFALPHOMANYTEWORDROOM_OLD_AMBER
.Done:
	end

RuinsOfAlphOmanyteWordRoomPlumeWall:
	checkevent EVENT_OMANYTE_WORD_ROOM_PLUME_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphOmanyteWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_OMANYTE_WORD_ROOM_PLUME_WALL_OPEN
	appear RUINSOFALPHOMANYTEWORDROOM_PLUME_FOSSIL
.Done:
	end

RuinsOfAlphOmanyteWordRoomOldAmber:
	opentext
	giveitem OLD_AMBER
	iffalse RuinsOfAlphOmanyteWordRoomFossilPocketFull
	disappear RUINSOFALPHOMANYTEWORDROOM_OLD_AMBER
	writetext RuinsOfAlphOmanyteWordRoomGotOldAmberText
	sjump RuinsOfAlphOmanyteWordRoomFinishFossil

RuinsOfAlphOmanyteWordRoomPlumeFossil:
	opentext
	giveitem PLUME_FOSSIL
	iffalse RuinsOfAlphOmanyteWordRoomFossilPocketFull
	disappear RUINSOFALPHOMANYTEWORDROOM_PLUME_FOSSIL
	writetext RuinsOfAlphOmanyteWordRoomGotPlumeFossilText

RuinsOfAlphOmanyteWordRoomFinishFossil:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	end

RuinsOfAlphOmanyteWordRoomFossilPocketFull:
	pocketisfull
	closetext
	end

RuinsOfAlphOmanyteWordRoomWallCrumblesText:
	text "The wall crumbles"
	line "away!"
	done

RuinsOfAlphOmanyteWordRoomGotOldAmberText:
	text "<PLAYER> got the"
	line "OLD AMBER!"
	done

RuinsOfAlphOmanyteWordRoomGotPlumeFossilText:
	text "<PLAYER> got the"
	line "PLUME FOSSIL!"
	done

RuinsOfAlphOmanyteWordRoom_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9,  7, RUINS_OF_ALPH_OMANYTE_ITEM_ROOM, 3
	warp_event 10,  7, RUINS_OF_ALPH_OMANYTE_ITEM_ROOM, 4
	warp_event 17, 13, RUINS_OF_ALPH_INNER_CHAMBER, 6

	db 0 ; coord events

	db 2 ; bg events
	bg_event  4,  0, BGEVENT_UP, RuinsOfAlphOmanyteWordRoomAmberWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphOmanyteWordRoomPlumeWall

	db 2 ; object events
	object_event  4,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphOmanyteWordRoomOldAmber, EVENT_PICKED_UP_OLD_AMBER_FROM_OMANYTE_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphOmanyteWordRoomPlumeFossil, EVENT_PICKED_UP_PLUME_FOSSIL_FROM_OMANYTE_WORD_ROOM

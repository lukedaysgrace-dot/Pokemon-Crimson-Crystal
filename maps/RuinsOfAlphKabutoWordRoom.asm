	object_const_def
	const RUINSOFALPHKABUTOWORDROOM_DOME_FOSSIL
	const RUINSOFALPHKABUTOWORDROOM_HELIX_FOSSIL
	const RUINSOFALPHKABUTOWORDROOM_ROOT_FOSSIL

RuinsOfAlphKabutoWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_KABUTO_WORD_ROOM_DOME_WALL_OPEN
	iffalse .CheckHelixWall
	changeblock 2, 0, $41
.CheckHelixWall:
	checkevent EVENT_KABUTO_WORD_ROOM_HELIX_WALL_OPEN
	iffalse .CheckRootWall
	changeblock 8, 0, $41
.CheckRootWall:
	checkevent EVENT_KABUTO_WORD_ROOM_ROOT_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_KABUTO_WORD_ROOM_DOME_WALL_OPEN
	iftrue .DomeWallOpen
	disappear RUINSOFALPHKABUTOWORDROOM_DOME_FOSSIL
	sjump .CheckHelixObject
.DomeWallOpen:
	checkevent EVENT_PICKED_UP_DOME_FOSSIL_FROM_KABUTO_WORD_ROOM
	iftrue .CheckHelixObject
	appear RUINSOFALPHKABUTOWORDROOM_DOME_FOSSIL
.CheckHelixObject:
	checkevent EVENT_KABUTO_WORD_ROOM_HELIX_WALL_OPEN
	iftrue .HelixWallOpen
	disappear RUINSOFALPHKABUTOWORDROOM_HELIX_FOSSIL
	sjump .CheckRootObject
.HelixWallOpen:
	checkevent EVENT_PICKED_UP_HELIX_FOSSIL_FROM_KABUTO_WORD_ROOM
	iftrue .CheckRootObject
	appear RUINSOFALPHKABUTOWORDROOM_HELIX_FOSSIL
.CheckRootObject:
	checkevent EVENT_KABUTO_WORD_ROOM_ROOT_WALL_OPEN
	iftrue .RootWallOpen
	disappear RUINSOFALPHKABUTOWORDROOM_ROOT_FOSSIL
	return
.RootWallOpen:
	checkevent EVENT_PICKED_UP_ROOT_FOSSIL_FROM_KABUTO_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHKABUTOWORDROOM_ROOT_FOSSIL
.ObjectsDone:
	return

RuinsOfAlphKabutoWordRoomDomeWall:
	checkevent EVENT_KABUTO_WORD_ROOM_DOME_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphKabutoWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 2, 0, $41
	reloadmappart
	setevent EVENT_KABUTO_WORD_ROOM_DOME_WALL_OPEN
	appear RUINSOFALPHKABUTOWORDROOM_DOME_FOSSIL
.Done:
	end

RuinsOfAlphKabutoWordRoomHelixWall:
	checkevent EVENT_KABUTO_WORD_ROOM_HELIX_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphKabutoWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 8, 0, $41
	reloadmappart
	setevent EVENT_KABUTO_WORD_ROOM_HELIX_WALL_OPEN
	appear RUINSOFALPHKABUTOWORDROOM_HELIX_FOSSIL
.Done:
	end

RuinsOfAlphKabutoWordRoomRootWall:
	checkevent EVENT_KABUTO_WORD_ROOM_ROOT_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphKabutoWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_KABUTO_WORD_ROOM_ROOT_WALL_OPEN
	appear RUINSOFALPHKABUTOWORDROOM_ROOT_FOSSIL
.Done:
	end

RuinsOfAlphKabutoWordRoomDomeFossil:
	opentext
	giveitem DOME_FOSSIL
	iffalse RuinsOfAlphKabutoWordRoomFossilPocketFull
	disappear RUINSOFALPHKABUTOWORDROOM_DOME_FOSSIL
	writetext RuinsOfAlphKabutoWordRoomGotDomeFossilText
	sjump RuinsOfAlphKabutoWordRoomFinishFossil

RuinsOfAlphKabutoWordRoomHelixFossil:
	opentext
	giveitem HELIX_FOSSIL
	iffalse RuinsOfAlphKabutoWordRoomFossilPocketFull
	disappear RUINSOFALPHKABUTOWORDROOM_HELIX_FOSSIL
	writetext RuinsOfAlphKabutoWordRoomGotHelixFossilText
	sjump RuinsOfAlphKabutoWordRoomFinishFossil

RuinsOfAlphKabutoWordRoomRootFossil:
	opentext
	giveitem ROOT_FOSSIL
	iffalse RuinsOfAlphKabutoWordRoomFossilPocketFull
	disappear RUINSOFALPHKABUTOWORDROOM_ROOT_FOSSIL
	writetext RuinsOfAlphKabutoWordRoomGotRootFossilText

RuinsOfAlphKabutoWordRoomFinishFossil:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	end

RuinsOfAlphKabutoWordRoomFossilPocketFull:
	pocketisfull
	closetext
	end

RuinsOfAlphKabutoWordRoomWallCrumblesText:
	text "The wall crumbles"
	line "away!"
	done

RuinsOfAlphKabutoWordRoomGotDomeFossilText:
	text "<PLAYER> got the"
	line "DOME FOSSIL!"
	done

RuinsOfAlphKabutoWordRoomGotHelixFossilText:
	text "<PLAYER> got the"
	line "HELIX FOSSIL!"
	done

RuinsOfAlphKabutoWordRoomGotRootFossilText:
	text "<PLAYER> got the"
	line "ROOT FOSSIL!"
	done

RuinsOfAlphKabutoWordRoom_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9,  5, RUINS_OF_ALPH_KABUTO_ITEM_ROOM, 3
	warp_event 10,  5, RUINS_OF_ALPH_KABUTO_ITEM_ROOM, 4
	warp_event 17, 11, RUINS_OF_ALPH_INNER_CHAMBER, 4

	db 0 ; coord events

	db 3 ; bg events
	bg_event  2,  0, BGEVENT_UP, RuinsOfAlphKabutoWordRoomDomeWall
	bg_event  8,  0, BGEVENT_UP, RuinsOfAlphKabutoWordRoomHelixWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphKabutoWordRoomRootWall

	db 3 ; object events
	object_event  2,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphKabutoWordRoomDomeFossil, EVENT_PICKED_UP_DOME_FOSSIL_FROM_KABUTO_WORD_ROOM
	object_event  8,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphKabutoWordRoomHelixFossil, EVENT_PICKED_UP_HELIX_FOSSIL_FROM_KABUTO_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphKabutoWordRoomRootFossil, EVENT_PICKED_UP_ROOT_FOSSIL_FROM_KABUTO_WORD_ROOM

	object_const_def
	const RUINSOFALPHAERODACTYLWORDROOM_DOME_FOSSIL
	const RUINSOFALPHAERODACTYLWORDROOM_HELIX_FOSSIL
	const RUINSOFALPHAERODACTYLWORDROOM_ROOT_FOSSIL

RuinsOfAlphAerodactylWordRoom_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .FossilWalls
	callback MAPCALLBACK_OBJECTS, .FossilObjects

.FossilWalls:
	checkevent EVENT_AERODACTYL_WORD_ROOM_DOME_WALL_OPEN
	iffalse .CheckHelixWall
	changeblock 2, 0, $41
.CheckHelixWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_HELIX_WALL_OPEN
	iffalse .CheckRootWall
	changeblock 8, 0, $41
.CheckRootWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ROOT_WALL_OPEN
	iffalse .WallsDone
	changeblock 16, 0, $41
.WallsDone:
	return

.FossilObjects:
	checkevent EVENT_AERODACTYL_WORD_ROOM_DOME_WALL_OPEN
	iftrue .DomeWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_DOME_FOSSIL
	sjump .CheckHelixObject
.DomeWallOpen:
	checkevent EVENT_PICKED_UP_DOME_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .CheckHelixObject
	appear RUINSOFALPHAERODACTYLWORDROOM_DOME_FOSSIL
.CheckHelixObject:
	checkevent EVENT_AERODACTYL_WORD_ROOM_HELIX_WALL_OPEN
	iftrue .HelixWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_HELIX_FOSSIL
	sjump .CheckRootObject
.HelixWallOpen:
	checkevent EVENT_PICKED_UP_HELIX_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .CheckRootObject
	appear RUINSOFALPHAERODACTYLWORDROOM_HELIX_FOSSIL
.CheckRootObject:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ROOT_WALL_OPEN
	iftrue .RootWallOpen
	disappear RUINSOFALPHAERODACTYLWORDROOM_ROOT_FOSSIL
	return
.RootWallOpen:
	checkevent EVENT_PICKED_UP_ROOT_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	iftrue .ObjectsDone
	appear RUINSOFALPHAERODACTYLWORDROOM_ROOT_FOSSIL
.ObjectsDone:
	return

RuinsOfAlphAerodactylWordRoomDomeWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_DOME_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 2, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_DOME_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_DOME_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomHelixWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_HELIX_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 8, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_HELIX_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_HELIX_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomRootWall:
	checkevent EVENT_AERODACTYL_WORD_ROOM_ROOT_WALL_OPEN
	iftrue .Done
	opentext
	writetext RuinsOfAlphAerodactylWordRoomWallCrumblesText
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 40
	changeblock 16, 0, $41
	reloadmappart
	setevent EVENT_AERODACTYL_WORD_ROOM_ROOT_WALL_OPEN
	appear RUINSOFALPHAERODACTYLWORDROOM_ROOT_FOSSIL
.Done:
	end

RuinsOfAlphAerodactylWordRoomDomeFossil:
	opentext
	giveitem DOME_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_DOME_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotDomeFossilText
	sjump RuinsOfAlphAerodactylWordRoomFinishFossil

RuinsOfAlphAerodactylWordRoomHelixFossil:
	opentext
	giveitem HELIX_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_HELIX_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotHelixFossilText
	sjump RuinsOfAlphAerodactylWordRoomFinishFossil

RuinsOfAlphAerodactylWordRoomRootFossil:
	opentext
	giveitem ROOT_FOSSIL
	iffalse RuinsOfAlphAerodactylWordRoomFossilPocketFull
	disappear RUINSOFALPHAERODACTYLWORDROOM_ROOT_FOSSIL
	writetext RuinsOfAlphAerodactylWordRoomGotRootFossilText

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

RuinsOfAlphAerodactylWordRoomGotDomeFossilText:
	text "<PLAYER> got the"
	line "DOME FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoomGotHelixFossilText:
	text "<PLAYER> got the"
	line "HELIX FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoomGotRootFossilText:
	text "<PLAYER> got the"
	line "ROOT FOSSIL!"
	done

RuinsOfAlphAerodactylWordRoom_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9,  5, RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, 3
	warp_event 10,  5, RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, 4
	warp_event 17, 11, RUINS_OF_ALPH_INNER_CHAMBER, 8

	db 0 ; coord events

	db 3 ; bg events
	bg_event  2,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomDomeWall
	bg_event  8,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomHelixWall
	bg_event 16,  0, BGEVENT_UP, RuinsOfAlphAerodactylWordRoomRootWall

	db 3 ; object events
	object_event  2,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomDomeFossil, EVENT_PICKED_UP_DOME_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	object_event  8,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomHelixFossil, EVENT_PICKED_UP_HELIX_FOSSIL_FROM_AERODACTYL_WORD_ROOM
	object_event 16,  0, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphAerodactylWordRoomRootFossil, EVENT_PICKED_UP_ROOT_FOSSIL_FROM_AERODACTYL_WORD_ROOM

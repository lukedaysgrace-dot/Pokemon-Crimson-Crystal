	object_const_def ; object_event constants
	const PLAYERSHOUSE2F_CONSOLE
	const PLAYERSHOUSE2F_DOLL_1
	const PLAYERSHOUSE2F_DOLL_2
	const PLAYERSHOUSE2F_BIG_DOLL

PlayersHouse2F_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .InitializeRoom
	callback MAPCALLBACK_TILES, .SetSpawn

; unused
.Null:
	end

.InitializeRoom:
	special ToggleDecorationsVisibility
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8
	checkevent EVENT_INITIALIZED_EVENTS
	iftrue .SkipInitialization
	jumpstd initializeevents
	return

.SkipInitialization:
	return

.SetSpawn:
	special ToggleMaptileDecorations
	return

	db 0, 0, 0 ; filler

Doll1Script:
	describedecoration DECODESC_LEFT_DOLL

Doll2Script:
	describedecoration DECODESC_RIGHT_DOLL

BigDollScript:
	describedecoration DECODESC_BIG_DOLL

GameConsoleScript:
	describedecoration DECODESC_CONSOLE

PlayersHousePosterScript:
	conditional_event EVENT_PLAYERS_ROOM_POSTER, .Script

.Script:
	describedecoration DECODESC_POSTER

PlayersHouseRadioScript:
	opentext
	writetext PlayersRadioMusicPlayerText
	callasm PlayersHouseMusicPlayer
	iftrue .NormalRadio
	closetext
	special RestartMapMusic
	end

.NormalRadio:
	closetext
	special RestartMapMusic
	sjump PlayersHouseNormalRadioScript

PlayersHouseNormalRadioScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue .NormalRadio
	checkevent EVENT_LISTENED_TO_INITIAL_RADIO
	iftrue .AbbreviatedRadio
	playmusic MUSIC_POKEMON_TALK
	opentext
	writetext PlayersRadioText1
	pause 45
	writetext PlayersRadioText2
	pause 45
	writetext PlayersRadioText3
	pause 45
	musicfadeout MUSIC_NEW_BARK_TOWN, 16
	writetext PlayersRadioText4
	pause 45
	closetext
	setevent EVENT_LISTENED_TO_INITIAL_RADIO
	end

.NormalRadio:
	jumpstd radio1

.AbbreviatedRadio:
	opentext
	writetext PlayersRadioText4
	pause 45
	closetext
	end

PlayersHouseMusicPlayer:
; Keep the menu open while playing, with no story or badge requirements.
	call LoadStandardMenuHeader
	ld hl, .MenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	call UpdateSprites
	call HideSprites
	xor a
	ld [wMenuScrollPosition], a
	ld a, 1
	ld [wMenuCursorBuffer], a
.ChooseSong:
	call ScrollingMenu
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .Cancel
	ld a, [wMenuSelection]
	cp (.SongsEnd - .Songs) / 2
	jr z, .NormalRadio
	add a
	ld e, a
	ld d, 0
	ld hl, .Songs
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	xor a
	ld [wMusicFade], a
	call MaxVolume
	pop de
	call PlayMusic
	; ScrollingMenu initializes its cursor from this buffer on each call.
	ld a, [wMenuCursorY]
	ld [wMenuCursorBuffer], a
	jr .ChooseSong

.Cancel:
	call CloseWindow
	xor a
	ld [wScriptVar], a
	ret

.NormalRadio:
	call CloseWindow
	ld a, TRUE
	ld [wScriptVar], a
	ret

.MenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 1, 1, SCREEN_WIDTH - 2, TEXTBOX_Y - 2
	dw .MenuData
	db 1

.MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS
	db 5, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL
	dbw BANK(.SongList), .SongList
	dba .PlaceSongName
	dba NULL
	dba NULL

.PlaceSongName:
	push de
	ld a, [wMenuSelection]
	ld hl, .SongNames
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	jp PlaceString

.Songs:
	dw MUSIC_GREEN_ENCOUNTER
	dw MUSIC_GREEN_BATTLE
	dw MUSIC_MEET_BLUE_CLOAK
	dw MUSIC_BLUE_CLOAK_BATTLE
	dw MUSIC_HUDSON_HAWK_TITLE
	dw MUSIC_LUGIAS_SONG
	dw MUSIC_SILENT_CRYPT
	dw MUSIC_UNDERGROUND_PATH
	dw MUSIC_CERULEAN_CAVE_RBY
	dw MUSIC_CRYSTAL_ENCOUNTER
	dw MUSIC_CRYSTAL_BATTLE
	dw MUSIC_GOLDENROD_CITY
	dw MUSIC_MAHOGANY_TOWN
	dw MUSIC_ROUTE_38_39
	dw MUSIC_LAVENDER
.SongsEnd:

.SongList:
	db (.SongsEnd - .Songs) / 2 + 1
FOR song, 0, (.SongsEnd - .Songs) / 2 + 1
	db song
ENDR
	db -1 ; CANCEL

.SongNames:
	db "GREEN ENCOUNTER@"
	db "GREEN BATTLE@"
	db "BLUECLOAK MEET@"
	db "BLUECLOAK BATTLE@"
	db "HUDSON HAWK@"
	db "LUGIA'S SONG@"
	db "SILENT CRYPT@"
	db "UNDERGROUND PATH@"
	db "CERULEAN CAVE@"
	db "CRYSTAL ENCOUNTER@"
	db "CRYSTAL BATTLE@"
	db "GOLDENROD CITY@"
	db "MAHOGANY TOWN@"
	db "ROUTE 38-39@"
	db "LAVENDER@"
	db "NORMAL RADIO@"

PlayersRadioMusicPlayerText:
	text "Extra music."
	line "A: Play  B: Exit."
	done

PlayersHouseBookshelfScript:
	jumpstd picturebookshelf

PlayersHousePCScript:
	opentext
	special PlayersHousePC
	iftrue .Warp
	closetext
	end
.Warp:
	warp NONE, 0, 0
	end

PlayersRadioText1:
	text "PROF.OAK'S #MON"
	line "TALK! Please tune"
	cont "in next time!"
	done

PlayersRadioText2:
	text "#MON CHANNEL!"
	done

PlayersRadioText3:
	text "This is DJ MARY,"
	line "your co-host!"
	done

PlayersRadioText4:
	text "#MON!"
	line "#MON CHANNEL…"
	done

PlayersHouse2F_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  7,  0, PLAYERS_HOUSE_1F, 3

	db 0 ; coord events

	db 4 ; bg events
	bg_event  2,  1, BGEVENT_UP, PlayersHousePCScript
	bg_event  3,  1, BGEVENT_READ, PlayersHouseRadioScript
	bg_event  5,  1, BGEVENT_READ, PlayersHouseBookshelfScript
	bg_event  6,  0, BGEVENT_IFSET, PlayersHousePosterScript

	db 4 ; object events
	object_event  4,  2, SPRITE_CONSOLE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GameConsoleScript, EVENT_PLAYERS_HOUSE_2F_CONSOLE
	object_event  4,  4, SPRITE_DOLL_1, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Doll1Script, EVENT_PLAYERS_HOUSE_2F_DOLL_1
	object_event  5,  4, SPRITE_DOLL_2, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Doll2Script, EVENT_PLAYERS_HOUSE_2F_DOLL_2
	object_event  0,  1, SPRITE_BIG_DOLL, SPRITEMOVEDATA_BIGDOLL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BigDollScript, EVENT_PLAYERS_HOUSE_2F_BIG_DOLL

	object_const_def ; object_event constants
	const LORELEISROOM_LORELEI

LoreleisRoom_MapScripts:
	db 2 ; scene scripts
	scene_script .LockDoor ; SCENE_DEFAULT
	scene_script .DummyScene ; SCENE_FINISHED

	db 1 ; callbacks
	callback MAPCALLBACK_TILES, .LoreleisRoomDoors

.LockDoor:
	prioritysjump .LoreleisDoorLocksBehindYou
	end

.DummyScene:
	end

.LoreleisRoomDoors:
	checkevent EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED
	iffalse .KeepEntranceOpen
	changeblock 4, 14, $2f ; ice wall seals the way
.KeepEntranceOpen:
	checkevent EVENT_LORELEIS_ROOM_EXIT_OPEN
	iffalse .KeepExitClosed
	changeblock 4, 2, $2e ; ice door opens
.KeepExitClosed:
	return

.LoreleisDoorLocksBehindYou:
	applymovement PLAYER, LoreleisRoom_EnterMovement
	refreshscreen $86
	playsound SFX_STRENGTH
	earthquake 80
	changeblock 4, 14, $2f ; ice wall seals the way
	reloadmappart
	closetext
	setscene SCENE_FINISHED
	setevent EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED
	waitsfx
	end

LoreleiScript_Battle:
	faceplayer
	opentext
	checkevent EVENT_BEAT_ELITE_4_LORELEI
	iftrue LoreleiScript_AfterBattle
	writetext LoreleiScript_LoreleiBeforeText
	waitbutton
	closetext
	winlosstext LoreleiScript_LoreleiBeatenText, 0
	farscall CheckJohtoRematchesScript
	iftrue .LoadRematchTeam
	loadtrainer LORELEI, LORELEI1
	sjump .StartBattle
.LoadRematchTeam:
	loadtrainer LORELEI_REMATCH, LORELEI2
.StartBattle:
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ELITE_4_LORELEI
	opentext
	writetext LoreleiScript_LoreleiDefeatText
	waitbutton
	closetext
	playsound SFX_ENTER_DOOR
	changeblock 4, 2, $2e ; ice door opens
	reloadmappart
	closetext
	setevent EVENT_LORELEIS_ROOM_EXIT_OPEN
	waitsfx
	end

LoreleiScript_AfterBattle:
	writetext LoreleiScript_LoreleiDefeatText
	waitbutton
	closetext
	end

LoreleisRoom_EnterMovement:
	step UP
	step UP
	step UP
	step UP
	step_end

LoreleiScript_LoreleiBeforeText:
	text "I am LORELEI of"
	line "the ELITE FOUR."

	para "You've done well"
	line "to come this far."

	para "No one can best me"
	line "when it comes to"
	cont "icy #MON!"

	para "Freezing moves"
	line "are powerful."

	para "Your #MON will"
	line "be at my mercy!"

	para "Are you ready?"
	done

LoreleiScript_LoreleiBeatenText:
	text "How dare you!"
	done

LoreleiScript_LoreleiDefeatText:
	text "You're better than"
	line "I thought."

	para "Go on--the CHAM-"
	line "PION is waiting."
	done

LoreleisRoom_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4, 17, KARENS_ROOM, 3
	warp_event  5, 17, KARENS_ROOM, 4
	warp_event  4,  2, LANCES_ROOM, 1
	warp_event  5,  2, LANCES_ROOM, 2

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event  5,  7, SPRITE_LORELEI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LoreleiScript_Battle, -1

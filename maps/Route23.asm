	object_const_def ; object_event constants
	const ROUTE23_GRAMPS

Route23_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint
	callback MAPCALLBACK_OBJECTS, .GrampsBlock

.FlyPoint:
	setflag ENGINE_FLYPOINT_INDIGO_PLATEAU
	return

.GrampsBlock:
; Once the ELITE FOUR have been beaten the first time they retreat to train,
; and GRAMPS guards the POKECENTER doors until the CLAIR rematch is won --
; the same gate that lets SILVER's ambush inside commence (see
; PlateauRivalBattle1 in maps/IndigoPlateauPokecenter1F.asm).
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .NoGramps
	checkevent EVENT_BEAT_CLAIR_REMATCH
	iftrue .NoGramps
	appear ROUTE23_GRAMPS
	return

.NoGramps:
	disappear ROUTE23_GRAMPS
	return

Route23GrampsScript:
; Talking to him from the side gives the same brush-off as the triggers.
	faceplayer
	opentext
	writetext Route23GrampsText
	waitbutton
	closetext
	turnobject ROUTE23_GRAMPS, DOWN
	end

Route23GrampsLeftDoorTrigger:
; The player stepped in front of the left door; GRAMPS is already there.
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .DontBlock
	checkevent EVENT_BEAT_CLAIR_REMATCH
	iftrue .DontBlock
	turnobject PLAYER, UP
	turnobject ROUTE23_GRAMPS, DOWN
	opentext
	writetext Route23GrampsText
	waitbutton
	closetext
	playsound SFX_TACKLE
	applymovement PLAYER, Route23GrampsKickDownMovement
.DontBlock:
	end

Route23GrampsRightDoorTrigger:
; The player stepped in front of the right door; GRAMPS slides over to block
; it, sends them packing, then shuffles back to his post.
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .DontBlock
	checkevent EVENT_BEAT_CLAIR_REMATCH
	iftrue .DontBlock
	turnobject PLAYER, UP
	applymovement ROUTE23_GRAMPS, Route23GrampsSlideRightMovement
	turnobject ROUTE23_GRAMPS, DOWN
	opentext
	writetext Route23GrampsText
	waitbutton
	closetext
	playsound SFX_TACKLE
	applymovement PLAYER, Route23GrampsKickDownMovement
	applymovement ROUTE23_GRAMPS, Route23GrampsSlideLeftMovement
	turnobject ROUTE23_GRAMPS, DOWN
.DontBlock:
	end

Route23GrampsSideTrigger:
; Sneaking along the wall from the east lands the player right in the
; doorway tile itself, so GRAMPS calls them out and boots them back east.
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .DontBlock
	checkevent EVENT_BEAT_CLAIR_REMATCH
	iftrue .DontBlock
	turnobject PLAYER, LEFT
	turnobject ROUTE23_GRAMPS, RIGHT
	opentext
	writetext Route23GrampsText
	waitbutton
	closetext
	playsound SFX_TACKLE
	applymovement PLAYER, Route23GrampsKickRightMovement
	turnobject ROUTE23_GRAMPS, DOWN
.DontBlock:
	end

Route23GrampsSlideRightMovement:
	step RIGHT
	step_end

Route23GrampsSlideLeftMovement:
	step LEFT
	step_end

Route23GrampsKickDownMovement:
	jump_step DOWN
	step_end

Route23GrampsKickRightMovement:
	jump_step RIGHT
	step_end

IndigoPlateauSign:
	jumptext IndigoPlateauSignText

Route23GrampsText:
	text "Hohoho, the"
	line "ELITE FOUR are"
	cont "currently"
	cont "training, kid."

	para "Come back after"
	line "you've managed"
	cont "to beat all of"
	cont "JOHTO's GYM"
	cont "LEADERS at their"
	cont "full strength."
	done

IndigoPlateauSignText:
	text "INDIGO PLATEAU"

	para "The Ultimate Goal"
	line "for Trainers!"

	para "#MON LEAGUE HQ"
	done

Route23_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  9,  5, INDIGO_PLATEAU_POKECENTER_1F, 1
	warp_event 10,  5, INDIGO_PLATEAU_POKECENTER_1F, 2
	warp_event  9, 13, VICTORY_ROAD, 10
	warp_event 10, 13, VICTORY_ROAD, 10

	db 3 ; coord events
	coord_event  9,  7, -1, Route23GrampsLeftDoorTrigger
	coord_event 10,  7, -1, Route23GrampsRightDoorTrigger
	coord_event 10,  6, -1, Route23GrampsSideTrigger

	db 1 ; bg events
	bg_event 11,  7, BGEVENT_READ, IndigoPlateauSign

	db 1 ; object events
	object_event  9,  6, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23GrampsScript, EVENT_ROUTE_23_POKECENTER_GRAMPS

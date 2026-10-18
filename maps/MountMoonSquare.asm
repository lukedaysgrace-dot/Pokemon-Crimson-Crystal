	object_const_def ; object_event constants
	const MOUNTMOONSQUARE_FAIRY1
	const MOUNTMOONSQUARE_FAIRY2
	const MOUNTMOONSQUARE_ROCK

MountMoonSquare_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene ; SCENE_DEFAULT

	db 3 ; callbacks
	callback MAPCALLBACK_NEWMAP, .DisappearMoonStone
	callback MAPCALLBACK_OBJECTS, .DisappearRock
	callback MAPCALLBACK_TILES, .CraterTiles

.DummyScene:
	end

.DisappearMoonStone:
	setevent EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE
	return

.DisappearRock:
	disappear MOUNTMOONSQUARE_ROCK
	return

.CraterTiles:
	checkevent EVENT_MT_MOON_WISHING_STAR_CRASHED
	iffalse .NoCrater
	changeblock 20, 14, $9f
.NoCrater:
	return

ClefairyDance:
	checkflag ENGINE_MT_MOON_SQUARE_CLEFAIRY
	iftrue .NoDancing
	readvar VAR_WEEKDAY
	ifnotequal MONDAY, .NoDancing
	checktime NITE
	iffalse .NoDancing
	appear MOUNTMOONSQUARE_FAIRY1
	appear MOUNTMOONSQUARE_FAIRY2
	applymovement PLAYER, PlayerWalksUpToDancingClefairies
	pause 15
	appear MOUNTMOONSQUARE_ROCK
	turnobject MOUNTMOONSQUARE_FAIRY1, RIGHT
	cry CLEFAIRY
	waitsfx
	pause 30
	follow MOUNTMOONSQUARE_FAIRY1, MOUNTMOONSQUARE_FAIRY2
	cry CLEFAIRY
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep1
	cry CLEFAIRY
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep2
	cry CLEFAIRY
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep3
	cry CLEFAIRY
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep4
	cry CLEFAIRY
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep5
	stopfollow
	applymovement MOUNTMOONSQUARE_FAIRY2, ClefairyDanceStep6
	follow MOUNTMOONSQUARE_FAIRY1, MOUNTMOONSQUARE_FAIRY2
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyDanceStep7
	stopfollow
	turnobject MOUNTMOONSQUARE_FAIRY1, DOWN
	pause 10
	showemote EMOTE_SHOCK, MOUNTMOONSQUARE_FAIRY1, 15
	turnobject MOUNTMOONSQUARE_FAIRY1, DOWN
	cry CLEFAIRY
	pause 15
	follow MOUNTMOONSQUARE_FAIRY1, MOUNTMOONSQUARE_FAIRY2
	applymovement MOUNTMOONSQUARE_FAIRY1, ClefairyFleeMovement
	disappear MOUNTMOONSQUARE_FAIRY1
	disappear MOUNTMOONSQUARE_FAIRY2
	stopfollow
	clearevent EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE
	setflag ENGINE_MT_MOON_SQUARE_CLEFAIRY
	end

.NoDancing:
	end

MountMoonSquareHiddenMoonStone:
	hiddenitem MOON_STONE, EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE

MountMoonSquareWishingStarCrash::
	checkevent EVENT_MT_MOON_WISHING_STAR_CRASHED
	iftrue .Done
	checkitem STAR_PIECE
	iffalse .Done
	opentext
	writetext MountMoonSquareStarPieceGlowingText
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	special MtMoonOverworldWishingStar
	playsound SFX_EGG_BOMB
	earthquake 80
	waitsfx
	setevent EVENT_MT_MOON_WISHING_STAR_CRASHED
	changeblock 20, 14, $9f
	reloadmappart
	opentext
	writetext MountMoonSquareStarCrashedText
	waitbutton
	closetext
.Done:
	end

MountMoonSquareCraterApproach:
	scall MountMoonSquareConsumeStarPiece
	end

MountMoonSquareConsumeStarPiece:
	checkevent EVENT_MT_MOON_WISHING_STAR_CRASHED
	iffalse .Done
	checkevent EVENT_MT_MOON_STAR_PIECE_VANISHED
	iftrue .Done
	checkitem STAR_PIECE
	iffalse .Done
	takeitem STAR_PIECE
	setevent EVENT_MT_MOON_STAR_PIECE_VANISHED
	opentext
	writetext MountMoonSquareStarPieceVanishesText
	waitbutton
	closetext
.Done:
	return

MountMoonSquareMeteor:
	checkevent EVENT_MT_MOON_WISHING_STAR_CRASHED
	iffalse .End
	checkevent EVENT_GOT_WISHING_STAR
	iftrue .End
	scall MountMoonSquareConsumeStarPiece
	opentext
	writetext MountMoonSquareMeteorText
	waitbutton
	verbosegiveitem WISHING_STAR
	iffalse .Done
	setevent EVENT_GOT_WISHING_STAR
.Done:
	closetext
.End:
	end

MountMoonSquareStarPieceGlowingText:
	text "Your STAR PIECE"
	line "begins to glow!"
	done

MountMoonSquareStarCrashedText:
	text "You see something"
	line "crash nearby!"
	done

MountMoonSquareStarPieceVanishesText:
	text "Your STAR PIECE"
	line "vanishes as you"
	cont "approach the"
	cont "crater."
	done

MountMoonSquareMeteorText:
	text "There seems to be"
	line "a star-shaped"
	cont "object embedded"
	cont "in the rock."

	para "It's surprisingly"
	line "cool to the touch!"
	done

DontLitterSign:
	jumptext DontLitterSignText

MtMoonSquareRock:
	jumpstd smashrock

PlayerWalksUpToDancingClefairies:
	step UP
	step_end

ClefairyDanceStep1:
	slow_step DOWN
	slow_jump_step DOWN
	step_end

ClefairyDanceStep2:
	slow_jump_step RIGHT
	step_end

ClefairyDanceStep3:
	slow_step UP
	slow_jump_step UP
	step_end

ClefairyDanceStep4:
	slow_jump_step LEFT
	step_end

ClefairyDanceStep5:
	slow_step DOWN
	slow_jump_step DOWN
	step_end

ClefairyDanceStep6:
	slow_step DOWN
	step_end

ClefairyDanceStep7:
	slow_step RIGHT
	step_end

ClefairyFleeMovement:
	step RIGHT
	step RIGHT
	step RIGHT
	jump_step RIGHT
	step RIGHT
	step RIGHT
	step_end

DontLitterSignText:
	text "MT.MOON SQUARE"
	line "DON'T LITTER"
	done

MountMoonSquare_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event 20,  5, MOUNT_MOON, 5
	warp_event 22, 11, MOUNT_MOON, 6
	warp_event 13,  7, MOUNT_MOON_GIFT_SHOP, 1

	db 5 ; coord events
	coord_event  7, 11, SCENE_DEFAULT, ClefairyDance
	coord_event 20, 15, -1, MountMoonSquareCraterApproach
	coord_event 22, 15, -1, MountMoonSquareCraterApproach
	coord_event 21, 14, -1, MountMoonSquareCraterApproach
	coord_event 21, 16, -1, MountMoonSquareCraterApproach

	db 3 ; bg events
	bg_event  7,  7, BGEVENT_ITEM, MountMoonSquareHiddenMoonStone
	bg_event 17,  7, BGEVENT_READ, DontLitterSign
	bg_event 21, 15, BGEVENT_READ, MountMoonSquareMeteor

	db 3 ; object events
	object_event  6,  6, SPRITE_FAIRY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_MT_MOON_SQUARE_CLEFAIRY
	object_event  7,  6, SPRITE_FAIRY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_MT_MOON_SQUARE_CLEFAIRY
	object_event  7,  7, SPRITE_ROCK, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonSquareRock, EVENT_MT_MOON_SQUARE_ROCK

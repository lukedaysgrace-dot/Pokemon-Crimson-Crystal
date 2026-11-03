	object_const_def ; object_event constants
	const MAHOGANYMART1F_PHARMACIST
	const MAHOGANYMART1F_BLACK_BELT
	const MAHOGANYMART1F_LANCE
	const MAHOGANYMART1F_DRAGON
	const MAHOGANYMART1F_GRANNY

MahoganyMart1F_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene0 ; SCENE_MAHOGANYMART1F_NOTHING
	scene_script .LanceUncoversStaircase ; SCENE_MAHOGANYMART1F_LANCE_UNCOVERS_STAIRS

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .MahoganyMart1FStaircase
	callback MAPCALLBACK_OBJECTS, .Shopkeepers

.DummyScene0:
	end

.LanceUncoversStaircase:
	prioritysjump MahoganyMart1FLanceUncoversStaircaseScript
	end

.MahoganyMart1FStaircase:
	checkevent EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART
	iftrue .ShowStairs
	return

.ShowStairs:
	changeblock 6, 2, $1e ; stairs
	return

.Shopkeepers:
; Also refresh old saves whose hideout was cleared before the shop moved.
	checkevent EVENT_CLEARED_ROCKET_HIDEOUT
	iffalse .HideGranny
	setevent EVENT_MAHOGANY_MART_ROCKETS
	appear MAHOGANYMART1F_GRANNY
	return

.HideGranny:
	clearevent EVENT_MAHOGANY_MART_ROCKETS
	disappear MAHOGANYMART1F_GRANNY
	return

MahogayMart1FPharmacistScript:
	faceplayer
	opentext
	checkevent EVENT_DECIDED_TO_HELP_LANCE
	iftrue .LanceEntered
	pokemart MARTTYPE_STANDARD, MART_MAHOGANY_1
	closetext
	end

.LanceEntered:
	writetext MahogayMart1FPharmacistText_LanceEntered
	waitbutton
	closetext
	end

MahogayMart1FBlackBeltScript:
	faceplayer
	opentext
	checkevent EVENT_DECIDED_TO_HELP_LANCE
	iftrue .LanceEntered
	writetext MahogayMart1FBlackBeltText
	waitbutton
	closetext
	end

.LanceEntered:
	writetext MahogayMart1FBlackBeltText_LanceEntered
	waitbutton
	closetext
	end

MahoganyMart1FLanceUncoversStaircaseScript:
	pause 15
	opentext
	writetext UnknownText_0x6c52a
	pause 15
	closetext
	playsound SFX_TACKLE
	applymovement MAHOGANYMART1F_DRAGON, MovementData_0x6c3f6
	applymovement MAHOGANYMART1F_BLACK_BELT, MovementData_0x6c3fb
	pause 15
	applymovement MAHOGANYMART1F_LANCE, MovementData_0x6c407
	opentext
	writetext UnknownText_0x6c549
	waitbutton
	closetext
	; Line up Lance, Dragonite and the player before heading to the stairs.
	follow MAHOGANYMART1F_LANCE, MAHOGANYMART1F_DRAGON
	applymovement MAHOGANYMART1F_LANCE, MahoganyMartLanceLeadMovement
	stopfollow
	readvar VAR_XCOORD
	ifequal 4, .PlayerInLine
	applymovement PLAYER, MahoganyMartPlayerJoinMovement
.PlayerInLine:
	follow MAHOGANYMART1F_DRAGON, PLAYER
	callasm MahoganyMartProcessionFirstLeg
	callasm MahoganyMartStopLanceMovement
	applymovement MAHOGANYMART1F_PHARMACIST, MovementData_0x6c403
	callasm MahoganyMartProcessionSecondLeg
	callasm MahoganyMartStopLanceMovement
	stopfollow
	applymovement MAHOGANYMART1F_DRAGON, MahoganyMartDragonStepAsideMovement
	applymovement PLAYER, MahoganyMartPlayerJoinMovement
	turnobject MAHOGANYMART1F_LANCE, LEFT
	opentext
	writetext UnknownText_0x6c59e
	waitbutton
	showemote EMOTE_SHOCK, MAHOGANYMART1F_PHARMACIST, 10
	playsound SFX_FAINT
	changeblock 6, 2, $1e ; stairs
	reloadmappart
	closetext
	setevent EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART
	turnobject MAHOGANYMART1F_LANCE, LEFT
	opentext
	writetext UnknownText_0x6c5ba
	waitbutton
	closetext
	applymovement MAHOGANYMART1F_DRAGON, MahoganyMartDragonReturnMovement
	follow MAHOGANYMART1F_LANCE, MAHOGANYMART1F_DRAGON
	applymovement MAHOGANYMART1F_LANCE, MovementData_0x6c412
	stopfollow
	playsound SFX_EXIT_BUILDING
	disappear MAHOGANYMART1F_LANCE
	applymovement MAHOGANYMART1F_DRAGON, MovementData_0x6c412
	disappear MAHOGANYMART1F_DRAGON
	setscene SCENE_MAHOGANYMART1F_NOTHING
	waitsfx
	end

MahogayMart1FGrannyScript:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_MAHOGANY_2
	closetext
	end

MovementData_0x6c3f6:
	fix_facing
	big_step LEFT
	big_step RIGHT
	remove_fixed_facing
	step_end

MovementData_0x6c3fb:
	fix_facing
	big_step LEFT
	remove_fixed_facing
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	step_end

MovementData_0x6c403:
	fix_facing
	big_step LEFT
	remove_fixed_facing
	step_end

MovementData_0x6c407:
	turn_head DOWN
	step_end

MahoganyMartLanceLeadMovement:
	slow_step UP
	step_end

MahoganyMartPlayerJoinMovement:
	slow_step RIGHT
	step_end

MahoganyMartDragonFirstLegMovement:
	slow_step UP
	step_end

MahoganyMartDragonSecondLegMovement:
	slow_step UP
	slow_step UP
	slow_step RIGHT
	step_end

MahoganyMartDragonStepAsideMovement:
	slow_step UP
	turn_head DOWN
	step_end

MahoganyMartDragonReturnMovement:
	; Join Lance from above along the clear floor, avoiding the bookcase below.
	slow_step RIGHT
	step_end

MovementData_0x6c412:
	slow_step RIGHT
	step_end

; Only one ordinary follow pair exists. Dragonite leads the player while
; Lance walks a second, map-local RAM movement stream one tile ahead.
; wc2e6 is the existing secondary movement pointer (SPRITEMOVEDATA_0D).
MahoganyMartProcessionFirstLeg:
	ld hl, .LanceMovement
	ld bc, .End - .LanceMovement
	ld de, MahoganyMartDragonFirstLegMovement
	jr MahoganyMartStartProcession
.LanceMovement:
	slow_step UP
	step_sleep 255 ; park until the foreground Dragonite movement finishes
	step_loop
.End:

MahoganyMartProcessionSecondLeg:
	ld hl, .LanceMovement
	ld bc, .End - .LanceMovement
	ld de, MahoganyMartDragonSecondLegMovement
	jr MahoganyMartStartProcession
.LanceMovement:
	slow_step UP
	slow_step RIGHT
	slow_step RIGHT
	step_sleep 255
	step_loop
.End:

MahoganyMartStartProcession:
	push de
	ld de, wMovementBuffer
	call CopyBytes
	ld a, LOW(wMovementBuffer)
	ld [wc2e6], a
	ld a, HIGH(wMovementBuffer)
	ld [wc2e6 + 1], a
	ld c, MAHOGANYMART1F_DRAGON - 1 ; native map-object IDs omit the script player slot
	farcall SetFlagsForMovement_1
	ld c, MAHOGANYMART1F_DRAGON - 1
	farcall _SetFlagsForMovement_2
	ld a, MAHOGANYMART1F_LANCE - 1
	call CheckObjectVisibility
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res OBJ_FLAGS2_5, [hl]
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_0D
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	ld [hl], 0
	pop hl
	ld b, BANK(MahoganyMart1F_MapScripts)
	ld c, MAHOGANYMART1F_DRAGON - 1
	call GetMovementData
	ld a, SCRIPT_WAIT_MOVEMENT
	ld [wScriptMode], a
	ld hl, wScriptFlags
	res SCRIPT_RUNNING, [hl]
	ret

MahoganyMartStopLanceMovement:
	ld a, MAHOGANYMART1F_LANCE - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_STANDING_LEFT
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00
	ret

UnknownText_0x6c414:
	text "Hello, kiddo!"

	para "How would you like"
	line "some RAGECANDYBAR?"

	para "It's the thing to"
	line "eat in MAHOGANY!"
	done

MahogayMart1FPharmacistText_LanceEntered:
	text "Arrgh… You found"
	line "the secret stair-"
	cont "way…"
	done

MahogayMart1FBlackBeltText:
	text "Heheh! The experi-"
	line "ment worked like a"
	cont "charm."

	para "MAGIKARP are just"
	line "worthless, but"

	para "GYARADOS are big"
	line "moneymakers."
	done

MahogayMart1FBlackBeltText_LanceEntered:
	text "Urrgh…"

	para "That guy's dragon"
	line "#MON are tough…"
	done

UnknownText_0x6c52a:
	text "LANCE: DRAGONITE,"
	line "HYPER BEAM."
	done

UnknownText_0x6c549:
	text "What took you,"
	line "<PLAY_G>?"

	para "Just as I thought,"
	line "that strange radio"

	para "signal is coming"
	line "from here."
	done

UnknownText_0x6c59e:
	text "The stairs are"
	line "right here."
	done

UnknownText_0x6c5ba:
	text "LANCE: <PLAY_G>, we"
	line "should split up to"

	para "check this place."
	line "I'll go first."
	done

MahoganyMart1F_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  3,  7, MAHOGANY_TOWN, 1
	warp_event  4,  7, MAHOGANY_TOWN, 1
	warp_event  7,  3, TEAM_ROCKET_BASE_B1F, 1

	db 0 ; coord events

	db 0 ; bg events

	db 5 ; object events
	object_event  4,  3, SPRITE_PHARMACIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MahogayMart1FPharmacistScript, EVENT_MAHOGANY_MART_ROCKETS
	object_event  1,  6, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MahogayMart1FBlackBeltScript, EVENT_MAHOGANY_MART_ROCKETS
	object_event  4,  6, SPRITE_LANCE, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE
	object_event  3,  6, SPRITE_DRAGON, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE
	object_event  1,  3, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MahogayMart1FGrannyScript, EVENT_MAHOGANY_MART_OWNERS

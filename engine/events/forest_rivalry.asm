; Object IDs are stable map-event slots; constants in maps/ are bank-local.
DEF FOREST_ZANGOOSE EQU 10
DEF FOREST_SEVIPER1 EQU 11
DEF FOREST_SEVIPER2 EQU 12

ForestRivalryRestoreObjects::
; MAPCALLBACK_OBJECTS runs only when the forest is entered from outside
; (warps, Fly, Teleport, whiteout returns...), never after an in-forest
; battle or when continuing a save made inside it.
	checkevent EVENT_VIRIDIAN_FOREST_ZANGOOSE_GONE
	iftrue .Done
	checkevent EVENT_VIRIDIAN_FOREST_RIVALRY_SEEN
	iffalse .Done
	checkevent EVENT_VIRIDIAN_FOREST_SEVIPER_BEATEN
	iftrue .Survivor
	; The player saw the fight start and left (by any route, including a
	; whiteout) before helping. Zangoose did not survive; the snakes are gone.
	setevent EVENT_VIRIDIAN_FOREST_ZANGOOSE_PERISHED
	setevent EVENT_VIRIDIAN_FOREST_ZANGOOSE_GONE
	setevent EVENT_VIRIDIAN_FOREST_SEVIPER1_GONE
	setevent EVENT_VIRIDIAN_FOREST_SEVIPER2_GONE
	return

.Survivor:
	; Keep the survivor at its final spot after a whiteout against Zangoose.
	checkevent EVENT_VIRIDIAN_FOREST_SEVIPER1_GONE
	iffalse .Done
	checkevent EVENT_VIRIDIAN_FOREST_SEVIPER2_GONE
	iffalse .Done
	moveobject FOREST_ZANGOOSE, 3, 30
.Done:
	return

ForestRivalryTrigger::
	checkevent EVENT_VIRIDIAN_FOREST_RIVALRY_SEEN
	iftrue .Done
	turnobject PLAYER, LEFT
	cry ZANGOOSE
	waitsfx
	turnobject FOREST_ZANGOOSE, RIGHT
	callasm ForestRivalryLunge
	playsound SFX_TACKLE
	applymovement FOREST_SEVIPER2, ForestRivalryKnockback
	callasm ForestRivalryEndLunge
	cry SEVIPER
	waitsfx
	pause 15
	applymovement FOREST_SEVIPER2, ForestRivalryReturn
	setevent EVENT_VIRIDIAN_FOREST_RIVALRY_SEEN
.Done:
	end

ForestRivalrySeviper1::
	scall ForestRivalrySeviperBattle
	; A loss jumps out through the native whiteout script before returning.
	disappear FOREST_SEVIPER1
	setevent EVENT_VIRIDIAN_FOREST_SEVIPER1_GONE
	reloadmapafterbattle
	applymovement FOREST_SEVIPER2, ForestRivalryFleeUpper
	disappear FOREST_SEVIPER2
	setevent EVENT_VIRIDIAN_FOREST_SEVIPER2_GONE
	sjump ForestRivalryApproach

ForestRivalrySeviper2::
	; They trade lunges without leaving either tile. Only the lower snake
	; can start the encounter, so this interaction is safe to repeat.
	turnobject FOREST_ZANGOOSE, RIGHT
	turnobject FOREST_SEVIPER2, LEFT
	callasm ForestRivalryLunge
	playsound SFX_TACKLE
	callasm ForestRivalryEndLunge
	callasm ForestRivalrySeviperCounterLunge
	cry SEVIPER
	waitsfx
	end

ForestRivalrySeviperBattle:
	faceplayer
	opentext
	writetext ForestRivalrySeviperText
	cry SEVIPER
	waitsfx
	waitbutton
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_FOREST_RIVALRY
	loadwildmon SEVIPER, 50
	startbattle
	ifequal LOSE, .Whiteout
	; Neither Run, escape items, Teleport nor phazing can end this fight.
	setevent EVENT_VIRIDIAN_FOREST_SEVIPER_BEATEN
	return
.Whiteout:
	reloadmapafterbattle
	end

ForestRivalryApproach:
	applymovement FOREST_ZANGOOSE, ForestRivalryApproachEast
	sjump ForestRivalryZangooseBattle

ForestRivalryZangoose::
	checkevent EVENT_VIRIDIAN_FOREST_SEVIPER_BEATEN
	iftrue ForestRivalryZangooseBattle
	; Talking before crossing a trigger cannot bypass the Seviper encounter.
	opentext
	writetext ForestRivalryZangooseText
	cry ZANGOOSE
	waitsfx
	waitbutton
	closetext
	end

ForestRivalryZangooseBattle:
	turnobject FOREST_ZANGOOSE, DOWN
	turnobject PLAYER, UP
	opentext
	writetext ForestRivalryZangooseText
	cry ZANGOOSE
	waitsfx
	waitbutton
	writetext ForestRivalryScarredText
	waitbutton
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_FOREST_RIVALRY
	loadwildmon ZANGOOSE_SCARRED, 50
	startbattle
	ifequal LOSE, .Whiteout
	disappear FOREST_ZANGOOSE
	setevent EVENT_VIRIDIAN_FOREST_ZANGOOSE_GONE
	reloadmapafterbattle
	end
.Whiteout:
	reloadmapafterbattle
	end

ForestRivalryRemains::
	checkevent EVENT_VIRIDIAN_FOREST_ZANGOOSE_PERISHED
	iffalse .Nothing
	jumptext ForestRivalryRemainsText
.Nothing:
	end

ForestRivalryKnockback:
	fix_facing
	big_step RIGHT
	remove_fixed_facing
	step_end

ForestRivalryReturn:
	step LEFT
	step_end

ForestRivalryFleeUpper:
	remove_fixed_facing
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	step_end

ForestRivalryApproachEast:
	remove_fixed_facing
	step RIGHT
	turn_head DOWN
	fix_facing
	step_end

ForestRivalrySeviperText:
	text "SEVI!"
	done

ForestRivalryZangooseText:
	text "ZAN?"
	done

ForestRivalryScarredText:
	text "Its fur is scarred"
	line "from countless"
	cont "battles."

	para "Years of fighting"
	line "SEVIPER have"
	cont "hardened its body"
	cont "against venom."

	para "The poison it once"
	line "endured now"
	cont "courses through"
	cont "its own claws!"
	done

ForestRivalryRemainsText:
	text "Tufts of white fur"
	line "are scattered"
	cont "here."

	para "The grass is torn"
	line "up and stained a"
	cont "dark red."

	para "ZANGOOSE fought"
	line "its final battle"
	cont "here, alone."
	done

ForestRivalryLunge:
	ld a, FOREST_ZANGOOSE - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld b, 4
.Frame:
	ld a, [hl]
	add 3
	ld [hl], a
	push bc
	push hl
	call UpdateSprites
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec b
	jr nz, .Frame
	ret

ForestRivalryEndLunge:
	ld a, FOREST_ZANGOOSE - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], 0
	jp UpdateSprites

ForestRivalrySeviperCounterLunge:
	ld a, FOREST_SEVIPER2 - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld de, .Offsets
.Frame:
	ld a, [de]
	inc de
	cp $80
	ret z
	ld [hl], a
	push hl
	push de
	call UpdateSprites
	ld c, 2
	call DelayFrames
	pop de
	pop hl
	jr .Frame
.Offsets:
	db -3, -6, -9, -12, -9, -6, -3, 0, $80

LoadWimpodAndZangoosePalette::
	ld a, [wMapGroup]
	cp GROUP_VIRIDIAN_FOREST
	jr nz, .Wimpod
	ld a, [wMapNumber]
	cp MAP_VIRIDIAN_FOREST
	jr nz, .Wimpod
	; The forest has no rock-paletted object besides Zangoose. Match
	; Wimpod's opaque gray body, keeping Zangoose's red markings and black.
	ld hl, .GrayRed
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM
.Wimpod:
	farcall LoadRoute31WimpodPalette
	ret
.GrayRed:
	RGB 31,31,31, 24,24,24, 31,07,01, 00,00,00

GetCanonicalPokemonFlagIndex::
	call GetPokemonIndexFromID
	ld d, h
	ld e, l
	ld a, d
	cp HIGH(ZANGOOSE_SCARRED)
	ret nz
	ld a, e
	cp LOW(ZANGOOSE_SCARRED)
	ret nz
	ld de, ZANGOOSE
	ret

SetScarredZangooseEncounterMove::
	ld a, [wEnemyMonSpecies]
	call GetPokemonIndexFromID
	ld a, h
	cp HIGH(ZANGOOSE_SCARRED)
	ret nz
	ld a, l
	cp LOW(ZANGOOSE_SCARRED)
	ret nz
	ld hl, DIRE_CLAW
	call GetMoveIDFromIndex
	ld [wEnemyMonMoves], a
	ret

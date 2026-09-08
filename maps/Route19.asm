	object_const_def ; object_event constants
	const ROUTE19_SWIMMER_GIRL
	const ROUTE19_SWIMMER_GUY1
	const ROUTE19_SWIMMER_GUY2
	const ROUTE19_SWIMMER_GUY3
	const ROUTE19_FISHER1
	const ROUTE19_FISHER2
	const ROUTE19_MOLTRES
	const ROUTE19_ZAPDOS
	const ROUTE19_ARTICUNO

Route19_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_TILES, .ClearRocks
	callback MAPCALLBACK_OBJECTS, .HideLegendaryBirds

.ClearRocks:
	checkevent EVENT_CINNABAR_ROCKS_CLEARED
	iftrue .CheckIslandEntrances
	changeblock  6,  6, $7a ; rock
	changeblock  8,  6, $7a ; rock
	changeblock 10,  6, $7a ; rock
	changeblock 12,  8, $7a ; rock
	changeblock  4,  8, $7a ; rock
	changeblock 10, 10, $7a ; rock
.CheckIslandEntrances:
	checkevent EVENT_ROUTE_19_ELEMENTAL_SPHERE_PLACED
	iftrue .OpenIslandEntrances
	changeblock  6, 26, $9e ; sealed Fire Island cliff
	changeblock 14, 26, $9e ; sealed Thunder Island cliff
	changeblock 10, 32, $9e ; sealed Ice Island cliff
	return
.OpenIslandEntrances:
	changeblock  6, 26, $06 ; Fire Island cave
	changeblock 14, 26, $06 ; Thunder Island cave
	changeblock 10, 32, $06 ; Ice Island cave
.Done:
	return

.HideLegendaryBirds:
	disappear ROUTE19_MOLTRES
	disappear ROUTE19_ZAPDOS
	disappear ROUTE19_ARTICUNO
	return

Route19BirdStatue:
	opentext
	checkevent EVENT_ROUTE_19_ELEMENTAL_SPHERE_PLACED
	iftrue .SpherePlaced
	writetext Route19BirdStatueText
	waitbutton
	checkitem ELEMENTAL_SPHERE
	iffalse .CloseText
	writetext Route19PlaceElementalSphereText
	yesorno
	iffalse .CloseText
	takeitem ELEMENTAL_SPHERE
	writetext Route19ElementalSpherePlacedText
	waitbutton
	closetext
	setevent EVENT_ROUTE_19_ELEMENTAL_SPHERE_PLACED
	playsound SFX_STRENGTH
	earthquake 60
	changeblock  6, 26, $06 ; Fire Island cave
	changeblock 14, 26, $06 ; Thunder Island cave
	changeblock 10, 32, $06 ; Ice Island cave
	reloadmappart
	waitsfx
	pause 15

	moveobject ROUTE19_MOLTRES, 8, 22
	appear ROUTE19_MOLTRES
	cry MOLTRES
	pause 15
	applymovement ROUTE19_MOLTRES, Route19MoltresEntersCaveMovement
	playsound SFX_WARP_FROM
	disappear ROUTE19_MOLTRES
	waitsfx
	pause 15

	disappear ROUTE19_SWIMMER_GUY1
	moveobject ROUTE19_ZAPDOS, 13, 22
	appear ROUTE19_ZAPDOS
	cry ZAPDOS
	pause 15
	applymovement ROUTE19_ZAPDOS, Route19ZapdosEntersCaveMovement
	playsound SFX_WARP_FROM
	disappear ROUTE19_ZAPDOS
	appear ROUTE19_SWIMMER_GUY1
	waitsfx
	pause 15

	moveobject ROUTE19_ARTICUNO, 3, 29
	appear ROUTE19_ARTICUNO
	cry ARTICUNO
	pause 15
	applymovement ROUTE19_ARTICUNO, Route19ArticunoEntersCaveMovement
	playsound SFX_WARP_FROM
	disappear ROUTE19_ARTICUNO
	waitsfx
	end

.SpherePlaced:
	writetext Route19BirdStatueActivatedText
.CloseText:
	waitbutton
	closetext
	end

Route19BirdCutsceneDummy:
	end

Route19MoltresEntersCaveMovement:
	remove_sliding
	big_step RIGHT
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step DOWN
	big_step DOWN
	set_sliding
	step_end

Route19ZapdosEntersCaveMovement:
	remove_sliding
	big_step LEFT
	big_step LEFT
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	set_sliding
	step_end

Route19ArticunoEntersCaveMovement:
	remove_sliding
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step RIGHT
	big_step RIGHT
	set_sliding
	step_end

TrainerSwimmerfDawn:
	trainer SWIMMERF, DAWN, EVENT_BEAT_SWIMMERF_DAWN, SwimmerfDawnSeenText, SwimmerfDawnBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfDawnAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermHarold:
	trainer SWIMMERM, HAROLD, EVENT_BEAT_SWIMMERM_HAROLD, SwimmermHaroldSeenText, SwimmermHaroldBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermHaroldAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermJerome:
	trainer SWIMMERM, JEROME, EVENT_BEAT_SWIMMERM_JEROME, SwimmermJeromeSeenText, SwimmermJeromeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermJeromeAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermTucker:
	trainer SWIMMERM, TUCKER, EVENT_BEAT_SWIMMERM_TUCKER, SwimmermTuckerSeenText, SwimmermTuckerBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermTuckerAfterBattleText
	waitbutton
	closetext
	end

Route19Fisher1Script:
	faceplayer
	opentext
	checkevent EVENT_CINNABAR_ROCKS_CLEARED
	iftrue .RocksCleared
	writetext Route19Fisher1Text
	waitbutton
	closetext
	end

.RocksCleared:
	writetext Route19Fisher1Text_RocksCleared
	waitbutton
	closetext
	end

Route19Fisher2Script:
	faceplayer
	opentext
	checkevent EVENT_CINNABAR_ROCKS_CLEARED
	iftrue .RocksCleared
	writetext Route19Fisher2Text
	waitbutton
	closetext
	end

.RocksCleared:
	writetext Route19Fisher2Text_RocksCleared
	waitbutton
	closetext
	end

Route19Sign:
	jumptext Route19SignText

CarefulSwimmingSign:
	jumptext CarefulSwimmingSignText

SwimmermHaroldSeenText:
	text "Have you ever gone"
	line "swimming in the"
	cont "sea at night?"
	done

SwimmermHaroldBeatenText:
	text "Glub…"
	done

SwimmermHaroldAfterBattleText:
	text "At night, the sea"
	line "turns black. It"

	para "feels like it will"
	line "swallow you up."
	done

SwimmermTuckerSeenText:
	text "Pant, pant…"
	line "Just… a little…"

	para "farther… to…"
	line "FUCHSIA…"
	done

SwimmermTuckerBeatenText:
	text "I'm drowning!"
	done

SwimmermTuckerAfterBattleText:
	text "I… asked my girl-"
	line "friend to swim to"
	cont "FUCHSIA… Gasp…"
	done

SwimmerfDawnSeenText:
	text "I'm disgusted by"
	line "wimpy people!"
	done

SwimmerfDawnBeatenText:
	text "I could beat you"
	line "at swimming…"
	done

SwimmerfDawnAfterBattleText:
	text "It's a quick swim"
	line "between FUCHSIA"

	para "and SEAFOAM IS-"
	line "LANDS…"

	para "Sheesh, some big"
	line "man my boyfriend"

	para "is! What a wimp!"
	done

SwimmermJeromeSeenText:
	text "Swimming?"
	line "I'm lousy at it."

	para "I'm just splashing"
	line "around in these"
	cont "shallow waters."
	done

SwimmermJeromeBeatenText:
	text "I thought I could"
	line "win."
	done

SwimmermJeromeAfterBattleText:
	text "I might be bad at"
	line "swimming, but I"
	cont "love the sea."
	done

Route19Fisher1Text:
	text "Sorry. This road"
	line "is closed for"
	cont "construction."

	para "If you want to get"
	line "to CINNABAR, you'd"

	para "better go south"
	line "from PALLET TOWN."
	done

Route19Fisher1Text_RocksCleared:
	text "I'm all sweaty."
	line "Time for a swim!"
	done

Route19Fisher2Text:
	text "Who knows how long"
	line "it would take to"
	cont "move this boulder…"
	done

Route19Fisher2Text_RocksCleared:
	text "The roadwork is"
	line "finally finished."

	para "Now I can go"
	line "fishing again."
	done

Route19SignText:
	text "ROUTE 19"

	para "FUCHSIA CITY -"
	line "SEAFOAM ISLANDS"
	done

CarefulSwimmingSignText:
	text "Please be careful"
	line "if you are swim-"
	cont "ming to SEAFOAM"
	cont "ISLANDS."

	para "FUCHSIA POLICE"
	done

Route19BirdStatueText:
	text "It's an ancient"
	line "bird statue."

	para "There seems to be"
	line "a hole in the"
	cont "center to place"
	cont "something."
	done

Route19PlaceElementalSphereText:
	text "Do you want to"
	line "place the"
	cont "ELEMENTAL SPHERE"
	cont "here?"
	done

Route19ElementalSpherePlacedText:
	text "The ELEMENTAL"
	line "SPHERE fits"
	cont "perfectly!"
	done

Route19BirdStatueActivatedText:
	text "The ELEMENTAL"
	line "SPHERE glows in"
	cont "the statue."
	done

Route19_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  7,  3, ROUTE_19_FUCHSIA_GATE, 3
	warp_event  6, 27, FIRE_ISLAND, 1
	warp_event 14, 27, THUNDER_ISLAND, 1
	warp_event 10, 33, ICE_ISLAND, 1

	db 0 ; coord events

	db 4 ; bg events
	bg_event 11, 13, BGEVENT_READ, Route19Sign
	bg_event 11,  1, BGEVENT_READ, CarefulSwimmingSign
	bg_event 10, 27, BGEVENT_READ, Route19BirdStatue
	bg_event 11, 27, BGEVENT_READ, Route19BirdStatue

	db 9 ; object events
	object_event  3, 20, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerSwimmerfDawn, -1
	object_event  1, 25, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermHarold, -1
	object_event 11, 17, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermJerome, -1
	object_event  2, 20, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerSwimmermTucker, -1
	object_event  9,  5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 1, Route19Fisher1Script, -1
	object_event 11,  5, SPRITE_FISHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 1, Route19Fisher2Script, -1
	object_event  8, 22, SPRITE_MOLTRES, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route19BirdCutsceneDummy, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	object_event 13, 22, SPRITE_ZAPDOS, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Route19BirdCutsceneDummy, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event  3, 29, SPRITE_ARTICUNO, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route19BirdCutsceneDummy, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3

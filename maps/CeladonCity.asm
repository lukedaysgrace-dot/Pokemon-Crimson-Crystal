	object_const_def ; object_event constants
	const CELADONCITY_FISHER
	const CELADONCITY_POLIWAG
	const CELADONCITY_TEACHER1
	const CELADONCITY_GRAMPS1
	const CELADONCITY_GRAMPS2
	const CELADONCITY_YOUNGSTER1
	const CELADONCITY_YOUNGSTER2
	const CELADONCITY_TEACHER2
	const CELADONCITY_LASS
	const CELADONCITY_BURGLAR
	const CELADONCITY_CHOICE_SPECS
	const CELADONCITY_OFFICER

CeladonCity_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint
	callback MAPCALLBACK_OBJECTS, .GlassesObjects

.FlyPoint:
	setflag ENGINE_FLYPOINT_CELADON
	return

.GlassesObjects:
	disappear CELADONCITY_BURGLAR
	disappear CELADONCITY_OFFICER
	checkevent EVENT_CELADON_SPECS_BURGLAR_FLED
	iffalse .HideGlasses
	checkevent EVENT_GOT_CELADON_CHOICE_SPECS
	iftrue .GlassesCollected
	checkevent EVENT_CELADON_SPECS_DROPPED_LOWER
	iffalse .ShowGlasses
	moveobject CELADONCITY_CHOICE_SPECS, 34, 11
.ShowGlasses:
	appear CELADONCITY_CHOICE_SPECS
	return
.GlassesCollected:
	disappear CELADONCITY_CHOICE_SPECS
	checkevent EVENT_BEAT_CELADON_OFFICER
	iftrue .ObjectsDone
; Recover saves left awaiting an officer rematch by the old loss behavior.
	scall CeladonCityResetGlassesEncounter
.ObjectsDone:
	return
.HideGlasses:
	disappear CELADONCITY_CHOICE_SPECS
	return

CeladonCityBurglarScene:
	checkevent EVENT_CELADON_SPECS_BURGLAR_FLED
	iftrue .Done
	setevent EVENT_CELADON_SPECS_BURGLAR_FLED
	readvar VAR_YCOORD
	ifequal 11, .LowerLane
	moveobject CELADONCITY_BURGLAR, 39, 10
	sjump .Approach
.LowerLane:
	setevent EVENT_CELADON_SPECS_DROPPED_LOWER
	moveobject CELADONCITY_BURGLAR, 39, 11
	moveobject CELADONCITY_CHOICE_SPECS, 34, 11
.Approach:
	appear CELADONCITY_BURGLAR
	applymovement CELADONCITY_BURGLAR, CeladonBurglarApproachMovement
	faceobject PLAYER, CELADONCITY_BURGLAR
	opentext
	writetext CeladonBurglarShoveText
	waitbutton
	closetext
	playsound SFX_TACKLE
	checkevent EVENT_CELADON_SPECS_DROPPED_LOWER
	iftrue .PushUp
	applymovement PLAYER, CeladonPlayerShovedDownMovement
	sjump .Drop
.PushUp:
	applymovement PLAYER, CeladonPlayerShovedUpMovement
.Drop:
	applymovement CELADONCITY_BURGLAR, CeladonBurglarDropMovement
	appear CELADONCITY_CHOICE_SPECS
	applymovement CELADONCITY_CHOICE_SPECS, CeladonGlassesAppearMovement
	playsound SFX_ITEM
	showemote EMOTE_SHOCK, CELADONCITY_BURGLAR, 15
	opentext
	writetext CeladonBurglarDroppedText
	waitbutton
	closetext
	applymovement CELADONCITY_BURGLAR, CeladonSuspectExitMovement
	disappear CELADONCITY_BURGLAR
.Done:
	end

CeladonCityChoiceSpecs:
	opentext
	verbosegiveitem CHOICE_SPECS
	iffalse .NoRoom
	setevent EVENT_GOT_CELADON_CHOICE_SPECS
	closetext
	disappear CELADONCITY_CHOICE_SPECS
; Start beyond the east edge of the camera, then walk into view.
	checkevent EVENT_CELADON_SPECS_DROPPED_LOWER
	iftrue .OfficerLower
	moveobject CELADONCITY_OFFICER, 40, 10
	sjump .OfficerAppears
.OfficerLower:
	moveobject CELADONCITY_OFFICER, 40, 11
.OfficerAppears:
; Movement type 00 retains the actor while it is outside the camera.
	loadmem wMap12Object + MAPOBJECT_MOVEMENT, SPRITEMOVEDATA_00
	appear CELADONCITY_OFFICER
	applymovement CELADONCITY_OFFICER, CeladonOfficerApproachMovement
; Stop to the player's right when they picked up the ball from the east.
	readvar VAR_XCOORD
	ifequal 35, .Confront
	applymovement CELADONCITY_OFFICER, CeladonOfficerCloserMovement
.Confront:
	faceobject CELADONCITY_OFFICER, PLAYER
	faceobject PLAYER, CELADONCITY_OFFICER
	sjump CeladonCityOfficerBattle
.NoRoom:
	closetext
	end

CeladonCityOfficerScript:
	faceplayer
CeladonCityOfficerBattle:
	setlasttalked CELADONCITY_OFFICER
	playmusic MUSIC_OFFICER_ENCOUNTER
	opentext
	writetext CeladonOfficerAccusationText
	waitbutton
	closetext
	winlosstext CeladonOfficerBeatenText, 0
	loadtrainer OFFICER, CELADON_HAYES
	startbattle
	ifnotequal LOSE, .Won
	scall CeladonCityResetGlassesEncounter
	reloadmapafterbattle
	end
.Won:
; Mark victory before map callbacks run so the earned reward stays yours.
	setevent EVENT_BEAT_CELADON_OFFICER
	reloadmapafterbattle
	opentext
	writetext CeladonOfficerApologyText
	waitbutton
	closetext
; Step into the other lane if the player would block the westward exit.
	readmem wMap12Object + MAPOBJECT_Y_COORD
	ifequal 10 + 4, .UpperExit
	readvar VAR_YCOORD
	ifnotequal 11, .Exit
	applymovement CELADONCITY_OFFICER, CeladonOfficerStepUpMovement
	sjump .Exit
.UpperExit:
	readvar VAR_YCOORD
	ifnotequal 10, .Exit
	applymovement CELADONCITY_OFFICER, CeladonOfficerStepDownMovement
.Exit:
	applymovement CELADONCITY_OFFICER, CeladonSuspectExitMovement
	disappear CELADONCITY_OFFICER
	end

CeladonCityResetGlassesEncounter:
; Remove only this encounter's pickup, preserving any earlier copies.
	checkevent EVENT_GOT_CELADON_CHOICE_SPECS
	iffalse .ResetFlags
	takeitem CHOICE_SPECS, 1
.ResetFlags:
	clearevent EVENT_GOT_CELADON_CHOICE_SPECS
	clearevent EVENT_CELADON_SPECS_BURGLAR_FLED
	clearevent EVENT_CELADON_SPECS_DROPPED_LOWER
	clearevent EVENT_BEAT_CELADON_OFFICER
	disappear CELADONCITY_BURGLAR
	disappear CELADONCITY_CHOICE_SPECS
	disappear CELADONCITY_OFFICER
	moveobject CELADONCITY_CHOICE_SPECS, 34, 10
	return

CeladonBurglarApproachMovement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end
CeladonPlayerShovedDownMovement:
	turn_head UP
	fix_facing
	fast_slide_step DOWN
	remove_fixed_facing
	step_end
CeladonPlayerShovedUpMovement:
	turn_head DOWN
	fix_facing
	fast_slide_step UP
	remove_fixed_facing
	step_end
CeladonBurglarDropMovement:
	big_step LEFT
	big_step LEFT
	turn_head RIGHT
	step_end
CeladonGlassesAppearMovement:
	step_sleep 1
	step_end
CeladonSuspectExitMovement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end
CeladonOfficerApproachMovement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end
CeladonOfficerCloserMovement:
	big_step LEFT
	big_step LEFT
	step_end
CeladonOfficerStepUpMovement:
	big_step UP
	step_end
CeladonOfficerStepDownMovement:
	big_step DOWN
	step_end

CeladonBurglarShoveText:
	text "Outta my way, kid!"
	done
CeladonBurglarDroppedText:
	text "Aw, crud! I"
	line "dropped them!"
	para "No time! I'm outta"
	line "here!"
	done
CeladonOfficerAccusationText:
	text "Hey! You there!"
	para "We've had reports"
	line "of a thief in the"
	cont "area!"
	para "Hold on... Are"
	line "those the stolen"
	cont "glasses?"
	para "Looks like I've"
	line "caught you"
	cont "red-handed!"
	para "<PLAYER>: ......"
	para "Save your excuses"
	line "for the station!"
	para "You're coming"
	line "with me!"
	done
CeladonOfficerBeatenText:
	text "Well, I'll be..."
	para "You're no ordinary"
	line "crook!"
	done
CeladonOfficerApologyText:
	text "Wait a minute..."
	para "You're the trainer"
	line "who took down TEAM"
	cont "ROCKET in"
	cont "GOLDENROD!"
	para "Sorry about that!"
	line "Guess I jumped to"
	cont "conclusions."
	para "Those glasses were"
	line "reported stolen,"
	cont "but the owner"
	cont "already collected"
	cont "the insurance."
	para "Consider them a"
	line "reward for your"
	cont "trouble!"
	para "Now, where'd that"
	line "burglar run off"
	cont "to?"
	done

CeladonCityCrystalCapeCallScript:
; Ring as the player steps out of ERIKA's gym after earning the RAINBOWBADGE.
	checkflag ENGINE_RAINBOWBADGE
	iffalse .Done
	checkevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	iffalse .Done
	farsjump Script_SpecialCrystalCall
.Done:
	end

CeladonCityFisherScript:
	jumptextfaceplayer CeladonCityFisherText

CeladonCityPoliwrath:
	opentext
	writetext CeladonCityPoliwrathText
	cry POLIWRATH
	waitbutton
	closetext
	end

CeladonCityTeacher1Script:
	jumptextfaceplayer CeladonCityTeacher1Text

CeladonCityGramps1Script:
	jumptextfaceplayer CeladonCityGramps1Text

CeladonCityGramps2Script:
	jumptextfaceplayer CeladonCityGramps2Text

CeladonCityYoungster1Script:
	jumptextfaceplayer CeladonCityYoungster1Text

CeladonCityYoungster2Script:
	jumptextfaceplayer CeladonCityYoungster2Text

CeladonCityTeacher2Script:
	jumptextfaceplayer CeladonCityTeacher2Text

CeladonCityLassScript:
	jumptextfaceplayer CeladonCityLassText

CeladonCitySign:
	jumptext CeladonCitySignText

CeladonGymSign:
	jumptext CeladonGymSignText

CeladonCityDeptStoreSign:
	jumptext CeladonCityDeptStoreSignText

CeladonCityMansionSign:
	jumptext CeladonCityMansionSignText

CeladonCityGameCornerSign:
	jumptext CeladonCityGameCornerSignText

CeladonCityTrainerTips:
	jumptext CeladonCityTrainerTipsText

CeladonCityPokecenterSign:
	jumpstd pokecentersign

CeladonCityHiddenPpUp:
	hiddenitem PP_UP, EVENT_CELADON_CITY_HIDDEN_PP_UP

CeladonCityFisherText:
	text "This POLIWRATH is"
	line "my partner."

	para "I wonder if it'll"
	line "ever evolve into a"
	cont "frog #MON."
	done

CeladonCityPoliwrathText:
	text "POLIWRATH: Croak!"
	done

CeladonCityTeacher1Text:
	text "I lost at the slot"
	line "machines again…"

	para "We girls also play"
	line "the slots now."

	para "You should check"
	line "them out too."
	done

CeladonCityGramps1Text:
	text "GRIMER have been"
	line "appearing lately."

	para "See that pond out"
	line "in front of the"

	para "house? GRIMER live"
	line "there now."

	para "Where did they"
	line "come from? This is"
	cont "a serious problem…"
	done

CeladonCityGramps2Text:
	text "Nihihi! This GYM"
	line "is great! Only"

	para "girls are allowed"
	line "here!"
	done

CeladonCityYoungster1Text:
	text "Want to know a"
	line "secret?"

	para "CELADON MANSION"
	line "has a hidden back"
	cont "door."
	done

CeladonCityYoungster2Text:
	text "They're holding an"
	line "eating contest at"
	cont "the restaurant."

	para "Just watching them"
	line "go at it makes me"
	cont "feel bloated…"
	done

CeladonCityTeacher2Text:
	text "CELADON DEPT.STORE"
	line "has the biggest"

	para "and best selection"
	line "of merchandise."

	para "If you can't get"
	line "it there, you"

	para "can't get it any-"
	line "where."

	para "Gee… I sound like"
	line "a sales clerk."
	done

CeladonCityLassText_Mobile:
; unused
	text "I love being"
	line "surrounded by tall"
	cont "buildings!"

	para "Isn't it true that"
	line "GOLDENROD #MON"

	para "CENTER was made"
	line "much, much bigger?"

	para "That is so neat!"
	line "I wish we had a"

	para "place like that in"
	line "KANTO…"
	done

CeladonCityLassText:
	text "Looking at the"
	line "ground while I was"

	para "walking made me"
	line "dizzy."
	done

CeladonCitySignText:
	text "CELADON CITY"

	para "The City of"
	line "Rainbow Dreams"
	done

CeladonGymSignText:
	text "CELADON CITY"
	line "#MON GYM"
	cont "LEADER: ERIKA"

	para "The Nature-Loving"
	line "Princess"
	done

CeladonCityDeptStoreSignText:
	text "Find What You"
	line "Need at CELADON"
	cont "DEPT.STORE!"
	done

CeladonCityMansionSignText:
	text "CELADON MANSION"
	done

CeladonCityGameCornerSignText:
	text "The Playground for"
	line "Everybody--CELADON"
	cont "GAME CORNER"
	done

CeladonCityTrainerTipsText:
	text "TRAINER TIPS"

	para "GUARD SPEC."
	line "protects #MON"

	para "against SPECIAL"
	line "attacks such as"
	cont "fire and water."

	para "Get your items at"
	line "CELADON DEPT."
	cont "STORE!"
	done

CeladonCity_MapEvents:
	db 0, 0 ; filler

	db 9 ; warp events
	warp_event  4,  9, CELADON_DEPT_STORE_1F, 1
	warp_event 16,  9, CELADON_MANSION_1F, 1
	warp_event 16,  3, CELADON_MANSION_1F, 3
	warp_event 17,  3, CELADON_MANSION_1F, 3
	warp_event 29,  9, CELADON_POKECENTER_1F, 1
	warp_event 18, 19, CELADON_GAME_CORNER, 1
	warp_event 23, 19, CELADON_GAME_CORNER_PRIZE_ROOM, 1
	warp_event 10, 29, CELADON_GYM, 1
	warp_event 25, 29, CELADON_CAFE, 1

	db 4 ; coord events
	coord_event 10, 29, -1, CeladonCityCrystalCapeCallScript
	coord_event 10, 30, -1, CeladonCityCrystalCapeCallScript
	coord_event 34, 10, -1, CeladonCityBurglarScene
	coord_event 34, 11, -1, CeladonCityBurglarScene

	db 8 ; bg events
	bg_event 23, 21, BGEVENT_READ, CeladonCitySign
	bg_event 11, 31, BGEVENT_READ, CeladonGymSign
	bg_event  6,  9, BGEVENT_READ, CeladonCityDeptStoreSign
	bg_event 13,  9, BGEVENT_READ, CeladonCityMansionSign
	bg_event 19, 21, BGEVENT_READ, CeladonCityGameCornerSign
	bg_event 29, 21, BGEVENT_READ, CeladonCityTrainerTips
	bg_event 30,  9, BGEVENT_READ, CeladonCityPokecenterSign
	bg_event 37, 21, BGEVENT_ITEM, CeladonCityHiddenPpUp

	db 12 ; object events
	object_event 26, 11, SPRITE_FAT_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityFisherScript, -1
	object_event 27, 11, SPRITE_POLIWRATH_NPC, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityPoliwrath, -1
	object_event 20, 24, SPRITE_TEACHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityTeacher1Script, -1
	object_event 14, 16, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps1Script, -1
	object_event  8, 31, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps2Script, -1
	object_event 18, 13, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityYoungster1Script, -1
	object_event 24, 33, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityYoungster2Script, -1
	object_event  6, 14, SPRITE_TEACHER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityTeacher2Script, -1
	object_event  7, 22, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityLassScript, -1
	object_event 39, 10, SPRITE_BURGLAR, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityBurglarScene, EVENT_CELADON_SPECS_BURGLAR_HIDDEN
	object_event 34, 10, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonCityChoiceSpecs, EVENT_CELADON_SPECS_BALL_HIDDEN
	object_event 33, 10, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityOfficerScript, EVENT_CELADON_SPECS_OFFICER_HIDDEN

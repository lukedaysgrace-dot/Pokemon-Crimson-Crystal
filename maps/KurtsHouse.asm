	object_const_def ; object_event constants
	const KURTSHOUSE_KURT1
	const KURTSHOUSE_TWIN1
	const KURTSHOUSE_SLOWPOKE
	const KURTSHOUSE_KURT2
	const KURTSHOUSE_TWIN2

KurtsHouse_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .KurtCallback

.KurtCallback:
	checkevent EVENT_CLEARED_SLOWPOKE_WELL
	iffalse .Done
	checkevent EVENT_FOREST_IS_RESTLESS
	iftrue .Done
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue .MakingBalls
	disappear KURTSHOUSE_KURT2
	appear KURTSHOUSE_KURT1
	disappear KURTSHOUSE_TWIN2
	appear KURTSHOUSE_TWIN1
	return

.MakingBalls:
	disappear KURTSHOUSE_KURT1
	appear KURTSHOUSE_KURT2
	disappear KURTSHOUSE_TWIN1
	appear KURTSHOUSE_TWIN2
.Done:
	return

Kurt1:
	faceplayer
	opentext
	checkevent EVENT_KURT_GAVE_YOU_LURE_BALL
	iftrue .GotLureBall
	checkevent EVENT_CLEARED_SLOWPOKE_WELL
	iftrue .ClearedSlowpokeWell
	writetext KurtsHouseKurtMakingBallsMustWaitText
	waitbutton
	closetext
	special FadeOutMusic
	setevent EVENT_AZALEA_TOWN_SLOWPOKETAIL_ROCKET
	readvar VAR_FACING
	ifequal UP, .RunAround
	turnobject PLAYER, DOWN
	playsound SFX_FLY
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtExitHouseMovement
	playsound SFX_EXIT_BUILDING
	disappear KURTSHOUSE_KURT1
	waitsfx
	special RestartMapMusic
	end

.RunAround:
	turnobject PLAYER, DOWN
	playsound SFX_FLY
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtGoAroundPlayerThenExitHouseMovement
	playsound SFX_EXIT_BUILDING
	disappear KURTSHOUSE_KURT1
	waitsfx
	special RestartMapMusic
	end

.ClearedSlowpokeWell:
	writetext KurtsHouseKurtHonoredToMakeBallsText
	buttonsound
	verbosegiveitem LURE_BALL
	iffalse .NoRoomForBall
	setevent EVENT_KURT_GAVE_YOU_LURE_BALL
.GotLureBall:
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iftrue .WaitForApricorns
	checkevent EVENT_GAVE_KURT_RED_APRICORN
	iftrue .GiveLevelBall
	checkevent EVENT_GAVE_KURT_BLU_APRICORN
	iftrue .GiveLureBall
	checkevent EVENT_GAVE_KURT_YLW_APRICORN
	iftrue .GiveMoonBall
	checkevent EVENT_GAVE_KURT_GRN_APRICORN
	iftrue .GiveFriendBall
	checkevent EVENT_GAVE_KURT_WHT_APRICORN
	iftrue .GiveFastBall
	checkevent EVENT_GAVE_KURT_BLK_APRICORN
	iftrue .GiveHeavyBall
	checkevent EVENT_GAVE_KURT_PNK_APRICORN
	iftrue .GiveLoveBall
	checkevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	iftrue .CanGiveGSBallToKurt
.NoGSBall:
; Also reached right after handing over a batch, so Kurt can start another.
	checkitem RED_APRICORN
	iftrue .AskApricorn
	checkitem BLU_APRICORN
	iftrue .AskApricorn
	checkitem YLW_APRICORN
	iftrue .AskApricorn
	checkitem GRN_APRICORN
	iftrue .AskApricorn
	checkitem WHT_APRICORN
	iftrue .AskApricorn
	checkitem BLK_APRICORN
	iftrue .AskApricorn
	checkitem PNK_APRICORN
	iftrue .AskApricorn
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iftrue .BringMoreApricorns
	writetext KurtsHouseKurtBallsFromApricornsText
	waitbutton
	closetext
	end

.BringMoreApricorns:
	writetext KurtsHouseKurtBringMoreApricornsText
	waitbutton
	closetext
	end

.AskApricorn:
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iftrue .AskForAnotherBatch
	writetext KurtsHouseKurtAskYouHaveAnApricornText
	sjump .ChooseApricorn

.AskForAnotherBatch:
	writetext KurtsHouseKurtAskAnotherBatchText
.ChooseApricorn:
	buttonsound
	special SelectApricornForKurt
	ifequal FALSE, .Cancel
	ifequal BLU_APRICORN, .Blu
	ifequal YLW_APRICORN, .Ylw
	ifequal GRN_APRICORN, .Grn
	ifequal WHT_APRICORN, .Wht
	ifequal BLK_APRICORN, .Blk
	ifequal PNK_APRICORN, .Pnk
; .Red
	setevent EVENT_GAVE_KURT_RED_APRICORN
	getitemname STRING_BUFFER_4, LEVEL_BALL
	sjump .GaveKurtApricorns

.Blu:
	setevent EVENT_GAVE_KURT_BLU_APRICORN
	getitemname STRING_BUFFER_4, LURE_BALL
	sjump .GaveKurtApricorns

.Ylw:
	setevent EVENT_GAVE_KURT_YLW_APRICORN
	getitemname STRING_BUFFER_4, MOON_BALL
	sjump .GaveKurtApricorns

.Grn:
	setevent EVENT_GAVE_KURT_GRN_APRICORN
	getitemname STRING_BUFFER_4, FRIEND_BALL
	sjump .GaveKurtApricorns

.Wht:
	setevent EVENT_GAVE_KURT_WHT_APRICORN
	getitemname STRING_BUFFER_4, FAST_BALL
	sjump .GaveKurtApricorns

.Blk:
	setevent EVENT_GAVE_KURT_BLK_APRICORN
	getitemname STRING_BUFFER_4, HEAVY_BALL
	sjump .GaveKurtApricorns

.Pnk:
	setevent EVENT_GAVE_KURT_PNK_APRICORN
	getitemname STRING_BUFFER_4, LOVE_BALL
.GaveKurtApricorns:
; wScriptVar still holds the chosen Apricorn here.
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	getitemname STRING_BUFFER_3, USE_SCRIPT_VAR
	callasm Kurt_LoadBatchCountText
	callasm Kurt_IsBatchCountOne
	iftrue .GaveOneApricorn
	writetext KurtsHouseKurtStartBatchText
	sjump .HeadToWorkbench

.GaveOneApricorn:
	writetext KurtsHouseKurtStartSingleBallText
.HeadToWorkbench:
	waitbutton
	closetext
	readvar VAR_FACING
	ifequal LEFT, .PlayerOnRight
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtToWorkbenchMovement
	end

.PlayerOnRight:
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtToWorkbenchFromRightMovement
	end

.WaitForApricorns:
	writetext KurtsHouseKurtItWillTakeADayText
	waitbutton
	closetext
	turnobject KURTSHOUSE_KURT1, UP
	end

.Cancel:
	writetext KurtsHouseKurtThatsALetdownText
	waitbutton
.NoRoomForBall:
	closetext
	end

.GiveLevelBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval LEVEL_BALL
	sjump .CollectBalls

.GiveLureBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval LURE_BALL
	sjump .CollectBalls

.GiveMoonBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval MOON_BALL
	sjump .CollectBalls

.GiveFriendBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval FRIEND_BALL
	sjump .CollectBalls

.GiveFastBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval FAST_BALL
	sjump .CollectBalls

.GiveHeavyBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval HEAVY_BALL
	sjump .CollectBalls

.GiveLoveBall:
	checkflag ENGINE_KURT_MAKING_BALLS
	iftrue KurtMakingBallsScript
	setval LOVE_BALL
.CollectBalls:
	getitemname STRING_BUFFER_3, USE_SCRIPT_VAR
	callasm Kurt_LoadBatchCountText
	callasm Kurt_CollectCraftedBalls
	iffalse .BallPocketFull
	callasm Kurt_LoadCollectedCountText
	ifequal 2, .PartialBatch
	callasm Kurt_IsBatchCountOne
	iftrue .CollectedOneBall
	writetext KurtsHouseKurtJustFinishedYourBallsText
	sjump .HandOverBalls

.CollectedOneBall:
	writetext KurtsHouseKurtJustFinishedYourBallText
.HandOverBalls:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	scall KurtsHouse_BallTipScript
	clearevent EVENT_GAVE_KURT_RED_APRICORN
	clearevent EVENT_GAVE_KURT_BLU_APRICORN
	clearevent EVENT_GAVE_KURT_YLW_APRICORN
	clearevent EVENT_GAVE_KURT_GRN_APRICORN
	clearevent EVENT_GAVE_KURT_WHT_APRICORN
	clearevent EVENT_GAVE_KURT_BLK_APRICORN
	clearevent EVENT_GAVE_KURT_PNK_APRICORN
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	sjump .NoGSBall

.PartialBatch:
	writetext KurtsHouseKurtPartialBatchText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	writetext KurtsHouseKurtPartialBatchRestText
	waitbutton
	closetext
	end

.BallPocketFull:
	writetext KurtsHouseKurtBallPocketFullText
	waitbutton
	closetext
	end

.CanGiveGSBallToKurt:
	checkevent EVENT_GAVE_GS_BALL_TO_KURT
	iftrue .GaveGSBallToKurt
	checkitem GS_BALL
	iffalse .NoGSBall
	writetext KurtsHouseKurtWhatIsThatText
	waitbutton
	closetext
	setevent EVENT_GAVE_GS_BALL_TO_KURT
	takeitem GS_BALL
	setflag ENGINE_KURT_MAKING_BALLS
	end

.GaveGSBallToKurt:
	checkflag ENGINE_KURT_MAKING_BALLS
	iffalse .NotMakingBalls
	writetext KurtsHouseKurtImCheckingItNowText
	waitbutton
	writetext KurtsHouseKurtAhHaISeeText
	waitbutton
	closetext
	end

.NotMakingBalls:
	writetext KurtsHouseKurtThisBallStartedToShakeText
	waitbutton
	closetext
	setevent EVENT_FOREST_IS_RESTLESS
	clearevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	clearevent EVENT_GAVE_GS_BALL_TO_KURT
	special FadeOutMusic
	pause 20
	showemote EMOTE_SHOCK, KURTSHOUSE_KURT1, 30
	readvar VAR_FACING
	ifequal UP, .GSBallRunAround
	turnobject PLAYER, DOWN
	playsound SFX_FLY
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtExitHouseMovement
	sjump .KurtHasLeftTheBuilding

.GSBallRunAround:
	turnobject PLAYER, DOWN
	playsound SFX_FLY
	applymovement KURTSHOUSE_KURT1, KurtsHouseKurtGoAroundPlayerThenExitHouseMovement
.KurtHasLeftTheBuilding:
	playsound SFX_EXIT_BUILDING
	disappear KURTSHOUSE_KURT1
	clearevent EVENT_AZALEA_TOWN_KURT
	waitsfx
	special RestartMapMusic
	setmapscene AZALEA_TOWN, SCENE_AZALEATOWN_KURT_RETURNS_GS_BALL
	end

KurtsHouse_BallTipScript:
; Called before the GAVE_KURT_* events are cleared.
	checkevent EVENT_GAVE_KURT_RED_APRICORN
	iftrue .Level
	checkevent EVENT_GAVE_KURT_BLU_APRICORN
	iftrue .Lure
	checkevent EVENT_GAVE_KURT_YLW_APRICORN
	iftrue .Moon
	checkevent EVENT_GAVE_KURT_GRN_APRICORN
	iftrue .Friend
	checkevent EVENT_GAVE_KURT_WHT_APRICORN
	iftrue .Fast
	checkevent EVENT_GAVE_KURT_BLK_APRICORN
	iftrue .Heavy
	checkevent EVENT_GAVE_KURT_PNK_APRICORN
	iftrue .Love
	end

.Level:
	writetext KurtsHouseKurtLevelBallTipText
	sjump .Done

.Lure:
	writetext KurtsHouseKurtLureBallTipText
	sjump .Done

.Moon:
	writetext KurtsHouseKurtMoonBallTipText
	sjump .Done

.Friend:
	writetext KurtsHouseKurtFriendBallTipText
	sjump .Done

.Fast:
	writetext KurtsHouseKurtFastBallTipText
	sjump .Done

.Heavy:
	writetext KurtsHouseKurtHeavyBallTipText
	sjump .Done

.Love:
	writetext KurtsHouseKurtLoveBallTipText
.Done:
	waitbutton
	end

Kurt2:
	faceplayer
	opentext
	checkevent EVENT_GAVE_GS_BALL_TO_KURT
	iftrue KurtScript_ImCheckingItNow
KurtMakingBallsScript:
	checkevent EVENT_BUGGING_KURT_TOO_MUCH
	iffalse Script_FirstTimeBuggingKurt
	writetext KurtsHouseKurtDontBotherMeText
	waitbutton
	closetext
	turnobject KURTSHOUSE_KURT2, UP
	end

Script_FirstTimeBuggingKurt:
	writetext KurtsHouseKurtGranddaughterHelpingWorkFasterText
	waitbutton
	closetext
	turnobject KURTSHOUSE_KURT2, UP
	setevent EVENT_BUGGING_KURT_TOO_MUCH
	end

KurtScript_ImCheckingItNow:
	writetext KurtsHouseKurtImCheckingItNowText
	waitbutton
	turnobject KURTSHOUSE_KURT2, UP
	writetext KurtsHouseKurtAhHaISeeText
	waitbutton
	closetext
	end

KurtsGranddaughter1:
	faceplayer
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iftrue KurtsGranddaughter2Subscript
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iftrue KurtsGranddaughterFunScript
	checkevent EVENT_FOREST_IS_RESTLESS
	iftrue .Lonely
	checkevent EVENT_FAST_SHIP_FIRST_TIME
	iftrue .Dad
	checkevent EVENT_CLEARED_SLOWPOKE_WELL
	iftrue .SlowpokeBack
	checkevent EVENT_AZALEA_TOWN_SLOWPOKETAIL_ROCKET
	iftrue .Lonely
	opentext
	writetext KurtsGranddaughterSlowpokeGoneText
	waitbutton
	closetext
	end

.SlowpokeBack:
	opentext
	writetext KurtsGranddaughterSlowpokeBackText
	waitbutton
	closetext
	end

.Lonely:
	opentext
	writetext KurtsGranddaughterLonelyText
	waitbutton
	closetext
	end

.Dad:
	opentext
	writetext KurtsGranddaughterDadText
	waitbutton
	closetext
	end

KurtsGranddaughter2:
	faceplayer
KurtsGranddaughter2Subscript:
	opentext
	checkevent EVENT_GAVE_GS_BALL_TO_KURT
	iftrue .GSBall
	writetext KurtsGranddaughterHelpText
	waitbutton
	closetext
	turnobject KURTSHOUSE_TWIN2, RIGHT
	end

.GSBall:
	writetext KurtsGranddaughterGSBallText
	waitbutton
	closetext
	turnobject KURTSHOUSE_TWIN2, RIGHT
	end

KurtsGranddaughterFunScript:
	opentext
	writetext KurtsGranddaughterFunText
	waitbutton
	closetext
	end

KurtsHouseSlowpoke:
	faceplayer
	opentext
	writetext KurtsHouseSlowpokeText
	cry SLOWPOKE
	waitbutton
	closetext
	end

KurtsHouseOakPhoto:
	jumptext KurtsHouseOakPhotoText

KurtsHouseCelebiStatue:
	jumptext KurtsHouseCelebiStatueText

KurtsHouseBookshelf:
	jumpstd difficultbookshelf

KurtsHouseRadio:
	jumpstd radio2

KurtsHouseKurtExitHouseMovement:
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	step_end

KurtsHouseKurtGoAroundPlayerThenExitHouseMovement:
	big_step RIGHT
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	step_end

KurtsHouseKurtToWorkbenchMovement:
; Cross above his granddaughter/Slowpoke, then below the workshop wall.
rept 6
	step RIGHT
endr
rept 3
	step DOWN
endr
rept 5
	step RIGHT
endr
rept 2
	step UP
endr
	turn_head UP
	step_end

KurtsHouseKurtToWorkbenchFromRightMovement:
; The player is at (4, 2), so take the southern route around them.
rept 3
	step DOWN
endr
rept 11
	step RIGHT
endr
rept 2
	step UP
endr
	turn_head UP
	step_end

KurtsHouseKurtMakingBallsMustWaitText:
	text "Hm? Who are you?"

	para "<PLAYER>, eh? You"
	line "want me to make"
	cont "some BALLS?"

	para "Sorry, but that'll"
	line "have to wait."

	para "Do you know TEAM"
	line "ROCKET? Ah, don't"

	para "worry. I'll tell"
	line "you anyhow."

	para "TEAM ROCKET's an"
	line "evil gang that"

	para "uses #MON for"
	line "their dirty work."

	para "They're supposed"
	line "to have disbanded"
	cont "three years ago."

	para "Anyway, they're at"
	line "the WELL, cutting"

	para "off SLOWPOKETAILS"
	line "for sale!"

	para "So I'm going to"
	line "go give them a"
	cont "lesson in pain!"

	para "Hang on, SLOWPOKE!"
	line "Old KURT is on his"
	cont "way!"
	done

KurtsHouseKurtHonoredToMakeBallsText:
	text "KURT: Hi, <PLAYER>!"

	para "You handled your-"
	line "self like a real"
	cont "hero at the WELL."

	para "I like your style!"

	para "I would be honored"
	line "to make BALLS for"

	para "a trainer like"
	line "you."

	para "This is all I have"
	line "now, but take it."
	done

KurtsHouseKurtBallsFromApricornsText:
	text "KURT: I make BALLS"
	line "from APRICORNS."

	para "Shake the trees on"
	line "the routes and"
	cont "bring me whatever"
	cont "falls out."

	para "Each color makes"
	line "a different BALL."

	para "Bring as many as"
	line "you like. I'll"
	cont "turn the whole"
	cont "pile into BALLS!"
	done

KurtsHouseKurtBringMoreApricornsText:
	text "KURT: Out of"
	line "APRICORNS, eh?"

	para "The trees keep"
	line "growing more."

	para "Bring me a fresh"
	line "pile anytime!"
	done

KurtsHouseKurtAskYouHaveAnApricornText:
	text "KURT: Oh? Those"
	line "are APRICORNS!"

	para "Pick a color and"
	line "I'll turn every"
	cont "last one into"
	cont "BALLS."
	done

KurtsHouseKurtAskAnotherBatchText:
	text "KURT: Got more"
	line "APRICORNS? Great!"

	para "Let's keep that"
	line "fire going!"
	done

KurtsHouseKurtStartBatchText:
	text "KURT: Let's see…"
	line "@"
	text_decimal wStringBuffer5, 2, 4
	text " @"
	text_ram wStringBuffer3
	text "S"

	para "That's enough for"
	line "a fine batch of"
	cont "@"
	text_ram wStringBuffer4
	text "S!"

	para "Go get some fresh"
	line "air. They'll be"
	cont "done by the time"
	cont "you're back!"
	done

KurtsHouseKurtStartSingleBallText:
	text "KURT: Just one"
	line "@"
	text_ram wStringBuffer3
	text "?"

	para "Ha! Small job, but"
	line "I'll make it a"
	cont "fine @"
	text_ram wStringBuffer4
	text "!"

	para "Go get some fresh"
	line "air. It'll be done"
	cont "by the time you're"
	cont "back!"
	done

KurtsHouseKurtItWillTakeADayText:
	text "KURT: Hey, you"
	line "can't rush good"
	cont "craftsmanship!"

	para "Go on outside for"
	line "a bit. It'll be"
	cont "ready when you"
	cont "come back in."
	done

KurtsHouseKurtThatsALetdownText:
	text "KURT: Oh…"
	line "That's a letdown."
	done

KurtsHouseKurtDontBotherMeText:
	text "KURT: I'm working!"
	line "Don't bother me!"
	done

KurtsHouseKurtJustFinishedYourBallsText:
	text "KURT: Ah, <PLAYER>!"
	line "Perfect timing!"

	para "Here you go!"
	line "@"
	text_decimal wStringBuffer5, 2, 4
	text " @"
	text_ram wStringBuffer3
	text "S!"
	done

KurtsHouseKurtJustFinishedYourBallText:
	text "KURT: Ah, <PLAYER>!"
	line "Perfect timing!"

	para "Here you go!"
	line "One @"
	text_ram wStringBuffer3
	text "!"
	done

KurtsHouseKurtPartialBatchText:
	text "KURT: Ah, <PLAYER>!"
	line "Here you go!"

	para "@"
	text_decimal wStringBuffer5, 2, 4
	text " @"
	text_ram wStringBuffer3
	text "S!"
	done

KurtsHouseKurtPartialBatchRestText:
	text "KURT: Whoa, your"
	line "BALL POCKET is"
	cont "stuffed full!"

	para "I'll hang on to"
	line "the other @"
	text_decimal wStringBuffer5 + 2, 2, 4
	text "."

	para "Make some room and"
	line "come see me again!"
	done

KurtsHouseKurtBallPocketFullText:
	text "KURT: Your BALLS"
	line "are ready, but"
	cont "your BALL POCKET"
	cont "is stuffed full!"

	para "Make some room and"
	line "come see me again."
	done

KurtsHouseKurtLevelBallTipText:
	text "KURT: LEVEL BALLS"
	line "work best when"
	cont "your #MON is a"
	cont "higher level than"
	cont "the wild one."
	done

KurtsHouseKurtLureBallTipText:
	text "KURT: LURE BALLS"
	line "are made for"
	cont "#MON you hook"
	cont "with a ROD."
	done

KurtsHouseKurtMoonBallTipText:
	text "KURT: MOON BALLS"
	line "work wonders on"
	cont "#MON that can"
	cont "evolve with a"
	cont "MOON STONE."
	done

KurtsHouseKurtFriendBallTipText:
	text "KURT: Anything you"
	line "catch in a FRIEND"
	cont "BALL will warm up"
	cont "to you right away!"
	done

KurtsHouseKurtFastBallTipText:
	text "KURT: FAST BALLS"
	line "are perfect for"
	cont "#MON that like"
	cont "to run away."
	done

KurtsHouseKurtHeavyBallTipText:
	text "KURT: HEAVY BALLS"
	line "work best on big,"
	cont "heavy #MON."

	para "On little ones,"
	line "not so much!"
	done

KurtsHouseKurtLoveBallTipText:
	text "KURT: Use LOVE"
	line "BALLS on the same"
	cont "kind of #MON as"
	cont "yours, but of the"
	cont "opposite gender."
	done

KurtsHouseKurtGranddaughterHelpingWorkFasterText:
	text "KURT: Now that my"
	line "granddaughter is"

	para "helping me, I can"
	line "work much faster."
	done

KurtsHouseKurtWhatIsThatText:
	text "Wh-what is that?"

	para "I've never seen"
	line "one before."

	para "It looks a lot"
	line "like a # BALL,"

	para "but it appears to"
	line "be something else."

	para "Let me check it"
	line "for you."
	done

KurtsHouseKurtImCheckingItNowText:
	text "I'm checking it"
	line "now."
	done

KurtsHouseKurtAhHaISeeText:
	text "Ah-ha! I see!"
	line "So…"
	done

KurtsHouseKurtThisBallStartedToShakeText:
	text "<PLAYER>!"

	para "This BALL started"
	line "to shake while I"
	cont "was checking it."

	para "There must be"
	line "something to this!"
	done

KurtsGranddaughterSlowpokeGoneText:
	text "The SLOWPOKE are"
	line "gone… Were they"

	para "taken away by bad"
	line "people?"
	done

KurtsGranddaughterLonelyText:
	text "Grandpa's gone…"
	line "I'm so lonely…"
	done

KurtsGranddaughterSlowpokeBackText:
	text "The SLOWPOKE my"
	line "dad gave me came"

	para "back! Its TAIL is"
	line "growing back too!"
	done

KurtsGranddaughterDadText:
	text "Dad works at SILPH"
	line "where he studies"
	cont "# BALLS."

	para "I have to stay"
	line "home with Grandpa"
	cont "and SLOWPOKE."
	done

KurtsGranddaughterHelpText:
	text "I get to help"
	line "Grandpa now!"

	para "Go play outside"
	line "for a bit. Your"
	cont "BALLS will be"
	cont "ready soon!"
	done

KurtsGranddaughterFunText:
	text "Grandpa let me"
	line "polish the BALLS"
	cont "this time!"

	para "Aren't they shiny?"
	done

KurtsGranddaughterGSBallText:
	text "Grandpa's checking"
	line "a BALL right now."

	para "So I'm waiting"
	line "till he's done."
	done

KurtsHouseSlowpokeText:
	text "SLOWPOKE: …"
	line "Yawn?"
	done

KurtsHouseOakPhotoText:
	text "…A young PROF."
	line "OAK?"
	done

KurtsHouseCelebiStatueText:
	text "It's a statue of"
	line "the forest's pro-"
	cont "tector."
	done

KurtsHouse_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  3,  7, AZALEA_TOWN, 4
	warp_event  4,  7, AZALEA_TOWN, 4

	db 0 ; coord events

	db 7 ; bg events
	bg_event  6,  1, BGEVENT_READ, KurtsHouseRadio
	bg_event  8,  0, BGEVENT_READ, KurtsHouseOakPhoto
	bg_event  9,  0, BGEVENT_READ, KurtsHouseOakPhoto
	bg_event  5,  1, BGEVENT_READ, KurtsHouseBookshelf
	bg_event  2,  1, BGEVENT_READ, KurtsHouseBookshelf
	bg_event  3,  1, BGEVENT_READ, KurtsHouseBookshelf
	bg_event  4,  1, BGEVENT_READ, KurtsHouseCelebiStatue

	db 5 ; object events
	object_event  3,  2, SPRITE_KURT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Kurt1, EVENT_KURTS_HOUSE_KURT_1
	object_event  5,  3, SPRITE_TWIN, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, KurtsGranddaughter1, EVENT_KURTS_HOUSE_GRANDDAUGHTER_1
	object_event  6,  3, SPRITE_SLOWPOKE, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, KurtsHouseSlowpoke, EVENT_KURTS_HOUSE_SLOWPOKE
	object_event 14,  3, SPRITE_KURT, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Kurt2, EVENT_KURTS_HOUSE_KURT_2
	object_event 11,  4, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, KurtsGranddaughter2, EVENT_KURTS_HOUSE_GRANDDAUGHTER_2

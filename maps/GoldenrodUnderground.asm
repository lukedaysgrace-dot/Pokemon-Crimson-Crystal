GOLDENRODUNDERGROUND_OLDER_HAIRCUT_PRICE   EQU 500
GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_PRICE EQU 300

	object_const_def ; object_event constants
	const GOLDENRODUNDERGROUND_SUPER_NERD1
	const GOLDENRODUNDERGROUND_SUPER_NERD2
	const GOLDENRODUNDERGROUND_SUPER_NERD3
	const GOLDENRODUNDERGROUND_SUPER_NERD4
	const GOLDENRODUNDERGROUND_POKE_BALL
	const GOLDENRODUNDERGROUND_GRAMPS
	const GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	const GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	const GOLDENRODUNDERGROUND_GRANNY
	const GOLDENRODUNDERGROUND_GIRL
	const GOLDENRODUNDERGROUND_THUG_PAULIE
	const GOLDENRODUNDERGROUND_THUG_BOBBY
	const GOLDENRODUNDERGROUND_THUG_TONY
	const GOLDENRODUNDERGROUND_RIOLU

GoldenrodUnderground_MapScripts:
	db 0 ; scene scripts

	db 3 ; callbacks
	callback MAPCALLBACK_NEWMAP, .ResetSwitches
	callback MAPCALLBACK_TILES, .CheckBasementKey
	callback MAPCALLBACK_OBJECTS, .CheckDayOfWeek

.ResetSwitches:
	clearevent EVENT_SWITCH_1
	clearevent EVENT_SWITCH_2
	clearevent EVENT_SWITCH_3
	clearevent EVENT_EMERGENCY_SWITCH
	clearevent EVENT_SWITCH_4
	clearevent EVENT_SWITCH_5
	clearevent EVENT_SWITCH_6
	clearevent EVENT_SWITCH_7
	clearevent EVENT_SWITCH_8
	clearevent EVENT_SWITCH_9
	clearevent EVENT_SWITCH_10
	clearevent EVENT_SWITCH_11
	clearevent EVENT_SWITCH_12
	clearevent EVENT_SWITCH_13
	clearevent EVENT_SWITCH_14
	setval 0
	writemem wUndergroundSwitchPositions
	return

.CheckBasementKey:
	checkevent EVENT_USED_BASEMENT_KEY
	iffalse .LockBasementDoor
	return

.LockBasementDoor:
	changeblock 18, 6, $3d ; locked door
	return

.CheckDayOfWeek:
	readvar VAR_WEEKDAY
	ifequal MONDAY, .Monday
	ifequal TUESDAY, .Tuesday
	ifequal WEDNESDAY, .Wednesday
	ifequal THURSDAY, .Thursday
	ifequal FRIDAY, .Friday
	ifequal SATURDAY, .Saturday

.Sunday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	disappear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	appear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	appear GOLDENRODUNDERGROUND_GRANNY
	return

.Monday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	checktime MORN
	iffalse .NotMondayMorning
	appear GOLDENRODUNDERGROUND_GRAMPS
.NotMondayMorning:
	disappear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_GRANNY
	return

.Tuesday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	appear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_GRANNY
	return

.Wednesday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	disappear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	appear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_GRANNY
	return

.Thursday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	appear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_GRANNY
	return

.Friday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	disappear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	appear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_GRANNY
	return

.Saturday:
	disappear GOLDENRODUNDERGROUND_GRAMPS
	appear GOLDENRODUNDERGROUND_OLDER_HAIRCUT_BROTHER
	disappear GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	appear GOLDENRODUNDERGROUND_GRANNY
	return

TrainerSupernerdEric:
	trainer SUPER_NERD, ERIC, EVENT_BEAT_SUPER_NERD_ERIC, SupernerdEricSeenText, SupernerdEricBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdEricAfterBattleText
	waitbutton
	closetext
	end

TrainerSupernerdTeru:
	trainer SUPER_NERD, TERU, EVENT_BEAT_SUPER_NERD_TERU, SupernerdTeruSeenText, SupernerdTeruBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdTeruAfterBattleText
	waitbutton
	closetext
	end

TrainerPokemaniacIssac:
	trainer POKEMANIAC, ISSAC, EVENT_BEAT_POKEMANIAC_ISSAC, PokemaniacIssacSeenText, PokemaniacIssacBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacIssacAfterBattleText
	waitbutton
	closetext
	end

TrainerPokemaniacDonald:
	trainer POKEMANIAC, DONALD, EVENT_BEAT_POKEMANIAC_DONALD, PokemaniacDonaldSeenText, PokemaniacDonaldBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacDonaldAfterBattleText
	waitbutton
	closetext
	end

BitterMerchantScript:
	opentext
	readvar VAR_WEEKDAY
	ifequal SUNDAY, .Open
	ifequal SATURDAY, .Open
	sjump GoldenrodUndergroundScript_ShopClosed

.Open:
	pokemart MARTTYPE_BITTER, MART_UNDERGROUND
	closetext
	end

BargainMerchantScript:
	opentext
	checkflag ENGINE_GOLDENROD_UNDERGROUND_MERCHANT_CLOSED
	iftrue GoldenrodUndergroundScript_ShopClosed
	readvar VAR_WEEKDAY
	ifequal MONDAY, .CheckMorn
	sjump GoldenrodUndergroundScript_ShopClosed

.CheckMorn:
	checktime MORN
	iffalse GoldenrodUndergroundScript_ShopClosed
	pokemart MARTTYPE_BARGAIN, 0
	closetext
	end

OlderHaircutBrotherScript:
	opentext
	readvar VAR_WEEKDAY
	ifequal TUESDAY, .DoHaircut
	ifequal THURSDAY, .DoHaircut
	ifequal SATURDAY, .DoHaircut
	sjump GoldenrodUndergroundScript_ShopClosed

.DoHaircut:
	checkflag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	iftrue .AlreadyGotHaircut
	special PlaceMoneyTopRight
	writetext GoldenrodUndergroundOlderHaircutBrotherOfferHaircutText
	yesorno
	iffalse .Refused
	checkmoney YOUR_MONEY, GOLDENRODUNDERGROUND_OLDER_HAIRCUT_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	writetext GoldenrodUndergroundOlderHaircutBrotherAskWhichMonText
	buttonsound
	special OlderHaircutBrother
	ifequal $0, .Refused
	ifequal $1, .Refused
	setflag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	ifequal $2, .two
	ifequal $3, .three
	sjump .else

.two
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.three
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.else
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.then
	takemoney YOUR_MONEY, GOLDENRODUNDERGROUND_OLDER_HAIRCUT_PRICE
	special PlaceMoneyTopRight
	writetext GoldenrodUndergroundOlderHaircutBrotherWatchItBecomeBeautifulText
	waitbutton
	closetext
	special FadeOutPalettes
	playmusic MUSIC_HEAL
	pause 60
	special FadeInPalettes
	special RestartMapMusic
	opentext
	writetext GoldenrodUndergroundOlderHaircutBrotherAllDoneText
	waitbutton
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iftrue EitherHaircutBrotherScript_SlightlyHappier
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iftrue EitherHaircutBrotherScript_Happier
	sjump EitherHaircutBrotherScript_MuchHappier

.Refused:
	writetext GoldenrodUndergroundOlderHaircutBrotherThatsAShameText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext GoldenrodUndergroundOlderHaircutBrotherYoullNeedMoreMoneyText
	waitbutton
	closetext
	end

.AlreadyGotHaircut:
	writetext GoldenrodUndergroundOlderHaircutBrotherOneHaircutADayText
	waitbutton
	closetext
	end

YoungerHaircutBrotherScript:
	opentext
	readvar VAR_WEEKDAY
	ifequal SUNDAY, .DoHaircut
	ifequal WEDNESDAY, .DoHaircut
	ifequal FRIDAY, .DoHaircut
	sjump GoldenrodUndergroundScript_ShopClosed

.DoHaircut:
	checkflag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	iftrue .AlreadyGotHaircut
	special PlaceMoneyTopRight
	writetext GoldenrodUndergroundYoungerHaircutBrotherOfferHaircutText
	yesorno
	iffalse .Refused
	checkmoney YOUR_MONEY, GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	writetext GoldenrodUndergroundYoungerHaircutBrotherAskWhichMonText
	buttonsound
	special YoungerHaircutBrother
	ifequal $0, .Refused
	ifequal $1, .Refused
	setflag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	ifequal $2, .two
	ifequal $3, .three
	sjump .else

.two
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.three
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.else
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	clearevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	sjump .then

.then
	takemoney YOUR_MONEY, GOLDENRODUNDERGROUND_YOUNGER_HAIRCUT_PRICE
	special PlaceMoneyTopRight
	writetext GoldenrodUndergroundYoungerHaircutBrotherIllMakeItLookCoolText
	waitbutton
	closetext
	special FadeOutPalettes
	playmusic MUSIC_HEAL
	pause 60
	special FadeInPalettes
	special RestartMapMusic
	opentext
	writetext GoldenrodUndergroundYoungerHaircutBrotherAllDoneText
	waitbutton
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iftrue EitherHaircutBrotherScript_SlightlyHappier
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iftrue EitherHaircutBrotherScript_Happier
	sjump EitherHaircutBrotherScript_MuchHappier

.Refused:
	writetext GoldenrodUndergroundYoungerHaircutBrotherHowDisappointingText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext GoldenrodUndergroundYoungerHaircutBrotherShortOnFundsText
	waitbutton
	closetext
	end

.AlreadyGotHaircut:
	writetext GoldenrodUndergroundYoungerHaircutBrotherOneHaircutADayText
	waitbutton
	closetext
	end

EitherHaircutBrotherScript_SlightlyHappier:
	writetext HaircutBrosText_SlightlyHappier
	special PlayCurMonCry
	waitbutton
	closetext
	end

EitherHaircutBrotherScript_Happier:
	writetext HaircutBrosText_Happier
	special PlayCurMonCry
	waitbutton
	closetext
	end

EitherHaircutBrotherScript_MuchHappier:
	writetext HaircutBrosText_MuchHappier
	special PlayCurMonCry
	waitbutton
	closetext
	end

BasementDoorScript::
	opentext
	checkevent EVENT_USED_BASEMENT_KEY
	iftrue .Open
	checkitem BASEMENT_KEY
	iftrue .Unlock
	writetext GoldenrodUndergroundTheDoorsLockedText
	waitbutton
	closetext
	end

.Unlock:
	playsound SFX_TRANSACTION
	writetext GoldenrodUndergroundBasementKeyOpenedDoorText
	waitbutton
	closetext
	changeblock 18, 6, $2e ; unlocked door
	reloadmappart
	closetext
	setevent EVENT_USED_BASEMENT_KEY
	end

.Open:
	writetext GoldenrodUndergroundTheDoorIsOpenText
	waitbutton
	closetext
	end

GoldenrodUndergroundScript_ShopClosed:
	writetext GoldenrodUndergroundWeAreNotOpenTodayText
	waitbutton
	closetext
	end

GoldenrodUndergroundCoinCase:
	itemball COIN_CASE

GoldenrodUndergroundNoEntrySign:
	jumptext GoldenrodUndergroundNoEntryText

GoldenrodUndergroundHiddenParlyzHeal:
	hiddenitem PARLYZ_HEAL, EVENT_GOLDENROD_UNDERGROUND_HIDDEN_PARLYZ_HEAL

GoldenrodUndergroundHiddenSuperPotion:
	hiddenitem SUPER_POTION, EVENT_GOLDENROD_UNDERGROUND_HIDDEN_SUPER_POTION

GoldenrodUndergroundHiddenAntidote:
	hiddenitem ANTIDOTE, EVENT_GOLDENROD_UNDERGROUND_HIDDEN_ANTIDOTE

; The three TEAM ROCKET grunts cornering the girl at the east end of the middle corridor.
; The whole thing is a one-shot: once EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
; is set the trigger never fires again. The girl and RIOLU remain until the
; reward is resolved, including if the player's party is full.

GoldenrodUndergroundThugSceneFromRow18:
	checkevent EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	iftrue GoldenrodUndergroundThugScene_Done
	applymovement PLAYER, GoldenrodUndergroundPlayerBacksDownMovement
	sjump GoldenrodUndergroundThugScene

GoldenrodUndergroundThugSceneTrigger:
	checkevent EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	iftrue GoldenrodUndergroundThugScene_Done
GoldenrodUndergroundThugScene:
	turnobject PLAYER, RIGHT
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15

; The girl is still pleading with them; they have not noticed you yet.
	opentext
	writetext GoldenrodUndergroundGirlPleaText
	waitbutton
	closetext
	opentext
	writetext GoldenrodUndergroundThugsDemandText
	waitbutton
	closetext

; RIOLU steps between the girl and TEAM ROCKET: (25,17) -> (24,18).
	applymovement GOLDENRODUNDERGROUND_RIOLU, GoldenrodUndergroundRioluProtectMovement
	opentext
	writetext GoldenrodUndergroundRioluText
	cry RIOLU
	waitsfx
	waitbutton
	closetext

; Now they notice you.
	showemote EMOTE_SHOCK, GOLDENRODUNDERGROUND_THUG_PAULIE, 15
	showemote EMOTE_SHOCK, GOLDENRODUNDERGROUND_THUG_BOBBY, 15
	showemote EMOTE_SHOCK, GOLDENRODUNDERGROUND_THUG_TONY, 15
	turnobject GOLDENRODUNDERGROUND_THUG_PAULIE, LEFT
	turnobject GOLDENRODUNDERGROUND_THUG_BOBBY, LEFT
	turnobject GOLDENRODUNDERGROUND_THUG_TONY, LEFT
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext GoldenrodUndergroundThugNoticeText
	waitbutton
	closetext

; PAULIE comes at you from above.
	applymovement GOLDENRODUNDERGROUND_THUG_PAULIE, GoldenrodUndergroundThugPaulieApproachMovement
	turnobject PLAYER, UP
	winlosstext GoldenrodUndergroundThugPaulieBeatenText, 0
	setlasttalked GOLDENRODUNDERGROUND_THUG_PAULIE
	loadtrainer GRUNTM, GRUNTM_GOLDENROD_RIOLU
	startbattle
	reloadmapafterbattle
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext GoldenrodUndergroundThugPaulieAfterText
	waitbutton
	closetext

; BOBBY steps around and blocks you from the front.
	applymovement GOLDENRODUNDERGROUND_THUG_BOBBY, GoldenrodUndergroundThugBobbyApproachMovement
	turnobject PLAYER, RIGHT
	winlosstext GoldenrodUndergroundThugBobbyBeatenText, 0
	setlasttalked GOLDENRODUNDERGROUND_THUG_BOBBY
	loadtrainer GRUNTF, GRUNTF_GOLDENROD_RIOLU
	startbattle
	reloadmapafterbattle
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext GoldenrodUndergroundThugBobbyAfterText
	waitbutton
	closetext

; TONY shoves BOBBY out of the way and takes his spot.
	applymovement GOLDENRODUNDERGROUND_THUG_TONY, GoldenrodUndergroundThugTonyApproachMovement
	playsound SFX_TACKLE
	applymovement GOLDENRODUNDERGROUND_THUG_BOBBY, GoldenrodUndergroundThugBobbyShovedMovement
	applymovement GOLDENRODUNDERGROUND_THUG_TONY, GoldenrodUndergroundThugTonyStepInMovement
	turnobject PLAYER, RIGHT
	opentext
	writetext GoldenrodUndergroundThugTonyShoveText
	waitbutton
	closetext
	winlosstext GoldenrodUndergroundThugTonyBeatenText, 0
	setlasttalked GOLDENRODUNDERGROUND_THUG_TONY
	loadtrainer GRUNTM, GRUNTM_GOLDENROD_RIOLU_LEADER
	startbattle
	reloadmapafterbattle
	playmusic MUSIC_ROCKET_ENCOUNTER

; They give up on RIOLU and clear out around you.
	opentext
	writetext GoldenrodUndergroundThugTonyAfterText
	waitbutton
	closetext
	opentext
	writetext GoldenrodUndergroundThugBobbyRingText
	waitbutton
	closetext
	opentext
	writetext GoldenrodUndergroundThugTonyForgetItText
	waitbutton
	closetext
	applymovement GOLDENRODUNDERGROUND_THUG_PAULIE, GoldenrodUndergroundThugLeavesFrom21Movement
	disappear GOLDENRODUNDERGROUND_THUG_PAULIE
	applymovement GOLDENRODUNDERGROUND_THUG_BOBBY, GoldenrodUndergroundThugLeavesFrom22Movement
	disappear GOLDENRODUNDERGROUND_THUG_BOBBY
	applymovement GOLDENRODUNDERGROUND_THUG_TONY, GoldenrodUndergroundThugTonyLeavesMovement
	disappear GOLDENRODUNDERGROUND_THUG_TONY
	setevent EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	special RestartMapMusic

; The girl comes over to thank you.
	applymovement GOLDENRODUNDERGROUND_GIRL, GoldenrodUndergroundGirlApproachMovement
	applymovement GOLDENRODUNDERGROUND_RIOLU, GoldenrodUndergroundRioluApproachMovement
	turnobject PLAYER, UP
	opentext
	scall GoldenrodUndergroundGirlRewardScript
	iffalse GoldenrodUndergroundThugScene_RewardPending
	closetext
	applymovement GOLDENRODUNDERGROUND_GIRL, GoldenrodUndergroundGirlLeavesMovement
	disappear GOLDENRODUNDERGROUND_GIRL
	checkevent EVENT_GOT_RIOLU_FROM_GOLDENROD_UNDERGROUND_GIRL
	iftrue GoldenrodUndergroundThugScene_Done
	applymovement GOLDENRODUNDERGROUND_RIOLU, GoldenrodUndergroundThugLeavesFrom22Movement
	disappear GOLDENRODUNDERGROUND_RIOLU
GoldenrodUndergroundThugScene_Done:
	end

GoldenrodUndergroundThugScene_RewardPending:
	closetext
	end

; Fallback if you walk away before she can hand the rewards over.
GoldenrodUndergroundGirlScript:
	faceplayer
	checkevent EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	iffalse .StillCornered
	opentext
	scall GoldenrodUndergroundGirlRewardScript
	iffalse .RewardPending
	closetext
	disappear GOLDENRODUNDERGROUND_GIRL
	disappear GOLDENRODUNDERGROUND_RIOLU
	end

.StillCornered:
	jumptext GoldenrodUndergroundGirlPleaText

.RewardPending:
	closetext
	end

GoldenrodUndergroundGirlRewardScript:
	checkevent EVENT_GOT_RIOLU_FROM_GOLDENROD_UNDERGROUND_GIRL
	iftrue .Farewell
	writetext GoldenrodUndergroundGirlThanksText
	yesorno
	iffalse .DeclinedRiolu
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	writetext GoldenrodUndergroundGirlAcceptedText
	waitbutton
	writetext GoldenrodUndergroundGirlReceivedRioluText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	givepoke RIOLU, 15
	special SetLastPartyMonMale
	setevent EVENT_GOT_RIOLU_FROM_GOLDENROD_UNDERGROUND_GIRL
	disappear GOLDENRODUNDERGROUND_RIOLU
	sjump .Farewell

.DeclinedRiolu:
	writetext GoldenrodUndergroundGirlDeclinedText
	waitbutton

.Farewell:
	setevent EVENT_GOLDENROD_UNDERGROUND_GIRL_LEFT
	writetext GoldenrodUndergroundGirlFarewellText
	waitbutton
	setval TRUE
	return

.PartyFull:
	writetext GoldenrodUndergroundGirlPartyFullText
	waitbutton
	setval FALSE
	return

; The ROCKET grunts are unreachable until the scene fires, but give them something.
GoldenrodUndergroundThugScript:
	faceplayer
	opentext
	writetext GoldenrodUndergroundThugsDemandText
	waitbutton
	closetext
	end

GoldenrodUndergroundRioluScript:
	opentext
	writetext GoldenrodUndergroundRioluText
	cry RIOLU
	waitsfx
	waitbutton
	closetext
	end

GoldenrodUndergroundRioluProtectMovement:
	step LEFT
	step DOWN
	turn_head LEFT
	jump_in_place
	jump_in_place
	step_end

GoldenrodUndergroundRioluApproachMovement:
	step LEFT
	step LEFT
	turn_head LEFT
	step_end

GoldenrodUndergroundPlayerBacksDownMovement:
	step DOWN
	step_end

GoldenrodUndergroundThugPaulieApproachMovement:
	step LEFT
	step DOWN
	step LEFT
	turn_head DOWN
	step_end

GoldenrodUndergroundThugBobbyApproachMovement:
	step DOWN
	step LEFT
	step_end

GoldenrodUndergroundThugTonyApproachMovement:
	step LEFT
	step_end

GoldenrodUndergroundThugBobbyShovedMovement:
	big_step UP
	turn_head DOWN
	step_end

GoldenrodUndergroundThugTonyStepInMovement:
	step LEFT
	step_end

GoldenrodUndergroundThugLeavesFrom21Movement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

GoldenrodUndergroundThugLeavesFrom22Movement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

GoldenrodUndergroundThugTonyLeavesMovement:
	big_step UP
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

GoldenrodUndergroundGirlApproachMovement:
	step UP
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step LEFT
	turn_head DOWN
	step_end

GoldenrodUndergroundGirlLeavesMovement:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

SupernerdEricSeenText:
	text "I got booted out"
	line "of the GAME COR-"
	cont "NER."

	para "I was trying to"
	line "cheat using my"
	cont "#MON…"
	done

SupernerdEricBeatenText:
	text "…Grumble…"
	done

SupernerdEricAfterBattleText:
	text "I guess I have to"
	line "do things fair and"
	cont "square…"
	done

SupernerdTeruSeenText:
	text "Do you consider"
	line "type alignments in"
	cont "battle?"

	para "If you know your"
	line "type advantages,"

	para "you'll do better"
	line "in battle."
	done

SupernerdTeruBeatenText:
	text "Ow, ow, ow!"
	done

SupernerdTeruAfterBattleText:
	text "I know my #MON"
	line "type alignments."

	para "But I only use one"
	line "type of #MON."
	done

PokemaniacIssacSeenText:
	text "My #MON just"
	line "got a haircut!"

	para "I'll show you how"
	line "strong it is!"
	done

PokemaniacIssacBeatenText:
	text "Aiyeeee!"
	done

PokemaniacIssacAfterBattleText:
	text "Your #MON will"
	line "like you more if"

	para "you give them"
	line "haircuts."
	done

PokemaniacDonaldSeenText:
	text "I think you have"
	line "some rare #MON"
	cont "with you."

	para "Let me see them!"
	done

PokemaniacDonaldBeatenText:
	text "Gaah! I lost!"
	line "That makes me mad!"
	done

PokemaniacDonaldAfterBattleText:
	text "Are you making a"
	line "#DEX? Here's a"
	cont "hot tip."

	para "The HIKER on ROUTE"
	line "33, ANTHONY, is a"
	cont "good guy."

	para "He'll phone you if"
	line "he sees any rare"
	cont "#MON."
	done

GoldenrodUndergroundTheDoorsLockedText:
	text "The door's locked…"
	done

GoldenrodUndergroundTheDoorIsOpenText:
	text "The door is open."
	done

GoldenrodUndergroundBasementKeyOpenedDoorText:
	text "The BASEMENT KEY"
	line "opened the door."
	done

GoldenrodUndergroundOlderHaircutBrotherOfferHaircutText:
	text "Welcome!"

	para "I run the #MON"
	line "SALON!"

	para "I'm the older and"
	line "better of the two"
	cont "HAIRCUT BROTHERS."

	para "I can make your"
	line "#MON beautiful"
	cont "for just ¥500."

	para "Would you like me"
	line "to do that?"
	done

GoldenrodUndergroundOlderHaircutBrotherAskWhichMonText:
	text "Which #MON"
	line "should I work on?"
	done

GoldenrodUndergroundOlderHaircutBrotherWatchItBecomeBeautifulText:
	text "OK! Watch it"
	line "become beautiful!"
	done

GoldenrodUndergroundOlderHaircutBrotherAllDoneText:
	text "There! All done!"
	done

GoldenrodUndergroundOlderHaircutBrotherThatsAShameText:
	text "Is that right?"
	line "That's a shame!"
	done

GoldenrodUndergroundOlderHaircutBrotherYoullNeedMoreMoneyText:
	text "You'll need more"
	line "money than that."
	done

GoldenrodUndergroundOlderHaircutBrotherOneHaircutADayText:
	text "I do only one"
	line "haircut a day. I'm"
	cont "done for today."
	done

GoldenrodUndergroundYoungerHaircutBrotherOfferHaircutText:
	text "Welcome to the"
	line "#MON SALON!"

	para "I'm the younger"
	line "and less expen-"
	cont "sive of the two"
	cont "HAIRCUT BROTHERS."

	para "I'll spiff up your"
	line "#MON for just"
	cont "¥300."

	para "So? How about it?"
	done

GoldenrodUndergroundYoungerHaircutBrotherAskWhichMonText:
	text "OK, which #MON"
	line "should I do?"
	done

GoldenrodUndergroundYoungerHaircutBrotherIllMakeItLookCoolText:
	text "OK! I'll make it"
	line "look cool!"
	done

GoldenrodUndergroundYoungerHaircutBrotherAllDoneText:
	text "There we go!"
	line "All done!"
	done

GoldenrodUndergroundYoungerHaircutBrotherHowDisappointingText:
	text "No? "
	line "How disappointing!"
	done

GoldenrodUndergroundYoungerHaircutBrotherShortOnFundsText:
	text "You're a little"
	line "short on funds."
	done

GoldenrodUndergroundYoungerHaircutBrotherOneHaircutADayText:
	text "I can do only one"
	line "haircut a day."

	para "Sorry, but I'm all"
	line "done for today."
	done

HaircutBrosText_SlightlyHappier:
	text_ram wStringBuffer3
	text " looks a"
	line "little happier."
	done

HaircutBrosText_Happier:
	text_ram wStringBuffer3
	text " looks"
	line "happy."
	done

HaircutBrosText_MuchHappier:
	text_ram wStringBuffer3
	text " looks"
	line "delighted!"
	done

GoldenrodUndergroundWeAreNotOpenTodayText:
	text "We're not open"
	line "today."
	done

GoldenrodUndergroundNoEntryText:
	text "NO ENTRY BEYOND"
	line "THIS POINT"
	done

GoldenrodUndergroundGirlPleaText:
	text "Leave me alone!"

	para "You can't take my"
	line "grandma's RIOLU!"
	done

GoldenrodUndergroundThugsDemandText:
	text "Hand it over"
	line "already!"

	para "That rare #MON"
	line "will make TEAM"
	cont "ROCKET a fortune!"
	done

GoldenrodUndergroundThugNoticeText:
	text "Huh? Who invited"
	line "you?"

	para "Beat it, kid. This"
	line "is TEAM ROCKET"
	cont "business!"
	done

GoldenrodUndergroundThugPaulieBeatenText:
	text "No way!"
	done

GoldenrodUndergroundThugPaulieAfterText:
	text "I was caught off"
	line "guard!"

	para "You're no match"
	line "for the others!"
	done

GoldenrodUndergroundThugBobbyBeatenText:
	text "What? I lost?!"
	done

GoldenrodUndergroundThugBobbyAfterText:
	text "How humiliating…"
	done

GoldenrodUndergroundThugTonyShoveText:
	text "Move it!"

	para "I can't believe"
	line "you two can't"
	cont "handle this kid!"
	done

GoldenrodUndergroundThugTonyBeatenText:
	text "Ugh! The kid's"
	line "for real!"
	done

GoldenrodUndergroundThugTonyAfterText:
	text "This kid's tougher"
	line "than I thought…"

	para "We're pulling out."
	done

GoldenrodUndergroundThugBobbyRingText:
	text "But what about"
	line "the #MON?"
	done

GoldenrodUndergroundThugTonyForgetItText:
	text "FORGET THE RIOLU!"

	para "We can't take it"
	line "with this brat in"
	cont "the way."

	para "Move out, now!"
	done

GoldenrodUndergroundGirlThanksText:
	text "Oh, thank you so"
	line "much!"

	para "Those TEAM ROCKET"
	line "members chased us"
	cont "all the way down"
	cont "here."

	para "RIOLU was my"
	line "grandma's. They'll"
	cont "come back for him,"
	cont "and I can't fight"
	cont "them off."

	para "He's brave for his"
	line "size. He'd be"
	cont "safer with a"
	cont "trainer like you."

	para "Would you please"
	line "take him?"
	done

GoldenrodUndergroundGirlAcceptedText:
	text "Wonderful! I know"
	line "you'll take good"
	cont "care of him."
	done

GoldenrodUndergroundGirlReceivedRioluText:
	text "<PLAYER> received"
	line "RIOLU!"
	done

GoldenrodUndergroundGirlDeclinedText:
	text "That's all right."

	para "It was a lot"
	line "to ask of you."

	para "I'll just have to"
	line "be more careful"
	cont "taking him out"
	cont "from now on."
	done

GoldenrodUndergroundGirlFarewellText:
	text "Thank you again!"

	para "I'm getting out of"
	line "here."
	done

GoldenrodUndergroundGirlPartyFullText:
	text "Oh… Your party is"
	line "full."

	para "Make room for"
	line "RIOLU, then come"
	cont "talk to me again."
	done

GoldenrodUndergroundRioluText:
	text "RIOLU: RIO!"
	done

GoldenrodUnderground_MapEvents:
	db 0, 0 ; filler

	db 6 ; warp events
	warp_event  3,  2, GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES, 7
	warp_event  3, 34, GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES, 4
	warp_event 18,  6, GOLDENROD_UNDERGROUND, 4
	warp_event 25, 35, GOLDENROD_UNDERGROUND, 3
	warp_event 26, 35, GOLDENROD_UNDERGROUND, 3
	warp_event 26, 31, GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES, 1

	db 2 ; coord events
	coord_event 21, 18, -1, GoldenrodUndergroundThugSceneFromRow18
	coord_event 21, 19, -1, GoldenrodUndergroundThugSceneTrigger

	db 5 ; bg events
	bg_event 18,  6, BGEVENT_READ, BasementDoorScript
	bg_event 19,  6, BGEVENT_READ, GoldenrodUndergroundNoEntrySign
	bg_event  6, 13, BGEVENT_ITEM, GoldenrodUndergroundHiddenParlyzHeal
	bg_event  4, 18, BGEVENT_ITEM, GoldenrodUndergroundHiddenSuperPotion
	bg_event 17,  8, BGEVENT_ITEM, GoldenrodUndergroundHiddenAntidote

	db 14 ; object events
	object_event  5, 31, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerSupernerdEric, -1
	object_event  6,  9, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerSupernerdTeru, -1
	object_event  3, 27, SPRITE_POKEMANIAC_NEW, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerPokemaniacIssac, -1
	object_event  2,  6, SPRITE_POKEMANIAC_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemaniacDonald, -1
	object_event  7, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, GoldenrodUndergroundCoinCase, EVENT_GOLDENROD_UNDERGROUND_COIN_CASE
	object_event  7, 11, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, BargainMerchantScript, EVENT_GOLDENROD_UNDERGROUND_GRAMPS
	object_event  7, 14, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlderHaircutBrotherScript, EVENT_GOLDENROD_UNDERGROUND_OLDER_HAIRCUT_BROTHER
	object_event  7, 15, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, YoungerHaircutBrotherScript, EVENT_GOLDENROD_UNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	object_event  7, 21, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, BitterMerchantScript, EVENT_GOLDENROD_UNDERGROUND_GRANNY
	object_event 25, 18, SPRITE_SCHOOL_GIRL, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, GoldenrodUndergroundGirlScript, EVENT_GOLDENROD_UNDERGROUND_GIRL_LEFT
	object_event 23, 17, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodUndergroundThugScript, EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	object_event 23, 18, SPRITE_ROCKET_GIRL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodUndergroundThugScript, EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	object_event 24, 19, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodUndergroundThugScript, EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN
	object_event 25, 17, SPRITE_RIOLU, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodUndergroundRioluScript, EVENT_GOLDENROD_UNDERGROUND_GIRL_LEFT

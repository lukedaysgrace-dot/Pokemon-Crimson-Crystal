	object_const_def ; object_event constants
	const ROUTE31_FISHER
	const ROUTE31_YOUNGSTER
	const ROUTE31_BUG_CATCHER
	const ROUTE31_COOLTRAINER_M
	const ROUTE31_FRUIT_TREE
	const ROUTE31_POKE_BALL1
	const ROUTE31_POKE_BALL2
	const ROUTE31_WIMPOD

Route31_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .CheckMomCall
	callback MAPCALLBACK_OBJECTS, .Wimpod

.Wimpod:
	checkevent EVENT_ROUTE_31_WIMPOD_FINISHED
	iffalse .WimpodDone
	disappear ROUTE31_WIMPOD
.WimpodDone:
	return

.CheckMomCall:
	checkevent EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST
	iffalse .DoMomCall
	return

.DoMomCall:
	specialphonecall SPECIALCALL_WORRIED
	return

TrainerBugCatcherWade1:
	trainer BUG_CATCHER, WADE1, EVENT_BEAT_BUG_CATCHER_WADE, BugCatcherWade1SeenText, BugCatcherWade1BeatenText, 0, .Script

.Script:
	loadvar VAR_CALLERID, PHONE_BUG_CATCHER_WADE
	endifjustbattled
	opentext
	checkflag ENGINE_WADE
	iftrue .WadeRematch
	checkflag ENGINE_WADE_HAS_ITEM
	iftrue .WadeItem
	checkcellnum PHONE_BUG_CATCHER_WADE
	iftrue .AcceptedNumberSTD
	checkevent EVENT_WADE_ASKED_FOR_PHONE_NUMBER
	iftrue .AskAgain
	writetext BugCatcherWade1AfterText
	waitbutton
	setevent EVENT_WADE_ASKED_FOR_PHONE_NUMBER
	scall .AskPhoneNumberSTD
	sjump .Continue

.AskAgain:
	scall .AskAgainSTD
.Continue:
	askforphonenumber PHONE_BUG_CATCHER_WADE
	ifequal PHONE_CONTACTS_FULL, .PhoneFullSTD
	ifequal PHONE_CONTACT_REFUSED, .DeclinedNumberSTD
	gettrainername STRING_BUFFER_3, BUG_CATCHER, WADE1
	scall .RegisterNumberSTD
	sjump .AcceptedNumberSTD

.WadeRematch:
	scall .RematchSTD
	winlosstext BugCatcherWade1BeatenText, 0
	readmem wWadeFightCount
	ifequal 4, .Fight4
	ifequal 3, .Fight3
	ifequal 2, .Fight2
	ifequal 1, .Fight1
	ifequal 0, .LoadFight0
.Fight4:
	checkevent EVENT_BEAT_ELITE_FOUR
	iftrue .LoadFight4
.Fight3:
	checkevent EVENT_CLEARED_RADIO_TOWER
	iftrue .LoadFight3
.Fight2:
	checkflag ENGINE_FLYPOINT_MAHOGANY
	iftrue .LoadFight2
.Fight1:
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iftrue .LoadFight1
.LoadFight0:
	loadtrainer BUG_CATCHER, WADE1
	startbattle
	reloadmapafterbattle
	loadmem wWadeFightCount, 1
	clearflag ENGINE_WADE
	end

.LoadFight1:
	loadtrainer BUG_CATCHER, WADE2
	startbattle
	reloadmapafterbattle
	loadmem wWadeFightCount, 2
	clearflag ENGINE_WADE
	end

.LoadFight2:
	loadtrainer BUG_CATCHER, WADE3
	startbattle
	reloadmapafterbattle
	loadmem wWadeFightCount, 3
	clearflag ENGINE_WADE
	end

.LoadFight3:
	loadtrainer BUG_CATCHER, WADE4
	startbattle
	reloadmapafterbattle
	loadmem wWadeFightCount, 4
	clearflag ENGINE_WADE
	end

.LoadFight4:
	loadtrainer BUG_CATCHER, WADE5
	startbattle
	reloadmapafterbattle
	clearflag ENGINE_WADE
	end

.WadeItem:
	scall .ItemSTD
	checkevent EVENT_WADE_HAS_BERRY
	iftrue .Berry
	checkevent EVENT_WADE_HAS_PSNCUREBERRY
	iftrue .Psncureberry
	checkevent EVENT_WADE_HAS_PRZCUREBERRY
	iftrue .Przcureberry
	checkevent EVENT_WADE_HAS_BITTER_BERRY
	iftrue .BitterBerry
.Berry:
	verbosegiveitem BERRY
	iffalse .PackFull
	sjump .Done
.Psncureberry:
	verbosegiveitem PSNCUREBERRY
	iffalse .PackFull
	sjump .Done
.Przcureberry:
	verbosegiveitem PRZCUREBERRY
	iffalse .PackFull
	sjump .Done
.BitterBerry:
	verbosegiveitem BITTER_BERRY
	iffalse .PackFull
.Done:
	clearflag ENGINE_WADE_HAS_ITEM
	sjump .AcceptedNumberSTD
.PackFull:
	sjump .PackFullSTD

.AskPhoneNumberSTD:
	jumpstd asknumber1m
	end

.AskAgainSTD:
	jumpstd asknumber2m
	end

.RegisterNumberSTD:
	jumpstd registerednumberm
	end

.AcceptedNumberSTD:
	jumpstd numberacceptedm
	end

.DeclinedNumberSTD:
	jumpstd numberdeclinedm
	end

.PhoneFullSTD:
	jumpstd phonefullm
	end

.RematchSTD:
	jumpstd rematchm
	end

.ItemSTD:
	jumpstd giftm
	end

.PackFullSTD:
	jumpstd packfullm
	end

Route31MailRecipientScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM50_HONE_CLAWS
	iftrue .DescribeHoneClaws
	checkevent EVENT_GOT_KENYA
	iftrue .TryGiveKenya
	writetext Text_Route31SleepyMan
	waitbutton
	closetext
	end

.TryGiveKenya:
	writetext Text_Route31SleepyManGotMail
	buttonsound
	checkpokemail ReceivedSpearowMailText
	ifequal POKEMAIL_WRONG_MAIL, .WrongMail
	ifequal POKEMAIL_REFUSED, .Refused
	ifequal POKEMAIL_NO_MAIL, .NoMail
	ifequal POKEMAIL_LAST_MON, .LastMon
	; POKEMAIL_CORRECT
	writetext Text_Route31HandOverMailMon
	buttonsound
	writetext Text_Route31ReadingMail
	buttonsound
	setevent EVENT_GAVE_KENYA
	verbosegiveitem TM_HONE_CLAWS
	iffalse .NoRoomForItems
	setevent EVENT_GOT_TM50_HONE_CLAWS
.DescribeHoneClaws:
	writetext Text_Route31DescribeHoneClaws
	waitbutton
.NoRoomForItems:
	closetext
	end

.WrongMail:
	writetext Text_Route31WrongMail
	waitbutton
	closetext
	end

.NoMail:
	writetext Text_Route31MissingMail
	waitbutton
	closetext
	end

.Refused:
	writetext Text_Route31DeclinedToHandOverMail
	waitbutton
	closetext
	end

.LastMon:
	writetext Text_Route31CantTakeLastMon
	waitbutton
	closetext
	end

ReceivedSpearowMailText:
	db   "DARK CAVE leads"
	next "to another road@"

Route31YoungsterScript:
	jumptextfaceplayer Route31YoungsterText

Route31Sign:
	jumptext Route31SignText

DarkCaveSign:
	jumptext DarkCaveSignText

Route31CooltrainerMScript:
	jumptextfaceplayer Route31CooltrainerMText

Route31FruitTree:
	fruittree FRUITTREE_ROUTE_31

Route31Potion:
	itemball POTION

Route31PokeBall:
	itemball POKE_BALL

Route31WimpodProximity:
	checkevent EVENT_ROUTE_31_WIMPOD_HIDDEN
	iftrue .Done
	checkevent EVENT_ROUTE_31_WIMPOD_WAITING
	iftrue .Done
	checkevent EVENT_ROUTE_31_WIMPOD_SWEET_SCENT
	iftrue Route31WimpodApproach
	sjump Route31WimpodFlee
.Done:
	end

Route31WimpodScript:
	checkevent EVENT_ROUTE_31_WIMPOD_WAITING
	iftrue Route31WimpodBattle
	; Also handle interacting from beside it after loading a save nearby.
	checkevent EVENT_ROUTE_31_WIMPOD_SWEET_SCENT
	iftrue Route31WimpodApproach
	sjump Route31WimpodFlee

Route31WimpodFlee:
	showemote EMOTE_SHOCK, ROUTE31_WIMPOD, 15
	; A player to the west blocks the straight escape. Go around below
	; them and use the left den tile (18,5); otherwise use (19,5).
	readvar VAR_YCOORD
	ifnotequal 6, .RightDen
	readvar VAR_XCOORD
	ifequal 20, .LeftDen
	ifequal 21, .LeftDen
.RightDen:
	applymovement ROUTE31_WIMPOD, Route31WimpodRunRightDen
	sjump .EnterDen
.LeftDen:
	applymovement ROUTE31_WIMPOD, Route31WimpodRunLeftDen
.EnterDen:
	; Start the final step without waiting for its destination. Remove the
	; sprite halfway into the cave, while it is still moving from row 6.
	callasm Route31WimpodStartEnteringDen
	deactivatefacing 10
	disappear ROUTE31_WIMPOD
	callasm Route31WimpodFinishEnteringDen
	opentext
	writetext Route31WimpodFledText
	waitbutton
	closetext
	end

Route31WimpodApproach:
	setevent EVENT_ROUTE_31_WIMPOD_WAITING
	opentext
	writetext Route31WimpodLikesScentText
	waitbutton
	closetext
	; The land-side trigger ring is two tiles away. Stop beside the
	; player, facing them, and leave the battle for the next A press.
	readvar VAR_XCOORD
	ifequal 20, .FromLeft
	ifequal 24, .FromRight
	readvar VAR_YCOORD
	ifnotequal 8, .Ready
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachDown
	readvar VAR_XCOORD
	ifequal 21, .StepLeft
	ifequal 23, .StepRight
	sjump .Ready
.FromLeft:
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachLeft
	sjump .Vertical
.FromRight:
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachRight
.Vertical:
	readvar VAR_YCOORD
	ifequal 6, .Ready
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachDown
	readvar VAR_YCOORD
	ifequal 7, .Ready
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachDown
	sjump .Ready
.StepLeft:
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachLeft
	sjump .Ready
.StepRight:
	applymovement ROUTE31_WIMPOD, Route31WimpodApproachRight
.Ready:
	writeobjectxy ROUTE31_WIMPOD
	faceobject ROUTE31_WIMPOD, PLAYER
	faceobject PLAYER, ROUTE31_WIMPOD
	end

Route31WimpodBattle:
	faceplayer
	showemote EMOTE_SHOCK, ROUTE31_WIMPOD, 15
	; Match the player's facing to turn away from them before the battle.
	readvar VAR_FACING
	ifequal DOWN, .TurnDown
	ifequal UP, .TurnUp
	ifequal LEFT, .TurnLeft
	turnobject ROUTE31_WIMPOD, RIGHT
	sjump .Battle
.TurnDown:
	turnobject ROUTE31_WIMPOD, DOWN
	sjump .Battle
.TurnUp:
	turnobject ROUTE31_WIMPOD, UP
	sjump .Battle
.TurnLeft:
	turnobject ROUTE31_WIMPOD, LEFT
.Battle:
	pause 8
	cry WIMPOD
	waitsfx
	loadwildmon WIMPOD, 8
	startbattle
	setevent EVENT_ROUTE_31_WIMPOD_FINISHED
	disappear ROUTE31_WIMPOD
	reloadmapafterbattle
	end

Route31WimpodStartEnteringDen:
	; Native object routines use zero-based map indices, unlike scripts.
	ld c, ROUTE31_WIMPOD - 1
	farcall SetFlagsForMovement_1
	ld c, ROUTE31_WIMPOD - 1
	ld b, BANK(Route31WimpodEnterDen)
	ld hl, Route31WimpodEnterDen
	jp GetMovementData

LoadRoute31WimpodPalette::
; Reuse Route 31's unoccupied rock OBJ palette for opaque gray and purple.
	ld a, [wMapGroup]
	cp GROUP_ROUTE_31
	ret nz
	ld a, [wMapNumber]
	cp MAP_ROUTE_31
	ret nz
	ld hl, .GrayPurple
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM
.GrayPurple:
	RGB 31,31,31, 24,24,24, 18,04,18, 00,00,00

Route31WimpodFinishEnteringDen:
	ld hl, wVramState
	res 7, [hl]
	ret

Route31WimpodRunRightDen:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

Route31WimpodRunLeftDen:
	big_step DOWN
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step UP
	step_end

Route31WimpodEnterDen:
	step UP
	step_end

Route31WimpodApproachDown:
	step DOWN
	step_end

Route31WimpodApproachLeft:
	step LEFT
	step_end

Route31WimpodApproachRight:
	step RIGHT
	step_end

Route31WimpodFledText:
	text "WIMPOD scurried"
	line "to its den!"
	done

Route31WimpodLikesScentText:
	text "WIMPOD looks at"
	line "you with a"
	cont "peculiar glance."

	para "It seems to like"
	line "your smell!"
	done

Route31CooltrainerMText:
	text "DARK CAVE…"

	para "If #MON could"
	line "light it up, I'd"
	cont "explore it."
	done

BugCatcherWade1SeenText:
	text "I caught a bunch"
	line "of #MON. Let me"
	cont "battle with you!"
	done

BugCatcherWade1BeatenText:
	text "Awwwww…"
	done

BugCatcherWade1AfterText:
	text "You can catch"
	line "#MON even if"

	para "you have six with"
	line "you."

	para "If you catch one,"
	line "it'll go to your"
	cont "BOX automatically."
	done

Text_Route31SleepyMan:
	text "… Hnuurg… Huh?"

	para "I walked too far"
	line "today looking for"
	cont "#MON."

	para "My feet hurt and"
	line "I'm sleepy…"

	para "If I were a wild"
	line "#MON, I'd be"
	cont "easy to catch…"

	para "…Zzzz…"
	done

Text_Route31SleepyManGotMail:
	text "…Zzzz… Huh?"

	para "What's that? You"
	line "have MAIL for me?"
	done

Text_Route31HandOverMailMon:
	text "<PLAYER> handed"
	line "over the #MON"
	cont "holding the MAIL."
	done

Text_Route31ReadingMail:
	text "Let's see…"

	para "…DARK CAVE leads"
	line "to another road…"

	para "That's good to"
	line "know."

	para "Thanks for bring-"
	line "ing this to me."

	para "My friend's a good"
	line "guy, and you're"
	cont "swell too!"

	para "I'd like to do"
	line "something good in"
	cont "return too!"

	para "I know! I want you"
	line "to have this!"
	done

Text_Route31DescribeHoneClaws:
	text "TM50 is HONE"
	line "CLAWS."

	para "It sharpens claws"
	line "to raise ATTACK"
	cont "and accuracy too."

	para "Ooooh… That sounds"
	line "sharp!"

	para "Handy against"
	line "#MON that like"
	cont "to dodge, I bet."
	done

Text_Route31WrongMail:
	text "This MAIL isn't"
	line "for me."
	done

Text_Route31MissingMail:
	text "Why is this #-"
	line "MON so special?"

	para "It doesn't have"
	line "any MAIL."
	done

Text_Route31DeclinedToHandOverMail:
	text "What? You don't"
	line "want anything?"
	done

Text_Route31CantTakeLastMon:
	text "If I take that"
	line "#MON from you,"

	para "what are you going"
	line "to use in battle?"
	done

Route31YoungsterText:
	text "I found a good"
	line "#MON in DARK"
	cont "CAVE."

	para "I'm going to raise"
	line "it to take on"
	cont "FALKNER."

	para "He's the leader of"
	line "VIOLET CITY's GYM."
	done

Route31SignText:
	text "ROUTE 31"

	para "VIOLET CITY -"
	line "CHERRYGROVE CITY"
	done

DarkCaveSignText:
	text "DARK CAVE"
	done

Route31_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  4,  6, ROUTE_31_VIOLET_GATE, 3
	warp_event  4,  7, ROUTE_31_VIOLET_GATE, 4
	warp_event 34,  5, DARK_CAVE_VIOLET_ENTRANCE, 1

	db 9 ; coord events
	coord_event 20, 6, -1, Route31WimpodProximity
	coord_event 20, 7, -1, Route31WimpodProximity
	coord_event 20, 8, -1, Route31WimpodProximity
	coord_event 21, 8, -1, Route31WimpodProximity
	coord_event 22, 8, -1, Route31WimpodProximity
	coord_event 23, 8, -1, Route31WimpodProximity
	coord_event 24, 8, -1, Route31WimpodProximity
	coord_event 24, 7, -1, Route31WimpodProximity
	coord_event 24, 6, -1, Route31WimpodProximity

	db 2 ; bg events
	bg_event  7,  5, BGEVENT_READ, Route31Sign
	bg_event 31,  5, BGEVENT_READ, DarkCaveSign

	db 8 ; object events
	object_event 17,  4, SPRITE_FAT_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route31MailRecipientScript, -1
	object_event  9,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route31YoungsterScript, -1
	object_event 21, 13, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 5, TrainerBugCatcherWade1, -1
	object_event 33,  8, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route31CooltrainerMScript, -1
	object_event 16,  4, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route31FruitTree, -1
	object_event 30,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route31Potion, EVENT_ROUTE_31_POTION
	object_event 19, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route31PokeBall, EVENT_ROUTE_31_POKE_BALL
	object_event 22,  6, SPRITE_WIMPOD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_ROCK, OBJECTTYPE_SCRIPT, 0, Route31WimpodScript, EVENT_ROUTE_31_WIMPOD_HIDDEN

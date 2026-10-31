	object_const_def ; object_event constants
	const COPYCATSHOUSE2F_COPYCAT1 ; if player is male
	const COPYCATSHOUSE2F_DODRIO
	const COPYCATSHOUSE2F_FAIRYDOLL ; lost item
	const COPYCATSHOUSE2F_MONSTERDOLL
	const COPYCATSHOUSE2F_BIRDDOLL
	const COPYCATSHOUSE2F_COPYCAT2 ; if player is female
	const COPYCATSHOUSE2F_CHOICE_SCARF

CopycatsHouse2F_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Callback

.Callback:
	; Her own look is a purple School Girl (also fixes older saves that
	; still have the old Lass default stored).
	variablesprite SPRITE_COPYCAT, SPRITE_SCHOOL_GIRL
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Female
	disappear COPYCATSHOUSE2F_COPYCAT2
	appear COPYCATSHOUSE2F_COPYCAT1
	sjump .Done
.Female:
	disappear COPYCATSHOUSE2F_COPYCAT1
	appear COPYCATSHOUSE2F_COPYCAT2
.Done:
	return

Copycat:
	faceplayer
	checkevent EVENT_GOT_PASS_FROM_COPYCAT
	iftrue .GotPass
	checkevent EVENT_RETURNED_LOST_ITEM_TO_COPYCAT
	iftrue .TryGivePassAgain
	checkitem LOST_ITEM
	iftrue .ReturnLostItem
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Default_Female_1
	applymovement COPYCATSHOUSE2F_COPYCAT1, CopycatSpinAroundMovementData
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_GOLD
	special CopycatUsePlayerPalette
	sjump .Default_Merge_1

.Default_Female_1:
	applymovement COPYCATSHOUSE2F_COPYCAT2, CopycatSpinAroundMovementData
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_LYRA
	special CopycatUsePlayerPalette
.Default_Merge_1:
	special RefreshSprites
	checkevent EVENT_RETURNED_MACHINE_PART
	iftrue .TalkAboutLostItem
	opentext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Default_Female_2a
	writetext CopycatText_Male_1
	sjump .Default_Merge_2a

.Default_Female_2a:
	writetext CopycatText_Female_1
.Default_Merge_2a:
	waitbutton
	closetext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Default_Female_3a
	applymovement COPYCATSHOUSE2F_COPYCAT1, CopycatSpinAroundMovementData
	sjump .Default_Merge_3a

.Default_Female_3a:
	applymovement COPYCATSHOUSE2F_COPYCAT2, CopycatSpinAroundMovementData
.Default_Merge_3a:
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_SCHOOL_GIRL
	special CopycatUseOwnPalette
	special RefreshSprites
	opentext
	writetext CopycatText_QuickMimicking
	waitbutton
	closetext
	end

.TalkAboutLostItem:
	opentext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Default_Female_2b
	writetext CopycatText_Male_2
	sjump .Default_Merge_2b

.Default_Female_2b:
	writetext CopycatText_Female_2
.Default_Merge_2b:
	waitbutton
	closetext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Default_Female_3b
	applymovement COPYCATSHOUSE2F_COPYCAT1, CopycatSpinAroundMovementData
	sjump .Default_Merge_3b

.Default_Female_3b:
	applymovement COPYCATSHOUSE2F_COPYCAT2, CopycatSpinAroundMovementData
.Default_Merge_3b:
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_SCHOOL_GIRL
	special CopycatUseOwnPalette
	special RefreshSprites
	opentext
	writetext CopycatText_Worried
	waitbutton
	closetext
	setevent EVENT_MET_COPYCAT_FOUND_OUT_ABOUT_LOST_ITEM
	end

.ReturnLostItem:
	opentext
	writetext CopycatText_GiveDoll
	buttonsound
	takeitem LOST_ITEM
	setevent EVENT_RETURNED_LOST_ITEM_TO_COPYCAT
	clearevent EVENT_COPYCATS_HOUSE_2F_DOLL
	sjump .GivePass

.TryGivePassAgain:
	opentext
.GivePass:
	writetext CopycatText_GivePass
	buttonsound
	verbosegiveitem PASS
	iffalse .Cancel
	setevent EVENT_GOT_PASS_FROM_COPYCAT
	writetext CopycatText_ExplainPass
	waitbutton
	sjump .OfferScarf

.OfferScarfForExistingPass:
	opentext
.OfferScarf:
	checkevent EVENT_TRIED_TAKING_COPYCAT_SCARF
	iftrue .RememberScarf
	writetext CopycatText_OfferScarf
	sjump .ScarfPermission
.RememberScarf:
	writetext CopycatText_RememberScarf
.ScarfPermission:
	waitbutton
	setevent EVENT_COPYCAT_SCARF_PERMISSION
	sjump .OfferMimic

.GotPass:
	checkevent EVENT_COPYCAT_SCARF_PERMISSION
	iffalse .OfferScarfForExistingPass
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .GotPass_Female_1
	applymovement COPYCATSHOUSE2F_COPYCAT1, CopycatSpinAroundMovementData
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_GOLD
	special CopycatUsePlayerPalette
	sjump .GotPass_Merge_1

.GotPass_Female_1:
	applymovement COPYCATSHOUSE2F_COPYCAT2, CopycatSpinAroundMovementData
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_LYRA
	special CopycatUsePlayerPalette
.GotPass_Merge_1:
	special RefreshSprites
	opentext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .GotPass_Female_2
	writetext CopycatText_Male_3
	sjump .GotPass_Merge_2

.GotPass_Female_2:
	writetext CopycatText_Female_3
.GotPass_Merge_2:
	waitbutton
	closetext
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .GotPass_Female_3
	applymovement COPYCATSHOUSE2F_COPYCAT1, CopycatSpinAroundMovementData
	sjump .GotPass_Merge_3

.GotPass_Female_3:
	applymovement COPYCATSHOUSE2F_COPYCAT2, CopycatSpinAroundMovementData
.GotPass_Merge_3:
	faceplayer
	variablesprite SPRITE_COPYCAT, SPRITE_SCHOOL_GIRL
	special CopycatUseOwnPalette
	special RefreshSprites
	opentext
	writetext CopycatText_ItsAScream
	waitbutton
	; fallthrough
.OfferMimic:
; After the lost doll is returned, the Copycat teaches MIMIC anytime.
	writetext CopycatText_OfferMimic
	yesorno
	iffalse .DeclinedMimic
	setval MOVETUTOR_MIMIC
	writetext CopycatText_MoveTutorBlank
	special MoveTutor
	ifnotequal FALSE, .DeclinedMimic
	writetext CopycatText_MimicTaught
	waitbutton
	closetext
	end

.DeclinedMimic:
	writetext CopycatText_MimicDeclined
	waitbutton
.Cancel:
	closetext
	end

CopycatsDodrio:
	opentext
	writetext CopycatsDodrioText1
	cry DODRIO
	buttonsound
	writetext CopycatsDodrioText2
	waitbutton
	closetext
	end

CopycatsHouse2FDoll:
	jumptext CopycatsHouse2FDollText

CopycatsHouse2FBookshelf:
	jumpstd picturebookshelf

CopycatsHouse2FChoiceScarf:
	checkevent EVENT_COPYCAT_SCARF_PERMISSION
	iftrue .TakeScarf
	setevent EVENT_TRIED_TAKING_COPYCAT_SCARF
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Female
	faceobject COPYCATSHOUSE2F_COPYCAT1, PLAYER
	sjump .Scold
.Female:
	faceobject COPYCATSHOUSE2F_COPYCAT2, PLAYER
.Scold:
	opentext
	writetext CopycatText_NoStealingScarf
	waitbutton
	closetext
	end
.TakeScarf:
	opentext
	verbosegiveitem CHOICE_SCARF
	iffalse .Done
	setevent EVENT_GOT_CHOICE_SCARF_FROM_COPYCAT
	disappear COPYCATSHOUSE2F_CHOICE_SCARF
.Done:
	closetext
	end

CopycatSpinAroundMovementData:
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	turn_head LEFT
	turn_head UP
	turn_head RIGHT
	turn_head DOWN
	step_end

CopycatText_Male_1:
	text "<PLAYER>: Hi! Do"
	line "you like #MON?"

	para "<PLAYER>: Uh, no, I"
	line "just asked you."

	para "<PLAYER>: Huh?"
	line "You're strange!"
	done

CopycatText_QuickMimicking:
	text "COPYCAT: Hmm?"
	line "Quit mimicking?"

	para "But that's my"
	line "favorite hobby!"
	done

CopycatText_Male_2:
	text "<PLAYER>: Hi!"
	line "I heard that you"

	para "lost your favorite"
	line "# DOLL."

	para "<PLAYER>: If I find"
	line "it, you'll give me"
	cont "a rail PASS?"

	para "<PLAYER>: I'll go"
	line "find it for you."

	para "You think you lost"
	line "it when you went"
	cont "to VERMILION CITY?"
	done

CopycatText_Worried:
	text "COPYCAT: Pardon?"

	para "I shouldn't decide"
	line "what you should"
	cont "do?"

	para "But I'm really"
	line "worried… What if"
	cont "someone finds it?"
	done

CopycatText_GiveDoll:
	text "COPYCAT: Yay!"
	line "That's my CLEFAIRY"
	cont "# DOLL!"

	para "See the tear where"
	line "the right leg is"

	para "sewn on? That's"
	line "proof!"
	done

CopycatText_GivePass:
	text "OK. Here's the"
	line "MAGNET TRAIN PASS"
	cont "like I promised!"
	done

CopycatText_ExplainPass:
	text "COPYCAT: That's"
	line "the PASS for the"
	cont "MAGNET TRAIN."

	para "The rail company"
	line "man gave me that"

	para "when they tore"
	line "down our old house"
	cont "for the STATION."
	done

CopycatText_Male_3:
	text "<PLAYER>: Hi!"
	line "Thanks a lot for"
	cont "the rail PASS!"

	para "<PLAYER>: Pardon?"

	para "<PLAYER>: Is it"
	line "that fun to mimic"
	cont "my every move?"
	done

CopycatText_NoStealingScarf:
	text "COPYCAT: Hey!"
	para "Didn't anyone"
	line "teach you stealing"
	cont "is wrong?!"
	done

CopycatText_OfferScarf:
	text "COPYCAT: Oh!"
	line "I almost forgot!"
	para "See that scarf"
	line "over there?"
	para "It's one of my"
	line "favorites!"
	para "But you helped me"
	line "get my precious"
	cont "# DOLL back, so"
	cont "you can have it!"
	para "Go on! Take it!"
	done

CopycatText_RememberScarf:
	text "COPYCAT: Oh!"
	line "One more thing!"
	para "Remember that"
	line "scarf you were"
	cont "eyeing earlier?"
	para "Hehe! Since you"
	line "found my"
	cont "# DOLL,"
	para "I guess you've"
	line "earned it!"
	para "Go ahead! It's"
	line "yours! No hard"
	cont "feelings."
	done

CopycatText_ItsAScream:
	text "COPYCAT: You bet!"
	line "It's a scream!"
	done

CopycatText_OfferMimic:
	text "COPYCAT: Hey! Want"
	line "me to teach one of"

	para "your #MON how"
	line "to use MIMIC?"

	para "Copying is my"
	line "specialty!"
	done

CopycatText_MoveTutorBlank:
	text_start
	done

CopycatText_MimicTaught:
	text "COPYCAT: Ta-da!"
	line "Now it can copy"
	cont "just like me!"
	done

CopycatText_MimicDeclined:
	text "COPYCAT: Aww…"
	line "Come back anytime"
	cont "you want me to"
	cont "teach your #MON"
	cont "how to MIMIC!"
	done

CopycatText_Female_1:
	text "<PLAYER>: Hi. You"
	line "must like #MON."

	para "<PLAYER>: No, not"
	line "me. I asked you."

	para "<PLAYER>: Pardon?"
	line "You're weird!"
	done

CopycatText_Female_2:
	text "<PLAYER>: Hi. Did"
	line "you really lose"
	cont "your # DOLL?"

	para "<PLAYER>: You'll"
	line "really give me a"

	para "rail PASS if I"
	line "find it for you?"

	para "<PLAYER>: Sure,"
	line "I'll look for it!"

	para "You think you lost"
	line "it when you were"
	cont "in VERMILION?"
	done

CopycatText_Female_3:
	text "<PLAYER>: Thank you"
	line "for the rail PASS!"

	para "<PLAYER>: …Pardon?"

	para "<PLAYER>: Is it"
	line "really that fun to"

	para "copy what I say"
	line "and do?"
	done

CopycatsDodrioText1:
	text "DODRIO: Gii giii!"
	done

CopycatsDodrioText2:
	text "MIRROR, MIRROR ON"
	line "THE WALL, WHO'S"

	para "THE FAIREST ONE OF"
	line "ALL?"
	done

CopycatsHouse2FDollText:
	text "This is a rare"
	line "#MON! Huh?"

	para "It's only a doll…"
	done

CopycatsHouse2F_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  3,  0, COPYCATS_HOUSE_1F, 3

	db 0 ; coord events

	db 2 ; bg events
	bg_event  0,  1, BGEVENT_READ, CopycatsHouse2FBookshelf
	bg_event  1,  1, BGEVENT_READ, CopycatsHouse2FBookshelf

	db 7 ; object events
	object_event  4,  3, SPRITE_COPYCAT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, Copycat, EVENT_COPYCAT_1
	object_event  6,  4, SPRITE_DODRIO, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CopycatsDodrio, -1
	object_event  6,  1, SPRITE_CLEFAIRY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, EVENT_COPYCATS_HOUSE_2F_DOLL
	object_event  2,  1, SPRITE_RHYDON, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, -1
	object_event  7,  1, SPRITE_PIDGEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, -1
	object_event  4,  3, SPRITE_COPYCAT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, Copycat, EVENT_COPYCAT_2
	object_event  3,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FChoiceScarf, EVENT_GOT_CHOICE_SCARF_FROM_COPYCAT

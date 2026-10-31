	object_const_def ; object_event constants
	const ECRUTEAKCITY_GRAMPS1
	const ECRUTEAKCITY_GRAMPS2
	const ECRUTEAKCITY_LASS1
	const ECRUTEAKCITY_LASS2
	const ECRUTEAKCITY_FISHER
	const ECRUTEAKCITY_YOUNGSTER
	const ECRUTEAKCITY_GRAMPS3
	const ECRUTEAKCITY_EUSINE
	const ECRUTEAKCITY_WELL_GRANNY
	const ECRUTEAKCITY_JIRACHI

EcruteakCity_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint
	callback MAPCALLBACK_OBJECTS, .Eusine

.FlyPoint:
	setflag ENGINE_FLYPOINT_ECRUTEAK
	return

.Eusine:
	disappear ECRUTEAKCITY_JIRACHI
	checkevent EVENT_FOUGHT_SUICUNE
	iftrue .HideEusine
	checkevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	iffalse .HideEusine
	clearevent EVENT_ECRUTEAK_CITY_EUSINE
	return

.HideEusine:
	setevent EVENT_ECRUTEAK_CITY_EUSINE
	return

EcruteakCityEusineTrigger:
	checkevent EVENT_FOUGHT_SUICUNE
	iftrue .Done
	checkevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	iftrue .Done
	appear ECRUTEAKCITY_EUSINE
	turnobject PLAYER, LEFT
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15
	playmusic MUSIC_MYSTICALMAN_ENCOUNTER
	applymovement ECRUTEAKCITY_EUSINE, EcruteakCityEusineApproachMovement
	opentext
	writetext EcruteakCityEusineBeforeText
	waitbutton
	closetext
	winlosstext EcruteakCityEusineBeatenText, 0
	setlasttalked ECRUTEAKCITY_EUSINE
	loadtrainer MYSTICALMAN, EUSINE2
	startbattle
	ifequal LOSE, .Lost
	setevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_MYSTICALMAN_ENCOUNTER
	opentext
	writetext EcruteakCityEusineAfterText
	waitbutton
	closetext
	playmapmusic
.Done:
	end

.Lost:
	dontrestartmapmusic
	reloadmapafterbattle
	end

EcruteakCityEusineScript:
	jumptextfaceplayer EcruteakCityEusineWaitingText

EcruteakCityEusineApproachMovement:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step RIGHT
	step_end

EcruteakCityGramps1Script:
	jumptextfaceplayer EcruteakCityGramps1Text

EcruteakCityGramps2Script:
	jumptextfaceplayer EcruteakCityGramps2Text

EcruteakCityGramps3Script:
	jumptextfaceplayer EcruteakCityGramps3Text

EcruteakCityLass1Script:
	jumptextfaceplayer EcruteakCityLass1Text

EcruteakCityLass2Script:
	faceplayer
	opentext
	checkevent EVENT_RELEASED_THE_BEASTS
	iftrue .ReleasedBeasts
	writetext EcruteakCityLass2Text
	waitbutton
	closetext
	end

.ReleasedBeasts:
	writetext EcruteakCityLass2Text_ReleasedBeasts
	waitbutton
	closetext
	end

EcruteakCityFisherScript:
	faceplayer
	opentext
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .JasmineReturned
	writetext EcruteakCityFisherText
	waitbutton
	closetext
	end

.JasmineReturned:
	writetext EcruteakCityFisherText_JasmineReturned
	waitbutton
	closetext
	end

EcruteakCityYoungsterScript:
	jumptextfaceplayer EcruteakCityYoungsterText

EcruteakCityWishingWell:
	opentext
	checkevent EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED
	iftrue .CheckShard
	checkitem WISHING_STAR
	iftrue EcruteakCityWishingWellWishingStar
.CheckShard:
	checkevent EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED
	iftrue .CoinWish
	checkitem STAR_SHARD
	iftrue EcruteakCityWishingWellStarShard
.CoinWish:
	writetext EcruteakCityWishingWellPromptText
	yesorno
	iffalse .Done
	checkmoney YOUR_MONEY, 100
	ifequal HAVE_LESS, .NotEnoughMoney
	checkevent EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY
	iftrue .AnotherWish
	; Reserve the reward before charging, so a full Bag cannot waste the wish.
	giveitem RARE_CANDY
	iffalse .BagFull
	takemoney YOUR_MONEY, 100
	setevent EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY
	writetext EcruteakCityWishingWellWishText
	waitbutton
	writetext EcruteakCityWishingWellRewardText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	itemnotify
	sjump .Done

.AnotherWish:
	takemoney YOUR_MONEY, 100
	writetext EcruteakCityWishingWellNothingText
	waitbutton
	sjump .Done

.NotEnoughMoney:
	writetext EcruteakCityWishingWellNoMoneyText
	waitbutton
	sjump .Done

.BagFull:
	writetext EcruteakCityWishingWellBagFullText
	waitbutton
.Done:
	closetext
	end

EcruteakCityWishingWellStarShard:
	writetext EcruteakCityWishingWellStarShardPromptText
	yesorno
	iffalse .Done
	; Exchanging the shard frees the Key Item slot needed for the star piece.
	takeitem STAR_SHARD
	iffalse .Done
	checkitem STAR_PIECE
	iftrue .HaveStarPiece
	giveitem STAR_PIECE
	iffalse .BagFull
.HaveStarPiece:
	setevent EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED
	writetext EcruteakCityWishingWellStarShardTossText
	waitbutton
	writetext EcruteakCityWishingWellStarPieceRisesText
	waitbutton
	closetext
	rept 3
		special FadeOutPalettes
		pause 4
		special FadeInPalettes
		pause 4
	endr
	opentext
	writetext EcruteakCityWishingWellStarPieceReceivedText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	; checkitem also updates wCurItem when the star piece was already owned.
	itemnotify
	closetext
	showemote EMOTE_SHOCK, ECRUTEAKCITY_WELL_GRANNY, 15
	readvar VAR_XCOORD
	ifequal 26, .PlayerEast
	; Below the well: stop to the player's left, without stepping onto them.
	applymovement ECRUTEAKCITY_WELL_GRANNY, EcruteakCityWellGrannyApproachSouth
	turnobject PLAYER, LEFT
	scall .GrannyStory
	applymovement ECRUTEAKCITY_WELL_GRANNY, EcruteakCityWellGrannyReturnSouth
	end

.PlayerEast:
	; The well and north wall block the direct path, so walk around its base.
	applymovement ECRUTEAKCITY_WELL_GRANNY, EcruteakCityWellGrannyApproachEast
	turnobject PLAYER, DOWN
	scall .GrannyStory
	applymovement ECRUTEAKCITY_WELL_GRANNY, EcruteakCityWellGrannyReturnEast
	end

.GrannyStory:
	setlasttalked ECRUTEAKCITY_WELL_GRANNY
	faceplayer
	opentext
	writetext EcruteakCityWellGrannyStarPieceText
	waitbutton
	closetext
	return

.BagFull:
	giveitem STAR_SHARD
	writetext EcruteakCityWishingWellKeyItemsFullText
	waitbutton
.Done:
	closetext
	end

EcruteakCityWishingWellWishingStar:
	writetext EcruteakCityWishingStarPromptText
	yesorno
	iffalse .Done
	takeitem WISHING_STAR
	iffalse .Done
	setevent EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED
	writetext EcruteakCityWishingStarTossText
	waitbutton
	closetext
	special EcruteakWellJirachiRise
	cry JIRACHI
	waitsfx
	special EcruteakWellJirachiCircle
	setlasttalked ECRUTEAKCITY_JIRACHI
	faceplayer
	opentext
	writetext EcruteakCityJirachiText
	cry JIRACHI
	waitsfx
	waitbutton
	closetext
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon JIRACHI, 50
	startbattle
	disappear ECRUTEAKCITY_JIRACHI
	reloadmapafterbattle
	end
.Done:
	closetext
	end

EcruteakCityWishingStarPromptText:
	text "The WISHING STAR"
	line "shimmers softly."

	para "Drop it into"
	line "the well?"
	done

EcruteakCityWishingStarTossText:
	text "You dropped the"
	line "WISHING STAR into"
	cont "the well."

	para "A brilliant light"
	line "shines from below!"
	done

EcruteakCityJirachiText:
	text "JIRACHI: CHI!"
	done

EcruteakCityWellGrannyApproachSouth:
	step DOWN
	step_end

EcruteakCityWellGrannyReturnSouth:
	step UP
	turn_head DOWN
	step_end

EcruteakCityWellGrannyApproachEast:
	step DOWN
	step RIGHT
	step RIGHT
	step_end

EcruteakCityWellGrannyReturnEast:
	step LEFT
	step LEFT
	step UP
	turn_head DOWN
	step_end

EcruteakCityWellGrannyScript:
	faceplayer
	opentext
	checkevent EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED
	iftrue .StarPiece
	checkevent EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY
	iftrue .FoundCandy
	writetext EcruteakCityWellGrannyText
	waitbutton
	closetext
	end

.FoundCandy:
	writetext EcruteakCityWellGrannyAfterText
	waitbutton
	closetext
	end

.StarPiece:
	writetext EcruteakCityWellGrannyStarPieceText
	waitbutton
	closetext
	end

EcruteakCitySign:
	jumptext EcruteakCitySignText

TinTowerSign:
	jumptext TinTowerSignText

EcruteakGymSign:
	jumptext EcruteakGymSignText

EcruteakDanceTheaterSign:
	jumptext EcruteakDanceTheaterSignText

BurnedTowerSign:
	jumptext BurnedTowerSignText

EcruteakCityPokecenterSign:
	jumpstd pokecentersign

EcruteakCityMartSign:
	jumpstd martsign

EcruteakCityHiddenHyperPotion:
	hiddenitem HYPER_POTION, EVENT_ECRUTEAK_CITY_HIDDEN_HYPER_POTION

UnusedMissingDaughterText:
; unused
	text "Oh, no. Oh, no…"

	para "My daughter is"
	line "missing."

	para "No… She couldn't"
	line "have gone to the"
	cont "BURNED TOWER."

	para "I told her not to"
	line "go near it…"

	para "People seem to"
	line "disappear there…"

	para "Oh, what should I"
	line "do…?"
	done

EcruteakCityGramps1Text:
	text "ECRUTEAK used to"
	line "have two towers:"

	para "one each in the"
	line "east and west."
	done

EcruteakCityGramps2Text:
	text "Ah, child."
	line "Have you learned"

	para "to dance like the"
	line "KIMONO GIRLS?"

	para "If you go to their"
	line "DANCE THEATER, an"

	para "odd old man will"
	line "give you something"
	cont "nice, I hear."
	done

EcruteakCityLass1Text:
	text "I'm going to prac-"
	line "tice at the DANCE"

	para "THEATER. Care to"
	line "join me?"
	done

EcruteakCityLass2Text:
	text "The tower that"
	line "used to be here…"

	para "My grandma told me"
	line "it used to be much"
	cont "taller."
	done

EcruteakCityLass2Text_ReleasedBeasts:
	text "Three big #MON"
	line "ran off in differ-"
	cont "ent directions."
	cont "What were they?"
	done

EcruteakCityFisherText:
	text "I heard a rumor"
	line "about OLIVINE"
	cont "LIGHTHOUSE."

	para "The #MON that"
	line "serves as the"

	para "beacon fell ill."
	line "Sounds like they"
	cont "are in trouble."
	done

EcruteakCityFisherText_JasmineReturned:
	text "The #MON at"
	line "OLIVINE LIGHTHOUSE"
	cont "has been cured."

	para "Boats can safely"
	line "sail out to sea at"
	cont "night again."
	done

EcruteakCityYoungsterText:
	text "I hear #MON are"
	line "rampaging at the"

	para "LAKE OF RAGE. I'd"
	line "like to see that."
	done

EcruteakCityGramps3Text:
	text "In the distant"
	line "past…"

	para "This tower burned"
	line "in a fire. Three"

	para "nameless #MON"
	line "perished in it."

	para "A rainbow-colored"
	line "#MON descended"

	para "from the sky and"
	line "resurrected them…"

	para "It's a legend that"
	line "has been passed"

	para "down by ECRUTEAK"
	line "GYM LEADERS."

	para "Me?"

	para "I was a trainer"
	line "way back when."
	cont "Hohoho!"
	done

EcruteakCitySignText:
	text "ECRUTEAK CITY"
	line "A Historical City"

	para "Where the Past"
	line "Meets the Present"
	done

TinTowerSignText:
	text "TIN TOWER"

	para "A legendary #-"
	line "MON is said to"
	cont "roost here."
	done

EcruteakGymSignText:
	text "ECRUTEAK CITY"
	line "#MON GYM"
	cont "LEADER: MORTY"

	para "The Mystic Seer of"
	line "the Future"
	done

EcruteakDanceTheaterSignText:
	text "ECRUTEAK DANCE"
	line "THEATER"
	done

BurnedTowerSignText:
	text "BURNED TOWER"

	para "It was destroyed"
	line "by a mysterious"
	cont "fire."

	para "Please stay away,"
	line "as it is unsafe."
	done

EcruteakCityEusineBeforeText:
	text "EUSINE: Wait,"
	line "<PLAYER>."

	para "I know that ENTEI"
	line "is waiting within"
	cont "the tower."

	para "Before you go in,"
	line "I need to know if"
	cont "you're ready to"
	cont "face its awesome"
	cont "power."

	para "Battle me and show"
	line "me your strength!"
	done

EcruteakCityEusineBeatenText:
	text "So this is your"
	line "true strength…"
	done

EcruteakCityEusineAfterText:
	text "EUSINE: Amazing!"

	para "ENTEI's power is"
	line "fierce and proud."

	para "But the bond with"
	line "your #MON is"
	cont "just as strong."

	para "Go on, <PLAYER>."
	line "ENTEI awaits you!"
	done

EcruteakCityEusineWaitingText:
	text "EUSINE: ENTEI is"
	line "waiting inside."

	para "Go on, <PLAYER>."
	line "Show ENTEI the"
	cont "bond you have with"
	cont "your #MON!"
	done

EcruteakCityWishingWellStarShardPromptText:
	text "The water in the"
	line "well is perfectly"
	cont "still."

	para "The STAR SHARD"
	line "begins to glow"
	cont "faintly…"

	para "Toss the"
	line "STAR SHARD into"
	cont "the well?"
	done

EcruteakCityWishingWellStarShardTossText:
	text "You tossed the"
	line "STAR SHARD into"
	cont "the well."

	para "…"
	done

EcruteakCityWishingWellStarPieceRisesText:
	text "A brilliant light"
	line "shines from"
	cont "beneath the water!"

	para "Something rises"
	line "to the surface…"
	done

EcruteakCityWishingWellStarPieceReceivedText:
	text "Received a"
	line "STAR PIECE!"
	done

EcruteakCityWishingWellKeyItemsFullText:
	text "Your KEY ITEMS"
	line "pocket is full."

	para "You keep the"
	line "STAR SHARD."
	done

EcruteakCityWellGrannyStarPieceText:
	text "OLD WOMAN: Oh my!"
	line "Did you see that?"

	para "I've been coming"
	line "to this well since"
	cont "I was a little"
	cont "girl, but I've"
	cont "never seen"
	cont "anything like it!"

	para "You know, my"
	line "mother used to"
	cont "tell me stories"
	cont "about strange"
	cont "lights appearing"
	cont "over MT.MOON."

	para "She said the"
	line "#MON there"
	cont "would gather"
	cont "beneath the stars,"
	cont "almost as if they"
	cont "were waiting for"
	cont "something."

	para "I wonder if"
	line "there's any truth"
	cont "to those old"
	cont "stories…"

	para "Perhaps that stone"
	line "of yours has"
	cont "something to do"
	cont "with it."
	done

EcruteakCityWishingWellPromptText:
	text "It's an old"
	line "wishing well."

	para "Several coins"
	line "glimmer beneath"
	cont "the water."

	para "Toss in ¥100?"
	done

EcruteakCityWishingWellWishText:
	text "You tossed ¥100"
	line "into the well!"

	para "You close your"
	line "eyes and make a"
	cont "wish…"

	para "…"

	para "Something sparkles"
	line "beneath the water!"
	done

EcruteakCityWishingWellRewardText:
	text "You found a"
	line "RARE CANDY!"
	done

EcruteakCityWishingWellNothingText:
	text "You tossed ¥100"
	line "into the well."

	para "Ripples spread"
	line "across the water…"

	para "Nothing else"
	line "happens."
	done

EcruteakCityWishingWellNoMoneyText:
	text "You don't have"
	line "enough money."
	done

EcruteakCityWishingWellBagFullText:
	text "Your BAG is full."

	para "Make room before"
	line "making a wish."
	done

EcruteakCityWellGrannyText:
	text "When I was a"
	line "little girl, my"

	para "mother would bring"
	line "me here to make a"
	cont "wish."

	para "I still remember"
	line "what I wished"
	cont "for…"

	para "But I won't tell"
	line "you!"

	para "Then it might not"
	line "come true!"
	done

EcruteakCityWellGrannyAfterText:
	text "Oh? You found"
	line "something in the"
	cont "well?"

	para "How curious…"

	para "I've been coming"
	line "here for years,"

	para "and that's never"
	line "happened to me!"

	para "Perhaps the well"
	line "has taken a liking"
	cont "to you."
	done

EcruteakCity_MapEvents:
	db 0, 0 ; filler

	db 15 ; warp events
	warp_event 35, 26, ROUTE_42_ECRUTEAK_GATE, 1
	warp_event 35, 27, ROUTE_42_ECRUTEAK_GATE, 2
	warp_event 18, 11, ECRUTEAK_TIN_TOWER_ENTRANCE, 1
	warp_event 20,  2, WISE_TRIOS_ROOM, 1
	warp_event 20,  3, WISE_TRIOS_ROOM, 2
	warp_event 23, 27, ECRUTEAK_POKECENTER_1F, 1
	warp_event  5, 21, ECRUTEAK_LUGIA_SPEECH_HOUSE, 1
	warp_event 23, 21, DANCE_THEATRE, 1
	warp_event 29, 21, ECRUTEAK_MART, 2
	warp_event  6, 27, ECRUTEAK_GYM, 1
	warp_event 13, 27, ECRUTEAK_ITEMFINDER_HOUSE, 1
	warp_event 37,  7, TIN_TOWER_1F, 1
	warp_event  5,  5, BURNED_TOWER_1F, 1
	warp_event  0, 18, ROUTE_38_ECRUTEAK_GATE, 3
	warp_event  0, 19, ROUTE_38_ECRUTEAK_GATE, 4

	db 1 ; coord events
	coord_event 36, 9, -1, EcruteakCityEusineTrigger

	db 9 ; bg events
	bg_event 15, 21, BGEVENT_READ, EcruteakCitySign
	bg_event 38, 10, BGEVENT_READ, TinTowerSign
	bg_event  8, 28, BGEVENT_READ, EcruteakGymSign
	bg_event 21, 21, BGEVENT_READ, EcruteakDanceTheaterSign
	bg_event  2, 10, BGEVENT_READ, BurnedTowerSign
	bg_event 24, 27, BGEVENT_READ, EcruteakCityPokecenterSign
	bg_event 30, 21, BGEVENT_READ, EcruteakCityMartSign
	bg_event 23, 14, BGEVENT_ITEM, EcruteakCityHiddenHyperPotion
	bg_event 25,  8, BGEVENT_READ, EcruteakCityWishingWell

	db 10 ; object events
	object_event 18, 15, SPRITE_GRAMPS, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps1Script, -1
	object_event 20, 21, SPRITE_GRAMPS, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps2Script, -1
	object_event 21, 29, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, EcruteakCityLass1Script, -1
	object_event  3,  9, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityLass2Script, -1
	object_event  9, 22, SPRITE_FAT_GUY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, EcruteakCityFisherScript, -1
	object_event 10, 14, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, EcruteakCityYoungsterScript, -1
	object_event  3,  7, SPRITE_GRAMPS, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, EcruteakCityGramps3Script, EVENT_ECRUTEAK_CITY_GRAMPS
	object_event 31,  5, SPRITE_MYSTICALMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, EcruteakCityEusineScript, EVENT_ECRUTEAK_CITY_EUSINE
	object_event 24,  8, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakCityWellGrannyScript, EVENT_GOT_WISHING_STAR
	object_event 25,  8, SPRITE_JIRACHI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_ECRUTEAK_WELL_JIRACHI

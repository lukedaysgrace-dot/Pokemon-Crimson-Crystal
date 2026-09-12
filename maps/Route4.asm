	object_const_def ; object_event constants
	const ROUTE4_YOUNGSTER
	const ROUTE4_LASS1
	const ROUTE4_LASS2
	const ROUTE4_POKE_BALL
	const ROUTE4_COSPLAYER1
	const ROUTE4_COSPLAYER2

Route4_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TrainerBirdKeeperHank:
	trainer BIRD_KEEPER, HANK, EVENT_BEAT_BIRD_KEEPER_HANK, BirdKeeperHankSeenText, BirdKeeperHankBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperHankAfterBattleText
	waitbutton
	closetext
	end

TrainerSchoolGirlHope:
	trainer SCHOOL_GIRL, HOPE, EVENT_BEAT_SCHOOL_GIRL_HOPE, SchoolGirlHopeSeenText, SchoolGirlHopeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SchoolGirlHopeAfterBattleText
	waitbutton
	closetext
	end

TrainerSchoolGirlSharon:
	trainer SCHOOL_GIRL, SHARON, EVENT_BEAT_SCHOOL_GIRL_SHARON, SchoolGirlSharonSeenText, SchoolGirlSharonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SchoolGirlSharonAfterBattleText
	waitbutton
	closetext
	end

TrainerCosplayerPearl:
	trainer COSPLAYER, COSPLAYER4, EVENT_BEAT_COSPLAYER_PEARL, CosplayerPearlSeenText, CosplayerPearlBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CosplayerPearlAfterBattleText
	waitbutton
	closetext
	end

TrainerCosplayerPixie:
	trainer COSPLAYER, COSPLAYER5, EVENT_BEAT_COSPLAYER_PIXIE, CosplayerPixieSeenText, CosplayerPixieBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CosplayerPixieAfterBattleText
	waitbutton
	closetext
	end

MtMoonSquareSign:
	jumptext MtMoonSquareSignText

Route4HPUp:
	itemball HP_UP

Route4HiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_ROUTE_4_HIDDEN_ULTRA_BALL

BirdKeeperHankSeenText:
	text "I'm raising my"
	line "#MON. Want to"
	cont "battle with me?"
	done

BirdKeeperHankBeatenText:
	text "Ack! I lost that"
	line "one…"
	done

BirdKeeperHankAfterBattleText:
	text "If you have a"
	line "specific #MON"

	para "that you want to"
	line "raise, put it out"

	para "first, then switch"
	line "it right away."

	para "That's how to do"
	line "it."
	done

SchoolGirlHopeSeenText:
	text "I programmed a"
	line "battle plan."

	para "My lucky #MON"
	line "will test it!"
	done

SchoolGirlHopeBeatenText:
	text "That's a bug I"
	line "didn't expect!"
	done

SchoolGirlHopeAfterBattleText:
	text "Luck and logic"
	line "both matter."

	para "That's my theory!"
	done

SchoolGirlSharonSeenText:
	text "My sketchbook is"
	line "full of #MON."

	para "Let's make this"
	line "a masterpiece!"
	done

SchoolGirlSharonBeatenText:
	text "You colored beyond"
	line "my plan…"
	done

SchoolGirlSharonAfterBattleText:
	text "SMEARGLE paints;"
	line "ALTARIA sings."

	para "Our art club never"
	line "runs out of ideas."
	done

CosplayerPearlSeenText:
	text "This costume took"
	line "me weeks to make!"
	done

CosplayerPearlBeatenText:
	text "You'll pay for the"
	line "wardrobe damage!"
	done

CosplayerPearlAfterBattleText:
	text "CLEFABLE is my"
	line "dream cosplay"
	cont "partner."
	done

CosplayerPixieSeenText:
	text "Ta-da! How do I"
	line "look?"
	done

CosplayerPixieBeatenText:
	text "My wig fell off…"
	done

CosplayerPixieAfterBattleText:
	text "Next convention,"
	line "I'll have an even"
	cont "better costume!"
	done

MtMoonSquareSignText:
	text "MT.MOON SQUARE"

	para "Just go up the"
	line "stairs."
	done

Route4_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  2,  5, MOUNT_MOON, 2

	db 0 ; coord events

	db 2 ; bg events
	bg_event  3,  7, BGEVENT_READ, MtMoonSquareSign
	bg_event 10,  3, BGEVENT_ITEM, Route4HiddenUltraBall

	db 6 ; object events
	object_event 17,  9, SPRITE_BIRD_KEEPER_NEW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperHank, -1
	object_event  9,  8, SPRITE_SCHOOL_GIRL, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerSchoolGirlHope, -1
	object_event 21,  6, SPRITE_SCHOOL_GIRL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerSchoolGirlSharon, -1
	object_event 26,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route4HPUp, EVENT_ROUTE_4_HP_UP
	object_event 14,  6, SPRITE_COSPLAYER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerCosplayerPearl, -1
	object_event 22, 10, SPRITE_COSPLAYER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerCosplayerPixie, -1

	object_const_def ; object_event constants
	const ICEISLAND_ICE_STONE
	const ICEISLAND_BOARDER_AIDAN
	const ICEISLAND_BOARDER_NOEL
	const ICEISLAND_SKIER_BIANCA

IceIsland_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

IceIslandIceStone:
	itemball ICE_STONE

TrainerBoarderAidan:
	trainer BOARDER, BOARDER_AIDAN, EVENT_BEAT_BOARDER_AIDAN, BoarderAidanSeenText, BoarderAidanBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BoarderAidanAfterBattleText
	waitbutton
	closetext
	end

TrainerBoarderNoel:
	trainer BOARDER, BOARDER_NOEL, EVENT_BEAT_BOARDER_NOEL, BoarderNoelSeenText, BoarderNoelBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BoarderNoelAfterBattleText
	waitbutton
	closetext
	end

TrainerSkierBianca:
	trainer SKIER, SKIER_BIANCA, EVENT_BEAT_SKIER_BIANCA, SkierBiancaSeenText, SkierBiancaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SkierBiancaAfterBattleText
	waitbutton
	closetext
	end

BoarderAidanSeenText:
	text "Fresh powder!"
	line "Let's battle!"
	done

BoarderAidanBeatenText:
	text "That wiped me out!"
	done

BoarderAidanAfterBattleText:
	text "My #MON love"
	line "the cold in here."
	done

BoarderNoelSeenText:
	text "The colder it gets,"
	line "the better I ride!"
	done

BoarderNoelBeatenText:
	text "I lost my edge!"
	done

BoarderNoelAfterBattleText:
	text "The snow here is"
	line "perfect all year."
	done

SkierBiancaSeenText:
	text "Care for a battle"
	line "on the ice?"
	done

SkierBiancaBeatenText:
	text "What a slippery"
	line "defeat!"
	done

SkierBiancaAfterBattleText:
	text "Strong footing is"
	line "everything on ice."
	done

IceIsland_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  8, 19, ROUTE_41, 5
	warp_event  9, 19, ROUTE_41, 5

	db 0 ; coord events

	db 0 ; bg events

	db 4 ; object events
	object_event 15,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, IceIslandIceStone, EVENT_ICE_ISLAND_ICE_STONE
	object_event  4,  5, SPRITE_SNOWBOARDER_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBoarderAidan, -1
	object_event 14, 10, SPRITE_SNOWBOARDER_NEW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBoarderNoel, -1
	object_event  6, 15, SPRITE_SKIER_NEW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSkierBianca, -1

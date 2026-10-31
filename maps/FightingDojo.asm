	object_const_def ; object_event constants
	const FIGHTINGDOJO_KIYO
	const FIGHTINGDOJO_POKE_BALL
	const FIGHTINGDOJO_RIKU
	const FIGHTINGDOJO_MASARU

FightingDojo_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

FightingDojoKiyoStopScript:
	checkevent EVENT_BEAT_DOJO_KIYO
	iftrue .Done
	sjump FightingDojoKiyoScript
.Done:
	end

FightingDojoKiyoScript:
	setlasttalked FIGHTINGDOJO_KIYO
	faceplayer
	faceobject PLAYER, FIGHTINGDOJO_KIYO
	opentext
	checkevent EVENT_GOT_CHOICE_BAND_FROM_KIYO
	iftrue .AfterGift
	checkevent EVENT_BEAT_DOJO_KIYO
	iftrue .GiveBand
	writetext FightingDojoKiyoSeenText
	waitbutton
	closetext
	winlosstext FightingDojoKiyoBeatenText, 0
	loadtrainer KARATE_KING, KARATE_KIYO
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_DOJO_KIYO
	opentext
.GiveBand:
	writetext FightingDojoKiyoGiftText
	buttonsound
	verbosegiveitem CHOICE_BAND
	iffalse .Done
	setevent EVENT_GOT_CHOICE_BAND_FROM_KIYO
.AfterGift:
	writetext FightingDojoKiyoAfterText
	waitbutton
.Done:
	closetext
	end

TrainerDojoRiku:
	trainer BLACKBELT_T, DOJO_RIKU, EVENT_BEAT_DOJO_RIKU, FightingDojoRikuSeenText, FightingDojoRikuBeatenText, 0, .Script
.Script:
	endifjustbattled
	jumptext FightingDojoRikuAfterText

TrainerDojoMasaru:
	trainer BLACKBELT_T, DOJO_MASARU, EVENT_BEAT_DOJO_MASARU, FightingDojoMasaruSeenText, FightingDojoMasaruBeatenText, 0, .Script
.Script:
	endifjustbattled
	jumptext FightingDojoMasaruAfterText

FightingDojoSign1:
	jumptext FightingDojoSign1Text

FightingDojoSign2:
	jumptext FightingDojoSign2Text

FightingDojoFocusBand:
	itemball FOCUS_BAND

FightingDojoKiyoSeenText:
	text "Hold it!"

	para "I am KIYO, the"
	line "KARATE KING!"

	para "My training in"
	line "MT.MORTAR is done."

	para "I've mastered many"
	line "kinds of FIGHTING"
	cont "#MON!"

	para "I will defeat"
	line "SABRINA and"
	cont "rightfully claim"
	cont "SAFFRON's GYM"
	cont "title for my DOJO!"

	para "Now, show me the"
	line "strength of your"
	cont "body and spirit!"

	para "Hwaaarggh!"
	done

FightingDojoKiyoBeatenText:
	text "Waaaarggh!"
	line "I'm beaten!"
	done

FightingDojoKiyoGiftText:
	text "A loss is a loss."
	line "I admit it!"

	para "Your strength has"
	line "earned you this"
	cont "CHOICE BAND."
	done

FightingDojoKiyoAfterText:
	text "A CHOICE BAND"
	line "boosts ATTACK, but"
	cont "locks your #MON"
	cont "into one move."

	para "Choose your moves"
	line "with discipline!"

	para "I will keep"
	line "training until"
	cont "this DOJO becomes"
	cont "SAFFRON's GYM!"
	done

FightingDojoRikuSeenText:
	text "Feet apart! Knees"
	line "bent!"

	para "Now, battle!"
	done

FightingDojoRikuBeatenText:
	text "My stance! It"
	line "crumbled!"
	done

FightingDojoRikuAfterText:
	text "KIYO makes us do a"
	line "hundred push-ups"
	cont "for every loss."

	para "See you in an"
	line "hour."
	done

FightingDojoMasaruSeenText:
	text "I've broken forty"
	line "boards today!"

	para "You're number"
	line "forty-one!"
	done

FightingDojoMasaruBeatenText:
	text "Ow! My knuckles!"
	done

FightingDojoMasaruAfterText:
	text "Our KARATE KING"
	line "never stops"
	cont "training."

	para "I think he sleeps"
	line "standing up!"
	done

FightingDojoSign1Text:
	text "What goes around"
	line "comes around!"
	done

FightingDojoSign2Text:
	text "Enemies on every"
	line "side!"
	done

FightingDojo_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  4, 11, SAFFRON_CITY, 1
	warp_event  5, 11, SAFFRON_CITY, 1

; Catch each walkable route around KIYO's row, including the side aisles.
	db 7 ; coord events
	coord_event  0,  3, -1, FightingDojoKiyoStopScript
	coord_event  1,  3, -1, FightingDojoKiyoStopScript
	coord_event  2,  3, -1, FightingDojoKiyoStopScript
	coord_event  5,  3, -1, FightingDojoKiyoStopScript
	coord_event  7,  3, -1, FightingDojoKiyoStopScript
	coord_event  8,  3, -1, FightingDojoKiyoStopScript
	coord_event  9,  3, -1, FightingDojoKiyoStopScript

	db 2 ; bg events
	bg_event  4,  0, BGEVENT_READ, FightingDojoSign1
	bg_event  5,  0, BGEVENT_READ, FightingDojoSign2

	db 4 ; object events
	object_event  4,  3, SPRITE_KARATE_KING, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, FightingDojoKiyoScript, -1
	object_event  3,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, FightingDojoFocusBand, EVENT_PICKED_UP_FOCUS_BAND
	object_event  3,  7, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerDojoRiku, -1
	object_event  6,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerDojoMasaru, -1

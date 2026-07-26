	object_const_def ; object_event constants
	const SILENTCRYPT_HEX_MANIAC1
	const SILENTCRYPT_HEX_MANIAC2
	const SILENTCRYPT_MEDIUM
	const SILENTCRYPT_GRANNY

SilentCrypt_MapScripts:
	db 1 ; scene scripts
	scene_script .DummyScene ; SCENE_DEFAULT

	db 0 ; callbacks

.DummyScene:
	end

TrainerHexManiacOdessa:
	trainer HEX_MANIAC, ODESSA, EVENT_BEAT_HEX_MANIAC_ODESSA, HexManiacOdessaSeenText, HexManiacOdessaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HexManiacOdessaAfterBattleText
	waitbutton
	closetext
	end

TrainerHexManiacLilith:
	trainer HEX_MANIAC, LILITH, EVENT_BEAT_HEX_MANIAC_LILITH, HexManiacLilithSeenText, HexManiacLilithBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HexManiacLilithAfterBattleText
	waitbutton
	closetext
	end

TrainerMediumBethany:
	trainer MEDIUM, BETHANY, EVENT_BEAT_MEDIUM_BETHANY, MediumBethanySeenText, MediumBethanyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumBethanyAfterBattleText
	waitbutton
	closetext
	end

SilentCryptGrannyAdviceScript:
; Fires below the gravekeeper's door, once the old man has thrown the player
; out at least once. The granny walks over from 4,4, explains what happened,
; then returns to her post.
	checkevent EVENT_MEDIUM_GAVE_ADVICE
	iftrue .Done
	checkevent EVENT_MET_GRAVEKEEPER
	iffalse .Done
	showemote EMOTE_SHOCK, SILENTCRYPT_GRANNY, 15
	applymovement SILENTCRYPT_GRANNY, SilentCryptGrannyApproachMovement
	opentext
	writetext SilentCryptGrannyAdviceText
	waitbutton
	closetext
	setevent EVENT_MEDIUM_GAVE_ADVICE
	applymovement SILENTCRYPT_GRANNY, SilentCryptGrannyReturnMovement
.Done:
	end

SilentCryptGrannyApproachMovement:
; 4,4 -> 7,4, ending up facing right, next to the player at 8,4.
	slow_step RIGHT
	slow_step RIGHT
	slow_step RIGHT
	step_end

SilentCryptGrannyReturnMovement:
; Back to 4,4 and facing up again.
	slow_step LEFT
	slow_step LEFT
	slow_step LEFT
	turn_head UP
	step_end

SilentCryptGrannyScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SPELL_TAG_FROM_GRAVEKEEPER
	iftrue .Finished
	checkevent EVENT_MEDIUM_GAVE_ADVICE
	iffalse .Idle
	checkevent EVENT_CLEANED_GRAVE_1
	iffalse .Remind
	checkevent EVENT_CLEANED_GRAVE_2
	iffalse .Remind
	writetext SilentCryptGrannyBothCleanText
	waitbutton
	closetext
	end

.Remind:
	writetext SilentCryptGrannyRemindText
	waitbutton
	closetext
	end

.Idle:
	writetext SilentCryptGrannyIdleText
	waitbutton
	closetext
	end

.Finished:
	writetext SilentCryptGrannyFinishedText
	waitbutton
	closetext
	end

SilentCryptGrave1:
	opentext
	checkevent EVENT_CLEANED_GRAVE_1
	iftrue .AlreadyClean
	checkevent EVENT_MEDIUM_GAVE_ADVICE
	iffalse .TooDirty
	writetext SilentCryptLoneGraveText
	waitbutton
	playsound SFX_FULL_HEAL
	waitsfx
	writetext SilentCryptScrubbedText
	waitbutton
	setevent EVENT_CLEANED_GRAVE_1
	closetext
	end

.TooDirty:
	writetext SilentCryptFilthyGraveText
	waitbutton
	closetext
	end

.AlreadyClean:
	writetext SilentCryptGraveCleanText
	waitbutton
	closetext
	end

SilentCryptGrave3:
	opentext
	checkevent EVENT_CLEANED_GRAVE_2
	iftrue .AlreadyClean
	checkevent EVENT_MEDIUM_GAVE_ADVICE
	iffalse .TooDirty
	writetext SilentCryptLoneGraveText
	waitbutton
	playsound SFX_FULL_HEAL
	waitsfx
	writetext SilentCryptScrubbedText
	waitbutton
	setevent EVENT_CLEANED_GRAVE_2
	closetext
	end

.TooDirty:
	writetext SilentCryptFilthyGraveText
	waitbutton
	closetext
	end

.AlreadyClean:
	writetext SilentCryptGraveCleanText
	waitbutton
	closetext
	end

HexManiacOdessaSeenText:
	text "Sssh. You'll wake"
	line "them."

	para "…Too late."
	done

HexManiacOdessaBeatenText:
	text "They stopped"
	line "listening to me…"
	done

HexManiacOdessaAfterBattleText:
	text "I come here to be"
	line "spoken to."

	para "You wouldn't"
	line "understand. Nobody"
	cont "up there does."
	done

HexManiacLilithSeenText:
	text "Count the stones."

	para "There are always"
	line "more than there"
	cont "were yesterday."
	done

HexManiacLilithBeatenText:
	text "Oh… you're still"
	line "warm."
	done

HexManiacLilithAfterBattleText:
	text "Don't take"
	line "anything from the"
	cont "graves."

	para "…You will anyway."
	line "They all do."
	done

MediumBethanySeenText:
	text "A voice asked me"
	line "to keep watch"
	cont "here."

	para "I never asked"
	line "whose voice."
	done

MediumBethanyBeatenText:
	text "Then I have"
	line "failed my post…"
	done

MediumBethanyAfterBattleText:
	text "The one buried"
	line "deepest here has"
	cont "no name."

	para "Names are how the"
	line "dead are held."

	para "Nothing holds"
	line "that one."
	done

SilentCryptLoneGraveText:
	text "A gravestone,"
	line "standing alone."
	done

SilentCryptFilthyGraveText:
	text "The stone is"
	line "filthy and"
	cont "illegible."
	done

SilentCryptScrubbedText:
	text "<PLAYER> scrubbed"
	line "the gravestone"
	cont "spotless!"
	done

SilentCryptGraveCleanText:
	text "The stone is"
	line "clean. The letters"
	cont "read clearly now."
	done

SilentCryptGrannyAdviceText:
	text "Don't mind him,"
	line "child."

	para "He's seen many"
	line "cruel people over"
	cont "the years."

	para "A red-haired boy"
	line "came through here"
	cont "just the other"
	cont "day."

	para "Sullied the two"
	line "stones that stand"
	cont "alone, and took"
	cont "what folk had"
	cont "left at them."

	para "Didn't even look"
	line "back."

	para "Maybe if you clean"
	line "those two graves,"
	cont "and show him"
	cont "you're a kind"
	cont "person, he'll be"
	cont "willing to talk."
	done

SilentCryptGrannyRemindText:
	text "The two stones"
	line "that stand alone,"
	cont "dear."

	para "The ones that boy"
	line "put his hands on."
	done

SilentCryptGrannyBothCleanText:
	text "Look at them"
	line "shine."

	para "Go on. Knock on"
	line "his door again."

	para "He'll answer this"
	line "time."
	done

SilentCryptGrannyIdleText:
	text "Cold down here,"
	line "isn't it?"

	para "The old"
	line "gravekeeper keeps"
	cont "to his house."

	para "He doesn't care"
	line "much for"
	cont "children."
	done

SilentCryptGrannyFinishedText:
	text "He gave you"
	line "something, didn't"
	cont "he?"

	para "First time in"
	line "forty years."
	done

SilentCrypt_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 10, 15, ROUTE_37, 1
	warp_event  9,  3, GRAVEKEEPERS_HOUSE, 1

	db 1 ; coord events
	coord_event  8,  4, SCENE_DEFAULT, SilentCryptGrannyAdviceScript

	db 2 ; bg events
	bg_event  4, 13, BGEVENT_READ, SilentCryptGrave1
	bg_event  4,  5, BGEVENT_READ, SilentCryptGrave3

	db 4 ; object events
	object_event  6,  6, SPRITE_HEX_MANIAC, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerHexManiacOdessa, -1
	object_event 13,  6, SPRITE_HEX_MANIAC, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerHexManiacLilith, -1
	object_event  7, 10, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerMediumBethany, -1
	object_event  4,  4, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SilentCryptGrannyScript, -1

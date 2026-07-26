	object_const_def ; object_event constants
	const SILENTCRYPT_HEX_MANIAC1
	const SILENTCRYPT_HEX_MANIAC2
	const SILENTCRYPT_MEDIUM

SilentCrypt_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

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

SilentCryptGrave1:
	jumptext SilentCryptGrave1Text

SilentCryptGrave2:
	opentext
	checkevent EVENT_SILENT_CRYPT_SPELL_TAG
	iftrue .Emptied
	writetext SilentCryptGrave2Text
	buttonsound
	verbosegiveitem SPELL_TAG
	iffalse .Done
	setevent EVENT_SILENT_CRYPT_SPELL_TAG
	writetext SilentCryptGrave2LootedText
	waitbutton
.Done:
	closetext
	end

.Emptied:
	writetext SilentCryptGrave2EmptyText
	waitbutton
	closetext
	end

SilentCryptGrave3:
	jumptext SilentCryptGrave3Text

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

SilentCryptGrave1Text:
	text "A worn stone slab."

	para "HERE LIE THOSE"
	line "WHO WOULD NOT"
	cont "REST."
	done

SilentCryptGrave2Text:
	text "The name has been"
	line "scratched off."

	para "Something is"
	line "wedged in the"
	cont "crack…"
	done

SilentCryptGrave2LootedText:
	text "The crypt goes"
	line "very quiet."

	para "Something cold"
	line "brushes past your"
	cont "shoulder…"
	done

SilentCryptGrave2EmptyText:
	text "The crack in the"
	line "stone is empty"
	cont "now."

	para "You feel watched."
	done

SilentCryptGrave3Text:
	text "SPEAK NOT ALOUD"
	line "IN THIS PLACE."

	para "IT LISTENS."
	done

SilentCrypt_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 10, 15, ROUTE_37, 1

	db 0 ; coord events

	db 3 ; bg events
	bg_event  4,  5, BGEVENT_READ, SilentCryptGrave1
	bg_event  8,  9, BGEVENT_READ, SilentCryptGrave2
	bg_event 12, 13, BGEVENT_READ, SilentCryptGrave3

	db 3 ; object events
	object_event  6,  6, SPRITE_HEX_MANIAC, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerHexManiacOdessa, -1
	object_event 13,  6, SPRITE_HEX_MANIAC, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerHexManiacLilith, -1
	object_event  7, 10, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerMediumBethany, -1

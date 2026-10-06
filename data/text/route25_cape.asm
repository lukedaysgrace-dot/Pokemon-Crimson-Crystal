; CRYSTAL's dialogue for the CERULEAN CAPE MEW event (see maps/Route25.asm).
; Kept out of the map's own bank, which has no room left for it; the map
; script reaches these with farwritetext.

Route25CrystalBeforeText::
	text "CRYSTAL: Quiet."
	line "Look over there."

	para "That's MEW."

	para "…I'm trying not to"
	line "shout."

	para "We both want a"
	line "chance to catch"
	cont "it. Let's settle"
	cont "this first."

	para "One battle. Winner"
	line "gets the first"
	cont "try."

	para "Ready, <PLAYER>?"
	line "I've been waiting"
	cont "for this!"
	done

Route25CrystalAfterText::
	text "CRYSTAL: I thought"
	line "I had you. I'll"
	cont "work out what went"
	cont "wrong later."

	para "You earned the"
	line "first try. Go on,"
	cont "<PLAYER>."

	para "Let's see if you"
	line "can catch MEW!"
	done

Route25CrystalGoCatchItText::
	text "CRYSTAL: MEW is"
	line "right there. Go!"

	para "And be careful. I"
	line "want usable"
	cont "observations!"
	done

Route25CrystalMewCaughtText::
	text "CRYSTAL: You"
	line "actually caught"
	cont "MEW. Let me see"
	cont "your #DEX!"

	para "…There it is. OAK"
	line "is going to have"
	cont "questions."

	para "When we started, I"
	line "only thought about"
	cont "filling the"
	cont "#DEX."

	para "Then you kept"
	line "beating me. You"
	cont "made me work"
	cont "harder."

	para "It was incredibly"
	line "annoying. But I"
	cont "wouldn't change"
	cont "it."

	para "Take care of MEW,"
	line "<PLAYER>."

	para "And call me when"
	line "you find something"
	cont "impossible again!"
	done

Route25CrystalMewEscapedText::
	text "CRYSTAL: …It got"
	line "away."

	para "We may not get"
	line "another chance."
	cont "But we know it's"
	cont "real now."

	para "I'll send OAK our"
	line "notes. This"
	cont "sighting still"
	cont "matters."
	done

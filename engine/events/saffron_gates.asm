PUSHS
SECTION "Saffron Gate Drink Scripts", ROMX

; Called by all four guards and their corridor triggers. Like Red/Blue,
; automatically accept one drink and open every gate with one shared flag.
; Return TRUE when passage is allowed, FALSE when the player is turned back.
SaffronGateGuardDrinkScript::
	opentext
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .AlreadyOpen
	takeitem FRESH_WATER
	iftrue .GaveDrink
	takeitem SODA_POP
	iftrue .GaveDrink
	takeitem LEMONADE
	iftrue .GaveDrink
	writetext SaffronGateGuardClosedText
	waitbutton
	closetext
	setval FALSE
	return

.GaveDrink:
	writetext SaffronGateGuardGaveDrinkText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	setval TRUE
	return

.AlreadyOpen:
	writetext SaffronGateGuardOpenText
	waitbutton
	closetext
	setval TRUE
	return

SaffronGateGuardClosedText:
	text "GUARD:"
	line "Sorry, this gate"
	cont "is closed for now."

	para "It's been a long"
	line "day, and I haven't"
	cont "had a chance to"
	cont "take a break."

	para "A cold drink would"
	line "sure help…"
	done

SaffronGateGuardGaveDrinkText:
	text "GUARD:"
	line "Oh, is that for"
	cont "me?"

	para "…Glug, glug…"

	para "Ahh, that's"
	line "better!"

	para "Thanks for that!"

	para "I'll let the other"
	line "guards know they"
	cont "can let you"
	cont "through, too."
	done

SaffronGateGuardOpenText:
	text "GUARD:"
	line "Thanks for that!"

	para "You can go on"
	line "through."
	done

POPS

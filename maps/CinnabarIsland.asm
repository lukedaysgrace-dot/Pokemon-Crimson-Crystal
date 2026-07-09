	object_const_def ; object_event constants
	const CINNABARISLAND_BLUE
	const CINNABARISLAND_BLUE_CLOAK

CinnabarIsland_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .FlyPoint

.FlyPoint:
	setflag ENGINE_FLYPOINT_CINNABAR
	return

CinnabarIslandBlue:
	faceplayer
	opentext
	writetext CinnabarIslandBlueText
	waitbutton
	closetext
	playsound SFX_WARP_TO
	applymovement CINNABARISLAND_BLUE, CinnabarIslandBlueTeleport
	disappear CINNABARISLAND_BLUE
	clearevent EVENT_VIRIDIAN_GYM_BLUE
	end

CinnabarIslandBlueCloakScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BLUE_CLOAK
	iftrue .Beaten
	writetext CinnabarIslandBlueCloakBeforeText
	waitbutton
	closetext
	winlosstext CinnabarIslandBlueCloakBeatenText, 0
	loadtrainer BLUE_CLOAK, BLUE_CLOAK1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLUE_CLOAK
	clearevent EVENT_RED2_IN_PALLET
	opentext
	writetext CinnabarIslandBlueCloakAfterText
	waitbutton
	closetext
	end

.Beaten:
	writetext CinnabarIslandBlueCloakAfterText
	waitbutton
	closetext
	end

CinnabarIslandGymSign:
	jumptext CinnabarIslandGymSignText

CinnabarIslandSign:
	jumptext CinnabarIslandSignText

CinnabarIslandPokecenterSign:
	jumpstd pokecentersign

CinnabarIslandHiddenRareCandy:
	hiddenitem RARE_CANDY, EVENT_CINNABAR_ISLAND_HIDDEN_RARE_CANDY

CinnabarIslandBlueTeleport:
	teleport_from
	step_end

CinnabarIslandBlueText:
	text "Who are you?"

	para "Well, it's plain"
	line "to see that you're"
	cont "a trainer…"

	para "My name's BLUE."

	para "I was once the"
	line "CHAMPION, although"

	para "it was for only a"
	line "short time…"

	para "That meddling RED"
	line "did me in…"

	para "Anyway, what do"
	line "you want? You want"

	para "to challenge me or"
	line "something?"

	para "…I hate to say"
	line "it, but I'm not in"

	para "the mood for a"
	line "battle now."

	para "Take a good look"
	line "around you…"

	para "A volcano erupts,"
	line "and just like"

	para "that, a whole town"
	line "disappears."

	para "We can go on win-"
	line "ning and losing in"

	para "#MON. But if"
	line "nature so much as"

	para "twitches, we can"
	line "lose in a second."

	para "…"

	para "That's the way it"
	line "is…"

	para "But, anyway, I'm"
	line "still a trainer."

	para "If I see a strong"
	line "opponent, it makes"
	cont "me want to battle."

	para "If you want to"
	line "battle me, come to"
	cont "the VIRIDIAN GYM."

	para "I'll take you on"
	line "then."
	done

CinnabarIslandBlueCloakBeforeText:
	text "BLUE: …You're the"
	line "one who beat RED."

	para "I've been waiting"
	line "for a rematch of"
	cont "my own."

	para "Don't hold back!"
	done

CinnabarIslandBlueCloakBeatenText:
	text "Tch… Still not"
	line "enough…"
	done

CinnabarIslandBlueCloakAfterText:
	text "BLUE: You're the"
	line "real deal."

	para "Don't get soft on"
	line "me now."
	done

CinnabarIslandGymSignText:
	text "There's a notice"
	line "here…"

	para "CINNABAR GYM has"
	line "relocated to SEA-"
	cont "FOAM ISLANDS."

	para "BLAINE"
	done

CinnabarIslandSignText:
	text "CINNABAR ISLAND"

	para "The Fiery Town of"
	line "Burning Desire"
	done

CinnabarIsland_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 11, 11, CINNABAR_POKECENTER_1F, 1

	db 0 ; coord events

	db 4 ; bg events
	bg_event 12, 11, BGEVENT_READ, CinnabarIslandPokecenterSign
	bg_event  9, 11, BGEVENT_READ, CinnabarIslandGymSign
	bg_event  7,  7, BGEVENT_READ, CinnabarIslandSign
	bg_event  9,  1, BGEVENT_ITEM, CinnabarIslandHiddenRareCandy

	db 2 ; object events
	object_event  9,  6, SPRITE_BLUE, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarIslandBlue, EVENT_BLUE_IN_CINNABAR
	object_event  9,  6, SPRITE_BLUE_CLOAK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarIslandBlueCloakScript, EVENT_BLUE_CLOAK_IN_CINNABAR

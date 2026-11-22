	object_const_def
	const SHUCKS_BARTENDER
	const SHUCKS_HOSTESS
	const SHUCKS_STAGE_DANCER
	const SHUCKS_POOL_PLAYER
	const SHUCKS_SAILOR
	const SHUCKS_PATRON
	const SHUCKS_REGULAR
	const SHUCKS_DANCING_PATRON
	const SHUCKS_GAMEBOY_KID
	const SHUCKS_SHUCKLE
	const SHUCKS_GAMBLER

Shucks_MapScripts:
	db 0 ; scene scripts
	db 0 ; callbacks

ShucksBartenderScript:
	faceplayer
	checktime NITE
	iffalse .Closed
	opentext
	writetext ShucksBartenderText
	waitbutton
	scall ShucksShuckleGreeting
	writetext ShucksBartenderShopText
	waitbutton
	pokemart MARTTYPE_SHUCKS, MART_SHUCKS
	closetext
	turnobject SHUCKS_BARTENDER, DOWN
	end
.Closed:
	farjumptext Text_ShucksClosed

ShucksDancingPatronScript:
	opentext
	writetext ShucksDancingPatronJamText
	waitbutton
	callasm ShucksStopDancing
	faceplayer
	writetext ShucksDancingPatronGrooveText
	waitbutton
	turnobject SHUCKS_DANCING_PATRON, DOWN
	callasm ShucksResumeDancing
	closetext
	end

ShucksStopDancing:
	ld a, SHUCKS_DANCING_PATRON - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_FLAGS1
	add hl, bc
	set SLIDING_F, [hl] ; hold the standing frame while he talks
	ret

ShucksResumeDancing:
	ld a, SHUCKS_DANCING_PATRON - 1
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res SLIDING_F, [hl]
	ret

ShucksGameboyKidScript:
	faceplayer
	opentext
	writetext ShucksGameboyKidText
	waitbutton
	turnobject SHUCKS_GAMEBOY_KID, DOWN
	writetext ShucksBartenderReplyText
	waitbutton
	writetext ShucksShuckleQuestionText
	cry SHUCKLE
	waitbutton
	closetext
	end

ShucksShuckleScript:
	opentext
	scall ShucksShuckleGreeting
	closetext
	end

ShucksShuckleGreeting:
	cry SHUCKLE
	writetext ShucksShuckleGreetingText
	waitbutton
	end

ShucksHostessScript:
	jumptextfaceplayer ShucksHostessText

ShucksStageDancerScript:
	jumptext ShucksStageDancerText

ShucksPoolPlayerScript:
	jumptextfaceplayer ShucksPoolPlayerText

ShucksGamblerScript:
	faceplayer
	opentext
	writetext ShucksGamblerText
	buttonsound
	turnobject SHUCKS_GAMBLER, RIGHT
	writetext ShucksGamblerAfterShotText
	waitbutton
	callasm ShucksPutGamblerToSleep
	closetext
	pause 20
	readvar VAR_YCOORD
	ifnotequal 10, .Approach
	applymovement PLAYER, ShucksMakeRoomMovement
.Approach:
	callasm ShucksKeepPoolPlayerOnMap
	applymovement SHUCKS_POOL_PLAYER, ShucksPoolPlayerApproachMovement
	opentext
	writetext ShucksPoolPlayerEscortText
	waitbutton
	callasm ShucksWakeGambler
	closetext
	callasm ShucksKeepGamblerOnMap
	follow SHUCKS_POOL_PLAYER, SHUCKS_GAMBLER
	applymovement SHUCKS_POOL_PLAYER, ShucksEscortToExitMovement
	pause 12
	stopfollow
	disappear SHUCKS_POOL_PLAYER
	applymovement SHUCKS_GAMBLER, ShucksGamblerExitMovement
	disappear SHUCKS_GAMBLER
	end

ShucksPutGamblerToSleep:
	ld a, SPRITE_GAMBLER_ASLEEP
	jr ShucksSetGamblerSprite

ShucksWakeGambler:
	ld a, SPRITE_GAMBLER
ShucksSetGamblerSprite:
	push af
	ld a, SHUCKS_GAMBLER - 1
	call CheckObjectVisibility
	jr c, .missing
	pop af
	ld e, a
	call GetSpriteVTile
	ret c
	ld hl, OBJECT_SPRITE_TILE
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld [hl], e
	; The sleeping sheet has a single facing. The awake gambler faces his escort.
	ld a, OW_DOWN
	call SetSpriteDirection
	jp UpdateSprites
.missing
	pop af
	ret

ShucksKeepPoolPlayerOnMap:
	ld a, SHUCKS_POOL_PLAYER - 1
	jr ShucksKeepEscortObjectOnMap

ShucksKeepGamblerOnMap:
	ld a, SHUCKS_GAMBLER - 1
ShucksKeepEscortObjectOnMap:
	push af
	call CheckObjectVisibility
	jr nc, .pin
	pop af
	push af
	call _CopyObjectStruct
	pop af
	push af
	call CheckObjectVisibility
.pin
	; The escort continues to the rug even beyond the player's viewport.
	jr c, .done
	ld hl, OBJECT_FLAGS1
	add hl, bc
	set WONT_DELETE_F, [hl]
.done
	pop af
	ret

ShucksMakeRoomMovement:
	step LEFT
	turn_head RIGHT
	step_end

ShucksPoolPlayerApproachMovement:
	step DOWN
	step DOWN
rept 5
	step LEFT
endr
	step UP
	step_end

ShucksEscortToExitMovement:
	step DOWN
rept 7
	step RIGHT
endr
rept 4
	step DOWN
endr
	step_end

ShucksGamblerExitMovement:
	step DOWN
	step_end

ShucksSailorScript:
	jumptextfaceplayer ShucksSailorText

ShucksPatronScript:
	jumptextfaceplayer ShucksPatronText

ShucksRegularScript:
	jumptextfaceplayer ShucksRegularText

ShucksMenuScript:
	jumptext ShucksMenuText

ShucksPoolTableScript:
	jumptext ShucksPoolTableText

ShucksCueRackScript:
	jumptext ShucksCueRackText

ShucksBottleShelfScript:
	jumptext ShucksBottleShelfText

ShucksSpeakerScript:
	jumptext ShucksSpeakerText

ShucksBartenderText:
	text "Hey there kiddo,"
	line "the name's BUCK"
	cont "and this here's my"
	cont "partner in crime"
	cont "SHUCK!"
	done

ShucksBartenderShopText:
	text "You're a little"
	line "young to be in"
	cont "here but no"
	cont "worries, we have"
	cont "options for kids."

	para "What would you"
	line "like?"
	done

ShucksDancingPatronJamText:
	text "oh yeah, this is"
	line "my jam!"
	done

ShucksDancingPatronGrooveText:
	text "Hey buddy, you"
	line "mind not throwing"
	cont "off my groove?"
	done

ShucksGameboyKidText:
	text "Dad says I spend"
	line "too much time"
	cont "playing video"
	cont "games."

	para "He runs a bar with"
	line "a SHUCKLE."

	para "Who's the weird"
	line "one here?"
	done

ShucksBartenderReplyText:
	text "BUCK: I heard that!"

	para "Ol' Shuck here"
	line "works harder than"
	cont "you do!"
	done

ShucksShuckleQuestionText:
	text "SHUCK?"
	done

ShucksShuckleGreetingText:
	text "SHUCK!"
	done

ShucksHostessText:
	text "Hey there hon,"
	line "anything I can get"
	cont "you from the kids"
	cont "menu?"
	done

ShucksStageDancerText:
	text "Well hey there"
	line "sweetie! Looking"
	cont "for a little"
	cont "excitement?"

	para "On Friday nights,"
	line "we spice things up"
	cont "with a special"
	cont "battle challenge!"

	para "Beat all the"
	line "ladies and I'll"
	cont "make sure you"
	cont "leave with"
	cont "something worth"
	cont "your trouble!"

	para "So bring your"
	line "toughest #MON"
	cont "and show us what"
	cont "you got!"
	done

ShucksPoolPlayerText:
	text "This old coot"
	line "comes in here all"
	cont "the time and"
	cont "always gets tanked"
	cont "before he even"
	cont "manages to start"
	cont "the game."
	done

ShucksPoolPlayerEscortText:
	text "You'd think by now"
	line "BUCK wouldn't"
	cont "allow him in here,"
	cont "but he's too"
	cont "kindhearted to"
	cont "kick him out."

	para "I guess I'll help"
	line "the poor guy out"
	cont "this time."
	done

ShucksGamblerText:
	text "H-hey! Wanna play"
	line "a round?"

	para "I used to be the"
	line "best pool player"
	cont "in JOHTO!"

	para "Watch this shot!"
	line "I'll show ya how"
	cont "it's done!"
	done

ShucksGamblerAfterShotText:
	text "…Wait. Why are"
	line "there three cue"
	cont "balls?"

	para "HIC!"

	para "…I think I need"
	line "to sit down…"
	done

ShucksSailorText:
	text "An ice-cold MOOMOO"
	line "MILK after a long"
	cont "voyage…"

	para "Now that's what I"
	line "call shore leave!"
	done

ShucksPatronText:
	text "The dancers have"
	line "a show tonight!"
	para "I've got the best"
	line "seat in the house."
	done

ShucksRegularText:
	text "Same table, same"
	line "drink every night."

	para "The bartender has"
	line "my order poured"
	cont "before I sit down!"
	done

ShucksMenuText:
	text "SHUCKS"

	para "SHUCK'S SPECIAL"
	line "¥800"
	cont "Our signature"
	cont "drink."

	para "Ol' Shuck's secret"
	line "recipe. Don't ask"
	cont "what's in it!"

	para "SHUCK'S RESERVE"
	line "¥1,500"
	cont "One per night."
	done

ShucksPoolTableText:
	text "A green felt pool"
	line "table. The balls"
	cont "are racked for a"
	cont "break."
	done

ShucksCueRackText:
	text "Pool cues, neatly"
	line "arranged by size."
	done

ShucksBottleShelfText:
	text "Rows of glass"
	line "bottles glint in"
	cont "the stage lights."
	done

ShucksSpeakerText:
	text "A huge speaker."
	line "It's thumping with"
	cont "a heavy bass line!"
	done

Shucks_MapEvents:
	db 0, 0 ; filler
	db 2 ; warp events
	warp_event  9, 15, GOLDENROD_CITY, 16
	warp_event 10, 15, GOLDENROD_CITY, 16
	db 0 ; coord events
	db 9 ; bg events
	bg_event 10,  0, BGEVENT_UP, ShucksMenuScript
	bg_event  4,  8, BGEVENT_READ, ShucksPoolTableScript
	bg_event  5, 10, BGEVENT_READ, ShucksPoolTableScript
	bg_event  3,  9, BGEVENT_READ, ShucksPoolTableScript
	bg_event  6,  9, BGEVENT_READ, ShucksPoolTableScript
	bg_event  1,  9, BGEVENT_READ, ShucksCueRackScript
	bg_event  2,  3, BGEVENT_READ, ShucksBottleShelfScript
	bg_event 11,  3, BGEVENT_READ, ShucksSpeakerScript
	bg_event 19,  3, BGEVENT_READ, ShucksSpeakerScript
	db 11 ; object events
	object_event  4,  2, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksBartenderScript, -1
	object_event  8,  7, SPRITE_HOSTESS, SPRITEMOVEDATA_WANDER, 2, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksHostessScript, -1
	object_event 14,  3, SPRITE_HOSTESS, SPRITEMOVEDATA_ANIMATED_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksStageDancerScript, -1
	object_event  7,  9, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksPoolPlayerScript, -1
	object_event  1,  4, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksSailorScript, -1
	object_event 10, 10, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksPatronScript, -1
	object_event 19, 13, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ShucksRegularScript, -1
	object_event 13,  5, SPRITE_FAT_GUY, SPRITEMOVEDATA_ANIMATED_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksDancingPatronScript, -1
	object_event  5,  4, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksGameboyKidScript, -1
	object_event  3,  2, SPRITE_SHUCKLE, SPRITEMOVEDATA_ANIMATED_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ShucksShuckleScript, -1
	object_event  2,  9, SPRITE_GAMBLER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksGamblerScript, -1

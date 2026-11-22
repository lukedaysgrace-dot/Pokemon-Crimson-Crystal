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
	const SHUCKS_COUNTER_COOLTRAINER
	const SHUCKS_TABLE_TEACHER
	const SHUCKS_CORNER_POKEFAN
	const SHUCKS_CORNER_COOLTRAINER

; Friday-night personas. ShucksFridayCast rewrites these weekday-only objects
; on entry during the Friday shift, so the show needs no extra object slots.
SHUCKS_STAGE_HOSTESS EQU SHUCKS_STAGE_DANCER   ; CORAL, then SCARLET, then VOLTA
SHUCKS_BRAWLER       EQU SHUCKS_DANCING_PATRON
SHUCKS_FRIDAY_TEACHER        EQU SHUCKS_SAILOR
SHUCKS_FRIDAY_COOLTRAINER_F1 EQU SHUCKS_PATRON
SHUCKS_FRIDAY_COOLTRAINER_F2 EQU SHUCKS_REGULAR
SHUCKS_FRIDAY_COOLTRAINER_M  EQU SHUCKS_POOL_PLAYER
SHUCKS_FRIDAY_COOLTRAINER_F3 EQU SHUCKS_GAMBLER

; ShucksGetShiftState results
	const_def
	const SHUCKS_SHIFT_FRESH      ; brawler still on stage
	const SHUCKS_SHIFT_BRAWL_SEEN ; brawler gone, challenge open
	const SHUCKS_SHIFT_WON        ; prize claimed this Friday

SHUCKS_CURTAIN_OPEN_LEFT  EQU $2e
SHUCKS_CURTAIN_OPEN_RIGHT EQU $2f

Shucks_MapScripts:
	db 2 ; scene scripts
	scene_script .DummyScene ; SCENE_SHUCKS_NOTHING
	scene_script .DummyScene ; SCENE_SHUCKS_FRIDAY_BRAWL

	db 2 ; callbacks
	callback MAPCALLBACK_OBJECTS, .FridayNight
	callback MAPCALLBACK_TILES, .Curtains

.DummyScene:
	end

.FridayNight:
	setscene SCENE_SHUCKS_NOTHING
	callasm ShucksCheckFridayNight
	iffalse .FridayNightDone
	callasm ShucksApplyFridayCast
	callasm ShucksGetShiftState
	ifequal SHUCKS_SHIFT_WON, .AlreadyWon
	ifequal SHUCKS_SHIFT_BRAWL_SEEN, .BrawlSeen
	setscene SCENE_SHUCKS_FRIDAY_BRAWL
	return

.AlreadyWon:
	; VOLTA, the last hostess, holds the stage for the rest of the night.
	callasm ShucksStageHostessAsVolta
.BrawlSeen:
	setevent EVENT_SHUCKS_BRAWLER_GONE
.FridayNightDone:
	return

.Curtains:
	checkevent EVENT_SHUCKS_CURTAINS_OPEN
	iffalse .CurtainsDone
	changeblock 14, 0, SHUCKS_CURTAIN_OPEN_LEFT
	changeblock 16, 0, SHUCKS_CURTAIN_OPEN_RIGHT
.CurtainsDone:
	return

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

ShucksCounterCooltrainerScript:
	jumptextfaceplayer ShucksCounterCooltrainerText

ShucksTableTeacherScript:
	jumptextfaceplayer ShucksTableTeacherText

ShucksCornerPokefanScript:
	jumptextfaceplayer ShucksCornerPokefanText

ShucksCornerCooltrainerScript:
	jumptextfaceplayer ShucksCornerCooltrainerText

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

; Friday night show ------------------------------------------------------------

ShucksFridayBrawlScene:
; Coord event at the foot of the stage stairs (15, 5): CORAL's #MON sends the
; brawler flying off the stage just as the player walks up.
	turnobject PLAYER, UP
	playsound SFX_WATER_GUN
	waitsfx
	playsound SFX_MEGA_PUNCH
	applymovement SHUCKS_BRAWLER, ShucksBrawlerKnockedBackMovement
	playsound SFX_TACKLE
	applymovement PLAYER, ShucksPlayerShovedMovement
	applymovement SHUCKS_BRAWLER, ShucksBrawlerStumbleMovement
	turnobject PLAYER, RIGHT
	opentext
	writetext ShucksBrawlerPummeledText
	waitbutton
	closetext
	applymovement SHUCKS_BRAWLER, ShucksBrawlerLeaveMovement
	disappear SHUCKS_BRAWLER
	callasm ShucksSetBrawlSeen
	setscene SCENE_SHUCKS_NOTHING
	end

ShucksBrawlerScript:
	jumptextfaceplayer ShucksBrawlerOnStageText

ShucksFridayHostessScript:
	faceplayer
	opentext
	checkevent EVENT_SHUCKS_PRIZE_OWED
	iftrue ShucksHostessGivePrize
	callasm ShucksGetShiftState
	ifequal SHUCKS_SHIFT_WON, .AlreadyWon
	writetext ShucksCoralWelcomeText
	yesorno
	iffalse .Declined
	writetext ShucksCoralCurtainsText
	waitbutton
	closetext
	; Open the curtains for the show.
	playsound SFX_WALL_OPEN
	changeblock 14, 0, SHUCKS_CURTAIN_OPEN_LEFT
	changeblock 16, 0, SHUCKS_CURTAIN_OPEN_RIGHT
	reloadmappart
	setevent EVENT_SHUCKS_CURTAINS_OPEN
	waitsfx

	; Round 1: CORAL (Water)
	winlosstext ShucksCoralBeatenText, 0
	loadtrainer HOSTESS, HOSTESS_CORAL_1
	startbattle
	reloadmapafterbattle
	opentext
	writetext ShucksCoralAfterText
	waitbutton
	closetext
	applymovement SHUCKS_STAGE_HOSTESS, ShucksHostessExitMovement
	disappear SHUCKS_STAGE_HOSTESS
	pause 20

	; Round 2: SCARLET (Fire)
	callasm ShucksStageHostessAsScarlet
	scall ShucksNextHostessEnters
	opentext
	writetext ShucksScarletIntroText
	waitbutton
	closetext
	winlosstext ShucksScarletBeatenText, 0
	loadtrainer HOSTESS, HOSTESS_SCARLET_1
	startbattle
	reloadmapafterbattle
	opentext
	writetext ShucksScarletAfterText
	waitbutton
	closetext
	applymovement SHUCKS_STAGE_HOSTESS, ShucksHostessExitMovement
	disappear SHUCKS_STAGE_HOSTESS
	pause 20

	; Round 3: VOLTA (Electric)
	callasm ShucksStageHostessAsVolta
	scall ShucksNextHostessEnters
	opentext
	writetext ShucksVoltaIntroText
	waitbutton
	closetext
	winlosstext ShucksVoltaBeatenText, 0
	loadtrainer HOSTESS, HOSTESS_VOLTA_1
	startbattle
	reloadmapafterbattle
	setevent EVENT_SHUCKS_PRIZE_OWED
	opentext
	writetext ShucksVoltaAfterText
	waitbutton
	sjump ShucksHostessGivePrize

.AlreadyWon:
	writetext ShucksVoltaComeBackText
	waitbutton
	closetext
	end

.Declined:
	writetext ShucksCoralDeclinedText
	waitbutton
	closetext
	end

ShucksNextHostessEnters:
	moveobject SHUCKS_STAGE_HOSTESS, 15, 1
	appear SHUCKS_STAGE_HOSTESS
	applymovement SHUCKS_STAGE_HOSTESS, ShucksHostessEnterMovement
	faceplayer
	end

ShucksHostessGivePrize:
; First win: the STOUT CHARM. Every later Friday: a PP UP.
	checkevent EVENT_GOT_STOUT_CHARM
	iftrue .PPUp
	verbosegiveitem STOUT_CHARM
	iffalse .BagFull
	setevent EVENT_GOT_STOUT_CHARM
	writetext ShucksStoutCharmExplainText
	waitbutton
	sjump .Claimed

.PPUp:
	verbosegiveitem PP_UP
	iffalse .BagFull
.Claimed:
	clearevent EVENT_SHUCKS_PRIZE_OWED
	callasm ShucksSetChallengeWon
	writetext ShucksVoltaComeBackText
	waitbutton
	closetext
	end

.BagFull:
	writetext ShucksPrizeBagFullText
	waitbutton
	closetext
	end

ShucksFridayTeacherScript:
	jumptextfaceplayer ShucksFridayTeacherText

ShucksFridayCooltrainerF1Script:
	jumptextfaceplayer ShucksFridayCooltrainerF1Text

ShucksFridayCooltrainerF2Script:
	jumptextfaceplayer ShucksFridayCooltrainerF2Text

ShucksFridayCooltrainerMScript:
	jumptextfaceplayer ShucksFridayCooltrainerMText

ShucksFridayCooltrainerF3Script:
	jumptextfaceplayer ShucksFridayCooltrainerF3Text

ShucksCheckFridayNight:
; wScriptVar = TRUE during the Friday shift: Friday from 6 PM, through the
; early hours of Saturday until morning.
	xor a
	ld [wScriptVar], a
	call UpdateTime
	call GetWeekday
	ld b, a
	ldh a, [hHours]
	cp NITE_HOUR
	jr c, .early_hours
	ld a, b
	cp FRIDAY
	ret nz
	jr .friday_night
.early_hours
	cp MORN_HOUR
	ret nc
	ld a, b
	cp SATURDAY
	ret nz
.friday_night
	ld a, TRUE
	ld [wScriptVar], a
	ret

ShucksGetShiftState:
	ld a, [wSwarmFlags]
	ld b, SHUCKS_SHIFT_WON
	bit SWARMFLAGS_SHUCKS_CHALLENGE_WON_F, a
	jr nz, .done
	ld b, SHUCKS_SHIFT_BRAWL_SEEN
	bit SWARMFLAGS_SHUCKS_BRAWL_SEEN_F, a
	jr nz, .done
	ld b, SHUCKS_SHIFT_FRESH
.done
	ld a, b
	ld [wScriptVar], a
	ret

ShucksSetBrawlSeen:
	ld hl, wSwarmFlags
	set SWARMFLAGS_SHUCKS_BRAWL_SEEN_F, [hl]
	ret

ShucksSetChallengeWon:
	ld hl, wSwarmFlags
	set SWARMFLAGS_SHUCKS_BRAWL_SEEN_F, [hl]
	set SWARMFLAGS_SHUCKS_CHALLENGE_WON_F, [hl]
	ret

ShucksStageHostessAsScarlet:
	ld a, PAL_NPC_RED
	jr ShucksSetStageHostessColor

ShucksStageHostessAsVolta:
	ld a, PAL_NPC_BROWN
ShucksSetStageHostessColor:
; The next appear (or the map's object load) copies this colour into the
; hostess' object struct; the same object plays all three hostesses.
	swap a
	and $f0
	ld e, a ; GetMapObject clobbers bc
	ld a, SHUCKS_STAGE_HOSTESS - 1
	call GetMapObject
	ld hl, MAPOBJECT_COLOR
	add hl, bc
	ld a, [hl]
	and $0f ; keep the object type
	or e
	ld [hl], a
	ret

ShucksApplyFridayCast:
; Overwrite each listed weekday object with its Friday persona.
	ld hl, ShucksFridayCast
.loop
	ld a, [hli]
	cp -1
	ret z
	push hl
	dec a ; object constant -> map object index
	call GetMapObject
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, OBJECT_EVENT_SIZE
	call CopyBytes
	jr .loop

ShucksFridayCast:
	db SHUCKS_STAGE_HOSTESS
	object_event 15,  2, SPRITE_HOSTESS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShucksFridayHostessScript, EVENT_SHUCKS_STAGE_HOSTESS_GONE
	db SHUCKS_BRAWLER
	object_event 15,  3, SPRITE_FAT_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksBrawlerScript, EVENT_SHUCKS_BRAWLER_GONE
	db SHUCKS_FRIDAY_TEACHER
	object_event 10, 10, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksFridayTeacherScript, -1
	db SHUCKS_FRIDAY_COOLTRAINER_F1
	object_event 13, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksFridayCooltrainerF1Script, -1
	db SHUCKS_FRIDAY_COOLTRAINER_F2
	object_event 19, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ShucksFridayCooltrainerF2Script, -1
	db SHUCKS_FRIDAY_COOLTRAINER_M
	object_event 16, 13, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ShucksFridayCooltrainerMScript, -1
	db SHUCKS_FRIDAY_COOLTRAINER_F3
	object_event 19, 13, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_PINK, OBJECTTYPE_SCRIPT, 0, ShucksFridayCooltrainerF3Script, -1
	db -1

ShucksBrawlerKnockedBackMovement:
	fix_facing
	fast_slide_step DOWN
	step_end

ShucksPlayerShovedMovement:
	fix_facing
	slide_step LEFT
	remove_fixed_facing
	step_end

ShucksBrawlerStumbleMovement:
	slide_step DOWN
	remove_fixed_facing
	turn_head LEFT
	step_end

ShucksBrawlerLeaveMovement:
rept 7
	step DOWN
endr
rept 5
	step LEFT
endr
rept 3
	step DOWN
endr
	step_end

ShucksHostessExitMovement:
	turn_head UP
	step_sleep 8
	step UP
	step_end

ShucksHostessEnterMovement:
	step DOWN
	step_end

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

ShucksBrawlerPummeledText:
	text "Oh man…"

	para "The hostesses are"
	line "extremely tough."
	cont "I got pummeled."
	done

ShucksBrawlerOnStageText:
	text "Hey, wait your"
	line "turn, buddy!"
	done

ShucksCoralWelcomeText:
	text "CORAL: Well hey"
	line "there, sugar!"

	para "It's Friday night,"
	line "so it's time for"
	cont "our stage show!"

	para "Three hostesses,"
	line "back to back. No"
	cont "breaks to heal in"
	cont "between."

	para "Beat all three of"
	line "us and you'll walk"
	cont "out with a prize."

	para "Ready to step into"
	line "the spotlight?"
	done

ShucksCoralCurtainsText:
	text "CORAL: Ooh, I like"
	line "your nerve!"

	para "Raise the"
	line "curtains, boys!"
	done

ShucksCoralDeclinedText:
	text "CORAL: Aww. The"
	line "spotlight will be"
	cont "waiting, hon."
	done

ShucksCoralBeatenText:
	text "My, my! You made"
	line "quite a splash!"
	done

ShucksCoralAfterText:
	text "CORAL: Not bad,"
	line "sugar. But the"
	cont "night's young."

	para "Don't you go"
	line "anywhere!"
	done

ShucksScarletIntroText:
	text "SCARLET: So you're"
	line "the one who got"
	cont "past CORAL?"

	para "Things are about"
	line "to heat up, hot"
	cont "stuff!"
	done

ShucksScarletBeatenText:
	text "Ouch! You're too"
	line "hot to handle!"
	done

ShucksScarletAfterText:
	text "SCARLET: Fine,"
	line "you win this one."

	para "But our headliner"
	line "is a real live"
	cont "wire. Good luck!"
	done

ShucksVoltaIntroText:
	text "VOLTA: The crowd's"
	line "buzzing about you!"

	para "Let's give them a"
	line "finale they'll"
	cont "never forget!"
	done

ShucksVoltaBeatenText:
	text "Wow! What a"
	line "shocking finish!"
	done

ShucksVoltaAfterText:
	text "VOLTA: You beat"
	line "all three of us!"
	cont "That doesn't"
	cont "happen often."

	para "A promise is a"
	line "promise. Here's"
	cont "your prize!"
	done

ShucksStoutCharmExplainText:
	text "VOLTA: Hold onto"
	line "that STOUT CHARM."

	para "A #MON holding"
	line "it shrugs off the"
	cont "extra effects of"
	cont "moves, like"
	cont "flinching."

	para "It won't get"
	line "confused either,"
	cont "not even by"
	cont "CONFUSE RAY!"

	para "Moves made just to"
	line "inflict a status,"
	cont "like THUNDER WAVE,"
	cont "still work, so"
	cont "don't get cocky!"
	done

ShucksVoltaComeBackText:
	text "VOLTA: That's the"
	line "show for tonight!"

	para "Come back next"
	line "Friday and try"
	cont "to win again!"
	done

ShucksPrizeBagFullText:
	text "VOLTA: Your BAG's"
	line "stuffed, hon!"

	para "Make some room and"
	line "talk to me before"
	cont "you leave, OK?"
	done

ShucksFridayTeacherText:
	text "I grade papers all"
	line "week long."

	para "On Fridays I come"
	line "here to grade the"
	cont "stage battles!"
	done

ShucksFridayCooltrainerF1Text:
	text "The hostesses"
	line "always seem just a"
	cont "little stronger"
	cont "than whoever"
	cont "challenges them."

	para "Spooky, right?"
	done

ShucksFridayCooltrainerF2Text:
	text "First up is CORAL,"
	line "the WATER-type"
	cont "hostess."

	para "Then comes SCARLET"
	line "with her FIRE"
	cont "#MON."
	done

ShucksFridayCooltrainerMText:
	text "Three battles and"
	line "no healing in"
	cont "between."

	para "Ration your items"
	line "or you'll never"
	cont "reach VOLTA."
	done

ShucksFridayCooltrainerF3Text:
	text "VOLTA closes the"
	line "show with her"
	cont "ELECTRIC #MON."

	para "I hear she gives"
	line "first-time winners"
	cont "a special charm!"
	done

ShucksCounterCooltrainerText:
	text "I came for a bite"
	line "after training."

	para "SHUCKLE already"
	line "knows my order!"
	done

ShucksTableTeacherText:
	text "My class is out"
	line "for the day."

	para "I'm staying right"
	line "here till my tea"
	cont "goes cold."
	done

ShucksCornerPokefanText:
	text "My SNUBBULL likes"
	line "this corner."

	para "She can hear the"
	line "music and still"
	cont "take a nap."
	done

ShucksCornerCooltrainerText:
	text "I can land a"
	line "THUNDER from clear"
	cont "across the field."

	para "At the pool table?"
	line "I miss every shot."
	done

Shucks_MapEvents:
	db 0, 0 ; filler
	db 2 ; warp events
	warp_event  9, 15, GOLDENROD_CITY, 16
	warp_event 10, 15, GOLDENROD_CITY, 16
	db 1 ; coord events
	coord_event 15,  5, SCENE_SHUCKS_FRIDAY_BRAWL, ShucksFridayBrawlScene

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
	db 15 ; object events
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
	object_event  3,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ShucksCounterCooltrainerScript, -1
	object_event 16, 10, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ShucksTableTeacherScript, -1
	object_event  1, 14, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ShucksCornerPokefanScript, -1
	object_event  4, 14, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ShucksCornerCooltrainerScript, -1

; One page for the four saved gameplay settings. No new saved fields.
; wJumptableIndex = row (0-4); wBuffer1 = pending difficulty (0/1).
InitNewGameOptions:
	call InitGenderScreen
	call LoadGenderScreenPal
	call CharSelect_LoadTextPalette
	call CharSelect_FillBackground
	xor a
	ld [wJumptableIndex], a
	ld [wBuffer1], a
	ld [wGameplayRules], a
	hlcoord 0, 0
	lb bc, 11, 18
	call Textbox
	hlcoord 2, 1
	ld de, .Title
	call PlaceString
	hlcoord 2, 3
	ld de, .Labels
	call PlaceString
	call NewGameOptions_Draw
	call WaitBGMap2
	call SetPalettes
	call ClearJoypad
.loop
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyPressed]
	bit D_UP_F, a
	jr nz, .up
	bit D_DOWN_F, a
	jr nz, .down
	and A_BUTTON | D_LEFT | D_RIGHT | START
	jr z, .loop
	ld a, [wJumptableIndex]
	cp 4
	jr z, .continue
	ldh a, [hJoyPressed]
	and START
	jr nz, .loop
	ld a, [wJumptableIndex]
	and a
	jr z, .difficulty
	dec a
	ld b, a
	ld a, 1
	jr z, .toggle
.mask
	add a
	dec b
	jr nz, .mask
.toggle
	ld hl, wGameplayRules
	xor [hl]
	ld [hl], a
	jr .draw
.difficulty
	ld a, [wBuffer1]
	xor 1
	ld [wBuffer1], a
	jr .draw
.up
	ld a, [wJumptableIndex]
	and a
	jr nz, .decrement
	ld a, 5
.decrement
	dec a
	jr .row
.down
	ld a, [wJumptableIndex]
	inc a
	cp 5
	jr c, .row
	xor a
.row
	ld [wJumptableIndex], a
.draw
	call NewGameOptions_Draw
	jr .loop
.continue
	ldh a, [hJoyPressed]
	and A_BUTTON | START
	jr z, .loop
	ld de, ENGINE_HARD_MODE
	ld b, RESET_FLAG
	ld a, [wBuffer1]
	and a
	jr z, .apply
	ld b, SET_FLAG
.apply
	farcall EngineFlagAction
	ret

.Title: db "NEW GAME OPTIONS@"
.Labels:
	db "Mode<LF><LF>"
	db "Typing<LF><LF>"
	db "Stats<LF><LF>"
	db "Abilities<LF><LF>"
	db "CONTINUE@"

NewGameOptions_Draw:
	ld a, [wBuffer1]
	and a
	ld de, .Normal
	jr z, .difficulty
	ld de, .Hard
.difficulty
	hlcoord 10, 3
	call PlaceString
	ld a, [wGameplayRules]
	bit GAMEPLAYRULES_ORIGINAL_TYPES_F, a
	ld de, .Enhanced
	jr z, .typing
	ld de, .Original
.typing
	hlcoord 10, 5
	call PlaceString
	ld a, [wGameplayRules]
	bit GAMEPLAYRULES_ORIGINAL_STATS_F, a
	ld de, .Enhanced
	jr z, .stats
	ld de, .Original
.stats
	hlcoord 10, 7
	call PlaceString
	ld a, [wGameplayRules]
	bit GAMEPLAYRULES_NO_ABILITIES_F, a
	ld de, .On
	jr z, .abilities
	ld de, .Off
.abilities
	hlcoord 12, 9
	call PlaceString
; Clear the cursor column.
	hlcoord 1, 3
	ld b, 10
	ld de, SCREEN_WIDTH
.clear
	ld [hl], " "
	add hl, de
	dec b
	jr nz, .clear
	ld a, [wJumptableIndex]
	add a
.cursor
	ld b, a
	hlcoord 1, 3
	and a
	jr z, .place
.cursor_row
	add hl, de
	dec b
	jr nz, .cursor_row
.place
	ld [hl], "▶"

; Short context for the selected setting, always on this same page.
	hlcoord 0, 13
	lb bc, 3, 18
	call Textbox
	ld a, [wJumptableIndex]
	ld hl, .Help
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [wJumptableIndex]
	and a
	jr nz, .help
	ld a, [wBuffer1]
	and a
	jr z, .help
	ld de, .HardHelp
.help
	hlcoord 1, 14
	call PlaceString
	ret

.Normal:   db "Normal  @"
.Hard:     db "Hard    @"
.Original: db "Original@"
.Enhanced: db "Enhanced@"
.On:       db "On    @"
.Off:      db "Off   @"

.Help:
	dw .NormalHelp, .TypingHelp, .StatsHelp, .AbilitiesHelp, .ContinueHelp
.NormalHelp:
	db "Items, switches OK<LF>No GYM level caps.@"
.HardHelp:
	db "No battle items.<LF>Level caps.<LF>SET mode.@"
.TypingHelp:
	db "Official types or<LF>Crimson changes.@"
.StatsHelp:
	db "Official stats or<LF>Crimson buffs.@"
.AbilitiesHelp:
	db "Use ABILITIES in<LF>battle: On or Off.@"
.ContinueHelp:
	db "A: begin adventure<LF>Up/Down: settings@"

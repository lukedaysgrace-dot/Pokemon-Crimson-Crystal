	const_def 1
	const PINK_PAGE   ; 1: overview (dex no, name, types, OT, ID) + experience
	const BLUE_PAGE   ; 2: HP + stats + ability
	const GREEN_PAGE  ; 3: moves + held item
	const ORANGE_PAGE ; 4: met info + friendship
NUM_STAT_PAGES EQU const_value + -1

; Pages now use 3 bits of wcf64 (bit 2 was previously unused).
STAT_PAGE_MASK EQU %00000111

; Polished-style summary screen tiles, loaded at vTiles2 $42-$4a.
; ($36-$3d, the old 2x2 page squares, are left loaded but unused;
; the page squares are OAM sprites now.)
SUMMARY_TILE_SIDE_TL  EQU $42 ; side panel top-left corner
SUMMARY_TILE_SIDE_T   EQU $43 ; side panel top edge (also bottom panel top edge)
SUMMARY_TILE_SIDE_L   EQU $44 ; side panel left edge
SUMMARY_TILE_SIDE_BL  EQU $45 ; side panel bottom-left corner
SUMMARY_TILE_SIDE_B   EQU $46 ; side panel bottom edge
SUMMARY_TILE_TAB_L    EQU $47 ; bottom tab left corner
SUMMARY_TILE_TAB_FILL EQU $48 ; bottom tab top edge
SUMMARY_TILE_TAB_R    EQU $49 ; bottom tab right corner

; OBJ tiles (vTiles0): $00 page square, $01 selected page square,
; $02 caught ball icon (colored through OBJ palette 4)

BattleStatsScreenInit:
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jr nz, StatsScreenInit

	ld a, [wBattleMode]
	and a
	jr z, StatsScreenInit
	jr _MobileStatsScreenInit

StatsScreenInit:
	ld hl, StatsScreenMain
	jr StatsScreenInit_gotaddress

_MobileStatsScreenInit:
	ld hl, StatsScreenMobile
	jr StatsScreenInit_gotaddress

StatsScreenInit_gotaddress:
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a ; disable overworld tile animations
	ld a, [wBoxAlignment] ; whether sprite is to be mirrorred
	push af
	ld a, [wJumptableIndex]
	ld b, a
	ld a, [wcf64]
	ld c, a

	push bc
	push hl
	call ClearBGPalettes
	call ClearTileMap
	call UpdateSprites
	farcall StatsScreen_LoadFont
	pop hl
	call _hl_
	call ClearSprites
	call ClearBGPalettes
	call ClearTileMap
	pop bc

	; restore old values
	ld a, b
	ld [wJumptableIndex], a
	ld a, c
	ld [wcf64], a
	pop af
	ld [wBoxAlignment], a
	pop af
	ldh [hMapAnims], a
	ret

StatsScreenMain:
	xor a
	ld [wJumptableIndex], a
	; stupid interns
	ld [wcf64], a
	ld a, [wcf64]
	and $ff ^ STAT_PAGE_MASK
	or 1
	ld [wcf64], a
.loop
	ld a, [wJumptableIndex]
	and $ff ^ (1 << 7)
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim ; check for keys?
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
	ret

StatsScreenMobile:
	xor a
	ld [wJumptableIndex], a
	; stupid interns
	ld [wcf64], a
	ld a, [wcf64]
	and $ff ^ STAT_PAGE_MASK
	or 1
	ld [wcf64], a
.loop
	farcall Mobile_SetOverworldDelay
	ld a, [wJumptableIndex]
	and $ff ^ (1 << 7)
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim
	farcall MobileComms_CheckInactivityTimer
	jr c, .exit
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop

.exit
	ret

StatsScreenPointerTable:
	dw MonStatsInit       ; regular pokémon
	dw EggStatsInit       ; egg
	dw StatsScreenWaitCry
	dw EggStatsJoypad
	dw StatsScreen_LoadPage
	dw StatsScreenWaitCry
	dw MonStatsJoypad
	dw StatsScreen_Exit

StatsScreen_WaitAnim:
	ld hl, wcf64
	bit 6, [hl]
	jr nz, .try_anim
	bit 5, [hl]
	jr nz, .finish
	call DelayFrame
	ret

.try_anim
	farcall SetUpPokeAnim
	jr nc, .finish
	ld hl, wcf64
	res 6, [hl]
.finish
	ld hl, wcf64
	res 5, [hl]
	; transfer tiles and attributes together so page switches
	; land in a single frame instead of colors changing first
	farcall HDMATransferAttrMapAndTileMapToWRAMBank3
	ret

StatsScreen_SetJumptableIndex:
	ld a, [wJumptableIndex]
	and $80
	or h
	ld [wJumptableIndex], a
	ret

StatsScreen_Exit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

MonStatsInit:
	ld hl, wcf64
	res 6, [hl]
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	farcall HDMATransferTileMapToWRAMBank3
	call StatsScreen_CopyToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call StatsScreen_InitStatics
	ld hl, wcf64
	set 4, [hl]
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.egg
	ld h, 1
	call StatsScreen_SetJumptableIndex
	ret

EggStatsInit:
	call EggStatsScreen
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

EggStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .check
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.check
	bit A_BUTTON_F, a
	jr nz, .quit
	and D_DOWN | D_UP | A_BUTTON | B_BUTTON
	jp StatsScreen_JoypadAction

.quit
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

StatsScreen_LoadPage:
	call StatsScreen_LoadGFX
	ld hl, wcf64
	res 4, [hl]
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

MonStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .next
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.next
	and D_DOWN | D_UP | D_LEFT | D_RIGHT | A_BUTTON | B_BUTTON
	jp StatsScreen_JoypadAction

StatsScreenWaitCry:
	call IsSFXPlaying
	ret nc
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

StatsScreen_CopyToTempMon:
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .breedmon
	ld a, [wBufferMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wBufferMon
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	jr .done

.breedmon
	farcall CopyMonToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .done
	ld a, [wMonType]
	cp BOXMON
	jr c, .done
	farcall CalcTempmonStats
.done
	and a
	ret

StatsScreen_GetJoypad:
	call GetJoypad
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .notbreedmon
	push hl
	push de
	push bc
	farcall StatsScreenDPad
	pop bc
	pop de
	pop hl
	ld a, [wMenuJoypad]
	and D_DOWN | D_UP
	jr nz, .set_carry
	ld a, [wMenuJoypad]
	jr .clear_flags

.notbreedmon
	ldh a, [hJoyPressed]
.clear_flags
	and a
	ret

.set_carry
	scf
	ret

StatsScreen_JoypadAction:
	push af
	ld a, [wcf64]
	and STAT_PAGE_MASK
	ld c, a
	pop af
	bit B_BUTTON_F, a
	jp nz, .b_button
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	jr .done

.d_down
	ld a, [wMonType]
	cp BOXMON
	jr nc, .done
	and a
	ld a, [wPartyCount]
	jr z, .next_mon
	ld a, [wOTPartyCount]
.next_mon
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	cp b
	jr z, .done
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.d_up
	ld a, [wCurPartyMon]
	and a
	jr z, .done
	dec a
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.a_button
	ld a, c
	cp ORANGE_PAGE ; last page
	jr z, .b_button
.d_right
	inc c
	ld a, ORANGE_PAGE ; last page
	cp c
	jr nc, .set_page
	ld c, PINK_PAGE ; first page
	jr .set_page

.d_left
	dec c
	jr nz, .set_page
	ld c, ORANGE_PAGE ; last page
	jr .set_page

.done
	ret

.set_page
	ld a, [wcf64]
	and $ff ^ STAT_PAGE_MASK
	or c
	ld [wcf64], a
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.load_mon
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.b_button
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

StatsScreen_InitStatics:
; Load the summary tiles, compute the HP palette, and place the
; level + gender below the pokepic. Everything else is per-page.
	call LoadSummaryScreenGFX
	call .PlaceHPBar
	xor a
	ldh [hBGMapMode], a
	hlcoord 1, 8
	call PrintLevel
	hlcoord 5, 8
	call StatsScreen_PlaceGenderChar
	ret

.PlaceHPBar:
	ld hl, wTempMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wTempMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	farcall ComputeHPBarPixels
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call DelayFrame
	ret

StatsScreen_PlaceGenderChar:
	push hl
	farcall GetGender
	pop hl
	ret c
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"
.got_gender
	ld [hl], a
	ret

LoadSummaryScreenGFX:
	ld de, SummaryScreenTilesGFX
	ld hl, vTiles2 tile SUMMARY_TILE_SIDE_TL
	lb bc, BANK(SummaryScreenTilesGFX), 8
	call Get2bpp
	ld de, SummaryScreenSquareOBJGFX
	ld hl, vTiles0 tile $00
	lb bc, BANK(SummaryScreenSquareOBJGFX), 2
	call Get2bpp
	; the caught ball icon is the same graphic the party menu used
	; (gfx/stats/caught_ball.png)
	ld de, PartyMenuBallGFX
	ld hl, vTiles0 tile $02
	lb bc, BANK(PartyMenuBallGFX), 1
	call Get2bpp
	ret

StatsScreen_PlaceHorizontalDivider:
	hlcoord 0, 7
	ld b, SCREEN_WIDTH
	ld a, $62 ; horizontal divider (empty HP/exp bar)
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

StatsScreen_LoadGFX:
	ld a, [wBaseSpecies]
	ld [wTempSpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	xor a
	ldh [hBGMapMode], a
	call .ClearBox
	call StatsScreen_DrawFrames
	call .PageTilemap
	call .LoadPals
	call StatsScreen_PlacePageSquares
	ld hl, wcf64
	bit 4, [hl]
	jr nz, .place_frontpic
	call SetPalettes
	ret

.place_frontpic
	call StatsScreen_PlaceFrontpic
	ret

.ClearBox:
	; side panel area
	hlcoord 7, 1
	lb bc, 11, 13
	call ClearBox
	; old tab remnants left of the panel
	hlcoord 0, 11
	lb bc, 1, 7
	call ClearBox
	; bottom panel area
	hlcoord 0, 12
	lb bc, 6, 20
	call ClearBox
	; top row right of the pokepic
	hlcoord 7, 0
	lb bc, 1, 13
	call ClearBox
	ret

.LoadPals:
	ld a, [wcf64]
	and STAT_PAGE_MASK
	ld c, a
	farcall LoadSummaryScreenPals
	call DelayFrame
	ld hl, wcf64
	set 5, [hl]
	ret

.PageTilemap:
	ld a, [wcf64]
	and STAT_PAGE_MASK
	dec a
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
; entries correspond to *_PAGE constants
	dw StatsScreen_PinkPage
	dw StatsScreen_BluePage
	dw StatsScreen_GreenPage
	dw StatsScreen_OrangePage

StatsScreen_DrawFrames:
; Draw the side panel frame, the bottom panel top edge,
; and the page switch arrows.
	hlcoord 7, 1
	ld [hl], SUMMARY_TILE_SIDE_TL
	hlcoord 8, 1
	ld a, SUMMARY_TILE_SIDE_T
	ld b, 12
.top
	ld [hli], a
	dec b
	jr nz, .top
	hlcoord 7, 2
	ld de, SCREEN_WIDTH
	ld a, SUMMARY_TILE_SIDE_L
	ld b, 9
.left
	ld [hl], a
	add hl, de
	dec b
	jr nz, .left
	hlcoord 7, 11
	ld [hl], SUMMARY_TILE_SIDE_BL
	hlcoord 8, 11
	ld a, SUMMARY_TILE_SIDE_B
	ld b, 12
.bottom
	ld [hli], a
	dec b
	jr nz, .bottom
	hlcoord 0, 12
	ld a, SUMMARY_TILE_SIDE_T ; doubles as the bottom panel top edge
	ld b, SCREEN_WIDTH
.bottom_panel
	ld [hli], a
	dec b
	jr nz, .bottom_panel
	; page switch arrows
	hlcoord 11, 0
	ld [hl], "◀"
	hlcoord 19, 0
	ld [hl], "▶"
	ret

DrawSummaryTab:
; Draw the bottom panel tab and its label. de = label string.
; The tab hump is always 6 cells wide (columns 1-6) so it never
; overlaps the side panel's bottom-left corner; longer labels
; simply spill onto the panel's top edge, like Polished's do.
	push de
	hlcoord 1, 11
	ld [hl], SUMMARY_TILE_TAB_L
	inc hl
	ld a, SUMMARY_TILE_TAB_FILL
	ld b, 4
.hump
	ld [hli], a
	dec b
	jr nz, .hump
	ld [hl], SUMMARY_TILE_TAB_R
	; blank the tab interior on row 12
	hlcoord 1, 12
	ld a, " "
	ld b, 6
.blank
	ld [hli], a
	dec b
	jr nz, .blank
	pop de
	hlcoord 2, 12
	jp PlaceString

StatsScreen_PlacePageSquares:
; Place the four page squares as OAM sprites along the top.
	ld a, [wcf64]
	and STAT_PAGE_MASK
	ld d, a
	ld hl, wVirtualOAM
	ld b, 1   ; page counter
	ld c, 104 ; x of first square
.loop
	ld a, 17 ; y
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	cp d
	ld a, 0 ; normal square tile (preserves flags)
	jr nz, .got_tile
	inc a   ; selected square tile
.got_tile
	ld [hli], a
	ld a, b
	dec a   ; OBJ palette 0-3
	ld [hli], a
	ld a, c
	add 16
	ld c, a
	inc b
	ld a, b
	cp NUM_STAT_PAGES + 1
	jr nz, .loop

	; sprite 4: caught ball icon on the pink and orange pages
	ld hl, wVirtualOAMSprite04
	ld a, [wcf64]
	and STAT_PAGE_MASK
	cp PINK_PAGE
	lb de, 56, 152 ; y, x: right of the type badges at (18, 5)
	jr z, .got_ball_pos
	cp ORANGE_PAGE
	lb de, 88, 72 ; y, x: at (8, 9), next to the ball name
	jr z, .got_ball_pos
	; other pages: hide it
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret
.got_ball_pos
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $02 ; ball tile
	ld [hli], a
	ld a, 4 ; ball OBJ palette
	ld [hl], a
	ret

PlaceTypeAbbreviation:
; Print the 4-character abbreviation for type a at hl.
	push hl
	ld l, a
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de ; x5
	ld de, TypeAbbreviations
	add hl, de
	ld d, h
	ld e, l
	pop hl
	jp PlaceString

; ================================
; Pink page: overview + experience
; ================================

StatsScreen_PinkPage:
	ld de, .ExpTabString
	call DrawSummaryTab

	; dex number
	ld a, [wBaseSpecies]
	ld [wCurSpecies], a
	call GetPokemonIndexFromID
	ld a, h
	ld h, l
	ld l, a
	push hl
	ld hl, sp + 0
	ld d, h
	ld e, l
	hlcoord 8, 2
	ld a, "№"
	ld [hli], a
	ld a, "."
	ld [hli], a
	lb bc, PRINTNUM_LEADINGZEROS | 2, 3
	call PrintNum
	add sp, 2

	; shiny indicator
	ld bc, wTempMonDVs
	farcall CheckShininess
	jr nc, .not_shiny
	hlcoord 18, 2
	ld [hl], $3f ; shiny sparkles icon
.not_shiny

	; nickname
	ld hl, .NicknamePointers
	call GetNicknamePointer
	call CopyNickname
	hlcoord 8, 3
	call PlaceString

	; species
	hlcoord 8, 4
	ld a, "/"
	ld [hli], a
	ld a, [wBaseSpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	call PlaceString

	; type badges
	ld a, [wBaseType1]
	hlcoord 8, 5
	call PlaceTypeAbbreviation
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	jr z, .one_type
	hlcoord 13, 5
	call PlaceTypeAbbreviation
.one_type
	; (the caught ball icon at (18, 5) is an OAM sprite; see
	; StatsScreen_PlacePageSquares)

	; OT name
	ld de, OTString
	hlcoord 8, 7
	call PlaceString
	ld hl, .OTNamePointers
	call GetNicknamePointer
	call CopyNickname
	farcall CorrectNickErrors
	hlcoord 11, 7
	call PlaceString
	ld a, [wTempMonCaughtGender]
	and a
	jr z, .ot_done
	cp $7f
	jr z, .ot_done
	and $80
	ld a, "♂"
	jr z, .got_ot_gender
	ld a, "♀"
.got_ot_gender
	hlcoord 18, 7
	ld [hl], a
.ot_done

	; ID number
	ld de, IDNoString
	hlcoord 8, 9
	call PlaceString
	hlcoord 11, 9
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	ld de, wTempMonID
	call PrintNum

	; --- bottom panel: experience ---
	ld de, .ExpPointStr
	hlcoord 1, 13
	call PlaceString
	hlcoord 12, 13
	lb bc, 3, 7
	ld de, wTempMonExp
	call PrintNum
	call .CalcExpToNextLevel
	ld de, .LevelUpStr
	hlcoord 1, 15
	call PlaceString
	hlcoord 12, 15
	lb bc, 3, 7
	ld de, wBuffer1
	call PrintNum
	ld de, .ToStr
	hlcoord 13, 17
	call PlaceString
	hlcoord 16, 17
	call .PrintNextLevel
	; the original exp bar
	hlcoord 2, 17
	ld a, [wTempMonLevel]
	ld b, a
	ld de, wTempMonExp + 2
	predef FillInExpBar
	hlcoord 1, 17
	ld [hl], $40 ; left exp bar end cap
	hlcoord 10, 17
	ld [hl], $41 ; right exp bar end cap
	ret

.PrintNextLevel:
	ld a, [wTempMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .AtMaxLevel
	inc a
	ld [wTempMonLevel], a
.AtMaxLevel:
	call PrintLevel
	pop af
	ld [wTempMonLevel], a
	ret

.CalcExpToNextLevel:
	ld a, [wTempMonLevel]
	cp MAX_LEVEL
	jr z, .AlreadyAtMaxLevel
	inc a
	ld d, a
	farcall CalcExpAtLevel
	ld hl, wTempMonExp + 2
	ldh a, [hQuotient + 3]
	sub [hl]
	dec hl
	ld [wBuffer3], a
	ldh a, [hQuotient + 2]
	sbc [hl]
	dec hl
	ld [wBuffer2], a
	ldh a, [hQuotient + 1]
	sbc [hl]
	ld [wBuffer1], a
	ret

.AlreadyAtMaxLevel:
	ld hl, wBuffer1
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.NicknamePointers:
	dw wPartyMonNicknames
	dw wOTPartyMonNicknames
	dw sBoxMonNicknames
	dw wBufferMonNick

.OTNamePointers:
	dw wPartyMonOT
	dw wOTPartyMonOT
	dw sBoxMonOT
	dw wBufferMonOT

.ExpTabString:
	db "Exp.@"

.ExpPointStr:
	db "Exp.Points@"

.LevelUpStr:
	db "Level Up@"

.ToStr:
	db "to@"

IDNoString:
	db "<ID>№.@"

OTString:
	db "OT/@"

; ==============================
; Blue page: stats + ability
; ==============================

StatsScreen_BluePage:
	ld de, .AbilityTabString
	call DrawSummaryTab

	; the original HP bar (caps, bar, and HP numbers)
	hlcoord 10, 2
	ld b, $0
	predef DrawPlayerHP

	; stat labels
	ld de, .AttackStr
	hlcoord 8, 4
	call PlaceString
	ld de, .DefenseStr
	hlcoord 8, 5
	call PlaceString
	ld de, .SpclAtkStr
	hlcoord 8, 6
	call PlaceString
	ld de, .SpclDefStr
	hlcoord 8, 7
	call PlaceString
	ld de, .SpeedStr
	hlcoord 8, 8
	call PlaceString

	; stat values
	ld de, wTempMonAttack
	hlcoord 16, 4
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonDefense
	hlcoord 16, 5
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpclAtk
	hlcoord 16, 6
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpclDef
	hlcoord 16, 7
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpeed
	hlcoord 16, 8
	lb bc, 2, 3
	call PrintNum

	; --- bottom panel: ability ---
	ld a, [wTempMonPersonality]
	ld b, a
	ld a, [wTempMonSpecies]
	ld c, a
	call GetAbility
	push bc
	farcall GetAbilityName
	ld de, wStringBuffer1
	hlcoord 1, 13
	call PlaceString
	; ability slot indicator
	ld a, [wTempMonPersonality]
	and ABILITY_MASK
	cp HIDDEN_ABILITY
	ld b, "H"
	jr z, .got_slot
	cp ABILITY_2
	ld b, "2"
	jr z, .got_slot
	ld b, "1"
.got_slot
	ld a, b
	hlcoord 18, 13
	ld [hl], a
	pop bc
	; note: farcall clobbers hl, so the coords are passed in de
	decoord 1, 15
	farcall PrintAbilityDescriptionStats
	ret

.AbilityTabString:
	db "Ability@"

.AttackStr:
	db "Attack@"

.DefenseStr:
	db "Defense@"

.SpclAtkStr:
	db "Sp.Atk@"

.SpclDefStr:
	db "Sp.Def@"

.SpeedStr:
	db "Speed@"

; ==============================
; Green page: moves + held item
; ==============================

StatsScreen_GreenPage:
	ld de, .ItemTabString
	call DrawSummaryTab

	; --- bottom panel: held item ---
	call .GetItemName
	hlcoord 1, 13
	call PlaceString
	ld a, [wTempMonItem]
	and a
	jr z, .no_item_desc
	ld [wCurSpecies], a
	decoord 1, 15
	farcall PrintItemDescription
	ld a, [wBaseSpecies]
	ld [wCurSpecies], a
.no_item_desc

	; --- side panel: moves ---
	ld hl, wTempMonMoves
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	call CopyBytes
	hlcoord 8, 2
	ld a, SCREEN_WIDTH * 2
	ld [wBuffer1], a
	predef ListMoves
	hlcoord 12, 3
	ld a, SCREEN_WIDTH * 2
	ld [wBuffer1], a
	predef ListMovePP

	; move type badges
	ld c, 0
.badge_loop
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	and a
	jr z, .badges_done
	push bc
	ld de, wStringBuffer2
	call GetMoveData
	ld a, [wStringBuffer2 + MOVE_TYPE]
	pop bc
	push bc
	push af
	hlcoord 8, 3
	ld a, c
	and a
	jr z, .got_row
	ld de, 2 * SCREEN_WIDTH
.row_loop
	add hl, de
	dec a
	jr nz, .row_loop
.got_row
	pop af
	call PlaceTypeAbbreviation
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .badge_loop
.badges_done
	ret

.GetItemName:
	ld de, .NoItemString
	ld a, [wTempMonItem]
	and a
	ret z
	ld b, a
	farcall TimeCapsule_ReplaceTeruSama
	ld a, b
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ret

.ItemTabString:
	db "Item@"

.NoItemString:
	db "No held item@"

; ====================================
; Orange page: met info + friendship
; ====================================

StatsScreen_OrangePage:
	ld de, .FriendTabString
	call DrawSummaryTab

	; --- side panel: met info ---
	ld de, .WhereMetStr
	hlcoord 8, 2
	call PlaceString

	ld a, [wTempMonCaughtLocation]
	and CAUGHT_LOCATION_MASK
	cp GIFT_LOCATION
	jr z, .gift
	and a
	jr z, .unknown_loc
	ld e, a
	farcall GetLandmarkName
	call .PrintLocationName
	jr .loc_done
.gift
	ld de, .ReceivedStr
	hlcoord 8, 3
	call PlaceString
	ld de, .AsGiftStr
	hlcoord 8, 4
	call PlaceString
	jr .loc_done
.unknown_loc
	ld de, .FarawayStr
	hlcoord 8, 3
	call PlaceString
	ld de, .PlaceStr
	hlcoord 8, 4
	call PlaceString
.loc_done

	; caught level
	ld a, [wTempMonCaughtLevel]
	and CAUGHT_LEVEL_MASK
	jr z, .level_done
	cp CAUGHT_EGG_LEVEL
	jr z, .hatched
	ld de, .MetAtStr
	hlcoord 8, 6
	call PlaceString
	ld h, b
	ld l, c
	ld a, [wTempMonLevel]
	push af
	ld a, [wTempMonCaughtLevel]
	and CAUGHT_LEVEL_MASK
	ld [wTempMonLevel], a
	call PrintLevel
	pop af
	ld [wTempMonLevel], a
	jr .level_done
.hatched
	ld de, .HatchedStr
	hlcoord 8, 6
	call PlaceString
.level_done

	; shiny indicator
	ld bc, wTempMonDVs
	farcall CheckShininess
	jr nc, .not_shiny
	hlcoord 18, 2
	ld [hl], $3f ; shiny sparkles icon
.not_shiny

	; caught ball (the icon at (8, 9) is an OAM sprite; see
	; StatsScreen_PlacePageSquares)
	ld de, .BallUsedStr
	hlcoord 8, 8
	call PlaceString
	ld a, [wTempMonPersonality]
	and CAUGHT_BALL_MASK
	; must be a plain call: farcall would clobber a (the ball index),
	; which made every mon read as caught in a Poke Ball
	call GetCaughtBallItem
	ld a, c
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	hlcoord 9, 9
	call PlaceString

	; --- bottom panel: friendship ---
	hlcoord 1, 13
	ld [hl], $34 ; heart icon
	hlcoord 3, 13
	lb bc, 1, 3
	ld de, wTempMonHappiness
	call PrintNum
	ld de, .OutOf255Str
	hlcoord 6, 13
	call PlaceString
	; friendship meter, original HP/exp bar style
	hlcoord 1, 15
	ld [hl], $40 ; left end cap
	hlcoord 8, 15
	ld [hl], $41 ; right end cap
	ld a, [wTempMonHappiness]
	ld c, a
	ld b, 0
	ld d, 0
	ld e, 255
	farcall ComputeHPBarPixels
	hlcoord 2, 15
	call .DrawFriendshipBar
	ret

.DrawFriendshipBar:
; Draw a 6-tile bar at hl filled to e pixels (0-48),
; using the original HP/exp bar tiles.
	ld c, 6
.bar_loop
	ld a, e
	sub TILE_WIDTH
	jr c, .partial
	ld e, a
	ld a, $6a ; full bar
	jr .put
.partial
	ld a, e
	and a
	jr z, .empty
	add $62 ; partially filled bar
	ld e, 0
	jr .put
.empty
	ld a, $62 ; empty bar
.put
	ld [hli], a
	dec c
	jr nz, .bar_loop
	ret

.PrintLocationName:
; Print the landmark name in wStringBuffer1 at (8, 3).
; Names longer than 12 characters get split at the last space
; and continue on the next row.
	ld hl, wStringBuffer1
	ld b, 0
.len_loop
	ld a, [hli]
	cp "@"
	jr z, .got_len
	inc b
	ld a, b
	cp 18
	jr nz, .len_loop
.got_len
	ld a, b
	cp 13
	jr c, .fits
	; find the last space at index 12 or lower
	ld b, 12
.space_loop
	ld hl, wStringBuffer1
	push bc
	ld c, b
	ld b, 0
	add hl, bc
	pop bc
	ld a, [hl]
	cp " "
	jr z, .split
	dec b
	jr nz, .space_loop
	; no space found: truncate
	ld hl, wStringBuffer1 + 12
	ld [hl], "@"
	jr .fits
.split
	ld [hl], "@"
	inc hl
	push hl
	ld de, wStringBuffer1
	hlcoord 8, 3
	call PlaceString
	pop de
	hlcoord 8, 4
	jp PlaceString
.fits
	ld de, wStringBuffer1
	hlcoord 8, 3
	jp PlaceString

.FriendTabString:
	db "Friend@"

.WhereMetStr:
	db "Where met:@"

.MetAtStr:
	db "Met at @"

.HatchedStr:
	db "Hatched@"

.BallUsedStr:
	db "Ball used:@"

.ReceivedStr:
	db "Received as@"

.AsGiftStr:
	db "a gift@"

.FarawayStr:
	db "Faraway@"

.PlaceStr:
	db "place@"

.OutOf255Str:
	db "/255@"

; ==============================

StatsScreen_PlaceFrontpic:
	ld hl, wTempMonDVs
	predef GetUnownLetter
	call StatsScreen_GetAnimationParam
	jr c, .egg
	and a
	jr z, .no_cry
	jr .cry

.egg
	call .AnimateEgg
	call SetPalettes
	ret

.no_cry
	call .AnimateMon
	call SetPalettes
	ret

.cry
	call SetPalettes
	call .AnimateMon
	ld a, [wCurPartySpecies]
	call PlayMonCry2
	ret

.AnimateMon:
	ld hl, wcf64
	set 5, [hl]
	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(UNOWN)
	ld a, h
	hlcoord 0, 0
	jp nz, PrepMonFrontpic
	if HIGH(UNOWN) == 0
		and a
	elif HIGH(UNOWN) == 1
		dec a
	else
		cp HIGH(UNOWN)
	endc
	jp nz, PrepMonFrontpic
	xor a
	ld [wBoxAlignment], a
	jp _PrepMonFrontpic

.AnimateEgg:
	ld a, [wCurPartySpecies]
	push hl
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(UNOWN)
	ld a, h
	pop hl
	jr nz, .not_unown_egg
	if HIGH(UNOWN) == 0
		and a
	elif HIGH(UNOWN) == 1
		dec a
	else
		cp HIGH(UNOWN)
	endc
	jr z, .unownegg
.not_unown_egg
	ld a, TRUE
	ld [wBoxAlignment], a
	jr .get_animation
.unownegg
	xor a
	ld [wBoxAlignment], a
	; fallthrough

.get_animation
	ld a, [wCurPartySpecies]
	call IsAPokemon
	ret c
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	hlcoord 0, 0
	ld d, $0
	ld e, ANIM_MON_MENU
	predef LoadMonAnimation
	ld hl, wcf64
	set 6, [hl]
	ret

StatsScreen_GetAnimationParam:
	ld a, [wMonType]
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
	dw .PartyMon
	dw .OTPartyMon
	dw .BoxMon
	dw .Tempmon
	dw .Wildmon

.PartyMon:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld b, h
	ld c, l
	jr .CheckEggFaintedFrzSlp

.OTPartyMon:
	xor a
	ret

.BoxMon:
	ld hl, sBoxMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	call AddNTimes
	ld b, h
	ld c, l
	ld a, BANK(sBoxMons)
	call GetSRAMBank
	call .CheckEggFaintedFrzSlp
	push af
	call CloseSRAM
	pop af
	ret

.Tempmon:
	ld bc, wTempMonSpecies
	jr .CheckEggFaintedFrzSlp ; utterly pointless

.CheckEggFaintedFrzSlp:
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call CheckFaintedFrzSlp
	jr c, .FaintedFrzSlp
.egg
	xor a
	scf
	ret

.Wildmon:
	ld a, $1
	and a
	ret

.FaintedFrzSlp:
	xor a
	ret

StatsScreen_LoadTextboxSpaceGFX:
	nop
	push hl
	push de
	push bc
	push af
	call DelayFrame
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a
	ld de, TextboxSpaceGFX
	lb bc, BANK(TextboxSpaceGFX), 1
	ld hl, vTiles2 tile " "
	call Get2bpp
	pop af
	ldh [rVBK], a
	pop af
	pop bc
	pop de
	pop hl
	ret

EggStatsScreen:
	xor a
	ldh [hBGMapMode], a
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call StatsScreen_PlaceHorizontalDivider
	ld de, EggString
	hlcoord 8, 1
	call PlaceString
	ld de, IDNoString
	hlcoord 8, 3
	call PlaceString
	ld de, OTString
	hlcoord 8, 5
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 5
	call PlaceString
	ld a, [wTempMonHappiness] ; egg status
	ld de, EggSoonString
	cp $6
	jr c, .picked
	ld de, EggCloseString
	cp $b
	jr c, .picked
	ld de, EggMoreTimeString
	cp $29
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 1, 9
	call PlaceString
	ld hl, wcf64
	set 5, [hl]
	call SetPalettes ; pals
	call DelayFrame
	hlcoord 0, 0
	call PrepMonFrontpic
	farcall HDMATransferTileMapToWRAMBank3
	call StatsScreen_AnimateEgg

	ld a, [wTempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	call PlaySFX
	ret

EggString:
	db "EGG@"

FiveQMarkString:
	db "?????@"

EggSoonString:
	db   "It's making sounds"
	next "inside. It's going"
	next "to hatch soon!@"

EggCloseString:
	db   "It moves around"
	next "inside sometimes."
	next "It must be close"
	next "to hatching.@"

EggMoreTimeString:
	db   "Wonder what's"
	next "inside? It needs"
	next "more time, though.@"

EggALotMoreTimeString:
	db   "This EGG needs a"
	next "lot more time to"
	next "hatch.@"

StatsScreen_AnimateEgg:
	call StatsScreen_GetAnimationParam
	ret nc
	ld a, [wTempMonHappiness]
	ld e, $7
	cp 6
	jr c, .animate
	ld e, $8
	cp 11
	jr c, .animate
	ret

.animate
	push de
	ld a, $1
	ld [wBoxAlignment], a
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	pop de
	hlcoord 0, 0
	ld d, $0
	predef LoadMonAnimation
	ld hl, wcf64
	set 6, [hl]
	ret

CopyNickname:
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	jr .okay ; utterly pointless
.okay
	ld a, [wMonType]
	cp BOXMON
	jr nz, .partymon
	ld a, BANK(sBoxMonNicknames)
	call GetSRAMBank
	push de
	call CopyBytes
	pop de
	call CloseSRAM
	ret

.partymon
	push de
	call CopyBytes
	pop de
	ret

GetNicknamePointer:
	ld a, [wMonType]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonType]
	cp TEMPMON
	ret z
	ld a, [wCurPartyMon]
	jp SkipNames

CheckFaintedFrzSlp:
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .fainted_frz_slp
	ld hl, MON_STATUS
	add hl, bc
	ld a, [hl]
	and 1 << FRZ | SLP
	jr nz, .fainted_frz_slp
	and a
	ret

.fainted_frz_slp
	scf
	ret

TypeAbbreviations:
; 5 bytes per entry ("@"-terminated), indexed by type constant
	db "NORM@" ; NORMAL
	db "FGHT@" ; FIGHTING
	db "FLYG@" ; FLYING
	db "POIS@" ; POISON
	db "GRND@" ; GROUND
	db "ROCK@" ; ROCK
	db "BIRD@" ; BIRD
	db "BUG @" ; BUG
	db "GHST@" ; GHOST
	db "STEL@" ; STEEL
	db "??? @" ; TYPE_10
	db "??? @" ; TYPE_11
	db "??? @" ; TYPE_12
	db "??? @" ; TYPE_13
	db "??? @" ; TYPE_14
	db "??? @" ; TYPE_15
	db "??? @" ; TYPE_16
	db "??? @" ; TYPE_17
	db "??? @" ; TYPE_18
	db "CURS@" ; CURSE_T
	db "FIRE@" ; FIRE
	db "WATR@" ; WATER
	db "GRAS@" ; GRASS
	db "ELEC@" ; ELECTRIC
	db "PSYC@" ; PSYCHIC
	db "ICE @" ; ICE
	db "DRGN@" ; DRAGON
	db "DARK@" ; DARK
	db "FARY@" ; FAIRY

SummaryScreenTilesGFX:
; 8 tiles, 2bpp. Color mapping (side panel palette): 0 = panel fill,
; 1 = accent (page color), 2 = white/outside, 3 = black.
; A white highlight line runs just inside the accent border to give
; the panels a glossier, less flat look.
	; $42 side panel top-left corner
	db $00, $ff
	db $0f, $f0
	db $3f, $c0
	db $7f, $80
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	; $43 side panel top edge / bottom panel top edge
	db $00, $ff
	db $ff, $00
	db $ff, $00
	db $00, $ff
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00
	; $44 side panel left edge
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	; $45 side panel bottom-left corner
	db $60, $90
	db $60, $90
	db $60, $90
	db $60, $90
	db $7f, $80
	db $3f, $c0
	db $0f, $f0
	db $00, $ff
	; $46 side panel bottom edge
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $ff
	db $ff, $00
	db $ff, $00
	db $00, $ff
	; $47 tab left corner
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $0f, $f0
	db $10, $e0
	db $20, $c0
	db $40, $80
	; $48 tab top edge
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $ff, $00
	db $00, $ff
	db $00, $00
	db $00, $00
	; $49 tab right corner
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $00, $ff
	db $f0, $0f
	db $08, $07
	db $04, $03
	db $02, $01

SummaryScreenSquareOBJGFX:
; 2 OBJ tiles: page square (unselected), page square (selected).
; Color mapping (OBJ palettes 0-3): 1 = white, 2 = page color, 3 = black.
; (OBJ tile $02 is loaded separately from PartyMenuBallGFX.)
	; tile $00: small filled square
	db $00, $00
	db $00, $7e
	db $00, $7e
	db $00, $7e
	db $00, $7e
	db $00, $7e
	db $00, $7e
	db $00, $00
	; tile $01: selected square (black outline)
	db $ff, $ff
	db $81, $ff
	db $81, $ff
	db $81, $ff
	db $81, $ff
	db $81, $ff
	db $81, $ff
	db $ff, $ff

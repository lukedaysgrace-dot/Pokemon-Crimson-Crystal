	const_def 1
	const PINK_PAGE   ; 1: overview (dex no, name, types, OT, ID) + experience
	const BLUE_PAGE   ; 2: HP + stats + ability
	const GREEN_PAGE  ; 3: moves + held item
	const ORANGE_PAGE ; 4: met info + friendship
NUM_STAT_PAGES EQU const_value + -1

; Pages now use 3 bits of wcf64 (bit 2 was previously unused).
STAT_PAGE_MASK EQU %00000111

; Gen 2 style summary screen layout:
;   rows 0-6:  pokepic (cols 0-6) + header (cols 7-19). Row 0 is a page-colored
;              strip (dex number, level, gender), rows 1-2 nickname/species,
;              rows 3-5 a per-page headline, row 6 the page selector.
;   rows 7-17: a framed box holding the page's main content, with the page
;              title in a tab on its top edge.
; Custom BG tiles (the old 2x2 page squares at $36-$3d are free here):
SUMMARY_TILE_BOX_TL   EQU $36 ; box frame (side panel palette)
SUMMARY_TILE_BOX_T    EQU $37
SUMMARY_TILE_BOX_TR   EQU $38
SUMMARY_TILE_BOX_L    EQU $39
SUMMARY_TILE_BOX_R    EQU $3a
SUMMARY_TILE_BOX_BL   EQU $3b
SUMMARY_TILE_BOX_B    EQU $3c
SUMMARY_TILE_BOX_BR   EQU $3d
SUMMARY_TILE_TAB_L    EQU $42 ; title tab caps (strip palette)
SUMMARY_TILE_TAB_R    EQU $43
SUMMARY_TILE_STRIP_L  EQU $44 ; header strip rounded left end
SUMMARY_TILE_BALL_BG  EQU $45 ; white disc behind the ball sprite
SUMMARY_TILE_DOT      EQU $46 ; dotted leader for the stat list
NUM_SUMMARY_TILES     EQU 5

; OBJ tiles (vTiles0): $00 page square, $01 selected page square,
; $02 caught ball icon (OBJ palette 4), $03 move cursor,
; $04 Pokerus symbol, $05 shiny star (both OBJ palette 5),
; $06-$09 overworld caught ball (OBJ palette 6, INFO only),
; $0a-$0d secondary type (OBJ palette 7, INFO only, two-pixel inset)

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
	jr nz, .page_transfer
	call DelayFrame
	ret

.try_anim
	farcall SetUpPokeAnim
	jr nc, .check_page
	ld hl, wcf64
	res 6, [hl]
.check_page
	ld hl, wcf64
	bit 5, [hl]
	jr nz, .page_transfer
	; A plain animation step only ever rewrites the tilemap; the anim
	; engine pushes the attribute map itself when it flips VRAM banks.
	; Each HDMA transfer costs a frame, so sending the attribute map
	; here too would make every step take two frames -- that is what
	; made the menu animation run at half the speed of the battle one.
	farcall HDMATransferTileMapToWRAMBank3
	ret

.page_transfer
	; A page (re)load changed both maps: transfer tiles and attributes
	; together so the switch lands in a single frame instead of the
	; colors changing first.
	ld hl, wcf64
	res 5, [hl]
	farcall StatsScreen_CommitPage
	xor a
	ldh [hOAMUpdate], a
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
	cp GREEN_PAGE
	jp z, StatsScreen_MoveInfo ; A on the moves page opens the move info view
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
; Load the summary tiles and compute the HP palette.
; Everything else (header included) is drawn per page.
	call LoadSummaryScreenGFX
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
	xor a
	ldh [hBGMapMode], a
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
	; Cache every category: browsing move details must not rewrite a
	; visible category graphic before its matching palette is committed.
	ld de, CategoryIconGFX
	ld hl, vTiles2 tile $5d
	lb bc, BANK(CategoryIconGFX), 2
	call Get2bpp
	ld de, CategoryIconGFX + 2 tiles
	ld hl, vTiles2 tile $79
	lb bc, BANK(CategoryIconGFX), 2
	call Get2bpp
	ld de, CategoryIconGFX + 4 tiles
	ld hl, vTiles2 tile $7d
	lb bc, BANK(CategoryIconGFX), 2
	call Get2bpp
	ld de, SummaryFrameTilesGFX
	ld hl, vTiles2 tile SUMMARY_TILE_BOX_TL
	lb bc, BANK(SummaryFrameTilesGFX), 8
	call Get2bpp
	ld de, SummaryScreenTilesGFX
	ld hl, vTiles2 tile SUMMARY_TILE_TAB_L
	lb bc, BANK(SummaryScreenTilesGFX), NUM_SUMMARY_TILES
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
	; selection arrow for the move info view
	ld de, StatsScreenArrowGFX
	ld hl, vTiles0 tile $03
	lb bc, BANK(StatsScreenArrowGFX), 1
	call Get1bpp
	; Pokerus (color 1) and the battle shiny star (color 2) are sprites
	; sharing OBJ palette 5, so the header shows them on every page.
	ld de, StatsScreenPokerusOBJGFX
	ld hl, vTiles0 tile $04
	lb bc, BANK(StatsScreenPokerusOBJGFX), 1
	call Get2bpp
	ld de, ShinyStarGFX
	ld hl, vTiles0 tile $05
	lb bc, BANK(ShinyStarGFX), 1
	call Get2bpp
	; Full overworld item-ball sprite for the INFO header.
	ld de, PokeBallSpriteGFX
	ld hl, vTiles0 tile $06
	lb bc, BANK(PokeBallSpriteGFX), 4
	call Get2bpp
	ret

StatsScreenArrowGFX:
; 8x8 1bpp "▶" cursor for the move info view
	db %00000000
	db %01000000
	db %01100000
	db %01111000
	db %01111110
	db %01111000
	db %01100000
	db %01000000

StatsScreen_LoadGFX:
	ld a, 1
	ldh [hOAMUpdate], a ; selector sprites belong to the pending page
	ld a, [wBaseSpecies]
	ld [wTempSpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	xor a
	ldh [hBGMapMode], a
	; everything but the pokepic
	hlcoord 7, 0
	lb bc, 7, 13
	call ClearBox
	hlcoord 0, 7
	lb bc, 11, 20
	call ClearBox
	call StatsScreen_DrawFrames
	call .PageTilemap
	call .LoadPals
	ld hl, wcf64
	bit 4, [hl]
	jr nz, .place_frontpic
	; the page squares and ball are OAM sprites, so they show up the
	; moment they're written: place them last, right before the page's
	; tile transfer, so the whole screen appears at once
	call StatsScreen_PlacePageSquares
	ret

.place_frontpic
	call StatsScreen_PlaceFrontpic
	call StatsScreen_PlacePageSquares
	ret

.LoadPals:
	ld a, [wcf64]
	and STAT_PAGE_MASK
	ld c, a
	farcall LoadSummaryScreenPals
	; The commit uploads palettes, both maps and OAM in one VBlank.
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
; Draw the shared header (strip, nickname, species, page arrows)
; and the content box frame.
	; header strip: rounded left end, then dex number / level / gender
	hlcoord 7, 0
	ld [hl], SUMMARY_TILE_STRIP_L
	; dex number: the regional (Pokedex) number, same as the Pokedex shows
	ld a, [wBaseSpecies]
	ld [wCurSpecies], a
	call GetPokemonIndexFromID
	; farcall clobbers hl, so pass the species index in de
	ld d, h
	ld e, l
	farcall GetRegionalDexNumber_DE
	ld a, h
	ld h, l
	ld l, a
	push hl
	ld hl, sp + 0
	ld d, h
	ld e, l
	hlcoord 8, 0
	ld a, "№"
	ld [hli], a
	ld a, "."
	ld [hli], a
	lb bc, PRINTNUM_LEADINGZEROS | 2, 3
	call PrintNum
	add sp, 2
	hlcoord 14, 0
	call PrintLevel
	hlcoord 18, 0
	call StatsScreen_PlaceGenderChar

	; nickname
	ld hl, StatsScreen_NicknamePointers
	call GetNicknamePointer
	call CopyNickname
	hlcoord 8, 1
	call PlaceString

	; species
	hlcoord 9, 2
	ld a, "/"
	ld [hli], a
	ld a, [wBaseSpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	call PlaceString

	; page switch arrows around the page squares
	hlcoord 10, 6
	ld [hl], "◀"
	hlcoord 19, 6
	ld [hl], "▶"

	; fallthrough

StatsScreen_DrawBox:
; Draw the content box frame (rows 7-17).
	hlcoord 0, 7
	lb de, SUMMARY_TILE_BOX_TL, SUMMARY_TILE_BOX_T
	ld c, SUMMARY_TILE_BOX_TR
	call .Row
	hlcoord 0, 8
	ld b, 9
.sides
	ld [hl], SUMMARY_TILE_BOX_L
	push bc
	ld bc, SCREEN_WIDTH - 1
	add hl, bc
	ld [hl], SUMMARY_TILE_BOX_R
	inc hl
	pop bc
	dec b
	jr nz, .sides
	lb de, SUMMARY_TILE_BOX_BL, SUMMARY_TILE_BOX_B
	ld c, SUMMARY_TILE_BOX_BR
	; fallthrough

.Row:
; hl = row start; d = left corner, e = edge, c = right corner
	ld [hl], d
	inc hl
	ld a, e
	ld b, SCREEN_WIDTH - 2
.row_loop
	ld [hli], a
	dec b
	jr nz, .row_loop
	ld [hl], c
	ret

StatsScreen_NicknamePointers:
	dw wPartyMonNicknames
	dw wOTPartyMonNicknames
	dw wTempMonNickname
	dw wBufferMonNick

DrawSummaryTab:
; Draw the page title tab on the box's top edge. de = label string.
	hlcoord 1, 7
	ld [hl], SUMMARY_TILE_TAB_L
	hlcoord 2, 7
	call PlaceString
	ld h, b
	ld l, c
	ld [hl], SUMMARY_TILE_TAB_R
	ret

StatsScreen_PlaceHeaderLabel:
; Place the page headline label (de) at the top of the header.
	hlcoord 8, 3
	jp PlaceString

StatsScreen_PlacePageSquares:
; Place the four page squares as OAM sprites in the header's selector row,
; between the page arrows.
	ld a, [wcf64]
	and STAT_PAGE_MASK
	ld d, a
	ld hl, wVirtualOAM
	ld b, 1   ; page counter
	ld c, 100 ; x of first square
.loop
	ld a, 64 ; y (row 6)
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

	; The old nickname ball is no longer displayed.
	ld hl, wVirtualOAMSprite04
	call .HideSprite

	; sprite 5 is the move info cursor; sprites 6-7: Pokerus and shiny,
	; tucked into the header's right edge
	ld hl, wVirtualOAMSprite06
	ld a, [wTempMonPokerusStatus]
	and $0f
	lb de, 56, 152 ; (18, 5)
	ld a, $04
	call nz, .PlaceSprite
	call z, .HideSprite
	ld bc, wTempMonDVs
	farcall CheckShininess
	ld hl, wVirtualOAMSprite07
	lb de, 56, 160 ; (19, 5)
	ld a, $05
	call c, .PlaceSprite
	call nc, .HideSprite

	call .PlaceInfoBall
	call .PlaceSecondaryType
	; sprite 8: the small ball beside the ball name on the memo page
	ld hl, wVirtualOAMSprite08
	ld a, [wcf64]
	and STAT_PAGE_MASK
	cp ORANGE_PAGE
	jr nz, .HideSprite
	lb de, 96, 62 ; y, x: (7, 10), nudged left onto its white disc
	ld a, $02
	call .PlaceSprite
	ld a, 4
	ld [hl], a
	ret

.PlaceInfoBall:
	ld hl, wVirtualOAMSprite09
	ld a, [wcf64]
	and STAT_PAGE_MASK
	cp PINK_PAGE
	jr z, .info_ball
	; Clear all four pieces when leaving INFO or browsing another mon.
	ld bc, 4 * 4
	xor a
	jp ByteFill
.info_ball
	ld de, wVirtualOAMSprite09
	ld hl, .InfoBallOAM
	ld bc, 4 * 4
	jp CopyBytes

.InfoBallOAM:
	; y, x, tile, palette: 16x16 ball right of the INFO type bars
	db 40, 134, $06, 6
	db 40, 142, $07, 6
	db 48, 134, $08, 6
	db 48, 142, $09, 6

.PlaceSecondaryType:
	ld hl, wVirtualOAMSprite13
	ld a, [wcf64]
	and STAT_PAGE_MASK
	cp PINK_PAGE
	jr nz, .hide_secondary_type
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	jr z, .hide_secondary_type
	ld hl, .SecondaryTypeOAM
	ld de, wVirtualOAMSprite13
	ld bc, 4 * 4
	jp CopyBytes
.hide_secondary_type
	ld bc, 4 * 4
	xor a
	jp ByteFill

.SecondaryTypeOAM:
	; Keep the primary at x64; place the secondary at x94, not x96.
	db 48, 102, $0a, 7
	db 48, 110, $0b, 7
	db 48, 118, $0c, 7
	db 48, 126, $0d, 7

.PlaceSprite:
; place tile a at y d, x e with OBJ palette 5; hl -> attributes byte
	push af
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	pop af
	ld [hli], a
	ld a, 5
	ld [hl], a
	ret ; flags are preserved for the conditional calls

.HideSprite:
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatsScreen_LoadTypeIcon:
; Load a four-tile type pill into slot c (0-1 INFO, 2-5 MOVES).
; INFO and MOVES share slots: they are never adjacent pages. Only INFO
; restores EXP graphics, while a STATS or MEMO page is still visible.
; Returns the first BG tile id in a, except INFO's secondary OBJ slot.
	push bc
	ld hl, SummaryTypeIconGFX
	ld bc, 4 tiles
	call AddNTimes
	ld d, h
	ld e, l
	pop bc
	ld a, c
	cp 1
	jr nz, .bg_type
	; INFO's secondary is an OBJ so it can move by two pixels rather
	; than a whole BG cell. Other type pills keep their ordinary slots.
	ld hl, vTiles0 tile $0a
	lb bc, BANK(SummaryTypeIconGFX), 4
	jp Get2bpp_2
.bg_type
	ld a, c
	call StatsScreen_TypeIconTile
	push af
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; x16 (tile size)
	ld bc, vTiles2
	add hl, bc
	lb bc, BANK(SummaryTypeIconGFX), 4
	call Get2bpp_2
	pop af
	ret

StatsScreen_TypeIconTile:
	push hl
	push de
	ld e, a
	ld d, 0
	ld hl, .Tiles
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret
.Tiles:
	db $4b, $4f ; INFO: species types
	db $4b, $4f, $53, $57 ; MOVES: types (overlap EXP, restored only on INFO)

StatsScreen_PlaceTypeIcon:
; Write tile ids a, a+1, a+2, a+3 at hl.
	ld b, 4
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
	ret

StatsScreen_GetMoveDisplayType:
; Return the display type (in a) for the move struct in wStringBuffer2.
; Hidden Power shows this mon's own type (its HiddenPowerType byte).
; Clobbers bc, de.
	ld a, [wStringBuffer2 + MOVE_EFFECT]
	cp EFFECT_HIDDEN_POWER
	ld a, [wStringBuffer2 + MOVE_TYPE]
	ret nz
	ld de, wTempMonHiddenPowerType
	ld bc, wTempMonAttack
	farcall GetHiddenPowerDisplayStats ; c = type
	ld a, c
	ret

; ================================
; Pink page: overview + experience
; ================================

StatsScreen_PinkPage:
	; MOVES borrows the EXP tiles. Restore them only when entering INFO:
	; neither adjacent page uses them, so no visible graphic can change.
	ld de, ExpBarGFX
	ld hl, vTiles2 tile $55
	lb bc, BANK(ExpBarGFX), 8
	call Get2bpp_2
	ld de, .TabString
	call DrawSummaryTab

	; --- header: type pills ---
	ld a, [wBaseType1]
	ld c, 0
	call StatsScreen_LoadTypeIcon
	hlcoord 8, 4
	call StatsScreen_PlaceTypeIcon
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	jr z, .one_type
	ld c, 1
	call StatsScreen_LoadTypeIcon
.one_type

	; --- box: trainer info ---
	ld de, OTString
	hlcoord 1, 9
	call PlaceString
	ld hl, .OTNamePointers
	call GetNicknamePointer
	call CopyNickname
	farcall CorrectNickErrors
	hlcoord 4, 9
	call PlaceString

	ld de, IDNoString
	hlcoord 1, 10
	call PlaceString
	hlcoord 4, 10
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	ld de, wTempMonID
	call PrintNum

	; --- box: experience ---
; Everything below works off the level, and a level below MIN_LEVEL makes both
; CalcExpToNextLevel and the exp bar operate on a negative exp span, which locks
; the screen up with the music still running. wTempMon is a working copy, so
; clamping here is display-only and can't corrupt the real party entry.
	ld a, [wTempMonLevel]
	cp MIN_LEVEL
	jr nc, .exp_level_okay
	ld a, MIN_LEVEL
	ld [wTempMonLevel], a
.exp_level_okay
	ld de, .ExpPointStr
	hlcoord 1, 12
	call PlaceString
	hlcoord 12, 12
	lb bc, 3, 7
	ld de, wTempMonExp
	call PrintNum
	call .CalcExpToNextLevel
	ld de, .LevelUpStr
	hlcoord 1, 13
	call PlaceString
	hlcoord 12, 13
	lb bc, 3, 7
	ld de, wBuffer1
	call PrintNum
	ld de, .ToStr
	hlcoord 13, 15
	call PlaceString
	hlcoord 16, 15
	call .PrintNextLevel
	; the original exp bar
	hlcoord 2, 15
	ld a, [wTempMonLevel]
	ld b, a
	ld de, wTempMonExp + 2
	predef FillInExpBar
	hlcoord 1, 15
	ld [hl], $40 ; left exp bar end cap
	hlcoord 10, 15
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
	ret nc
	; An inconsistent level/EXP pair must not wrap into an eight-digit value:
	; PrintNum supports seven digits and would render a non-digit tile.

.AlreadyAtMaxLevel:
	ld hl, wBuffer1
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.OTNamePointers:
	dw wPartyMonOT
	dw wOTPartyMonOT
	dw wTempMonOT
	dw wBufferMonOT

.TabString:
	db "INFO@"

.ExpPointStr:
	db "EXP POINTS@"

.LevelUpStr:
	db "LEVEL UP@"

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
	ld de, .TabString
	call DrawSummaryTab

	; --- header: status + the original HP bar ---
	ld de, .StatusStr
	call StatsScreen_PlaceHeaderLabel
	; stored mons have no status (and read as 0 HP)
	ld a, [wMonType]
	cp BOXMON
	jr z, .status_ok
	hlcoord 15, 3
	ld de, wTempMonStatus
	predef PlaceStatusString
	jr nz, .status_done
.status_ok
	ld de, .OKStr
	hlcoord 15, 3
	call PlaceString
.status_done
	hlcoord 8, 4
	ld b, $0
	predef DrawPlayerHP

	; --- box: stats, with dotted leaders out to the values ---
	ld de, .AttackStr
	hlcoord 1, 8
	call .StatLabel
	ld de, .DefenseStr
	hlcoord 1, 9
	call .StatLabel
	ld de, .SpclAtkStr
	hlcoord 1, 10
	call .StatLabel
	ld de, .SpclDefStr
	hlcoord 1, 11
	call .StatLabel
	ld de, .SpeedStr
	hlcoord 1, 12
	call .StatLabel

	ld de, wTempMonAttack
	hlcoord 16, 8
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonDefense
	hlcoord 16, 9
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpclAtk
	hlcoord 16, 10
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpclDef
	hlcoord 16, 11
	lb bc, 2, 3
	call PrintNum
	ld de, wTempMonSpeed
	hlcoord 16, 12
	lb bc, 2, 3
	call PrintNum

	; --- box: ability ---
	ld a, [wTempMonPersonality]
	ld b, a
	ld a, [wTempMonSpecies]
	ld c, a
	call GetAbility
	farcall ZeroAbilityIfDisabled
	push bc
	farcall GetAbilityName
	ld de, wStringBuffer1
	hlcoord 1, 14
	call PlaceString
	; ability slot indicator (none when abilities are turned off)
	pop bc
	push bc
	ld a, b
	and a ; NO_ABILITY?
	jr z, .slot_done
	ld a, [wTempMonPersonality]
	and ABILITY_MASK
	cp ABILITY_3
	ld b, "3"
	jr z, .got_slot
	cp ABILITY_2
	ld b, "2"
	jr z, .got_slot
	ld b, "1"
.got_slot
	ld a, b
	hlcoord 18, 14
	ld [hl], a
.slot_done
	pop bc
	; note: farcall clobbers hl, so the coords are passed in de
	decoord 1, 15
	farcall PrintAbilityDescriptionStats
	ret

.StatLabel:
; Dots from hl to the value column, then the label (de) over them.
	push hl
	ld a, SUMMARY_TILE_DOT
	ld b, 15
.dots
	ld [hli], a
	dec b
	jr nz, .dots
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld [hl], " "
	ret

.TabString:
	db "STATS@"

.StatusStr:
	db "STATUS/@"

.OKStr:
	db "OK@"

.AttackStr:
	db "ATTACK@"

.DefenseStr:
	db "DEFENSE@"

.SpclAtkStr:
	db "SPCL.ATK@"

.SpclDefStr:
	db "SPCL.DEF@"

.SpeedStr:
	db "SPEED@"

; ==============================
; Green page: moves + held item
; ==============================

StatsScreen_GreenPage:
	ld de, .TabString
	call DrawSummaryTab

	; --- header: held item ---
	ld de, .ItemStr
	call StatsScreen_PlaceHeaderLabel
	call StatsScreen_GetHeldItemName
	hlcoord 8, 4
	call PlaceString

	; --- box: moves ---
	; Load every move's type pill into its icon slot up front, so the
	; move loop below only writes tile ids.
	call .LoadMoveTypeIcons

	ld c, 0
.move_loop
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	and a
	ret z
	push bc
	; move name on row 8 + 2 * slot
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	pop bc
	push bc
	ld a, c
	add a
	add 8
	call .RowCoord
	call PlaceString
	; info row below the name: type pill (already loaded into the slot's
	; icon tiles by .LoadMoveTypeIcons) and PP
	pop bc
	push bc
	ld a, c
	add a
	add 9
	call .RowCoord
	ld a, c
	add 2
	call StatsScreen_TypeIconTile
	call StatsScreen_PlaceTypeIcon
	ld de, 6
	add hl, de
	ld a, $3e ; "PP" tiles
	ld [hli], a
	ld [hl], a
	; max PP (GetMaxPPOfMove reads the move index from wMenuCursorY)
	pop bc
	push bc
	ld a, [wMenuCursorY]
	push af
	ld a, c
	ld [wMenuCursorY], a
	farcall GetMaxPPOfMove
	pop af
	ld [wMenuCursorY], a
	; current PP
	pop bc
	push bc
	ld b, 0
	ld hl, wTempMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStringBuffer1 + 4], a
	; print cur/max, right-aligned against the box edge
	ld a, c
	add a
	add 9
	call .RowCoord
	ld de, 12
	add hl, de
	ld de, wStringBuffer1 + 4
	lb bc, 1, 2
	call PrintNum
	ld a, "/"
	ld [hli], a
	ld de, wTempPP
	lb bc, 1, 2
	call PrintNum
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .move_loop
	ret

.LoadMoveTypeIcons:
; Copy each known move's type pill into slots 2-5. Neither adjacent
; page uses these tiles. No registers are live across the calls.
	ld c, 0
.icon_loop
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	and a
	ret z
	push bc
	ld de, wStringBuffer2
	call GetMoveData
	call StatsScreen_GetMoveDisplayType
	pop bc
	push bc
	inc c
	inc c
	call StatsScreen_LoadTypeIcon
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .icon_loop
	ret

.RowCoord:
; hl = wTileMap + row a * SCREEN_WIDTH + column 2
; (keep in sync with LoadSummaryScreenPals.GreenSetup)
	push de
	ld l, a
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de ; x5
	add hl, hl
	add hl, hl ; x20
	ld de, wTileMap + 2
	add hl, de
	pop de
	ret

.TabString:
	db "MOVES@"

.ItemStr:
	db "ITEM/@"

StatsScreen_GetHeldItemName:
; de = held item name, or "No held item"
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

.NoItemString:
	db "No held item@"

StatsScreen_FillAttr:
; Fill a b x c box of the attribute map at hl with a.
	ld de, SCREEN_WIDTH
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .row
	ret

; =====================================================
; Move info view (A on the green page)
; =====================================================

StatsScreen_MoveInfo:
; Up/Down selects a move; the lower half of the box shows its category,
; type, power, accuracy and description. A or B returns to the moves list.
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	xor a
	ld [wMenuCursorY], a
	call .ShowMoveInfo
.loop
	call StatsScreen_WaitAnim
	call GetJoypad
	ldh a, [hJoyPressed]
	bit B_BUTTON_F, a
	jr nz, .exit
	bit A_BUTTON_F, a
	jr nz, .exit
	bit D_UP_F, a
	jr nz, .up
	bit D_DOWN_F, a
	jr nz, .down
	jr .loop

.up
	ld a, [wMenuCursorY]
	and a
	jr nz, .up_ok
	call .CountMoves
.up_ok
	dec a
	jr .set_cursor

.down
	call .CountMoves
	ld b, a
	ld a, [wMenuCursorY]
	inc a
	cp b
	jr c, .set_cursor
	xor a
.set_cursor
	ld [wMenuCursorY], a
	call .ShowMoveInfo
	jr .loop

.exit
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	; hide the selection arrow
	ld hl, wVirtualOAMSprite05
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	; redraw the moves page (tiles, attributes and palettes together)
	ld h, 4
	jp StatsScreen_SetJumptableIndex

.CountMoves:
; a = number of known moves (1-4); clobbers b, hl
	ld hl, wTempMonMoves
	ld b, 0
.count_loop
	ld a, [hli]
	and a
	jr z, .counted
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .count_loop
.counted
	ld a, b
	ret

.ShowMoveInfo:
	ld a, 1
	ldh [hOAMUpdate], a ; keep the old cursor until the page commit
	; clear the box interior back to plain box colors
	hlcoord 1, 8
	lb bc, 9, 18
	call ClearBox
	hlcoord 1, 8, wAttrMap
	lb bc, 9, 18
	ld a, $3
	call StatsScreen_FillAttr
	; compact move list on rows 8-11
	ld c, 0
.name_loop
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	and a
	jr z, .names_done
	push bc
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	pop bc
	push bc
	ld a, c
	add 8
	call StatsScreen_GreenPage.RowCoord
	call PlaceString
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .name_loop
.names_done
	; selection arrow (OAM sprite 5) left of the selected name
	ld a, [wMenuCursorY]
	add a
	add a
	add a
	add 80 ; first name row is tilemap row 8
	ld hl, wVirtualOAMSprite05
	ld [hli], a ; y
	ld a, 16 ; x: column 1
	ld [hli], a
	ld a, $03 ; arrow tile
	ld [hli], a
	xor a ; OBJ palette 0 (black at color 3)
	ld [hl], a
	; fetch the selected move
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	ld hl, wTempMonMoves
	add hl, bc
	ld a, [hl]
	push af
	ld de, wStringBuffer2
	call GetMoveData
	; Hidden Power shows this mon's own type, its fixed power, and the
	; category its (unboosted) stats would give it right now.
	ld a, [wStringBuffer2 + MOVE_EFFECT]
	cp EFFECT_HIDDEN_POWER
	jr nz, .got_move_data
	ld de, wTempMonHiddenPowerType
	ld bc, wTempMonAttack
	farcall GetHiddenPowerDisplayStats ; b = category, c = type, d = power
	ld a, b
	ld [wStringBuffer2 + MOVE_CATEGORY], a
	ld a, c
	ld [wStringBuffer2 + MOVE_TYPE], a
	ld a, d
	ld [wStringBuffer2 + MOVE_POWER], a
.got_move_data
	; Category and type palettes both use the green box background.
	farcall LoadStatsMoveInfoPals
	ld a, [wStringBuffer2 + MOVE_CATEGORY]
	ld e, a
	ld d, 0
	ld hl, .CategoryTiles
	add hl, de
	ld a, [hl]
	hlcoord 1, 13
	ld [hli], a
	inc a
	ld [hl], a
	hlcoord 1, 13, wAttrMap
	ld a, 7 ; category palette, matching the box fill
	ld [hli], a
	ld [hl], a
	; move details rebuild the selected type in palette 6
	ld a, [wMenuCursorY]
	ld c, a
	ld a, 6
	hlcoord 4, 13, wAttrMap
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, c
	add 2
	call StatsScreen_TypeIconTile
	hlcoord 4, 13
	call StatsScreen_PlaceTypeIcon
	; power / accuracy line
	hlcoord 9, 13
	ld de, .PowAccString
	call PlaceString
	; display power
	ld a, [wStringBuffer2 + MOVE_POWER]
	hlcoord 9, 13
	cp 2
	jr c, .no_power
	ld [wStringBuffer1], a
	ld de, wStringBuffer1
	lb bc, 1, 3
	call PrintNum
	jr .accuracy
.no_power
	ld de, .NAString
	call PlaceString
.accuracy
	; accuracy is stored 0-255 "percent"-scaled; convert to 0-100
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wStringBuffer2 + MOVE_ACC]
	ldh [hMultiplicand + 2], a
	ld a, 100
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 3]
	add 128 ; round to nearest
	ld d, a
	ldh a, [hProduct + 2]
	adc 0
	ldh [hDividend + 0], a
	ld a, d
	ldh [hDividend + 1], a
	ld a, 255
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld [wStringBuffer1], a
	hlcoord 14, 13
	ld de, wStringBuffer1
	lb bc, 1, 3
	call PrintNum
	; description
	pop af
	ld [wCurSpecies], a
	hlcoord 1, 14
	predef PrintMoveDesc
	ld a, [wBaseSpecies]
	ld [wCurSpecies], a
	; push the redraw (tiles + attributes) on the next frame
	ld hl, wcf64
	set 5, [hl]
	ret

.PowAccString:
	db "   <BOLD_P>/   <PCT>@"
.CategoryTiles:
	db $5d, $79, $7d
.NAString:
	db "---@"

; ====================================
; Orange page: met info + friendship
; ====================================

StatsScreen_OrangePage:
	ld de, .TabString
	call DrawSummaryTab

	; --- header: friendship ---
	ld de, .FriendStr
	call StatsScreen_PlaceHeaderLabel
	hlcoord 8, 4
	ld [hl], $34 ; heart icon
	hlcoord 10, 4
	lb bc, 1, 3
	ld de, wTempMonHappiness
	call PrintNum
	ld de, .OutOf255Str
	hlcoord 13, 4
	call PlaceString
	; friendship meter, original HP/exp bar style
	hlcoord 8, 5
	ld [hl], $40 ; left end cap
	hlcoord 15, 5
	ld [hl], $41 ; right end cap
	ld a, [wTempMonHappiness]
	ld c, a
	ld b, 0
	ld d, 0
	ld e, 255
	farcall ComputeHPBarPixels
	hlcoord 9, 5
	call .DrawFriendshipBar

	; --- box: where it was met ---
	; (landmark names are at most 16 characters, so they fit on one row;
	; a soft linebreak prints as a space)
	ld a, [wTempMonCaughtLocation]
	and CAUGHT_LOCATION_MASK
	cp GIFT_LOCATION
	jr z, .gift
	and a
	jr z, .unknown_loc
	ld e, a
	farcall GetLandmarkName
	ld de, wStringBuffer1
	hlcoord 1, 8
	call PlaceString
	jr .loc_done
.gift
	ld de, .ReceivedStr
	hlcoord 1, 8
	call PlaceString
	ld de, .AsGiftStr
	hlcoord 13, 8
	call PlaceString
	jr .loc_done
.unknown_loc
	ld de, .FarawayStr
	hlcoord 1, 8
	call PlaceString
	ld de, .PlaceStr
	hlcoord 9, 8
	call PlaceString
.loc_done

	; caught level
	ld a, [wTempMonCaughtLevel]
	and CAUGHT_LEVEL_MASK
	jr z, .level_done
	cp CAUGHT_EGG_LEVEL
	jr z, .hatched
	ld de, .MetAtStr
	hlcoord 1, 9
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
	hlcoord 1, 9
	call PlaceString
.level_done

	; caught ball (the icon at (7, 10) is an OAM sprite; see
	; StatsScreen_PlacePageSquares)
	ld de, .BallUsedStr
	hlcoord 1, 10
	call PlaceString
	; white backing for the ball sprite
	hlcoord 7, 10
	ld [hl], SUMMARY_TILE_BALL_BG
	ld a, [wTempMonPersonality]
	and CAUGHT_BALL_MASK
	; must be a plain call: farcall would clobber a (the ball index),
	; which made every mon read as caught in a Poke Ball
	call GetCaughtBallItem
	ld a, c
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	hlcoord 8, 10
	call PlaceString

	; --- box: held item + description ---
	ld de, StatsScreen_GreenPage.ItemStr
	hlcoord 1, 12
	call PlaceString
	call StatsScreen_GetHeldItemName
	hlcoord 6, 12
	call PlaceString
	ld a, [wTempMonItem]
	and a
	ret z
	ld [wCurSpecies], a
	decoord 1, 13
	farcall PrintItemDescription
	ld a, [wBaseSpecies]
	ld [wCurSpecies], a
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

.TabString:
	db "MEMO@"

.FriendStr:
	db "FRIENDSHIP@"

.MetAtStr:
	db "MET AT @"

.HatchedStr:
	db "HATCHED FROM EGG@"

.BallUsedStr:
	db "BALL/@"

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
	; stored mons are decoded into wTempMon by the storage backend
	ld bc, wTempMonSpecies
	jr .CheckEggFaintedFrzSlp

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
	call LoadSummaryScreenGFX
	; header: a blank strip, then the egg's "identity"
	hlcoord 7, 0
	ld [hl], SUMMARY_TILE_STRIP_L
	ld de, .DexStr
	hlcoord 8, 0
	call PlaceString
	ld de, EggString
	hlcoord 8, 1
	call PlaceString
	ld de, IDNoString
	hlcoord 8, 3
	call PlaceString
	ld de, OTString
	hlcoord 8, 4
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 4
	call PlaceString
	; box: how close it is to hatching
	call StatsScreen_DrawBox
	ld de, .TabString
	call DrawSummaryTab
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
	ld c, 0 ; egg colors, no page extras
	farcall LoadSummaryScreenPals
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

.TabString:
	db "STATUS@"

.DexStr:
	db "№.???@"

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
	cp BOXMON
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

SummaryFrameTilesGFX:
; 8 tiles, 2bpp, side panel palette: 0 = box fill, 1 = page accent,
; 2 = white, 3 = black. A rounded black/accent/black band.
	; top-left
	db $00, $ff ; WWWWWWWW
	db $1f, $ff ; WWWKKKKK
	db $3f, $e0 ; WWKAAAAA
	db $7f, $c0 ; WKAAAAAA
	db $7f, $cf ; WKAAKKKK
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	; top
	db $00, $ff ; WWWWWWWW
	db $ff, $ff ; KKKKKKKK
	db $ff, $00 ; AAAAAAAA
	db $ff, $00 ; AAAAAAAA
	db $ff, $ff ; KKKKKKKK
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	; top-right
	db $00, $ff ; WWWWWWWW
	db $f8, $ff ; KKKKKWWW
	db $fc, $07 ; AAAAAKWW
	db $fe, $03 ; AAAAAAKW
	db $fe, $f3 ; KKKKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	; left
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	; right
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	; bottom-left
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $78, $c8 ; WKAAKTTT
	db $7f, $cf ; WKAAKKKK
	db $7f, $c0 ; WKAAAAAA
	db $3f, $e0 ; WWKAAAAA
	db $1f, $ff ; WWWKKKKK
	db $00, $ff ; WWWWWWWW
	; bottom
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $ff, $ff ; KKKKKKKK
	db $ff, $00 ; AAAAAAAA
	db $ff, $00 ; AAAAAAAA
	db $ff, $ff ; KKKKKKKK
	db $00, $ff ; WWWWWWWW
	; bottom-right
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $1e, $13 ; TTTKAAKW
	db $fe, $f3 ; KKKKAAKW
	db $fe, $03 ; AAAAAAKW
	db $fc, $07 ; AAAAAKWW
	db $f8, $ff ; KKKKKWWW
	db $00, $ff ; WWWWWWWW

SummaryScreenTilesGFX:
; NUM_SUMMARY_TILES tiles, 2bpp.
; Strip palette (0 = accent, 1 = black, 2 = box fill, 3 = white):
	; SUMMARY_TILE_TAB_L: title tab left cap
	db $f8, $f8 ; WWWWWAAA
	db $f0, $00 ; KKKKAAAA
	db $00, $00 ; AAAAAAAA
	db $00, $00 ; AAAAAAAA
	db $f0, $00 ; KKKKAAAA
	db $00, $f0 ; TTTTAAAA
	db $00, $f8 ; TTTTTAAA
	db $00, $fc ; TTTTTTAA
	; SUMMARY_TILE_TAB_R: title tab right cap
	db $1f, $1f ; AAAWWWWW
	db $0f, $00 ; AAAAKKKK
	db $00, $00 ; AAAAAAAA
	db $00, $00 ; AAAAAAAA
	db $0f, $00 ; AAAAKKKK
	db $00, $0f ; AAAATTTT
	db $00, $1f ; AAATTTTT
	db $00, $3f ; AATTTTTT
	; SUMMARY_TILE_STRIP_L: header strip left end
	db $f0, $f0 ; WWWWAAAA
	db $c0, $c0 ; WWAAAAAA
	db $80, $80 ; WAAAAAAA
	db $80, $80 ; WAAAAAAA
	db $80, $80 ; WAAAAAAA
	db $80, $80 ; WAAAAAAA
	db $80, $80 ; WAAAAAAA
	db $c0, $c0 ; WWAAAAAA
; Side panel palette:
	; SUMMARY_TILE_BALL_BG: white disc behind the ball sprite (color 2),
	; kept inside the ball outline so no white peeks out around it
	db $00, $00
	db $00, $78
	db $00, $fc
	db $00, $fc
	db $00, $fc
	db $00, $78
	db $00, $00
	db $00, $00
	; SUMMARY_TILE_DOT: stat leader dot (accent)
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT
	db $18, $00 ; TTTAATTT
	db $18, $00 ; TTTAATTT
	db $00, $00 ; TTTTTTTT
	db $00, $00 ; TTTTTTTT

StatsScreenPokerusOBJGFX:
; Bill's PC infected Pokerus symbol in color 1, so it can share OBJ palette 5
; with the shiny star (color 2).
	db $00, $00
	db $bd, $00
	db $5a, $00
	db $5a, $00
	db $7e, $00
	db $66, $00
	db $bd, $00
	db $00, $00

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

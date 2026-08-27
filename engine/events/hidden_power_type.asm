HiddenPowerSelectMon:
; Hidden Power Guy, step 1: pick the party Pokémon whose Hidden Power he
; will reshape (each Pokémon keeps its own type in its HiddenPowerType byte).
; wScriptVar: 0 = cancelled, 1 = chosen (wCurPartyMon), 2 = it is an Egg.
; On success wStringBuffer3 holds its nickname and wStringBuffer4 the name
; of its current Hidden Power type (both for text_ram).
	farcall SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call .CopyNickToBuffer3
	; current type name -> wStringBuffer4
	ld a, MON_HIDDEN_POWER_TYPE
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr nz, .got_type
	ld a, HIDDEN_POWER_DEFAULT_TYPE
.got_type
	call .CopyTypeNameToBuffer4
	ld a, 1
	ld [wScriptVar], a
	ret

.egg
	ld a, 2
	ld [wScriptVar], a
	ret

.cancel
	xor a
	ld [wScriptVar], a
	ret

.CopyNickToBuffer3:
	call GetCurNick ; -> wStringBuffer1
	ld hl, wStringBuffer1
	ld de, wStringBuffer3
	ld bc, MON_NAME_LENGTH
	jp CopyBytes

.CopyTypeNameToBuffer4:
; a = type
	ld [wNamedObjectIndexBuffer], a
	predef GetTypeName ; -> wStringBuffer1
	ld hl, wStringBuffer1
	ld de, wStringBuffer4
	ld bc, MOVE_NAME_LENGTH
	jp CopyBytes

HiddenPowerTypeMenu:
; Hidden Power Guy, step 2: let the player pick the new type for the
; Pokémon chosen by HiddenPowerSelectMon (wCurPartyMon). The category is
; never chosen here - in battle Hidden Power always uses whichever of the
; user's Attack / Sp.Atk is currently higher.
; On success: stores the type in that Pokémon's HiddenPowerType byte only,
; leaves its nickname in wStringBuffer3 and the type name in wStringBuffer4
; (both for text_ram), and sets wScriptVar to TRUE. On cancel (B), sets
; wScriptVar to FALSE and changes nothing.

	ld hl, .TypeList
	ld de, wStringBuffer2
	ld bc, .TypeListEnd - .TypeList
	call CopyBytes

	call LoadStandardMenuHeader
	ld hl, .TypeMenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	call UpdateSprites
	xor a
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	call CloseWindow
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .cancel

; Type chosen: store it on this Pokémon only.
	ld a, [wMenuSelection]
	push af
	ld a, MON_HIDDEN_POWER_TYPE
	call GetPartyParamLocation
	pop af
	ld [hl], a
	call HiddenPowerSelectMon.CopyTypeNameToBuffer4
	call HiddenPowerSelectMon.CopyNickToBuffer3
	ld a, TRUE
	ld [wScriptVar], a
	ret

.cancel
	xor a ; FALSE
	ld [wScriptVar], a
	ret

.TypeList:
	db .TypeListRowsEnd - .TypeListRows ; number of items
.TypeListRows:
	db FIGHTING
	db FLYING
	db POISON
	db GROUND
	db ROCK
	db BUG
	db GHOST
	db STEEL
	db FIRE
	db WATER
	db GRASS
	db ELECTRIC
	db PSYCHIC
	db ICE
	db DRAGON
	db DARK
	db FAIRY
.TypeListRowsEnd:
	db -1 ; end
.TypeListEnd:

.TypeMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 10, 1, 18, 16
	dw .TypeMenuData
	db 1 ; default option

.TypeMenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 7, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dbw 0, wStringBuffer2
	dba .PrintTypeName
	dba NULL
	dba NULL

.PrintTypeName:
	ld a, [wMenuSelection]
	cp -1
	ret z
	ld [wNamedObjectIndexBuffer], a
	push de
	predef GetTypeName
	pop hl
	ld de, wStringBuffer1
	jp PlaceString

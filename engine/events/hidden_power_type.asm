HiddenPowerTypeMenu:
; Let the player pick the type and category their Hidden Power will use.
; On success: stores the type in wHiddenPowerType (bit 7 set = physical,
; clear = special), leaves the type name in wStringBuffer3 and the
; category name in wStringBuffer4 (both for text_ram), and sets
; wScriptVar to TRUE. On cancel (B in either menu), sets wScriptVar
; to FALSE and changes nothing.

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

; Type chosen; now the category.
	ld a, [wMenuSelection]
	push af
	ld hl, .CategoryMenuHeader
	call LoadMenuHeader
	call VerticalMenu
	push af ; save carry (set if B was pressed)
	call CloseWindow
	pop af
	pop bc ; b = chosen type
	jr c, .cancel

	ld a, b
	ld [wNamedObjectIndexBuffer], a
	ld a, [wMenuCursorY]
	dec a ; 1 = physical, 2 = special
	jr z, .physical
	ld de, .SpecialString
	ld a, b
	jr .store

.physical
	ld de, .PhysicalString
	ld a, b
	or 1 << 7 ; physical flag

.store
	ld [wHiddenPowerType], a
	; Category name -> wStringBuffer4 (de = source).
	ld hl, wStringBuffer4
	call CopyName2
	; Type name -> wStringBuffer3.
	predef GetTypeName ; -> wStringBuffer1
	ld hl, wStringBuffer1
	ld de, wStringBuffer3
	ld bc, MOVE_NAME_LENGTH
	call CopyBytes
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

.CategoryMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 9, 5, 19, 9
	dw .CategoryMenuData
	db 1 ; default option

.CategoryMenuData:
	db STATICMENU_CURSOR | STATICMENU_NO_TOP_SPACING ; flags
	db 2 ; items
.PhysicalString:
	db "PHYSICAL@"
.SpecialString:
	db "SPECIAL@"

FossilRevivalMenu:
; Build a scrolling menu from only the fossils currently in the Bag.
; Returns the selected item ID in wScriptVar, or 0 if there are no fossils.
; Choosing CANCEL returns -1 so the map script can distinguish it from none.
	ld hl, wMenuItemsList + 1
	ld de, .Fossils
	ld b, .FossilsEnd - .Fossils
	ld c, 0
.check_fossil:
	ld a, [de]
	inc de
	ld [wCurItem], a
	push hl
	ld hl, wNumItems
	call CheckItem
	pop hl
	jr nc, .next_fossil
	ld a, [wCurItem]
	ld [hli], a
	inc c
.next_fossil:
	dec b
	jr nz, .check_fossil

	ld [hl], -1
	ld a, c
	ld [wMenuItemsList], a
	and a
	jr z, .none

	call LoadStandardMenuHeader
	ld hl, .MenuHeader
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
	ld a, [wMenuSelection]
	ld [wScriptVar], a
	ret

.cancel:
	ld a, -1
	ld [wScriptVar], a
	ret

.none:
	xor a
	ld [wScriptVar], a
	ret

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 3, 1, 18, 16
	dw .MenuData
	db 1 ; default option

.MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 7, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dbw 0, wMenuItemsList
	dba PlaceMenuItemName
	dba NULL
	dba NULL

.Fossils:
	db DOME_FOSSIL
	db HELIX_FOSSIL
	db ROOT_FOSSIL
	db CLAW_FOSSIL
	db ARMOR_FOSSIL
	db SAIL_FOSSIL
	db SKULL_FOSSIL
	db COVER_FOSSIL
	db JAW_FOSSIL
	db OLD_AMBER
	db PLUME_FOSSIL
.FossilsEnd:

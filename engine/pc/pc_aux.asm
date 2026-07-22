; Auxiliary routines for the graphical storage system.
; Kept in a separate bank so the nearly-full Bills PC bank only needs
; small far-call trampolines.

_PCPickItem::
; Select an item from the Pack for Item Mode. Returns nz on success.
	farcall DepositSellInitPackBuffers
	jp _PCGetItemToGive

_PCGetItemToGive:
	farcall DepositSellPack
	ld a, [wPackUsedItem]
	and a
	ret z

	; Key Items and anything marked non-tossable cannot be held.
	ld a, [wCurPocket]
	cp KEY_ITEM_POCKET
	jr z, .cant_be_held
	call CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .cant_be_held

	ld a, 1
	and a
	ret

.cant_be_held
	ld hl, .CantBeHeldText
	call MenuTextboxBackup
	jr _PCGetItemToGive

.CantBeHeldText:
	text_far UnknownText_0x1c1c09
	text_end

_PCGiveItem::
	farcall DepositSellInitPackBuffers
.loop
	call _PCGetItemToGive
	ret z

	; Mail is party-only because boxed mons have no mail-message slot.
	ld a, [wCurItem]
	ld d, a
	farcall ItemIsMail
	jr nc, .item_ok
	ld a, [wTempMonBox]
	and a
	jr z, .item_ok
	ld hl, .CantPlaceMailInStorageText
	call MenuTextboxBackup
	jr .loop

.item_ok
	farcall PartyMonItemName
	farcall GiveItemToPokemon

	ld hl, wTempMonNickname
	ld de, wMonOrItemNameBuffer
	ld bc, MON_NAME_LENGTH
	call CopyBytes

	ld hl, .MadeHoldText
	call MenuTextboxBackup

	ld a, [wTempMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wCurItem]
	ld [wTempMonItem], a
	farcall UpdateStorageBoxMonFromTemp

	; A Mail selection is only possible for a party mon.
	ld a, [wTempMonSlot]
	dec a
	ld [wCurPartyMon], a
	ld a, [wCurItem]
	ld d, a
	farcall ItemIsMail
	ret nc
	farcall ComposeMailMessage
	ret

.CantPlaceMailInStorageText:
	text "Can't place Mail in"
	line "storage."
	prompt

.MadeHoldText:
	text_far UnknownText_0x1c1b57
	text_end

_NoYesBox::
; Polished's destructive confirmations default to NO.
	ld hl, .MenuHeader
	call LoadMenuHeader
	call VerticalMenu
	push af
	ld c, 15
	call DelayFrames
	call CloseWindow
	pop af
	ret c
	ld a, [wMenuCursorY]
	dec a
	jr nz, .yes
	scf
	ret
.yes
	and a
	ret

.MenuHeader:
	db MENU_BACKUP_TILES
	menu_coords SCREEN_WIDTH - 6, 7, SCREEN_WIDTH - 1, 11
	dw .MenuData
	db 1

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_NO_TOP_SPACING
	db 2
	db "NO@"
	db "YES@"

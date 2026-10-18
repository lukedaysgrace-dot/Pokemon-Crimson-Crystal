PUSHS
SECTION "Decoration Shops", ROMX

CeladonFurnitureShop::
	xor a
	jr OpenDecorationShop
MountMoonDollShop::
	ld a, 1
	jr OpenDecorationShop
GoldenrodDailyDollShop::
	ld a, 2

OpenDecorationShop:
	ld [wDecorationShopID], a
	call FadeToMenu
	farcall BlankScreen
.loop
	call UpdateTime
	call BuildDecorationShopStock
	ld a, [wDecorationShopStock]
	and a
	jr z, .sold_out
	farcall PlaceMoneyTopRight
	xor a
	ld [wMenuScrollPosition], a
	ld a, 1
	ld [wMenuCursorBuffer], a
	ld hl, .MenuHeader
	call CopyMenuHeader
	call ScrollingMenu
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jp z, CloseSubmenu
	ld a, [wMenuSelection]
	cp -1
	jp z, CloseSubmenu
	ld [wDecorationShopSelected], a
	ld c, a
	ld de, wStringBuffer3
	farcall GetDecorationName_c_de
	ld a, [wDecorationShopSelected]
	call GetDecorationShopPrice
	ld hl, DecorationShopConfirmText
	call PrintText
	call YesNoBox
	jr c, .loop
	ld a, [wDecorationShopSelected]
	call TryBuyDecoration
	and a
	jr z, .bought
	cp 1
	ld hl, DecorationShopAlreadyOwnedText
	jr z, .message
	ld hl, DecorationShopNoMoneyText
	jr .message
.bought
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	ld hl, DecorationShopBoughtText
.message
	call PrintText
	call JoyWaitAorB
	jr .loop
.sold_out
	ld hl, DecorationShopSoldOutText
	call PrintText
	call JoyWaitAorB
	jp CloseSubmenu

.MenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 3, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw .MenuData
	db 1
.MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS
	db 4, 0
	db SCROLLINGMENU_ITEMS_NORMAL
	dbw 0, wDecorationShopStock
	dba DecorationShopPlaceName
	dbw 0, 0
	dbw 0, 0

DecorationShopPlaceName:
	ld a, [wMenuSelection]
	push de
	ld c, a
	ld de, wStringBuffer3
	farcall GetDecorationName_c_de
	pop hl
	ld de, wStringBuffer3
	jp PlaceString

BuildDecorationShopStock::
	xor a
	ld [wDecorationShopStock], a
	ld a, [wDecorationShopID]
	cp 2
	jr z, .daily
	ld hl, CeladonFurnitureStock
	and a
	jr z, .fixed
	ld hl, MountMoonDollStock
.fixed
	ld a, [hli]
	cp -1
	jr z, .done
	call AppendDecorationShopStock
	jr .fixed
.daily
	; Four fixed daily batches cover all eleven dolls. The RTC wraps after
	; 140 days, so this four-day cycle also stays consistent across that wrap.
	ld a, [wCurDay]
	and 3
	ld b, a
	add a
	add b
	ld c, a
	ld b, DECOSHOP_DAILY_STOCK
.next_doll
	ld hl, GoldenrodDailyDollStock
	ld e, c
	ld d, 0
	add hl, de
	ld a, [hl]
	call AppendDecorationShopStock
	inc c
	ld a, c
	cp DECOSHOP_ROOF_DOLLS
	jr c, .next_index
	ld c, 0
.next_index
	dec b
	jr nz, .next_doll
.done
	ld hl, wDecorationShopStock
	ld e, [hl]
	ld d, 0
	inc de
	add hl, de
	ld [hl], -1
	ret

AppendDecorationShopStock:
	ld [wDecorationShopSelected], a
	push bc
	push de
	push hl
	ld b, CHECK_FLAG
	farcall_a DecorationFlagAction
	ld a, c
	and a
	jr nz, .done
	ld hl, wDecorationShopStock
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld a, [wDecorationShopSelected]
	ld [hl], a
.done
	pop hl
	pop de
	pop bc
	ret

GetDecorationShopPrice::
	ld c, a
	ld hl, DecorationShopPrices
.loop
	ld a, [hli]
	cp -1
	jr z, .missing
	cp c
	jr z, .found
	inc hl
	inc hl
	jr .loop
.found
	ld a, [hli]
	ld [wDecorationShopPrice + 2], a
	ld a, [hl]
	ld [wDecorationShopPrice + 1], a
	xor a
	ld [wDecorationShopPrice], a
	ret
.missing
	scf
	ret

TryBuyDecoration::
; a = decoration ID; return 0 bought, 1 already owned, 2 poor, 3 not stocked.
	ld [wDecorationShopSelected], a
	ld b, CHECK_FLAG
	farcall_a DecorationFlagAction
	ld a, c
	and a
	jr nz, .owned
	ld hl, wDecorationShopStock
	ld b, [hl]
	inc hl
.find
	ld a, b
	and a
	jr z, .not_stocked
	ld a, [wDecorationShopSelected]
	cp [hl]
	jr z, .stocked
	inc hl
	dec b
	jr .find
.stocked
	call GetDecorationShopPrice
	jr c, .not_stocked
	ld de, wMoney
	ld bc, wDecorationShopPrice
	farcall CompareMoney
	jr c, .poor
	farcall TakeMoney
	ld a, [wDecorationShopSelected]
	ld b, SET_FLAG
	farcall_a DecorationFlagAction
	xor a
	ret
.owned
	ld a, 1
	ret
.poor
	ld a, 2
	ret
.not_stocked
	ld a, 3
	ret

DecorationShopConfirmText:
	text_ram wStringBuffer3
	text_start
	line "¥@"
	text_decimal wDecorationShopPrice, 3, 5
	text " Buy it?"
	done
DecorationShopBoughtText:
	text "Added to your"
	line "room decorations!"
	para "Use your bedroom"
	line "PC to set it up."
	done
DecorationShopAlreadyOwnedText:
	text "You already own"
	line "that decoration!"
	done
DecorationShopNoMoneyText:
	text "You don't have"
	line "enough money!"
	done
DecorationShopSoldOutText:
	text "You already own"
	line "everything in"
	cont "stock right now!"
	done

INCLUDE "data/decorations/shops.asm"
POPS

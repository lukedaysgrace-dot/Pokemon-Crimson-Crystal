PUSHS
SECTION "Consumable convenience", ROMX

UsePartyItemRepeatedly::
	call GetRepeatableConsumableQuantity
	jp nc, DoItemEffect
.loop
	push bc ; total quantity before use (all stacks)
	ld a, [wCurItem]
	push af
	ld a, -1 ; find by item ID, even after a stack disappears
	ld [wCurItemQuantity], a
	call DoItemEffect
	pop af
	ld [wCurItem], a
	pop de
	push de
	call GetRepeatableConsumableQuantity
	pop de
	ret nc ; exhausted, or no longer in the field
	; Repeat only if an item was consumed. Cancel and no-effect cases exit.
	ld a, c
	sub e
	ld a, b
	sbc d
	jr c, .loop
	ret

GetRepeatableConsumableQuantity::
	ld a, [wBattleMode]
	and a
	ret nz
	call IsRepeatableConsumable
	ret nc
	jp GetBagItemQuantity

IsRepeatableConsumable::
	ld a, [wCurItem]
	call GetValidItemIndexFromID
	dec hl
	add hl, hl
	ld bc, ItemEffects
	add hl, bc
	ld a, BANK(ItemEffects)
	call GetFarHalfword
	ld d, h
	ld e, l
	ld hl, .Effects
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	ret z
	ld a, b
	cp d
	jr nz, .loop
	ld a, c
	cp e
	jr nz, .loop
	scf
	ret
.Effects
	dw VitaminEffect, RareCandyEffect, RestoreHPEffect, StatusHealingEffect
	dw FullRestoreEffect, ReviveEffect, EnergypowderEffect, EnergyRootEffect
	dw HealPowderEffect, RevivalHerbEffect, RestorePPEffect
	dw 0

GetBagItemQuantity::
	ld a, [wCurItem]
	call GetItemIndexFromID
	ld b, h
	ld c, l
	ld hl, wItems
	ld de, 0
	ld a, [wNumItems]
	ld [wTempLoopCounter], a
.loop
	ld a, [wTempLoopCounter]
	and a
	jr z, .done
	dec a
	ld [wTempLoopCounter], a
	ld a, [hli]
	cp b
	jr nz, .skip_low
	ld a, [hli]
	cp c
	jr nz, .next
	ld a, [hl]
	add e
	ld e, a
	jr nc, .next
	inc d
	jr .next
.skip_low
	inc hl
.next
	inc hl
	jr .loop
.done
	ld b, d
	ld c, e
	ld a, b
	or c
	ret z
	scf
	ret

PrintRepeatConsumableQuantity::
	call GetRepeatableConsumableQuantity
	ret nc
	ld a, b
	ld [wStringBuffer3], a
	ld a, c
	ld [wStringBuffer3 + 1], a
	ld a, [wCurItem]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	hlcoord 1, 15
	call PlaceString
	ld h, b
	ld l, c
	ld a, " "
	ld [hli], a
	ld a, "×"
	ld [hli], a
	ld de, wStringBuffer3
	lb bc, 2, 4
	jp PrintNum

POPS

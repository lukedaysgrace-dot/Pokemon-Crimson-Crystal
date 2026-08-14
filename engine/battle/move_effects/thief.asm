BattleThief_Core:
; thief (body in the Battle Effect Overflow bank)

	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy

; The player needs to be able to steal an item.

	call .playeritem
	ld a, [hl]
	and a
	ret nz

; The enemy needs to have an item to steal.

	call .enemyitem
	ld a, [hl]
	and a
	ret z

; Sticky Hold keeps the victim's item where it is (Mold Breaker pierces).

	push hl
	farcall GetOppIgnorableAbility_b
	ld a, b
	cp STICKY_HOLD
	pop hl
	jr z, .sticky_hold

; Can't steal mail.

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	ld d, a
	farcall ItemIsMail
	ret c

	ld a, [wEffectFailed]
	and a
	ret nz

	ld a, [wLinkMode]
	and a
	jr z, .stealenemyitem

	ld a, [wBattleMode]
	dec a
	ret z

.stealenemyitem
	call .enemyitem
	xor a
	ld [hl], a
	ld [de], a

	call .playeritem
	ld a, [wNamedObjectIndexBuffer]
	ld [hl], a
	ld [de], a
	; the enemy side lost its item (for Unburden)
	ld c, 1
	farcall MarkSideLostItem_Core
	jr .stole

.enemy

; The enemy can't already have an item.

	call .enemyitem
	ld a, [hl]
	and a
	ret nz

; The player must have an item to steal.

	call .playeritem
	ld a, [hl]
	and a
	ret z

; Sticky Hold keeps the victim's item where it is (Mold Breaker pierces).

	push hl
	farcall GetOppIgnorableAbility_b
	ld a, b
	cp STICKY_HOLD
	pop hl
	jr z, .sticky_hold

; Can't steal mail!

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	ld d, a
	farcall ItemIsMail
	ret c

	ld a, [wEffectFailed]
	and a
	ret nz

; If the enemy steals your item,
; it's gone for good if you don't get it back.

	call .playeritem
	xor a
	ld [hl], a
	ld [de], a

	call .enemyitem
	ld a, [wNamedObjectIndexBuffer]
	ld [hl], a
	ld [de], a
	; the player side lost its item (for Unburden)
	ld c, 0
	farcall MarkSideLostItem_Core

.stole
	call GetItemName
	ld hl, StoleText
	jp StdBattleTextbox

.sticky_hold
	farcall StickyHoldAnnounce_Core
	ret

.playeritem
	ld a, 1
	call BattlePartyAttr
	ld d, h
	ld e, l
	ld hl, wBattleMonItem
	ret

.enemyitem
	ld a, 1
	call OTPartyAttr
	ld d, h
	ld e, l
	ld hl, wEnemyMonItem
	ret

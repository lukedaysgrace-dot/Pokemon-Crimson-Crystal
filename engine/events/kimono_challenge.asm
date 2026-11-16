; Only successful manual consumption reaches this hook. Held Berries and
; healing moves are allowed; canceled/ineffective Bag actions do not count.
PUSHS
SECTION "Kimono Challenge Item Tracking", ROMX

KimonoChallengeUsedItem:
	push af
	push bc
	push de
	push hl
	ld a, [wMapGroup]
	cp GROUP_DANCE_THEATRE
	jr nz, .done
	ld a, [wMapNumber]
	cp MAP_DANCE_THEATRE
	jr nz, .done
	ld a, [wCurItem]
	call GetItemIndexFromID
	ld a, h
	and a
	jr nz, .done
	ld a, l
	ld hl, .HealingItems
	ld de, 1
	call IsInArray
	jr nc, .done
	ld de, EVENT_KIMONO_CHALLENGE_FAILED
	ld b, SET_FLAG
	call EventFlagAction
.done
	pop hl
	pop de
	pop bc
	pop af
	ret

.HealingItems:
	db POTION, SUPER_POTION, HYPER_POTION, MAX_POTION, FULL_RESTORE
	db ANTIDOTE, BURN_HEAL, ICE_HEAL, AWAKENING, PARLYZ_HEAL, FULL_HEAL
	db REVIVE, MAX_REVIVE, FRESH_WATER, SODA_POP, LEMONADE, MOOMOO_MILK, RAGECANDYBAR
	db ENERGYPOWDER, ENERGY_ROOT, HEAL_POWDER, REVIVAL_HERB
	db BERRY, GOLD_BERRY, BERRY_JUICE, PSNCUREBERRY, PRZCUREBERRY
	db BURNT_BERRY, ICE_BERRY, MINT_BERRY, MIRACLEBERRY, BITTER_BERRY
	db ETHER, MAX_ETHER, ELIXER, MAX_ELIXER, MYSTERYBERRY, SACRED_ASH
	db -1
POPS

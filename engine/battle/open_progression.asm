; This is a bounded party override, not a global level scaler. No persistent
; state: badge ownership is checked anew for every battle/transition.
GetOpenProgressionStage::
; a = 0/1/2 while active; $ff before Morty or after all three badges.
; Additional late-game guards also reject malformed/out-of-order old saves.
	ld a, [wKantoBadges]
	and a
	jr nz, .inactive
	ld a, [wJohtoBadges]
	bit RISINGBADGE, a
	jr nz, .inactive
	bit FOGBADGE, a
	jr z, .inactive
	and (1 << STORMBADGE) | (1 << MINERALBADGE) | (1 << GLACIERBADGE)
	ld b, a
	ld c, 0
	ld d, 8
.count
	srl b
	jr nc, .next
	inc c
.next
	dec d
	jr nz, .count
	ld a, c
	cp 3
	ret c
.inactive
	ld a, $ff
	ret

SelectOpenProgressionParty::
; Returns a:hl = replacement name/type record, or a = 0 for original data.
; The table includes map identity and a defeated-event guard, so sharing a
; trainer class/party ID elsewhere and first-tier phone rematches stay fixed.
	call GetOpenProgressionStage
	cp $ff
	jr z, .original
	ld c, a
	ld hl, OpenProgressionParties
.entry
	ld a, [hl]
	cp $ff
	jr z, .original
	push hl
	ld a, [wMapGroup]
	cp [hl]
	jr nz, .skip
	inc hl
	ld a, [wMapNumber]
	cp [hl]
	jr nz, .skip
	inc hl
	ld a, [wOtherTrainerClass]
	cp [hl]
	jr nz, .skip
	inc hl
	ld a, [wOtherTrainerID]
	cp [hl]
	jr nz, .skip
	pop de ; discard entry start
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, d
	and e
	cp $ff ; scripted story battle: no repeatable trainer defeated flag
	jr z, .select
	push hl
	push bc
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop bc
	pop hl
	and a
	jr nz, .original
.select
	ld a, c
	add a
	add c
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	inc hl
	ld h, [hl]
	ld l, e
	ret
.skip
	pop hl
	ld de, 15 ; group/map/class/ID + event + three far pointers
	add hl, de
	jr .entry
.original
	xor a
	ret

ClampTrainerStatExpToLevel::
; bc = authored generic training. Return the smaller of that and this party
; member's level allowance. Normal Mode returns zero before reaching here.
; wCurPartyLevel is the actual selected (including open-tier) mon's level.
	ld hl, TrainerStatExpLevelLimits
.next
	ld a, [wCurPartyLevel]
	cp [hl]
	jr c, .found
	jr z, .found
	inc hl
	inc hl
	inc hl
	jr .next
.found
	inc hl
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, b
	cp d
	ret c
	jr nz, .limit
	ld a, c
	cp e
	ret c
.limit
	ld b, d
	ld c, e
	ret

INCLUDE "data/trainers/stat_exp_limits.asm"

ClampOpenProgressionWildLevel::
; Bound newly accessible encounters to the same tier as the region's trainers.
; Never raise a level. Roamers keep their shared level/HP records unchanged.
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz
	ld a, [wBattleMode]
	cp WILD_BATTLE
	ret nz
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	ret z
	call GetOpenProgressionStage
	cp 3
	ret nc
	ld c, a
	ld hl, .maps
.next
	ld a, [hli]
	cp $ff
	ret z
	ld b, a
	ld a, [wMapGroup]
	cp b
	jr nz, .skip
	ld a, [wMapNumber]
	cp [hl]
	jr z, .found
.skip
	inc hl
	jr .next
.found
	ld b, 0
	ld hl, .caps
	add hl, bc
	ld b, [hl]
	ld a, [wCurPartyLevel]
	cp b
	ret c
	ret z
	ld a, b
	ld [wCurPartyLevel], a
	ret
.caps
	db 30, 34, 38
.maps
	db GROUP_ROUTE_38, MAP_ROUTE_38
	db GROUP_ROUTE_39, MAP_ROUTE_39
	db GROUP_ROUTE_40, MAP_ROUTE_40
	db GROUP_ROUTE_41, MAP_ROUTE_41
	db GROUP_ROUTE_42, MAP_ROUTE_42
	db GROUP_ROUTE_43, MAP_ROUTE_43
	db GROUP_OLIVINE_CITY, MAP_OLIVINE_CITY
	db GROUP_CIANWOOD_CITY, MAP_CIANWOOD_CITY
	db GROUP_LAKE_OF_RAGE, MAP_LAKE_OF_RAGE
	db GROUP_SHIVER_ISLE, MAP_SHIVER_ISLE
	db GROUP_UNION_CAVE_B1F, MAP_UNION_CAVE_B1F
	db GROUP_UNION_CAVE_B2F, MAP_UNION_CAVE_B2F
	db GROUP_MOUNT_MORTAR_1F_OUTSIDE, MAP_MOUNT_MORTAR_1F_OUTSIDE
	db GROUP_MOUNT_MORTAR_1F_INSIDE, MAP_MOUNT_MORTAR_1F_INSIDE
	db GROUP_MOUNT_MORTAR_B1F, MAP_MOUNT_MORTAR_B1F
	db GROUP_RUINS_OF_ALPH_OUTSIDE, MAP_RUINS_OF_ALPH_OUTSIDE
	db -1

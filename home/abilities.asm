GetAbility::
; Look up a mon's ability from species and personality.
; in: c = species (8-bit ID), b = personality byte
; out: a, b = ability constant
; preserves de, hl
	push hl
	push de
	ldh a, [hROMBank]
	push af
	push bc
	ld a, c
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	pop bc ; b = personality
	jr z, .no_ability
	rst Bankswitch
	ld de, BASE_ABILITY_1
	add hl, de
	ld d, h
	ld e, l ; de = ability 1 pointer
	ld a, b
	and ABILITY_MASK
	cp ABILITY_2
	jr z, .slot2
	cp HIDDEN_ABILITY
	jr nz, .got_ptr ; ABILITY_1, or unset bits: default to slot 1
	inc hl
.slot2
	inc hl
.got_ptr
	ld a, [hl]
	and a
	jr nz, .got
; empty slot: fall back to ability 1
	ld a, [de]
.got
	ld b, a
	pop af
	rst Bankswitch
	pop de
	pop hl
	ret

.no_ability
	xor a ; NO_ABILITY
	ld b, a
	pop af
	rst Bankswitch
	pop de
	pop hl
	ret

SetPlayerAbility::
; Set wPlayerAbility from wBattleMon's species and personality.
	push bc
	ld a, [wBattleMonPersonality]
	ld b, a
	ld a, [wBattleMonSpecies]
	ld c, a
	call GetAbility
	ld a, b
	ld [wPlayerAbility], a
	pop bc
	ret

SetEnemyAbility::
; Set wEnemyAbility from wEnemyMon's species and personality.
	push bc
	ld a, [wEnemyMonPersonality]
	ld b, a
	ld a, [wEnemyMonSpecies]
	ld c, a
	call GetAbility
	ld a, b
	ld [wEnemyAbility], a
	pop bc
	ret

GetRandomAbilitySlot::
; Roll a 50/50 ability slot for the current base data (wCurBaseData).
; If the species has no second ability, always returns slot 1.
; out: a = ABILITY_1 or ABILITY_2. Preserves bc, de, hl.
	ld a, [wBaseAbility2]
	and a ; NO_ABILITY?
	jr z, .slot1
	call Random
	and %1
	jr z, .slot1
	ld a, ABILITY_2
	ret
.slot1
	ld a, ABILITY_1
	ret

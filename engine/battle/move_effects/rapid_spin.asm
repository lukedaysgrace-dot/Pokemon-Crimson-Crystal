BattleCommand_ClearHazards:
; clearhazards

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_leeched
	res SUBSTATUS_LEECH_SEED, [hl]
	ld hl, ShedLeechSeedText
	call StdBattleTextbox
.not_leeched

	ld hl, wPlayerScreens
	ld de, wPlayerWrapCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens_wrap
	ld hl, wEnemyScreens
	ld de, wEnemyWrapCount
.got_screens_wrap
	bit SCREENS_SPIKES, [hl]
	jr z, .no_spikes
	; reload the screens pointer (hl may have been clobbered above)
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens_2
	ld hl, wEnemyScreens
.got_screens_2
	ld a, [hl]
	and SCREENS_TOXIC_SPIKES_MASK
	jr z, .no_toxic_spikes
	ld a, [hl]
	and $ff ^ SCREENS_TOXIC_SPIKES_MASK
	ld [hl], a
	ld hl, BlewToxicSpikesText
	push de
	call StdBattleTextbox
	pop de
.no_toxic_spikes
	res SCREENS_SPIKES, [hl]
	ld hl, BlewSpikesText
	push de
	call StdBattleTextbox
	pop de
.no_spikes

	ld a, [de]
	and a
	ret z
	xor a
	ld [de], a
	ld hl, ReleasedByText
	jp StdBattleTextbox

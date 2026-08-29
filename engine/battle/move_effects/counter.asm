BattleCommand_Counter:
; counter

	ld a, 1
	ld [wAttackMissed], a
	; these scripts have no checkhit, so Protect / Detect / Baneful Bunker
	; never blocked them (audit 2026-08-28 #24)
	call BattleCommand_CheckHit.Protect
	jp nz, EndMoveEffect
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	ret z

	ld b, a
	callfar GetMoveEffect
	ld a, b
	cp EFFECT_COUNTER
	ret z

	call BattleCommand_ResetTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z

	call CheckOpponentWentFirst
	ret z

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	ld de, wStringBuffer1
	call GetMoveData
	; Hidden Power's category is whatever the opponent's stats picked when
	; it was used, not the move table's
	farcall HiddenPowerCounterCategory

	ld a, [wStringBuffer1 + MOVE_POWER]
	and a
	ret z

	ld a, [wStringBuffer1 + MOVE_CATEGORY]
	cp CATEGORIZE_SPECIAL
	ret z

	ld hl, wCurDamage
	ld a, [hli]
	or [hl]
	jr z, .failed

	ld a, [hl]
	add a
	ld [hld], a
	ld a, [hl]
	adc a
	ld [hl], a
	jr nc, .capped
	ld a, $ff
	ld [hli], a
	ld [hl], a
.capped

	xor a
	ld [wAttackMissed], a
	ret

.failed
	ld a, 1
	ld [wEffectFailed], a
	and a
	ret

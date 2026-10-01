BattleCommand_MirrorCoat:
; mirrorcoat

	ld a, 1
	ld [wAttackMissed], a
	; these scripts have no checkhit, so Protect / Detect / Baneful Bunker
	; never blocked them (audit 2026-08-28 #24)
	call BattleCommand_CheckHit.Protect
	jp nz, EndMoveEffect

	call BattleCommand_ResetTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z

	call CheckOpponentWentFirst
	ret z

	; Use this round's actual direct HP hit, not a move-table category or
	; the shared scratch damage left by a Substitute, recoil or drain.
	farcall LoadCounterHit_Core
	ld a, b
	cp 2
	ret nz

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

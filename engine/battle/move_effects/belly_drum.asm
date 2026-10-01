BattleCommand_BellyDrum:
; bellydrum
	; Belly Drum fails at +6 Attack before Contrary is applied, but may
	; succeed at -6 with Contrary (paying HP even though the stage stays -6).
	ld hl, wPlayerStatLevels + ATTACK
	ldh a, [hBattleTurn]
	and a
	jr z, .got_attack_stage
	ld hl, wEnemyStatLevels + ATTACK
.got_attack_stage
	ld a, [hl]
	cp MAX_STAT_LEVEL
	jr nc, .failed
	callfar GetHalfMaxHP
	callfar CheckUserHasEnoughHP
	jr nc, .failed

	push bc
	call AnimateCurrentMove
	pop bc
	callfar SubtractHPFromUser
	call UpdateUserInParty
	; Apply the single +12-stage change directly. Repeated AttackUp2 calls
	; leak Contrary's inversion marker and can accidentally raise it again.
	farcall GetTrueUserAbility_b
	ld a, b
	cp CONTRARY
	ld b, MAX_STAT_LEVEL
	jr nz, .got_final_stage
	ld b, 1 ; -6
.got_final_stage
	ld hl, wPlayerStatLevels + ATTACK
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, wEnemyStatLevels + ATTACK
	ld [hl], b
	call CalcEnemyStats
	jr .done
.player
	ld [hl], b
	call CalcPlayerStats
.done

	ld hl, BellyDrumText
	jp StdBattleTextbox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

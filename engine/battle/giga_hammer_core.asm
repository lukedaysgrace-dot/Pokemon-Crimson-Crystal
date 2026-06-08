; Giga Hammer battle commands (Battle Core bank) — keeps Effect Commands bank under its limit.

BattleGigaHammer_CheckCore:
	ldh a, [hBattleTurn]
	ld b, a
	and a
	ld hl, wPlayerGigaHammerLock
	jr z, .got_lock
	ld hl, wEnemyGigaHammerLock
.got_lock
	ld a, [hl]
	and a
	ret z
	ld a, b
	and a
	jr nz, .no_repick
	ld a, 1
	ld [wPlayerMustRechooseMove], a
.no_repick
	call BattleGigaHammer_ApplyFailAnimAndText
	callfar EndMoveEffect
	ret

BattleGigaHammer_ApplyFailAnimAndText:
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleGigaHammer_SetLockCore:
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerGigaHammerLock
	jr z, .set
	ld hl, wEnemyGigaHammerLock
.set
	ld a, 1
	ld [hl], a
	ret

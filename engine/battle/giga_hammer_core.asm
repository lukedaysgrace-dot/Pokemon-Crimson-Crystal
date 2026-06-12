; Giga Hammer-style battle commands (Battle Core bank) - keeps Effect Commands bank under its limit.

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
	ld c, a
	ld a, b
	and a
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	jr z, .got_move
	ld a, [wEnemyMoveStruct + MOVE_ANIM]
.got_move
	cp c
	ret nz
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
	jr nz, .enemy
	ld hl, wPlayerGigaHammerLock
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	jr .set
.enemy
	ld hl, wEnemyGigaHammerLock
	ld a, [wEnemyMoveStruct + MOVE_ANIM]
.set
	ld [hl], a
	ret

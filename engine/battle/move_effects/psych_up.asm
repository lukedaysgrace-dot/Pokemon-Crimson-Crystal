BattleCommand_PsychUp:
; psychup

	ld hl, wEnemyStatLevels
	ld de, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .pointers_correct
; It's the enemy's turn, so swap the pointers.
	push hl
	ld h, d
	ld l, e
	pop de
.pointers_correct
	; Modern Psych Up also copies neutral stages, clearing the user's own
	; changes. Copying stages bypasses Contrary and stat-drop protection.
	ld b, NUM_LEVEL_STATS
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop2
	; Focus Energy is the supported critical-hit stage effect and is copied
	; too; clear it on the user when the target has no Focus Energy.
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FOCUS_ENERGY
	ld b, a
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	res SUBSTATUS_FOCUS_ENERGY, [hl]
	ld a, [hl]
	or b
	ld [hl], a
	ldh a, [hBattleTurn]
	and a
	jr nz, .calc_enemy_stats
	call CalcPlayerStats
	jr .merge

.calc_enemy_stats
	call CalcEnemyStats
.merge
	call AnimateCurrentMove
	ld hl, CopiedStatsText
	jp StdBattleTextbox

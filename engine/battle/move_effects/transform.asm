BattleCommand_Transform::
; transform

	call ClearLastMove
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_TRANSFORMED, [hl]
	jp nz, BattleEffect_ButItFailed
	call CheckHiddenOpponent
	jp nz, BattleEffect_ButItFailed
	xor a
	ld [wNumHits], a
	ld a, $1
	ld [wKickCounter], a
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_SUBSTITUTE, [hl]
	push af
	jr z, .mimic_substitute
	call CheckUserIsCharging
	jr nz, .mimic_substitute
	ld hl, SUBSTITUTE
	call GetMoveIDFromIndex
	call LoadAnim
.mimic_substitute
	call TransformMonData
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonSpecies
	jr z, .got_species
	ld hl, wEnemyMonSpecies
.got_species
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	call _CheckBattleScene
	jr c, .mimic_anims
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerMinimized]
	jr z, .got_byte
	ld a, [wEnemyMinimized]
.got_byte
	and a
	jr nz, .mimic_anims
	; Play Transform "raw" so Imposter works without a move struct
	ld de, TRANSFORM
	call FarPlayBattleAnimation
	jr .after_anim

.mimic_anims
	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSubNoAnim
.after_anim
	xor a
	ld [wNumHits], a
	ld a, $2
	ld [wKickCounter], a
	pop af
	jr z, .no_substitute
	ld hl, SUBSTITUTE
	call GetMoveIDFromIndex
	call LoadAnim
.no_substitute
	ld a, [wTempByteValue]
	and a
	ret nz
	ld hl, TransformedText
	jp StdBattleTextbox

TransformMonData::
; Copy the target's ability, moves, DVs, stats and stat stages onto the user.
; Sets SUBSTATUS_TRANSFORMED. Used by the move and by Imposter.
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	set SUBSTATUS_TRANSFORMED, [hl]
	call ResetActorDisable
	; canon: Transform also copies the target's ability
	; (Neutralizing Gas can't be copied - ABILFLAG_NO_TRANSFORM)
	farcall TransformCopyAbility
	ld hl, wBattleMonSpecies
	ld de, wEnemyMonSpecies
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_mon_species
	ld hl, wEnemyMonSpecies
	ld de, wBattleMonSpecies
	xor a
	ld [wCurMoveNum], a
.got_mon_species
	push hl
	ld a, [hli]
	ld [de], a
	inc hl
	inc de
	inc de
	ld bc, NUM_MOVES
	call CopyBytes
	ldh a, [hBattleTurn]
	and a
	jr z, .mimic_enemy_backup
	ld a, [de]
	ld [wEnemyBackupDVs], a
	inc de
	ld a, [de]
	ld [wEnemyBackupDVs + 1], a
	dec de
.mimic_enemy_backup
; copy DVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
; move pointer to stats
	ld bc, wBattleMonStats - wBattleMonPP
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, wBattleMonStructEnd - wBattleMonStats
	call CopyBytes
; init the power points
	ld bc, wBattleMonMoves - wBattleMonStructEnd
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld bc, wBattleMonPP - wBattleMonStructEnd
	add hl, bc
	ld b, NUM_MOVES
.pp_loop
	ld a, [de]
	inc de
	and a
	jr z, .done_move
	push bc
	ld bc, SKETCH
	call CompareMove
	pop bc
	ld a, 1
	jr z, .done_move
	ld a, 5
.done_move
	ld [hli], a
	dec b
	jr nz, .pp_loop
	pop hl
	ld hl, wEnemyStats
	ld de, wPlayerStats
	ld bc, 2 * 5
	call BattleSideCopy
	ld hl, wEnemyStatLevels
	ld de, wPlayerStatLevels
	ld bc, 8
	jp BattleSideCopy

BattleSideCopy:
; Copy bc bytes from hl to de if it's the player's turn.
; Copy bc bytes from de to hl if it's the enemy's turn.
	ldh a, [hBattleTurn]
	and a
	jr z, .copy

; Swap hl and de
	push hl
	ld h, d
	ld l, e
	pop de
.copy
	jp CopyBytes

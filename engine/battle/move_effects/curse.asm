BattleCommand_Curse:
; curse

	ld de, wBattleMonType1
	ld bc, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld de, wEnemyMonType1
	ld bc, wEnemyStatLevels

.go

; Curse is different for Ghost-types.

	ld a, [de]
	cp GHOST
	jp z, .ghost
	inc de
	ld a, [de]
	cp GHOST
	jp z, .ghost

; Fail only when all three changes are capped in their actual direction.
; Contrary reverses each one, and Speed can change even if the Attack and
; Defense boosts are already capped.
	push bc
	farcall GetTrueUserAbility_b
	ld a, b
	pop bc
	cp CONTRARY
	jr z, .contrary_caps

; Attack
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr c, .raise

; Defense
	inc bc
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr c, .raise
; Speed
	inc bc
	ld a, [bc]
	cp 1 ; -6
	jp z, .cantraise
	jr .raise

.contrary_caps
	ld a, [bc]
	cp 1 ; -6
	jr nz, .raise
	inc bc
	ld a, [bc]
	cp 1 ; -6
	jr nz, .raise
	inc bc
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jp nc, .cantraise

.raise

; Raise Attack and Defense, and lower Speed.

	ld a, $1
	ld [wKickCounter], a
	call AnimateCurrentMove
	; One stat up anim + "ATTACK and DEFENSE rose!", then one stat down
	; anim + "SPEED fell!".
	call BattleCommand_DeferStatMessages
	; savemiss scope so the deferred Speed drop is recognised as
	; self-inflicted (no Defiant/Competitive) - audit 2026-08-28 #4
	call BattleCommand_SaveMiss
	call BattleCommand_SwitchTurn
	call BattleCommand_SpeedDown
	call BattleCommand_StatDownMessage
	call ResetMiss
	call BattleCommand_SwitchTurn
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage
	call ResetMiss
	call BattleCommand_DefenseUp
	call BattleCommand_StatUpMessage
	call BattleCommand_FlushStatMessages
	jp BattleCommand_RestoreMiss

.ghost

; Cut HP in half and put a curse on the opponent.

	call CheckHiddenOpponent
	jr nz, .failed

	call CheckSubstituteOpp
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CURSE, [hl]
	jr nz, .failed

	set SUBSTATUS_CURSE, [hl]
	call AnimateCurrentMove
	ld hl, GetHalfMaxHP
	call CallBattleCore
	ld hl, SubtractHPFromUser
	call CallBattleCore
	call UpdateUserInParty
	ld hl, PutACurseText
	jp StdBattleTextbox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

.cantraise

; None of the three stat changes can take effect.

	ld b, ABILITY + 1
	call GetStatName
	call AnimateFailedMove
	ld hl, WontRiseAnymoreText
	jp StdBattleTextbox

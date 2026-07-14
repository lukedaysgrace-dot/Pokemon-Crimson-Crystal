BattlePerishSong_Core::
; Apply Perish Song to each battler that is not already perishing and is
; not protected by Soundproof. Mold Breaker ignores the target's
; Soundproof, but never the user's own ability.
	ld hl, wPlayerSubStatus1
	ld de, wEnemySubStatus1
	bit SUBSTATUS_PERISH, [hl]
	jr z, .ok

	ld a, [de]
	bit SUBSTATUS_PERISH, a
	jr nz, .failed

.ok
	ld c, 0 ; number of battlers newly affected
	bit SUBSTATUS_PERISH, [hl]
	jr nz, .enemy
	ldh a, [hBattleTurn]
	and a
	jr nz, .player_is_target
	farcall GetPlayerAbilityEffective_b
	jr .check_player_soundproof
.player_is_target
	farcall GetOpponentIgnorableAbility_b
.check_player_soundproof
	ld a, b
	cp SOUNDPROOF
	jr z, .enemy

	set SUBSTATUS_PERISH, [hl]
	ld a, 4
	ld [wPlayerPerishCount], a
	inc c

.enemy
	ld a, [de]
	bit SUBSTATUS_PERISH, a
	jr nz, .finish
	ldh a, [hBattleTurn]
	and a
	jr z, .enemy_is_target
	farcall GetEnemyAbilityEffective_b
	jr .check_enemy_soundproof
.enemy_is_target
	farcall GetOpponentIgnorableAbility_b
.check_enemy_soundproof
	ld a, b
	cp SOUNDPROOF
	jr z, .finish

	ld a, [de]
	set SUBSTATUS_PERISH, a
	ld [de], a
	ld a, 4
	ld [wEnemyPerishCount], a
	inc c

.finish
	ld a, c
	and a
	jr z, .failed
	callfar AnimateCurrentMove
	ld hl, StartPerishText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	farcall PrintButItFailed
	ret

; ============================================================
; Move Expansion 2026-07 - new move effect cores
; Stealth Rock, Stone Axe, Defog, Rage Fist
; Reached via callfar from engine/battle/effect_commands.asm.
; ============================================================

BattleStealthRock_Core:
; Lay pointed stones on the opponent's side. Only one layer, unlike Spikes.
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyScreens
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_STEALTH_ROCK, [hl]
	jr nz, .failed
	set SCREENS_STEALTH_ROCK, [hl]
	callfar AnimateCurrentMove
	ld hl, StealthRockText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleStealthRockHit_Core:
; Stone Axe: set the hazard after damage. Silent if the stones are already up,
; and does nothing at all if the attack missed.
	ld a, [wAttackMissed]
	and a
	ret nz
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyScreens
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_STEALTH_ROCK, [hl]
	ret nz
	set SCREENS_STEALTH_ROCK, [hl]
	ld hl, StealthRockText
	jp StdBattleTextbox

BattleDefog_Core:
; Clear entry hazards and screens from BOTH sides of the field.
; The target's evasion drop is handled by the effect script.
	callfar AnimateCurrentMove

	ld hl, wPlayerScreens
	call .ClearSide
	ld hl, wEnemyScreens
	call .ClearSide

	ld hl, DefogText
	jp StdBattleTextbox

.ClearSide:
	ld a, [hl]
	and $ff ^ (1 << SCREENS_REFLECT | 1 << SCREENS_LIGHT_SCREEN | 1 << SCREENS_SPIKES | 1 << SCREENS_STEALTH_ROCK | SCREENS_TOXIC_SPIKES_MASK)
	ld [hl], a
	ret

BattleRageFist_Core:
; Power = 50 + 50 * (hits the user has taken this battle), capped at 250 so it
; still fits in the one-byte power field.
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerRageFistHits]
	jr z, .got_count
	ld a, [wEnemyRageFistHits]
.got_count
	cp 4
	jr c, .no_cap
	ld a, 4
.no_cap
	ld b, a
	ld a, 50
	inc b
	jr .check
.loop
	add 50
.check
	dec b
	jr nz, .loop

	ld d, a
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerMoveStructPower
	jr z, .got_move
	ld hl, wEnemyMoveStructPower
.got_move
	ld [hl], d
	ret

StealthRockDamage_Core:
; Switch-in damage from pointed stones. Relocated out of the Battle Core bank,
; so every Battle Core helper is reached by farcall.
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerScreens
	jr z, .got_screens
	ld hl, wEnemyScreens
.got_screens
	bit SCREENS_STEALTH_ROCK, [hl]
	ret z

	ld hl, BattleText_UserHurtByStealthRock
	call StdBattleTextbox

	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType1
.got_types
	ld a, ROCK
	farcheckmatchup
	ld a, [wTypeMatchup]

	cp 3   ; 0.25x
	jr c, .thirtysecond
	cp 6   ; 0.5x
	jr c, .sixteenth
	cp 11  ; 1x
	jr c, .eighth
	cp 21  ; 2x
	jr c, .quarter

	farcall GetHalfMaxHP
	jr .apply

.thirtysecond
	farcall GetEighthMaxHP
	srl b
	rr c
	srl b
	rr c
	jr .floor

.sixteenth
	farcall GetEighthMaxHP
	srl b
	rr c
	jr .floor

.eighth
	farcall GetEighthMaxHP
	jr .apply

.quarter
	farcall GetQuarterMaxHP
	jr .apply

.floor
	ld a, b
	or c
	jr nz, .apply
	ld c, 1

.apply
	farcall SubtractHPFromTarget

	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_hud
	farcall UpdatePlayerHUD
	jp WaitBGMap

.enemy_hud
	farcall UpdateEnemyHUD
	jp WaitBGMap

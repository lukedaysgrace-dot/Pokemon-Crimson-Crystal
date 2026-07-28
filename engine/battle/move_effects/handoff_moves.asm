; Move effects added from MOVE_EXPANSION_HANDOFF.md.

BattleCommand_StealthRock:
; stealthrock
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_STEALTH_ROCK, [hl]
	jr nz, .failed
	set SCREENS_STEALTH_ROCK, [hl]
	call AnimateCurrentMove
	ld hl, StealthRockText
	jp StdBattleTextbox
.failed
	jp FailMove

BattleCommand_StickyWeb:
; stickyweb
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_STICKY_WEB, [hl]
	jr nz, .failed
	set SCREENS_STICKY_WEB, [hl]
	call AnimateCurrentMove
	ld hl, StickyWebText
	jp StdBattleTextbox
.failed
	jp FailMove

BattleCommand_Defog:
; defog
; Clears entry hazards and screens from BOTH sides.
	ld hl, wPlayerScreens
	call .ClearSide
	ld hl, wEnemyScreens
	call .ClearSide
	xor a
	ld [wPlayerLightScreenCount], a
	ld [wPlayerReflectCount], a
	ld [wEnemyLightScreenCount], a
	ld [wEnemyReflectCount], a
	call AnimateCurrentMove
	ld hl, DefogText
	jp StdBattleTextbox

.ClearSide:
	ld a, [hl]
	and ~((1 << SCREENS_STEALTH_ROCK) | (1 << SCREENS_SPIKES) | \
	      SCREENS_TOXIC_SPIKES_MASK | (1 << SCREENS_STICKY_WEB) | \
	      (1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)) & $ff
	ld [hl], a
	ret

BattleCommand_FreezeDry:
; freezedry
; Ice hits Water super-effectively.
	push hl
	push bc
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonType1
	jr z, .got_types
	ld hl, wBattleMonType1
.got_types
	ld a, [hli]
	cp WATER
	jr z, .water
	ld a, [hl]
	cp WATER
	jr nz, .done
.water
	; Ice is normally 1/2 against Water; multiply by 4 to reach 2x.
	ld a, [wTypeModifier]
	and $7f
	add a
	add a
	ld [wTypeModifier], a
.done
	pop bc
	pop hl
	ret

GetPhysicalAttackSource::
; hl = the user's unboosted Attack stat. Body Press substitutes the user's
; Defense; Foul Play substitutes the target's Attack. Preserves everything else.
	push af
	push bc
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_BODY_PRESS
	jr z, .body_press
	cp EFFECT_FOUL_PLAY
	jr z, .foul_play
.done
	pop bc
	pop af
	ret

.body_press
	inc hl
	inc hl ; Attack -> Defense
	jr .done

.foul_play
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonAttack
	jr z, .done
	ld hl, wBattleMonAttack
	jr .done

GetPhysicalAttackSourceBoosted::
; As above, but for the stat-stage-modified copies used on a critical hit.
	push af
	push bc
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_BODY_PRESS
	jr z, .body_press
	cp EFFECT_FOUL_PLAY
	jr z, .foul_play
.done
	pop bc
	pop af
	ret

.body_press
	inc hl
	inc hl ; Attack -> Defense
	jr .done

.foul_play
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyAttack
	jr z, .done
	ld hl, wPlayerAttack
	jr .done

StealthRockDamage_Core::
; Called on switch-in. Damages the incoming mon based on Rock's
; effectiveness against its types: 1/32 .. 1/2 of max HP.
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wEnemyScreens
.got_screens
	bit SCREENS_STEALTH_ROCK, [hl]
	ret z

	farcall UserHasMagicGuard_Core
	ret z

	; b = number of halvings/doublings, starting from 1/8 max HP
	ld b, 0
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType1
.got_types
	ld a, [hli]
	call .RockVsType
	ld a, [hl]
	call .RockVsType

	push bc
	ld hl, HurtByStealthRockText
	call StdBattleTextbox
	pop bc

	call GetEighthMaxHP
.scale
	ld a, b
	and a
	jr z, .apply
	bit 7, b
	jr nz, .halve
	; resisted: halve
	srl c
	dec b
	jr .scale
.halve
	; super effective: double
	sla c
	rl b
	jr .apply
.apply
	ld a, c
	and a
	jr nz, .ok
	ld c, 1
.ok
	call SubtractHPFromTarget
	jp WaitBGMap

.RockVsType:
; Adjusts b: +1 per type Rock is strong against, -1 per resistance.
	cp FLYING
	jr z, .strong
	cp BUG
	jr z, .strong
	cp FIRE
	jr z, .strong
	cp ICE
	jr z, .strong
	cp FIGHTING
	jr z, .weak
	cp GROUND
	jr z, .weak
	cp STEEL
	jr z, .weak
	ret
.strong
	inc b
	ret
.weak
	dec b
	ret

StickyWebSpeedDrop_Core::
; Called on switch-in. Grounded mons lose one stage of Speed.
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wEnemyScreens
.got_screens
	bit SCREENS_STICKY_WEB, [hl]
	ret z
	farcall CheckSpikesUngrounded_Core
	ret c
	; -1 Speed stage (7 is neutral, 1 is the floor)
	ld hl, wPlayerSpdLevel
	ldh a, [hBattleTurn]
	and a
	jr z, .got_level
	ld hl, wEnemySpdLevel
.got_level
	ld a, [hl]
	cp 1
	ret z
	dec [hl]
	push hl
	ld hl, CaughtInStickyWebText
	call StdBattleTextbox
	pop hl
	ld hl, CalcPlayerStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_calc
	ld hl, CalcEnemyStats
.got_calc
	ld a, BANK(CalcPlayerStats)
	rst FarCall
	ret

CheckCriticalHitMove_Core::
; bc = 16-bit move index. Returns carry if the move has a high critical-hit ratio.
; Lives here because the Effect Commands bank is full.
	ld de, 2
	ld hl, CriticalHitMoves
	jp IsInHalfwordArray

INCLUDE "data/moves/critical_hit_moves.asm"

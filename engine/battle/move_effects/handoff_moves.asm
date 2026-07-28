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
; Entry hazards are cleared from both sides. Reflect, Light Screen,
; Safeguard, and Mist are cleared only from the target's side.
	ld a, [wAttackMissed]
	and a
	jr z, .hit
	farcall GetFailureResultText
	ret

.hit
	ld hl, wPlayerScreens
	call .ClearHazards
	ld hl, wEnemyScreens
	call .ClearHazards

	ld hl, wEnemyScreens
	ld de, wEnemySafeguardCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_target
	ld hl, wPlayerScreens
	ld de, wPlayerSafeguardCount
.got_target
	ld a, [hl]
	and ~((1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN) | \
	      (1 << SCREENS_SAFEGUARD)) & $ff
	ld [hl], a
	xor a
	ld [de], a ; Safeguard
	inc de
	ld [de], a ; Light Screen
	inc de
	ld [de], a ; Reflect

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_MIST, [hl]

	call AnimateCurrentMove
	ld hl, DefogText
	jp StdBattleTextbox

.ClearHazards:
	ld a, [hl]
	and ~((1 << SCREENS_STEALTH_ROCK) | (1 << SCREENS_SPIKES) | \
	      SCREENS_TOXIC_SPIKES_MASK | (1 << SCREENS_STICKY_WEB)) & $ff
	ld [hl], a
	ret

BattleCommand_FreezeDry:
; freezedry
; Ice hits Water super-effectively. BattleCommand_Stab deliberately defers
; the ability/item damage-modifier pass for Freeze-Dry until this command,
; so those modifiers see the overridden matchup too.
	push hl
	push bc
	push de
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
	jr nz, .run_modifiers
.water
	; Ice is normally 1/2 against Water. Multiplying both the already
	; type-adjusted damage and the displayed matchup by 4 changes that
	; contribution to 2x.
	call .DoubleDamage
	call .DoubleDamage
	ld a, [wTypeModifier]
	ld b, a
	and $7f
	add a
	add a
	ld c, a
	ld a, b
	and $80
	or c
	ld [wTypeModifier], a
.run_modifiers
	pop de
	pop bc
	pop hl
	farcall RunNullificationAbilities
	ret

.DoubleDamage:
	ld hl, wCurDamage + 1
	sla [hl]
	dec hl
	rl [hl]
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hl], a
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

GetPhysicalAttackStagesForCritical::
; Return b = the physical offensive stat stage actually used by the move,
; and a = the target's Defense stage. Critical-hit stage selection must
; follow the substituted stat for Body Press and Foul Play too.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld c, a
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy

	ld a, c
	cp EFFECT_BODY_PRESS
	ld a, [wPlayerDefLevel]
	jr z, .got_player_attack
	ld a, c
	cp EFFECT_FOUL_PLAY
	ld a, [wEnemyAtkLevel]
	jr z, .got_player_attack
	ld a, [wPlayerAtkLevel]
.got_player_attack
	ld b, a
	ld a, [wEnemyDefLevel]
	ret

.enemy
	ld a, c
	cp EFFECT_BODY_PRESS
	ld a, [wEnemyDefLevel]
	jr z, .got_enemy_attack
	ld a, c
	cp EFFECT_FOUL_PLAY
	ld a, [wPlayerAtkLevel]
	jr z, .got_enemy_attack
	ld a, [wEnemyAtkLevel]
.got_enemy_attack
	ld b, a
	ld a, [wPlayerDefLevel]
	ret

CheckDamageStatsCritical_Core::
; Return carry if stage-modified stats should be used in damage calculations.
; Base stats are used if the attack is a critical hit and the target's
; defensive stage is higher than the relevant offensive stage.
	ld a, [wCriticalHit]
	and a
	scf
	ret z

	push hl
	push bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerMoveStruct + MOVE_CATEGORY]
	cp CATEGORIZE_SPECIAL
; special
	ld a, [wPlayerSAtkLevel]
	ld b, a
	ld a, [wEnemySDefLevel]
	jr nc, .end
; physical
	call GetPhysicalAttackStagesForCritical
	jr .end

.enemy
	ld a, [wEnemyMoveStruct + MOVE_CATEGORY]
	cp CATEGORIZE_SPECIAL
; special
	ld a, [wEnemySAtkLevel]
	ld b, a
	ld a, [wPlayerSDefLevel]
	jr nc, .end
; physical
	call GetPhysicalAttackStagesForCritical
.end
	cp b
	pop bc
	pop hl
	ret

MoveIgnoresDefenseStages_Core::
; Sacred Sword and Chip Away ignore all of the target's Defense stages.
; Their own Accuracy and the user's Attack stages still apply.
	push hl
	ld hl, .Moves
	call CheckCurrentMoveInHalfwordList_Core
	pop hl
	ret

.Moves:
	dw SACRED_SWORD
	dw CHIP_AWAY
	dw -1

ApplyDefenseIgnoringEvasion_Core::
; Sacred Sword and Chip Away treat the target's evasion as neutral while
; retaining the user's Accuracy stage.
	call MoveIgnoresDefenseStages_Core
	ret nc
	ld c, BASE_STAT_LEVEL
	ret

MoveBreaksScreens_Core::
; Returns carry for moves which remove the target's Reflect/Light Screen.
; All input registers are preserved.
	push hl
	ld hl, .Moves
	call CheckCurrentMoveInHalfwordList_Core
	pop hl
	ret

.Moves:
	dw BRICK_BREAK
	dw RAGING_BULL
	dw -1

CheckCurrentMoveInHalfwordList_Core:
; hl = halfword move list. Preserves bc and de; returns carry if present.
	push bc
	push de
	push hl
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	pop hl
	ld de, 2
	call IsInHalfwordArray
	pop de
	pop bc
	ret

ApplyDefenseIgnoringPhysicalStats_Core::
; Called after the normal current Attack/raw Defense pointers are loaded.
; Carry means the move was handled: bc is the target's raw Defense and
; hl is the user's stage-modified Attack, except that a critical hit
; ignores a negative Attack stage as usual.
	call MoveIgnoresDefenseStages_Core
	ret nc

	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy

	push hl
	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ld a, [wCriticalHit]
	and a
	jr z, .handled
	ld a, [wPlayerAtkLevel]
	cp BASE_STAT_LEVEL
	jr nc, .handled
	ld hl, wPlayerAttack
	jr .handled

.enemy
	push hl
	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ld a, [wCriticalHit]
	and a
	jr z, .handled
	ld a, [wEnemyAtkLevel]
	cp BASE_STAT_LEVEL
	jr nc, .handled
	ld hl, wEnemyAttack

.handled
	scf
	ret

BreakScreensOnHit_Core::
; Brick Break and Raging Bull remove the target's Reflect and Light Screen
; on a successful, non-immune hit. Damage calculation already skipped
; Reflect before this command runs.
	push af
	push bc
	push de
	push hl

	ld a, [wAttackMissed]
	and a
	jr nz, .done
	call MoveBreaksScreens_Core
	jr nc, .done
	ld a, [wTypeModifier]
	and $7f
	jr z, .done

	ld de, .Enemy
	ldh a, [hBattleTurn]
	and a
	jr z, .copy_target_name
	ld de, .Your
.copy_target_name
	ld hl, wStringBuffer1
	call CopyName2

	ld hl, wEnemyScreens
	ld de, wEnemyLightScreenCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_target
	ld hl, wPlayerScreens
	ld de, wPlayerLightScreenCount
.got_target
	ld a, [hl]
	and (1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)
	ld b, a
	jr z, .done
	ld a, [hl]
	and ~((1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)) & $ff
	ld [hl], a
	xor a
	ld [de], a ; Light Screen
	inc de
	ld [de], a ; Reflect

	bit SCREENS_REFLECT, b
	jr z, .light_screen
	push bc
	ld hl, BattleText_MonsReflectFaded
	call StdBattleTextbox
	pop bc
.light_screen
	bit SCREENS_LIGHT_SCREEN, b
	jr z, .done
	ld hl, BattleText_MonsLightScreenFell
	call StdBattleTextbox

.done
	pop hl
	pop de
	pop bc
	pop af
	ret

.Your:
	db "Your@"
.Enemy:
	db "Enemy@"

ApplyRagingBullType_Core::
; Raging Bull is Normal for ordinary Tauros (and other users), Fire for
; Paldean Blaze Breed Tauros, and Water for Paldean Aqua Breed Tauros.
	push af
	push bc
	push de
	push hl

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld bc, RAGING_BULL
	ld a, h
	cp b
	jr nz, .done
	ld a, l
	cp c
	jr nz, .done

	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, .got_species
	ld a, [wEnemyMonSpecies]
.got_species
	call GetPokemonIndexFromID

	ld c, NORMAL
	ld de, TAUROS_PALDEAN_FIRE
	call .CompareSpecies
	jr z, .fire
	ld de, TAUROS_PALDEAN_WATER
	call .CompareSpecies
	jr z, .water
	jr .set_type
.fire
	ld c, FIRE
	jr .set_type
.water
	ld c, WATER
.set_type
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [hl], c

.done
	pop hl
	pop de
	pop bc
	pop af
	ret

.CompareSpecies:
	ld a, h
	cp d
	ret nz
	ld a, l
	cp e
	ret

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

	; A preceding entry hazard may already have knocked the switch-in out.
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	ld a, [hli]
	or [hl]
	ret z

	farcall UserHasMagicGuard_Core
	ret z

	; e = signed number of doublings (positive) or halvings (negative),
	; starting from 1/8 max HP.
	ld e, 0
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType1
.got_types
	ld a, [hli]
	ld d, a
	call .RockVsType
	ld a, [hl]
	cp d
	jr z, .got_effectiveness ; monotypes store the same type twice
	call .RockVsType
.got_effectiveness

	push de
	ld hl, HurtByStealthRockText
	call StdBattleTextbox
	pop de

	call GetEighthMaxHP
.scale
	ld a, e
	and a
	jr z, .apply
	bit 7, e
	jr nz, .halve
	; super effective: double
	sla c
	rl b
	dec e
	jr .scale
.halve
	; resisted: halve
	srl b
	rr c
	inc e
	jr .scale
.apply
	ld a, c
	or b
	and a
	jr nz, .ok
	ld c, 1
.ok
	call SubtractHPFromTarget
	jp WaitBGMap

.RockVsType:
; Adjusts e: +1 per type Rock is strong against, -1 per resistance.
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
	inc e
	ret
.weak
	dec e
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

	; A preceding entry hazard may already have knocked the switch-in out.
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	ld a, [hli]
	or [hl]
	ret z

	call .CheckUngrounded
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

.CheckUngrounded:
; Flying types, Levitate, and Air Balloon avoid Sticky Web. Do not reuse
; CheckSpikesUngrounded_Core here: that helper also exempts Magic Guard,
; which prevents indirect damage but not a stat drop.
	ld hl, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType
.got_types
	ld a, [hli]
	cp FLYING
	jr z, .yes
	ld a, [hl]
	cp FLYING
	jr z, .yes
	farcall GetTrueUserAbility_b
	ld a, b
	cp LEVITATE
	jr z, .yes
	callfar GetUserItem
	ld a, b
	cp HELD_AIR_BALLOON
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

CheckCriticalHitMove_Core::
; bc = 16-bit move index. Returns carry if the move has a high critical-hit ratio.
; Lives here because the Effect Commands bank is full.
	ld de, 2
	ld hl, CriticalHitMoves
	jp IsInHalfwordArray

INCLUDE "data/moves/critical_hit_moves.asm"

; ============================================================
; Move Expansion: full-behaviour pass
; Brick Break / Headlong Rush screen+hazard removal, Raging Bull typing,
; Dire Claw status roll, Fickle Beam power roll, Glaive Rush drawback,
; Baneful Bunker.
; Reached via callfar from engine/battle/effect_commands.asm.
; ============================================================

BattleBreakScreens_Core:
; Shatter the target's Reflect and Light Screen. Headlong Rush additionally
; sweeps that side's entry hazards. Does nothing if the attack missed.
	ld a, [wAttackMissed]
	and a
	ret nz

	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyScreens
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens

	ld a, [hl]
	and (1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)
	jr z, .no_screens

	ld a, [hl]
	and $ff ^ ((1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN))
	ld [hl], a
	push hl
	ld hl, BrokeScreensText
	call StdBattleTextbox
	pop hl
.no_screens

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_HEADLONG_RUSH
	ret nz

	ld a, [hl]
	and $ff ^ ((1 << SCREENS_SPIKES) | (1 << SCREENS_STEALTH_ROCK) | SCREENS_TOXIC_SPIKES_MASK)
	ld [hl], a
	ret

BattleRagingBull_Core:
; The move's type follows the user's form. Base Tauros stays NORMAL.
; Species IDs are 8-bit with a 16-bit index behind them, so compare via
; GetPokemonIndexFromID like the Mimikyu check in abilities_engine.
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, .got_species
	ld a, [wEnemyMonSpecies]
.got_species
	call GetPokemonIndexFromID

	ld a, l
	cp LOW(TAUROS_PALDEAN_FIRE)
	jr nz, .not_fire
	ld a, h
	cp HIGH(TAUROS_PALDEAN_FIRE)
	jr nz, .not_fire
	ld b, FIRE
	jr .set_type

.not_fire
	ld a, l
	cp LOW(TAUROS_PALDEAN_WATER)
	ret nz
	ld a, h
	cp HIGH(TAUROS_PALDEAN_WATER)
	ret nz
	ld b, WATER

.set_type
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [hl], b
	ret

BattleFickleBeam_Core:
; 30% of the time the move fires at double power.
	call BattleRandom
	cp 30 percent
	ret nc

	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerMoveStructPower
	jr z, .got_power
	ld hl, wEnemyMoveStructPower
.got_power
	ld a, [hl]
	add a
	jr nc, .no_overflow
	ld a, 255
.no_overflow
	ld [hl], a

	ld hl, FickleBeamAllOutText
	jp StdBattleTextbox

BattleGlaiveRush_Core:
; Flag the user: until its next turn, incoming attacks cannot miss and deal
; double damage. Consumed in CheckHit / DamageCalc.
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_GLAIVE_RUSH, [hl]
	ret

BattleBanefulBunker_Core:
; Protect, plus a flag so that anything making contact gets poisoned.
	farcall BattleCommand_Protect
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret z
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_BANEFUL_BUNKER, [hl]
	ret

BanefulBunkerPoison_Core:
; Called when a move is stopped by Protect. Poisons the attacker if the
; protecting side used Baneful Bunker and the blocked move makes contact.
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVar
	bit SUBSTATUS_BANEFUL_BUNKER, a
	ret z
	farcall CheckContactMove ; carry = the move makes contact
	ret nc
	farcall BattleCommand_SwitchTurn
	farcall BattleCommand_PoisonTarget
	farcall BattleCommand_SwitchTurn
	ret

BattleDireClawStatus_Core:
; 50% chance of poison, paralysis or sleep, evenly split.
; Uses farcalls instead of a jump table so it can live outside the
; Effect Commands bank.
	farcall BattleCommand_EffectChance

.loop
	call BattleRandom
	swap a
	and %11
	jr z, .loop
	dec a
	and a
	jr z, .poison
	dec a
	jr z, .paralyze
	farcall BattleCommand_SleepTarget
	ret

.poison
	farcall BattleCommand_PoisonTarget
	ret

.paralyze
	farcall BattleCommand_ParalyzeTarget
	ret

FreezeDryOverride_Core:
; Freeze-Dry is super effective against WATER-types. The chart accumulates with
; a truncating divide, so scaling the finished matchup loses precision (Water/Ice
; lands on 0.25x instead of 0.5x). Recompute instead: score the move against the
; target's OTHER type alone and double it. Pure WATER is a flat 2x.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_FREEZE_DRY
	ret nz

	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .types
	ld hl, wBattleMonType1
.types
	ld b, [hl]
	inc hl
	ld c, [hl]

	ld a, b
	cp WATER
	jr z, .other_is_c
	ld a, c
	cp WATER
	ret nz ; not a WATER-type, nothing to override
	ld a, b
	jr .have_other
.other_is_c
	ld a, c
.have_other
	cp WATER
	jr nz, .recompute

; Pure WATER: exactly 2x.
	ld a, 20
	ld [wTypeMatchup], a
	ret

.recompute
	ld [wFreezeDryTypeScratch], a
	ld [wFreezeDryTypeScratch + 1], a
	ld hl, wFreezeDryTypeScratch
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar ; preserves hl
	farcheckmatchup
	ld a, [wTypeMatchup]
	add a
	ld [wTypeMatchup], a
	ret

FreezeDryDamage_Core:
; BattleCommand_Stab walks the type chart itself and multiplies wCurDamage as
; it goes; wTypeMatchup only drives the "super effective" message. So fixing
; the matchup was never going to change the damage - this does.
; The chart scores ICE vs WATER at 0.5x and Freeze-Dry wants 2x, which is
; exactly x4 no matter what the target's other type is, because that other
; type's multiplier is applied identically either way.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_FREEZE_DRY
	ret nz

	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wBattleMonType1
.got_types
	ld a, [hli]
	cp WATER
	jr z, .water
	ld a, [hl]
	cp WATER
	ret nz

.water
; wCurDamage is big-endian.
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld c, [hl]
	sla c
	rl b
	jr c, .cap
	sla c
	rl b
	jr c, .cap
	ld a, b
	ld [wCurDamage], a
	ld a, c
	ld [wCurDamage + 1], a
	ret

.cap
	ld a, $ff
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ret

; Hidden Power
;
; Every Pokémon stores its own Hidden Power type in its HiddenPowerType byte
; (box_struct / party_struct / battle_struct; PC records pack it into
; SAVEMON_FLAGS bits 1-5, see engine/pc/storage_codec.asm). The type is set per
; Pokémon at the Hidden Power Guy (engine/events/hidden_power_type.asm). A
; stored value of 0 means "never chosen" and resolves to
; HIDDEN_POWER_DEFAULT_TYPE. DVs play no part in any of this.
;
; The base power is always HIDDEN_POWER_BASE_POWER. The damage category is
; decided every time the move is used, from the user's current (stat-stage
; modified) stats: physical - Attack vs Defense - when Attack is higher than
; Sp.Atk, otherwise special - Sp.Atk vs Sp.Def (ties go special). The type
; only governs STAB, type effectiveness, immunities and type-based effects.
;
; The user's move struct is patched in UpdateMoveData (type, power, category),
; so every later check sees the real values; the hiddenpower effect command
; refreshes the category right before damagestats. The AI patches
; wEnemyMoveStruct the same way (HiddenPowerPatchEnemyMoveStruct).

ResolveHiddenPowerType::
; a = stored HiddenPowerType byte -> a = type constant (0 -> default)
	and a
	ret nz
	ld a, HIDDEN_POWER_DEFAULT_TYPE
	ret

GetUserHiddenPowerType::
; Return in a the type of the user's (hBattleTurn) Hidden Power.
; Transform does not copy HiddenPowerType, so a transformed user keeps its own.
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonHiddenPowerType]
	jr z, ResolveHiddenPowerType
	ld a, [wEnemyMonHiddenPowerType]
	jr ResolveHiddenPowerType

GetHiddenPowerCategory::
; bc = pointer to a big-endian Attack stat that is followed by Defense, Speed
; and Sp.Atk (a party or battle struct Stats block, wPlayerStats or wEnemyStats).
; Returns a = CATEGORIZE_PHYSICAL if Attack > Sp.Atk, else CATEGORIZE_SPECIAL.
; Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld a, [hli]
	ld d, a ; Attack (high)
	ld a, [hli]
	ld e, a ; Attack (low)
	ld bc, wPlayerSpAtk - wPlayerDefense
	add hl, bc
	ld a, [hli]
	ld b, a ; Sp.Atk (high)
	ld c, [hl] ; Sp.Atk (low)
	; physical iff de (Attack) > bc (Sp.Atk)
	ld a, d
	cp b
	jr c, .special
	jr nz, .physical
	ld a, e
	cp c
	jr c, .special
	jr z, .special
.physical
	ld a, CATEGORIZE_PHYSICAL
	jr .done
.special
	ld a, CATEGORIZE_SPECIAL
.done
	pop bc
	pop de
	pop hl
	ret

GetUserHiddenPowerCategory::
; Return in a the category the user's (hBattleTurn) Hidden Power uses right
; now, from its stat-stage modified stats. (ApplyStatLevelMultiplier writes
; the boosted stats into the battle struct - wBattleMonAttack etc.; the
; wPlayerStats / wEnemyStats blocks keep the unmodified originals.)
	push bc
	ldh a, [hBattleTurn]
	and a
	ld bc, wBattleMonAttack
	jr z, .got_stats
	ld bc, wEnemyMonAttack
.got_stats
	call GetHiddenPowerCategory
	pop bc
	ret

HiddenPowerUpdateMoveStruct::
; Called from UpdateMoveData after the user's move struct has been loaded.
; If the move is Hidden Power, overwrite its type, power and category.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_HIDDEN_POWER
	ret nz
	call GetUserHiddenPowerType
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [hl], b
	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVarAddr
	ld [hl], HIDDEN_POWER_BASE_POWER
	; fallthrough

HiddenPowerUpdateCategory::
; Store the user's current Hidden Power category in its move struct.
	call GetUserHiddenPowerCategory
	ld hl, wPlayerMoveStructCategory
	ld b, a
	ldh a, [hBattleTurn]
	and a
	jr z, .got_struct
	ld hl, wEnemyMoveStructCategory
.got_struct
	ld [hl], b
	ret

HiddenPowerDamage::
; Body of the hiddenpower effect command. The move struct already holds the
; user's type and power (UpdateMoveData); re-pick the category from the stats
; the user has at this moment, then run damagestats with it.
; Returns b/c/d/e as damagestats does (attack, defense, power, level).
	call HiddenPowerUpdateCategory
	farcall BattleCommand_DamageStats ; damagestats
	ret

HiddenPowerPatchEnemyMoveStruct::
; For the AI: if wEnemyMoveStruct holds Hidden Power, fill in the active enemy
; mon's own type, the fixed power and the category its current stats give.
; Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld a, [wEnemyMoveStructEffect]
	cp EFFECT_HIDDEN_POWER
	jr nz, .done
	ld a, [wEnemyMonHiddenPowerType]
	call ResolveHiddenPowerType
	ld [wEnemyMoveStructType], a
	ld a, HIDDEN_POWER_BASE_POWER
	ld [wEnemyMoveStructPower], a
	ld bc, wEnemyMonAttack ; stage-modified stats
	call GetHiddenPowerCategory
	ld [wEnemyMoveStructCategory], a
.done
	pop bc
	pop de
	pop hl
	ret

HiddenPowerPatchOTPartyMoveStruct::
; Like HiddenPowerPatchEnemyMoveStruct, for a move of OT party mon b (0-5)
; that is not necessarily in battle: its own type, the fixed power, and the
; category its party stats give. Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld a, [wEnemyMoveStructEffect]
	cp EFFECT_HIDDEN_POWER
	jr nz, .done
	push bc
	ld hl, wOTPartyMon1HiddenPowerType
	ld a, b
	call GetPartyLocation ; clobbers bc
	ld a, [hl]
	call ResolveHiddenPowerType
	ld [wEnemyMoveStructType], a
	ld a, HIDDEN_POWER_BASE_POWER
	ld [wEnemyMoveStructPower], a
	pop bc
	ld hl, wOTPartyMon1Attack
	ld a, b
	call GetPartyLocation
	ld b, h
	ld c, l
	call GetHiddenPowerCategory
	ld [wEnemyMoveStructCategory], a
.done
	pop bc
	pop de
	pop hl
	ret

HiddenPowerCounterCategory::
; Counter / Mirror Coat: wStringBuffer1 holds the move data of the opponent's
; last move. If that move is Hidden Power, its category is the one the
; opponent's stats picked when it was used this turn, which its move struct
; still holds - use that instead of the move table's fixed category.
	ld a, [wStringBuffer1 + MOVE_EFFECT]
	cp EFFECT_HIDDEN_POWER
	ret nz
	ldh a, [hBattleTurn]
	and a
	ld a, [wEnemyMoveStructCategory] ; the player is countering the enemy
	jr z, .got_category
	ld a, [wPlayerMoveStructCategory]
.got_category
	ld [wStringBuffer1 + MOVE_CATEGORY], a
	ret

HiddenPowerPatchPlayerLastMoveCategory::
; AI_Smart_Counter / AI_Smart_MirrorCoat load the PLAYER's last move into
; wEnemyMoveStruct (through AIGetEnemyMove, which patches Hidden Power with
; the enemy's data). If that move is Hidden Power, the category that matters
; is the one the player's stats picked when it was used - its move struct
; still holds it. Preserves bc, de, hl.
	ld a, [wEnemyMoveStructEffect]
	cp EFFECT_HIDDEN_POWER
	ret nz
	ld a, [wPlayerMoveStructCategory]
	ld [wEnemyMoveStructCategory], a
	ret

GetHiddenPowerDisplayStats::
; Returns the values a move info box should display for Hidden Power:
; b = category, c = type, d = power.
; de = pointer to the mon's HiddenPowerType byte (wTempMonHiddenPowerType on
;      the stats screen, wBattleMonHiddenPowerType in battle),
; bc = pointer to the stats to compare (wTempMonAttack: the mon's own stats;
;      wBattleMonAttack in battle: the stat-stage modified ones).
; Passed in de/bc rather than hl because farcall clobbers hl on entry.
	ld a, [de]
	call ResolveHiddenPowerType
	ld e, a
	call GetHiddenPowerCategory
	ld b, a
	ld c, e
	ld d, HIDDEN_POWER_BASE_POWER
	ret

PrintMoveAccuracyPercent::
; Print the displayed accuracy for the move info box at 6, 10.
; Accuracy is stored as "x percent" (0-255 scale); convert back to 0-100.
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wPlayerMoveStructAccuracy]
	ldh [hMultiplicand + 2], a
	ld a, 100
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 3]
	add 128 ; round to nearest
	ld d, a
	ldh a, [hProduct + 2]
	adc 0
	ldh [hDividend + 0], a
	ld a, d
	ldh [hDividend + 1], a
	ld a, 255
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld [wStringBuffer1], a
	hlcoord 6, 10
	ld de, wStringBuffer1
	lb bc, 1, 3
	jp PrintNum

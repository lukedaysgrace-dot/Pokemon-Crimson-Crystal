; Battle-only Aegislash forms. Real species, HP, DVs, experience and party
; records always remain AEGISLASH. The retired extra slot supplies Blade art
; and base stats; it is excluded from every visible Pokedex order.

ResetStanceState::
	ld hl, wPlayerBladeForm
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerBladeForm)
	ldh [rSVBK], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop af
	ldh [rSVBK], a
	ret

ResetPlayerStance::
	ld hl, wPlayerBladeForm
	jr ResetStanceByte
ResetEnemyStance::
	ld hl, wEnemyBladeForm
ResetStanceByte:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerBladeForm)
	ldh [rSVBK], a
	ld [hl], 0
	pop af
	ldh [rSVBK], a
	ret

GetUserBladeForm:
	ld hl, wPlayerBladeForm
	ldh a, [hBattleTurn]
	and a
	jr z, ReadStanceByte
	inc hl
ReadStanceByte:
; Return the banked byte in b; farcall does not preserve a.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerBladeForm)
	ldh [rSVBK], a
	ld b, [hl]
	pop af
	ldh [rSVBK], a
	ret

SetUserBladeForm:
; a = new form, preserves bc/de.
	push bc
	ld b, a
	call GetUserBladeFormAddress
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerBladeForm)
	ldh [rSVBK], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
	pop bc
	ret
GetUserBladeFormAddress:
	ld hl, wPlayerBladeForm
	ldh a, [hBattleTurn]
	and a
	ret z
	inc hl
	ret

CopyOpponentStanceForTransform::
; Transform copies the current appearance/stats and ability. Its transformed
; flag prevents Stance Change, so the copied form persists until switching.
	farcall SwitchTurn
	call GetUserBladeForm
	farcall SwitchTurn
	ld a, b
	jp SetUserBladeForm

ReapplyPlayerStanceAfterLevelUp::
; Level-up updates the saved Shield stats first, then restores the active
; Blade stats. No battle-only stats may leak into the party record.
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .done
	call GetUserBladeForm
	ld a, b
	and a
	call nz, RecalculateStanceStats
.done
	pop af
	ldh [hBattleTurn], a
	ret

OverridePlayerStanceAppearance::
	push de
	ld de, wPlayerBladeForm
	call OverrideStanceAppearance
	pop de
	ret
OverrideEnemyStanceAppearance::
	push de
	ld de, wEnemyBladeForm
	call OverrideStanceAppearance
	pop de
	ret
OverrideStanceAppearance:
; b = fallback species. Never change a copied Illusion or transformed species.
	push bc
	push de
	ld a, b
	call GetPokemonIndexFromID
	ld a, h
	cp HIGH(AEGISLASH)
	jr nz, .normal
	ld a, l
	cp LOW(AEGISLASH)
	jr nz, .normal
	pop hl
	call ReadStanceByte
	ld a, b
	pop bc
	and a
	ret z
	ld hl, AEGISLASH_BLADE
	call GetPokemonIDFromIndex
	ld b, a
	ret
.normal
	pop de
	pop bc
	ret

StanceChangeBeforeMove::
; DoTurn is reached only after sleep, paralysis, flinch, obedience and PP
; checks. Change before accuracy/protection, including a failed King's Shield.
	farcall GetTrueUserAbility_b
	ld a, b
	cp STANCE_CHANGE
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVar
	bit SUBSTATUS_TRANSFORMED, a
	ret nz
	ld hl, wBattleMonSpecies
	ldh a, [hBattleTurn]
	and a
	jr z, .user_species
	ld hl, wEnemyMonSpecies
.user_species
	ld a, [hl]
	call GetPokemonIndexFromID
	ld a, h
	cp HIGH(AEGISLASH)
	ret nz
	ld a, l
	cp LOW(AEGISLASH)
	ret nz
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld bc, KINGS_SHIELD
	farcall_a CompareMove
	ld c, 0 ; King's Shield enters Shield even if its guard will fail.
	jr z, .wanted
	farcall GetMoveCategory_b
	ld a, b
	cp CATEGORIZE_STATUS
	ret z
	ld c, 1
.wanted
	call GetUserBladeForm
	ld a, b
	cp c
	ret z
	ld a, c
	call SetUserBladeForm
	call RecalculateStanceStats
	jp PresentStanceChange

PresentStanceChange:
; Fade only the actor while its BG tiles are replaced. Uploading an entire
; front/back picture spans several VBlanks; hiding it prevents visible rows
; of the old and new forms mixing. HUDs and the other battler stay visible.
	farcall CheckBattleScene
	jr c, .instant
	ldh a, [hCGB]
	and a
	jr z, .instant
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .instant
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerMinimized]
	jr z, .minimized
	ld a, [wEnemyMinimized]
.minimized
	and a
	jr nz, .instant
	ld hl, .FadeOut
	call .fade
	; Palettes remain white throughout the complete sprite upload.
	farcall BattleCommand_RaiseSubNoAnim
	; Refresh the palette source without exposing the new colors before
	; the fade-in. ReloadBattleAnimColors also calls ApplyPals, which would
	; show a full-color frame between these two halves of the transition.
	farcall LoadAllDefaultBattlePalettes
	xor a
	call SetStanceFadePalette
	ld c, 2
	call DelayFrames
	ld hl, .FadeIn
	jp .fade
.instant
	farcall ReloadBattleAnimColors
	farcall BattleCommand_RaiseSubNoAnim
	ret
.fade
	ld a, [hli]
	cp -1
	ret z
	push hl
	call SetStanceFadePalette
	ld c, 3
	call DelayFrames
	pop hl
	jr .fade
.FadeOut
	db $90, $40, $00, -1
.FadeIn
	db $40, $90, $e4, -1

SetStanceFadePalette:
; Existing animation helpers map the actor's BG/object palettes (including
; the middle backpic row) from their untouched default colors.
	ld b, a
	ldh a, [hBattleTurn]
	and a
	ld a, b
	jr nz, .enemy
	farcall_a BGEffects_LoadBGPal0_OBPal1
	ret
.enemy
	farcall_a BGEffects_LoadBGPal1_OBPal0
	ret

RecalculateStanceStats::
; Recalculate from each stat's own DVs/stat EXP, rather than swapping final
; Attack/Defense values. Stages and burn/frostbite penalties are reapplied.
	ld a, [wCurSpecies]
	push af
	ld a, [wCurPartyLevel]
	push af
	call GetUserBladeForm
	ld a, b
	and a
	ld hl, AEGISLASH
	jr z, .species
	ld hl, AEGISLASH_BLADE
.species
	call GetPokemonIDFromIndex
	ld [wCurSpecies], a
	call GetBaseData
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wBattleMonLevel]
	ld [wCurPartyLevel], a
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1StatExp - 1
	call GetPartyLocation
	ld b, TRUE
	jr .calculate
.enemy
	ld a, [wEnemyMonLevel]
	ld [wCurPartyLevel], a
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .wild
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1StatExp - 1
	call GetPartyLocation
	ld b, TRUE
	jr .calculate
.wild
	ld hl, wEnemyMonDVs - (MON_DVS - MON_STAT_EXP + 1)
	ld b, FALSE
.calculate
	ld de, wTempMonMaxHP
	predef CalcMonStats
	ld hl, wTempMonAttack
	ld de, wPlayerStats
	ldh a, [hBattleTurn]
	and a
	jr z, .copy
	ld de, wEnemyStats
.copy
	ld bc, 10
	call CopyBytes
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_stats
	farcall CalcPlayerStats
	jr .restore
.enemy_stats
	farcall CalcEnemyStats
.restore
	pop af
	ld [wCurPartyLevel], a
	pop af
	ld [wCurSpecies], a
	jp GetBaseData

GetOpponentKingsShield:
	ld hl, wKingsShieldFlags
	call ReadStanceByte
	ldh a, [hBattleTurn]
	and a
	ld a, b
	jr nz, .player
	srl a
.player
	and 1
	ld b, a
	ret

KingsShieldAllowsStatus::
; b = 1 when the protected target's King's Shield lets this status through.
	call GetOpponentKingsShield
	ld a, b
	and a
	ret z
	farcall GetMoveCategory_b
	ld a, b
	cp CATEGORIZE_STATUS
	ld b, 0
	ret nz
	inc b
	ret

ClearUserKingsShield::
	ld c, 0
	jr SetKingsShieldFlag
MarkUserKingsShield::
	ld c, 0
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld bc, KINGS_SHIELD
	farcall_a CompareMove
	ld c, 0
	jr nz, SetKingsShieldFlag
	inc c
SetKingsShieldFlag:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wKingsShieldFlags)
	ldh [rSVBK], a
	ld hl, wKingsShieldFlags
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	res 0, [hl]
	ld a, c
	and a
	jr z, .done
	set 0, [hl]
	jr .done
.enemy
	res 1, [hl]
	ld a, c
	and a
	jr z, .done
	set 1, [hl]
.done
	pop af
	ldh [rSVBK], a
	ret

KingsShieldPunish::
; The turn holder is the attacker whose move was blocked. Modern King's
; Shield lowers Attack one stage on moves that make contact.
	call GetOpponentKingsShield
	ld a, b
	and a
	ret z
	farcall CheckContactMove
	ret nc
	ld a, [wAttackMissed]
	push af
	ld a, [wEffectFailed]
	push af
	ld a, [wFailedMessage]
	push af
	ld a, [wEntryWebStatDrop]
	push af
	; The blocked hit may already carry a type-immunity/miss marker. That
	; prevents damage, but must not cancel the guard's separate contact drop.
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wFailedMessage], a
	; A contact attacker is punished even through its own Substitute.
	ld a, 1
	ld [wEntryWebStatDrop], a
	farcall SwitchTurn
	ld b, ATTACK
	farcall AbilityLowerOppStat
	farcall SwitchTurn
	pop af
	ld [wEntryWebStatDrop], a
	pop af
	ld [wFailedMessage], a
	pop af
	ld [wEffectFailed], a
	pop af
	ld [wAttackMissed], a
	ret

; Illusion is presentation only. Never replace a battle species, types, DVs,
; stats, moves, held item, or saved party data with the disguise's data.
; Slots are stored plus one; zero means no active illusion. Rebuilt on entry.

InitBattleMonWithIllusion::
; Relocated from the full Battle Core bank to leave room for display hooks.
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld de, wBattleMonSpecies
	ld bc, MON_ID
	call CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, wBattleMonDVs
	ld bc, MON_PKRUS - MON_DVS
	call CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, wBattleMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	call CopyBytes
	ld a, [wBattleMonSpecies]
	ld [wTempBattleMonSpecies], a
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseType1]
	ld [wBattleMonType1], a
	ld a, [wBaseType2]
	ld [wBattleMonType2], a
	call SetPlayerAbility
	ld hl, wPartyMonNicknames
	ld a, [wCurBattleMon]
	call SkipNames
	ld de, wBattleMonNick
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld hl, wBattleMonAttack
	ld de, wPlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	call CopyBytes
	farcall ApplyStatusEffectOnPlayerStats
	jp InitPlayerIllusion

IllusionPlayerPalette::
	farcall GetPartyMonDVs
	ld a, [wTempBattleMonSpecies]
	ld b, a
	and a
	ret z ; trainer/player backpic before a Pokemon enters
	call GetPlayerIllusionSlot
	ret z
	jp OverridePlayerIllusionAppearance
IllusionEnemyPalette::
	farcall GetEnemyMonDVs
	ld a, [wTempEnemyMonSpecies]
	ld b, a
	and a
	ret z
	call GetEnemyIllusionSlot
	ret z
	jp OverrideEnemyIllusionAppearance

ResetIllusionState::
	ldh a, [hBattleTurn]
	push af
	call SetPlayerTurn
	xor a
	call SetUserIllusionSlot
	call SetEnemyTurn
	xor a
	call SetUserIllusionSlot
	pop af
	ldh [hBattleTurn], a
	ret

GetPlayerIllusionSlot:
	push hl
	ld hl, wPlayerIllusionSlot
	jr GetIllusionSlot
GetEnemyIllusionSlot:
	push hl
	ld hl, wEnemyIllusionSlot
GetIllusionSlot:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerIllusionSlot)
	ldh [rSVBK], a
	ld a, [hl]
	ld l, a
	pop af
	ldh [rSVBK], a
	ld a, l
	pop hl
	and a
	ret

SetUserIllusionSlot:
; a = slot plus one (zero clears). Preserves all registers.
	push hl
	push bc
	ld b, a
	ld hl, wPlayerIllusionSlot
	ldh a, [hBattleTurn]
	and a
	jr z, .slot
	inc hl
.slot
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerIllusionSlot)
	ldh [rSVBK], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
	ld a, b
	pop bc
	pop hl
	ret

InitPlayerIllusion::
	ldh a, [hBattleTurn]
	push af
	call SetPlayerTurn
	call InitUserIllusion
	pop af
	ldh [hBattleTurn], a
	ret
InitEnemyIllusion::
	ldh a, [hBattleTurn]
	push af
	call SetEnemyTurn
	call InitUserIllusion
	pop af
	ldh [hBattleTurn], a
	ret

InitUserIllusion:
	xor a
	call SetUserIllusionSlot
	; The first enemy is drawn before the player has entered. Its old ability
	; byte can still belong to the previous battle; check suppression once
	; both real battlers are installed by RunEntryAbilities instead.
	ldh a, [hBattleTurn]
	and a
	jr z, .effective
	ld a, [wBattleHasJustStarted]
	and a
	jr z, .effective
	ld a, [wEnemyAbility]
	ld b, a
	jr .ability
.effective
	farcall GetTrueUserAbility_b
.ability
	ld a, b
	cp ILLUSION
	ret nz
	ldh a, [hBattleTurn]
	and a
	ld a, [wPartyCount]
	ld hl, wPartyMon1HP
	ld de, wCurBattleMon
	jr z, .party
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	ret nz ; a wild Pokemon has no party to impersonate
	ld a, [wOTPartyCount]
	ld hl, wOTPartyMon1HP
	ld de, wCurOTMon
.party
	and a
	ret z
	dec a
	ld c, a
.find
	push hl
	ld hl, wPartySpecies
	ldh a, [hBattleTurn]
	and a
	jr z, .species
	ld hl, wOTPartySpecies
.species
	push bc
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	pop bc
	pop hl
	jr z, .next
	push hl
	push bc
	ld a, c
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop hl
	jr nz, .found
.next
	ld a, c
	and a
	ret z
	dec c
	jr .find
.found
	ld a, [de]
	cp c
	ret z ; the last conscious Pokemon is the user itself
	ld a, c
	inc a
	call SetUserIllusionSlot
	ldh a, [hBattleTurn]
	and a
	ld hl, wPartyMonNicknames
	ld de, wBattleMonNick
	jr z, .name
	ld a, c
	jp IllusionCopyEnemyName
.name
	ld a, c
	call SkipNames
	ld bc, MON_NAME_LENGTH
	jp CopyBytes

OverridePlayerIllusionAppearance::
; b = fallback species. Returns cosmetic species/DVs in b/hl.
; Set hl here: the farcall macro uses hl to dispatch, not to pass arguments.
	ld hl, wBattleMonDVs
	call GetPlayerIllusionSlot
	ret z
	dec a
	ld hl, wPartyMon1Species
	jr OverrideIllusionAppearance
OverrideEnemyIllusionAppearance::
	ld hl, wEnemyMonDVs
	call GetEnemyIllusionSlot
	ret z
	dec a
	ld hl, wOTPartyMon1Species
OverrideIllusionAppearance:
	push de
	push bc
	call GetPartyLocation
	ld d, [hl]
	ld bc, MON_DVS
	add hl, bc
	pop bc
	ld b, d
	pop de
	ret

GetPlayerIllusionGender::
; b = real gender flags; return the same flags as GetGenderFromFlags.
	ld de, wPartyMon1Species
	call GetPlayerIllusionSlot
	jr IllusionGender
GetEnemyIllusionGender::
	ld de, wOTPartyMon1Species
	call GetEnemyIllusionSlot
IllusionGender:
	jr nz, .disguised
	farcall GetGenderFromFlags
	ret
.disguised
	dec a
	ld h, d
	ld l, e
	call GetPartyLocation
	ld d, [hl] ; cosmetic species
	ld bc, MON_UNUSED
	add hl, bc
	ld b, [hl] ; cosmetic gender flags
	ld a, d
	call IllusionGenderRatio
	ld d, a
	; GetGenderFromFlags also needs the cosmetic species' gender ratio.
	; Restore the real ratio immediately: the HUD's EXP bar needs the real
	; base data, so loading the disguise's full base data here is incorrect.
	ld a, [wBaseGender]
	push af
	ld a, d
	ld [wBaseGender], a
	farcall GetGenderFromFlags
	pop bc
	ld a, b
	ld [wBaseGender], a ; ld/pop preserve the returned carry/zero flags
	ret

IllusionGenderRatio:
; d = cosmetic species, returns a = its gender ratio, preserving bc.
	push bc
	ld a, d
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	ld de, BASE_GENDER
	add hl, de
	call GetFarByte
	pop bc
	ret

CheckIllusionTransformBlocked::
; b = nonzero if either battler is disguised. Transform/Imposter must fail.
	call GetUserIllusionSlot
	jr nz, .done
	ldh a, [hBattleTurn]
	and a
	jr nz, .player
	call GetEnemyIllusionSlot
	jr .done
.player
	call GetPlayerIllusionSlot
.done
	ld b, a
	ret

IllusionDirectHit::
; Called only after a connected damaging hit reached the holder, including
; fainting hits, fixed damage, Future Sight and every hit of a multi-hit move.
	farcall SwitchTurn
	call GetUserIllusionSlot
	jr z, .done
	farcall GetTrueUserAbility_b
	ld a, b
	cp ILLUSION
	jr nz, .done
	call RevealUserIllusion
	; A fainted holder reveals itself but cannot receive a stat increase.
	farcall UserHasFainted
	jr z, .done
	farcall BeginAbility
	ld b, SPEED
	farcall StatUpAbility
	farcall EndAbility
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
.done
	farcall SwitchTurn
	ret

GetUserIllusionSlot:
	ldh a, [hBattleTurn]
	and a
	jp z, GetPlayerIllusionSlot
	jp GetEnemyIllusionSlot

CheckIllusionSuppression::
; Ability loss/suppression reveals without the direct-hit Speed reward.
; Losing Gas never creates a new disguise; only a new entry does that.
	call .side
	farcall SwitchTurn
	call .side
	farcall SwitchTurn
	ret
.side
	call GetUserIllusionSlot
	ret z
	farcall GetTrueUserAbility_b
	ld a, b
	cp ILLUSION
	ret z
	; A replacement has already loaded new data; entry clears its slot.
	jp RevealUserIllusion

RevealUserIllusion:
	; Keep copied graphics/palette/name active until the in-animation swap cue.
	call PlayIllusionBreakAnimation
.animation_done
	; With battle animations disabled the in-script cue was skipped.
	call GetUserIllusionSlot
	call nz, IllusionRevealDuringWarp
	; Refresh animated frontpic frames only after LCD distortion has ended.
	farcall BattleCommand_RaiseSubNoAnim
	call UpdateBattleHuds
	ld hl, IllusionBrokeText
	jp StdBattleTextbox

IllusionRevealDuringWarp::
; Invoked at Transform's picture-update cue while the wave settles. The
; interpreter has WRAM5 selected, but battler/party data is in WRAM1.
	ldh a, [rSVBK]
	push af
	ldh a, [hLCDCPointer]
	push af
	xor a
	ldh [hLCDCPointer], a
	ld a, BANK(wEnemyMon)
	ldh [rSVBK], a
.swap
	xor a
	call SetUserIllusionSlot ; clear before loading the real graphics and boost
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurBattleMon]
	ld hl, wPartyMonNicknames
	ld de, wBattleMonNick
	jr z, .name
	ld a, [wCurOTMon]
	call IllusionCopyEnemyName
	jr .graphics
.name
	call SkipNames
	ld bc, MON_NAME_LENGTH
	call CopyBytes
.graphics
	; Directly reload the real species' palette, without any flash/inversion.
	farcall ReloadBattleAnimColors
	pop af
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	ldh [hLCDCPointer], a
	ret

PrepareIllusionRevealPic::
; Buffer the real pic before arming the wave, as Transform does. Never wait
; for graphics with WRAM1 selected while the bank-5 LCD effect is running.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wEnemyMon)
	ldh [rSVBK], a
	ld a, [wCurPartySpecies]
	push af
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .copy_player
	ld a, [wPlayerMinimized]
	and a
	jr nz, .copy_player
	ld a, [wBattleMonSpecies]
	ld [wCurPartySpecies], a
	ld hl, wBattleMonDVs
	predef GetUnownLetter
	ld de, vTiles0
	predef GetMonBackpic
	jr .done
.enemy
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .copy_enemy
	ld a, [wEnemyMinimized]
	and a
	jr nz, .copy_enemy
	ld a, [wEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
	ld de, vTiles0
	predef GetMonFrontpic
	jr .done
.copy_player
	ld de, vTiles2 tile $31
	ld c, 6 * 6
	jr .copy
.copy_enemy
	ld de, vTiles2
	ld c, 7 * 7
.copy
	ld hl, vTiles0
	ld b, 0
	call Request2bpp
.done
	pop af
	ld [wCurPartySpecies], a
	pop af
	ldh [rSVBK], a
	ret

PlayIllusionBreakAnimation:
; This presentation must not consume a hit or overwrite the attacking move's
; animation context, particularly during multi-hit and secondary-effect moves.
	ld a, [wNumHits]
	push af
	ld a, [wBattleAnimParam]
	push af
	ld a, [wFXAnimID]
	push af
	ld a, [wFXAnimID + 1]
	push af
	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	ld a, LOW(ANIM_ILLUSION_BREAK)
	ld [wFXAnimID], a
	ld a, HIGH(ANIM_ILLUSION_BREAK)
	ld [wFXAnimID + 1], a
	predef PlayBattleAnim
	pop af
	ld [wFXAnimID + 1], a
	pop af
	ld [wFXAnimID], a
	pop af
	ld [wBattleAnimParam], a
	pop af
	ld [wNumHits], a
	ret

BattleAnim_IllusionBreak:
; Transform's wave grows, the real sprite/palette appears at its update cue,
; then the wave contracts around the real Pokemon. No palette flash.
	anim_1gfx ANIM_GFX_HIT
	; Inline Transform's opposite-mon protection: animation calls are local
	; to their script bank, while this script lives beside the Illusion code.
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_transform
	anim_sound 0, 0, SFX_SPITE
	anim_bgeffect ANIM_BG_WAVE_DEFORM_USER, $0, $1, $0
	anim_wait 40
	anim_updateactorpic
	anim_incbgeffect ANIM_BG_WAVE_DEFORM_USER
	anim_wait 40
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

IllusionCopyEnemyName:
; a = OT party slot. Regular NPC trainers have no stored nicknames.
	ld c, a
	ld a, [wLinkMode]
	and a
	jr nz, .nickname
	ld a, [wInBattleTowerBattle]
	bit 0, a
	jr nz, .nickname
	ld hl, wOTPartyMon1Species
	ld a, c
	call GetPartyLocation
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, wStringBuffer1
	jr .copy
.nickname
	ld hl, wOTPartyMonNicknames
	ld a, c
	call SkipNames
.copy
	ld de, wEnemyMonNick
	ld bc, MON_NAME_LENGTH
	jp CopyBytes

BattleCommand_ClearHazards:
; clearhazards

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_leeched
	res SUBSTATUS_LEECH_SEED, [hl]
	ld hl, ShedLeechSeedText
	call StdBattleTextbox
.not_leeched

	ld hl, wPlayerScreens
	ld de, wPlayerWrapCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens_wrap
	ld hl, wEnemyScreens
	ld de, wEnemyWrapCount
.got_screens_wrap
	; Each hazard is checked independently (toxic spikes used to be
	; cleared only when regular spikes were also present).
	ld a, [hl]
	and SCREENS_TOXIC_SPIKES_MASK
	jr z, .no_toxic_spikes
	ld a, [hl]
	and $ff ^ SCREENS_TOXIC_SPIKES_MASK
	ld [hl], a
	push hl
	push de
	ld hl, BlewToxicSpikesText
	call StdBattleTextbox
	pop de
	pop hl
.no_toxic_spikes
	bit SCREENS_SPIKES, [hl]
	jr z, .no_spikes
	res SCREENS_SPIKES, [hl]
	push hl
	push de
	call ClearUserSpikesLayers
	ld hl, BlewSpikesText
	call StdBattleTextbox
	pop de
	pop hl
.no_spikes
	bit SCREENS_STICKY_WEB, [hl]
	jr z, .no_sticky_web
	res SCREENS_STICKY_WEB, [hl]
	push hl
	push de
	ld hl, BlewStickyWebText
	call StdBattleTextbox
	pop de
	pop hl
.no_sticky_web
	bit SCREENS_STEALTH_ROCK, [hl]
	jr z, .no_stealth_rock
	res SCREENS_STEALTH_ROCK, [hl]
	push de
	ld hl, BlewStealthRockText
	call StdBattleTextbox
	pop de
.no_stealth_rock

	ld a, [de]
	and a
	ret z
	xor a
	ld [de], a
	ld hl, ReleasedByText
	jp StdBattleTextbox

ClearUserSpikesLayers:
; zero the spikes layer count on the user's side
	push hl
	ld hl, wPlayerSpikesLayers
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemySpikesLayers
.got_side
	xor a
	ld [hl], a
	pop hl
	ret

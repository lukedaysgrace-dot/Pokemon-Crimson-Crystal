; Small helpers kept out of the full Battle Core bank.

CheckSleepingTreeMon:
; Return carry if species is in the list
; for the current time of day

; Don't do anything if this isn't a tree encounter
	ld a, [wBattleType]
	cp BATTLETYPE_TREE
	jr nz, .NotSleeping

	ld a, [wTempEnemyMonSpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l

; Get list for the time of day
	ld hl, AsleepTreeMonsMorn
	ld a, [wTimeOfDay]
	cp DAY_F
	jr c, .Check
	ld hl, AsleepTreeMonsDay
	jr z, .Check
	ld hl, AsleepTreeMonsNite

.Check:
	ld de, 2 ; length of species id
	call IsInHalfwordArray
; If it's a match, the opponent is asleep
	ret c

.NotSleeping:
	and a
	ret

INCLUDE "data/wild/treemons_asleep.asm"

CheckContestBattleOver:
; Also covers the SAFARI ZONE, which shares the ball counter.
	ld a, [wBattleType]
	cp BATTLETYPE_CONTEST
	jr z, .check_balls
	cp BATTLETYPE_SAFARI
	jr nz, .contest_not_over
.check_balls
	ld a, [wParkBallsRemaining]
	and a
	jr nz, .contest_not_over
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	scf
	ret

.contest_not_over
	and a
	ret

HandleOpponentBerserkGene_Core::
	ldh a, [hBattleTurn]
	push af
	xor 1
	ldh [hBattleTurn], a
	call HandleUserBerserkGene_Core
	pop af
	ldh [hBattleTurn], a
	ret

HandleUserBerserkGene_Core::
; Reusable, Mewtwo-only item: strictly below half HP, once per entry.
; Preserve the in-progress move's stat/failure state and multi-hit count.
	push bc
	push de
	push hl
	call .check
	pop hl
	pop de
	pop bc
	ret

.check
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonItem]
	jr z, .item
	ld a, [wEnemyMonItem]
.item
	cp BERSERK_GENE
	ret nz
	farcall GetTrueUserAbility_b
	ld a, b
	cp KLUTZ
	ret z
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, .species
	ld a, [wEnemyMonSpecies]
.species
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(MEWTWO)
	ret nz
	ld a, h
	cp HIGH(MEWTWO)
	ret nz
	ld hl, wBattleMonHP
	ld de, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .hp
	ld hl, wEnemyMonHP
	ld de, wEnemyMonMaxHP
.hp
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	ret z ; fainted holders cannot activate
	; HP * 2 < max HP (including odd maximum HP).
	sla c
	rl b
	ret c
	ld a, [de]
	cp b
	jp c, .done
	jr nz, .below_half
	inc de
	ld a, [de]
	cp c
	jp z, .done
	jp c, .done
.below_half
	ldh a, [hBattleTurn]
	ld c, a
	farcall ReadItemStateFlags
	bit ITEMSTATE_BERSERK_GENE_USED, b
	ret nz
	set ITEMSTATE_BERSERK_GENE_USED, b
	farcall WriteItemStateFlags
	ld a, [wLoweredStat]
	push af
	ld a, [wFailedMessage]
	push af
	ld a, [wAttackMissed]
	push af
	ld a, [wEffectFailed]
	push af
	ld a, [wNumHits]
	push af
	ld b, ATTACK
	call .raise
	push af
	ld b, SP_ATTACK
	call .raise
	pop bc ; b = whether Attack rose, a = whether Special Attack rose
	ld hl, BattleText_BerserkGeneRaisedBoth
	and a
	jr z, .attack_only
	bit 0, b
	jr nz, .message
	ld hl, BattleText_BerserkGeneRaisedSpAttack
	jr .message
.attack_only
	bit 0, b
	jr z, .restore
	ld hl, BattleText_BerserkGeneRaisedAttack
.message
	call StdBattleTextbox
.restore
	pop af
	ld [wNumHits], a
	pop af
	ld [wEffectFailed], a
	pop af
	ld [wAttackMissed], a
	pop af
	ld [wFailedMessage], a
	pop af
	ld [wLoweredStat], a
.done
	ret

.raise
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	jr nz, .no_raise
	ld a, [wLoweredStat]
	bit 7, a ; Contrary already handled its drop animation/message
	jr nz, .no_raise
	farcall PlayStatUpAnim_Core
	ld a, 1
	ret
.no_raise
	xor a
	ret

ComputeEnemyHPPercentage:
; Compute hMultiplicand * 100 / max HP without ever using a zero divisor.
; Shift the 16-bit divisor and multiplier together until the divisor fits
; in one byte. For max HP below 256 (including 1-3), no shift is needed.
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	ld c, 100
	and a
	jr z, .shift_done
.shift
	rra
	rr b
	srl c
	and a
	jr nz, .shift
.shift_done
	ld a, c
	ldh [hMultiplier], a
	call Multiply
	ld a, b
	ld b, 4
	ldh [hDivisor], a
	jp Divide

CheckTargetFaintedWithCheat::
	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, CheckBattleHPIsZero_Overflow

CheckPlayerFaintedWithCheat::
	ld hl, wBattleMonHP
	ld a, [wPlayerInvincibleCheat]
	and a
	jr z, CheckBattleHPIsZero_Overflow
	ld a, [hli]
	or [hl]
	ret nz
	call KeepPlayerAtOneHP
	ret

CheckBattleHPIsZero_Overflow:
	ld a, [hli]
	or [hl]
	ret

KeepPlayerAtOneHP::
; The battle struct and party struct are separate copies. Keep both at 1 HP
; immediately so ending one battle and starting another cannot make party
; validation see a fainted active mon while the invincibility cheat says it
; survived.
	push bc
	xor a
	ld [wBattleMonHP], a
	inc a
	ld [wBattleMonHP + 1], a
	ld hl, wPartyMon1HP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

_BattleRandom::
; If the normal RNG is used in a link battle it'll desync.
; To circumvent this a shared PRNG is used instead.

IF DEF(DEBUG_BATTLE)
; Battle tester RNG control: forced mode returns a fixed value, seeded mode
; runs the deterministic link-battle PRNG stream even out of link mode.
	ldh a, [hDebugRNGMode]
	and a
	jr z, .no_debug_rng
	dec a
	jr nz, .debug_prng ; mode 2+: deterministic stream
	ldh a, [hDebugRNGValue]
	ret
.no_debug_rng
ENDC

; But if we're in a non-link battle we're safe to use it
	ld a, [wLinkMode]
	and a
	jp z, Random

IF DEF(DEBUG_BATTLE)
.debug_prng
ENDC
; The PRNG operates in streams of 10 values.

; Which value are we trying to pull?
	push hl
	push bc
	ld a, [wLinkBattleRNCount]
	ld c, a
	ld b, 0
	ld hl, wLinkBattleRNs
	add hl, bc
	inc a
	ld [wLinkBattleRNCount], a

; If we haven't hit the end yet, we're good
	cp 10 - 1 ; Exclude last value. See the closing comment
	ld a, [hl]
	pop bc
	pop hl
	ret c

; If we have, we have to generate new pseudorandom data
; Instead of having multiple PRNGs, ten seeds are used
	push hl
	push bc
	push af

; Reset count to 0
	xor a
	ld [wLinkBattleRNCount], a
	ld hl, wLinkBattleRNs
	ld b, 10 ; number of seeds

; Generate next number in the sequence for each seed
; a[n+1] = (a[n] * 5 + 1) % 256
.loop
	; get last #
	ld a, [hl]

	; a * 5 + 1
	ld c, a
	add a
	add a
	add c
	inc a

	; update #
	ld [hli], a
	dec b
	jr nz, .loop

; This has the side effect of pulling the last value first,
; then wrapping around. As a result, when we check to see if
; we've reached the end, we check the one before it.

	pop af
	pop bc
	pop hl
	ret

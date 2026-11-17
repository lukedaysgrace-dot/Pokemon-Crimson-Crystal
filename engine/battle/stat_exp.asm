ApplyTrainerStatExpCore::
; de = mon's party-struct base. Called before CalcMonStats constructs its
; actual stats. This never changes levels, moves, DVs, badges or save fields.
	ld a, [wMonType]
	and $f
	cp OTPARTYMON
	ret nz
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz
	push de
	ld de, ENGINE_HARD_MODE
	ld b, CHECK_FLAG
	farcall EngineFlagAction
	ld a, c
	pop de
	and a
	jr z, .fixed
	call GetTrainerStatExpMatchingPolicy
	jr c, .match_party
.fixed
; Ordinary classes retain their authored, level-bounded training. Normal
; Mode's lookup returns zero and clears every word, even on reused structs.
	push de
	farcall GetTrainerStatExp
	pop hl
	ld de, MON_STAT_EXP
	add hl, de
	ld d, NUM_EXP_STATS
.fixed_stat
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	dec d
	jr nz, .fixed_stat
	ret
.match_party
	ld b, a ; point bonus: 0 for Cooltrainers/Duelists, 2 for major characters
	ld h, d
	ld l, e
	ld de, MON_STAT_EXP
	add hl, de
	ld c, 0 ; byte offset into the player's five Stat EXP words
.matched_stat
	push hl
	call GetPlayerMaximumStatExp
	ld a, b
	and a
	call nz, AddTrainerStatExpPointBonus
	pop hl
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	inc c
	inc c
	ld a, c
	cp NUM_EXP_STATS * 2
	jr c, .matched_stat
	ret

GetTrainerStatExpMatchingPolicy::
; Carry = a matching policy exists; a = point bonus. Preserves de.
	ld a, [wOtherTrainerClass]
	ld c, a
	ld hl, TrainerStatExpMatchingPolicy
.next
	ld a, [hli]
	cp $ff
	jr z, .fixed
	cp c
	jr z, .found
	inc hl
	jr .next
.found
	ld a, [hl]
	scf
	ret
.fixed
	and a
	ret

GetPlayerMaximumStatExp::
; c = byte offset (0/2/4/6/8); de = highest non-Egg party training word.
; Preserves bc. Each stat is independent; fainted members remain eligible.
	push bc
	ld de, 0
	ld a, [wPartyCount]
	and a
	jr z, .done
	cp PARTY_LENGTH + 1
	jr nc, .done
	ld b, a
	ld hl, wPartyMon1
.mon
	push hl
	push bc
	ld a, [wPartyCount]
	sub b
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	and a
	jr z, .next_mon
	cp EGG
	jr z, .next_mon
	push hl
	push bc
	ld b, 0
	add hl, bc
	ld bc, MON_STAT_EXP
	add hl, bc
	ld a, [hli]
	cp d
	jr c, .keep_maximum
	jr nz, .new_maximum
	ld a, [hl]
	cp e
	jr c, .keep_maximum
.new_maximum
	ld a, [hld]
	ld e, a
	ld d, [hl]
.keep_maximum
	pop bc
	pop hl
.next_mon
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, .mon
.done
	pop bc
	ret

AddTrainerStatExpPointBonus::
; de = player's word, b = positive point bonus. Return de = the square
; threshold for that many extra points, saturating at $ffff. Never uses a
; flat raw-EXP increment: that would be disproportionately strong early.
; Preserves bc. Cooltrainers/Duelists bypass this and copy the exact word.
	push bc
	push bc
	farcall GetSquareRoot
	srl b
	srl b
	ld a, b
	pop bc
	add b
	cp 63
	jr nc, .maximum
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, 0
	call AddNTimes ; hl = (4 * points) squared
	ld d, h
	ld e, l
	jr .done
.maximum
	ld de, $ffff
.done
	pop bc
	ret

INCLUDE "data/trainers/stat_exp_matching.asm"

MarkPartyStatExpRecalculation::
	push bc
	ld b, SET_FLAG
	jr SetPartyStatExpRecalculationFlag

ClearPartyStatExpRecalculation::
; Level-ups already calculated all stats using the latest Stat EXP. A later
; award (including the EXP Share pass of the same KO) can mark this slot again.
	push bc
	ld b, RESET_FLAG
SetPartyStatExpRecalculationFlag:
	ld a, [wCurPartyMon]
	ld c, a
	ld hl, wPendingStatExpRecalcs
	predef SmallFarFlagAction
	pop bc
	ret

RecalculatePartyStatExpAfterBattle::
; Only actual recipients need refreshing. Fainted recipients of an earlier
; KO still need their stats updated, but must stay fainted. Never read battle
; stats: they may contain stages, status penalties, Transform or Blade form.
	ld a, [wPendingStatExpRecalcs]
	and a
	ret z
	ld a, [wCurPartyMon]
	push af
	ld a, [wCurPartyLevel]
	push af
	ld a, [wCurSpecies]
	push af
	xor a
	ld [wCurPartyMon], a
.loop
	ld hl, wPendingStatExpRecalcs
	srl [hl]
	call c, .Recalculate
	ld hl, wCurPartyMon
	inc [hl]
	ld a, [wPartyCount]
	cp [hl]
	jr nz, .loop
	xor a
	ld [wPendingStatExpRecalcs], a
	pop af
	ld [wCurSpecies], a
	pop af
	ld [wCurPartyLevel], a
	pop af
	ld [wCurPartyMon], a
	ret

.Recalculate:
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push bc ; original HP; zero must remain zero
	ld a, [hli]
	ld d, a
	ld a, [hl]
	sub c
	ld c, a
	ld a, d
	sbc b
	ld b, a
	push bc ; damage taken = old maximum - current HP
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	; Uses the normal stat-mode-aware base data, DVs and five Stat EXP words.
	farcall UpdateStatsAfterItem
	pop bc ; damage taken
	pop de ; original HP
	ld a, d
	or e
	ret z
	ld a, MON_MAXHP + 1
	call GetPartyParamLocation
	ld a, [hld]
	sub c
	ld e, a
	ld a, [hl]
	sbc b
	ld d, a
	; Stat EXP only increases stats. Guard against stale/inconsistent old
	; maxima as well, so recalculation itself cannot knock a living mon out.
	jr c, .minimum_hp
	or e
	jr nz, .store_hp
.minimum_hp
	ld de, 1
.store_hp
	dec hl
	ld a, e
	ld [hld], a
	ld [hl], d
	ret

DivideExperienceAndStatExp::
; count number of battle participants
	ld a, [wBattleParticipantsNotFainted]
	ld b, a
	ld c, PARTY_LENGTH
	ld de, 0
.count_loop
	push bc
	push de
	ld a, e
	ld hl, wPartyMon1Level
	call GetPartyLocation
	ld a, [wLevelCap]
	ld b, a
	ld a, [hl]
	cp b
	pop de
	pop bc
	jr c, .gains_exp
	srl b
	ld a, d
	jr .no_exp

.gains_exp
	xor a
	srl b
	adc d
	ld d, a
.no_exp
	inc e
	dec c
	jr nz, .count_loop
; EXP excludes capped participants, but Stat EXP must still be divided
; among every living participant. Otherwise switching in capped mons
; duplicates training (all six capped participants used to get a full award).
	ld a, [wBattleParticipantsNotFainted]
	ld b, a
	ld c, PARTY_LENGTH
	ld e, 0
.count_stat_recipients
	srl b
	jr nc, .next_stat_recipient
	inc e
.next_stat_recipient
	dec c
	jr nz, .count_stat_recipients
	ld hl, wEnemyMonBaseStats
	ld c, wEnemyMonShinyGenderFlags - wEnemyMonBaseStats ; fits wBackupEnemyMonBaseStats
.base_stat_division_loop
; The last byte is base EXP; the preceding base-stat/catch-rate bytes use
; the Stat EXP recipient count. A zero denominator has no recipients, so
; leaving those unused bytes undivided is harmless and avoids Divide by zero.
	ld a, c
	cp 1
	ld a, d
	jr z, .got_divisor
	ld a, e
.got_divisor
	and a
	jr nz, .nonzero_divisor
	inc a
.nonzero_divisor
	ldh [hDivisor], a
	xor a
	ldh [hDividend + 0], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld [hli], a
	dec c
	jr nz, .base_stat_division_loop
	ret

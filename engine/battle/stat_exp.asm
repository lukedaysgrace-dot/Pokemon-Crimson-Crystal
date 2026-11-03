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

; The ten retired slots are deliberately reused. All unrelated saved indexes
; stay stable. The extra retired Espathra slot now contains battle-only Blade
; data, so old saved Espathra are read as Sableye instead. Save layout stays v5.

NormalizeRetiredRosterIndexDE::
; Save-ingress only. Never apply this to graphics/base-data lookups.
; Preserves bc; de is the canonical saved species index.
	ld a, d
	cp HIGH(AEGISLASH_BLADE)
	ret nz
	ld a, e
	cp LOW(AEGISLASH_BLADE)
	ret nz
	ld de, SABLEYE
	ret

NormalizeLoadedRoster::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPokemonIndexTable)
	ldh [rSVBK], a
	ld hl, wPokemonIndexTableEntries
	ld b, MON_TABLE_ENTRIES
.indexes
	ld e, [hl]
	inc hl
	ld d, [hl]
	push hl
	call NormalizeRetiredRosterIndexDE
	pop hl
	ld [hl], d
	dec hl
	ld [hl], e
	inc hl
	inc hl
	dec b
	jr nz, .indexes
	ld a, BANK(wPokedexSeen)
	ldh [rSVBK], a
	ld de, AEGISLASH_BLADE
	call CheckSeenMonIndex
	jr z, .caught
	ld de, SABLEYE
	call SetSeenMonIndex
.caught
	ld de, AEGISLASH_BLADE
	call CheckCaughtMonIndex
	jr z, .clear_hidden
	ld de, SABLEYE
	call SetCaughtMonIndex
.clear_hidden
	ld hl, wPokedexSeen
	ld de, AEGISLASH_BLADE - 1
	ld b, RESET_FLAG
	call FlagAction
	ld hl, wPokedexCaught
	ld de, AEGISLASH_BLADE - 1
	ld b, RESET_FLAG
	call FlagAction
	call RecalculateReplacementPartyStats
	pop af
	ldh [rSVBK], a
	ret

RecalculateReplacementPartyStats:
; Existing saves must not retain retired species' stats after remapping.
; Keep current HP (clamped to the new maximum), moves, items, nickname and DVs.
	ld a, [wCurSpecies]
	push af
	ld a, [wCurPartyLevel]
	push af
	ld a, [wCurPartyMon]
	push af
	xor a
	ld [wCurPartyMon], a
.party
	ld a, [wPartyCount]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	jr nc, .done
	ld hl, wPartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [wCurSpecies], a
	call GetPokemonIndexFromID
	ld d, h
	ld e, l
	ld hl, .ReplacementIndexes
.find
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .next
	ld a, b
	cp d
	jr nz, .find
	ld a, c
	cp e
	jr nz, .find
	call GetBaseData
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1MaxHP
	call GetPartyLocation
	ld d, h
	ld e, l
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1StatExp - 1
	call GetPartyLocation
	ld b, TRUE
	predef CalcMonStats
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld a, d
	cp [hl]
	jr c, .next
	jr nz, .clamp
	inc hl
	ld a, e
	cp [hl]
	jr c, .next
	dec hl
.clamp
	ld a, [hli]
	ld e, [hl]
	dec hl
	dec hl
	ld [hl], e
	dec hl
	ld [hl], a
.next
	ld hl, wCurPartyMon
	inc [hl]
	jp .party
.done
	pop af
	ld [wCurPartyMon], a
	pop af
	ld [wCurPartyLevel], a
	pop af
	ld [wCurSpecies], a
	ret
.ReplacementIndexes
	dw ZORUA, ZOROARK, SEEDOT, NUZLEAF, SHIFTRY
	dw HONEDGE, DOUBLADE, AEGISLASH, SABLEYE, 0

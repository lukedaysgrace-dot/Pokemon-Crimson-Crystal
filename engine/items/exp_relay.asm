PUSHS
SECTION "EXP RELAY", ROMX

ExpRelayCore::
	xor a
	ld [wItemEffectSucceeded], a
	ld a, [wBattleMode]
	and a
	ret nz
	ld a, [wPartyCount]
	cp 2
	jr c, .need_two
	cp PARTY_LENGTH + 1
	ret nc
	ld b, PARTYMENUACTION_EXP_RELAY_DONOR
	callfar UseItem_SelectMon
	jp c, ClearPalettes
	ld a, [wCurPartyMon]
	push af ; keep donor off menu scratch RAM
.recipient
	ld b, PARTYMENUACTION_EXP_RELAY_RECIPIENT
	callfar UseItem_SelectMon
	jr c, .cancel_donor
	ld a, [wCurPartyMon]
	ld c, a
	pop af
	push af
	ld b, a
	cp c
	jr z, .same_mon
	push bc
	call ExpRelayValidatePair
	pop bc
	jr c, .cancel_donor
	; Copy names only after both menus, which use the string buffers.
	push bc
	ld a, b
	ld hl, wPartyMonNicknames
	call GetNick
	ld hl, wStringBuffer1
	ld de, wStringBuffer3
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop bc
	push bc
	ld a, c
	ld hl, wPartyMonNicknames
	call GetNick
	ld hl, .ConfirmText
	call PrintText
	call YesNoBox
	pop bc
	jr c, .cancel_donor
	call ExpRelayTransfer
	jr c, .cancel_donor
	pop af
	ld a, 1
	ld [wItemEffectSucceeded], a
	ld de, SFX_FULL_HEAL
	call PlaySFX
	call WaitSFX
	ld hl, .SuccessText
	call PrintText
	jp ClearPalettes

.same_mon
	ld hl, .SameMonText
	call PrintText
	jr .recipient

.cancel_donor
	pop af
	jp ClearPalettes

.need_two
	ld hl, .NeedTwoText
	call PrintText
	jp ClearPalettes

.ConfirmText:
	text "Move all Stat EXP"
	line "from @"
	text_ram wStringBuffer3
	text ""
	cont "to @"
	text_ram wStringBuffer1
	text "?"
	para "Donor loses all."
	line "Excess is lost."
	done

.SuccessText:
	text "Stat EXP relayed!"
	line "Stats updated."
	prompt

.SameMonText:
	text "Choose a different"
	line "#MON."
	prompt

.NeedTwoText:
	text "You need two"
	line "#MON to relay."
	prompt

ExpRelayValidatePair:
; b = donor, c = recipient (zero based). Carry rejects without writes.
	ld a, [wBattleMode]
	and a
	jr nz, .invalid
	ld a, [wPartyCount]
	cp 2
	jr c, .invalid
	cp PARTY_LENGTH + 1
	jr nc, .invalid
	cp b
	jr z, .invalid
	jr c, .invalid
	cp c
	jr z, .invalid
	jr c, .invalid
	ld a, b
	cp c
	jr z, .invalid
	call .valid_mon
	ret c
	ld a, c
.valid_mon
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	cp EGG
	jr z, .invalid
	call IsAPokemon
	ret c
	ld hl, wPartyMon1Species
	ld a, e
	push bc
	call GetPartyLocation
	pop bc
	ld a, [hl]
	cp EGG
	jr z, .invalid
	jp IsAPokemon
.invalid
	scf
	ret

ExpRelayTransfer::
; Atomic after confirmation. Five unsigned big-endian words, saturating at
; $ffff. Uses no saved scratch fields; never changes regular EXP or DVs.
	push bc
	call ExpRelayValidatePair
	pop bc
	ret c
	ld a, [wCurPartyMon]
	push af
	push bc
	ld a, b
	ld [wCurPartyMon], a
	ld a, MON_STAT_EXP
	call GetPartyParamLocation
	push hl
	ld a, c
	ld [wCurPartyMon], a
	ld a, MON_STAT_EXP
	call GetPartyParamLocation
	pop de ; donor; hl = recipient
	ld b, NUM_EXP_STATS
.transfer
	; Low byte first, then add high bytes with carry.
	inc de
	inc hl
	ld a, [de]
	add [hl]
	ld [hld], a
	dec de
	ld a, [de]
	adc [hl]
	ld [hl], a
	jr nc, .no_overflow
	ld a, $ff
	ld [hli], a
	ld [hld], a
.no_overflow
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	inc hl
	inc hl
	dec b
	jr nz, .transfer
	pop bc
	push bc
	ld a, b
	call ExpRelayRecalculate
	pop bc
	ld a, c
	call ExpRelayRecalculate
	pop af
	ld [wCurPartyMon], a
	and a
	ret

ExpRelayRecalculate:
; Use the same base data and calculator as vitamins, including stat modes.
	ld [wCurPartyMon], a
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	callfar UpdateStatsAfterItem
	; Preserve current HP unless the new maximum is smaller. Never revive or
	; heal the recipient, and never leave a donor above its new maximum HP.
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr c, .clamp
	ret nz
	ld a, [hl]
	cp c
	ret nc
.clamp
	ld a, [hld]
	ld c, a
	ld b, [hl]
	dec hl
	ld a, c
	ld [hld], a
	ld [hl], b
	ret

POPS

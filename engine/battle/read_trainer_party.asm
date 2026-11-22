ReadTrainerParty:
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	ld hl, wOTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, wOTPartyMons
	ld bc, wOTPartyMonsEnd - wOTPartyMons
	xor a
	call ByteFill

	ld a, [wOtherTrainerClass]
	cp CAL
	jr nz, .not_cal2
	ld a, [wOtherTrainerID]
	cp CAL2
	jr z, .cal2
	ld a, [wOtherTrainerClass]
.not_cal2

	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wTrainerGroupBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call GetTrainerPartyID
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer
.loop
	ld a, [wTrainerGroupBank]
	call GetFarByte
	add a, l
	ld l, a
	jr nc, .skip_trainer
	inc h
	jr .skip_trainer
.got_trainer
	inc hl
	call SelectLocalOpenProgressionParty

.skip_name
	call GetNextTrainerDataByte
	cp "@"
	jr nz, .skip_name

	call GetNextTrainerDataByte
	ld [wOtherTrainerType], a
	ld d, h
	ld e, l
	call ReadTrainerPartyPieces

.done
	jp ComputeTrainerReward

.cal2
	ld a, BANK(sMysteryGiftTrainer)
	call GetSRAMBank
	ld a, TRAINERTYPE_MOVES
	ld [wOtherTrainerType], a
	ld de, sMysteryGiftTrainer
	call ReadTrainerPartyPieces
	call CloseSRAM
	jr .done

SetTrainerBattleLevel:
; The battle transition runs before the enemy party is built. Read the first
; level directly from the selected trainer record so the transition can make
; a deterministic strength comparison. Link, Battle Tower, and CAL2 parties
; are already external/special data, so use the strongest transition for them.
	ld a, $ff
	ld [wCurPartyLevel], a

	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wOtherTrainerClass]
	cp CAL
	jr nz, .regular_trainer
	ld a, [wOtherTrainerID]
	cp CAL2
	ret z
	ld a, [wOtherTrainerClass]

.regular_trainer
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wTrainerGroupBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call GetTrainerPartyID
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer
	ld a, [wTrainerGroupBank]
	call GetFarByte
	add a, l
	ld l, a
	jr nc, .skip_trainer
	inc h
	jr .skip_trainer

.got_trainer
	inc hl ; record length
	call SelectLocalOpenProgressionParty
.skip_name
	call GetNextTrainerDataByte
	cp "@"
	jr nz, .skip_name

	call GetNextTrainerDataByte ; trainer type
	call GetNextTrainerDataByte ; first party member's level
	call ScaleHostessPartyLevel
	ld [wCurPartyLevel], a
	ret

SelectLocalOpenProgressionParty:
; Override only an explicitly listed map/class/ID, at battle start. Both the
; transition and party reader use this path. Identity and defeated flags stay
; unchanged, and the original pointer survives every rejected override.
	push bc
	push de
	push hl
	farcall SelectOpenProgressionParty
	and a
	jr z, .original
	ld [wTrainerGroupBank], a
	pop de ; discard original pointer, keep the selected hl
	pop de
	pop bc
	ret
.original
	pop hl
	pop de
	pop bc
	ret

GetTrainerPartyID:
; Return the party record to read in a. The Trainer House's CAL3 grows with
; the player: CAL3-CAL6 are chosen by the highest level in the player's party
; (below 60, 60s, 70s, 80+). Shucks' hostesses add a tier chosen by the
; party's average level (see GetHostessTier). Every other trainer uses
; wOtherTrainerID. Preserves bc, de, hl.
	ld a, [wOtherTrainerClass]
	cp HOSTESS
	jr z, .hostess
	cp CAL
	jr nz, .default
	ld a, [wOtherTrainerID]
	cp CAL3
	ret nz
	push bc
	push hl
	ld b, 0
	ld a, [wPartyCount]
	and a
	jr z, .got_highest
	ld c, a
	ld hl, wPartyMon1Level
.loop
	ld a, [hl]
	cp b
	jr c, .next
	ld b, a
.next
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
.got_highest
	ld a, b
	ld b, CAL6
	cp 80
	jr nc, .got_id
	ld b, CAL5
	cp 70
	jr nc, .got_id
	ld b, CAL4
	cp 60
	jr nc, .got_id
	ld b, CAL3
.got_id
	ld a, b
	pop hl
	pop bc
	ret

.default
	ld a, [wOtherTrainerID]
	ret

.hostess
	push bc
	call GetHostessTier
	ld b, a
	ld a, [wOtherTrainerID]
	add b
	pop bc
	ret

GetHostessTier:
; a = 0 (average below 20), 1 (20s) ... 5 (60s), 6 (70+). Preserves bc, de, hl.
	call GetPartyAverageLevel
	push bc
	ld b, -1
.tens
	inc b
	sub 10
	jr nc, .tens
	; b = average / 10
	ld a, b
	sub 1
	jr nc, .not_low
	xor a
.not_low
	cp HOSTESS_TIERS
	jr c, .done
	ld a, HOSTESS_TIERS - 1
.done
	pop bc
	ret

ScaleHostessPartyLevel:
; a = level byte from trainer data. Hostess level bytes are bonuses over the
; player's non-Egg party average; every other class keeps its fixed level.
; Returns the level to use, capped at MAX_LEVEL. Preserves bc, de, hl.
	push bc
	ld b, a
	ld a, [wOtherTrainerClass]
	cp HOSTESS
	ld a, b
	jr nz, .done
	call GetPartyAverageLevel
	add b
	jr c, .cap
	cp MAX_LEVEL + 1
	jr c, .done
.cap
	ld a, MAX_LEVEL
.done
	pop bc
	ret

GetPartyAverageLevel::
; a = rounded-down average level of the player's non-Egg party members,
; fainted members included (at least 1). Preserves bc, de, hl.
	push bc
	push de
	push hl
	ld de, 0 ; level sum
	ld c, 0 ; counted members
	ld a, [wPartyCount]
	and a
	jr z, .divide
	cp PARTY_LENGTH + 1
	jr nc, .divide
	ld b, a
	ld hl, wPartySpecies
.loop
	ld a, [hl]
	cp EGG
	jr z, .next
	push hl
	ld a, l
	sub LOW(wPartySpecies)
	ld hl, wPartyMon1Level
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	and a
	jr z, .got_mon
.find_mon
	add hl, bc
	dec a
	jr nz, .find_mon
.got_mon
	pop bc
	ld a, [hl]
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	inc c
	pop hl
.next
	inc hl
	dec b
	jr nz, .loop

.divide
	ld a, c
	and a
	jr z, .minimum
	ld b, -1
.subtract
	inc b
	ld a, e
	sub c
	ld e, a
	jr nc, .subtract
	dec d
	bit 7, d
	jr z, .subtract
	ld a, b
	and a
	jr nz, .done
.minimum
	ld a, 1
.done
	pop hl
	pop de
	pop bc
	ret

ReadTrainerPartyPieces:
	ld h, d
	ld l, e

.loop
	call GetNextTrainerDataByte
	cp $ff
	ret z

	call ScaleHostessPartyLevel
	ld [wCurPartyLevel], a
	call GetNextTrainerDataByte
	push hl
	push af
	call GetNextTrainerDataByte
	ld h, a
	pop af
	ld l, a
	call GetPokemonIDFromIndex
	ld [wCurPartySpecies], a

	ld a, OTPARTYMON
	ld [wMonType], a
	predef TryAddMonToParty
	pop hl
	inc hl ;because hl was pushed before the last call to GetNextTrainerDataByte

	ld a, [wOtherTrainerType]
	and TRAINERTYPE_ITEM
	jr z, .no_item
	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Item
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	call GetNextTrainerDataByte
	ld [de], a
.no_item

	ld a, [wOtherTrainerType]
	and TRAINERTYPE_ABILITY
	jr z, .no_ability
	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Personality
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	call GetNextTrainerDataByte
	and ABILITY_MASK ; ABILITY_1 / ABILITY_2 / ABILITY_3
	ld b, a
	ld a, [de]
	and ~ABILITY_MASK & $ff
	or b
	ld [de], a
.no_ability

	ld a, [wOtherTrainerType]
	rra ; TRAINERTYPE_MOVES_F == 0
	jr nc, .no_moves
	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Moves
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl

	ld b, NUM_MOVES
.copy_moves
	call GetNextTrainerDataByte
	push hl
	push af
	call GetNextTrainerDataByte
	ld h, a
	pop af
	ld l, a
	call GetMoveIDFromIndex
	pop hl
	inc hl
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de

	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	ld l, a
	ld a, MOVE_PP
	call GetMoveAttribute
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
.no_moves

	jp .loop

ComputeTrainerReward:
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a ; hMultiplicand + 0
	ld [hli], a ; hMultiplicand + 1
	ld a, [wEnemyTrainerBaseReward]
	ld [hli], a ; hMultiplicand + 2
	ld a, [wCurPartyLevel]
	ld [hl], a ; hMultiplier
	call Multiply
	ld hl, wBattleReward
	xor a
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	ret

Battle_GetTrainerName::
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ld hl, wOTPlayerName
	ld a, BANK(@)
	ld [wTrainerGroupBank], a
	jp nz, CopyTrainerName

	ld a, [wOtherTrainerID]
	ld b, a
	ld a, [wOtherTrainerClass]
	ld c, a
	; fallthrough

GetTrainerName::
	ld a, c
	cp CAL
	jr nz, .not_cal2

	ld a, BANK(sMysteryGiftTrainerHouseFlag)
	call GetSRAMBank
	ld a, [sMysteryGiftTrainerHouseFlag]
	and a
	call CloseSRAM
	jr z, .not_cal2

	ld a, BANK(sMysteryGiftPartnerName)
	call GetSRAMBank
	ld hl, sMysteryGiftPartnerName
	call CopyTrainerName
	jp CloseSRAM

.not_cal2
	dec c
	push bc
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wTrainerGroupBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc

.loop
	dec b
	jr z, .done

	ld a, [wTrainerGroupBank]
	call GetFarByte
	add a, l
	ld l, a
	jr nc, .loop
	inc h
	jr .loop

.done
	inc hl
	; fallthrough

CopyTrainerName:
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	ld a, [wTrainerGroupBank]
	call FarCopyBytes
	pop de
	ret

Function39990:
; This function is useless.
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	pop de
	ret

GetNextTrainerDataByte:
	ld a, [wTrainerGroupBank]
	call GetFarByte
	inc hl
	ret

INCLUDE "data/trainers/party_pointers.asm"

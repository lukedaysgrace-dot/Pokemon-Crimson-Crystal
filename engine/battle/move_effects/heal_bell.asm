BattleCommand_HealBell:
; healbell

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
	ld de, wPartyMon1Status
	ldh a, [hBattleTurn]
	and a
	jr z, .got_status
	ld de, wOTPartyMon1Status
.got_status
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld h, d
	ld l, e
	ld bc, PARTYMON_STRUCT_LENGTH
	ld d, PARTY_LENGTH
.loop
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .loop
	; The whole party is cured, so the badly-poisoned bookkeeping must go
	; too, or the counter re-arms on the next plain poison / switch-in
	; (audit 2026-08-28 #9).
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_TOXIC, [hl]
	ld hl, wPlayerToxicCount
	ld de, wPlayerToxicSlots
	ldh a, [hBattleTurn]
	and a
	jr z, .got_toxic
	ld hl, wEnemyToxicCount
	ld de, wEnemyToxicSlots
.got_toxic
	xor a
	ld [hl], a
	ld [de], a
	call AnimateCurrentMove

	ld hl, BellChimedText
	call StdBattleTextbox

	ldh a, [hBattleTurn]
	and a
	jp z, CalcPlayerStats
	jp CalcEnemyStats

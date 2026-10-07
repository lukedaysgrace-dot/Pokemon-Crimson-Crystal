; Supreme Overlord snapshots the side's capped faint history on entry.
; Reviving a teammate does not erase its faint, and a later faint counts
; again. These helpers always restore the active WRAM bank and turn.
; The same battle-scoped storage keeps Rage Fist's hit history per party
; member through switching and revival, without passing it to teammates.

InitSupremeHistory_Core::
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	xor a
	ld hl, wSupremeHistoryReady
	ld bc, wSupremeHistoryEnd - wSupremeHistoryReady
	call ByteFill
	pop af
	ldh [rSVBK], a
	pop bc
	ret

PrepareSupremeEntry_Core::
	push bc
	push de
	call InitializeSupremeHistory
	call SupremeHistoryAddrs
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	ld a, [hl]
	ld [bc], a
	xor a
	ld [de], a ; the incoming mon's next faint has not been counted
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

InitializeSupremeHistory:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	ld a, [wSupremeHistoryReady]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	and a
	ret nz
	; Party HP is now loaded. Include teammates already fainted at the
	; start of this cartridge battle as well as later battle KOs.
	ldh a, [hBattleTurn]
	push af
	farcall SetPlayerTurn
	farcall CountFaintedAllies
	call .store_count
	farcall SetEnemyTurn
	farcall CountFaintedAllies
	call .store_count
	pop af
	ldh [hBattleTurn], a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	ld a, TRUE
	ld [wSupremeHistoryReady], a
	pop af
	ldh [rSVBK], a
	ret
.store_count
	ld b, a
	ld hl, wPlayerFaintCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_count
	inc hl
.got_count
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerFaintCount)
	ldh [rSVBK], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
	ret

RecordFaintHistoryBoth_Core::
	push bc
	push de
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	ld a, [wSupremeHistoryReady]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	and a
	jr z, .done ; no active battlers before the first entry
	ldh a, [hBattleTurn]
	push af
	farcall SetPlayerTurn
	call .side
	farcall SetEnemyTurn
	call .side
	pop af
	ldh [hBattleTurn], a
.done
	pop de
	pop bc
	ret
.side
	farcall UserHasFainted
	push af
	call SupremeHistoryAddrs
	ldh a, [rSVBK]
	ld b, a
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	pop af
	jr nz, .alive
	ld a, [de]
	and a
	jr nz, .restore
	ld a, TRUE
	ld [de], a
	ld a, [hl]
	cp 5
	jr nc, .restore
	inc [hl]
	jr .restore
.alive
	xor a
	ld [de], a
.restore
	ld a, b
	ldh [rSVBK], a
	ret

ReadSupremeFallen_Core::
; a = the current holder's entry snapshot; preserves bc/de.
	push bc
	push de
	call SupremeHistoryAddrs
	ldh a, [rSVBK]
	push af
	ld a, BANK(wSupremeHistoryReady)
	ldh [rSVBK], a
	ld a, [bc]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	pop de
	pop bc
	ret

SupremeHistoryAddrs:
; hl = faint count, de = counted flag, bc = Supreme Overlord snapshot.
	ld hl, wPlayerFaintCount
	ld de, wPlayerFaintCounted
	ld bc, wPlayerSupremeFallen
	ldh a, [hBattleTurn]
	and a
	ret z
	inc hl
	inc de
	inc bc
	ret

LoadUserRageFistHistory_Core::
; Entry resets the active tally, then restores this mon's own battle
; history. Baton Pass does not transfer the outgoing mon's tally.
	push bc
	push de
	call RageFistHistorySlot
	jr c, .done
	call RageFistActiveCounter
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerRageFistHistory)
	ldh [rSVBK], a
	ld b, [hl]
	ld a, BANK(wPlayerRageFistHits)
	ldh [rSVBK], a
	ld a, b
	ld [de], a
	pop af
	ldh [rSVBK], a
.done
	pop de
	pop bc
	ret

RecordOpponentRageFistHistory_Core::
; Called after the defender's hit tally increases, including its KO hit.
	push bc
	push de
	ldh a, [hBattleTurn]
	push af
	farcall SwitchTurn
	call RageFistHistorySlot
	jr c, .done
	call RageFistActiveCounter
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerRageFistHits)
	ldh [rSVBK], a
	ld a, [de]
	ld b, a
	ld a, BANK(wPlayerRageFistHistory)
	ldh [rSVBK], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
.done
	pop af
	ldh [hBattleTurn], a
	pop de
	pop bc
	ret

RageFistActiveCounter:
; de = current turn holder's active hit tally; preserves hl.
	ld de, wPlayerRageFistHits
	ldh a, [hBattleTurn]
	and a
	ret z
	ld de, wEnemyRageFistHits
	ret

RageFistHistorySlot:
; hl = party member's persistent hit tally. Carry for an invalid slot.
	ld hl, wPlayerRageFistHistory
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurBattleMon]
	jr z, .got_slot
	ld hl, wEnemyRageFistHistory
	ld a, [wBattleMode]
	dec a
	ld a, 0 ; wild opponents use slot 0
	jr z, .got_slot
	ld a, [wCurOTMon]
.got_slot
	cp PARTY_LENGTH
	ccf
	ret c
	ld e, a
	ld d, 0
	add hl, de
	and a
	ret

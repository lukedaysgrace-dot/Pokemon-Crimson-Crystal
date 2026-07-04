BattleTripleKick_Core:
; triplekick body. Lives in the Battle Effect Overflow bank; the command
; dispatcher jumps with the Effect Commands bank active, so the command
; itself is a callfar stub over there (see BattleCommand_TripleKick).

	ld a, [wKickCounter]
	ld b, a
	inc b
	ld hl, wCurDamage + 1
	ld a, [hld]
	ld e, a
	ld a, [hli]
	ld d, a
.next_kick
	dec b
	ret z
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hli], a

; No overflow.
	jr nc, .next_kick
	ld a, $ff
	ld [hld], a
	ld [hl], a
	ret

BattleKickCounter_Core:
; kickcounter body (see BattleCommand_KickCounter).

	ld hl, wKickCounter
	inc [hl]
	ret

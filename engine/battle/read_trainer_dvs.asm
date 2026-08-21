GetTrainerDVs:
; Return the DVs of wOtherTrainerClass in bc

	push hl
	ld a, [wOtherTrainerClass]
	dec a
	ld c, a
	ld b, 0

	ld hl, TrainerClassDVs
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld b, a
	ld c, [hl]

	pop hl
	ret

GetTrainerStatExp:
; Return the stat exp of wOtherTrainerClass in bc, stored big endian
; (b = high byte, c = low byte) so it can be written straight into a
; party struct.
; Trainer stat exp is a Hard Mode bonus only: in Normal mode every
; trainer class returns 0, regardless of the table below.

	push hl
	push de
	ld de, ENGINE_HARD_MODE
	ld b, CHECK_FLAG
	farcall EngineFlagAction
	pop de
	pop hl
	ld a, c
	and a
	jr z, .no_stat_exp

	ld a, [wOtherTrainerClass]
	and a
	jr nz, .got_class
; No trainer class to look up; give nothing rather than reading past the table.
.no_stat_exp
	ld bc, 0
	ret

.got_class
	push hl
	dec a
	ld c, a
	ld b, 0

	ld hl, TrainerClassStatExp
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld c, a
	ld b, [hl]

	pop hl
	ret

INCLUDE "data/trainers/dvs.asm"
INCLUDE "data/trainers/stat_exp.asm"

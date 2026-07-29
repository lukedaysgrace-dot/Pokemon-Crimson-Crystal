FarCall    EQU $08
Bankswitch EQU $10
JumpTable  EQU $28

farcall: MACRO ; bank, address
	ld a, BANK(\1)
	ld hl, \1
	rst FarCall
ENDM

callfar: MACRO ; address, bank
	ld hl, \1
	ld a, BANK(\1)
	rst FarCall
ENDM

homecall: MACRO
	ldh a, [hROMBank]
	push af
	ld a, BANK(\1)
	rst Bankswitch
	call \1
	pop af
	rst Bankswitch
ENDM

farcheckmatchup: MACRO
; Cross-bank stand-in for `call CheckTypeMatchup`.
; a = attacking type, hl = pointer to the defender's two types.
; Preserves bc, de and hl, like the bank-local call does.
; NOTE: `predef CheckTypeMatchup` does NOT work - Predef preserves bc/de/hl/f
; but not a, because a is the predef ID. Use this instead.
	push hl
	push de
	push bc
	ld b, a
	ld d, h
	ld e, l
	farcall CheckTypeMatchupFar
	pop bc
	pop de
	pop hl
ENDM

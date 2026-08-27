FarCall_de::
; Call a:de.
; Preserves other registers.

	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	ldh a, [hBuffer]
	rst Bankswitch
	call .de
	jr ReturnFarCall

.de
	push de
	ret

FarCall_hl::
; Call a:hl.
; Preserves other registers. The callee gets a = [hFarCallReturnA], so
; farcall_a (macros/rst.asm) can pass a through; plain farcalls clobber a.

	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	ldh a, [hBuffer]
	rst Bankswitch
	ldh a, [hFarCallReturnA]
	call FarJump_hl

ReturnFarCall::
; We want to retain the contents of f and a.
; To do this, we can pop to bc instead of af, and park a in HRAM.
; (Vanilla returned a = c; the storage API relies on a coming back intact.)

	ldh [hFarCallReturnA], a
	ld a, b
	ld [wFarCallBCBuffer], a
	ld a, c
	ld [wFarCallBCBuffer + 1], a

; Restore the working bank.
	pop bc
	ld a, b
	rst Bankswitch

	ld a, [wFarCallBCBuffer]
	ld b, a
	ld a, [wFarCallBCBuffer + 1]
	ld c, a
	ldh a, [hFarCallReturnA]
	ret

FarJump_hl::
	jp hl

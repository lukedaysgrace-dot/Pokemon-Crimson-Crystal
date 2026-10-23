; Keep the unrolled loops in ROM0, including when the source is banked ROM.
; This section fits in the unused space between the vectors and ROM header.
PUSHS
SECTION "Memory copy helpers", ROM0

CopyBytes::
; Copy bc bytes from hl to de, forwards. Zero length is a no-op.
; Adapted from Polished Crystal's four-byte loop (home/copy.asm).
; Preserve carry as the original routine did, including through far callers.
	push af
	inc b
	srl c
	jr nc, .skip1
	ld a, [hli]
	ld [de], a
	inc de
.skip1
	srl c
	jr nc, .skip2
rept 2
	ld a, [hli]
	ld [de], a
	inc de
endr
.skip2
	jr z, .next
.loop
rept 4
	ld a, [hli]
	ld [de], a
	inc de
endr
	dec c
	jr nz, .loop
.next
	dec b
	jr z, .done
	ld c, $40
	jr .loop
.done
	ld c, a
	pop af
	ld a, c
	ld bc, 1
	dec c ; original return flags: Z, N, no H, incoming carry
	ret

ByteFill::
; Fill bc bytes at hl with a. Preserves a and de; zero length is a no-op.
; Adapted from Polished Crystal's four-byte loop (home/copy.asm).
	push af
	inc b
	srl c
	jr nc, .skip1
	ld [hli], a
.skip1
	srl c
	jr nc, .skip2
	ld [hli], a
	ld [hli], a
.skip2
	jr z, .next
.loop
rept 4
	ld [hli], a
endr
	dec c
	jr nz, .loop
.next
	dec b
	jr z, .done
	ld c, $40
	jr .loop
.done
	pop af
	ld b, 1
	dec b ; preserve the original return flags, including incoming carry
	ret

POPS

SwapBytes::
; swap bc bytes between hl and de
.Loop:
	; stash [hl] away on the stack
	ld a, [hl]
	push af

	; copy a byte from [de] to [hl]
	ld a, [de]
	ld [hli], a

	; retrieve the previous value of [hl]; put it in [de]
	pop af
	ld [de], a
	inc de

	; handle loop stuff
	dec bc
	ld a, b
	or c
	jr nz, .Loop
	ret

GetFarByte::
; retrieve a single byte from a:hl, and return it in a.
	; bankswitch to new bank
	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	ldh a, [hBuffer]
	rst Bankswitch

	; get byte from new bank
	ld a, [hl]
	ldh [hBuffer], a

	; bankswitch to previous bank
	pop af
	rst Bankswitch

	; return retrieved value in a
	ldh a, [hBuffer]
	ret

GetFarHalfword::
; retrieve a halfword from a:hl, and return it in hl.
	; bankswitch to new bank
	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	ldh a, [hBuffer]
	rst Bankswitch

	; get halfword from new bank, put it in hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; bankswitch to previous bank and return
	pop af
	rst Bankswitch
	ret

FarCopyWRAM::
	ldh [hBuffer], a
	ldh a, [rSVBK]
	push af
	ldh a, [hBuffer]
	ldh [rSVBK], a

	call CopyBytes

	pop af
	ldh [rSVBK], a
	ret

GetFarWRAMByte::
	ldh [hBuffer], a
	ldh a, [rSVBK]
	push af
	ldh a, [hBuffer]
	ldh [rSVBK], a
	ld a, [hl]
	ldh [hBuffer], a
	pop af
	ldh [rSVBK], a
	ldh a, [hBuffer]
	ret

GetFarWRAMWord::
	ldh [hBuffer], a
	ldh a, [rSVBK]
	push af
	ldh a, [hBuffer]
	ldh [rSVBK], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ldh [rSVBK], a
	ret

EmptyAllSRAMBanks:
; Every bank, including the PokeDB storage banks past bank 3.
	xor a
.loop
	push af
	call .EmptyBank
	pop af
	inc a
	cp NUM_SRAM_BANKS
	jr c, .loop
	ret

.EmptyBank:
	call GetSRAMBank
	ld hl, SRAM_Begin
	ld bc, SRAM_End - SRAM_Begin
	xor a
	call ByteFill
	call CloseSRAM
	ret

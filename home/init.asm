Reset::
	di
	call MapSetup_Sound_Off
	xor a
	ldh [hMapAnims], a
	call ClearPalettes
	xor a
	ldh [rIF], a
	ld a, 1 << VBLANK
	ldh [rIE], a
	ei

	ld hl, wcfbe
	set 7, [hl]

	ld c, 32
	call DelayFrames

	jr Init

_Start::
	cp $11
	jr z, .cgb
	xor a
	jr .load

.cgb
	ld a, $1

.load
	ldh [hCGB], a
	ld a, $1
	ldh [hSystemBooted], a

Init::
	di

	xor a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rRP], a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rSB], a
	ldh [rSC], a
	ldh [rWX], a
	ldh [rWY], a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	ldh [rTMA], a
	ldh [rTAC], a
	ld [WRAM1_Begin], a

	ld a, %100 ; Start timer at 4096Hz
	ldh [rTAC], a

.wait
	ldh a, [rLY]
	cp LY_VBLANK + 1
	jr nz, .wait

	xor a
	ldh [rLCDC], a

; 60fps: enter CGB double speed mode now, while the LCD is off. Switching
; speeds with the LCD on collapses video output and can hang real hardware,
; so this has to happen here rather than later in Init.
;
; This does NOT change the frame rate or any movement speed: the LCD still
; refreshes at ~59.73Hz and every step, animation and timer is driven off
; VBlank. It doubles the CPU clock, which is what the 60fps overworld loop
; needs - that loop now runs once per frame instead of once per two frames,
; so it has half the wall-clock budget vanilla gave it. Without the doubled
; clock the loop overruns VBlank on busy maps and visibly judders.
; Polished Crystal does exactly this (see its engine/init.asm).
	ldh a, [hCGB]
	and a
	jr z, .no_double_speed
	ld hl, rKEY1
	bit 7, [hl]
	jr nz, .no_double_speed
	set 0, [hl] ; arm the speed switch
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ld a, $30
	ldh [rJOYP], a
	stop ; rgbasm adds a nop after this instruction by default
.no_double_speed

; Clear WRAM bank 0
	ld hl, WRAM0_Begin
	ld bc, WRAM0_End - WRAM0_Begin
.ByteFill:
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .ByteFill

	ld sp, wStack

; Clear HRAM
	ldh a, [hCGB]
	push af
	ldh a, [hSystemBooted]
	push af
	xor a
	ld hl, HRAM_Begin
	ld bc, HRAM_End - HRAM_Begin
	call ByteFill
	pop af
	ldh [hSystemBooted], a
	pop af
	ldh [hCGB], a
	ld a, -1
	ldh [hSRAMBank], a

	call ClearWRAM
	ld a, 1
	ldh [rSVBK], a
	call ClearVRAM
	call ClearSprites
	call ClearsScratch

	ld a, BANK(GameInit) ; aka BANK(WriteOAMDMACodeToHRAM)
	rst Bankswitch

	call WriteOAMDMACodeToHRAM

	xor a
	ldh [hMapAnims], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rJOYP], a

	ld a, $8 ; HBlank int enable
	ldh [rSTAT], a

	ld a, $90
	ldh [hWY], a
	ldh [rWY], a

	ld a, 7
	ldh [hWX], a
	ldh [rWX], a

	ld a, LCDC_DEFAULT ; %11100011
	; LCD on
	; Win tilemap 1
	; Win on
	; BG/Win tiledata 0
	; BG Tilemap 0
	; OBJ 8x8
	; OBJ on
	; BG on
	ldh [rLCDC], a

	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a

	farcall InitCGBPals

	ld a, HIGH(vBGMap1)
	ldh [hBGMapAddress + 1], a
	xor a ; LOW(vBGMap1)
	ldh [hBGMapAddress], a

	farcall StartClock

	xor a
	ld [MBC3LatchClock], a
	ld [MBC3SRamEnable], a

; (Double speed is enabled earlier in Init, with the LCD off. Vanilla called
; NormalSpeed here; doing so now would undo it.)

	xor a
	ldh [rIF], a
	ld a, IE_DEFAULT
	ldh [rIE], a
	ei

	call DelayFrame

	predef InitSGBBorder ; SGB init

	call MapSetup_Sound_Off
	xor a
	ld [wMapMusic], a
	jp GameInit

ClearVRAM::
; Wipe VRAM banks 0 and 1

	ld a, 1
	ldh [rVBK], a
	call .clear

	xor a ; 0
	ldh [rVBK], a
.clear
	ld hl, VRAM_Begin
	ld bc, VRAM_End - VRAM_Begin
	xor a
	call ByteFill
	ret

ClearWRAM::
; Wipe swappable WRAM banks (1-7)
; Assumes CGB or AGB

	ld a, 1
.bank_loop
	push af
	ldh [rSVBK], a
	xor a
	ld hl, WRAM1_Begin
	ld bc, WRAM1_End - WRAM1_Begin
	call ByteFill
	pop af
	inc a
	cp 8
	jr c, .bank_loop
	ret

ClearsScratch::
; Wipe the first 32 bytes of sScratch

	ld a, BANK(sScratch)
	call GetSRAMBank
	ld hl, sScratch
	ld bc, $20
	xor a
	call ByteFill
	call CloseSRAM
	ret

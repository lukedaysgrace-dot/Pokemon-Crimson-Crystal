; Game Boy hardware interrupts

SECTION "vblank", ROM0
	jp VBlank

SECTION "lcd", ROM0
	; Dispatch through the HRAM trampoline (hLCDInterruptFunction),
	; so that the storage system UI can install a custom hblank handler.
	push af
	jp hLCDInterruptFunction

SECTION "timer", ROM0
	jp Timer

SECTION "serial", ROM0
	jp Serial

SECTION "joypad", ROM0
	jp JoypadInt

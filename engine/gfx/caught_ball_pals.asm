LoadCaughtBallBGPals::
; Load the caught ball colors into BG palettes 4-6 for the party menu.
; Relocated out of the (full) bank2 color.asm; reached via farcall.
	ld hl, CaughtBallBGPals
	ld de, wBGPals1 palette 4
	ld bc, 3 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	ret

CaughtBallBGPals:
INCLUDE "gfx/stats/caught_balls.pal"

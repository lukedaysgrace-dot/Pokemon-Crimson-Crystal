; The idle animation starts fresh from the base pic, so it can only use frames
; that render correctly on their own. Frame 3 does not -- these sheets are
; differential, and the idle never plays frames 1-2 to build up to it, which is
; what produced two garbled frames a second after the intro animation.
; Holding the base pic is glitch-free. If you want movement back, try single
; frames here one at a time and keep whichever looks right by itself.
	frame 0, 20
	endanim

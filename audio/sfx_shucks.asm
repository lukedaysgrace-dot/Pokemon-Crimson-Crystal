; Shucks' stage curtains sweep open for the Friday-night show: a fabric
; whoosh on the noise channel under a quick rolled "ta-da" on pulse 1.

Sfx_CurtainOpen:
	musicheader 2, 5, .Fanfare
	musicheader 1, 8, .Swoosh

.Fanfare:
	duty_cycle 2
	pitch_sweep 0, 8 ; no sweep
	square_note 3, 9, 1, $0783 ; C6
	square_note 3, 10, 1, $079d ; E6
	square_note 3, 11, 1, $07ac ; G6
	square_note 24, 12, 3, $07c1 ; C7, ringing out
	endchannel

.Swoosh:
	; Curtains slide apart: hiss swells in, then drops in pitch as it settles.
	noise_note 3, 3, -2, $21
	noise_note 5, 8, -1, $21
	noise_note 7, 11, 1, $22
	noise_note 7, 9, 2, $32
	noise_note 9, 7, 3, $43
	noise_note 14, 5, 4, $54 ; soft rustle tail
	endchannel

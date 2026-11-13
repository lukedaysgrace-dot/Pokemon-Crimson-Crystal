; Air gathering around small glass fragments, then a short stone impact.
; Formation uses pulse 2 and noise only, leaving the theme's lead and bass.
; The lock has a lower ID, so it can replace formation at the visual cue.

Sfx_CrimsonVSForm:
	musicheader 2, 6, .Glass
	musicheader 1, 8, .Air
.Glass:
	dutycycle $0
	square_note 8, 0, 0, 0
	square_note 2, 3, 1, 1840
	square_note 4, 0, 0, 0
	square_note 2, 4, 1, 1892
	square_note 3, 0, 0, 0
	square_note 2, 4, 1, 1924
	square_note 2, 0, 0, 0
	square_note 2, 5, 1, 1944
	square_note 2, 0, 0, 0
	square_note 3, 5, 2, 1965
	square_note 3, 0, 0, 0
	square_note 4, 6, 2, 1980
	endchannel
.Air:
	noise_note 9, 2, -7, $34
	noise_note 9, 3, -7, $24
	noise_note 9, 4, -7, $14
	noise_note 9, 5, 5, $13
	noise_note 9, 5, 3, $12
	endchannel

Sfx_CrimsonVSLock:
	musicheader 3, 5, .Thump
	musicheader 1, 6, .Body
	musicheader 1, 8, .Impact
.Thump:
	dutycycle $2
	soundinput $8
	square_note 2, 13, 1, 1472
	square_note 3, 10, 2, 1024
	square_note 6, 6, 2, 512
	square_note 19, 3, 7, 512 ; quiet 20-frame tail (~0.335 seconds)
	endchannel
.Body:
	dutycycle $2
	square_note 2, 9, 1, 1536
	square_note 3, 7, 2, 1280
	square_note 6, 4, 2, 896
	square_note 19, 2, 7, 896
	endchannel
.Impact:
	noise_note 2, 14, 1, $44
	noise_note 6, 9, 2, $54
	noise_note 7, 5, 3, $64
	noise_note 19, 3, 7, $64
	endchannel

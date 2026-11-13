; Glass glints in the gathering air, then a deep stone impact.
; Both cues use only the noise channel, so no pulse/wave music voice is ever
; muted, and CrimsonVSSound skips them entirely for themes with drums.
; The lock has a lower ID, so it can replace formation at the visual cue.

Sfx_CrimsonVSForm:
	musicheader 1, 8, .Air
.Air:
	; Periodic (7-bit) noise rings like glass; the hiss between swells up.
	noise_note 1, 6, 1, $09 ; glint
	noise_note 7, 2, -7, $34 ; air gathers
	noise_note 1, 7, 1, $08
	noise_note 7, 3, -7, $24
	noise_note 1, 8, 1, $09
	noise_note 7, 4, -7, $14
	noise_note 1, 9, 1, $08
	noise_note 7, 5, 5, $13
	noise_note 9, 5, 3, $12
	endchannel

Sfx_CrimsonVSLock:
; The impact lives entirely on the noise channel, under every VS theme that
; has no drums (pulse 1, pulse 2 and wave keep playing untouched).
	musicheader 1, 8, .Impact
.Impact:
	noise_note 1, 15, 0, $31 ; bright crack
	noise_note 2, 15, 1, $44 ; punch
	noise_note 3, 14, 2, $55 ; body
	noise_note 5, 12, 3, $66 ; low thump
	noise_note 19, 8, 4, $77 ; quiet 20-frame rumble tail (~0.335 seconds)
	endchannel

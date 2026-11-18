; Archer Battle - Crimson Crystal. Extended v3 / v1 arrangement.
; A minor / A Phrygian; tempo 156, notetype 12 (~123 BPM).
; Intro 4 | Main 8 | v3 Lead-up 8 | Wobble 4 | Toccata 4
; | adapted v1 Command bridge 4 | v1 Rise 4 | v1 Half-time hook 8
; | v3 Breakdown 4 | v3 Final drop 4 | loop to intro bar 3.
; First pass: 52 bars (~101.9 s). Loop: 50 bars, 800 sixteenths (~97.9 s).
; All four channels stay aligned, including the 32nd-note bass/snare runs.
; The originals remain in rocketexecutivethemev1.asm and v3.asm.

Music_ArcherBattle:
	musicheader 4, 1, Music_ArcherBattle_Ch1
	musicheader 1, 2, Music_ArcherBattle_Ch2
	musicheader 1, 3, Music_ArcherBattle_Ch3
	musicheader 1, 4, Music_ArcherBattle_Ch4

Music_ArcherBattle_Ch1:
	tempo 156
	volume $77

; Intro: 2 bars (v3).
Music_ArcherBattle_Ch1_Intro:
	notetype 12, $2f
	sound_duty $2, $2, $2, $2
	octave 2
	note E_, 16
	intensity $2f
	note F_, 16

Music_ArcherBattle_Ch1_Loop:

; Hammer: 2 bars (v3).
Music_ArcherBattle_Ch1_Hammer:
	notetype 12, $51
	sound_duty 1, 1, 1, 1
	octave 3
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	intensity $61
	note D_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	intensity $71
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note A_, 1
	intensity $81
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	intensity $91
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	intensity $a1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	intensity $a1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	intensity $b1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 1
	note B_, 1

; Main: 8 bars (v3).
Music_ArcherBattle_Ch1_Main:
	notetype 12, $92
	sound_duty 0, 0, 0, 0
	octave 3
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	sound_duty 1, 1, 1, 1
	intensity $a2
	note A_, 6
	intensity $92
	note A_, 4
	intensity $a2
	octave 4
	note C_, 2
	intensity $a4
	octave 3
	note B_, 4
	intensity $a2
	note A_, 6
	intensity $92
	note A_, 4
	intensity $a2
	octave 4
	note C_, 2
	intensity $a4
	octave 3
	note A#, 4
	intensity $b1
	note E_, 1
	intensity $a1
	note D#, 1
	intensity $91
	note D_, 1
	intensity $81
	note C#, 1
	intensity $b1
	note D_, 1
	intensity $a1
	note C#, 1
	intensity $91
	note C_, 1
	intensity $81
	octave 2
	note B_, 1
	intensity $a4
	note G#, 4
	note __, 4
	sound_duty 2, 2, 2, 2
	intensity $97
	octave 3
	note C_, 6
	intensity $97
	note C_, 6
	intensity $94
	octave 2
	note G_, 4
	intensity $94
	octave 3
	note E_, 4
	intensity $92
	note D_, 2
	intensity $94
	note C_, 4
	intensity $92
	note C_, 2
	intensity $94
	note C_, 4
	intensity $97
	note D_, 6
	intensity $97
	note C_, 6
	intensity $94
	octave 2
	note A_, 4
	intensity $97
	note G#, 8
	note __, 2
	intensity $92
	note G#, 2
	intensity $92
	note B_, 2
	intensity $92
	octave 3
	note D_, 2

; LeadUp: 8 bars (v3).
Music_ArcherBattle_Ch1_LeadUp:
	notetype 12, $41
	sound_duty 1, 1, 1, 1
	octave 2
	note F_, 1
	note A_, 1
	octave 3
	note C_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note C_, 1
	octave 2
	note A_, 1
	note F_, 1
	note A_, 1
	octave 3
	note C_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note C_, 1
	octave 2
	note A_, 1
	intensity $51
	note F_, 1
	note A_, 1
	octave 3
	note C_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note C_, 1
	octave 2
	note A_, 1
	note F_, 1
	note A_, 1
	octave 3
	note C_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note C_, 1
	octave 2
	note A_, 1
	intensity $61
	note G_, 1
	note B_, 1
	octave 3
	note D_, 1
	note G_, 1
	note B_, 1
	note G_, 1
	note D_, 1
	octave 2
	note B_, 1
	note G_, 1
	note B_, 1
	octave 3
	note D_, 1
	note G_, 1
	note B_, 1
	note G_, 1
	note D_, 1
	octave 2
	note B_, 1
	intensity $81
	note G_, 1
	note B_, 1
	octave 3
	note D_, 1
	note G_, 1
	note B_, 1
	note G_, 1
	note D_, 1
	octave 2
	note B_, 1
	note G_, 1
	note B_, 1
	octave 3
	note D_, 1
	note G_, 1
	note B_, 1
	note G_, 1
	note D_, 1
	octave 2
	note B_, 1
	intensity $91
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	octave 4
	note C_, 1
	octave 3
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	octave 4
	note C_, 1
	octave 3
	note A_, 1
	note E_, 1
	note C_, 1
	intensity $a1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	octave 4
	note C_, 1
	octave 3
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	octave 4
	note C_, 1
	octave 3
	note A_, 1
	note E_, 1
	note C_, 1
	intensity $91
	octave 1
	note E_, 1
	intensity $91
	octave 2
	note E_, 1
	intensity $a1
	octave 1
	note E_, 1
	intensity $a1
	octave 2
	note E_, 1
	intensity $a1
	octave 1
	note E_, 1
	intensity $b1
	octave 2
	note E_, 1
	intensity $b1
	octave 1
	note E_, 1
	intensity $b1
	octave 2
	note E_, 1
	intensity $c1
	octave 1
	note E_, 1
	intensity $c1
	octave 2
	note E_, 1
	intensity $c1
	octave 1
	note E_, 1
	intensity $d1
	octave 2
	note E_, 1
	intensity $d1
	octave 1
	note E_, 1
	intensity $d1
	octave 2
	note E_, 1
	intensity $e1
	octave 1
	note E_, 1
	intensity $e1
	octave 2
	note E_, 1
	intensity $c1
	note E_, 1
	intensity $c1
	note G_, 1
	intensity $d1
	note F#, 1
	intensity $d1
	note A_, 1
	intensity $d1
	note G#, 1
	intensity $d1
	note B_, 1
	intensity $e1
	note A#, 1
	intensity $e1
	octave 3
	note C#, 1
	intensity $e1
	note C_, 1
	intensity $e1
	note D#, 1
	intensity $f1
	note D_, 1
	intensity $f1
	note F_, 1
	note __, 4

; Wobble: 4 bars (v3).
Music_ArcherBattle_Ch1_Wobble:
	notetype 12, $c4
	sound_duty 0, 1, 2, 1
	octave 1
	note A_, 4
	note __, 2
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c2
	octave 2
	note C_, 2
	intensity $c2
	octave 1
	note A#, 2
	intensity $c4
	note A_, 4
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c2
	note A_, 2
	intensity $c2
	octave 2
	note E_, 2
	intensity $c2
	note F_, 2
	intensity $c4
	octave 1
	note A_, 4
	note __, 2
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c2
	octave 2
	note C_, 2
	intensity $c2
	note D_, 2
	intensity $c1
	octave 1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c2
	note A_, 2
	intensity $c2
	note A_, 2
	intensity $c2
	note A#, 2
	intensity $c2
	note B_, 2
	intensity $c2
	octave 2
	note C_, 2
	intensity $c2
	note C#, 2

; Toccata: 4 bars (v3).
Music_ArcherBattle_Ch1_Toccata:
	notetype 12, $a2
	sound_duty 0, 1, 2, 1
	octave 1
	note A_, 2
	note __, 2
	note A_, 2
	note A_, 2
	note __, 2
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	intensity $a2
	note F_, 2
	note __, 2
	note F_, 2
	note F_, 2
	note __, 2
	note F_, 2
	octave 2
	note F_, 2
	octave 1
	note F_, 2
	intensity $a2
	octave 2
	note D_, 2
	note __, 2
	note D_, 2
	note D_, 2
	note __, 2
	note D_, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
; Final E bar: thin the growl and widen the rhythm into the bridge.
	notetype 12, $a2
	sound_duty 0, 1, 2, 1
	octave 1
	note E_, 2
	note __, 2
	sound_duty 1, 1, 2, 1
	intensity $93
	note E_, 2
	note E_, 2
	sound_duty 1, 1, 1, 1
	intensity $94
	octave 2
	note E_, 2
	note G#, 2
	note B_, 2
	note G#, 2

; CommandBridge: 4 bars (v1).
Music_ArcherBattle_Ch1_CommandBridge:
; Clean A-minor landing: one pulse lead over rounded bass; no counterline.
; Keep the lead pitches in the surrounding register into v1's F3 phrase.
	notetype 12, $94
	note __, 16
	notetype 12, $77
	sound_duty $3, $3, $3, $3
	octave 3
	note D_, 8
	octave 2
	note A#, 8
	note B_, 8
	octave 3
	note D_, 8
	octave 2
	note B_, 8
	note G#, 8

; SecondRise: 4 bars (v1).
Music_ArcherBattle_Ch1_SecondRise:
	notetype 12, $62
	sound_duty $1, $1, $1, $1
	octave 2
	note F_, 2
	intensity $72
	note F_, 2
	intensity $72
	note F_, 2
	intensity $82
	note F_, 2
	intensity $82
	note F_, 2
	intensity $92
	note F_, 2
	intensity $92
	note F_, 2
	intensity $a2
	note F_, 2
	intensity $a2
	note F#, 2
	intensity $a2
	note F#, 2
	intensity $b2
	note F#, 2
	intensity $b2
	note F#, 2
	intensity $b2
	note F#, 2
	intensity $c2
	note F#, 2
	intensity $c2
	note F#, 2
	intensity $d2
	note F#, 2
	intensity $81
	note G_, 1
	intensity $81
	note A_, 1
	intensity $91
	note G#, 1
	intensity $91
	note A#, 1
	intensity $91
	note A_, 1
	intensity $a1
	note B_, 1
	intensity $a1
	note A#, 1
	intensity $a1
	octave 3
	note C_, 1
	intensity $b1
	octave 2
	note B_, 1
	intensity $b1
	octave 3
	note C#, 1
	intensity $b1
	note C_, 1
	intensity $c1
	note D_, 1
	intensity $c1
	note C#, 1
	intensity $c1
	note D#, 1
	intensity $d1
	note D_, 1
	intensity $d1
	note E_, 1
	intensity $d1
	note D#, 1
	intensity $d1
	note F_, 1
	intensity $e1
	note E_, 1
	intensity $e1
	note F#, 1
	intensity $e1
	note F_, 1
	intensity $e1
	note G_, 1
	intensity $f1
	note F#, 1
	intensity $f1
	note G#, 1
	intensity $f1
	note G_, 1
	intensity $f1
	note A_, 1
	intensity $f1
	note G#, 1
	intensity $f1
	note A#, 1
	note __, 4

; HalfTimeHook: 8 bars (v1).
Music_ArcherBattle_Ch1_HalfTimeHook:
	notetype 12, $a2
	sound_duty $1, $1, $1, $1
	octave 2
	note A_, 2
	note __, 1
	intensity $a2
	note A_, 1
	note __, 2
	intensity $a2
	note A_, 2
	note __, 2
	intensity $a2
	note A_, 2
	intensity $a2
	octave 3
	note C_, 2
	intensity $a2
	octave 2
	note A#, 2
	intensity $a4
	octave 3
	note E_, 3
	intensity $a4
	note D_, 3
	intensity $a2
	note C_, 2
	intensity $a4
	octave 2
	note B_, 3
	intensity $a4
	note A_, 3
	intensity $a2
	note G#, 2
	intensity $a2
	note A_, 2
	note __, 1
	intensity $a2
	note A_, 1
	note __, 2
	intensity $a2
	note A_, 2
	note __, 2
	intensity $a2
	note A_, 2
	intensity $a2
	octave 3
	note C_, 2
	intensity $a2
	octave 2
	note A#, 2
	intensity $a4
	octave 3
	note E_, 3
	intensity $a4
	note F_, 3
	intensity $a2
	note E_, 2
	intensity $a2
	note D_, 2
	intensity $a2
	note C_, 2
	intensity $a2
	octave 2
	note A#, 2
	intensity $a2
	note G#, 2
	intensity $a2
	note A_, 2
	note __, 1
	intensity $a2
	note A_, 1
	note __, 2
	intensity $a2
	note A_, 2
	note __, 2
	intensity $a2
	note A_, 2
	intensity $a2
	octave 3
	note C_, 2
	intensity $a2
	octave 2
	note A#, 2
	intensity $a4
	octave 3
	note F_, 3
	intensity $a4
	note E_, 3
	intensity $a2
	note C_, 2
	intensity $a4
	octave 2
	note A_, 3
	intensity $a4
	note F_, 3
	intensity $a2
	note D_, 2
	intensity $a2
	note B_, 2
	note __, 1
	intensity $a2
	note B_, 1
	note __, 2
	intensity $a2
	note B_, 2
	note __, 2
	intensity $a2
	note B_, 2
	intensity $a2
	octave 3
	note D_, 2
	intensity $a2
	note C_, 2
	intensity $a4
	note E_, 3
	intensity $a4
	note D_, 3
	intensity $a2
	note C_, 2
	intensity $a4
	octave 2
	note B_, 3
	intensity $a4
	note G#, 3
	intensity $a2
	note E_, 2

; Breakdown: 4 bars (v3).
Music_ArcherBattle_Ch1_Breakdown:
	notetype 12, $a2
	sound_duty 0, 1, 2, 1
	octave 1
	note __, 12
	intensity $c1
	note A_, 1
	note A_, 1
	intensity $c2
	octave 2
	note E_, 2
	note __, 12
	intensity $c1
	octave 1
	note A#, 1
	note A#, 1
	intensity $c2
	note G#, 2
	note __, 12
	intensity $c1
	note A_, 1
	note A_, 1
	intensity $c2
	octave 2
	note E_, 2
	intensity $91
	octave 1
	note A_, 1
	intensity $a1
	note A_, 1
	intensity $a1
	note A_, 1
	intensity $b1
	note A_, 1
	intensity $b1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $c1
	note A_, 1
	intensity $d1
	note A_, 1
	intensity $d1
	note A_, 1
	intensity $e1
	note A_, 1
	intensity $e1
	note A_, 1
	intensity $f1
	note A_, 1
	note __, 4

; FinalDrop: 4 bars (v3).
Music_ArcherBattle_Ch1_FinalDrop:
	notetype 12, $f1
	sound_duty 2, 2, 2, 2
	octave 1
	note __, 3
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note F_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note D_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note C_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note D_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note C_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note F_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note F_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note G_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note F_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note D_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note C_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note D_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note F_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note E_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note D_, 1
	intensity $82
	octave 2
	note A_, 1
	intensity $82
	octave 3
	note C_, 1
	intensity $82
	octave 2
	note A_, 1
	sound_duty 0, 1, 2, 1
	intensity $c2
	octave 1
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	intensity $c1
	note E_, 1
	note E_, 1
	note __, 2
	intensity $c2
	note G#, 2
	intensity $c4
	note B_, 2
	loopchannel 0, Music_ArcherBattle_Ch1_Loop

Music_ArcherBattle_Ch2:

; Intro: 2 bars (v3).
Music_ArcherBattle_Ch2_Intro:
	notetype 12, $2f
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 2
	note A_, 16
	intensity $2f
	note A#, 16

Music_ArcherBattle_Ch2_Loop:

; Hammer: 2 bars (v3).
Music_ArcherBattle_Ch2_Hammer:
	notetype 12, $c2
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 2
	note A_, 6
	note A_, 4
	octave 3
	note C_, 2
	intensity $c7
	octave 2
	note A#, 4
	intensity $c2
	note A_, 6
	note A_, 4
	octave 3
	note C_, 2
	intensity $c7
	octave 2
	note B_, 4

; Main: 8 bars (v3).
Music_ArcherBattle_Ch2_Main:
	notetype 12, $b7
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 2
	note A_, 6
	intensity $b7
	note G#, 6
	intensity $b7
	note E_, 4
	intensity $b4
	note A_, 4
	intensity $b2
	note B_, 2
	intensity $b4
	octave 3
	note C_, 4
	intensity $b2
	note D_, 2
	intensity $b4
	note E_, 4
	intensity $b7
	note F_, 6
	intensity $b2
	note E_, 2
	intensity $b2
	note D_, 2
	intensity $b2
	note C_, 2
	intensity $b4
	note D_, 4
	intensity $b7
	note E_, 8
	note __, 2
	intensity $b2
	octave 2
	note B_, 2
	intensity $b2
	octave 3
	note C_, 2
	intensity $b2
	note D_, 2
	intensity $c7
	octave 2
	note A_, 6
	intensity $c7
	note G#, 6
	intensity $c4
	note E_, 4
	intensity $c4
	octave 3
	note C_, 4
	intensity $c2
	octave 2
	note B_, 2
	intensity $c4
	note A_, 4
	intensity $c2
	note G#, 2
	intensity $c4
	note A_, 4
	intensity $c7
	note A#, 6
	intensity $c7
	note A_, 6
	intensity $c4
	note F_, 4
	intensity $c7
	note E_, 8
	note __, 2
	intensity $c2
	note E_, 2
	intensity $c2
	note G#, 2
	intensity $c2
	note B_, 2

; LeadUp: 8 bars (v3).
Music_ArcherBattle_Ch2_LeadUp:
	notetype 12, $84
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 2
	note F_, 3
	intensity $84
	note A_, 3
	intensity $83
	octave 3
	note C_, 2
	intensity $84
	note E_, 4
	intensity $84
	note C_, 4
	intensity $94
	octave 2
	note F_, 3
	intensity $94
	note A_, 3
	intensity $93
	octave 3
	note C_, 2
	intensity $94
	note F_, 4
	intensity $94
	note E_, 4
	intensity $94
	octave 2
	note G_, 3
	intensity $94
	note B_, 3
	intensity $93
	octave 3
	note D_, 2
	intensity $94
	note F_, 4
	intensity $94
	note D_, 4
	intensity $a4
	octave 2
	note G_, 3
	intensity $a4
	note B_, 3
	intensity $a3
	octave 3
	note D_, 2
	intensity $a4
	note G_, 4
	intensity $a4
	note F_, 4
	intensity $b4
	octave 2
	note A_, 3
	intensity $b4
	octave 3
	note C_, 3
	intensity $b3
	note E_, 2
	intensity $b4
	note A_, 4
	intensity $b4
	note E_, 4
	intensity $c4
	octave 2
	note A_, 3
	intensity $c4
	octave 3
	note C_, 3
	intensity $c3
	note E_, 2
	intensity $c4
	note A_, 4
	intensity $c4
	note B_, 4
	intensity $91
	note E_, 1
	intensity $91
	note E_, 1
	intensity $a1
	note E_, 1
	intensity $a1
	note E_, 1
	intensity $b1
	note E_, 1
	intensity $b1
	note E_, 1
	intensity $b1
	note E_, 1
	intensity $c1
	note E_, 1
	intensity $c1
	note E_, 1
	intensity $d1
	note E_, 1
	intensity $d1
	note E_, 1
	intensity $d1
	note E_, 1
	intensity $e1
	note E_, 1
	intensity $e1
	note E_, 1
	intensity $f1
	note E_, 1
	intensity $f1
	note E_, 1
	intensity $c1
	note E_, 1
	intensity $c1
	note F_, 1
	intensity $d1
	note F#, 1
	intensity $d1
	note G_, 1
	intensity $d1
	note G#, 1
	intensity $d1
	note A_, 1
	intensity $e1
	note A#, 1
	intensity $e1
	note B_, 1
	intensity $e1
	octave 4
	note C_, 1
	intensity $e1
	note C#, 1
	intensity $f1
	note D_, 1
	intensity $f1
	note D#, 1
	note __, 4

; Wobble: 4 bars (v3).
Music_ArcherBattle_Ch2_Wobble:
	notetype 12, $d4
	sound_duty $1, $1, $1, $1
	vibrato $12, $64
	octave 2
	note A_, 4
	note __, 4
	intensity $d2
	octave 3
	note E_, 2
	note __, 1
	intensity $d2
	note E_, 1
	intensity $d2
	note D_, 2
	intensity $d2
	note C_, 2
	intensity $d4
	octave 2
	note A#, 3
	intensity $d4
	note A_, 3
	intensity $d2
	note G#, 2
	intensity $d4
	note A_, 4
	note __, 4
	intensity $d4
	note A_, 4
	note __, 4
	intensity $d2
	octave 3
	note E_, 2
	note __, 1
	intensity $d2
	note E_, 1
	intensity $d2
	note F_, 2
	intensity $d2
	note E_, 2
	intensity $d4
	note D_, 3
	intensity $d4
	note C_, 3
	intensity $d2
	octave 2
	note A#, 2
	intensity $d2
	note A_, 1
	intensity $d2
	note G#, 1
	intensity $d2
	note A_, 1
	intensity $d2
	note B_, 1
	intensity $d2
	octave 3
	note C_, 1
	intensity $d2
	note D_, 1
	intensity $d2
	note E_, 2

; Toccata: 4 bars (v3).
Music_ArcherBattle_Ch2_Toccata:
	notetype 12, $91
	sound_duty $1, $1, $1, $1
	vibrato $12, $64
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $c2
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note G_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $c2
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	note A#, 1
	intensity $c2
	note A_, 1
	intensity $c2
	note G#, 1
; Final E bar: thin the growl and widen the rhythm into the bridge.
	notetype 12, $91
	sound_duty 1, 1, 1, 1
	vibrato $12, $64
	octave 2
	note G#, 1
	intensity $c2
	note B_, 1
	intensity $91
	note G#, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note G#, 1
	intensity $b2
	note B_, 1
	intensity $91
	note G#, 1
	intensity $b2
	octave 3
	note D_, 1
	intensity $b3
	octave 3
	note E_, 2
	note D_, 2
	octave 2
	note B_, 2
	intensity $a4
	note G#, 2

; CommandBridge: 4 bars (v1).
Music_ArcherBattle_Ch2_CommandBridge:
; Clean A-minor landing: one pulse lead over rounded bass; no counterline.
; Keep the lead pitches in the surrounding register into v1's F3 phrase.
	notetype 12, $a4
	sound_duty 2, 2, 2, 2
	vibrato 0, 0
	octave 2
	note A_, 2
	octave 3
	note C_, 2
	octave 2
	note B_, 2
	note A_, 2
	intensity $a7
	note B_, 4
	octave 3
	note D_, 4
	notetype 12, $b7
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 3
	note F_, 8
	note E_, 4
	note D_, 4
	note G#, 6
	note F_, 6
	note E_, 4
	note D_, 4
	note C_, 4
	octave 2
	note B_, 4
	note G#, 4

; SecondRise: 4 bars (v1).
Music_ArcherBattle_Ch2_SecondRise:
	notetype 12, $62
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 3
	note C_, 2
	intensity $72
	note C_, 2
	intensity $72
	note C_, 2
	intensity $82
	note C_, 2
	intensity $82
	note C_, 2
	intensity $92
	note C_, 2
	intensity $92
	note C_, 2
	intensity $a2
	note C_, 2
	intensity $a2
	note C#, 2
	intensity $a2
	note C#, 2
	intensity $b2
	note C#, 2
	intensity $b2
	note C#, 2
	intensity $b2
	note C#, 2
	intensity $c2
	note C#, 2
	intensity $c2
	note C#, 2
	intensity $d2
	note C#, 2
	intensity $a1
	note D_, 1
	intensity $a1
	note D_, 1
	intensity $b1
	note D_, 1
	intensity $b1
	note D_, 1
	intensity $b1
	note D_, 1
	intensity $b1
	note D_, 1
	intensity $c1
	note D_, 1
	intensity $c1
	note D_, 1
	intensity $c1
	note D_, 1
	intensity $c1
	note D_, 1
	intensity $d1
	note D_, 1
	intensity $d1
	note D_, 1
	intensity $d1
	note D_, 1
	intensity $d1
	note D_, 1
	intensity $e1
	note D_, 1
	intensity $e1
	note D_, 1
	intensity $b1
	note D#, 1
	intensity $b1
	note D#, 1
	intensity $c1
	note D#, 1
	intensity $c1
	note D#, 1
	intensity $c1
	note D#, 1
	intensity $c1
	note D#, 1
	intensity $d1
	note D#, 1
	intensity $d1
	note D#, 1
	intensity $d1
	note D#, 1
	intensity $d1
	note D#, 1
	intensity $e1
	note D#, 1
	intensity $e1
	note D#, 1
	note __, 4

; HalfTimeHook: 8 bars (v1).
Music_ArcherBattle_Ch2_HalfTimeHook:
	notetype 12, $c2
	sound_duty $2, $2, $2, $2
	vibrato $12, $64
	octave 3
	note A_, 2
	note __, 1
	intensity $c2
	note A_, 1
	note __, 2
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c2
	note A_, 2
	intensity $c2
	octave 4
	note C_, 2
	intensity $c2
	octave 3
	note A#, 2
	intensity $c4
	octave 4
	note E_, 3
	intensity $c4
	note D_, 3
	intensity $c2
	note C_, 2
	intensity $c4
	octave 3
	note B_, 3
	intensity $c4
	note A_, 3
	intensity $c2
	note G#, 2
	intensity $c2
	note A_, 2
	note __, 1
	intensity $c2
	note A_, 1
	note __, 2
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c2
	note A_, 2
	intensity $c2
	octave 4
	note C_, 2
	intensity $c2
	octave 3
	note A#, 2
	intensity $c4
	octave 4
	note E_, 3
	intensity $c4
	note F_, 3
	intensity $c2
	note E_, 2
	intensity $c2
	note D_, 2
	intensity $c2
	note C_, 2
	intensity $c2
	octave 3
	note A#, 2
	intensity $c2
	note G#, 2
	intensity $c2
	note A_, 2
	note __, 1
	intensity $c2
	note A_, 1
	note __, 2
	intensity $c2
	note A_, 2
	note __, 2
	intensity $c2
	note A_, 2
	intensity $c2
	octave 4
	note C_, 2
	intensity $c2
	octave 3
	note A#, 2
	intensity $c4
	octave 4
	note F_, 3
	intensity $c4
	note E_, 3
	intensity $c2
	note C_, 2
	intensity $c4
	octave 3
	note A_, 3
	intensity $c4
	note F_, 3
	intensity $c2
	note D_, 2
	intensity $c2
	note B_, 2
	note __, 1
	intensity $c2
	note B_, 1
	note __, 2
	intensity $c2
	note B_, 2
	note __, 2
	intensity $c2
	note B_, 2
	intensity $c2
	octave 4
	note D_, 2
	intensity $c2
	note C_, 2
	intensity $c4
	note E_, 3
	intensity $c4
	note D_, 3
	intensity $c2
	note C_, 2
	intensity $c4
	octave 3
	note B_, 3
	intensity $c4
	note G#, 3
	intensity $c2
	note E_, 2

; Breakdown: 4 bars (v3).
Music_ArcherBattle_Ch2_Breakdown:
	notetype 12, $d4
	sound_duty $1, $1, $1, $1
	vibrato $12, $64
	octave 2
	note A_, 3
	intensity $d4
	note A_, 3
	intensity $d2
	octave 3
	note C_, 2
	intensity $d4
	octave 2
	note A#, 4
	note __, 4
	intensity $d4
	note A_, 3
	intensity $d4
	note A_, 3
	intensity $d2
	octave 3
	note E_, 2
	intensity $d4
	note D_, 4
	note __, 4
	intensity $d4
	octave 2
	note A_, 3
	intensity $d4
	note A_, 3
	intensity $d2
	octave 3
	note C_, 2
	intensity $d4
	octave 2
	note A#, 4
	note __, 4
	intensity $a1
	note E_, 1
	intensity $b1
	note F_, 1
	intensity $b1
	note G#, 1
	intensity $c1
	note A_, 1
	intensity $c1
	note B_, 1
	intensity $d1
	octave 3
	note C_, 1
	intensity $d1
	note D_, 1
	intensity $e1
	note E_, 1
	intensity $e1
	note F_, 1
	intensity $f1
	note G#, 1
	intensity $d4
	note A_, 2
	note __, 4

; FinalDrop: 4 bars (v3).
Music_ArcherBattle_Ch2_FinalDrop:
	notetype 12, $91
	sound_duty $1, $1, $1, $1
	vibrato $12, $64
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $c2
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note G_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $c2
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	octave 3
	note C_, 1
	intensity $91
	octave 2
	note A_, 1
	intensity $c2
	note A#, 1
	intensity $c2
	note A_, 1
	intensity $c2
	note G#, 1
	intensity $d2
	octave 3
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	intensity $d1
	note E_, 1
	note E_, 1
	note __, 2
	intensity $d2
	octave 2
	note G#, 2
	intensity $d4
	note B_, 2
	loopchannel 0, Music_ArcherBattle_Ch2_Loop

Music_ArcherBattle_Ch3:

; Intro: 2 bars (v3).
Music_ArcherBattle_Ch3_Intro:
	notetype 12, $1b
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 11
	note A_, 2
	note __, 1
	note A_, 2
	note __, 11

Music_ArcherBattle_Ch3_Loop:

; Hammer: 2 bars (v3).
Music_ArcherBattle_Ch3_Hammer:
	notetype 12, $1b
	octave 1
	note A_, 6
	note A_, 4
	octave 2
	note C_, 2
	octave 1
	note A#, 4
	note A_, 6
	note A_, 4
	octave 2
	note C_, 2
	octave 1
	note B_, 4

; Main: 8 bars (v3).
Music_ArcherBattle_Ch3_Main:
	notetype 12, $1b
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	octave 2
	note E_, 2
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note E_, 1
	note __, 1
	note C_, 1
	octave 1
	note A#, 1
	octave 2
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	octave 3
	note F_, 1
	note __, 1
	octave 2
	note F_, 1
	note F_, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	octave 3
	note F_, 1
	note __, 1
	octave 2
	note F_, 1
	note F_, 1
	octave 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	octave 2
	note E_, 1
	note __, 1
	octave 1
	note E_, 1
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	octave 2
	note E_, 1
	note __, 1
	octave 1
	note G_, 1
	note G#, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	octave 2
	note E_, 1
	note __, 1
	note C_, 1
	octave 1
	note A#, 1
	note A#, 1
	note __, 1
	note A#, 1
	note A#, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note A#, 1
	note A#, 1
	note __, 1
	note A#, 1
	note A#, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note A#, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	octave 2
	note E_, 1
	note __, 1
	octave 1
	note E_, 1
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	octave 2
	note E_, 1
	note __, 1
	octave 1
	note G#, 1
	note B_, 1

; LeadUp: 8 bars (v3).
Music_ArcherBattle_Ch3_LeadUp:
	notetype 12, $2b
	octave 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	intensity $1b
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note __, 4

; Wobble: 4 bars (v3).
Music_ArcherBattle_Ch3_Wobble:
	notetype 6, $1b
	octave 1
	note A_, 8
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $1b
	note C_, 1
	intensity $10
	note C_, 1
	intensity $10
	note C_, 1
	intensity $1b
	octave 1
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $10
	note A#, 1
	intensity $10
	note A#, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	note __, 4
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	octave 1
	note A_, 8
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $1b
	note C_, 1
	intensity $10
	note C_, 1
	intensity $10
	note C_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A#, 1
	intensity $10
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $10
	note A#, 1
	intensity $1b
	note B_, 1
	intensity $10
	note B_, 1
	intensity $1b
	note B_, 1
	intensity $10
	note B_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $10
	note C_, 1
	intensity $1b
	note C_, 1
	intensity $10
	note C_, 1
	intensity $1b
	note C#, 1
	intensity $10
	note C#, 1
	intensity $1b
	note C#, 1
	intensity $10
	note C#, 1

; Toccata: 4 bars (v3).
Music_ArcherBattle_Ch3_Toccata:
	notetype 6, $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note G_, 1
	intensity $1b
	note G_, 1
	intensity $10
	note G_, 1
	intensity $10
	note G_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $12
	note F_, 1
	intensity $12
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	octave 2
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	octave 1
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $12
	note F_, 1
	intensity $12
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	octave 2
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $12
	note D_, 1
	intensity $12
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $12
	note D_, 1
	intensity $12
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note C_, 1
	intensity $1b
	note C_, 1
	intensity $10
	note C_, 1
	intensity $10
	note C_, 1
; Final E bar: thin the growl and widen the rhythm into the bridge.
	notetype 6, $1b
	octave 1
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	octave 2
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	octave 1
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note E_, 2
	intensity $12
	note E_, 2
	intensity $1b
	note E_, 2
	note E_, 2
	notetype 12, $1b
	note E_, 2
	note __, 2
	note E_, 2
	note G#, 1
	note B_, 1

; CommandBridge: 4 bars (v1).
Music_ArcherBattle_Ch3_CommandBridge:
; Clean A-minor landing: one pulse lead over rounded bass; no counterline.
; Keep the lead pitches in the surrounding register into v1's F3 phrase.
	notetype 12, $10
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	note A_, 2
	note __, 2
	note A_, 2
	note __, 1
	note A_, 1
	octave 2
	note E_, 2
	octave 1
	note A_, 2
	notetype 12, $1b
	octave 1
	note A#, 2
	note __, 1
	note A#, 2
	note __, 1
	octave 2
	note A#, 2
	octave 1
	note A#, 2
	note __, 1
	note A#, 2
	note __, 1
	octave 2
	note A#, 2
	octave 1
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	octave 2
	note E_, 2
	octave 1
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note B_, 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	octave 2
	note E_, 2
	octave 1
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 2

; SecondRise: 4 bars (v1).
Music_ArcherBattle_Ch3_SecondRise:
	notetype 12, $1b
	octave 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note F#, 2
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note __, 4

; HalfTimeHook: 8 bars (v1).
Music_ArcherBattle_Ch3_HalfTimeHook:
	notetype 12, $1b
	octave 1
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note F_, 3
	note F_, 3
	octave 2
	note F_, 2
	octave 1
	note F_, 2
	note __, 1
	note F_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note F_, 3
	note F_, 3
	octave 2
	note F_, 2
	octave 1
	note F_, 2
	note __, 1
	note F_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note E_, 3
	note E_, 3
	octave 2
	note E_, 2
	octave 1
	note E_, 2
	note __, 1
	note E_, 1
	note G_, 2
	note F_, 2
	note E_, 3
	note E_, 3
	octave 2
	note E_, 2
	octave 1
	note E_, 2
	note __, 1
	note E_, 1
	note G#, 2
	note B_, 2

; Breakdown: 4 bars (v3).
Music_ArcherBattle_Ch3_Breakdown:
	notetype 6, $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	note __, 4
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $12
	note A#, 1
	intensity $12
	note A#, 1
	intensity $10
	note A#, 1
	intensity $10
	note A#, 1
	intensity $10
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $1b
	note A#, 1
	intensity $10
	note A#, 1
	intensity $10
	note A#, 1
	intensity $1b
	note G#, 1
	intensity $1b
	note G#, 1
	intensity $10
	note G#, 1
	intensity $10
	note G#, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	note __, 4
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	note __, 8

; FinalDrop: 4 bars (v3).
Music_ArcherBattle_Ch3_FinalDrop:
	notetype 6, $1b
	octave 1
	note A_, 8
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $12
	note A_, 1
	intensity $12
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	note G_, 1
	intensity $1b
	note G_, 1
	intensity $10
	note G_, 1
	intensity $10
	note G_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $12
	note F_, 1
	intensity $12
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	octave 2
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	octave 1
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $12
	note F_, 1
	intensity $12
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $10
	note F_, 1
	intensity $10
	note F_, 1
	intensity $1b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	octave 2
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $12
	note D_, 1
	intensity $12
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $10
	note A_, 1
	intensity $10
	note A_, 1
	intensity $1b
	octave 2
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $12
	note D_, 1
	intensity $12
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $1b
	note D_, 1
	intensity $10
	note D_, 1
	intensity $10
	note D_, 1
	intensity $1b
	note C_, 1
	intensity $1b
	note C_, 1
	intensity $10
	note C_, 1
	intensity $10
	note C_, 1
	intensity $1b
	octave 1
	note E_, 4
	note __, 4
	intensity $1b
	note E_, 4
	note __, 4
	intensity $1b
	note E_, 2
	intensity $1b
	note E_, 2
	note __, 4
	intensity $1b
	note G#, 4
	intensity $1b
	note B_, 4
	loopchannel 0, Music_ArcherBattle_Ch3_Loop

Music_ArcherBattle_Ch4:
	togglenoise 6

; Intro: 2 bars (v3).
Music_ArcherBattle_Ch4_Intro:
	notetype 12
	note C_, 3
	note C_, 13
	note C_, 3
	note C_, 9
	note G#, 2
	note G#, 2

Music_ArcherBattle_Ch4_Loop:

; Hammer: 2 bars (v3).
Music_ArcherBattle_Ch4_Hammer:
	notetype 12
	note C_, 6
	note C_, 4
	note C#, 2
	note C_, 4
	note C_, 6
	note C_, 4
	note C#, 1
	note D_, 1
	note F#, 1
	note F#, 1
	note G_, 1
	note G#, 1

; Main: 8 bars (v3).
Music_ArcherBattle_Ch4_Main:
	notetype 12
	note F_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note C#, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note F#, 1
	note G_, 1
	note F_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note F#, 1
	note F#, 1
	note G_, 1
	note G#, 1

; LeadUp: 8 bars (v3).
Music_ArcherBattle_Ch4_LeadUp:
	notetype 12
	note C_, 8
	note C_, 8
	note C_, 8
	note C_, 4
	note C_, 2
	note C_, 2
	note C_, 4
	note C#, 4
	note C_, 4
	note C#, 4
	note C_, 4
	note C#, 4
	note C_, 4
	note C#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 6
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 9

; Wobble: 4 bars (v3).
Music_ArcherBattle_Ch4_Wobble:
	notetype 12
	note F_, 6
	note C_, 2
	note C#, 3
	note C_, 1
	note D#, 2
	note D#, 2
	note C_, 4
	note D#, 2
	note C_, 2
	note C#, 2
	note C_, 1
	note C_, 1
	note D#, 2
	note D#, 1
	note D#, 1
	note C_, 6
	note C_, 2
	note C#, 3
	note C_, 1
	note D#, 2
	note D#, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1

; Toccata: 4 bars (v3).
Music_ArcherBattle_Ch4_Toccata:
	notetype 12
	note F_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
; Final E bar: thin the growl and widen the rhythm into the bridge.
	notetype 12
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1

; CommandBridge: 4 bars (v1).
Music_ArcherBattle_Ch4_CommandBridge:
; Clean A-minor landing: one pulse lead over rounded bass; no counterline.
; Keep the lead pitches in the surrounding register into v1's F3 phrase.
	notetype 12
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	notetype 12
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note E_, 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note E_, 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1

; SecondRise: 4 bars (v1).
Music_ArcherBattle_Ch4_SecondRise:
	notetype 12
	note C_, 4
	note C#, 4
	note C_, 4
	note C#, 4
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 6
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 9

; HalfTimeHook: 8 bars (v1).
Music_ArcherBattle_Ch4_HalfTimeHook:
	notetype 12
	note F_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 2
	note D#, 2
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note C#, 3
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C#, 1

; Breakdown: 4 bars (v3).
Music_ArcherBattle_Ch4_Breakdown:
	notetype 12
	note C_, 8
	note B_, 8
	note C_, 8
	note B_, 8
	note C_, 8
	note B_, 4
	note B_, 2
	note B_, 2
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 5

; FinalDrop: 4 bars (v3).
Music_ArcherBattle_Ch4_FinalDrop:
	notetype 12
	note F_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D#, 1
	note F_, 4
	note C_, 4
	note C_, 1
	note C_, 3
	note F#, 1
	note F#, 1
	note G#, 1
	note G#, 1
	loopchannel 0, Music_ArcherBattle_Ch4_Loop

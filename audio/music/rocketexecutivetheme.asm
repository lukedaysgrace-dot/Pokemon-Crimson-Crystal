; Rocket Executive Theme - Crimson Crystal (new; not hooked up).
; A minor / A Phrygian. tempo 156, notetype 12: ~123 BPM.
; Intro 4 (swells, grunt slither + hammer) | Main 8 (deep A-G#-E theme)
; | Lead-up 8 (climbing line, swelling arps, snare roll, one beat of silence)
; | Drop 16: wobble (saw bass swapping wave 11/2/0 per 32nd + ch1 growl via
; sound_duty) / toccata (16ths around an A pedal) / break it down (kick+clap,
; chant, answers, silence) / re-drop (ch1 chases the toccata) | loop to intro bar 3.
; Loop: 544 sixteenths, ~3978 sound updates (~66.6 s).
; Ch1 uses sound_duty from the loop point on (constant patterns stand in for
; dutycycle). Ch4: drumkit 6 (Rocket kit in drumkits.asm).

Music_RocketExecutiveTheme:
	musicheader 4, 1, Music_RocketExecutiveTheme_Ch1
	musicheader 1, 2, Music_RocketExecutiveTheme_Ch2
	musicheader 1, 3, Music_RocketExecutiveTheme_Ch3
	musicheader 1, 4, Music_RocketExecutiveTheme_Ch4

Music_RocketExecutiveTheme_Ch1:
	tempo 156
	volume $77
	dutycycle $2
	notetype $c, $2f
	intensity $2f
	octave 2
	note E_, 16
	intensity $2f
	note F_, 16
Music_RocketExecutiveTheme_Ch1_Loop:
	sound_duty 1, 1, 1, 1
	intensity $51
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
	sound_duty 0, 0, 0, 0
	intensity $92
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
	sound_duty 1, 1, 1, 1
	intensity $41
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
	sound_duty 0, 1, 2, 1
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
	intensity $a2
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
	intensity $a2
	octave 1
	note E_, 2
	note __, 2
	note E_, 2
	note E_, 2
	note __, 2
	note E_, 2
	octave 2
	note E_, 2
	octave 1
	note E_, 2
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
	sound_duty 2, 2, 2, 2
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
	loopchannel 0, Music_RocketExecutiveTheme_Ch1_Loop

Music_RocketExecutiveTheme_Ch2:
	dutycycle $2
	vibrato $12, $64
	notetype $c, $2f
	intensity $2f
	octave 2
	note A_, 16
	intensity $2f
	note A#, 16
Music_RocketExecutiveTheme_Ch2_Loop:
	dutycycle $2
	intensity $c2
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
	dutycycle $2
	intensity $b7
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
	dutycycle $2
	intensity $84
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
	dutycycle $1
	intensity $d4
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
	intensity $91
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
	intensity $c2
	note B_, 1
	intensity $91
	note G#, 1
	intensity $c2
	octave 3
	note D_, 1
	intensity $91
	octave 2
	note G#, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $91
	octave 2
	note G#, 1
	intensity $c2
	octave 3
	note F_, 1
	intensity $91
	octave 2
	note G#, 1
	intensity $c2
	octave 3
	note E_, 1
	intensity $c2
	note D_, 1
	intensity $c2
	octave 2
	note B_, 1
	intensity $d4
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
	loopchannel 0, Music_RocketExecutiveTheme_Ch2_Loop

Music_RocketExecutiveTheme_Ch3:
	notetype $c, $1b
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 11
	note A_, 2
	note __, 1
	note A_, 2
	note __, 11
Music_RocketExecutiveTheme_Ch3_Loop:
	intensity $1b
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
	intensity $1b
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
	intensity $2b
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
	notetype 6, $1b
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
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $12
	note E_, 1
	intensity $12
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
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
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $10
	note E_, 1
	intensity $10
	note E_, 1
	intensity $1b
	octave 1
	note G#, 1
	intensity $10
	note G#, 1
	intensity $1b
	note G#, 1
	intensity $10
	note G#, 1
	intensity $1b
	note B_, 1
	intensity $10
	note B_, 1
	intensity $1b
	note B_, 1
	intensity $10
	note B_, 1
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
	notetype $c, $1b
	loopchannel 0, Music_RocketExecutiveTheme_Ch3_Loop

Music_RocketExecutiveTheme_Ch4:
	togglenoise 6
	notetype $c
	note C_, 3
	note C_, 13
	note C_, 3
	note C_, 9
	note G#, 2
	note G#, 2
Music_RocketExecutiveTheme_Ch4_Loop:
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
	notetype $c
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
	note C_, 2
	note D#, 1
	note D#, 1
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
	loopchannel 0, Music_RocketExecutiveTheme_Ch4_Loop

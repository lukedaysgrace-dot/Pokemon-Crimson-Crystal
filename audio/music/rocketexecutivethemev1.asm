; Rocket Executive Theme v1 (first version) - Crimson Crystal. Archive copy, not hooked up.
; A minor / A Phrygian. tempo 156, notetype 12: ~123 BPM.
; Intro 4 | A 8 (deep main melody) | B 8 (command) | Build 4 (lead-up,
; one beat of silence) | Break It Down 8 (bass drop, half-time hook)
; | Break It Down 2 8 (wub bass, shadowed hook, tom run) | loop to A.
; Loop: 576 sixteenths, ~4212 sound updates (~70.5 s).
; Built on the grunt battle theme: its chromatic slither (intro/riser),
; its A-A-C-Bb hammer rhythm (ostinato/hook) and its A-G#-E melody cell.
; Ch1: swells / ostinato / pads / riser / hook octave; Ch2: lead;
; Ch3: saw bass (wave 11); Ch4: drumkit 6 (Rocket kit in drumkits.asm).

Music_RocketExecutiveThemeV1:
	musicheader 4, 1, Music_RocketExecutiveThemeV1_Ch1
	musicheader 1, 2, Music_RocketExecutiveThemeV1_Ch2
	musicheader 1, 3, Music_RocketExecutiveThemeV1_Ch3
	musicheader 1, 4, Music_RocketExecutiveThemeV1_Ch4

Music_RocketExecutiveThemeV1_Ch1:
	tempo 156
	volume $77
	dutycycle $2
	notetype $c, $2f
	intensity $2f
	octave 2
	note E_, 16
	intensity $2f
	note F_, 16
	dutycycle $1
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
Music_RocketExecutiveThemeV1_Ch1_Loop:
	dutycycle $0
	intensity $92
	octave 3
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note A_, 6
	note A_, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	intensity $92
	note E_, 6
	note E_, 4
	note G#, 2
	note F_, 4
	intensity $92
	note E_, 6
	note E_, 4
	note G#, 2
	note F_, 4
	dutycycle $3
	intensity $77
	note D_, 8
	note D_, 8
	note F_, 8
	note D_, 8
	note C_, 8
	octave 2
	note A_, 8
	octave 3
	note C_, 8
	octave 2
	note B_, 8
	note A#, 8
	note F_, 8
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
	dutycycle $1
	intensity $62
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
	dutycycle $1
	intensity $a2
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
	dutycycle $3
	intensity $92
	octave 3
	note E_, 2
	note __, 1
	intensity $92
	note E_, 1
	note __, 2
	intensity $92
	note E_, 2
	note __, 2
	intensity $92
	note E_, 2
	intensity $92
	note A_, 2
	intensity $92
	note F_, 2
	intensity $94
	octave 4
	note C_, 3
	intensity $94
	octave 3
	note A_, 3
	intensity $92
	note A_, 2
	intensity $94
	note E_, 3
	intensity $94
	note E_, 3
	intensity $92
	note F_, 2
	intensity $92
	note E_, 2
	note __, 1
	intensity $92
	note E_, 1
	note __, 2
	intensity $92
	note E_, 2
	note __, 2
	intensity $92
	note E_, 2
	intensity $92
	note A_, 2
	intensity $92
	note F_, 2
	intensity $94
	octave 4
	note C_, 3
	intensity $94
	note C_, 3
	intensity $92
	note C_, 2
	intensity $92
	octave 3
	note A_, 2
	intensity $92
	note A_, 2
	intensity $92
	note F_, 2
	intensity $92
	note F_, 2
	intensity $92
	note F_, 2
	note __, 1
	intensity $92
	note F_, 1
	note __, 2
	intensity $92
	note F_, 2
	note __, 2
	intensity $92
	note F_, 2
	intensity $92
	note F_, 2
	intensity $92
	note F_, 2
	intensity $94
	octave 4
	note C_, 3
	intensity $94
	note C_, 3
	intensity $92
	octave 3
	note F_, 2
	intensity $94
	note F_, 3
	intensity $94
	note C_, 3
	intensity $92
	octave 2
	note A#, 2
	intensity $92
	octave 3
	note G#, 2
	note __, 1
	intensity $92
	note G#, 1
	note __, 2
	intensity $92
	note G#, 2
	note __, 2
	intensity $92
	note G#, 2
	intensity $92
	note B_, 2
	intensity $92
	note G_, 2
	intensity $92
	note G#, 2
	note F_, 2
	note E_, 2
	note D_, 2
	intensity $a7
	note E_, 8
	loopchannel 0, Music_RocketExecutiveThemeV1_Ch1_Loop

Music_RocketExecutiveThemeV1_Ch2:
	dutycycle $2
	vibrato $12, $64
	notetype $c, $2f
	intensity $2f
	octave 2
	note A_, 16
	intensity $2f
	note A#, 16
	intensity $c2
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
Music_RocketExecutiveThemeV1_Ch2_Loop:
	dutycycle $2
	intensity $b7
	octave 2
	note A_, 6
	note G#, 6
	note E_, 4
	note A_, 6
	note B_, 6
	octave 3
	note C_, 4
	note D_, 6
	note C_, 6
	octave 2
	note A#, 4
	intensity $a0
	note A#, 10
	intensity $b7
	note A_, 2
	note A#, 2
	octave 3
	note C_, 2
	note C_, 6
	octave 2
	note A_, 6
	note F_, 4
	octave 3
	note D_, 6
	note E_, 6
	note F_, 4
	intensity $a0
	note E_, 12
	intensity $b7
	note F_, 2
	note E_, 2
	octave 2
	note B_, 6
	octave 3
	note C_, 6
	octave 2
	note B_, 2
	note G#, 2
	intensity $b7
	octave 3
	note F_, 6
	note E_, 6
	note D_, 4
	note A_, 8
	note G_, 4
	note F_, 4
	note E_, 6
	note D_, 6
	note C_, 4
	intensity $a0
	note E_, 10
	intensity $b7
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 6
	note C_, 6
	octave 2
	note A#, 4
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
	dutycycle $2
	intensity $62
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
	dutycycle $2
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
	note D_, 3
	note C_, 2
	octave 3
	note B_, 2
	note G#, 2
	intensity $c7
	note B_, 4
	loopchannel 0, Music_RocketExecutiveThemeV1_Ch2_Loop

Music_RocketExecutiveThemeV1_Ch3:
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
Music_RocketExecutiveThemeV1_Ch3_Loop:
	intensity $1b
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
	note A_, 2
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
	note F_, 2
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
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	octave 2
	note F_, 2
	octave 1
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	octave 2
	note C_, 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	note A_, 2
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
	octave 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	note A_, 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	octave 3
	note D_, 2
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
	note A_, 2
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
	note F_, 2
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
	intensity $1b
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
	intensity $1b
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	octave 2
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $2b
	note A_, 1
	note __, 1
	intensity $1b
	note A_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $2b
	note C_, 1
	intensity $1b
	octave 1
	note A#, 1
	intensity $2b
	note A#, 1
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
	intensity $1b
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	note A_, 1
	intensity $1b
	octave 2
	note A_, 1
	intensity $2b
	note A_, 1
	intensity $1b
	octave 1
	note A_, 1
	intensity $2b
	note A_, 1
	note __, 1
	intensity $1b
	note A_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $2b
	note C_, 1
	intensity $1b
	octave 1
	note A#, 1
	intensity $2b
	note A#, 1
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
	intensity $1b
	note F_, 1
	intensity $2b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $2b
	note F_, 1
	intensity $1b
	note F_, 1
	intensity $1b
	octave 2
	note F_, 1
	intensity $2b
	note F_, 1
	intensity $1b
	octave 1
	note F_, 1
	intensity $2b
	note F_, 1
	note __, 1
	intensity $1b
	note F_, 1
	intensity $1b
	octave 2
	note C_, 1
	intensity $2b
	note C_, 1
	intensity $1b
	octave 1
	note A#, 1
	intensity $2b
	note A#, 1
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
	intensity $1b
	note E_, 1
	intensity $2b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $2b
	note E_, 1
	intensity $1b
	note E_, 1
	intensity $1b
	octave 2
	note E_, 1
	intensity $2b
	note E_, 1
	intensity $1b
	octave 1
	note E_, 1
	intensity $2b
	note E_, 1
	note __, 1
	intensity $1b
	note E_, 1
	intensity $1b
	note G_, 1
	intensity $2b
	note G_, 1
	intensity $1b
	note F_, 1
	intensity $2b
	note F_, 1
	intensity $1b
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
	loopchannel 0, Music_RocketExecutiveThemeV1_Ch3_Loop

Music_RocketExecutiveThemeV1_Ch4:
	togglenoise 6
	notetype $c
	note C_, 3
	note C_, 13
	note C_, 3
	note C_, 9
	note G#, 2
	note G#, 2
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
Music_RocketExecutiveThemeV1_Ch4_Loop:
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
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
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
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
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
	note C_, 2
	note C_, 1
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
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
	note C_, 2
	note C_, 1
	note C#, 2
	note C#, 1
	note D_, 1
	note F#, 1
	note G_, 1
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
	notetype $c
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
	note F_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note C_, 2
	note C#, 2
	note D#, 1
	note C_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note C_, 3
	note C_, 3
	note C_, 2
	note F#, 1
	note F#, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note F_, 1
	note F_, 1
	loopchannel 0, Music_RocketExecutiveThemeV1_Ch4_Loop

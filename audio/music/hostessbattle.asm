; Hostess Battle - Crimson Crystal. Shucks' Friday-night stage show.
; D minor (harmonic), tempo 156, notetype 12 (~123 BPM club groove).
; Intro 4 | A (melody) 8 | B (club riff) 8 | Build 4 | Drop 8 | Bridge 4 | loop to A.
; First pass: 36 bars (~70 s). Loop: 32 bars. All four channels stay aligned.

Music_HostessBattle:
	musicheader 4, 1, Music_HostessBattle_Ch1
	musicheader 1, 2, Music_HostessBattle_Ch2
	musicheader 1, 3, Music_HostessBattle_Ch3
	musicheader 1, 4, Music_HostessBattle_Ch4

Music_HostessBattle_Ch1:
	tempo 156
	volume $77
; intro
	dutycycle 2
	vibrato $12, $33
	notetype 12, $c2
	octave 4
	note D_, 2
	note __, 1
	note D_, 1
	note __, 2
	note D_, 2
	intensity $a1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	intensity $c2
	note C#, 2
	note __, 1
	note C#, 1
	note __, 2
	note C#, 2
	intensity $b2
	note E_, 2
	intensity $b7
	note A_, 6
	note __, 16
	intensity $77
	octave 3
	note A_, 4
	intensity $97
	octave 4
	note C#, 4
	intensity $b7
	note E_, 4
	intensity $d7
	note G_, 4
Music_HostessBattle_Ch1_Loop:
; A
	dutycycle 2
	notetype 12, $b5
	octave 4
	note D_, 4
	note F_, 2
	note A_, 6
	note G_, 2
	note F_, 2
	note D_, 4
	note F_, 2
	note A#, 4
	note A_, 2
	note G_, 2
	note F_, 2
	note G_, 6
	note F_, 2
	note E_, 2
	note D_, 2
	octave 3
	note A#, 4
	octave 4
	note C#, 6
	note E_, 2
	note A_, 6
	note G_, 2
	octave 5
	note D_, 4
	note C_, 2
	octave 4
	note A_, 6
	note F_, 2
	note G_, 2
	note F_, 4
	note G_, 2
	note A#, 6
	note A_, 2
	note G_, 2
	note G_, 2
	note A_, 2
	note A#, 2
	octave 5
	note D_, 6
	note C_, 2
	octave 4
	note A#, 2
	intensity $b7
	note A_, 10
	intensity $b5
	note G_, 2
	note F_, 2
	note E_, 2
; B
	dutycycle 1
	intensity $c1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 1
	note G_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 1
	note C_, 1
	note __, 1
	octave 3
	note A_, 1
	note __, 1
	octave 4
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 1
	note G_, 1
	note __, 1
	note F_, 1
	note __, 1
	note E_, 1
	note F_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 1
	note A#, 1
	note __, 1
	note A_, 1
	note __, 1
	note F_, 1
	note D_, 1
	note __, 1
	octave 3
	note A#, 1
	note __, 1
	octave 4
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note F_, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A#, 1
	note __, 1
	note G_, 1
	octave 5
	note D_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 4
	note A#, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A#, 1
	note __, 1
	octave 5
	note D_, 1
	note C_, 1
	note __, 1
	octave 4
	note A#, 1
	note __, 1
	note A_, 1
	note A#, 1
	note __, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 5
	note C#, 1
	note __, 1
	octave 4
	note A_, 1
	octave 5
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	note C#, 1
	octave 4
	note A_, 1
	note __, 1
	note E_, 1
	note __, 1
	intensity $c3
	note E_, 2
	note G_, 2
	note A_, 2
	octave 5
	note C#, 2
	intensity $c7
	note E_, 4
	note __, 4
; build
	dutycycle 2
	intensity $92
	octave 3
	note A_, 2
	note A_, 2
	note A_, 2
	note A_, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	intensity $a2
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	octave 4
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	intensity $b1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	intensity $d1
	notetype 6, $d1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	notetype 12, $d1
	note __, 4
; drop
	dutycycle 1
	intensity $c2
	note __, 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 2
	note __, 2
	note G_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 2
	note __, 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 2
	note __, 2
	octave 5
	note C_, 1
	note __, 1
	octave 4
	note A_, 1
	note __, 1
	note G_, 1
	note F_, 1
	note __, 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 2
	note __, 2
	note A_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 2
	note __, 2
	note C#, 1
	note __, 1
	note E_, 1
	note __, 1
	note A_, 2
	note __, 2
	note G_, 1
	note __, 1
	note E_, 1
	note __, 1
	note C#, 2
	intensity $b2
	note __, 2
	octave 5
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 2
	note __, 2
	note G_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 2
	note __, 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 2
	note __, 2
	octave 6
	note C_, 1
	note __, 1
	octave 5
	note A_, 1
	note __, 1
	note G_, 1
	note F_, 1
	note __, 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 2
	note __, 2
	note A_, 1
	note __, 1
	note F_, 1
	note __, 1
	note D_, 2
	note __, 2
	note C#, 1
	note __, 1
	note E_, 1
	note __, 1
	note A_, 2
	notetype 6, $b2
	note A_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 4
	note A_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	octave 5
	note C#, 1
	note E_, 1
	note G_, 1
; bridge
	dutycycle 2
	intensity $b6
	notetype 12, $b6
	octave 4
	note F_, 6
	note D_, 2
	note A#, 8
	note G_, 6
	note E_, 2
	octave 5
	note C_, 8
	intensity $b7
	note C#, 8
	intensity $b5
	octave 4
	note A_, 4
	note E_, 4
	note A_, 4
	note G_, 2
	note F_, 2
	note E_, 4
	note C#, 4
	loopchannel 0, Music_HostessBattle_Ch1_Loop

Music_HostessBattle_Ch2:
; intro
	dutycycle 2
	notetype 12, $b2
	octave 3
	note A_, 2
	note __, 1
	note A_, 1
	note __, 2
	note A_, 2
	intensity $91
	octave 4
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	intensity $b2
	note A_, 2
	note __, 1
	note A_, 1
	note __, 2
	note A_, 2
	intensity $a2
	octave 4
	note C#, 2
	intensity $a7
	note E_, 6
	dutycycle 1
	intensity $81
	note __, 2
	octave 3
	note F_, 1
	note __, 1
	note __, 2
	note A_, 1
	note __, 1
	note __, 2
	note F_, 1
	note __, 1
	note __, 2
	note A_, 1
	note __, 1
	intensity $91
	note __, 2
	note E_, 1
	note __, 1
	note __, 2
	octave 4
	note C#, 1
	note __, 1
	note __, 2
	octave 3
	note E_, 1
	note __, 1
	note __, 2
	octave 4
	note C#, 1
	note __, 1
Music_HostessBattle_Ch2_Loop:
; A
	dutycycle 1
	notetype 12, $91
	note __, 2
	octave 3
	note F_, 1
	note __, 1
	note __, 2
	note A_, 1
	note __, 1
	note __, 2
	note F_, 1
	note __, 1
	note __, 2
	note A_, 1
	note __, 1
	note __, 2
	note F_, 1
	note __, 1
	note __, 2
	note A#, 1
	note __, 1
	note __, 2
	note F_, 1
	note __, 1
	note __, 2
	note A#, 1
	note __, 1
	note __, 2
	note G_, 1
	note __, 1
	note __, 2
	note A#, 1
	note __, 1
	note __, 2
	note G_, 1
	note __, 1
	note __, 2
	note A#, 1
	note __, 1
	note __, 2
	note E_, 1
	note __, 1
	note __, 2
	octave 4
	note C#, 1
	note __, 1
	note __, 2
	octave 3
	note E_, 1
	note __, 1
	note __, 2
	octave 4
	note C#, 1
	note __, 1
	dutycycle 2
	intensity $86
	note A_, 4
	note A_, 2
	note F_, 6
	note D_, 2
	note E_, 2
	note D_, 4
	note D_, 2
	note F_, 6
	note F_, 2
	note D_, 2
	note D_, 2
	note F_, 2
	note G_, 2
	note A#, 6
	note A_, 2
	note G_, 2
	intensity $87
	note E_, 10
	intensity $86
	note E_, 2
	note D_, 2
	note C#, 2
; B
	dutycycle 2
	intensity $67
	octave 3
	note A_, 8
	note F_, 8
	note A_, 6
	octave 4
	note C_, 2
	note D_, 8
	note D_, 8
	note F_, 8
	note F_, 6
	note D_, 2
	octave 3
	note A#, 8
	note A#, 8
	octave 4
	note D_, 8
	note D_, 6
	octave 3
	note A#, 2
	note G_, 8
	octave 4
	note C#, 8
	note E_, 8
	note E_, 4
	note G_, 4
	note A_, 4
	note __, 4
; build
	dutycycle 2
	intensity $72
	octave 2
	note A_, 2
	note A_, 2
	note A_, 2
	note A_, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	intensity $82
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	octave 3
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	intensity $91
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	intensity $b1
	notetype 6, $b1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F_, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	notetype 12, $b1
	note __, 4
; drop
	dutycycle 0
	intensity $71
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	note F_, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 2
	note A#, 1
	octave 3
	note D_, 1
	note F_, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 3
	note D_, 1
	note F_, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 3
	note D_, 1
	note F_, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 3
	note D_, 1
	note F_, 1
	note A#, 1
	octave 2
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	octave 2
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	octave 2
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	octave 2
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	intensity $81
	notetype 6, $81
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A_, 1
	octave 5
	note D_, 1
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note F_, 1
	note D_, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
	octave 3
	note A_, 1
	octave 4
	note C#, 1
	note E_, 1
	note G_, 1
; bridge
	dutycycle 2
	intensity $86
	notetype 12, $86
	note D_, 6
	octave 3
	note A#, 2
	octave 4
	note F_, 8
	note E_, 6
	note C_, 2
	note G_, 8
	intensity $87
	note A_, 8
	intensity $85
	note E_, 4
	note C#, 4
	note E_, 4
	note E_, 2
	note D_, 2
	note C#, 4
	octave 3
	note A_, 4
	loopchannel 0, Music_HostessBattle_Ch2_Loop

Music_HostessBattle_Ch3:
; intro
	notetype 12, $1a
	octave 2
	note D_, 2
	note __, 1
	note D_, 1
	note __, 2
	note D_, 2
	octave 3
	note D_, 1
	note C_, 1
	octave 2
	note A#, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	note C#, 1
	octave 1
	note A_, 2
	note __, 1
	note A_, 1
	note __, 2
	note A_, 2
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	octave 2
	note A_, 1
	note C#, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	note A_, 1
	octave 3
	note D_, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note E_, 1
	note A_, 1
Music_HostessBattle_Ch3_Loop:
; A
	notetype 12, $1a
	octave 2
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	note A_, 1
	octave 3
	note D_, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note F_, 1
	note A#, 1
	octave 1
	note G_, 1
	note __, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	octave 1
	note G_, 1
	note __, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note D_, 1
	note G_, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note E_, 1
	note A_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	note A_, 1
	octave 3
	note D_, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note F_, 1
	note A#, 1
	octave 1
	note G_, 1
	note __, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	octave 1
	note G_, 1
	note __, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note D_, 1
	note G_, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note E_, 1
	note A_, 1
; B
	intensity $1b
	note D_, 2
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note D_, 2
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note D_, 2
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note D_, 2
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	octave 2
	note D_, 1
	octave 1
	note A#, 2
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note A#, 2
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note A#, 2
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note A#, 2
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	octave 2
	note A#, 1
	octave 1
	note A#, 1
	note G_, 2
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note G_, 2
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note G_, 2
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note G_, 2
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	note A_, 2
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note A_, 2
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note A_, 2
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note A_, 2
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
; build
	intensity $1b
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	notetype 6, $1b
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 3
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	notetype 12, $1b
	note __, 4
; drop
	intensity $1b
	octave 2
	note D_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G#, 1
	note A_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note D_, 1
	octave 2
	note D_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	note F_, 1
	note D_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 1
	note A_, 1
	note A#, 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	octave 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A#, 1
	octave 1
	note A_, 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	octave 2
	note C#, 1
	note __, 1
	note E_, 1
	note __, 1
	note G_, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note E_, 1
	note D_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G#, 1
	note A_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note D_, 1
	octave 2
	note D_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	note F_, 1
	note D_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 1
	note A_, 1
	note A#, 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	octave 2
	note D_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A#, 1
	notetype 6, $1b
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 2
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	notetype 12, $1b
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
; bridge
	intensity $1a
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	octave 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	octave 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	octave 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note E_, 1
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note A_, 1
	note __, 1
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	loopchannel 0, Music_HostessBattle_Ch3_Loop

Music_HostessBattle_Ch4:
	togglenoise 6
; intro
	notetype 12
	note C_, 2
	note __, 1
	note C_, 1
	note __, 2
	note F_, 2
	note C#, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note C_, 2
	note __, 1
	note C_, 1
	note __, 2
	note F_, 2
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note C#, 1
	note C#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
Music_HostessBattle_Ch4_Loop:
; A
	notetype 12
	note F_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note C#, 1
	note C#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
; B
	notetype 12
	note F_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note F_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note E_, 1
	note A#, 1
	note C#, 1
	note C#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
; build
	notetype 12
	note C#, 4
	note C#, 4
	note C#, 4
	note C#, 4
	note C#, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note C#, 2
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
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 6
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
	notetype 12
	note __, 4
; drop
	note F_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	notetype 6
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
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 12
	note F_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note C_, 1
	note D#, 1
	note C#, 1
	note C_, 1
	note B_, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note C_, 1
	note D#, 1
	note C#, 1
	note C_, 1
	note B_, 1
	note D#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 12
	note C_, 1
	note D#, 1
	note C#, 1
	note C_, 1
	note B_, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note C_, 1
	note D#, 1
	note C#, 1
	note C_, 1
	note B_, 1
	note D#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	notetype 12
	note C_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note B_, 1
	note D#, 1
	note E_, 1
	note C_, 1
	notetype 6
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
	note C#, 1
	note C#, 1
	note C#, 1
; bridge
	notetype 12
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note D#, 1
	note A#, 1
	note C_, 2
	note E_, 2
	note B_, 2
	note E_, 1
	note C_, 1
	note F#, 1
	note F#, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	notetype 6
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	loopchannel 0, Music_HostessBattle_Ch4_Loop


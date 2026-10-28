; Hudson Hawk (Game Boy), Title Screen - Keith Tinman.
; Gen 2 style arrangement for Crimson Crystal, built from the original rip
; (kingshriek, https://snesmusic.org/hoot/kingshriek/). Same melody, bass
; line, harmony and groove, re-voiced for the Crystal sound engine:
; - Ch1: duty 3 "oom-pah" backing (low root + short chord-tone stab),
;   replacing the per-frame arpeggio chords.
; - Ch2: duty-2 lead with Crystal vibrato and envelopes (duty 1 on the
;   answer phrase that used octave shimmer in the original).
; - Ch3: standard Crystal bass wave ($14).
; - Ch4: drumkit 3 (kick/snare/hi-hat/crash) on the original kick/snare
;   pattern, with off-beat hats and section crashes.
; Tempo 128 = 150 BPM; one loop is 28 bars (2688 frames, ~45 seconds).

Music_HudsonHawkTitle:
	musicheader 4, 1, Music_HudsonHawkTitle_Ch1
	musicheader 1, 2, Music_HudsonHawkTitle_Ch2
	musicheader 1, 3, Music_HudsonHawkTitle_Ch3
	musicheader 1, 4, Music_HudsonHawkTitle_Ch4

Music_HudsonHawkTitle_Ch1:
	tempo 128
	volume $77
	dutycycle 3
	stereopanning $f
Music_HudsonHawkTitle_Ch1_Loop:
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar1
	callchannel Music_HudsonHawkTitle_Ch1_Bar2
	callchannel Music_HudsonHawkTitle_Ch1_Bar13_14
	callchannel Music_HudsonHawkTitle_Ch1_Bar15
	callchannel Music_HudsonHawkTitle_Ch1_Bar16
	callchannel Music_HudsonHawkTitle_Ch1_Bar17_18
	callchannel Music_HudsonHawkTitle_Ch1_Bar19
	callchannel Music_HudsonHawkTitle_Ch1_Bar20
	callchannel Music_HudsonHawkTitle_Ch1_Bar21
	callchannel Music_HudsonHawkTitle_Ch1_Bar22
	callchannel Music_HudsonHawkTitle_Ch1_Bar21
	callchannel Music_HudsonHawkTitle_Ch1_Bar22
	callchannel Music_HudsonHawkTitle_Ch1_Bar21
	callchannel Music_HudsonHawkTitle_Ch1_Bar22
	callchannel Music_HudsonHawkTitle_Ch1_Bar21
	callchannel Music_HudsonHawkTitle_Ch1_Bar22
	loopchannel 0, Music_HudsonHawkTitle_Ch1_Loop

Music_HudsonHawkTitle_Ch1_Bar1:
	dutycycle 3
	notetype $c, $62
	octave 1
	note B_, 2
	intensity $91
	octave 4
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	intensity $62
	octave 1
	note B_, 2
	intensity $91
	octave 4
	note D_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 4
	note D_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 4
	note D_, 1
	intensity $62
	octave 2
	note B_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar2:
	dutycycle 3
	notetype $c, $62
	octave 2
	note F_, 2
	intensity $91
	octave 3
	note B_, 2
	note B_, 2
	intensity $62
	octave 2
	note F_, 2
	intensity $91
	octave 3
	note B_, 2
	intensity $62
	octave 2
	note F_, 1
	intensity $91
	octave 3
	note B_, 2
	intensity $62
	octave 2
	note F_, 1
	intensity $91
	octave 3
	note B_, 1
	intensity $62
	octave 2
	note F_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar13_14:
	notetype $c, $91
	note __, 2
	dutycycle 3
	octave 4
	note C#, 1
	note __, 1
	note C#, 1
	note __, 3
	note C#, 2
	note __, 1
	note C#, 2
	note __, 1
	note C#, 1
	note __, 3
	octave 3
	note A#, 2
	note A#, 2
	note __, 2
	note A#, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar15:
	dutycycle 3
	notetype $c, $62
	octave 1
	note A#, 2
	intensity $91
	octave 4
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	intensity $62
	octave 1
	note A#, 2
	intensity $91
	octave 4
	note C#, 2
	intensity $62
	octave 1
	note A#, 1
	intensity $91
	octave 4
	note C#, 2
	intensity $62
	octave 1
	note A#, 1
	intensity $91
	octave 4
	note C#, 1
	intensity $62
	octave 2
	note A#, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar16:
	dutycycle 3
	notetype $c, $62
	octave 2
	note E_, 2
	intensity $91
	octave 3
	note A#, 2
	note A#, 2
	intensity $62
	octave 2
	note E_, 2
	intensity $91
	octave 3
	note A#, 2
	intensity $62
	octave 2
	note E_, 1
	intensity $91
	octave 3
	note A#, 2
	intensity $62
	octave 2
	note E_, 1
	intensity $91
	octave 3
	note A#, 1
	intensity $62
	octave 2
	note E_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar17_18:
	notetype $c, $91
	note __, 2
	dutycycle 3
	octave 4
	note D_, 1
	note __, 1
	note D_, 1
	note __, 3
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	note D_, 1
	note __, 3
	octave 3
	note B_, 2
	note B_, 2
	note __, 2
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	note B_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar19:
	dutycycle 3
	notetype $c, $62
	octave 2
	note B_, 2
	intensity $91
	octave 4
	note D_, 2
	note D_, 2
	intensity $62
	octave 1
	note B_, 2
	intensity $91
	octave 4
	note D_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 4
	note D_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 4
	note D_, 1
	intensity $62
	octave 1
	note B_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar20:
	dutycycle 3
	notetype $c, $62
	octave 2
	note F_, 2
	intensity $91
	octave 4
	note F#, 2
	note F#, 2
	intensity $62
	octave 2
	note F_, 2
	intensity $91
	octave 4
	note F#, 2
	intensity $62
	octave 2
	note F_, 1
	intensity $91
	octave 4
	note F#, 2
	intensity $62
	octave 2
	note F_, 1
	intensity $91
	octave 4
	note F#, 1
	intensity $62
	octave 2
	note F_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar21:
	dutycycle 3
	notetype $c, $62
	octave 1
	note B_, 2
	intensity $91
	octave 3
	note B_, 2
	note B_, 2
	intensity $62
	octave 1
	note B_, 2
	intensity $91
	octave 3
	note B_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 3
	note B_, 2
	intensity $62
	octave 1
	note B_, 1
	intensity $91
	octave 3
	note B_, 1
	intensity $62
	octave 1
	note B_, 1
	endchannel

Music_HudsonHawkTitle_Ch1_Bar22:
	dutycycle 3
	notetype $c, $62
	octave 2
	note G_, 2
	intensity $91
	octave 3
	note A_, 2
	note A_, 2
	intensity $62
	octave 2
	note G_, 2
	intensity $91
	octave 3
	note A_, 2
	intensity $62
	octave 2
	note F_, 1
	intensity $91
	octave 3
	note A_, 2
	intensity $62
	octave 2
	note G_, 1
	intensity $91
	octave 3
	note A_, 1
	intensity $62
	octave 2
	note F_, 1
	endchannel

Music_HudsonHawkTitle_Ch2:
	dutycycle 2
	vibrato $10, $23
Music_HudsonHawkTitle_Ch2_Loop:
	callchannel Music_HudsonHawkTitle_Ch2_Bar1
	callchannel Music_HudsonHawkTitle_Ch2_Bar2
	callchannel Music_HudsonHawkTitle_Ch2_Bar1
	callchannel Music_HudsonHawkTitle_Ch2_Bar4_6
	callchannel Music_HudsonHawkTitle_Ch2_Bar7
	callchannel Music_HudsonHawkTitle_Ch2_Bar8
	callchannel Music_HudsonHawkTitle_Ch2_Bar9
	callchannel Music_HudsonHawkTitle_Ch2_Bar10
	callchannel Music_HudsonHawkTitle_Ch2_Bar7
	callchannel Music_HudsonHawkTitle_Ch2_Bar8
	callchannel Music_HudsonHawkTitle_Ch2_Bar13
	callchannel Music_HudsonHawkTitle_Ch2_Bar14
	callchannel Music_HudsonHawkTitle_Ch2_Bar15_16
	callchannel Music_HudsonHawkTitle_Ch2_Bar17
	callchannel Music_HudsonHawkTitle_Ch2_Bar18
	callchannel Music_HudsonHawkTitle_Ch2_Bar19_22
	callchannel Music_HudsonHawkTitle_Ch2_Bar23_24
	callchannel Music_HudsonHawkTitle_Ch2_Bar25_26
	callchannel Music_HudsonHawkTitle_Ch2_Bar27_28
	loopchannel 0, Music_HudsonHawkTitle_Ch2_Loop

Music_HudsonHawkTitle_Ch2_Bar1:
	dutycycle 2
	notetype $c, $a7
	octave 2
	note B_, 2
	octave 3
	note B_, 7
	note __, 7
	endchannel

Music_HudsonHawkTitle_Ch2_Bar2:
	dutycycle 2
	notetype $c, $a7
	octave 3
	note F_, 2
	octave 4
	note F_, 7
	note __, 7
	endchannel

Music_HudsonHawkTitle_Ch2_Bar4_6:
	dutycycle 2
	notetype $c, $a7
	octave 2
	note F_, 2
	octave 3
	note F_, 7
	note __, 16
	note __, 16
	note __, 7
	endchannel

Music_HudsonHawkTitle_Ch2_Bar7:
	dutycycle 2
	notetype $c, $b6
	octave 3
	note A#, 1
	note B_, 11
	note F#, 3
	note G_, 1
	endchannel

Music_HudsonHawkTitle_Ch2_Bar8:
	dutycycle 2
	notetype $c, $b6
	octave 3
	note F_, 3
	notetype $6, $b6
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	notetype $c, $b6
	note F#, 1
	note E_, 3
	note F_, 1
	note D_, 2
	octave 2
	note B_, 3
	octave 3
	note C_, 1
	endchannel

Music_HudsonHawkTitle_Ch2_Bar9:
	dutycycle 1
	notetype $c, $a5
	octave 4
	note F#, 1
	note F_, 1
	note E_, 2
	note D_, 2
	octave 3
	note B_, 1
	octave 4
	note D_, 2
	note E_, 1
	note F_, 2
	note F#, 2
	note F_, 2
	endchannel

Music_HudsonHawkTitle_Ch2_Bar10:
	dutycycle 1
	notetype $c, $a5
	octave 4
	note E_, 2
	note F_, 1
	note F#, 2
	note F_, 2
	note E_, 2
	note D_, 1
	octave 3
	note B_, 3
	note __, 3
	endchannel

Music_HudsonHawkTitle_Ch2_Bar13:
	dutycycle 2
	notetype $c, $b7
	octave 3
	note A_, 1
	note A#, 5
	notetype $6, $b7
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	notetype $c, $b7
	octave 4
	note F_, 4
	endchannel

Music_HudsonHawkTitle_Ch2_Bar14:
	dutycycle 2
	notetype $c, $b7
	octave 4
	note E_, 16
	endchannel

Music_HudsonHawkTitle_Ch2_Bar15_16:
	dutycycle 2
	notetype $c, $b7
	octave 4
	note C#, 10
	note C_, 2
	note C#, 2
	note C_, 16
	note __, 2
	endchannel

Music_HudsonHawkTitle_Ch2_Bar17:
	dutycycle 2
	notetype $c, $b7
	octave 3
	note A#, 1
	note B_, 11
	octave 4
	note F#, 4
	endchannel

Music_HudsonHawkTitle_Ch2_Bar18:
	dutycycle 2
	notetype $c, $b7
	octave 4
	note F_, 16
	endchannel

Music_HudsonHawkTitle_Ch2_Bar19_22:
	dutycycle 2
	notetype $c, $b7
	octave 4
	note D_, 10
	note C#, 2
	note D_, 2
	note C#, 16
	note __, 4
	intensity $a4
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 4
	note D_, 2
	octave 3
	note F#, 1
	note B_, 2
	note __, 5
	note F#, 2
	note F_, 1
	note E_, 2
	note D_, 2
	octave 2
	note B_, 3
	note __, 2
	note B_, 2
	endchannel

Music_HudsonHawkTitle_Ch2_Bar23_24:
	dutycycle 2
	notetype $c, $a4
	octave 3
	note D_, 1
	note E_, 2
	note F_, 2
	note F#, 2
	note F_, 2
	note E_, 1
	note D_, 2
	octave 2
	note B_, 3
	note __, 16
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch2_Bar25_26:
	dutycycle 2
	notetype $c, $a4
	octave 4
	note F#, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D_, 3
	note A_, 2
	note F#, 1
	note A_, 2
	note B_, 2
	note A_, 2
	note F#, 2
	note F_, 1
	note E_, 2
	endchannel

Music_HudsonHawkTitle_Ch2_Bar27_28:
	dutycycle 2
	notetype $c, $a4
	octave 4
	note D_, 2
	octave 3
	note B_, 4
	note __, 16
	note __, 1
	note B_, 1
	octave 4
	note D_, 1
	note E_, 1
	note F_, 2
	note F#, 1
	note F_, 1
	note E_, 1
	note D_, 1
	endchannel

Music_HudsonHawkTitle_Ch3:
Music_HudsonHawkTitle_Ch3_Loop:
	callchannel Music_HudsonHawkTitle_Ch3_Bar1
	callchannel Music_HudsonHawkTitle_Ch3_Bar2
	callchannel Music_HudsonHawkTitle_Ch3_Bar3
	callchannel Music_HudsonHawkTitle_Ch3_Bar4
	callchannel Music_HudsonHawkTitle_Ch3_Bar5
	callchannel Music_HudsonHawkTitle_Ch3_Bar6
	callchannel Music_HudsonHawkTitle_Ch3_Bar7
	callchannel Music_HudsonHawkTitle_Ch3_Bar8
	callchannel Music_HudsonHawkTitle_Ch3_Bar5
	callchannel Music_HudsonHawkTitle_Ch3_Bar10
	callchannel Music_HudsonHawkTitle_Ch3_Bar7
	callchannel Music_HudsonHawkTitle_Ch3_Bar8
	callchannel Music_HudsonHawkTitle_Ch3_Bar13
	callchannel Music_HudsonHawkTitle_Ch3_Bar14
	callchannel Music_HudsonHawkTitle_Ch3_Bar15
	callchannel Music_HudsonHawkTitle_Ch3_Bar16
	callchannel Music_HudsonHawkTitle_Ch3_Bar17
	callchannel Music_HudsonHawkTitle_Ch3_Bar18
	callchannel Music_HudsonHawkTitle_Ch3_Bar19
	callchannel Music_HudsonHawkTitle_Ch3_Bar20
	callchannel Music_HudsonHawkTitle_Ch3_Bar21
	callchannel Music_HudsonHawkTitle_Ch3_Bar22
	callchannel Music_HudsonHawkTitle_Ch3_Bar23
	callchannel Music_HudsonHawkTitle_Ch3_Bar22
	callchannel Music_HudsonHawkTitle_Ch3_Bar21
	callchannel Music_HudsonHawkTitle_Ch3_Bar22
	callchannel Music_HudsonHawkTitle_Ch3_Bar23
	callchannel Music_HudsonHawkTitle_Ch3_Bar22
	loopchannel 0, Music_HudsonHawkTitle_Ch3_Loop

Music_HudsonHawkTitle_Ch3_Bar1:
	notetype $c, $14
	octave 1
	note B_, 2
	note B_, 2
	note B_, 1
	note __, 1
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	endchannel

Music_HudsonHawkTitle_Ch3_Bar2:
	notetype $c, $14
	octave 1
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	endchannel

Music_HudsonHawkTitle_Ch3_Bar3:
	notetype $c, $14
	octave 1
	note B_, 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	note B_, 2
	endchannel

Music_HudsonHawkTitle_Ch3_Bar4:
	notetype $c, $14
	octave 1
	note F_, 2
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 2
	endchannel

Music_HudsonHawkTitle_Ch3_Bar5:
	notetype $c, $14
	octave 1
	note B_, 2
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 2
	note B_, 1
	octave 2
	note D_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 1
	note F_, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar6:
	notetype $c, $14
	octave 1
	note B_, 1
	note __, 2
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 2
	note B_, 1
	octave 2
	note D_, 1
	note __, 1
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar7:
	notetype $c, $14
	octave 1
	note B_, 1
	note __, 2
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 2
	note B_, 1
	octave 2
	note A_, 1
	note __, 1
	note B_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar8:
	notetype $c, $14
	octave 2
	note D_, 1
	note __, 2
	note D_, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 2
	note D_, 1
	note E_, 1
	note __, 1
	note F_, 1
	note __, 1
	note E_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar10:
	notetype $c, $14
	octave 1
	note B_, 1
	note __, 2
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 2
	note B_, 1
	note A#, 1
	note __, 1
	octave 2
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar13:
	notetype $c, $14
	octave 1
	note A#, 2
	note __, 2
	note A#, 2
	note __, 1
	note A#, 1
	note __, 1
	note A#, 1
	note A#, 2
	note __, 2
	note A#, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar14:
	notetype $c, $14
	octave 1
	note G#, 1
	note __, 3
	note G#, 1
	note __, 2
	note F#, 1
	note __, 1
	note F#, 1
	octave 2
	note F#, 1
	note __, 1
	note F#, 1
	note __, 1
	note F#, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar15:
	notetype $c, $14
	octave 1
	note A#, 1
	note __, 3
	note A#, 1
	note __, 2
	note A#, 1
	note __, 1
	note A#, 1
	note A#, 2
	note __, 2
	note A#, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar16:
	notetype $c, $14
	octave 2
	note C#, 1
	note __, 3
	note C#, 1
	note __, 2
	note C#, 1
	note __, 1
	note C#, 1
	octave 3
	note C#, 1
	note __, 1
	octave 2
	note D#, 1
	note __, 1
	note C#, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar17:
	notetype $c, $14
	octave 1
	note B_, 2
	note __, 2
	note B_, 2
	note __, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 2
	note __, 2
	note B_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar18:
	notetype $c, $14
	octave 1
	note A_, 1
	note __, 3
	note A_, 1
	note __, 2
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar19:
	notetype $c, $14
	octave 1
	note B_, 1
	note __, 3
	note B_, 1
	note __, 2
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 2
	note __, 2
	note B_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar20:
	notetype $c, $14
	octave 2
	note D_, 1
	note __, 3
	note D_, 1
	note __, 2
	note D_, 1
	note __, 1
	note D_, 1
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar21:
	notetype $c, $14
	octave 1
	note B_, 2
	note __, 2
	note B_, 2
	note __, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note F_, 1
	note __, 1
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar22:
	notetype $c, $14
	octave 1
	note G_, 1
	note __, 3
	note G_, 1
	note __, 2
	note G_, 1
	note __, 1
	note G_, 1
	octave 2
	note D_, 1
	note __, 1
	note C#, 1
	note __, 1
	octave 1
	note A_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch3_Bar23:
	notetype $c, $14
	octave 1
	note B_, 1
	note __, 3
	note B_, 1
	note __, 2
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note F_, 1
	note __, 1
	note E_, 1
	note __, 1
	note D_, 1
	note __, 1
	endchannel

Music_HudsonHawkTitle_Ch4:
	togglenoise $3
Music_HudsonHawkTitle_Ch4_Loop:
	callchannel Music_HudsonHawkTitle_Ch4_Bar1_4
	callchannel Music_HudsonHawkTitle_Ch4_Bar5
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	callchannel Music_HudsonHawkTitle_Ch4_Bar5
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	callchannel Music_HudsonHawkTitle_Ch4_Bar5
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar6
	callchannel Music_HudsonHawkTitle_Ch4_Bar7
	callchannel Music_HudsonHawkTitle_Ch4_Bar8
	loopchannel 0, Music_HudsonHawkTitle_Ch4_Loop

Music_HudsonHawkTitle_Ch4_Bar1_4:
	notetype $c
	note D#, 6
	note D#, 2
	note D#, 10
	note D#, 4
	note D#, 2
	note D#, 2
	note D#, 8
	note D#, 4
	note D#, 2
	note D#, 16
	note __, 2
	note D_, 4
	note D_, 2
	endchannel

Music_HudsonHawkTitle_Ch4_Bar5:
	notetype $c
	note B_, 4
	note D_, 2
	note G_, 1
	note D#, 2
	note D#, 1
	note D#, 2
	note D_, 2
	note D#, 2
	endchannel

Music_HudsonHawkTitle_Ch4_Bar6:
	notetype $c
	note D#, 2
	note G_, 2
	note D_, 2
	note G_, 1
	note D#, 2
	note D#, 1
	note D#, 2
	note D_, 2
	note D#, 2
	endchannel

Music_HudsonHawkTitle_Ch4_Bar7:
	notetype $c
	note D#, 2
	note D#, 2
	note D_, 2
	note G_, 1
	note D#, 2
	note D#, 1
	note D#, 2
	note D_, 2
	note D#, 2
	endchannel

Music_HudsonHawkTitle_Ch4_Bar8:
	notetype $c
	note D#, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note G_, 1
	note D_, 2
	note D_, 1
	note D_, 2
	note D#, 2
	note D_, 2
	endchannel

; Rocket Executive Battle - Crimson Crystal.
; A minor / A Phrygian, with chromatic and diminished threats.
; Opening 8 bars unchanged; darker answers begin at ~11.25 seconds.
; tempo 224, notetype 6: 84 sound updates per 4/4 bar (~171 BPM).
; Intro 4 | A 8 (Rocket hook) | B 8 (command) | C 8 (half-time/build)
; | D 8 (escalated reprise) | loop to A. Loop: 2688 updates (~45 s).
; Ch1: clipped fifths / arpeggios / counterline; Ch2: Rocket-derived lead;
; Ch3: saw bass (wave 11), gated with one notetype-2 unit of rest;
; Ch4: drumkit 6, kick syncopation and snare on beats 2 and 4.
; Named admins only: Proton, Petrel, Ariana, Archer.

Music_RocketExecutiveBattle:
	musicheader 4, 1, Music_RocketExecutiveBattle_Ch1
	musicheader 1, 2, Music_RocketExecutiveBattle_Ch2
	musicheader 1, 3, Music_RocketExecutiveBattle_Ch3
	musicheader 1, 4, Music_RocketExecutiveBattle_Ch4

Music_RocketExecutiveBattle_Ch1:
	tempo 224
	volume $77
	stereopanning $f0
	callchannel Music_RocketExecutiveBattle_Ch1_Intro
Music_RocketExecutiveBattle_Ch1_Loop:
	callchannel Music_RocketExecutiveBattle_Ch1_A
	callchannel Music_RocketExecutiveBattle_Ch1_B
	callchannel Music_RocketExecutiveBattle_Ch1_C
	callchannel Music_RocketExecutiveBattle_Ch1_D
	loopchannel 0, Music_RocketExecutiveBattle_Ch1_Loop

Music_RocketExecutiveBattle_Ch2:
	stereopanning $ff
	callchannel Music_RocketExecutiveBattle_Ch2_Intro
Music_RocketExecutiveBattle_Ch2_Loop:
	callchannel Music_RocketExecutiveBattle_Ch2_A
	callchannel Music_RocketExecutiveBattle_Ch2_B
	callchannel Music_RocketExecutiveBattle_Ch2_C
	callchannel Music_RocketExecutiveBattle_Ch2_D
	loopchannel 0, Music_RocketExecutiveBattle_Ch2_Loop

Music_RocketExecutiveBattle_Ch3:
	stereopanning $ff
	callchannel Music_RocketExecutiveBattle_Ch3_Intro
Music_RocketExecutiveBattle_Ch3_Loop:
	callchannel Music_RocketExecutiveBattle_Ch3_A
	callchannel Music_RocketExecutiveBattle_Ch3_B
	callchannel Music_RocketExecutiveBattle_Ch3_C
	callchannel Music_RocketExecutiveBattle_Ch3_D
	loopchannel 0, Music_RocketExecutiveBattle_Ch3_Loop

Music_RocketExecutiveBattle_Ch4:
	stereopanning $ff
	togglenoise 6
	notetype 6
	callchannel Music_RocketExecutiveBattle_Ch4_Intro
Music_RocketExecutiveBattle_Ch4_Loop:
	callchannel Music_RocketExecutiveBattle_Ch4_A
	callchannel Music_RocketExecutiveBattle_Ch4_B
	callchannel Music_RocketExecutiveBattle_Ch4_C
	callchannel Music_RocketExecutiveBattle_Ch4_D
	loopchannel 0, Music_RocketExecutiveBattle_Ch4_Loop

Music_RocketExecutiveBattle_Ch2_Intro:
	dutycycle 3
	notetype 6, $c3
	vibrato $00, $00
; bar 1
	octave 3
	note A_, 3
	note __, 1
	note A_, 2
	note __, 2
	note A#, 3
	note __, 1
	note A#, 2
	note __, 2
; bar 2
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note A_, 4
; bar 3
	octave 3
	note A_, 3
	note A_, 2
	octave 4
	note C_, 1
	octave 3
	note A#, 2
	note A_, 3
	note __, 1
	note G#, 2
	note E_, 2
; bar 4
	octave 4
	note E_, 3
	note __, 1
	note F_, 2
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note __, 2
	endchannel

Music_RocketExecutiveBattle_Ch2_A:
	dutycycle 3
	notetype 6, $b3
	vibrato $00, $00
; bar 1
	octave 3
	note A_, 3
	note A_, 2
	octave 4
	note C_, 1
	octave 3
	note A#, 2
	note A_, 3
	note A_, 2
	note G_, 1
	note G#, 2
; bar 2
	note A_, 3
	note A_, 2
	octave 4
	note C_, 1
	octave 3
	note A#, 2
	octave 4
	note E_, 3
	note D#, 1
	note D_, 2
	note C_, 2
; bar 3
	octave 3
	note A_, 3
	note A_, 2
	octave 4
	note C_, 1
	octave 3
	note A#, 2
	note A_, 3
	note G#, 1
	note E_, 2
	note G_, 2
; bar 4
	note A#, 3
	note A_, 1
	note G#, 2
	note E_, 2
	note G#, 3
	note B_, 1
	octave 4
	note D_, 2
	note E_, 2
; bar 5
	note A_, 3
	note A_, 2
	octave 5
	note C_, 1
	octave 4
	note A#, 2
	note A_, 3
	note A_, 2
	note G_, 1
	note G#, 2
; bar 6
	note A_, 3
	note G#, 1
	note E_, 2
	note C_, 2
	octave 3
	note A#, 3
	octave 4
	note C_, 1
	note D_, 2
	note E_, 2
; bar 7
	note F_, 3
	note E_, 1
	note D_, 2
	note C_, 2
	octave 3
	note A#, 3
	note G#, 1
	note G#, 2
	note F_, 2
; bar 8
	note E_, 2
	note __, 1
	note E_, 1
	note G#, 2
	note B_, 2
	octave 4
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note G#, 2
	endchannel

Music_RocketExecutiveBattle_Ch2_B:
	dutycycle 2
	notetype 6, $b5
	vibrato $10, $23
; bar 1
	octave 4
	note E_, 2
	note A_, 3
	note G#, 1
	note A_, 2
	octave 5
	note C_, 3
	octave 4
	note B_, 1
	note A#, 2
	note A_, 2
; bar 2
	note A#, 3
	note A_, 1
	note F_, 2
	note E_, 2
	note C#, 3
	note E_, 1
	note F_, 2
	note G#, 2
; bar 3
	note A_, 3
	note E_, 1
	note C_, 2
	note E_, 2
	note G#, 3
	note A_, 1
	note B_, 2
	octave 5
	note C_, 2
; bar 4
	octave 4
	note B_, 3
	note A#, 1
	note G#, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 2
	note G#, 2
; bar 5
	note G#, 6
	note G_, 2
	note F_, 3
	note E_, 1
	note C_, 2
	octave 3
	note G#, 2
; bar 6
	octave 4
	note D_, 3
	note E_, 1
	note F_, 2
	note G#, 2
	note G#, 3
	note F_, 1
	note E_, 2
	note D_, 2
; bar 7
	note F_, 3
	note E_, 1
	note C#, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	note C#, 2
	note F_, 2
; bar 8
	note E_, 3
	note F_, 1
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note E_, 2
	note __, 2
	endchannel

Music_RocketExecutiveBattle_Ch2_C:
	dutycycle 3
	notetype 6, $b4
	vibrato $00, $00
; bar 1
	octave 3
	note A_, 3
	note __, 1
	note A#, 2
	note A_, 2
	note E_, 6
	note __, 2
; bar 2
	note G#, 3
	note __, 1
	note A_, 2
	note G#, 2
	note E_, 4
	note D_, 2
	note __, 2
; bar 3
	note G_, 3
	note __, 1
	note G#, 2
	note G_, 2
	note D_, 6
	note __, 2
; bar 4
	note F#, 3
	note __, 1
	note G_, 2
	note F#, 2
	note D#, 4
	note E_, 2
	note __, 2
; bar 5
	note F_, 3
	note E_, 1
	note F_, 2
	note G#, 2
	octave 4
	note C_, 3
	octave 3
	note B_, 1
	note A#, 2
	note G#, 2
; bar 6
	note A#, 3
	note A_, 1
	note A#, 2
	octave 4
	note C#, 2
	note F_, 3
	note E_, 1
	note C#, 2
	note C_, 2
; bar 7
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note F_, 2
	note G#, 2
	note B_, 2
	note G#, 2
	note F_, 2
	note D_, 2
; bar 8
	note E_, 2
	note __, 1
	note E_, 1
	note F_, 2
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note __, 2
	endchannel

Music_RocketExecutiveBattle_Ch2_D:
	dutycycle 3
	notetype 6, $c3
	vibrato $00, $00
; bar 1
	octave 4
	note A_, 3
	note A_, 2
	octave 5
	note C_, 1
	octave 4
	note A#, 2
	note A_, 3
	note E_, 1
	note G_, 2
	note G#, 2
; bar 2
	note A_, 3
	note A_, 2
	octave 5
	note C_, 1
	octave 4
	note A#, 2
	octave 5
	note E_, 3
	note D#, 1
	note D_, 2
	note C_, 2
; bar 3
	octave 4
	note A_, 3
	note G#, 1
	note A_, 2
	octave 5
	note C_, 2
	octave 4
	note A#, 3
	note A_, 1
	note G#, 2
	note E_, 2
; bar 4
	note F_, 3
	note E_, 1
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note E_, 3
	note F_, 1
	note G#, 2
	note B_, 2
; bar 5
	octave 5
	note C_, 3
	octave 4
	note B_, 1
	note G#, 2
	note E_, 2
	octave 5
	note C_, 3
	octave 4
	note B_, 1
	note A#, 2
	note G#, 2
; bar 6
	octave 5
	note C#, 3
	note C_, 1
	octave 4
	note A#, 2
	note F_, 2
	octave 5
	note C#, 3
	note C_, 1
	octave 4
	note A#, 2
	note G#, 2
; bar 7
	note G#, 2
	note A_, 2
	note B_, 2
	octave 5
	note D_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	octave 4
	note B_, 2
; bar 8
	note A_, 2
	note G#, 2
	note G_, 2
	note F#, 2
	note F_, 2
	note E_, 2
	note D#, 1
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	endchannel

Music_RocketExecutiveBattle_Ch1_Intro:
	dutycycle 3
	notetype 6, $a2
	vibrato $00, $00
	tone $0000
; bar 1
	octave 3
	note D#, 3
	note __, 1
	note D#, 2
	note __, 2
	note E_, 3
	note __, 1
	note E_, 2
	note __, 2
; bar 2
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 4
; bar 3
	octave 3
	note E_, 3
	note __, 2
	note E_, 1
	note F_, 2
	note E_, 3
	note __, 1
	note D_, 2
	octave 2
	note B_, 2
; bar 4
	octave 3
	note B_, 3
	note __, 1
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note F_, 2
	note D_, 2
	note __, 2
	endchannel

Music_RocketExecutiveBattle_Ch1_A:
	dutycycle 3
	notetype 6, $83
	vibrato $00, $00
	tone $0000
; bar 1
	octave 3
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 2
	note E_, 2
	note __, 1
	note E_, 1
	note D_, 2
	note E_, 2
; bar 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 2
	note G#, 3
	note __, 1
	note B_, 2
	note G#, 2
; bar 3
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 2
	note E_, 2
	note __, 1
	note E_, 1
	note D_, 2
	note E_, 2
; bar 4
	note F_, 3
	note E_, 1
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 3
	note __, 1
	note G#, 2
	note B_, 2
; bar 5
	octave 4
	note D#, 2
	note __, 1
	note D#, 2
	note __, 1
	note D_, 2
	note D#, 2
	note __, 1
	note D#, 1
	octave 3
	note B_, 2
	note B_, 2
; bar 6
	octave 4
	note C_, 3
	octave 3
	note B_, 1
	note G#, 2
	note E_, 2
	note F_, 3
	note __, 1
	note A#, 2
	octave 4
	note C_, 2
; bar 7
	octave 3
	note G#, 3
	note G#, 1
	note F_, 2
	note E_, 2
	note F_, 3
	note E_, 1
	note D_, 2
	octave 2
	note B_, 2
; bar 8
	note B_, 2
	note __, 1
	note B_, 1
	octave 3
	note D_, 2
	note G#, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note E_, 2
	endchannel

Music_RocketExecutiveBattle_Ch1_B:
	dutycycle 1
	notetype 6, $72
	vibrato $00, $00
	tone $0000
; bar 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note E_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
; bar 2
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note F_, 1
	note A#, 1
	note F_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note F_, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note F_, 1
	note A#, 1
	note F_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
; bar 3
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note E_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
; bar 4
	octave 2
	note G#, 1
	note B_, 1
	octave 3
	note D_, 1
	note E_, 1
	note D_, 1
	octave 2
	note B_, 1
	note G#, 1
	octave 3
	note D_, 1
	octave 2
	note G#, 1
	note B_, 1
	octave 3
	note D_, 1
	note E_, 1
	note D_, 1
	octave 2
	note B_, 1
	note G#, 1
	note B_, 1
; bar 5
	note F_, 1
	note G#, 1
	octave 3
	note C_, 1
	note F_, 1
	note C_, 1
	octave 2
	note G#, 1
	note F_, 1
	octave 3
	note C_, 1
	octave 2
	note F_, 1
	note G#, 1
	octave 3
	note C_, 1
	note F_, 1
	note C_, 1
	octave 2
	note G#, 1
	note F_, 1
	note G#, 1
; bar 6
	octave 3
	note D_, 1
	note F_, 1
	note G#, 1
	octave 4
	note D_, 1
	octave 3
	note G#, 1
	note F_, 1
	note D_, 1
	note G#, 1
	note D_, 1
	note F_, 1
	note G#, 1
	octave 4
	note D_, 1
	octave 3
	note G#, 1
	note F_, 1
	note D_, 1
	note F_, 1
; bar 7
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note F_, 1
	note A#, 1
	note F_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note F_, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note F_, 1
	note A#, 1
	note F_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
; bar 8
	note E_, 1
	note G#, 1
	note B_, 1
	octave 4
	note D_, 1
	octave 3
	note B_, 1
	note G#, 1
	note E_, 1
	note B_, 1
	note E_, 1
	note G#, 1
	note B_, 1
	octave 4
	note D_, 1
	octave 3
	note B_, 1
	note G#, 1
	note E_, 1
	note G#, 1
	endchannel

Music_RocketExecutiveBattle_Ch1_C:
	dutycycle 2
	notetype 6, $72
	vibrato $00, $00
	tone $0000
; bar 1
	octave 3
	note D#, 3
	note A_, 3
	note A#, 2
	note D#, 3
	note A_, 3
	note D#, 2
; bar 2
	note E_, 3
	note G#, 3
	note A_, 2
	note E_, 3
	note G#, 3
	note E_, 2
; bar 3
	note C#, 3
	note G_, 3
	note G#, 2
	note C#, 3
	note G_, 3
	note C#, 2
; bar 4
	note C_, 3
	note F#, 3
	note G_, 2
	note C_, 3
	note F#, 3
	note E_, 2
; bar 5
	note C_, 3
	note F_, 3
	note G#, 2
	note C_, 3
	note F_, 3
	note G#, 2
; bar 6
	note F_, 3
	note A#, 3
	octave 4
	note C#, 2
	octave 3
	note F_, 3
	note A#, 3
	octave 4
	note C#, 2
; bar 7
	octave 3
	note D_, 2
	note F_, 2
	note G#, 2
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note F_, 2
; bar 8
	note B_, 2
	note __, 1
	note B_, 1
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note F_, 2
	note E_, 2
	note __, 2
	endchannel

Music_RocketExecutiveBattle_Ch1_D:
	dutycycle 3
	notetype 6, $93
	vibrato $00, $00
	tone $0000
; bar 1
	octave 3
	note E_, 3
	note E_, 2
	note F#, 1
	note F_, 2
	note E_, 3
	octave 4
	note C_, 1
	octave 3
	note B_, 2
	note B_, 2
; bar 2
	note E_, 3
	note E_, 2
	note F#, 1
	note F_, 2
	note G#, 3
	note B_, 1
	note G#, 2
	note E_, 2
; bar 3
	octave 4
	note C_, 3
	octave 3
	note B_, 1
	octave 4
	note C_, 2
	note E_, 2
	note D_, 3
	note C_, 1
	octave 3
	note B_, 2
	note G#, 2
; bar 4
	octave 4
	note D_, 3
	octave 3
	note B_, 1
	note G#, 2
	note E_, 2
	note B_, 3
	octave 4
	note D_, 1
	note E_, 2
	note G#, 2
; bar 5
	octave 3
	note G#, 3
	note G_, 1
	note E_, 2
	note C_, 2
	note G#, 3
	note G_, 1
	note F_, 2
	note E_, 2
; bar 6
	octave 4
	note F_, 3
	note E_, 1
	note C#, 2
	octave 3
	note A#, 2
	octave 4
	note F_, 3
	note E_, 1
	note C#, 2
	note C_, 2
; bar 7
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note F_, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note D_, 2
; bar 8
	note E_, 2
	note D#, 2
	note D_, 2
	note C#, 2
	note C_, 2
	octave 3
	note B_, 2
	note A#, 1
	note A_, 1
	note G_, 1
	note G#, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_Intro:
	notetype 2, $1b
; bar 1
	octave 1
	note A_, 8
	note __, 1
	note __, 3
	octave 2
	note A_, 5
	note __, 1
	note __, 6
	octave 1
	note A#, 8
	note __, 1
	note __, 3
	octave 2
	note A#, 5
	note __, 1
	note __, 6
; bar 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	octave 2
	note G#, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	octave 2
	note G_, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	octave 2
	note F#, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
; bar 3
	octave 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 5
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	octave 2
	note G_, 5
	note __, 1
	note G#, 5
	note __, 1
; bar 4
	note E_, 8
	note __, 1
	note __, 3
	note E_, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	note D_, 5
	note __, 1
	octave 2
	note B_, 5
	note __, 1
	note G#, 5
	note __, 1
	note __, 6
	endchannel

Music_RocketExecutiveBattle_Ch3_A:
	notetype 2, $1b
; bar 1
	octave 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 3
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 4
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
; bar 5
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 6
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	note B_, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note B_, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
; bar 7
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	note F#, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
; bar 8
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_B:
	notetype 2, $1b
; bar 1
	octave 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 2
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	note B_, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note B_, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
; bar 3
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 4
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
; bar 5
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	note F#, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
; bar 6
	note D_, 5
	note __, 1
	note A_, 2
	note __, 1
	note D_, 2
	note __, 1
	note D_, 5
	note __, 1
	note D#, 2
	note __, 1
	note D_, 2
	note __, 1
	note D_, 5
	note __, 1
	note A_, 2
	note __, 1
	note D_, 2
	note __, 1
	note D#, 5
	note __, 1
	note A_, 2
	note __, 1
	note D_, 2
	note __, 1
; bar 7
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	note B_, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
; bar 8
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_C:
	notetype 2, $1b
; bar 1
	octave 1
	note A_, 8
	note __, 1
	note __, 3
	note A_, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
	octave 1
	note A_, 8
	note __, 1
	note __, 3
	note A#, 5
	note __, 1
	octave 3
	note E_, 5
	note __, 1
; bar 2
	octave 1
	note G#, 8
	note __, 1
	note __, 3
	note G#, 5
	note __, 1
	octave 3
	note D_, 5
	note __, 1
	octave 1
	note G#, 8
	note __, 1
	note __, 3
	note A_, 5
	note __, 1
	octave 3
	note D_, 5
	note __, 1
; bar 3
	octave 1
	note G_, 8
	note __, 1
	note __, 3
	note G_, 5
	note __, 1
	octave 3
	note D_, 5
	note __, 1
	octave 1
	note G_, 8
	note __, 1
	note __, 3
	note G#, 5
	note __, 1
	octave 3
	note D_, 5
	note __, 1
; bar 4
	octave 1
	note F#, 8
	note __, 1
	note __, 3
	note F#, 5
	note __, 1
	octave 3
	note C#, 5
	note __, 1
	octave 1
	note F#, 8
	note __, 1
	note __, 3
	note G_, 5
	note __, 1
	octave 3
	note C#, 5
	note __, 1
; bar 5
	octave 2
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	note F#, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F#, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
; bar 6
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	note B_, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note B_, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
; bar 7
	note G#, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
	note G#, 5
	note __, 1
	note A_, 2
	note __, 1
	note G#, 2
	note __, 1
	note G#, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
; bar 8
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_D:
	notetype 2, $1b
; bar 1
	octave 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 2
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 3
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	note A#, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
	note A_, 5
	note __, 1
	octave 3
	note E_, 2
	note __, 1
	octave 2
	note A_, 2
	note __, 1
; bar 4
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
; bar 5
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	note F#, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 5
	note __, 1
	octave 3
	note C_, 2
	note __, 1
	octave 2
	note F_, 2
	note __, 1
; bar 6
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	note B_, 2
	note __, 1
	note A#, 2
	note __, 1
	note A#, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
	note B_, 5
	note __, 1
	octave 3
	note F_, 2
	note __, 1
	octave 2
	note A#, 2
	note __, 1
; bar 7
	note G#, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
	note G#, 5
	note __, 1
	note A_, 2
	note __, 1
	note G#, 2
	note __, 1
	note G#, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
	note G#, 5
	note __, 1
	octave 3
	note D_, 2
	note __, 1
	octave 2
	note G#, 2
	note __, 1
; bar 8
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note F_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	note F_, 5
	note __, 1
	note B_, 2
	note __, 1
	note E_, 2
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_Intro:
; bar 1
	note C_, 3
	note __, 1
	note C_, 2
	note D#, 2
	note C_, 3
	note __, 1
	note C#, 2
	note D#, 2
; bar 2
	note C_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C#, 1
	note A_, 1
	note A_, 1
	note A_, 1
; bar 3
	note F_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 2
; bar 4
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note A_, 1
	note A_, 1
	note F#, 2
	note G_, 1
	note G#, 1
	note C#, 1
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_A:
; bar 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 2
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 3
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 4
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note __, 1
; bar 5
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 6
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 7
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 8
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note F#, 1
	note G_, 1
	note G#, 2
	endchannel

Music_RocketExecutiveBattle_Ch4_B:
; bar 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 2
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 3
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 4
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note __, 1
; bar 5
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 6
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 7
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 8
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note F#, 1
	note G_, 1
	note G#, 2
	endchannel

Music_RocketExecutiveBattle_Ch4_C:
; bar 1
	note C_, 3
	note A#, 1
	note D#, 2
	note C_, 2
	note C#, 3
	note A#, 1
	note D#, 2
	note C_, 1
	note D_, 1
; bar 2
	note C_, 3
	note A#, 1
	note D#, 2
	note C_, 2
	note C#, 3
	note A#, 1
	note D#, 2
	note C_, 1
	note D_, 1
; bar 3
	note C_, 3
	note A#, 1
	note D#, 2
	note C_, 2
	note C#, 3
	note A#, 1
	note D#, 2
	note C_, 1
	note D_, 1
; bar 4
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note __, 1
; bar 5
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 6
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 7
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note F#, 1
	note G_, 1
	note G#, 2
; bar 8
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note __, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_D:
; bar 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 2
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 3
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 4
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note F#, 1
	note G_, 1
	note G#, 2
; bar 5
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 6
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note D#, 1
	note C#, 2
	note D#, 1
	note D_, 1
; bar 7
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D_, 1
	note D#, 1
; bar 8
	note C_, 2
	note D#, 1
	note C_, 1
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note __, 1
	endchannel

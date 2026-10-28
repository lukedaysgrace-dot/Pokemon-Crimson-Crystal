; Rocket Executive Battle - original composition for Crimson Crystal.
; Plays for the four named admins: Proton, Petrel, Ariana and Archer
; (see PlayBattleMusic in engine/battle/start_battle.asm).
;
; E minor with Phrygian (F) and tritone (Bb) colour, 149 BPM.
; tempo 256 with notetype 6: one 16th note = 6 frames, one bar = 96 frames.
;
; Form (bars):  Intro 4 | A 8 | B 8 | C 8 | D 8 | B' 8 | loop to A
;   Intro  tritone hits, chromatic bass climbs, a diminished cascade over a
;          swelling pedal, then dominant hits and a tom fill.
;   A      "The Prowl": pumping 16th octave bass riff (E with a Phrygian F),
;          tresillo stabs, then a creeping chromatic line doubled an octave
;          down on ch1 (detuned with tone for weight).
;   B      Main theme (Em C Am B | Em C F B) with a parallel harmony on ch1.
;   C      Lament bass E D# D C# C B A# B in a gallop, soaring lead,
;          16th-note arpeggios on ch1.
;   D      Half-time breakdown: deep E1/F1 chugs, quiet tremolo,
;          low march melody, swelling build into the reprise.
;   B'     Theme reprise: ch1 doubles the lead an octave down, gallop bass.
;
; Ch1 harmony/texture (left), Ch2 lead, Ch3 bass on wave sample 12 (full
; volume on strong 16ths, half volume on weak ones), Ch4 drumkit 6.
; One loop is 40 bars = 3840 frames (about 64 seconds); intro is 384 frames.

Music_RocketExecutiveBattle:
	musicheader 4, 1, Music_RocketExecutiveBattle_Ch1
	musicheader 1, 2, Music_RocketExecutiveBattle_Ch2
	musicheader 1, 3, Music_RocketExecutiveBattle_Ch3
	musicheader 1, 4, Music_RocketExecutiveBattle_Ch4

Music_RocketExecutiveBattle_Ch1:
	tempo 256
	volume $77
	stereopanning $f0
	callchannel Music_RocketExecutiveBattle_Ch1_Intro
Music_RocketExecutiveBattle_Ch1_Loop:
	callchannel Music_RocketExecutiveBattle_Ch1_StabsA
	callchannel Music_RocketExecutiveBattle_Ch1_CreepA
	callchannel Music_RocketExecutiveBattle_Ch1_ThemeB
	callchannel Music_RocketExecutiveBattle_Ch1_ArpC
	callchannel Music_RocketExecutiveBattle_Ch1_TremD
	callchannel Music_RocketExecutiveBattle_Ch1_ThemeB2
	loopchannel 0, Music_RocketExecutiveBattle_Ch1_Loop

Music_RocketExecutiveBattle_Ch2:
	stereopanning $ff
	callchannel Music_RocketExecutiveBattle_Ch2_Intro
Music_RocketExecutiveBattle_Ch2_Loop:
	callchannel Music_RocketExecutiveBattle_Ch2_StabsA
	callchannel Music_RocketExecutiveBattle_Ch2_CreepA
	callchannel Music_RocketExecutiveBattle_Ch2_ThemeB
	callchannel Music_RocketExecutiveBattle_Ch2_SoarC
	callchannel Music_RocketExecutiveBattle_Ch2_MarchD
	callchannel Music_RocketExecutiveBattle_Ch2_ThemeB
	loopchannel 0, Music_RocketExecutiveBattle_Ch2_Loop

Music_RocketExecutiveBattle_Ch3:
	stereopanning $ff
	callchannel Music_RocketExecutiveBattle_Ch3_Intro
Music_RocketExecutiveBattle_Ch3_Loop:
Music_RocketExecutiveBattle_Ch3_Rep1:
	callchannel Music_RocketExecutiveBattle_Ch3_RiffA
	loopchannel 3, Music_RocketExecutiveBattle_Ch3_Rep1
	callchannel Music_RocketExecutiveBattle_Ch3_TurnA
	callchannel Music_RocketExecutiveBattle_Ch3_ThemeB
	callchannel Music_RocketExecutiveBattle_Ch3_GallopC
	callchannel Music_RocketExecutiveBattle_Ch3_ChugD
	callchannel Music_RocketExecutiveBattle_Ch3_GallopB2
	loopchannel 0, Music_RocketExecutiveBattle_Ch3_Loop

Music_RocketExecutiveBattle_Ch4:
	stereopanning $ff
	callchannel Music_RocketExecutiveBattle_Ch4_Intro
Music_RocketExecutiveBattle_Ch4_Loop:
	callchannel Music_RocketExecutiveBattle_Ch4_GrooveA
	callchannel Music_RocketExecutiveBattle_Ch4_GrooveA2
	callchannel Music_RocketExecutiveBattle_Ch4_GrooveB
	callchannel Music_RocketExecutiveBattle_Ch4_GrooveC
	callchannel Music_RocketExecutiveBattle_Ch4_HalfD
	callchannel Music_RocketExecutiveBattle_Ch4_GrooveB2
	loopchannel 0, Music_RocketExecutiveBattle_Ch4_Loop

; Channel 1 phrases

Music_RocketExecutiveBattle_Ch1_Intro:
; bar 1
	dutycycle 3
	tone $0001
	notetype 6, $b3
	octave 3
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
; bar 2
	note B_, 3
	note B_, 3
	note B_, 2
	note __, 8
; bar 3
	dutycycle 2
	intensity $72
	note __, 1
	octave 4
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 3
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note A#, 1
	note G_, 1
	note E_, 1
; bar 4
	dutycycle 3
	intensity $b3
	note F#, 2
	note __, 1
	note F#, 1
	note F#, 2
	note __, 2
	intensity $3f
	note A_, 8
	endchannel

Music_RocketExecutiveBattle_Ch1_StabsA:
; bar 1
	dutycycle 2
	tone $0000
	vibrato $00, $00
	notetype 6, $93
	octave 3
	note G_, 2
	note __, 1
	note G_, 2
	note __, 1
	note G_, 1
	note __, 9
; bar 2
	note __, 8
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 2
; bar 3
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	note B_, 1
	note __, 9
; bar 4
	note __, 8
	octave 4
	note C_, 2
	note __, 1
	note C_, 2
	note __, 1
	note C_, 2
	endchannel

Music_RocketExecutiveBattle_Ch1_CreepA:
; bar 1
	dutycycle 3
	tone $0002
	vibrato $10, $33
	notetype 6, $87
	octave 2
	note B_, 6
	octave 3
	note C_, 2
	octave 2
	note B_, 4
	note A#, 4
; bar 2
	note B_, 6
	note __, 2
	octave 3
	note C_, 4
	octave 2
	note A_, 4
; bar 3
	octave 3
	note E_, 6
	note F_, 2
	note E_, 4
	note D#, 4
; bar 4
	note F#, 4
	note G_, 2
	note F#, 2
	note D#, 8
	endchannel

Music_RocketExecutiveBattle_Ch1_ThemeB:
; bar 1
	dutycycle 1
	tone $0000
	vibrato $12, $23
	notetype 6, $97
	octave 3
	note G_, 3
	note B_, 3
	octave 4
	note E_, 2
	note D_, 4
	octave 3
	note B_, 4
; bar 2
	octave 4
	note C_, 8
	octave 3
	note A_, 4
	note G_, 4
; bar 3
	note E_, 3
	note A_, 3
	octave 4
	note C_, 2
	note E_, 8
; bar 4
	note D#, 3
	note E_, 3
	note D#, 2
	octave 3
	note B_, 8
; bar 5
	note G_, 3
	note B_, 3
	octave 4
	note E_, 2
	note G_, 4
	note F#, 2
	note E_, 2
; bar 6
	note G_, 8
	note E_, 4
	note C_, 4
; bar 7
	note C_, 3
	note F_, 3
	note A_, 2
	note F_, 8
; bar 8
	note F#, 3
	note E_, 3
	note D#, 2
	octave 3
	note B_, 4
	note F#, 4
	endchannel

Music_RocketExecutiveBattle_Ch1_ArpC:
; bar 1
	dutycycle 0
	tone $0000
	notetype 6, $72
	octave 3
	note E_, 1
	note G_, 1
	note B_, 1
	octave 4
	note E_, 1
	octave 3
	note B_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note B_, 1
	octave 4
	note E_, 1
	octave 3
	note B_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note B_, 1
	octave 4
	note E_, 1
; bar 2
	octave 3
	note D#, 1
	note F#, 1
	note B_, 1
	octave 4
	note D#, 1
	octave 3
	note B_, 1
	note F#, 1
	note D#, 1
	note F#, 1
	note B_, 1
	octave 4
	note D#, 1
	octave 3
	note B_, 1
	note F#, 1
	note D#, 1
	note F#, 1
	note B_, 1
	octave 4
	note D#, 1
; bar 3
	octave 3
	note D_, 1
	note F#, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note A_, 1
	note F#, 1
	note D_, 1
	note F#, 1
	note A_, 1
	octave 4
	note D_, 1
	octave 3
	note A_, 1
	note F#, 1
	note D_, 1
	note F#, 1
	note A_, 1
	octave 4
	note D_, 1
; bar 4
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note E_, 1
	note G_, 1
	note A_, 1
; bar 5
	note C_, 1
	note E_, 1
	note G_, 1
	octave 4
	note C_, 1
	octave 3
	note G_, 1
	note E_, 1
	note C_, 1
	note E_, 1
	note G_, 1
	octave 4
	note C_, 1
	octave 3
	note G_, 1
	note E_, 1
	note C_, 1
	note E_, 1
	note G_, 1
	octave 4
	note C_, 1
; bar 6
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note B_, 1
	note F#, 1
	note D#, 1
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note B_, 1
	note F#, 1
	note D#, 1
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note B_, 1
; bar 7
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 2
	note A#, 1
	octave 3
	note C#, 1
	note E_, 1
	note G_, 1
; bar 8
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note A_, 1
	note F#, 1
	note D#, 1
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note A_, 1
	note F#, 1
	note D#, 1
	octave 2
	note B_, 1
	octave 3
	note D#, 1
	note F#, 1
	note A_, 1
	endchannel

Music_RocketExecutiveBattle_Ch1_TremD:
; bar 1
	dutycycle 2
	tone $0000
	notetype 6, $61
	octave 3
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note G_, 1
; bar 2
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note A_, 1
; bar 3
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
; bar 4
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
; bar 5
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
	octave 3
	note E_, 1
	octave 4
	note C_, 1
; bar 6
	octave 3
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
; bar 7
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
	note C#, 1
	note G_, 1
; bar 8
	intensity $81
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	note D#, 1
	note A_, 1
	endchannel

Music_RocketExecutiveBattle_Ch1_ThemeB2:
; bar 1
	dutycycle 3
	tone $0002
	vibrato $12, $23
	notetype 6, $a7
	octave 2
	note B_, 3
	octave 3
	note E_, 3
	note G_, 2
	note F#, 4
	note E_, 4
; bar 2
	note F_, 6
	note E_, 2
	note C_, 4
	octave 2
	note B_, 4
; bar 3
	note A_, 3
	octave 3
	note C_, 3
	note E_, 2
	note A_, 6
	note G_, 2
; bar 4
	note F#, 3
	note G_, 3
	note F#, 2
	note D#, 8
; bar 5
	octave 2
	note B_, 3
	octave 3
	note E_, 3
	note G_, 2
	note B_, 4
	note A_, 2
	note G_, 2
; bar 6
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note G_, 4
	note E_, 4
; bar 7
	note F_, 3
	note A_, 3
	octave 4
	note C_, 2
	octave 3
	note B_, 4
	note A_, 4
; bar 8
	note A_, 3
	note G_, 3
	note F#, 2
	note D#, 4
	octave 2
	note B_, 4
	endchannel

; Channel 2 phrases

Music_RocketExecutiveBattle_Ch2_Intro:
; bar 1
	dutycycle 1
	vibrato $08, $24
	notetype 6, $c3
	octave 4
	note E_, 3
	note E_, 3
	note E_, 2
	note __, 8
; bar 2
	note F_, 3
	note F_, 3
	note F_, 2
	note __, 8
; bar 3
	dutycycle 2
	intensity $a2
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	octave 3
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
	note A#, 1
	note G_, 1
	note E_, 1
	note C#, 1
; bar 4
	dutycycle 1
	intensity $c3
	note B_, 2
	note __, 1
	note B_, 1
	note B_, 2
	note __, 2
	intensity $b8
	note B_, 8
	endchannel

Music_RocketExecutiveBattle_Ch2_StabsA:
; bar 1
	dutycycle 2
	vibrato $00, $00
	notetype 6, $b3
	octave 3
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	note B_, 1
	note __, 9
; bar 2
	note __, 8
	octave 4
	note C_, 2
	note __, 1
	note C_, 2
	note __, 1
	note C_, 2
; bar 3
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 1
	note __, 9
; bar 4
	note __, 8
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	endchannel

Music_RocketExecutiveBattle_Ch2_CreepA:
; bar 1
	dutycycle 1
	vibrato $10, $33
	notetype 6, $b7
	octave 3
	note B_, 6
	octave 4
	note C_, 2
	octave 3
	note B_, 4
	note A#, 4
; bar 2
	note B_, 6
	note __, 2
	octave 4
	note C_, 4
	octave 3
	note A_, 4
; bar 3
	octave 4
	note E_, 6
	note F_, 2
	note E_, 4
	note D#, 4
; bar 4
	note F#, 4
	note G_, 2
	note F#, 2
	note D#, 8
	endchannel

Music_RocketExecutiveBattle_Ch2_ThemeB:
; bar 1
	dutycycle 2
	vibrato $12, $34
	notetype 6, $c7
	octave 3
	note B_, 3
	octave 4
	note E_, 3
	note G_, 2
	note F#, 4
	note E_, 4
; bar 2
	note F_, 6
	note E_, 2
	note C_, 4
	octave 3
	note B_, 4
; bar 3
	note A_, 3
	octave 4
	note C_, 3
	note E_, 2
	note A_, 6
	note G_, 2
; bar 4
	note F#, 3
	note G_, 3
	note F#, 2
	note D#, 8
; bar 5
	octave 3
	note B_, 3
	octave 4
	note E_, 3
	note G_, 2
	note B_, 4
	note A_, 2
	note G_, 2
; bar 6
	octave 5
	note C_, 6
	octave 4
	note B_, 2
	note G_, 4
	note E_, 4
; bar 7
	note F_, 3
	note A_, 3
	octave 5
	note C_, 2
	octave 4
	note B_, 4
	note A_, 4
; bar 8
	note A_, 3
	note G_, 3
	note F#, 2
	note D#, 4
	octave 3
	note B_, 4
	endchannel

Music_RocketExecutiveBattle_Ch2_SoarC:
; bar 1
	dutycycle 2
	vibrato $14, $35
	notetype 6, $c8
	octave 4
	note B_, 10
	note A_, 2
	note G_, 4
; bar 2
	note F#, 12
	note G_, 2
	note F#, 2
; bar 3
	note A_, 10
	note G_, 2
	note F#, 4
; bar 4
	note E_, 10
	note F#, 2
	note G_, 4
; bar 5
	octave 5
	note C_, 10
	octave 4
	note B_, 2
	note G_, 4
; bar 6
	note B_, 12
	note A_, 2
	note F#, 2
; bar 7
	note G_, 6
	note E_, 2
	note C#, 4
	octave 3
	note A#, 4
; bar 8
	intensity $c5
	note B_, 2
	octave 4
	note D#, 2
	note F#, 2
	note A_, 2
	intensity $c8
	note B_, 8
	endchannel

Music_RocketExecutiveBattle_Ch2_MarchD:
; bar 1
	dutycycle 3
	vibrato $18, $34
	notetype 6, $b5
	octave 3
	note B_, 6
	octave 4
	note C_, 2
	octave 3
	note B_, 8
; bar 2
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note A_, 8
; bar 3
	note G_, 6
	note A_, 2
	note G_, 4
	note F#, 4
; bar 4
	note F_, 8
	note E_, 8
; bar 5
	dutycycle 2
	intensity $b7
	octave 4
	note G_, 6
	note F_, 2
	note E_, 8
; bar 6
	note F#, 6
	note G_, 2
	note F#, 4
	note D#, 4
; bar 7
	note G_, 4
	note E_, 4
	note C#, 4
	octave 3
	note A#, 4
; bar 8
	intensity $3f
	note B_, 16
	endchannel

; Channel 3 phrases

Music_RocketExecutiveBattle_Ch3_Intro:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
; bar 2
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	note F#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C_, 1
	note C#, 1
; bar 3
	intensity $3c
	octave 2
	note E_, 1
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	intensity $2c
	note E_, 1
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
; bar 4
	octave 1
	note B_, 2
	note __, 1
	note B_, 1
	note B_, 2
	note __, 2
	note B_, 2
	octave 2
	note C_, 2
	note C#, 1
	note D_, 1
	note D#, 2
	endchannel

Music_RocketExecutiveBattle_Ch3_RiffA:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note G_, 1
; bar 2
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note F_, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 1
	intensity $2c
	octave 2
	note F_, 1
	note __, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	note D_, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_TurnA:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	note D#, 1
; bar 2
	intensity $1c
	octave 1
	note B_, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	note __, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	octave 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	endchannel

Music_RocketExecutiveBattle_Ch3_ThemeB:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 1
	note B_, 1
; bar 2
	intensity $1c
	octave 2
	note C_, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	note __, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	note __, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note G_, 1
; bar 3
	intensity $1c
	octave 1
	note A_, 1
	intensity $2c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 1
	intensity $2c
	octave 1
	note A_, 1
	note __, 1
	intensity $2c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 1
	intensity $2c
	octave 1
	note A_, 1
	intensity $1c
	note A_, 1
	intensity $2c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 1
	intensity $2c
	octave 1
	note A_, 1
	note __, 1
	intensity $2c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 1
	intensity $2c
	note E_, 1
; bar 4
	intensity $1c
	octave 1
	note B_, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	note __, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	note __, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	note D#, 1
; bar 5
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 2
	note E_, 1
	note __, 1
	intensity $2c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 1
	intensity $2c
	octave 1
	note B_, 1
; bar 6
	intensity $1c
	octave 2
	note C_, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	note __, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note C_, 1
	note __, 1
	intensity $2c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 1
	intensity $2c
	octave 2
	note E_, 1
; bar 7
	intensity $1c
	note F_, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 1
	intensity $2c
	octave 2
	note F_, 1
	note __, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 1
	intensity $2c
	octave 2
	note F_, 1
	intensity $1c
	note F_, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 1
	intensity $2c
	octave 2
	note F_, 1
	note __, 1
	intensity $2c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 1
	intensity $2c
	octave 2
	note C_, 1
; bar 8
	intensity $1c
	octave 1
	note B_, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	note __, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	octave 1
	note B_, 1
	note __, 1
	intensity $2c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 1
	intensity $2c
	note D#, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_GallopC:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
; bar 2
	intensity $1c
	note D#, 2
	intensity $2c
	note D#, 1
	intensity $1c
	note D#, 1
	intensity $1c
	octave 3
	note D#, 2
	intensity $2c
	octave 2
	note D#, 1
	intensity $1c
	note D#, 1
	intensity $1c
	note D#, 2
	intensity $2c
	note D#, 1
	intensity $1c
	note D#, 1
	intensity $1c
	octave 3
	note D#, 2
	intensity $2c
	octave 2
	note D#, 1
	intensity $1c
	note D#, 1
; bar 3
	intensity $1c
	note D_, 2
	intensity $2c
	note D_, 1
	intensity $1c
	note D_, 1
	intensity $1c
	octave 3
	note D_, 2
	intensity $2c
	octave 2
	note D_, 1
	intensity $1c
	note D_, 1
	intensity $1c
	note D_, 2
	intensity $2c
	note D_, 1
	intensity $1c
	note D_, 1
	intensity $1c
	octave 3
	note D_, 2
	intensity $2c
	octave 2
	note D_, 1
	intensity $1c
	note D_, 1
; bar 4
	intensity $1c
	note C#, 2
	intensity $2c
	note C#, 1
	intensity $1c
	note C#, 1
	intensity $1c
	octave 3
	note C#, 2
	intensity $2c
	octave 2
	note C#, 1
	intensity $1c
	note C#, 1
	intensity $1c
	note C#, 2
	intensity $2c
	note C#, 1
	intensity $1c
	note C#, 1
	intensity $1c
	octave 3
	note C#, 2
	intensity $2c
	octave 2
	note C#, 1
	intensity $1c
	note C#, 1
; bar 5
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
; bar 6
	intensity $1c
	octave 1
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
; bar 7
	intensity $1c
	note A#, 2
	intensity $2c
	note A#, 1
	intensity $1c
	note A#, 1
	intensity $1c
	octave 2
	note A#, 2
	intensity $2c
	octave 1
	note A#, 1
	intensity $1c
	note A#, 1
	intensity $1c
	note A#, 2
	intensity $2c
	note A#, 1
	intensity $1c
	note A#, 1
	intensity $1c
	octave 2
	note A#, 2
	intensity $2c
	octave 1
	note A#, 1
	intensity $1c
	note A#, 1
; bar 8
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	octave 2
	note D#, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_ChugD:
; bar 1
	notetype 6, $1c
	octave 1
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 2
	note E_, 4
	intensity $2c
	note E_, 2
	intensity $1c
	octave 2
	note E_, 2
; bar 2
	intensity $1c
	octave 1
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 2
	note F_, 4
	intensity $2c
	note F_, 2
	intensity $1c
	octave 2
	note F_, 2
; bar 3
	intensity $1c
	octave 1
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 2
	note E_, 4
	intensity $2c
	note E_, 2
	intensity $1c
	octave 2
	note E_, 2
; bar 4
	intensity $1c
	octave 1
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 2
	note E_, 4
	intensity $2c
	note E_, 2
	intensity $1c
	octave 2
	note E_, 2
; bar 5
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 2
	note C_, 4
	intensity $2c
	note C_, 2
	intensity $1c
	octave 3
	note C_, 2
; bar 6
	intensity $1c
	octave 1
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 2
	note B_, 4
	intensity $2c
	note B_, 2
	intensity $1c
	octave 2
	note B_, 2
; bar 7
	intensity $1c
	note C#, 2
	intensity $2c
	note C#, 1
	intensity $1c
	note C#, 2
	intensity $2c
	note C#, 1
	intensity $1c
	note C#, 2
	octave 1
	note A#, 4
	intensity $2c
	note A#, 2
	intensity $1c
	octave 2
	note A#, 2
; bar 8
	intensity $3c
	octave 1
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	intensity $2c
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	intensity $1c
	note B_, 1
	octave 2
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note D#, 1
	endchannel

Music_RocketExecutiveBattle_Ch3_GallopB2:
; bar 1
	notetype 6, $1c
	octave 2
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
; bar 2
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
; bar 3
	intensity $1c
	octave 1
	note A_, 2
	intensity $2c
	note A_, 1
	intensity $1c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 2
	intensity $2c
	octave 1
	note A_, 1
	intensity $1c
	note A_, 1
	intensity $1c
	note A_, 2
	intensity $2c
	note A_, 1
	intensity $1c
	note A_, 1
	intensity $1c
	octave 2
	note A_, 2
	intensity $2c
	octave 1
	note A_, 1
	intensity $1c
	note A_, 1
; bar 4
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
; bar 5
	intensity $1c
	octave 2
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	note E_, 2
	intensity $2c
	note E_, 1
	intensity $1c
	note E_, 1
	intensity $1c
	octave 3
	note E_, 2
	intensity $2c
	octave 2
	note E_, 1
	intensity $1c
	note E_, 1
; bar 6
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	note C_, 2
	intensity $2c
	note C_, 1
	intensity $1c
	note C_, 1
	intensity $1c
	octave 3
	note C_, 2
	intensity $2c
	octave 2
	note C_, 1
	intensity $1c
	note C_, 1
; bar 7
	intensity $1c
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 2
	intensity $2c
	octave 2
	note F_, 1
	intensity $1c
	note F_, 1
	intensity $1c
	note F_, 2
	intensity $2c
	note F_, 1
	intensity $1c
	note F_, 1
	intensity $1c
	octave 3
	note F_, 2
	intensity $2c
	octave 2
	note F_, 1
	intensity $1c
	note F_, 1
; bar 8
	intensity $1c
	octave 1
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	note B_, 2
	intensity $2c
	note B_, 1
	intensity $1c
	note B_, 1
	intensity $1c
	octave 2
	note B_, 2
	intensity $2c
	octave 1
	note B_, 1
	intensity $1c
	octave 2
	note D#, 1
	endchannel

; Channel 4 phrases

Music_RocketExecutiveBattle_Ch4_Intro:
; bar 1
	togglenoise 6
	notetype 6
	note F_, 3
	note C_, 3
	note C_, 2
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note C#, 1
; bar 2
	note F_, 3
	note C_, 3
	note C_, 2
	note D_, 1
	note A_, 1
	note D_, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
; bar 3
	note C_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note A_, 1
	note D_, 1
	note A_, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
; bar 4
	note F_, 2
	note __, 1
	note C_, 1
	note F_, 2
	note __, 2
	note F#, 1
	note F#, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note C#, 1
	note C#, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_GrooveA:
; bar 1
	notetype 6
	note F_, 3
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 2
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 3
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 4
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note E_, 2
	endchannel

Music_RocketExecutiveBattle_Ch4_GrooveA2:
; bar 1
	notetype 6
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 2
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 3
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note E_, 2
; bar 4
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note F#, 1
	note G#, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_GrooveB:
; bar 1
	notetype 6
	note F_, 3
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 2
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 3
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 4
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note E_, 2
; bar 5
	note F_, 3
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 6
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 7
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 8
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note F#, 1
	note G#, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_GrooveC:
; bar 1
	notetype 6
	note F_, 4
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 2
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 3
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 4
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
; bar 5
	note F_, 4
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 6
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 7
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note D#, 1
	note C_, 1
	note C_, 2
	note D#, 1
	note A#, 1
	note C#, 2
	note E_, 2
; bar 8
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_HalfD:
; bar 1
	notetype 6
	note F_, 6
	note C_, 2
	note C#, 4
	note D#, 2
	note D#, 1
	note D_, 1
; bar 2
	note C_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 4
	note D#, 2
	note D#, 1
	note D_, 1
; bar 3
	note C_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 4
	note D#, 2
	note D#, 1
	note D_, 1
; bar 4
	note C_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 4
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
; bar 5
	note F_, 6
	note C_, 2
	note C#, 4
	note D#, 2
	note D#, 1
	note D_, 1
; bar 6
	note C_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 4
	note D#, 2
	note D#, 1
	note D_, 1
; bar 7
	note C_, 2
	note D#, 2
	note C_, 2
	note C_, 2
	note C#, 4
	note D_, 1
	note A_, 1
	note C#, 1
	note C#, 1
; bar 8
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	endchannel

Music_RocketExecutiveBattle_Ch4_GrooveB2:
; bar 1
	notetype 6
	note F_, 3
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 2
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 3
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 4
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note E_, 2
; bar 5
	note F_, 3
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 6
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 7
	note C_, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note A#, 1
	note D#, 1
	note C_, 1
	note C_, 1
	note A#, 1
	note C_, 1
	note A#, 1
	note C#, 1
	note A#, 1
	note D_, 1
	note A#, 1
; bar 8
	note C_, 1
	note D#, 1
	note D#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note F#, 1
	note F#, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note C#, 1
	note C#, 1
	endchannel

; Battle! Norse Team -- evil team battle theme (Viking / Norse-god villains)
; Original track for Pokemon Crimson Crystal. Slow, heavy, low-register.
; Opening: falling two-octave cascade w/ echo voice, Phrygian chord hits, B-major horn blast.
; Loop: A (theme over syncopated riff) -> B (gods' march) -> rising cascade bridge -> riff break.
; Old pokecrystal macro syntax. Uses existing data only: drumkit 0 (smooth noise
; sounds only) and wave sample 2. NOT added to audio.asm, music_pointers.asm or
; music_constants.asm.

Music_NorseTeamBattle:
	musicheader 4, 1, Music_NorseTeamBattle_Ch1
	musicheader 1, 2, Music_NorseTeamBattle_Ch2
	musicheader 1, 3, Music_NorseTeamBattle_Ch3
	musicheader 1, 4, Music_NorseTeamBattle_Ch4

Music_NorseTeamBattle_Ch1:
	tempo 148
	volume $77
	vibrato $14, $22
	notetype $c, $a2
	dutycycle $1
	intensity $72
	note __, 1
	octave 4
	note E_, 1
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	dutycycle $2
	intensity $b3
	octave 3
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	note B_, 2
	intensity $a7
	note D#, 16
	dutycycle $3
	intensity $a1
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note D_, 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 1
	note A_, 2
Music_NorseTeamBattle_Loop_Ch1:
	dutycycle $3
	intensity $a1
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note D_, 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 1
	note A_, 2
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note D_, 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 1
	note A_, 2
	note G_, 1
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	note __, 1
	note G#, 2
	note G_, 1
	note G_, 1
	note __, 1
	note G_, 1
	note A#, 2
	note G#, 2
	note G_, 1
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	note __, 1
	octave 2
	note C#, 2
	note C_, 2
	octave 1
	note A#, 2
	note G#, 2
	note F_, 2
	note F#, 1
	note F#, 1
	note __, 1
	note F#, 1
	note F#, 1
	note __, 1
	note G_, 2
	note F#, 1
	note F#, 1
	note __, 1
	note F#, 1
	note A#, 2
	note G_, 2
	note F#, 1
	note F#, 1
	note __, 1
	note F#, 1
	note F#, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 2
	note A#, 2
	note G_, 2
	note E_, 2
	dutycycle $2
	intensity $87
	octave 4
	note C_, 3
	octave 3
	note A_, 3
	note B_, 2
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note A_, 3
	note G_, 3
	note A_, 2
	note E_, 8
	note A_, 3
	note F_, 3
	note E_, 2
	note F_, 6
	note A_, 2
	note A_, 3
	note A_, 3
	note F_, 2
	note C_, 8
	note E_, 3
	note G_, 3
	note A_, 2
	octave 4
	note C_, 6
	note C_, 2
	octave 3
	note B_, 3
	note G_, 3
	note A_, 2
	note B_, 6
	octave 4
	note C_, 2
	note D#, 3
	octave 3
	note B_, 3
	note B_, 2
	octave 4
	note D#, 8
	note C_, 3
	octave 3
	note B_, 3
	note A_, 2
	note F#, 8
	dutycycle $1
	intensity $72
	note __, 1
	octave 2
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 3
	note C_, 1
	note D_, 1
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 4
	note C_, 1
	note D_, 1
	note E_, 1
	dutycycle $2
	intensity $b3
	octave 3
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	note B_, 2
	intensity $a7
	note D#, 16
	dutycycle $3
	intensity $a1
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note D_, 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 1
	note A_, 2
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch1

Music_NorseTeamBattle_Ch2:
	vibrato $12, $23
	notetype $c, $a2
	dutycycle $2
	intensity $a2
	octave 4
	note E_, 1
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 2
	intensity $c3
	octave 4
	note C_, 3
	note C_, 3
	octave 3
	note B_, 2
	octave 4
	note C_, 3
	note C_, 3
	note D_, 2
	note D_, 3
	note D_, 3
	note C_, 2
	note E_, 3
	note E_, 3
	note D#, 2
	intensity $c7
	octave 3
	note B_, 16
	note __, 16
	note __, 16
Music_NorseTeamBattle_Loop_Ch2:
	dutycycle $2
	intensity $b6
	octave 3
	note B_, 3
	note E_, 3
	note F_, 2
	note G_, 6
	note F_, 2
	note E_, 3
	note D_, 3
	note E_, 2
	octave 2
	note B_, 8
	octave 3
	note B_, 3
	note E_, 3
	note F_, 2
	note G_, 6
	note A_, 2
	note A#, 3
	note A_, 3
	note G_, 2
	note F_, 4
	note E_, 4
	octave 4
	note C_, 3
	octave 3
	note G_, 3
	note A#, 2
	note A_, 6
	note G_, 2
	note F_, 3
	note E_, 3
	note F_, 2
	note G_, 8
	note F#, 3
	note G_, 3
	note A_, 2
	note B_, 6
	note A_, 2
	note G_, 3
	note F#, 3
	note D#, 2
	octave 2
	note B_, 8
	dutycycle $2
	intensity $b7
	octave 4
	note E_, 3
	note C_, 3
	note D_, 2
	note E_, 6
	note D_, 2
	note C_, 3
	octave 3
	note B_, 3
	octave 4
	note C_, 2
	octave 3
	note A_, 8
	octave 4
	note C_, 3
	octave 3
	note A_, 3
	note G_, 2
	note A_, 6
	octave 4
	note C_, 2
	note D_, 3
	note C_, 3
	octave 3
	note A_, 2
	note F_, 8
	note G_, 3
	octave 4
	note C_, 3
	note D_, 2
	note E_, 6
	note F_, 2
	note D_, 3
	octave 3
	note B_, 3
	octave 4
	note C_, 2
	note D_, 6
	note E_, 2
	note F#, 3
	note D#, 3
	note E_, 2
	note F#, 8
	note E_, 3
	note D#, 3
	note C_, 2
	octave 3
	note B_, 8
	dutycycle $2
	intensity $a2
	octave 2
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 3
	note C_, 1
	note D_, 1
	note E_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 4
	note C_, 1
	note D_, 1
	note E_, 2
	intensity $c3
	note C_, 3
	note C_, 3
	octave 3
	note B_, 2
	octave 4
	note C_, 3
	note C_, 3
	note D_, 2
	note D_, 3
	note D_, 3
	note C_, 2
	note E_, 3
	note E_, 3
	note D#, 2
	intensity $c7
	octave 3
	note B_, 16
	note __, 16
	note __, 16
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch2

Music_NorseTeamBattle_Ch3:
	notetype $c, $12
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	octave 1
	note B_, 2
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note G_, 2
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note A#, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note D_, 2
Music_NorseTeamBattle_Loop_Ch3:
	octave 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note G_, 2
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note A#, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note G_, 2
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note A#, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	note C#, 2
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note D#, 2
	note C#, 2
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	note F#, 2
	note F_, 2
	note D#, 2
	note C#, 2
	octave 1
	note A#, 2
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	octave 2
	note D#, 2
	note C_, 2
	octave 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 2
	note E_, 2
	note D#, 2
	note C_, 2
	octave 1
	note A_, 2
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	octave 1
	note A_, 3
	note A_, 3
	octave 2
	note A_, 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note C_, 3
	note C_, 3
	octave 3
	note C_, 2
	octave 2
	note C_, 3
	note C_, 3
	octave 3
	note C_, 2
	octave 1
	note G_, 3
	note G_, 3
	octave 2
	note G_, 2
	octave 1
	note G_, 3
	note G_, 3
	octave 2
	note G_, 2
	octave 1
	note B_, 3
	note B_, 3
	octave 2
	note B_, 2
	octave 1
	note B_, 3
	note B_, 3
	octave 2
	note B_, 2
	octave 1
	note B_, 3
	note B_, 3
	octave 2
	note B_, 2
	octave 1
	note B_, 3
	note B_, 3
	octave 2
	note B_, 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	octave 1
	note B_, 2
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	octave 1
	note B_, 1
	octave 2
	note B_, 1
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note G_, 2
	note F_, 2
	note E_, 1
	note E_, 1
	note __, 1
	note E_, 1
	note E_, 1
	note __, 1
	note A#, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch3

Music_NorseTeamBattle_Ch4:
	togglenoise 0
	notetype $c
	note E_, 16
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note C#, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
Music_NorseTeamBattle_Loop_Ch4:
	note E_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note E_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note D#, 1
	note C#, 2
	note G_, 2
	note C#, 2
	note C#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 16
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 3
	note C_, 3
	note C#, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 1
	note D#, 1
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch4

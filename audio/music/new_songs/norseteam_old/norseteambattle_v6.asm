; Battle! Norse Team -- evil team battle theme (Viking / Norse-god villains)
; Original track for Pokemon Crimson Crystal. Slow, heavy, low-register.
; Opening: syncopated power-chord hits (E -> F -> G -> A) into a held B blast + snare roll.
; Loop: A (two-voice theme over riff) -> stop-time hits w/ answers -> B (horns in fifths over 3-3-2 hits) -> A reprise -> hit bridge -> riff break.
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
	notetype $c, $b4
	dutycycle $3
	intensity $b4
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note F_, 8
	intensity $b4
	note E_, 3
	note E_, 3
	note E_, 2
	note G_, 4
	note F_, 4
	intensity $b4
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	intensity $b4
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	octave 1
	note B_, 2
	intensity $a7
	octave 2
	note F#, 16
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
	dutycycle $2
	intensity $96
	octave 2
	note B_, 4
	octave 3
	note E_, 2
	note G_, 4
	note F#, 2
	note E_, 2
	note D_, 2
	note E_, 3
	octave 2
	note B_, 3
	note G_, 2
	note B_, 8
	octave 3
	note C_, 4
	note E_, 2
	note F_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 3
	note C_, 3
	octave 2
	note G_, 2
	note E_, 8
	note E_, 2
	note A_, 2
	octave 3
	note C_, 2
	note E_, 6
	note E_, 2
	note D_, 2
	note C_, 3
	note D_, 3
	note C_, 2
	octave 2
	note A_, 4
	note E_, 4
	note F#, 2
	note B_, 2
	octave 3
	note D#, 2
	note F#, 6
	note F#, 2
	note E_, 2
	note D#, 3
	note E_, 3
	note D#, 2
	octave 2
	note B_, 4
	note F#, 4
	dutycycle $3
	intensity $b4
	note E_, 2
	note E_, 2
	note E_, 2
	note __, 10
	note F_, 2
	note F_, 2
	note F_, 2
	note __, 10
	note G_, 2
	note G_, 2
	note G_, 2
	note __, 10
	note A_, 3
	note A_, 3
	octave 1
	note B_, 2
	intensity $a7
	octave 2
	note F#, 8
	dutycycle $2
	intensity $a7
	note D_, 3
	note F_, 1
	note A_, 4
	octave 3
	note D_, 6
	note C_, 2
	octave 2
	note A#, 3
	note A_, 1
	note F_, 4
	note D_, 8
	note C_, 3
	note F_, 1
	note A_, 4
	octave 3
	note C_, 6
	octave 2
	note A#, 2
	note G_, 3
	note F_, 1
	note E_, 4
	note C_, 8
	note D_, 3
	note F_, 1
	note A_, 4
	octave 3
	note D_, 4
	note E_, 4
	note D_, 3
	note C_, 1
	octave 2
	note A#, 4
	note F_, 4
	note D_, 4
	note E_, 3
	note G#, 1
	note B_, 4
	octave 3
	note E_, 6
	note D_, 2
	note C_, 3
	octave 2
	note B_, 1
	note G#, 4
	note E_, 8
	dutycycle $3
	intensity $a5
	note E_, 4
	note G_, 2
	note B_, 4
	note A_, 2
	note G_, 2
	note F#, 2
	note G_, 3
	note E_, 3
	octave 1
	note B_, 2
	octave 2
	note E_, 8
	note E_, 4
	note G_, 2
	note A_, 4
	note G_, 2
	note F_, 2
	note E_, 2
	note F_, 3
	note E_, 3
	note C_, 2
	octave 1
	note G_, 8
	dutycycle $3
	intensity $b4
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note G_, 4
	note F_, 4
	intensity $b4
	note F_, 3
	note F_, 3
	note E_, 2
	note F_, 3
	note F_, 3
	note G_, 2
	intensity $b4
	note G_, 3
	note G_, 3
	note F_, 2
	note A_, 3
	note A_, 3
	octave 1
	note B_, 2
	intensity $a7
	octave 2
	note F#, 16
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
	vibrato $10, $23
	notetype $c, $c4
	dutycycle $2
	intensity $c4
	octave 2
	note B_, 3
	note B_, 3
	note B_, 2
	octave 3
	note C_, 8
	intensity $c4
	octave 2
	note B_, 3
	note B_, 3
	note B_, 2
	octave 3
	note D_, 4
	note C_, 4
	intensity $c4
	note C_, 3
	note C_, 3
	octave 2
	note B_, 2
	octave 3
	note C_, 3
	note C_, 3
	note D_, 2
	intensity $c4
	note D_, 3
	note D_, 3
	note C_, 2
	note E_, 3
	note E_, 3
	octave 2
	note F#, 2
	intensity $c7
	note B_, 16
	note __, 16
	note __, 16
Music_NorseTeamBattle_Loop_Ch2:
	dutycycle $2
	intensity $c6
	octave 3
	note E_, 4
	note G_, 2
	note B_, 4
	note A_, 2
	note G_, 2
	note F#, 2
	note G_, 3
	note E_, 3
	octave 2
	note B_, 2
	octave 3
	note E_, 8
	note E_, 4
	note G_, 2
	note A_, 4
	note G_, 2
	note F_, 2
	note E_, 2
	note F_, 3
	note E_, 3
	note C_, 2
	octave 2
	note G_, 8
	note A_, 2
	octave 3
	note C_, 2
	note E_, 2
	note A_, 6
	note G_, 2
	note F_, 2
	note E_, 3
	note F_, 3
	note E_, 2
	note C_, 4
	octave 2
	note A_, 4
	note B_, 2
	octave 3
	note D#, 2
	note F#, 2
	note B_, 6
	note A_, 2
	note G_, 2
	note F#, 3
	note G_, 3
	note F#, 2
	note D#, 4
	octave 2
	note B_, 4
	dutycycle $2
	intensity $c4
	note __, 6
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note E_, 4
	note __, 6
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 4
	note __, 6
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 4
	note E_, 3
	note E_, 3
	note D#, 2
	octave 2
	note B_, 8
	dutycycle $1
	intensity $c7
	note A_, 3
	octave 3
	note C_, 1
	note E_, 4
	note A_, 6
	note G_, 2
	note F_, 3
	note E_, 1
	note C_, 4
	octave 2
	note A_, 8
	note G_, 3
	octave 3
	note C_, 1
	note E_, 4
	note G_, 6
	note F_, 2
	note D_, 3
	note C_, 1
	octave 2
	note B_, 4
	note G_, 8
	note A_, 3
	octave 3
	note C_, 1
	note E_, 4
	note A_, 4
	note B_, 4
	note A_, 3
	note G_, 1
	note F_, 4
	note C_, 4
	octave 2
	note A_, 4
	note B_, 3
	octave 3
	note D#, 1
	note F#, 4
	note B_, 6
	note A_, 2
	note G_, 3
	note F#, 1
	note D#, 4
	octave 2
	note B_, 8
	dutycycle $2
	intensity $c6
	octave 3
	note E_, 4
	note G_, 2
	note B_, 4
	note A_, 2
	note G_, 2
	note F#, 2
	note G_, 3
	note E_, 3
	octave 2
	note B_, 2
	octave 3
	note E_, 8
	note E_, 4
	note G_, 2
	note A_, 4
	note G_, 2
	note F_, 2
	note E_, 2
	note F_, 3
	note E_, 3
	note C_, 2
	octave 2
	note G_, 8
	dutycycle $2
	intensity $c4
	note B_, 3
	note B_, 3
	note B_, 2
	octave 3
	note D_, 4
	note C_, 4
	intensity $c4
	note C_, 3
	note C_, 3
	octave 2
	note B_, 2
	octave 3
	note C_, 3
	note C_, 3
	note D_, 2
	intensity $c4
	note D_, 3
	note D_, 3
	note C_, 2
	note E_, 3
	note E_, 3
	octave 2
	note F#, 2
	intensity $c7
	note B_, 16
	note __, 16
	note __, 16
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch2

Music_NorseTeamBattle_Ch3:
	notetype $c, $12
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note F_, 8
	note E_, 3
	note E_, 3
	note E_, 2
	note G_, 4
	note F_, 4
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
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	note __, 1
	note A#, 2
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note A_, 1
	note __, 1
	octave 2
	note D#, 2
	note D_, 2
	note C_, 2
	octave 1
	note A#, 2
	note G_, 2
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
	octave 2
	note E_, 2
	note E_, 2
	note E_, 2
	note __, 10
	note F_, 2
	note F_, 2
	note F_, 2
	note __, 10
	note G_, 2
	note G_, 2
	note G_, 2
	note __, 10
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
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note G_, 4
	note F_, 4
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
	note C_, 3
	note C_, 3
	note D_, 2
	note E_, 8
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 4
	note C_, 4
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
	note E_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note E_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C_, 2
	note C_, 2
	note C_, 2
	note __, 2
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note __, 4
	note C_, 2
	note C_, 2
	note C_, 2
	note __, 2
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note __, 4
	note C_, 2
	note C_, 2
	note C_, 2
	note __, 2
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note __, 4
	note C_, 3
	note C_, 3
	note C_, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note E_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note D#, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note E_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note G_, 1
	note G_, 1
	note G_, 1
	note C#, 2
	note C_, 3
	note C_, 3
	note C_, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note E_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note D#, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note C_, 1
	note G_, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 3
	note C_, 3
	note D_, 2
	note C_, 4
	note C_, 4
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

; Battle! Norse Team -- evil team battle theme (Viking / Norse-god villains)
; Original track for Pokemon Crimson Crystal. Slow, heavy, low-register.
; Intro: lone bass ostinato, then low horns in open fifths (E-B -> F-C -> tritone).
; Loop: A (brooding E-minor/Phrygian theme) -> B (octave-doubled march) -> C (sinking bridge).
; Old pokecrystal macro syntax. Uses existing data only: drumkit 0 (smooth noise
; sounds only) and wave sample 2. NOT added to audio.asm, music_pointers.asm or
; music_constants.asm.

Music_NorseTeamBattle:
	musicheader 4, 1, Music_NorseTeamBattle_Ch1
	musicheader 1, 2, Music_NorseTeamBattle_Ch2
	musicheader 1, 3, Music_NorseTeamBattle_Ch3
	musicheader 1, 4, Music_NorseTeamBattle_Ch4

Music_NorseTeamBattle_Ch1:
	tempo 150
	volume $77
	dutycycle $2
	vibrato $18, $22
	notetype $c, $2b
	note __, 16
	octave 2
	note E_, 16
	note F_, 16
	note E_, 8
	note D#, 8
Music_NorseTeamBattle_Loop_Ch1:
	dutycycle $2
	intensity $60
	octave 2
	note G_, 16
	note G_, 16
	note A_, 16
	note G_, 16
	note G_, 16
	note A_, 16
	note G_, 16
	note F#, 16
	dutycycle $2
	intensity $87
	note A_, 8
	octave 3
	note C_, 4
	octave 2
	note B_, 4
	note B_, 8
	note G_, 4
	note E_, 4
	note F_, 4
	note A_, 4
	octave 3
	note C_, 6
	octave 2
	note B_, 2
	note E_, 4
	note G_, 4
	octave 3
	note C_, 8
	octave 2
	note A_, 6
	note B_, 2
	octave 3
	note C_, 4
	note E_, 4
	note D_, 6
	octave 2
	note B_, 2
	note G_, 4
	note E_, 4
	note F_, 6
	note E_, 2
	note F_, 4
	note A_, 4
	note F#, 8
	note D#, 4
	octave 1
	note B_, 4
	intensity $3b
	octave 2
	note B_, 16
	note B_, 16
	note B_, 16
	note B_, 16
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch1

Music_NorseTeamBattle_Ch2:
	dutycycle $2
	vibrato $14, $23
	notetype $c, $3b
	note __, 16
	octave 2
	note B_, 16
	octave 3
	note C_, 16
	octave 2
	note B_, 8
	note A_, 8
Music_NorseTeamBattle_Loop_Ch2:
	intensity $a7
	octave 2
	note B_, 4
	octave 3
	note E_, 6
	note F_, 2
	note E_, 4
	note D_, 4
	note E_, 4
	octave 2
	note B_, 8
	octave 3
	note A_, 6
	note G_, 2
	note F_, 4
	note E_, 4
	note E_, 10
	note D_, 2
	note C_, 4
	note C_, 4
	note E_, 4
	note G_, 6
	note F#, 2
	note A_, 6
	note G_, 2
	note E_, 4
	note C_, 4
	note E_, 4
	note G_, 4
	note B_, 6
	note A_, 2
	note A_, 4
	note F#, 4
	note D#, 4
	octave 2
	note B_, 4
	intensity $a7
	octave 3
	note A_, 8
	octave 4
	note C_, 4
	octave 3
	note B_, 4
	note B_, 8
	note G_, 4
	note E_, 4
	note F_, 4
	note A_, 4
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note E_, 4
	note G_, 4
	octave 4
	note C_, 8
	octave 3
	note A_, 6
	note B_, 2
	octave 4
	note C_, 4
	note E_, 4
	note D_, 6
	octave 3
	note B_, 2
	note G_, 4
	note E_, 4
	note F_, 6
	note E_, 2
	note F_, 4
	note A_, 4
	note F#, 8
	note D#, 4
	octave 2
	note B_, 4
	intensity $4b
	octave 3
	note G_, 16
	note F#, 16
	note F_, 16
	note E_, 8
	note D#, 8
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch2

Music_NorseTeamBattle_Ch3:
	notetype $c, $12
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	note G#, 2
	note F#, 2
	note F_, 4
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
Music_NorseTeamBattle_Loop_Ch3:
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	note G#, 2
	note F#, 2
	note F_, 4
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note C_, 2
	note __, 1
	note C_, 2
	note __, 1
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 4
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 2
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 4
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	octave 1
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	note B_, 2
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note B_, 4
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 2
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 4
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	note G#, 2
	note F#, 2
	note F_, 4
	note C_, 2
	note __, 1
	note C_, 2
	note __, 1
	note C_, 2
	note D#, 2
	note C#, 2
	note C_, 4
	octave 1
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	note A_, 2
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note A_, 4
	octave 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note F_, 2
	note __, 1
	note F_, 2
	note __, 1
	note F_, 2
	note G#, 2
	note F#, 2
	note F_, 4
	octave 1
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	note B_, 2
	octave 2
	note C_, 2
	octave 1
	note A#, 2
	note B_, 4
	octave 2
	note E_, 16
	note D#, 16
	note D_, 16
	note C_, 8
	octave 1
	note B_, 8
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch3

Music_NorseTeamBattle_Ch4:
	togglenoise 0
	notetype $c
	note __, 16
	note __, 16
	note E_, 16
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D_, 2
	note D_, 2
	note C#, 2
	note C#, 2
Music_NorseTeamBattle_Loop_Ch4:
	note E_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note D#, 2
	note D_, 2
	note C#, 2
	note E_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note C#, 2
	note G_, 2
	note D#, 2
	note D_, 2
	note C#, 2
	note C_, 2
	note E_, 16
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 2
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
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	loopchannel 0, Music_NorseTeamBattle_Loop_Ch4

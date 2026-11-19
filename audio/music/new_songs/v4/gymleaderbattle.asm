; Battle! Gym Leader
; Original track for Pokemon Crimson Crystal (old pokecrystal macro syntax).

Music_GymLeaderBattle:
	musicheader 3, 1, Music_GymLeaderBattle_Ch1
	musicheader 1, 2, Music_GymLeaderBattle_Ch2
	musicheader 1, 3, Music_GymLeaderBattle_Ch3

Music_GymLeaderBattle_Ch1:
	tempo 101
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b2
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F#, 1
	note E_, 1
	note D_, 1
	note C#, 1
	octave 2
	note B_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C#, 1
	note D_, 1
	note E_, 1
	note F#, 1
	note G_, 1
	note A_, 1
	note B_, 2
	note __, 2
	note B_, 2
	note __, 2
	note B_, 1
	note B_, 1
	note __, 2
	octave 4
	note C_, 4
	notetype $c, $b7
	octave 3
	note G_, 16
	note F#, 16
Music_GymLeaderBattle_Ch1_loop:
	notetype $c, $a5
	octave 3
	note E_, 6
	note E_, 2
	note E_, 4
	octave 2
	note B_, 4
	note B_, 6
	octave 3
	note E_, 2
	note E_, 4
	note E_, 4
	note G_, 6
	note E_, 2
	note E_, 4
	note C_, 4
	note C_, 10
	note __, 2
	note C_, 2
	note C_, 2
	note E_, 6
	note C_, 2
	note E_, 4
	note A_, 4
	note A_, 8
	note A_, 4
	note A_, 4
	note F#, 6
	note F#, 2
	note D#, 4
	octave 2
	note B_, 4
	note B_, 8
	note B_, 4
	note F#, 4
	octave 3
	note F_, 6
	note F_, 2
	note F_, 4
	note C_, 4
	note C_, 6
	note F_, 2
	note F_, 4
	note F_, 4
	note G#, 6
	note F_, 2
	note F_, 4
	note C#, 4
	note C#, 10
	note __, 2
	note C#, 2
	note C#, 2
	note F_, 6
	note C#, 2
	note F_, 4
	note A#, 4
	note A#, 8
	note A#, 4
	note A#, 4
	note G_, 6
	note G_, 2
	note E_, 4
	note C_, 4
	note C_, 8
	note C_, 4
	octave 2
	note G_, 4
	note B_, 4
	octave 3
	note E_, 4
	note E_, 4
	note B_, 4
	note A_, 6
	note A_, 2
	note D_, 4
	note D_, 4
	note C_, 6
	note E_, 2
	note G_, 4
	octave 4
	note C_, 4
	octave 3
	note B_, 8
	note F#, 4
	octave 2
	note B_, 4
	octave 3
	note E_, 4
	note E_, 4
	note B_, 4
	octave 4
	note E_, 4
	note D_, 6
	octave 3
	note A_, 2
	note A_, 4
	note D_, 4
	note E_, 4
	note G_, 4
	note F#, 4
	note F#, 4
	note F#, 8
	note F#, 4
	octave 2
	note B_, 4
	notetype $c, $b7
	loopchannel 0, Music_GymLeaderBattle_Ch1_loop

Music_GymLeaderBattle_Ch2:
	dutycycle $3
	vibrato $08, $36
	tone $0001
	notetype $c, $c2
	octave 4
	note E_, 1
	note D_, 1
	note C_, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F#, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F#, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 4
	note C_, 1
	note D_, 1
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	note E_, 1
	note E_, 1
	note __, 2
	note F_, 4
	notetype $c, $c7
	note C_, 16
	octave 3
	note B_, 16
Music_GymLeaderBattle_Ch2_loop:
	notetype $c, $c6
	octave 3
	note B_, 6
	note A_, 2
	note G_, 4
	note E_, 4
	note F#, 6
	note G_, 2
	note A_, 4
	note B_, 4
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note A_, 4
	note G_, 4
	note G_, 10
	note __, 2
	note E_, 2
	note G_, 2
	note A_, 6
	note G_, 2
	note A_, 4
	octave 4
	note C_, 4
	note E_, 8
	note D_, 4
	note C_, 4
	octave 3
	note B_, 6
	note A_, 2
	note G_, 4
	note F#, 4
	note F#, 8
	note D#, 4
	octave 2
	note B_, 4
	octave 4
	note C_, 6
	octave 3
	note A#, 2
	note G#, 4
	note F_, 4
	note G_, 6
	note G#, 2
	note A#, 4
	octave 4
	note C_, 4
	note C#, 6
	note C_, 2
	octave 3
	note A#, 4
	note G#, 4
	note G#, 10
	note __, 2
	note F_, 2
	note G#, 2
	note A#, 6
	note G#, 2
	note A#, 4
	octave 4
	note C#, 4
	note F_, 8
	note D#, 4
	note C#, 4
	note C_, 6
	octave 3
	note A#, 2
	note G#, 4
	note G_, 4
	note G_, 8
	note E_, 4
	note C_, 4
	note E_, 4
	note G_, 4
	note B_, 4
	octave 4
	note E_, 4
	note D_, 6
	note C_, 2
	octave 3
	note A_, 4
	note F#, 4
	note G_, 6
	note A_, 2
	octave 4
	note C_, 4
	note E_, 4
	note D#, 8
	octave 3
	note B_, 4
	note F#, 4
	note G_, 4
	note B_, 4
	octave 4
	note E_, 4
	note G_, 4
	note F#, 6
	note E_, 2
	note D_, 4
	octave 3
	note A_, 4
	note B_, 4
	octave 4
	note C_, 4
	octave 3
	note B_, 4
	note A_, 4
	note B_, 8
	note A_, 4
	note F#, 4
	notetype $c, $c7
	loopchannel 0, Music_GymLeaderBattle_Ch2_loop

Music_GymLeaderBattle_Ch3:
	notetype $c, $19
	octave 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
Music_GymLeaderBattle_Ch3_loop:
	octave 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note F_, 2
	octave 3
	note C_, 2
	note F_, 2
	note C_, 2
	octave 2
	note F_, 2
	octave 3
	note C_, 2
	note F_, 2
	note C_, 2
	octave 2
	note F_, 2
	octave 3
	note C_, 2
	note F_, 2
	note C_, 2
	octave 2
	note F_, 2
	octave 3
	note C_, 2
	note F_, 2
	note C_, 2
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	note B_, 2
	note F#, 2
	loopchannel 0, Music_GymLeaderBattle_Ch3_loop

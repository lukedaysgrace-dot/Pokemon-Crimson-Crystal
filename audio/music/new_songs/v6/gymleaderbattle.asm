; Battle! Gym Leader
; Original track for Pokemon Crimson Crystal (old pokecrystal macro syntax).

Music_GymLeaderBattle:
	musicheader 4, 1, Music_GymLeaderBattle_Ch1
	musicheader 1, 2, Music_GymLeaderBattle_Ch2
	musicheader 1, 3, Music_GymLeaderBattle_Ch3
	musicheader 1, 4, Music_GymLeaderBattle_Ch4

Music_GymLeaderBattle_Ch1:
	tempo 128
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b3
	octave 3
	note E_, 3
	note E_, 3
	note E_, 2
	note E_, 3
	note E_, 3
	note E_, 2
	note C_, 3
	note C_, 3
	note C_, 2
	note D_, 3
	note D_, 3
	note D_, 2
	note B_, 2
	note B_, 2
	note G#, 2
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 8
	note E_, 4
	octave 2
	note B_, 4
Music_GymLeaderBattle_Ch1_loop:
	notetype $c, $a5
	octave 3
	note E_, 3
	note E_, 3
	note A_, 2
	note A_, 8
	note G_, 3
	note G_, 3
	note G_, 2
	note G_, 8
	note F_, 3
	note F_, 3
	note G#, 2
	note F_, 4
	note C_, 4
	note E_, 8
	note E_, 4
	note B_, 4
	note E_, 3
	note E_, 3
	note A_, 2
	note A_, 8
	note G_, 3
	note G_, 3
	note B_, 2
	octave 4
	note D_, 8
	note C_, 6
	octave 3
	note A_, 2
	note A_, 4
	note F_, 4
	note E_, 6
	note G#, 2
	note E_, 4
	note E_, 4
	note F_, 3
	note F_, 3
	note A#, 2
	note A#, 8
	note G#, 3
	note G#, 3
	note G#, 2
	note G#, 8
	note F#, 3
	note F#, 3
	note A_, 2
	note F#, 4
	note C#, 4
	note F_, 8
	note F_, 4
	octave 4
	note C_, 4
	octave 3
	note F_, 3
	note F_, 3
	note A#, 2
	note A#, 8
	note G#, 3
	note G#, 3
	octave 4
	note C_, 2
	note D#, 8
	note C#, 6
	octave 3
	note A#, 2
	note A#, 4
	note F#, 4
	note F_, 6
	note A_, 2
	note F_, 4
	note F_, 4
	note C_, 2
	note F_, 2
	note F_, 8
	note F_, 4
	note D_, 2
	note G_, 2
	note G_, 8
	note G_, 4
	note B_, 8
	note G_, 4
	note E_, 4
	note A_, 12
	note E_, 4
	note D_, 2
	note A_, 2
	octave 4
	note D_, 8
	octave 3
	note A_, 4
	note D_, 2
	note G_, 2
	note G_, 8
	note G_, 4
	note G_, 6
	note G_, 2
	octave 4
	note C_, 4
	note C_, 4
	octave 3
	note B_, 4
	note B_, 4
	note G#, 4
	note E_, 4
	intensity $5f
	octave 2
	note B_, 2
	note B_, 2
	octave 3
	note C_, 2
	note C_, 2
	note D_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note E_, 2
	note F_, 2
	note F_, 2
	note F#, 2
	note F#, 2
	note __, 4
	intensity $93
	note A_, 3
	note A_, 3
	octave 4
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note C_, 2
	octave 3
	note B_, 8
	octave 4
	note C_, 3
	note C_, 3
	octave 3
	note B_, 2
	note A_, 4
	note G_, 4
	note G#, 8
	note B_, 4
	octave 4
	note E_, 4
	octave 3
	note A_, 3
	note A_, 3
	octave 4
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note E_, 2
	note G_, 8
	note F_, 6
	note E_, 2
	note D_, 4
	note C_, 4
	octave 3
	note B_, 6
	octave 4
	note C_, 2
	octave 3
	note B_, 4
	note G#, 4
	notetype $c, $b3
	loopchannel 0, Music_GymLeaderBattle_Ch1_loop

Music_GymLeaderBattle_Ch2:
	dutycycle $3
	vibrato $10, $25
	tone $0001
	notetype $c, $c3
	octave 3
	note A_, 3
	note A_, 3
	note A_, 2
	note A_, 3
	note A_, 3
	note A_, 2
	note F_, 3
	note F_, 3
	note F_, 2
	note G_, 3
	note G_, 3
	note G_, 2
	octave 4
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note B_, 2
	note B_, 8
	note G#, 4
	note E_, 4
Music_GymLeaderBattle_Ch2_loop:
	notetype $c, $c6
	octave 3
	note A_, 3
	note A_, 3
	octave 4
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note C_, 2
	octave 3
	note B_, 8
	octave 4
	note C_, 3
	note C_, 3
	octave 3
	note B_, 2
	note A_, 4
	note G_, 4
	note G#, 8
	note B_, 4
	octave 4
	note E_, 4
	octave 3
	note A_, 3
	note A_, 3
	octave 4
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note E_, 2
	note G_, 8
	note F_, 6
	note E_, 2
	note D_, 4
	note C_, 4
	octave 3
	note B_, 6
	octave 4
	note C_, 2
	octave 3
	note B_, 4
	note G#, 4
	note A#, 3
	note A#, 3
	octave 4
	note C#, 2
	note F_, 8
	note D#, 3
	note D#, 3
	note C#, 2
	note C_, 8
	note C#, 3
	note C#, 3
	note C_, 2
	octave 3
	note A#, 4
	note G#, 4
	note A_, 8
	octave 4
	note C_, 4
	note F_, 4
	octave 3
	note A#, 3
	note A#, 3
	octave 4
	note C#, 2
	note F_, 8
	note D#, 3
	note D#, 3
	note F_, 2
	note G#, 8
	note F#, 6
	note F_, 2
	note D#, 4
	note C#, 4
	note C_, 6
	note C#, 2
	note C_, 4
	octave 3
	note A_, 4
	note F_, 2
	note A_, 2
	octave 4
	note C_, 8
	octave 3
	note A_, 4
	note G_, 2
	note B_, 2
	octave 4
	note D_, 8
	octave 3
	note B_, 4
	octave 4
	note E_, 8
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 12
	octave 3
	note A_, 4
	note A_, 2
	octave 4
	note D_, 2
	note F_, 8
	note E_, 4
	octave 3
	note G_, 2
	note B_, 2
	octave 4
	note D_, 8
	note C_, 4
	note C_, 6
	note D_, 2
	note E_, 4
	note G_, 4
	note E_, 4
	note D_, 4
	note C_, 4
	octave 3
	note B_, 4
	intensity $6f
	note E_, 2
	note E_, 2
	note F_, 2
	note F_, 2
	note G_, 2
	note G_, 2
	note G#, 2
	note G#, 2
	note A_, 2
	note A_, 2
	note A#, 2
	note A#, 2
	note B_, 2
	note B_, 2
	note __, 4
	intensity $d3
	octave 2
	note A_, 3
	note A_, 3
	octave 3
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note C_, 2
	octave 2
	note B_, 8
	octave 3
	note C_, 3
	note C_, 3
	octave 2
	note B_, 2
	note A_, 4
	note G_, 4
	note G#, 8
	note B_, 4
	octave 3
	note E_, 4
	octave 2
	note A_, 3
	note A_, 3
	octave 3
	note C_, 2
	note E_, 8
	note D_, 3
	note D_, 3
	note E_, 2
	note G_, 8
	note F_, 6
	note E_, 2
	note D_, 4
	note C_, 4
	octave 2
	note B_, 6
	octave 3
	note C_, 2
	octave 2
	note B_, 4
	note G#, 4
	notetype $c, $c3
	loopchannel 0, Music_GymLeaderBattle_Ch2_loop

Music_GymLeaderBattle_Ch3:
	notetype $c, $19
	octave 2
	note A_, 3
	note A_, 3
	note A_, 2
	note A_, 3
	note A_, 3
	note A_, 2
	note F_, 3
	note F_, 3
	note F_, 2
	note G_, 3
	note G_, 3
	note G_, 2
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
Music_GymLeaderBattle_Ch3_loop:
	octave 2
	note A_, 3
	note A_, 3
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	note A_, 2
	octave 2
	note G_, 3
	note G_, 3
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
	note G_, 2
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
	note A_, 3
	note A_, 3
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	note E_, 2
	note A_, 2
	octave 2
	note G_, 3
	note G_, 3
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
	note G_, 2
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
	note A#, 3
	note A#, 3
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	note A#, 2
	octave 2
	note G#, 3
	note G#, 3
	note G#, 2
	octave 3
	note D#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	octave 2
	note F#, 2
	octave 3
	note C#, 2
	note F#, 2
	note C#, 2
	octave 2
	note F#, 2
	octave 3
	note C#, 2
	note F#, 2
	note C#, 2
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
	note A#, 3
	note A#, 3
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note F_, 2
	note A#, 2
	octave 2
	note G#, 3
	note G#, 3
	note G#, 2
	octave 3
	note D#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	octave 2
	note F#, 2
	octave 3
	note C#, 2
	note F#, 2
	note C#, 2
	octave 2
	note F#, 2
	octave 3
	note C#, 2
	note F#, 2
	note C#, 2
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
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
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
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	note G_, 2
	note D_, 2
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
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	note __, 4
	intensity $12
	octave 2
	note A_, 3
	note A_, 3
	note A_, 2
	note A_, 3
	note A_, 3
	octave 3
	note A_, 2
	octave 2
	note G_, 3
	note G_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	octave 3
	note G_, 2
	octave 2
	note F_, 3
	note F_, 3
	note F_, 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note E_, 3
	note E_, 3
	octave 3
	note E_, 2
	octave 2
	note A_, 3
	note A_, 3
	note A_, 2
	note A_, 3
	note A_, 3
	octave 3
	note A_, 2
	octave 2
	note G_, 3
	note G_, 3
	note G_, 2
	note G_, 3
	note G_, 3
	octave 3
	note G_, 2
	octave 2
	note F_, 3
	note F_, 3
	note F_, 2
	note F_, 3
	note F_, 3
	octave 3
	note F_, 2
	octave 2
	note E_, 3
	note E_, 3
	note E_, 2
	note E_, 3
	note E_, 3
	octave 3
	note E_, 2
	notetype $c, $19
	loopchannel 0, Music_GymLeaderBattle_Ch3_loop

Music_GymLeaderBattle_Ch4:
	togglenoise $3
	notetype $c
	note A#, 3
	note A#, 3
	note A#, 2
	note A#, 3
	note A#, 3
	note A#, 2
	note A#, 3
	note A#, 3
	note A#, 2
	note A#, 3
	note A#, 3
	note A#, 2
	note D#, 2
	note __, 14
	note __, 8
	note C_, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
Music_GymLeaderBattle_Ch4_loop:
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note A#, 3
	note A#, 3
	note A#, 2
	note __, 8
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 6
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note D#, 2
	note __, 14
	note A#, 4
	note A#, 4
	note A#, 4
	note A#, 4
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note __, 4
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note A#, 3
	note A#, 3
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	loopchannel 0, Music_GymLeaderBattle_Ch4_loop

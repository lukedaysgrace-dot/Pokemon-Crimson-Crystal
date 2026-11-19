Music_StarterTown:
	musicheader 4, 1, Music_StarterTown_Ch1
	musicheader 1, 2, Music_StarterTown_Ch2
	musicheader 1, 3, Music_StarterTown_Ch3
	musicheader 1, 4, Music_StarterTown_Ch4

Music_StarterTown_Ch1:
	tempo 176
	volume $77
	stereopanning $0f
	vibrato $10, $22
	dutycycle $2
	notetype $c, $a7
	note __, 16
	note __, 16
Music_StarterTown_Ch1_loop:
	dutycycle $2
	intensity $a7
	octave 3
	note G_, 2
	note A_, 2
	note B_, 4
	octave 4
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 6
	octave 3
	note B_, 2
	note A_, 4
	note G_, 4
	note F#, 4
	note A_, 4
	octave 4
	note D_, 6
	note C_, 2
	octave 3
	note B_, 10
	note __, 2
	note G_, 2
	note A_, 2
	note B_, 4
	octave 4
	note E_, 4
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 4
	octave 3
	note B_, 4
	note A_, 4
	note B_, 2
	octave 4
	note C_, 2
	note E_, 4
	note D_, 4
	note D_, 8
	note C_, 2
	octave 3
	note B_, 2
	note A_, 4
	dutycycle $1
	intensity $97
	note G_, 2
	note A_, 2
	note B_, 4
	octave 4
	note D_, 4
	note G_, 4
	note E_, 6
	note D_, 2
	note C_, 4
	note E_, 4
	note D_, 6
	note C_, 2
	octave 3
	note B_, 4
	note A_, 4
	note G_, 6
	note A_, 2
	note B_, 8
	octave 4
	note C_, 4
	note E_, 4
	note G_, 4
	note E_, 4
	note D_, 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 4
	note F#, 4
	note G_, 12
	note __, 4
	note __, 10
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	dutycycle $2
	intensity $86
	note E_, 8
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 8
	octave 3
	note B_, 4
	note G_, 4
	note A_, 4
	note B_, 4
	octave 4
	note C_, 4
	note E_, 4
	note D_, 10
	note __, 2
	note C_, 2
	note D_, 2
	note E_, 4
	note G_, 4
	note F#, 4
	note E_, 4
	note D_, 6
	note C_, 2
	octave 3
	note B_, 4
	octave 4
	note C_, 4
	octave 3
	note A_, 4
	note B_, 2
	octave 4
	note C_, 2
	note E_, 4
	note D_, 4
	note D_, 8
	note C_, 4
	octave 3
	note A_, 4
	loopchannel 0, Music_StarterTown_Ch1_loop

Music_StarterTown_Ch2:
	stereopanning $f0
	dutycycle $0
	notetype $c, $62
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_D7
Music_StarterTown_Ch2_loop:
	callchannel Music_StarterTown_Ch2_G
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_D
	callchannel Music_StarterTown_Ch2_G
	callchannel Music_StarterTown_Ch2_Em
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_Am
	callchannel Music_StarterTown_Ch2_D
	callchannel Music_StarterTown_Ch2_G
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_D
	callchannel Music_StarterTown_Ch2_Em
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_D
	callchannel Music_StarterTown_Ch2_G
	callchannel Music_StarterTown_Ch2_G
	intensity $52
	callchannel Music_StarterTown_Ch2_Em
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_Am
	callchannel Music_StarterTown_Ch2_D
	callchannel Music_StarterTown_Ch2_Em
	callchannel Music_StarterTown_Ch2_C
	callchannel Music_StarterTown_Ch2_Am
	callchannel Music_StarterTown_Ch2_D7
	intensity $62
	loopchannel 0, Music_StarterTown_Ch2_loop

Music_StarterTown_Ch2_G:
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D_, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D_, 2
	note G_, 2
	endchannel

Music_StarterTown_Ch2_C:
	octave 3
	note C_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	endchannel

Music_StarterTown_Ch2_D:
	octave 2
	note A_, 2
	octave 3
	note F#, 2
	note D_, 2
	note F#, 2
	octave 2
	note A_, 2
	octave 3
	note F#, 2
	note D_, 2
	note F#, 2
	endchannel

Music_StarterTown_Ch2_D7:
	octave 2
	note A_, 2
	octave 3
	note F#, 2
	note C_, 2
	note F#, 2
	octave 2
	note A_, 2
	octave 3
	note F#, 2
	note C_, 2
	note F#, 2
	endchannel

Music_StarterTown_Ch2_Em:
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note E_, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note E_, 2
	note G_, 2
	endchannel

Music_StarterTown_Ch2_Am:
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note C_, 2
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note C_, 2
	note E_, 2
	endchannel

Music_StarterTown_Ch3:
	stereopanning $ff
	notetype $c, $20
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_D7
Music_StarterTown_Ch3_loop:
	callchannel Music_StarterTown_Ch3_G
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_D
	callchannel Music_StarterTown_Ch3_G
	callchannel Music_StarterTown_Ch3_Em
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_Am
	callchannel Music_StarterTown_Ch3_D
	callchannel Music_StarterTown_Ch3_G
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_D
	callchannel Music_StarterTown_Ch3_Em
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_D
	callchannel Music_StarterTown_Ch3_G
	callchannel Music_StarterTown_Ch3_G
	callchannel Music_StarterTown_Ch3_Em
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_Am
	callchannel Music_StarterTown_Ch3_D
	callchannel Music_StarterTown_Ch3_Em
	callchannel Music_StarterTown_Ch3_C
	callchannel Music_StarterTown_Ch3_Am
	callchannel Music_StarterTown_Ch3_D7
	loopchannel 0, Music_StarterTown_Ch3_loop

Music_StarterTown_Ch3_G:
	octave 2
	note G_, 3
	note __, 1
	octave 3
	note D_, 3
	note __, 1
	note G_, 3
	note __, 1
	note D_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch3_C:
	octave 2
	note C_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 3
	note C_, 3
	note __, 1
	octave 2
	note G_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch3_D:
	octave 2
	note D_, 3
	note __, 1
	note A_, 3
	note __, 1
	octave 3
	note D_, 3
	note __, 1
	octave 2
	note A_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch3_D7:
	octave 2
	note D_, 3
	note __, 1
	note A_, 3
	note __, 1
	octave 3
	note D_, 3
	note __, 1
	octave 2
	note A_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch3_Em:
	octave 2
	note E_, 3
	note __, 1
	note B_, 3
	note __, 1
	octave 3
	note E_, 3
	note __, 1
	octave 2
	note B_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch3_Am:
	octave 2
	note A_, 3
	note __, 1
	octave 3
	note E_, 3
	note __, 1
	note A_, 3
	note __, 1
	note E_, 3
	note __, 1
	endchannel

Music_StarterTown_Ch4:
	stereopanning $f0
	togglenoise $0
	notetype $c
	note __, 16
	note __, 12
	note F_, 2
	note F_, 1
	note F_, 1
Music_StarterTown_Ch4_loop:
	callchannel Music_StarterTown_Ch4_main
	loopchannel 15, Music_StarterTown_Ch4_loop
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note D#, 1
	note D#, 1
	note F_, 2
Music_StarterTown_Ch4_bridge:
	callchannel Music_StarterTown_Ch4_soft
	loopchannel 8, Music_StarterTown_Ch4_bridge
	loopchannel 0, Music_StarterTown_Ch4_loop

Music_StarterTown_Ch4_main:
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 1
	note F_, 1
	endchannel

Music_StarterTown_Ch4_soft:
	note G_, 4
	note F_, 4
	note G_, 4
	note F_, 2
	note F_, 2
	endchannel

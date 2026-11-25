; Converted from pret/poketcg matchloss.asm by tools/beast_triad/tcg_music.py.

Music_BeastTriadLoss:
	musicheader 3, 1, Music_BeastTriadLoss_Ch1
	musicheader 1, 2, Music_BeastTriadLoss_Ch2
	musicheader 1, 3, Music_BeastTriadLoss_Ch3

Music_BeastTriadLoss_Ch1:
	tempo 256
	volume $77
	notetype 1, $b0
	dutycycle 2
	vibrato 20, $44
	tone 0
	octave 4
	note E_, 3
	notetype 17, $b0
	note F_, 1
	notetype 1, $b0
	note C_, 5
	intensity $37
	note C_, 15
	intensity $a0
	octave 3
	note A#, 5
	intensity $37
	note A#, 14
	intensity $a0
	octave 4
	note D_, 3
	notetype 2, $a0
	note D#, 9
	octave 3
	note A#, 3
	intensity $37
	note A#, 8
	intensity $a0
	note G#, 3
	intensity $37
	note G#, 8
	notetype 1, $a0
	octave 4
	note C_, 3
	notetype 2, $a0
	note C#, 10
	octave 3
	note G#, 3
	intensity $37
	note G#, 9
	notetype 1, $a0
	note F#, 5
	notetype 3, $37
	note F#, 7
	notetype 1, $a0
	note B_, 5
	notetype 17, $a0
	octave 4
	note C_, 6
	notetype 2, $37
	note C_, 9
	endchannel

Music_BeastTriadLoss_Ch2:
	notetype 1, $00
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 4
	notetype 107, $90
	dutycycle 2
	vibrato 20, $c6
	tone 0
	octave 3
	note G_, 1
	notetype 2, $37
	note G_, 9
	endchannel

Music_BeastTriadLoss_Ch3:
	notetype 2, $1b
	vibrato 0, $00
	tone 0
	octave 2
	note A#, 10
	octave 3
	note F_, 5
	intensity $2b
	note F_, 5
	intensity $1b
	note A#, 5
	notetype 1, $2b
	note A#, 9
	notetype 3, $1b
	octave 2
	note G#, 7
	notetype 1, $1b
	octave 3
	note D#, 11
	intensity $2b
	note D#, 11
	intensity $1b
	note G#, 11
	intensity $2b
	note G#, 11
	notetype 23, $1b
	octave 2
	note F#, 1
	notetype 1, $1b
	octave 3
	note C#, 12
	intensity $2b
	note C#, 12
	intensity $1b
	note F#, 12
	intensity $2b
	note F#, 13
	notetype 107, $1b
	octave 2
	note F_, 1
	endchannel

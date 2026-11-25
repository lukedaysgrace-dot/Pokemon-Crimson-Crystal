; Converted from pret/poketcg matchvictory.asm by tools/beast_triad/tcg_music.py.

Music_BeastTriadVictory:
	musicheader 3, 1, Music_BeastTriadVictory_Ch1
	musicheader 1, 2, Music_BeastTriadVictory_Ch2
	musicheader 1, 3, Music_BeastTriadVictory_Ch3

Music_BeastTriadVictory_Ch1:
	tempo 256
	volume $77
	notetype 2, $b0
	dutycycle 0
	vibrato 20, $44
	tone 0
	octave 3
	note A_, 12
	notetype 1, $27
	note A_, 5
	intensity $b0
	note A_, 7
	intensity $27
	note A_, 3
	intensity $b0
	note F_, 7
	intensity $27
	note F_, 3
	intensity $b0
	note A_, 7
	intensity $27
	note A_, 2
	intensity $b0
	note B_, 10
	intensity $27
	note B_, 10
	intensity $b0
	octave 4
	note C_, 10
	intensity $27
	note C_, 11
	intensity $b0
	note D_, 10
	intensity $27
	note D_, 10
	intensity $b0
	note C#, 8
	intensity $27
	note C#, 13
	intensity $b0
	note D_, 5
	intensity $27
	note D_, 6
	notetype 19, $b0
	note E_, 5
	notetype 2, $27
	note E_, 16
	endchannel

Music_BeastTriadVictory_Ch2:
	notetype 1, $b0
	dutycycle 0
	vibrato 20, $44
	tone 0
	octave 3
	note F_, 5
	intensity $27
	note F_, 5
	intensity $b0
	octave 2
	note A_, 5
	octave 3
	note C_, 5
	note F_, 5
	intensity $27
	note F_, 4
	intensity $b0
	note C_, 7
	intensity $27
	note C_, 3
	intensity $b0
	octave 2
	note A_, 7
	intensity $27
	note A_, 3
	intensity $b0
	octave 3
	note C_, 7
	intensity $27
	note C_, 2
	intensity $b0
	note G_, 10
	intensity $27
	note G_, 10
	intensity $b0
	note A_, 10
	intensity $27
	note A_, 11
	intensity $b0
	note B_, 10
	intensity $27
	note B_, 10
	intensity $b0
	note A_, 8
	intensity $27
	note A_, 13
	intensity $b0
	note B_, 5
	intensity $27
	note B_, 6
	notetype 19, $b0
	octave 4
	note C#, 5
	notetype 2, $27
	note C#, 16
	endchannel

Music_BeastTriadVictory_Ch3:
	notetype 2, $1b
	vibrato 0, $00
	tone 0
	octave 2
	note F_, 12
	notetype 1, $1b
	rest 5
	note F_, 7
	rest 3
	note F_, 7
	rest 3
	note F_, 7
	rest 2
	note G_, 10
	rest 10
	note G_, 11
	rest 10
	note G_, 10
	rest 10
	note A_, 8
	rest 13
	note E_, 5
	rest 6
	notetype 19, $1b
	note A_, 5
	endchannel

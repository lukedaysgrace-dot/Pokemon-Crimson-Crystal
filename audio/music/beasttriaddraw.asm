; Converted from pret/poketcg matchdraw.asm by tools/beast_triad/tcg_music.py.

Music_BeastTriadDraw:
	musicheader 3, 1, Music_BeastTriadDraw_Ch1
	musicheader 1, 2, Music_BeastTriadDraw_Ch2
	musicheader 1, 3, Music_BeastTriadDraw_Ch3

Music_BeastTriadDraw_Ch1:
	tempo 256
	volume $77
	notetype 1, $b0
	dutycycle 1
	vibrato 0, $00
	tone 0
	octave 4
	note C_, 12
	octave 3
	note B_, 6
	note A#, 6
	note A_, 6
	note G#, 6
	note G_, 6
	note F#, 6
	note F_, 11
	note E_, 6
	note D#, 6
	note D_, 6
	note C#, 6
	note C_, 6
	octave 2
	note B_, 6
	note A#, 12
	note B_, 6
	intensity $27
	note B_, 6
	intensity $b0
	note F#, 12
	note G_, 6
	intensity $27
	note G_, 6
	intensity $b0
	note C_, 6
	intensity $27
	note C_, 12
	intensity $b0
	octave 3
	note E_, 3
	note G_, 3
	octave 4
	note C_, 6
	intensity $27
	note C_, 5
	endchannel

Music_BeastTriadDraw_Ch2:
	notetype 1, $00
	rest 16
	rest 16
	rest 16
	intensity $b0
	dutycycle 1
	vibrato 0, $00
	tone 0
	octave 3
	note C_, 11
	octave 2
	note B_, 6
	note A#, 6
	note A_, 6
	note G#, 6
	note G_, 6
	note F#, 6
	note F_, 12
	note F#, 6
	intensity $27
	note F#, 6
	intensity $b0
	note C#, 12
	note D_, 6
	intensity $27
	note D_, 6
	intensity $b0
	octave 1
	note G_, 6
	notetype 2, $27
	note G_, 9
	intensity $b0
	octave 3
	note E_, 3
	notetype 1, $27
	note E_, 5
	endchannel

Music_BeastTriadDraw_Ch3:
	notetype 1, $00
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 15
	intensity $1b
	vibrato 0, $00
	tone 0
	octave 2
	note G_, 12
	note F#, 6
	rest 6
	note D#, 12
	note C#, 6
	rest 6
	note C_, 6
	rest 16
	rest 2
	octave 3
	note C_, 6
	endchannel

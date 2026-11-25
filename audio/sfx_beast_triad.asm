; Beast Triad card sounds. Short, so a quick run of captures stays readable.

Sfx_BeastTriadFlip:
; A soft paper swish as a captured card turns over.
	musicheader 1, 8, .Ch8
.Ch8:
	noise_note 1, 3, -2, $23
	noise_note 2, 6, 1, $22
	noise_note 3, 4, 2, $21
	endchannel

Sfx_BeastTriadCapture:
; You take a card: a bright rising major arpeggio with a sparkle on top.
	musicheader 2, 5, .Ch5
	musicheader 1, 8, .Ch8
.Ch5:
	dutycycle 2
	square_note 2, 12, 1, $705 ; C5
	square_note 2, 12, 1, $739 ; E5
	square_note 2, 13, 1, $759 ; G5
	square_note 14, 13, 3, $783 ; C6 rings out
	endchannel
.Ch8:
	noise_note 5, 0, 0, $00
	noise_note 1, 6, 1, $10
	noise_note 1, 4, 1, $00
	noise_note 6, 3, 2, $10
	endchannel

Sfx_BeastTriadCaptured:
; The foe takes your card: a falling minor figure over a dull thud.
	musicheader 2, 5, .Ch5
	musicheader 1, 8, .Ch8
.Ch5:
	dutycycle 1
	square_note 3, 12, 1, $6b2 ; G4
	square_note 3, 11, 1, $65b ; D#4
	square_note 16, 11, 4, $5ca ; A3, sagging
	endchannel
.Ch8:
	noise_note 2, 10, 2, $54
	noise_note 9, 6, 3, $66
	endchannel

Sfx_BeastTriadTake:
; Claiming a prize card.
	musicheader 2, 5, .Ch5
	musicheader 1, 6, .Ch6
.Ch5:
	dutycycle 2
	square_note 3, 11, 1, $759 ; G5
	square_note 3, 11, 1, $783 ; C6
	square_note 3, 12, 1, $79d ; E6
	square_note 18, 12, 4, $7a7 ; G6
	endchannel
.Ch6:
	dutycycle 1
	square_note 3, 8, 1, $705 ; C5
	square_note 3, 8, 1, $739 ; E5
	square_note 3, 9, 1, $759 ; G5
	square_note 18, 9, 4, $783 ; C6
	endchannel

Sfx_BeastTriadLose:
; A card leaves your collection.
	musicheader 1, 5, .Ch5
.Ch5:
	dutycycle 2
	square_note 4, 11, 2, $6b2 ; G4
	square_note 4, 10, 2, $672 ; E4
	square_note 4, 9, 2, $642 ; D4
	square_note 20, 9, 5, $5ac ; A3
	endchannel

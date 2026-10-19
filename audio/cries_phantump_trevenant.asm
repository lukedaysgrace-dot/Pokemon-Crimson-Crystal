; Phantump and Trevenant cries from pkmncoraldev/polishedcoral.
; Source: 2191e0eaad134b4cf006709be82f7362cf70248c/audio/cries_2.asm

Cry_Phantump:
	channel_count 3
	channel 5, Cry_Phantump_Ch5
	channel 6, Cry_Phantump_Ch6
	channel 8, Cry_Phantump_Ch8

Cry_Phantump_Ch5:
	duty_cycle_pattern 0, 0, 1, 1
	square_note 1, 14, -1, 1781
	pitch_sweep 7, 7
	square_note 7, 14, 0, 1781
	pitch_sweep 8, 8
	square_note 4, 15, 0, 1852
	square_note 3, 13, 0, 1857
	square_note 3, 15, 0, 1853
	square_note 2, 14, 0, 1852
	square_note 8, 12, 0, 1834
	square_note 3, 12, 0, 1831
	square_note 5, 12, 0, 1822
	square_note 2, 12, 0, 1820
	square_note 3, 12, 0, 1799
	square_note 5, 14, 5, 1805
	square_note 2, 11, 2, 1787
	square_note 9, 15, 3, 1798
	square_note 2, 10, 2, 1774
	square_note 10, 15, 1, 1783
	sound_ret

Cry_Phantump_Ch6:
	duty_cycle_pattern 3, 2, 1, 3
	square_note 1, 9, 1, 1716
	square_note 1, 3, 1, 1716
	square_note 1, 9, 1, 1717
	square_note 1, 3, 1, 1717
.loop1:
	square_note 1, 10, 1, 1718
	square_note 1, 3, 1, 1718
	sound_loop 16, .loop1
	square_note 1, 10, 1, 1718
	square_note 2, 3, 1, 1718
	square_note 1, 9, 1, 1717
	square_note 1, 3, 1, 1717
	sound_ret

Cry_Phantump_Ch8:
	noise_note 5, 7, -3, 35
	noise_note 6, 8, 4, 33
	noise_note 2, 0, 1, 33
	noise_note 3, 4, -1, 156
	noise_note 28, 4, 0, 156
	noise_note 15, 4, 6, 156
	sound_ret

Cry_Trevenant:
	channel_count 3
	channel 5, Cry_Trevenant_Ch5
	channel 6, Cry_Trevenant_Ch6
	channel 8, Cry_Trevenant_Ch8

Cry_Trevenant_Ch5:
	duty_cycle_pattern 1, 3, 2, 3
	square_note 4, 11, -1, 1282
	square_note 12, 13, 6, 1311
	square_note 9, 14, 3, 1334
	square_note 7, 13, 2, 1366
	square_note 7, 11, 2, 1411
	square_note 7, 12, 2, 1444
	square_note 7, 13, 2, 1488
	square_note 7, 14, 1, 1518
	square_note 5, 15, 1, 1546
	square_note 7, 14, 2, 1518
	square_note 5, 13, 2, 1488
	square_note 5, 11, 2, 1444
	square_note 5, 9, 2, 1366
	square_note 5, 7, 3, 1334
	square_note 3, 7, 1, 1311
	square_note 10, 5, 2, 1282
	sound_ret

Cry_Trevenant_Ch6:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 4, 13, -1, 282
	square_note 12, 14, 6, 311
	square_note 9, 14, 3, 334
	square_note 7, 15, 2, 366
	square_note 7, 15, 2, 411
	square_note 7, 15, 2, 444
	square_note 7, 14, 2, 488
	square_note 3, 10, 3, 1783
	square_note 14, 12, 2, 1789
	square_note 3, 11, 2, 1664
	square_note 5, 12, 2, 1676
	square_note 5, 9, 2, 1664
	square_note 5, 7, 2, 1656
	square_note 5, 7, 2, 1653
	square_note 10, 5, 2, 1643
	sound_ret

Cry_Trevenant_Ch8:
	noise_note 1, 8, -1, 77
.loop1:
	noise_note 1, 8, 1, 77
	noise_note 1, 5, 1, 77	
	sound_loop 3, .loop1
.loop2:
	noise_note 1, 10, 1, 77
	noise_note 1, 5, 1, 77
	sound_loop 5, .loop2
.loop3:
	noise_note 1, 8, 1, 77
	noise_note 1, 5, 1, 77	
	sound_loop 3, .loop3
	noise_note 7, 9, -7, 32
	noise_note 8, 10, 3, 32
	noise_note 8, 11, -7, 32
	noise_note 9, 12, 5, 32
	noise_note 2, 8, 1, 75
	noise_note 1, 5, 1, 75
	noise_note 2, 8, 1, 75
	noise_note 1, 4, 1, 75
	noise_note 2, 6, 1, 75
	noise_note 10, 4, 1, 75
	sound_ret

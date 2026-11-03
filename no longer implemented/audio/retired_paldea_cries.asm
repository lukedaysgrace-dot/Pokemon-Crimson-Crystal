; Paldea

Cry_Flittle:
	channel_count 3
	channel 5, Cry_Flittle_Ch5
	channel 6, Cry_Flittle_Ch6
	channel 8, Cry_Flittle_Ch8

Cry_Flittle_Ch5:
	duty_cycle_pattern 2, 2, 2, 2
.body:
	square_note 1, 14, 1, 1868
	square_note 1, 10, 1, 1606
	square_note 1, 12, 1, 1445
	square_note 1, 14, 1, 1722
	square_note 1, 14, 1, 1873
	square_note 1, 10, 1, 1620
	square_note 1, 12, 1, 1468
	square_note 1, 14, 1, 1734
	square_note 1, 14, 1, 1877
	square_note 1, 10, 1, 1642
	square_note 1, 12, 1, 1492
	square_note 1, 14, 1, 1740
	square_note 1, 14, 1, 1884
	square_note 1, 10, 1, 1668
	square_note 1, 12, 1, 1516
	square_note 1, 14, 1, 1755
	square_note 1, 14, 1, 1888
	square_note 1, 10, 1, 1682
	square_note 1, 12, 1, 1541
	square_note 1, 14, 1, 1764
	square_note 1, 14, 1, 1892
	square_note 1, 10, 1, 1705
	square_note 1, 12, 1, 1575
	square_note 2, 14, 2, 1772
	square_note 1, 13, 1, 1904
	square_note 1, 10, 1, 1722
	square_note 1, 12, 1, 1606
	square_note 1, 12, 1, 1909
	square_note 1, 0, 1, 1909
	square_note 1, 10, 1, 1909
	square_note 1, 0, 1, 1909
	square_note 1, 10, 1, 1920
	square_note 1, 0, 1, 1920
	square_note 1, 10, 1, 1920
	square_note 1, 0, 1, 1920
	square_note 1, 10, 1, 1936
	square_note 1, 0, 1, 1936
	square_note 1, 10, 1, 1936
	square_note 1, 0, 1, 1936
	square_note 1, 8, 1, 1944
	square_note 1, 0, 1, 1944
	square_note 2, 8, 1, 1946
	square_note 2, 0, 1, 1946
	square_note 2, 6, 1, 1971
	square_note 2, 0, 1, 1971
	square_note 2, 6, 1, 1969
	square_note 2, 0, 1, 1969
	square_note 12, 6, 1, 1983
	sound_ret

Cry_Flittle_Ch6:
	duty_cycle_pattern 2, 1, 2, 1
	square_note 1, 0, 1, 1808
	sound_jump Cry_Flittle_Ch5.body

Cry_Flittle_Ch8:
.loop1:
	noise_note 1, 8, 1, $1
	noise_note 1, 0, 1, $1
	sound_loop 7, .loop1
.loop2:
	noise_note 1, 5, 5, $1
	noise_note 1, 0, 1, $1
	sound_loop 3, .loop2
	noise_note 10, 4, 5, $1
	sound_ret

Cry_Espathra:
	channel_count 3
	channel 5, Cry_Espathra_Ch5
	channel 6, Cry_Espathra_Ch6
	channel 8, Cry_Espathra_Ch8

Cry_Espathra_Ch5:
	duty_cycle_pattern 1, 1, 1, 0
	pitch_sweep 7, 7
	square_note 5, 15, 7, 1628
	pitch_sweep 8, 8
	square_note 6, 14, 2, 1700
	square_note 3, 5, 1, 1704
	square_note 1, 14, 6, 1624
	square_note 2, 14, 6, 1636
	square_note 11, 13, 2, 1652
	square_note 3, 6, 1, 1654
	square_note 1, 14, 2, 1604
	square_note 2, 13, 2, 1616
	square_note 40, 12, 1, 1628
	sound_ret

Cry_Espathra_Ch6:
	duty_cycle_pattern 1, 1, 3, 0
	square_note 5, 0, -1, 1734
	square_note 6, 10, 3, 1734
	square_note 3, 7, 1, 1734
	square_note 3, 0, -1, 1712
	square_note 11, 10, 3, 1712
	square_note 3, 7, 1, 1712
	square_note 4, 0, 1, 1734
	square_note 4, 4, -1, 1752
	square_note 4, 13, 7, 1754
	square_note 5, 12, 6, 1753
	square_note 4, 13, 6, 1755
	square_note 1, 11, 3, 1776
	square_note 40, 12, 1, 1778
	sound_ret

Cry_Espathra_Ch8:
	noise_note 3, 3, -1, $5c
	noise_note 7, 4, 6, $4c
	noise_note 3, 3, 2, $5c
	noise_note 2, 6, -1, $4c
	noise_note 3, 7, -1, $4c
	noise_note 7, 10, 5, $6c
	noise_note 3, 11, 4, $7c
	noise_note 2, 10, 3, $6c
	noise_note 3, 3, -1, $5c
	noise_note 7, 10, 6, $4c
	noise_note 5, 8, 5, $5c
	noise_note 2, 0, -1, $5c
	noise_note 3, 2, -1, $5c
	noise_note 3, 11, -1, $5c
	noise_note 2, 14, 1, $6c
	noise_note 5, 3, -1, $5c
	noise_note 5, 2, -1, $5c
	noise_note 4, 1, -1, $5c
	noise_note 4, 1, -1, $5c
	noise_note 4, 0, -1, $5c
	noise_note 3, 0, -2, $4c
	noise_note 3, 0, -2, $4c
	noise_note 3, 0, -2, $4c
	noise_note 3, 0, -2, $3c
	noise_note 10, 2, 2, $4c
	sound_ret

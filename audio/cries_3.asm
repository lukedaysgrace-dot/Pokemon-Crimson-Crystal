; More cries imported from Polished Coral (classic note-based versions).
; Lives in its own bank because "Cries" and "Cries 2" are full.
; Cry_Espeon is Polished Coral's CRY_ESPEON slot (Crystal's original
; Tyrogue cry data), which this game had replaced with Aipom's cry.

Cry_Exeggutor:
	musicheader 3, 5, Cry_Exeggutor_Ch5
	musicheader 1, 6, Cry_Exeggutor_Ch6
	musicheader 1, 8, Cry_Exeggutor_Ch8

Cry_Exeggutor_Ch5:
Cry_Exeggutor_branch_f3a1a:
	sound_duty 0, 2, 0, 2
	sound __,  6, $f2, $0650
	sound __, 10, $d1, $0660
	sound __,  6, $e2, $0612
	sound __, 10, $c1, $0622
	sound __,  6, $f2, $0610
	sound __,  7, $d1, $0620
	loopchannel 2, Cry_Exeggutor_branch_f3a1a
	endchannel

Cry_Exeggutor_Ch6:
	sound_duty 0, 0, 0, 1
	sound __,  5, $8, 0
	sound __,  6, $f2, $0651
	sound __, 10, $d1, $0661
	sound __,  6, $e2, $0614
	sound __,  9, $c1, $0624
	sound __,  6, $f2, $0611
	sound __, 13, $d1, $0621
	sound __,  6, $e2, $0614
	sound __,  9, $c1, $0624
	sound __,  6, $f2, $0611
	sound __,  5, $d1, $0621
	endchannel

Cry_Exeggutor_Ch8:
	noise __,  7, $d2, $1c
	noise __, 10, $b1, $2c
	noise __,  9, $c2, $2c
	noise __, 10, $b1, $3c
	noise __,  7, $c2, $2c
	noise __, 10, $a2, $3c
	noise __,  8, $c2, $2c
	noise __,  6, $a1, $3c
	noise __, 10, $c2, $2c
	noise __,  5, $a1, $3c
	endchannel

Cry_Espeon:
	musicheader 3, 5, Cry_Espeon_Ch5
	musicheader 1, 6, Cry_Espeon_Ch6
	musicheader 1, 8, Cry_Espeon_Ch8

Cry_Espeon_Ch5:
	sound_duty 2, 0, 1, 3
	sound __,  4, $f8, $06b0
	sound __,  2, $f8, $06a5
	sound __,  2, $f8, $069d
	sound __,  8, $f1, $068a
	sound __,  4, $f8, $0736
	sound __,  4, $f8, $0720
	sound C_,  5, $f2, $070e
	endchannel

Cry_Espeon_Ch6:
	sound_duty 3, 1, 2, 0
Cry_Espeon_branch_f3443:
	sound __,  2, $f1, $07b4
	loopchannel 8, Cry_Espeon_branch_f3443
Cry_Espeon_branch_f344b:
	sound __,  2, $c1, $0790
	loopchannel 3, Cry_Espeon_branch_f344b
Cry_Espeon_branch_f3453:
	sound __,  2, $b1, $078d
	loopchannel 2, Cry_Espeon_branch_f3453
	sound C_,  1, $92, $0795
	endchannel

Cry_Espeon_Ch8:
Cry_Espeon_branch_f3460:
	noise __,  1, $f1, $28
	loopchannel 4, Cry_Espeon_branch_f3460
	noise __,  1, $91, $49
	noise __,  2, $a8, $4a
	noise __,  1, $e1, $4b
	noise __,  6, $d2, $4f
	noise __,  4, $c2, $4e
	noise __,  4, $b2, $4d
	noise C_,  5, $a3, $4c
	endchannel

Cry_Leafeon:
	channel_count 3
	channel 5, Cry_Leafeon_Ch5
	channel 6, Cry_Leafeon_Ch6
	channel 8, Cry_Leafeon_Ch8

Cry_Leafeon_Ch5:
	duty_cycle_pattern 1, 1, 1, 0
	square_note 2, 13, -5, 1600
	square_note 1, 14, 4, 1726
	square_note 3, 15, 7, 1894
	square_note 1, 14, 0, 1890
	square_note 1, 13, 0, 1886
	square_note 1, 13, 0, 1882
	square_note 1, 12, 0, 1877
	square_note 1, 14, 0, 1877
	square_note 1, 9, 0, 1873
	square_note 1, 7, 0, 1869
	square_note 2, 5, 2, 1862
	sound_ret

Cry_Leafeon_Ch6:
	duty_cycle_pattern 0, 0, 1, 0
	square_note 2, 7, -8, 1798
	square_note 1, 6, 4, 1798
	square_note 2, 7, 4, 1858
	square_note 16, 8, 5, 1860
	sound_ret

Cry_Leafeon_Ch8:
.loop1:
	noise_note 4, 5, 5, 145
	noise_note 1, 3, 3, 214
	noise_note 3, 4, 3, 213
	noise_note 6, 3, 7, 212
	sound_loop 2, .loop1
	noise_note 4, 3, 5, 145
	noise_note 2, 4, 3, 214
	noise_note 4, 3, 5, 212
	sound_ret

Cry_Glaceon:
	channel_count 2
	channel 5, Cry_Glaceon_Ch5
	channel 6, Cry_Glaceon_Ch6

Cry_Glaceon_Ch5:
	duty_cycle_pattern 2, 2, 2, 1
	square_note 3, 12, -3, 1856
	square_note 2, 14, 3, 1860
	square_note 5, 13, -3, 1833
	square_note 1, 14, -3, 1856
	square_note 1, 15, 0, 1860
	square_note 1, 13, 0, 1859
	square_note 1, 12, 0, 1864
	square_note 1, 9, 0, 1888
	square_note 1, 10, 0, 1920
	square_note 3, 12, 4, 1931
	pitch_sweep 3, -7
	square_note 4, 8, 6, 1931
	pitch_sweep 8, 8
	square_note 5, 5, 3, 1823
	sound_ret

Cry_Glaceon_Ch6:
	duty_cycle_pattern 0, 0, 2, 2
	square_note 2, 13, 2, 1924
	square_note 2, 14, 7, 1966
	square_note 3, 13, 7, 1958
	square_note 1, 0, 7, 1930
	square_note 5, 15, 3, 1930
	square_note 1, 0, 7, 1930
	square_note 1, 13, 7, 1924
	square_note 1, 14, 7, 1940
	square_note 2, 15, 2, 1958
	square_note 1, 15, 3, 1957
	square_note 7, 14, 2, 1946
	sound_ret

Cry_Sylveon:
	channel_count 3
	channel 5, Cry_Sylveon_Ch5
	channel 6, Cry_Sylveon_Ch6
	channel 8, Cry_Sylveon_Ch8

Cry_Sylveon_Ch5:
	duty_cycle_pattern 0, 0, 0, 0
	pitch_sweep 6, 7
	square_note 1, 14, -3, 1920
	pitch_sweep 8, 8
	square_note 2, 15, 5, 2000
	pitch_sweep 3, -7
	square_note 5, 12, 4, 2000
	pitch_sweep 8, 8
	square_note 1, 10, 0, 1950
	square_note 1, 13, -1, 1953
	square_note 1, 14, 0, 1959
	square_note 1, 14, 0, 1968
	square_note 1, 14, 0, 1975
	square_note 1, 14, 0, 1981
	square_note 1, 14, 0, 1988
	square_note 7, 12, 1, 1991
	sound_ret

Cry_Sylveon_Ch6:
	duty_cycle_pattern 0, 1, 1, 0
	square_note 2, 11, -3, 1933
	square_note 9, 13, 5, 2000
	square_note 15, 7, 4, 1951
	sound_ret

Cry_Sylveon_Ch8:
	noise_note 12, 9, 0, 24
	noise_note 12, 0, -5, 17
	noise_note 16, 4, 0, 17
	noise_note 16, 4, 0, 18
	noise_note 8, 4, 0, 19
	noise_note 26, 3, 7, 19
	sound_ret

Cry_PorygonZ:
	channel_count 3
	channel 5, Cry_PorygonZ_Ch5
	channel 6, Cry_PorygonZ_Ch6
	channel 8, Cry_PorygonZ_Ch8

Cry_PorygonZ_Ch5:
	duty_cycle_pattern 3, 1, 3, 3
	square_note 18, 15, 5, 1992
	square_note 2, 13, 5, 1935
	square_note 2, 13, 5, 1939
	square_note 2, 14, 5, 1943
	square_note 2, 14, 5, 1947
	square_note 2, 14, 5, 1952
	square_note 5, 15, 1, 1993
	square_note 30, 10, 6, 2005
	sound_ret

Cry_PorygonZ_Ch6:
	duty_cycle_pattern 1, 0, 0, 3
	square_note 6, 0, 1, 1340
	square_note 4, 11, 5, 1340
	square_note 10, 13, 2, 1600
	square_note 8, 13, 2, 1650
	square_note 3, 9, 3, 1340
	square_note 4, 14, 2, 1834
	square_note 20, 13, 3, 1873
	sound_ret

Cry_PorygonZ_Ch8:
	noise_note 10, 10, -1, 41
	noise_note 8, 10, 2, 46
	noise_note 10, 10, 2, 44
	noise_note 8, 10, 2, 46
	noise_note 12, 10, 2, 42
	noise_note 2, 10, 2, 46
	noise_note 28, 11, 4, 37
	noise_note 11, 11, 2, 14
	noise_note 11, 10, 2, 13
	noise_note 12, 10, 2, 13
	noise_note 3, 11, -1, 13
	noise_note 2, 8, 1, 13
	noise_note 5, 10, 2, 13
	noise_note 10, 11, 1, 13
	sound_ret

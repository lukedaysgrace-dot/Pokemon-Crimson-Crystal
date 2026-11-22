; Zangoose and Seviper cries.
; Authored for Crimson Crystal by tracing the official cries frame by frame
; (1/60 s): pitch contour, loudness, hiss colour and voice formants.

Cry_Zangoose:
	channel_count 3
	channel 5, Cry_Zangoose_Ch5
	channel 6, Cry_Zangoose_Ch6
	channel 8, Cry_Zangoose_Ch8

Cry_Zangoose_Ch5:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 2, 5, -1, 1668
	square_note 3, 8, 0, 1696
	square_note 2, 8, 0, 1710
	square_note 4, 9, 2, 1699
	square_note 2, 6, 0, 1724
	square_note 2, 5, 0, 1743
	square_note 2, 4, 1, 1760
	square_note 3, 3, 1, 1781
	sound_ret

Cry_Zangoose_Ch6:
	duty_cycle_pattern 2, 2, 2, 2
	square_note 3, 2, -1, 1947
	square_note 4, 4, 0, 1943
	square_note 4, 4, 0, 1910
	square_note 2, 3, 0, 1961
	square_note 2, 3, 0, 1975
	square_note 2, 2, 1, 1988
	square_note 3, 2, 1, 1999
	sound_ret

Cry_Zangoose_Ch8:
	noise_note 1, 9, -1, 54
	noise_note 1, 14, 0, 53
	noise_note 0, 12, 0, 67
	noise_note 1, 14, 0, 54
	noise_note 1, 13, 0, 53
	noise_note 2, 15, 0, 68
	noise_note 1, 14, 0, 67
	noise_note 0, 9, 0, 53
	noise_note 1, 11, 0, 52
	noise_note 1, 9, 0, 53
	noise_note 2, 8, 0, 52
	noise_note 5, 7, 1, 51
	sound_ret

Cry_Seviper:
	channel_count 2
	channel 5, Cry_Seviper_Ch5
	channel 8, Cry_Seviper_Ch8

Cry_Seviper_Ch5:
	duty_cycle_pattern 0, 0, 0, 0
	square_note 0, 1, 0, 1888
	square_note 0, 2, 0, 1914
	square_note 0, 0, -7, 1914
	square_note 0, 5, 0, 1914
	square_note 0, 2, 0, 1888
	square_note 1, 0, -7, 1888
	square_note 0, 3, 0, 1914
	square_note 0, 0, -7, 1914
	square_note 0, 2, 0, 1914
	square_note 0, 3, 0, 1888
	square_note 0, 0, -7, 1888
	square_note 0, 4, 0, 1888
	square_note 0, 3, 0, 1914
	square_note 0, 2, 0, 1888
	square_note 0, 1, 0, 1914
	square_note 3, 0, -7, 1914
	square_note 0, 1, 0, 1888
	square_note 0, 0, -7, 1888
	square_note 0, 1, 0, 1888
	square_note 10, 0, -7, 1888
	sound_ret

Cry_Seviper_Ch8:
	noise_note 0, 11, 0, 37
	noise_note 0, 12, 0, 36
	noise_note 0, 10, 0, 37
	noise_note 0, 15, 0, 37
	noise_note 0, 12, 0, 37
	noise_note 0, 9, 0, 36
	noise_note 0, 4, 0, 37
	noise_note 0, 13, 0, 36
	noise_note 0, 9, 0, 37
	noise_note 0, 12, 0, 36
	noise_note 0, 13, 0, 37
	noise_note 0, 6, 0, 37
	noise_note 0, 14, 0, 51
	noise_note 0, 13, 0, 37
	noise_note 0, 12, 0, 51
	noise_note 0, 11, 0, 36
	noise_note 0, 5, 0, 36
	noise_note 0, 4, 0, 50
	noise_note 0, 4, 0, 36
	noise_note 0, 9, 0, 50
	noise_note 0, 11, 0, 37
	noise_note 0, 10, 0, 36
	noise_note 0, 11, 0, 37
	noise_note 0, 5, 0, 50
	noise_note 0, 10, 0, 36
	noise_note 0, 10, 0, 50
	noise_note 0, 9, 0, 36
	noise_note 0, 3, 0, 50
	noise_note 0, 10, 0, 36
	noise_note 0, 10, 0, 50
	noise_note 0, 9, 0, 36
	noise_note 0, 6, 0, 50
	noise_note 0, 3, 0, 36
	noise_note 0, 0, 0, 0
	sound_ret

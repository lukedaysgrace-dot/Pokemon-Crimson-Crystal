; Authored Game Boy adaptations: two short nasal grunts and a deeper, sandy roar.
; These are original PSG arrangements, not exact sampled main-series cries.

Cry_Hippopotas:
	channel_count 3
	channel 5, Cry_Hippopotas_Ch5
	channel 6, Cry_Hippopotas_Ch6
	channel 8, Cry_Hippopotas_Ch8

Cry_Hippopotas_Ch5:
	duty_cycle_pattern 0, 1, 2, 1
	square_note 4, 13, 1, 1450
	square_note 5, 15, 2, 1560
	square_note 5, 12, 3, 1490
	square_note 2, 0, 0, 1490
	square_note 4, 14, 1, 1490
	square_note 6, 13, 2, 1580
	square_note 8, 10, 3, 1380
	sound_ret

Cry_Hippopotas_Ch6:
	duty_cycle_pattern 2, 3, 2, 3
	square_note 4, 9, 1, 1060
	square_note 5, 11, 2, 1190
	square_note 5, 8, 3, 1100
	square_note 2, 0, 0, 1100
	square_note 4, 10, 1, 1100
	square_note 6, 9, 2, 1220
	square_note 8, 7, 3, 980
	sound_ret

Cry_Hippopotas_Ch8:
	noise_note 4, 6, 2, 69
	noise_note 5, 8, 3, 68
	noise_note 5, 5, 2, 70
	noise_note 2, 0, 0, 70
	noise_note 4, 7, 2, 69
	noise_note 6, 8, 3, 68
	noise_note 8, 5, 3, 71
	sound_ret

Cry_Hippowdon:
	channel_count 3
	channel 5, Cry_Hippowdon_Ch5
	channel 6, Cry_Hippowdon_Ch6
	channel 8, Cry_Hippowdon_Ch8

Cry_Hippowdon_Ch5:
	duty_cycle_pattern 2, 3, 0, 3
	square_note 5, 13, 1, 1100
	square_note 6, 15, 1, 1260
	square_note 6, 15, 2, 1320
	square_note 7, 14, 2, 1220
	square_note 8, 13, 2, 1130
	square_note 9, 11, 3, 980
	square_note 12, 8, 4, 820
	sound_ret

Cry_Hippowdon_Ch6:
	duty_cycle_pattern 3, 2, 3, 2
	square_note 5, 10, 1, 450
	square_note 6, 12, 1, 620
	square_note 6, 12, 2, 680
	square_note 7, 11, 2, 580
	square_note 8, 10, 2, 490
	square_note 9, 8, 3, 340
	square_note 12, 6, 4, 180
	sound_ret

Cry_Hippowdon_Ch8:
	noise_note 5, 9, 1, 85
	noise_note 6, 12, 2, 84
	noise_note 6, 13, 2, 83
	noise_note 7, 11, 2, 84
	noise_note 8, 10, 3, 85
	noise_note 9, 8, 3, 86
	noise_note 12, 5, 4, 87
	sound_ret

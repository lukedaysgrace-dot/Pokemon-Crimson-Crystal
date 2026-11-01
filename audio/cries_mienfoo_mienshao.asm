; Mienfoo and Mienshao cries from pkmncoraldev/polishedcoral.
; Source: 2191e0eaad134b4cf006709be82f7362cf70248c/audio/cries_2.asm

Cry_Mienfoo:
        channel_count 3
        channel 5, Cry_Mienfoo_Ch5
	channel 6, Cry_Mienfoo_Ch6
	channel 8, Cry_Mienfoo_Ch8

Cry_Mienfoo_Ch5:
	duty_cycle_pattern 1, 0, 0, 0
	square_note 3, 15, -1, 1697
	square_note 3, 11, 1, 1711
	square_note 8, 13, -1, 1652
	square_note 3, 13, 3, 1650
	square_note 3, 12, 3, 1647
	square_note 8, 11, -1, 1657
	square_note 3, 10, 3, 1654
	square_note 3, 9, 3, 1652
	square_note 10, 7, -4, 1687
	square_note 2, 5, 1, 1687
	square_note 2, 5, -2, 1738
	square_note 14, 4, 5, 1739
	sound_ret

Cry_Mienfoo_Ch6:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 3, 11, -1, 1697
	square_note 3, 8, 1, 1711
	square_note 14, 9, 2, 1395
	square_note 16, 4, 4, 1392
	sound_ret

Cry_Mienfoo_Ch8:
	noise_note 10, 13, 4, 189
	noise_note 10, 14, 1, 137
	sound_ret

Cry_Mienshao:
        channel_count 3
        channel 5, Cry_Mienshao_Ch5
	channel 6, Cry_Mienshao_Ch6
	channel 8, Cry_Mienshao_Ch8

Cry_Mienshao_Ch5:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 5, 0, 1, 1697
	square_note 3, 13, -1, 1764
	square_note 10, 9, 0, 1764
	square_note 2, 9, 0, 1763
	square_note 2, 8, 0, 1762
	square_note 2, 8, 0, 1761
	square_note 2, 7, 0, 1760
	square_note 2, 7, 0, 1759
	square_note 2, 6, 0, 1758
	square_note 1, 6, 0, 1757
	square_note 1, 6, 0, 1756
	square_note 1, 5, 0, 1755
	square_note 1, 5, 0, 1753
	square_note 1, 5, 0, 1751
	square_note 1, 4, 0, 1750
	square_note 2, 3, 0, 1748
	sound_ret

Cry_Mienshao_Ch6:
	duty_cycle_pattern 0, 0, 1, 0
	square_note 1, 15, -1, 1647
	square_note 3, 15, -1, 1658
	square_note 1, 0, -3, 1658
	square_note 1, 15, 0, 1657
	duty_cycle_pattern 0, 0, 0, 0
	square_note 3, 6, -1, 1764
	square_note 10, 5, 0, 1764
	square_note 2, 5, 0, 1763
	square_note 2, 5, 0, 1762
	square_note 2, 4, 0, 1761
	square_note 2, 4, 0, 1760
	square_note 2, 4, 0, 1759
	square_note 2, 3, 0, 1758
	square_note 1, 3, 0, 1757
	square_note 1, 3, 0, 1756
	square_note 1, 2, 0, 1755
	square_note 1, 2, 0, 1753
	square_note 1, 2, 0, 1751
	square_note 1, 2, 0, 1750
	square_note 4, 1, 0, 1748
	square_note 1, 1, 1, 1748
	sound_ret

Cry_Mienshao_Ch8:
	noise_note 10, 9, 2, 173
	sound_ret

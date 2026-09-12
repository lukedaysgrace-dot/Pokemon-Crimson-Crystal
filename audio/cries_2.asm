; Cries imported from Polished Coral (audio/cries_2.asm).
; New cries for species past the original 251; lives in its own bank
; because the "Cries" bank is nearly full.

; === Hoenn (gen 3) ===

Cry_Aron:
	channel_count 3
	channel 5, Cry_Aron_Ch5
	channel 6, Cry_Aron_Ch6
	channel 8, Cry_Aron_Ch8

Cry_Aron_Ch5:
	duty_cycle_pattern 0, 1, 2, 3
	square_note 8, 15, 1, 1892
	square_note 8, 14, 1, 1892
	square_note 8, 14, 1, 1888
	square_note 16, 14, 0, 1883
	square_note 3, 14, 7, 1881
	square_note 8, 0, 1, 1881
	sound_ret

Cry_Aron_Ch6:
	duty_cycle_pattern 2, 2, 2, 2
	square_note 16, 12, 3, 1890
	square_note 8, 12, 1, 1886
	square_note 16, 11, 0, 1881
	square_note 3, 8, 7, 1885
	square_note 8, 0, 1, 1885
	sound_ret

Cry_Aron_Ch8:
	noise_note 10, 10, 0, 10
	noise_note 16, 8, 2, 48
	sound_ret

Cry_Lairon:
	channel_count 3
	channel 5, Cry_Lairon_Ch5
	channel 6, Cry_Lairon_Ch6
	channel 8, Cry_Lairon_Ch8

Cry_Lairon_Ch5:
	duty_cycle_pattern 1, 1, 1, 0
	square_note 16, 11, 0, 1890
	square_note 5, 10, 1, 1890
	square_note 12, 11, 1, 1865
	square_note 14, 12, 2, 1894
	square_note 5, 11, 1, 1894
	square_note 10, 12, 1, 1852
	square_note 10, 11, 1, 1847
	square_note 8, 10, 1, 1843
	square_note 8, 9, 1, 1843
	square_note 8, 9, 1, 1840
	square_note 16, 8, 1, 1837
	sound_ret

Cry_Lairon_Ch6:
	duty_cycle_pattern 0, 0, 1, 0
	square_note 16, 15, 0, 1892
	square_note 5, 14, 1, 1892
	square_note 12, 14, 1, 1868
	square_note 14, 15, 2, 1896
	square_note 5, 14, 1, 1896
	square_note 10, 15, 1, 1855
	square_note 10, 14, 1, 1850
	square_note 8, 13, 1, 1845
	square_note 8, 12, 1, 1845
	square_note 8, 12, 1, 1842
	square_note 16, 12, 1, 1838
	sound_ret

Cry_Lairon_Ch8:
	noise_note 10, 15, 0, 54
	noise_note 8, 13, 4, 55
	noise_note 10, 12, 0, 54
	noise_note 15, 9, 0, 56
	noise_note 8, 9, 1, 56
	sound_ret

Cry_Aggron:
	channel_count 3
	channel 5, Cry_Aggron_Ch5
	channel 6, Cry_Aggron_Ch6
	channel 8, Cry_Aggron_Ch8

Cry_Aggron_Ch5:
	duty_cycle_pattern 0, 0, 1, 0
	square_note 14, 15, 0, 1877
	square_note 3, 14, 5, 1849
	square_note 3, 14, 5, 1845
	square_note 16, 15, 0, 1877
	square_note 6, 15, 5, 1879
	square_note 16, 15, 2, 1877
	sound_ret

Cry_Aggron_Ch6:
	duty_cycle_pattern 1, 1, 1, 0
	square_note 7, 10, 0, 1851
	square_note 7, 8, 0, 1849
	square_note 3, 8, 5, 1822
	square_note 3, 9, 5, 1818
	square_note 16, 9, 0, 1851
	square_note 4, 8, 5, 1854
	square_note 16, 7, 5, 1851
	square_note 5, 9, 1, 1834
	sound_ret

Cry_Aggron_Ch8:
	noise_note 10, 12, 0, 55
	noise_note 8, 11, 4, 54
	noise_note 15, 12, 0, 55
	noise_note 15, 11, 0, 55
	noise_note 15, 10, 3, 71
	sound_ret

Cry_Numel:
        channel_count 3
        channel 5, Cry_Numel_Ch5
	channel 6, Cry_Numel_Ch6
	channel 8, Cry_Numel_Ch8

Cry_Numel_Ch5:
	duty_cycle_pattern 0, 1, 3, 0
	square_note 16, 0, -1, 1503
	square_note 16, 0, -1, 1300
	square_note 16, 0, -1, 1500
	square_note 4, 0, 1, 1500
	sound_ret

Cry_Numel_Ch6:
	duty_cycle_pattern 0, 1, 3, 0
	square_note 16, 0, -1, 1813
	square_note 16, 0, -1, 1730
	square_note 16, 0, -1, 1809
	square_note 4, 0, 1, 1808
	sound_ret

Cry_Numel_Ch8:
	noise_note 8, 5, -1, $79
	noise_note 8, 5, -1, $46
	noise_note 8, 5, -1, $79
	noise_note 4, 0, 1, $79
	sound_ret

Cry_Camerupt:
        channel_count 3
        channel 5, Cry_Camerupt_Ch5
	channel 6, Cry_Camerupt_Ch6
	channel 8, Cry_Camerupt_Ch8

Cry_Camerupt_Ch5:
	duty_cycle_pattern 0, 2, 0, 2
	square_note 4, 0, -1, 1429
	square_note 12, 4, 0, 1429
	square_note 6, 4, 4, 1426
	square_note 6, 0, -1, 1429
	square_note 4, 6, 3, 1421
	sound_ret

Cry_Camerupt_Ch6:
	duty_cycle_pattern 1, 2, 0, 0
	square_note 4, 0, -1, 1118
	square_note 12, 4, 0, 1112
	square_note 6, 4, 4, 1123
	square_note 5, 0, -1, 1048
	square_note 3, 6, 3, 1032
	sound_ret

Cry_Camerupt_Ch8:
	noise_note 16, 9, -1, $46
	noise_note 2, 10, 4, $46
	noise_note 12, 10, 4, $45
	noise_note 16, 9, -1, $54
	noise_note 2, 8, 4, $54
	noise_note 3, 12, 0, $46
	noise_note 8, 9, 1, $45
	sound_ret

Cry_Swablu:
        channel_count 2
        channel 5, Cry_Swablu_Ch5
	channel 6, Cry_Swablu_Ch6

Cry_Swablu_Ch5:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 5, 15, 1, 1723
	;square_note 1, 0, 1, 1723
	square_note 5, 15, 1, 1723
	;square_note 1, 0, 1, 1723
	square_note 5, 15, 1, 1723
	;square_note 1, 0, 1, 1723
	square_note 4, 15, 1, 1724
	square_note 10, 15, 0, 1745
	square_note 1, 0, 1, 1745
	sound_ret

Cry_Swablu_Ch6:
	duty_cycle_pattern 1, 1, 1, 2
	square_note 5, 15, 1, 1724
	square_note 5, 15, 1, 1724
	square_note 5, 15, 1, 1724
	square_note 4, 15, 1, 1725
	square_note 10, 15, 0, 1746
	square_note 1, 0, 1, 1746
	sound_ret

Cry_Altaria:
        channel_count 3
        channel 5, Cry_Altaria_Ch5
	channel 6, Cry_Altaria_Ch6
	channel 8, Cry_Altaria_Ch8

Cry_Altaria_Ch5:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 8, 15, 1, 1743
	square_note 4, 14, 1, 1741
	square_note 4, 14, 1, 1738
	square_note 4, 14, 1, 1736
	square_note 2, 13, 1, 1734
	square_note 3, 10, 1, 1731
	sound_ret

Cry_Altaria_Ch6:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 8, 15, 1, 1744
	square_note 4, 14, 1, 1742
	square_note 4, 14, 1, 1739
	square_note 4, 14, 1, 1737
	square_note 2, 13, 1, 1735
	square_note 3, 10, 1, 1732
	sound_ret

Cry_Altaria_Ch8:
	noise_note 11, 15, 3, 82
	noise_note 16, 10, 2, 44
	sound_ret

Cry_Snorunt:
        channel_count 3
        channel 5, Cry_Snorunt_Ch5
	channel 6, Cry_Snorunt_Ch6
	channel 8, Cry_Snorunt_Ch8

Cry_Snorunt_Ch5:
	duty_cycle_pattern 1, 0, 1, 1
	;pitch_offset 128
	pitch_offset 213
	sound_call Cry_Snorunt_Ch6_branch
	square_note 4, 10, 1, 1712
	square_note 4, 9, -1, 1721
	square_note 6, 6, 1, 1706
	sound_ret

Cry_Snorunt_Ch6:
	duty_cycle_pattern 0, 1, 3, 1
	sound_call Cry_Snorunt_Ch6_branch
	square_note 4, 10, 1, 1706
	square_note 4, 9, -1, 1721
	square_note 6, 6, 1, 1688
	sound_ret

Cry_Snorunt_Ch6_branch:
	square_note 2, 11, -1, 1752
	square_note 4, 12, 1, 1747
	square_note 4, 10, -1, 1752
	square_note 4, 11, 1, 1732
	square_note 4, 10, -1, 1747
	square_note 4, 12, 1, 1721
	square_note 4, 11, -1, 1732
	sound_ret

Cry_Snorunt_Ch8:
.loop1:
	noise_note 1, 15, 2, 17
	noise_note 2, 15, 2, 240
	noise_note 2, 15, 2, 22
 	sound_loop 2, .loop1
	noise_note 2, 15, 2, 17
	noise_note 2, 15, 2, 240
	noise_note 4, 11, 5, 22
	noise_note 16, 9, 2, 21
	sound_ret

; === Sinnoh (gen 4) ===

Cry_Drifloon:
        channel_count 2
        channel 5, Cry_Drifloon_Ch5
        channel 6, Cry_Drifloon_Ch6

Cry_Drifloon_Ch5:
	duty_cycle_pattern 2, 2, 2, 2
	square_note 3, 15, 3, 1777
	square_note 9, 15, 2, 1706
	square_note 2, 8, 3, 1935
	square_note 8, 9, 2, 1946
	square_note 2, 0, 1, 1946
	duty_cycle_pattern 0, 0, 0, 0
	pitch_sweep 6, -7
	square_note 26, 6, 0, 1945
	pitch_sweep 8, 8
	sound_ret

Cry_Drifloon_Ch6:
	duty_cycle_pattern 1, 1, 1, 0
	square_note 3, 12, 3, 1792
	square_note 9, 10, 2, 1718
	square_note 3, 15, 3, 1893
	square_note 7, 15, 2, 1913
	square_note 5, 0, 1, 1913
	square_note 1, 8, 1, 1945
	square_note 2, 13, 1, 1946
	square_note 2, 8, 1, 1946
	square_note 3, 0, 1, 1946
	square_note 2, 11, 1, 1945
	square_note 3, 9, 1, 1945
	square_note 2, 0, 1, 1946
	square_note 3, 12, 1, 1984
	square_note 2, 10, 1, 1980
	sound_ret

Cry_Drifblim:
        channel_count 3
        channel 5, Cry_Drifblim_Ch5
        channel 6, Cry_Drifblim_Ch6
	channel 8, Cry_Drifblim_Ch8

Cry_Drifblim_Ch5:
	duty_cycle_pattern 1, 1, 1, 2
	square_note 2, 12, 3, 1243
	square_note 3, 13, 3, 1257
	square_note 7, 14, 1, 1268
	square_note 2, 12, 3, 1084
	square_note 3, 13, 3, 1093
	square_note 7, 14, 3, 1106
	square_note 2, 11, 3, 733
	square_note 3, 11, 3, 755
	square_note 5, 13, 3, 777
	square_note 4, 15, 3, 1345
	square_note 4, 14, 1, 1289
	square_note 2, 12, 3, 969
	square_note 2, 13, 3, 986
	square_note 5, 14, 3, 1004
	square_note 8, 15, 3, 1400
	square_note 2, 4, 3, 1193
	square_note 2, 5, 3, 1209
	square_note 4, 5, 1, 1222
	square_note 2, 4, 3, 1478
	square_note 3, 4, 2, 1487
	square_note 1, 4, 1, 1494
	sound_ret

Cry_Drifblim_Ch6:
	duty_cycle_pattern 0, 0, 0, 0
	square_note 12, 14, 0, 678
	square_note 4, 10, 0, 662
	square_note 8, 7, 1, 643
	square_note 12, 14, 0, 1091
	square_note 4, 10, 0, 1062
	square_note 8, 7, 3, 1023
	square_note 8, 14, 2, 1309
	square_note 4, 9, 2, 1288
	square_note 8, 7, 1, 1268
	sound_ret

Cry_Drifblim_Ch8:
	noise_note 12, 12, 6, $5c
	noise_note 12, 11, 6, $6c
	noise_note 12, 12, 6, $5c
	noise_note 12, 11, 6, $6c
	noise_note 8, 11, 6, $5c
	noise_note 8, 10, 6, $6c
	noise_note 3, 10, 1, 11
	noise_note 3, 10, 2, 15
	noise_note 16, 9, 2, 28
	sound_ret

Cry_Buneary:
        channel_count 2
        channel 5, Cry_Buneary_Ch5
        channel 6, Cry_Buneary_Ch6

Cry_Buneary_Ch5:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 4, 11, -1, 1876
	square_note 2, 14, 2, 1900
	square_note 3, 15, 1, 1954
	square_note 2, 11, -1, 1867
	square_note 2, 14, 2, 1888
	square_note 3, 15, 1, 1943
	square_note 2, 11, -1, 1848
	square_note 2, 14, 2, 1876
	square_note 3, 15, 1, 1939
	square_note 2, 13, 2, 1832
	square_note 2, 14, 2, 1865
	square_note 5, 15, 3, 1931
	square_note 3, 11, 3, 1808
	square_note 3, 12, 3, 1812
	square_note 1, 12, 3, 1824
	square_note 1, 13, 3, 1877
	square_note 1, 13, 3, 1896
	square_note 1, 13, 3, 1917
	square_note 1, 14, 3, 1932
	square_note 1, 15, 3, 1941
	square_note 9, 15, 3, 1948
	square_note 3, 13, 2, 1937
	square_note 2, 13, 2, 1913
	square_note 1, 11, 2, 1888
	square_note 1, 5, 2, 1856
	square_note 1, 5, 2, 1846
	square_note 1, 3, 2, 1835
	square_note 1, 2, 2, 1827
	sound_ret

Cry_Buneary_Ch6:
	duty_cycle_pattern 3, 0, 1, 3
	square_note 4, 5, -1, 1874
	square_note 2, 6, 2, 1898
	square_note 3, 7, 1, 1953
	square_note 2, 5, -1, 1865
	square_note 2, 6, 2, 1886
	square_note 3, 7, 1, 1942
	square_note 2, 5, -1, 1846
	square_note 2, 6, 2, 1874
	square_note 3, 7, 1, 1938
	square_note 2, 5, 2, 1830
	square_note 2, 6, 2, 1863
	square_note 5, 7, 3, 1930
	square_note 3, 4, 3, 1806
	square_note 3, 4, 3, 1810
	square_note 1, 4, 3, 1821
	square_note 1, 5, 3, 1873
	square_note 1, 5, 3, 1893
	square_note 1, 5, 3, 1915
	square_note 1, 6, 3, 1930
	square_note 1, 6, 3, 1939
	square_note 9, 7, 3, 1946
	square_note 3, 5, 2, 1935
	square_note 2, 5, 2, 1911
	square_note 1, 5, 2, 1885
	square_note 1, 2, 2, 1853
	square_note 1, 2, 2, 1843
	square_note 1, 1, 2, 1832
	square_note 1, 1, 1, 1824
	sound_ret

Cry_Lopunny:
        channel_count 2
        channel 5, Cry_Lopunny_Ch5
        channel 6, Cry_Lopunny_Ch6

Cry_Lopunny_Ch5:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 2, 11, -1, 1803
	square_note 2, 11, 2, 1792
	square_note 1, 10, 2, 1787
	square_note 2, 12, 2, 1791
	square_note 2, 13, 2, 1799
	square_note 4, 13, 2, 1861
	square_note 3, 13, 2, 1881
	square_note 3, 14, 2, 1966
	square_note 5, 15, 2, 1973
	square_note 4, 14, 2, 1969
	square_note 4, 13, 2, 1966
	square_note 3, 13, 2, 1951
	square_note 3, 11, 1, 1944
	square_note 4, 11, 2, 1803
	square_note 2, 13, -1, 1968
	square_note 2, 13, 2, 1974
	square_note 1, 13, 1, 1982
	square_note 1, 0, 1, 1982
	square_note 2, 12, -1, 1853
	duty_cycle_pattern 2, 1, 1, 1
	pitch_sweep 7, 7
	square_note 5, 10, 0, 1853
	pitch_sweep 8, 8
	square_note 7, 12, 0, 1917
	pitch_sweep 4, -7
	square_note 14, 12, 5, 1917
	pitch_sweep 8, 8
	sound_ret

Cry_Lopunny_Ch6:
	duty_cycle_pattern 3, 0, 1, 3
	square_note 2, 5, -1, 1800
	square_note 2, 5, 2, 1789
	square_note 1, 4, 2, 1783
	square_note 2, 6, 2, 1789
	square_note 2, 7, 2, 1796
	square_note 4, 7, 2, 1858
	square_note 3, 7, 2, 1877
	square_note 3, 8, 2, 1965
	square_note 5, 9, 2, 1972
	square_note 4, 8, 2, 1968
	square_note 4, 7, 2, 1965
	square_note 3, 7, 2, 1950
	square_note 3, 5, 1, 1942
	square_note 4, 5, 2, 1800
	square_note 2, 7, -1, 1967
	square_note 2, 7, 2, 1973
	square_note 1, 7, 1, 1981
	square_note 1, 0, 1, 1981
	sound_ret

Cry_Snover:
        channel_count 3
        channel 5, Cry_Snover_Ch5
        channel 6, Cry_Snover_Ch6
	channel 8, Cry_Snover_Ch8

Cry_Snover_Ch5:
	duty_cycle_pattern 0, 2, 0, 2
	square_note 3, 8, -1, 1700
	pitch_sweep 2, -7
	square_note 5, 10, 1, 1700
	pitch_sweep 8, 8
	square_note 1, 0, 1, 1700
	duty_cycle_pattern 2, 2, 2, 1
	square_note 15, 15, 1, 1685
	square_note 1, 0, 1, 1685
	duty_cycle_pattern 0, 2, 0, 2
	pitch_sweep 2, 7
	square_note 4, 14, 1, 1685
	pitch_sweep 8, 8
	square_note 8, 15, -1, 1700
	pitch_sweep 2, -7
	square_note 3, 11, 1, 1700
	pitch_sweep 8, 8
	duty_cycle_pattern 2, 2, 2, 1
	square_note 8, 8, 1, 1684
	sound_ret

Cry_Snover_Ch6:
	duty_cycle_pattern 1, 1, 2, 2
	square_note 9, 0, 1, 876
	square_note 10, 7, -1, 876
	square_note 10, 7, 2, 889
	square_note 11, 0, 1, 889
	square_note 10, 7, -1, 876
	square_note 10, 7, 2, 889
	square_note 1, 0, 1, 889
	sound_ret

Cry_Snover_Ch8:
	noise_note 2, 3, 1, $89
	noise_note 2, 5, 6, $5a
	noise_note 2, 4, 6, $5c
	noise_note 5, 6, -1, 178
	noise_note 2, 5, 6, $5a
	noise_note 2, 4, 6, $5c
	noise_note 5, 6, -1, 180
	noise_note 5, 6, 1, 180
	sound_ret

Cry_Abomasnow:
        channel_count 3
        channel 5, Cry_Abomasnow_Ch5
        channel 6, Cry_Abomasnow_Ch6
	channel 8, Cry_Abomasnow_Ch8

Cry_Abomasnow_Ch5:
	duty_cycle_pattern 1, 0, 3, 0
	square_note 54, 0, 3, 1027
	square_note 5, 14, 3, 1027
	square_note 2, 14, 3, 992
	square_note 6, 14, 1, 963
	square_note 2, 15, -1, 1354
	square_note 8, 15, 0, 1361
	pitch_sweep 3, -7
	square_note 5, 15, 4, 1361
	pitch_sweep 8, 8
	square_note 4, 10, -3, 787
	square_note 2, 10, -1, 788
	square_note 2, 8, -1, 786
	square_note 12, 5, 4, 787
	sound_ret

Cry_Abomasnow_Ch6:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 1, 11, 6, 0
	square_note 2, 12, 6, 112
	square_note 2, 13, 6, 252
	square_note 2, 14, 6, 367
	square_note 7, 15, 6, 486
	square_note 6, 14, 6, 486
	square_note 7, 15, 6, 486
	square_note 6, 14, 6, 486
	square_note 7, 15, 6, 486
	square_note 5, 13, 6, 486
	square_note 4, 11, 6, 486
	square_note 2, 7, 6, 367
	square_note 2, 5, 6, 252
	square_note 2, 5, 6, 112
	square_note 6, 5, 1, 0
	sound_ret

Cry_Abomasnow_Ch8:
	noise_note 14, 3, -1, $6c
	noise_note 12, 8, 7, $6c
	noise_note 12, 10, 6, $6c
	noise_note 6, 12, 1, $7c
	noise_note 3, 10, -1, $7c
	noise_note 13, 12, 2, $4c
	noise_note 21, 9, 4, $8c
	sound_ret

Cry_Froslass:
        channel_count 3
        channel 5, Cry_Froslass_Ch5
        channel 6, Cry_Froslass_Ch6
	channel 8, Cry_Froslass_Ch8

Cry_Froslass_Ch5:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 16, 2, -4, 1680
	square_note 10, 6, 0, 1680
	square_note 16, 6, 6, 1680
	duty_cycle_pattern 0, 0, 0, 0
	square_note 10, 2, -4, 1608
	square_note 8, 5, 7, 1600
	sound_ret

Cry_Froslass_Ch6:
	duty_cycle_pattern 0, 0, 0, 1
	square_note 3, 7, 1, 1789
	square_note 16, 14, 7, 1793
	square_note 8, 11, -1, 1793
	square_note 2, 11, -1, 1797
	square_note 1, 12, 0, 1800
	square_note 1, 13, 0, 1803
	square_note 1, 15, 0, 1806
	square_note 1, 15, 0, 1809
	square_note 1, 14, 0, 1811
	square_note 1, 14, 0, 1814
	square_note 9, 12, 4, 1816
	square_note 4, 5, 3, 1814
	sound_ret

Cry_Froslass_Ch8:
	noise_note 61, 5, 0, 177
	noise_note 12, 0, -2, 194
	noise_note 24, 4, 7, 190
	sound_ret

; Unova

; === Unova (gen 5) ===

Cry_Drilbur:
        channel_count 3
        channel 5, Cry_Drilbur_Ch5
	channel 6, Cry_Drilbur_Ch6
        channel 8, Cry_Drilbur_Ch8

Cry_Drilbur_Ch5:
	duty_cycle_pattern 0, 0, 1, 1
	square_note 1, 10, 0, 1584
	square_note 5, 15, 2, 1589
	square_note 2, 0, 1, 1589
	square_note 3, 11, 0, 1589
	square_note 5, 15, 2, 1584
	square_note 5, 0, 1, 1584
	pitch_sweep 7, 7
	square_note 6, 4, -1, 1580
.loop1:
	square_note 1, 15, 0, 1700
	pitch_sweep 8, 8
	square_note 1, 14, 0, 1702
	sound_loop 4, .loop1
	pitch_sweep 3, -7
	square_note 11, 14, 7, 1700
	pitch_sweep 7, 7
	square_note 10, 6, 7, 1536
	pitch_sweep 8, 8
	sound_ret

Cry_Drilbur_Ch6:
	duty_cycle_pattern 0, 0, 2, 1
	square_note 8, 7, 3, 1450
	square_note 14, 7, 3, 1424
	square_note 4, 6, 4, 1417
	square_note 9, 7, 7, 1424
	sound_ret

Cry_Drilbur_Ch8:
	noise_note 5, 10, 5, 92
	noise_note 5, 15, 5, 21
	noise_note 5, 10, 5, 92
	noise_note 12, 14, 5, 21
	noise_note 3, 8, -1, 31
	noise_note 15, 5, 5, 31
	sound_ret

Cry_Excadrill:
        channel_count 3
        channel 5, Cry_Excadrill_Ch5
	channel 6, Cry_Excadrill_Ch6
        channel 8, Cry_Excadrill_Ch8

Cry_Excadrill_Ch5:
	duty_cycle_pattern 0, 2, 0, 2
	square_note 1, 12, 0, 1400
	square_note 6, 15, 2, 1410
	square_note 2, 0, 1, 1410
	square_note 3, 13, 0, 1343
	square_note 8, 15, 1, 1355
	square_note 2, 13, 0, 1237
	square_note 3, 13, 0, 1230
	square_note 2, 15, 0, 1224
	square_note 2, 15, 0, 1221
	square_note 2, 14, 0, 1224
	square_note 2, 12, 0, 1221
	square_note 2, 12, 0, 1224
	square_note 16, 10, 2, 1233
	sound_ret

Cry_Excadrill_Ch6:
	duty_cycle_pattern 0, 0, 1, 2
	square_note 1, 8, 0, 1584
	square_note 6, 10, 2, 1589
	square_note 2, 0, 1, 1589
	square_note 3, 8, 0, 1533
	square_note 8, 10, 1, 1538
	square_note 2, 9, 0, 1466
	square_note 3, 9, 0, 1466
	square_note 2, 8, 0, 1453
	square_note 2, 9, 0, 1453
	square_note 2, 9, 0, 1445
	square_note 2, 8, 0, 1459
	square_note 2, 7, 0, 1466
	square_note 16, 7, 2, 1466
	sound_ret

Cry_Excadrill_Ch8:
	noise_note 8, 10, 5, 244
	noise_note 8, 15, 5, 234
	noise_note 16, 11, 6, 244
	noise_note 8, 14, 5, 234
	noise_note 6, 10, 5, 244
	noise_note 8, 8, 0, 230
	noise_note 16, 6, 7, 231
	sound_ret

Cry_Venipede:
        channel_count 3
        channel 5, Cry_Venipede_Ch5
	channel 6, Cry_Venipede_Ch6
        channel 8, Cry_Venipede_Ch8

Cry_Venipede_Ch5:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 6, 15, -1, 1807
	pitch_sweep 3, -7
	square_note 9, 14, -1, 1807
	square_note 1, 0, 1, 1807
	pitch_sweep 8, 8
	sound_ret

Cry_Venipede_Ch6:
	duty_cycle_pattern 1, 1, 1, 1
	square_note 9, 9, 0, 1634
	square_note 2, 8, 0, 1617
	square_note 2, 9, 0, 1623
	square_note 2, 9, 2, 1634
	sound_ret

Cry_Venipede_Ch8:
	noise_note 16, 10, 3, 129
	sound_ret

Cry_Whirlipede:
        channel_count 3
        channel 5, Cry_Whirlipede_Ch5
	channel 6, Cry_Whirlipede_Ch6
        channel 8, Cry_Whirlipede_Ch8

Cry_Whirlipede_Ch5:
	duty_cycle_pattern 0, 0, 3, 0
	square_note 12, 8, -1, 1834
	square_note 4, 7, 0, 1834
	square_note 9, 8, -1, 1834
	square_note 3, 7, 0, 1833
	square_note 1, 14, 0, 1786
	square_note 1, 14, 0, 1795
	square_note 1, 0, 5, 1790
	square_note 8, 13, 1, 1783
	sound_ret

Cry_Whirlipede_Ch6:
	duty_cycle_pattern 1, 1, 0, 1
	square_note 12, 14, -1, 1657
	square_note 4, 14, 0, 1667
	square_note 9, 14, -1, 1673
	square_note 3, 13, -1, 1689
	square_note 8, 14, 2, 1706
	sound_ret


Cry_Whirlipede_Ch8:
	noise_note 2, 15, 2, 134
.loop1:
	noise_note 16, 14, -1, 155
	noise_note 8, 13, 0, 155
	sound_loop 2, .loop1
	noise_note 4, 12, 2, 154
	sound_ret

Cry_Scolipede:
        channel_count 3
        channel 5, Cry_Scolipede_Ch5
	channel 6, Cry_Scolipede_Ch6
        channel 8, Cry_Scolipede_Ch8

Cry_Scolipede_Ch5:
	duty_cycle_pattern 1, 1, 0, 1
	pitch_offset 255
	square_note 14, 10, -1, 1299
	square_note 6, 10, 0, 1299
	square_note 10, 10, 0, 1299
	square_note 3, 9, -1, 1346
	square_note 10, 10, 0, 1356
	square_note 1, 12, 0, 1474
	square_note 1, 10, 0, 1483
	square_note 4, 7, 1, 1496
	sound_ret

Cry_Scolipede_Ch6:
	duty_cycle_pattern 0, 0, 3, 0
	square_note 8, 0, 1, 1657
	square_note 4, 12, -1, 1706
	square_note 8, 12, 2, 1712
	square_note 5, 3, -1, 1677
	square_note 9, 12, 4, 1666
	sound_ret

Cry_Scolipede_Ch8:
	noise_note 2, 15, 2, 113
	noise_note 16, 13, 0, 76
	noise_note 16, 12, 0, 76
	noise_note 16, 12, 0, 76
	noise_note 9, 12, 6, 76
	noise_note 16, 12, 0, 68
	noise_note 16, 9, 3, 68
	sound_ret

Cry_Scraggy:
        channel_count 3
        channel 5, Cry_Scraggy_Ch5
	channel 6, Cry_Scraggy_Ch6
	channel 8, Cry_Scraggy_Ch8

Cry_Scraggy_Ch5:
	duty_cycle_pattern 1, 0, 3, 3
	square_note 2, 15, 1, 1764
	square_note 2, 15, 1, 1769
	square_note 2, 15, 1, 1763
	square_note 2, 15, 1, 1768
	square_note 1, 12, 1, 1763
	square_note 3, 11, 1, 1769
	square_note 5, 12, 0, 1722

	sound_ret

Cry_Scraggy_Ch6:
	square_note 17, 0, 1, 1726
	square_note 20, 9, 4, 1726
	sound_ret

Cry_Scraggy_Ch8:
	noise_note 1, 12, 1, 154
	noise_note 1, 13, 1, 155
	noise_note 1, 13, 1, 154
	noise_note 16, 11, 2, 160
	sound_ret

Cry_Scrafty:
        channel_count 3
        channel 5, Cry_Scrafty_Ch5
	channel 6, Cry_Scrafty_Ch6
	channel 8, Cry_Scrafty_Ch8

Cry_Scrafty_Ch5:
	duty_cycle_pattern 0, 1, 1, 1
	square_note 1, 14, -1, 1756
	square_note 2, 14, -1, 1764
	square_note 4, 14, 1, 1769
	square_note 5, 5, 1, 1769
	square_note 1, 10, -1, 1546
	square_note 6, 10, 1, 1554
	square_note 9, 13, 5, 1734
	sound_ret

Cry_Scrafty_Ch6:
	duty_cycle_pattern 0, 3, 0, 0
	square_note 7, 13, 1, 1970
	square_note 12, 15, 1, 1004
	square_note 9, 0, 1, 1004
	duty_cycle_pattern 0, 1, 1, 1
	square_note 2, 4, 5, 1688
	square_note 10, 4, 4, 1685
	sound_ret

Cry_Scrafty_Ch8:
	noise_note 10, 10, -1, 45
	noise_note 8, 14, 2, 190
	noise_note 14, 11, 5, 230
	noise_note 10, 8, 2, 62
	sound_ret

Cry_Joltik:
        channel_count 3
        channel 5, Cry_Joltik_Ch5
	channel 6, Cry_Joltik_Ch6
	channel 8, Cry_Joltik_Ch8

Cry_Joltik_Ch5:
	duty_cycle_pattern 0, 0, 1, 0
	square_note 4, 14, 2, 1944
	square_note 1, 2, 1, 1947
	square_note 8, 15, 1, 1970
	square_note 12, 5, 1, 1969
	sound_ret

Cry_Joltik_Ch6:
	duty_cycle_pattern 0, 0, 2, 2
	square_note 3, 14, 1, 161
	square_note 16, 10, 3, 6
	sound_ret

Cry_Joltik_Ch8:
	noise_note 1, 15, 7, 73
	noise_note 3, 15, 7, 140
	noise_note 11, 11, 3, 60
	noise_note 12, 7, 1, 115
	sound_ret

Cry_Galvantula:
        channel_count 3
        channel 5, Cry_Galvantula_Ch5
	channel 6, Cry_Galvantula_Ch6
	channel 8, Cry_Galvantula_Ch8

Cry_Galvantula_Ch5:
	duty_cycle_pattern 1, 3, 1, 0
	square_note 2, 14, 3, 1960
	square_note 4, 15, 3, 1962
	square_note 2, 0, 1, 1962
	square_note 2, 14, 3, 1940
	square_note 4, 15, 3, 1943
	square_note 2, 0, 1, 1963
	square_note 2, 14, 3, 1922
	square_note 4, 15, 1, 1926
	square_note 2, 13, 3, 1883
	square_note 3, 14, 3, 1885
	square_note 2, 12, 3, 1883
	square_note 10, 8, 2, 1881
	sound_ret

Cry_Galvantula_Ch6:
	duty_cycle_pattern 0, 0, 2, 2
	square_note 6, 10, 1, 2045
	square_note 2, 0, 1, 2045
	square_note 6, 10, 1, 2045
	square_note 2, 0, 1, 2045
	square_note 6, 10, 1, 2045
	square_note 15, 10, 2, 2037
	sound_ret

Cry_Galvantula_Ch8:
	noise_note 1, 12, 7, 73
	noise_note 3, 13, 7, 109
	noise_note 1, 12, 7, 73
	noise_note 3, 13, 7, 109
	noise_note 1, 12, 7, 73
	noise_note 3, 13, 7, 109
	noise_note 1, 12, 7, 73
	noise_note 3, 13, 7, 110
	noise_note 10, 13, 4, 171
	noise_note 18, 13, 3, 60
	noise_note 4, 7, 1, 115
	sound_ret

Cry_Litwick:
        channel_count 2
        channel 5, Cry_Litwick_Ch5
	channel 6, Cry_Litwick_Ch6

Cry_Litwick_Ch5:
	duty_cycle_pattern 2, 2, 2, 2
	square_note 2, 14, -1, 1921
	square_note 2, 14, 4, 1924
	square_note 3, 14, 4, 1930
	square_note 14, 13, 3, 1826
	square_note 4, 12, 2, 1811
	square_note 6, 5, 3, 1811
	sound_ret

Cry_Litwick_Ch6:
	duty_cycle_pattern 2, 1, 1, 1
	square_note 7, 5, -1, 1992
	square_note 12, 10, 2, 2016
	square_note 7, 7, 2, 1992
	square_note 2, 3, 2, 2002
	square_note 12, 3, 3, 2004
	sound_ret

Cry_Lampent:
        channel_count 3
        channel 5, Cry_Lampent_Ch5
	channel 6, Cry_Lampent_Ch6
	channel 8, Cry_Lampent_Ch8

Cry_Lampent_Ch5:
	duty_cycle_pattern 0, 0, 0, 0
	square_note 12, 0, 1, 1700
	pitch_sweep 5, -7
	square_note 32, 14, 6, 1990
	pitch_sweep 8, 8
	square_note 7, 5, 4, 1700
	sound_ret

Cry_Lampent_Ch6:
	duty_cycle_pattern 2, 2, 2, 2
	square_note 7, 4, -1, 1700
	square_note 3, 7, 0, 1752
	square_note 2, 7, 0, 1901
	square_note 1, 7, 0, 1907
	square_note 1, 7, 0, 1919
	square_note 1, 7, 0, 1924
	square_note 1, 8, 4, 1929
	square_note 1, 8, 4, 1931
	square_note 12, 7, 4, 1934
	sound_ret

Cry_Lampent_Ch8:
	noise_note 6, 9, 4, 142
	noise_note 8, 13, 2, 10
	sound_ret

Cry_Chandelure:
        channel_count 3
        channel 5, Cry_Chandelure_Ch5
	channel 6, Cry_Chandelure_Ch6
	channel 8, Cry_Chandelure_Ch8

Cry_Chandelure_Ch5:
	duty_cycle_pattern 0, 0, 0, 0
	pitch_sweep 6, -7
	square_note 34, 15, -1, 1716
	pitch_sweep 8, 8
	duty_cycle_pattern 0, 0, 1, 0
	square_note 5, 14, 3, 1540
	square_note 2, 14, 3, 1546
	square_note 7, 14, 3, 1552
	square_note 4, 14, 3, 1455
	square_note 6, 14, 3, 1443
	square_note 5, 11, 1, 1447
	sound_ret

Cry_Chandelure_Ch6:
	duty_cycle_pattern 0, 3, 1, 1
	square_note 6, 0, -5, 1354
	square_note 6, 4, 0, 1347
	square_note 6, 7, 0, 1334
	square_note 6, 9, 7, 1322
	square_note 5, 9, 7, 1315
	square_note 5, 9, 7, 1308
	square_note 5, 11, -1, 1300
	square_note 2, 11, 3, 1316
	square_note 7, 12, 3, 1330
	square_note 4, 12, 3, 1215
	square_note 6, 12, 3, 1103
	square_note 5, 10, 1, 1112
	sound_ret

Cry_Chandelure_Ch8:
	noise_note 12, 0, -1, 110
	noise_note 18, 10, 0, 84
	noise_note 12, 10, 0, 85
	noise_note 12, 10, 7, 86
	noise_note 18, 11, 6, 112
	noise_note 16, 11, 2, 108
	sound_ret

Cry_Larvesta:
        channel_count 2
        channel 5, Cry_Larvesta_Ch5
	channel 8, Cry_Larvesta_Ch8

Cry_Larvesta_Ch5:
	duty_cycle_pattern 3, 3, 0, 1
	square_note 2, 15, 7, 1945
	square_note 3, 15, 7, 1982
	square_note 5, 14, 1, 2015
	square_note 13, 13, 3, 2102
	square_note 8, 12, 2, 2101
	sound_ret

Cry_Larvesta_Ch8:
	noise_note 4, 14, 4, $3c
	noise_note 6, 13, 6, $2c
	noise_note 5, 14, 4, $3c
	noise_note 13, 11, 7, $5c
	noise_note 16, 10, 2, $5d
	sound_ret

Cry_Volcarona:
        channel_count 2
        channel 5, Cry_Volcarona_Ch5
	channel 8, Cry_Volcarona_Ch8

Cry_Volcarona_Ch5:
	duty_cycle_pattern 3, 3, 0, 1
	square_note 8, 11, 1, 1809
	square_note 5, 0, 2, 1809
	square_note 5, 13, 0, 1765
	square_note 5, 12, 0, 1776
	square_note 6, 12, 3, 1782
	square_note 15, 15, 1, 1784
	square_note 11, 13, 4, 1860
	square_note 18, 13, 4, 1888
	square_note 11, 10, 3, 1877
	square_note 11, 10, 2, 1860
	sound_ret

Cry_Volcarona_Ch8:
	noise_note 16, 10, -1, $ab
	noise_note 5, 15, 3, $9f
	noise_note 5, 14, 3, $aa
	noise_note 6, 15, 5, $ac
	noise_note 12, 14, 5, $9b
	noise_note 9, 15, 4, $8b
	noise_note 16, 14, 6, $8c
	noise_note 6, 15, 4, $ac
	noise_note 12, 14, 7, $9b
	noise_note 16, 13, 1, $ac
	sound_ret

; Kalos

; === Kalos (gen 6) ===

Cry_Noibat:
	channel_count 2
	channel 5, Cry_Noibat_Ch5
	channel 6, Cry_Noibat_Ch6

Cry_Noibat_Ch5:
	duty_cycle_pattern 0, 0, 3, 1
	square_note 10, 12, 1, 1792
	square_note 10, 13, 1, 1768
	square_note 11, 13, 1, 1780
	square_note 13, 14, 1, 1828
	square_note 2, 0, 1, 1828
	square_note 8, 14, 1, 1839
	square_note 2, 0, 1, 1839
	square_note 4, 12, 1, 1839
	square_note 4, 14, 1, 1841
	square_note 4, 11, 1, 1839
	square_note 4, 13, 1, 1841
	square_note 4, 11, 1, 1837
	square_note 4, 13, 1, 1839
	square_note 4, 11, 1, 1837
	square_note 4, 13, 1, 1839
	square_note 1, 8, 2, 1826
	square_note 2, 9, 1, 1828
	square_note 2, 10, 1, 1831
	square_note 1, 8, 2, 1826
	square_note 2, 9, 1, 1828
	square_note 2, 8, 1, 1831
	sound_ret

Cry_Noibat_Ch6:
	duty_cycle_pattern 2, 2, 3, 2
	square_note 6, 10, 1, 966
	square_note 4, 0, 1, 966
	square_note 10, 10, 1, 1565
	square_note 11, 7, 1, 978
	square_note 13, 0, 1, 978
	square_note 12, 0, 1, 978
	square_note 4, 4, 0, 1822
	square_note 4, 4, 0, 1820
	square_note 4, 4, 0, 1822
	square_note 4, 4, 0, 1820
	square_note 4, 3, 0, 1822
	square_note 4, 3, 0, 1820
	square_note 4, 2, 0, 1822
	square_note 4, 2, 1, 1820
	square_note 4, 4, 0, 1811
	square_note 4, 4, 2, 1811
	sound_ret

Cry_Noivern:
	channel_count 3
	channel 5, Cry_Noivern_Ch5
	channel 6, Cry_Noivern_Ch6
	channel 8, Cry_Noivern_Ch8

Cry_Noivern_Ch5:
	duty_cycle_pattern 0, 1, 0, 0
	square_note 1, 12, 0, 1768
	square_note 1, 11, 1, 1749
	square_note 1, 10, 1, 1744
	square_note 1, 11, 1, 1749
	square_note 1, 12, 1, 1756
	square_note 1, 13, 1, 1800
	square_note 1, 13, 1, 1833
	square_note 5, 15, 1, 1871
	square_note 3, 14, 1, 1873
	square_note 7, 13, 1, 1871
	square_note 1, 12, 1, 1833
	square_note 1, 11, 1, 1769
	square_note 3, 11, 5, 1755
	square_note 6, 0, 1, 1755
	square_note 3, 13, 1, 1855
	square_note 2, 14, 0, 1866
	square_note 3, 0, 1, 1866
	square_note 1, 14, 0, 1874
	square_note 2, 15, 0, 1877
	square_note 4, 15, 1, 1880
	square_note 1, 0, 1, 1880
.loop1:
	square_note 1, 15, 0, 1867
	square_note 2, 15, 0, 1870
	square_note 2, 15, 1, 1874
	square_note 3, 0, 1, 1874
	sound_loop 2, .loop1
.loop2:
	square_note 1, 15, 0, 1857
	square_note 2, 15, 0, 1861
	square_note 2, 15, 1, 1865
	square_note 3, 0, 1, 1865
	sound_loop 2, .loop2
.loop3:
	square_note 1, 15, 0, 1844
	square_note 2, 15, 0, 1849
	square_note 2, 15, 1, 1854
	square_note 3, 0, 1, 1854
	sound_loop 2, .loop3
	square_note 1, 14, 0, 1835
	square_note 2, 14, 0, 1838
	square_note 2, 14, 0, 1843
	square_note 1, 0, 1, 1843
	sound_ret

Cry_Noivern_Ch6:
	duty_cycle_pattern 1, 0, 0, 3
	square_note 2, 0, 0, 1766
	square_note 1, 6, 0, 1766
	square_note 1, 5, 1, 1747
	square_note 1, 5, 1, 1742
	square_note 1, 5, 1, 1747
	square_note 1, 5, 1, 1754
	square_note 1, 5, 1, 1798
	square_note 1, 5, 1, 1831
	square_note 5, 6, 1, 1869
	square_note 3, 6, 1, 1871
	square_note 7, 6, 1, 1869
	square_note 1, 5, 1, 1831
	square_note 1, 5, 1, 1767
	square_note 4, 4, 5, 1753
	square_note 6, 0, 1, 1753
	square_note 3, 5, 1, 1853
	square_note 2, 5, 0, 1864
	square_note 3, 0, 1, 1864
	square_note 1, 5, 0, 1872
	square_note 2, 6, 0, 1875
	square_note 2, 6, 1, 1878
	square_note 3, 0, 1, 1878
.loop1:
	square_note 1, 6, 0, 1865
	square_note 2, 6, 0, 1868
	square_note 2, 6, 1, 1872
	square_note 3, 0, 1, 1872
	sound_loop 2, .loop1
.loop2:
	square_note 1, 6, 0, 1855
	square_note 2, 6, 0, 1859
	square_note 2, 6, 1, 1863
	square_note 3, 0, 1, 1863
	sound_loop 2, .loop2
.loop3:
	square_note 1, 6, 0, 1842
	square_note 2, 6, 0, 1847
	square_note 2, 6, 1, 1852
	square_note 3, 0, 1, 1852
	sound_loop 2, .loop3
	square_note 1, 4, 0, 1833
	square_note 2, 5, 1, 1836
	square_note 2, 5, 0, 1841
	square_note 1, 0, 1, 1841
	sound_ret

Cry_Noivern_Ch8:
	noise_note 14, 9, 5, 234
	noise_note 4, 8, 3, 234
	noise_note 2, 10, 4, 2
	noise_note 2, 0, 1, 2
	noise_note 2, 10, 4, 1
	noise_note 2, 0, 1, 1
.loop1:
	noise_note 2, 10, 4, 2
	noise_note 3, 0, 1, 2
	sound_loop 4, .loop1
.loop2:
	noise_note 2, 10, 4, 3
	noise_note 3, 0, 1, 3
	sound_loop 2, .loop2
	noise_note 2, 10, 5, 3
	sound_ret

; === Galar (gen 8) ===

Cry_Dreepy:
	channel_count 3
	channel 5, Cry_Dreepy_Ch5
	channel 6, Cry_Dreepy_Ch6
	channel 8, Cry_Dreepy_Ch8

Cry_Dreepy_Ch5:
	duty_cycle_pattern 3, 3, 1, 1
	square_note 10, 4, 6, 2017
	square_note 8, 11, 6, 2016
	square_note 6, 5, 6, 2018
	square_note 7, 7, 6, 2017
	pitch_sweep 4, -7
	square_note 16, 9, 5, 1668
	pitch_sweep 8, 8
	sound_ret

Cry_Dreepy_Ch8:
	noise_note 4, 6, -1, $89
	noise_note 4, 12, 7, $8e
	noise_note 7, 14, 7, $8b
	noise_note 36, 14, 7, $8c
	sound_ret

Cry_Drakloak:
	channel_count 3
	channel 5, Cry_Drakloak_Ch5
	channel 6, Cry_Drakloak_Ch6
	channel 8, Cry_Drakloak_Ch8

Cry_Drakloak_Ch5:
	duty_cycle_pattern 3, 3, 1, 1
	square_note 4, 12, -1, 1691
	square_note 2, 13, 6, 1741
	square_note 2, 13, 6, 1748
	square_note 4, 15, 6, 1754
	square_note 4, 7, 6, 2018
	square_note 5, 9, 6, 2017
	square_note 8, 14, 2, 1668
	square_note 20, 13, 4, 1665
	sound_ret

Cry_Drakloak_Ch6:
Cry_Dreepy_Ch6:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 7, 7, 3, 1991
	square_note 11, 9, 4, 1987
	square_note 9, 9, 4, 1991
	square_note 7, 9, 3, 1993
	square_note 16, 7, 2, 1989
	sound_ret

Cry_Drakloak_Ch8:
	noise_note 7, 6, -1, 15
	noise_note 20, 12, 7, 13
	noise_note 16, 12, 7, 15
	noise_note 20, 14, 2, 210
	sound_ret

Cry_Dragapult:
	channel_count 3
	channel 5, Cry_Dragapult_Ch5
	channel 6, Cry_Dragapult_Ch6
	channel 8, Cry_Dragapult_Ch8

Cry_Dragapult_Ch5:
	duty_cycle_pattern 3, 3, 1, 1
	square_note 10, 14, 6, 2017
	square_note 8, 14, 6, 2016
	square_note 6, 15, 6, 2018
	square_note 3, 15, 6, 2017
	square_note 10, 3, -1, 1821
	square_note 2, 12, -1, 1831
	square_note 3, 15, 4, 1833
	pitch_sweep 5, -7
	square_note 6, 14, 0, 1828
	pitch_sweep 8, 8
	square_note 5, 12, 6, 1800
	square_note 28, 12, 4, 1798
	sound_ret

Cry_Dragapult_Ch6:
	duty_cycle_pattern 1, 0, 1, 0
	square_note 1, 14, 6, 1361
	square_note 2, 15, 6, 1369
	square_note 11, 15, 4, 1377
	square_note 1, 14, 6, 1295
	square_note 2, 13, 6, 1308
	square_note 3, 11, 1, 1322
	square_note 24, 15, 4, 1317
	sound_ret

Cry_Dragapult_Ch8:
	noise_note 8, 15, 7, 13
	noise_note 8, 14, 7, 12
	noise_note 12, 13, 7, 12
	noise_note 32, 15, 3, 13
	sound_ret

; Paldea


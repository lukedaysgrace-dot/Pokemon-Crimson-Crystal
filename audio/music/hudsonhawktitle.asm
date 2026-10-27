; Hudson Hawk (Game Boy), Title Screen — Keith Tinman.
; Port for Crimson Crystal from the sequence matching the supplied WAV.
; Source rip: kingshriek, https://snesmusic.org/hoot/kingshriek/
; One loop: 2688 frames (about 45 seconds). All channels share this length.
; Existing raw sound/noise commands preserve the original pitch modulation.
; Wave channel uses the full-range bass sample 10 in audio/wave_samples.asm.
; Longer bass notes use a two-frame attack, half-volume tail, and
; one-frame release gap; phrase lengths and pitches are unchanged.
; Available as a separate track; not assigned to the title screen.

Music_HudsonHawkTitle:
	musicheader 4, 1, Music_HudsonHawkTitle_Ch1
	musicheader 1, 2, Music_HudsonHawkTitle_Ch2
	musicheader 1, 3, Music_HudsonHawkTitle_Ch3
	musicheader 1, 4, Music_HudsonHawkTitle_Ch4

Music_HudsonHawkTitle_Ch1:
	tempo 256
	volume $77
	stereopanning $ff
	togglesfx
	notetype 1, $00
Music_HudsonHawkTitle_Ch1_Loop:
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase2
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase7
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase9
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase12
	callchannel Music_HudsonHawkTitle_Ch1_Phrase13
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase19
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase20
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase21
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase22
	callchannel Music_HudsonHawkTitle_Ch1_Phrase23
	callchannel Music_HudsonHawkTitle_Ch1_Phrase24
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase25
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase26
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase27
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase7
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase9
	callchannel Music_HudsonHawkTitle_Ch1_Phrase12
	callchannel Music_HudsonHawkTitle_Ch1_Phrase28
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase29
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase20
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase30
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase31
	callchannel Music_HudsonHawkTitle_Ch1_Phrase22
	callchannel Music_HudsonHawkTitle_Ch1_Phrase20
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase21
	callchannel Music_HudsonHawkTitle_Ch1_Phrase23
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase32
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase33
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase2
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase34
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase35
	callchannel Music_HudsonHawkTitle_Ch1_Phrase13
	callchannel Music_HudsonHawkTitle_Ch1_Phrase36
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase37
	callchannel Music_HudsonHawkTitle_Ch1_Phrase38
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase31
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase22
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase39
	callchannel Music_HudsonHawkTitle_Ch1_Phrase22
	callchannel Music_HudsonHawkTitle_Ch1_Phrase40
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase41
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase42
	callchannel Music_HudsonHawkTitle_Ch1_Phrase13
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase43
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase44
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase45
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase46
	callchannel Music_HudsonHawkTitle_Ch1_Phrase23
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase47
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase9
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase12
	callchannel Music_HudsonHawkTitle_Ch1_Phrase48
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase44
	callchannel Music_HudsonHawkTitle_Ch1_Phrase38
	callchannel Music_HudsonHawkTitle_Ch1_Phrase19
	callchannel Music_HudsonHawkTitle_Ch1_Phrase49
	callchannel Music_HudsonHawkTitle_Ch1_Phrase37
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase50
	callchannel Music_HudsonHawkTitle_Ch1_Phrase44
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase45
	callchannel Music_HudsonHawkTitle_Ch1_Phrase23
	callchannel Music_HudsonHawkTitle_Ch1_Phrase36
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase51
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase52
	callchannel Music_HudsonHawkTitle_Ch1_Phrase5
	callchannel Music_HudsonHawkTitle_Ch1_Phrase41
	callchannel Music_HudsonHawkTitle_Ch1_Phrase53
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase54
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase47
	callchannel Music_HudsonHawkTitle_Ch1_Phrase55
	callchannel Music_HudsonHawkTitle_Ch1_Phrase9
	callchannel Music_HudsonHawkTitle_Ch1_Phrase12
	callchannel Music_HudsonHawkTitle_Ch1_Phrase56
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase57
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase20
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase30
	callchannel Music_HudsonHawkTitle_Ch1_Phrase15
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase22
	callchannel Music_HudsonHawkTitle_Ch1_Phrase37
	callchannel Music_HudsonHawkTitle_Ch1_Phrase18
	callchannel Music_HudsonHawkTitle_Ch1_Phrase21
	callchannel Music_HudsonHawkTitle_Ch1_Phrase58
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase61
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase62
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase63
	callchannel Music_HudsonHawkTitle_Ch1_Phrase64
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase65
	callchannel Music_HudsonHawkTitle_Ch1_Phrase64
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase66
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase67
	callchannel Music_HudsonHawkTitle_Ch1_Phrase68
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase70
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase71
	callchannel Music_HudsonHawkTitle_Ch1_Phrase60
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase70
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase72
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase73
	callchannel Music_HudsonHawkTitle_Ch1_Phrase74
	callchannel Music_HudsonHawkTitle_Ch1_Phrase75
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase75
	callchannel Music_HudsonHawkTitle_Ch1_Phrase76
	callchannel Music_HudsonHawkTitle_Ch1_Phrase77
	callchannel Music_HudsonHawkTitle_Ch1_Phrase78
	callchannel Music_HudsonHawkTitle_Ch1_Phrase63
	callchannel Music_HudsonHawkTitle_Ch1_Phrase79
	callchannel Music_HudsonHawkTitle_Ch1_Phrase80
	callchannel Music_HudsonHawkTitle_Ch1_Phrase63
	callchannel Music_HudsonHawkTitle_Ch1_Phrase79
	callchannel Music_HudsonHawkTitle_Ch1_Phrase81
	callchannel Music_HudsonHawkTitle_Ch1_Phrase82
	callchannel Music_HudsonHawkTitle_Ch1_Phrase83
	callchannel Music_HudsonHawkTitle_Ch1_Phrase84
	callchannel Music_HudsonHawkTitle_Ch1_Phrase85
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase71
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase86
	callchannel Music_HudsonHawkTitle_Ch1_Phrase84
	callchannel Music_HudsonHawkTitle_Ch1_Phrase87
	callchannel Music_HudsonHawkTitle_Ch1_Phrase88
	callchannel Music_HudsonHawkTitle_Ch1_Phrase86
	callchannel Music_HudsonHawkTitle_Ch1_Phrase89
	callchannel Music_HudsonHawkTitle_Ch1_Phrase69
	callchannel Music_HudsonHawkTitle_Ch1_Phrase86
	callchannel Music_HudsonHawkTitle_Ch1_Phrase90
	callchannel Music_HudsonHawkTitle_Ch1_Phrase91
	callchannel Music_HudsonHawkTitle_Ch1_Phrase92
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase93
	callchannel Music_HudsonHawkTitle_Ch1_Phrase55
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase55
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase3
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase16
	callchannel Music_HudsonHawkTitle_Ch1_Phrase17
	callchannel Music_HudsonHawkTitle_Ch1_Phrase29
	callchannel Music_HudsonHawkTitle_Ch1_Phrase38
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase94
	callchannel Music_HudsonHawkTitle_Ch1_Phrase38
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase29
	callchannel Music_HudsonHawkTitle_Ch1_Phrase38
	callchannel Music_HudsonHawkTitle_Ch1_Phrase4
	callchannel Music_HudsonHawkTitle_Ch1_Phrase95
	callchannel Music_HudsonHawkTitle_Ch1_Phrase59
	callchannel Music_HudsonHawkTitle_Ch1_Phrase96
	callchannel Music_HudsonHawkTitle_Ch1_Phrase97
	callchannel Music_HudsonHawkTitle_Ch1_Phrase7
	callchannel Music_HudsonHawkTitle_Ch1_Phrase98
	callchannel Music_HudsonHawkTitle_Ch1_Phrase93
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase99
	callchannel Music_HudsonHawkTitle_Ch1_Phrase6
	callchannel Music_HudsonHawkTitle_Ch1_Phrase10
	callchannel Music_HudsonHawkTitle_Ch1_Phrase100
	callchannel Music_HudsonHawkTitle_Ch1_Phrase11
	callchannel Music_HudsonHawkTitle_Ch1_Phrase93
	callchannel Music_HudsonHawkTitle_Ch1_Phrase8
	callchannel Music_HudsonHawkTitle_Ch1_Phrase9
	callchannel Music_HudsonHawkTitle_Ch1_Phrase101
	callchannel Music_HudsonHawkTitle_Ch1_Phrase102
	callchannel Music_HudsonHawkTitle_Ch1_Phrase19
	callchannel Music_HudsonHawkTitle_Ch1_Phrase103
	callchannel Music_HudsonHawkTitle_Ch1_Phrase104
	callchannel Music_HudsonHawkTitle_Ch1_Phrase105
	callchannel Music_HudsonHawkTitle_Ch1_Phrase106
	callchannel Music_HudsonHawkTitle_Ch1_Phrase107
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase108
	callchannel Music_HudsonHawkTitle_Ch1_Phrase109
	callchannel Music_HudsonHawkTitle_Ch1_Phrase107
	callchannel Music_HudsonHawkTitle_Ch1_Phrase110
	callchannel Music_HudsonHawkTitle_Ch1_Phrase111
	callchannel Music_HudsonHawkTitle_Ch1_Phrase107
	callchannel Music_HudsonHawkTitle_Ch1_Phrase110
	callchannel Music_HudsonHawkTitle_Ch1_Phrase112
	callchannel Music_HudsonHawkTitle_Ch1_Phrase14
	callchannel Music_HudsonHawkTitle_Ch1_Phrase26
	callchannel Music_HudsonHawkTitle_Ch1_Phrase113
	callchannel Music_HudsonHawkTitle_Ch1_Phrase114
	callchannel Music_HudsonHawkTitle_Ch1_Phrase115
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase117
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase113
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase119
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase117
	callchannel Music_HudsonHawkTitle_Ch1_Phrase119
	callchannel Music_HudsonHawkTitle_Ch1_Phrase120
	callchannel Music_HudsonHawkTitle_Ch1_Phrase121
	callchannel Music_HudsonHawkTitle_Ch1_Phrase122
	callchannel Music_HudsonHawkTitle_Ch1_Phrase123
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase125
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase126
	callchannel Music_HudsonHawkTitle_Ch1_Phrase127
	callchannel Music_HudsonHawkTitle_Ch1_Phrase128
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase129
	callchannel Music_HudsonHawkTitle_Ch1_Phrase130
	callchannel Music_HudsonHawkTitle_Ch1_Phrase131
	callchannel Music_HudsonHawkTitle_Ch1_Phrase132
	callchannel Music_HudsonHawkTitle_Ch1_Phrase133
	callchannel Music_HudsonHawkTitle_Ch1_Phrase134
	callchannel Music_HudsonHawkTitle_Ch1_Phrase135
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase136
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase137
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase138
	callchannel Music_HudsonHawkTitle_Ch1_Phrase139
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase140
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase141
	callchannel Music_HudsonHawkTitle_Ch1_Phrase142
	callchannel Music_HudsonHawkTitle_Ch1_Phrase121
	callchannel Music_HudsonHawkTitle_Ch1_Phrase127
	callchannel Music_HudsonHawkTitle_Ch1_Phrase123
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase143
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase126
	callchannel Music_HudsonHawkTitle_Ch1_Phrase127
	callchannel Music_HudsonHawkTitle_Ch1_Phrase123
	callchannel Music_HudsonHawkTitle_Ch1_Phrase144
	callchannel Music_HudsonHawkTitle_Ch1_Phrase145
	callchannel Music_HudsonHawkTitle_Ch1_Phrase146
	callchannel Music_HudsonHawkTitle_Ch1_Phrase131
	callchannel Music_HudsonHawkTitle_Ch1_Phrase132
	callchannel Music_HudsonHawkTitle_Ch1_Phrase133
	callchannel Music_HudsonHawkTitle_Ch1_Phrase147
	callchannel Music_HudsonHawkTitle_Ch1_Phrase19
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase138
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase115
	callchannel Music_HudsonHawkTitle_Ch1_Phrase139
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase26
	callchannel Music_HudsonHawkTitle_Ch1_Phrase113
	callchannel Music_HudsonHawkTitle_Ch1_Phrase114
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase148
	callchannel Music_HudsonHawkTitle_Ch1_Phrase139
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase140
	callchannel Music_HudsonHawkTitle_Ch1_Phrase142
	callchannel Music_HudsonHawkTitle_Ch1_Phrase149
	callchannel Music_HudsonHawkTitle_Ch1_Phrase127
	callchannel Music_HudsonHawkTitle_Ch1_Phrase128
	callchannel Music_HudsonHawkTitle_Ch1_Phrase150
	callchannel Music_HudsonHawkTitle_Ch1_Phrase143
	callchannel Music_HudsonHawkTitle_Ch1_Phrase144
	callchannel Music_HudsonHawkTitle_Ch1_Phrase126
	callchannel Music_HudsonHawkTitle_Ch1_Phrase122
	callchannel Music_HudsonHawkTitle_Ch1_Phrase123
	callchannel Music_HudsonHawkTitle_Ch1_Phrase151
	callchannel Music_HudsonHawkTitle_Ch1_Phrase152
	callchannel Music_HudsonHawkTitle_Ch1_Phrase153
	callchannel Music_HudsonHawkTitle_Ch1_Phrase154
	callchannel Music_HudsonHawkTitle_Ch1_Phrase132
	callchannel Music_HudsonHawkTitle_Ch1_Phrase155
	callchannel Music_HudsonHawkTitle_Ch1_Phrase147
	callchannel Music_HudsonHawkTitle_Ch1_Phrase30
	callchannel Music_HudsonHawkTitle_Ch1_Phrase1
	callchannel Music_HudsonHawkTitle_Ch1_Phrase113
	callchannel Music_HudsonHawkTitle_Ch1_Phrase156
	callchannel Music_HudsonHawkTitle_Ch1_Phrase115
	callchannel Music_HudsonHawkTitle_Ch1_Phrase114
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase99
	callchannel Music_HudsonHawkTitle_Ch1_Phrase113
	callchannel Music_HudsonHawkTitle_Ch1_Phrase116
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase119
	callchannel Music_HudsonHawkTitle_Ch1_Phrase157
	callchannel Music_HudsonHawkTitle_Ch1_Phrase118
	callchannel Music_HudsonHawkTitle_Ch1_Phrase158
	callchannel Music_HudsonHawkTitle_Ch1_Phrase142
	callchannel Music_HudsonHawkTitle_Ch1_Phrase121
	callchannel Music_HudsonHawkTitle_Ch1_Phrase159
	callchannel Music_HudsonHawkTitle_Ch1_Phrase128
	callchannel Music_HudsonHawkTitle_Ch1_Phrase160
	callchannel Music_HudsonHawkTitle_Ch1_Phrase143
	callchannel Music_HudsonHawkTitle_Ch1_Phrase151
	callchannel Music_HudsonHawkTitle_Ch1_Phrase126
	callchannel Music_HudsonHawkTitle_Ch1_Phrase127
	callchannel Music_HudsonHawkTitle_Ch1_Phrase161
	callchannel Music_HudsonHawkTitle_Ch1_Phrase124
	callchannel Music_HudsonHawkTitle_Ch1_Phrase129
	callchannel Music_HudsonHawkTitle_Ch1_Phrase153
	callchannel Music_HudsonHawkTitle_Ch1_Phrase162
	callchannel Music_HudsonHawkTitle_Ch1_Phrase132
	callchannel Music_HudsonHawkTitle_Ch1_Phrase163
	callchannel Music_HudsonHawkTitle_Ch1_Phrase164
	callchannel Music_HudsonHawkTitle_Ch1_Phrase165
	loopchannel 0, Music_HudsonHawkTitle_Ch1_Loop

Music_HudsonHawkTitle_Ch1_Phrase1:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $20, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase2:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 1, $10, $03da
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase3:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase4:
	dutycycle 0
	sound 0, 5, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase5:
	dutycycle 0
	sound 0, 5, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase6:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 2, $10, $03da
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase7:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase8:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $074e
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase9:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 1, $30, $03da
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase10:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase11:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase12:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $05ed
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase13:
	dutycycle 3
	sound 0, 1, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase14:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $20, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase15:
	dutycycle 3
	sound 0, 1, $20, $0511
	sound 0, 2, $10, $0511
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase16:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase17:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $0744
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase18:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $0744
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase19:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 1, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $20, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase20:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase21:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 1, $30, $0511
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase22:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase23:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase24:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 1, $30, $0511
	sound 0, 1, $20, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase25:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase26:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 1, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $20, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase27:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $06f6
	sound 0, 1, $50, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase28:
	dutycycle 3
	sound 0, 2, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 1, $30, $05ed
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase29:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase30:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase31:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $0744
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase32:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase33:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $06f6
	sound 0, 1, $50, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase34:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase35:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $05ed
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase36:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 1, $30, $0511
	sound 0, 1, $20, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase37:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase38:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $0744
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase39:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $10, $0744
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase40:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase41:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 1, $30, $03da
	sound 0, 1, $20, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase42:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $06f6
	sound 0, 1, $50, $05ed
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase43:
	dutycycle 3
	sound 0, 1, $20, $0511
	sound 0, 1, $10, $0511
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase44:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase45:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 1, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase46:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $20, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase47:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase48:
	dutycycle 3
	sound 0, 2, $50, $05ed
	sound 0, 1, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase49:
	dutycycle 3
	sound 0, 1, $20, $0511
	sound 0, 2, $10, $0511
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase50:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 1, $30, $0511
	sound 0, 1, $30, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase51:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase52:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase53:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 2, $10, $03da
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $90, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase54:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $10, $074e
	dutycycle 0
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase55:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $074e
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase56:
	dutycycle 3
	sound 0, 1, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 1, $20, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase57:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase58:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase59:
	dutycycle 0
	sound 0, 6, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase60:
	dutycycle 0
	sound 0, 5, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase61:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06e6
	sound 0, 1, $40, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase62:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06e6
	sound 0, 1, $50, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase63:
	dutycycle 3
	sound 0, 1, $90, $06e6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase64:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0744
	sound 0, 1, $10, $06e6
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase65:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06e6
	sound 0, 1, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase66:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase67:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0739
	sound 0, 1, $60, $06e6
	sound 0, 1, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase68:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0739
	sound 0, 1, $10, $06e6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase69:
	dutycycle 3
	sound 0, 1, $90, $06e6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase70:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0739
	dutycycle 0
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase71:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0739
	sound 0, 1, $10, $06e6
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase72:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0739
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase73:
	dutycycle 3
	sound 0, 2, $50, $039b
	sound 0, 2, $40, $039b
	sound 0, 2, $30, $039b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase74:
	dutycycle 3
	sound 0, 1, $20, $039b
	sound 0, 2, $10, $039b
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase75:
	dutycycle 3
	sound 0, 1, $90, $06e6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase76:
	dutycycle 0
	sound 0, 5, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $039b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase77:
	dutycycle 3
	sound 0, 1, $50, $039b
	sound 0, 2, $40, $039b
	sound 0, 2, $30, $039b
	sound 0, 1, $20, $039b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase78:
	dutycycle 3
	sound 0, 1, $20, $039b
	sound 0, 2, $10, $039b
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase79:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0744
	sound 0, 1, $10, $06e6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $039b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase80:
	dutycycle 3
	sound 0, 2, $50, $039b
	sound 0, 1, $40, $039b
	sound 0, 2, $30, $039b
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase81:
	dutycycle 3
	sound 0, 1, $50, $039b
	sound 0, 2, $40, $039b
	sound 0, 2, $30, $039b
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase82:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $80, $06e6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06e6
	sound 0, 1, $50, $05cd
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase83:
	dutycycle 3
	sound 0, 1, $50, $05cd
	sound 0, 2, $40, $05cd
	sound 0, 2, $30, $05cd
	sound 0, 1, $50, $04e5
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase84:
	dutycycle 3
	sound 0, 1, $50, $04e5
	sound 0, 2, $40, $04e5
	sound 0, 2, $30, $04e5
	sound 0, 1, $20, $04e5
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase85:
	dutycycle 3
	sound 0, 1, $20, $04e5
	sound 0, 1, $10, $04e5
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase86:
	dutycycle 3
	sound 0, 1, $30, $06e6
	sound 0, 1, $20, $0739
	sound 0, 1, $10, $06e6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $04e5
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase87:
	dutycycle 3
	sound 0, 1, $20, $04e5
	sound 0, 2, $10, $04e5
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase88:
	dutycycle 3
	sound 0, 1, $a0, $06e6
	sound 0, 1, $90, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $06e6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase89:
	dutycycle 3
	sound 0, 2, $50, $04e5
	sound 0, 2, $40, $04e5
	sound 0, 1, $30, $04e5
	sound 0, 1, $a0, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase90:
	dutycycle 3
	sound 0, 1, $50, $04e5
	sound 0, 2, $40, $04e5
	sound 0, 2, $30, $04e5
	sound 0, 1, $20, $06e6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase91:
	dutycycle 3
	sound 0, 1, $90, $06e6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $06e6
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $04e5
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase92:
	dutycycle 3
	sound 0, 2, $50, $04e5
	sound 0, 1, $40, $04e5
	sound 0, 2, $30, $04e5
	sound 0, 1, $20, $04e5
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase93:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase94:
	dutycycle 3
	sound 0, 1, $a0, $06f6
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $06f6
	sound 0, 1, $50, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase95:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase96:
	dutycycle 3
	sound 0, 1, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 1, $20, $05ed
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase97:
	dutycycle 3
	sound 0, 1, $20, $05ed
	sound 0, 2, $10, $05ed
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase98:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $074e
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $06f6
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase99:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase100:
	dutycycle 3
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $074e
	dutycycle 0
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase101:
	dutycycle 3
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase102:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $20, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase103:
	dutycycle 3
	sound 0, 1, $20, $0511
	sound 0, 2, $10, $0511
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase104:
	dutycycle 3
	sound 0, 1, $a0, $0720
	sound 0, 1, $90, $074e
	sound 0, 1, $80, $076b
	sound 0, 1, $70, $0720
	sound 0, 1, $50, $074e
	sound 0, 1, $40, $076b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase105:
	dutycycle 3
	sound 0, 1, $30, $0720
	sound 0, 1, $20, $074e
	sound 0, 1, $10, $076b
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase106:
	dutycycle 3
	sound 0, 1, $a0, $0720
	sound 0, 1, $90, $074e
	sound 0, 1, $80, $076b
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $076b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase107:
	dutycycle 3
	sound 0, 1, $30, $0720
	sound 0, 1, $20, $074e
	sound 0, 1, $10, $076b
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase108:
	dutycycle 3
	sound 0, 1, $20, $0511
	sound 0, 1, $10, $0511
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase109:
	dutycycle 3
	sound 0, 1, $90, $0720
	sound 0, 1, $80, $074e
	sound 0, 1, $70, $076b
	sound 0, 1, $60, $0720
	sound 0, 1, $50, $074e
	sound 0, 1, $40, $076b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase110:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $a0, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase111:
	dutycycle 3
	sound 0, 1, $a0, $0720
	sound 0, 1, $90, $074e
	sound 0, 1, $80, $076b
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $074e
	sound 0, 1, $40, $076b
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase112:
	dutycycle 3
	sound 0, 1, $a0, $0720
	sound 0, 1, $80, $074e
	sound 0, 1, $70, $077b
	sound 0, 1, $60, $0720
	sound 0, 1, $50, $074e
	sound 0, 1, $40, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase113:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 2, $10, $03da
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase114:
	dutycycle 3
	sound 0, 1, $a0, $069d
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $069d
	sound 0, 1, $60, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase115:
	dutycycle 3
	sound 0, 1, $30, $069d
	sound 0, 1, $20, $06f6
	sound 0, 1, $10, $0720
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase116:
	dutycycle 3
	sound 0, 1, $90, $069d
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase117:
	dutycycle 3
	sound 0, 1, $30, $069d
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase118:
	dutycycle 3
	sound 0, 1, $30, $069d
	sound 0, 1, $20, $06f6
	sound 0, 1, $10, $0720
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase119:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase120:
	dutycycle 3
	sound 0, 1, $a0, $069d
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $60, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase121:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $50, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase122:
	dutycycle 3
	sound 0, 2, $50, $0563
	sound 0, 2, $40, $0563
	sound 0, 1, $30, $0563
	sound 0, 1, $20, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase123:
	dutycycle 3
	sound 0, 1, $20, $0563
	sound 0, 2, $10, $0563
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase124:
	dutycycle 3
	sound 0, 1, $90, $0672
	sound 0, 1, $80, $06d6
	sound 0, 1, $70, $0713
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase125:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $10, $06d6
	dutycycle 0
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase126:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0713
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase127:
	dutycycle 3
	sound 0, 1, $50, $0563
	sound 0, 2, $40, $0563
	sound 0, 2, $30, $0563
	sound 0, 1, $20, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase128:
	dutycycle 3
	sound 0, 1, $20, $0563
	sound 0, 2, $10, $0563
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase129:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0713
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase130:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase131:
	dutycycle 3
	sound 0, 1, $90, $0672
	sound 0, 1, $80, $06d6
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase132:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0720
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase133:
	dutycycle 3
	sound 0, 1, $50, $0563
	sound 0, 2, $40, $0563
	sound 0, 2, $30, $0563
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase134:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $0672
	sound 0, 1, $60, $06d6
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase135:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $20, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase136:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 1, $10, $03da
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase137:
	dutycycle 3
	sound 0, 1, $30, $069d
	sound 0, 1, $20, $06f6
	sound 0, 1, $10, $0720
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase138:
	dutycycle 3
	sound 0, 1, $20, $03da
	sound 0, 2, $10, $03da
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase139:
	dutycycle 3
	sound 0, 1, $a0, $069d
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase140:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 1, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase141:
	dutycycle 3
	sound 0, 1, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 2, $30, $03da
	sound 0, 1, $20, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase142:
	dutycycle 3
	sound 0, 1, $90, $069d
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $50, $03da
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase143:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0713
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase144:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0713
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase145:
	dutycycle 3
	sound 0, 1, $30, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0713
	dutycycle 0
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase146:
	dutycycle 3
	sound 0, 2, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 1, $30, $0511
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase147:
	dutycycle 3
	sound 0, 1, $90, $0672
	sound 0, 1, $80, $06d6
	sound 0, 1, $70, $0713
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase148:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 1, $30, $03da
	sound 0, 1, $20, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase149:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 1, $30, $03da
	sound 0, 1, $50, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase150:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $80, $06d6
	sound 0, 1, $70, $0713
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase151:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $0672
	sound 0, 1, $60, $06d6
	sound 0, 1, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase152:
	dutycycle 3
	sound 0, 1, $40, $0672
	sound 0, 1, $20, $06d6
	sound 0, 1, $10, $0713
	dutycycle 0
	sound 0, 2, $00, $0000
	dutycycle 3
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase153:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $20, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase154:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0720
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase155:
	dutycycle 3
	sound 0, 2, $50, $0563
	sound 0, 2, $40, $0563
	sound 0, 1, $30, $0563
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase156:
	dutycycle 3
	sound 0, 1, $a0, $069d
	sound 0, 1, $90, $06f6
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase157:
	dutycycle 3
	sound 0, 1, $a0, $069d
	sound 0, 1, $90, $06f6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $069d
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase158:
	dutycycle 3
	sound 0, 2, $50, $03da
	sound 0, 2, $40, $03da
	sound 0, 1, $30, $03da
	sound 0, 1, $a0, $069d
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase159:
	dutycycle 3
	sound 0, 2, $50, $0563
	sound 0, 1, $40, $0563
	sound 0, 2, $30, $0563
	sound 0, 1, $20, $0563
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase160:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0713
	sound 0, 1, $70, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $40, $0713
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase161:
	dutycycle 3
	sound 0, 1, $20, $0563
	sound 0, 1, $10, $0563
	dutycycle 0
	sound 0, 3, $00, $0000
	dutycycle 3
	sound 0, 1, $a0, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase162:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $0672
	sound 0, 1, $60, $06d6
	sound 0, 1, $50, $0720
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase163:
	dutycycle 3
	sound 0, 1, $50, $0563
	sound 0, 2, $40, $0563
	sound 0, 2, $30, $0563
	sound 0, 1, $20, $0672
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase164:
	dutycycle 3
	sound 0, 1, $a0, $0672
	sound 0, 1, $90, $06d6
	sound 0, 1, $70, $0713
	sound 0, 1, $60, $0672
	sound 0, 1, $50, $06d6
	sound 0, 1, $50, $0511
	endchannel

Music_HudsonHawkTitle_Ch1_Phrase165:
	dutycycle 3
	sound 0, 1, $50, $0511
	sound 0, 2, $40, $0511
	sound 0, 2, $30, $0511
	sound 0, 1, $90, $0511
	endchannel

Music_HudsonHawkTitle_Ch2:
	stereopanning $ff
	togglesfx
	notetype 1, $00
Music_HudsonHawkTitle_Ch2_Loop:
	callchannel Music_HudsonHawkTitle_Ch2_Phrase1
	callchannel Music_HudsonHawkTitle_Ch2_Phrase2
	callchannel Music_HudsonHawkTitle_Ch2_Phrase3
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase5
	callchannel Music_HudsonHawkTitle_Ch2_Phrase6
	callchannel Music_HudsonHawkTitle_Ch2_Phrase7
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase1
	callchannel Music_HudsonHawkTitle_Ch2_Phrase8
	callchannel Music_HudsonHawkTitle_Ch2_Phrase9
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase10
	callchannel Music_HudsonHawkTitle_Ch2_Phrase11
	callchannel Music_HudsonHawkTitle_Ch2_Phrase12
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase13
	callchannel Music_HudsonHawkTitle_Ch2_Phrase14
	callchannel Music_HudsonHawkTitle_Ch2_Phrase15
	callchannel Music_HudsonHawkTitle_Ch2_Phrase16
	callchannel Music_HudsonHawkTitle_Ch2_Phrase17
	callchannel Music_HudsonHawkTitle_Ch2_Phrase18
	callchannel Music_HudsonHawkTitle_Ch2_Phrase19
	callchannel Music_HudsonHawkTitle_Ch2_Phrase20
	callchannel Music_HudsonHawkTitle_Ch2_Phrase21
	callchannel Music_HudsonHawkTitle_Ch2_Phrase22
	callchannel Music_HudsonHawkTitle_Ch2_Phrase23
	callchannel Music_HudsonHawkTitle_Ch2_Phrase24
	callchannel Music_HudsonHawkTitle_Ch2_Phrase25
	callchannel Music_HudsonHawkTitle_Ch2_Phrase26
	callchannel Music_HudsonHawkTitle_Ch2_Phrase27
	callchannel Music_HudsonHawkTitle_Ch2_Phrase28
	callchannel Music_HudsonHawkTitle_Ch2_Phrase13
	callchannel Music_HudsonHawkTitle_Ch2_Phrase14
	callchannel Music_HudsonHawkTitle_Ch2_Phrase15
	callchannel Music_HudsonHawkTitle_Ch2_Phrase16
	callchannel Music_HudsonHawkTitle_Ch2_Phrase17
	callchannel Music_HudsonHawkTitle_Ch2_Phrase18
	callchannel Music_HudsonHawkTitle_Ch2_Phrase19
	callchannel Music_HudsonHawkTitle_Ch2_Phrase20
	callchannel Music_HudsonHawkTitle_Ch2_Phrase29
	callchannel Music_HudsonHawkTitle_Ch2_Phrase30
	callchannel Music_HudsonHawkTitle_Ch2_Phrase31
	callchannel Music_HudsonHawkTitle_Ch2_Phrase32
	callchannel Music_HudsonHawkTitle_Ch2_Phrase33
	callchannel Music_HudsonHawkTitle_Ch2_Phrase34
	callchannel Music_HudsonHawkTitle_Ch2_Phrase35
	callchannel Music_HudsonHawkTitle_Ch2_Phrase36
	callchannel Music_HudsonHawkTitle_Ch2_Phrase37
	callchannel Music_HudsonHawkTitle_Ch2_Phrase38
	callchannel Music_HudsonHawkTitle_Ch2_Phrase39
	callchannel Music_HudsonHawkTitle_Ch2_Phrase40
	callchannel Music_HudsonHawkTitle_Ch2_Phrase41
	callchannel Music_HudsonHawkTitle_Ch2_Phrase42
	callchannel Music_HudsonHawkTitle_Ch2_Phrase42
	callchannel Music_HudsonHawkTitle_Ch2_Phrase43
	callchannel Music_HudsonHawkTitle_Ch2_Phrase44
	callchannel Music_HudsonHawkTitle_Ch2_Phrase45
	callchannel Music_HudsonHawkTitle_Ch2_Phrase46
	callchannel Music_HudsonHawkTitle_Ch2_Phrase47
	callchannel Music_HudsonHawkTitle_Ch2_Phrase48
	callchannel Music_HudsonHawkTitle_Ch2_Phrase49
	callchannel Music_HudsonHawkTitle_Ch2_Phrase50
	callchannel Music_HudsonHawkTitle_Ch2_Phrase51
	callchannel Music_HudsonHawkTitle_Ch2_Phrase52
	callchannel Music_HudsonHawkTitle_Ch2_Phrase53
	callchannel Music_HudsonHawkTitle_Ch2_Phrase54
	callchannel Music_HudsonHawkTitle_Ch2_Phrase55
	callchannel Music_HudsonHawkTitle_Ch2_Phrase56
	callchannel Music_HudsonHawkTitle_Ch2_Phrase57
	callchannel Music_HudsonHawkTitle_Ch2_Phrase57
	callchannel Music_HudsonHawkTitle_Ch2_Phrase58
	callchannel Music_HudsonHawkTitle_Ch2_Phrase59
	callchannel Music_HudsonHawkTitle_Ch2_Phrase60
	callchannel Music_HudsonHawkTitle_Ch2_Phrase61
	callchannel Music_HudsonHawkTitle_Ch2_Phrase62
	callchannel Music_HudsonHawkTitle_Ch2_Phrase63
	callchannel Music_HudsonHawkTitle_Ch2_Phrase64
	callchannel Music_HudsonHawkTitle_Ch2_Phrase65
	callchannel Music_HudsonHawkTitle_Ch2_Phrase66
	callchannel Music_HudsonHawkTitle_Ch2_Phrase67
	callchannel Music_HudsonHawkTitle_Ch2_Phrase68
	callchannel Music_HudsonHawkTitle_Ch2_Phrase69
	callchannel Music_HudsonHawkTitle_Ch2_Phrase70
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase71
	callchannel Music_HudsonHawkTitle_Ch2_Phrase72
	callchannel Music_HudsonHawkTitle_Ch2_Phrase73
	callchannel Music_HudsonHawkTitle_Ch2_Phrase74
	callchannel Music_HudsonHawkTitle_Ch2_Phrase75
	callchannel Music_HudsonHawkTitle_Ch2_Phrase76
	callchannel Music_HudsonHawkTitle_Ch2_Phrase77
	callchannel Music_HudsonHawkTitle_Ch2_Phrase78
	callchannel Music_HudsonHawkTitle_Ch2_Phrase79
	callchannel Music_HudsonHawkTitle_Ch2_Phrase80
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase4
	callchannel Music_HudsonHawkTitle_Ch2_Phrase81
	callchannel Music_HudsonHawkTitle_Ch2_Phrase82
	callchannel Music_HudsonHawkTitle_Ch2_Phrase83
	loopchannel 0, Music_HudsonHawkTitle_Ch2_Loop

Music_HudsonHawkTitle_Ch2_Phrase1:
	dutycycle 0
	sound 0, 1, $00, $0000
	sound 0, 1, $60, $060b
	sound 0, 7, $60, $05ed
	sound 0, 3, $50, $05ed
	sound 0, 1, $50, $0705
	sound 0, 1, $60, $0705
	sound 0, 5, $60, $06f6
	sound 0, 5, $50, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase2:
	dutycycle 0
	sound 0, 1, $50, $06f6
	sound 0, 7, $40, $06f6
	sound 0, 6, $30, $06f6
	sound 0, 7, $20, $06f6
	sound 0, 3, $10, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase3:
	dutycycle 0
	sound 0, 3, $10, $06f6
	sound 0, 16, $00, $0000
	sound 0, 5, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase4:
	dutycycle 0
	sound 0, 16, $00, $0000
	sound 0, 8, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase5:
	dutycycle 0
	sound 0, 1, $00, $0000
	sound 0, 1, $60, $069d
	sound 0, 5, $60, $0688
	sound 0, 5, $50, $0688
	sound 0, 1, $50, $074e
	sound 0, 1, $60, $074e
	sound 0, 5, $60, $0744
	sound 0, 5, $50, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase6:
	dutycycle 0
	sound 0, 1, $50, $0744
	sound 0, 7, $40, $0744
	sound 0, 6, $30, $0744
	sound 0, 7, $20, $0744
	sound 0, 3, $10, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase7:
	dutycycle 0
	sound 0, 3, $10, $0744
	sound 0, 16, $00, $0000
	sound 0, 5, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase8:
	dutycycle 0
	sound 0, 2, $50, $06f6
	sound 0, 6, $40, $06f6
	sound 0, 6, $30, $06f6
	sound 0, 7, $20, $06f6
	sound 0, 3, $10, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase9:
	dutycycle 0
	sound 0, 3, $10, $06f6
	sound 0, 1, $10, $06f9
	sound 0, 16, $00, $0000
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase10:
	dutycycle 0
	sound 0, 2, $60, $053b
	sound 0, 7, $60, $0511
	sound 0, 3, $50, $0511
	sound 0, 1, $50, $069d
	sound 0, 1, $60, $069d
	sound 0, 5, $60, $0688
	sound 0, 5, $50, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase11:
	dutycycle 0
	sound 0, 2, $50, $0688
	sound 0, 6, $40, $0688
	sound 0, 7, $30, $0688
	sound 0, 6, $20, $0688
	sound 0, 3, $10, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase12:
	dutycycle 0
	sound 0, 3, $10, $0688
	sound 0, 1, $10, $068d
	sound 0, 16, $00, $0000
	sound 0, 4, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase13:
	dutycycle 2
	sound 0, 1, $60, $06e7
	sound 0, 1, $60, $06e8
	sound 0, 1, $60, $06e9
	sound 0, 1, $60, $06ea
	sound 0, 1, $60, $06eb
	sound 0, 1, $60, $06ec
	sound 0, 1, $60, $06ed
	sound 0, 1, $60, $06ee
	sound 0, 1, $60, $06ef
	sound 0, 1, $60, $06f0
	sound 0, 1, $60, $06f1
	sound 0, 1, $60, $06f2
	sound 0, 1, $60, $06f3
	sound 0, 1, $60, $06f4
	sound 0, 1, $60, $06f5
	sound 0, 9, $60, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase14:
	dutycycle 2
	sound 0, 16, $60, $06f6
	sound 0, 8, $60, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase15:
	dutycycle 2
	sound 0, 16, $60, $06f6
	sound 0, 1, $60, $06f9
	sound 0, 1, $60, $06fc
	sound 0, 1, $60, $06ff
	sound 0, 1, $60, $06fc
	sound 0, 1, $60, $06f9
	sound 0, 1, $60, $06f6
	sound 0, 1, $60, $06f3
	sound 0, 1, $60, $069d
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase16:
	dutycycle 2
	sound 0, 16, $60, $069d
	sound 0, 2, $60, $069d
	sound 0, 1, $60, $06a6
	sound 0, 1, $60, $06af
	sound 0, 1, $60, $06b8
	sound 0, 1, $60, $06af
	sound 0, 1, $60, $06a6
	sound 0, 1, $60, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase17:
	dutycycle 2
	sound 0, 16, $60, $0688
	sound 0, 2, $60, $0688
	sound 0, 1, $60, $0692
	sound 0, 1, $60, $069c
	sound 0, 1, $60, $06a6
	sound 0, 1, $60, $069c
	sound 0, 1, $60, $0692
	sound 0, 1, $60, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase18:
	dutycycle 2
	sound 0, 1, $60, $067e
	sound 0, 1, $60, $0674
	sound 0, 1, $60, $066a
	sound 0, 1, $60, $0674
	sound 0, 1, $60, $067e
	sound 0, 1, $60, $0688
	sound 0, 1, $60, $0692
	sound 0, 1, $60, $069c
	sound 0, 1, $60, $06a6
	sound 0, 1, $60, $069c
	sound 0, 1, $60, $0692
	sound 0, 13, $60, $0672
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase19:
	dutycycle 2
	sound 0, 6, $60, $0672
	sound 0, 1, $60, $067c
	sound 0, 1, $60, $0686
	sound 0, 1, $60, $0690
	sound 0, 1, $60, $0686
	sound 0, 2, $60, $067c
	sound 0, 11, $60, $0641
	sound 0, 1, $60, $05ed
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase20:
	dutycycle 2
	sound 0, 16, $60, $05ed
	sound 0, 2, $60, $05ed
	sound 0, 1, $60, $05fb
	sound 0, 1, $60, $0609
	sound 0, 1, $60, $0617
	sound 0, 1, $60, $0609
	sound 0, 2, $60, $05fb
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase21:
	dutycycle 3
	sound 0, 1, $80, $074e
	sound 0, 1, $70, $07a7
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $07a7
	sound 0, 1, $60, $074e
	sound 0, 2, $80, $0744
	sound 0, 1, $80, $07a2
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $07a2
	sound 0, 1, $60, $0744
	sound 0, 2, $80, $0739
	sound 0, 1, $70, $079c
	sound 0, 1, $70, $0739
	sound 0, 1, $60, $079c
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $079c
	sound 0, 1, $50, $0739
	sound 0, 1, $40, $079c
	sound 0, 1, $40, $0739
	sound 0, 1, $30, $079c
	sound 0, 1, $30, $0739
	sound 0, 1, $80, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase22:
	dutycycle 3
	sound 0, 1, $80, $0720
	sound 0, 1, $70, $0790
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $0790
	sound 0, 1, $60, $0720
	sound 0, 1, $50, $0790
	sound 0, 1, $50, $0720
	sound 0, 1, $40, $0790
	sound 0, 1, $40, $0720
	sound 0, 1, $30, $0790
	sound 0, 1, $30, $0720
	sound 0, 1, $20, $06f6
	sound 0, 1, $80, $06f6
	sound 0, 1, $70, $077b
	sound 0, 1, $70, $06f6
	sound 0, 1, $60, $077b
	sound 0, 1, $60, $06f6
	sound 0, 2, $80, $0720
	sound 0, 1, $70, $0790
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $0790
	sound 0, 1, $60, $0720
	sound 0, 1, $50, $0790
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase23:
	dutycycle 3
	sound 0, 1, $50, $0720
	sound 0, 1, $40, $0790
	sound 0, 1, $40, $0720
	sound 0, 1, $30, $0790
	sound 0, 1, $20, $0720
	sound 0, 1, $20, $0739
	sound 0, 1, $80, $0739
	sound 0, 1, $70, $079c
	sound 0, 1, $70, $0739
	sound 0, 1, $60, $079c
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $0744
	sound 0, 1, $80, $0744
	sound 0, 1, $80, $07a2
	sound 0, 1, $70, $0744
	sound 0, 1, $70, $07a2
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $07a2
	sound 0, 1, $50, $0744
	sound 0, 1, $40, $07a2
	sound 0, 1, $40, $0744
	sound 0, 1, $30, $07a2
	sound 0, 1, $30, $0744
	sound 0, 1, $80, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase24:
	dutycycle 3
	sound 0, 1, $80, $074e
	sound 0, 1, $70, $07a7
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $07a7
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $07a7
	sound 0, 1, $50, $074e
	sound 0, 1, $40, $07a7
	sound 0, 1, $30, $074e
	sound 0, 1, $30, $07a7
	sound 0, 2, $20, $074e
	sound 0, 1, $80, $0744
	sound 0, 1, $70, $07a2
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $07a2
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $07a2
	sound 0, 1, $50, $0744
	sound 0, 1, $40, $07a2
	sound 0, 1, $40, $0744
	sound 0, 1, $30, $07a2
	sound 0, 1, $20, $0744
	sound 0, 1, $80, $0739
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase25:
	dutycycle 3
	sound 0, 1, $80, $0739
	sound 0, 1, $70, $079c
	sound 0, 1, $70, $0739
	sound 0, 1, $60, $079c
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $079c
	sound 0, 1, $50, $0739
	sound 0, 1, $40, $079c
	sound 0, 1, $40, $0739
	sound 0, 1, $30, $079c
	sound 0, 1, $30, $0739
	sound 0, 2, $80, $0744
	sound 0, 1, $70, $07a2
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $07a2
	sound 0, 1, $60, $0744
	sound 0, 2, $80, $074e
	sound 0, 1, $70, $07a7
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $07a7
	sound 0, 1, $60, $074e
	sound 0, 1, $50, $07a7
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase26:
	dutycycle 3
	sound 0, 1, $50, $074e
	sound 0, 1, $40, $07a7
	sound 0, 1, $30, $074e
	sound 0, 1, $30, $07a7
	sound 0, 1, $20, $074e
	sound 0, 2, $80, $0744
	sound 0, 1, $70, $07a2
	sound 0, 1, $70, $0744
	sound 0, 1, $60, $07a2
	sound 0, 1, $60, $0744
	sound 0, 1, $50, $07a2
	sound 0, 1, $50, $0744
	sound 0, 1, $40, $07a2
	sound 0, 1, $40, $0744
	sound 0, 1, $30, $07a2
	sound 0, 1, $20, $0744
	sound 0, 2, $80, $0739
	sound 0, 1, $70, $079c
	sound 0, 1, $70, $0739
	sound 0, 1, $60, $079c
	sound 0, 1, $60, $0739
	sound 0, 1, $50, $079c
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase27:
	dutycycle 3
	sound 0, 1, $50, $0739
	sound 0, 1, $40, $079c
	sound 0, 1, $40, $0739
	sound 0, 1, $30, $079c
	sound 0, 1, $30, $0739
	sound 0, 2, $80, $0720
	sound 0, 1, $70, $0790
	sound 0, 1, $70, $0720
	sound 0, 1, $60, $0790
	sound 0, 1, $60, $0720
	sound 0, 1, $50, $06f6
	sound 0, 1, $80, $06f6
	sound 0, 1, $80, $077b
	sound 0, 1, $70, $06f6
	sound 0, 1, $70, $077b
	sound 0, 1, $60, $06f6
	sound 0, 1, $60, $077b
	sound 0, 1, $50, $06f6
	sound 0, 1, $40, $077b
	sound 0, 1, $40, $06f6
	sound 0, 1, $30, $077b
	sound 0, 1, $30, $06f6
	sound 0, 1, $20, $077b
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase28:
	dutycycle 3
	sound 0, 1, $20, $06f6
	sound 0, 1, $10, $077b
	sound 0, 1, $10, $06f6
	dutycycle 0
	sound 0, 16, $00, $0000
	sound 0, 5, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase29:
	dutycycle 0
	sound 0, 1, $50, $06d7
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06d9
	sound 0, 1, $50, $06da
	sound 0, 1, $50, $06db
	sound 0, 1, $50, $06dc
	sound 0, 1, $50, $06dd
	sound 0, 1, $50, $06de
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06e0
	sound 0, 1, $50, $06e1
	sound 0, 1, $50, $06e2
	sound 0, 1, $50, $06e3
	sound 0, 1, $50, $06e4
	sound 0, 1, $50, $06e5
	sound 0, 9, $50, $06e6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase30:
	dutycycle 0
	sound 0, 10, $50, $06e6
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06fb
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06d1
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06f4
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase31:
	dutycycle 0
	sound 0, 1, $50, $06fb
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06d1
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06fb
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06d1
	sound 0, 1, $50, $06d8
	sound 0, 1, $50, $06df
	sound 0, 1, $50, $06e6
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase32:
	dutycycle 0
	sound 0, 16, $50, $0744
	sound 0, 7, $50, $0744
	sound 0, 1, $50, $0739
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase33:
	dutycycle 0
	sound 0, 16, $50, $0739
	sound 0, 8, $50, $0739
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase34:
	dutycycle 0
	sound 0, 3, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase35:
	dutycycle 0
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase36:
	dutycycle 0
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0735
	sound 0, 1, $50, $0737
	sound 0, 1, $50, $0739
	sound 0, 1, $50, $073b
	sound 0, 1, $50, $073d
	sound 0, 1, $50, $073b
	sound 0, 2, $50, $0739
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase37:
	dutycycle 0
	sound 0, 16, $50, $0713
	sound 0, 8, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase38:
	dutycycle 0
	sound 0, 3, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase39:
	dutycycle 0
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 2, $50, $0713
	sound 0, 11, $50, $0705
	sound 0, 1, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase40:
	dutycycle 0
	sound 0, 12, $50, $0713
	sound 0, 12, $50, $0705
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase41:
	dutycycle 0
	sound 0, 15, $50, $0705
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $06ff
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0708
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase42:
	dutycycle 0
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $06ff
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $06ff
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $06ff
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0708
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase43:
	dutycycle 0
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $06ff
	sound 0, 1, $50, $0702
	sound 0, 1, $50, $0705
	sound 0, 1, $50, $0708
	sound 0, 1, $50, $070b
	sound 0, 1, $50, $0708
	sound 0, 2, $50, $0705
	sound 0, 12, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase44:
	dutycycle 0
	sound 0, 1, $50, $06e7
	sound 0, 1, $50, $06e8
	sound 0, 1, $50, $06e9
	sound 0, 1, $50, $06ea
	sound 0, 1, $50, $06eb
	sound 0, 1, $50, $06ec
	sound 0, 1, $50, $06ed
	sound 0, 1, $50, $06ee
	sound 0, 1, $50, $06ef
	sound 0, 1, $50, $06f0
	sound 0, 1, $50, $06f1
	sound 0, 1, $50, $06f2
	sound 0, 1, $50, $06f3
	sound 0, 1, $50, $06f4
	sound 0, 1, $50, $06f5
	sound 0, 9, $50, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase45:
	dutycycle 0
	sound 0, 16, $50, $06f6
	sound 0, 8, $50, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase46:
	dutycycle 0
	sound 0, 16, $50, $06f6
	sound 0, 7, $50, $06f6
	sound 0, 1, $50, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase47:
	dutycycle 0
	sound 0, 16, $50, $074e
	sound 0, 7, $50, $074e
	sound 0, 1, $50, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase48:
	dutycycle 0
	sound 0, 16, $50, $0744
	sound 0, 8, $50, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase49:
	dutycycle 0
	sound 0, 3, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase50:
	dutycycle 0
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase51:
	dutycycle 0
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0740
	sound 0, 1, $50, $0742
	sound 0, 1, $50, $0744
	sound 0, 1, $50, $0746
	sound 0, 1, $50, $0748
	sound 0, 1, $50, $0746
	sound 0, 2, $50, $0744
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase52:
	dutycycle 0
	sound 0, 16, $50, $0720
	sound 0, 8, $50, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase53:
	dutycycle 0
	sound 0, 3, $50, $0720
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0726
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $071a
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0726
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $071a
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0726
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $071d
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase54:
	dutycycle 0
	sound 0, 1, $50, $071a
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0726
	sound 0, 1, $50, $0723
	sound 0, 1, $50, $0720
	sound 0, 1, $50, $071d
	sound 0, 1, $50, $071a
	sound 0, 1, $50, $071d
	sound 0, 2, $50, $0720
	sound 0, 11, $50, $0713
	sound 0, 1, $50, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase55:
	dutycycle 0
	sound 0, 12, $50, $0720
	sound 0, 12, $50, $0713
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase56:
	dutycycle 0
	sound 0, 15, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase57:
	dutycycle 0
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase58:
	dutycycle 0
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $070d
	sound 0, 1, $50, $0710
	sound 0, 1, $50, $0713
	sound 0, 1, $50, $0716
	sound 0, 1, $50, $0719
	sound 0, 1, $50, $0716
	sound 0, 2, $50, $0713
	sound 0, 12, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase59:
	dutycycle 0
	sound 0, 11, $00, $0000
	sound 0, 2, $90, $069d
	sound 0, 2, $80, $069d
	sound 0, 1, $70, $069d
	sound 0, 2, $60, $069d
	sound 0, 2, $50, $069d
	sound 0, 2, $40, $069d
	sound 0, 1, $30, $06f6
	sound 0, 1, $90, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase60:
	dutycycle 0
	sound 0, 2, $80, $06f6
	sound 0, 2, $70, $06f6
	sound 0, 2, $60, $06f6
	sound 0, 1, $50, $06f6
	sound 0, 2, $40, $06f6
	sound 0, 1, $30, $06f6
	sound 0, 1, $30, $069d
	sound 0, 1, $90, $069d
	sound 0, 2, $80, $069d
	sound 0, 2, $70, $069d
	sound 0, 2, $60, $069d
	sound 0, 2, $50, $069d
	sound 0, 1, $40, $069d
	sound 0, 1, $30, $069d
	sound 0, 1, $30, $0720
	sound 0, 1, $90, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase61:
	dutycycle 0
	sound 0, 2, $80, $0720
	sound 0, 2, $70, $0720
	sound 0, 2, $60, $0720
	sound 0, 2, $50, $0720
	sound 0, 2, $40, $0720
	sound 0, 2, $90, $069d
	sound 0, 2, $80, $069d
	sound 0, 2, $70, $069d
	sound 0, 2, $90, $06f6
	sound 0, 2, $80, $06f6
	sound 0, 2, $70, $06f6
	sound 0, 2, $60, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase62:
	dutycycle 0
	sound 0, 1, $50, $06f6
	sound 0, 2, $40, $06f6
	sound 0, 2, $30, $06f6
	sound 0, 16, $00, $0000
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase63:
	dutycycle 0
	sound 0, 11, $00, $0000
	sound 0, 1, $90, $069d
	sound 0, 2, $80, $069d
	sound 0, 2, $70, $069d
	sound 0, 2, $60, $069d
	sound 0, 1, $50, $069d
	sound 0, 2, $40, $069d
	sound 0, 1, $30, $069d
	sound 0, 1, $30, $0688
	sound 0, 1, $90, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase64:
	dutycycle 0
	sound 0, 2, $80, $0688
	sound 0, 2, $70, $0688
	sound 0, 1, $60, $0672
	sound 0, 2, $90, $0672
	sound 0, 2, $80, $0672
	sound 0, 1, $70, $0672
	sound 0, 2, $60, $0672
	sound 0, 2, $50, $0672
	sound 0, 2, $40, $0672
	sound 0, 1, $30, $0641
	sound 0, 2, $90, $0641
	sound 0, 2, $80, $0641
	sound 0, 1, $70, $0641
	sound 0, 2, $60, $0641
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase65:
	dutycycle 0
	sound 0, 2, $50, $0641
	sound 0, 2, $40, $0641
	sound 0, 1, $30, $05ed
	sound 0, 1, $90, $05ed
	sound 0, 2, $80, $05ed
	sound 0, 2, $70, $05ed
	sound 0, 1, $60, $05ed
	sound 0, 2, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 2, $20, $05ed
	sound 0, 2, $10, $05ed
	sound 0, 3, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase66:
	dutycycle 0
	sound 0, 11, $00, $0000
	sound 0, 2, $90, $05ed
	sound 0, 2, $80, $05ed
	sound 0, 2, $70, $05ed
	sound 0, 1, $60, $05ed
	sound 0, 2, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 1, $30, $0641
	sound 0, 1, $90, $0641
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase67:
	dutycycle 0
	sound 0, 2, $80, $0641
	sound 0, 2, $70, $0641
	sound 0, 1, $60, $0672
	sound 0, 1, $90, $0672
	sound 0, 2, $80, $0672
	sound 0, 2, $70, $0672
	sound 0, 2, $60, $0672
	sound 0, 2, $50, $0672
	sound 0, 2, $40, $0672
	sound 0, 1, $30, $0688
	sound 0, 2, $90, $0688
	sound 0, 2, $80, $0688
	sound 0, 1, $70, $0688
	sound 0, 2, $60, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase68:
	dutycycle 0
	sound 0, 2, $50, $0688
	sound 0, 2, $40, $0688
	sound 0, 1, $30, $069d
	sound 0, 2, $90, $069d
	sound 0, 2, $80, $069d
	sound 0, 1, $70, $069d
	sound 0, 2, $60, $069d
	sound 0, 2, $50, $069d
	sound 0, 2, $40, $069d
	sound 0, 1, $30, $0688
	sound 0, 1, $90, $0688
	sound 0, 2, $80, $0688
	sound 0, 2, $70, $0688
	sound 0, 2, $60, $0688
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase69:
	dutycycle 0
	sound 0, 1, $50, $0688
	sound 0, 2, $40, $0688
	sound 0, 1, $30, $0688
	sound 0, 1, $30, $0672
	sound 0, 1, $90, $0672
	sound 0, 2, $80, $0672
	sound 0, 2, $70, $0672
	sound 0, 1, $60, $0641
	sound 0, 2, $90, $0641
	sound 0, 1, $80, $0641
	sound 0, 2, $70, $0641
	sound 0, 2, $60, $0641
	sound 0, 2, $50, $0641
	sound 0, 2, $40, $0641
	sound 0, 1, $30, $05ed
	sound 0, 1, $90, $05ed
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase70:
	dutycycle 0
	sound 0, 1, $90, $05ed
	sound 0, 2, $80, $05ed
	sound 0, 2, $70, $05ed
	sound 0, 1, $60, $05ed
	sound 0, 2, $50, $05ed
	sound 0, 2, $40, $05ed
	sound 0, 2, $30, $05ed
	sound 0, 2, $20, $05ed
	sound 0, 2, $10, $05ed
	sound 0, 8, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase71:
	dutycycle 2
	sound 0, 1, $a0, $074e
	sound 0, 2, $90, $074e
	sound 0, 2, $80, $074e
	sound 0, 3, $a0, $0744
	sound 0, 2, $90, $0744
	sound 0, 1, $80, $0744
	sound 0, 2, $a0, $0739
	sound 0, 2, $90, $0739
	sound 0, 2, $80, $0739
	sound 0, 2, $a0, $0720
	sound 0, 2, $90, $0720
	sound 0, 2, $80, $0720
	sound 0, 1, $70, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase72:
	dutycycle 2
	sound 0, 2, $90, $074e
	sound 0, 3, $80, $074e
	sound 0, 1, $70, $0744
	sound 0, 2, $90, $0744
	sound 0, 3, $80, $0744
	sound 0, 1, $70, $0739
	sound 0, 2, $90, $0739
	sound 0, 3, $80, $0739
	sound 0, 3, $90, $0720
	sound 0, 3, $80, $0720
	sound 0, 1, $70, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase73:
	dutycycle 2
	sound 0, 2, $90, $074e
	sound 0, 2, $80, $074e
	sound 0, 1, $70, $074e
	sound 0, 1, $60, $0744
	sound 0, 1, $90, $0744
	sound 0, 2, $80, $0744
	sound 0, 2, $70, $0744
	sound 0, 1, $60, $0739
	sound 0, 2, $90, $0739
	sound 0, 2, $80, $0739
	sound 0, 1, $70, $0739
	sound 0, 1, $70, $0720
	sound 0, 1, $90, $0720
	sound 0, 2, $80, $0720
	sound 0, 2, $70, $0720
	sound 0, 1, $90, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase74:
	dutycycle 2
	sound 0, 2, $90, $074e
	sound 0, 3, $80, $074e
	sound 0, 3, $90, $0744
	sound 0, 3, $80, $0744
	sound 0, 3, $90, $0739
	sound 0, 3, $80, $0739
	sound 0, 4, $90, $0720
	sound 0, 2, $80, $0720
	sound 0, 1, $70, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase75:
	dutycycle 2
	sound 0, 2, $70, $0720
	sound 0, 3, $60, $0720
	sound 0, 3, $50, $0720
	sound 0, 3, $40, $0720
	sound 0, 1, $30, $076b
	sound 0, 2, $90, $076b
	sound 0, 3, $80, $076b
	sound 0, 3, $70, $076b
	sound 0, 3, $60, $076b
	sound 0, 1, $90, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase76:
	dutycycle 2
	sound 0, 3, $90, $074e
	sound 0, 2, $80, $074e
	sound 0, 3, $90, $076b
	sound 0, 3, $80, $076b
	sound 0, 3, $70, $076b
	sound 0, 3, $60, $076b
	sound 0, 3, $90, $077b
	sound 0, 3, $80, $077b
	sound 0, 1, $70, $077b
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase77:
	dutycycle 2
	sound 0, 2, $70, $077b
	sound 0, 3, $60, $077b
	sound 0, 3, $90, $076b
	sound 0, 3, $80, $076b
	sound 0, 3, $70, $076b
	sound 0, 3, $60, $076b
	sound 0, 1, $50, $074e
	sound 0, 2, $90, $074e
	sound 0, 3, $80, $074e
	sound 0, 1, $70, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase78:
	dutycycle 2
	sound 0, 2, $70, $074e
	sound 0, 3, $60, $074e
	sound 0, 1, $50, $0744
	sound 0, 3, $90, $0744
	sound 0, 2, $80, $0744
	sound 0, 1, $70, $0739
	sound 0, 2, $90, $0739
	sound 0, 3, $80, $0739
	sound 0, 3, $70, $0739
	sound 0, 3, $60, $0739
	sound 0, 1, $50, $0739
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase79:
	dutycycle 2
	sound 0, 2, $90, $0720
	sound 0, 3, $80, $0720
	sound 0, 3, $70, $0720
	sound 0, 3, $60, $0720
	sound 0, 4, $90, $06f6
	sound 0, 2, $80, $06f6
	sound 0, 3, $70, $06f6
	sound 0, 3, $60, $06f6
	sound 0, 1, $50, $06f6
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase80:
	dutycycle 2
	sound 0, 2, $50, $06f6
	sound 0, 2, $40, $06f6
	sound 0, 3, $30, $06f6
	sound 0, 3, $20, $06f6
	sound 0, 2, $10, $06f6
	dutycycle 0
	sound 0, 12, $00, $0000
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase81:
	dutycycle 0
	sound 0, 16, $00, $0000
	sound 0, 2, $00, $0000
	dutycycle 2
	sound 0, 2, $90, $06f6
	sound 0, 3, $80, $06f6
	sound 0, 1, $90, $0720
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase82:
	dutycycle 2
	sound 0, 2, $90, $0720
	sound 0, 3, $80, $0720
	sound 0, 4, $90, $0739
	sound 0, 2, $80, $0739
	sound 0, 3, $90, $0744
	sound 0, 3, $80, $0744
	sound 0, 3, $70, $0744
	sound 0, 3, $60, $0744
	sound 0, 1, $90, $074e
	endchannel

Music_HudsonHawkTitle_Ch2_Phrase83:
	dutycycle 2
	sound 0, 2, $90, $074e
	sound 0, 3, $80, $074e
	sound 0, 3, $90, $0744
	sound 0, 3, $80, $0744
	sound 0, 3, $90, $0739
	sound 0, 3, $80, $0739
	sound 0, 3, $90, $0720
	sound 0, 3, $80, $0720
	sound 0, 1, $90, $0720
	endchannel

Music_HudsonHawkTitle_Ch3:
	stereopanning $ff
	togglesfx
	notetype 1, $00
Music_HudsonHawkTitle_Ch3_Loop:
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase2
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase3
	callchannel Music_HudsonHawkTitle_Ch3_Phrase4
	callchannel Music_HudsonHawkTitle_Ch3_Phrase4
	callchannel Music_HudsonHawkTitle_Ch3_Phrase4
	callchannel Music_HudsonHawkTitle_Ch3_Phrase5
	callchannel Music_HudsonHawkTitle_Ch3_Phrase5
	callchannel Music_HudsonHawkTitle_Ch3_Phrase5
	callchannel Music_HudsonHawkTitle_Ch3_Phrase5
	callchannel Music_HudsonHawkTitle_Ch3_Phrase6
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase2
	callchannel Music_HudsonHawkTitle_Ch3_Phrase2
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase1
	callchannel Music_HudsonHawkTitle_Ch3_Phrase7
	callchannel Music_HudsonHawkTitle_Ch3_Phrase8
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase9
	callchannel Music_HudsonHawkTitle_Ch3_Phrase8
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase14
	callchannel Music_HudsonHawkTitle_Ch3_Phrase15
	callchannel Music_HudsonHawkTitle_Ch3_Phrase16
	callchannel Music_HudsonHawkTitle_Ch3_Phrase17
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase14
	callchannel Music_HudsonHawkTitle_Ch3_Phrase15
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase19
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase20
	callchannel Music_HudsonHawkTitle_Ch3_Phrase21
	callchannel Music_HudsonHawkTitle_Ch3_Phrase22
	callchannel Music_HudsonHawkTitle_Ch3_Phrase23
	callchannel Music_HudsonHawkTitle_Ch3_Phrase24
	callchannel Music_HudsonHawkTitle_Ch3_Phrase25
	callchannel Music_HudsonHawkTitle_Ch3_Phrase26
	callchannel Music_HudsonHawkTitle_Ch3_Phrase24
	callchannel Music_HudsonHawkTitle_Ch3_Phrase25
	callchannel Music_HudsonHawkTitle_Ch3_Phrase27
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase29
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase14
	callchannel Music_HudsonHawkTitle_Ch3_Phrase15
	callchannel Music_HudsonHawkTitle_Ch3_Phrase29
	callchannel Music_HudsonHawkTitle_Ch3_Phrase17
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase30
	callchannel Music_HudsonHawkTitle_Ch3_Phrase15
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase19
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase12
	callchannel Music_HudsonHawkTitle_Ch3_Phrase13
	callchannel Music_HudsonHawkTitle_Ch3_Phrase20
	callchannel Music_HudsonHawkTitle_Ch3_Phrase21
	callchannel Music_HudsonHawkTitle_Ch3_Phrase22
	callchannel Music_HudsonHawkTitle_Ch3_Phrase23
	callchannel Music_HudsonHawkTitle_Ch3_Phrase24
	callchannel Music_HudsonHawkTitle_Ch3_Phrase25
	callchannel Music_HudsonHawkTitle_Ch3_Phrase26
	callchannel Music_HudsonHawkTitle_Ch3_Phrase24
	callchannel Music_HudsonHawkTitle_Ch3_Phrase25
	callchannel Music_HudsonHawkTitle_Ch3_Phrase27
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase29
	callchannel Music_HudsonHawkTitle_Ch3_Phrase31
	callchannel Music_HudsonHawkTitle_Ch3_Phrase32
	callchannel Music_HudsonHawkTitle_Ch3_Phrase31
	callchannel Music_HudsonHawkTitle_Ch3_Phrase33
	callchannel Music_HudsonHawkTitle_Ch3_Phrase34
	callchannel Music_HudsonHawkTitle_Ch3_Phrase31
	callchannel Music_HudsonHawkTitle_Ch3_Phrase32
	callchannel Music_HudsonHawkTitle_Ch3_Phrase35
	callchannel Music_HudsonHawkTitle_Ch3_Phrase36
	callchannel Music_HudsonHawkTitle_Ch3_Phrase37
	callchannel Music_HudsonHawkTitle_Ch3_Phrase36
	callchannel Music_HudsonHawkTitle_Ch3_Phrase38
	callchannel Music_HudsonHawkTitle_Ch3_Phrase39
	callchannel Music_HudsonHawkTitle_Ch3_Phrase40
	callchannel Music_HudsonHawkTitle_Ch3_Phrase40
	callchannel Music_HudsonHawkTitle_Ch3_Phrase41
	callchannel Music_HudsonHawkTitle_Ch3_Phrase42
	callchannel Music_HudsonHawkTitle_Ch3_Phrase32
	callchannel Music_HudsonHawkTitle_Ch3_Phrase42
	callchannel Music_HudsonHawkTitle_Ch3_Phrase33
	callchannel Music_HudsonHawkTitle_Ch3_Phrase34
	callchannel Music_HudsonHawkTitle_Ch3_Phrase31
	callchannel Music_HudsonHawkTitle_Ch3_Phrase43
	callchannel Music_HudsonHawkTitle_Ch3_Phrase44
	callchannel Music_HudsonHawkTitle_Ch3_Phrase45
	callchannel Music_HudsonHawkTitle_Ch3_Phrase46
	callchannel Music_HudsonHawkTitle_Ch3_Phrase45
	callchannel Music_HudsonHawkTitle_Ch3_Phrase47
	callchannel Music_HudsonHawkTitle_Ch3_Phrase48
	callchannel Music_HudsonHawkTitle_Ch3_Phrase49
	callchannel Music_HudsonHawkTitle_Ch3_Phrase50
	callchannel Music_HudsonHawkTitle_Ch3_Phrase45
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase53
	callchannel Music_HudsonHawkTitle_Ch3_Phrase54
	callchannel Music_HudsonHawkTitle_Ch3_Phrase55
	callchannel Music_HudsonHawkTitle_Ch3_Phrase54
	callchannel Music_HudsonHawkTitle_Ch3_Phrase56
	callchannel Music_HudsonHawkTitle_Ch3_Phrase57
	callchannel Music_HudsonHawkTitle_Ch3_Phrase58
	callchannel Music_HudsonHawkTitle_Ch3_Phrase58
	callchannel Music_HudsonHawkTitle_Ch3_Phrase59
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase11
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase43
	callchannel Music_HudsonHawkTitle_Ch3_Phrase61
	callchannel Music_HudsonHawkTitle_Ch3_Phrase19
	callchannel Music_HudsonHawkTitle_Ch3_Phrase62
	callchannel Music_HudsonHawkTitle_Ch3_Phrase19
	callchannel Music_HudsonHawkTitle_Ch3_Phrase63
	callchannel Music_HudsonHawkTitle_Ch3_Phrase64
	callchannel Music_HudsonHawkTitle_Ch3_Phrase65
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase19
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase66
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase67
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase69
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase56
	callchannel Music_HudsonHawkTitle_Ch3_Phrase70
	callchannel Music_HudsonHawkTitle_Ch3_Phrase71
	callchannel Music_HudsonHawkTitle_Ch3_Phrase72
	callchannel Music_HudsonHawkTitle_Ch3_Phrase73
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase66
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase67
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase69
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase56
	callchannel Music_HudsonHawkTitle_Ch3_Phrase70
	callchannel Music_HudsonHawkTitle_Ch3_Phrase71
	callchannel Music_HudsonHawkTitle_Ch3_Phrase72
	callchannel Music_HudsonHawkTitle_Ch3_Phrase54
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase10
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase66
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase67
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase69
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase56
	callchannel Music_HudsonHawkTitle_Ch3_Phrase70
	callchannel Music_HudsonHawkTitle_Ch3_Phrase71
	callchannel Music_HudsonHawkTitle_Ch3_Phrase72
	callchannel Music_HudsonHawkTitle_Ch3_Phrase54
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase51
	callchannel Music_HudsonHawkTitle_Ch3_Phrase60
	callchannel Music_HudsonHawkTitle_Ch3_Phrase52
	callchannel Music_HudsonHawkTitle_Ch3_Phrase66
	callchannel Music_HudsonHawkTitle_Ch3_Phrase28
	callchannel Music_HudsonHawkTitle_Ch3_Phrase18
	callchannel Music_HudsonHawkTitle_Ch3_Phrase67
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase69
	callchannel Music_HudsonHawkTitle_Ch3_Phrase68
	callchannel Music_HudsonHawkTitle_Ch3_Phrase56
	callchannel Music_HudsonHawkTitle_Ch3_Phrase70
	callchannel Music_HudsonHawkTitle_Ch3_Phrase71
	callchannel Music_HudsonHawkTitle_Ch3_Phrase72
	callchannel Music_HudsonHawkTitle_Ch3_Phrase54
	loopchannel 0, Music_HudsonHawkTitle_Ch3_Loop

Music_HudsonHawkTitle_Ch3_Phrase1:
	sound 0, 2, $1a, $03da
	sound 0, 9, $2a, $03da
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase2:
	sound 0, 2, $1a, $03da
	sound 0, 2, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase3:
	sound 0, 2, $1a, $03da
	sound 0, 8, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $039b
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase4:
	sound 0, 2, $1a, $039b
	sound 0, 2, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $039b
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase5:
	sound 0, 2, $1a, $039b
	sound 0, 9, $2a, $039b
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase6:
	sound 0, 2, $1a, $039b
	sound 0, 8, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase7:
	sound 0, 2, $1a, $03da
	sound 0, 8, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0223
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase8:
	sound 0, 2, $1a, $0223
	sound 0, 9, $2a, $0223
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase9:
	sound 0, 1, $1a, $024c
	sound 0, 1, $1a, $0275
	sound 0, 1, $1a, $029e
	sound 0, 1, $1a, $0275
	sound 0, 1, $1a, $024c
	sound 0, 1, $1a, $0223
	sound 0, 1, $1a, $01fa
	sound 0, 1, $1a, $01d1
	sound 0, 1, $1a, $01a8
	sound 0, 1, $1a, $01d1
	sound 0, 1, $1a, $01fa
	sound 0, 1, $1a, $0223
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase10:
	sound 0, 2, $1a, $03da
	sound 0, 8, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase11:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 4, $2a, $03da
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase12:
	sound 0, 1, $1a, $03da
	sound 0, 10, $0a, $0000
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase13:
	sound 0, 2, $1a, $03da
	sound 0, 4, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 5, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase14:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 3, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase15:
	sound 0, 2, $1a, $0483
	sound 0, 2, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $04e5
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase16:
	sound 0, 2, $1a, $04e5
	sound 0, 2, $2a, $04e5
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $04e1
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase17:
	sound 0, 1, $1a, $04e4
	sound 0, 1, $1a, $04e7
	sound 0, 1, $1a, $04ea
	sound 0, 1, $1a, $04ed
	sound 0, 1, $1a, $04f0
	sound 0, 1, $1a, $04f3
	sound 0, 1, $1a, $04f6
	sound 0, 1, $1a, $04f9
	sound 0, 1, $1a, $04fc
	sound 0, 1, $1a, $04ff
	sound 0, 1, $1a, $0502
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase18:
	sound 0, 2, $1a, $04e5
	sound 0, 2, $2a, $04e5
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase19:
	sound 0, 2, $1a, $0483
	sound 0, 2, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase20:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 3, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $05ac
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase21:
	sound 0, 2, $1a, $05ac
	sound 0, 2, $2a, $05ac
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $05ed
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase22:
	sound 0, 2, $1a, $05ed
	sound 0, 2, $2a, $05ed
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase23:
	sound 0, 2, $1a, $0483
	sound 0, 2, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase24:
	sound 0, 2, $1a, $0483
	sound 0, 4, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 5, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase25:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $0483
	sound 0, 4, $2a, $0483
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase26:
	sound 0, 1, $1a, $0483
	sound 0, 10, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase27:
	sound 0, 2, $1a, $04e5
	sound 0, 2, $2a, $04e5
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0511
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase28:
	sound 0, 2, $1a, $0511
	sound 0, 2, $2a, $0511
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $04e5
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase29:
	sound 0, 2, $1a, $04e5
	sound 0, 2, $2a, $04e5
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase30:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 3, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0383
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase31:
	sound 0, 2, $1a, $039b
	sound 0, 8, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase32:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $039b
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase33:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $039b
	sound 0, 3, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase34:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $039b
	sound 0, 4, $2a, $039b
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase35:
	sound 0, 2, $1a, $039b
	sound 0, 2, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0312
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase36:
	sound 0, 2, $1a, $0312
	sound 0, 2, $2a, $0312
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase37:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $0312
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase38:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $0277
	sound 0, 3, $2a, $0277
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase39:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $0277
	sound 0, 3, $2a, $0277
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $053b
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase40:
	sound 0, 2, $1a, $053b
	sound 0, 2, $2a, $053b
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $053b
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase41:
	sound 0, 2, $1a, $053b
	sound 0, 2, $2a, $053b
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase42:
	sound 0, 2, $1a, $039b
	sound 0, 2, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase43:
	sound 0, 12, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase44:
	sound 0, 2, $1a, $039b
	sound 0, 2, $2a, $039b
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $044e
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase45:
	sound 0, 2, $1a, $044e
	sound 0, 2, $2a, $044e
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase46:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $044e
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase47:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $044e
	sound 0, 3, $2a, $044e
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase48:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $044e
	sound 0, 3, $2a, $044e
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0627
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase49:
	sound 0, 2, $1a, $0627
	sound 0, 2, $2a, $0627
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $04b5
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase50:
	sound 0, 2, $1a, $04b5
	sound 0, 2, $2a, $04b5
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $044e
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase51:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase52:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 3, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase53:
	sound 0, 2, $1a, $03da
	sound 0, 2, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0358
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase54:
	sound 0, 2, $1a, $0358
	sound 0, 2, $2a, $0358
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase55:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $0358
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase56:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $02c7
	sound 0, 3, $2a, $02c7
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase57:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $02c7
	sound 0, 3, $2a, $02c7
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0563
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase58:
	sound 0, 2, $1a, $0563
	sound 0, 2, $2a, $0563
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0563
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase59:
	sound 0, 2, $1a, $0563
	sound 0, 2, $2a, $0563
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase60:
	sound 0, 2, $1a, $03da
	sound 0, 2, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase61:
	sound 0, 2, $1a, $03da
	sound 0, 2, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase62:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase63:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $0483
	sound 0, 3, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 1, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase64:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $0483
	sound 0, 3, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0641
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase65:
	sound 0, 2, $1a, $0641
	sound 0, 2, $2a, $0641
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $04e5
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase66:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $03da
	sound 0, 3, $2a, $03da
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0511
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase67:
	sound 0, 2, $1a, $0483
	sound 0, 2, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $02c7
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase68:
	sound 0, 2, $1a, $02c7
	sound 0, 2, $2a, $02c7
	sound 0, 1, $0a, $0000
	sound 0, 7, $0a, $0000
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase69:
	sound 0, 11, $0a, $0000
	sound 0, 1, $1a, $02c7
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase70:
	sound 0, 5, $0a, $0000
	sound 0, 2, $1a, $02c7
	sound 0, 3, $2a, $02c7
	sound 0, 1, $0a, $0000
	sound 0, 1, $1a, $0483
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase71:
	sound 0, 2, $1a, $0483
	sound 0, 2, $2a, $0483
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $044e
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase72:
	sound 0, 2, $1a, $044e
	sound 0, 2, $2a, $044e
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $0358
	endchannel

Music_HudsonHawkTitle_Ch3_Phrase73:
	sound 0, 2, $1a, $0358
	sound 0, 2, $2a, $0358
	sound 0, 1, $0a, $0000
	sound 0, 6, $0a, $0000
	sound 0, 1, $1a, $03da
	endchannel

Music_HudsonHawkTitle_Ch4:
	stereopanning $ff
	togglesfx
	notetype 1
Music_HudsonHawkTitle_Ch4_Loop:
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase4
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase8
	callchannel Music_HudsonHawkTitle_Ch4_Phrase9
	callchannel Music_HudsonHawkTitle_Ch4_Phrase10
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase11
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase12
	callchannel Music_HudsonHawkTitle_Ch4_Phrase13
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase4
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase15
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase17
	callchannel Music_HudsonHawkTitle_Ch4_Phrase18
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase19
	callchannel Music_HudsonHawkTitle_Ch4_Phrase20
	callchannel Music_HudsonHawkTitle_Ch4_Phrase20
	callchannel Music_HudsonHawkTitle_Ch4_Phrase17
	callchannel Music_HudsonHawkTitle_Ch4_Phrase18
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase18
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase22
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase17
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase23
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase24
	callchannel Music_HudsonHawkTitle_Ch4_Phrase25
	callchannel Music_HudsonHawkTitle_Ch4_Phrase26
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase27
	callchannel Music_HudsonHawkTitle_Ch4_Phrase28
	callchannel Music_HudsonHawkTitle_Ch4_Phrase10
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase29
	callchannel Music_HudsonHawkTitle_Ch4_Phrase30
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase31
	callchannel Music_HudsonHawkTitle_Ch4_Phrase4
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase32
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase11
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase34
	callchannel Music_HudsonHawkTitle_Ch4_Phrase20
	callchannel Music_HudsonHawkTitle_Ch4_Phrase35
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase5
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase31
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase9
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase24
	callchannel Music_HudsonHawkTitle_Ch4_Phrase26
	callchannel Music_HudsonHawkTitle_Ch4_Phrase36
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase12
	callchannel Music_HudsonHawkTitle_Ch4_Phrase13
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase18
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase15
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase3
	callchannel Music_HudsonHawkTitle_Ch4_Phrase17
	callchannel Music_HudsonHawkTitle_Ch4_Phrase18
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase16
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase37
	callchannel Music_HudsonHawkTitle_Ch4_Phrase20
	callchannel Music_HudsonHawkTitle_Ch4_Phrase35
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase14
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase22
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase2
	callchannel Music_HudsonHawkTitle_Ch4_Phrase17
	callchannel Music_HudsonHawkTitle_Ch4_Phrase21
	callchannel Music_HudsonHawkTitle_Ch4_Phrase23
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase6
	callchannel Music_HudsonHawkTitle_Ch4_Phrase33
	callchannel Music_HudsonHawkTitle_Ch4_Phrase9
	callchannel Music_HudsonHawkTitle_Ch4_Phrase38
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase11
	callchannel Music_HudsonHawkTitle_Ch4_Phrase4
	callchannel Music_HudsonHawkTitle_Ch4_Phrase39
	callchannel Music_HudsonHawkTitle_Ch4_Phrase26
	callchannel Music_HudsonHawkTitle_Ch4_Phrase40
	callchannel Music_HudsonHawkTitle_Ch4_Phrase7
	callchannel Music_HudsonHawkTitle_Ch4_Phrase1
	callchannel Music_HudsonHawkTitle_Ch4_Phrase41
	loopchannel 0, Music_HudsonHawkTitle_Ch4_Loop

Music_HudsonHawkTitle_Ch4_Phrase1:
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase2:
	noise 0, 12, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase3:
	noise 0, 1, $70, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase4:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase5:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $20, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase6:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase7:
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase8:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 2, $30, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase9:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase10:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase11:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase12:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase13:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $10, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase14:
	noise 0, 1, $80, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase15:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase16:
	noise 0, 6, $00, $00
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase17:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase18:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $10, $60
	noise 0, 6, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase19:
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase20:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase21:
	noise 0, 6, $00, $00
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase22:
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase23:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $50, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase24:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase25:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $80, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase26:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase27:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 2, $30, $61
	noise 0, 1, $20, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase28:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $40, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase29:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase30:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $20, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase31:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase32:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $40, $5f
	noise 0, 1, $30, $60
	noise 0, 1, $20, $60
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase33:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase34:
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 2, $30, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase35:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase36:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase37:
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $79
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase38:
	noise 0, 6, $00, $00
	noise 0, 1, $70, $5b
	noise 0, 1, $60, $5b
	noise 0, 1, $50, $5d
	noise 0, 1, $30, $5f
	noise 0, 1, $20, $60
	noise 0, 1, $10, $59
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase39:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 1, $30, $61
	noise 0, 1, $30, $79
	noise 0, 1, $70, $69
	noise 0, 1, $60, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase40:
	noise 0, 1, $10, $60
	noise 0, 5, $00, $00
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $60, $61
	noise 0, 1, $50, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	endchannel

Music_HudsonHawkTitle_Ch4_Phrase41:
	noise 0, 1, $80, $69
	noise 0, 1, $70, $59
	noise 0, 1, $50, $61
	noise 0, 1, $40, $61
	noise 0, 1, $30, $61
	noise 0, 1, $20, $61
	noise 0, 1, $10, $60
	noise 0, 4, $00, $00
	noise 0, 1, $90, $60
	endchannel

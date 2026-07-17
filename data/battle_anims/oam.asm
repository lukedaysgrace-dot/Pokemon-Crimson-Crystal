BattleAnimOAMData:
; entries correspond to BATTLEANIMOAMSET_* constants
	; vtile offset, data length, data pointer
	dbbw $00, 16, .OAMData_00_PCP ; BATTLEANIMOAMSET_00
	dbbw $04,  9, .OAMData_01_PCP ; BATTLEANIMOAMSET_01
	dbbw $08,  4, .OAMData_02 ; BATTLEANIMOAMSET_02
	dbbw $09,  4, .OAMData_03 ; BATTLEANIMOAMSET_03
	dbbw $0d,  4, .OAMData_04 ; BATTLEANIMOAMSET_04
	dbbw $0f,  4, .OAMData_03 ; BATTLEANIMOAMSET_05
	dbbw $13,  4, .OAMData_04 ; BATTLEANIMOAMSET_06
	dbbw $04, 16, .OAMData_00 ; BATTLEANIMOAMSET_07
	dbbw $08, 16, .OAMData_00 ; BATTLEANIMOAMSET_08
	dbbw $08, 16, .OAMData_09 ; BATTLEANIMOAMSET_09
	dbbw $00,  4, .OAMData_04_PCP ; BATTLEANIMOAMSET_0A
	dbbw $02,  4, .OAMData_03 ; BATTLEANIMOAMSET_0B
	dbbw $06,  2, .OAMData_0c ; BATTLEANIMOAMSET_0C
	dbbw $07,  2, .OAMData_0c ; BATTLEANIMOAMSET_0D
	dbbw $02,  4, .OAMData_04_PCP ; BATTLEANIMOAMSET_0E
	dbbw $04,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_0F
	dbbw $05,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_10
	dbbw $00,  2, .OAMData_11 ; BATTLEANIMOAMSET_11
	dbbw $02,  2, .OAMData_11 ; BATTLEANIMOAMSET_12
	dbbw $00,  4, .OAMData_13 ; BATTLEANIMOAMSET_13
	dbbw $00,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_14
	dbbw $01,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_15
	dbbw $02,  1, .OAMData_0f ; BATTLEANIMOAMSET_16
	dbbw $03,  1, .OAMData_0f ; BATTLEANIMOAMSET_17
	dbbw $00,  4, .OAMData_02_PCP ; BATTLEANIMOAMSET_18
	dbbw $01, 16, .OAMData_00_PCP ; BATTLEANIMOAMSET_19
	dbbw $05, 16, .OAMData_00_PCP ; BATTLEANIMOAMSET_1A
	dbbw $00,  4, .OAMData_03 ; BATTLEANIMOAMSET_1B
	dbbw $05, 12, .OAMData_1c ; BATTLEANIMOAMSET_1C
	dbbw $02,  4, .OAMData_02 ; BATTLEANIMOAMSET_1D
	dbbw $06,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_1E
	dbbw $07,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_1F
	dbbw $08,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_20
	dbbw $04,  4, .OAMData_03 ; BATTLEANIMOAMSET_21
	dbbw $09, 22, .OAMData_22 ; BATTLEANIMOAMSET_22
	dbbw $04,  2, .OAMData_11 ; BATTLEANIMOAMSET_23
	dbbw $06,  2, .OAMData_11 ; BATTLEANIMOAMSET_24
	dbbw $0c,  1, .OAMData_0f ; BATTLEANIMOAMSET_25
	dbbw $0a,  1, .OAMData_0f ; BATTLEANIMOAMSET_26
	dbbw $0b,  4, .OAMData_02 ; BATTLEANIMOAMSET_27
	dbbw $08,  4, .OAMData_04 ; BATTLEANIMOAMSET_28
	dbbw $06,  4, .OAMData_04 ; BATTLEANIMOAMSET_29
	dbbw $00,  5, .OAMData_2a ; BATTLEANIMOAMSET_2A
	dbbw $03,  6, .OAMData_2b ; BATTLEANIMOAMSET_2B
	dbbw $00,  7, .OAMData_2c ; BATTLEANIMOAMSET_2C
	dbbw $03,  8, .OAMData_2d ; BATTLEANIMOAMSET_2D
	dbbw $00,  9, .OAMData_2e ; BATTLEANIMOAMSET_2E
	dbbw $00,  4, .OAMData_2f ; BATTLEANIMOAMSET_2F
	dbbw $02,  4, .OAMData_30 ; BATTLEANIMOAMSET_30
	dbbw $04,  6, .OAMData_31 ; BATTLEANIMOAMSET_31
	dbbw $00,  2, .OAMData_32 ; BATTLEANIMOAMSET_32
	dbbw $00,  7, .OAMData_33 ; BATTLEANIMOAMSET_33
	dbbw $00, 14, .OAMData_32 ; BATTLEANIMOAMSET_34
	dbbw $00, 21, .OAMData_33 ; BATTLEANIMOAMSET_35
	dbbw $00,  2, .OAMData_36 ; BATTLEANIMOAMSET_36
	dbbw $00,  6, .OAMData_36 ; BATTLEANIMOAMSET_37
	dbbw $00, 10, .OAMData_36 ; BATTLEANIMOAMSET_38
	dbbw $00, 14, .OAMData_36 ; BATTLEANIMOAMSET_39
	dbbw $00,  2, .OAMData_3a ; BATTLEANIMOAMSET_3A
	dbbw $00,  6, .OAMData_3a ; BATTLEANIMOAMSET_3B
	dbbw $00, 10, .OAMData_3a ; BATTLEANIMOAMSET_3C
	dbbw $00, 14, .OAMData_3a ; BATTLEANIMOAMSET_3D
	dbbw $00,  4, .OAMData_3e ; BATTLEANIMOAMSET_3E
	dbbw $00, 16, .OAMData_3e ; BATTLEANIMOAMSET_3F
	dbbw $00, 26, .OAMData_3e ; BATTLEANIMOAMSET_40
	dbbw $00, 26, .OAMData_41 ; BATTLEANIMOAMSET_41
	dbbw $0e,  4, .OAMData_42 ; BATTLEANIMOAMSET_42
	dbbw $0e,  8, .OAMData_42 ; BATTLEANIMOAMSET_43
	dbbw $0e,  4, .OAMData_44 ; BATTLEANIMOAMSET_44
	dbbw $0e,  8, .OAMData_44 ; BATTLEANIMOAMSET_45
	dbbw $0e,  4, .OAMData_46 ; BATTLEANIMOAMSET_46
	dbbw $0e,  4, .OAMData_47 ; BATTLEANIMOAMSET_47
	dbbw $00,  6, .OAMData_48 ; BATTLEANIMOAMSET_48
	dbbw $03,  4, .OAMData_49 ; BATTLEANIMOAMSET_49
	dbbw $03,  2, .OAMData_4a ; BATTLEANIMOAMSET_4A
	dbbw $01,  5, .OAMData_0f_PCP ; BATTLEANIMOAMSET_4B
	dbbw $01,  6, .OAMData_4c_PCP ; BATTLEANIMOAMSET_4C
	dbbw $01,  7, .OAMData_4d_PCP ; BATTLEANIMOAMSET_4D
	dbbw $01,  3, .OAMData_4d_PCP ; BATTLEANIMOAMSET_4E
	dbbw $01,  8, .OAMData_4f_PCP ; BATTLEANIMOAMSET_4F
	dbbw $01,  9, .OAMData_50_PCP ; BATTLEANIMOAMSET_50
	dbbw $01, 10, .OAMData_51_PCP ; BATTLEANIMOAMSET_51
	dbbw $01,  6, .OAMData_51_PCP ; BATTLEANIMOAMSET_52
	dbbw $00,  9, .OAMData_01_PCP ; BATTLEANIMOAMSET_53
	dbbw $04,  4, .OAMData_02_PCP ; BATTLEANIMOAMSET_54
	dbbw $05,  4, .OAMData_02_PCP ; BATTLEANIMOAMSET_55
	dbbw $00,  2, .OAMData_56 ; BATTLEANIMOAMSET_56
	dbbw $02,  2, .OAMData_56 ; BATTLEANIMOAMSET_57
	dbbw $04,  2, .OAMData_56 ; BATTLEANIMOAMSET_58
	dbbw $02,  4, .OAMData_59 ; BATTLEANIMOAMSET_59
	dbbw $02,  4, .OAMData_5a ; BATTLEANIMOAMSET_5A
	dbbw $02,  2, .OAMData_0c ; BATTLEANIMOAMSET_5B
	dbbw $04,  2, .OAMData_0c ; BATTLEANIMOAMSET_5C
	dbbw $06,  4, .OAMData_5d ; BATTLEANIMOAMSET_5D
	dbbw $08,  2, .OAMData_0c ; BATTLEANIMOAMSET_5E
	dbbw $09,  2, .OAMData_0c ; BATTLEANIMOAMSET_5F
	dbbw $05,  2, .OAMData_60 ; BATTLEANIMOAMSET_60
	dbbw $00,  2, .OAMData_61 ; BATTLEANIMOAMSET_61
	dbbw $00,  5, .OAMData_61 ; BATTLEANIMOAMSET_62
	dbbw $00,  9, .OAMData_61 ; BATTLEANIMOAMSET_63
	dbbw $09,  9, .OAMData_61 ; BATTLEANIMOAMSET_64
	dbbw $00,  4, .OAMData_65 ; BATTLEANIMOAMSET_65
	dbbw $00,  7, .OAMData_65 ; BATTLEANIMOAMSET_66
	dbbw $00,  9, .OAMData_65 ; BATTLEANIMOAMSET_67
	dbbw $09,  9, .OAMData_65 ; BATTLEANIMOAMSET_68
	dbbw $04,  1, .OAMData_69 ; BATTLEANIMOAMSET_69
	dbbw $05,  2, .OAMData_6a ; BATTLEANIMOAMSET_6A
	dbbw $06,  4, .OAMData_03 ; BATTLEANIMOAMSET_6B
	dbbw $0a,  4, .OAMData_03 ; BATTLEANIMOAMSET_6C
	dbbw $0e,  4, .OAMData_03 ; BATTLEANIMOAMSET_6D
	dbbw $08,  5, .OAMData_6e ; BATTLEANIMOAMSET_6E
	dbbw $0d,  3, .OAMData_6f ; BATTLEANIMOAMSET_6F
	dbbw $01,  8, .OAMData_70 ; BATTLEANIMOAMSET_70
	dbbw $03,  8, .OAMData_70 ; BATTLEANIMOAMSET_71
	dbbw $05,  8, .OAMData_70 ; BATTLEANIMOAMSET_72
	dbbw $07,  8, .OAMData_70 ; BATTLEANIMOAMSET_73
	dbbw $06,  4, .OAMData_02_PCP ; BATTLEANIMOAMSET_74
	dbbw $07,  4, .OAMData_02 ; BATTLEANIMOAMSET_75
	dbbw $0a,  2, .OAMData_76 ; BATTLEANIMOAMSET_76
	dbbw $00,  1, .OAMData_77_PCP ; BATTLEANIMOAMSET_77
	dbbw $00,  3, .OAMData_78_PCP ; BATTLEANIMOAMSET_78
	dbbw $00,  6, .OAMData_79_PCP ; BATTLEANIMOAMSET_79
	dbbw $00,  9, .OAMData_7a_PCP ; BATTLEANIMOAMSET_7A
	dbbw $00, 12, .OAMData_7b_PCP ; BATTLEANIMOAMSET_7B
	dbbw $00, 14, .OAMData_7c_PCP ; BATTLEANIMOAMSET_7C
	dbbw $00, 15, .OAMData_7d_PCP ; BATTLEANIMOAMSET_7D
	dbbw $04,  4, .OAMData_03 ; BATTLEANIMOAMSET_7E
	dbbw $08,  4, .OAMData_03 ; BATTLEANIMOAMSET_7F
	dbbw $0d,  1, .OAMData_0f ; BATTLEANIMOAMSET_80
	dbbw $0e,  4, .OAMData_30 ; BATTLEANIMOAMSET_81
	dbbw $10,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_82
	dbbw $11,  1, .OAMData_0f ; BATTLEANIMOAMSET_83
	dbbw $04,  2, .OAMData_6a ; BATTLEANIMOAMSET_84
	dbbw $00, 14, .OAMData_85 ; BATTLEANIMOAMSET_85
	dbbw $0a,  4, .OAMData_04 ; BATTLEANIMOAMSET_86
	dbbw $00,  8, .OAMData_87 ; BATTLEANIMOAMSET_87
	dbbw $00, 12, .OAMData_88 ; BATTLEANIMOAMSET_88
	dbbw $00, 16, .OAMData_87 ; BATTLEANIMOAMSET_89
	dbbw $09,  2, .OAMData_8a ; BATTLEANIMOAMSET_8A
	dbbw $09,  4, .OAMData_8a ; BATTLEANIMOAMSET_8B
	dbbw $09,  6, .OAMData_8a ; BATTLEANIMOAMSET_8C
	dbbw $09,  8, .OAMData_8a ; BATTLEANIMOAMSET_8D
	dbbw $12,  5, .OAMData_8e ; BATTLEANIMOAMSET_8E
	dbbw $00,  4, .OAMData_8f ; BATTLEANIMOAMSET_8F
	dbbw $04,  4, .OAMData_8f ; BATTLEANIMOAMSET_90
	dbbw $08,  4, .OAMData_8f ; BATTLEANIMOAMSET_91
	dbbw $0c,  4, .OAMData_8f ; BATTLEANIMOAMSET_92
	dbbw $00,  6, .OAMData_93 ; BATTLEANIMOAMSET_93
	dbbw $04,  4, .OAMData_03 ; BATTLEANIMOAMSET_94
	dbbw $0a,  4, .OAMData_04 ; BATTLEANIMOAMSET_95
	dbbw $15,  4, .OAMData_30 ; BATTLEANIMOAMSET_96
	dbbw $04,  4, .OAMData_30 ; BATTLEANIMOAMSET_97
	dbbw $0c,  4, .OAMData_04 ; BATTLEANIMOAMSET_98
	dbbw $0a,  4, .OAMData_99 ; BATTLEANIMOAMSET_99
	dbbw $0c,  4, .OAMData_03 ; BATTLEANIMOAMSET_9A
	dbbw $00, 36, .OAMData_9b ; BATTLEANIMOAMSET_9B
	dbbw $0d,  2, .OAMData_9c ; BATTLEANIMOAMSET_9C
	dbbw $0d,  4, .OAMData_9c ; BATTLEANIMOAMSET_9D
	dbbw $0d,  6, .OAMData_9c ; BATTLEANIMOAMSET_9E
	dbbw $02,  8, .OAMData_9f ; BATTLEANIMOAMSET_9F
	dbbw $08,  7, .OAMData_a0 ; BATTLEANIMOAMSET_A0
	dbbw $08,  5, .OAMData_a0 ; BATTLEANIMOAMSET_A1
	dbbw $08,  3, .OAMData_a0 ; BATTLEANIMOAMSET_A2
	dbbw $00, 16, .OAMData_1c ; BATTLEANIMOAMSET_A3
	dbbw $00,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A4
	dbbw $06,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A5
	dbbw $0c,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A6
	dbbw $12,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A7
	dbbw $18,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A8
	dbbw $1e,  9, .OAMData_a4 ; BATTLEANIMOAMSET_A9
	dbbw $24,  9, .OAMData_a4 ; BATTLEANIMOAMSET_AA
	dbbw $2a,  9, .OAMData_a4 ; BATTLEANIMOAMSET_AB
	dbbw $00,  4, .OAMData_59_PCP ; BATTLEANIMOAMSET_AC
	dbbw $12,  4, .OAMData_03 ; BATTLEANIMOAMSET_AD
	dbbw $10,  4, .OAMData_04 ; BATTLEANIMOAMSET_AE
	dbbw $16,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_AF
	dbbw $17,  4, .OAMData_02 ; BATTLEANIMOAMSET_B0
	dbbw $18,  4, .OAMData_03 ; BATTLEANIMOAMSET_B1
	dbbw $1c,  4, .OAMData_03 ; BATTLEANIMOAMSET_B2
	dbbw $20,  3, .OAMData_03 ; BATTLEANIMOAMSET_B3
	dbbw $23,  4, .OAMData_04 ; BATTLEANIMOAMSET_B4
	dbbw $25,  3, .OAMData_03 ; BATTLEANIMOAMSET_B5
	dbbw $17,  4, .OAMData_03 ; BATTLEANIMOAMSET_B6
	dbbw $0a, 16, .OAMData_00 ; BATTLEANIMOAMSET_B7
	dbbw $10, 16, .OAMData_1c ; BATTLEANIMOAMSET_B8
	dbbw $00, 16, .OAMData_1c ; BATTLEANIMOAMSET_B9
	dbbw $04,  4, .OAMData_03 ; BATTLEANIMOAMSET_BA
	dbbw $08,  2, .OAMData_11 ; BATTLEANIMOAMSET_BB
	dbbw $20,  6, .OAMData_bc ; BATTLEANIMOAMSET_BC
	dbbw $29, 14, .OAMData_bd ; BATTLEANIMOAMSET_BD
	dbbw $04,  4, .OAMData_03 ; BATTLEANIMOAMSET_BE
	dbbw $1a,  4, .OAMData_30_PCP ; BATTLEANIMOAMSET_BF
	dbbw $16,  9, .OAMData_01_PCP ; BATTLEANIMOAMSET_C0
	dbbw $10, 16, .OAMData_c1_PCP ; BATTLEANIMOAMSET_C1
	dbbw $09,  6, .OAMData_c2 ; BATTLEANIMOAMSET_C2
	dbbw $11,  9, .OAMData_c3 ; BATTLEANIMOAMSET_C3
	dbbw $0e,  4, .OAMData_03 ; BATTLEANIMOAMSET_C4
	dbbw $0b,  4, .OAMData_30_PCP ; BATTLEANIMOAMSET_C5
	dbbw $1c,  6, .OAMData_02_PCP ; BATTLEANIMOAMSET_C6
	dbbw $20, 16, .OAMData_c1_PCP ; BATTLEANIMOAMSET_C7
	dbbw $05,  6, .OAMData_c8 ; BATTLEANIMOAMSET_C8
	dbbw $0b,  4, .OAMData_03 ; BATTLEANIMOAMSET_C9
	dbbw $09,  4, .OAMData_ca ; BATTLEANIMOAMSET_CA
	dbbw $0b,  4, .OAMData_04 ; BATTLEANIMOAMSET_CB
	dbbw $11, 13, .OAMData_cc ; BATTLEANIMOAMSET_CC
	dbbw $00,  9, .OAMData_c3 ; BATTLEANIMOAMSET_CD
	dbbw $09,  9, .OAMData_c3 ; BATTLEANIMOAMSET_CE
	dbbw $00, 12, .OAMData_cf ; BATTLEANIMOAMSET_CF
	dbbw $06, 12, .OAMData_cf ; BATTLEANIMOAMSET_D0
	dbbw $0c, 12, .OAMData_cf ; BATTLEANIMOAMSET_D1
	dbbw $12, 12, .OAMData_cf ; BATTLEANIMOAMSET_D2
	dbbw $00, 13, .OAMData_cc ; BATTLEANIMOAMSET_D3
	dbbw $00,  7, .OAMData_d4 ; BATTLEANIMOAMSET_D4
	dbbw $00,  6, .OAMData_d5 ; BATTLEANIMOAMSET_D5
	dbbw $00, 14, .OAMData_d6 ; BATTLEANIMOAMSET_D6
	dbbw $00, 12, .OAMData_d7 ; BATTLEANIMOAMSET_D7
	dbbw $00, 13, .OAMData_Hail ; BATTLEANIMOAMSET_HAIL
	dbbw $00, 16, .OAMData_Stats ; BATTLEANIMOAMSET_STAT
	dbbw $05,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_55
	dbbw $04,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_54
	dbbw $00,  9, .OAMData_01_pc ; BATTLEANIMOAMSET_PC_53
	dbbw $00,  4, .OAMData_59_pc ; BATTLEANIMOAMSET_PC_AC
	dbbw $04,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_0F
	dbbw $00, 29, .OAMData_dd_PCP ; BATTLEANIMOAMSET_PC_DD
	dbbw $09, 16, .OAMData_00_PCP ; BATTLEANIMOAMSET_PC_DC
	dbbw $08,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_20
	dbbw $00, 18, .OAMData_ef ; BATTLEANIMOAMSET_PC_EF
	dbbw $09, 18, .OAMData_ef ; BATTLEANIMOAMSET_PC_F0
	dbbw $05,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_10
	dbbw $02,  4, .OAMData_04_pc ; BATTLEANIMOAMSET_PC_0E
	dbbw $00,  4, .OAMData_04_pc ; BATTLEANIMOAMSET_PC_0A
	dbbw $07,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_1F
	dbbw $06,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_1E
	dbbw $02,  5, .OAMData_e2 ; BATTLEANIMOAMSET_PC_E2
	dbbw $02,  6, .OAMData_e3 ; BATTLEANIMOAMSET_PC_E3
	dbbw $02,  7, .OAMData_e4 ; BATTLEANIMOAMSET_PC_E4
	dbbw $02,  8, .OAMData_e5 ; BATTLEANIMOAMSET_PC_E5
	dbbw $02,  9, .OAMData_e6 ; BATTLEANIMOAMSET_PC_E6
	dbbw $02, 10, .OAMData_e7 ; BATTLEANIMOAMSET_PC_E7
	dbbw $02, 11, .OAMData_e8 ; BATTLEANIMOAMSET_PC_E8
	dbbw $01,  5, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_4B
	dbbw $01,  6, .OAMData_4c_pc ; BATTLEANIMOAMSET_PC_4C
	dbbw $01,  7, .OAMData_4d_pc ; BATTLEANIMOAMSET_PC_4D
	dbbw $01,  8, .OAMData_4f_pc ; BATTLEANIMOAMSET_PC_4F
	dbbw $01,  9, .OAMData_50_pc ; BATTLEANIMOAMSET_PC_50
	dbbw $01, 10, .OAMData_51_pc ; BATTLEANIMOAMSET_PC_51
	dbbw $01,  6, .OAMData_51_pc ; BATTLEANIMOAMSET_PC_52
	dbbw $01,  3, .OAMData_4d_pc ; BATTLEANIMOAMSET_PC_4E
	dbbw $09,  4, .OAMData_02_PCP ; BATTLEANIMOAMSET_PC_EE
	dbbw $02,  2, .OAMData_e0 ; BATTLEANIMOAMSET_PC_E0
	dbbw $00,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_18
	dbbw $01, 16, .OAMData_00_pc ; BATTLEANIMOAMSET_PC_19
	dbbw $05, 16, .OAMData_00_pc ; BATTLEANIMOAMSET_PC_1A
	dbbw $00, 16, .OAMData_00_pc ; BATTLEANIMOAMSET_PC_00
	dbbw $04, 16, .OAMData_00_pc ; BATTLEANIMOAMSET_PC_07
	dbbw $0b,  4, .OAMData_30_pc ; BATTLEANIMOAMSET_PC_C5
	dbbw $1c,  6, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_C6
	dbbw $20, 16, .OAMData_c1_pc ; BATTLEANIMOAMSET_PC_C7
	dbbw $1a,  4, .OAMData_30_pc ; BATTLEANIMOAMSET_PC_BF
	dbbw $16,  9, .OAMData_01_pc ; BATTLEANIMOAMSET_PC_C0
	dbbw $10, 16, .OAMData_c1_pc ; BATTLEANIMOAMSET_PC_C1
	dbbw $0a,  9, .OAMData_f3 ; BATTLEANIMOAMSET_PC_F3
	dbbw $00, 14, .OAMData_dd ; BATTLEANIMOAMSET_PC_85
	dbbw $0e, 13, .OAMData_dd ; BATTLEANIMOAMSET_PC_95
	dbbw $1b, 14, .OAMData_dd ; BATTLEANIMOAMSET_PC_B9
	dbbw $29, 14, .OAMData_dd ; BATTLEANIMOAMSET_PC_BD
	dbbw $04,  9, .OAMData_01_pc ; BATTLEANIMOAMSET_PC_01
	dbbw $01, 15, .OAMData_HoneClaws1 ; BATTLEANIMOAMSET_PC_HONE_CLAWS_1
	dbbw $01, 18, .OAMData_HoneClaws2 ; BATTLEANIMOAMSET_PC_HONE_CLAWS_2
	dbbw $01, 21, .OAMData_HoneClaws3 ; BATTLEANIMOAMSET_PC_HONE_CLAWS_3
	dbbw $01,  9, .OAMData_HoneClaws3 ; BATTLEANIMOAMSET_PC_HONE_CLAWS_4
	dbbw $01,  8, .OAMData_70_pc ; BATTLEANIMOAMSET_PC_70
	dbbw $03,  8, .OAMData_70_pc ; BATTLEANIMOAMSET_PC_71
	dbbw $05,  8, .OAMData_70_pc ; BATTLEANIMOAMSET_PC_72
	dbbw $07,  8, .OAMData_70_pc ; BATTLEANIMOAMSET_PC_73
	dbbw $07, 10, .OAMData_HyperVoice ; BATTLEANIMOAMSET_PC_HYPER_VOICE
	dbbw $07,  4, .OAMData_03 ; BATTLEANIMOAMSET_PC_E1
	dbbw $00, 12, .OAMData_fb ; BATTLEANIMOAMSET_PC_FB
	dbbw $00,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_14
	dbbw $01,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_15
	dbbw $06,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_74
	dbbw $0c,  6, .OAMData_BigWhip1 ; BATTLEANIMOAMSET_PC_BIG_WHIP_1
	dbbw $00,  6, .OAMData_BigWhip2 ; BATTLEANIMOAMSET_PC_BIG_WHIP_2
	dbbw $06,  6, .OAMData_BigWhip3 ; BATTLEANIMOAMSET_PC_BIG_WHIP_3
	dbbw $00, 24, .OAMData_df_PCP ; BATTLEANIMOAMSET_PC_DF
	dbbw $00,  8, .OAMData_de_PCP ; BATTLEANIMOAMSET_PC_DE
	dbbw $16,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_AF
	dbbw $00,  9, .OAMData_SwirlShort_PCP ; BATTLEANIMOAMSET_PC_SWIRL_SHORT_1
	dbbw $0c,  9, .OAMData_SwirlShort_PCP ; BATTLEANIMOAMSET_PC_SWIRL_SHORT_2
	dbbw $06,  9, .OAMData_SwirlShort_PCP ; BATTLEANIMOAMSET_PC_SWIRL_SHORT_3
	dbbw $12,  9, .OAMData_SwirlShort_PCP ; BATTLEANIMOAMSET_PC_SWIRL_SHORT_4
	dbbw $03,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_EA
	dbbw $02,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_1D
	dbbw $01,  4, .OAMData_02_pc ; BATTLEANIMOAMSET_PC_EB
	dbbw $00, 16, .OAMData_VoltSwitch1_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_1
	dbbw $0f,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_PC_DISCHARGE_SPARKS_N_1
	dbbw $0e,  1, .OAMData_0f_PCP ; BATTLEANIMOAMSET_PC_DISCHARGE_SPARKS_N_2
	dbbw $10,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_82
	dbbw $08, 16, .OAMData_d8_PCP ; BATTLEANIMOAMSET_PC_D9
	dbbw $10, 16, .OAMData_d8_PCP ; BATTLEANIMOAMSET_PC_DA
	dbbw $18, 16, .OAMData_d8_PCP ; BATTLEANIMOAMSET_PC_DB
	dbbw $0d,  1, .OAMData_0f_pc ; BATTLEANIMOAMSET_PC_80
	dbbw $00, 16, .OAMData_VoltSwitch2_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_2
	dbbw $00, 16, .OAMData_VoltSwitch3_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_3
	dbbw $00, 16, .OAMData_VoltSwitch4_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_4
	dbbw $00, 16, .OAMData_VoltSwitch5_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_5
	dbbw $00, 16, .OAMData_VoltSwitch6_PCP ; BATTLEANIMOAMSET_PC_VOLT_SWITCH_6
	dbbw $02,  7, .OAMData_e8 ; BATTLEANIMOAMSET_E9
	dbbw $00, 18, .OAMData_Hurricane ; BATTLEANIMOAMSET_HURRICANE
	dbbw $20, 16, .OAMData_1c ; BATTLEANIMOAMSET_U_TURN_FALL
	dbbw $00, 16, .OAMData_d8_PCP ; BATTLEANIMOAMSET_PC_D8

; polishedcrystal ports (batch 2)
	dbbw $1b,  4, .OAMData_PC_BRICK_BREAK ; BATTLEANIMOAMSET_PC_BRICK_BREAK
	dbbw $fc,  3, .OAMData_PC_BUG_BUZZ1 ; BATTLEANIMOAMSET_PC_BUG_BUZZ1
	dbbw $f8,  5, .OAMData_PC_BUG_BUZZ2 ; BATTLEANIMOAMSET_PC_BUG_BUZZ2
	dbbw $1f,  4, .OAMData_PC_BRICK_BREAK ; BATTLEANIMOAMSET_PC_BULLET_PUNCH
	dbbw $00,  9, .OAMData_PC_EC ; BATTLEANIMOAMSET_PC_EC
	dbbw $00, 20, .OAMData_PC_F1 ; BATTLEANIMOAMSET_PC_F1
	dbbw $05, 16, .OAMData_PC_F2 ; BATTLEANIMOAMSET_PC_F2
	dbbw $00, 17, .OAMData_PC_F6 ; BATTLEANIMOAMSET_PC_F6
	dbbw $00, 12, .OAMData_PC_F7 ; BATTLEANIMOAMSET_PC_F7
	dbbw $06, 16, .OAMData_PC_F8 ; BATTLEANIMOAMSET_PC_F8
	dbbw $0e, 16, .OAMData_PC_F8 ; BATTLEANIMOAMSET_PC_F9
	dbbw $16, 12, .OAMData_PC_F7 ; BATTLEANIMOAMSET_PC_FA
	dbbw $04,  6, .OAMData_PC_FC ; BATTLEANIMOAMSET_PC_FC
	dbbw $00,  6, .OAMData_PC_ICICLE_CRASH ; BATTLEANIMOAMSET_PC_ICICLE_CRASH
	dbbw $00,  9, .OAMData_PC_EC ; BATTLEANIMOAMSET_PC_MUSHROOM_1
	dbbw $06,  9, .OAMData_PC_EC ; BATTLEANIMOAMSET_PC_MUSHROOM_2
	dbbw $0c,  9, .OAMData_PC_EC ; BATTLEANIMOAMSET_PC_MUSHROOM_3
	dbbw $11,  2, .OAMData_PC_STONE_EDGE ; BATTLEANIMOAMSET_PC_STONE_EDGE
	dbbw $0e, 13, .OAMData_PC_GYRO_BALL_2 ; BATTLEANIMOAMSET_PC_GYRO_BALL_2
	dbbw $1b, 14, .OAMData_PC_GYRO_BALL_3 ; BATTLEANIMOAMSET_PC_GYRO_BALL_3
	dbbw $00,  9, .OAMData_c3 ; BATTLEANIMOAMSET_METEOR_BIG

.OAMData_11:
	dsprite  -1, 0,  -1, 4, $00, $0
	dsprite   0, 0,  -1, 4, $01, $0

.OAMData_56:
	dsprite  -1, 4,  -1, 0, $00, $0
	dsprite  -1, 4,   0, 0, $01, $0

.OAMData_03:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $02, $0
	dsprite   0, 0,   0, 0, $03, $0

.OAMData_02:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, X_FLIP
	dsprite   0, 0,  -1, 0, $00, Y_FLIP
	dsprite   0, 0,   0, 0, $00, X_FLIP | Y_FLIP

.OAMData_c3:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $02, $0
	dsprite  -1, 4,  -2, 4, $03, $0
	dsprite  -1, 4,  -1, 4, $04, $0
	dsprite  -1, 4,   0, 4, $05, $0
	dsprite   0, 4,  -2, 4, $06, $0
	dsprite   0, 4,  -1, 4, $07, $0
	dsprite   0, 4,   0, 4, $08, $0

.OAMData_01:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $00, X_FLIP
	dsprite  -1, 4,  -2, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $03, $0
	dsprite  -1, 4,   0, 4, $02, X_FLIP | Y_FLIP
	dsprite   0, 4,  -2, 4, $00, Y_FLIP
	dsprite   0, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite   0, 4,   0, 4, $00, X_FLIP | Y_FLIP

.OAMData_cf:
	dsprite  -2, 0,  -2, 4, $00, $0
	dsprite  -2, 0,  -1, 4, $01, $0
	dsprite  -2, 0,   0, 4, $02, $0
	dsprite  -1, 0,  -2, 4, $03, $0
	dsprite  -1, 0,  -1, 4, $04, $0
	dsprite  -1, 0,   0, 4, $05, $0
	dsprite   0, 0,  -2, 4, $05, X_FLIP | Y_FLIP
	dsprite   0, 0,  -1, 4, $04, X_FLIP | Y_FLIP
	dsprite   0, 0,   0, 4, $03, X_FLIP | Y_FLIP
	dsprite   1, 0,  -2, 4, $02, X_FLIP | Y_FLIP
	dsprite   1, 0,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 4, $00, X_FLIP | Y_FLIP

.OAMData_1c:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $02, $0
	dsprite  -2, 0,   1, 0, $03, $0
	dsprite  -1, 0,  -2, 0, $04, $0
	dsprite  -1, 0,  -1, 0, $05, $0
	dsprite  -1, 0,   0, 0, $06, $0
	dsprite  -1, 0,   1, 0, $07, $0
	dsprite   0, 0,  -2, 0, $08, $0
	dsprite   0, 0,  -1, 0, $09, $0
	dsprite   0, 0,   0, 0, $0a, $0
	dsprite   0, 0,   1, 0, $0b, $0
	dsprite   1, 0,  -2, 0, $0c, $0
	dsprite   1, 0,  -1, 0, $0d, $0
	dsprite   1, 0,   0, 0, $0e, $0
	dsprite   1, 0,   1, 0, $0f, $0

.OAMData_00:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -1, 0,  -2, 0, $02, $0
	dsprite  -1, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $01, X_FLIP
	dsprite  -2, 0,   1, 0, $00, X_FLIP
	dsprite  -1, 0,   0, 0, $03, X_FLIP
	dsprite  -1, 0,   1, 0, $02, X_FLIP
	dsprite   0, 0,  -2, 0, $02, Y_FLIP
	dsprite   0, 0,  -1, 0, $03, Y_FLIP
	dsprite   1, 0,  -2, 0, $00, Y_FLIP
	dsprite   1, 0,  -1, 0, $01, Y_FLIP
	dsprite   0, 0,   0, 0, $03, X_FLIP | Y_FLIP
	dsprite   0, 0,   1, 0, $02, X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $01, X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, X_FLIP | Y_FLIP

.OAMData_09:
	dsprite  -3, 4,  -3, 4, $00, $0
	dsprite  -3, 4,  -2, 4, $01, $0
	dsprite  -2, 4,  -3, 4, $02, $0
	dsprite  -2, 4,  -2, 4, $03, $0
	dsprite  -3, 4,   0, 4, $01, X_FLIP
	dsprite  -3, 4,   1, 4, $00, X_FLIP
	dsprite  -2, 4,   0, 4, $03, X_FLIP
	dsprite  -2, 4,   1, 4, $02, X_FLIP
	dsprite   0, 4,  -3, 4, $02, Y_FLIP
	dsprite   0, 4,  -2, 4, $03, Y_FLIP
	dsprite   1, 4,  -3, 4, $00, Y_FLIP
	dsprite   1, 4,  -2, 4, $01, Y_FLIP
	dsprite   0, 4,   0, 4, $03, X_FLIP | Y_FLIP
	dsprite   0, 4,   1, 4, $02, X_FLIP | Y_FLIP
	dsprite   1, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite   1, 4,   1, 4, $00, X_FLIP | Y_FLIP

.OAMData_0c:
	dsprite  -1, 4,  -1, 0, $00, $0
	dsprite  -1, 4,   0, 0, $00, X_FLIP

.OAMData_6a:
	dsprite   0, 0,  -1, 0, $00, $0
	dsprite   0, 0,   0, 0, $00, X_FLIP

.OAMData_04:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, X_FLIP
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $01, X_FLIP

.OAMData_5d:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $00, Y_FLIP
	dsprite   0, 0,   0, 0, $01, Y_FLIP

.OAMData_13:
	dsprite  -1, 2,  -1, 0, $02, $0
	dsprite   0, 2,  -1, 0, $03, $0
	dsprite  -2, 6,   0, 0, $02, $0
	dsprite  -1, 6,   0, 0, $03, $0

.OAMData_22:
	dsprite   1, 0, -11, 0, $01, $0
	dsprite   0, 0, -10, 0, $02, $0
	dsprite   0, 0,  -9, 0, $03, $0
	dsprite   0, 0,  -8, 0, $00, $0
	dsprite   0, 0,  -7, 0, $03, $0
	dsprite   0, 0,  -6, 0, $00, $0
	dsprite   0, 0,  -5, 0, $03, $0
	dsprite   0, 0,  -4, 0, $00, $0
	dsprite   0, 0,  -3, 0, $03, $0
	dsprite   0, 0,  -2, 0, $00, $0
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite  -1, 0,   0, 0, $02, $0
	dsprite  -1, 0,   1, 0, $03, $0
	dsprite  -1, 0,   2, 0, $00, $0
	dsprite  -1, 0,   3, 0, $03, $0
	dsprite  -1, 0,   4, 0, $00, $0
	dsprite  -1, 0,   5, 0, $03, $0
	dsprite  -1, 0,   6, 0, $00, $0
	dsprite  -1, 0,   7, 0, $03, $0
	dsprite  -1, 0,   8, 0, $00, $0
	dsprite  -1, 0,   9, 0, $01, $0
	dsprite  -2, 0,  10, 0, $02, $0

.OAMData_2a:
	dsprite  -3, 4,  -1, 0, $00, $0
	dsprite  -3, 4,   0, 0, $00, X_FLIP
	dsprite  -2, 4,  -1, 0, $01, $0
	dsprite  -2, 4,   0, 0, $01, X_FLIP
	dsprite  -1, 4,  -1, 4, $02, $0

.OAMData_2b:
	dsprite  -4, 4,  -1, 0, $00, $0
	dsprite  -4, 4,   0, 0, $00, X_FLIP
	dsprite  -3, 4,  -1, 0, $01, $0
	dsprite  -3, 4,   0, 0, $01, X_FLIP
	dsprite  -2, 4,  -1, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $02, $0

.OAMData_2c:
	dsprite  -5, 4,  -1, 0, $00, $0
	dsprite  -5, 4,   0, 0, $00, X_FLIP
	dsprite  -4, 4,  -1, 0, $01, $0
	dsprite  -4, 4,   0, 0, $01, X_FLIP
	dsprite  -3, 4,  -1, 4, $02, $0
	dsprite  -2, 4,  -1, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $02, $0

.OAMData_2d:
	dsprite  -6, 4,  -1, 0, $00, $0
	dsprite  -6, 4,   0, 0, $00, X_FLIP
	dsprite  -5, 4,  -1, 0, $01, $0
	dsprite  -5, 4,   0, 0, $01, X_FLIP
	dsprite  -4, 4,  -1, 4, $02, $0
	dsprite  -3, 4,  -1, 4, $02, $0
	dsprite  -2, 4,  -1, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $02, $0

.OAMData_2e:
	dsprite  -7, 4,  -1, 0, $00, $0
	dsprite  -7, 4,   0, 0, $00, X_FLIP
	dsprite  -6, 4,  -1, 0, $01, $0
	dsprite  -6, 4,   0, 0, $01, X_FLIP
	dsprite  -5, 4,  -1, 4, $02, $0
	dsprite  -4, 4,  -1, 4, $02, $0
	dsprite  -3, 4,  -1, 4, $02, $0
	dsprite  -2, 4,  -1, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $02, $0

.OAMData_2f:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, X_FLIP
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $00, X_FLIP | Y_FLIP

.OAMData_30:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $01, X_FLIP | Y_FLIP
	dsprite   0, 0,   0, 0, $00, X_FLIP | Y_FLIP

.OAMData_31:
	dsprite  -2, 4,  -1, 0, $00, $0
	dsprite  -2, 4,   0, 0, $01, $0
	dsprite  -1, 4,  -1, 0, $02, $0
	dsprite  -1, 4,   0, 0, $03, $0
	dsprite   0, 4,  -1, 0, $04, $0
	dsprite   0, 4,   0, 0, $05, $0

.OAMData_76:
	dsprite  -1, 5,  -1, 0, $00, $0
	dsprite  -1, 1,   0, 0, $00, $0

.OAMData_32:
	dsprite  -1, 0,  -2, 4, $00, $0
	dsprite  -1, 0,   0, 4, $00, $0
	dsprite  -3, 0,  -2, 4, $00, $0
	dsprite  -3, 0,   0, 4, $00, $0
	dsprite  -2, 0,  -3, 4, $00, $0
	dsprite  -2, 0,  -2, 4, $01, $0
	dsprite  -2, 0,  -1, 4, $00, $0
	dsprite  -2, 0,   0, 4, $01, $0
	dsprite  -2, 0,   1, 4, $00, $0
	dsprite  -1, 0,  -4, 4, $00, $0
	dsprite  -1, 0,  -3, 4, $01, $0
	dsprite  -1, 0,  -1, 4, $01, $0
	dsprite  -1, 0,   1, 4, $01, $0
	dsprite  -1, 0,   2, 4, $00, $0

.OAMData_33:
	dsprite  -2, 0,  -2, 4, $00, $0
	dsprite  -2, 0,   0, 4, $00, $0
	dsprite  -1, 0,  -3, 4, $00, $0
	dsprite  -1, 0,  -2, 4, $01, $0
	dsprite  -1, 0,  -1, 4, $00, $0
	dsprite  -1, 0,   0, 4, $01, $0
	dsprite  -1, 0,   1, 4, $00, $0
	dsprite  -4, 0,  -2, 4, $00, $0
	dsprite  -4, 0,   0, 4, $00, $0
	dsprite  -3, 0,  -3, 4, $00, $0
	dsprite  -3, 0,  -2, 4, $01, $0
	dsprite  -3, 0,  -1, 4, $00, $0
	dsprite  -3, 0,   0, 4, $01, $0
	dsprite  -3, 0,   1, 4, $00, $0
	dsprite  -2, 0,  -4, 4, $00, $0
	dsprite  -2, 0,  -3, 4, $01, $0
	dsprite  -2, 0,  -1, 4, $01, $0
	dsprite  -2, 0,   1, 4, $01, $0
	dsprite  -2, 0,   2, 4, $00, $0
	dsprite  -1, 0,  -4, 4, $01, $0
	dsprite  -1, 0,   2, 4, $01, $0

.OAMData_36:
	dsprite  -7, 4,  -1, 0, $00, $0
	dsprite  -7, 4,   0, 0, $01, $0
	dsprite  -6, 4,  -1, 0, $02, $0
	dsprite  -6, 4,   0, 0, $03, $0
	dsprite  -5, 4,  -1, 0, $04, $0
	dsprite  -5, 4,   0, 0, $05, $0
	dsprite  -4, 4,  -1, 0, $06, $0
	dsprite  -4, 4,   0, 0, $07, $0
	dsprite  -3, 4,  -1, 0, $08, $0
	dsprite  -3, 4,   0, 0, $09, $0
	dsprite  -2, 4,  -1, 0, $0a, $0
	dsprite  -2, 4,   0, 0, $0b, $0
	dsprite  -1, 4,  -1, 0, $0c, $0
	dsprite  -1, 4,   0, 0, $0d, $0

.OAMData_3a:
	dsprite  -7, 4,  -1, 0, $0c, $0
	dsprite  -7, 4,   0, 0, $0d, $0
	dsprite  -6, 4,  -1, 0, $08, $0
	dsprite  -6, 4,   0, 0, $09, $0
	dsprite  -5, 4,  -1, 0, $04, $0
	dsprite  -5, 4,   0, 0, $05, $0
	dsprite  -4, 4,  -1, 0, $00, $0
	dsprite  -4, 4,   0, 0, $01, $0
	dsprite  -3, 4,  -1, 0, $02, $0
	dsprite  -3, 4,   0, 0, $03, $0
	dsprite  -2, 4,   0, 0, $02, $0
	dsprite  -2, 4,   1, 0, $03, $0
	dsprite  -1, 4,   0, 0, $0a, $0
	dsprite  -1, 4,   1, 0, $0b, $0

.OAMData_3e:
	dsprite   1, 4,  -2, 0, $00, Y_FLIP
	dsprite   1, 4,  -1, 0, $02, Y_FLIP
	dsprite   1, 4,   0, 0, $02, X_FLIP | Y_FLIP
	dsprite   1, 4,   1, 0, $00, X_FLIP | Y_FLIP
	dsprite  -1, 4,  -3, 0, $09, X_FLIP
	dsprite  -1, 4,  -2, 0, $08, X_FLIP
	dsprite  -1, 4,  -1, 0, $06, $0
	dsprite  -1, 4,   0, 0, $07, $0
	dsprite  -1, 4,   1, 0, $08, $0
	dsprite  -1, 4,   2, 0, $09, $0
	dsprite   0, 4,  -3, 0, $01, X_FLIP
	dsprite   0, 4,  -2, 0, $00, X_FLIP
	dsprite   0, 4,  -1, 0, $0c, $0
	dsprite   0, 4,   0, 0, $0d, $0
	dsprite   0, 4,   1, 0, $00, $0
	dsprite   0, 4,   2, 0, $01, $0
	dsprite  -3, 4,  -2, 0, $00, $0
	dsprite  -3, 4,  -1, 0, $02, $0
	dsprite  -3, 4,   0, 0, $02, X_FLIP
	dsprite  -3, 4,   1, 0, $00, X_FLIP
	dsprite  -2, 4,  -3, 0, $03, X_FLIP
	dsprite  -2, 4,  -2, 0, $02, X_FLIP
	dsprite  -2, 4,  -1, 0, $04, $0
	dsprite  -2, 4,   0, 0, $05, $0
	dsprite  -2, 4,   1, 0, $02, $0
	dsprite  -2, 4,   2, 0, $03, $0

.OAMData_41:
	dsprite  -3, 4,  -2, 0, $00, $0
	dsprite  -3, 4,  -1, 0, $02, $0
	dsprite  -3, 4,   0, 0, $02, X_FLIP
	dsprite  -3, 4,   1, 0, $00, X_FLIP
	dsprite  -2, 4,  -3, 4, $00, $0
	dsprite  -2, 4,  -2, 4, $01, $0
	dsprite  -2, 4,  -1, 0, $05, X_FLIP
	dsprite  -2, 4,   0, 0, $04, X_FLIP
	dsprite  -2, 4,   0, 4, $01, X_FLIP
	dsprite  -2, 4,   1, 4, $00, X_FLIP
	dsprite  -1, 4,  -3, 4, $02, $0
	dsprite  -1, 4,  -2, 4, $03, $0
	dsprite  -1, 4,  -1, 0, $07, X_FLIP
	dsprite  -1, 4,   0, 0, $06, X_FLIP
	dsprite  -1, 4,   0, 4, $03, X_FLIP
	dsprite  -1, 4,   1, 4, $02, X_FLIP
	dsprite   0, 4,  -3, 4, $04, $0
	dsprite   0, 4,  -2, 4, $05, $0
	dsprite   0, 4,  -1, 0, $0d, X_FLIP
	dsprite   0, 4,   0, 0, $0c, X_FLIP
	dsprite   0, 4,   0, 4, $05, X_FLIP
	dsprite   0, 4,   1, 4, $04, X_FLIP
	dsprite   1, 4,  -2, 0, $00, Y_FLIP
	dsprite   1, 4,  -1, 0, $02, Y_FLIP
	dsprite   1, 4,   0, 0, $02, X_FLIP | Y_FLIP
	dsprite   1, 4,   1, 0, $00, X_FLIP | Y_FLIP

.OAMData_42:
	dsprite  -3, 0,  -1, 4, $02, $0
	dsprite   2, 0,  -1, 4, $02, X_FLIP | Y_FLIP
	dsprite  -1, 4,  -3, 0, $01, $0
	dsprite  -1, 4,   2, 0, $01, X_FLIP | Y_FLIP
	dsprite  -4, 0,  -1, 4, $02, $0
	dsprite   3, 0,  -1, 4, $02, X_FLIP | Y_FLIP
	dsprite  -1, 4,  -4, 0, $01, $0
	dsprite  -1, 4,   3, 0, $01, X_FLIP | Y_FLIP

.OAMData_44:
	dsprite  -3, 5,  -3, 5, $00, X_FLIP
	dsprite  -3, 5,   1, 3, $00, $0
	dsprite   1, 3,  -3, 5, $00, X_FLIP | Y_FLIP
	dsprite   1, 3,   1, 3, $00, Y_FLIP
	dsprite  -4, 5,  -4, 5, $00, X_FLIP
	dsprite  -4, 5,   2, 3, $00, $0
	dsprite   2, 3,  -4, 5, $00, X_FLIP | Y_FLIP
	dsprite   2, 3,   2, 3, $00, Y_FLIP

.OAMData_46:
	dsprite  -3, 4,  -1, 4, $02, $0
	dsprite   1, 4,  -1, 4, $02, X_FLIP | Y_FLIP
	dsprite  -1, 4,  -3, 4, $01, $0
	dsprite  -1, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_47:
	dsprite  -2, 0,  -2, 0, $00, X_FLIP
	dsprite  -2, 0,   1, 0, $00, $0
	dsprite   1, 0,  -2, 0, $00, X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, Y_FLIP

.OAMData_48:
	dsprite  -3, 0,  -1, 4, $00, $0
	dsprite  -2, 0,  -1, 2, $00, $0
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite   0, 0,  -1, 0, $00, $0
	dsprite   1, 0,  -1, 2, $00, $0
	dsprite   2, 0,  -1, 4, $00, $0

.OAMData_49:
	dsprite  -1, 4,  -2, 0, $00, X_FLIP
	dsprite  -1, 2,  -1, 0, $00, X_FLIP
	dsprite  -1, 2,   0, 0, $00, $0
	dsprite  -1, 4,   1, 0, $00, $0

.OAMData_4a:
	dsprite  -1, 4,  -1, 0, $00, X_FLIP | Y_FLIP
	dsprite  -1, 4,   0, 0, $00, Y_FLIP

.OAMData_0f:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 4,  -2, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $01, X_FLIP
	dsprite   0, 4,  -2, 4, $01, Y_FLIP
	dsprite   0, 4,  -1, 4, $01, X_FLIP | Y_FLIP

.OAMData_4c:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   0, 2,  -3, 6, $01, $0
	dsprite   0, 2,  -2, 6, $01, X_FLIP
	dsprite   1, 2,  -3, 6, $01, Y_FLIP
	dsprite   1, 2,  -2, 6, $01, X_FLIP | Y_FLIP

.OAMData_4d:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 0,  -3, 0, $01, $0
	dsprite   1, 0,  -2, 0, $01, X_FLIP
	dsprite   2, 0,  -3, 0, $01, Y_FLIP
	dsprite   2, 0,  -2, 0, $01, X_FLIP | Y_FLIP

.OAMData_4f:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   1, 6,  -4, 2, $01, $0
	dsprite   1, 6,  -3, 2, $01, X_FLIP
	dsprite   2, 6,  -4, 2, $01, Y_FLIP
	dsprite   2, 6,  -3, 2, $01, X_FLIP | Y_FLIP

.OAMData_50:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   2, 4,  -5, 4, $01, $0
	dsprite   2, 4,  -4, 4, $01, X_FLIP
	dsprite   3, 4,  -5, 4, $01, Y_FLIP
	dsprite   3, 4,  -4, 4, $01, X_FLIP | Y_FLIP

.OAMData_51:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   3, 2,  -5, 6, $00, $0
	dsprite   3, 2,  -6, 6, $01, $0
	dsprite   3, 2,  -5, 6, $01, X_FLIP
	dsprite   4, 2,  -6, 6, $01, Y_FLIP
	dsprite   4, 2,  -5, 6, $01, X_FLIP | Y_FLIP

.OAMData_59:
	dsprite  -1, 4,  -2, 0, $00, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $01, X_FLIP
	dsprite  -1, 4,   1, 0, $00, X_FLIP

.OAMData_5a:
	dsprite  -1, 4,  -2, 0, $02, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $01, X_FLIP
	dsprite  -1, 4,   1, 0, $02, X_FLIP

.OAMData_60:
	dsprite  -1, 0,  -1, 4, $00, $0

.OAMData_69:
	dsprite   0, 0,  -1, 4, $00, $0

.OAMData_61:
	dsprite  -1, 4,  -4, 4, $00, $0
	dsprite  -1, 4,  -3, 4, $01, $0
	dsprite  -1, 4,  -2, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $03, $0
	dsprite  -1, 4,   0, 4, $04, $0
	dsprite  -1, 4,   1, 4, $05, $0
	dsprite  -1, 4,   2, 4, $06, $0
	dsprite  -2, 4,   1, 4, $07, $0
	dsprite  -2, 4,   2, 4, $08, $0

.OAMData_65:
	dsprite  -2, 4,  -4, 4, $08, X_FLIP
	dsprite  -2, 4,  -3, 4, $07, X_FLIP
	dsprite  -1, 4,  -4, 4, $06, X_FLIP
	dsprite  -1, 4,  -3, 4, $05, X_FLIP
	dsprite  -1, 4,  -2, 4, $04, X_FLIP
	dsprite  -1, 4,  -1, 4, $03, X_FLIP
	dsprite  -1, 4,   0, 4, $02, X_FLIP
	dsprite  -1, 4,   1, 4, $01, X_FLIP
	dsprite  -1, 4,   2, 4, $00, X_FLIP

.OAMData_d4:
	dsprite   0, 0,  -4, 4, $00, OBP_NUM
	dsprite   0, 0,  -3, 4, $01, OBP_NUM
	dsprite   0, 0,  -2, 4, $02, OBP_NUM
	dsprite   0, 0,  -1, 4, $03, OBP_NUM
	dsprite   0, 0,   0, 4, $04, OBP_NUM
	dsprite   0, 0,   1, 4, $05, OBP_NUM
	dsprite   0, 0,   2, 4, $06, OBP_NUM

.OAMData_d6:
	dsprite  -1, 0,  -4, 4, $00, OBP_NUM
	dsprite   0, 0,  -4, 4, $01, OBP_NUM
	dsprite  -1, 0,  -3, 4, $02, OBP_NUM
	dsprite   0, 0,  -3, 4, $03, OBP_NUM
	dsprite  -1, 0,  -2, 4, $04, OBP_NUM
	dsprite   0, 0,  -2, 4, $05, OBP_NUM
	dsprite  -1, 0,  -1, 4, $06, OBP_NUM
	dsprite   0, 0,  -1, 4, $07, OBP_NUM
	dsprite  -1, 0,   0, 4, $08, OBP_NUM
	dsprite   0, 0,   0, 4, $09, OBP_NUM
	dsprite  -1, 0,   1, 4, $0a, OBP_NUM
	dsprite   0, 0,   1, 4, $0b, OBP_NUM
	dsprite  -1, 0,   2, 4, $0c, OBP_NUM
	dsprite   0, 0,   2, 4, $0d, OBP_NUM

.OAMData_d5:
	dsprite   0, 0,  -3, 0, $00, $1 | OBP_NUM
	dsprite   0, 0,  -2, 0, $01, $1 | OBP_NUM
	dsprite   0, 0,  -1, 0, $02, $1 | OBP_NUM
	dsprite   0, 0,   0, 0, $03, $1 | OBP_NUM
	dsprite   0, 0,   1, 0, $04, $1 | OBP_NUM
	dsprite   0, 0,   2, 0, $05, $1 | OBP_NUM

.OAMData_d7:
	dsprite   0, 0,  -3, 0, $00, $1 | OBP_NUM
	dsprite   1, 0,  -3, 0, $01, $1 | OBP_NUM
	dsprite   0, 0,  -2, 0, $02, $1 | OBP_NUM
	dsprite   1, 0,  -2, 0, $03, $1 | OBP_NUM
	dsprite   0, 0,  -1, 0, $04, $1 | OBP_NUM
	dsprite   1, 0,  -1, 0, $05, $1 | OBP_NUM
	dsprite   0, 0,   0, 0, $06, $1 | OBP_NUM
	dsprite   1, 0,   0, 0, $07, $1 | OBP_NUM
	dsprite   0, 0,   1, 0, $08, $1 | OBP_NUM
	dsprite   1, 0,   1, 0, $09, $1 | OBP_NUM
	dsprite   0, 0,   2, 0, $0a, $1 | OBP_NUM
	dsprite   1, 0,   2, 0, $0b, $1 | OBP_NUM

.OAMData_Hail:
	dsprite  -2, 0, -13, 4, $04, $0
	dsprite  -4, 0, -11, 4, $04, $0
	dsprite  -1, 0,  -9, 4, $04, $0
	dsprite  -5, 0,  -7, 4, $04, $0
	dsprite  -3, 0,  -5, 4, $04, $0
	dsprite  -5, 0,  -3, 4, $04, $0
	dsprite  -3, 0,  -1, 4, $04, $0
	dsprite  -3, 0,   0, 4, $04, $0
	dsprite  -5, 0,   2, 4, $04, $0
	dsprite   0, 0,   4, 4, $04, $0
	dsprite  -2, 0,   6, 4, $04, $0
	dsprite  -4, 0,   8, 4, $04, $0
	dsprite  -2, 0,  10, 4, $04, $0

.OAMData_6e:
	dsprite  -2, 4,   0, 4, $00, $0
	dsprite  -1, 4,  -2, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $02, $0
	dsprite  -1, 4,   0, 4, $03, $0
	dsprite   0, 4,  -2, 4, $04, $0

.OAMData_6f:
	dsprite  -1, 4,  -2, 4, $00, $0
	dsprite  -1, 4,  -1, 4, $01, $0
	dsprite  -1, 4,   0, 4, $02, $0

.OAMData_77:
	dsprite  -4, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_78:
	dsprite  -4, 4,   1, 4, $00, $0
	dsprite  -4, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite  -3, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_79:
	dsprite  -4, 4,   1, 4, $01, $0
	dsprite  -4, 4,   0, 4, $00, $0
	dsprite  -4, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite  -3, 4,   1, 4, $00, $0
	dsprite  -3, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite  -2, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_7a:
	dsprite  -4, 4,  -2, 4, $01, X_FLIP | Y_FLIP
	dsprite  -4, 4,  -1, 4, $00, $0
	dsprite  -4, 4,   0, 4, $01, $0
	dsprite  -3, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite  -3, 4,   0, 4, $00, $0
	dsprite  -3, 4,   1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite  -2, 4,   1, 4, $00, $0
	dsprite  -1, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_7b:
	dsprite  -4, 4,  -3, 4, $01, X_FLIP | Y_FLIP
	dsprite  -4, 4,  -2, 4, $00, $0
	dsprite  -4, 4,  -1, 4, $01, $0
	dsprite  -3, 4,  -2, 4, $01, X_FLIP | Y_FLIP
	dsprite  -3, 4,  -1, 4, $00, $0
	dsprite  -3, 4,   0, 4, $01, $0
	dsprite  -2, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite  -2, 4,   0, 4, $00, $0
	dsprite  -2, 4,   1, 4, $01, $0
	dsprite  -1, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite  -1, 4,   1, 4, $00, $0
	dsprite   0, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_7c:
	dsprite  -4, 4,  -3, 4, $00, $0
	dsprite  -4, 4,  -2, 4, $01, $0
	dsprite  -3, 4,  -3, 4, $01, X_FLIP | Y_FLIP
	dsprite  -3, 4,  -2, 4, $00, $0
	dsprite  -3, 4,  -1, 4, $01, $0
	dsprite  -2, 4,  -2, 4, $01, X_FLIP | Y_FLIP
	dsprite  -2, 4,  -1, 4, $00, $0
	dsprite  -2, 4,   0, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite  -1, 4,   0, 4, $00, $0
	dsprite  -1, 4,   1, 4, $01, $0
	dsprite   0, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite   0, 4,   1, 4, $00, $0
	dsprite   1, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_7d:
	dsprite  -4, 4,  -3, 4, $01, $0
	dsprite  -3, 4,  -3, 4, $00, $0
	dsprite  -3, 4,  -2, 4, $01, $0
	dsprite  -2, 4,  -3, 4, $01, X_FLIP | Y_FLIP
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -1, 4,  -2, 4, $01, X_FLIP | Y_FLIP
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 4,   0, 4, $01, $0
	dsprite   0, 4,  -1, 4, $01, X_FLIP | Y_FLIP
	dsprite   0, 4,   0, 4, $00, $0
	dsprite   0, 4,   1, 4, $01, $0
	dsprite   1, 4,   0, 4, $01, X_FLIP | Y_FLIP
	dsprite   1, 4,   1, 4, $00, $0
	dsprite   2, 4,   1, 4, $01, X_FLIP | Y_FLIP

.OAMData_70:
	dsprite  -2, 0,  -1, 0, $00, $0
	dsprite  -1, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $00, X_FLIP
	dsprite  -1, 0,   0, 0, $01, X_FLIP
	dsprite   0, 0,  -1, 0, $01, Y_FLIP
	dsprite   1, 0,  -1, 0, $00, Y_FLIP
	dsprite   0, 0,   0, 0, $01, X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $00, X_FLIP | Y_FLIP


.OAMData_87:
	dsprite  -2, 4,  -1, 0, $00, $0
	dsprite  -2, 4,   0, 0, $01, $0
	dsprite  -1, 4,  -1, 0, $02, $0
	dsprite  -1, 4,   0, 0, $03, $0
	dsprite  -1, 4,  -1, 0, $00, $0
	dsprite  -1, 4,   0, 0, $01, $0
	dsprite   0, 4,  -1, 0, $02, $0
	dsprite   0, 4,   0, 0, $03, $0
	dsprite  -3, 4,  -1, 0, $00, $0
	dsprite  -3, 4,   0, 0, $01, $0
	dsprite  -2, 4,  -1, 0, $02, $0
	dsprite  -2, 4,   0, 0, $03, $0
	dsprite   0, 4,  -1, 0, $00, $0
	dsprite   0, 4,   0, 0, $01, $0
	dsprite   1, 4,  -1, 0, $02, $0
	dsprite   1, 4,   0, 0, $03, $0

.OAMData_88:
	dsprite  -2, 0,  -1, 0, $00, $0
	dsprite  -2, 0,   0, 0, $01, $0
	dsprite  -1, 0,  -1, 0, $02, $0
	dsprite  -1, 0,   0, 0, $03, $0
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $02, $0
	dsprite   0, 0,   0, 0, $03, $0
	dsprite   0, 0,  -1, 0, $00, $0
	dsprite   0, 0,   0, 0, $01, $0
	dsprite   1, 0,  -1, 0, $02, $0
	dsprite   1, 0,   0, 0, $03, $0

.OAMData_8a:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 0,   0, 4, $00, $0
	dsprite  -2, 4,   1, 4, $00, $0
	dsprite  -2, 0,   2, 4, $00, $0
	dsprite  -3, 4,   3, 4, $00, $0
	dsprite  -3, 0,   4, 4, $00, $0
	dsprite  -4, 0,   5, 4, $00, $0
	dsprite  -5, 4,   6, 4, $00, $0

.OAMData_8e:
	dsprite  -3, 4,  -1, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $02, $0
	dsprite   0, 4,  -1, 4, $01, Y_FLIP
	dsprite   1, 4,  -1, 4, $00, Y_FLIP

.OAMData_8f:
	dsprite  -1, 4,  -2, 0, $00, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $02, $0
	dsprite  -1, 4,   1, 0, $03, $0

.OAMData_93:
	dsprite  -1, 0,  -2, 4, $00, $0
	dsprite  -1, 0,  -1, 4, $01, $0
	dsprite  -1, 0,   0, 4, $02, $0
	dsprite   0, 0,  -2, 4, $03, $0
	dsprite   0, 0,  -1, 4, $04, $0
	dsprite   0, 0,   0, 4, $05, $0

.OAMData_99:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $05, $0
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $05, $0

.OAMData_9b:
	dsprite  -4, 4,   1, 0, $00, $0
	dsprite  -4, 4,   2, 0, $01, $0
	dsprite  -3, 4,  -1, 0, $02, $0
	dsprite  -3, 4,   0, 0, $03, $0
	dsprite  -3, 4,   1, 0, $04, $0
	dsprite  -3, 4,   2, 0, $05, $0
	dsprite  -3, 4,   3, 0, $06, $0
	dsprite  -2, 4,  -2, 0, $07, $0
	dsprite  -2, 4,  -1, 0, $08, $0
	dsprite  -2, 4,   0, 0, $09, $0
	dsprite  -2, 4,   1, 0, $0a, $0
	dsprite  -2, 4,   2, 0, $0b, $0
	dsprite  -2, 4,   3, 0, $0c, $0
	dsprite  -2, 4,   4, 0, $0d, $0
	dsprite  -1, 4,  -3, 0, $0e, $0
	dsprite  -1, 4,  -2, 0, $0f, $0
	dsprite  -1, 4,  -1, 0, $10, $0
	dsprite  -1, 4,   0, 0, $11, $0
	dsprite  -1, 4,   1, 0, $12, $0
	dsprite  -1, 4,   2, 0, $13, $0
	dsprite   0, 4,  -5, 0, $14, $0
	dsprite   0, 4,  -4, 0, $15, $0
	dsprite   0, 4,  -3, 0, $16, $0
	dsprite   0, 4,  -2, 0, $17, $0
	dsprite   0, 4,  -1, 0, $18, $0
	dsprite   0, 4,   0, 0, $19, $0
	dsprite   0, 4,   1, 0, $1a, $0
	dsprite   0, 4,   2, 0, $1b, $0
	dsprite   0, 4,   3, 0, $1c, $0
	dsprite   1, 4,  -5, 0, $1d, $0
	dsprite   1, 4,  -4, 0, $1e, $0
	dsprite   1, 4,  -2, 0, $1f, $0
	dsprite   1, 4,  -1, 0, $20, $0
	dsprite   1, 4,   0, 0, $21, $0
	dsprite   1, 4,   1, 0, $22, $0
	dsprite   2, 4,   0, 0, $23, $0

.OAMData_9c:
	dsprite   0, 4,  -1, 0, $02, $0
	dsprite   0, 4,   0, 0, $03, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $01, X_FLIP
	dsprite  -2, 4,  -1, 0, $00, $0
	dsprite  -2, 4,   0, 0, $00, X_FLIP

.OAMData_9f:
	dsprite  -1, 0,  -2, 0, $00, $0
	dsprite  -1, 0,  -1, 0, $01, $0
	dsprite  -1, 0,   0, 0, $02, $0
	dsprite  -1, 0,   1, 0, $03, $0
	dsprite   0, 0,  -2, 0, $04, $0
	dsprite   0, 0,  -1, 0, $05, $0
	dsprite   0, 0,   0, 0, $06, $0
	dsprite   0, 0,   1, 0, $07, $0

.OAMData_a0:
	dsprite  -2, 4,  -1, 4, $00, $0
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 4,  -1, 4, $00, $0
	dsprite  -3, 4,  -1, 4, $00, $0
	dsprite   1, 4,  -1, 4, $00, $0
	dsprite  -4, 4,  -1, 4, $00, $0
	dsprite   2, 4,  -1, 4, $00, $0

.OAMData_a4:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $02, $0
	dsprite  -1, 4,  -2, 4, $03, $0
	dsprite  -1, 4,  -1, 4, $04, $0
	dsprite  -1, 4,   0, 4, $05, $0
	dsprite   0, 4,  -2, 4, $00, Y_FLIP
	dsprite   0, 4,  -1, 4, $01, Y_FLIP
	dsprite   0, 4,   0, 4, $02, Y_FLIP


.OAMData_bc:
	dsprite  -1, 4,  -3, 0, $00, $0
	dsprite  -1, 4,  -2, 0, $01, $0
	dsprite  -1, 4,  -1, 0, $02, $0
	dsprite  -1, 4,   0, 0, $02, X_FLIP
	dsprite  -1, 4,   1, 0, $01, X_FLIP
	dsprite  -1, 4,   2, 0, $00, X_FLIP

.OAMData_c1:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $02, $0
	dsprite  -2, 0,   1, 0, $00, X_FLIP
	dsprite  -1, 0,  -2, 0, $03, $0
	dsprite  -1, 0,  -1, 0, $04, $0
	dsprite  -1, 0,   0, 0, $04, X_FLIP
	dsprite  -1, 0,   1, 0, $05, $0
	dsprite   0, 0,  -2, 0, $05, X_FLIP | Y_FLIP
	dsprite   0, 0,  -1, 0, $04, Y_FLIP
	dsprite   0, 0,   0, 0, $04, X_FLIP | Y_FLIP
	dsprite   0, 0,   1, 0, $03, X_FLIP | Y_FLIP
	dsprite   1, 0,  -2, 0, $00, Y_FLIP
	dsprite   1, 0,  -1, 0, $02, X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $01, X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, X_FLIP | Y_FLIP

.OAMData_c2:
	dsprite  -1, 0,  -2, 0, $00, $0
	dsprite  -1, 0,  -1, 0, $01, $0
	dsprite  -1, 0,   0, 0, $00, X_FLIP | Y_FLIP
	dsprite   0, 0,  -1, 0, $00, $0
	dsprite   0, 0,   0, 0, $01, $0
	dsprite   0, 0,   1, 0, $00, X_FLIP | Y_FLIP

.OAMData_c8:
	dsprite  -1, 0,   1, 4, $00, $0
	dsprite  -1, 0,   2, 4, $01, $0
	dsprite   0, 0,  -1, 4, $02, $0
	dsprite   0, 0,   0, 4, $03, $0
	dsprite   0, 0,   1, 4, $04, $0
	dsprite   0, 0,   2, 4, $05, $0

.OAMData_ca:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, X_FLIP | Y_FLIP
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $01, X_FLIP

.OAMData_cc:
	dsprite  -2, 0, -13, 4, $00, $0
	dsprite  -4, 0, -11, 4, $00, $0
	dsprite  -1, 0,  -9, 4, $00, $0
	dsprite  -5, 0,  -7, 4, $00, $0
	dsprite  -3, 0,  -5, 4, $00, $0
	dsprite  -5, 0,  -3, 4, $00, $0
	dsprite  -3, 0,  -1, 4, $00, $0
	dsprite  -3, 0,   0, 4, $00, $0
	dsprite  -5, 0,   2, 4, $00, $0
	dsprite   0, 0,   4, 4, $00, $0
	dsprite  -2, 0,   6, 4, $00, $0
	dsprite  -4, 0,   8, 4, $00, $0
	dsprite  -2, 0,  10, 4, $00, $0

.OAMData_Stats:
	dsprite  -1, 0,  -3, 0, $00, $0
	dsprite  -1, 0,  -2, 0, $00, $0
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, $0
	dsprite  -1, 0,   1, 0, $00, $0
	dsprite  -1, 0,   2, 0, $00, $0
	dsprite  -1, 0,   3, 0, $00, $0
	dsprite  -1, 0,   4, 0, $00, $0
	dsprite   0, 0,  -3, 0, $01, $0
	dsprite   0, 0,  -2, 0, $01, $0
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $01, $0
	dsprite   0, 0,   1, 0, $01, $0
	dsprite   0, 0,   2, 0, $01, $0
	dsprite   0, 0,   3, 0, $01, $0
	dsprite   0, 0,   4, 0, $01, $0

.OAMData_02_pc:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, $0 | X_FLIP
	dsprite   0, 0,  -1, 0, $00, $0 | Y_FLIP
	dsprite   0, 0,   0, 0, $00, $0 | X_FLIP | Y_FLIP

.OAMData_01_pc:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $00, $0 | X_FLIP
	dsprite  -1, 4,  -2, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $03, $0
	dsprite  -1, 4,   0, 4, $02, $0 | X_FLIP | Y_FLIP
	dsprite   0, 4,  -2, 4, $00, $0 | Y_FLIP
	dsprite   0, 4,  -1, 4, $01, $0 | X_FLIP | Y_FLIP
	dsprite   0, 4,   0, 4, $00, $0 | X_FLIP | Y_FLIP

.OAMData_59_pc:
	dsprite  -1, 4,  -2, 0, $00, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $01, $0 | X_FLIP
	dsprite  -1, 4,   1, 0, $00, $0 | X_FLIP

.OAMData_0f_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 4,  -2, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $01, $0 | X_FLIP
	dsprite   0, 4,  -2, 4, $01, $0 | Y_FLIP
	dsprite   0, 4,  -1, 4, $01, $0 | X_FLIP | Y_FLIP

.OAMData_dd:

.OAMData_00_pc:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -1, 0,  -2, 0, $02, $0
	dsprite  -1, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $01, $0 | X_FLIP
	dsprite  -2, 0,   1, 0, $00, $0 | X_FLIP
	dsprite  -1, 0,   0, 0, $03, $0 | X_FLIP
	dsprite  -1, 0,   1, 0, $02, $0 | X_FLIP
	dsprite   0, 0,  -2, 0, $02, $0 | Y_FLIP
	dsprite   0, 0,  -1, 0, $03, $0 | Y_FLIP
	dsprite   1, 0,  -2, 0, $00, $0 | Y_FLIP
	dsprite   1, 0,  -1, 0, $01, $0 | Y_FLIP
	dsprite   0, 0,   0, 0, $03, $0 | X_FLIP | Y_FLIP
	dsprite   0, 0,   1, 0, $02, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $01, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, $0 | X_FLIP | Y_FLIP

.OAMData_04_pc:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, $0 | X_FLIP
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $01, $0 | X_FLIP

.OAMData_4c_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   0, 2,  -3, 6, $01, $0
	dsprite   0, 2,  -2, 6, $01, $0 | X_FLIP
	dsprite   1, 2,  -3, 6, $01, $0 | Y_FLIP
	dsprite   1, 2,  -2, 6, $01, $0 | X_FLIP | Y_FLIP

.OAMData_4d_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 0,  -3, 0, $01, $0
	dsprite   1, 0,  -2, 0, $01, $0 | X_FLIP
	dsprite   2, 0,  -3, 0, $01, $0 | Y_FLIP
	dsprite   2, 0,  -2, 0, $01, $0 | X_FLIP | Y_FLIP

.OAMData_4f_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   1, 6,  -4, 2, $01, $0
	dsprite   1, 6,  -3, 2, $01, $0 | X_FLIP
	dsprite   2, 6,  -4, 2, $01, $0 | Y_FLIP
	dsprite   2, 6,  -3, 2, $01, $0 | X_FLIP | Y_FLIP

.OAMData_50_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   2, 4,  -5, 4, $01, $0
	dsprite   2, 4,  -4, 4, $01, $0 | X_FLIP
	dsprite   3, 4,  -5, 4, $01, $0 | Y_FLIP
	dsprite   3, 4,  -4, 4, $01, $0 | X_FLIP | Y_FLIP

.OAMData_51_pc:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   3, 2,  -5, 6, $00, $0
	dsprite   3, 2,  -6, 6, $01, $0
	dsprite   3, 2,  -5, 6, $01, $0 | X_FLIP
	dsprite   4, 2,  -6, 6, $01, $0 | Y_FLIP
	dsprite   4, 2,  -5, 6, $01, $0 | X_FLIP | Y_FLIP

.OAMData_30_pc:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $01, $0 | X_FLIP | Y_FLIP
	dsprite   0, 0,   0, 0, $00, $0 | X_FLIP | Y_FLIP

.OAMData_c1_pc:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $02, $0
	dsprite  -2, 0,   1, 0, $00, $0 | X_FLIP
	dsprite  -1, 0,  -2, 0, $03, $0
	dsprite  -1, 0,  -1, 0, $04, $0
	dsprite  -1, 0,   0, 0, $04, $0 | X_FLIP
	dsprite  -1, 0,   1, 0, $05, $0
	dsprite   0, 0,  -2, 0, $05, $0 | X_FLIP | Y_FLIP
	dsprite   0, 0,  -1, 0, $04, $0 | Y_FLIP
	dsprite   0, 0,   0, 0, $04, $0 | X_FLIP | Y_FLIP
	dsprite   0, 0,   1, 0, $03, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,  -2, 0, $00, $0 | Y_FLIP
	dsprite   1, 0,  -1, 0, $02, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $01, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, $0 | X_FLIP | Y_FLIP

.OAMData_f3:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $03, $0
	dsprite  -2, 4,   0, 4, $06, $0
	dsprite  -1, 4,  -2, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $04, $0
	dsprite  -1, 4,   0, 4, $07, $0
	dsprite   0, 4,  -2, 4, $02, $0
	dsprite   0, 4,  -1, 4, $05, $0
	dsprite   0, 4,   0, 4, $08, $0

.OAMData_70_pc:
	dsprite  -2, 0,  -1, 0, $00, $0
	dsprite  -1, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $00, $0 | X_FLIP
	dsprite  -1, 0,   0, 0, $01, $0 | X_FLIP
	dsprite   0, 0,  -1, 0, $01, $0 | Y_FLIP
	dsprite   1, 0,  -1, 0, $00, $0 | Y_FLIP
	dsprite   0, 0,   0, 0, $01, $0 | X_FLIP | Y_FLIP
	dsprite   1, 0,   0, 0, $00, $0 | X_FLIP | Y_FLIP

.OAMData_HyperVoice:
	dsprite  -3, 0,   0, 0, $00, $0
	dsprite  -2, 0,   0, 0, $01, $0
	dsprite  -1, 0,   0, 0, $06, $0
	dsprite  -3, 0,   1, 0, $00, X_FLIP
	dsprite  -2, 0,   1, 0, $01, X_FLIP
	dsprite  -1, 0,   1, 0, $06, X_FLIP
	dsprite   0, 0,   0, 0, $01, Y_FLIP
	dsprite   1, 0,   0, 0, $00, Y_FLIP
	dsprite   0, 0,   1, 0, $01, X_FLIP | Y_FLIP
	dsprite   1, 0,   1, 0, $00, X_FLIP | Y_FLIP


; --- Volt Switch OAM data (ported from Polished Crystal .OAMData_VoltSwitch1..6) ---
.OAMData_VoltSwitch1:
	dsprite  -2, 0,  -4, 0, $00, $0
	dsprite  -2, 0,  -3, 0, $01, $0
	dsprite  -2, 0,  -2, 0, $02, $0
	dsprite  -2, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $04, $0
	dsprite  -2, 0,   1, 0, $05, $0
	dsprite  -2, 0,   2, 0, $06, $0
	dsprite  -2, 0,   3, 0, $00, X_FLIP
	dsprite  -1, 0,  -4, 0, $00, Y_FLIP
	dsprite  -1, 0,  -3, 0, $01, Y_FLIP
	dsprite  -1, 0,  -2, 0, $02, Y_FLIP
	dsprite  -1, 0,  -1, 0, $03, Y_FLIP
	dsprite  -1, 0,   0, 0, $03, X_FLIP | Y_FLIP
	dsprite  -1, 0,   1, 0, $02, X_FLIP | Y_FLIP
	dsprite  -1, 0,   2, 0, $01, X_FLIP | Y_FLIP
	dsprite  -1, 0,   3, 0, $00, X_FLIP | Y_FLIP

.OAMData_VoltSwitch2:
	dsprite  -2, 0,  -4, 0, $00, $0
	dsprite  -2, 0,  -3, 0, $01, $0
	dsprite  -2, 0,  -2, 0, $02, $0
	dsprite  -2, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $03, X_FLIP
	dsprite  -2, 0,   1, 0, $02, X_FLIP
	dsprite  -2, 0,   2, 0, $07, $0
	dsprite  -2, 0,   3, 0, $08, $0
	dsprite  -1, 0,  -4, 0, $00, Y_FLIP
	dsprite  -1, 0,  -3, 0, $01, Y_FLIP
	dsprite  -1, 0,  -2, 0, $02, Y_FLIP
	dsprite  -1, 0,  -1, 0, $03, Y_FLIP
	dsprite  -1, 0,   0, 0, $03, X_FLIP | Y_FLIP
	dsprite  -1, 0,   1, 0, $09, $0
	dsprite  -1, 0,   2, 0, $0a, $0
	dsprite  -1, 0,   3, 0, $0b, $0

.OAMData_VoltSwitch3:
	dsprite  -2, 0,  -4, 0, $00, $0
	dsprite  -2, 0,  -3, 0, $01, $0
	dsprite  -2, 0,  -2, 0, $02, $0
	dsprite  -2, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $03, X_FLIP
	dsprite  -2, 0,   1, 0, $02, X_FLIP
	dsprite  -2, 0,   2, 0, $01, X_FLIP
	dsprite  -2, 0,   3, 0, $00, X_FLIP
	dsprite  -1, 0,  -4, 0, $00, Y_FLIP
	dsprite  -1, 0,  -3, 0, $01, Y_FLIP
	dsprite  -1, 0,  -2, 0, $02, Y_FLIP
	dsprite  -1, 0,  -1, 0, $03, Y_FLIP
	dsprite  -1, 0,   0, 0, $0c, $0
	dsprite  -1, 0,   1, 0, $0d, $0
	dsprite  -1, 0,   2, 0, $0e, $0
	dsprite  -1, 0,   3, 0, $00, X_FLIP | Y_FLIP

.OAMData_VoltSwitch4:
	dsprite  -2, 0,  -4, 0, $00, $0
	dsprite  -2, 0,  -3, 0, $01, $0
	dsprite  -2, 0,  -2, 0, $02, $0
	dsprite  -2, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $03, X_FLIP
	dsprite  -2, 0,   1, 0, $02, X_FLIP
	dsprite  -2, 0,   2, 0, $01, X_FLIP
	dsprite  -2, 0,   3, 0, $00, X_FLIP
	dsprite  -1, 0,  -4, 0, $00, Y_FLIP
	dsprite  -1, 0,  -3, 0, $0f, $0
	dsprite  -1, 0,  -2, 0, $10, $0
	dsprite  -1, 0,  -1, 0, $11, $0
	dsprite  -1, 0,   0, 0, $12, $0
	dsprite  -1, 0,   1, 0, $02, X_FLIP | Y_FLIP
	dsprite  -1, 0,   2, 0, $01, X_FLIP | Y_FLIP
	dsprite  -1, 0,   3, 0, $00, X_FLIP | Y_FLIP

.OAMData_VoltSwitch5:
	dsprite  -2, 0,  -4, 0, $13, $0
	dsprite  -2, 0,  -3, 0, $14, $0
	dsprite  -2, 0,  -2, 0, $02, $0
	dsprite  -2, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $03, X_FLIP
	dsprite  -2, 0,   1, 0, $02, X_FLIP
	dsprite  -2, 0,   2, 0, $01, X_FLIP
	dsprite  -2, 0,   3, 0, $00, X_FLIP
	dsprite  -1, 0,  -4, 0, $15, $0
	dsprite  -1, 0,  -3, 0, $16, $0
	dsprite  -1, 0,  -2, 0, $17, $0
	dsprite  -1, 0,  -1, 0, $03, Y_FLIP
	dsprite  -1, 0,   0, 0, $03, X_FLIP | Y_FLIP
	dsprite  -1, 0,   1, 0, $02, X_FLIP | Y_FLIP
	dsprite  -1, 0,   2, 0, $01, X_FLIP | Y_FLIP
	dsprite  -1, 0,   3, 0, $00, X_FLIP | Y_FLIP

.OAMData_VoltSwitch6:
	dsprite  -2, 0,  -4, 0, $00, $0
	dsprite  -2, 0,  -3, 0, $18, $0
	dsprite  -2, 0,  -2, 0, $19, $0
	dsprite  -2, 0,  -1, 0, $1a, $0
	dsprite  -2, 0,   0, 0, $1b, $0
	dsprite  -2, 0,   1, 0, $02, X_FLIP
	dsprite  -2, 0,   2, 0, $01, X_FLIP
	dsprite  -2, 0,   3, 0, $00, X_FLIP
	dsprite  -1, 0,  -4, 0, $00, Y_FLIP
	dsprite  -1, 0,  -3, 0, $01, Y_FLIP
	dsprite  -1, 0,  -2, 0, $02, Y_FLIP
	dsprite  -1, 0,  -1, 0, $03, Y_FLIP
	dsprite  -1, 0,   0, 0, $03, X_FLIP | Y_FLIP
	dsprite  -1, 0,   1, 0, $02, X_FLIP | Y_FLIP
	dsprite  -1, 0,   2, 0, $01, X_FLIP | Y_FLIP
	dsprite  -1, 0,   3, 0, $00, X_FLIP | Y_FLIP

.OAMData_00_PCP:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -1, 0,  -2, 0, $02, $0
	dsprite  -1, 0,  -1, 0, $03, $0
	dsprite  -2, 0,   0, 0, $01, $0 | OAM_XFLIP
	dsprite  -2, 0,   1, 0, $00, $0 | OAM_XFLIP
	dsprite  -1, 0,   0, 0, $03, $0 | OAM_XFLIP
	dsprite  -1, 0,   1, 0, $02, $0 | OAM_XFLIP
	dsprite   0, 0,  -2, 0, $02, $0 | OAM_YFLIP
	dsprite   0, 0,  -1, 0, $03, $0 | OAM_YFLIP
	dsprite   1, 0,  -2, 0, $00, $0 | OAM_YFLIP
	dsprite   1, 0,  -1, 0, $01, $0 | OAM_YFLIP
	dsprite   0, 0,   0, 0, $03, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 0,   1, 0, $02, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 0,   0, 0, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 0,   1, 0, $00, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_01_PCP:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $00, $0 | OAM_XFLIP
	dsprite  -1, 4,  -2, 4, $02, $0
	dsprite  -1, 4,  -1, 4, $03, $0
	dsprite  -1, 4,   0, 4, $02, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 4,  -2, 4, $00, $0 | OAM_YFLIP
	dsprite   0, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 4,   0, 4, $00, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_04_PCP:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, $0 | OAM_XFLIP
	dsprite   0, 0,  -1, 0, $01, $0
	dsprite   0, 0,   0, 0, $01, $0 | OAM_XFLIP
.OAMData_0f_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 4,  -2, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $01, $0 | OAM_XFLIP
	dsprite   0, 4,  -2, 4, $01, $0 | OAM_YFLIP
	dsprite   0, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_02_PCP:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $00, $0 | OAM_XFLIP
	dsprite   0, 0,  -1, 0, $00, $0 | OAM_YFLIP
	dsprite   0, 0,   0, 0, $00, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_4c_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   0, 2,  -3, 6, $01, $0
	dsprite   0, 2,  -2, 6, $01, $0 | OAM_XFLIP
	dsprite   1, 2,  -3, 6, $01, $0 | OAM_YFLIP
	dsprite   1, 2,  -2, 6, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_4d_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 0,  -3, 0, $01, $0
	dsprite   1, 0,  -2, 0, $01, $0 | OAM_XFLIP
	dsprite   2, 0,  -3, 0, $01, $0 | OAM_YFLIP
	dsprite   2, 0,  -2, 0, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_4f_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   1, 6,  -4, 2, $01, $0
	dsprite   1, 6,  -3, 2, $01, $0 | OAM_XFLIP
	dsprite   2, 6,  -4, 2, $01, $0 | OAM_YFLIP
	dsprite   2, 6,  -3, 2, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_50_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   2, 4,  -5, 4, $01, $0
	dsprite   2, 4,  -4, 4, $01, $0 | OAM_XFLIP
	dsprite   3, 4,  -5, 4, $01, $0 | OAM_YFLIP
	dsprite   3, 4,  -4, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_51_PCP:
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite   0, 2,  -2, 6, $00, $0
	dsprite   1, 0,  -2, 0, $00, $0
	dsprite   1, 6,  -3, 2, $00, $0
	dsprite   2, 4,  -4, 4, $00, $0
	dsprite   3, 2,  -5, 6, $00, $0
	dsprite   3, 2,  -6, 6, $01, $0
	dsprite   3, 2,  -5, 6, $01, $0 | OAM_XFLIP
	dsprite   4, 2,  -6, 6, $01, $0 | OAM_YFLIP
	dsprite   4, 2,  -5, 6, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_77_PCP:
	dsprite  -4, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_78_PCP:
	dsprite  -4, 4,   1, 4, $00, $0
	dsprite  -4, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -3, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_79_PCP:
	dsprite  -4, 4,   1, 4, $01, $0
	dsprite  -4, 4,   0, 4, $00, $0
	dsprite  -4, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -3, 4,   1, 4, $00, $0
	dsprite  -3, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -2, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_7a_PCP:
	dsprite  -4, 4,  -2, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -4, 4,  -1, 4, $00, $0
	dsprite  -4, 4,   0, 4, $01, $0
	dsprite  -3, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -3, 4,   0, 4, $00, $0
	dsprite  -3, 4,   1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -2, 4,   1, 4, $00, $0
	dsprite  -1, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_7b_PCP:
	dsprite  -4, 4,  -3, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -4, 4,  -2, 4, $00, $0
	dsprite  -4, 4,  -1, 4, $01, $0
	dsprite  -3, 4,  -2, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -3, 4,  -1, 4, $00, $0
	dsprite  -3, 4,   0, 4, $01, $0
	dsprite  -2, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -2, 4,   0, 4, $00, $0
	dsprite  -2, 4,   1, 4, $01, $0
	dsprite  -1, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -1, 4,   1, 4, $00, $0
	dsprite   0, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_7c_PCP:
	dsprite  -4, 4,  -3, 4, $00, $0
	dsprite  -4, 4,  -2, 4, $01, $0
	dsprite  -3, 4,  -3, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -3, 4,  -2, 4, $00, $0
	dsprite  -3, 4,  -1, 4, $01, $0
	dsprite  -2, 4,  -2, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -2, 4,  -1, 4, $00, $0
	dsprite  -2, 4,   0, 4, $01, $0
	dsprite  -1, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -1, 4,   0, 4, $00, $0
	dsprite  -1, 4,   1, 4, $01, $0
	dsprite   0, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 4,   1, 4, $00, $0
	dsprite   1, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_7d_PCP:
	dsprite  -4, 4,  -3, 4, $01, $0
	dsprite  -3, 4,  -3, 4, $00, $0
	dsprite  -3, 4,  -2, 4, $01, $0
	dsprite  -2, 4,  -3, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -1, 4,  -2, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite  -1, 4,  -1, 4, $00, $0
	dsprite  -1, 4,   0, 4, $01, $0
	dsprite   0, 4,  -1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 4,   0, 4, $00, $0
	dsprite   0, 4,   1, 4, $01, $0
	dsprite   1, 4,   0, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 4,   1, 4, $00, $0
	dsprite   2, 4,   1, 4, $01, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_85:
	dbsprite  -2,  -2, 0, 0, $00, $0
	dbsprite  -1,  -2, 0, 0, $01, $0
	dbsprite   0,  -2, 0, 0, $02, $0
	dbsprite   1,  -2, 0, 0, $03, $0
	dbsprite  -2,  -1, 0, 0, $04, $0
	dbsprite  -1,  -1, 0, 0, $05, $0
	dbsprite   0,  -1, 0, 0, $06, $0
	dbsprite   1,  -1, 0, 0, $07, $0
	dbsprite  -1,   0, 0, 0, $08, $0
	dbsprite   0,   0, 0, 0, $09, $0
	dbsprite   1,   0, 0, 0, $0a, $0
	dbsprite  -1,   1, 0, 0, $0b, $0
	dbsprite   0,   1, 0, 0, $0c, $0
	dbsprite   1,   1, 0, 0, $0d, $0
.OAMData_95:
	dbsprite   0,  -2, 0, 0, $00, $0
	dbsprite  -2,  -1, 0, 0, $01, $0
	dbsprite  -1,  -1, 0, 0, $02, $0
	dbsprite   0,  -1, 0, 0, $03, $0
	dbsprite   1,  -1, 0, 0, $04, $0
	dbsprite  -2,   0, 0, 0, $05, $0
	dbsprite  -1,   0, 0, 0, $06, $0
	dbsprite   0,   0, 0, 0, $07, $0
	dbsprite   1,   0, 0, 0, $08, $0
	dbsprite  -2,   1, 0, 0, $09, $0
	dbsprite  -1,   1, 0, 0, $0a, $0
	dbsprite   0,   1, 0, 0, $0b, $0
	dbsprite   1,   1, 0, 0, $0c, $0
.OAMData_59_PCP:
	dsprite  -1, 4,  -2, 0, $00, $0
	dsprite  -1, 4,  -1, 0, $01, $0
	dsprite  -1, 4,   0, 0, $01, $0 | OAM_XFLIP
	dsprite  -1, 4,   1, 0, $00, $0 | OAM_XFLIP
.OAMData_b9:
	dbsprite  -1,  -2, 0, 0, $00, $0
	dbsprite   0,  -2, 0, 0, $01, $0
	dbsprite   1,  -2, 0, 0, $02, $0
	dbsprite  -1,  -1, 0, 0, $03, $0
	dbsprite   0,  -1, 0, 0, $04, $0
	dbsprite   1,  -1, 0, 0, $05, $0
	dbsprite  -2,   0, 0, 0, $06, $0
	dbsprite  -1,   0, 0, 0, $07, $0
	dbsprite   0,   0, 0, 0, $08, $0
	dbsprite   1,   0, 0, 0, $09, $0
	dbsprite  -2,   1, 0, 0, $0a, $0
	dbsprite  -1,   1, 0, 0, $0b, $0
	dbsprite   0,   1, 0, 0, $0c, $0
	dbsprite   1,   1, 0, 0, $0d, $0

.OAMData_bd:
	dbsprite  -2,  -2, 0, 0, $00, $0
	dbsprite  -1,  -2, 0, 0, $01, $0
	dbsprite  -2,  -1, 0, 0, $02, $0
	dbsprite  -1,  -1, 0, 0, $03, $0
	dbsprite   0,  -1, 0, 0, $04, $0
	dbsprite   1,  -1, 0, 0, $05, $0
	dbsprite  -2,   0, 0, 0, $06, $0
	dbsprite  -1,   0, 0, 0, $07, $0
	dbsprite   0,   0, 0, 0, $08, $0
	dbsprite   1,   0, 0, 0, $09, $0
	dbsprite  -2,   1, 0, 0, $0a, $0
	dbsprite  -1,   1, 0, 0, $0b, $0
	dbsprite   0,   1, 0, 0, $0c, $0
	dbsprite   1,   1, 0, 0, $0d, $0
.OAMData_30_PCP:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 0,   0, 0, $00, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_c1_PCP:
	dsprite  -2, 0,  -2, 0, $00, $0
	dsprite  -2, 0,  -1, 0, $01, $0
	dsprite  -2, 0,   0, 0, $02, $0
	dsprite  -2, 0,   1, 0, $00, $0 | OAM_XFLIP
	dsprite  -1, 0,  -2, 0, $03, $0
	dsprite  -1, 0,  -1, 0, $04, $0
	dsprite  -1, 0,   0, 0, $04, $0 | OAM_XFLIP
	dsprite  -1, 0,   1, 0, $05, $0
	dsprite   0, 0,  -2, 0, $05, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 0,  -1, 0, $04, $0 | OAM_YFLIP
	dsprite   0, 0,   0, 0, $04, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   0, 0,   1, 0, $03, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 0,  -2, 0, $00, $0 | OAM_YFLIP
	dsprite   1, 0,  -1, 0, $02, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 0,   0, 0, $01, $0 | OAM_XFLIP | OAM_YFLIP
	dsprite   1, 0,   1, 0, $00, $0 | OAM_XFLIP | OAM_YFLIP
.OAMData_dd_PCP:
	dbsprite  -2,  -4, 0, 7, $01, $0
	dbsprite  -1,  -4, 0, 7, $02, $0
	dbsprite  -3,  -3, 0, 7, $03, $0
	dbsprite  -2,  -3, 0, 7, $04, $0
	dbsprite  -1,  -3, 0, 7, $05, $0
	dbsprite  -3,  -2, 0, 7, $06, $0
	dbsprite  -2,  -2, 0, 7, $07, $0
	dbsprite   1,  -4, 0, 7, $01, OAM_XFLIP
	dbsprite   0,  -4, 0, 7, $02, OAM_XFLIP
	dbsprite   2,  -3, 0, 7, $03, OAM_XFLIP
	dbsprite   1,  -3, 0, 7, $04, OAM_XFLIP
	dbsprite   0,  -3, 0, 7, $05, OAM_XFLIP
	dbsprite   2,  -2, 0, 7, $06, OAM_XFLIP
	dbsprite   1,  -2, 0, 7, $07, OAM_XFLIP
	dbsprite  -2,   1, 0, 7, $01, OAM_YFLIP
	dbsprite  -1,   1, 0, 7, $02, OAM_YFLIP
	dbsprite  -3,   0, 0, 7, $03, OAM_YFLIP
	dbsprite  -2,   0, 0, 7, $04, OAM_YFLIP
	dbsprite  -1,   0, 0, 7, $05, OAM_YFLIP
	dbsprite  -3,  -1, 0, 7, $06, OAM_YFLIP
	dbsprite  -2,  -1, 0, 7, $07, OAM_YFLIP
	dbsprite   1,   1, 0, 7, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 7, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,   0, 0, 7, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   0, 0, 7, $04, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 0, 7, $05, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 7, $06, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 7, $07, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,  -1, 0, 7, $08, OAM_XFLIP | OAM_YFLIP
.OAMData_ef:
	dbsprite   0,  -2, 4, 4, $00, $0
	dbsprite   1,  -2, 4, 4, $01, $0
	dbsprite   2,  -2, 4, 4, $02, $0
	dbsprite   0,  -1, 4, 4, $03, $0
	dbsprite   1,  -1, 4, 4, $04, $0
	dbsprite   2,  -1, 4, 4, $05, $0
	dbsprite   0,   0, 4, 4, $06, $0
	dbsprite   1,   0, 4, 4, $07, $0
	dbsprite   2,   0, 4, 4, $08, $0
	dbsprite  -3,  -2, 4, 4, $00, OAM_XFLIP
	dbsprite  -4,  -2, 4, 4, $01, OAM_XFLIP
	dbsprite  -5,  -2, 4, 4, $02, OAM_XFLIP
	dbsprite  -3,  -1, 4, 4, $03, OAM_XFLIP
	dbsprite  -4,  -1, 4, 4, $04, OAM_XFLIP
	dbsprite  -5,  -1, 4, 4, $05, OAM_XFLIP
	dbsprite  -3,   0, 4, 4, $06, OAM_XFLIP
	dbsprite  -4,   0, 4, 4, $07, OAM_XFLIP
	dbsprite  -5,   0, 4, 4, $08, OAM_XFLIP
.OAMData_e2:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 0, $00, $0
	dbsprite   0, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -1,  0, -1, 0, $00, OAM_YFLIP
	dbsprite   0,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e3:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 0, $00, $0
	dbsprite  -1, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -2,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -1,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e4:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 4, $04, $0
	dbsprite  -3, -1, -1, 0, $00, $0
	dbsprite  -2, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -3,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -2,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e5:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 4, $04, $0
	dbsprite  -3, -1, -1, 4, $04, $0
	dbsprite  -4, -1, -1, 0, $00, $0
	dbsprite  -3, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -4,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -3,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e6:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 4, $04, $0
	dbsprite  -3, -1, -1, 4, $04, $0
	dbsprite  -4, -1, -1, 4, $04, $0
	dbsprite  -5, -1, -1, 0, $00, $0
	dbsprite  -4, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -5,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -4,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e7:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 4, $04, $0
	dbsprite  -3, -1, -1, 4, $04, $0
	dbsprite  -4, -1, -1, 4, $04, $0
	dbsprite  -5, -1, -1, 4, $04, $0
	dbsprite  -6, -1, -1, 0, $00, $0
	dbsprite  -5, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -6,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -5,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e8:
	dbsprite   0, -1, -1, 4, $04, $0
	dbsprite  -1, -1, -1, 4, $04, $0
	dbsprite  -2, -1, -1, 4, $04, $0
	dbsprite  -3, -1, -1, 4, $04, $0
	dbsprite  -4, -1, -1, 4, $04, $0
	dbsprite  -5, -1, -1, 4, $04, $0
	dbsprite  -6, -1, -1, 4, $04, $0
	dbsprite  -7, -1, -1, 0, $00, $0
	dbsprite  -6, -1, -1, 0, $00, OAM_XFLIP
	dbsprite  -7,  0, -1, 0, $00, OAM_YFLIP
	dbsprite  -6,  0, -1, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_e0:
	dbsprite  -1,  -1, 4, 4, $00, $0
	dbsprite   0,   0, 2, 2, $00, $0
.OAMData_HoneClaws1:
	dbsprite   0,   0,  1,  1, $00, $0
	dbsprite  -1,   0,  1,  1, $01, $0
	dbsprite   0,   0,  1,  1, $01, OAM_XFLIP
	dbsprite  -1,   0,  1,  1, $01, OAM_YFLIP
	dbsprite  -1,   0,  1,  1, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,  -1,  4,  4, $00, $0
	dbsprite  -2,  -1,  4,  4, $01, $0
	dbsprite  -1,  -1,  4,  4, $01, OAM_XFLIP
	dbsprite  -2,   0,  4,  4, $01, OAM_YFLIP
	dbsprite  -1,   0,  4,  4, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,  -1, -1, -1, $00, $0
	dbsprite  -2,  -1, -1, -1, $01, $0
	dbsprite  -1,  -1, -1, -1, $01, OAM_XFLIP
	dbsprite  -2,   0, -1, -1, $01, OAM_YFLIP
	dbsprite  -1,   0, -1, -1, $01, OAM_XFLIP | OAM_YFLIP
.OAMData_HoneClaws2:
	dbsprite   0,   0,  1,  1, $00, $0
	dbsprite  -1,   0,  3,  7, $00, $0
	dbsprite  -2,   0,  3,  7, $01, $0
	dbsprite  -1,   0,  3,  7, $01, OAM_XFLIP
	dbsprite  -2,   1,  3,  7, $01, OAM_YFLIP
	dbsprite  -1,   1,  3,  7, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,  -1,  4,  4, $00, $0
	dbsprite  -2,   0,  6,  2, $00, $0
	dbsprite  -3,   0,  6,  2, $01, $0
	dbsprite  -2,   0,  6,  2, $01, OAM_XFLIP
	dbsprite  -3,   1,  6,  2, $01, OAM_YFLIP
	dbsprite  -2,   1,  6,  2, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,  -1, -1, -1, $00, $0
	dbsprite  -2,   0,  1, -3, $00, $0
	dbsprite  -3,   0,  1, -3, $01, $0
	dbsprite  -2,   0,  1, -3, $01, OAM_XFLIP
	dbsprite  -3,   1,  1, -3, $01, OAM_YFLIP
	dbsprite  -2,   1,  1, -3, $01, OAM_XFLIP | OAM_YFLIP
.OAMData_HoneClaws3:
	dbsprite   0,   0,  1,  1, $00, $0
	dbsprite  -1,   0,  3,  7, $00, $0
	dbsprite  -2,   1,  5,  5, $00, $0
	dbsprite  -1,  -1,  4,  4, $00, $0
	dbsprite  -2,   0,  6,  2, $00, $0
	dbsprite  -2,   1,  0,  0, $00, $0
	dbsprite  -1,  -1, -1, -1, $00, $0
	dbsprite  -2,   0,  1, -3, $00, $0
	dbsprite  -2,   1, -5, -5, $00, $0
	dbsprite  -3,   1,  5,  5, $01, $0
	dbsprite  -2,   1,  5,  5, $01, OAM_XFLIP
	dbsprite  -3,   2,  5,  5, $01, OAM_YFLIP
	dbsprite  -2,   2,  5,  5, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -3,   1,  0,  0, $01, $0
	dbsprite  -2,   1,  0,  0, $01, OAM_XFLIP
	dbsprite  -3,   2,  0,  0, $01, OAM_YFLIP
	dbsprite  -2,   2,  0,  0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -3,   1, -5, -5, $01, $0
	dbsprite  -2,   1, -5, -5, $01, OAM_XFLIP
	dbsprite  -3,   2, -5, -5, $01, OAM_YFLIP
	dbsprite  -2,   2, -5, -5, $01, OAM_XFLIP | OAM_YFLIP
.OAMData_fb:
	dbsprite  -2,  -2, 0, 0, $00, $0
	dbsprite  -1,  -2, 0, 0, $01, $0
	dbsprite  -2,  -1, 0, 0, $02, $0
	dbsprite   0,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP
	dbsprite  -2,   0, 0, 0, $02, OAM_YFLIP
	dbsprite  -2,   1, 0, 0, $00, OAM_YFLIP
	dbsprite  -1,   1, 0, 0, $01, OAM_YFLIP
	dbsprite   1,   0, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_BigWhip1:
	dbsprite   1,  -1, 0, 0, $00, $0
	dbsprite   0,   0, 0, 0, $01, $0
	dbsprite   1,   0, 0, 0, $02, $0
	dbsprite  -1,   1, 0, 0, $03, $0
	dbsprite   0,   1, 0, 0, $04, $0
	dbsprite   1,   1, 0, 0, $05, $0
.OAMData_BigWhip2:
	dbsprite   0,  -2, 0, 0, $00, $0
	dbsprite   1,  -2, 0, 0, $01, $0
	dbsprite   1,  -1, 0, 0, $02, $0
	dbsprite   1,   0, 0, 0, $03, $0
	dbsprite   0,   1, 0, 0, $04, $0
	dbsprite   1,   1, 0, 0, $05, $0
.OAMData_BigWhip3:
	dbsprite  -2,   0, 0, 0, $00, $0
	dbsprite   1,   0, 0, 0, $01, $0
	dbsprite  -2,   1, 0, 0, $02, $0
	dbsprite  -1,   1, 0, 0, $03, $0
	dbsprite   0,   1, 0, 0, $04, $0
	dbsprite   1,   1, 0, 0, $05, $0
.OAMData_d8_PCP:
; ported from polishedcrystal .OAMData_d8 (vortex ring)
	dbsprite  -2,  -2, 0, 0, $00, $0
	dbsprite  -1,  -2, 0, 0, $01, $0
	dbsprite   0,  -2, 0, 0, $02, $0
	dbsprite   1,  -2, 0, 0, $03, $0
	dbsprite  -2,  -1, 0, 0, $04, $0
	dbsprite  -1,  -1, 0, 0, $05, $0
	dbsprite   0,  -1, 0, 0, $06, $0
	dbsprite   1,  -1, 0, 0, $07, $0
	dbsprite  -2,   0, 0, 0, $07, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,   0, 0, 0, $06, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 0, 0, $05, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   0, 0, 0, $04, OAM_XFLIP | OAM_YFLIP
	dbsprite  -2,   1, 0, 0, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,   1, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_SwirlShort_PCP:
; ported from polishedcrystal .OAMData_SwirlShort
	dbsprite  -2,  -2, 4, 4, $00, $0
	dbsprite  -1,  -2, 4, 4, $01, $0
	dbsprite   0,  -2, 4, 4, $02, $0
	dbsprite  -2,  -1, 4, 4, $03, $0
	dbsprite  -1,  -1, 4, 4, $04, $0
	dbsprite   0,  -1, 4, 4, $05, $0
	dbsprite  -2,   0, 4, 4, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite  -1,   0, 4, 4, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 4, 4, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_de_PCP:
; ported from polishedcrystal .OAMData_de (small ring)
	dbsprite  -2,  -2, 4, 4, $00, $0
	dbsprite  -1,  -2, 4, 4, $01, $0
	dbsprite   0,  -2, 4, 4, $00, OAM_XFLIP
	dbsprite  -2,  -1, 4, 4, $02, $0
	dbsprite   0,  -1, 4, 4, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite  -2,   0, 4, 4, $00, OAM_YFLIP
	dbsprite  -1,   0, 4, 4, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 4, 4, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_df_PCP:
; ported from polishedcrystal .OAMData_df (big ring)
	dbsprite  -3,  -4, 0, 7, $00, $0
	dbsprite  -2,  -4, 0, 7, $01, $0
	dbsprite  -1,  -4, 0, 7, $02, $0
	dbsprite  -3,  -3, 0, 7, $03, $0
	dbsprite  -2,  -3, 0, 7, $04, $0
	dbsprite  -3,  -2, 0, 7, $06, $0
	dbsprite   2,  -4, 0, 7, $00, OAM_XFLIP
	dbsprite   1,  -4, 0, 7, $01, OAM_XFLIP
	dbsprite   0,  -4, 0, 7, $02, OAM_XFLIP
	dbsprite   2,  -3, 0, 7, $03, OAM_XFLIP
	dbsprite   1,  -3, 0, 7, $04, OAM_XFLIP
	dbsprite   2,  -2, 0, 7, $06, OAM_XFLIP
	dbsprite  -3,   1, 0, 7, $00, OAM_YFLIP
	dbsprite  -2,   1, 0, 7, $01, OAM_YFLIP
	dbsprite  -1,   1, 0, 7, $02, OAM_YFLIP
	dbsprite  -3,   0, 0, 7, $03, OAM_YFLIP
	dbsprite  -2,   0, 0, 7, $04, OAM_YFLIP
	dbsprite  -3,  -1, 0, 7, $06, OAM_YFLIP
	dbsprite   2,   1, 0, 7, $00, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   1, 0, 7, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 7, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,   0, 0, 7, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,   0, 0, 7, $04, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 7, $06, OAM_XFLIP | OAM_YFLIP
.OAMData_VoltSwitch1_PCP:
	dbsprite  -4,  -2, 0, 0, $00, $0
	dbsprite  -3,  -2, 0, 0, $01, $0
	dbsprite  -2,  -2, 0, 0, $02, $0
	dbsprite  -1,  -2, 0, 0, $03, $0
	dbsprite   0,  -2, 0, 0, $04, $0
	dbsprite   1,  -2, 0, 0, $05, $0
	dbsprite   2,  -2, 0, 0, $06, $0
	dbsprite   3,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -4,  -1, 0, 0, $00, OAM_YFLIP
	dbsprite  -3,  -1, 0, 0, $01, OAM_YFLIP
	dbsprite  -2,  -1, 0, 0, $02, OAM_YFLIP
	dbsprite  -1,  -1, 0, 0, $03, OAM_YFLIP
	dbsprite   0,  -1, 0, 0, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   3,  -1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_VoltSwitch2_PCP:
	dbsprite  -4,  -2, 0, 0, $00, $0
	dbsprite  -3,  -2, 0, 0, $01, $0
	dbsprite  -2,  -2, 0, 0, $02, $0
	dbsprite  -1,  -2, 0, 0, $03, $0
	dbsprite   0,  -2, 0, 0, $03, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $02, OAM_XFLIP
	dbsprite   2,  -2, 0, 0, $07, $0
	dbsprite   3,  -2, 0, 0, $08, $0
	dbsprite  -4,  -1, 0, 0, $00, OAM_YFLIP
	dbsprite  -3,  -1, 0, 0, $01, OAM_YFLIP
	dbsprite  -2,  -1, 0, 0, $02, OAM_YFLIP
	dbsprite  -1,  -1, 0, 0, $03, OAM_YFLIP
	dbsprite   0,  -1, 0, 0, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 0, $09, $0
	dbsprite   2,  -1, 0, 0, $0a, $0
	dbsprite   3,  -1, 0, 0, $0b, $0
.OAMData_VoltSwitch3_PCP:
	dbsprite  -4,  -2, 0, 0, $00, $0
	dbsprite  -3,  -2, 0, 0, $01, $0
	dbsprite  -2,  -2, 0, 0, $02, $0
	dbsprite  -1,  -2, 0, 0, $03, $0
	dbsprite   0,  -2, 0, 0, $03, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $02, OAM_XFLIP
	dbsprite   2,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   3,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -4,  -1, 0, 0, $00, OAM_YFLIP
	dbsprite  -3,  -1, 0, 0, $01, OAM_YFLIP
	dbsprite  -2,  -1, 0, 0, $02, OAM_YFLIP
	dbsprite  -1,  -1, 0, 0, $03, OAM_YFLIP
	dbsprite   0,  -1, 0, 0, $0c, $0
	dbsprite   1,  -1, 0, 0, $0d, $0
	dbsprite   2,  -1, 0, 0, $0e, $0
	dbsprite   3,  -1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_VoltSwitch4_PCP:
	dbsprite  -4,  -2, 0, 0, $00, $0
	dbsprite  -3,  -2, 0, 0, $01, $0
	dbsprite  -2,  -2, 0, 0, $02, $0
	dbsprite  -1,  -2, 0, 0, $03, $0
	dbsprite   0,  -2, 0, 0, $03, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $02, OAM_XFLIP
	dbsprite   2,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   3,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -4,  -1, 0, 0, $00, OAM_YFLIP
	dbsprite  -3,  -1, 0, 0, $0f, $0
	dbsprite  -2,  -1, 0, 0, $10, $0
	dbsprite  -1,  -1, 0, 0, $11, $0
	dbsprite   0,  -1, 0, 0, $12, $0
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   3,  -1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_VoltSwitch5_PCP:
	dbsprite  -4,  -2, 0, 0, $13, $0
	dbsprite  -3,  -2, 0, 0, $14, $0
	dbsprite  -2,  -2, 0, 0, $02, $0
	dbsprite  -1,  -2, 0, 0, $03, $0
	dbsprite   0,  -2, 0, 0, $03, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $02, OAM_XFLIP
	dbsprite   2,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   3,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -4,  -1, 0, 0, $15, $0
	dbsprite  -3,  -1, 0, 0, $16, $0
	dbsprite  -2,  -1, 0, 0, $17, $0
	dbsprite  -1,  -1, 0, 0, $03, OAM_YFLIP
	dbsprite   0,  -1, 0, 0, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   3,  -1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_VoltSwitch6_PCP:
	dbsprite  -4,  -2, 0, 0, $00, $0
	dbsprite  -3,  -2, 0, 0, $18, $0
	dbsprite  -2,  -2, 0, 0, $19, $0
	dbsprite  -1,  -2, 0, 0, $1a, $0
	dbsprite   0,  -2, 0, 0, $1b, $0
	dbsprite   1,  -2, 0, 0, $02, OAM_XFLIP
	dbsprite   2,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   3,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -4,  -1, 0, 0, $00, OAM_YFLIP
	dbsprite  -3,  -1, 0, 0, $01, OAM_YFLIP
	dbsprite  -2,  -1, 0, 0, $02, OAM_YFLIP
	dbsprite  -1,  -1, 0, 0, $03, OAM_YFLIP
	dbsprite   0,  -1, 0, 0, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 0, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   3,  -1, 0, 0, $00, OAM_XFLIP | OAM_YFLIP
.OAMData_Hurricane:
	dbsprite  -2,  -4, 4, 0, $00, $0
	dbsprite  -1,  -4, 4, 0, $01, $0
	dbsprite   0,  -4, 4, 0, $02, $0
	dbsprite  -2,  -3, 4, 0, $03, $0
	dbsprite  -1,  -3, 4, 0, $04, $0
	dbsprite   0,  -3, 4, 0, $05, $0
	dbsprite  -2,  -2, 4, 0, $06, $0
	dbsprite  -1,  -2, 4, 0, $07, $0
	dbsprite   0,  -2, 4, 0, $08, $0
	dbsprite  -2,  -1, 4, 0, $09, $0
	dbsprite  -1,  -1, 4, 0, $0a, $0
	dbsprite   0,  -1, 4, 0, $0b, $0
	dbsprite  -2,   0, 4, 0, $0c, $0
	dbsprite  -1,   0, 4, 0, $0d, $0
	dbsprite   0,   0, 4, 0, $0e, $0
	dbsprite  -2,   1, 4, 0, $0f, $0
	dbsprite  -1,   1, 4, 0, $10, $0
	dbsprite   0,   1, 4, 0, $11, $0

; polishedcrystal ports (batch 2)
.OAMData_PC_BRICK_BREAK:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $02, $0
	dsprite   0, 0,   0, 0, $03, $0

.OAMData_PC_BUG_BUZZ1:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $03, $0

.OAMData_PC_BUG_BUZZ2:
	dsprite  -2, 4,  -2, 4, $00, $0
	dsprite  -2, 4,  -1, 4, $01, $0
	dsprite  -2, 4,   0, 4, $02, $0
	dsprite  -1, 4,  -2, 4, $03, $0
	dsprite   0, 4,  -2, 4, $06, $0

.OAMData_PC_EC:
	dbsprite  -2,  -2, 4, 4, $00, $0
	dbsprite  -1,  -2, 4, 4, $01, $0
	dbsprite   0,  -2, 4, 4, $00, OAM_XFLIP
	dbsprite  -2,  -1, 4, 4, $02, $0
	dbsprite  -1,  -1, 4, 4, $03, $0
	dbsprite   0,  -1, 4, 4, $02, OAM_XFLIP
	dbsprite  -2,   0, 4, 4, $04, $0
	dbsprite  -1,   0, 4, 4, $05, $0
	dbsprite   0,   0, 4, 4, $04, OAM_XFLIP

.OAMData_PC_F1:
	dbsprite  -2,  -3, 0, 7, $00, $0
	dbsprite  -1,  -3, 0, 7, $01, $0
	dbsprite  -3,  -2, 0, 7, $02, $0
	dbsprite  -2,  -2, 0, 7, $03, $0
	dbsprite  -1,  -2, 0, 7, $04, $0
	dbsprite   1,  -3, 0, 7, $00, OAM_XFLIP
	dbsprite   0,  -3, 0, 7, $01, OAM_XFLIP
	dbsprite   2,  -2, 0, 7, $02, OAM_XFLIP
	dbsprite   1,  -2, 0, 7, $03, OAM_XFLIP
	dbsprite   0,  -2, 0, 7, $04, OAM_XFLIP
	dbsprite  -2,   0, 0, 7, $00, OAM_YFLIP
	dbsprite  -1,   0, 0, 7, $01, OAM_YFLIP
	dbsprite  -3,  -1, 0, 7, $02, OAM_YFLIP
	dbsprite  -2,  -1, 0, 7, $03, OAM_YFLIP
	dbsprite  -1,  -1, 0, 7, $04, OAM_YFLIP
	dbsprite   1,   0, 0, 7, $00, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 0, 7, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   2,  -1, 0, 7, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 7, $03, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,  -1, 0, 7, $04, OAM_XFLIP | OAM_YFLIP

.OAMData_PC_F2:
	dbsprite  -2,  -3, 0, 7, $00, $0
	dbsprite  -1,  -3, 0, 7, $01, $0
	dbsprite  -2,  -2, 0, 7, $02, $0
	dbsprite  -1,  -2, 0, 7, $03, $0
	dbsprite   1,  -3, 0, 7, $00, OAM_XFLIP
	dbsprite   0,  -3, 0, 7, $01, OAM_XFLIP
	dbsprite   1,  -2, 0, 7, $02, OAM_XFLIP
	dbsprite   0,  -2, 0, 7, $03, OAM_XFLIP
	dbsprite  -2,   0, 0, 7, $00, OAM_YFLIP
	dbsprite  -1,   0, 0, 7, $01, OAM_YFLIP
	dbsprite  -2,  -1, 0, 7, $02, OAM_YFLIP
	dbsprite  -1,  -1, 0, 7, $03, OAM_YFLIP
	dbsprite   1,   0, 0, 7, $00, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   0, 0, 7, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite   1,  -1, 0, 7, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,  -1, 0, 7, $03, OAM_XFLIP | OAM_YFLIP

.OAMData_PC_F6:
	dbsprite  -2,  -2, -1, 1, $00, $0
	dbsprite  -1,  -2, -1, 1, $01, $0
	dbsprite   0,  -2, -1, 1, $02, $0
	dbsprite  -2,  -1, -1, 1, $03, $0
	dbsprite  -1,  -1, -1, 1, $04, $0
	dbsprite   0,  -1, -1, 1, $05, $0
	dbsprite  -2,   0, -1, 1, $06, $0
	dbsprite  -1,   0, -1, 1, $07, $0
	dbsprite   0,   0, -1, 1, $08, $0
	dbsprite  -3,  -1, -1, 1, $00, $0
	dbsprite  -3,   0, -3, 3, $05, OAM_XFLIP | OAM_YFLIP
	dbsprite  -3,   1, -3, 3, $02, OAM_XFLIP | OAM_YFLIP
	dbsprite  -2,   1, -3, 3, $01, OAM_XFLIP | OAM_YFLIP
	dbsprite  -3,   0, -1, 1, $03, $0
	dbsprite  -2,   0, -3, 3, $06, $0
	dbsprite  -2,   1, -1, 1, $07, $0
	dbsprite  -1,   1, -1, 1, $08, $0

.OAMData_PC_F7:
	dbsprite  -2,  -1, 0, 0, $00, $0
	dbsprite  -1,  -1, 0, 0, $01, $0
	dbsprite   0,  -1, 0, 0, $01, OAM_XFLIP
	dbsprite   1,  -1, 0, 0, $00, OAM_XFLIP
	dbsprite  -2,   0, 0, 0, $02, $0
	dbsprite  -1,   0, 0, 0, $03, $0
	dbsprite   0,   0, 0, 0, $03, OAM_XFLIP
	dbsprite   1,   0, 0, 0, $02, OAM_XFLIP
	dbsprite  -2,   1, 0, 0, $04, $0
	dbsprite  -1,   1, 0, 0, $05, $0
	dbsprite   0,   1, 0, 0, $05, OAM_XFLIP
	dbsprite   1,   1, 0, 0, $04, OAM_XFLIP

.OAMData_PC_F8:
	dbsprite  -2,  -2, 0, 0, $00, $0
	dbsprite  -1,  -2, 0, 0, $01, $0
	dbsprite   0,  -2, 0, 0, $01, OAM_XFLIP
	dbsprite   1,  -2, 0, 0, $00, OAM_XFLIP
	dbsprite  -2,  -1, 0, 0, $02, $0
	dbsprite  -1,  -1, 0, 0, $03, $0
	dbsprite   0,  -1, 0, 0, $03, OAM_XFLIP
	dbsprite   1,  -1, 0, 0, $02, OAM_XFLIP
	dbsprite  -2,   0, 0, 0, $04, $0
	dbsprite  -1,   0, 0, 0, $05, $0
	dbsprite   0,   0, 0, 0, $05, OAM_XFLIP
	dbsprite   1,   0, 0, 0, $04, OAM_XFLIP
	dbsprite  -2,   1, 0, 0, $06, $0
	dbsprite  -1,   1, 0, 0, $07, $0
	dbsprite   0,   1, 0, 0, $07, OAM_XFLIP
	dbsprite   1,   1, 0, 0, $06, OAM_XFLIP

.OAMData_PC_FC:
	dsprite  -1, 0,  -2, 4, $00, $0
	dsprite  -1, 0,  -1, 4, $01, $0
	dsprite  -1, 0,   0, 4, $02, $0
	dsprite   0, 0,  -2, 4, $03, $0
	dsprite   0, 0,  -1, 4, $04, $0
	dsprite   0, 0,   0, 4, $05, $0

.OAMData_PC_ICICLE_CRASH:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite  -1, 0,   0, 0, $01, $0
	dsprite   0, 0,  -1, 0, $02, $0
	dsprite   0, 0,   0, 0, $03, $0
	dsprite   1, 0,  -1, 0, $04, $0
	dsprite   1, 0,   0, 0, $05, $0

.OAMData_PC_STONE_EDGE:
	dsprite  -1, 0,  -1, 0, $00, $0
	dsprite   0, 0,  -1, 0, $01, $0

.OAMData_PC_GYRO_BALL_2:
	dbsprite   0,  -2, 0, 0, $00, $0
	dbsprite  -2,  -1, 0, 0, $01, $0
	dbsprite  -1,  -1, 0, 0, $02, $0
	dbsprite   0,  -1, 0, 0, $03, $0
	dbsprite   1,  -1, 0, 0, $04, $0
	dbsprite  -2,   0, 0, 0, $05, $0
	dbsprite  -1,   0, 0, 0, $06, $0
	dbsprite   0,   0, 0, 0, $07, $0
	dbsprite   1,   0, 0, 0, $08, $0
	dbsprite  -2,   1, 0, 0, $09, $0
	dbsprite  -1,   1, 0, 0, $0a, $0
	dbsprite   0,   1, 0, 0, $0b, $0
	dbsprite   1,   1, 0, 0, $0c, $0

.OAMData_PC_GYRO_BALL_3:
	dbsprite  -1,  -2, 0, 0, $00, $0
	dbsprite   0,  -2, 0, 0, $01, $0
	dbsprite   1,  -2, 0, 0, $02, $0
	dbsprite  -1,  -1, 0, 0, $03, $0
	dbsprite   0,  -1, 0, 0, $04, $0
	dbsprite   1,  -1, 0, 0, $05, $0
	dbsprite  -2,   0, 0, 0, $06, $0
	dbsprite  -1,   0, 0, 0, $07, $0
	dbsprite   0,   0, 0, 0, $08, $0
	dbsprite   1,   0, 0, 0, $09, $0
	dbsprite  -2,   1, 0, 0, $0a, $0
	dbsprite  -1,   1, 0, 0, $0b, $0
	dbsprite   0,   1, 0, 0, $0c, $0
	dbsprite   1,   1, 0, 0, $0d, $0

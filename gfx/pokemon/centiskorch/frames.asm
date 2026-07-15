	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37
.frame2
	db $01 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39
.frame3
	db $02 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
.frame4
	db $03 ; bitmask
	db $31, $32, $33, $34, $35, $3c, $36, $37, $38, $39, $3d, $3a
	db $3b
.frame5
	db $04 ; bitmask
	db $31, $32, $33, $34, $35, $3e, $3f, $36, $37, $38, $39, $3d
	db $40, $3a, $3b
.frame6
	db $05 ; bitmask
	db $41, $42, $43, $44, $45, $46, $33, $47, $48, $35, $3e, $3f
	db $49, $4a, $4b, $4c, $4d, $4e, $38, $39, $3d, $40, $3a, $3b
.frame7
	db $06 ; bitmask
	db $31, $32, $33, $34, $35, $3e, $3f, $36, $37, $3d, $40, $3a
	db $3b
.frame8
	db $07 ; bitmask
	db $31, $32, $33, $34, $35, $3e, $3f, $36, $37, $3d, $40
.frame9
	db $08 ; bitmask
	db $31, $32, $33, $34, $35, $4f, $3f, $36, $37, $40

	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41
.frame2
	db $01 ; bitmask
	db $31, $32, $33, $42, $36, $37, $38, $43, $3b, $3c, $3d, $3f
	db $40, $41
.frame3
	db $02 ; bitmask
	db $31, $32, $33, $34, $35, $39, $3a, $3e
.frame4
	db $03 ; bitmask
	db $44, $36, $37, $38, $43, $3b, $3c, $3d, $3f, $40, $41
.frame5
	db $04 ; bitmask
	db $31, $32, $33, $45
.frame6
	db $05 ; bitmask
.frame7
	db $04 ; bitmask
	db $31, $32, $33, $45
.frame8
	db $05 ; bitmask

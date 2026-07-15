	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38
.frame2
	db $00 ; bitmask
	db $31, $32, $33, $39, $35, $36, $37, $3a
.frame3
	db $00 ; bitmask
	db $31, $32, $33, $3b, $35, $36, $37, $3c
.frame4
	db $00 ; bitmask
	db $31, $32, $33, $3d, $35, $36, $37, $3e
.frame5
	db $01 ; bitmask
	db $3f, $40, $41

	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34
.frame2
	db $01 ; bitmask
	db $35, $36, $37
.frame3
	db $02 ; bitmask
	db $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d
.frame4
	db $03 ; bitmask
	db $38, $39, $3a, $3b, $3c, $3d

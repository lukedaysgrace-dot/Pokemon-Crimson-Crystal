	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33
.frame2
	db $01 ; bitmask
	db $34, $35, $36, $37, $31, $32, $33, $38, $39, $3a, $3b, $3c
	db $3d, $3e
.frame3
	db $02 ; bitmask
	db $00, $3f, $40, $41, $31, $32, $33, $42, $43, $44, $45, $46
	db $47, $48, $49, $4a, $3e
.frame4
	db $00 ; bitmask
	db $4b, $4c, $4d

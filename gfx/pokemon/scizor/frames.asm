	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $00, $00, $00, $33, $34, $35, $00, $36, $37, $38, $39, $3a
	db $3b, $3c
.frame3
	db $02 ; bitmask
	db $00, $3d, $3e, $3f, $33, $40, $41, $42, $43, $44, $45, $46
	db $47
.frame4
	db $03 ; bitmask
	db $00, $48, $00, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51

	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36
.frame2
	db $01 ; bitmask
	db $37, $31, $32, $38, $33, $34, $39, $3a, $35, $36, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42
.frame3
	db $02 ; bitmask
	db $43, $44, $31, $32, $45, $33, $34, $46, $47, $48, $35, $36
	db $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52
.frame4
	db $03 ; bitmask
	db $53, $54, $55, $56

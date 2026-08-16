	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d
.frame2
	db $01 ; bitmask
	db $31, $3e, $3f, $40, $34, $41, $36, $37, $42, $39, $43, $3b
	db $3c, $44, $45, $05, $46, $47, $48, $49, $4a, $4b, $4c, $05
	db $4d, $4e, $05, $2a, $4f, $50
.frame3
	db $02 ; bitmask
	db $51, $52, $39, $53, $54, $55, $56

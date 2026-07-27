	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $1b, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40
.frame2
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $1b, $41, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40
.frame3
	db $01 ; bitmask
	db $42, $43, $1b, $31, $32, $33, $34, $44, $35, $36, $37, $1b
	db $45, $46, $47, $38, $39, $3a, $48, $49, $3b, $3c, $3d, $4a
	db $4b, $3e, $3f, $4c, $4d, $4e, $4f, $40, $50, $51, $52
.frame4
	db $02 ; bitmask
	db $53, $54, $55

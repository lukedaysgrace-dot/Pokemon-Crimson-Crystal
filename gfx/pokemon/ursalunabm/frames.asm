	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39
.frame2
	db $01 ; bitmask
	db $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45
	db $46, $47, $48, $49, $4a, $4b, $4c, $4d
.frame3
	db $01 ; bitmask
	db $4e, $4f, $3c, $50, $3e, $3f, $40, $41, $42, $43, $44, $45
	db $46, $47, $51, $52, $4a, $53, $54, $55
.frame4
	db $02 ; bitmask
	db $56, $57, $58, $59, $5a, $5b

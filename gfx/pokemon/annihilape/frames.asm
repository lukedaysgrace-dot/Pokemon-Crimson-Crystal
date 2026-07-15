	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31
.frame2
	db $01 ; bitmask
	db $32, $33, $34, $35, $36
.frame3
	db $02 ; bitmask
	db $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42
	db $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e
	db $4f
.frame4
	db $03 ; bitmask
	db $37, $50, $51, $52, $3b, $3c, $53, $54, $55, $40, $41, $42
	db $43, $44, $45, $56, $57, $58, $48, $49, $59, $5a, $5b, $5c
	db $5d, $06

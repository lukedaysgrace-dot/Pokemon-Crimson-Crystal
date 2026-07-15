	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $00, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47
.frame2
	db $00 ; bitmask
	db $00, $31, $32, $33, $48, $49, $36, $37, $38, $39, $3a, $4a
	db $4b, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47
.frame3
	db $01 ; bitmask
	db $4c, $4d, $4e, $4f, $50, $51, $52, $53
.frame4
	db $02 ; bitmask
	db $54, $55, $56, $57, $58, $59

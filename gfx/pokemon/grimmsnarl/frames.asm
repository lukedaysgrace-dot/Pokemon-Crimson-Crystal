	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31, $32, $06, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40, $41, $42, $06, $06
.frame2
	db $01 ; bitmask
	db $31, $32, $06, $33, $34, $35, $43, $44, $45, $37, $46, $47
	db $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $06
	db $06
.frame3
	db $02 ; bitmask
	db $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53
	db $54, $55, $56
.frame4
	db $03 ; bitmask
	db $4c, $4d, $57, $4f, $50
.frame5
	db $04 ; bitmask
	db $43, $58

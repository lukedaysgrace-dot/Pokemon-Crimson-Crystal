	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42
.frame2
	db $01 ; bitmask
	db $43, $44, $45
.frame3
	db $02 ; bitmask
	db $31, $32, $43, $44, $33, $45, $34, $35, $36, $37, $38, $39
	db $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42
.frame4
	db $03 ; bitmask
	db $46, $47, $48, $49, $00, $4a, $4b, $4c, $4d, $33, $4e, $4f
	db $50, $51, $52, $53

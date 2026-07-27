	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $00, $31, $32, $33, $00, $34, $35, $36, $37
.frame2
	db $01 ; bitmask
	db $00, $38, $39, $3a, $3b, $3c, $3d
.frame3
	db $02 ; bitmask
	db $00, $31, $32, $33, $00, $34, $35, $3e, $3f, $39, $3a, $3b
	db $3c, $3d
.frame4
	db $03 ; bitmask
	db $00, $40, $41, $42, $00, $43, $44, $45, $46, $47, $00, $48
	db $49, $00, $4a, $4b
.frame5
	db $04 ; bitmask
	db $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54
.frame6
	db $05 ; bitmask
	db $4d, $55, $4f, $56, $50, $57, $58, $59, $5a, $5b, $5c
.frame7
	db $06 ; bitmask
	db $5d, $5e, $52, $5f, $60, $53, $54, $61, $62

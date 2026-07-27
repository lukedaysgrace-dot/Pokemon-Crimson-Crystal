	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $06, $06, $35, $36, $37, $06, $06, $38
	db $39, $3a
.frame2
	db $01 ; bitmask
	db $3b, $3c, $31, $32, $33, $34, $06, $06, $35, $36, $37, $06
	db $06, $38, $39, $3a
.frame3
	db $02 ; bitmask
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $31, $32, $4b, $4c, $4d, $06, $06, $06, $4e, $06
	db $06, $4f
.frame4
	db $02 ; bitmask
	db $3d, $50, $51, $40, $41, $52, $53, $44, $45, $46, $47, $54
	db $49, $4a, $31, $32, $4b, $4c, $4d, $06, $06, $06, $4e, $06
	db $06, $4f
.frame5
	db $03 ; bitmask
	db $55, $56, $57, $58, $4a, $59, $5a, $5b, $5c, $5d
.frame6
	db $04 ; bitmask
	db $5e, $5f, $60

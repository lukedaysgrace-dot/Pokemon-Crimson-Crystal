	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $33
.frame3
	db $02 ; bitmask
	db $06, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e
	db $3f, $40, $41, $42
.frame4
	db $03 ; bitmask
	db $06, $34, $35, $43, $36, $37, $38, $39, $44, $3a, $3b, $3c
	db $3d, $45, $3e, $3f, $40, $46, $47, $41, $42
.frame5
	db $04 ; bitmask
	db $06, $34, $35, $43, $36, $37, $38, $39, $44, $3a, $3b, $3c
	db $3d, $48, $49, $3e, $3f, $40, $4a, $4b, $41, $42
.frame6
	db $05 ; bitmask
	db $06, $34, $35, $4c, $4d, $36, $37, $38, $39, $4e, $4f, $3a
	db $3b, $3c, $3d, $50, $3e, $3f, $40, $51, $06, $52, $53, $42
	db $54, $55, $56, $57, $58, $59, $5a, $5b
.frame7
	db $06 ; bitmask
	db $5c, $5d, $5e, $5f, $43, $60, $61, $62, $63, $44, $64, $65
	db $66, $48, $49, $67, $68, $69, $40, $4a, $4b, $6a, $6b

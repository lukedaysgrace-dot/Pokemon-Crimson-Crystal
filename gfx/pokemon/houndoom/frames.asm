	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
	dw .frame10
	dw .frame11
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
.frame2
	db $00 ; bitmask
	db $3c, $3d, $3e, $3f, $35, $36, $37, $38, $39, $3a, $3b
.frame3
	db $01 ; bitmask
	db $40, $41, $42, $43, $44, $45, $36, $37, $38, $39, $3a, $3b
.frame4
	db $01 ; bitmask
	db $40, $46, $42, $43, $47, $45, $36, $37, $38, $39, $3a, $3b
.frame5
	db $02 ; bitmask
	db $48, $49, $4a, $4b, $42, $43, $4c, $45, $36, $37, $38, $39
	db $3a, $3b
.frame6
	db $03 ; bitmask
	db $4d, $4e, $4f, $50, $51, $42, $43, $52, $45, $36, $37, $38
	db $39, $3a, $3b
.frame7
	db $03 ; bitmask
	db $53, $54, $55, $40, $56, $42, $43, $44, $45, $36, $37, $38
	db $39, $3a, $3b
.frame8
	db $04 ; bitmask
	db $57, $58, $59, $5a, $40, $5b, $42, $43, $44, $45, $36, $37
	db $38, $39, $3a, $3b
.frame9
	db $00 ; bitmask
	db $31, $32, $5c, $5d, $35, $5e, $37, $38, $39, $3a, $3b
.frame10
	db $05 ; bitmask
	db $00, $5f, $60, $61
.frame11
	db $06 ; bitmask
	db $00, $5f, $62, $63, $64

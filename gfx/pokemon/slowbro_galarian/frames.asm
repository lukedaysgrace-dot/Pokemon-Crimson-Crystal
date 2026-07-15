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
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38
.frame2
	db $01 ; bitmask
	db $31, $32, $33, $34, $35, $36, $39, $37, $38, $3a
.frame3
	db $02 ; bitmask
	db $31, $32, $33, $34, $35, $36, $3b, $3c, $3d, $3e, $15, $3f
	db $40, $41, $42, $15, $43, $44, $45, $46, $47, $48, $49
.frame4
	db $03 ; bitmask
	db $4a, $4b, $4c, $4d, $31, $4e, $4f, $50, $51, $34, $35, $36
	db $37, $38
.frame5
	db $03 ; bitmask
	db $4a, $4b, $4c, $4d, $52, $53, $4f, $50, $51, $54, $55, $36
	db $37, $38
.frame6
	db $04 ; bitmask
	db $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $35, $36, $37, $38
.frame7
	db $05 ; bitmask
	db $4a, $4b, $4c, $4d, $56, $57, $50, $51
.frame8
	db $06 ; bitmask
	db $58, $52, $59, $54, $5a
.frame9
	db $07 ; bitmask
	db $58, $31, $34
.frame10
	db $08 ; bitmask
	db $58, $5b, $5c, $5d, $5e, $5f, $60, $61, $62, $63, $64, $15
	db $15, $65, $66, $67, $68, $15, $69, $6a, $6b, $6c, $15, $15
	db $15, $6d

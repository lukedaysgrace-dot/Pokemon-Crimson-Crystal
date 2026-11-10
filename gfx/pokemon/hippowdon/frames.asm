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
	dw .frame12
	dw .frame13
	dw .frame14
.frame1
	db $00 ; bitmask
	db $31
.frame2
	db $01 ; bitmask
	db $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d
.frame3
	db $02 ; bitmask
	db $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
.frame4
	db $03 ; bitmask
	db $4a, $4b, $4c, $4d, $40, $4e, $4f, $43, $50, $51, $52, $53
	db $54, $55, $56
.frame5
	db $04 ; bitmask
	db $57, $58, $59, $5a, $5b, $40, $5c, $5d, $5e, $43, $5f, $60
	db $61, $62, $63, $64, $65
.frame6
	db $03 ; bitmask
	db $4a, $4b, $66, $67, $40, $68, $69, $43, $6a, $6b, $6c, $53
	db $6d, $6e, $49
.frame7
	db $05 ; bitmask
	db $57, $58, $6f, $70, $71, $40, $72, $73, $74, $43, $75, $45
	db $46, $62, $63, $76, $48, $49
.frame8
	db $03 ; bitmask
	db $4a, $4b, $4c, $4d, $40, $4e, $4f, $43, $50, $51, $52, $53
	db $54, $55, $56
.frame9
	db $04 ; bitmask
	db $57, $58, $59, $5a, $5b, $40, $5c, $5d, $5e, $43, $5f, $60
	db $61, $62, $63, $64, $65
.frame10
	db $03 ; bitmask
	db $4a, $4b, $66, $67, $40, $68, $69, $43, $6a, $6b, $6c, $53
	db $6d, $6e, $49
.frame11
	db $02 ; bitmask
	db $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
.frame12
	db $06 ; bitmask
	db $77, $78, $6c, $79, $7a, $56
.frame13
	db $07 ; bitmask
	db $7b, $7c, $7d, $7e
.frame14
	db $06 ; bitmask
	db $7f, $80, $46, $79, $81, $56

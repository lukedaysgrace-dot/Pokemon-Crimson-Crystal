	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f
.frame2
	db $01 ; bitmask
	db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
	db $3d, $4c
.frame3
	db $02 ; bitmask
	db $4d, $4e, $4f, $50, $51, $52, $53, $54, $55, $56, $57, $58
	db $48, $49, $4a, $4b, $3d, $4c
.frame4
	db $03 ; bitmask
	db $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $00, $61
.frame5
	db $04 ; bitmask
	db $59, $5a, $62, $00, $63, $64, $65, $5e, $66, $67, $68, $69
	db $00, $61
.frame6
	db $05 ; bitmask
	db $6a, $6b, $00, $6c, $6d, $6e, $6f, $70, $71
.frame7
	db $06 ; bitmask
	db $6b, $00, $72, $73, $6e, $74, $75, $76
.frame8
	db $06 ; bitmask
	db $77, $00, $78, $79, $6e, $7a, $7b, $7c
.frame9
	db $07 ; bitmask
	db $7d, $7e, $7f

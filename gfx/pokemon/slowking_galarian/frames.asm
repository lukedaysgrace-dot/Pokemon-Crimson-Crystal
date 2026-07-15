	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $00, $00, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
.frame3
	db $02 ; bitmask
	db $00, $00, $3d, $3e, $33, $34, $3f, $40, $35, $36, $37, $38
	db $39, $3a, $3b, $3c
.frame4
	db $03 ; bitmask
	db $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $36
	db $4c, $4d, $37, $38, $39, $3a, $3b, $3c
.frame5
	db $04 ; bitmask
	db $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4e, $4c
	db $4d
.frame6
	db $05 ; bitmask
	db $4f, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a
	db $5b, $5c, $5d
.frame7
	db $06 ; bitmask
	db $5e, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69
	db $6a, $6b, $6c, $6d, $6e, $6f
.frame8
	db $07 ; bitmask
	db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b
	db $7c, $7d, $7e, $7f, $80

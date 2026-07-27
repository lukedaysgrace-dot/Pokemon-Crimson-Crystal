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
	db $31, $32, $33, $00, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f
.frame2
	db $01 ; bitmask
	db $00, $40, $00, $00, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $4b, $4c, $4d, $3c, $3d, $3e, $3f
.frame3
	db $02 ; bitmask
	db $00, $00, $00, $00, $4e, $4f, $50, $51, $52, $53, $54, $55
	db $56, $57, $58, $3c, $3d, $3e, $3f
.frame4
	db $03 ; bitmask
	db $00, $00, $59, $5a, $5b, $00, $5c, $5d, $5e, $5f, $60, $61
	db $62, $63, $64, $3c, $3d, $3e, $3f
.frame5
	db $04 ; bitmask
	db $00, $00, $00, $65, $5b, $00, $5c, $5d, $66, $67, $68, $69
	db $6a, $6b, $6c, $4b, $4d, $3c, $3d, $3e, $3f
.frame6
	db $05 ; bitmask
	db $00, $00, $00, $6d, $5b, $00, $5c, $5d, $6e, $6f, $70, $71
	db $55, $6b, $3c, $3d, $3e, $3f
.frame7
	db $06 ; bitmask
	db $00, $72, $73, $00, $74, $75, $36, $37, $38, $39, $3a, $3b
.frame8
	db $07 ; bitmask
	db $47, $6c, $4b, $4d

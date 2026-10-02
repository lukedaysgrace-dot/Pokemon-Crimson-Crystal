	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34
.frame2
	db $01 ; bitmask
	db $35, $36, $32, $37, $38, $34
.frame3
	db $02 ; bitmask
	db $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44
.frame4
	db $03 ; bitmask
	db $45, $46, $00, $00, $47, $48, $49, $00, $00, $4a, $4b, $4c
	db $4d, $4e, $4f, $50, $51, $52, $00, $53, $54, $55, $56, $57
	db $00, $58, $59, $5a, $5b, $5c
.frame5
	db $04 ; bitmask
	db $5d, $5e, $5f, $00, $60, $61, $62, $00, $63, $64, $4e, $4f
	db $50, $51, $52, $00, $65, $66, $67, $68, $57, $00, $69, $6a
	db $6b, $6c, $6d

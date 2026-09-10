	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a
.frame2
	db $00 ; bitmask
	db $3b, $32, $3c, $3d, $35, $3e, $3f, $38, $39, $3a
.frame3
	db $01 ; bitmask
	db $40, $41, $42, $32, $43, $00, $00, $35, $44, $45, $3f, $38
	db $39, $3a
.frame4
	db $02 ; bitmask
	db $46, $47, $40, $48, $49, $32, $43, $00, $00, $35, $4a, $4b
	db $3f, $38, $4c, $4d, $3a
.frame5
	db $03 ; bitmask
	db $46, $47, $40, $48, $49, $4e, $4f, $43, $00, $00, $50, $51
	db $4a, $4b, $00, $52, $53, $4c, $4d, $54, $55, $56, $57, $58
	db $22
.frame6
	db $04 ; bitmask
	db $46, $47, $59, $5a, $5b, $5c, $4c, $5d

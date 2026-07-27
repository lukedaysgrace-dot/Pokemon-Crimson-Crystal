	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $33, $34, $35, $36
.frame3
	db $02 ; bitmask
	db $37, $38, $39, $3a, $00, $3b, $3c, $3d, $00, $3e, $3f, $40
	db $41, $42
.frame4
	db $03 ; bitmask
	db $43, $44, $45, $46, $47, $00, $48, $49, $4a, $4b, $4c, $4d
	db $4e, $4f
.frame5
	db $04 ; bitmask
	db $37, $38, $39, $3a, $00, $3b, $3c, $3d, $00, $3e, $50, $34
	db $40, $51, $52, $36, $45, $46, $47, $00, $48, $49, $4a, $4b
	db $4c, $4d, $4e, $4f
.frame6
	db $05 ; bitmask
	db $37, $38, $39, $3a, $00, $3b, $3c, $3d, $00, $3e, $3f, $40
	db $51, $53, $45, $46, $47, $00, $48, $49, $4a, $4b, $4c, $4d
	db $4e, $4f

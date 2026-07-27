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
	db $31, $32, $33, $34, $35, $36, $00, $37, $38, $39, $00, $00
	db $00
.frame3
	db $01 ; bitmask
	db $31, $32, $33, $3a, $3b, $3c, $00, $00, $00, $00, $00, $00
	db $00
.frame4
	db $02 ; bitmask
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $32, $33, $4b, $4c, $4d, $4e, $00, $00, $4f, $50
	db $00, $00, $00
.frame5
	db $03 ; bitmask
	db $33, $3a, $3b, $3c, $00, $00, $00, $00, $00, $00, $00
.frame6
	db $04 ; bitmask
	db $51, $33, $3a, $3b, $3c, $00, $00, $00, $00, $00, $00, $00
.frame7
	db $03 ; bitmask
	db $33, $34, $35, $36, $00, $37, $38, $39, $00, $00, $00

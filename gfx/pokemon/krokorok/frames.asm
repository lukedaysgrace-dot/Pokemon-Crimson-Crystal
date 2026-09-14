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
	db $24, $25, $26
.frame2
	db $00 ; bitmask
	db $24, $00, $27
.frame3
	db $01 ; bitmask
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $00, $30, $00, $31
	db $32
.frame4
	db $02 ; bitmask
	db $00, $33, $34, $00, $35, $36
.frame5
	db $03 ; bitmask
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $37, $00, $38, $39
	db $00, $3a, $3b
.frame6
	db $04 ; bitmask
	db $37, $00, $38, $39, $00, $3c, $3d
.frame7
	db $04 ; bitmask
	db $37, $00, $3e, $3f, $00, $40, $41
.frame8
	db $05 ; bitmask
	db $37, $00, $42, $43, $00, $44
.frame9
	db $06 ; bitmask
	db $45, $46
.frame10
	db $07 ; bitmask
	db $47, $48, $49, $4a
.frame11
	db $08 ; bitmask

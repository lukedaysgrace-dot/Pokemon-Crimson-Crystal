	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $1c, $24, $25, $26, $1e, $1f, $20, $21, $22
	db $23
.frame3
	db $02 ; bitmask
	db $04, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31
	db $32, $33, $34, $35, $36, $37, $38, $39, $04, $3a, $3b, $3c
	db $3d
.frame4
	db $02 ; bitmask
	db $04, $27, $3e, $3f, $40, $2b, $2c, $41, $42, $2f, $30, $31
	db $32, $33, $34, $35, $36, $37, $38, $39, $04, $3a, $3b, $3c
	db $3d
.frame5
	db $02 ; bitmask
	db $04, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31
	db $43, $44, $34, $35, $45, $46, $47, $39, $04, $48, $49, $4a
	db $3d
.frame6
	db $03 ; bitmask
	db $4b, $21, $4c, $4d
.frame7
	db $04 ; bitmask
	db $4e, $4f

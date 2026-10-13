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
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d
.frame2
	db $01 ; bitmask
	db $1e, $1f, $20, $1a, $21, $22, $23, $24, $0f, $25, $26
.frame3
	db $02 ; bitmask
	db $1e, $27, $28, $1a, $29, $2a, $22, $2b, $2c, $0f, $2d
.frame4
	db $02 ; bitmask
	db $2e, $2f, $28, $30, $31, $2a, $32, $33, $2c, $0f, $2d
.frame5
	db $02 ; bitmask
	db $34, $35, $28, $36, $37, $2a, $32, $33, $2c, $0f, $2d
.frame6
	db $03 ; bitmask
	db $38, $39, $3a, $28, $3b, $3c, $2a, $32, $33, $2c, $0f, $2d
.frame7
	db $04 ; bitmask
	db $3d, $3e, $3f, $28, $40, $41, $42, $2a, $32, $33, $2c, $0f
	db $2d
.frame8
	db $02 ; bitmask
	db $43, $44, $45, $30, $46, $2a, $32, $33, $2c, $0f, $2d
.frame9
	db $02 ; bitmask
	db $2e, $47, $48, $30, $31, $2a, $32, $33, $2c, $0f, $2d
.frame10
	db $05 ; bitmask
	db $49, $4a, $4b, $4c

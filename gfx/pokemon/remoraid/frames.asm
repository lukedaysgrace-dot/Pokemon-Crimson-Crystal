	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $1c, $1d
.frame3
	db $02 ; bitmask
	db $1e
.frame4
	db $03 ; bitmask
	db $1e, $1f, $20, $21
.frame5
	db $03 ; bitmask
	db $1e, $22, $23, $24
.frame6
	db $03 ; bitmask
	db $1e, $25, $26, $27

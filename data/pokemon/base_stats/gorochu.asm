; Stats, typing, catch rate, experience, growth and compatible TMs from
; Pokemon-Rage-Blue, commit 2bb6ad785bd60582e8dccb2ccc8a29ff1a48a2e4.
; Gen 1's Special 100 is used for both Special Attack and Special Defense.
	db 0 ; species ID placeholder

	db  70,  90,  65, 115, 100, 100
	;   hp  atk  def  spd  sat  sdf

	db ELECTRIC, DARK ; type
	db 45 ; catch rate
	db 190 ; base exp
	db NO_ITEM, BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/gorochu/front.dimensions"
	abilities_for GOROCHU, STATIC, LIGHTNING_ROD, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; Rage Blue's TM/HM moves that are machines or tutors in Crimson Crystal.
	tmhm TOXIC, HYPER_BEAM, THUNDERBOLT, THUNDER, SWIFT, REST, FLY, FLASH
	; end

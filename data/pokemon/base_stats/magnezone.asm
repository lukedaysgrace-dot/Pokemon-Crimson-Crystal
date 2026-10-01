	db 0 ; species ID placeholder

	db  70,  70, 115,  60, 130,  90
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, STEEL ; type
	db 30 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/magnezone/front.dimensions"
	abilities_for MAGNEZONE, STURDY, ANALYTIC, LEVITATE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, FACADE, RETURN, SWAGGER, FLASH_CANNON, REST, ATTRACT
	; end

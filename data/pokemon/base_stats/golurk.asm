	db 0 ; species ID placeholder

	db  94, 124,  90,  87,  55,  55
	;  hp  atk  def  spd  sat  sdf

	db GROUND, GHOST ; type
	db 90 ; catch rate
	db 169 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/golurk/front.dimensions"
	abilities_for GOLURK, IRON_FIST, KLUTZ, NO_GUARD
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, FACADE, RETURN, SWAGGER, FLASH_CANNON, KNOCK_OFF, REST, ATTRACT, ZEN_HEADBUTT
	; end

	db 0 ; species ID placeholder

	db 110, 115,  80,  95,  60,  75
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, GHOST ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/annihilape/front.dimensions"
	abilities_for ANNIHILAPE, VITAL_SPIRIT, INNER_FOCUS, DEFIANT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, FACADE, RETURN, SWAGGER, BULK_UP, REST, ATTRACT, NIGHT_SLASH
	; end

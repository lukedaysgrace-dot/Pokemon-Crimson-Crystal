	db 0 ; species ID placeholder

	db 113,  70, 120,  52, 135,  65
	;  hp  atk  def  spd  sat  sdf

	db GROUND, NORMAL ; type
	db 60 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ursalunabm/front.dimensions"
	abilities_for URSALUNABM, GUTS, BERSERK, MINDS_EYE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, SWAGGER, SANDSTORM, BULK_UP, REST, ATTRACT, NIGHT_SLASH, STRENGTH
	; end

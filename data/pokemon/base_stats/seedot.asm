	db 0 ; species ID placeholder

	db 40, 40, 50, 30, 30, 30
	;  hp  atk  def  spd  sat  sdf

	db GRASS, GRASS ; type
	db 255 ; catch rate
	db 44 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/seedot/front.dimensions"
	abilities_for SEEDOT, PRANKSTER, WIND_RIDER, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, ENERGY_BALL, FACADE, SOLARBEAM, RETURN, DIG, SHADOW_BALL, SWAGGER, NASTY_PLOT, REST, ATTRACT, NIGHT_SLASH, FLASH
	; end

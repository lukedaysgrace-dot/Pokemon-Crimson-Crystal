	db 0 ; species ID placeholder

	db 45, 80, 100, 28, 35, 37
	;  hp  atk  def  spd  sat  sdf

	db STEEL, GHOST ; type
	db 180 ; catch rate
	db 65 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/honedge/front.dimensions"
	abilities_for HONEDGE, NO_GUARD, NO_GUARD, NO_GUARD
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, SWAGGER, FLASH_CANNON, REST, ATTRACT, FURY_CUTTER, NIGHT_SLASH, CUT
	; end

	db 0 ; species ID placeholder

	db 110,  85, 110,  35, 100, 100
	;   hp  atk  def  spd  sat  sdf

	db GRASS, DRAGON ; type
	db 45 ; catch rate
	db 170 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/appletun/front.dimensions"
	abilities_for APPLETUN, RIPEN, GLUTTONY, THICK_FAT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_PLANT, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, ENERGY_BALL, FACADE, SOLARBEAM, IRON_HEAD, RETURN, SWAGGER, REST, ATTRACT, THIEF, ZEN_HEADBUTT
	; end

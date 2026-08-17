	db 0 ; species ID placeholder

	db  95, 125,  85,  45, 105,  75
	;  hp  atk  def  spd  sat  sdf

	db GRASS, DRAGON ; type
	db 45 ; catch rate
	db 186 ; base exp
	db NO_ITEM, GOLD_BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/exeggutor_alolan/front.dimensions"
	abilities_for EXEGGUTOR_ALOLAN, FRISK, HARVEST, ROCK_HEAD
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_PLANT, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, ENERGY_BALL, SOLARBEAM, EARTHQUAKE, RETURN, SWAGGER, KNOCK_OFF, SLUDGE_BOMB, REST, ATTRACT, THIEF, ZEN_HEADBUTT, STRENGTH, FLASH, FLAMETHROWER
	; end

	db 0 ; species ID placeholder

	db  95, 105,  85,  45, 125,  75
	;  hp  atk  def  spd  sat  sdf

	db GRASS, DRAGON ; type
	db 45 ; catch rate
	db 212 ; base exp
	db NO_ITEM, GOLD_BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/exeggutor_alolan/front.dimensions"
	abilities_for EXEGGUTOR_ALOLAN, FRISK, FRISK, HARVEST
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_PLANT, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, GIGA_DRAIN, SOLARBEAM, EARTHQUAKE, RETURN, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, SLUDGE_BOMB, REST, ATTRACT, THIEF, FLASH, STRENGTH, DREAM_EATER, ENDURE, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER
	; end

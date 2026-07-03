	db 0 ; species ID placeholder

	db  95, 115,  80,  90,  95,  80
	;  hp  atk  def  spd  sat  sdf

	db FIRE, ROCK ; type
	db 75 ; catch rate
	db 213 ; base exp
	db NO_ITEM, ICE_BERRY ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/arcanine_hisuian/front.dimensions"
	abilities_for ARCANINE_HISUIAN, INTIMIDATE, FLASH_FIRE, ROCK_HEAD
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, SOLARBEAM, IRON_TAIL, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, FIRE_BLAST, SWIFT, REST, ATTRACT, THIEF, STRENGTH, ENDURE, HEADBUTT, SLEEP_TALK, SWAGGER
	; end

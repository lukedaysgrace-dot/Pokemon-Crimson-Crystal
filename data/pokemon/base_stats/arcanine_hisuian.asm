	db 0 ; species ID placeholder

	db  95, 120,  85,  90,  80,  85
	;  hp  atk  def  spd  sat  sdf

	db FIRE, ROCK ; type
	db 75 ; catch rate
	db 194 ; base exp
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
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, SOLARBEAM, IRON_HEAD, RETURN, DIG, SWAGGER, FIRE_BLAST, SWIFT, REST, ATTRACT, THIEF, POWER_GEM, STRENGTH, FLAMETHROWER
	; end

	db 0 ; species ID placeholder

	db  60,  75,  45,  55,  65,  50
	;  hp  atk  def  spd  sat  sdf

	db FIRE, ROCK ; type
	db 190 ; catch rate
	db 91 ; base exp
	db ICE_BERRY, ICE_BERRY ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/growlithe_hisuian/front.dimensions"
	abilities_for GROWLITHE_HISUIAN, INTIMIDATE, FLASH_FIRE, ROCK_HEAD
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, IRON_TAIL, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, FIRE_BLAST, SWIFT, REST, ATTRACT, THIEF, STRENGTH, ENDURE, HEADBUTT, SLEEP_TALK, SWAGGER
	; end

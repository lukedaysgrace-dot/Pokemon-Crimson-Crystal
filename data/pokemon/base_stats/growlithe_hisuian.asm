	db 0 ; species ID placeholder

	db  60,  75,  45,  55,  65,  50
	;  hp  atk  def  spd  sat  sdf

	db FIRE, ROCK ; type
	db 190 ; catch rate
	db 70 ; base exp
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
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, WILL_O_WISP, IRON_HEAD, RETURN, DIG, SWAGGER, FIRE_BLAST, SWIFT, REST, ATTRACT, THIEF, POWER_GEM, STRENGTH, FLAMETHROWER
	; end

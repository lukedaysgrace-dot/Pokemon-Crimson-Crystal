	db 0 ; species ID placeholder

	db 100, 134, 110,  61,  95, 100
	;   hp  atk  def  spd  sat  sdf

	db ROCK, DARK ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tyranitar/front.dimensions"
	abilities_for TYRANITAR, SAND_STREAM, NO_ABILITY, INTIMIDATE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, KNOCK_OFF, SANDSTORM, FIRE_BLAST, DRAGON_DANCE, REST, ATTRACT, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, POWER_GEM, CUT, SURF, STRENGTH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

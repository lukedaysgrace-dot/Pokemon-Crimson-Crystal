	db 0 ; species ID placeholder

	db  78,  84,  78, 100, 110,  85
	;   hp  atk  def  spd  sat  sdf

	db FIRE, DRAGON ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/charizard/front.dimensions"
	abilities_for CHARIZARD, LEVITATE, BLAZE, DROUGHT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, SWIFT, DRAGON_DANCE, REST, ATTRACT, STEEL_WING, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, CUT, FLY, STRENGTH, FLAMETHROWER
	; end

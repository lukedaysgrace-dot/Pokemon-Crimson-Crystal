	db 0 ; species ID placeholder

	db  58,  64,  58,  80,  80,  65
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 142 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/charmeleon_clone/front.dimensions"
	abilities_for CHARMELEON_CLONE, SOLAR_POWER, BLAZE, DROUGHT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, WILL_O_WISP, FACADE, IRON_HEAD, DRAGON_CLAW, RETURN, DIG, MUD_SLAP, SWAGGER, FIRE_BLAST, SWIFT, DRAGON_DANCE, REST, ATTRACT, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, CUT, STRENGTH, FLAMETHROWER
	; end

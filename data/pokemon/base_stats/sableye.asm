	db 0 ; species ID placeholder

	db 60, 75, 100, 50, 75, 100
	;  hp  atk  def  spd  sat  sdf

	db DARK, GHOST ; type
	db 45 ; catch rate
	db 133 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sableye/front.dimensions"
	abilities_for SABLEYE, MAGIC_BOUNCE, KEEN_EYE, PRANKSTER
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, WILL_O_WISP, FACADE, RETURN, DIG, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, BULK_UP, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, FIRE_PUNCH, FURY_CUTTER, HONE_CLAWS, ZEN_HEADBUTT, POWER_GEM, CUT, FLASH
	; end

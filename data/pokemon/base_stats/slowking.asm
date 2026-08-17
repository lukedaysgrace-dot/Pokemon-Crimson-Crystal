	db 0 ; species ID placeholder

	db  95,  75,  80,  30, 100, 110
	;   hp  atk  def  spd  sat  sdf

	db WATER, PSYCHIC ; type
	db 70 ; catch rate
	db 172 ; base exp
	db NO_ITEM, KINGS_ROCK ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/slowking/front.dimensions"
	abilities_for SLOWKING, OBLIVIOUS, OWN_TEMPO, REGENERATOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MONSTER, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, FIRE_BLAST, SWIFT, NASTY_PLOT, REST, ATTRACT, BUG_BITE, ZEN_HEADBUTT, POWER_GEM, SURF, STRENGTH, FLASH, WHIRLPOOL, FLAMETHROWER, ICE_BEAM
	; end

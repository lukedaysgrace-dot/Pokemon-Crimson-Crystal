	db 0 ; species ID placeholder

	db  95, 100,  95,  30, 100,  70
	;  hp  atk  def  spd  sat  sdf

	db POISON, PSYCHIC ; type
	db 75 ; catch rate
	db 207 ; base exp
	db NO_ITEM, KINGS_ROCK ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/slowbro_galarian/front.dimensions"
	abilities_for SLOWBRO_GALARIAN, OWN_TEMPO, NO_ABILITY, REGENERATOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MONSTER, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, FIRE_BLAST, SWIFT, NASTY_PLOT, REST, ATTRACT, ZEN_HEADBUTT, POWER_GEM, SURF, STRENGTH, FLASH, WHIRLPOOL, WATERFALL, FLAMETHROWER, ICE_BEAM
	; end

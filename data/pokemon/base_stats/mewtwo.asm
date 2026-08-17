	db 0 ; species ID placeholder

	db 106, 110,  90, 130, 154,  90
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 40 ; catch rate
	db 255 ; base exp
	db NO_ITEM, BERSERK_GENE ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 120 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mewtwo/front.dimensions"
	abilities_for MEWTWO, PRESSURE, NO_ABILITY, UNNERVE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, SOLARBEAM, IRON_HEAD, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, FIRE_BLAST, SWIFT, BULK_UP, THUNDERPUNCH, NASTY_PLOT, REST, FIRE_PUNCH, ZEN_HEADBUTT, POWER_GEM, STRENGTH, FLASH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

	db 0 ; species ID placeholder

	db  91, 134,  95,  80, 100, 100
	;   hp  atk  def  spd  sat  sdf

	db DRAGON, FLYING ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, DRAGON_SCALE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/dragonite/front.dimensions"
	abilities_for DRAGONITE, MARVEL_SCALE, SHED_SKIN, MULTISCALE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_1, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, DRAGON_CLAW, THUNDER, RETURN, MUD_SLAP, SWAGGER, ICE_PUNCH, SANDSTORM, FIRE_BLAST, SWIFT, THUNDERPUNCH, DRAGON_DANCE, REST, ATTRACT, STEEL_WING, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, FLY, SURF, STRENGTH, WHIRLPOOL, WATERFALL, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

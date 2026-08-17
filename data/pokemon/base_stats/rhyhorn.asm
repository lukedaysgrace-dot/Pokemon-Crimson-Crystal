	db 0 ; species ID placeholder

	db  80,  85,  95,  25,  30,  30
	;   hp  atk  def  spd  sat  sdf

	db GROUND, ROCK ; type
	db 120 ; catch rate
	db 69 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/rhyhorn/front.dimensions"
	abilities_for RHYHORN, ROCK_HEAD, RECKLESS, SHEER_FORCE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, PROTECT, FACADE, IRON_HEAD, THUNDER, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, REST, ATTRACT, STRENGTH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

	db 0 ; species ID placeholder

	db 250,   5,   5,  50,  35, 105
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 255 ; base exp
	db OVAL_STONE, LUCKY_EGG ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/chansey/front.dimensions"
	abilities_for CHANSEY, SERENE_GRACE, NATURAL_CURE, NO_ABILITY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_FAIRY, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, SOLARBEAM, IRON_HEAD, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH, FLASH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

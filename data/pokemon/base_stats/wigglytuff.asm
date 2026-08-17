	db 0 ; species ID placeholder

	db 140,  80,  55,  55,  95,  60
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FAIRY ; type
	db 50 ; catch rate
	db 218 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/wigglytuff/front.dimensions"
	abilities_for WIGGLYTUFF, MAGIC_GUARD, COMPETITIVE, FRISK
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_FAIRY, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, SOLARBEAM, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, FIRE_BLAST, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, FIRE_PUNCH, ZEN_HEADBUTT, STRENGTH, FLASH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

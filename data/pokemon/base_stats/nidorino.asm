	db 0 ; species ID placeholder

	db  61,  72,  57,  65,  55,  55
	;   hp  atk  def  spd  sat  sdf

	db POISON, POISON ; type
	db 120 ; catch rate
	db 128 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/nidorino/front.dimensions"
	abilities_for NIDORINO, POISON_POINT, RIVALRY, HUSTLE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, MUD_SLAP, SWAGGER, REST, ATTRACT, THIEF, HONE_CLAWS, STRENGTH, THUNDERBOLT, ICE_BEAM
	; end

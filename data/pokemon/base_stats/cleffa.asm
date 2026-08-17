	db 0 ; species ID placeholder

	db  50,  25,  28,  15,  45,  55
	;   hp  atk  def  spd  sat  sdf

	db FAIRY, FAIRY ; type
	db 150 ; catch rate
	db 44 ; base exp
	db MYSTERYBERRY, MOON_STONE ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/cleffa/front.dimensions"
	abilities_for CLEFFA, CUTE_CHARM, MAGIC_GUARD, NO_ABILITY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, RAIN_DANCE, FACADE, SOLARBEAM, IRON_HEAD, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, FIRE_BLAST, REST, ATTRACT, ZEN_HEADBUTT, FLASH, FLAMETHROWER
	; end

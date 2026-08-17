	db 0 ; species ID placeholder

	db  90,  30,  15,  15,  40,  20
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FAIRY ; type
	db 170 ; catch rate
	db 42 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/igglybuff/front.dimensions"
	abilities_for IGGLYBUFF, MAGIC_GUARD, COMPETITIVE, CUTE_CHARM
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, RAIN_DANCE, FACADE, SOLARBEAM, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, FIRE_BLAST, REST, ATTRACT, FLASH, FLAMETHROWER
	; end

	db 0 ; species ID placeholder

	db  75, 110, 105, 100,  30,  70
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, WATER ; type
	db 45 ; catch rate
	db 211 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tauros_paldean_water/front.dimensions"
	abilities_for TAUROS_PALDEAN_WATER, INTIMIDATE, ANGER_POINT, CUD_CHEW
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_TAIL, EARTHQUAKE, RETURN, ROCK_SMASH, DOUBLE_TEAM, REST, ATTRACT, SURF, STRENGTH, WHIRLPOOL, ENDURE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER
	; end

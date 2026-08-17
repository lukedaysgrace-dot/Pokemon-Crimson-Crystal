	db 0 ; species ID placeholder

	db  50,  95, 180,  70,  85,  45
	;   hp  atk  def  spd  sat  sdf

	db WATER, ICE ; type
	db 60 ; catch rate
	db 184 ; base exp
	db PEARL, BIG_PEARL ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/cloyster/front.dimensions"
	abilities_for CLOYSTER, SKILL_LINK, SHELL_ARMOR, ICE_BODY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_3, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, ICICLE_CRASH, PROTECT, RAIN_DANCE, FACADE, RETURN, SWAGGER, SWIFT, REST, ATTRACT, SURF, WHIRLPOOL, ICE_BEAM
	; end

	db 0 ; species ID placeholder

	db  70, 135,  95,  85,  45,  70
	;   hp  atk  def  spd  sat  sdf

	db BUG, ROCK ; type
	db 25 ; catch rate
	db 175 ; base exp
	db NO_ITEM, HARD_STONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/kleavor/front.dimensions"
	abilities_for KLEAVOR, TECHNICIAN, SHEER_FORCE, SHARPNESS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_BUG, EGG_BUG ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, RETURN, SWAGGER, SANDSTORM, SWIFT, REST, ATTRACT, THIEF, BUG_BITE, NIGHT_SLASH, CUT, STRENGTH
	; end

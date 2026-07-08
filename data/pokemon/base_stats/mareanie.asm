	db 0 ; species ID placeholder

	db  50,  53,  62,  45,  43,  52
	;   hp  atk  def  spd  sat  sdf

	db POISON, WATER ; type
	db 190 ; catch rate
	db 61 ; base exp
	db NO_ITEM, POISON_BARB ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mareanie/front.dimensions"
	abilities_for MAREANIE, MERCILESS, LIMBER, REGENERATOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm TOXIC, HIDDEN_POWER, SNORE, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SLUDGE_BOMB, SWAGGER, SLEEP_TALK, REST, ATTRACT, SURF, WHIRLPOOL
	; end

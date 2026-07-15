	db 0 ; species ID placeholder

	db  86,  81,  97,  43,  86, 107
	;  hp  atk  def  spd  sat  sdf

	db ROCK, GRASS ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/cradily/front.dimensions"
	abilities_for CRADILY, STORM_DRAIN, STAMINA, REGENERATOR
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_3, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT
	; end

	db 0 ; species ID placeholder

	db  75,  90,  90,  80,  90, 105
	;  hp  atk  def  spd  sat  sdf

	db DRAGON, FAIRY ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/altaria/front.dimensions"
	abilities_for ALTARIA, CLOUD_NINE, NATURAL_CURE, PIXILATE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_FLYING, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, FLY, STEEL_WING
	; end

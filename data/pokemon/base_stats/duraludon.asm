	db 0 ; species ID placeholder

	db  70,  95, 115,  85, 120,  50
	;  hp  atk  def  spd  sat  sdf

	db STEEL, DRAGON ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/duraludon/front.dimensions"
	abilities_for DURALUDON, STURDY, NO_ABILITY, STEADFAST
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, EARTHQUAKE, DIG, SANDSTORM, ROCK_SMASH, STRENGTH
	; end

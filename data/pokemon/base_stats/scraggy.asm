	db 0 ; species ID placeholder

	db  50,  75,  70,  48,  35,  70
	;  hp  atk  def  spd  sat  sdf

	db DARK, FIGHTING ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/scraggy/front.dimensions"
	abilities_for SCRAGGY, SHED_SKIN, MOXIE, INTIMIDATE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, DYNAMICPUNCH, ROCK_SMASH, STRENGTH
	; end

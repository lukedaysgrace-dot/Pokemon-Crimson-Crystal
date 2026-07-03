	db 0 ; species ID placeholder

	db  10,  55,  30,  90,  35,  45
	;  hp  atk  def  spd  sat  sdf

	db GROUND, STEEL ; type
	db 255 ; catch rate
	db 81 ; base exp
	db NO_ITEM, SOFT_SAND ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/diglett_alolan/front.dimensions"
	abilities_for DIGLETT_ALOLAN, SAND_VEIL, TANGLING_HAIR, SAND_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, EARTHQUAKE, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, SLUDGE_BOMB, SANDSTORM, REST, ATTRACT, THIEF, CUT, ENDURE, HEADBUTT, SLEEP_TALK, SWAGGER
	; end

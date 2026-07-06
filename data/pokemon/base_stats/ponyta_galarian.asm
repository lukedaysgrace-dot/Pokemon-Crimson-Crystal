	db 0 ; species ID placeholder

	db  50,  85,  55,  90,  65,  65
	;  hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 190 ; catch rate
	db 152 ; base exp
	db NO_ITEM, MIRACLEBERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ponyta_galarian/front.dimensions"
	abilities_for PONYTA_GALARIAN, PASTEL_VEIL, NO_ABILITY, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, IRON_TAIL, RETURN, DOUBLE_TEAM, SWIFT, REST, ATTRACT, STRENGTH, ENDURE, HEADBUTT, SLEEP_TALK, SWAGGER
	; end

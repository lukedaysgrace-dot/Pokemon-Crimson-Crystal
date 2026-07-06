	db 0 ; species ID placeholder

	db  45,  45,  30,  50,  55,  40
	;  hp  atk  def  spd  sat  sdf

	db DARK, FAIRY ; type
	db 255 ; catch rate
	db 53 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio (male only)
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/impidimp/front.dimensions"
	abilities_for IMPIDIMP, PRANKSTER, FRISK, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT
	; end

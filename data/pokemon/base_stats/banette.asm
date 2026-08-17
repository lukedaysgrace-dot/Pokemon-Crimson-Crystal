	db 0 ; species ID placeholder

	db  64, 125,  65,  70,  93,  63
	;   hp  atk  def  spd  sat  sdf

	db GHOST, NORMAL ; type
	db 45 ; catch rate
	db 159 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/banette/front.dimensions"
	abilities_for BANETTE, FRISK, CURSED_BODY, PRANKSTER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, ICE_PUNCH, KNOCK_OFF, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, FIRE_PUNCH, STRENGTH
	; end

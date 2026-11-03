	db 0 ; species ID placeholder
	db 55, 100, 60, 110, 125, 60
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, GHOST ; type (Hisuian form)
	db 45 ; catch rate
	db 179 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/zoroark/front.dimensions"
	abilities_for ZOROARK, ILLUSION, ILLUSION, ILLUSION
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, ROCK_SMASH, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, RETURN, DIG, PSYCHIC_M, SHADOW_BALL, KNOCK_OFF, SLUDGE_BOMB, SWIFT, NASTY_PLOT, REST, THIEF, HONE_CLAWS, FLAMETHROWER
	; end

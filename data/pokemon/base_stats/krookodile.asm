	db 0 ; species ID placeholder

	db  95, 117,  80,  92,  65,  70
	;   hp  atk  def  spd  sat  sdf

	db GROUND, DARK ; type
	db 45 ; catch rate
	db 234 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/krookodile/front.dimensions"
	abilities_for KROOKODILE, INTIMIDATE, MOXIE, ANGER_POINT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, DRAGON_CLAW, HIDDEN_POWER, WORK_UP, HYPER_BEAM, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SLUDGE_BOMB, SANDSTORM, SWIFT, BULK_UP, REST, ATTRACT, THIEF, CUT, STRENGTH
	; end

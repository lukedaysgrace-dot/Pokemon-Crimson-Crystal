	db 0 ; species ID placeholder

	db  55,  95,  55, 115,  35,  75
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, POISON ; type
	db 60 ; catch rate
	db 86 ; base exp
	db QUICK_CLAW, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sneasel_hisuian/front.dimensions"
	abilities_for SNEASEL_HISUIAN, INNER_FOCUS, POISON_TOUCH, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, SWIFT, BULK_UP, NASTY_PLOT, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, CUT, SURF, STRENGTH, WHIRLPOOL
	; end

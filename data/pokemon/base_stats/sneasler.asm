	db 0 ; species ID placeholder

	db  80, 130,  60, 120,  40,  80
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, POISON ; type
	db 45 ; catch rate
	db 179 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sneasler/front.dimensions"
	abilities_for SNEASLER, PRESSURE, POISON_TOUCH, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, SWIFT, BULK_UP, NASTY_PLOT, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, CUT, SURF, STRENGTH, WHIRLPOOL
	; end

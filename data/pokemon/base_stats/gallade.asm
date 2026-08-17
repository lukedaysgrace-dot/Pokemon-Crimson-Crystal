	db 0 ; species ID placeholder

	db  68, 125,  65,  80,  65, 115
	;  hp  atk  def  spd  sat  sdf

	db PSYCHIC, FIGHTING ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/gallade/front.dimensions"
	abilities_for GALLADE, STEADFAST, SHARPNESS, JUSTIFIED
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, WORK_UP, PROTECT, WILL_O_WISP, FACADE, RETURN, PSYCHIC_M, SWAGGER, KNOCK_OFF, SWIFT, BULK_UP, REST, ATTRACT, THIEF, NIGHT_SLASH, ZEN_HEADBUTT, CUT, STRENGTH
	; end

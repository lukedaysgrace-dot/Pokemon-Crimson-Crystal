	db 0 ; species ID placeholder

	db  60, 130,  80,  70,  60,  60
	;  hp  atk  def  spd  sat  sdf

	db GRASS, FIGHTING ; type
	db 90 ; catch rate
	db 161 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/breloom/front.dimensions"
	abilities_for BRELOOM, TECHNICIAN, POISON_HEAL, QUICK_FEET
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FAIRY, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, ENERGY_BALL, FACADE, RETURN, SWAGGER, BULK_UP, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH
	; end

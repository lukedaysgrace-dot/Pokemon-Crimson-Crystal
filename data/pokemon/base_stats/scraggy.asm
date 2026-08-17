	db 0 ; species ID placeholder

	db  50,  75,  70,  48,  35,  70
	;  hp  atk  def  spd  sat  sdf

	db DARK, FIGHTING ; type
	db 180 ; catch rate
	db 70 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/scraggy/front.dimensions"
	abilities_for SCRAGGY, SHED_SKIN, MOXIE, INTIMIDATE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, CURSE, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, WORK_UP, PROTECT, FACADE, DRAGON_CLAW, RETURN, SWAGGER, KNOCK_OFF, BULK_UP, DRAGON_DANCE, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH
	; end

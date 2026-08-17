	db 0 ; species ID placeholder

	db  46,  87,  60,  57,  30,  40
	;  hp  atk  def  spd  sat  sdf

	db DRAGON, DRAGON ; type
	db 75 ; catch rate
	db 64 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/axew/front.dimensions"
	abilities_for AXEW, RIVALRY, MOLD_BREAKER, UNNERVE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, DRAGON_PULSE, HIDDEN_POWER, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, RETURN, SWAGGER, DRAGON_DANCE, REST, ATTRACT, HONE_CLAWS, NIGHT_SLASH, STRENGTH
	; end

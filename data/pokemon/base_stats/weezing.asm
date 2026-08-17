	db 0 ; species ID placeholder

	db  65,  90, 120,  60,  85,  70
	;   hp  atk  def  spd  sat  sdf

	db POISON, POISON ; type
	db 60 ; catch rate
	db 172 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/weezing/front.dimensions"
	abilities_for WEEZING, LEVITATE, NEUTRALIZING_GAS, STENCH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, THUNDER, RETURN, SWAGGER, SLUDGE_BOMB, FIRE_BLAST, REST, ATTRACT, THIEF, FLAMETHROWER, THUNDERBOLT
	; end

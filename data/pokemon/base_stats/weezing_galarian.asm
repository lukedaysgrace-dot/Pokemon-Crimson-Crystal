	db 0 ; species ID placeholder

	db  65,  80, 120,  60,  95,  70
	;  hp  atk  def  spd  sat  sdf

	db POISON, FAIRY ; type
	db 60 ; catch rate
	db 172 ; base exp
	db NO_ITEM, SMOKE_BALL ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/weezing_galarian/front.dimensions"
	abilities_for WEEZING_GALARIAN, LEVITATE, NEUTRALIZING_GAS, WHITE_SMOKE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, WILL_O_WISP, THUNDER, RETURN, SHADOW_BALL, SWAGGER, SLUDGE_BOMB, FIRE_BLAST, REST, ATTRACT, THIEF, FLASH, FLAMETHROWER, THUNDERBOLT
	; end

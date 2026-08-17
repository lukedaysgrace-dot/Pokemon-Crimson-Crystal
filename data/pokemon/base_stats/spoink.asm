	db 0 ; species ID placeholder

	db  60,  25,  35,  60,  70,  80
	;  hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 255 ; catch rate
	db 66 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/spoink/front.dimensions"
	abilities_for SPOINK, THICK_FAT, OWN_TEMPO, GLUTTONY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, FACADE, RETURN, SWAGGER, FLASH_CANNON, REST, ATTRACT, ZEN_HEADBUTT, POWER_GEM
	; end

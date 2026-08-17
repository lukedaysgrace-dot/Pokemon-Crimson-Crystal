	db 0 ; species ID placeholder

	db  60,  40,  80,  40,  60,  45
	;   hp  atk  def  spd  sat  sdf

	db GRASS, PSYCHIC ; type
	db 90 ; catch rate
	db 65 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/exeggcute/front.dimensions"
	abilities_for EXEGGCUTE, CHLOROPHYLL, NO_ABILITY, HARVEST
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_PLANT, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, ENERGY_BALL, FACADE, SOLARBEAM, RETURN, PSYCHIC_M, SWAGGER, SLUDGE_BOMB, REST, ATTRACT, THIEF, ZEN_HEADBUTT, STRENGTH, FLASH
	; end

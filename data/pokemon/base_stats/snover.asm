	db 0 ; species ID placeholder

	db  60,  62,  50,  40,  62,  60
	;  hp  atk  def  spd  sat  sdf

	db GRASS, ICE ; type
	db 120 ; catch rate
	db 67 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/snover/front.dimensions"
	abilities_for SNOVER, SNOW_WARNING, SOUNDPROOF, THICK_FAT
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, ENERGY_BALL, FACADE, RETURN, SWAGGER, REST, ATTRACT
	; end

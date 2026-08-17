	db 0 ; species ID placeholder

	db  50,  50,  50,  20,  90,  50
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 190 ; catch rate
	db 50 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/slugma/front.dimensions"
	abilities_for SLUGMA, MAGMA_ARMOR, FLAME_BODY, WEAK_ARMOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, WILL_O_WISP, FACADE, RETURN, MUD_SLAP, SWAGGER, FIRE_BLAST, REST, ATTRACT, POWER_GEM, FLAMETHROWER
	; end

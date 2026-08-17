	db 0 ; species ID placeholder

	db  60,  50, 150,  30, 110, 100
	;   hp  atk  def  spd  sat  sdf

	db FIRE, ROCK ; type
	db 75 ; catch rate
	db 151 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/magcargo/front.dimensions"
	abilities_for MAGCARGO, SOLID_ROCK, FLAME_BODY, WEAK_ARMOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, FIRE_BLAST, REST, ATTRACT, POWER_GEM, STRENGTH, FLAMETHROWER
	; end

	db 0 ; species ID placeholder

	db  75,  90, 140,  40,  60,  60
	;   hp  atk  def  spd  sat  sdf

	db BUG, STEEL ; type
	db 75 ; catch rate
	db 163 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/forretress/front.dimensions"
	abilities_for FORRETRESS, STURDY, NO_ABILITY, OVERCOAT
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_BUG, EGG_BUG ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, SWEET_SCENT, HYPER_BEAM, PROTECT, ENERGY_BALL, FACADE, SOLARBEAM, RETURN, SWAGGER, FLASH_CANNON, SANDSTORM, REST, ATTRACT, STRENGTH
	; end

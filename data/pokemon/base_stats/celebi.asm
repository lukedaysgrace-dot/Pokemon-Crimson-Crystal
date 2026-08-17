	db 0 ; species ID placeholder

	db 100, 100, 100, 100, 100, 100
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, GRASS ; type
	db 25 ; catch rate
	db 255 ; base exp
	db NO_ITEM, MIRACLEBERRY ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 120 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/celebi/front.dimensions"
	abilities_for CELEBI, NATURAL_CURE, NO_ABILITY, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, SWEET_SCENT, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, FACADE, SOLARBEAM, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, SANDSTORM, SWIFT, NASTY_PLOT, REST, ZEN_HEADBUTT, FLASH
	; end

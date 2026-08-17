	db 0 ; species ID placeholder

	db 106, 130,  90,  90, 110, 154
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FLYING ; type
	db 40 ; catch rate
	db 255 ; base exp
	db SACRED_ASH, SACRED_ASH ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 120 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ho_oh/front.dimensions"
	abilities_for HO_OH, PRESSURE, NO_ABILITY, REGENERATOR
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, WILL_O_WISP, FACADE, SOLARBEAM, THUNDER, EARTHQUAKE, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, SWIFT, REST, STEEL_WING, ZEN_HEADBUTT, FLY, STRENGTH, FLASH, FLAMETHROWER, THUNDERBOLT
	; end

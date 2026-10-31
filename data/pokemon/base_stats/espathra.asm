	db 0 ; species ID placeholder

	db  95,  60,  60, 105, 101,  60
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 45 ; catch rate
	db 168 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/espathra/front.dimensions"
	abilities_for ESPATHRA, COMPETITIVE, FRISK, SPEED_BOOST
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, PSYCHIC_M, SHADOW_BALL, FLASH_CANNON, SWIFT, REST, THIEF, ZEN_HEADBUTT, ENERGY_BALL, MUD_SLAP, RAIN_DANCE, SANDSTORM
	; end

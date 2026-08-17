	db 0 ; species ID placeholder

	db  60,  55, 100,  30,  65, 100
	;  hp  atk  def  spd  sat  sdf

	db GHOST, GHOST ; type
	db 60 ; catch rate
	db 144 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/corsola_galarian/front.dimensions"
	abilities_for CORSOLA_GALARIAN, WEAK_ARMOR, NO_ABILITY, CURSED_BODY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, PROTECT, RAIN_DANCE, ENERGY_BALL, WILL_O_WISP, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, SWAGGER, SANDSTORM, REST, ATTRACT, POWER_GEM, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end

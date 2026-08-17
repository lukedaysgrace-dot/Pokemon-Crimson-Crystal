	db 0 ; species ID placeholder

	db  90, 115, 125,  30,  30,  75
	;   hp  atk  def  spd  sat  sdf

	db ROCK, ROCK ; type
	db 65 ; catch rate
	db 144 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sudowoodo/front.dimensions"
	abilities_for SUDOWOODO, ROCK_HEAD, STURDY, RATTLED
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, SANDSTORM, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, POWER_GEM, STRENGTH
	; end

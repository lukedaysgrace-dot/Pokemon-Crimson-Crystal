	db 0 ; species ID placeholder

	db  60,  85, 100,  10,  10,  60
	;  hp  atk  def  spd  sat  sdf

	db ROCK, ROCK ; type
	db 255 ; catch rate
	db 68 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/bonsly/front.dimensions"
	abilities_for BONSLY, STURDY, ROCK_HEAD, RATTLED
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RETURN, DIG, SWAGGER, SANDSTORM, REST, ATTRACT, THIEF, POWER_GEM
	; end

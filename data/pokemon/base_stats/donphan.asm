	db 0 ; species ID placeholder

	db  90, 120, 120,  50,  60,  60
	;   hp  atk  def  spd  sat  sdf

	db GROUND, GROUND ; type
	db 60 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/donphan/front.dimensions"
	abilities_for DONPHAN, SAND_VEIL, STURDY, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, SANDSTORM, REST, ATTRACT, STRENGTH
	; end

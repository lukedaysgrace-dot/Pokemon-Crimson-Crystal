	db 0 ; species ID placeholder

	db 105,  95,  75,  45,  55,  55
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, DRAGON ; type
	db 190 ; catch rate
	db 145 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/dunsparce/front.dimensions"
	abilities_for DUNSPARCE, SERENE_GRACE, RATTLED, RUN_AWAY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, FACADE, SOLARBEAM, IRON_HEAD, THUNDER, RETURN, DIG, MUD_SLAP, SWAGGER, REST, ATTRACT, THIEF, ZEN_HEADBUTT, STRENGTH, FLAMETHROWER, THUNDERBOLT
	; end

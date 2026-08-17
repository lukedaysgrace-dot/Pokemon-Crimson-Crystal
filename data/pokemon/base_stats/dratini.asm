	db 0 ; species ID placeholder

	db  41,  64,  45,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db DRAGON, DRAGON ; type
	db 45 ; catch rate
	db 60 ; base exp
	db NO_ITEM, DRAGON_SCALE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/dratini/front.dimensions"
	abilities_for DRATINI, MARVEL_SCALE, SHED_SKIN, MULTISCALE
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_1, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ZAP_CANNON, DRAGON_PULSE, HIDDEN_POWER, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, SWAGGER, FIRE_BLAST, SWIFT, DRAGON_DANCE, REST, ATTRACT, SURF, WATERFALL, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end

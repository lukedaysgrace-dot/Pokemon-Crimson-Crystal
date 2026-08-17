	db 0 ; species ID placeholder

	db  30,  40,  70,  60,  70,  25
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 225 ; catch rate
	db 59 ; base exp
	db NO_ITEM, DRAGON_SCALE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/horsea/front.dimensions"
	abilities_for HORSEA, SWIFT_SWIM, SNIPER, DAMP
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, DRAGON_PULSE, HIDDEN_POWER, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, RETURN, SWAGGER, FLASH_CANNON, SWIFT, DRAGON_DANCE, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end

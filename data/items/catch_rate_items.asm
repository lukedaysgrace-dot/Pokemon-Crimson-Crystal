; Pokémon traded from RBY do not have held items, so GSC usually interprets the
; catch rate as an item. However, if the catch rate appears in this table, the
; item associated with the table entry is used instead.

TimeCapsule_CatchRateItems:
	db SKATEBOARD, LEFTOVERS ; $19 (formerly ITEM_19)
	db TART_APPLE, BITTER_BERRY
	db SWEET_APPLE, GOLD_BERRY
	db ICE_STONE, BERRY
	db SYRUPY_APPLE, BERRY
	db RELIC_CLOCK, BERRY
	db ABILITY_CAP, BERRY
	db TOXIC_ORB, BERRY
	db ITEM_C3, BERRY
	db ITEM_DC, BERRY
	db ITEM_FA, BERRY
	db -1,      BERRY
	db 0 ; end

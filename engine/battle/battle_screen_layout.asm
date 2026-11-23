; _CGB_FinishBattleScreenLayout's attribute map, kept out of the full
; graphics bank (farcalled from engine/gfx/cgb_layouts.asm).
FinishBattleScreenLayout::
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, PAL_BATTLE_BG_ENEMY_HP
	call ByteFill
	hlcoord 0, 4, wAttrMap
	lb bc, 8, 10
	ld a, PAL_BATTLE_BG_PLAYER
	call FillBoxWithByte
	hlcoord 10, 0, wAttrMap
	lb bc, 7, 10
	ld a, PAL_BATTLE_BG_ENEMY
	call FillBoxWithByte
	; (Removed a redundant re-fill of rows 0-3, cols 0-9 with PAL_BATTLE_BG_ENEMY_HP;
	;  the full-screen ByteFill above already set that region to ENEMY_HP, and nothing
	;  overwrites it in between. Freed space keeps bank2 within its 0x4000 limit.)
	hlcoord 10, 7, wAttrMap
	lb bc, 5, 10
	ld a, PAL_BATTLE_BG_PLAYER_HP
	call FillBoxWithByte
	hlcoord 10, 11, wAttrMap
	lb bc, 1, 9
	ld a, PAL_BATTLE_BG_EXP
	call FillBoxWithByte
	hlcoord 1, 9, wAttrMap
	lb bc, 1, 6
	ld a, PAL_BATTLE_BG_TYPE_CAT
	call FillBoxWithByte
	hlcoord 0, 12, wAttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, PAL_BATTLE_BG_TEXT
	call ByteFill
	; Recolor the two shiny star icon tiles blue (exp bar palette). These tiles
	; are blank unless the mon is shiny, so this is invisible for normal mons.
	ld a, PAL_BATTLE_BG_EXP
	ld [wAttrMap + 1 * SCREEN_WIDTH + 4], a
	ld [wAttrMap + 8 * SCREEN_WIDTH + 12], a
	farcall ApplyAttrMap
	ret

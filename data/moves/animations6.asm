; October 2026 move ports. Source revisions are recorded in tools/testdata/move-expansion-2026-10-19.md.
; All called helpers are copied into this bank; no cross-bank anim_call.

; Adapted from polishedcoral
BattleAnim_FollowEnemyFeet_1_PC19:
	anim_enemyfeetobj
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 6
	anim_ret


; Adapted from polishedcoral
BattleAnim_Psyshock_Oct19:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PSYCHO_BOOST_2
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_CHARGE
	anim_call BattleAnim_FollowEnemyFeet_1_PC19
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_GLIMMER, 44, 88, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_PSYCHIC
	anim_bgeffect ANIM_BG_TELEPORT, $0, $0, $0
.loop
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $38
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $8
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $10
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $28
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $0
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $18
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 136, 48, $30
	anim_wait 4
	anim_loop 2, .loop
	anim_wait 1
	anim_1gfx ANIM_GFX_GLOW
.loop2
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 148, 36, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 116, 48, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 132, 60, $0
	anim_wait 4
	anim_loop 2, .loop2
	anim_wait 28
	anim_incbgeffect ANIM_BG_TELEPORT
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 1
	anim_clearobjs
	anim_ret
	

; Adapted from polishedcoral
BattleAnim_ShowMon_0_PC19:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj  1
	anim_wait 1
	anim_ret


; Adapted from polishedcoral
BattleAnim_TargetObj_2Row_PC19:
	anim_playerheadobj
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret


; Adapted from polishedcoral
BattleAnim_DragonHammer_Oct19:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_SMOKE_PUFF
	anim_call BattleAnim_TargetObj_2Row_PC19
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_wait 8
	anim_call BattleAnim_ShowMon_0_PC19
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGONBREATH
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BRIGHT
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 08, $0
	anim_wait 1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 16, $0
	anim_wait 1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 24, $0
	anim_wait 1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 32, $0
	anim_wait 1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 40, $0
	anim_wait 1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 48, $0
	anim_wait 1
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 60, $0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $60, $2, $20
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 1
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 1
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 44
	anim_ret
	

; Adapted from polishedcoral
BattleAnim_CottonGuard_Oct19:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_COTTON_GUARD
	anim_1gfx ANIM_GFX_COTTON
	anim_sound 0, 1, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_COTTON_GUARD, 52, 84, $38
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 36, 92, $20
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 60, 98, $8
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 52, 104, $10
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 38, 80, $28
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 64, 82, $0
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 44, 102, $18
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_COTTON_GUARD, 54, 72, $30
	anim_wait 12
	anim_sound 0, 1, SFX_JUMP_OVER_LEDGE
	anim_wait 48
	anim_ret


; Adapted from polishedcoral
BattleAnim_CosmicPower_Oct19:
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_COSMIC
	anim_2gfx ANIM_GFX_STARS, ANIM_GFX_COSMIC_POWER
	anim_clearopponenthud
	anim_bgp $1b
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $0, $0
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_CYCLE_BGPALS_INVERTED, $0, $4, $0
	anim_sound 0, 0, SFX_GAME_FREAK_LOGO_GS
	anim_obj ANIM_OBJ_COSMIC_POWER_BG, 61, 79, $30
	anim_wait 64
	anim_sound 0, 0, SFX_METRONOME
.loop
	anim_obj ANIM_OBJ_COSMIC_POWER, 56, 88, $32
	anim_wait 4
	anim_obj ANIM_OBJ_COSMIC_POWER, 40, 88, $2c
	anim_wait 4
	anim_obj ANIM_OBJ_COSMIC_POWER, 60, 104, $34
	anim_wait 4
	anim_obj ANIM_OBJ_COSMIC_POWER, 36, 104, $2e
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_ret


; Adapted from polishedcoral
BattleAnim_OminousWind_Oct19:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_HAZE
	anim_bgp $1b
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 24, $10
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 48, $2
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 32, $6
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 56, $c
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 80, $4
	anim_obj ANIM_OBJ_OMINOUS_WIND, 8, 104, $e
	anim_wait 120
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_ret


; Adapted from polishedcoral
BattleAnim_PetalBlizzard_Oct19:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_PINK
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PINK
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PINK
	; ANIM_OBJ_HIT uses this fork's original HIT tiles, not Coral's HIT_2.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_CHARGE, ANIM_GFX_FLOWER
	; Space the particles so the ten object slots can show every petal.
	anim_sound 0, 1, SFX_GAME_FREAK_LOGO_GS
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
.loop
	anim_obj ANIM_OBJ_PETAL_BLIZZARD, 48, 104, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 56, 90, $30
	anim_wait 8
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 40, 90, $20
	anim_wait 8
	anim_obj ANIM_OBJ_PETAL_BLIZZARD, 48, 104, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 60, 106, $10
	anim_wait 8
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 36, 106, $0
	anim_wait 8
	anim_loop 2, .loop
	anim_wait 88
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT, 136, 40, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_clearobjs
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $2, $0
.loop2
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_PETAL_BLIZZARD, 132, 68, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 144, 54, $30
	anim_wait 8
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 128, 54, $20
	anim_wait 8
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_PETAL_BLIZZARD, 132, 68, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 148, 70, $10
	anim_wait 8
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 124, 70, $0
	anim_wait 8
	anim_loop 1, .loop2
	anim_wait 88
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_MeteorMash_Oct19:
	anim_3gfx ANIM_GFX_STARS, ANIM_GFX_HIT, ANIM_GFX_WATER
	anim_bgp $1b
	anim_sound 0, 1, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 64
	anim_clearobjs
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $28, $2, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_LONG_PUNCH, 136, 56, $0
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $28
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $5c
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $10
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $e8
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $9c
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $d0
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $1c
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $50
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $dc
	anim_wait 3
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $90
	anim_wait 32
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_Eruption_branch_PO19:
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_ERUPTION_BIG_ROCK, 48, 88, $32
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 58, 88, $5c
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $e8
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $d0
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 58, 88, $50
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_SMALL_ROCK, 48, 88, $30
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_BIG_ROCK, 48, 88, $2e
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_BIG_ROCK, 48, 88, $31
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_SMALL_ROCK, 48, 88, $33
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_BIG_ROCK, 48, 88, $2f
	anim_wait 2
	anim_obj ANIM_OBJ_ERUPTION_SMALL_ROCK, 48, 88, $30
	anim_wait 16
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_ShowMon_0_2_PO19:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_TargetObj_2Row_2_PO19:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_Eruption_Oct19:
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_LAVA_ROCKS
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_LAVA_ROCKS, ANIM_GFX_FIRE
	anim_call BattleAnim_TargetObj_2Row_2_PO19
	anim_bgeffect ANIM_BG_WITHDRAW, $0, $1, $50
	anim_wait 8
	anim_sound 0, 1, SFX_OUTRAGE
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_wait 64
	anim_incbgeffect ANIM_BG_WITHDRAW
	anim_call BattleAnim_Eruption_branch_PO19
	anim_bgeffect ANIM_BG_WITHDRAW, $0, $1, $50
	anim_wait 24
	anim_incbgeffect ANIM_BG_WITHDRAW
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_call BattleAnim_Eruption_branch_PO19
	anim_wait 16
	anim_call BattleAnim_ShowMon_0_2_PO19
	anim_clearobjs
	anim_obj ANIM_OBJ_ERUPTION_FALLING_ROCK, 128, 70, $30
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $4, $0
	anim_obj ANIM_OBJ_ERUPTION_FALLING_ROCK, 152, 70, $30
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $4, $0
	anim_obj ANIM_OBJ_ERUPTION_FALLING_ROCK, 112, 70, $30
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $4, $0
	anim_obj ANIM_OBJ_ERUPTION_FALLING_ROCK, 120, 68, $30
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $4, $0
	anim_obj ANIM_OBJ_ERUPTION_FALLING_ROCK, 144, 68, $30
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $4, $0
	anim_wait 32
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_WaterSpout_Oct19:
	anim_2gfx ANIM_GFX_WATER, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_WATER
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_WATER
.loop
	anim_sound 0, 0, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 48, 80, $30
	anim_wait 2
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 52, 80, $30
	anim_wait 2
	anim_sound 0, 0, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 48, 80, $30
	anim_wait 2
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 46, 80, $30
	anim_wait 2
	anim_sound 0, 0, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 48, 80, $30
	anim_wait 2
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 54, 80, $30
	anim_wait 2
	anim_sound 0, 0, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_SPOUT_RISING, 48, 80, $30
	anim_wait 2
	anim_loop 3, .loop
	anim_wait 32
	anim_sound 0, 0, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 108, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 156, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 116, 1, $10
	anim_wait 2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $55, $1, $0
.loop2
	anim_obj ANIM_OBJ_HIT_YFIX, 108, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 150, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 156, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 124, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 116, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 140, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 150, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 132, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 108, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 156, 1, $10
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 132, 68, $0
	anim_obj ANIM_OBJ_WATER_SPOUT_FALLING, 116, 1, $10
	anim_wait 2
	anim_loop 2, .loop2
	anim_obj ANIM_OBJ_HIT_YFIX, 108, 68, $0
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 156, 68, $0
	anim_wait 2
	anim_obj ANIM_OBJ_HIT_YFIX, 116, 68, $0
	anim_wait 2
	anim_wait 32
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_DoomDesire_Oct19:
	anim_2gfx ANIM_GFX_SMALL_EXPLOSION, ANIM_GFX_SHINE
	anim_bgp $90
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_DRAGONBREATH
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $0, $0
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_MOONLIGHT, 0, 24, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 16, 40, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 32, 56, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 48, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 64, 88, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 80, 104, $0
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_MOONLIGHT, 48, 24, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 64, 40, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 80, 56, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 96, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 112, 88, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 128, 104, $0
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_MOONLIGHT, 80, 24, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 96, 40, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 112, 56, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 128, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 144, 88, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 160, 104, $0
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_MOONLIGHT, 112, 24, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 128, 40, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 144, 56, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 160, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 176, 88, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $4, $10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SMALL_EXPLOSION, 140, 42, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SMALL_EXPLOSION, 124, 62, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SMALL_EXPLOSION, 140, 62, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SMALL_EXPLOSION, 124, 42, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SMALL_EXPLOSION, 132, 52, $0
	anim_wait 32
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_TailGlow_Oct19:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_1gfx ANIM_GFX_GLOW
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_GAME_FREAK_LOGO_GS
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_obj ANIM_OBJ_SMALL_GLOW, 48, 96, $0
	anim_wait 112
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_Recycle_Oct19:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_RECYCLE
	anim_1gfx ANIM_GFX_RECYCLE
	anim_sound 0, 0, SFX_SHARPEN
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_obj ANIM_OBJ_RECYCLE, 48, 88, $0
	anim_wait 104
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_BlazeKick_Oct19:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_KICK, 136, 56, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	; Let slow flames leave before subsequent particles fill the object pool.
	anim_wait 6
	anim_obj ANIM_OBJ_KICK, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $28
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $30
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $38
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $20
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $8
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $18
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $4
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $2b
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $14
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $3b
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $24
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $b
	anim_wait 32
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_SkyUppercut_Oct19:
	anim_2gfx ANIM_GFX_WIND_BG, ANIM_GFX_HIT
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SKY_UPPERCUT,  12, 36, $30
	anim_obj ANIM_OBJ_SKY_UPPERCUT,  40, 133, $30
	anim_obj ANIM_OBJ_SKY_UPPERCUT,  68, 67, $30
	anim_obj ANIM_OBJ_SKY_UPPERCUT,  96, 11, $30
	anim_obj ANIM_OBJ_SKY_UPPERCUT, 122, 109, $30
	anim_obj ANIM_OBJ_SKY_UPPERCUT, 140, 162, $30
	anim_wait 40
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $28, $2, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_UPPERCUT_PUNCH, 136, 86, $30
	anim_wait 6
	anim_obj ANIM_OBJ_RISING_HIT, 136, 56, $30
	anim_wait 8
	anim_clearobjs
	anim_wait 14
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_PoisonBubble_branch_PO19:
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 132, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 116, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 148, 72, $0
	anim_wait 8
	anim_loop 2, .loop
	anim_wait 48
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_TargetObj_1Row_2_PO19:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret


; Adapted from mae-pokeorange
BattleAnim_PoisonTail_Oct19:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_POISON
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_call BattleAnim_TargetObj_1Row_2_PO19
	anim_bgeffect ANIM_BG_WOBBLE_MON, $0, $1, $0
	anim_wait 16
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_WOBBLE_MON
	anim_call BattleAnim_ShowMon_0_2_PO19
	anim_jump BattleAnim_PoisonBubble_branch_PO19



; Rebuilt against the user's GBC reference recordings (October 19).
; The Orange entries are stubs; these reproduce the supplied sequences,
; rather than substituting Air Cutter or a travelling stream of fire.
BattleAnim_VacuumWave_Oct19:
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_BIG_RINGS, ANIM_GFX_RINGS
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_VACUUM_REFERENCE
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 136, 52, $0
	anim_wait 6
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHRINKING_RING_BIG, 136, 52, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHRINKING_RING_SMALL, 136, 52, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_wait 8
	anim_ret

; Eight sparks leave the user in each pulse. Keep the orb and surrounding
; lightning in two slots, leaving eight slots for the radial particles.
BattleAnim_DischargeRays_Ref:
	anim_obj ANIM_OBJ_DISCHARGE_RADIAL, 48, 88, $0
	anim_obj ANIM_OBJ_DISCHARGE_DIAGONAL, 48, 88, $8
	anim_obj ANIM_OBJ_DISCHARGE_VERTICAL, 48, 88, $10
	anim_obj ANIM_OBJ_DISCHARGE_DIAGONAL_REVERSE, 48, 88, $18
	anim_obj ANIM_OBJ_DISCHARGE_RADIAL, 48, 88, $20
	anim_obj ANIM_OBJ_DISCHARGE_DIAGONAL, 48, 88, $28
	anim_obj ANIM_OBJ_DISCHARGE_VERTICAL, 48, 88, $30
	anim_obj ANIM_OBJ_DISCHARGE_DIAGONAL_REVERSE, 48, 88, $38
	anim_ret

BattleAnim_Discharge_Oct19:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
.small
	anim_sound 0, 0, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_THUNDERSHOCK_BALL, 48, 88, $2
	anim_obj ANIM_OBJ_SPARKS_CIRCLE, 48, 88, $0
	anim_call BattleAnim_DischargeRays_Ref
	anim_wait 19
	anim_clearobjs
	anim_loop 2, .small
	; The recording changes from a small black/gray orb to a larger
	; black/cyan orb; the yellow/orange sparks keep radiating from the user.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DISCHARGE_ORB
.large
	anim_sound 0, 0, SFX_THUNDERBOLT
	anim_obj ANIM_OBJ_THUNDERBOLT_BALL, 48, 88, $2
	anim_obj ANIM_OBJ_SPARKS_CIRCLE_BIG, 48, 88, $0
	anim_call BattleAnim_DischargeRays_Ref
	anim_wait 13
	anim_clearobjs
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
.finish
	anim_obj ANIM_OBJ_THUNDERBOLT_BALL, 48, 88, $2
	anim_obj ANIM_OBJ_SPARKS_CIRCLE_BIG, 48, 88, $0
	anim_call BattleAnim_DischargeRays_Ref
	anim_wait 13
	anim_clearobjs
	anim_loop 5, .finish
	anim_ret

BattleAnim_LavaPlume_Oct19:
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_LAVA_SMOKE
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	; The plume starts eight pixels below Discharge's orb. The recording
	; emits two flames every six frames, changing angle with each burst.
	; Short fire bursts end with the plume. Ember's long looping sound
	; keeps PlayBattleAnim waiting after the visible sequence is finished.
.plume
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $10
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $38
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $10
	anim_obj ANIM_OBJ_LAVA_PLUME_EMBER, 48, 96, $37
	anim_wait 5
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $2a
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $4
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $38
	anim_wait 5
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $18
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $3b
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $28
	anim_obj ANIM_OBJ_LAVA_PLUME_EMBER, 48, 96, $26
	anim_wait 5
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $1a
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $28
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $0
	anim_wait 5
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $30
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $1e
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $30
	anim_obj ANIM_OBJ_LAVA_PLUME_EMBER, 48, 96, $3a
	anim_wait 5
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $0
	anim_obj ANIM_OBJ_LAVA_PLUME_FLAME, 48, 96, $24
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE, 48, 96, $20
	anim_wait 5
	anim_loop 2, .plume
	; Allow the final particles to leave, retaining the reference's final
	; white silhouette before restoring the user's palette.
	anim_wait 18
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_clearobjs
	anim_wait 1
	anim_ret

; Sour Apple move upgrades, 2026-10-27.
; PiaCarrot/mae-pokeorange @ 41a44630a3f712f3f45a157874361234e13e68ca.
; Bank-local helper scripts and append-only resource ids.

BattleAnim_Gust_SourApple:

BattleAnim_Sonicboom_SourApple:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HIT
.loop
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 6
	anim_loop 9, .loop
	anim_obj ANIM_OBJ_HIT_YFIX, 144, 64, $18
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 32, $18
	anim_wait 16
	anim_ret

BattleAnim_Tackle_SourApple:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_SHAKE_MON_X, $0, $11, $4
.loop
	anim_sound 0, 0, SFX_SQUEAK
	anim_wait 8
	anim_loop 3, .loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_incbgeffect ANIM_BG_SHAKE_MON_X
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 12
	anim_clearobjs
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $0, $0
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 60, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 60, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 132, 52, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $a, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_Whirlwind_SourApple:
	anim_1gfx ANIM_GFX_WIND
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
.loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 64, 112, $0
	anim_wait 6
	anim_loop 9, .loop
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_incobj 7
	anim_incobj 8
	anim_incobj 9
	anim_sound 16, 2, SFX_WHIRLWIND
	anim_wait 128
	anim_if_param_equal $0, .done
	anim_bgeffect ANIM_BG_REMOVE_MON, $0, $0, $0
	anim_wait 64
.done
	anim_ret

BattleAnim_Twister_SourApple:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
.loop1
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 64, 112, $0
	anim_wait 6
	anim_loop 9, .loop1
.loop2
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 8
	anim_loop 8, .loop2
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_incobj 7
	anim_incobj 8
	anim_incobj 9
	anim_wait 64
	anim_obj ANIM_OBJ_HIT_YFIX, 144, 64, $18
.loop3
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 8
	anim_loop 4, .loop3
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 32, $18
.loop4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 8
	anim_loop 4, .loop4
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_incobj 7
	anim_incobj 8
	anim_incobj 9
	anim_wait 32
	anim_ret

BattleAnim_ShadowBall_SourApple:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BLUE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BLUE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_BLUE
	anim_3gfx ANIM_GFX_GLOW, ANIM_GFX_SMOKE, ANIM_GFX_CHARGE,
	anim_bgp $1b
	anim_obj ANIM_OBJ_ABSORB_CENTER, 44, 88, $0
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $30
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $31
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $32
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $33
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $34
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $35
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $36
	anim_obj ANIM_OBJ_CHARGE, 44, 88, $37
.loop
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_wait 16
	anim_loop 4, .loop
	anim_wait 32
	anim_clearobjs
	anim_sound 0, 1, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SIGNAL_BEAM_R, 64, 92, $2
	anim_wait 32
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GRAY
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $6, $1, $0
	anim_obj ANIM_OBJ_BALL_POOF, 132, 56, $10
	anim_wait 24
	anim_ret

BattleAnim_Wish_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_COSMIC
	anim_2gfx ANIM_GFX_STARS, ANIM_GFX_COSMIC_POWER
	anim_clearopponenthud
	anim_bgp $1b
	anim_obj ANIM_OBJ_COSMIC_POWER_BG, 61, 75, $30
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $0, $0
	anim_wait 16
	anim_sound 0, 1, SFX_GAME_FREAK_LOGO_GS
	anim_obj ANIM_OBJ_WISH_1, 30, 46, $42
	anim_wait 16
	anim_obj ANIM_OBJ_WISH_2, 50, 50, $0
	anim_wait 16
	anim_obj ANIM_OBJ_WISH_2, 70, 52, $0
	anim_wait 16
	anim_obj ANIM_OBJ_WISH_2, 90, 56, $0
	anim_wait 16
	anim_obj ANIM_OBJ_WISH_2, 110, 60, $0
	anim_wait 16
	anim_obj ANIM_OBJ_WISH_2, 130, 64, $0
	anim_wait 80
	anim_setobj 3, 3
	anim_setobj 4, 3
	anim_setobj 5, 3
	anim_setobj 6, 3
	anim_setobj 7, 3
	anim_incbgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW
	anim_bgeffect ANIM_BG_CYCLE_BGPALS_INVERTED, $0, $0, $0
	anim_sound 0, 0, SFX_MOONLIGHT
	anim_wait 42
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_ret

BattleAnim_PoisonFang_SourApple:
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_POISON
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_obj ANIM_OBJ_POISON_FANG_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_POISON_FANG_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT, 136, 56, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 4
	anim_clearobjs
	anim_wait 8
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
;fallthrough

BattleAnim_Poison_Bubble_branch_2_SourApple:
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

BattleAnim_VoltTackle_SourApple:
	anim_3gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION, ANIM_GFX_SPEED
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_obj ANIM_OBJ_THUNDER_WAVE, 48, 92, $0
	anim_bgp $1b
	anim_incobj 1
	anim_wait 48
	anim_clearobjs
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
.loop
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_obj ANIM_OBJ_VOLT_TACKLE, 48, 88, $0
	anim_wait 1
	anim_loop 8, .loop
	anim_wait 2
.loop2
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_obj ANIM_OBJ_VOLT_TACKLE, 158, 72, $20
	anim_wait 1
	anim_loop 8, .loop2
	anim_wait 2
.loop3
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_obj ANIM_OBJ_VOLT_TACKLE, 0, 56, $0
	anim_wait 1
	anim_loop 8, .loop3
	anim_wait 2
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $4, $10
	anim_obp0 $30
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_wait 16
	anim_obj ANIM_OBJ_31, 136, 56, $0
	anim_wait 64
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_RockPolish_SourApple:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
	anim_2gfx ANIM_GFX_ROCK_POLISH, ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK, $0, $1, $40
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_85DEG_R_YFLIP, 52, 88, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_5DEG_L_YFLIP, 40, 100, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_45DEG_R, 48, 96, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_5DEG_L, 56, 96, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_85DEG_L_YFLIP, 36, 84, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_45DEG_R_YFLIP, 60, 96, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_5DEG_R, 52, 88, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_85DEG_R, 40, 100, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_45DEG_L, 48, 96, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_85DEG_L, 56, 96, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_5DEG_R_YFLIP, 36, 84, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ROCK_POLISH_45DEG_L_YFLIP, 60, 96, $0
	anim_wait 8
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 32, 72, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 64, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 32, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 64, 72, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 48, 88, $0
	anim_wait 5
	anim_wait 16
	anim_ret

BattleAnim_PoisonJab_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_OBJECTS_2, ANIM_GFX_HIT, ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $2, $0
.loop
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_POISON_JAB_SW, 132, 56, $38
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 44, $0
	anim_obj ANIM_OBJ_POISON_JAB_E, 132, 56, $20
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_POISON_JAB_NW, 132, 56, $8
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 60, $0
	anim_obj ANIM_OBJ_POISON_JAB_N, 132, 56, $10
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_POISON_JAB_SE, 132, 56, $28
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 60, $0
	anim_obj ANIM_OBJ_POISON_JAB_W, 132, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_POISON_JAB_NE, 132, 56, $18
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 44, $0
	anim_obj ANIM_OBJ_POISON_JAB_S, 132, 56, $30
	anim_wait 4
	anim_loop 2, .loop
	anim_jump BattleAnim_Poison_Bubble_branch_2_SourApple

BattleAnim_BugBuzz_SourApple:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_LIME
	anim_2gfx ANIM_GFX_MID_GLOW_CLEAR, ANIM_GFX_BUG_BUZZ
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4a, $1, $0
.loop
	anim_obj ANIM_OBJ_MID_GLOW_SHRINKING, 48, 96, $0
	anim_sound 6, 2, SFX_BIND
	anim_obj ANIM_OBJ_BUG_BUZZ_L, 32, 84, $28
	anim_obj ANIM_OBJ_BUG_BUZZ_R, 64, 84, $38
	anim_wait 2
	anim_sound 6, 2, SFX_BIND
	anim_wait 2
	anim_sound 6, 2, SFX_BIND
	anim_obj ANIM_OBJ_BUG_BUZZ_L, 32, 84, $28
	anim_obj ANIM_OBJ_BUG_BUZZ_R, 64, 84, $38
	anim_wait 2
	anim_sound 6, 2, SFX_BIND
	anim_wait 2
	anim_loop 6, .loop
	anim_wait 2
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_wait 6
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 64
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_VacuumWave_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_VERY_BRIGHT
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_VERY_BRIGHT
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_BIG_GLOW_CLEAR
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_VACUUM_SHRINKING, 136, 52, $0
	anim_wait 8
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT, 136, 52, $0
	anim_wait 32
	anim_ret

BattleAnim_BraveBird_SourApple:
	anim_1gfx ANIM_GFX_SKY_ATTACK
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_bgeffect ANIM_BG_REMOVE_MON, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_CYCLE_BGPALS_INVERTED, $0, $4, $0
	anim_obp0 $30
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_BRAVE_BIRD, 48, 88, $0
	anim_wait 16
	anim_clearobjs
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BRAVE_BIRD, 48, 88, $18
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_ThunderFang_SourApple:
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_LIGHTNING
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_obj ANIM_OBJ_HIT, 136, 56, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 4
	anim_clearobjs
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 152, 68, $0
	anim_wait 32
	anim_ret

BattleAnim_IceFang_SourApple:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_ICE
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT, 136, 56, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 4
	anim_clearobjs
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 128, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 144, 70, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 120, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 152, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 144, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 128, 70, $0
	anim_wait 32
	anim_ret

BattleAnim_FireFang_SourApple:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT, 136, 56, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 4
	anim_clearobjs
	anim_sound 0, 1, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_BURNED, 136, 56, $10
	anim_obj ANIM_OBJ_BURNED, 136, 56, $90
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_ShadowSneak_SourApple:
	anim_2gfx ANIM_GFX_SHADOW_SNEAK_SA, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GRAY
	anim_battlergfx_2row
	anim_bgp $f8
	anim_obp0 $ef
	anim_sound 6, 2, SFX_WHIRLWIND
.loop
	anim_obj ANIM_OBJ_SHADOW_SNEAK, 44, 120, $2
	anim_wait 2
	anim_loop 4, .loop
	anim_wait 32
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 60, $0
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 140, 60, $0
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HIT_YFIX, 132, 52, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 1
	anim_clearobjs
	anim_ret

BattleAnim_PsychoCut_SourApple:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PSYCHO_BOOST_2
	anim_2gfx ANIM_GFX_BIG_WHIP, ANIM_GFX_GLOW
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_sound 0, 0, SFX_PSYBEAM
	anim_obj ANIM_OBJ_SMALL_GLOW, 44, 96, $0
	anim_wait 16
	anim_obj ANIM_OBJ_SPINNING_CRESCENT, 44, 96, $0
	anim_wait 32
	anim_clearobjs
	anim_obj ANIM_OBJ_SPINNING_CRESCENT, 44, 96, $0
	anim_wait 36
	anim_clearobjs
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_PSYCHO_CUT, 44, 96, $18
	anim_wait 20
	anim_sound 0, 1, SFX_PSYCHIC
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_bgeffect ANIM_BG_TELEPORT, $0, $0, $8
	anim_wait 64
	anim_incbgeffect ANIM_BG_TELEPORT
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 1
	anim_clearobjs
	anim_ret

BattleAnim_Defog_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_VERY_BRIGHT
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BRIGHT
	anim_2gfx ANIM_GFX_BIG_WHIP, ANIM_GFX_HAZE
	anim_bgp $90
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 24, $10
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 48, $2
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 32, $6
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 56, $c
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 80, $4
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 104, $e
	anim_wait 64
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_DRAGON_RUSH, 144, 245, $14
	anim_obj ANIM_OBJ_DRAGON_RUSH_XFLIP, 128, 245, $0c
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_clearobjs
	anim_wait 12
	anim_ret

BattleAnim_TrickRoom_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PSYCHO_BOOST_2
	anim_1gfx ANIM_GFX_TRICK_ROOM
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $6, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
	anim_sound 0, 0, SFX_PSYBEAM
.loop
	anim_obj ANIM_OBJ_TRICK_ROOM, 80, 72, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 156, 36, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 40, 24, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 140, 100, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 164, 64, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 48, 66, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 96, 24, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 60, 96, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 102, 86, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 150, 14, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 26, 80, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 12, 50, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 72, 30, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 110, 62, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 170, 94, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 80, 104, $0
	anim_wait 3
	anim_loop 2, .loop
	anim_wait 32
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_wait 4
	anim_ret

BattleAnim_Discharge_SourApple:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $6, $0
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_34, 48, 88, $2
	anim_obj ANIM_OBJ_33, 48, 88, $0
	anim_wait 4
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_wait 4
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_wait 4
	anim_clearobjs
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 48, 88, $2
	anim_obj ANIM_OBJ_33, 48, 88, $0
	anim_wait 4
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_wait 4
	anim_clearobjs
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 48, 88, $2
	anim_obj ANIM_OBJ_31, 48, 88, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_wait 4
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 48, 88, $2
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SMALL, 48, 88, $0
.loop
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_N,  48, 88, $0
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NE, 48, 88, $8
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_E,  48, 88, $10
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SE, 48, 88, $18
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_S,  48, 88, $20
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SW, 48, 88, $28
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_W,  48, 88, $30
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NW, 48, 88, $38
	anim_wait 10
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_N,  48, 88, $4
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NE, 48, 88, $b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_E,  48, 88, $14
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SE, 48, 88, $1b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_S,  48, 88, $24
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SW, 48, 88, $2b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_W,  48, 88, $34
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NW, 48, 88, $3b
	anim_wait 10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_N,  48, 88, $0
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NE, 48, 88, $8
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_E,  48, 88, $10
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SE, 48, 88, $18
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_S,  48, 88, $20
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SW, 48, 88, $28
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_W,  48, 88, $30
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NW, 48, 88, $38
	anim_wait 10
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_N,  48, 88, $4
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NE, 48, 88, $b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_E,  48, 88, $14
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SE, 48, 88, $1b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_S,  48, 88, $24
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_SW, 48, 88, $2b
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_W,  48, 88, $34
	anim_obj ANIM_OBJ_DISCHARGE_SPARKS_NW, 48, 88, $3b
	anim_wait 10
	anim_loop 2, .loop
	anim_clearobjs
	anim_wait 4
	anim_ret

BattleAnim_LavaPlume_SourApple:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_LAVA_PLUME
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_SMOKE_PUFF_BIG_SA
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
.loop
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $38
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $10
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 58, 88, $5c
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 52, 96, $2
	anim_wait 3
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $2a
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $4
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $e8
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 40, 100, $28
	anim_wait 3
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $18
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $3b
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $d0
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 48, 84, $38
	anim_wait 3
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $1a
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $0a
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 58, 88, $50
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 56, 100, $8
	anim_wait 3
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $1e
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $30
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $e8
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 44, 88, $30
	anim_wait 3
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 96, $24
	anim_wait 3
	anim_obj ANIM_OBJ_ERUPTION_SMALL_FLAME, 38, 88, $d0
	anim_obj ANIM_OBJ_LAVA_PLUME_SMOKE_SOUR, 48, 108, $18
	anim_wait 3
	anim_loop 2, .loop
	anim_wait 20
	anim_ret

BattleAnim_LeafStorm_SourApple:
	anim_1gfx ANIM_GFX_LEAF_STORM_SA
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GREEN
	anim_4gfx ANIM_GFX_VORTEX_SA, ANIM_GFX_LEAF_STORM_SA, ANIM_GFX_WIND_BG, ANIM_GFX_SWIRL_SA
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $6, $0
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 48, $2
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 56, $c
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
	anim_obj ANIM_OBJ_AGILITY, 8, 104, $e
	anim_sound 0, 1, SFX_OUTRAGE
.loop
	anim_obj ANIM_OBJ_SWIRL_SHORT_SOUR, 44, 96, $0
	anim_wait 8
	anim_loop 4, .loop
	anim_obj ANIM_OBJ_VORTEX_SOUR, 44, 96, $0
	anim_wait 32
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_GREEN
	anim_obj ANIM_OBJ_VORTEX_SOUR, 44, 96, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 80, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LEAF_STORM_BIG_LEAF, 44, 92, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 112, $18
	anim_wait 2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $2, $0
.loop2
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_LEAF_STORM_BIG_LEAF, 44, 96, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 80, $18
	anim_wait 2
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 112, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 80, $18
	anim_wait 2
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_LEAF_STORM_BIG_LEAF, 44, 92, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 44, 112, $18
	anim_wait 2
	anim_loop 5, .loop2
	anim_incbgeffect ANIM_BG_SHAKE_SCREEN_X
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 4
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 32
	anim_ret

BattleAnim_CrossPoison_SourApple:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_POISON
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_UP_LEFT, 150, 68, $0
	anim_obj ANIM_OBJ_CUT_LONG_UP_RIGHT, 118, 68, $0
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_wait 24
	anim_jump BattleAnim_Poison_Bubble_branch_short_3_SourApple

BattleAnim_StealthRock_SourApple:
	anim_1gfx ANIM_GFX_ROCKS
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_STEALTH_ROCK, 48, 80, $20
	anim_wait 8
	anim_obj ANIM_OBJ_STEALTH_ROCK, 48, 80, $30
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_STEALTH_ROCK, 48, 80, $28
	anim_wait 8
	anim_obj ANIM_OBJ_STEALTH_ROCK, 52, 80, $20
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_STEALTH_ROCK, 44, 80, $30
	anim_wait 8
	anim_obj ANIM_OBJ_STEALTH_ROCK, 44, 80, $28
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_STEALTH_ROCK, 44, 80, $20
	anim_wait 8
	anim_obj ANIM_OBJ_STEALTH_ROCK, 52, 80, $30
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_STEALTH_ROCK, 52, 80, $28
	anim_wait 8
	anim_obj ANIM_OBJ_STEALTH_ROCK, 48, 80, $20
	anim_wait 64
	anim_ret

BattleAnim_HeadSmash_SourApple:
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_GRAY
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_HEADBUTT
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 12
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $4, $10
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 138, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $9c
	anim_wait 6
	anim_clearobjs
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $d0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $1c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $50
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $dc
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $90
	anim_wait 32
	anim_ret

BattleAnim_Poison_Bubble_branch_short_3_SourApple:
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 132, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 116, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, 148, 72, $0
	anim_wait 48
	anim_ret

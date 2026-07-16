; Move animations ported from polishedcrystal (scripts bank 4).
; Generated port: helpers are bank-local copies (suffix _PC4).

BattleAnimSub_Acid_PC4:
.loop
	anim_sound 6, 2, SFX_BUBBLE_BEAM
	anim_obj ANIM_OBJ_ACID,   8, 0,  11, 4, $10
	anim_wait 5
	anim_loop 8, .loop
	anim_ret

BattleAnimSub_BGCycleOBPalsGrayAndYellow_0_2_0_PC4:
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_ret

BattleAnimSub_Beam_PC4:
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,   8, 0,  11, 4, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,  10, 0,  10, 4, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,  12, 0,   9, 4, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,  14, 0,   8, 4, $0
	anim_obj ANIM_OBJ_BEAM_TIP,  15, 6,   7, 6, $0
	anim_ret

BattleAnimSub_Explosion2_PC4:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION1, -14, 4,   4, 0, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION1,  14, 4,   9, 0, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION1, -14, 4,   9, 0, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION1,  14, 4,   4, 0, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION1, -16, 4,   6, 4, $0
	anim_ret

BattleAnimSub_Fire_PC4:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 1, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_BURNED, 136, 56, $10
	anim_obj ANIM_OBJ_BURNED, 136, 56, $90
	anim_wait 4
	anim_loop 4, .loop
	anim_ret

BattleAnimSub_Focus_PC4:
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_FOCUS,   5, 4,  13, 4, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   4, 4,  13, 4, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   6, 4,  13, 4, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   3, 4,  13, 4, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   7, 4,  13, 4, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   2, 4,  13, 4, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS,   8, 4,  13, 4, $8
	anim_wait 2
	anim_ret

BattleAnimSub_Glimmer_PC4:
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_GLIMMER,   5, 4,   8, 0, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER,   3, 0,  12, 0, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER,   7, 0,  13, 0, $0
	anim_wait 21
	anim_ret

BattleAnimSub_Hail_PC4:
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_HAIL, 88, 0, $0
	anim_obj ANIM_OBJ_HAIL, 68, 0, $1
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_HAIL, 188, 0, $2
	anim_obj ANIM_OBJ_HAIL, 168, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_HAIL, 28, 0, $1
	anim_obj ANIM_OBJ_HAIL, 8, 0, $2
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_HAIL, 238, 0, $0
	anim_obj ANIM_OBJ_HAIL, 218, 0, $1
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_HAIL, 138, 0, $2
	anim_obj ANIM_OBJ_HAIL, 118, 0, $1
	anim_wait 8
	anim_ret

BattleAnimSub_Ice_PC4:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE,  16, 0,   5, 2, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, -14, 0,   8, 6, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE,  15, 0,   7, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, -13, 0,   7, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, -14, 0,   5, 2, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE,  16, 0,   8, 6, $0
	anim_ret

BattleAnimSub_Metallic_PC4:
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_METALLIC
	anim_sound 0, 0, SFX_SHINE
	anim_wait 8
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 32
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 64
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_DEFAULT
	anim_ret

BattleAnimSub_PunchShake_PC4:
	anim_obj ANIM_OBJ_PUNCH_SHAKE, -15, 0,   7, 0, $43
	anim_ret

BattleAnimSub_SandOrMud_PC4:
.loop
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SAND,   8, 0,  11, 4, $4
	anim_wait 4
	anim_loop 8, .loop
	anim_wait 32
	anim_ret

BattleAnimSub_Sandstorm_PC4:
	anim_1gfx ANIM_GFX_POWDER
	anim_obj ANIM_OBJ_SANDSTORM,  11, 0,   0, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM,   9, 0,   0, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM,   7, 0,   0, 0, $2
	anim_1gfx ANIM_GFX_POWDER
	anim_obj ANIM_OBJ_SANDSTORM,  11, 0,   0, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM,   9, 0,   0, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM,   7, 0,   0, 0, $2
	anim_ret

BattleAnimSub_ShakeEnemy_PC4:
	anim_sound 6, 2, SFX_LEER
	anim_obj ANIM_OBJ_LEER,   9, 0,  10, 4, $0
	anim_obj ANIM_OBJ_LEER,   8, 0,  10, 0, $0
	anim_obj ANIM_OBJ_LEER,  11, 0,   9, 4, $0
	anim_obj ANIM_OBJ_LEER,  10, 0,   9, 0, $0
	anim_obj ANIM_OBJ_LEER,  13, 0,   8, 4, $0
	anim_obj ANIM_OBJ_LEER,  12, 0,   8, 0, $0
	anim_obj ANIM_OBJ_LEER,  15, 0,   7, 4, $0
	anim_obj ANIM_OBJ_LEER,  14, 0,   7, 0, $0
	anim_obj ANIM_OBJ_LEER_TIP, -16, 2,   6, 6, $0
	anim_obj ANIM_OBJ_LEER_TIP,  15, 2,   6, 2, $0
	anim_ret

BattleAnimSub_Sludge_PC4:
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, -16, 4,   9, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE,  14, 4,   9, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_SLUDGE, -14, 4,   9, 0, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_ret

BattleAnimSub_Sound_PC4:
	anim_obj ANIM_OBJ_SOUND,   8, 0,   9, 4, $0
	anim_obj ANIM_OBJ_SOUND,   8, 0,  11, 0, $1
	anim_obj ANIM_OBJ_SOUND,   8, 0,  12, 4, $2
	anim_ret

BattleAnimSub_WingAttack_PC4:
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, -14, 4,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_YFIX,  14, 4,   7, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, -14, 0,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_YFIX,  15, 0,   7, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 4,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_YFIX,  15, 4,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_Recover_branch_PC4:
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $30
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $31
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $32
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $33
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $34
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $35
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $36
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $37
	anim_wait 64
	anim_ret

BattleAnim_ReturnMon_PC4:
	anim_sound 0, 0, SFX_BALL_POOF
.anim
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Scratch_PC4:
	anim_1gfx ANIM_GFX_CUT
.hit
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, -14, 0,   6, 0, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, -15, 4,   5, 4, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, -15, 0,   5, 0, $0
	anim_wait 32
	anim_ret

BattleAnim_ShowMon_0_PC4:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_ShowMon_1_PC4:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_SubPowder_PC4:
	anim_1gfx ANIM_GFX_POWDER
.loop
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER,  13, 0,   2, 0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, -15, 0,   2, 0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER,  14, 0,   2, 0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER,  16, 0,   2, 0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER,  15, 0,   2, 0, $0
	anim_wait 4
	anim_loop 2, .loop
	anim_wait 96
	anim_ret

BattleAnim_TargetObj_1Row_PC4:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_TargetObj_2Row_PC4:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_UserObj_2Row_PC4:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_wait 4
	anim_ret

BattleAnim_Attract_PC4:
	anim_1gfx ANIM_GFX_OBJECTS
.loop
	anim_sound 0, 0, SFX_ATTRACT
	anim_obj ANIM_OBJ_ATTRACT,   5, 4,  10, 0, $2
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 128
	anim_wait 64
	anim_ret

BattleAnim_AuroraBeam_PC4:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_AURORA
	anim_1gfx ANIM_GFX_BEAM_AURORA
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW_FULL_SHIFT, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_wait 64
	anim_call BattleAnimSub_Beam_PC4
	anim_wait 48
	anim_incobj 5
	anim_wait 64
	anim_ret

BattleAnim_Barrier_PC4:
	anim_1gfx ANIM_GFX_REFLECT
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_wait 8
.loop
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN,   9, 0,  10, 0, $0
	anim_wait 32
	anim_loop 2, .loop
	anim_ret

BattleAnim_BatonPass_PC4:
	anim_1gfx ANIM_GFX_MISC
	anim_obj ANIM_OBJ_BATON_PASS,   5, 4,  13, 0, $20
	anim_sound 0, 0, SFX_BATON_PASS
	anim_call BattleAnim_ReturnMon_PC4.anim
	anim_wait 64
	anim_ret

BattleAnim_Bonemerang_PC4:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_BONEMERANG,  11, 0,   7, 0, $1c
	anim_wait 24
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 0,   7, 0, $0
	anim_wait 24
	anim_ret

BattleAnim_Cut_PC4:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, -13, 0,   5, 0, $0
	anim_wait 32
	anim_ret

BattleAnim_DragonRage_PC4:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_DRAGON_RAGE
	anim_1gfx ANIM_GFX_FIRE
.loop
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_DRAGON_RAGE, 64, 92, $0
	anim_wait 3
	anim_loop 16, .loop
	anim_wait 64
	anim_ret

BattleAnim_Dragonbreath_PC4:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_DRAGONBREATH
	anim_1gfx ANIM_GFX_FIRE
	anim_sound 6, 2, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_DRAGONBREATH, 64, 92, $4
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 64
	anim_ret

BattleAnim_Dynamicpunch_PC4:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_call BattleAnimSub_PunchShake_PC4
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $12
	anim_call BattleAnimSub_Explosion2_PC4
	anim_wait 16
	anim_bgp $e4
	anim_ret

BattleAnim_Earthquake_PC4:
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $4, $10
.loop
	anim_sound 0, 1, SFX_EMBER
	anim_wait 24
	anim_loop 4, .loop
	anim_ret

BattleAnim_Endure_PC4:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_1Row_PC4
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_call BattleAnimSub_BGCycleOBPalsGrayAndYellow_0_2_0_PC4
.loop
	anim_call BattleAnimSub_Focus_PC4
	anim_loop 5, .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_call BattleAnim_ShowMon_0_PC4
	anim_ret

BattleAnim_FirePunch_PC4:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_call BattleAnimSub_PunchShake_PC4
	anim_call BattleAnimSub_Fire_PC4
	anim_wait 16
	anim_ret

BattleAnim_Glare_PC4:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $20
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_call BattleAnimSub_ShakeEnemy_PC4
	anim_wait 16
	anim_ret

BattleAnim_Growl_PC4:
	anim_1gfx ANIM_GFX_NOISE
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_cry $0
.loop
	anim_call BattleAnimSub_Sound_PC4
	anim_wait 16
	anim_loop 3, .loop
	anim_ret

BattleAnim_Hail_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
	anim_1gfx ANIM_GFX_ICE
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
.loop
	anim_call BattleAnimSub_Hail_PC4
	anim_loop 3, .loop
	anim_ret

BattleAnim_Haze_PC4:
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 0, 1, SFX_SURF
.loop
	anim_obj ANIM_OBJ_HAZE,   6, 0,   7, 0, $0
	anim_obj ANIM_OBJ_HAZE, -16, 4,   2, 0, $0
	anim_wait 12
	anim_loop 5, .loop
	anim_wait 96
	anim_ret

BattleAnim_HornAttack_PC4:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GRAY
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_HORN,   9, 0,  10, 0, $1
	anim_wait 16
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_HyperBeam_PC4:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $4, $10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_call BattleAnimSub_Beam_PC4
	anim_wait 48
	anim_ret

BattleAnim_HyperFang_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $1, $0
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_FANG, -15, 0,   7, 0, $0
	anim_wait 6
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_Hypnosis_PC4:
	anim_1gfx ANIM_GFX_PSYCHIC
.loop
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE,   8, 0,  11, 0, $2
	anim_obj ANIM_OBJ_WAVE,   7, 0,  10, 0, $2
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 56
	anim_ret

BattleAnim_IcePunch_PC4:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_ICE
	anim_call BattleAnimSub_PunchShake_PC4
	anim_call BattleAnimSub_Ice_PC4
	anim_wait 32
	anim_ret

BattleAnim_Leer_PC4:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_call BattleAnimSub_ShakeEnemy_PC4
	anim_wait 16
	anim_ret

BattleAnim_Lick_PC4:
	anim_1gfx ANIM_GFX_WATER
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_LICK, -15, 0,   7, 0, $0
	anim_wait 64
	anim_ret

BattleAnim_MetalClaw_PC4:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row_PC4
	anim_call BattleAnimSub_Metallic_PC4
	anim_call BattleAnim_ShowMon_0_PC4
	anim_1gfx ANIM_GFX_CUT
	anim_resetobp0
	anim_jump BattleAnim_Scratch_PC4.hit

BattleAnim_Metronome_PC4:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_SPEED
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_METRONOME_HAND,   9, 0,  11, 0, $0
.loop
	anim_obj ANIM_OBJ_METRONOME_SPARKLE,   9, 0,  10, 0, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 48
	anim_ret

BattleAnim_MudSlap_PC4:
	anim_1gfx ANIM_GFX_SAND
	anim_obp0 $fc
	anim_call BattleAnimSub_SandOrMud_PC4
	anim_ret

BattleAnim_NightShade_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp1 $1b
	anim_wait 32
	anim_call BattleAnim_UserObj_2Row_PC4
	anim_bgeffect ANIM_BG_NIGHT_SHADE, $0, $0, $8
	anim_sound 0, 1, SFX_PSYCHIC
	anim_wait 96
	anim_incbgeffect ANIM_BG_NIGHT_SHADE
	anim_call BattleAnim_ShowMon_1_PC4
	anim_bgp $e4
	anim_ret

BattleAnim_PayDay_PC4:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_STATUS
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_HIT_YFIX,  16, 0,   7, 0, $0
	anim_wait 16
	anim_sound 0, 1, SFX_PAY_DAY
	anim_obj ANIM_OBJ_PAY_DAY,  15, 0,   9, 4, $1
	anim_wait 64
	anim_ret

BattleAnim_Peck_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX,  16, 0,   6, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, -15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_PoisonSting_PC4:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_NEEDLE,   8, 0,  11, 4, $14
	anim_wait 16
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_HIT_SMALL, -15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_Poisonpowder_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_jump BattleAnim_SubPowder_PC4

BattleAnim_Recover_PC4:
	anim_2gfx ANIM_GFX_BUBBLE, ANIM_GFX_SHINE
	anim_sound 0, 0, SFX_SHARPEN
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_call BattleAnim_Recover_branch_PC4
	anim_wait 32
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $0, $0
	anim_call BattleAnimSub_Glimmer_PC4
	anim_ret

BattleAnim_Rest_PC4:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_TAIL_WHIP
.loop
	anim_obj ANIM_OBJ_ASLEEP,   8, 0,  10, 0, $0
	anim_wait 40
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_Sandstorm_PC4:
	anim_call BattleAnimSub_Sandstorm_PC4
.loop
	anim_sound 0, 1, SFX_MENU
	anim_wait 8
	anim_loop 16, .loop
	anim_wait 8
	anim_ret

BattleAnim_ScaryFace_PC4:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_call BattleAnimSub_ShakeEnemy_PC4
	anim_wait 64
	anim_ret

BattleAnim_Screech_PC4:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $8, $1, $20
	anim_sound 6, 2, SFX_SCREECH
.loop
	anim_obj ANIM_OBJ_WAVE,   8, 0,  11, 0, $2
	anim_wait 2
	anim_loop 2, .loop
	anim_wait 64
	anim_ret

BattleAnim_Slash_PC4:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, -13, 0,   5, 0, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, -14, 4,   4, 4, $0
	anim_wait 32
	anim_ret

BattleAnim_SleepTalk_PC4:
	anim_1gfx ANIM_GFX_STATUS
.loop
	anim_sound 0, 0, SFX_STRENGTH
	anim_obj ANIM_OBJ_ASLEEP,   8, 0,  10, 0, $0
	anim_wait 40
	anim_loop 2, .loop
	anim_wait 32
	anim_ret

BattleAnim_SludgeBomb_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SLUDGE_BOMB,   8, 0,  11, 4, $10
	anim_wait 36
	anim_call BattleAnimSub_Sludge_PC4
	anim_wait 48
	anim_ret

BattleAnim_SteelWing_PC4:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row_PC4
	anim_call BattleAnimSub_Metallic_PC4
	anim_call BattleAnim_ShowMon_0_PC4
	anim_1gfx ANIM_GFX_HIT
	anim_resetobp0
	anim_jump BattleAnimSub_WingAttack_PC4

BattleAnim_Struggle_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_StunSpore_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW
	anim_jump BattleAnim_SubPowder_PC4

BattleAnim_Supersonic_PC4:
	anim_1gfx ANIM_GFX_PSYCHIC
.loop
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE,   8, 0,  11, 0, $2
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 64
	anim_ret

BattleAnim_Tackle_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_PC4
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 0,   6, 0, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0_PC4
	anim_ret

BattleAnim_Toxic_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_call BattleAnimSub_Acid_PC4
	anim_wait 32
	anim_call BattleAnimSub_Sludge_PC4
	anim_wait 64
	anim_ret

BattleAnim_Transform_PC4:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row_PC4
	anim_transform
	anim_sound 0, 0, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_WAVE_DEFORM_MON, $0, $1, $0
	anim_wait 48
	anim_updateactorpic
	anim_incbgeffect ANIM_BG_WAVE_DEFORM_MON
	anim_wait 48
	anim_call BattleAnim_ShowMon_0_PC4
	anim_ret

BattleAnim_XScissor_PC4:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 32
	anim_ret

BattleAnim_InHail_PC4:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
	anim_1gfx ANIM_GFX_ICE
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
.loop
	anim_call BattleAnimSub_Hail_PC4
	anim_loop 2, .loop
	anim_ret

BattleAnim_InSandstorm_PC4:
	anim_call BattleAnimSub_Sandstorm_PC4
.loop
	anim_sound 0, 1, SFX_MENU
	anim_wait 8
	anim_loop 6, .loop
	anim_wait 8
	anim_ret

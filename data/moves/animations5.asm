; Crimson Crystal battle animations for the 2026-07 move expansion
; (scripts bank 5). Helpers are bank-local copies (suffix _CC), same
; convention as the polishedcrystal ports in animations2/3/4.

BattleAnim_TargetObj_1Row_CC:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_ShowMon_0_CC:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnimSub_SpeedLines_CC:
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_ret

BattleAnim_Overheat_CC:
; Fiery power builds around the user, then a torrent of flame engulfs
; the target and detonates.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $8, $0
	anim_bgp $1b
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $20
	anim_wait 4
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $30
	anim_wait 4
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $8
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $38
	anim_wait 16
	anim_clearobjs
	anim_wait 1
.loop
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FLAMETHROWER, 72, 92, $0
	anim_wait 4
	anim_loop 6, .loop
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $3, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $20
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 130, 64, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $30
	anim_wait 24
	anim_ret

BattleAnim_LeafStorm_CC:
; A storm of leaves whipped up under a darkened sky.
	anim_1gfx ANIM_GFX_PLANT
	anim_bgp $1b
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $5c
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $e8
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $9c
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $d0
	anim_wait 6
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $1c
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $50
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $dc
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $90
	anim_wait 48
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $2, $0
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 3
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 5
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 7
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 9
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 1
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 2
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 4
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 6
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 8
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 10
	anim_wait 64
	anim_ret

BattleAnim_FakeOut_CC:
; A sudden clap right in the target's face.
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_PALM, 122, 44, $0
	anim_obj ANIM_OBJ_PALM, 148, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 48, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 12
	anim_ret

BattleAnim_FlipTurn_CC:
; The user rockets through the target on a jet of water, then flips
; back out of battle, U-turn style.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_WATER
	anim_4gfx ANIM_GFX_SPEED, ANIM_GFX_HIT, ANIM_GFX_BUBBLE, ANIM_GFX_U_TURN
	anim_sound 6, 2, SFX_SURF
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 12
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $5c
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $e8
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $d0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $50
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_BLUR_VERTICAL_UP, 132, 30, $30
	anim_wait 16
	anim_clearobjs
	anim_obj ANIM_OBJ_BLUR_VERTICAL_DOWN, 48, 0, $10
	anim_wait 16
	anim_clearobjs
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_IronDefense_CC:
; The user's body takes on a hard metallic sheen.
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_METALLIC
	anim_sound 0, 0, SFX_SHINE
	anim_wait 8
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 32
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 48
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_DEFAULT
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_RockPolish_CC:
; Rough stone chips grind away, leaving the user gleaming.
	anim_3gfx ANIM_GFX_ROCKS, ANIM_GFX_SHINE, ANIM_GFX_SPEED
	anim_sound 0, 0, SFX_SANDSTORM
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $e8
	anim_wait 12
	anim_sound 0, 0, SFX_SANDSTORM
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $9c
	anim_obj ANIM_OBJ_ROCK_SMASH, 64, 92, $d0
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 44, 76, $0
	anim_obj ANIM_OBJ_GLIMMER, 84, 92, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 64, 104, $0
	anim_obj ANIM_OBJ_SHINY, 56, 84, $0
	anim_wait 32
	anim_ret

BattleAnim_WoodHammer_CC:
; A full-body slam with a hammering blow of solid timber.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_PLANT
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 6
	anim_sound 0, 1, SFX_HEADBUTT
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_STRENGTH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_obj ANIM_OBJ_RAZOR_LEAF, 128, 64, $9c
	anim_obj ANIM_OBJ_RAZOR_LEAF, 128, 64, $d0
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_HeadSmash_CC:
; An all-out, skull-first crash with rubble flying everywhere.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_wait 6
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $1c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $50
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $dc
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $90
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_DrillRun_CC:
; The user spins like a drill and bores into the target.
	anim_4gfx ANIM_GFX_SPEED, ANIM_GFX_HORN, ANIM_GFX_HIT, ANIM_GFX_ROCKS
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 8
.loop
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_MEDIUM_HORN, 136, 56, $28
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 4
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $10
	anim_wait 24
	anim_ret

BattleAnim_PsychoCut_CC:
; Blades of pure psychic energy scythe across the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_CUT
	anim_bgp $1b
	anim_sound 0, 0, SFX_PSYCHIC
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 24
	anim_sound 0, 1, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 152, 52, $20
	anim_wait 32
	anim_ret

BattleAnim_SacredSword_CC:
; The blade gleams as it is raised, then crossing slashes tear in.
	anim_4gfx ANIM_GFX_WHIP, ANIM_GFX_SHINE, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_SWORDS_DANCE,   6, 0,  13, 4, $0
	anim_obj ANIM_OBJ_GLIMMER, 64, 76, $0
	anim_wait 24
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 16
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_BrickBreak_CC:
; A karate chop smashes clean through the barrier in front of the foe.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_REFLECT, ANIM_GFX_ROCKS
	anim_obp0 $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 136, 48, $0
	anim_wait 16
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_VERTICAL_CHOP, 136, 48, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_sound 0, 1, SFX_GLASS_TING
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $e8
	anim_wait 24
	anim_ret

BattleAnim_HeatWave_CC:
; A scorching wind fans embers across the field into the target.
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_WIND
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $8, $0
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 0, $12
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 4, $14
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 4, $13
	anim_wait 8
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 8
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,  15, 0,   8, 4, $30
	anim_obj ANIM_OBJ_EMBER, -16, 4,   8, 4, $30
	anim_obj ANIM_OBJ_EMBER, -14, 0,   8, 4, $30
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 32
	anim_ret

BattleAnim_Snarl_CC:
; A menacing yell that rattles the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_2gfx ANIM_GFX_NOISE, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 16
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 16
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_LEER
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Nuzzle_CC:
; The user sidles up and rubs its charged cheeks on the target.
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_SPARKS_CIRCLE, -15, 0,   7, 0, $0
	anim_wait 48
	anim_ret

BattleAnim_BulletSeed_CC:
; One quick burst of hard seeds per hit - kept short so the
; multi-hit loop stays snappy.
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_HIT
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $20
	anim_obj ANIM_OBJ_SEED_BOMB, 48, 76, $30
	anim_wait 8
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_DualWingbeat_CC:
; Two heavy wingbeats slam the target from both sides.
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, -14, 4,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_YFIX,  14, 4,   7, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 0,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX,  15, 0,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_RockTomb_CC:
; Boulders drop from above and box the target in.
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 136, 48, $48
	anim_obj ANIM_OBJ_SMALL_ROCK, 148, 56, $30
	anim_obj ANIM_OBJ_SMALL_ROCK, 124, 52, $50
	anim_wait 8
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 128, 44, $38
	anim_obj ANIM_OBJ_SMALL_ROCK, 144, 64, $40
	anim_obj ANIM_OBJ_SMALL_ROCK, 132, 60, $28
	anim_wait 8
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_STOMP
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_wait 24
	anim_ret

BattleAnim_LowSweep_CC:
; A darting kick swept low at the target's legs.
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 8
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_KICK, -15, 0,   8, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_JUMP_KICK
	anim_obj ANIM_OBJ_HIT_YFIX, -15, 4,   8, 0, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_MudShot_CC:
; Globs of mud blast the target and mire it down.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BROWN
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
.loop
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 6
	anim_loop 3, .loop
	anim_wait 8
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 60, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_AirCutter_CC:
; Razor-edged blades of wind slice across the target.
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_WHIP
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_AIR_SLASH, 144, 40, $28
	anim_obj ANIM_OBJ_AIR_SLASH, 152, 48, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AIR_SLASH, 136, 48, $28
	anim_obj ANIM_OBJ_AIR_SLASH, 144, 56, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AIR_SLASH, 128, 56, $28
	anim_obj ANIM_OBJ_AIR_SLASH, 136, 64, $8
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 32
	anim_ret

BattleAnim_CrossPoison_CC:
; Poison-soaked blades slash in an X across the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 12
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 130, 48, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 142, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_MagicalLeaf_CC:
; Glittering leaves that curve unerringly into the target.
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_SHINE
	anim_sound 0, 0, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $5c
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF,   6, 0,  10, 0, $e8
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 64, 88, $0
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 1
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 2
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 3
	anim_wait 2
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_incobj 4
	anim_wait 32
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 136, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_SignalBeam_CC:
; A sinister, flickering beam of light bores into the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SIGNAL_BEAM_RED
	anim_2gfx ANIM_GFX_GLOW, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_PSYBEAM
	anim_obj ANIM_OBJ_SIGNAL_BEAM_R, 64, 92, $2
.loop
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SIGNAL_BEAM_BLUE
	anim_wait 4
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SIGNAL_BEAM_RED
	anim_wait 4
	anim_loop 4, .loop
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_PSYBEAM
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_ScaleShot_CC:
; A volley of hard, gleaming scales - kept short so the multi-hit
; loop stays snappy.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_TRIANGLE, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 98, $2
	anim_wait 12
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_PhantomForce_CC:
; Turn 1: the user melts away into the shadows.
; Turn 2: it strikes from the void, ignoring any protection.
	anim_if_param_equal $1, .turn1
	anim_if_param_equal $2, .miss
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_1gfx ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 1, SFX_NIGHTMARE
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_VERTICAL_CHOP, 136, 48, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 0,   7, 0, $0
	anim_wait 24
.miss
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret
.turn1
	anim_1gfx ANIM_GFX_SPEED
	anim_bgp $1b
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $1, $0
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_WARP_TO
	anim_obj ANIM_OBJ_WARP,   5, 4,  13, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,  12, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,  11, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,  10, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,   9, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,   8, 4, $0
	anim_obj ANIM_OBJ_WARP,   5, 4,   7, 4, $0
	anim_wait 64
	anim_ret

; ==== 2026-07 move expansion, batch 2 ====

BattleAnim_HeadlongRush_CC:
; A reckless full-body charge that churns up the ground.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_STRENGTH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $3, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 60, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $e8
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_ShadowBone_CC:
; A spectral bone whirls out and clubs the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_BONEMERANG, 88, 56, $1c
	anim_wait 24
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_DireClaw_CC:
; Venom-slick claws rake the target.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_TEAR, ANIM_GFX_HIT, ANIM_GFX_POISON
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CLAW_TEAR, 132, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CLAW_TEAR, 140, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 130, 48, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 142, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_BarbBarrage_CC:
; A hail of poisonous barbs peppers the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
.loop
	anim_sound 6, 2, SFX_POISON_STING
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 5
	anim_loop 4, .loop
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_InfernalParade_CC:
; Eerie will-o-wisp flames swirl in and engulf the target.
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_WILL_O_WISP
	anim_1gfx ANIM_GFX_FIRE
	anim_bgp $1b
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 0, $12
	anim_wait 6
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  11, 0, $14
	anim_wait 6
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 4, $13
	anim_wait 12
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_sound 0, 1, SFX_EMBER
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $30
	anim_wait 32
	anim_ret

BattleAnim_KowtowCleave_CC:
; A feint, then a merciless dark blade comes down.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_MENU
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_ArmorCannon_CC:
; The user blasts pieces of its own burning armor at the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $8, $0
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $20
	anim_wait 12
	anim_clearobjs
	anim_sound 6, 2, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EMBER,   8, 0,  11, 0, $12
	anim_wait 4
	anim_sound 6, 2, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 0, $14
	anim_wait 12
	anim_incobj 1
	anim_incobj 2
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $3, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 130, 64, $0
	anim_wait 24
	anim_ret

BattleAnim_ShellSideArm_CC:
; A globby poison shot fired from the shell.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 6
	anim_obj ANIM_OBJ_MUD_SHOT, 60, 88, $4
	anim_wait 12
	anim_sound 0, 1, SFX_SLUDGE_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ACID, 136, 56, $10
	anim_wait 24
	anim_ret

BattleAnim_GlaiveRush_CC:
; An all-out glaive charge with total disregard for defense.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_THROW_BALL
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 10
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $3, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_DragonDarts_CC:
; Two darts streak into the target one after the other.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_TRIANGLE, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 98, $2
	anim_wait 10
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 6
	anim_sound 6, 2, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 98, $2
	anim_wait 10
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_AppleAcid_CC:
; An apple lobs over and bursts into stinging acid.
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_POISON
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $20
	anim_wait 16
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GASTRO_ACID
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_ACID, 136, 48, $10
	anim_wait 16
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_GravApple_CC:
; An apple plummets straight down onto the target's head.
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_GREEN
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_BIG_ROCK, 136, 48, $48
	anim_wait 16
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_PsyshieldBash_CC:
; A psychic barrier forms, then the user rams behind it.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_REFLECT, ANIM_GFX_HIT
	anim_obp0 $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 24
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_RagingFury_CC:
; A blazing rampage that crashes flames over the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $8, $0
	anim_sound 0, 0, SFX_OUTRAGE
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 64, 88, $20
	anim_wait 8
	anim_clearobjs
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $3, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 52, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $10
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_StrangeSteam_CC:
; Pink, dreamlike steam billows over the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PINK
	anim_2gfx ANIM_GFX_HAZE, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 88, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 80, $0
	anim_wait 16
	anim_sound 0, 1, SFX_SWEET_SCENT_2
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 24
	anim_ret

BattleAnim_EerieSpell_CC:
; A sinister incantation of sound and psychic power.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_PSYCHIC, ANIM_GFX_NOISE
	anim_bgp $1b
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 136, 56, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 24
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_BanefulBunker_CC:
; A protective barrier bristling with venomous spikes.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_OBJECTS, ANIM_GFX_POISON
	anim_sound 0, 0, SFX_PROTECT
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $0
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $d
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $1a
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $27
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $34
	anim_wait 32
	anim_sound 0, 0, SFX_TOXIC
	anim_obj ANIM_OBJ_POISON_DROPLET, 56, 80, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 72, 76, $0
	anim_wait 24
	anim_ret

BattleAnim_RagingBull_CC:
; A furious charge that smashes straight through barriers.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_REFLECT, ANIM_GFX_ROCKS
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_obj ANIM_OBJ_SCREEN, 136, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_GLASS_TING
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $e8
	anim_wait 24
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_FickleBeam_CC:
; A wavering draconic beam - sometimes every head fires at once.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_BEAM, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,   8, 0,  11, 4, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,  10, 0,  10, 4, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM,  12, 0,   9, 4, $0
	anim_wait 12
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_AEROBLAST
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_StoneAxe_CC:
; An axe of stone cleaves in, leaving jagged points hanging.
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_ROCKS
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_wait 16
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 120, 48, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 136, 40, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 152, 48, $0
	anim_wait 32
	anim_ret

BattleAnim_QuiverDance_CC:
; A mystic, mesmerizing dance.
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_STARS
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_GLIMMER, 44, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 84, 96, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 84, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 44, 96, $0
	anim_wait 16
	anim_sound 0, 0, SFX_TWINKLE
	anim_obj ANIM_OBJ_SWIRL_SHORT, 64, 88, $0
	anim_wait 24
	anim_ret

BattleAnim_StealthRock_CC:
; Jagged stones scatter and hang in the air on the foe's side.
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_SHINE
	anim_sound 6, 2, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 120, 40, $30
	anim_obj ANIM_OBJ_SMALL_ROCK, 140, 36, $40
	anim_wait 12
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 116, 48, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 132, 40, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 148, 48, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 132, 44, $0
	anim_wait 24
	anim_ret

BattleAnim_Defog_CC:
; A clearing gust sweeps the whole field clean.
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_WIND_BG
	anim_obp0 $fc
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 48, $2
	anim_obj ANIM_OBJ_AGILITY, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 32, $6
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
.loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 6
	anim_loop 6, .loop
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 32
	anim_resetobp0
	anim_ret

BattleAnim_BodyPress_CC:
; The user flattens the target under its full weight.
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 10
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 64, $0
	anim_obj ANIM_OBJ_HIT_YFIX, 144, 64, $0
	anim_wait 24
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_WorkUp_CC:
; The user rouses itself with fighting spirit.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED
	anim_2gfx ANIM_GFX_BULK_UP, ANIM_GFX_SHINE
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_BULK_UP, 64, 88, $0
	anim_wait 24
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 48, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 80, 92, $0
	anim_wait 24
	anim_ret

BattleAnim_Superpower_CC:
; Every last bit of power thrown into one colossal blow.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED
	anim_sound 0, 0, SFX_RAGE
	anim_wait 8
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 52, $0
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_FieryDance_CC:
; A whirl of dancing flames that fan out over the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $4, $0
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 0, $12
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 4, $14
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 4, $13
	anim_wait 8
	anim_obj ANIM_OBJ_GLIMMER, 64, 88, $0
	anim_wait 8
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,  15, 0,   8, 4, $30
	anim_obj ANIM_OBJ_EMBER, -16, 4,   8, 4, $30
	anim_obj ANIM_OBJ_EMBER, -14, 0,   8, 4, $30
	anim_wait 32
	anim_ret

BattleAnim_FoulPlay_CC:
; The user turns the foe's own strength against it.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_2gfx ANIM_GFX_TEAR, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_MENU
	anim_wait 8
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CLAW_TEAR, 132, 48, $0
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_RageFist_CC:
; A spectral fist swollen with stored rage.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_1gfx ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_RAGE
	anim_wait 8
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 148, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 122, 34, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_CrushClaw_CC:
; Claws crush down and tear through the target.
	anim_2gfx ANIM_GFX_TEAR, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CLAW_TEAR, 132, 48, $0
	anim_wait 10
	anim_sound 0, 1, SFX_VICEGRIP
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 24
	anim_ret

BattleAnim_ForcePalm_CC:
; A palm strike that detonates with a shock wave.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_LIGHTNING
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_PALM, 124, 44, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_SPARKS_CIRCLE, -15, 0,   7, 0, $0
	anim_wait 40
	anim_ret

BattleAnim_HammerArm_CC:
; A slow, crushing hammer blow.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 136, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_STRENGTH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $24, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 132, 60, $0
	anim_wait 24
	anim_ret

BattleAnim_CircleThrow_CC:
; The foe is seized and hurled away in a wide arc.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_WIND
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_SUBMISSION
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 52, $0
	anim_wait 8
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_FreezeDry_CC:
; The target's moisture is flash-frozen solid.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
	anim_2gfx ANIM_GFX_ICE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_SHARD, 64, 88, $0
	anim_wait 12
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $28
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $10
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $9c
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 56, $0
	anim_wait 32
	anim_ret

BattleAnim_Bounce_CC:
; Turn 1: the user springs high out of sight.
; Turn 2: it slams down onto the target.
	anim_if_param_equal $1, .turn1
	anim_if_param_equal $2, .miss
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 0,   7, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, -14, 4,   8, 0, $0
	anim_wait 24
.miss
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret
.turn1
	anim_1gfx ANIM_GFX_U_TURN
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $1, $0
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_JUMP_KICK
	anim_obj ANIM_OBJ_BLUR_VERTICAL_UP, 48, 30, $30
	anim_wait 48
	anim_ret

BattleAnim_DragonTail_CC:
; A sweeping tail blow that bats the foe out of battle.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_WIND
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 16
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 32
	anim_ret

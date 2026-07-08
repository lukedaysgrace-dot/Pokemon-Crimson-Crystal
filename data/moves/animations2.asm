; Move animations ported from polishedcrystal (second scripts bank).
BattleAnim_TargetObj_1Row_B:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_TargetObj_2Row_B:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_UserObj_2Row_B:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_wait 4
	anim_ret

BattleAnim_ShowMon_0_B:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_ShowMon_1_B:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 1
	anim_ret
; ==== Move animations ported from polishedcrystal ====

BattleAnim_Acrobatics:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $11, $4
.loop
	anim_sound 0, 0, SFX_SQUEAK
	anim_wait 8
	anim_loop 3, .loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_incbgeffect ANIM_BG_VIBRATE_MON
	anim_call BattleAnimSub_QuickAttack
	anim_wait 12
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 12
	anim_clearobjs
	anim_bgeffect ANIM_BG_07, $0, $0, $0
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
	anim_bgeffect ANIM_BG_07, $0, $a, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret


BattleAnim_AerialAce:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_CUT
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_call BattleAnimSub_QuickAttack
	anim_wait 12
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 160, 40, $0
	anim_wait 24
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_obj ANIM_OBJ_CUT_UP_RIGHT, 120, 68, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 24
	anim_ret


BattleAnim_AquaTail:
	anim_3gfx ANIM_GFX_HIT_2, ANIM_GFX_BUBBLE, ANIM_GFX_SAND
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_RISING_BUBBLE, 64, 104, $0
	anim_wait 16
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_RISING_BUBBLE, 32, 104, $0
	anim_wait 16
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_RISING_BUBBLE, 48, 104, $0
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_call BattleAnim_TargetObj_1Row_B
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_wait 16
	anim_sound 0, 1, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_DIG_SAND, 104, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 112, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 120, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 128, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 136, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 144, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 152, 60, $0
	anim_wait 1
	anim_obj ANIM_OBJ_DIG_SAND, 160, 60, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $5c
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $e8
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $d0
	anim_wait 8
	anim_incbgeffect ANIM_BG_26
	anim_wait 16
	anim_jump BattleAnim_ShowMon_0_B


BattleAnim_Astonish:
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_MISC_2
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 12
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 1
	anim_clearobjs
	anim_wait 1
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_FORESIGHT, 136, 48, $0
	anim_obj ANIM_OBJ_DROPLET_R, 146, 52, $38
	anim_obj ANIM_OBJ_DROPLET_L, 126, 52, $28
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_ret


BattleAnim_AuraSphere:
; The user gathers rising blue energy (Focus Energy-style charge), then fires the blue aura sphere.
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_GLOW
	anim_bgeffect ANIM_BG_06, $0, $2, $0
.charge_loop
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 44, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 36, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 52, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 28, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 60, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 20, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_AURA_SPHERE_CHARGE, 68, 108, $8
	anim_wait 2
	anim_loop 3, .charge_loop
	anim_wait 8
	anim_obj ANIM_OBJ_AURA_SPHERE_GLOW, 48, 96, $0
	anim_wait 16
	anim_clearobjs
	anim_3gfx ANIM_GFX_BIG_GLOW_CLEAR, ANIM_GFX_AURA_SPHERE, ANIM_GFX_WIND_BG
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_AURA_SPHERE, 64, 88, $6
	anim_wait 12
	anim_bgeffect ANIM_BG_1F, $08, $2, $0
	anim_sound 0, 1, SFX_AEROBLAST
	anim_obj ANIM_OBJ_BIG_GLOW_CLEAR, 136, 48, $0
	anim_wait 8
	anim_clearobjs
	anim_wait 32
	anim_ret


BattleAnim_Avalanche:
	anim_2gfx ANIM_GFX_ICE, ANIM_GFX_SMOKE_PUFF
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_bgeffect ANIM_BG_20, $c0, $1, $0
	anim_bgp $90
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 134, 250, $10
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 110, 20, $12
	anim_wait 2
.loop
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 122, 250, $12
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 142, 20, $0e
	anim_wait 2
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_AVALANCHE_BIG, 144, 250, $0e
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 118, 20, $11
	anim_wait 2
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 154, 250, $0f
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 130, 20, $10
	anim_wait 2
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_AVALANCHE_BIG, 118, 250, $11
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 154, 20, $0f
	anim_wait 2
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 134, 250, $10
	anim_wait 2
	anim_obj ANIM_OBJ_SNOW_FALL, 110, 20, $12
	anim_wait 2
	anim_sound 0, 1, SFX_TACKLE
	anim_loop 4, .loop
	anim_wait 32
	anim_ret


BattleAnim_BraveBird:
	anim_1gfx ANIM_GFX_SKY_ATTACK
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_bgeffect ANIM_BG_27, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $0
	anim_obp0 $30
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_BRAVE_BIRD, 48, 88, $0
	anim_wait 16
	anim_clearobjs
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BRAVE_BIRD, 48, 88, $18
	anim_wait 16
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_wait 64
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret


BattleAnim_BulkUp:
	anim_2gfx ANIM_GFX_BULK_UP, ANIM_GFX_WIND
	anim_sound 0, 0, SFX_SQUEAK
	anim_obj ANIM_OBJ_BULK_UP, 48, 88, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_1F, $08, $2, $0
	anim_sound 0, 0, SFX_HORN_ATTACK
	anim_wait 24
	anim_bgeffect ANIM_BG_1F, $08, $2, $0
	anim_sound 0, 0, SFX_HORN_ATTACK
	anim_wait 24
	anim_clearobjs
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
	anim_wait 32
	anim_ret


BattleAnim_Bulldoze:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row_B
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $11, $4
.loop
	anim_sound 0, 1, SFX_SPARK
	anim_wait 8
	anim_loop 6, .loop
	anim_incbgeffect ANIM_BG_VIBRATE_MON
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_20, $40, $3, $0
.loop2
	anim_sound 0, 1, SFX_SPARK
	anim_wait 4
	anim_loop 12, .loop2
	anim_incbgeffect ANIM_BG_20
	anim_wait 16
	anim_ret


BattleAnim_CalmMind:
	anim_3gfx ANIM_GFX_BIG_RINGS, ANIM_GFX_RINGS, ANIM_GFX_GLOW
	anim_bgp $1b
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_ATTRACT
	anim_obj ANIM_OBJ_SMALL_GLOW, 48, 96, $0
	anim_wait 32
	anim_clearobjs
	anim_sound 0, 1, SFX_GAME_FREAK_LOGO_GS
.loop
	anim_obj ANIM_OBJ_SHRINKING_RING_BIG, 48, 96, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHRINKING_RING_SMALL, 48, 96, $0
	anim_wait 16
	anim_loop 4, .loop
	anim_wait 16
	anim_ret


BattleAnim_DragonDance:
	anim_1gfx ANIM_GFX_CHARGE
	anim_bgeffect ANIM_BG_18, $0, $1, $40
.loop
	anim_sound 0, 0, SFX_OUTRAGE
	anim_obj ANIM_OBJ_DRAGON_DANCE, 48, 104, $0
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 48
	anim_ret


BattleAnim_DragonPulse:
	anim_call BattleAnimSub_BGCycleOBPalsGrayAndYellow_0_2_0
	anim_2gfx ANIM_GFX_GLOW, ANIM_GFX_CHARGE,
	anim_bgeffect ANIM_BG_1F, $55, $1, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_obj ANIM_OBJ_SMALL_GLOW, 48, 96, $0
.loop
	anim_sound 0, 0, SFX_AEROBLAST
	anim_obj ANIM_OBJ_DRAGON_PULSE, 64, 88, $4
	anim_wait 4
	anim_loop 16, .loop
	anim_incobj 1
	anim_wait 16
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_ret


BattleAnim_EarthPower:
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_ROCKS
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_bgp $1b
	anim_bgeffect ANIM_BG_1F, $28, $2, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 120, 68, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 120, 68, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 120, 68, $9c
	anim_obj ANIM_OBJ_ROCK_SMASH, 120, 68, $50
	anim_obj ANIM_OBJ_EMBER, 120, 68, $30
	anim_wait 40
	anim_clearobjs
	anim_wait 8
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_1F, $28, $2, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 144, 68, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 144, 68, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 144, 68, $d0
	anim_obj ANIM_OBJ_ROCK_SMASH, 144, 68, $10
	anim_obj ANIM_OBJ_EMBER, 144, 68, $30
	anim_wait 40
	anim_clearobjs
	anim_wait 8
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_1F, $28, $2, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 132, 68, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 132, 68, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 132, 68, $d0
	anim_obj ANIM_OBJ_ROCK_SMASH, 132, 68, $50
	anim_obj ANIM_OBJ_EMBER, 132, 68, $30
	anim_wait 48
	anim_ret


BattleAnim_EnergyBall:
	anim_4gfx ANIM_GFX_ENERGY_BALL, ANIM_GFX_GLOW, ANIM_GFX_HIT, ANIM_GFX_BUBBLE
	anim_bgeffect ANIM_BG_06, $0, $4, $0
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
	anim_sound 0, 0, SFX_WARP_TO
	anim_wait 16
	anim_loop 4, .loop
	anim_wait 16
	anim_sound 0, 1, SFX_PRESENT
	anim_wait 48
	anim_clearobjs
	anim_sound 0, 1, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_SIGNAL_BEAM_R, 64, 92, $2
	anim_wait 32
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_1F, $6, $1, $0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $5c
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $e8
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $d0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $50
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_YFIX, 144, 48, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 40, $0
	anim_wait 16
	anim_ret


BattleAnim_Extrasensory:
	anim_1gfx ANIM_GFX_SHINE
	anim_call BattleAnim_UserObj_2Row_B
	anim_sound 0, 1, SFX_CUT
	anim_bgp $1b
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_GLIMMER, 44, 96, $0
	anim_wait 40
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_NIGHT_SHADE, $0, $0, $8
	anim_obj ANIM_OBJ_GLIMMER, 44, 96, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_NIGHT_SHADE
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_TELEPORT, $0, $0, $0
	anim_obj ANIM_OBJ_GLIMMER, 44, 96, $0
	anim_wait 4
	anim_sound 0, 1, SFX_PSYCHIC
	anim_wait 64
	anim_incbgeffect ANIM_BG_TELEPORT
	anim_call BattleAnim_ShowMon_1_B
	anim_ret


BattleAnim_Facade:
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_MISC_2
	anim_call BattleAnim_TargetObj_2Row_B
	anim_bgeffect ANIM_BG_BOUNCE_DOWN, $0, $1, $0
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_DROPLET_R, 64, 102, $3b
	anim_obj ANIM_OBJ_DROPLET_L, 44, 102, $24
	anim_wait 24
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_DROPLET_R, 64, 82, $3b
	anim_obj ANIM_OBJ_DROPLET_L, 44, 82, $24
	anim_wait 24
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_DROPLET_R, 64, 102, $3b
	anim_obj ANIM_OBJ_DROPLET_L, 44, 102, $24
	anim_wait 24
	anim_incbgeffect ANIM_BG_18
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_DROPLET_R, 64, 82, $3b
	anim_obj ANIM_OBJ_DROPLET_L, 44, 82, $24
	anim_wait 24
	anim_incbgeffect ANIM_BG_BOUNCE_DOWN
	anim_call BattleAnim_ShowMon_0_B
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 16
	anim_ret


BattleAnim_FlareBlitz:
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_HIT
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
.loop
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_FLARE_BLITZ, 44, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FLARE_BLITZ, 36, 108, $6
	anim_wait 2
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_FLARE_BLITZ, 52, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FLARE_BLITZ, 28, 108, $8
	anim_wait 2
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_FLARE_BLITZ, 60, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FLARE_BLITZ, 20, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FLARE_BLITZ, 68, 108, $8
	anim_wait 2
	anim_loop 3, .loop
	anim_wait 16
	anim_incbgeffect ANIM_BG_1A
	anim_wait 1
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 1
	anim_clearobjs
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $0
	anim_bgeffect ANIM_BG_1F, $30, $2, $0
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $28
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $30
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $38
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $8
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $18
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $4
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $2b
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $14
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $3b
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $24
	anim_wait 1
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $b
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_wait 2
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_wait 33
	anim_clearobjs
	anim_ret


BattleAnim_FlashCannon:
	anim_4gfx ANIM_GFX_BIG_GLOW_CLEAR, ANIM_GFX_GLOW, ANIM_GFX_CHARGE, ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $6, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_BIG_GLOW_CLEAR, 48, 96, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $3, $0
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 64, 80, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $00
	anim_wait 6
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $30
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 32, 114, $0
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $0c
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 64, 114, $0
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $24
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 32, 80, $0
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $18
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 48, 96, $0
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SLOW_GROWING_GLOW, 48, 96, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $00
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $30
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $0c
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $24
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 96, $18
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_wait 6
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_GIGA_DRAIN
	anim_obj ANIM_OBJ_FLASH_CANNON, 48, 96, $4
	anim_wait 24
	anim_sound 0, 0, SFX_AEROBLAST
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 140, 44, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $0
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $28
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $30
	anim_wait 1
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $38
	anim_wait 1
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 124, 60, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $20
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $8
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $18
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $4
	anim_wait 1
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 140, 60, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $2b
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $14
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $3b
	anim_wait 1
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 136, 48, $24
	anim_wait 1
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 124, 44, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_WHITE, 136, 48, $b
	anim_wait 4
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 132, 52, $0
	anim_wait 32
	anim_ret


BattleAnim_FocusBlast:
	anim_3gfx ANIM_GFX_VORTEX, ANIM_GFX_WIND_BG, ANIM_GFX_SWIRL
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnimSub_AgilityMinor
	anim_sound 0, 1, SFX_OUTRAGE
.loop
	anim_obj ANIM_OBJ_SWIRL_SHORT, 44, 96, $0
	anim_wait 8
	anim_loop 4, .loop
	anim_obj ANIM_OBJ_VORTEX, 44, 96, $0
	anim_wait 64
	anim_clearobjs
	anim_wait 1
	anim_2gfx ANIM_GFX_BIG_GLOW_CLEAR, ANIM_GFX_FOCUS_BLAST
	anim_sound 0, 1, SFX_MEGA_PUNCH
.loop2
	anim_obj ANIM_OBJ_FOCUS_BLAST, 64, 88, $12
	anim_wait 32
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_bgeffect ANIM_BG_1F, $60, $2, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_BIG_GLOW_CLEAR, 136, 48, $0
	anim_wait 40
	anim_ret


BattleAnim_GigaImpact:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_CHARGE
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_sound 0, 0, SFX_OUTRAGE
.loop
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $0
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $20
	anim_wait 4
	anim_loop 4, .loop
	anim_wait 48
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_call BattleAnim_TargetObj_2Row_B
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_SPARK
	anim_wait 16
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_clearobjs
	anim_sound 0, 1, SFX_THUNDER
	anim_bgeffect ANIM_BG_1F, $60, $4, $10
.loop2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_wait 20
	anim_loop 3, .loop2
	anim_wait 16
	anim_ret


BattleAnim_GunkShot:
	anim_purplepal
	anim_2gfx ANIM_GFX_WIND_BG, ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_obj ANIM_OBJ_GUNK_SHOT, 48, 96, $0
	anim_call BattleAnimSub_AgilityMinor
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_GUNK_SHOT_BUBBLES, 48, 88, $5c
	anim_wait 2
	anim_obj ANIM_OBJ_GUNK_SHOT_BUBBLES, 48, 88, $e8
	anim_wait 2
	anim_obj ANIM_OBJ_GUNK_SHOT_BUBBLES, 48, 88, $d0
	anim_wait 2
	anim_obj ANIM_OBJ_GUNK_SHOT_BUBBLES, 48, 88, $50
	anim_wait 2
	anim_loop 6, .loop
	anim_wait 16
	anim_clearobjs
	anim_bgp $1b
	anim_bgeffect ANIM_BG_1F, $60, $4, $10
.loop2
	anim_sound 6, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 4
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 4
	anim_sound 6, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $d0
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $50
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 4
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 4
	anim_loop 4, .loop2
	anim_wait 4
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $d0
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $50
	anim_wait 32
	anim_ret


BattleAnim_GyroBall:
	anim_1gfx ANIM_GFX_GYRO_BALL
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_call BattleAnimSub_BGCycleOBPalsGrayAndYellow_0_2_0
	anim_sound 0, 0, SFX_OUTRAGE
	anim_obj ANIM_OBJ_GYRO_BALL, 44, 96, $0
	anim_wait 64
	anim_incbgeffect ANIM_BG_18
	anim_clearobjs
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 13
	anim_incobj 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 1
	anim_clearobjs
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_WIND
	anim_bgeffect ANIM_BG_07, $0, $4, $0
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_wait 8
	anim_sound 0, 0, SFX_PSYBEAM
.loop
	anim_obj ANIM_OBJ_RAPID_SPIN, 136, 72, $0
	anim_wait 2
	anim_loop 5, .loop
	anim_wait 62
	anim_ret


BattleAnim_Hex:
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_SPEED
	anim_battlergfx_2row
	anim_bgp $f8
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 8
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 40
	anim_bgp $1b
	anim_sound 0, 0, SFX_SPITE
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_obj ANIM_OBJ_BURNED, 116, 52, $10
	anim_obj ANIM_OBJ_BURNED, 148, 52, $90
	anim_bgeffect ANIM_BG_1F, $55, $1, $0
.loop
	anim_obj ANIM_OBJ_FOCUS, 136, 72, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 128, 72, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 144, 72, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 120, 72, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 152, 72, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 112, 72, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 160, 72, $8
	anim_wait 2
	anim_loop 3, .loop
	anim_wait 24
	anim_ret


BattleAnim_HoneClaws:
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_HONE_CLAWS_RIGHT, 24, 84, $0
	anim_wait 7
	anim_sound 0, 1, SFX_SHINE
	anim_wait 5
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_HONE_CLAWS_LEFT, 72, 84, $0
	anim_wait 7
	anim_sound 0, 1, SFX_SHINE
	anim_wait 5
.loop
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_HONE_CLAWS_RIGHT, 24, 84, $0
	anim_wait 2
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 20, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 28, 104, $0
	anim_wait 5
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_HONE_CLAWS_LEFT, 72, 84, $0
	anim_wait 2
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 76, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_PULSING_SPARKLE_YFIX, 68, 104, $0
	anim_wait 5
	anim_loop 3, .loop
	anim_ret


BattleAnim_Hurricane:
	anim_2gfx ANIM_GFX_HURRICANE, ANIM_GFX_WIND_BG
	anim_bgeffect ANIM_BG_1F, $90, $4, $10
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $4, $0
	anim_bgeffect ANIM_BG_06, $0, $4, $0
	anim_obj ANIM_OBJ_HURRICANE, 132, 56, $38
	anim_call BattleAnimSub_AgilityMinor
.loop
	anim_sound 0, 1, SFX_THUNDER
	anim_wait 4
	anim_loop 18, .loop
	anim_wait 24
	anim_ret


BattleAnim_HyperVoice:
	anim_2gfx ANIM_GFX_NOISE, ANIM_GFX_PSYCHIC
.loop
	anim_cry $0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_1F, $30, $2, $0
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_obj ANIM_OBJ_HYPER_VOICE, 64, 88, $2
	anim_wait 2
	anim_obj ANIM_OBJ_HYPER_VOICE, 64, 88, $2
	anim_wait 28
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 28
	anim_loop 2, .loop
	anim_wait 8
	anim_ret


BattleAnim_IcicleSpear:
	anim_3gfx ANIM_GFX_HORN, ANIM_GFX_ICE, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_MEDIUM_HORN, 64, 92, $28
	anim_wait 12
	anim_obj ANIM_OBJ_MEDIUM_HORN, 56, 84, $28
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $28
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $10
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $9c
	anim_wait 12
	anim_obj ANIM_OBJ_MEDIUM_HORN, 52, 88, $28
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_obj ANIM_OBJ_ICE_SPLASH, 128, 48, $28
	anim_obj ANIM_OBJ_ICE_SPLASH, 128, 48, $10
	anim_obj ANIM_OBJ_ICE_SPLASH, 128, 48, $9c
	anim_wait 12
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 132, 52, $0
	anim_obj ANIM_OBJ_ICE_SPLASH, 132, 52, $28
	anim_obj ANIM_OBJ_ICE_SPLASH, 132, 52, $10
	anim_obj ANIM_OBJ_ICE_SPLASH, 132, 52, $9c
	anim_wait 16
	anim_ret


BattleAnim_IronHead:
	anim_3gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT, ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row_B
	anim_call BattleAnimSub_Metallic
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 6
	anim_sound 0, 1, SFX_HEADBUTT
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $9c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $d0
	anim_wait 6
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $1c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $50
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $dc
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $90
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_B
	anim_ret


BattleAnim_KnockOff:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_PALM, 136, 08, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 16, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 24, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 32, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 40, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 48, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_20, $10, $1, $20
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_obj ANIM_OBJ_PALM, 136, 56, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 64, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 72, $0
	anim_wait 8
	anim_ret


BattleAnim_NastyPlot:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 64, 88, $2
	anim_wait 16
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 68, 88, $1
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 28, 88, $2
	anim_wait 16
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 72, 88, $0
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 24, 88, $1
	anim_obj ANIM_OBJ_NASTY_PLOT_2, 46, 80, $2
	anim_wait 16
	anim_obj ANIM_OBJ_NASTY_PLOT_1, 20, 88, $0
	anim_obj ANIM_OBJ_NASTY_PLOT_2, 46, 80, $1
	anim_wait 16
	anim_obj ANIM_OBJ_NASTY_PLOT_2, 46, 80, $0
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_2gfx ANIM_GFX_OBJECTS, ANIM_GFX_MISC
	anim_obj ANIM_OBJ_NASTY_PLOT_HAND, 48, 72, $0
	anim_sound 0, 1, SFX_FORESIGHT
	anim_obj ANIM_OBJ_NASTY_PLOT_SURPRISED, 48, 72, $0
	anim_wait 24
	anim_ret


BattleAnim_NightSlash:
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_WIND_BG
	anim_bgp $1b
	anim_obp0 $c0
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 32, $6
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
	anim_bgeffect ANIM_BG_1F, $08, $2, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 40
	anim_bgeffect ANIM_BG_1F, $08, $2, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 152, 52, $20
	anim_wait 32
	anim_ret


BattleAnim_PowerGem:
	anim_1gfx ANIM_GFX_SHINE
	anim_bgp $1b
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_POWER_GEM, 46, 88, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 24, 90, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 36, 72, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 44, 112, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 30, 106, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 64, 104, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 54, 68, $0
	anim_wait 1
	anim_obj ANIM_OBJ_POWER_GEM, 72, 82, $0
	anim_wait 80
	anim_sound 0, 1, SFX_SHINE
	anim_incobj  8
	anim_wait 2
	anim_incobj  7
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_incobj  6
	anim_wait 4
	anim_sound 0, 1, SFX_SHINE
	anim_incobj  4
	anim_wait 2
	anim_incobj  1
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_incobj  3
	anim_wait 2
	anim_incobj  5
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_incobj  2
	anim_wait 34
	anim_ret


BattleAnim_PowerWhip:
	anim_2gfx ANIM_GFX_BIG_WHIP, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_CUT
	anim_obj ANIM_OBJ_PUNISHMENT, 96, 245, $0c
	anim_wait 2
	anim_obj ANIM_OBJ_PUNISHMENT, 96, 245, $0c
	anim_wait 12
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $08
	anim_bgeffect ANIM_BG_20, $28, $2, $0
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_HIT_BIG, 136, 48, $0
	anim_wait 32
	anim_ret


BattleAnim_Psystrike:
	anim_4gfx ANIM_GFX_PSYSTRIKE, ANIM_GFX_CHARGE, ANIM_GFX_GLOW, ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_1F, $40, $1, $0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $0
	anim_bgeffect ANIM_BG_06, $0, $4, $0
	anim_sound 0, 0, SFX_BIND
	anim_obj ANIM_OBJ_PSYSTRIKE_BALL, 64, 88, $12
	anim_wait 32
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $1
	anim_sound 0, 1, SFX_PSYCHIC
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
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
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $ff
	anim_sound 0, 1, SFX_PSYBEAM
.loop2
	anim_obj ANIM_OBJ_SHRINKING_GLOW_YFIX, 148, 36, $0
	anim_obj ANIM_OBJ_FOCUS, 132, 68, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 124, 68, $6
	anim_wait 2
	anim_obj ANIM_OBJ_SHRINKING_GLOW_YFIX, 116, 48, $0
	anim_obj ANIM_OBJ_FOCUS, 140, 68, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 116, 68, $8
	anim_wait 2
	anim_obj ANIM_OBJ_SHRINKING_GLOW_YFIX, 132, 60, $0
	anim_obj ANIM_OBJ_FOCUS, 148, 68, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 108, 68, $8
	anim_wait 2
	anim_obj ANIM_OBJ_SHRINKING_GLOW_YFIX, 124, 24, $0
	anim_obj ANIM_OBJ_FOCUS, 156, 68, $8
	anim_wait 2
	anim_obj ANIM_OBJ_SHRINKING_GLOW_YFIX, 144, 52, $0
	anim_wait 2
	anim_loop 3, .loop2
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_wait 1
	anim_clearobjs
	anim_ret


BattleAnim_RockBlast:
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_BLAST, 64, 92, $4
	anim_wait 16
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 56, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 56, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 56, $d0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 56, $50
	anim_wait 32
	anim_ret


BattleAnim_Roost:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_wait 16
	anim_sound 0, 0, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_ROOST, 48, 80, $00
	anim_obj ANIM_OBJ_ROOST, 48, 80, $0d
	anim_obj ANIM_OBJ_ROOST, 48, 80, $1a
	anim_obj ANIM_OBJ_ROOST, 48, 80, $27
	anim_obj ANIM_OBJ_ROOST, 48, 80, $34
	anim_wait 130
	anim_incbgeffect ANIM_BG_18
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_jump BattleAnimSub_Glimmer


BattleAnim_Scald:
	anim_3gfx ANIM_GFX_HIT_2, ANIM_GFX_MISC, ANIM_GFX_SMOKE_PUFF
	anim_bgp $90
	anim_sound 0, 1, SFX_SURF
	anim_obj ANIM_OBJ_SCALD, 64, 88, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SCALD, 64, 88, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SCALD, 64, 88, $4
	anim_wait 4
.loop
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_SCALD, 64, 88, $4
	anim_obj ANIM_OBJ_SCALD_STEAM, 120, 46, $30
	anim_wait 1
	anim_obj ANIM_OBJ_SCALD_STEAM, 144, 34, $30
	anim_wait 3
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_SCALD, 64, 88, $4
	anim_wait 4
	anim_loop 7, .loop
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_SCALD_STEAM, 120, 46, $30
	anim_wait 1
	anim_obj ANIM_OBJ_SCALD_STEAM, 144, 34, $30
	anim_wait 3
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SCALD_STEAM, 120, 46, $30
	anim_wait 1
	anim_obj ANIM_OBJ_SCALD_STEAM, 144, 34, $30
	anim_wait 7
	anim_bgeffect ANIM_BG_19, $0, $0, $40
	anim_sound 0, 1, SFX_POISON_STING
.loop2
	anim_obj ANIM_OBJ_SCALD_STEAM, 120, 46, $30
	anim_wait 1
	anim_obj ANIM_OBJ_SCALD_STEAM, 144, 34, $30
	anim_wait 8
	anim_loop 6, .loop2
	anim_wait 8
	anim_incbgeffect ANIM_BG_19
	anim_ret


BattleAnim_SeedBomb:
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_EXPLOSION
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $20
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 48, 72, $30
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 64, 72, $28
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 48, 72, $20
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $30
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 130, 68, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 134, 50, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 132, 54, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 62, $0
	anim_wait 24
	anim_ret


BattleAnim_ShellSmash:
	anim_3gfx ANIM_GFX_REFLECT, ANIM_GFX_HIT, ANIM_GFX_ROCKS
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $1, $0
	anim_wait 6
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHELL_SMASH_SHELL, 48, 106, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_bgeffect ANIM_BG_1F, $58, $2, $0
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_clearobjs
	anim_bgeffect ANIM_BG_07, $0, $6, $0
	anim_incbgeffect ANIM_BG_1F
	anim_wait 1
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_SHELL_SMASH_HIT, 48, 106, $0
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $5c
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $e8
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $d0
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $50
	anim_wait 12
	anim_bgeffect ANIM_BG_19, $0, $1, $40
	anim_call BattleAnim_ShowMon_0_B
	anim_ret




BattleAnim_Transfer_Orbs_branch:
	anim_bgeffect ANIM_BG_06, $0, $4, $0
	anim_1gfx ANIM_GFX_CHARGE
.loop
	anim_sound 6, 3, SFX_STOP_SLOT
	anim_obj ANIM_OBJ_SKILL_SWAP_1, 136, 64, $2
	anim_wait 6
	anim_sound 6, 3, SFX_STOP_SLOT
	anim_obj ANIM_OBJ_SKILL_SWAP_1, 136, 64, $2
	anim_wait 6
	anim_sound 6, 3, SFX_STOP_SLOT
	anim_obj ANIM_OBJ_SKILL_SWAP_1, 136, 64, $2
	anim_wait 6
	anim_sound 6, 3, SFX_STOP_SLOT
	anim_obj ANIM_OBJ_SKILL_SWAP_1, 136, 64, $2
	anim_wait 6
	anim_sound 6, 3, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SKILL_SWAP_2, 52, 88, $8
	anim_wait 6
	anim_sound 6, 3, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SKILL_SWAP_2, 52, 88, $8
	anim_wait 6
	anim_sound 6, 3, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SKILL_SWAP_2, 52, 88, $8
	anim_wait 6
	anim_sound 6, 3, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SKILL_SWAP_2, 52, 88, $8
	anim_wait 6
	anim_loop 2, .loop
	anim_wait 32
	anim_ret


BattleAnim_ToxicSpikes:
	anim_purplepal
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_POISON
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $20
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $30
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $28
	anim_wait 40
	anim_jump BattleAnimSub_SludgeShort


BattleAnim_Trick:
	anim_1gfx ANIM_GFX_STATUS
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_sound 0, 1, SFX_GET_COIN_FROM_SLOTS
	anim_obj ANIM_OBJ_TRICK, 90, 68, $18
	anim_obj ANIM_OBJ_TRICK, 90, 68, $38
	anim_wait 16
.loop
	anim_sound 0, 1, SFX_STOP_SLOT
	anim_wait 32
	anim_loop 4, .loop
	anim_wait 7
	anim_sound 0, 1, SFX_SLOT_MACHINE_START
	anim_incobj 1
	anim_incobj 2
	anim_wait 6
	anim_clearobjs
	anim_wait 6
	anim_ret


BattleAnim_TrickRoom:
	anim_1gfx ANIM_GFX_TRICK_ROOM
	anim_bgeffect ANIM_BG_06, $0, $6, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
.loop
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 80, 72, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 156, 36, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 40, 24, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 140, 100, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 164, 64, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 48, 66, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 96, 24, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 60, 96, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 102, 86, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 150, 14, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 26, 80, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 12, 50, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 72, 30, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 110, 62, $0
	anim_wait 3
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_TRICK_ROOM, 170, 94, $0
	anim_wait 3
	anim_obj ANIM_OBJ_TRICK_ROOM, 80, 104, $0
	anim_wait 3
	anim_loop 2, .loop
	anim_wait 32
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_wait 4
	anim_ret


BattleAnim_VoltSwitch:
	anim_3gfx ANIM_GFX_CHARGE, ANIM_GFX_VOLT_SWITCH, ANIM_GFX_LIGHTNING
	anim_bgeffect ANIM_BG_06, $0, $4, $0
	anim_battlergfx_2row
	anim_sound 0, 0, SFX_WARP_TO
	anim_call BattleAnimSub_EnergyOrb
	anim_wait 12
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_obj ANIM_OBJ_VOLT_SWITCH, 64, 92, $4
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 64, 92, $5c
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 76, 84, $d0
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 108, 76, $e8
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 112, 68, $50
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 100, 60, $5c
	anim_wait 4
	anim_sound 0, 0, SFX_THUNDERSHOCK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $10, $FF
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
.loop
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 132, 56, $5c
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 132, 56, $e8
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 128, 56, $d0
	anim_wait 2
	anim_obj ANIM_OBJ_VOLT_SWITCH_SPARKS, 156, 56, $50
	anim_wait 2
	anim_loop 8, .loop
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_ret


BattleAnim_WaterPulse:
	anim_bgeffect ANIM_BG_06, $0, $4, $0
	anim_2gfx ANIM_GFX_BUBBLE, ANIM_GFX_PSYCHIC
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 6, 2, SFX_BUBBLEBEAM
	anim_wait 64
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 6
	anim_loop 3, .loop
	anim_wait 6
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
.loop2
	anim_sound 0, 1, SFX_LICK
	anim_wait 3
	anim_loop 3, .loop2
	anim_wait 32
	anim_call BattleAnim_ShowMon_1_B
	anim_ret


BattleAnim_WillOWisp:
	anim_1gfx ANIM_GFX_FIRE
	anim_bgp $1b
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_DRAGON_RAGE, 64, 92, $0
	anim_wait 40
	anim_sound 0, 0, SFX_CURSE
.loop
	anim_obj ANIM_OBJ_SACRED_FIRE, 132, 68, $0
	anim_wait 8
	anim_loop 4, .loop
	anim_wait 48
	anim_ret


BattleAnim_ZenHeadbutt:
	anim_2gfx ANIM_GFX_GLOW, ANIM_GFX_SHINE
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_06, $0, $6, $0
	anim_bgp $1b
	anim_sound 0, 0, SFX_PSYBEAM
	anim_obj ANIM_OBJ_ZEN_HEADBUTT, 44, 104, $30
	anim_wait 8
.loop
	anim_obj ANIM_OBJ_ZEN_HEADBUTT_PARTICLE,  44, 96, $5c
	anim_wait 8
	anim_obj ANIM_OBJ_ZEN_HEADBUTT_PARTICLE,  44, 96, $e8
	anim_wait 8
	anim_obj ANIM_OBJ_ZEN_HEADBUTT_PARTICLE,  44, 96, $d0
	anim_wait 8
	anim_obj ANIM_OBJ_ZEN_HEADBUTT_PARTICLE,  44, 96, $50
	anim_wait 8
	anim_loop 2, .loop
	anim_clearobjs
	anim_2gfx ANIM_GFX_HIT_2, ANIM_GFX_STARS
	anim_wait 1
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 12
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_wait 1
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_sound 0, 0, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
.loop2
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $5c
	anim_wait 2
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $e8
	anim_wait 2
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $d0
	anim_wait 2
	anim_obj ANIM_OBJ_STAR_BURST, 136, 56, $50
	anim_wait 2
	anim_loop 2, .loop2
	anim_wait 32
	anim_ret

BattleAnim_FlameCharge:
	anim_1gfx ANIM_GFX_FIRE
	anim_bgeffect ANIM_BG_18, $0, $1, $40
.loop
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_CHARGE, 40, 86, $10
	anim_wait 6
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_CHARGE, 56, 86, $90
	anim_wait 6
	anim_loop 5, .loop
	anim_wait 80
	anim_incbgeffect ANIM_BG_18
	anim_wait 1
	anim_clearobjs
	anim_call BattleAnim_TargetObj_1Row_B
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $1
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $4
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $5
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_incobj 11
	anim_wait 8
	anim_ret

; Shared subroutines ported from polishedcrystal

BattleAnimSub_AgilityMinor:
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 48, $2
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 56, $c
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
	anim_obj ANIM_OBJ_AGILITY, 8, 104, $e
	anim_ret


BattleAnimSub_BGCycleOBPalsGrayAndYellow_0_2_0:
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_ret


BattleAnimSub_EnergyOrb:
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $38
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $10
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $28
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $0
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $18
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $30
	anim_wait 4
	anim_ret


BattleAnimSub_Glimmer:
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_GLIMMER,   5, 4,   8, 0, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER,   3, 0,  12, 0, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER,   7, 0,  13, 0, $0
	anim_wait 21
	anim_ret


BattleAnimSub_Metallic:
	anim_sound 0, 0, SFX_SHINE
	anim_wait 8
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 32
	anim_obj ANIM_OBJ_HARDEN,   6, 0,  10, 4, $0
	anim_wait 64
	anim_ret


BattleAnimSub_QuickAttack:
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_ret


BattleAnimSub_SludgeShort:
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


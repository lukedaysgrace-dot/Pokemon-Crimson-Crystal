; Creative move showcase. Helpers are bank-local; phases explicitly retire
; their objects before reusing VRAM. New resource ids are append-only.

BattleAnim_ArmorCannon_Creative:
; A hot reactor draws in sparks, then fires a molten shell with armor shrapnel.
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_GLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_METALLIC
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 0, SFX_CHARGE
	anim_obj ANIM_OBJ_FLASH_CANNON_CHARGE, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $10
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $20
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $30
	anim_wait 32
	anim_clearobjs
	anim_3gfx ANIM_GFX_GLOW, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_METALLIC
	anim_sound 6, 2, SFX_AEROBLAST
	anim_obj ANIM_OBJ_FLASH_CANNON, 64, 88, $4
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH_CANNON, 72, 84, $4
	anim_wait 12
	anim_clearobjs
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $3, $0
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $3, $2
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 52, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $e8
	anim_wait 10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 120, 44, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 148, 60, $0
	anim_wait 24
	anim_ret

BattleAnim_AppleAcid_Creative:
; A real apple lob splits into a lime geyser, then drips down the victim.
	anim_1gfx ANIM_GFX_CREATIVE_APPLE
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_APPLE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_APPLE_SHOT, 56, 92, $4
	anim_wait 38
	anim_clearobjs
	anim_3gfx ANIM_GFX_POISON, ANIM_GFX_HIT, ANIM_GFX_WATER
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ACID_APPLE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ACID_APPLE
	anim_sound 0, 1, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ACID, 136, 48, $10
	anim_wait 6
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $10
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $90
	anim_wait 20
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_ACID_APPLE
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_POISON_DROPLET, 120, 40, $0
	anim_wait 5
	anim_obj ANIM_OBJ_POISON_DROPLET, 144, 36, $0
	anim_wait 5
	anim_obj ANIM_OBJ_ACID, 132, 64, $10
	anim_wait 24
	anim_ret

BattleAnim_FieryDance_Creative:
; A turning flame ribbon becomes two spreading fire fans on the target.
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_SWIRL_SA, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 0, SFX_SWORDS_DANCE
.dance
	anim_obj ANIM_OBJ_SWIRL_SHORT_SOUR, 48, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 88, $8
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 88, $28
	anim_wait 12
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 88, $18
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 88, $38
	anim_wait 12
	anim_clearobjs
	anim_loop 2, .dance
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FLARE_BLITZ, 64, 92, $4
	anim_wait 20
	anim_clearobjs
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $3, $2
	anim_sound 0, 1, SFX_EMBER
.fan
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $30
	anim_wait 16
	anim_clearobjs
	anim_loop 2, .fan
	anim_sound 0, 0, SFX_TWINKLE
	anim_obj ANIM_OBJ_GLIMMER, 40, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 56, 96, $0
	anim_wait 20
	anim_ret

BattleAnim_FoulPlay_Creative:
; Read the foe, vanish, then ambush it from both sides with hooked dark arcs.
	anim_2gfx ANIM_GFX_STATUS, ANIM_GFX_SHADOW_SNEAK_SA
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_sound 0, 1, SFX_PSYCHIC
	anim_obj ANIM_OBJ_PSYCH_UP, 136, 48, $0
	anim_obj ANIM_OBJ_PSYCH_UP, 136, 48, $20
	anim_wait 20
	anim_clearobjs
	anim_bgeffect ANIM_BG_HIDE_MON, $0, BG_EFFECT_USER, $0
	anim_sound 6, 2, SFX_WARP_TO
	anim_obj ANIM_OBJ_SHADOW_SNEAK, 56, 96, $4
	anim_wait 20
	anim_clearobjs
	anim_3gfx ANIM_GFX_BIG_WHIP, ANIM_GFX_TEAR, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DARK_PULSE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_DARK_PULSE
	anim_bgp $1b
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_PUNISHMENT, 136, 52, $8
	anim_obj ANIM_OBJ_PUNISHMENT, 136, 52, $28
	anim_wait 12
	anim_clearobjs
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $3, $0
	anim_obj ANIM_OBJ_DIRE_CLAW_REVERSE, 132, 48, $0
	anim_wait 12
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, BG_EFFECT_USER, $0
	anim_wait 20
	anim_ret

BattleAnim_GigaHammer_Creative:
; Metal brightens, a 48px hammer hangs overhead, then drops with real weight.
	anim_2gfx ANIM_GFX_REFLECT, ANIM_GFX_GLOW
	anim_setobjpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_METALLIC
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SMALL_GLOW, 48, 92, $0
	anim_wait 24
	anim_clearobjs
	anim_1gfx ANIM_GFX_GIGATON_HAMMER
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_METALLIC
	anim_sound 6, 2, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_GIGATON_HAMMER, 136, 56, $48
	anim_wait 26
	anim_clearobjs
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_SMOKE_PUFF
	anim_resetobp0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $3, $4
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $20, $4, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 64, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $9c
	anim_wait 12
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 120, 64, $28
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 148, 64, $38
	anim_wait 24
	anim_ret

BattleAnim_GravApple_Creative:
; An apple suspended against gravity suddenly accelerates into the target.
	anim_3gfx ANIM_GFX_CREATIVE_APPLE, ANIM_GFX_PSYCHIC, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_APPLE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_sound 0, 1, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 136, 24, $2
	anim_obj ANIM_OBJ_GLIMMER, 120, 24, $0
	anim_wait 16
	anim_clearobjs
	anim_obj ANIM_OBJ_APPLE_DROP, 136, 56, $38
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 24
	anim_clearobjs
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GRAY
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_GREEN
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $3, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $24, $4, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $9c
	anim_wait 12
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 120, 64, $28
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 148, 64, $38
	anim_wait 24
	anim_ret

BattleAnim_HeatCrash_Creative:
; A fiery ascent goes offscreen; a massive ember comet crashes back down.
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_U_TURN
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 48, 96, $0
	anim_obj ANIM_OBJ_FLAME_WHEEL, 48, 88, $20
	anim_wait 20
	anim_clearobjs
	anim_bgeffect ANIM_BG_HIDE_MON, $0, BG_EFFECT_USER, $0
	anim_sound 0, 0, SFX_JUMP_OVER_LEDGE
	anim_obj ANIM_OBJ_BLUR_VERTICAL_UP, 48, 88, $18
	anim_wait 20
	anim_clearobjs
	anim_2gfx ANIM_GFX_METEOR, ANIM_GFX_FIRE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 1, SFX_AEROBLAST
	anim_obj ANIM_OBJ_HEAT_COMET, 136, 56, $48
	anim_wait 26
	anim_clearobjs
	anim_3gfx ANIM_GFX_EXPLOSION, ANIM_GFX_FIRE, ANIM_GFX_SMOKE_PUFF
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $28, $4, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $8
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $28
	anim_wait 18
	anim_clearobjs
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 120, 64, $28
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 148, 64, $38
	anim_bgeffect ANIM_BG_SHOW_MON, $0, BG_EFFECT_USER, $0
	anim_wait 24
	anim_ret

BattleAnim_InfernalParade_Creative:
; Ghost masks lead a blue-fire procession that surrounds and consumes the foe.
	anim_3gfx ANIM_GFX_ANGELS, ANIM_GFX_FIRE, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_WILL_O_WISP
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_WILL_O_WISP
	anim_bgp $1b
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_PARADE_GHOST, 64, 76, $3
	anim_obj ANIM_OBJ_PARADE_GHOST, 48, 92, $3
	anim_wait 12
	anim_obj ANIM_OBJ_PARADE_GHOST, 64, 100, $3
	anim_wait 24
	anim_clearobjs
	anim_sound 0, 1, SFX_PERISH_SONG
.pyre
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $30
	anim_wait 18
	anim_clearobjs
	anim_loop 2, .pyre
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $4
	anim_setobjpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_CHARRED
	anim_sound 0, 1, SFX_BURN
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 136, 44, $0
	anim_obj ANIM_OBJ_GLIMMER, 120, 40, $0
	anim_obj ANIM_OBJ_GLIMMER, 148, 56, $0
	anim_wait 32
	anim_ret

BattleAnim_Infestation_Creative:
; Animated, six-legged beetles orbit, tighten in, then attack under a web.
	anim_3gfx ANIM_GFX_INFESTATION_BUG, ANIM_GFX_WEB, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_DARK_PULSE
	anim_sound 0, 1, SFX_SPITE
	anim_call BattleAnimSub_Swarm_Creative
	anim_wait 48
	anim_clearobjs
	anim_sound 0, 1, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_SPIDER_WEB, 136, 52, $0
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $0
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $10
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $20
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $30
	anim_wait 24
	anim_clearobjs
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 120, 48, $0
	anim_wait 5
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 148, 56, $0
	anim_wait 5
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 64, $0
	anim_wait 20
	anim_ret

BattleAnimSub_Swarm_Creative:
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $0
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $a
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $15
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $20
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $2a
	anim_obj ANIM_OBJ_INFESTATION_BUG, 136, 56, $35
	anim_ret

BattleAnim_QuiverDance_Creative:
; Paired luminous wings flutter through three colors around a rising spiral.
	anim_3gfx ANIM_GFX_BUG_BUZZ, ANIM_GFX_SHINE, ANIM_GFX_SWIRL_SA
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SP_ATTACK
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_SP_ATTACK
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_call BattleAnimSub_QuiverWings_Creative
	anim_wait 24
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SP_DEFENSE
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_SP_DEFENSE
	anim_sound 0, 0, SFX_SHINE
	anim_call BattleAnimSub_QuiverWings_Creative
	anim_wait 24
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SPEED
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_SPEED
	anim_sound 0, 0, SFX_TWINKLE
	anim_call BattleAnimSub_QuiverWings_Creative
	anim_wait 24
	anim_clearobjs
	anim_obj ANIM_OBJ_GLIMMER, 32, 76, $0
	anim_obj ANIM_OBJ_GLIMMER, 64, 88, $0
	anim_obj ANIM_OBJ_GLIMMER, 48, 104, $0
	anim_wait 20
	anim_ret

BattleAnimSub_QuiverWings_Creative:
	anim_obj ANIM_OBJ_BUG_BUZZ_L, 48, 88, $8
	anim_obj ANIM_OBJ_BUG_BUZZ_R, 48, 88, $28
	anim_obj ANIM_OBJ_SWIRL_SHORT_SOUR, 48, 88, $0
	anim_ret

BattleAnim_SolarBlade_Creative:
	anim_if_param_equal $0, .strike
; Sunlight condenses through rings into a huge green blade.
	anim_3gfx ANIM_GFX_CHARGE, ANIM_GFX_CUT, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_sound 0, 0, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_SOLAR_BEAM_CHARGE, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $10
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $20
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $30
	anim_wait 32
	anim_clearobjs
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_CUT_LONG_UP_LEFT, 48, 88, $0
	anim_obj ANIM_OBJ_GLIMMER, 48, 72, $0
	anim_wait 28
	anim_ret
.strike
; A gold flash reveals one colossal crossing green cleave and leaf aftershock.
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_LEAF_STORM_SA, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_GLOW_LIME
	anim_sound 0, 0, SFX_MORNING_SUN
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 152, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 120, 40, $0
	anim_wait 12
	anim_clearobjs
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $3, $0
	anim_obj ANIM_OBJ_CUT_LONG_UP_LEFT, 136, 56, $0
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 136, 56, $8
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 136, 56, $18
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 136, 56, $28
	anim_obj ANIM_OBJ_LEAF_STORM_SMALL_LEAF, 136, 56, $38
	anim_wait 16
	anim_clearobjs
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 24
	anim_ret

BattleAnim_TailGlow_Creative:
; A tail light grows into a golden halo and releases a ring of sparks.
; The real battle's following stat message supplies exactly three
; Special Attack rises via wLoweredStat=$23. Do not duplicate those here.
	anim_3gfx ANIM_GFX_GLOW, ANIM_GFX_CHARGE, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_sound 0, 0, SFX_GAME_FREAK_LOGO_GS
	anim_obj ANIM_OBJ_SMALL_GLOW, 40, 100, $0
	anim_wait 24
	anim_clearobjs
	anim_obj ANIM_OBJ_SLOW_GROWING_GLOW, 40, 100, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 32, 104, $0
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 56, 104, $0
	anim_wait 32
	anim_clearobjs
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $3, $2
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 48, 88, $0
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 48, 88, $10
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 48, 88, $20
	anim_obj ANIM_OBJ_FLASH_CANNON_SPARKS_RED, 48, 88, $30
	anim_wait 20
	anim_clearobjs
	anim_obj ANIM_OBJ_GLIMMER, 32, 76, $0
	anim_obj ANIM_OBJ_GLIMMER, 64, 88, $0
	anim_wait 20
	anim_ret

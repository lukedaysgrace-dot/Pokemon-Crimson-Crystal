; Creative move showcase.
; Every animation loads all of its graphics up front, so no phase swaps tile
; data while old sprites are still on screen. Objects are allowed to finish
; their own motion instead of being cut off, there is at most one short
; flash per move, and recolored battlers are restored before the move ends.
; Helpers are bank-local: anim_call cannot reach other animation banks.

BattleAnim_ArmorCannon_Creative:
; Fire gathers in the user's armor, a molten shell is fired, and the impact
; sprays glowing metal shards and flame.
	anim_5gfx ANIM_GFX_CHARGE, ANIM_GFX_GLOW, ANIM_GFX_EXPLOSION, ANIM_GFX_ROCKS, ANIM_GFX_FIRE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_HEAT_WAVE
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_BLAST
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_LAVA_ROCKS
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_METALLIC
	anim_sound 0, 0, SFX_CHARGE
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $10
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $30
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $8
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $28
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $18
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $38
	anim_wait 12
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 56, 84, $0
	anim_wait 8
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_DEFAULT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $8, $1, $0
	anim_sound 6, 2, SFX_AEROBLAST
	anim_obj ANIM_OBJ_FLASH_CANNON, 64, 84, $4
	anim_wait 20
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $3, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 52, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $9c
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 52, $24
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 52, $3c
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 52, $2c
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 52, $34
	anim_wait 28
	anim_ret

BattleAnim_AppleAcid_Creative:
; A sour apple is lobbed at the foe and bursts into lime acid that splashes
; out, eats at the target in two corrosive pulses and drips off.
	anim_2gfx ANIM_GFX_CREATIVE_APPLE, ANIM_GFX_POISON
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_APPLE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ACID_APPLE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_APPLE_SHOT, 56, 92, $4
	anim_wait 36
	anim_sound 0, 1, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $d0
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $50
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $90
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 52, $1c
	anim_wait 6
	anim_sound 0, 1, SFX_TOXIC
	anim_setbgpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_ACID_APPLE
	anim_wait 8
	anim_setbgpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_DEFAULT
	anim_obj ANIM_OBJ_POISON_DROPLET, 124, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TOXIC
	anim_setbgpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_ACID_APPLE
	anim_obj ANIM_OBJ_POISON_DROPLET, 148, 40, $0
	anim_wait 8
	anim_setbgpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_DEFAULT
	anim_obj ANIM_OBJ_POISON_DROPLET, 136, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 116, 52, $0
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 152, 56, $0
	anim_wait 20
	anim_ret

BattleAnim_FieryDance_Creative:
; The user twirls inside a rising spiral of flame, unrolls it into a
; wavering fire ribbon and wraps the foe in a spinning blaze.
	anim_1gfx ANIM_GFX_FIRE
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $0
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $20
	anim_wait 8
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $10
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $30
	anim_wait 8
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $8
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $28
	anim_wait 36
.ribbon
	anim_obj ANIM_OBJ_DRAGON_RAGE, 64, 88, $0
	anim_wait 4
	anim_loop 5, .ribbon
	anim_wait 16
	anim_sound 0, 1, SFX_BURN
.wrap
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 90, $88
	anim_wait 2
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 72, $98
	anim_wait 2
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 54, $a0
	anim_wait 6
	anim_loop 2, .wrap
	anim_wait 24
	anim_ret

BattleAnim_FoulPlay_Creative:
; The user melts into a shadow that slips under the foe, rakes it twice from
; behind with its own strength, then rises back out of the dark.
	anim_4gfx ANIM_GFX_SHADOW_SNEAK_SA, ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_STARS
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_DARK_PULSE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PAYBACK
	anim_sound 0, 0, SFX_CURSE
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK, $0, BG_EFFECT_USER, $40
	anim_wait 16
	anim_bgeffect ANIM_BG_HIDE_MON, $0, BG_EFFECT_USER, $0
	anim_wait 2
	anim_incbgeffect ANIM_BG_FADE_MON_TO_BLACK
	anim_sound 6, 2, SFX_WARP_TO
	anim_obj ANIM_OBJ_SHADOW_SNEAK, 56, 96, $4
	anim_wait 18
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING, $0, BG_EFFECT_TARGET, $20
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 148, 48, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 142, 42, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 136, 36, $0
	anim_wait 12
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 120, 36, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 140, 52, $0
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $28
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $5c
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $10
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $e8
	anim_wait 18
	anim_incbgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING
	anim_bgeffect ANIM_BG_FADE_MON_FROM_BLACK, $0, BG_EFFECT_USER, $30
	anim_wait 1
	anim_sound 0, 0, SFX_WARP_FROM
	anim_bgeffect ANIM_BG_SHOW_MON, $0, BG_EFFECT_USER, $0
	anim_wait 16
	anim_ret

BattleAnim_GigaHammer_Creative:
; The user's body takes on a steel sheen, a giant mallet sinks into view over
; the foe, winds up and slams down; dust and shards spray from the impact.
	anim_4gfx ANIM_GFX_REFLECT, ANIM_GFX_GIGATON_HAMMER, ANIM_GFX_ROCKS, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_METALLIC
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_METALLIC
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_HARDEN, 58, 84, $0
	anim_wait 12
	anim_sound 0, 1, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_GIGATON_HAMMER, 136, 56, $20
	anim_wait 16
	anim_setbgpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_DEFAULT
	anim_wait 12
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $2, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $28, $4, $0
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 64, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 64, $38
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $e8
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $9c
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 120, 60, $2c
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 152, 60, $34
	anim_wait 30
	anim_ret

BattleAnim_GravApple_Creative:
; Gravity bears down on the foe and pulls a huge apple out of the sky; it
; hangs for a beat, then plummets and craters the ground.
	anim_4gfx ANIM_GFX_CREATIVE_APPLE, ANIM_GFX_BIG_RINGS, ANIM_GFX_ROCKS, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_APPLE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PAYBACK
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GRAY
	anim_sound 0, 1, SFX_GRAVITY
	anim_obj ANIM_OBJ_SHRINKING_RING_BIG, 136, 44, $0
	anim_wait 8
	anim_obj ANIM_OBJ_APPLE_DROP, 136, 56, $1c
	anim_wait 10
	anim_obj ANIM_OBJ_SHRINKING_RING_BIG, 136, 48, $0
	anim_wait 18
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 7
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $28, $4, $0
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 64, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 64, $38
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $e8
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 64, $9c
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 120, 60, $2c
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 152, 60, $34
	anim_wait 30
	anim_ret

BattleAnim_HeatCrash_Creative:
; Flames spiral up around the user and it launches out of sight, then it
; crashes back down onto the foe as a blazing comet: a fiery blast and smoke.
	anim_4gfx ANIM_GFX_FIRE, ANIM_GFX_METEOR, ANIM_GFX_EXPLOSION, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_FIRE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_LAVA_SMOKE
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $0
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $20
	anim_wait 6
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $10
	anim_obj ANIM_OBJ_FLAME_TWIRL, 48, 100, $30
	anim_wait 18
	anim_sound 0, 0, SFX_FLY
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 40, 96, $30
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 56, 96, $30
	anim_wait 2
	anim_bgeffect ANIM_BG_HIDE_MON, $0, BG_EFFECT_USER, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 48, 88, $30
	anim_wait 18
	anim_sound 0, 1, SFX_AEROBLAST
	anim_obj ANIM_OBJ_HEAT_COMET, 136, 56, $a8
	anim_wait 12
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_BLAST
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $2, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $28, $4, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $24
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $3c
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $2c
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $34
	anim_wait 10
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 124, 56, $30
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 148, 52, $30
	anim_wait 8
	anim_obj ANIM_OBJ_TARGET_BURNOUT, 136, 48, $30
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, BG_EFFECT_USER, $0
	anim_wait 24
	anim_ret

BattleAnim_InfernalParade_Creative:
; A ghost leads a procession of violet will-o'-wisps across the field; they
; circle the foe and flare up as it is scorched by spectral fire.
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_ANGELS
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_WILL_O_WISP
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_PARADE_GHOST, 64, 84, $2
	anim_wait 6
.march
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_DRAGON_RAGE, 64, 88, $0
	anim_wait 6
	anim_loop 5, .march
	anim_wait 16
	anim_sound 0, 1, SFX_SPITE
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING, $0, BG_EFFECT_TARGET, $20
.encircle
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 90, $88
	anim_wait 2
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 72, $98
	anim_wait 2
	anim_obj ANIM_OBJ_FIRE_SPIN, 112, 54, $a0
	anim_wait 6
	anim_loop 2, .encircle
	anim_sound 0, 1, SFX_BURN
	anim_wait 20
	anim_incbgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING
	anim_wait 16
	anim_ret

BattleAnim_Infestation_Creative:
; A swarm of beetles fans out around the foe, circles and closes in; a web
; drops over them as they bite.
	anim_3gfx ANIM_GFX_INFESTATION_BUG, ANIM_GFX_WEB, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_DARK_PULSE
	anim_sound 0, 1, SFX_SPITE
	anim_call BattleAnimSub_Swarm_Creative
	anim_wait 20
	anim_sound 0, 1, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_SPIDER_WEB, 136, 52, $0
	anim_wait 12
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 124, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 148, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 132, 60, $0
	anim_wait 6
	anim_obj ANIM_OBJ_HIT_SMALL_YFIX, 140, 44, $0
	anim_wait 28
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
; Luminous wings beat around the user while pink, gold and blue
; scales drift up together for the three stats it raises.
	anim_3gfx ANIM_GFX_BUG_BUZZ, ANIM_GFX_SHINE, ANIM_GFX_SPEED
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_SP_ATTACK
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SP_DEFENSE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_SPEED
	anim_sound 0, 0, SFX_SWEET_SCENT
.flutter
	anim_obj ANIM_OBJ_BUG_BUZZ_L, 48, 88, $28
	anim_obj ANIM_OBJ_BUG_BUZZ_R, 48, 88, $38
	anim_wait 4
	anim_obj ANIM_OBJ_RISING_SPARKLE, 36, 104, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 60, 80, $0
	anim_wait 4
	anim_obj ANIM_OBJ_RISING_SPARKLE, 60, 104, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 36, 76, $0
	anim_sound 0, 0, SFX_TWINKLE
	anim_wait 8
	anim_loop 3, .flutter
	anim_wait 24
	anim_ret

BattleAnim_SolarBlade_Creative:
	anim_if_param_equal $0, .strike
; Rays of sunlight stream into the user, which brightens with stored light.
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_sound 0, 0, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $0
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $10
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $30
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $8
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $28
	anim_wait 4
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $18
	anim_obj ANIM_OBJ_ENERGY_ORB, 48, 88, $38
	anim_wait 12
	anim_bgeffect ANIM_BG_FADE_MON_GLOW, $0, BG_EFFECT_USER, $30
	anim_wait 8
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 44, 76, $0
	anim_wait 30
	anim_ret

.strike
; A blade of light cuts across the foe twice in a burst of sunlit sparks.
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_STARS
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GLOW_LIME
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_FADE_MON_GLOW, $0, BG_EFFECT_USER, $10
	anim_wait 10
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 152, 40, $0
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 120, 40, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $5c
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $e8
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $28
	anim_obj ANIM_OBJ_STAR_BURST, 136, 52, $9c
	anim_wait 28
	anim_ret

BattleAnim_TailGlow_Creative:
; The user's tail kindles like a firefly: the glow swells, the body
; brightens once and sparks drift upward.
; The real battle's following stat message supplies exactly three
; Special Attack rises via wLoweredStat=$23. Do not duplicate those here.
	anim_3gfx ANIM_GFX_GLOW, ANIM_GFX_CHARGE, ANIM_GFX_SHINE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_sound 0, 0, SFX_GAME_FREAK_LOGO_GS
	anim_obj ANIM_OBJ_SLOW_GROWING_GLOW, 40, 100, $0
	anim_wait 16
.fireflies
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 32, 104, $0
	anim_wait 6
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 52, 100, $0
	anim_wait 6
	anim_obj ANIM_OBJ_TINY_RISING_ORB, 40, 96, $0
	anim_wait 6
	anim_loop 3, .fireflies
	anim_bgeffect ANIM_BG_FADE_MON_GLOW, $0, BG_EFFECT_USER, $40
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 36, 84, $0
	anim_wait 6
	anim_obj ANIM_OBJ_GLIMMER, 56, 92, $0
	anim_wait 40
	anim_ret

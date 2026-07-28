; Battle animation scripts ported from Johto Legends.
; ANIM_OBJ_/ANIM_GFX_/SFX_ constants absent from Crimson Crystal were
; substituted with the nearest Crimson equivalent.

BattleAnim_RockTomb:
	anim_1gfx ANIM_GFX_ROCKS
	anim_bgeffect ANIM_BG_1F, $60, $1, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 128, 64, $40
	anim_wait 2
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 120, 68, $30
	anim_wait 2
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 152, 68, $30
	anim_wait 2
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 144, 64, $40
	anim_wait 2
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 136, 68, $30
	anim_jump BattleAnim_Wait96

BattleAnim_Wait96:
	anim_wait 96
	anim_ret

BattleAnim_Featherdance:
	anim_1gfx ANIM_GFX_MISC
	anim_sound 0, 0, SFX_MORNING_SUN
.loop
	anim_obj ANIM_OBJ_PETAL_DANCE, 132, 36, $0
	anim_wait 16
	anim_loop 5, .loop
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING, $0, $0, $40
	anim_wait 96
	anim_incbgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING
	anim_jump BattleAnim_ShowMon_1

;BattleAnim_FakeTears:
;	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_WATER
;	anim_1gfx ANIM_GFX_MISC_2
;	anim_call BattleAnim_TargetObj_1Row
;	anim_bgeffect ANIM_BG_26, $0, $1, $0
;.loop
;	anim_sound 0, 0, SFX_ATTRACT
;	anim_obj ANIM_OBJ_TEARS_2, 44, 82, $24
;	anim_wait 8
;	anim_sound 0, 0, SFX_ATTRACT
;	anim_obj ANIM_OBJ_TEARS_1, 64, 82, $3b
;	anim_wait 8
;	anim_loop 6, .loop
;	anim_incbgeffect ANIM_BG_26
;	anim_call BattleAnim_ShowMon_0
;	anim_wait 12
;	anim_ret

BattleAnim_MirrorShot:

BattleAnim_AgilityLoop:
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 48, $2
	anim_obj ANIM_OBJ_AGILITY, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 32, $6
	anim_obj ANIM_OBJ_AGILITY, 8, 56, $c
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
	anim_obj ANIM_OBJ_AGILITY, 8, 104, $e
.loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_wait 4
	anim_loop 18, .loop
	anim_ret

BattleAnim_SilverWind:
    anim_2gfx ANIM_GFX_WIND_BG, ANIM_GFX_HIT
    anim_obp0 $fc
    anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_call BattleAnim_AgilityLoop
	anim_incbgeffect ANIM_BG_18
	anim_wait 4
    anim_sound 0, 1, SFX_COMET_PUNCH
    anim_obj ANIM_OBJ_00, 136, 48, $0
    anim_wait 8
    anim_sound 0, 1, SFX_COMET_PUNCH
    anim_obj ANIM_OBJ_00, 136, 48, $0
    anim_wait 8
    anim_sound 0, 1, SFX_COMET_PUNCH
    anim_obj ANIM_OBJ_00, 136, 48, $0
    anim_wait 32
    anim_jump BattleAnim_ShowMon_0

BattleAnim_DragonRush:

BattleAnim_DrillRun:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_jump BattleAnim_HornDrillBranch

BattleAnim_HornDrillBranch:
	anim_obj ANIM_OBJ_HORN, 72, 80, $3
	anim_wait 8
.loop
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_00, 132, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_00, 140, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_00, 132, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_00, 124, 48, $0
	anim_wait 8
	anim_loop 3, .loop
	anim_ret

BattleAnim_Wait32:
	anim_wait 32
	anim_ret

BattleAnim_MetalSound:
	anim_1gfx ANIM_GFX_PSYCHIC
.loop
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_obj ANIM_OBJ_WAVE, 56, 80, $2
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 56
	anim_ret

BattleAnim_DisarmVoice:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PEACH

BattleAnim_DazzlinGleam:
	anim_1gfx ANIM_GFX_SPEED
	anim_sound 0, 1, SFX_FLASH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $20
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $8
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $10
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $18
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $20
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $28
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $30
	anim_wait 4
	anim_obj ANIM_OBJ_FLASH, 136, 56, $38
	anim_jump BattleAnim_Wait32

BattleAnim_SignalBeam:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_YELLOW
	anim_1gfx ANIM_GFX_EGG
.Loop
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_SHADOW_BALL, 64, 92, $2
	anim_wait 1
	anim_loop 19, .Loop
	anim_wait 24
	anim_ret

BattleAnim_MagicalLeaf:
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_RED

BattleAnim_MudBomb:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BROWN

BattleAnim_Revenge:
    anim_1gfx ANIM_GFX_WIND
.loop
    anim_sound 0, 0, SFX_ENCORE
    anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
    anim_wait 64
    anim_loop 2, .loop
    anim_wait 16
	anim_jump BattleAnim_Waterfall

BattleAnim_RockWrecker:
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_call BattleAnim_Strength
	anim_jump BattleAnim_DoubleEdge

BattleAnim_Wait16:
	anim_wait 16
	anim_ret

BattleAnim_FlameBurst:
	anim_1gfx ANIM_GFX_FIRE
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 64, 96, $12
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 64, 100, $14
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 64, 84, $13
	anim_wait 16
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 120, 68, $30
	anim_obj ANIM_OBJ_EMBER, 132, 68, $30
	anim_obj ANIM_OBJ_EMBER, 144, 68, $30
	anim_jump BattleAnim_Wait32

BattleAnim_Discharge:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_31, 136, 56, $0
	anim_wait 64
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_jump BattleAnim_Wait64

BattleAnim_Wait64:
	anim_wait 64
	anim_ret

BattleAnim_IronDefense:

BattleAnim_BulletSeed:
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_HIT
.Loop
	anim_obj ANIM_OBJ_SEED_BOMB, 64, 70, $10
	anim_wait 8
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_04, 128, 40, $0
	anim_wait 1
	anim_loop 10, .Loop
;	anim_obj ANIM_OBJ_SEED_BOMB, 64, 70, $10
;	anim_wait 8
;	anim_sound 0, 1, SFX_VINE_WHIP
;	anim_obj ANIM_OBJ_04, 136, 56, $0
;	anim_wait 8
;	anim_obj ANIM_OBJ_SEED_BOMB, 64, 70, $10
;	anim_wait 8
;	anim_sound 0, 1, SFX_VINE_WHIP
;	anim_obj ANIM_OBJ_04, 132, 48, $0
	anim_jump BattleAnim_Wait8

BattleAnim_Wait8:
	anim_wait 8
	anim_ret

BattleAnim_PetalBlizz:
    anim_1gfx ANIM_GFX_FLOWER
    anim_sound 0, 0, SFX_SWORDS_DANCE
    anim_obj ANIM_OBJ_FLOWER, 48, 108, $0
    anim_obj ANIM_OBJ_FLOWER, 48, 108, $d
    anim_obj ANIM_OBJ_FLOWER, 48, 108, $1a
    anim_incbgeffect ANIM_BG_BOUNCE_DOWN
    anim_obj ANIM_OBJ_FLOWER, 48, 108, $27
    anim_obj ANIM_OBJ_FLOWER, 48, 108, $34
    anim_wait 56
    anim_ret

BattleAnim_Inferno:
	anim_1gfx ANIM_GFX_FIRE
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0

BattleAnim_WoodHammer:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_call BattleAnim_KnockOff
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $d0
	anim_jump BattleAnim_Wait32

BattleAnim_Payback:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 112, 64, $0
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_FORESIGHT, 120, 56, $0
	anim_wait 2
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 128, 56, $0
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_FORESIGHT, 136, 48, $0
	anim_wait 2
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 144, 48, $0
	anim_wait 2
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_FORESIGHT, 152, 40, $0
	anim_wait 24
	anim_ret

BattleAnim_RoarBranch:
	anim_1gfx ANIM_GFX_NOISE
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_cry $1
.loop
	anim_call BattleAnim_Roar_branch_cbbbc
	anim_wait 16
	anim_loop 3, .loop
	anim_wait 16
	anim_if_param_equal $0, .done
	anim_bgeffect ANIM_BG_27, $0, $0, $0
	anim_wait 64
.done
	anim_ret

BattleAnim_Snarl:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_jump BattleAnim_RoarBranch

BattleAnim_RoundM:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_AURORA

BattleAnim_HiHorsepower:

BattleAnim_MudShot:
	anim_1gfx ANIM_GFX_SAND
	anim_obp0 $fc
	anim_jump BattleAnim_MudSlap_branch_cbc5b

BattleAnim_SandTomb:
	anim_1gfx ANIM_GFX_POWDER
	anim_obj ANIM_OBJ_SANDSTORM, 88, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM, 72, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM, 56, 0, $2
.loop
	anim_sound 0, 1, SFX_MENU
	anim_wait 8
	anim_loop 16, .loop
	anim_jump BattleAnim_Wait8

BattleAnim_LowSweep:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 124, 64, $0
	anim_obj ANIM_OBJ_00, 124, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 132, 64, $0
	anim_obj ANIM_OBJ_00, 132, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 140, 64, $0
	anim_obj ANIM_OBJ_00, 140, 64, $0
	anim_jump BattleAnim_Wait16

BattleAnim_CrossPoison:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_POISON
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_A0, 152, 40, $0
	anim_obj ANIM_OBJ_A1, 120, 72, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_1F, $58, $2, $0
	anim_wait 92
	anim_sound 0, 1, SFX_VICEGRIP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_wait 16
	anim_call BattleAnim_Sludge_branch_cbc15
	anim_wait 56
	anim_ret

BattleAnim_SmartStrike:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_Harden_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_jump BattleAnim_Megahorn
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_IronTail_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_HORN, 72, 80, $1
	anim_wait 16
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_jump BattleAnim_Wait16

BattleAnim_Belch:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_jump BattleAnim_Smog2

BattleAnim_Smog2:
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 16, 2, SFX_BUBBLEBEAM
.loop
	anim_obj ANIM_OBJ_POISON_GAS, 44, 80, $2
	anim_wait 8
	anim_loop 10, .loop
	anim_wait 128
	anim_ret

BattleAnim_Nuzzle:

BattleAnim_CrushClaw:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_SCRATCH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_jump BattleAnim_Wait32

BattleAnim_AirCutter:
	anim_2gfx ANIM_GFX_WHIP, ANIM_GFX_CUT
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_40, 116, 52, $80
	anim_wait 4
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_3F, 128, 60, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 4
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 8
	anim_jump BattleAnim_ShowMon_0

BattleAnim_OdorSleuth:
	anim_1gfx ANIM_GFX_SHINE
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 1, SFX_FORESIGHT
	anim_obj ANIM_OBJ_FORESIGHT, 132, 40, $0
	anim_wait 24
	anim_bgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING, $0, $0, $40
	anim_wait 64
	anim_incbgeffect ANIM_BG_FADE_MON_TO_BLACK_REPEATING
	anim_call BattleAnim_ShowMon_1
	anim_jump BattleAnim_Wait8

BattleAnim_Howl:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED

BattleAnim_PsychoCut:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_jump BattleAnim_Wait32

BattleAnim_DualChop:

BattleAnim_RockPolish:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_Harden_branch_cbc43
	anim_jump BattleAnim_ShowMon_0

BattleAnim_DoubleHitM:

BattleAnim_BlazeKick:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_call BattleAnim_FirePunch_branch_cbbcc
	anim_jump BattleAnim_Wait16

BattleAnim_SheerCold:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_1gfx ANIM_GFX_ICE
.loop
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 64, 88, $63
	anim_wait 2
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 64, 80, $64
	anim_wait 2
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 64, 96, $63
	anim_wait 2
	anim_loop 3, .loop
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_wait 32
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 74, $10
	anim_wait 128
	anim_sound 0, 1, SFX_SHINE
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_wait 24
	anim_ret

BattleAnim_EchoedVoice:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW

BattleAnim_MuddyWater:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_BROWN

BattleAnim_HeatWave:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_FIRE
	anim_bgp $90
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 0, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_RADIAL_FLAME, 88, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_RADIAL_FLAME, 56, 16, $1
	anim_wait 8
	anim_obj ANIM_OBJ_RADIAL_FLAME, 72, 32, $1
	anim_wait 8
	anim_obj ANIM_OBJ_RADIAL_FLAME, 24, 48, $1
	anim_wait 8
	anim_obj ANIM_OBJ_RADIAL_FLAME, 40, 64, $1
	anim_loop 3, .loop
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_ret

BattleAnim_LavaPlume:
	anim_1gfx ANIM_GFX_FIRE
	anim_battlergfx_2row
	anim_sound 6, 2, SFX_EMBER
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
.loop
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $38
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $10
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $36
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $4
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $18
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $28
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $40
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $32
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $20
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $30
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $0
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $24
	anim_wait 1
	anim_obj ANIM_OBJ_FLAMETHROWER, 48, 96, $8
	anim_wait 1
	anim_loop 2, .loop
	anim_wait 32
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $1
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $4
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $5
.loop2
	anim_sound 0, 0, SFX_BURN
	anim_wait 4
	anim_loop 3, .loop2
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_NeedleArm:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_obj ANIM_OBJ_HORN, 72, 72, $2
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_04, 128, 40, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HORN, 80, 88, $2
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_04, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HORN, 76, 80, $2
	anim_wait 8
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_04, 132, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_06, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_GrassWhistle:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_jump BattleAnim_SingBranch

BattleAnim_SingBranch:
	anim_1gfx ANIM_GFX_NOISE
	anim_sound 16, 2, SFX_SING
.loop
	anim_obj ANIM_OBJ_SING, 64, 92, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SING, 64, 92, $1
	anim_wait 8
	anim_obj ANIM_OBJ_SING, 64, 92, $2
	anim_wait 8
	anim_obj ANIM_OBJ_SING, 64, 92, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SING, 64, 92, $2
	anim_wait 8
	anim_loop 4, .loop
	anim_jump BattleAnim_Wait64

BattleAnim_OminousWind:
    anim_2gfx ANIM_GFX_WIND_BG, ANIM_GFX_ANGELS
    anim_obp0 $fc
    anim_call BattleAnim_TargetObj_1Row
	anim_bgp $1b
	anim_obp0 $f
	anim_call BattleAnim_AgilityLoop
    anim_wait 4
    anim_call BattleAnim_ShowMon_0
	anim_obj ANIM_OBJ_NIGHTMARE, 132, 40, $0
	anim_obj ANIM_OBJ_NIGHTMARE, 132, 40, $a0
	anim_sound 0, 1, SFX_NIGHTMARE
	anim_jump BattleAnim_Wait96

BattleAnim_FrenzyPlant:
	anim_2gfx ANIM_GFX_WHIP, ANIM_GFX_PLANT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 124, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 124, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_RAZOR_LEAF, 132, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 132, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_RAZOR_LEAF, 140, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 140, 64, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $d0
	anim_wait 32
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $dc
	anim_jump BattleAnim_Wait32

BattleAnim_BlastBurn:
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION
.loop1
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 64, 92, $7
	anim_wait 6
	anim_loop 10, .loop1
.loop2
	anim_sound 0, 1, SFX_EMBER
	anim_wait 8
	anim_loop 10, .loop2
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_incobj 7
	anim_incobj 8
	anim_incobj 9
	anim_incobj 10
	anim_wait 2
	anim_bgeffect ANIM_BG_1F, $60, $4, $10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $24
	anim_if_param_equal $1, .loop3
	anim_call BattleAnim_Explosion_branch_cbb8f
	anim_jump BattleAnim_Wait16

.loop3
	anim_call BattleAnim_Explosion_branch_cbb62
	anim_wait 5
	anim_loop 2, .loop3
	anim_jump BattleAnim_Wait16

BattleAnim_HydroCannon:
	anim_bgeffect ANIM_BG_30, $0, $0, $0
	anim_1gfx ANIM_GFX_WATER
	anim_bgp $1b
	anim_obp0 $27
	anim_jump BattleAnim_HydroPumpJump

BattleAnim_HydroPumpJump:
	anim_call BattleAnim_UserObj_2Row
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 108, 72, $0
	anim_bgeffect ANIM_BG_31, $1c, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 116, 72, $0
	anim_bgeffect ANIM_BG_31, $8, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 124, 72, $0
	anim_bgeffect ANIM_BG_31, $30, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 132, 72, $0
	anim_bgeffect ANIM_BG_31, $1c, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 140, 72, $0
	anim_bgeffect ANIM_BG_31, $8, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 148, 72, $0
	anim_bgeffect ANIM_BG_31, $30, $0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_HYDRO_PUMP, 156, 72, $0
	anim_bgeffect ANIM_BG_31, $1c, $0, $0
	anim_wait 32
	anim_call BattleAnim_ShowMon_1
	anim_bgeffect ANIM_BG_32, $0, $0, $0
	anim_jump BattleAnim_Wait16

BattleAnim_WaveCrash:
	anim_2gfx ANIM_GFX_BUBBLE, ANIM_GFX_HIT
	anim_call BattleAnim_Surf
	anim_jump BattleAnim_DoubleEdge

BattleAnim_FakeOut:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_99, 136, 46, $e0
	anim_obj ANIM_OBJ_99, 136, 46, $20
	anim_wait 16
	anim_sound 0, 0, SFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAGE
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_jump BattleAnim_Wait32

BattleAnim_HeadlongRush:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BROWN

BattleAnim_DualWingbeat:
	anim_1gfx ANIM_GFX_HIT
	anim_jump BattleAnim_WingGFX

BattleAnim_WingGFX:
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_01, 148, 56, $0
	anim_obj ANIM_OBJ_01, 116, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_01, 144, 56, $0
	anim_obj ANIM_OBJ_01, 120, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_01, 140, 56, $0
	anim_obj ANIM_OBJ_01, 124, 56, $0
	anim_jump BattleAnim_Wait16

BattleAnim_PsybeamLoop:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_08, $0, $4, $0
.loop
	anim_sound 6, 2, SFX_PSYBEAM
	anim_obj ANIM_OBJ_WAVE, 64, 88, $4
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 48
	anim_ret

BattleAnim_TwinBeam:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BLUE
	anim_jump BattleAnim_PsybeamLoop

BattleAnim_Psyshield:
	anim_call BattleAnim_LightScreen
	anim_wait 32
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 136, 48, $0
	anim_wait 8
	anim_jump BattleAnim_ShowMon_0

BattleAnim_MeteorMash:
	anim_2gfx ANIM_GFX_OBJECTS, ANIM_GFX_HIT
	anim_call BattleAnim_Swift
	anim_jump BattleAnim_MegaPunch

BattleAnim_ForcePalm:

BattleAnim_SkyUppercut:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW
	anim_jump BattleAnim_Waterfall2

BattleAnim_Waterfall2:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 16
	anim_call BattleAnim_ShowMon_0
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 3
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 3
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_01, 136, 40, $0
	anim_wait 3
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_01, 136, 32, $0
	anim_wait 3
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_01, 136, 24, $0
	anim_jump BattleAnim_Wait8

BattleAnim_HeadSmash:

BattleAnim_RagingFury:

BattleAnim_StrangeSteam:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED
	anim_jump BattleAnim_Smog2

BattleAnim_ShadowBone:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_MISC
	anim_bgp $1b
	anim_obp0 $27

BattleAnim_PoisonTail:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TailAttack
	anim_wait 16
	anim_1gfx ANIM_GFX_POISON
	anim_jump BattleAnim_Sludge_branch_cbc15

BattleAnim_TailAttack:
    anim_sound 0, 1, SFX_VICEGRIP
    anim_obj ANIM_OBJ_04, 120, 32, $0
    anim_wait 8
    anim_sound 0, 1, SFX_VICEGRIP
    anim_obj ANIM_OBJ_04, 152, 40, $0
    anim_wait 8
    anim_sound 0, 1, SFX_VICEGRIP
    anim_obj ANIM_OBJ_04, 136, 48, $0
	anim_ret

BattleAnim_FreezeGlare:
	anim_2gfx ANIM_GFX_BEAM, ANIM_GFX_ICE
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PURPLE
	anim_call BattleAnim_Glare_branch_cbadc
	anim_wait 32
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_jump BattleAnim_IcePunch_branch_cbbdf

BattleAnim_FieryWrath:
	anim_1gfx ANIM_GFX_FIRE
	anim_bgp $1b
	anim_obp0 $27
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_DRAGONBREATH
	anim_jump BattleAnim_SacredFireLoop

BattleAnim_SacredFireLoop:
.loop
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_SACRED_FIRE, 48, 104, $0
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 96
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $1
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $4
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 48, $5
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_incobj 9
	anim_jump BattleAnim_Wait8

BattleAnim_ShellSideArm:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SLUDGE, 64, 92, $4
	anim_wait 16
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_jump BattleAnim_Toxic_branch_cbc15

BattleAnim_MeteoAssault:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_YELLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW

BattleAnim_CosmicPower:
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_MOON
	anim_bgp $1b
	anim_bgeffect ANIM_BG_20, $10, $1, $20
    anim_sound 6, 2, SFX_SWEET_KISS
    anim_obj ANIM_OBJ_MOON_GLOBE, 45, 104, $1
    anim_wait 128
	anim_clearobjs
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PURPLE
	anim_jump BattleAnim_Growth_Branch

BattleAnim_Growth_Branch:
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $0
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $8
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $10
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $18
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $20
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $28
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $30
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $38
	anim_jump BattleAnim_Wait64

BattleAnim_StrengthSap:
	anim_2gfx ANIM_GFX_BUBBLE, ANIM_GFX_SHINE
	anim_sound 6, 3, SFX_WATER_GUN
	anim_call BattleAnim_GigaDrain_branch_cbab3
	anim_wait 128
	anim_wait 48
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_if_param_equal $1, .one
	anim_jump BattleAnim_MorningSun_branch_cbc6a

.one
	anim_jump BattleAnim_MorningSun_branch_cbc80

BattleAnim_HammerArm:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_wait 48
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
.loop
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_06, 136, 56, $0
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_06, 136, 56, $0
	anim_wait 6
	anim_loop 3, .loop
	anim_ret

BattleAnim_EndureLoop:
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_bgeffect ANIM_BG_07, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_47, 44, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_47, 36, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_47, 52, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_47, 28, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_47, 60, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_47, 20, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_47, 68, 108, $8
	anim_wait 2
	anim_loop 5, .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_1A
	anim_ret

BattleAnim_Superpower:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_EndureLoop
	anim_1gfx ANIM_GFX_HIT
	anim_jump BattleAnim_DoubleEdge

BattleAnim_PowerUpPunch:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_CometPunch_branch_c9641
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_06, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_jump BattleAnim_Wait8

BattleAnim_BrickBreak:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_06, 136, 24, $30
	anim_obj ANIM_OBJ_00, 136, 24, $30
	anim_wait 16
	anim_bgeffect ANIM_BG_1F, $55, $2, $0
	anim_wait 64
	anim_clearobjs
	anim_obj ANIM_OBJ_06, 136, 82, $30
	anim_obj ANIM_OBJ_00, 136, 82, $30
	anim_wait 8
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 34
	anim_ret

BattleAnim_QuiverDance:
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_SHINE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_FORESIGHT
	anim_obj ANIM_OBJ_DRAGON_DANCE, 48, 104, $0
	anim_wait 12
	anim_loop 8, .loop
	anim_wait 16
	anim_incbgeffect ANIM_BG_2C
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_sound 0, 1, SFX_FLASH
	anim_obj ANIM_OBJ_GLIMMER, 44, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 24, 96, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_18
	anim_jump BattleAnim_ShowMon_0

BattleAnim_AcidSpray:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_POISON
	anim_call BattleAnim_Acid_branch_cbc35
	anim_jump BattleAnim_Wait64

BattleAnim_PlayNice:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_sound 0, 0, SFX_TAIL_WHIP
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_26
	anim_jump BattleAnim_ShowMon_0

BattleAnim_CircleThrow:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_2F, $0, $1, $0
	anim_wait 16
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_04, 64, 96, $0
	anim_wait 8
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_04, 56, 88, $0
	anim_wait 8
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_04, 68, 104, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_2F
	anim_wait 16
	anim_call BattleAnim_ShowMon_0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_03, 132, 56, $0
	anim_jump BattleAnim_Wait16

BattleAnim_Bounce:

BattleAnim_ChargeBeam:
    anim_3gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION, ANIM_GFX_BEAM
    anim_sound 0, 0, SFX_ZAP_CANNON
    anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
    anim_obj ANIM_OBJ_THUNDER_WAVE, 48, 92, $0
    anim_wait 24
    anim_setobj $1, $3
    anim_wait 1
    anim_sound 0, 0, SFX_HYPER_BEAM
    anim_obj ANIM_OBJ_27, 64, 92, $0
    anim_wait 4
    anim_sound 0, 0, SFX_HYPER_BEAM
    anim_obj ANIM_OBJ_27, 80, 84, $0
    anim_wait 4
    anim_sound 0, 1, SFX_HYPER_BEAM
    anim_obj ANIM_OBJ_27, 96, 76, $0
    anim_wait 4
    anim_sound 0, 1, SFX_HYPER_BEAM
    anim_obj ANIM_OBJ_27, 112, 68, $0
    anim_obj ANIM_OBJ_28, 126, 62, $0
    anim_wait 48
    anim_clearobjs
    anim_obj ANIM_OBJ_34, 136, 56, $2
    anim_wait 16
    anim_sound 0, 1, SFX_THUNDERSHOCK
    anim_obj ANIM_OBJ_33, 136, 56, $0
    anim_jump BattleAnim_Wait64

BattleAnim_DragonTail:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_wait 32
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 3
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 128, 48, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 144, 48, $0
	anim_wait 3
	anim_jump BattleAnim_ShowMon_0

BattleAnim_GrassKnot:
	anim_1gfx ANIM_GFX_PLANT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_RAZOR_LEAF, 124, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 124, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_RAZOR_LEAF, 132, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 132, 64, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_RAZOR_LEAF, 140, 64, $0
	anim_obj ANIM_OBJ_RAZOR_LEAF, 140, 64, $0
	anim_wait 16
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $d0
	anim_wait 32
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $dc
	anim_jump BattleAnim_Wait32

BattleAnim_WorkUp:
	anim_1gfx ANIM_GFX_WIND
	anim_call BattleAnim_TargetObj_2Row
	anim_sound 0, 0, SFX_AEROBLAST
	anim_bgeffect ANIM_BG_18, $0, $1, $40
.loop
	anim_bgeffect ANIM_BG_WITHDRAW, $0, $1, $50
	anim_wait 3
	anim_incbgeffect ANIM_BG_WITHDRAW
	anim_loop 16, .loop
	anim_wait 32
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
	anim_wait 32
	anim_jump BattleAnim_ShowMon_0

BattleAnim_Flatter:

BattleAnim_AquaRing:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_obj ANIM_OBJ_RISING_BUBBLE, 80, 80, $0
	anim_obj ANIM_OBJ_RISING_BUBBLE, 80, 80, $d
	anim_obj ANIM_OBJ_RISING_BUBBLE, 80, 80, $1a
	anim_obj ANIM_OBJ_RISING_BUBBLE, 80, 80, $27
	anim_obj ANIM_OBJ_RISING_BUBBLE, 80, 80, $34
	anim_sound 0, 0, SFX_PROTECT
	anim_wait 96
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_ret

BattleAnim_Coil:
	anim_1gfx ANIM_GFX_ROPE
	anim_sound 0, 1, SFX_BIND
	anim_obj ANIM_OBJ_DRAGON_DANCE, 48, 98, $0
	anim_wait 8
	anim_obj ANIM_OBJ_DRAGON_DANCE, 48, 96, $0
	anim_wait 8
	anim_obj ANIM_OBJ_DRAGON_DANCE, 48, 104, $0
	anim_wait 16
	anim_sound 0, 1, SFX_BIND
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_jump BattleAnim_Wait64

BattleAnim_PsychoBoost:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgp $1b
	anim_obp0 $f

BattleAnim_EerieSpell:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_PURPLE

BattleAnim_ClearSmog:
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 0, 1, SFX_BUBBLEBEAM
.loop
	anim_obj ANIM_OBJ_SMOG, 132, 16, $0
	anim_wait 8
	anim_loop 10, .loop
	anim_jump BattleAnim_Wait96

BattleAnim_RagingBull:
    anim_1gfx ANIM_GFX_WIND
.loop
    anim_sound 0, 0, SFX_ENCORE
    anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
    anim_wait 64
    anim_loop 2, .loop
    anim_wait 16
    anim_jump BattleAnim_DoubleEdge

BattleAnim_DireClaw:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE

BattleAnim_PhantomForce:
	anim_if_param_equal $1, BattleAnim_PhantomForceBranch
	anim_if_param_equal $2, BattleAnim_PhantomForceBranch2
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TailAttack
	anim_wait 32

BattleAnim_PhantomForceBranch:
	anim_bgp $1b
	anim_obp1 $1b
	anim_wait 36
	anim_sound 0, 0, SFX_CURSE
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_jump BattleAnim_Wait96

BattleAnim_PhantomForceBranch2:
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_jump BattleAnim_Wait32

BattleAnim_SacredSword:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_jump BattleAnim_Wait48

BattleAnim_Wait48:
	anim_wait 48
	anim_ret

BattleAnim_ChipAway:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SPARK
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_2E, $60, $1, $1
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_03, 136, 40, $0
	anim_wait 8
	anim_jump BattleAnim_ShowMon_0

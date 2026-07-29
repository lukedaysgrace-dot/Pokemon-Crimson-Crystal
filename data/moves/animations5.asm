; ============================================================
; Move Expansion 2026-07
; Part 1: animations ported from Johto Legends (data/moves/animations.asm)
; Part 2: new animations built from Crimson Crystal objects
; ============================================================

BattleAnim_FakeOut:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_99, 136, 46, $90
	anim_obj ANIM_OBJ_99, 136, 46, $10
	anim_wait 16
	anim_sound 0, 0, SFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAGE
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_jump BattleAnim_Wait32

BattleAnim_IronDefense:

BattleAnim_RockPolish:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row_5
	anim_call BattleAnim_Harden_branch_cbc43_5
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_WoodHammer:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GREEN
	anim_call BattleAnim_KnockOff_5
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 136, 40, $d0
	anim_jump BattleAnim_Wait32
	
BattleAnim_HeadSmash:

BattleAnim_DrillRun:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_jump BattleAnim_HornDrillBranch

BattleAnim_PsychoCut:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_1gfx ANIM_GFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_jump BattleAnim_Wait32

BattleAnim_SacredSword:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_YELLOW
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_jump BattleAnim_Wait48

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

BattleAnim_HeatWave:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_FIRE
	anim_bgp $90
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 0, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_HEAT_WAVE, 88, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_HEAT_WAVE, 56, 16, $1
	anim_wait 8
	anim_obj ANIM_OBJ_HEAT_WAVE, 72, 32, $1
	anim_wait 8
	anim_obj ANIM_OBJ_HEAT_WAVE, 24, 48, $1
	anim_wait 8
	anim_obj ANIM_OBJ_HEAT_WAVE, 40, 64, $1
	anim_loop 3, .loop
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_ret

BattleAnim_Snarl:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_jump BattleAnim_RoarBranch

BattleAnim_Nuzzle:

BattleAnim_BulletSeed:
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_HIT
.Loop
	anim_obj ANIM_OBJ_BULLET_SEED, 64, 70, $10
	anim_wait 8
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_04, 128, 40, $0
	anim_wait 1
	anim_loop 10, .Loop
;	anim_obj ANIM_OBJ_BULLET_SEED, 64, 70, $10
;	anim_wait 8
;	anim_sound 0, 1, SFX_VINE_WHIP
;	anim_obj ANIM_OBJ_04, 136, 56, $0
;	anim_wait 8
;	anim_obj ANIM_OBJ_BULLET_SEED, 64, 70, $10
;	anim_wait 8
;	anim_sound 0, 1, SFX_VINE_WHIP
;	anim_obj ANIM_OBJ_04, 132, 48, $0
	anim_jump BattleAnim_Wait8

BattleAnim_DualWingbeat:
	anim_1gfx ANIM_GFX_HIT
	anim_jump BattleAnim_WingGFX

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

BattleAnim_MudShot:
	anim_1gfx ANIM_GFX_SAND
	anim_obp0 $fc
	anim_jump BattleAnim_MudSlap_branch_cbc5b_5

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
	anim_jump BattleAnim_ShowMon_0_5

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
	anim_call BattleAnim_Sludge_branch_cbc15_5
	anim_wait 56
	anim_ret

BattleAnim_MagicalLeaf:
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_RED
	anim_jump BattleAnim_RazorLeaf_5

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

BattleAnim_PhantomForce:
; EFFECT_FLY, so the same three-way param split as BattleAnim_Fly:
; $1 = the charge turn, $2 = coming back without connecting,
; anything else = the strike (which falls through into the reappear).
	anim_if_param_equal $1, BattleAnim_PhantomForceBranch
	anim_if_param_equal $2, BattleAnim_PhantomForceBranch2

; The strike. This is deliberately BattleAnim_ShadowBall's exact GFX and palette
; recipe with impacts appended - no anim_setobjpal and no anim_obp0. Those two
; were what turned the shadow ball into a solid square: obp0 $c0 collapses three
; of the four object shades into one, so anything drawn with it becomes a blob.
; ANIM_GFX_HIT is appended last so EGG and SMOKE keep the same tile offsets
; Shadow Ball relies on.
	anim_3gfx ANIM_GFX_EGG, ANIM_GFX_SMOKE, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 0, SFX_CURSE
	anim_wait 12
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SHADOW_BALL, 64, 92, $2
	anim_wait 32
	anim_obj ANIM_OBJ_BALL_POOF, 132, 56, $10
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $c0, $1, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 124, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 148, 64, $0
	anim_wait 24

BattleAnim_PhantomForceBranch2:
; Reappear - also the path taken when it comes back without striking.
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_PhantomForceBranch:
; Charge turn: fade out and stay out.
;
; ANIM_BG_16 is a scanline palette fade over the battler's own rows. It ends
; instead of reversing (unlike ANIM_BG_1D, which is why the sprite used to flash
; back in), so the mon is still dark when HIDE_MON lands.
;
; Deliberately NO anim_call BattleAnim_TargetObj_1Row here. That command
; converts the battler pic from BG tiles into OAM objects and MUST be paired
; with BattleAnim_ShowMon_0 to put it back. Leaving it unpaired is what was
; chopping the bottom off the opponent and the top off your own back sprite -
; the BG map kept pointing at rows that had been handed to OAM and never
; restored. The fade does not need it; only effects that move the mon do.
	anim_1gfx ANIM_GFX_SPEED
	anim_sound 0, 0, SFX_CURSE
	anim_bgeffect ANIM_BG_16, $0, $1, $40
	anim_wait 48
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_16
	anim_ret

BattleAnim_HeadlongRush:
; No wind-up. It just detonates on contact and takes the ground with it.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BROWN
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS
	anim_call BattleAnim_TargetObj_1Row_5
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 3
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_1F, $c0, $1, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 128, 52, $40
	anim_wait 4
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 48, $0
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 148, 60, $30
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 140, 64, $48
	anim_wait 12
	anim_call BattleAnim_ShowMon_0_5
	anim_wait 24
	anim_ret

BattleAnim_ShadowBone:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_jump BattleAnim_BoneClub_5

BattleAnim_DireClaw:
; Three raking claws that leave venom behind.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 6
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 120, 48, $0
	anim_wait 14
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 132, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 148, 60, $0
	anim_wait 24
	anim_ret

BattleAnim_ShellSideArm:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SHELLSIDEARM, 64, 92, $4
	anim_wait 16
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_jump BattleAnim_Toxic_branch_cbc15_5

BattleAnim_Psyshield:
	anim_call BattleAnim_LightScreen_5
	anim_wait 32
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row_5
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 136, 48, $0
	anim_wait 8
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_RagingFury:

BattleAnim_StrangeSteam:
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED
	anim_jump BattleAnim_Smog2

BattleAnim_EerieSpell:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_PURPLE

BattleAnim_RagingBull:
	anim_1gfx ANIM_GFX_WIND
.loop
	anim_sound 0, 0, SFX_ENCORE
	anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
	anim_wait 64
	anim_loop 2, .loop
	anim_wait 16
	anim_jump BattleAnim_DoubleEdge_5

BattleAnim_QuiverDance:
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_SHINE
	anim_call BattleAnim_TargetObj_1Row_5
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
	anim_bgeffect ANIM_BG_06, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_FORESIGHT
	anim_obj ANIM_OBJ_QUIVER_DANCE, 48, 104, $0
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
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_WorkUp:
	anim_1gfx ANIM_GFX_WIND
	anim_call BattleAnim_TargetObj_2Row_5
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
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_Superpower:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_EndureLoop
	anim_1gfx ANIM_GFX_HIT
	anim_jump BattleAnim_DoubleEdge_5

BattleAnim_CrushClaw:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_SCRATCH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_jump BattleAnim_Wait32

BattleAnim_ForcePalm:

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

BattleAnim_CircleThrow:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_5
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
	anim_call BattleAnim_ShowMon_0_5
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_03, 132, 56, $0
	anim_jump BattleAnim_Wait16

BattleAnim_Bounce:

BattleAnim_DragonTail:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_5
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0_5
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_wait 32
	anim_call BattleAnim_TargetObj_1Row_5
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 3
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 128, 48, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 144, 48, $0
	anim_wait 3
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_Wait32:
	anim_wait 32
	anim_ret

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

BattleAnim_Wait48:
	anim_wait 48
	anim_ret

BattleAnim_RoarBranch:
	anim_1gfx ANIM_GFX_NOISE
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_cry $1
.loop
	anim_call BattleAnim_Roar_branch_cbbbc_5
	anim_wait 16
	anim_loop 3, .loop
	anim_wait 16
	anim_if_param_equal $0, .done
	anim_bgeffect ANIM_BG_27, $0, $0, $0
	anim_wait 64
.done
	anim_ret

BattleAnim_Wait8:
	anim_wait 8
	anim_ret

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

BattleAnim_Wait96:
	anim_wait 96
	anim_ret

BattleAnim_Wait16:
	anim_wait 16
	anim_ret

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

BattleAnim_Smog2:
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 16, 2, SFX_BUBBLEBEAM
.loop
	anim_obj ANIM_OBJ_POISON_GAS, 44, 80, $2
	anim_wait 8
	anim_loop 10, .loop
	anim_wait 128
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

; ============================================================
; Move Expansion 2026-07 - custom animations
; Built from Crimson Crystal's existing battle-anim object set.
; ============================================================

BattleAnim_Overheat:
; Blistering firestorm, then the user's glow burns out (SpAtk drop)
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION, ANIM_GFX_SMOKE_PUFF
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME, 44, 96, $0
	anim_wait 12
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $1
	anim_wait 8
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 128, 64, $4
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 128, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_EXPLOSION2, 144, 60, $0
	anim_wait 24
	anim_sound 0, 0, SFX_UNKNOWN_66
	anim_obj ANIM_OBJ_SMOKE, 48, 96, $20
	anim_wait 24
	anim_ret

BattleAnim_LeafStorm:
; Rising green vortex that tears the target apart, then the user wilts
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_GREEN
	anim_3gfx ANIM_GFX_PLANT, ANIM_GFX_PETALS, ANIM_GFX_VORTEX
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_VORTEX, 136, 72, $0
	anim_wait 10
.loop
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_RAZOR_LEAF, 120, 88, 10
	anim_wait 4
	anim_obj ANIM_OBJ_PETAL_DANCE, 148, 80, $0
	anim_wait 4
	anim_obj ANIM_OBJ_RAZOR_LEAF, 132, 64, $28
	anim_wait 4
	anim_loop 4, .loop
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_PETAL_DANCE_IMPACT, 136, 56, $28
	anim_wait 24
	anim_incbgeffect ANIM_BG_2C
	anim_wait 8
	anim_ret

BattleAnim_FlipTurn:
; A splashing strike, then the user rockets back out of the field
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_WATER
	anim_3gfx ANIM_GFX_WATER, ANIM_GFX_BUBBLE, ANIM_GFX_U_TURN
	anim_sound 0, 1, SFX_WATER_GUN
	anim_obj ANIM_OBJ_AQUA_JET, 72, 80, $0
	anim_wait 10
	anim_sound 0, 1, SFX_SURF
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 136, 56, $d0
	anim_obj ANIM_OBJ_DROPLET_L, 128, 60, $24
	anim_obj ANIM_OBJ_DROPLET_R, 144, 60, $3b
	anim_wait 16
	anim_sound 0, 0, SFX_WARP_TO
	anim_obj ANIM_OBJ_VOLT_SWITCH, 48, 96, $4
	anim_wait 24
	anim_ret

BattleAnim_ScaleShot:
; A rattling volley of hardened scales
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_TRIANGLE, ANIM_GFX_HIT
.loop
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 64, 80, $2
	anim_wait 5
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 64, 88, $2
	anim_wait 5
	anim_loop 3, .loop
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_SMALL, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_HIT_SMALL, 128, 64, $0
	anim_wait 16
	anim_ret

BattleAnim_BarbBarrage:
; A spray of toxic barbs
	anim_purplepal
	anim_3gfx ANIM_GFX_HORN, ANIM_GFX_POISON, ANIM_GFX_HIT
.loop
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_NEEDLE, 64, 80, $14
	anim_wait 4
	anim_obj ANIM_OBJ_NEEDLE, 64, 92, 11
	anim_wait 4
	anim_loop 4, .loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_POISON_DROPLET, 136, 56, $11
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 128, 64, $0f
	anim_wait 20
	anim_ret

BattleAnim_InfernalParade:
; A procession of ghostly violet flames
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_PURPLE
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_GLOW_SHADOW, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 72, 88, $30
	anim_wait 6
	anim_obj ANIM_OBJ_EMBER, 88, 72, 8
	anim_wait 6
	anim_loop 3, .loop
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_BIG_GLOW_CLEAR, 136, 56, $0
	anim_wait 12
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 20
	anim_ret

BattleAnim_KowtowCleave:
; A low bow, then a dark rising cleave
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_GLOW_SHADOW, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 48, 100, $0
	anim_wait 20
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_UP_RIGHT, 132, 60, $0
	anim_wait 8
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 20
	anim_ret

BattleAnim_ArmorCannon:
; Armor plates ignite and are fired as a cannon blast
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_CHARGE, ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_SHARPEN
	anim_obj ANIM_OBJ_CHARGE, 48, 96, $30
	anim_wait 16
	anim_obj ANIM_OBJ_CHARGE, 48, 96, $31
	anim_wait 16
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $5
	anim_wait 10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_EXPLOSION2, 130, 66, $0
	anim_wait 6
	anim_obj ANIM_OBJ_EXPLOSION2, 142, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_GlaiveRush:
; A headlong dragon dive with a heavy landing
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_HIT_2, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $0
	anim_wait 10
	anim_obj ANIM_OBJ_BLUR_DIAGONAL, 88, 72, $18
	anim_wait 8
	anim_bgeffect ANIM_BG_TACKLE, $0, $0, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 132, 60, $0
	anim_wait 24
	anim_ret

BattleAnim_DragonDarts:
; Two dragon darts fired in sequence
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_SHAPES, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_OUTRAGE
	anim_obj ANIM_OBJ_DRAGON_PULSE, 64, 80, $4
	anim_wait 10
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_SMALL, 136, 52, $0
	anim_wait 10
	anim_sound 0, 1, SFX_OUTRAGE
	anim_obj ANIM_OBJ_DRAGON_PULSE, 64, 92, $4
	anim_wait 10
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_SMALL, 132, 62, $0
	anim_wait 20
	anim_ret

BattleAnim_AppleAcid:
; A sour apple bursts into corrosive spray
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_ACID
	anim_3gfx ANIM_GFX_PLANT, ANIM_GFX_POISON, ANIM_GFX_EXPLOSION
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $20
	anim_wait 14
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 8
.loop
	anim_sound 0, 0, SFX_TOXIC
	anim_obj ANIM_OBJ_ACID, 136, 56, 11
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 128, 64, $11
	anim_wait 6
	anim_loop 3, .loop
	anim_wait 16
	anim_ret

BattleAnim_GravApple:
; An apple is dragged down from above and smashes on the target
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_RED
	anim_3gfx ANIM_GFX_PLANT, ANIM_GFX_EXPLOSION, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SEED_BOMB, 136, 0, $20
	anim_wait 16
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 60, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 20
	anim_incbgeffect ANIM_BG_2C
	anim_wait 8
	anim_ret

BattleAnim_BanefulBunker:
; A protective shell that seethes with poison
	anim_purplepal
	anim_2gfx ANIM_GFX_REFLECT, ANIM_GFX_POISON
	anim_call BattleAnim_TargetObj_1Row_5
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_PROTECT, 44, 92, $0
	anim_wait 12
	anim_sound 0, 0, SFX_TOXIC
	anim_obj ANIM_OBJ_POISON_DROPLET, 36, 96, $0f
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 56, 88, $11
	anim_wait 32
	anim_jump BattleAnim_ShowMon_0_5

BattleAnim_FickleBeam:
; A dragon beam fired with wavering, then sudden, conviction
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_3gfx ANIM_GFX_CHARGE, ANIM_GFX_BEAM, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_SHARPEN
	anim_obj ANIM_OBJ_CHARGE, 48, 96, $32
	anim_wait 20
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM, 72, 72, $0
	anim_wait 4
	anim_obj ANIM_OBJ_BEAM, 96, 68, $0
	anim_wait 4
	anim_obj ANIM_OBJ_BEAM_TIP, 128, 60, 7
	anim_wait 12
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 24
	anim_ret

BattleAnim_StoneAxe:
; A heavy cleave, then the rock it shears loose bursts up out of the target.
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 20
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $c0, $1, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_AVALANCHE_BIG, 144, 250, $0e
	anim_wait 3
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 122, 250, $12
	anim_wait 3
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_AVALANCHE_BIG, 118, 250, $11
	anim_wait 3
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 154, 250, $0f
	anim_wait 3
	anim_obj ANIM_OBJ_AVALANCHE_SMALL, 134, 250, $10
	anim_wait 32
	anim_ret

BattleAnim_StealthRock:
; Jagged stones rise and hang suspended around the far side of the field
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_SHINE
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SMALL_ROCK, 120, 80, $30
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_BIG_ROCK, 148, 64, $30
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SMALL_ROCK, 136, 48, $30
	anim_wait 12
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 148, 64, $0
	anim_wait 6
	anim_obj ANIM_OBJ_GLIMMER, 120, 80, $0
	anim_wait 48
	anim_ret

BattleAnim_Defog:
; A sweeping gale that clears the field
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HAZE
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
.loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 64, 72, $0
	anim_wait 6
	anim_obj ANIM_OBJ_GUST, 64, 88, $0
	anim_wait 6
	anim_loop 4, .loop
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HURRICANE, 136, 56, $38
	anim_wait 24
	anim_incbgeffect ANIM_BG_2C
	anim_wait 8
	anim_ret

BattleAnim_BodyPress:
; The user hardens, then throws its whole braced body at the target
	anim_3gfx ANIM_GFX_REFLECT, ANIM_GFX_HIT_2, ANIM_GFX_EXPLOSION
	anim_call BattleAnim_TargetObj_1Row_5
	anim_call BattleAnim_Harden_branch_cbc43_5
	anim_call BattleAnim_ShowMon_0_5
	anim_bgeffect ANIM_BG_TACKLE, $0, $0, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 132, 60, $0
	anim_wait 24
	anim_ret

BattleAnim_FieryDance:
; A whirling dance of flame that leaves embers glittering around the user
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_SHINE, ANIM_GFX_SWIRL
	anim_bgeffect ANIM_BG_06, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_SWIRL_SHORT, 48, 96, $0
	anim_wait 8
	anim_loop 3, .loop
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME, 136, 56, $0
	anim_wait 12
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 136, 56, $0
	anim_wait 12
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 40, 88, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 60, 100, $0
	anim_wait 24
	anim_ret

BattleAnim_FoulPlay:
; The target's own force is gathered and turned back against it
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_3gfx ANIM_GFX_GLOW_SHADOW, ANIM_GFX_HIT_2, ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_DARK_PULSE_W, 128, 56, $20
	anim_wait 5
	anim_obj ANIM_OBJ_DARK_PULSE_NW, 128, 48, $28
	anim_wait 5
	anim_obj ANIM_OBJ_DARK_PULSE_SW, 128, 64, $18
	anim_wait 12
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHRINKING_GLOW, 48, 96, $0
	anim_wait 16
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_HIT_BIG, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT, 130, 62, $0
	anim_wait 20
	anim_ret

BattleAnim_RageFist:
; Fury boils over into a single heavy punch
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_STATUS, ANIM_GFX_HIT_2, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_ANGER, 44, 80, $0
	anim_wait 8
	anim_obj ANIM_OBJ_ANGER, 60, 88, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $40, $3, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_LONG_PUNCH, 136, 56, $0
	anim_wait 10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 24
	anim_ret

BattleAnim_FreezeDry:
; A dry, biting frost that flash-freezes moisture
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_3gfx ANIM_GFX_ICE, ANIM_GFX_SHINE, ANIM_GFX_SMOKE_PUFF
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_POWDER
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 80, $4
	anim_wait 6
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 92, $4
	anim_wait 6
	anim_loop 3, .loop
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE, 136, 56, $0
	anim_wait 10
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 56, $0
	anim_wait 12
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 130, 50, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 144, 64, $0
	anim_wait 24
	anim_ret


; ---------------------------------------------------------------------------
; In-bank copies of shared animation subroutines.
;
; anim_jump / anim_call / anim_if_param_* store a bare 2-byte address and the
; interpreter keeps running in whichever bank the script started in. The bank
; comes from the `banim` table and is per-move, so a jump from this file into
; animations.asm landed on the same offset in THIS bank and executed garbage.
; That is why several of these moves hung, stalled or played nothing.
;
; These are verbatim copies with a _5 suffix. Keep them in sync by hand if the
; originals ever change.
; ---------------------------------------------------------------------------

BattleAnim_RazorLeaf_5:
	anim_1gfx ANIM_GFX_PLANT
	anim_sound 0, 0, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $5c
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $10
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $e8
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $9c
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $d0
	anim_wait 6
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $1c
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $50
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $dc
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $90
	anim_wait 80
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

BattleAnim_Slash_5:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_obj ANIM_OBJ_3A, 148, 36, $0
	anim_wait 32
	anim_ret

BattleAnim_LightScreen_5:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_REFLECT
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_FLASH
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $0
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $8
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $10
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $18
	anim_wait 4
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_obj ANIM_OBJ_SHINY, 72, 80, $20
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $28
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $30
	anim_wait 4
	anim_obj ANIM_OBJ_SHINY, 72, 80, $38
	anim_wait 64
	anim_ret

BattleAnim_DoubleEdge_5:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row_5
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $10
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 3
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 128, 48, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 144, 48, $0
	anim_wait 3
	anim_call BattleAnim_ShowMon_0_5
	anim_ret

BattleAnim_BoneClub_5:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_MISC
	anim_obj ANIM_OBJ_BONE_CLUB, 64, 88, $2
	anim_wait 32
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Fly_branch_cbb12_5:
BattleAnim_Teleport_branch_cbb12_5:
	anim_sound 0, 0, SFX_WARP_TO
	anim_obj ANIM_OBJ_44, 44, 108, $0
	anim_obj ANIM_OBJ_44, 44, 100, $0
	anim_obj ANIM_OBJ_44, 44, 92, $0
	anim_obj ANIM_OBJ_44, 44, 84, $0
	anim_obj ANIM_OBJ_44, 44, 76, $0
	anim_obj ANIM_OBJ_44, 44, 68, $0
	anim_obj ANIM_OBJ_44, 44, 60, $0
	anim_ret

BattleAnim_Roar_branch_cbbbc_5:
BattleAnim_Snore_branch_cbbbc_5:
	anim_obj ANIM_OBJ_4B, 64, 76, $0
	anim_obj ANIM_OBJ_4B, 64, 88, $1
	anim_obj ANIM_OBJ_4B, 64, 100, $2
	anim_ret

BattleAnim_Sludge_branch_cbc15_5:
BattleAnim_Toxic_branch_cbc15_5:
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 132, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 116, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 148, 72, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_ret

BattleAnim_Harden_branch_cbc43_5:
BattleAnim_IronTail_branch_cbc43_5:
BattleAnim_MetalClaw_branch_cbc43_5:
BattleAnim_SteelWing_branch_cbc43_5:
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_17, $0, $1, $40
	anim_wait 8
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 32
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 64
	anim_incbgeffect ANIM_BG_17
	anim_ret

BattleAnim_MudSlap_branch_cbc5b_5:
BattleAnim_SandAttack_branch_cbc5b_5:
.loop
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_58, 64, 92, $4
	anim_wait 4
	anim_loop 8, .loop
	anim_wait 32
	anim_ret

BattleAnim_TargetObj_1Row_5:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_TargetObj_2Row_5:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_ShowMon_0_5:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_KnockOff_5:
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
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $10, $1, $20
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_obj ANIM_OBJ_PALM, 136, 56, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 64, $0
	anim_wait 1
	anim_obj ANIM_OBJ_PALM, 136, 72, $0
	anim_wait 8
	anim_ret

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

BattleAnim_TargetObj_2Row_CC:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_UserObj_2Row_CC:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_wait 4
	anim_ret

BattleAnim_ShowMon_1_CC:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
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
; (mae-pokeorange) Fire builds in the user until it erupts in a ring of
; flame over the target, leaving both sides scorched under the smoke.
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_SMOKE_PUFF
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_setobjpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_FIRE
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $44, $2, $0
	anim_sound 0, 0, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $28
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $30
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $38
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $8
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $18
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $4
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $2b
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $14
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $3b
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $24
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $b
	anim_wait 12
	anim_clearobjs
	anim_loop 5, .loop
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $6
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $2c
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $1d
	anim_obj ANIM_OBJ_RADIAL_FLAME_SLOW, 136, 56, $39
	anim_wait 16
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_obp0 $fc
	anim_setobjpal PAL_BATTLE_BG_USER, PAL_BTLCUSTOM_CHARRED
	anim_setobjpal PAL_BATTLE_BG_TARGET, PAL_BTLCUSTOM_CHARRED
	anim_sound 0, 0, SFX_BALL_POOF
.loop2
	anim_obj ANIM_OBJ_OVERHEAT_SMOKE, 36, 84, $30
	anim_obj ANIM_OBJ_OVERHEAT_SMOKE, 120, 46, $30
	anim_wait 1
	anim_obj ANIM_OBJ_OVERHEAT_SMOKE, 60, 96, $30
	anim_obj ANIM_OBJ_OVERHEAT_SMOKE, 144, 34, $30
	anim_wait 8
	anim_loop 6, .loop2
	anim_wait 32
	anim_ret

BattleAnim_LeafStorm_CC:
; The sky darkens as a cyclone of leaves whips up around the user,
; hangs for a beat, then every leaf tears across the field at once.
	anim_1gfx ANIM_GFX_PLANT
	anim_bgp $1b
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 0, SFX_RAZOR_WIND
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
	anim_wait 56
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $2, $0
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
	anim_wait 24
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HURRICANE, 132, 56, $38
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_wait 40
	anim_ret

BattleAnim_FakeOut_CC:
; (mae-pokeorange) The little clapping hands snap shut right in the
; target's face - startle, shock lines, then the flinch-flash.
	anim_1gfx ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_FAKE_OUT_L, 112, 48, $0
	anim_obj ANIM_OBJ_FAKE_OUT_R, 158, 48, $0
	anim_wait 32
	anim_clearobjs
	anim_sound 0, 0, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_SMELLINGSALT_L, 112, 48, $0
	anim_obj ANIM_OBJ_SMELLINGSALT_R, 158, 48, $20
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_FAKE_OUT_L, 112, 48, $0
	anim_obj ANIM_OBJ_FAKE_OUT_R, 158, 48, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_wait 32
	anim_ret

BattleAnim_FlipTurn_CC:
; The user rockets through the target on a jet of water, then flips
; up and out of the battle in a U-turn arc.
	anim_3gfx ANIM_GFX_AQUA_JET, ANIM_GFX_HIT, ANIM_GFX_U_TURN
	anim_sound 6, 2, SFX_SURF
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_AQUA_JET, 72, 89, $0
	anim_wait 4
	anim_obj ANIM_OBJ_AQUA_JET, 92, 78, $0
	anim_wait 4
	anim_obj ANIM_OBJ_AQUA_JET, 112, 67, $0
	anim_wait 4
	anim_obj ANIM_OBJ_AQUA_JET, 132, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYDRO_PUMP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $5c
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $e8
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $d0
	anim_obj ANIM_OBJ_BUBBLE_SPLASH, 140, 64, $50
	anim_wait 12
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_U_TURN_RISE, 48, 88, $30
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_ret

BattleAnim_IronDefense_CC:
; (mae-pokeorange) The user's body flashes over and over as it takes on
; a hard metallic sheen.
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row_CC
.loop
	anim_bgp $90
	anim_sound 0, 0, SFX_FORESIGHT
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 6
	anim_bgp $f8
	anim_wait 6
	anim_loop 5, .loop
	anim_wait 6
	anim_jump BattleAnim_ShowMon_0_CC

BattleAnim_RockPolish_CC:
; (mae-pokeorange) Grit sparks off the user's hide from every angle,
; then it gleams with polished sparkles.
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
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 32, 72, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 64, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 32, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 64, 72, $0
	anim_wait 5
	anim_obj ANIM_OBJ_PULSING_SPARKLE, 48, 88, $0
	anim_wait 5
	anim_wait 16
	anim_ret

BattleAnim_WoodHammer_CC:
; The user winds up and swings its whole body like a mallet of solid
; timber - splinters and smoke everywhere, and the recoil rattles it.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_PLANT, ANIM_GFX_SMOKE_PUFF
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $9c
	anim_wait 16
	anim_clearobjs
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
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $60, $2, $20
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_obj ANIM_OBJ_RAZOR_LEAF, 128, 64, $9c
	anim_obj ANIM_OBJ_RAZOR_LEAF, 128, 64, $d0
	anim_wait 2
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 22
	; the recoil bites back
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_sound 0, 0, SFX_TACKLE
	anim_wait 12
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_HeadSmash_CC:
; The user steels itself, then throws away its own safety in a
; skull-first crash that levels the field.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_FOCUS, 44, 108, $6
	anim_wait 3
	anim_obj ANIM_OBJ_FOCUS, 36, 108, $8
	anim_wait 3
	anim_obj ANIM_OBJ_FOCUS, 52, 108, $6
	anim_wait 10
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_clearobjs
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
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $3, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_wait 6
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $40, $2, $20
	anim_obj ANIM_OBJ_EXPLOSION2, 128, 64, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $1c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $50
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $dc
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $90
	anim_wait 32
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_DrillRun_CC:
; The user whirls itself into a living drill, then bores in with
; three grinding strikes before the point punches through.
	anim_4gfx ANIM_GFX_VORTEX, ANIM_GFX_HORN, ANIM_GFX_HIT, ANIM_GFX_ROCKS
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_VORTEX, 44, 88, $0
	anim_wait 24
	anim_clearobjs
	anim_wait 1
.loop
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_MEDIUM_HORN, 136, 56, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $28
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $8, $2, $0
	anim_wait 6
	anim_loop 3, .loop
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 60, $e8
	anim_wait 28
	anim_ret

BattleAnim_PsychoCut_CC:
; Psychic power ripples outward, condenses into blades, and scythes
; across the target in two flickering arcs.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_2gfx ANIM_GFX_PSYCHIC, ANIM_GFX_CUT
	anim_bgp $1b
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 44, 88, $0
	anim_wait 20
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 16
	anim_sound 0, 1, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 32
	anim_ret

BattleAnim_SacredSword_CC:
; The blade is raised high and consecrated in light, then two holy
; slashes cross through the target - stat tricks mean nothing to it.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_GLOW_YELLOW
	anim_4gfx ANIM_GFX_WHIP, ANIM_GFX_SHINE, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_SWORDS_DANCE,   6, 0,  13, 4, $0
	anim_obj ANIM_OBJ_MORNING_SUN, 16, 48, $88
	anim_wait 12
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 48, 72, $0
	anim_obj ANIM_OBJ_GLIMMER, 72, 88, $0
	anim_wait 20
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_wait 10
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 10
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_GLIMMER, 136, 44, $0
	anim_wait 28
	anim_ret

BattleAnim_BrickBreak_CC:
; The chopping hand hangs poised above the foe (pokeorange), then comes
; down through the screen with a glass-shattering blow.
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_REFLECT, ANIM_GFX_ROCKS
	anim_obp0 $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 136, 48, $0
	anim_wait 8
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_VERTICAL_CHOP_STILL, 136, 24, $30
	anim_wait 16
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $55, $2, $0
	anim_wait 48
	anim_clearobjs
	anim_obj ANIM_OBJ_SCREEN, 136, 48, $0
	anim_obj ANIM_OBJ_VERTICAL_CHOP, 136, 48, $0
	anim_wait 4
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 2
	anim_sound 0, 1, SFX_GLASS_TING
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 52, $e8
	anim_wait 32
	anim_ret

BattleAnim_HeatWave_CC:
; (mae-pokeorange) A shimmering wall of superheated air washes over the
; whole field.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_HEAT_WAVE
	anim_1gfx ANIM_GFX_HAZE
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $4, $0
	anim_bgp $90
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 24, $10
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 48, $2
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 32, $6
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 56, $c
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 80, $4
	anim_obj ANIM_OBJ_MIST_BALL_BG, 8, 104, $e
	anim_wait 160
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_ret

BattleAnim_Snarl_CC:
; A guttural snarl rolls out in wave after wave of black sound,
; rattling the target and sapping its will to fight.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_2gfx ANIM_GFX_NOISE, ANIM_GFX_HIT
	anim_bgp $1b
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 12
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_wait 12
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 12
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_LEER
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_wait 20
	anim_ret

BattleAnim_Nuzzle_CC:
; The user scampers up and rubs its charged cheeks on the target -
; adorable, and completely paralyzing.
	anim_3gfx ANIM_GFX_LIGHTNING, ANIM_GFX_HIT, ANIM_GFX_STATUS
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
	anim_wait 24
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_THUNDER_WAVE, 132, 48, $10
	anim_wait 8
	anim_obj ANIM_OBJ_PARALYZED, 104, 52, $42
	anim_obj ANIM_OBJ_PARALYZED, 160, 52, $c2
	anim_wait 24
	anim_ret

BattleAnim_BulletSeed_CC:
; (mae-pokeorange, shortened) A rattling burst of hard seeds per hit -
; kept short so the multi-hit loop stays snappy.
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_obj ANIM_OBJ_BULLET_SEED, 64, 90, $6
	anim_wait 4
	anim_obj ANIM_OBJ_BULLET_SEED, 64, 90, $6
	anim_wait 3
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_obj ANIM_OBJ_BULLET_SEED, 64, 90, $6
	anim_wait 3
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 6
	anim_ret

BattleAnim_DualWingbeat_CC:
; One heavy wingbeat per hit, slamming in from both sides at once.
	anim_2gfx ANIM_GFX_WHIP, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_AIR_SLASH, 152, 48, $8
	anim_obj ANIM_OBJ_AIR_SLASH, 120, 48, $28
	anim_wait 8
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 0,   7, 0, $0
	anim_obj ANIM_OBJ_HIT_YFIX,  14, 4,   7, 0, $0
	anim_wait 16
	anim_ret

BattleAnim_RockTomb_CC:
; (mae-pokeorange) Boulders thud down one by one and box the target in,
; stamped with a big flashing X.
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_ROCK_TOMB, 128, 70, $30
	anim_wait 18
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $2, $0
	anim_obj ANIM_OBJ_ROCK_TOMB, 152, 68, $30
	anim_wait 18
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $2, $0
	anim_obj ANIM_OBJ_ROCK_TOMB, 112, 68, $30
	anim_wait 18
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $4, $2, $0
	anim_obj ANIM_OBJ_ROCK_TOMB, 136, 66, $30
	anim_wait 18
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_wait 40
	anim_clearobjs
	anim_sound 6, 3, SFX_PLACE_PUZZLE_PIECE_DOWN
	anim_obj ANIM_OBJ_RED_X, 132, 44, $2e
	anim_wait 32
	anim_ret

BattleAnim_LowSweep_CC:
; A darting slide, a sweeping kick at the legs, and the target's
; footing - and speed - go out from under it.
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_HIT, ANIM_GFX_WIND_BG
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 8
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_KICK, -15, 0,   8, 0, $0
	anim_wait 6
	anim_sound 0, 1, SFX_JUMP_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, -15, 4,   8, 0, $0
	anim_wait 10
	; its legs go sluggish
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_AGILITY, 116, 72, $10
	anim_obj ANIM_OBJ_AGILITY, 140, 76, $10
	anim_wait 24
	anim_ret

BattleAnim_MudShot_CC:
; (mae-pokeorange) A sustained stream of mud globs splatters over the
; target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_BROWN
	anim_1gfx ANIM_GFX_POISON
.loop
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
	anim_loop 4, .loop
	anim_wait 4
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $d0
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $50
	anim_wait 16
	anim_ret

BattleAnim_AirCutter_CC:
; (mae-pokeorange) Waves of razor wind stream off the user's wingbeats
; and slice across the wobbling target.
	anim_2gfx ANIM_GFX_WHIP, ANIM_GFX_HIT
	anim_call BattleAnim_UserObj_2Row_CC
	anim_bgeffect ANIM_BG_WOBBLE_MON, $0, $0, $0
.loop
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_AIR_CUTTER, 64, 80, $18
	anim_wait 4
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_AIR_CUTTER, 64, 96, $18
	anim_wait 4
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_AIR_CUTTER, 64, 88, $18
	anim_wait 4
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_AIR_CUTTER, 64, 104, $18
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 32
	anim_incbgeffect ANIM_BG_WOBBLE_MON
	anim_call BattleAnim_ShowMon_1_CC
	anim_ret

BattleAnim_CrossPoison_CC:
; Two venom-soaked blades scissor through the target in an X, leaving
; poison dripping from the wound.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_bgp $1b
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CROSS_CHOP1,  15, 0,   9, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CROSS_CHOP2, -13, 0,   5, 0, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 6
	anim_obj ANIM_OBJ_POISON_DROPLET, 130, 48, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 142, 48, $0
	anim_obj ANIM_OBJ_SKULL, 136, 40, $0
	anim_wait 28
	anim_ret

BattleAnim_MagicalLeaf_CC:
; (mae-pokeorange) Rainbow leaves swirl around the user, then every one
; of them homes in on the target.
	anim_setobjpal PAL_BATTLE_OB_GREEN, PAL_BTLCUSTOM_AURORA
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
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 3
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 5
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 7
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 9
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 1
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 2
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 4
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 6
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 8
	anim_wait 2
	anim_sound 16, 2, SFX_SWEET_SCENT
	anim_incobj 10
	anim_wait 64
	anim_ret

BattleAnim_SignalBeam_CC:
; (mae-pokeorange) Alternating red and blue orbs of sinister light pulse
; into the target while the whole screen strobes.
	anim_1gfx ANIM_GFX_GLOW
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SIGNAL_BEAM_RED
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_SIGNAL_BEAM_BLUE
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_SIGNAL_BEAM_R, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_SIGNAL_BEAM_B, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_SIGNAL_BEAM_R, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_SIGNAL_BEAM_B, 64, 92, $0
	anim_wait 4
	anim_loop 4, .loop
	anim_wait 64
	anim_ret

BattleAnim_ScaleShot_CC:
; A volley of hard, gleaming scales - several per hit, kept short so
; the multi-hit loop stays snappy.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_TRIANGLE, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 98, $2
	anim_wait 3
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 56, 90, $2
	anim_wait 3
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 82, $2
	anim_wait 8
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 130, 62, $0
	anim_wait 6
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
; the user slowly fades from sight (Faint Attack-style fade) and STAYS
; gone: the pic is hidden before the fade effect is released, so nothing
; comes back until the turn-2 strike.
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_CURSE
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_FADE_MON_TO_WHITE_WAIT_FADE_BACK, $0, $1, $80
	anim_wait 96
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 2
	anim_incbgeffect ANIM_BG_FADE_MON_TO_WHITE_WAIT_FADE_BACK
	anim_call BattleAnim_ShowMon_0_CC
	anim_wait 4
	anim_ret

; ==== 2026-07 move expansion, batch 2 ====

BattleAnim_HeadlongRush_CC:
; Dust erupts under the user's feet as it barrels forward and buries
; the target in a reckless, ground-churning collision.
	anim_4gfx ANIM_GFX_SAND, ANIM_GFX_HIT, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_sound 0, 0, SFX_SANDSTORM
	anim_obj ANIM_OBJ_DIG_SAND, 40, 92, $0
	anim_obj ANIM_OBJ_DIG_SAND, 48, 92, $0
	anim_obj ANIM_OBJ_DIG_SAND, 56, 92, $0
	anim_wait 12
	anim_clearobjs
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
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 128, 56, $0
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 60, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $5c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 68, $e8
	anim_wait 6
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $30, $2, $20
	anim_obj ANIM_OBJ_DIG_SAND, 120, 60, $0
	anim_obj ANIM_OBJ_DIG_SAND, 136, 60, $0
	anim_obj ANIM_OBJ_DIG_SAND, 152, 60, $0
	anim_wait 28
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_ShadowBone_CC:
; A dead mon's spirit seeps out of the bone as it whirls in, and the
; haunted club comes down with the weight of the grave.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_3gfx ANIM_GFX_MISC, ANIM_GFX_ANGELS, ANIM_GFX_HIT
	anim_bgp $1b
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 68, 80, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_BONEMERANG, 88, 56, $1c
	anim_wait 24
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $30, $2, $20
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 132, 40, $0
	anim_wait 28
	anim_ret

BattleAnim_DireClaw_CC:
; The claws flash with a killer's edge, rake the target twice, and
; leave poison, paralysis and drowsiness all fighting to set in.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_4gfx ANIM_GFX_TEAR, ANIM_GFX_HIT, ANIM_GFX_POISON, ANIM_GFX_STATUS
	anim_bgp $1b
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_HONE_CLAWS_LEFT, 72, 84, $0
	anim_obj ANIM_OBJ_HONE_CLAWS_RIGHT, 24, 84, $0
	anim_wait 16
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_CLAW_TEAR, 132, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_SCRATCH
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_CLAW_TEAR, 140, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	; which poison takes hold...?
	anim_obj ANIM_OBJ_POISON_DROPLET, 126, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_PARALYZED, 160, 52, $c2
	anim_wait 6
	anim_obj ANIM_OBJ_ASLEEP, 146, 36, $0
	anim_wait 24
	anim_ret

BattleAnim_BarbBarrage_CC:
; Volley after volley of venomous barbs needle into the target, and
; the poison already in its veins makes every one hurt worse.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_HORN, ANIM_GFX_POISON, ANIM_GFX_HIT
.loop
	anim_sound 6, 2, SFX_POISON_STING
	anim_obj ANIM_OBJ_NEEDLE, 64, 92, $14
	anim_wait 3
	anim_obj ANIM_OBJ_NEEDLE, 60, 86, $14
	anim_wait 3
	anim_obj ANIM_OBJ_NEEDLE, 68, 98, $14
	anim_wait 3
	anim_loop 3, .loop
	anim_wait 6
	anim_sound 0, 1, SFX_TOXIC
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 56, $0
	anim_wait 4
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 48, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 130, 48, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 142, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_InfernalParade_CC:
; A procession of ghost-lights drifts in one by one, circling the
; target - then the whole parade ignites at once.
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_WILL_O_WISP
	anim_2gfx ANIM_GFX_FIRE, ANIM_GFX_ANGELS
	anim_bgp $1b
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 0, $12
	anim_wait 8
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  11, 0, $14
	anim_wait 8
	anim_sound 6, 2, SFX_NIGHTMARE
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 4, $13
	anim_wait 8
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 68, 80, $0
	anim_wait 12
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_sound 0, 1, SFX_EMBER
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $10
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $30
	anim_wait 8
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 132, 40, $0
	anim_wait 28
	anim_ret

BattleAnim_KowtowCleave_CC:
; A courteous bow... and the instant the target relaxes, the dark
; blade takes its head - it never misses.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgp $1b
	anim_call BattleAnim_TargetObj_1Row_CC
	; the bow
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_wait 6
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_wait 8
	; the cleave
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_wait 10
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_UP_RIGHT, 124, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_ArmorCannon_CC:
; The user superheats and blasts pieces of its own armor at the
; target - devastating, but its defenses go with them.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING, $0, $1, $40
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 44, 88, $20
	anim_wait 24
	anim_incbgeffect ANIM_BG_FADE_MON_TO_LIGHT_REPEATING
	anim_clearobjs
	; its own armor shears off and fires
	anim_sound 6, 2, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $50
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $5c
	anim_obj ANIM_OBJ_EMBER,   8, 0,  11, 0, $12
	anim_wait 6
	anim_sound 6, 2, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $d0
	anim_obj ANIM_OBJ_SHELL_SMASH_DEBRIS, 48, 106, $e8
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 0, $14
	anim_wait 10
	anim_incobj 3
	anim_incobj 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $3, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 136, 56, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_EXPLOSION2, 130, 64, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $5c
	anim_wait 24
	anim_ret

BattleAnim_ShellSideArm_CC:
; The shell glints as it sizes the target up, charges a wobbling orb
; of filth, and fires whichever way will hurt more.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_REFLECT, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_obp0 $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_WITHDRAW, 44, 88, $0
	anim_wait 20
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 0, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 92, $4
	anim_wait 5
	anim_obj ANIM_OBJ_MUD_SHOT, 60, 88, $4
	anim_wait 5
	anim_obj ANIM_OBJ_MUD_SHOT, 64, 84, $4
	anim_wait 10
	anim_sound 0, 1, SFX_SLUDGE_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ACID, 136, 56, $10
	anim_wait 8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_wait 24
	anim_ret

BattleAnim_GlaiveRush_CC:
; The user hurls itself forward as a living blade - a blurring dash,
; two crossing slashes, and no thought at all for what comes back.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_4gfx ANIM_GFX_U_TURN, ANIM_GFX_SPEED, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_THROW_BALL
	anim_call BattleAnimSub_SpeedLines_CC
	anim_wait 8
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_BLUR_DIAGONAL, 64, 92, $18
	anim_wait 10
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $18, $3, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_RIGHT, 118, 40, $0
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 60, $0
	anim_wait 20
	anim_ret

BattleAnim_DragonDarts_CC:
; One Dreepy winds up and streaks into the target per hit.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_TRIANGLE, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPINNING_TRIANGLE, 52, 84, $0
	anim_wait 10
	anim_clearobjs
	anim_sound 6, 2, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SHOOTING_TRIANGLE, 48, 98, $2
	anim_wait 10
	anim_sound 0, 1, SFX_TACKLE
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 16
	anim_ret

BattleAnim_AppleAcid_CC:
; An apple sails over in a lazy arc, bursts on the target's head,
; and the acid inside eats everything it touches.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GASTRO_ACID
	anim_3gfx ANIM_GFX_PLANT, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_SEED_BOMB, 56, 72, $20
	anim_wait 16
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_obj ANIM_OBJ_HIT_YFIX, 136, 48, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_ACID, 136, 48, $10
	anim_wait 8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $5c
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $e8
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $d0
	anim_obj ANIM_OBJ_INK_SPLASH, 136, 56, $50
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 12
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_ACID, 130, 56, $10
	anim_wait 20
	anim_ret

BattleAnim_GravApple_CC:
; Gravity itself reaches up, plucks the apple, and drives it straight
; down through the target.
	anim_setobjpal PAL_BATTLE_OB_BROWN, PAL_BTLCUSTOM_GREEN
	anim_3gfx ANIM_GFX_MISC, ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_KINESIS, 132, 20, $0
	anim_wait 16
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SMALL_ROCK, 128, 36, $30
	anim_wait 8
	anim_obj ANIM_OBJ_BIG_ROCK, 136, 48, $48
	anim_wait 12
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $40, $2, $20
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 64, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 24
	anim_ret

BattleAnim_PsyshieldBash_CC:
; Psychic energy ripples into a barrier in front of the user, and it
; rams in behind it, shield-first.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_PSYCHIC, ANIM_GFX_REFLECT, ANIM_GFX_HIT
	anim_obp0 $0
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 44, 88, $0
	anim_wait 16
	anim_clearobjs
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 20
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SHRINKING_RING_BIG, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_RagingFury_CC:
; The user is swallowed by its own inferno and thrashes through the
; target wreathed in fire it can't stop.
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_sound 0, 0, SFX_OUTRAGE
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 88, $3
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 88, $4
	anim_wait 24
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_clearobjs
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $3, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 52, $0
	anim_obj ANIM_OBJ_FLAME_WHEEL, 128, 60, $0
	anim_wait 6
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $0
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $20
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 136, 56, $10
	anim_wait 28
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_StrangeSteam_CC:
; Sickly-sweet pink steam billows out in waves, wraps the target and
; leaves its head swimming.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PINK
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BRIGHT_PINK
	anim_3gfx ANIM_GFX_HAZE, ANIM_GFX_SMOKE_PUFF, ANIM_GFX_SPEED
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 88, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 80, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SHOOTING_MIST, 64, 96, $0
	anim_wait 12
	anim_sound 0, 1, SFX_SWEET_SCENT_2
	anim_obj ANIM_OBJ_SCALD_STEAM, 120, 46, $30
	anim_obj ANIM_OBJ_SCALD_STEAM, 144, 34, $30
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_DAZZLE, 132, 44, $0
	anim_obj ANIM_OBJ_DAZZLE, 132, 44, $20
	anim_wait 28
	anim_ret

BattleAnim_EerieSpell_CC:
; An incantation hums through the air; a spiteful spirit answers it
; and gnaws the very memory of the target's move away.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_PSYCHIC, ANIM_GFX_NOISE, ANIM_GFX_ANGELS
	anim_bgp $1b
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 44, 88, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SCREECH
	anim_obj ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj ANIM_OBJ_SOUND, 64, 100, $2
	anim_wait 16
	anim_sound 0, 0, SFX_SPITE
	anim_obj ANIM_OBJ_SPITE, 132, 16, $0
	anim_wait 24
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_WAVE, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_BanefulBunker_CC:
; The protective dome rises - then poisoned spikes punch out through
; its surface. Touch it and regret it.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PURPLE
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_PURPLE
	anim_3gfx ANIM_GFX_OBJECTS, ANIM_GFX_HORN, ANIM_GFX_POISON
	anim_sound 0, 0, SFX_PROTECT
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $0
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $d
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $1a
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $27
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $34
	anim_wait 24
	anim_sound 0, 0, SFX_POISON_STING
	anim_obj ANIM_OBJ_NEEDLE, 64, 92, $14
	anim_obj ANIM_OBJ_NEEDLE, 56, 84, $14
	anim_wait 8
	anim_sound 0, 0, SFX_TOXIC
	anim_obj ANIM_OBJ_POISON_DROPLET, 56, 80, $0
	anim_obj ANIM_OBJ_POISON_DROPLET, 72, 76, $0
	anim_obj ANIM_OBJ_SKULL, 48, 60, $0
	anim_wait 28
	anim_ret

BattleAnim_RagingBull_CC:
; Steam, stamping, seeing red - then the bull charges clean through
; whatever wall stands in its way.
	anim_4gfx ANIM_GFX_HIT, ANIM_GFX_REFLECT, ANIM_GFX_ROCKS, ANIM_GFX_STATUS
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_ANGER, 40, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_ANGER, 60, 52, $0
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_wait 12
	anim_clearobjs
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
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $2, $0
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
; Full Hyper Beam-style segment chain so the beam actually reaches
; the target instead of stopping halfway.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_2gfx ANIM_GFX_BEAM, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM, 80, 84, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM, 96, 76, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BEAM, 112, 68, $0
	anim_obj ANIM_OBJ_28, 126, 62, $0
	anim_wait 12
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_AEROBLAST
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 24
	anim_ret

BattleAnim_StoneAxe_CC:
; The stone axe cleaves through, and the shards it sheds hang in the
; air around the target, sharp side out.
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $08, $2, $0
	anim_obj ANIM_OBJ_CUT_LONG_DOWN_LEFT, 150, 40, $0
	anim_wait 10
	anim_sound 0, 1, SFX_STRENGTH
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 136, 56, $5c
	anim_wait 12
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 120, 48, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 136, 40, $0
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 152, 48, $0
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 136, 44, $0
	anim_wait 20
	anim_ret

BattleAnim_QuiverDance_CC:
; A mesmerizing, mystic dance - each turn of it shimmers a different
; color as mind, spirit and speed all sharpen at once.
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_SWIRL
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SP_ATTACK
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_GLIMMER, 44, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 84, 96, $0
	anim_wait 14
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SP_DEFENSE
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 84, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 44, 96, $0
	anim_wait 14
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SPEED
	anim_sound 0, 0, SFX_TWINKLE
	anim_obj ANIM_OBJ_SWIRL_SHORT, 64, 88, $0
	anim_wait 20
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_GRAY
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 64, 88, $0
	anim_wait 20
	anim_ret

BattleAnim_StealthRock_CC:
; Jagged stones float up and drift across the field, then settle into
; the air on the foe's side... waiting.
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_SHINE
	anim_bgp $1b
	anim_sound 6, 2, SFX_STRENGTH
	anim_obj ANIM_OBJ_ANCIENTPOWER, 64, 108, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ANCIENTPOWER, 85, 97, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ANCIENTPOWER, 106, 87, $20
	anim_wait 4
	anim_obj ANIM_OBJ_ANCIENTPOWER, 126, 77, $20
	anim_wait 20
	anim_clearobjs
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 116, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 132, 40, $0
	anim_wait 6
	anim_obj ANIM_OBJ_STONE_EDGE_STILL, 148, 48, $0
	anim_wait 12
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 132, 44, $0
	anim_wait 24
	anim_ret

BattleAnim_Defog_CC:
; Fog blankets the field... then one great clearing gust scours the
; whole battlefield spotless.
	anim_3gfx ANIM_GFX_HAZE, ANIM_GFX_WIND, ANIM_GFX_WIND_BG
	anim_obp0 $fc
	anim_sound 0, 0, SFX_SURF
	anim_obj ANIM_OBJ_HAZE, 48, 56, $0
	anim_obj ANIM_OBJ_HAZE, 132, 16, $0
	anim_wait 24
	anim_clearobjs
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
	anim_loop 5, .loop
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 24
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 100, 48, $0
	anim_wait 16
	anim_resetobp0
	anim_ret

BattleAnim_BodyPress_CC:
; The user braces its whole armored bulk, then simply falls on the
; target - defense as offense, full weight behind it.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_SMOKE_PUFF
	anim_call BattleAnim_TargetObj_1Row_CC
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_wait 16
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 10
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 2
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_clearobjs
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $60, $2, $20
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 2
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 116, 62, $28
	anim_obj ANIM_OBJ_IMPACT_SMOKE, 156, 62, $38
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 124, 64, $0
	anim_obj ANIM_OBJ_HIT_YFIX, 144, 64, $0
	anim_wait 24
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_WorkUp_CC:
; The user psyches itself up - veins bulging, power lines streaming -
; until fighting spirit boils over.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_RED
	anim_4gfx ANIM_GFX_BULK_UP, ANIM_GFX_SHINE, ANIM_GFX_SPEED, ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_ANGER, 72, 80, $0
	anim_wait 12
	anim_obj ANIM_OBJ_BULK_UP, 64, 88, $0
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_FOCUS, 44, 108, $6
	anim_wait 3
	anim_obj ANIM_OBJ_FOCUS, 36, 108, $8
	anim_wait 3
	anim_obj ANIM_OBJ_FOCUS, 52, 108, $6
	anim_wait 14
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $1
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 48, 80, $0
	anim_obj ANIM_OBJ_GLIMMER, 80, 92, $0
	anim_wait 24
	anim_ret

BattleAnim_Superpower_CC:
; (mae-pokeorange) The user gathers glowing power lines, hurls itself
; forward, and the screen erupts under three colossal blows.
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_2Row_CC
	anim_bgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING, $0, $1, $20
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_FOCUS, 44, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 36, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 52, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 28, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 60, 108, $6
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 20, 108, $8
	anim_wait 2
	anim_obj ANIM_OBJ_FOCUS, 68, 108, $8
	anim_wait 2
	anim_loop 3, .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_CYCLE_MON_LIGHT_DARK_REPEATING
	anim_incbgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_SPARK
	anim_wait 16
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_clearobjs
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 1
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $60, $4, $10
.loop2
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 48, $0
	anim_wait 20
	anim_loop 3, .loop2
	anim_wait 16
	anim_ret

BattleAnim_FieryDance_CC:
; The user dances wreathed in whirling flame, fans it over the
; target - and draws its power back in with the final flourish.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_SHINE, ANIM_GFX_CHARGE
	anim_bgeffect ANIM_BG_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $4, $0
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 36, 88, $8
	anim_wait 8
	anim_obj ANIM_OBJ_RADIAL_FLAME_RED, 52, 88, $38
	anim_wait 8
	anim_obj ANIM_OBJ_GLIMMER, 44, 76, $0
	anim_wait 12
	anim_clearobjs
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  12, 0, $12
	anim_wait 4
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER,   8, 0,  10, 4, $13
	anim_wait 10
	anim_incobj 1
	anim_incobj 2
	anim_sound 0, 1, SFX_EMBER
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_EMBER,  15, 0,   8, 4, $30
	anim_obj ANIM_OBJ_EMBER, -16, 4,   8, 4, $30
	anim_wait 16
	; the dance draws power back to the user
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_MORNING_SUN, 16, 48, $88
	anim_wait 24
	anim_ret

BattleAnim_FoulPlay_CC:
; The user reads the foe's strength, mirrors it... and swings the
; target's own power back into its face.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DARK_PULSE
	anim_3gfx ANIM_GFX_STATUS, ANIM_GFX_TEAR, ANIM_GFX_HIT
	anim_bgp $1b
	; drink in the target's strength
	anim_sound 0, 0, SFX_PSYCHIC
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $0
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $20
	anim_wait 24
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_SCRATCH
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_CLAW_TEAR, 132, 48, $0
	anim_wait 10
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HIT_YFIX, 128, 60, $0
	anim_wait 20
	anim_ret

BattleAnim_RageFist_CC:
; Every blow the user has ever taken pours into one spectral fist -
; it swells, glows, and detonates against the target.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_SHADOW_BALL
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_GLOW_SHADOW, ANIM_GFX_STATUS
	anim_bgp $1b
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_ANGER, 72, 80, $0
	anim_obj ANIM_OBJ_GROWING_BALL, 64, 92, $0
	anim_wait 20
	anim_clearobjs
	anim_wait 1
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_PUNCH, 148, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_PUNCH, 122, 34, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_LONG_PUNCH, 136, 52, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 28
	anim_ret

BattleAnim_CrushClaw_CC:
; (mae-pokeorange) A triple raking slash, then the claws crush down.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GRAY
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_FIRE
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_TEAR
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 144, 48, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 140, 44, $0
	anim_obj ANIM_OBJ_CUT_DOWN_LEFT, 136, 40, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $30, $2, $0
	anim_obj ANIM_OBJ_CLAW_TEAR, 144, 48, $0
	anim_wait 64
	anim_call BattleAnim_ShowMon_1_CC
	anim_ret

BattleAnim_ForcePalm_CC:
; (mae-pokeorange) The open palm presses in, then detonates a spiked
; shockwave point-blank.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GRAY
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_PAYBACK
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_BIG_GLOW_SPIKED
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_obj ANIM_OBJ_PALM_STILL, 94, 48, $0
	anim_wait 32
	anim_clearobjs
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_obj ANIM_OBJ_FORCE_PALM, 94, 48, $0
	anim_wait 6
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_BIG_GLOW_SPIKED, 136, 48, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 2
	anim_clearobjs
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_obj ANIM_OBJ_PALM_STILL, 166, 48, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnim_HammerArm_CC:
; (mae-pokeorange) The hammering fist drops out of the sky and slams
; down in a burst of smoke.
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_GRAY
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_BRIGHT
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_SMOKE_PUFF
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_HAMMER_ARM, 136, 68, $30
	anim_wait 16
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

BattleAnim_CircleThrow_CC:
; A perfect judo grip - the foe is heaved skyward, spun in a wide
; arc, and hurled bodily out of the fight.
	anim_2gfx ANIM_GFX_GLOBE, ANIM_GFX_HIT
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
	; up and over
	anim_sound 0, 0, SFX_STRENGTH
	anim_obj ANIM_OBJ_SEISMIC_TOSS_UP, 132, 48, $30
	anim_wait 24
	anim_clearobjs
	anim_sound 0, 1, SFX_STOMP
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_Y, $30, $2, $20
	anim_obj ANIM_OBJ_SEISMIC_TOSS_DOWN, 132, 240, $10
	anim_wait 16
	anim_call BattleAnim_ShowMon_0_CC
	anim_ret

BattleAnim_FreezeDry_CC:
; Every drop of moisture is wicked out of the target, then flash-
; frozen around it in a single crackling instant.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_ICE
	anim_3gfx ANIM_GFX_WATER, ANIM_GFX_ICE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	; the moisture rises out of it
	anim_sound 0, 0, SFX_SURF
	anim_obj ANIM_OBJ_DROPLET_L, 126, 52, $28
	anim_obj ANIM_OBJ_DROPLET_R, 146, 52, $38
	anim_wait 12
	anim_obj ANIM_OBJ_DROPLET_L, 130, 44, $28
	anim_obj ANIM_OBJ_DROPLET_R, 142, 44, $38
	anim_wait 16
	anim_clearobjs
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $28
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $10
	anim_obj ANIM_OBJ_ICE_SPLASH, 136, 56, $9c
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 56, $0
	anim_wait 16
	anim_obj ANIM_OBJ_GLIMMER, 136, 44, $0
	anim_wait 20
	anim_ret

BattleAnim_Bounce_CC:
; (mae-pokeorange) Turn 1: the user springs high out of sight.
; Turn 2: it drops out of the sky onto the target.
	anim_if_param_equal $1, .turn1
	anim_if_param_equal $2, .miss
	anim_2gfx ANIM_GFX_U_TURN, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_KINESIS
	anim_obj ANIM_OBJ_U_TURN_FALL, 136, 230, $10
	anim_wait 16
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $4, $0
	anim_sound 0, 1, SFX_STOMP
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 56, $0
	anim_wait 16
.miss
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret
.turn1
	anim_1gfx ANIM_GFX_U_TURN
	anim_sound 0, 0, SFX_POTION
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_U_TURN_RISE, 48, 88, $30
	anim_wait 32
	anim_clearobjs
	anim_wait 1
	anim_ret

BattleAnim_DragonTail_CC:
; The user pivots into a full-bodied tail sweep that bats the foe
; clean off the field in a howl of wind.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_DRAGON_PULSE
	anim_4gfx ANIM_GFX_TRIANGLE, ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_WIND
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPINNING_TRIANGLE, 52, 84, $0
	anim_wait 12
	anim_clearobjs
	anim_sound 0, 1, SFX_CUT
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $10, $2, $0
	anim_obj ANIM_OBJ_CUT_HORIZONTAL, 112, 48, $0
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $20, $2, $0
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 136, 52, $0
	anim_wait 8
	; ...and out it goes
	anim_sound 0, 1, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 32
	anim_ret

BattleAnim_LuminaCrash_CC:
; (polishedcoral) The user gathers light, then a blinding starburst detonates
; on itself and again on the target, sparks flying outward each time.
	anim_setobjpal PAL_BATTLE_OB_GRAY, PAL_BTLCUSTOM_PSYCHO_BOOST_2
	anim_3gfx ANIM_GFX_LUMINA_CRASH, ANIM_GFX_SHINE, ANIM_GFX_CHARGE
	anim_bgeffect ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_sound 0, 0, SFX_PSYBEAM
	anim_obj ANIM_OBJ_POWER_GEM, 48, 96, $0
	anim_wait 16
	anim_clearobjs
	anim_obj ANIM_OBJ_LUMINA_CRASH, 48, 96, $0
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $0
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $28
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $30
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $38
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $20
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $8
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 48, 96, $4
	anim_wait 64
	anim_clearobjs
	anim_sound 0, 0, SFX_RAGE
	anim_obj ANIM_OBJ_GLIMMER, 48, 80, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_CYCLE_BGPALS_INVERTED, $0, $4, $0
	anim_sound 0, 0, SFX_BIND
	anim_bgeffect ANIM_BG_SHAKE_SCREEN_X, $14, $2, $0
	anim_obj ANIM_OBJ_LUMINA_CRASH, 136, 56, $0
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $0
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $28
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $30
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $38
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $20
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $8
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $18
	anim_wait 2
	anim_obj ANIM_OBJ_LUMINA_CRASH_TINY, 136, 56, $4
	anim_wait 64
	anim_ret

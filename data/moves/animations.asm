banim: MACRO
	dw \1
	db BANK(\1)
ENDM

; entries correspond to constants/move_constants.asm
; negative entries first (see the constants file for details)
	banim BattleAnim_InHail
	banim BattleAnim_ThrowPokeBall
	banim BattleAnim_SendOutMon
	banim BattleAnim_ReturnMon
	banim BattleAnim_Confused
	banim BattleAnim_Slp
	banim BattleAnim_Brn
	banim BattleAnim_Psn
	banim BattleAnim_Sap
	banim BattleAnim_Frz
	banim BattleAnim_Par
	banim BattleAnim_InLove
	banim BattleAnim_InSandstorm
	banim BattleAnim_InNightmare
	banim BattleAnim_InWhirlpool
	banim BattleAnim_Miss
	banim BattleAnim_EnemyDamage
	banim BattleAnim_EnemyStatDown
	banim BattleAnim_PlayerStatDown
	banim BattleAnim_PlayerDamage
	banim BattleAnim_Wobble
	banim BattleAnim_Shake
	banim BattleAnim_HitConfusion
BattleAnimations::
	banim BattleAnim_0
	banim BattleAnim_Pound
	banim BattleAnim_KarateChop
	banim BattleAnim_Doubleslap
	banim BattleAnim_CometPunch
	banim BattleAnim_MegaPunch
	banim BattleAnim_PayDay
	banim BattleAnim_FirePunch
	banim BattleAnim_IcePunch
	banim BattleAnim_Thunderpunch
	banim BattleAnim_Scratch
	banim BattleAnim_Vicegrip
	banim BattleAnim_Guillotine
	banim BattleAnim_RazorWind
	banim BattleAnim_SwordsDance
	banim BattleAnim_Cut
	banim BattleAnim_Gust
	banim BattleAnim_WingAttack
	banim BattleAnim_Whirlwind
	banim BattleAnim_Fly
	banim BattleAnim_Bind
	banim BattleAnim_Slam
	banim BattleAnim_VineWhip
	banim BattleAnim_Stomp
	banim BattleAnim_DoubleKick
	banim BattleAnim_MegaKick
	banim BattleAnim_JumpKick
	banim BattleAnim_RollingKick
	banim BattleAnim_SandAttack
	banim BattleAnim_Headbutt
	banim BattleAnim_HornAttack
	banim BattleAnim_FuryAttack
	banim BattleAnim_HornDrill
	banim BattleAnim_Tackle
	banim BattleAnim_BodySlam
	banim BattleAnim_Wrap
	banim BattleAnim_TakeDown
	banim BattleAnim_Thrash
	banim BattleAnim_DoubleEdge
	banim BattleAnim_TailWhip
	banim BattleAnim_PoisonSting
	banim BattleAnim_Twineedle
	banim BattleAnim_PinMissile
	banim BattleAnim_Leer
	banim BattleAnim_Bite
	banim BattleAnim_Growl
	banim BattleAnim_Roar
	banim BattleAnim_Sing
	banim BattleAnim_Supersonic
	banim BattleAnim_Sonicboom
	banim BattleAnim_Disable
	banim BattleAnim_Acid
	banim BattleAnim_Ember
	banim BattleAnim_Flamethrower
	banim BattleAnim_Mist
	banim BattleAnim_WaterGun
	banim BattleAnim_HydroPump
	banim BattleAnim_Surf
	banim BattleAnim_IceBeam
	banim BattleAnim_Blizzard
	banim BattleAnim_Psybeam
	banim BattleAnim_Bubblebeam
	banim BattleAnim_AuroraBeam
	banim BattleAnim_HyperBeam
	banim BattleAnim_Peck
	banim BattleAnim_DrillPeck
	banim BattleAnim_Submission
	banim BattleAnim_LowKick
	banim BattleAnim_Counter
	banim BattleAnim_SeismicToss
	banim BattleAnim_Strength
	banim BattleAnim_Absorb
	banim BattleAnim_MegaDrain
	banim BattleAnim_LeechSeed
	banim BattleAnim_Growth
	banim BattleAnim_RazorLeaf
	banim BattleAnim_Solarbeam
	banim BattleAnim_Poisonpowder
	banim BattleAnim_StunSpore
	banim BattleAnim_SleepPowder
	banim BattleAnim_PetalDance
	banim BattleAnim_StringShot
	banim BattleAnim_DragonRage
	banim BattleAnim_FireSpin
	banim BattleAnim_Thundershock
	banim BattleAnim_Thunderbolt
	banim BattleAnim_ThunderWave
	banim BattleAnim_Thunder
	banim BattleAnim_RockThrow
	banim BattleAnim_Earthquake
	banim BattleAnim_Fissure
	banim BattleAnim_Dig
	banim BattleAnim_Toxic
	banim BattleAnim_Confusion
	banim BattleAnim_PsychicM
	banim BattleAnim_Hypnosis
	banim BattleAnim_Meditate
	banim BattleAnim_Agility
	banim BattleAnim_QuickAttack
	banim BattleAnim_Rage
	banim BattleAnim_Teleport
	banim BattleAnim_NightShade
	banim BattleAnim_Mimic
	banim BattleAnim_Screech
	banim BattleAnim_DoubleTeam
	banim BattleAnim_Recover
	banim BattleAnim_Harden
	banim BattleAnim_Minimize
	banim BattleAnim_Smokescreen
	banim BattleAnim_ConfuseRay
	banim BattleAnim_Withdraw
	banim BattleAnim_DefenseCurl
	banim BattleAnim_Barrier
	banim BattleAnim_LightScreen
	banim BattleAnim_Haze
	banim BattleAnim_Reflect
	banim BattleAnim_FocusEnergy
	banim BattleAnim_Bide
	banim BattleAnim_Metronome
	banim BattleAnim_MirrorMove
	banim BattleAnim_Selfdestruct
	banim BattleAnim_EggBomb
	banim BattleAnim_Lick
	banim BattleAnim_Smog
	banim BattleAnim_Sludge
	banim BattleAnim_BoneClub
	banim BattleAnim_FireBlast
	banim BattleAnim_Waterfall
	banim BattleAnim_Clamp
	banim BattleAnim_Swift
	banim BattleAnim_SkullBash
	banim BattleAnim_SpikeCannon
	banim BattleAnim_Constrict
	banim BattleAnim_Amnesia
	banim BattleAnim_Kinesis
	banim BattleAnim_Softboiled
	banim BattleAnim_HiJumpKick
	banim BattleAnim_Glare
	banim BattleAnim_DreamEater
	banim BattleAnim_PoisonGas
	banim BattleAnim_Barrage
	banim BattleAnim_LeechLife
	banim BattleAnim_LovelyKiss
	banim BattleAnim_SkyAttack
	banim BattleAnim_Transform
	banim BattleAnim_Bubble
	banim BattleAnim_DizzyPunch
	banim BattleAnim_Spore
	banim BattleAnim_Flash
	banim BattleAnim_Psywave
	banim BattleAnim_Splash
	banim BattleAnim_AcidArmor
	banim BattleAnim_Crabhammer
	banim BattleAnim_Explosion
	banim BattleAnim_FurySwipes
	banim BattleAnim_Bonemerang
	banim BattleAnim_Rest
	banim BattleAnim_RockSlide
	banim BattleAnim_HyperFang
	banim BattleAnim_Sharpen
	banim BattleAnim_Conversion
	banim BattleAnim_TriAttack
	banim BattleAnim_SuperFang
	banim BattleAnim_Slash
	banim BattleAnim_Substitute
	banim BattleAnim_Struggle
	banim BattleAnim_Sketch
	banim BattleAnim_TripleKick
	banim BattleAnim_Thief
	banim BattleAnim_SpiderWeb
	banim BattleAnim_MindReader
	banim BattleAnim_Nightmare
	banim BattleAnim_FlameWheel
	banim BattleAnim_Snore
	banim BattleAnim_Curse
	banim BattleAnim_Flail
	banim BattleAnim_Conversion2
	banim BattleAnim_Aeroblast
	banim BattleAnim_CottonSpore
	banim BattleAnim_Reversal
	banim BattleAnim_Spite
	banim BattleAnim_PowderSnow
	banim BattleAnim_Protect
	banim BattleAnim_MachPunch
	banim BattleAnim_ScaryFace
	banim BattleAnim_FaintAttack
	banim BattleAnim_SweetKiss
	banim BattleAnim_BellyDrum
	banim BattleAnim_SludgeBomb
	banim BattleAnim_MudSlap
	banim BattleAnim_Octazooka
	banim BattleAnim_Spikes
	banim BattleAnim_ZapCannon
	banim BattleAnim_Foresight
	banim BattleAnim_DestinyBond
	banim BattleAnim_PerishSong
	banim BattleAnim_IcyWind
	banim BattleAnim_Detect
	banim BattleAnim_BoneRush
	banim BattleAnim_LockOn
	banim BattleAnim_Outrage
	banim BattleAnim_Sandstorm
	banim BattleAnim_GigaDrain
	banim BattleAnim_Endure
	banim BattleAnim_Charm
	banim BattleAnim_Rollout
	banim BattleAnim_FalseSwipe
	banim BattleAnim_Swagger
	banim BattleAnim_MilkDrink
	banim BattleAnim_Spark
	banim BattleAnim_FuryCutter
	banim BattleAnim_SteelWing
	banim BattleAnim_MeanLook
	banim BattleAnim_Attract
	banim BattleAnim_SleepTalk
	banim BattleAnim_HealBell
	banim BattleAnim_Return
	banim BattleAnim_Present
	banim BattleAnim_Frustration
	banim BattleAnim_Safeguard
	banim BattleAnim_PainSplit
	banim BattleAnim_SacredFire
	banim BattleAnim_Magnitude
	banim BattleAnim_Dynamicpunch
	banim BattleAnim_Megahorn
	banim BattleAnim_Dragonbreath
	banim BattleAnim_BatonPass
	banim BattleAnim_Encore
	banim BattleAnim_Pursuit
	banim BattleAnim_RapidSpin
	banim BattleAnim_SweetScent
	banim BattleAnim_IronTail
	banim BattleAnim_MetalClaw
	banim BattleAnim_VitalThrow
	banim BattleAnim_MorningSun
	banim BattleAnim_Synthesis
	banim BattleAnim_Moonlight
	banim BattleAnim_HiddenPower
	banim BattleAnim_CrossChop
	banim BattleAnim_Twister
	banim BattleAnim_RainDance
	banim BattleAnim_SunnyDay
	banim BattleAnim_Crunch
	banim BattleAnim_MirrorCoat
	banim BattleAnim_PsychUp
	banim BattleAnim_Extremespeed
	banim BattleAnim_Ancientpower
	banim BattleAnim_ShadowBall
	banim BattleAnim_FutureSight
	banim BattleAnim_RockSmash
	banim BattleAnim_Whirlpool
	banim BattleAnim_BeatUp
	banim BattleAnim_GigaHammer
	banim BattleAnim_DazzlingGleam
	banim BattleAnim_DisarmingVoice
	banim BattleAnim_DrainingKiss
	banim BattleAnim_PlayRough
	banim BattleAnim_SpiritBreak
	banim BattleAnim_FairyWind
	banim BattleAnim_SuckerPunch
	banim BattleAnim_DarkPulse
	banim BattleAnim_FireFang
	banim BattleAnim_IceFang
	banim BattleAnim_ThunderFang
	banim BattleAnim_AquaJet
	banim BattleAnim_WildCharge
	banim BattleAnim_BitterBlade
	banim BattleAnim_HeatCrash
	banim BattleAnim_IceShard
	banim BattleAnim_TripleAxel
	banim BattleAnim_IcicleCrash
	banim BattleAnim_StruggleBug
	banim BattleAnim_Infestation
	banim BattleAnim_BugBuzz
	banim BattleAnim_Accelrock
	banim BattleAnim_StoneEdge
	banim BattleAnim_AirSlash
	banim BattleAnim_PoisonFang
	banim BattleAnim_Venoshock
	banim BattleAnim_Hail
	banim BattleAnim_LeafBlade
	banim BattleAnim_ShadowSneak
	banim BattleAnim_ShadowPunch
	banim BattleAnim_ShadowClaw
	banim BattleAnim_PoisonJab
	banim BattleAnim_Lunge
	banim BattleAnim_BugBite
	banim BattleAnim_XScissor
	banim BattleAnim_UTurn
	banim BattleAnim_DragonClaw
	banim BattleAnim_DracoMeteor
	banim BattleAnim_Moonblast
	banim BattleAnim_PixiePunch
	banim BattleAnim_BloodMoon
	banim BattleAnim_BulletPunch
	banim BattleAnim_DrainPunch
	banim BattleAnim_SolarBlade
	banim BattleAnim_CloseCombat
	banim BattleAnim_Acrobatics ; ACROBATICS
	banim BattleAnim_AerialAce ; AERIAL_ACE
	banim BattleAnim_AquaTail ; AQUA_TAIL
	banim BattleAnim_Astonish ; ASTONISH
	banim BattleAnim_AuraSphere ; AURA_SPHERE
	banim BattleAnim_Avalanche ; AVALANCHE
	banim BattleAnim_BraveBird ; BRAVE_BIRD
	banim BattleAnim_BulkUp ; BULK_UP
	banim BattleAnim_Bulldoze ; BULLDOZE
	banim BattleAnim_CalmMind ; CALM_MIND
	banim BattleAnim_DragonDance ; DRAGON_DANCE
	banim BattleAnim_DragonPulse ; DRAGON_PULSE
	banim BattleAnim_EarthPower ; EARTH_POWER
	banim BattleAnim_EnergyBall ; ENERGY_BALL
	banim BattleAnim_Extrasensory ; EXTRASENSORY
	banim BattleAnim_Facade ; FACADE
	banim BattleAnim_FlameCharge ; FLAME_CHARGE
	banim BattleAnim_FlareBlitz ; FLARE_BLITZ
	banim BattleAnim_FlashCannon ; FLASH_CANNON
	banim BattleAnim_FocusBlast ; FOCUS_BLAST
	banim BattleAnim_GigaImpact ; GIGA_IMPACT
	banim BattleAnim_GunkShot ; GUNK_SHOT
	banim BattleAnim_GyroBall ; GYRO_BALL
	banim BattleAnim_Hex ; HEX
	banim BattleAnim_HoneClaws ; HONE_CLAWS
	banim BattleAnim_Hurricane ; HURRICANE
	banim BattleAnim_HyperVoice ; HYPER_VOICE
	banim BattleAnim_IcicleSpear ; ICICLE_SPEAR
	banim BattleAnim_IronHead ; IRON_HEAD
	banim BattleAnim_KnockOff ; KNOCK_OFF
	banim BattleAnim_NastyPlot ; NASTY_PLOT
	banim BattleAnim_NightSlash ; NIGHT_SLASH
	banim BattleAnim_PowerGem ; POWER_GEM
	banim BattleAnim_PowerWhip ; POWER_WHIP
	banim BattleAnim_Psystrike ; PSYSTRIKE
	banim BattleAnim_RockBlast ; ROCK_BLAST
	banim BattleAnim_Roost ; ROOST
	banim BattleAnim_Scald ; SCALD
	banim BattleAnim_SeedBomb ; SEED_BOMB
	banim BattleAnim_ShellSmash ; SHELL_SMASH
	banim BattleAnim_SkillSwap ; SKILL_SWAP
	banim BattleAnim_ToxicSpikes ; TOXIC_SPIKES
	banim BattleAnim_Trick ; TRICK
	banim BattleAnim_TrickRoom ; TRICK_ROOM
	banim BattleAnim_VoltSwitch ; VOLT_SWITCH
	banim BattleAnim_WaterPulse ; WATER_PULSE
	banim BattleAnim_WillOWisp ; WILL_O_WISP
	banim BattleAnim_ZenHeadbutt ; ZEN_HEADBUTT
	banim BattleAnim_HiJumpKick ; TROP_KICK
	banim BattleAnim_MortalSpin ; MORTAL_SPIN
	banim BattleAnim_SweetScent2
	banim BattleAnim_StatUp
	banim BattleAnim_StatDown

BattleAnim_0:
BattleAnim_MirrorMove:
	anim_ret

BattleAnim_GigaHammer:
; Steel charge-up (same reflect / shine / harden sequence as Metal Claw),
; then heavy rocks and deep impact hits on the target.
; No anim_bgp / FLASH_INVERTED here: those fight the player palette and draw a
; bright frame around the backpic during the "dark" beat.
	anim_3gfx ANIM_GFX_REFLECT, ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_MetalClaw_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_wait 16
	anim_sound 0, 1, SFX_OUTRAGE
	anim_wait 28
	anim_bgeffect ANIM_BG_1F, $e0, $2, $0
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
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_0A, 136, 48, $43
	anim_wait 8
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_04, 140, 40, $0
	anim_obj ANIM_OBJ_05, 132, 52, $0
	anim_obj ANIM_OBJ_00, 128, 44, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_03, 144, 48, $0
	anim_obj ANIM_OBJ_04, 136, 36, $0
	anim_wait 10
	anim_sound 0, 1, SFX_STRENGTH
	anim_wait 14
	anim_incbgeffect ANIM_BG_26
	anim_wait 8
	anim_incbgeffect ANIM_BG_1F
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_resetobp0
	anim_ret

BattleAnim_DazzlingGleam:
; Bright pastel fairy flash washing across the battlefield
	anim_3gfx ANIM_GFX_SHINE, ANIM_GFX_BEAM, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_MOONLIGHT, 32, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 48, 84, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 64, 96, $0
	anim_wait 16
	anim_call BattleAnim_AuroraBeam_branch_cbb39
	anim_wait 16
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 128, 48, $10
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 144, 64, $18
	anim_wait 24
	anim_ret

BattleAnim_DisarmingVoice:
; Rings of sound then unavoidable fairy-colored sparks striking the foe
	anim_3gfx ANIM_GFX_NOISE, ANIM_GFX_OBJECTS, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_SUPERSONIC
.loop1
	anim_call BattleAnim_Growl_branch_cbbbc
	anim_wait 12
	anim_loop 3, .loop1
	anim_sound 6, 2, SFX_METRONOME
	anim_obj ANIM_OBJ_SWIFT, 64, 88, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SWIFT, 72, 80, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SWIFT, 56, 76, $4
	anim_wait 48
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_01, 128, 52, $8
	anim_wait 16
	anim_ret

BattleAnim_DrainingKiss:
; Kiss motif then pink healing streams like Giga Drain
	anim_3gfx ANIM_GFX_OBJECTS, ANIM_GFX_CHARGE, ANIM_GFX_ANGELS
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_SWEET_KISS, 96, 40, $0
	anim_sound 0, 1, SFX_SWEET_KISS
	anim_wait 32
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1C, $0, $0, $10
	anim_setvar $0
.loop
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 6
	anim_incvar
	anim_if_var_equal $5, .done
	anim_jump .loop

.done
	anim_wait 24
	anim_incbgeffect ANIM_BG_1C
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_PlayRough:
; Bouncy flurry of hits + shine/glimmer (3 gfx only)
	anim_3gfx ANIM_GFX_HIT, ANIM_GFX_SPEED, ANIM_GFX_SHINE
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_BOUNCE_DOWN, $0, $1, $0
	anim_wait 28
	anim_incbgeffect ANIM_BG_BOUNCE_DOWN
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_08, 136, 48, $0
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_MOONLIGHT, 132, 52, $0
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 128, 48, $0
	anim_wait 5
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 132, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 140, 52, $0
	anim_wait 4
.loop
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 132, 44, $0
	anim_wait 3
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 140, 52, $0
	anim_wait 3
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_01, 128, 56, $10
	anim_wait 3
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_MOONLIGHT, 136, 48, $0
	anim_wait 3
	anim_loop 3, .loop
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_08, 134, 50, $0
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 136, 46, $0
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_MOONLIGHT, 124, 54, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_01, 136, 50, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_04, 138, 46, $0
	anim_wait 10
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_SpiritBreak:
; Psychic shockwave then crushing bite-like strike (spirit shattered)
	anim_3gfx ANIM_GFX_PSYCHIC, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 80, 88, $2
	anim_wait 8
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 72, 92, $2
	anim_wait 8
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 88, 84, $2
	anim_wait 32
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_BITE, 136, 56, $a8
	anim_obj ANIM_OBJ_BITE, 136, 56, $28
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_00, 136, 52, $18
	anim_wait 16
	anim_ret

BattleAnim_FairyWind:
; Sparkling gust like Gust but with fairy shimmer
	anim_3gfx ANIM_GFX_WIND, ANIM_GFX_SHINE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
.loop
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 4
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_MOONLIGHT, 112, 68, $0
	anim_wait 4
	anim_loop 8, .loop
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_01, 128, 48, $18
	anim_wait 16
	anim_ret

BattleAnim_FireFang:
; Bite with embers (same element branch as Fire Punch)
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 8
	anim_call BattleAnim_FirePunch_branch_cbbcc
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 16
	anim_ret

BattleAnim_IceFang:
; Bite with ice sparkles (same branch as Ice Punch)
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_ICE
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 8
	anim_call BattleAnim_IcePunch_branch_cbbdf
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 16
	anim_ret

BattleAnim_ThunderFang:
; Bite with a lightning flash on the foe
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_HIT, ANIM_GFX_LIGHTNING
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 152, 68, $0
	anim_wait 20
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 16
	anim_ret

BattleAnim_PoisonFang:
; Fang bites + bubbling venom (branch shared with Toxic intro)
	anim_purplepal
	anim_3gfx ANIM_GFX_CUT, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 6
	anim_call BattleAnim_Toxic_branch_cbc35
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 136, 62, $0
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 16
	anim_ret

BattleAnim_Venoshock:
; Special poison blast — Sludge-style surge into impact
	anim_purplepal
	anim_2gfx ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_TOXIC
	anim_call BattleAnim_Sludge_branch_cbc15
	anim_wait 56
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_AquaJet:
; Quick Attack-style dash with water bursts on impact (3 gfx)
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_WATER, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_GUN, 96, 84, $0
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_GUN, 124, 68, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_WildCharge:
; Spark's flow (charge + tackle into bolt), then extra flashes, bolts, and hits
	anim_3gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_obj ANIM_OBJ_THUNDER_WAVE, 48, 92, $0
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_THUNDER_WAVE, 40, 96, $0
	anim_wait 20
	anim_setobj $1, $3
	anim_wait 1
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_wait 14
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_incobj 2
	anim_wait 1
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_obj ANIM_OBJ_33, 136, 56, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 52, $0
	anim_wait 5
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 128, 54, $2
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 144, 48, $10
	anim_wait 5
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_33, 132, 58, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 44, $8
	anim_wait 5
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 148, 64, $0
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 24
	anim_ret

BattleAnim_BitterBlade:
; Quick Attack–style vanish, slashes + foot embers + hit, user returns
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_FIRE
	anim_bgp $1b
	anim_obp0 $c0
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 6
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 144, 36, $0
	anim_wait 10
; Ember-like cascade along the bottom (same layout as BattleAnim_Ember on foe)
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 120, 68, $30
	anim_obj ANIM_OBJ_EMBER, 132, 68, $30
	anim_obj ANIM_OBJ_EMBER, 144, 68, $30
	anim_wait 10
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 114, 72, $30
	anim_obj ANIM_OBJ_EMBER, 126, 74, $30
	anim_obj ANIM_OBJ_EMBER, 138, 72, $30
	anim_wait 10
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_EMBER, 120, 76, $30
	anim_obj ANIM_OBJ_EMBER, 132, 76, $30
	anim_obj ANIM_OBJ_EMBER, 144, 76, $30
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 50, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 12
	anim_resetobp0
	anim_ret

BattleAnim_HeatCrash:
; Flame Wheel–style charge, then slam + burst (heavy Fire physical)
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_EXPLOSION, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 48, 96, $0
	anim_wait 4
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 56, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 52, 100, $0
	anim_wait 8
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_EMBER
	anim_wait 10
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_17, 136, 48, $0
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_01, 136, 52, $0
	anim_wait 16
	anim_ret

BattleAnim_IceShard:
; Aqua Jet timing but ice shards instead of water
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_ICE, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_BEAM, 96, 88, $4
	anim_wait 4
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_12, 104, 80, $0
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_TripleAxel:
; Hits 1-2: icy kick. Hit 3: icy kick with the Ice Punch burst.
	anim_2gfx ANIM_GFX_ICE, ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_TripleAxel_branch_a
	anim_if_param_equal $2, BattleAnim_TripleAxel_branch_b
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_wait 6
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_12, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_TripleAxel_branch_a:
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_wait 6
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_12, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_TripleAxel_branch_b:
; Final hit: kick, then full Ice Punch ice burst, then slam.
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_wait 8
	anim_call BattleAnim_IcePunch_branch_cbbdf
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_IcicleCrash:
; Screen shake + dense icicle barrage, ram, multi-hit slab impact (heavy Ice physical)
	anim_3gfx ANIM_GFX_ICE, ANIM_GFX_EXPLOSION, ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1F, $e0, $2, $0
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 64, 88, $63
	anim_obj ANIM_OBJ_BLIZZARD, 72, 84, $64
	anim_obj ANIM_OBJ_BLIZZARD, 56, 92, $63
	anim_wait 10
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 68, 80, $64
	anim_obj ANIM_OBJ_BLIZZARD, 60, 96, $63
	anim_wait 10
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 76, 88, $63
	anim_obj ANIM_OBJ_BLIZZARD, 52, 86, $64
	anim_wait 12
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BLIZZARD, 132, 40, $63
	anim_obj ANIM_OBJ_BLIZZARD, 140, 44, $64
	anim_wait 14
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_STRENGTH
	anim_wait 18
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 136, 48, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 50, $0
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_01, 128, 48, $18
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 142, 54, $10
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 74, $10
	anim_obj ANIM_OBJ_BLIZZARD, 136, 52, $63
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_BLIZZARD, 130, 56, $64
	anim_wait 20
	anim_incbgeffect ANIM_BG_1F
	anim_ret

BattleAnim_StruggleBug:
; Powder cloud rush + tremor, light finish hit (weak Bug special)
	anim_3gfx ANIM_GFX_POWDER, ANIM_GFX_NOISE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 96, 84, $11
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 104, 80, $13
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 112, 76, $14
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 120, 72, $12
	anim_wait 12
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Infestation:
; Silk crawl + poison spatter + nibble hits (no ANIM_BG_07 — avoids Spider Web freeze)
	anim_3gfx ANIM_GFX_WEB, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 6, 2, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 80, $0
	anim_wait 3
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 88, $0
	anim_wait 3
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 84, $0
	anim_wait 3
	anim_sound 6, 2, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_STRING_SHOT, 72, 82, $0
	anim_wait 3
	anim_obj ANIM_OBJ_STRING_SHOT, 72, 90, $0
	anim_wait 6
	anim_sound 6, 2, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_SPIDER_WEB, 132, 50, $0
	anim_wait 10
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 128, 68, $0
	anim_wait 5
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 144, 62, $0
	anim_wait 5
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 136, 74, $0
	anim_wait 8
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 132, 48, $10
	anim_wait 14
	anim_ret

BattleAnim_BugBuzz:
; Resonance waves + buzz tones on foe (Bug Buzz – SPCL.DEF drop)
	anim_3gfx ANIM_GFX_PSYCHIC, ANIM_GFX_NOISE, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
.loop_waves
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 5
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE, 72, 86, $2
	anim_wait 5
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_4B, 56, 76, $0
	anim_wait 5
	anim_loop 3, .loop_waves
	anim_wait 12
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_01, 130, 52, $10
	anim_wait 20
	anim_resetobp0
	anim_ret

BattleAnim_Accelrock:
; Priority dash like Aqua Jet, stone shards on impact
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 104, 80, $35
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 96, 76, $40
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_StoneEdge:
; Screen shake + volley of sharp rocks, heavy burst (Stone Edge)
	anim_3gfx ANIM_GFX_ROCKS, ANIM_GFX_EXPLOSION, ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1F, $e0, $2, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 120, 68, $30
	anim_obj ANIM_OBJ_BIG_ROCK, 132, 56, $48
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 144, 64, $38
	anim_obj ANIM_OBJ_BIG_ROCK, 128, 52, $40
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 136, 48, $42
	anim_wait 10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 136, 48, $0
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 52, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_01, 130, 48, $18
	anim_wait 16
	anim_incbgeffect ANIM_BG_1F
	anim_ret

BattleAnim_AirSlash:
; Gust shear + twin slashes (special Flying)
	anim_3gfx ANIM_GFX_WIND, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 6
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 148, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 140, 38, $0
	anim_wait 8
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 124, 68, $0
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 54, $0
	anim_wait 16
	anim_ret

BattleAnim_SweetScent2:
	anim_2gfx ANIM_GFX_FLOWER, ANIM_GFX_MISC
	anim_obj ANIM_OBJ_FLOWER, 64, 96, $2
	anim_wait 2
	anim_obj ANIM_OBJ_FLOWER, 64, 80, $2
	anim_wait 64
	anim_obj ANIM_OBJ_COTTON, 136, 40, $15
	anim_obj ANIM_OBJ_COTTON, 136, 40, $2a
	anim_obj ANIM_OBJ_COTTON, 136, 40, $3f
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_wait 128
	anim_ret

BattleAnim_ThrowPokeBall:
	anim_if_param_equal NO_ITEM, .TheTrainerBlockedTheBall
	anim_if_param_equal MASTER_BALL, .MasterBall
	anim_if_param_equal ULTRA_BALL, .UltraBall
	anim_if_param_equal GREAT_BALL, .GreatBall
	; any other ball
	anim_2gfx ANIM_GFX_POKE_BALL, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.TheTrainerBlockedTheBall:
	anim_2gfx ANIM_GFX_POKE_BALL, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_POKE_BALL_BLOCKED, 64, 92, $20
	anim_wait 20
	anim_obj ANIM_OBJ_01, 112, 40, $0
	anim_wait 32
	anim_ret

.UltraBall:
	anim_2gfx ANIM_GFX_POKE_BALL, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.GreatBall:
	anim_2gfx ANIM_GFX_POKE_BALL, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.MasterBall:
	anim_3gfx ANIM_GFX_POKE_BALL, ANIM_GFX_SMOKE, ANIM_GFX_SPEED
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_POKE_BALL, 64, 92, $20
	anim_wait 36
	anim_obj ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 24
	anim_sound 0, 1, SFX_MASTER_BALL
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $30
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $31
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $32
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $33
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $34
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $35
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $36
	anim_obj ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $37
	anim_wait 64
.Shake:
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $0, $0
	anim_wait 8
	anim_incobj 2
	anim_wait 16
	anim_sound 0, 1, SFX_CHANGE_DEX_MODE
	anim_incobj 1
	anim_wait 32
	anim_sound 0, 1, SFX_BALL_BOUNCE
	anim_wait 32
	anim_wait 32
	anim_wait 32
	anim_wait 8
	anim_setvar $0
.Loop:
	anim_wait 48
	anim_checkpokeball
	anim_if_var_equal $1, .Click
	anim_if_var_equal $2, .BreakFree
	anim_incobj 1
	anim_sound 0, 1, SFX_BALL_WOBBLE
	anim_jump .Loop

.Click:
	anim_keepsprites
	anim_ret

.BreakFree:
	anim_setobj $1, $b
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 2
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $0, $0
	anim_wait 32
	anim_ret

BattleAnim_SendOutMon:
	anim_if_param_equal $0, .Normal
	anim_if_param_equal $1, .Shiny
	anim_if_param_equal $2, .Unknown
	anim_1gfx ANIM_GFX_SMOKE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_2B, $0, $1, $0
	anim_sound 0, 0, SFX_BALL_POOF
	anim_obj ANIM_OBJ_1B, 48, 96, $0
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_wait 128
	anim_wait 4
	anim_call BattleAnim_ShowMon_0
	anim_ret

.Unknown:
	anim_1gfx ANIM_GFX_SMOKE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_2A, $0, $1, $0
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_sound 0, 0, SFX_BALL_POOF
	anim_obj ANIM_OBJ_1B, 48, 96, $0
	anim_incbgeffect ANIM_BG_2A
	anim_wait 96
	anim_incbgeffect ANIM_BG_2A
	anim_call BattleAnim_ShowMon_0
	anim_ret

.Shiny:
	anim_1gfx ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $0
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $8
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $10
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $18
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $20
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $28
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $30
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SHINY, 48, 96, $38
	anim_wait 32
	anim_ret

.Normal:
	anim_2gfx ANIM_GFX_POKE_BALL, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_SEND_OUT_POKE_BALL, 16, 110, $0
	anim_wait 14
	anim_setobj $1, $b
	anim_sound 0, 0, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 44, 96, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_ReturnMon:
	anim_sound 0, 0, SFX_BALL_POOF
BattleAnim_BatonPass_branch_c9486:
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Confused:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_KINESIS
	anim_obj ANIM_OBJ_CHICK, 44, 56, $15
	anim_obj ANIM_OBJ_CHICK, 44, 56, $aa
	anim_obj ANIM_OBJ_CHICK, 44, 56, $bf
	anim_wait 96
	anim_ret

BattleAnim_Slp:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_TAIL_WHIP
.loop
	anim_obj ANIM_OBJ_ASLEEP, 64, 80, $0
	anim_wait 40
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_Brn:
	anim_1gfx ANIM_GFX_FIRE
.loop
	anim_sound 0, 0, SFX_BURN
	anim_obj ANIM_OBJ_BURNED, 56, 88, $10
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 6
	anim_ret

BattleAnim_Psn:
	anim_1gfx ANIM_GFX_POISON
	anim_sound 0, 0, SFX_POISON
	anim_obj ANIM_OBJ_SKULL, 64, 56, $0
	anim_wait 8
	anim_sound 0, 0, SFX_POISON
	anim_obj ANIM_OBJ_SKULL, 48, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_Sap:
	anim_1gfx ANIM_GFX_CHARGE
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 16
	anim_ret

BattleAnim_Frz:
	anim_1gfx ANIM_GFX_ICE
	anim_obj ANIM_OBJ_FROZEN, 44, 110, $0
	anim_sound 0, 0, SFX_SHINE
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_wait 16
	anim_ret

BattleAnim_Par:
	anim_1gfx ANIM_GFX_STATUS
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_PARALYZED, 20, 88, $42
	anim_obj ANIM_OBJ_PARALYZED, 76, 88, $c2
	anim_wait 128
	anim_ret

BattleAnim_InLove:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_HEART, 64, 76, $0
	anim_wait 32
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_HEART, 36, 72, $0
	anim_wait 32
	anim_ret

BattleAnim_InSandstorm:
	anim_1gfx ANIM_GFX_POWDER
	anim_obj ANIM_OBJ_SANDSTORM, 88, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM, 72, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_SANDSTORM, 56, 0, $2
.loop
	anim_sound 0, 1, SFX_MENU
	anim_wait 8
	anim_loop 6, .loop
	anim_wait 8
	anim_ret

BattleAnim_Hail:
BattleAnim_InHail:
	anim_1gfx ANIM_GFX_ICE
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_obj ANIM_OBJ_HAIL, 88, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HAIL, 72, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_HAIL, 56, 0, $2
.loop
	anim_sound 0, 1, SFX_SHINE
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 8
	anim_ret

BattleAnim_InNightmare:
	anim_1gfx ANIM_GFX_ANGELS
	anim_sound 0, 0, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_IN_NIGHTMARE, 68, 80, $0
	anim_wait 40
	anim_ret

BattleAnim_InWhirlpool:
	anim_1gfx ANIM_GFX_WIND
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 1, SFX_SURF
.loop
	anim_obj ANIM_OBJ_GUST, 132, 72, $0
	anim_wait 6
	anim_loop 6, .loop
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_wait 1
	anim_ret

BattleAnim_HitConfusion:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_POUND
	anim_obj ANIM_OBJ_04, 44, 96, $0
	anim_wait 16
	anim_ret

BattleAnim_Miss:
	anim_ret

BattleAnim_EnemyDamage:
.loop
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $0, $0
	anim_wait 5
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_loop 3, .loop
	anim_ret

BattleAnim_EnemyStatDown:
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_wait 40
	anim_call BattleAnim_ShowMon_1
	anim_wait 1
	anim_ret

BattleAnim_PlayerStatDown:
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_WOBBLE_PLAYER, $0, $0, $0
	anim_wait 40
	anim_call BattleAnim_ShowMon_1
	anim_wait 1
	anim_ret

BattleAnim_PlayerDamage:
	anim_bgeffect ANIM_BG_20, $20, $2, $20
	anim_wait 40
	anim_ret

BattleAnim_Wobble:
	anim_bgeffect ANIM_BG_35, $0, $0, $0
	anim_wait 40
	anim_ret

BattleAnim_Shake:
	anim_bgeffect ANIM_BG_1F, $20, $2, $40
	anim_wait 40
	anim_ret

BattleAnim_Pound:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_08, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_KarateChop:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_08, 136, 40, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 40, $0
	anim_wait 6
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_08, 136, 44, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_KARATE_CHOP
	anim_obj ANIM_OBJ_08, 136, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_Doubleslap:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_Doubleslap_branch_c961b
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_08, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_Doubleslap_branch_c961b:
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_08, 120, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 120, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_CometPunch:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_CometPunch_branch_c9641
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_06, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_CometPunch_branch_c9641:
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_06, 120, 64, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 120, 64, $0
	anim_wait 8
	anim_ret

BattleAnim_Bide_branch_c9651:
BattleAnim_MegaPunch:
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

BattleAnim_Stomp:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_STOMP
	anim_obj ANIM_OBJ_07, 136, 40, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 40, $0
	anim_wait 6
	anim_sound 0, 1, SFX_STOMP
	anim_obj ANIM_OBJ_07, 136, 44, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 44, $0
	anim_wait 6
	anim_sound 0, 1, SFX_STOMP
	anim_obj ANIM_OBJ_07, 136, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_DoubleKick:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_DoubleKick_branch_c96bd
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_DoubleKick_branch_c96bd:
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 120, 64, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 120, 64, $0
	anim_wait 8
	anim_ret

BattleAnim_JumpKick:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_JumpKick_branch_c96f1
	anim_sound 0, 1, SFX_JUMP_KICK
	anim_obj ANIM_OBJ_07, 112, 72, $0
	anim_obj ANIM_OBJ_07, 100, 60, $0
	anim_setobj $1, $2
	anim_setobj $2, $2
	anim_wait 24
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_04, 136, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_JumpKick_branch_c96f1:
	anim_wait 8
	anim_sound 0, 0, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_04, 44, 88, $0
	anim_wait 16
	anim_ret

BattleAnim_HiJumpKick:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_if_param_equal $1, BattleAnim_HiJumpKick_branch_c971e
	anim_wait 32
	anim_sound 0, 1, SFX_JUMP_KICK
	anim_obj ANIM_OBJ_07, 112, 72, $0
	anim_setobj $1, $2
	anim_wait 16
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_04, 136, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_HiJumpKick_branch_c971e:
	anim_wait 16
	anim_sound 0, 0, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_04, 44, 88, $0
	anim_wait 16
	anim_ret

BattleAnim_RollingKick:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 112, 56, $0
	anim_setobj $1, $3
	anim_wait 12
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_MegaKick:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_wait 67
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
.loop
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_07, 136, 56, $0
	anim_wait 6
	anim_loop 3, .loop
	anim_ret

BattleAnim_HyperFang:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $20, $1, $0
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_FANG, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_SuperFang:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_wait 48
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
.loop
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_FANG, 136, 56, $0
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_FANG, 136, 56, $0
	anim_wait 6
	anim_loop 3, .loop
	anim_ret

BattleAnim_Ember:
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
	anim_wait 32
	anim_ret

BattleAnim_FirePunch:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_FIRE
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_call BattleAnim_FirePunch_branch_cbbcc
	anim_wait 16
	anim_ret

BattleAnim_FireSpin:
	anim_1gfx ANIM_GFX_FIRE
.loop
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 88, $4
	anim_wait 2
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 96, $3
	anim_wait 2
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 88, $3
	anim_wait 2
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_SPIN, 64, 96, $4
	anim_wait 2
	anim_loop 2, .loop
	anim_wait 96
	anim_ret

BattleAnim_DragonRage:
	anim_1gfx ANIM_GFX_FIRE
.loop
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_DRAGON_RAGE, 64, 92, $0
	anim_wait 3
	anim_loop 16, .loop
	anim_wait 64
	anim_ret

BattleAnim_Flamethrower:
	anim_1gfx ANIM_GFX_FIRE
	anim_sound 6, 2, SFX_EMBER
	anim_obj ANIM_OBJ_FLAMETHROWER, 64, 92, $3
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 75, 86, $5
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 85, 81, $7
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 96, 76, $9
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 106, 71, $b
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 116, 66, $c
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 126, 61, $a
	anim_wait 2
	anim_obj ANIM_OBJ_FLAMETHROWER, 136, 56, $8
	anim_wait 16
.loop
	anim_sound 0, 1, SFX_EMBER
	anim_wait 16
	anim_loop 6, .loop
	anim_wait 16
	anim_ret

BattleAnim_FireBlast:
	anim_1gfx ANIM_GFX_FIRE
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
.loop3
	anim_sound 0, 1, SFX_EMBER
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $1
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $2
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $3
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $4
	anim_obj ANIM_OBJ_FIRE_BLAST, 136, 56, $5
	anim_wait 16
	anim_loop 2, .loop3
	anim_wait 32
	anim_ret

BattleAnim_IcePunch:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_ICE
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_call BattleAnim_IcePunch_branch_cbbdf
	anim_wait 32
	anim_ret

BattleAnim_IceBeam:
	anim_1gfx ANIM_GFX_ICE
.loop
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_BEAM, 64, 92, $4
	anim_wait 4
	anim_loop 5, .loop
	anim_obj ANIM_OBJ_ICE_BUILDUP, 136, 74, $10
.loop2
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_ICE_BEAM, 64, 92, $4
	anim_wait 4
	anim_loop 15, .loop2
	anim_wait 48
	anim_sound 0, 1, SFX_SHINE
	anim_wait 8
	anim_sound 0, 1, SFX_SHINE
	anim_wait 8
	anim_ret

BattleAnim_Blizzard:
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

BattleAnim_Bubble:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_sound 32, 2, SFX_WATER_GUN
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $c1
	anim_wait 6
	anim_sound 32, 2, SFX_WATER_GUN
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $e1
	anim_wait 6
	anim_sound 32, 2, SFX_WATER_GUN
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $d1
	anim_wait 128
	anim_wait 32
	anim_ret

BattleAnim_Bubblebeam:
	anim_1gfx ANIM_GFX_BUBBLE
.loop
	anim_sound 16, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $92
	anim_wait 6
	anim_sound 16, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $b3
	anim_wait 6
	anim_sound 16, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_BUBBLE, 64, 92, $f4
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 64
	anim_clearobjs
	anim_bgeffect ANIM_BG_30, $0, $0, $0
	anim_wait 1
	anim_call BattleAnim_UserObj_2Row
	anim_bgeffect ANIM_BG_31, $1c, $0, $0
	anim_wait 19
	anim_call BattleAnim_ShowMon_1
	anim_bgeffect ANIM_BG_32, $0, $0, $0
	anim_wait 8
	anim_ret

BattleAnim_WaterGun:
	anim_bgeffect ANIM_BG_30, $0, $0, $0
	anim_1gfx ANIM_GFX_WATER
	anim_call BattleAnim_UserObj_2Row
	anim_sound 16, 2, SFX_WATER_GUN
	anim_obj ANIM_OBJ_WATER_GUN, 64, 88, $0
	anim_wait 8
	anim_obj ANIM_OBJ_WATER_GUN, 64, 76, $0
	anim_wait 8
	anim_obj ANIM_OBJ_WATER_GUN, 64, 82, $0
	anim_wait 24
	anim_bgeffect ANIM_BG_31, $1c, $0, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_31, $8, $0, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_31, $30, $0, $0
	anim_wait 32
	anim_call BattleAnim_ShowMon_1
	anim_bgeffect ANIM_BG_32, $0, $0, $0
	anim_wait 16
	anim_ret

BattleAnim_HydroPump:
	anim_bgeffect ANIM_BG_30, $0, $0, $0
	anim_1gfx ANIM_GFX_WATER
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
	anim_wait 16
	anim_ret

BattleAnim_Surf:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_bgeffect ANIM_BG_SURF, $0, $0, $0
	anim_obj ANIM_OBJ_SURF, 88, 104, $8
.loop
	anim_sound 0, 1, SFX_SURF
	anim_wait 32
	anim_loop 4, .loop
	anim_incobj 1
	anim_wait 56
	anim_ret

BattleAnim_VineWhip:
	anim_1gfx ANIM_GFX_WHIP
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_40, 116, 52, $80
	anim_wait 4
	anim_sound 0, 1, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_3F, 128, 60, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 4
	anim_ret

BattleAnim_LeechSeed:
	anim_1gfx ANIM_GFX_PLANT
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_LEECH_SEED, 48, 80, $20
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_LEECH_SEED, 48, 80, $30
	anim_wait 8
	anim_sound 16, 2, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_LEECH_SEED, 48, 80, $28
	anim_wait 32
	anim_sound 0, 1, SFX_CHARGE
	anim_wait 128
	anim_ret

BattleAnim_RazorLeaf:
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

BattleAnim_Solarbeam:
	anim_if_param_equal $0, .FireSolarBeam
	; charge turn
	anim_1gfx ANIM_GFX_CHARGE
	anim_sound 0, 0, SFX_CHARGE
	anim_obj ANIM_OBJ_3D, 48, 84, $0
	anim_obj ANIM_OBJ_3C, 48, 84, $0
	anim_obj ANIM_OBJ_3C, 48, 84, $8
	anim_obj ANIM_OBJ_3C, 48, 84, $10
	anim_obj ANIM_OBJ_3C, 48, 84, $18
	anim_obj ANIM_OBJ_3C, 48, 84, $20
	anim_obj ANIM_OBJ_3C, 48, 84, $28
	anim_obj ANIM_OBJ_3C, 48, 84, $30
	anim_obj ANIM_OBJ_3C, 48, 84, $38
	anim_wait 104
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_wait 64
	anim_ret

.FireSolarBeam
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnim_Solarbeam_branch_cbb39
	anim_wait 48
	anim_ret

BattleAnim_Thunderpunch:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_LIGHTNING
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 152, 68, $0
	anim_wait 64
	anim_ret

BattleAnim_Thundershock:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_obj ANIM_OBJ_34, 136, 56, $2
	anim_wait 16
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_33, 136, 56, $0
	anim_wait 96
	anim_ret

BattleAnim_Thunderbolt:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_31, 136, 56, $0
	anim_wait 64
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_wait 64
	anim_ret

BattleAnim_ThunderWave:
	anim_1gfx ANIM_GFX_LIGHTNING
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_THUNDER_WAVE, 136, 56, $0
	anim_wait 20
	anim_bgp $1b
	anim_incobj 1
	anim_wait 96
	anim_ret

BattleAnim_Thunder:
	anim_1gfx ANIM_GFX_LIGHTNING
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $20
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2E, 120, 68, $0
	anim_wait 16
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 152, 68, $0
	anim_wait 16
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2D, 136, 68, $0
	anim_wait 48
	anim_ret

BattleAnim_RazorWind:
	anim_if_param_equal $1, BattleAnim_RazorWind_branch_c9fb5
	anim_1gfx ANIM_GFX_WHIP
	anim_bgeffect ANIM_BG_06, $0, $1, $0
.loop
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_42, 152, 40, $3
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_42, 136, 56, $3
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_42, 152, 64, $3
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_41, 120, 40, $83
	anim_wait 4
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_41, 120, 64, $83
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 24
	anim_ret

BattleAnim_Sonicboom_JP:
	anim_2gfx ANIM_GFX_WHIP, ANIM_GFX_HIT
.loop
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SONICBOOM_JP, 64, 80, $3
	anim_wait 8
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SONICBOOM_JP, 64, 88, $2
	anim_wait 8
	anim_sound 3, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_SONICBOOM_JP, 64, 96, $4
	anim_wait 8
	anim_loop 2, .loop
	anim_wait 32
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Gust:
BattleAnim_Sonicboom:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HIT
.loop
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_GUST, 136, 72, $0
	anim_wait 6
	anim_loop 9, .loop
	anim_obj ANIM_OBJ_01, 144, 64, $18
	anim_wait 8
	anim_obj ANIM_OBJ_01, 128, 32, $18
	anim_wait 16
	anim_ret

BattleAnim_Selfdestruct:
	anim_1gfx ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $24
	anim_if_param_equal $1, .loop
	anim_call BattleAnim_Selfdestruct_branch_cbb8f
	anim_wait 16
	anim_ret

.loop
	anim_call BattleAnim_Selfdestruct_branch_cbb62
	anim_wait 5
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_loop 2, .loop
	anim_wait 16
	anim_ret

BattleAnim_Explosion:
	anim_1gfx ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_1F, $60, $4, $10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $24
	anim_if_param_equal $1, .loop
	anim_call BattleAnim_Explosion_branch_cbb8f
	anim_wait 16
	anim_ret

.loop
	anim_call BattleAnim_Explosion_branch_cbb62
	anim_wait 5
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_loop 2, .loop
	anim_wait 16
	anim_ret

BattleAnim_Acid:
	anim_purplepal
	anim_1gfx ANIM_GFX_POISON
	anim_call BattleAnim_Acid_branch_cbc35
	anim_wait 64
	anim_ret

BattleAnim_RockThrow:
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
	anim_wait 96
	anim_ret

BattleAnim_RockSlide:
	anim_1gfx ANIM_GFX_ROCKS
	anim_bgeffect ANIM_BG_1F, $c0, $1, $0
.loop
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 128, 64, $40
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 120, 68, $30
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 152, 68, $30
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 144, 64, $40
	anim_wait 4
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 136, 68, $30
	anim_wait 16
	anim_loop 4, .loop
	anim_wait 96
	anim_ret

BattleAnim_Sing:
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
	anim_wait 64
	anim_ret

BattleAnim_Poisonpowder:
; Poison Powder tints its powder purple; Sleep Powder/Spore keep their palettes.
	anim_purplepal
BattleAnim_SleepPowder:
BattleAnim_Spore:
BattleAnim_StunSpore:
	anim_1gfx ANIM_GFX_POWDER
.loop
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, 104, 16, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, 136, 16, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, 112, 16, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, 128, 16, $0
	anim_wait 4
	anim_sound 0, 1, SFX_POWDER
	anim_obj ANIM_OBJ_POWDER, 120, 16, $0
	anim_wait 4
	anim_loop 2, .loop
	anim_wait 96
	anim_ret

BattleAnim_HyperBeam:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_1F, $30, $4, $10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnim_HyperBeam_branch_cbb39
	anim_wait 48
	anim_ret

BattleAnim_AuroraBeam:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_wait 64
	anim_call BattleAnim_AuroraBeam_branch_cbb39
	anim_wait 48
	anim_incobj 5
	anim_wait 64
	anim_ret

BattleAnim_Vicegrip:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_VICEGRIP
	anim_obj ANIM_OBJ_37, 152, 40, $0
	anim_obj ANIM_OBJ_39, 120, 72, $0
	anim_wait 32
	anim_ret

BattleAnim_Scratch:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_wait 32
	anim_ret

BattleAnim_FurySwipes:
	anim_1gfx ANIM_GFX_CUT
	anim_if_param_equal $1, BattleAnim_FurySwipes_branch_c9dd9
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_sound 0, 1, SFX_SCRATCH
	anim_wait 32
	anim_ret

BattleAnim_FurySwipes_branch_c9dd9:
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_38, 120, 48, $0
	anim_obj ANIM_OBJ_38, 124, 44, $0
	anim_obj ANIM_OBJ_38, 128, 40, $0
	anim_sound 0, 1, SFX_SCRATCH
	anim_wait 32
	anim_ret

BattleAnim_Cut:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 32
	anim_ret

BattleAnim_Slash:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_obj ANIM_OBJ_3A, 148, 36, $0
	anim_wait 32
	anim_ret

BattleAnim_Clamp:
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_CLAMP, 136, 56, $a0
	anim_obj ANIM_OBJ_CLAMP, 136, 56, $20
	anim_wait 16
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 32
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 16
	anim_ret

BattleAnim_Bite:
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 16
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 8
	anim_ret

BattleAnim_Teleport:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TELEPORT, $0, $1, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 3
	anim_incbgeffect ANIM_BG_TELEPORT
	anim_call BattleAnim_ShowMon_0
	anim_bgeffect ANIM_BG_06, $0, $1, $0
	anim_call BattleAnim_Teleport_branch_cbb12
	anim_wait 64
	anim_ret

BattleAnim_Fly:
	anim_if_param_equal $1, BattleAnim_Fly_branch_c9e89
	anim_if_param_equal $2, BattleAnim_Fly_branch_c9e82
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 32
BattleAnim_Fly_branch_c9e82:
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Fly_branch_c9e89:
	anim_1gfx ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $1, $0
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_call BattleAnim_Fly_branch_cbb12
	anim_wait 64
	anim_ret

BattleAnim_DoubleTeam:
	anim_call BattleAnim_TargetObj_2Row
	anim_sound 0, 0, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_DOUBLE_TEAM, $0, $1, $0
	anim_wait 96
	anim_incbgeffect ANIM_BG_DOUBLE_TEAM
	anim_wait 24
	anim_incbgeffect ANIM_BG_DOUBLE_TEAM
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Recover:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_FULL_HEAL
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $30
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $31
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $32
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $33
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $34
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $35
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $36
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $37
	anim_wait 64
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Absorb:
	anim_1gfx ANIM_GFX_CHARGE
	anim_obj ANIM_OBJ_3D, 44, 88, $0
.loop
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 6
	anim_loop 5, .loop
	anim_wait 32
	anim_ret

BattleAnim_MegaDrain:
	anim_1gfx ANIM_GFX_CHARGE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1C, $0, $0, $10
	anim_setvar $0
.loop
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 6
	anim_incvar
	anim_if_var_equal $7, .done
	anim_if_var_equal $2, .spawn
	anim_jump .loop

.spawn
	anim_obj ANIM_OBJ_3D, 44, 88, $0
	anim_jump .loop

.done
	anim_wait 32
	anim_incbgeffect ANIM_BG_1C
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_EggBomb:
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_SWITCH_POKEMON
	anim_obj ANIM_OBJ_EGG, 44, 104, $1
	anim_wait 128
	anim_wait 96
	anim_incobj 1
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_18, 128, 64, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_18, 144, 68, $0
	anim_wait 8
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_18, 136, 72, $0
	anim_wait 24
	anim_ret

BattleAnim_Softboiled:
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_BUBBLE
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_SWITCH_POKEMON
	anim_obj ANIM_OBJ_EGG, 44, 104, $6
	anim_wait 128
	anim_incobj 2
	anim_obj ANIM_OBJ_EGG, 76, 104, $b
	anim_wait 16
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_sound 0, 0, SFX_METRONOME
.loop
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $20
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 128
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_FocusEnergy:
BattleAnim_RazorWind_branch_c9fb5:
BattleAnim_SkullBash_branch_c9fb5:
BattleAnim_SkyAttack_branch_c9fb5:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_16, $0, $1, $40
	anim_bgeffect ANIM_BG_06, $0, $2, $0
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
	anim_loop 3, .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_16
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Bide:
	anim_if_param_equal $0, BattleAnim_Bide_branch_c9651
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_ESCAPE_ROPE
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_wait 72
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Bind:
	anim_1gfx ANIM_GFX_ROPE
	anim_sound 0, 1, SFX_BIND
	anim_obj ANIM_OBJ_48, 132, 64, $0
	anim_wait 8
	anim_obj ANIM_OBJ_49, 132, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_48, 132, 48, $0
	anim_wait 64
	anim_sound 0, 1, SFX_BIND
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_wait 96
	anim_ret

BattleAnim_Wrap:
	anim_1gfx ANIM_GFX_ROPE
	anim_sound 0, 1, SFX_BIND
	anim_obj ANIM_OBJ_48, 132, 64, $0
	anim_wait 8
	anim_obj ANIM_OBJ_48, 132, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_48, 132, 48, $0
	anim_wait 64
	anim_sound 0, 1, SFX_BIND
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_wait 96
	anim_ret

BattleAnim_Confusion:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_UserObj_2Row
	anim_sound 0, 1, SFX_PSYCHIC
	anim_bgeffect ANIM_BG_NIGHT_SHADE, $0, $0, $8
	anim_wait 128
	anim_incbgeffect ANIM_BG_NIGHT_SHADE
	anim_call BattleAnim_ShowMon_1
	anim_ret

BattleAnim_Constrict:
	anim_1gfx ANIM_GFX_ROPE
	anim_sound 0, 1, SFX_BIND
	anim_obj ANIM_OBJ_49, 132, 64, $0
	anim_wait 8
	anim_obj ANIM_OBJ_48, 132, 48, $0
	anim_wait 8
	anim_obj ANIM_OBJ_49, 132, 40, $0
	anim_wait 8
	anim_obj ANIM_OBJ_48, 132, 56, $0
	anim_wait 64
	anim_ret

BattleAnim_Earthquake:
	anim_bgeffect ANIM_BG_1F, $60, $4, $10
.loop
	anim_sound 0, 1, SFX_EMBER
	anim_wait 24
	anim_loop 4, .loop
	anim_ret

BattleAnim_Fissure:
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_bgeffect ANIM_BG_1F, $60, $4, $0
.loop
	anim_sound 0, 1, SFX_EMBER
	anim_wait 24
	anim_loop 4, .loop
	anim_ret

BattleAnim_Growl:
	anim_1gfx ANIM_GFX_NOISE
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_cry $0
.loop
	anim_call BattleAnim_Growl_branch_cbbbc
	anim_wait 16
	anim_loop 3, .loop
	anim_wait 9
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_19, $0, $0, $40
	anim_wait 64
	anim_incbgeffect ANIM_BG_19
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 5
	anim_incobj 10
	anim_wait 8
	anim_ret

BattleAnim_Roar:
	anim_1gfx ANIM_GFX_NOISE
	anim_bgeffect ANIM_BG_06, $0, $2, $0
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

BattleAnim_Supersonic:
	anim_1gfx ANIM_GFX_PSYCHIC
.loop
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 64
	anim_ret

BattleAnim_Screech:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_1F, $8, $1, $20
	anim_sound 6, 2, SFX_SCREECH
.loop
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 2
	anim_loop 2, .loop
	anim_wait 64
	anim_ret

BattleAnim_ConfuseRay:
	anim_1gfx ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_08, $0, $4, $0
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $0
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $80
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $88
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $90
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $98
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $a0
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $a8
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $b0
	anim_obj ANIM_OBJ_CONFUSE_RAY, 64, 88, $b8
.loop
	anim_sound 6, 2, SFX_WHIRLWIND
	anim_wait 16
	anim_loop 8, .loop
	anim_wait 32
	anim_ret

BattleAnim_Leer:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnim_Leer_branch_cbadc
	anim_wait 16
	anim_ret

BattleAnim_Reflect:
	anim_1gfx ANIM_GFX_REFLECT
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 24
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 64
	anim_ret

BattleAnim_LightScreen:
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

BattleAnim_Amnesia:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_LICK
	anim_obj ANIM_OBJ_AMNESIA, 64, 80, $2
	anim_wait 16
	anim_obj ANIM_OBJ_AMNESIA, 68, 80, $1
	anim_wait 16
	anim_obj ANIM_OBJ_AMNESIA, 72, 80, $0
	anim_wait 64
	anim_ret

BattleAnim_DizzyPunch:
	anim_2gfx ANIM_GFX_STATUS, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 136, 40, $0
	anim_obj ANIM_OBJ_02, 136, 64, $0
	anim_wait 16
	anim_sound 0, 1, SFX_KINESIS
	anim_obj ANIM_OBJ_CHICK, 136, 24, $15
	anim_obj ANIM_OBJ_CHICK, 136, 24, $aa
	anim_obj ANIM_OBJ_CHICK, 136, 24, $bf
	anim_wait 96
	anim_ret

BattleAnim_Rest:
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_TAIL_WHIP
.loop
	anim_obj ANIM_OBJ_ASLEEP, 64, 80, $0
	anim_wait 40
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_AcidArmor:
	anim_purplepal
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_ACID_ARMOR, $0, $1, $8
	anim_sound 0, 0, SFX_MEGA_PUNCH
	anim_wait 64
	anim_incbgeffect ANIM_BG_ACID_ARMOR
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Splash:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_VICEGRIP
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_BOUNCE_DOWN, $0, $1, $0
	anim_wait 96
	anim_incbgeffect ANIM_BG_BOUNCE_DOWN
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Dig:
	anim_2gfx ANIM_GFX_SAND, ANIM_GFX_HIT
	anim_if_param_equal $0, .hit
	anim_if_param_equal $2, .fail
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_DIG, $0, $1, $1
	anim_obj ANIM_OBJ_57, 72, 104, $0
.loop
	anim_sound 0, 0, SFX_RAZOR_WIND
	anim_obj ANIM_OBJ_56, 56, 104, $0
	anim_wait 16
	anim_loop 6, .loop
	anim_wait 32
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_DIG
	anim_call BattleAnim_ShowMon_0
	anim_ret

.hit
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 32
.fail
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_SandAttack:
	anim_1gfx ANIM_GFX_SAND
	anim_call BattleAnim_SandAttack_branch_cbc5b
	anim_ret

BattleAnim_StringShot:
	anim_1gfx ANIM_GFX_WEB
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 80, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 132, 48, $1
	anim_wait 4
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 88, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 132, 64, $1
	anim_wait 4
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 84, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_STRING_SHOT, 132, 56, $2
	anim_wait 64
	anim_ret

BattleAnim_Headbutt:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_wait 32
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Tackle:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_00, 136, 48, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_BodySlam:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_BOUNCE_DOWN, $0, $1, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_BOUNCE_DOWN
	anim_wait 4
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 3
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 3
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_TakeDown:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 3
	anim_sound 0, 1, SFX_TACKLE
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_01, 128, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_TACKLE
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $2
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 3
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_DoubleEdge:
	anim_1gfx ANIM_GFX_HIT
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
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Submission:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_26, $0, $0, $0
	anim_sound 0, 1, SFX_SUBMISSION
	anim_wait 32
	anim_obj ANIM_OBJ_01, 120, 48, $0
	anim_wait 32
	anim_obj ANIM_OBJ_01, 152, 56, $0
	anim_wait 32
	anim_obj ANIM_OBJ_01, 136, 52, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_26
	anim_call BattleAnim_ShowMon_1
	anim_ret

BattleAnim_Whirlwind:
	anim_1gfx ANIM_GFX_WIND
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
	anim_bgeffect ANIM_BG_27, $0, $0, $0
	anim_wait 64
.done
	anim_ret

BattleAnim_Hypnosis:
	anim_1gfx ANIM_GFX_PSYCHIC
.loop
	anim_sound 6, 2, SFX_SUPERSONIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_obj ANIM_OBJ_WAVE, 56, 80, $2
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 56
	anim_ret

BattleAnim_Haze:
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 0, 1, SFX_SURF
.loop
	anim_obj ANIM_OBJ_HAZE, 48, 56, $0
	anim_obj ANIM_OBJ_HAZE, 132, 16, $0
	anim_wait 12
	anim_loop 5, .loop
	anim_wait 96
	anim_ret

BattleAnim_Mist:
	anim_obp0 $54
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 0, 0, SFX_SURF
.loop
	anim_obj ANIM_OBJ_MIST, 48, 56, $0
	anim_wait 8
	anim_loop 10, .loop
	anim_wait 96
	anim_ret

BattleAnim_Smog:
	anim_purplepal
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 0, 1, SFX_BUBBLEBEAM
.loop
	anim_obj ANIM_OBJ_SMOG, 132, 16, $0
	anim_wait 8
	anim_loop 10, .loop
	anim_wait 96
	anim_ret

BattleAnim_PoisonGas:
	anim_purplepal
	anim_1gfx ANIM_GFX_HAZE
	anim_sound 16, 2, SFX_BUBBLEBEAM
.loop
	anim_obj ANIM_OBJ_POISON_GAS, 44, 80, $2
	anim_wait 8
	anim_loop 10, .loop
	anim_wait 128
	anim_ret

BattleAnim_HornAttack:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_HORN, 72, 80, $1
	anim_wait 16
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_FuryAttack:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
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
	anim_ret

BattleAnim_HornDrill:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
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

BattleAnim_PoisonSting:
	anim_purplepal
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_60, 64, 92, $14
	anim_wait 16
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Twineedle:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_60, 64, 92, $14
	anim_obj ANIM_OBJ_60, 56, 84, $14
	anim_wait 16
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 136, 56, $0
	anim_obj ANIM_OBJ_05, 128, 48, $0
	anim_wait 16
	anim_ret

BattleAnim_PinMissile:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
.loop
	anim_obj ANIM_OBJ_60, 64, 92, $28
	anim_wait 8
	anim_obj ANIM_OBJ_60, 56, 84, $28
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_60, 52, 88, $28
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 128, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 132, 52, $0
	anim_loop 3, .loop
	anim_wait 16
	anim_ret

BattleAnim_SpikeCannon:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
.loop
	anim_obj ANIM_OBJ_60, 64, 92, $18
	anim_wait 8
	anim_obj ANIM_OBJ_60, 56, 84, $18
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_60, 52, 88, $18
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 128, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_POISON_STING
	anim_obj ANIM_OBJ_05, 132, 52, $0
	anim_loop 3, .loop
	anim_wait 16
	anim_ret

BattleAnim_Transform:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_transform
	anim_sound 0, 0, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_WAVE_DEFORM_USER, $0, $1, $0
	anim_wait 48
	anim_updateactorpic
	anim_incbgeffect ANIM_BG_WAVE_DEFORM_USER
	anim_wait 48
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_PetalDance:
	anim_sound 0, 0, SFX_MENU
	anim_2gfx ANIM_GFX_FLOWER, ANIM_GFX_HIT
.loop
	anim_obj ANIM_OBJ_PETAL_DANCE, 48, 56, $0
	anim_wait 11
	anim_loop 8, .loop
	anim_wait 128
	anim_wait 64
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Barrage:
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_EXPLOSION
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_SLUDGE_BOMB, 64, 92, $10
	anim_wait 36
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_18, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_PayDay:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_STATUS
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_01, 128, 56, $0
	anim_wait 16
	anim_sound 0, 1, SFX_PAY_DAY
	anim_obj ANIM_OBJ_PAY_DAY, 120, 76, $1
	anim_wait 64
	anim_ret

BattleAnim_Mimic:
	anim_1gfx ANIM_GFX_SPEED
	anim_obp0 $fc
	anim_sound 63, 3, SFX_LICK
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $0
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $8
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $10
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $18
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $20
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $28
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $30
	anim_obj ANIM_OBJ_MIMIC, 132, 44, $38
	anim_wait 128
	anim_wait 48
	anim_ret

BattleAnim_LovelyKiss:
	anim_2gfx ANIM_GFX_OBJECTS, ANIM_GFX_ANGELS
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_LOVELY_KISS, 152, 40, $0
	anim_wait 32
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_HEART, 128, 40, $0
	anim_wait 40
	anim_ret

BattleAnim_Bonemerang:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_HIT
	anim_sound 6, 2, SFX_HYDRO_PUMP
	anim_obj ANIM_OBJ_BONEMERANG, 88, 56, $1c
	anim_wait 24
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 24
	anim_ret

BattleAnim_Swift:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_sound 6, 2, SFX_METRONOME
	anim_obj ANIM_OBJ_SWIFT, 64, 88, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SWIFT, 64, 72, $4
	anim_wait 4
	anim_obj ANIM_OBJ_SWIFT, 64, 76, $4
	anim_wait 64
	anim_ret

BattleAnim_Crabhammer:
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_wait 48
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
.loop
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 12
	anim_loop 3, .loop
	anim_ret

BattleAnim_SkullBash:
	anim_if_param_equal $1, BattleAnim_SkullBash_branch_c9fb5
	anim_1gfx ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $14, $2, $0
	anim_wait 32
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
.loop
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_loop 3, .loop
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Kinesis:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_NOISE
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_obj ANIM_OBJ_KINESIS, 80, 76, $0
	anim_wait 32
.loop
	anim_sound 0, 0, SFX_KINESIS
	anim_obj ANIM_OBJ_4B, 64, 88, $0
	anim_wait 32
	anim_loop 3, .loop
	anim_wait 32
	anim_sound 0, 0, SFX_KINESIS_2
	anim_wait 32
	anim_ret

BattleAnim_Peck:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 128, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_DrillPeck:
	anim_1gfx ANIM_GFX_HIT
.loop
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 124, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 132, 48, $0
	anim_wait 4
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 140, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_PECK
	anim_obj ANIM_OBJ_02, 132, 64, $0
	anim_wait 4
	anim_loop 5, .loop
	anim_wait 16
	anim_ret

BattleAnim_Guillotine:
	anim_1gfx ANIM_GFX_CUT
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_sound 0, 1, SFX_VICEGRIP
	anim_obj ANIM_OBJ_37, 156, 44, $0
	anim_obj ANIM_OBJ_37, 152, 40, $0
	anim_obj ANIM_OBJ_37, 148, 36, $0
	anim_obj ANIM_OBJ_39, 124, 76, $0
	anim_obj ANIM_OBJ_39, 120, 72, $0
	anim_obj ANIM_OBJ_39, 116, 68, $0
	anim_obj ANIM_OBJ_39, 120, 72, $0
	anim_wait 32
	anim_ret

BattleAnim_Flash:
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
	anim_wait 32
	anim_ret

BattleAnim_Substitute:
	anim_sound 0, 0, SFX_SURF
	anim_if_param_equal $3, BattleAnim_Substitute_branch_ca77c
	anim_if_param_equal $2, BattleAnim_Substitute_branch_ca76e
	anim_if_param_equal $1, BattleAnim_Substitute_branch_ca760
	anim_1gfx ANIM_GFX_SMOKE
	anim_bgeffect ANIM_BG_27, $0, $1, $0
	anim_wait 48
	anim_raisesub
	anim_obj ANIM_OBJ_BALL_POOF, 48, 96, $0
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Substitute_branch_ca760:
	anim_bgeffect ANIM_BG_27, $0, $1, $0
	anim_wait 48
	anim_dropsub
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Substitute_branch_ca76e:
	anim_bgeffect ANIM_BG_27, $0, $1, $0
	anim_wait 48
	anim_raisesub
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Substitute_branch_ca77c:
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_wait 48
	anim_dropsub
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 32
	anim_ret

BattleAnim_Minimize:
	anim_sound 0, 0, SFX_SURF
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_minimize
	anim_bgeffect ANIM_BG_WAVE_DEFORM_USER, $0, $1, $0
	anim_wait 48
	anim_updateactorpic
	anim_incbgeffect ANIM_BG_WAVE_DEFORM_USER
	anim_wait 48
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_SkyAttack:
	anim_if_param_equal $1, BattleAnim_SkyAttack_branch_c9fb5
	anim_1gfx ANIM_GFX_SKY_ATTACK
	anim_bgeffect ANIM_BG_27, $0, $1, $0
	anim_wait 32
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_SKY_ATTACK, 48, 88, $40
	anim_wait 64
	anim_incobj 1
	anim_wait 21
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_wait 64
	anim_incobj 1
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_NightShade:
	anim_1gfx ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp1 $1b
	anim_wait 32
	anim_call BattleAnim_UserObj_2Row
	anim_bgeffect ANIM_BG_NIGHT_SHADE, $0, $0, $8
	anim_sound 0, 1, SFX_PSYCHIC
	anim_wait 96
	anim_incbgeffect ANIM_BG_NIGHT_SHADE
	anim_call BattleAnim_ShowMon_1
	anim_ret

BattleAnim_Lick:
	anim_1gfx ANIM_GFX_WATER
	anim_sound 0, 1, SFX_LICK
	anim_obj ANIM_OBJ_LICK, 136, 56, $0
	anim_wait 64
	anim_ret

BattleAnim_TriAttack:
	anim_3gfx ANIM_GFX_FIRE, ANIM_GFX_ICE, ANIM_GFX_LIGHTNING
	anim_call BattleAnim_TriAttack_branch_cbbcc
	anim_wait 16
	anim_call BattleAnim_TriAttack_branch_cbbdf
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $4
	anim_sound 0, 1, SFX_THUNDER
	anim_obj ANIM_OBJ_2F, 152, 68, $0
	anim_wait 16
	anim_ret

BattleAnim_Withdraw:
	anim_1gfx ANIM_GFX_REFLECT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_WITHDRAW, $0, $1, $50
	anim_wait 48
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_WITHDRAW, 48, 88, $0
	anim_wait 64
	anim_incobj 2
	anim_wait 1
	anim_incbgeffect ANIM_BG_WITHDRAW
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Psybeam:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_08, $0, $4, $0
.loop
	anim_sound 6, 2, SFX_PSYBEAM
	anim_obj ANIM_OBJ_WAVE, 64, 88, $4
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 48
	anim_ret

BattleAnim_DreamEater:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_bgp $1b
	anim_obp0 $27
	anim_sound 6, 3, SFX_WATER_GUN
	anim_call BattleAnim_DreamEater_branch_cbab3
	anim_wait 128
	anim_wait 48
	anim_ret

BattleAnim_LeechLife:
	anim_1gfx ANIM_GFX_BUBBLE
	anim_sound 6, 3, SFX_WATER_GUN
	anim_call BattleAnim_LeechLife_branch_cbab3
	anim_wait 128
	anim_wait 48
	anim_ret

BattleAnim_Harden:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_Harden_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Psywave:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
.loop
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 64, 80, $2
	anim_wait 8
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $3
	anim_wait 8
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 64, 96, $4
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 32
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_wait 4
	anim_ret

BattleAnim_Glare:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $20
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnim_Glare_branch_cbadc
	anim_wait 16
	anim_ret

BattleAnim_Thrash:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_08, 120, 72, $0
	anim_obj ANIM_OBJ_00, 120, 72, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_obj ANIM_OBJ_06, 136, 56, $0
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 152, 40, $0
	anim_obj ANIM_OBJ_00, 152, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_Growth:
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_1gfx ANIM_GFX_CHARGE
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $0
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $8
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $10
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $18
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $20
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $28
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $30
	anim_obj ANIM_OBJ_GROWTH, 48, 108, $38
	anim_wait 64
	anim_ret

BattleAnim_Conversion2:
	anim_1gfx ANIM_GFX_EXPLOSION
	anim_sound 63, 3, SFX_SHARPEN
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $0
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $8
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $10
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $18
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $20
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $28
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $30
	anim_obj ANIM_OBJ_CONVERSION2, 132, 44, $38
	anim_wait 128
	anim_wait 48
	anim_ret

BattleAnim_Smokescreen:
	anim_3gfx ANIM_GFX_HAZE, ANIM_GFX_EGG, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj ANIM_OBJ_SMOKESCREEN, 64, 92, $6c
	anim_wait 24
	anim_incobj 1
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj ANIM_OBJ_BALL_POOF, 108, 70, $10
	anim_wait 8
.loop
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_SMOKE, 132, 60, $20
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 128
	anim_ret

BattleAnim_Strength:
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_20, $10, $1, $20
	anim_sound 0, 0, SFX_STRENGTH
	anim_obj ANIM_OBJ_STRENGTH, 64, 104, $1
	anim_wait 128
	anim_incobj 1
	anim_wait 20
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 132, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_SwordsDance:
	anim_1gfx ANIM_GFX_WHIP
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj ANIM_OBJ_SWORDS_DANCE, 48, 108, $0
	anim_obj ANIM_OBJ_SWORDS_DANCE, 48, 108, $d
	anim_obj ANIM_OBJ_SWORDS_DANCE, 48, 108, $1a
	anim_obj ANIM_OBJ_SWORDS_DANCE, 48, 108, $27
	anim_obj ANIM_OBJ_SWORDS_DANCE, 48, 108, $34
	anim_wait 56
	anim_ret

BattleAnim_QuickAttack:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_Meditate:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_PSYBEAM
	anim_bgeffect ANIM_BG_WAVE_DEFORM_USER, $0, $1, $0
	anim_wait 48
	anim_incbgeffect ANIM_BG_WAVE_DEFORM_USER
	anim_wait 48
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Sharpen:
	anim_1gfx ANIM_GFX_SHAPES
	anim_obp0 $e4
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_SHARPEN
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_obj ANIM_OBJ_SHARPEN, 48, 88, $0
	anim_wait 96
	anim_incobj 2
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_DefenseCurl:
	anim_1gfx ANIM_GFX_SHAPES
	anim_obp0 $e4
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_SHARPEN
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_obj ANIM_OBJ_DEFENSE_CURL, 48, 88, $0
	anim_wait 96
	anim_incobj 2
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_SeismicToss:
	anim_2gfx ANIM_GFX_GLOBE, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_20, $10, $1, $20
	anim_sound 0, 0, SFX_STRENGTH
	anim_obj ANIM_OBJ_SEISMIC_TOSS, 64, 104, $1
	anim_wait 128
	anim_incobj 1
	anim_wait 20
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 132, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_Rage:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_RAGE
	anim_wait 72
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_obj ANIM_OBJ_00, 120, 72, $0
	anim_wait 6
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 152, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_Agility:
	anim_1gfx ANIM_GFX_WIND
	anim_obp0 $fc
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_18, $0, $1, $40
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
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_BoneClub:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_MISC
	anim_obj ANIM_OBJ_BONE_CLUB, 64, 88, $2
	anim_wait 32
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Barrier:
	anim_1gfx ANIM_GFX_REFLECT
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_wait 8
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 32
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_wait 32
	anim_ret

BattleAnim_Waterfall:
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
	anim_wait 8
	anim_ret

BattleAnim_PsychicM:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
.loop
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 96
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_wait 4
	anim_ret

BattleAnim_Sludge:
	anim_purplepal
	anim_1gfx ANIM_GFX_POISON
	anim_call BattleAnim_Sludge_branch_cbc15
	anim_wait 56
	anim_ret

BattleAnim_Toxic:
	anim_purplepal
	anim_1gfx ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_call BattleAnim_Toxic_branch_cbc35
	anim_wait 32
	anim_call BattleAnim_Toxic_branch_cbc15
	anim_wait 64
	anim_ret

BattleAnim_Metronome:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_SPEED
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_7A, 72, 88, $0
.loop
	anim_obj ANIM_OBJ_7B, 72, 80, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 48
	anim_ret

BattleAnim_Counter:
	anim_1gfx ANIM_GFX_HIT
.loop
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $2
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_08, 120, 72, $0
	anim_obj ANIM_OBJ_00, 120, 72, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $2
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_06, 136, 40, $0
	anim_obj ANIM_OBJ_00, 136, 40, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $6, $2
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_07, 152, 56, $0
	anim_obj ANIM_OBJ_00, 152, 56, $0
	anim_wait 6
	anim_loop 3, .loop
	anim_wait 16
	anim_ret

BattleAnim_LowKick:
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
	anim_wait 16
	anim_ret

BattleAnim_WingAttack:
	anim_1gfx ANIM_GFX_HIT
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
	anim_wait 16
	anim_ret

BattleAnim_Slam:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_WING_ATTACK
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_obj ANIM_OBJ_01, 124, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_Disable:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_STATUS
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_obj ANIM_OBJ_DISABLE, 132, 56, $0
	anim_wait 16
	anim_sound 0, 1, SFX_BIND
	anim_obj ANIM_OBJ_PARALYZED, 104, 56, $42
	anim_obj ANIM_OBJ_PARALYZED, 160, 56, $c2
	anim_wait 96
	anim_ret

BattleAnim_TailWhip:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_sound 0, 0, SFX_TAIL_WHIP
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_26
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Struggle:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 1, SFX_POUND
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Sketch:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_SKETCH
	anim_obj ANIM_OBJ_SKETCH, 72, 80, $0
	anim_wait 80
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_wait 1
	anim_ret

BattleAnim_TripleKick:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_TripleKick_branch_cac95
	anim_if_param_equal $2, BattleAnim_TripleKick_branch_caca5
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_07, 144, 48, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 144, 48, $0
	anim_wait 8
	anim_ret

BattleAnim_TripleKick_branch_cac95:
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 120, 64, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 120, 64, $0
	anim_wait 8
	anim_ret

BattleAnim_TripleKick_branch_caca5:
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_07, 132, 32, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 132, 32, $0
	anim_wait 8
	anim_ret

BattleAnim_Thief:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 16
	anim_sound 0, 1, SFX_THIEF
	anim_obj ANIM_OBJ_01, 128, 48, $0
	anim_wait 16
	anim_call BattleAnim_ShowMon_0
	anim_wait 1
	anim_1gfx ANIM_GFX_STATUS
	anim_sound 0, 1, SFX_THIEF_2
	anim_obj ANIM_OBJ_THIEF, 120, 76, $1
	anim_wait 64
	anim_ret

BattleAnim_SpiderWeb:
	anim_1gfx ANIM_GFX_WEB
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_SPIDER_WEB, 132, 48, $0
	anim_sound 6, 2, SFX_SPIDER_WEB
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 80, $0
	anim_wait 4
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 88, $0
	anim_wait 4
	anim_obj ANIM_OBJ_STRING_SHOT, 64, 84, $0
	anim_wait 64
	anim_ret

BattleAnim_MindReader:
	anim_1gfx ANIM_GFX_MISC
	anim_sound 0, 1, SFX_MIND_READER
.loop
	anim_obj ANIM_OBJ_MIND_READER, 132, 48, $3
	anim_obj ANIM_OBJ_MIND_READER, 132, 48, $12
	anim_obj ANIM_OBJ_MIND_READER, 132, 48, $20
	anim_obj ANIM_OBJ_MIND_READER, 132, 48, $31
	anim_wait 16
	anim_loop 2, .loop
	anim_wait 32
	anim_ret

BattleAnim_Nightmare:
	anim_1gfx ANIM_GFX_ANGELS
	anim_bgp $1b
	anim_obp0 $f
	anim_obj ANIM_OBJ_NIGHTMARE, 132, 40, $0
	anim_obj ANIM_OBJ_NIGHTMARE, 132, 40, $a0
	anim_sound 0, 1, SFX_NIGHTMARE
	anim_wait 96
	anim_ret

BattleAnim_FlameWheel:
	anim_1gfx ANIM_GFX_FIRE
.loop
	anim_sound 0, 0, SFX_EMBER
	anim_obj ANIM_OBJ_FLAME_WHEEL, 48, 96, $0
	anim_wait 6
	anim_loop 8, .loop
	anim_wait 96
	anim_call BattleAnim_TargetObj_1Row
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
	anim_incobj 9
	anim_wait 8
	anim_ret

BattleAnim_Snore:
	anim_2gfx ANIM_GFX_STATUS, ANIM_GFX_NOISE
	anim_obj ANIM_OBJ_ASLEEP, 64, 80, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_1F, $60, $2, $0
	anim_sound 0, 0, SFX_SNORE
.loop
	anim_call BattleAnim_Snore_branch_cbbbc
	anim_wait 16
	anim_loop 2, .loop
	anim_wait 8
	anim_ret

BattleAnim_Curse:
	anim_if_param_equal $1, .NotGhost
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_CURSE, 68, 72, $0
	anim_sound 0, 0, SFX_CURSE
	anim_wait 32
	anim_incobj 1
	anim_wait 12
	anim_sound 0, 0, SFX_POISON_STING
	anim_obj ANIM_OBJ_04, 44, 96, $0
	anim_wait 16
	anim_ret

.NotGhost:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_19, $0, $1, $40
	anim_sound 0, 0, SFX_SHARPEN
	anim_wait 64
	anim_incbgeffect ANIM_BG_19
	anim_wait 1
	anim_bgeffect ANIM_BG_16, $0, $1, $40
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
	anim_loop 3, .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_16
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Flail:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 0, SFX_SUBMISSION
	anim_bgeffect ANIM_BG_2C, $0, $1, $0
	anim_wait 8
	anim_obj ANIM_OBJ_01, 120, 48, $0
	anim_wait 8
	anim_obj ANIM_OBJ_01, 152, 48, $0
	anim_wait 8
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_2C
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Conversion:
	anim_1gfx ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 63, 3, SFX_SHARPEN
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $0
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $8
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $10
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $18
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $20
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $28
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $30
	anim_obj ANIM_OBJ_CONVERSION, 48, 88, $38
	anim_wait 128
	anim_ret

BattleAnim_Aeroblast:
	anim_2gfx ANIM_GFX_BEAM, ANIM_GFX_AEROBLAST
	anim_bgp $1b
	anim_bgeffect ANIM_BG_1F, $50, $4, $10
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_sound 0, 0, SFX_AEROBLAST
	anim_obj ANIM_OBJ_AEROBLAST, 72, 88, $0
	anim_wait 32
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_27, 80, 84, $0
	anim_wait 2
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_27, 96, 76, $0
	anim_wait 2
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_27, 112, 68, $0
	anim_obj ANIM_OBJ_28, 126, 62, $0
	anim_wait 48
	anim_ret

BattleAnim_CottonSpore:
	anim_obp0 $54
	anim_1gfx ANIM_GFX_MISC
	anim_sound 0, 1, SFX_POWDER
.loop
	anim_obj ANIM_OBJ_COTTON_SPORE, 132, 32, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 96
	anim_ret

BattleAnim_Reversal:
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

BattleAnim_Spite:
	anim_1gfx ANIM_GFX_ANGELS
	anim_obj ANIM_OBJ_SPITE, 132, 16, $0
	anim_sound 0, 1, SFX_SPITE
	anim_wait 96
	anim_ret

BattleAnim_PowderSnow:
	anim_1gfx ANIM_GFX_ICE
.loop
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_POWDER_SNOW, 64, 88, $23
	anim_wait 2
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_POWDER_SNOW, 64, 80, $24
	anim_wait 2
	anim_sound 6, 2, SFX_SHINE
	anim_obj ANIM_OBJ_POWDER_SNOW, 64, 96, $23
	anim_wait 2
	anim_loop 2, .loop
	anim_bgeffect ANIM_BG_WHITE_HUES, $0, $8, $0
	anim_wait 40
	anim_call BattleAnim_PowderSnow_branch_cbbdf
	anim_wait 32
	anim_ret

BattleAnim_Protect:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $0
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $d
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $1a
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $27
	anim_obj ANIM_OBJ_PROTECT, 80, 80, $34
	anim_sound 0, 0, SFX_PROTECT
	anim_wait 96
	anim_ret

BattleAnim_MachPunch:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_06, 136, 56, $0
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_ScaryFace:
	anim_1gfx ANIM_GFX_BEAM
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_call BattleAnim_ScaryFace_branch_cbadc
	anim_wait 64
	anim_ret

BattleAnim_FaintAttack:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_CURSE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1D, $0, $1, $80
	anim_wait 96
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 120, 32, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 152, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 136, 48, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_1D
	anim_call BattleAnim_ShowMon_0
	anim_wait 4
	anim_ret

BattleAnim_SweetKiss:
	anim_2gfx ANIM_GFX_OBJECTS, ANIM_GFX_ANGELS
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_SWEET_KISS, 96, 40, $0
	anim_sound 0, 1, SFX_SWEET_KISS
	anim_wait 32
	anim_sound 0, 1, SFX_SWEET_KISS_2
	anim_obj ANIM_OBJ_HEART, 120, 40, $0
	anim_wait 40
	anim_ret

BattleAnim_BellyDrum:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_NOISE
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 24
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 24
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 24
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_sound 0, 0, SFX_BELLY_DRUM
	anim_obj ANIM_OBJ_AA, 64, 104, $0
	anim_obj ANIM_OBJ_AB, 64, 92, $f8
	anim_wait 12
	anim_ret

BattleAnim_SludgeBomb:
	anim_purplepal
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_POISON
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SLUDGE_BOMB, 64, 92, $10
	anim_wait 36
	anim_call BattleAnim_SludgeBomb_branch_cbc15
	anim_wait 64
	anim_ret

BattleAnim_MudSlap:
	anim_1gfx ANIM_GFX_SAND
	anim_obp0 $fc
	anim_call BattleAnim_MudSlap_branch_cbc5b
	anim_ret

BattleAnim_Octazooka:
	anim_3gfx ANIM_GFX_HAZE, ANIM_GFX_EGG, ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_OCTAZOOKA, 64, 92, $4
	anim_wait 16
	anim_obj ANIM_OBJ_BALL_POOF, 132, 56, $10
	anim_wait 8
	anim_if_param_equal $0, .done
.loop
	anim_obj ANIM_OBJ_SMOKE, 132, 60, $20
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 128
.done
	anim_ret

BattleAnim_Spikes:
	anim_1gfx ANIM_GFX_MISC
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $20
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $30
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_SPIKES, 48, 88, $28
	anim_wait 64
	anim_ret

BattleAnim_ZapCannon:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_bgp $1b
	anim_obp0 $30
	anim_sound 6, 2, SFX_ZAP_CANNON
	anim_obj ANIM_OBJ_ZAP_CANNON, 64, 92, $2
	anim_wait 40
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_wait 16
	anim_obj ANIM_OBJ_31, 136, 56, $0
	anim_wait 128
	anim_ret

BattleAnim_Foresight:
	anim_1gfx ANIM_GFX_SHINE
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 1, SFX_FORESIGHT
	anim_obj ANIM_OBJ_FORESIGHT, 132, 40, $0
	anim_wait 24
	anim_bgeffect ANIM_BG_19, $0, $0, $40
	anim_wait 64
	anim_incbgeffect ANIM_BG_19
	anim_call BattleAnim_ShowMon_1
	anim_wait 8
	anim_ret

BattleAnim_DestinyBond:
	anim_1gfx ANIM_GFX_ANGELS
	anim_bgp $1b
	anim_obp0 $0
	anim_if_param_equal $1, BattleAnim_DestinyBond_branch_cb104
	anim_sound 6, 2, SFX_WHIRLWIND
	anim_obj ANIM_OBJ_DESTINY_BOND, 44, 120, $2
	anim_wait 128
	anim_ret

BattleAnim_DestinyBond_branch_cb104:
	anim_obj ANIM_OBJ_DESTINY_BOND, 132, 76, $0
	anim_sound 0, 1, SFX_KINESIS
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $0, $0
	anim_wait 32
	anim_ret

BattleAnim_PerishSong:
	anim_1gfx ANIM_GFX_NOISE
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 2, SFX_PERISH_SONG
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $0
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $8
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $10
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $18
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $20
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $28
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $30
	anim_obj ANIM_OBJ_PERISH_SONG, 88, 0, $38
	anim_wait 112
	anim_ret

BattleAnim_IcyWind:
	anim_1gfx ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_battlergfx_1row
	anim_sound 0, 0, SFX_PSYCHIC
.loop
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 88, $4
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 80, $4
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 96, $4
	anim_wait 8
	anim_loop 2, .loop
	anim_wait 16
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_NIGHT_SHADE, $0, $0, $8
	anim_wait 64
	anim_incbgeffect ANIM_BG_NIGHT_SHADE
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_incobj 7
	anim_wait 1
	anim_ret

BattleAnim_Detect:
	anim_1gfx ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 0, SFX_FORESIGHT
	anim_obj ANIM_OBJ_FORESIGHT, 64, 88, $0
	anim_wait 24
	anim_ret

BattleAnim_BoneRush:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_MISC
	anim_sound 0, 1, SFX_BONE_CLUB
	anim_obj ANIM_OBJ_BONE_RUSH, 132, 56, $2
	anim_wait 16
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 120, 48, $0
	anim_wait 16
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 144, 64, $0
	anim_wait 16
	anim_ret

BattleAnim_LockOn:
	anim_1gfx ANIM_GFX_MISC
	anim_sound 0, 1, SFX_MIND_READER
.loop
	anim_obj ANIM_OBJ_LOCK_ON, 132, 48, $3
	anim_obj ANIM_OBJ_LOCK_ON, 132, 48, $12
	anim_obj ANIM_OBJ_LOCK_ON, 132, 48, $20
	anim_obj ANIM_OBJ_LOCK_ON, 132, 48, $31
	anim_wait 16
	anim_loop 2, .loop
	anim_wait 32
	anim_ret

BattleAnim_Outrage:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_sound 0, 1, SFX_MOVE_PUZZLE_PIECE
	anim_obj ANIM_OBJ_00, 120, 72, $0
	anim_wait 6
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 152, 40, $0
	anim_wait 16
	anim_ret

BattleAnim_Sandstorm:
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
	anim_wait 8
	anim_ret

BattleAnim_GigaDrain:
	anim_2gfx ANIM_GFX_BUBBLE, ANIM_GFX_CHARGE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1C, $0, $0, $10
	anim_sound 6, 3, SFX_GIGA_DRAIN
	anim_call BattleAnim_GigaDrain_branch_cbab3
	anim_wait 48
	anim_wait 128
	anim_incbgeffect ANIM_BG_1C
	anim_call BattleAnim_ShowMon_0
	anim_wait 1
	anim_1gfx ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_07, $0, $0, $0
.loop
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_GLIMMER, 24, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 24, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 40, 84, $0
	anim_wait 5
	anim_loop 2, .loop
	anim_wait 32
	anim_ret

BattleAnim_Endure:
	anim_1gfx ANIM_GFX_SPEED
	anim_call BattleAnim_TargetObj_1Row
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
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Charm:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_sound 0, 0, SFX_ATTRACT
	anim_obj ANIM_OBJ_HEART, 64, 80, $0
	anim_wait 32
	anim_incbgeffect ANIM_BG_26
	anim_call BattleAnim_ShowMon_0
	anim_wait 4
	anim_ret

BattleAnim_Rollout:
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SPARK
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_2E, $60, $1, $1
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_03, 136, 40, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_FalseSwipe:
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_CUT
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 136, 40, $0
	anim_wait 32
	anim_ret

BattleAnim_Swagger:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_WIND
.loop
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SWAGGER, 72, 88, $44
	anim_wait 32
	anim_loop 2, .loop
	anim_wait 32
	anim_sound 0, 1, SFX_KINESIS_2
	anim_obj ANIM_OBJ_ANGER, 104, 40, $0
	anim_wait 40
	anim_ret

BattleAnim_MilkDrink:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_BUBBLE
	anim_call BattleAnim_TargetObj_1Row
	anim_obj ANIM_OBJ_MILK_DRINK, 74, 104, $0
	anim_wait 16
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_sound 0, 0, SFX_MILK_DRINK
.loop
	anim_obj ANIM_OBJ_RECOVER, 44, 88, $20
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 128
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Spark:
	anim_2gfx ANIM_GFX_LIGHTNING, ANIM_GFX_EXPLOSION
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $4, $3
	anim_obj ANIM_OBJ_THUNDER_WAVE, 48, 92, $0
	anim_wait 24
	anim_setobj $1, $3
	anim_wait 1
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_sound 0, 0, SFX_SPARK
	anim_wait 16
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_incobj 2
	anim_wait 1
	anim_sound 0, 1, SFX_THUNDERSHOCK
	anim_obj ANIM_OBJ_LIGHTNING_BOLT, 136, 56, $2
	anim_obj ANIM_OBJ_33, 136, 56, $0
	anim_wait 32
	anim_ret

BattleAnim_FuryCutter:
	anim_1gfx ANIM_GFX_CUT
.loop
	anim_sound 0, 1, SFX_CUT
	anim_if_param_and %00000001, .obj1
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_jump .okay

.obj1
	anim_obj ANIM_OBJ_3B, 112, 40, $0
.okay
	anim_wait 16
	anim_jumpuntil .loop
	anim_ret

BattleAnim_SteelWing:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_SteelWing_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_1gfx ANIM_GFX_HIT
	anim_resetobp0
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
	anim_wait 16
	anim_ret

BattleAnim_MeanLook:
	anim_1gfx ANIM_GFX_PSYCHIC
	anim_obp0 $e0
	anim_sound 0, 1, SFX_MEAN_LOOK
	anim_obj ANIM_OBJ_MEAN_LOOK, 148, 32, $0
	anim_wait 5
	anim_obj ANIM_OBJ_MEAN_LOOK, 116, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_MEAN_LOOK, 148, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_MEAN_LOOK, 116, 32, $0
	anim_wait 5
	anim_obj ANIM_OBJ_MEAN_LOOK, 132, 48, $0
	anim_wait 128
	anim_ret

BattleAnim_Attract:
	anim_1gfx ANIM_GFX_OBJECTS
.loop
	anim_sound 0, 0, SFX_ATTRACT
	anim_obj ANIM_OBJ_ATTRACT, 44, 80, $2
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 128
	anim_wait 64
	anim_ret

BattleAnim_SleepTalk:
	anim_1gfx ANIM_GFX_STATUS
.loop
	anim_sound 0, 0, SFX_STRENGTH
	anim_obj ANIM_OBJ_ASLEEP, 64, 80, $0
	anim_wait 40
	anim_loop 2, .loop
	anim_wait 32
	anim_ret

BattleAnim_HealBell:
	anim_2gfx ANIM_GFX_MISC, ANIM_GFX_NOISE
	anim_obj ANIM_OBJ_84, 72, 56, $0
	anim_wait 32
.loop
	anim_sound 0, 0, SFX_HEAL_BELL
	anim_obj ANIM_OBJ_85, 72, 52, $0
	anim_wait 8
	anim_sound 0, 0, SFX_HEAL_BELL
	anim_obj ANIM_OBJ_85, 72, 52, $1
	anim_wait 8
	anim_sound 0, 0, SFX_HEAL_BELL
	anim_obj ANIM_OBJ_85, 72, 52, $2
	anim_wait 8
	anim_sound 0, 0, SFX_HEAL_BELL
	anim_obj ANIM_OBJ_85, 72, 52, $0
	anim_wait 8
	anim_sound 0, 0, SFX_HEAL_BELL
	anim_obj ANIM_OBJ_85, 72, 52, $2
	anim_wait 8
	anim_loop 4, .loop
	anim_wait 64
	anim_ret

BattleAnim_Return:
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_BOUNCE_DOWN, $0, $1, $0
	anim_sound 0, 0, SFX_RETURN
	anim_wait 64
	anim_incbgeffect ANIM_BG_BOUNCE_DOWN
	anim_wait 32
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_03, 136, 40, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Present:
	anim_2gfx ANIM_GFX_STATUS, ANIM_GFX_BUBBLE
	anim_sound 0, 1, SFX_PRESENT
	anim_obj ANIM_OBJ_PRESENT, 64, 88, $6c
	anim_wait 56
	anim_obj ANIM_OBJ_AMNESIA, 104, 48, $0
	anim_wait 48
	anim_incobj 2
	anim_if_param_equal $3, .heal
	anim_incobj 1
	anim_wait 1
	anim_1gfx ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $12
.loop
	anim_call BattleAnim_Present_branch_cbb8f
	anim_wait 16
	anim_jumpuntil .loop
	anim_ret

.heal
	anim_sound 0, 1, SFX_METRONOME
.loop2
	anim_obj ANIM_OBJ_RECOVER, 132, 48, $24
	anim_wait 8
	anim_loop 8, .loop2
	anim_wait 128
	anim_ret

BattleAnim_Frustration:
	anim_1gfx ANIM_GFX_MISC
	anim_sound 0, 0, SFX_KINESIS_2
	anim_obj ANIM_OBJ_ANGER, 72, 80, $0
	anim_wait 40
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 120, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 152, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 48, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_26
	anim_wait 1
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_Safeguard:
	anim_1gfx ANIM_GFX_MISC
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_obj ANIM_OBJ_SAFEGUARD, 80, 80, $0
	anim_obj ANIM_OBJ_SAFEGUARD, 80, 80, $d
	anim_obj ANIM_OBJ_SAFEGUARD, 80, 80, $1a
	anim_obj ANIM_OBJ_SAFEGUARD, 80, 80, $27
	anim_obj ANIM_OBJ_SAFEGUARD, 80, 80, $34
	anim_sound 0, 0, SFX_PROTECT
	anim_wait 96
	anim_ret

BattleAnim_PainSplit:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_OBJECTS
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_TACKLE
	anim_obj ANIM_OBJ_04, 112, 48, $0
	anim_obj ANIM_OBJ_04, 76, 96, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_wait 1
	anim_ret

BattleAnim_SacredFire:
	anim_1gfx ANIM_GFX_FIRE
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
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
	anim_wait 8
	anim_ret

BattleAnim_Magnitude:
	anim_1gfx ANIM_GFX_ROCKS
.loop
	anim_bgeffect ANIM_BG_1F, $e, $4, $0
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 128, 64, $40
	anim_wait 2
	anim_obj ANIM_OBJ_SMALL_ROCK, 120, 68, $30
	anim_wait 2
	anim_obj ANIM_OBJ_SMALL_ROCK, 152, 68, $30
	anim_wait 2
	anim_obj ANIM_OBJ_SMALL_ROCK, 144, 64, $40
	anim_wait 2
	anim_obj ANIM_OBJ_SMALL_ROCK, 136, 68, $30
	anim_wait 2
	anim_jumpuntil .loop
	anim_wait 96
	anim_ret

BattleAnim_Dynamicpunch:
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $12
	anim_call BattleAnim_Dynamicpunch_branch_cbb8f
	anim_wait 16
	anim_ret

BattleAnim_Megahorn:
	anim_2gfx ANIM_GFX_HORN, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_1F, $40, $2, $0
	anim_wait 48
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $3
	anim_obj ANIM_OBJ_HORN, 72, 80, $1
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_wait 16
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Dragonbreath:
	anim_1gfx ANIM_GFX_FIRE
	anim_sound 6, 2, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_DRAGONBREATH, 64, 92, $4
	anim_wait 4
	anim_loop 10, .loop
	anim_wait 64
	anim_ret

BattleAnim_BatonPass:
	anim_1gfx ANIM_GFX_MISC
	anim_obj ANIM_OBJ_BATON_PASS, 44, 104, $20
	anim_sound 0, 0, SFX_BATON_PASS
	anim_call BattleAnim_BatonPass_branch_c9486
	anim_wait 64
	anim_ret

BattleAnim_Encore:
	anim_1gfx ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_99, 64, 80, $90
	anim_obj ANIM_OBJ_99, 64, 80, $10
	anim_sound 0, 0, SFX_ENCORE
	anim_wait 16
	anim_obj ANIM_OBJ_9A, 64, 72, $2c
	anim_wait 32
	anim_obj ANIM_OBJ_9A, 64, 72, $34
	anim_wait 16
	anim_ret

BattleAnim_Pursuit:
	anim_1gfx ANIM_GFX_HIT
	anim_if_param_equal $1, BattleAnim_Pursuit_branch_cb62b
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_Pursuit_branch_cb62b:
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $0, $0
	anim_wait 4
	anim_call BattleAnim_UserObj_1Row
	anim_obj ANIM_OBJ_AD, 132, 64, $0
	anim_wait 64
	anim_obj ANIM_OBJ_AD, 132, 64, $1
	anim_sound 0, 1, SFX_BALL_POOF
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $0, $0
	anim_wait 64
	anim_incobj 3
	anim_wait 16
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_00, 120, 56, $0
	anim_bgeffect ANIM_BG_2D, $0, $0, $0
	anim_wait 16
	anim_call BattleAnim_ShowMon_1
	anim_wait 1
	anim_ret

BattleAnim_MortalSpin:
; Poison-type spin: tint the effect purple, then reuse the Rapid Spin script.
	anim_purplepal
	anim_jump BattleAnim_RapidSpin

BattleAnim_RapidSpin:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HIT
	anim_obp0 $e4
.loop
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_RAPID_SPIN, 44, 112, $0
	anim_wait 2
	anim_loop 5, .loop
	anim_wait 24
	anim_call BattleAnim_TargetObj_2Row
	anim_bgeffect ANIM_BG_25, $0, $1, $0
	anim_wait 4
	anim_resetobp0
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_04, 136, 40, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 4
	anim_incobj 6
	anim_wait 1
	anim_ret

BattleAnim_SweetScent:
	anim_2gfx ANIM_GFX_FLOWER, ANIM_GFX_MISC
	anim_sound 0, 0, SFX_SWEET_SCENT
	anim_obj ANIM_OBJ_FLOWER, 64, 96, $2
	anim_wait 2
	anim_obj ANIM_OBJ_FLOWER, 64, 80, $2
	anim_wait 96
	anim_obp0 $54
	anim_sound 0, 1, SFX_SWEET_SCENT_2
	anim_obj ANIM_OBJ_COTTON, 136, 40, $15
	anim_obj ANIM_OBJ_COTTON, 136, 40, $2a
	anim_obj ANIM_OBJ_COTTON, 136, 40, $3f
	anim_wait 128
	anim_ret

BattleAnim_IronTail:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_IronTail_branch_cbc43
	anim_wait 4
	anim_1gfx ANIM_GFX_HIT
	anim_resetobp0
	anim_bgeffect ANIM_BG_26, $0, $1, $0
	anim_wait 16
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_00, 136, 48, $0
	anim_wait 16
	anim_incbgeffect ANIM_BG_26
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_MetalClaw:
	anim_1gfx ANIM_GFX_REFLECT
	anim_obp0 $0
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_call BattleAnim_MetalClaw_branch_cbc43
	anim_call BattleAnim_ShowMon_0
	anim_1gfx ANIM_GFX_CUT
	anim_resetobp0
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_wait 32
	anim_ret

BattleAnim_VitalThrow:
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
	anim_wait 16
	anim_ret

BattleAnim_MorningSun:
	anim_1gfx ANIM_GFX_SHINE
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 0, SFX_MORNING_SUN
.loop
	anim_obj ANIM_OBJ_MORNING_SUN, 16, 48, $88
	anim_wait 6
	anim_loop 5, .loop
	anim_wait 32
	anim_if_param_equal 0, .zero
	anim_call BattleAnim_MorningSun_branch_cbc6a
	anim_ret

.zero
	anim_call BattleAnim_MorningSun_branch_cbc80
	anim_ret

BattleAnim_Synthesis:
	anim_1gfx ANIM_GFX_SHINE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_18, $0, $1, $40
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_sound 0, 0, SFX_OUTRAGE
	anim_wait 72
	anim_incbgeffect ANIM_BG_18
	anim_call BattleAnim_ShowMon_0
	anim_if_param_equal $1, .one
	anim_call BattleAnim_Synthesis_branch_cbc6a
	anim_ret

.one
	anim_call BattleAnim_Synthesis_branch_cbc80
	anim_ret

BattleAnim_Crunch:
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_bgeffect ANIM_BG_1F, $20, $2, $0
	anim_obj ANIM_OBJ_BITE, 136, 56, $a8
	anim_obj ANIM_OBJ_BITE, 136, 56, $28
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_00, 144, 48, $18
	anim_wait 16
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_00, 128, 64, $18
	anim_wait 8
	anim_ret

BattleAnim_Moonlight:
; A pale moon globe rises up, then shimmers for the heal.
	anim_2gfx ANIM_GFX_GLOBE, ANIM_GFX_SHINE
	anim_bgp $1b
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_obj ANIM_OBJ_MOON_GLOBE, 88, 104, $1
	anim_wait 1
	anim_sound 0, 0, SFX_MOONLIGHT
	anim_wait 130
	; a silvery shimmer wavers over the Pokemon right before the heal
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_GLIMMER, 48, 48, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 60, 64, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 36, 72, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 56, 88, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 44, 60, $0
	anim_wait 4
	anim_obj ANIM_OBJ_GLIMMER, 64, 80, $0
	anim_wait 8
	anim_if_param_equal $3, .three
	anim_call BattleAnim_Moonlight_branch_cbc6a
	anim_ret

.three
	anim_call BattleAnim_Moonlight_branch_cbc80
	anim_ret

BattleAnim_HiddenPower:
	anim_1gfx ANIM_GFX_CHARGE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_bgeffect ANIM_BG_07, $0, $2, $0
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $0
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $8
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $10
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $18
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $20
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $28
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $30
	anim_obj ANIM_OBJ_HIDDEN_POWER, 44, 88, $38
.loop
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_wait 8
	anim_loop 12, .loop
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_wait 1
	anim_incobj 2
	anim_incobj 3
	anim_incobj 4
	anim_incobj 5
	anim_incobj 6
	anim_incobj 7
	anim_incobj 8
	anim_incobj 9
	anim_wait 16
	anim_1gfx ANIM_GFX_HIT
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 32
	anim_ret

BattleAnim_CrossChop:
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_A0, 152, 40, $0
	anim_obj ANIM_OBJ_A1, 120, 72, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_1F, $58, $2, $0
	anim_wait 92
	anim_sound 0, 1, SFX_VICEGRIP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_wait 16
	anim_ret

BattleAnim_Twister:
	anim_2gfx ANIM_GFX_WIND, ANIM_GFX_HIT
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
	anim_obj ANIM_OBJ_01, 144, 64, $18
.loop3
	anim_sound 0, 1, SFX_RAZOR_WIND
	anim_wait 8
	anim_loop 4, .loop3
	anim_obj ANIM_OBJ_01, 128, 32, $18
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

BattleAnim_RainDance:
	anim_1gfx ANIM_GFX_WATER
	anim_bgp $f8
	anim_obp0 $7c
	anim_sound 0, 1, SFX_RAIN_DANCE
	anim_obj ANIM_OBJ_RAIN, 88, 0, $0
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $1
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 128
	anim_ret

BattleAnim_SunnyDay:
	anim_1gfx ANIM_GFX_WATER
	anim_bgp $90
	anim_sound 0, 1, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 128
	anim_ret

BattleAnim_MirrorCoat:
	anim_2gfx ANIM_GFX_REFLECT, ANIM_GFX_SPEED
	anim_bgeffect ANIM_BG_06, $0, $2, $0
.loop
	anim_sound 0, 0, SFX_SHINE
	anim_obj ANIM_OBJ_SCREEN, 72, 80, $0
	anim_obj ANIM_OBJ_AE, 64, 72, $4
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 88, $4
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 80, $4
	anim_wait 8
	anim_obj ANIM_OBJ_AE, 64, 96, $4
	anim_wait 8
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_PsychUp:
	anim_1gfx ANIM_GFX_STATUS
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1A, $0, $1, $20
	anim_sound 0, 0, SFX_PSYBEAM
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $0
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $10
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $20
	anim_obj ANIM_OBJ_PSYCH_UP, 44, 88, $30
	anim_wait 64
	anim_incbgeffect ANIM_BG_1A
	anim_call BattleAnim_ShowMon_0
	anim_wait 16
	anim_ret

BattleAnim_Extremespeed:
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_CUT
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_Ancientpower:
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 64, 108, $20
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 75, 102, $20
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 85, 97, $20
	anim_wait 8
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 96, 92, $20
	anim_wait 8
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 106, 87, $20
	anim_wait 8
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 116, 82, $20
	anim_wait 8
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 126, 77, $20
	anim_wait 8
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_00, 136, 56, $0
	anim_wait 6
	anim_ret

BattleAnim_ShadowBall:
	anim_2gfx ANIM_GFX_EGG, ANIM_GFX_SMOKE
	anim_bgp $1b
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SHADOW_BALL, 64, 92, $2
	anim_wait 32
	anim_obj ANIM_OBJ_BALL_POOF, 132, 56, $10
	anim_wait 24
	anim_ret

BattleAnim_SuckerPunch:
; Quick Attack timing, but screen goes visibly dark (BGP/black hues) before the lunge
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_sound 0, 0, SFX_CURSE
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_wait 36
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 5
	anim_sound 0, 1, SFX_DOUBLESLAP
	anim_obj ANIM_OBJ_01, 132, 54, $10
	anim_wait 4
	anim_sound 0, 1, SFX_HEADBUTT
	anim_obj ANIM_OBJ_01, 140, 52, $0
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 134, 50, $0
	anim_wait 5
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_01, 136, 52, $8
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_resetobp0
	anim_wait 20
	anim_ret

BattleAnim_DarkPulse:
; Dark screen, Psychic waves, then foe shiver (EnemyStatDown-style vibrate; max 5 BG slots)
	anim_3gfx ANIM_GFX_PSYCHIC, ANIM_GFX_EGG, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_wait 32
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
.loop_waves
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 64, 88, $2
	anim_wait 6
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 56, 86, $2
	anim_wait 6
	anim_sound 6, 2, SFX_PSYCHIC
	anim_obj ANIM_OBJ_WAVE, 72, 90, $2
	anim_wait 6
	anim_loop 2, .loop_waves
	anim_wait 16
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_sound 6, 2, SFX_SLUDGE_BOMB
	anim_obj ANIM_OBJ_SHADOW_BALL, 64, 92, $2
	anim_wait 20
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect ANIM_BG_VIBRATE_MON, $0, $0, $0
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 128, 52, $8
	anim_wait 40
	anim_call BattleAnim_ShowMon_1
	anim_resetobp0
	anim_wait 8
	anim_ret

BattleAnim_FutureSight:
	anim_1gfx ANIM_GFX_WIND
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_bgeffect ANIM_BG_PSYCHIC, $0, $0, $0
	anim_obj ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj ANIM_OBJ_AGILITY, 8, 48, $2
	anim_obj ANIM_OBJ_AGILITY, 8, 88, $8
	anim_wait 4
	anim_obj ANIM_OBJ_AGILITY, 8, 32, $6
	anim_obj ANIM_OBJ_AGILITY, 8, 56, $c
	anim_obj ANIM_OBJ_AGILITY, 8, 80, $4
	anim_obj ANIM_OBJ_AGILITY, 8, 104, $e
.loop
	anim_sound 0, 0, SFX_THROW_BALL
	anim_wait 16
	anim_loop 4, .loop
	anim_incbgeffect ANIM_BG_PSYCHIC
	anim_ret

BattleAnim_RockSmash:
	anim_2gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_01, 128, 56, $0
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $28
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $5c
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $10
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $e8
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $9c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $d0
	anim_wait 6
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $1c
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $50
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $dc
	anim_obj ANIM_OBJ_ROCK_SMASH, 128, 64, $90
	anim_wait 32
	anim_ret

BattleAnim_Whirlpool:
	anim_1gfx ANIM_GFX_WIND
	anim_bgeffect ANIM_BG_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 1, SFX_SURF
	anim_wait 16
.loop
	anim_obj ANIM_OBJ_GUST, 132, 72, $0
	anim_wait 6
	anim_loop 9, .loop
	anim_wait 64
	anim_incbgeffect ANIM_BG_WHIRLPOOL
	anim_wait 1
	anim_ret

BattleAnim_BeatUp:
	anim_if_param_equal $0, .current_mon
	anim_sound 0, 0, SFX_BALL_POOF
	anim_bgeffect ANIM_BG_RETURN_MON, $0, $1, $0
	anim_wait 16
	anim_beatup
	anim_sound 0, 0, SFX_BALL_POOF
	anim_bgeffect ANIM_BG_ENTER_MON, $0, $1, $0
	anim_wait 16
.current_mon
	anim_1gfx ANIM_GFX_HIT
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_TACKLE, $0, $1, $0
	anim_wait 4
	anim_sound 0, 1, SFX_BEAT_UP
	anim_obj ANIM_OBJ_00, 136, 48, $0
	anim_wait 8
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_DreamEater_branch_cbab3:
BattleAnim_GigaDrain_branch_cbab3:
BattleAnim_LeechLife_branch_cbab3:
	anim_obj ANIM_OBJ_71, 132, 44, $0
	anim_obj ANIM_OBJ_71, 132, 44, $8
	anim_obj ANIM_OBJ_71, 132, 44, $10
	anim_obj ANIM_OBJ_71, 132, 44, $18
	anim_obj ANIM_OBJ_71, 132, 44, $20
	anim_obj ANIM_OBJ_71, 132, 44, $28
	anim_obj ANIM_OBJ_71, 132, 44, $30
	anim_obj ANIM_OBJ_71, 132, 44, $38
	anim_ret

BattleAnim_Glare_branch_cbadc:
BattleAnim_Leer_branch_cbadc:
BattleAnim_ScaryFace_branch_cbadc:
	anim_sound 6, 2, SFX_LEER
	anim_obj ANIM_OBJ_4E, 72, 84, $0
	anim_obj ANIM_OBJ_4E, 64, 80, $0
	anim_obj ANIM_OBJ_4E, 88, 76, $0
	anim_obj ANIM_OBJ_4E, 80, 72, $0
	anim_obj ANIM_OBJ_4E, 104, 68, $0
	anim_obj ANIM_OBJ_4E, 96, 64, $0
	anim_obj ANIM_OBJ_4E, 120, 60, $0
	anim_obj ANIM_OBJ_4E, 112, 56, $0
	anim_obj ANIM_OBJ_4F, 130, 54, $0
	anim_obj ANIM_OBJ_4F, 122, 50, $0
	anim_ret

BattleAnim_Fly_branch_cbb12:
BattleAnim_Teleport_branch_cbb12:
	anim_sound 0, 0, SFX_WARP_TO
	anim_obj ANIM_OBJ_44, 44, 108, $0
	anim_obj ANIM_OBJ_44, 44, 100, $0
	anim_obj ANIM_OBJ_44, 44, 92, $0
	anim_obj ANIM_OBJ_44, 44, 84, $0
	anim_obj ANIM_OBJ_44, 44, 76, $0
	anim_obj ANIM_OBJ_44, 44, 68, $0
	anim_obj ANIM_OBJ_44, 44, 60, $0
	anim_ret

BattleAnim_AuroraBeam_branch_cbb39:
BattleAnim_HyperBeam_branch_cbb39:
BattleAnim_Solarbeam_branch_cbb39:
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
	anim_ret

BattleAnim_Explosion_branch_cbb62:
BattleAnim_Selfdestruct_branch_cbb62:
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 24, 64, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 56, 104, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 24, 104, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 56, 64, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 40, 84, $0
	anim_ret

BattleAnim_Dynamicpunch_branch_cbb8f:
BattleAnim_Explosion_branch_cbb8f:
BattleAnim_Present_branch_cbb8f:
BattleAnim_Selfdestruct_branch_cbb8f:
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 148, 32, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 116, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 148, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 116, 32, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 132, 52, $0
	anim_ret

BattleAnim_Growl_branch_cbbbc:
BattleAnim_Roar_branch_cbbbc:
BattleAnim_Snore_branch_cbbbc:
	anim_obj ANIM_OBJ_4B, 64, 76, $0
	anim_obj ANIM_OBJ_4B, 64, 88, $1
	anim_obj ANIM_OBJ_4B, 64, 100, $2
	anim_ret

BattleAnim_FirePunch_branch_cbbcc:
BattleAnim_TriAttack_branch_cbbcc:
	anim_sound 0, 1, SFX_EMBER
.loop
	anim_obj ANIM_OBJ_BURNED, 136, 56, $10
	anim_obj ANIM_OBJ_BURNED, 136, 56, $90
	anim_wait 4
	anim_loop 4, .loop
	anim_ret

BattleAnim_IcePunch_branch_cbbdf:
BattleAnim_PowderSnow_branch_cbbdf:
BattleAnim_TriAttack_branch_cbbdf:
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 128, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 144, 70, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 120, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 152, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 144, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj ANIM_OBJ_12, 128, 70, $0
	anim_ret

BattleAnim_SludgeBomb_branch_cbc15:
BattleAnim_Sludge_branch_cbc15:
BattleAnim_Toxic_branch_cbc15:
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

BattleAnim_Acid_branch_cbc35:
BattleAnim_Toxic_branch_cbc35:
.loop
	anim_sound 6, 2, SFX_BUBBLEBEAM
	anim_obj ANIM_OBJ_19, 64, 92, $10
	anim_wait 5
	anim_loop 8, .loop
	anim_ret

BattleAnim_Harden_branch_cbc43:
BattleAnim_IronTail_branch_cbc43:
BattleAnim_MetalClaw_branch_cbc43:
BattleAnim_SteelWing_branch_cbc43:
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_17, $0, $1, $40
	anim_wait 8
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 32
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 64
	anim_incbgeffect ANIM_BG_17
	anim_ret

BattleAnim_MudSlap_branch_cbc5b:
BattleAnim_SandAttack_branch_cbc5b:
.loop
	anim_sound 6, 2, SFX_MENU
	anim_obj ANIM_OBJ_58, 64, 92, $4
	anim_wait 4
	anim_loop 8, .loop
	anim_wait 32
	anim_ret

BattleAnim_Moonlight_branch_cbc6a:
BattleAnim_MorningSun_branch_cbc6a:
BattleAnim_Synthesis_branch_cbc6a:
	anim_sound 0, 0, SFX_METRONOME
	anim_obj ANIM_OBJ_GLIMMER, 44, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 24, 96, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 21
	anim_ret

BattleAnim_Moonlight_branch_cbc80:
BattleAnim_MorningSun_branch_cbc80:
BattleAnim_Synthesis_branch_cbc80:
	anim_sound 0, 0, SFX_METRONOME
.loop
	anim_obj ANIM_OBJ_GLIMMER, 24, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 24, 104, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 56, 64, $0
	anim_wait 5
	anim_obj ANIM_OBJ_GLIMMER, 40, 84, $0
	anim_wait 5
	anim_loop 2, .loop
	anim_wait 16
	anim_ret

BattleAnim_TargetObj_1Row:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_TargetObj_2Row:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $0, $0
	anim_wait 6
	anim_ret

BattleAnim_ShowMon_0:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $0, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_UserObj_1Row:
	anim_battlergfx_2row
	anim_bgeffect ANIM_BG_BATTLEROBJ_1ROW, $0, $1, $0
	anim_wait 6
	anim_ret

BattleAnim_UserObj_2Row:
	anim_battlergfx_1row
	anim_bgeffect ANIM_BG_BATTLEROBJ_2ROW, $0, $1, $0
	anim_wait 4
	anim_ret

BattleAnim_ShowMon_1:
	anim_wait 1
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_LeafBlade:
; Sharp grass blades slash the target
	anim_2gfx ANIM_GFX_PLANT, ANIM_GFX_CUT
	anim_sound 0, 0, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_RAZOR_LEAF, 56, 80, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 88, $5c
	anim_wait 12
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_obj ANIM_OBJ_3A, 120, 72, $0
	anim_wait 24
	anim_ret

BattleAnim_ShadowSneak:
; Dark shadow lunge from behind (priority ghost strike)
	anim_2gfx ANIM_GFX_SPEED, ANIM_GFX_HIT
	anim_bgp $1b
	anim_obp0 $c0
	anim_bgeffect ANIM_BG_BLACK_HUES, $0, $8, $0
	anim_sound 0, 0, SFX_CURSE
	anim_wait 20
	anim_sound 0, 0, SFX_MENU
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $80
	anim_wait 12
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_04, 136, 48, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

BattleAnim_ShadowPunch:
; Faint Attack vanish, then a silent Thunder Punch fist from the dark
	anim_1gfx ANIM_GFX_HIT
	anim_sound 0, 0, SFX_CURSE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1D, $0, $1, $80
	anim_wait 40
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_wait 64
	anim_incbgeffect ANIM_BG_1D
	anim_call BattleAnim_ShowMon_0
	anim_wait 4
	anim_ret

BattleAnim_ShadowClaw:
; Faint Attack vanish, then brutal slash rakes from the dark
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_CURSE
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1D, $0, $1, $80
	anim_wait 40
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3B, 112, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 148, 36, $0
	anim_bgeffect ANIM_BG_1F, $58, $2, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_sound 0, 1, SFX_VICEGRIP
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_incbgeffect ANIM_BG_1D
	anim_call BattleAnim_ShowMon_0
	anim_wait 4
	anim_ret

BattleAnim_PoisonJab:
; Poisonous thrust into the target
	anim_purplepal
	anim_3gfx ANIM_GFX_HORN, ANIM_GFX_POISON, ANIM_GFX_HIT
	anim_obj ANIM_OBJ_HORN, 72, 80, $1
	anim_wait 12
	anim_sound 0, 1, SFX_HORN_ATTACK
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_call BattleAnim_Toxic_branch_cbc35
	anim_sound 0, 1, SFX_TOXIC
	anim_obj ANIM_OBJ_1A, 136, 62, $0
	anim_wait 16
	anim_ret

BattleAnim_Lunge:
; Bug-quick dash: speed lines + powder trail, no hide-mon
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_POWDER, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 8
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 88, 84, $11
	anim_obj ANIM_OBJ_POWDER, 96, 80, $13
	anim_wait 4
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 104, 76, $12
	anim_wait 4
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 16
	anim_ret

BattleAnim_BugBite:
; Buggy chomp: powder skitter then repeated bites
	anim_3gfx ANIM_GFX_POWDER, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_sound 0, 1, SFX_MENU
	anim_obj ANIM_OBJ_POWDER, 112, 72, $12
	anim_obj ANIM_OBJ_POWDER, 120, 68, $14
	anim_wait 6
	anim_obj ANIM_OBJ_BITE, 136, 56, $98
	anim_obj ANIM_OBJ_BITE, 136, 56, $18
	anim_wait 6
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 144, 48, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_01, 128, 64, $18
	anim_wait 8
	anim_sound 0, 1, SFX_BITE
	anim_obj ANIM_OBJ_00, 136, 52, $0
	anim_wait 12
	anim_ret

BattleAnim_XScissor:
; Crossing scissor-claw slash
	anim_1gfx ANIM_GFX_CUT
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_A0, 152, 40, $0
	anim_obj ANIM_OBJ_A1, 120, 72, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_1F, $58, $2, $0
	anim_wait 16
	anim_sound 0, 1, SFX_VICEGRIP
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_wait 16
	anim_ret

BattleAnim_UTurn:
	anim_1gfx ANIM_GFX_SPEED
	anim_sound 6, 2, SFX_THROW_BALL
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_call BattleAnimSub_UTurnQuickAttack
	anim_wait 12
	anim_1gfx ANIM_GFX_U_TURN
	anim_obj ANIM_OBJ_BLUR_DIAGONAL, 64, 92, $18
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_1gfx ANIM_GFX_HIT
	anim_wait 1
	anim_sound 0, 1, SFX_DOUBLE_KICK
	anim_obj ANIM_OBJ_HIT_BIG_YFIX, 132, 56, $0
	anim_wait 8
	anim_clearobjs
	anim_wait 1
	anim_1gfx ANIM_GFX_U_TURN
	anim_wait 1
	anim_sound 0, 0, SFX_RETURN
	anim_obj ANIM_OBJ_BLUR_VERTICAL_UP, 132, 30, $30
	anim_wait 32
	anim_clearobjs
	anim_obj ANIM_OBJ_BLUR_VERTICAL_DOWN, 48, 0, $10
	anim_wait 16
	anim_clearobjs
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_ret

BattleAnimSub_UTurnQuickAttack:
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_ret

BattleAnim_DragonClaw:
; Powerful dragon claw rake
	anim_2gfx ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_sound 0, 0, SFX_RAGE
	anim_call BattleAnim_TargetObj_1Row
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_37, 144, 48, $0
	anim_obj ANIM_OBJ_37, 140, 44, $0
	anim_obj ANIM_OBJ_37, 136, 40, $0
	anim_wait 8
	anim_sound 0, 1, SFX_SCRATCH
	anim_obj ANIM_OBJ_37, 132, 36, $0
	anim_call BattleAnim_ShowMon_0
	anim_wait 16
	anim_ret

BattleAnim_DracoMeteor:
; Meteor shower, rock barrage, then a brutal crash on the foe
	anim_3gfx ANIM_GFX_ROCKS, ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_1F, $c0, $1, $0
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 24, 108, $20
	anim_wait 4
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 40, 100, $20
	anim_wait 4
	anim_sound 0, 0, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 56, 92, $20
	anim_wait 4
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 72, 84, $20
	anim_wait 4
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 88, 76, $20
	anim_wait 4
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 104, 68, $20
	anim_wait 4
	anim_sound 0, 1, SFX_SPARK
	anim_obj ANIM_OBJ_ANCIENTPOWER, 120, 60, $20
	anim_wait 6
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 128, 64, $40
	anim_wait 3
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 136, 56, $30
	anim_wait 3
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_SMALL_ROCK, 144, 68, $30
	anim_wait 3
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_BIG_ROCK, 132, 52, $40
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $20
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_BIG_ROCK, 136, 24, $48
	anim_wait 8
	anim_bgeffect ANIM_BG_1F, $e0, $4, $10
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_18, 136, 56, $0
	anim_obj ANIM_OBJ_18, 128, 48, $0
	anim_obj ANIM_OBJ_18, 144, 64, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $10
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_03, 144, 48, $0
	anim_obj ANIM_OBJ_04, 136, 36, $0
	anim_obj ANIM_OBJ_05, 128, 52, $0
	anim_wait 32
	anim_ret

BattleAnim_Moonblast:
; Moonlight charge, then aurora beam blast
	anim_2gfx ANIM_GFX_SHINE, ANIM_GFX_BEAM
	anim_bgp $1b
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 0, 40, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 16, 56, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 32, 72, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 48, 88, $0
	anim_obj ANIM_OBJ_MOONLIGHT, 64, 104, $0
	anim_wait 1
	anim_sound 0, 0, SFX_MOONLIGHT
	anim_wait 104
	anim_call BattleAnim_Moonlight_branch_cbc6a
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_bgeffect ANIM_BG_ALTERNATE_HUES, $0, $2, $0
	anim_wait 16
	anim_call BattleAnim_AuroraBeam_branch_cbb39
	anim_wait 40
	anim_ret

BattleAnim_BloodMoon:
; A blood-red globe rises and floats up, gathers crimson energy, then fires a Hyper Beam-style blast.
	anim_3gfx ANIM_GFX_GLOBE, ANIM_GFX_CHARGE, ANIM_GFX_BEAM
	anim_bgp $1b
	anim_bgeffect ANIM_BG_07, $0, $0, $0
	anim_obj ANIM_OBJ_BLOOD_MOON_GLOBE, 88, 104, $1
	anim_wait 1
	anim_sound 0, 0, SFX_MOONLIGHT
	anim_wait 130
	; moon has risen to its peak and stopped; gather crimson energy into the Pokemon before firing
	anim_sound 0, 0, SFX_CHARGE
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE_CORE, 48, 84, $0
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $0
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $8
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $10
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $18
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $20
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $28
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $30
	anim_obj ANIM_OBJ_BLOOD_MOON_CHARGE, 48, 84, $38
	anim_wait 104
	anim_bgeffect ANIM_BG_1F, $30, $4, $10
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $40
	anim_bgeffect ANIM_BG_06, $0, $2, $0
	anim_wait 16
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BLOOD_MOON_BEAM, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BLOOD_MOON_BEAM, 80, 84, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BLOOD_MOON_BEAM, 96, 76, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj ANIM_OBJ_BLOOD_MOON_BEAM, 112, 68, $0
	anim_obj ANIM_OBJ_BLOOD_MOON_BEAM_END, 126, 62, $0
	anim_wait 40
	anim_ret

BattleAnim_PixiePunch:
; Thunder Punch fist impact, hearts rise from contact on the punch sound
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_OBJECTS
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_sound 0, 1, SFX_COMET_PUNCH
	anim_sound 0, 0, SFX_SWEET_KISS_2
	anim_obj ANIM_OBJ_HEART, 136, 56, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HEART, 132, 44, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HEART, 128, 32, $0
	anim_wait 8
	anim_obj ANIM_OBJ_HEART, 124, 20, $0
	anim_wait 40
	anim_ret

BattleAnim_BulletPunch:
; A Mach Punch rush followed by a metallic flash and fist impact.
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_REFLECT, ANIM_GFX_HIT
	anim_obp0 $0
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 12
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect ANIM_BG_17, $0, $1, $40
	anim_obj ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 8
	anim_incbgeffect ANIM_BG_17
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_resetobp0
	anim_wait 16
	anim_ret

BattleAnim_StatUp:
; Generic stat raise animation (ported from Polished Crystal).
; Rising bars + SFX; the mon pulses to black. Loops once per stage.
; ANIM_BG_19 = fade mon to black repeating (Polished's ANIM_BG_FADE_MON_TO_BLACK_REPEATING)
	anim_1gfx ANIM_GFX_STATS
	anim_bgeffect ANIM_BG_19, $0, $1, $40
	anim_obp0 $30
.loop
	anim_sound 0, 0, SFX_STAT_UP
	anim_obj ANIM_OBJ_STAT_UP, 44, 107, $30
	anim_wait 12
	anim_statloop .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_19
	anim_ret

BattleAnim_StatDown:
; Generic stat drop animation (ported from Polished Crystal).
	anim_1gfx ANIM_GFX_STATS
	anim_bgeffect ANIM_BG_19, $0, $1, $40
	anim_obp0 $30
.loop
	anim_sound 0, 0, SFX_STAT_DOWN
	anim_obj ANIM_OBJ_STAT_DOWN, 44, 56, $10
	anim_wait 12
	anim_statloop .loop
	anim_wait 8
	anim_incbgeffect ANIM_BG_19
	anim_ret

BattleAnim_DrainPunch:
; Heavy fist impact, then Absorb-style HP drain from the target.
	anim_2gfx ANIM_GFX_HIT, ANIM_GFX_CHARGE
	anim_sound 0, 1, SFX_MEGA_PUNCH
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_wait 6
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 12
	anim_call BattleAnim_TargetObj_1Row
	anim_bgeffect ANIM_BG_1C, $0, $0, $10
	anim_setvar $0
.loop
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 6
	anim_incvar
	anim_if_var_equal $5, .done
	anim_jump .loop

.done
	anim_wait 24
	anim_incbgeffect ANIM_BG_1C
	anim_call BattleAnim_ShowMon_0
	anim_ret

BattleAnim_SolarBlade:
	anim_if_param_equal $0, .FireSolarBlade
	; Charge sunlight into a green blade around the user.
	anim_2gfx ANIM_GFX_CHARGE, ANIM_GFX_PLANT
	anim_bgp $90
	anim_sound 0, 0, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_3D, 48, 84, $0
	anim_obj ANIM_OBJ_3C, 48, 84, $0
	anim_obj ANIM_OBJ_3C, 48, 84, $8
	anim_obj ANIM_OBJ_3C, 48, 84, $10
	anim_obj ANIM_OBJ_3C, 48, 84, $18
	anim_wait 16
	anim_sound 0, 0, SFX_VINE_WHIP
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $28
	anim_obj ANIM_OBJ_RAZOR_LEAF, 48, 80, $5c
	anim_wait 24
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $4
	anim_wait 64
	anim_ret

.FireSolarBlade:
	; Sunny Day glare, then a barrage of single-blade cut slashes.
	anim_3gfx ANIM_GFX_WATER, ANIM_GFX_CUT, ANIM_GFX_HIT
	anim_bgp $90
	anim_sound 0, 1, SFX_MORNING_SUN
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 16
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $3
	anim_bgeffect ANIM_BG_1F, $e0, $2, $0
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 40, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 120, 72, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 144, 32, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 128, 64, $0
	anim_wait 4
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 136, 44, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 152, 64, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 120, 40, $0
	anim_wait 4
	anim_sound 0, 1, SFX_CUT
	anim_obj ANIM_OBJ_3A, 140, 72, $0
	anim_wait 6
	anim_bgeffect ANIM_BG_FLASH_WHITE, $0, $4, $2
	anim_sound 0, 1, SFX_MEGA_KICK
	anim_obj ANIM_OBJ_03, 144, 48, $0
	anim_obj ANIM_OBJ_04, 136, 36, $0
	anim_obj ANIM_OBJ_05, 128, 52, $0
	anim_wait 32
	anim_ret

BattleAnim_CloseCombat:
	; Rush in, shake the screen, and pummel the target from every angle.
	anim_3gfx ANIM_GFX_SPEED, ANIM_GFX_HIT, ANIM_GFX_EXPLOSION
	anim_bgeffect ANIM_BG_HIDE_MON, $0, $1, $0
	anim_sound 0, 0, SFX_MENU
	anim_obj ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_wait 10
	anim_bgeffect ANIM_BG_1F, $e0, $4, $0
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 120, 40, $0
	anim_obj ANIM_OBJ_06, 120, 40, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 152, 64, $0
	anim_obj ANIM_OBJ_06, 152, 64, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 136, 32, $0
	anim_obj ANIM_OBJ_06, 136, 32, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 128, 72, $0
	anim_obj ANIM_OBJ_06, 128, 72, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 148, 44, $0
	anim_obj ANIM_OBJ_06, 148, 44, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 120, 60, $0
	anim_obj ANIM_OBJ_06, 120, 60, $0
	anim_wait 3
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_STRENGTH
	anim_obj ANIM_OBJ_17, 136, 56, $0
	anim_obj ANIM_OBJ_0A, 136, 56, $43
	anim_obj ANIM_OBJ_01, 136, 56, $0
	anim_wait 4
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 152, 36, $0
	anim_obj ANIM_OBJ_06, 152, 36, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 124, 76, $0
	anim_obj ANIM_OBJ_06, 124, 76, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 144, 68, $0
	anim_obj ANIM_OBJ_06, 144, 68, $0
	anim_wait 3
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj ANIM_OBJ_17, 128, 44, $0
	anim_obj ANIM_OBJ_06, 128, 44, $0
	anim_wait 3
	anim_bgeffect ANIM_BG_FLASH_INVERTED, $0, $8, $2
	anim_sound 0, 1, SFX_OUTRAGE
	anim_obj ANIM_OBJ_17, 144, 48, $0
	anim_obj ANIM_OBJ_03, 144, 48, $0
	anim_obj ANIM_OBJ_17, 136, 36, $0
	anim_obj ANIM_OBJ_04, 136, 36, $0
	anim_obj ANIM_OBJ_17, 128, 52, $0
	anim_obj ANIM_OBJ_05, 128, 52, $0
	anim_wait 8
	anim_bgeffect ANIM_BG_SHOW_MON, $0, $1, $0
	anim_wait 16
	anim_ret

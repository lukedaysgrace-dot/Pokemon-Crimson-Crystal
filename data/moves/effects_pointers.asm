MoveEffectsPointers:
; entries correspond to EFFECT_* constants
	dw NormalHit
	dw DoSleep
	dw PoisonHit
	dw LeechHit
	dw BurnHit
	dw FreezeHit
	dw ParalyzeHit
	dw Selfdestruct
	dw DreamEater
	dw MirrorMove
	dw AttackUp
	dw DefenseUp
	dw SpeedUp
	dw SpecialAttackUp
	dw SpecialDefenseUp
	dw AccuracyUp
	dw EvasionUp
	dw NormalHit
	dw AttackDown
	dw DefenseDown
	dw SpeedDown
	dw SpecialAttackDown
	dw SpecialDefenseDown
	dw AccuracyDown
	dw EvasionDown
	dw ResetStats
	dw Bide
	dw Rampage
	dw ForceSwitch
	dw MultiHit
	dw Conversion
	dw FlinchHit
	dw Heal
	dw Toxic
	dw PayDay
	dw LightScreen
	dw TriAttack
	dw NormalHit
	dw OHKOHit
	dw RazorWind
	dw SuperFang
	dw StaticDamage
	dw TrapTarget
	dw NormalHit
	dw MultiHit
	dw NormalHit
	dw Mist
	dw FocusEnergy
	dw RecoilHit
	dw DoConfuse
	dw AttackUp2
	dw DefenseUp2
	dw SpeedUp2
	dw SpecialAttackUp2
	dw SpecialDefenseUp2
	dw AccuracyUp2
	dw EvasionUp2
	dw Transform
	dw AttackDown2
	dw DefenseDown2
	dw SpeedDown2
	dw SpecialAttackDown2
	dw SpecialDefenseDown2
	dw AccuracyDown2
	dw EvasionDown2
	dw Reflect
	dw DoPoison
	dw DoParalyze
	dw AttackDownHit
	dw DefenseDownHit
	dw SpeedDownHit
	dw SpecialAttackDownHit
	dw SpecialDefenseDownHit
	dw AccuracyDownHit
	dw EvasionDownHit
	dw SkyAttack
	dw ConfuseHit
	dw PoisonMultiHit
	dw NormalHit
	dw Substitute
	dw HyperBeam
	dw Rage
	dw Mimic
	dw Metronome
	dw LeechSeed
	dw Splash
	dw Disable
	dw StaticDamage
	dw Psywave
	dw Counter
	dw Encore
	dw PainSplit
	dw Snore
	dw Conversion2
	dw LockOn
	dw Sketch
	dw DefrostOpponent
	dw SleepTalk
	dw DestinyBond
	dw Reversal
	dw Spite
	dw FalseSwipe
	dw HealBell
	dw NormalHit
	dw TripleKick
	dw Thief
	dw MeanLook
	dw Nightmare
	dw FlameWheel
	dw Curse
	dw NormalHit
	dw Protect
	dw Spikes
	dw Foresight
	dw PerishSong
	dw Sandstorm
	dw Endure
	dw Rollout
	dw Swagger
	dw FuryCutter
	dw Attract
	dw Return
	dw Present
	dw Frustration
	dw Safeguard
	dw SacredFire
	dw Magnitude
	dw BatonPass
	dw Pursuit
	dw RapidSpin
	dw NormalHit
	dw NormalHit
	dw MorningSun
	dw Synthesis
	dw Moonlight
	dw HiddenPower
	dw RainDance
	dw SunnyDay
	dw DefenseUpHit
	dw AttackUpHit
	dw AllUpHit
	dw FakeOut
	dw BellyDrum
	dw PsychUp
	dw MirrorCoat
	dw SkullBash
	dw Twister
	dw Earthquake
	dw FutureSight
	dw Gust
	dw Stomp
	dw Solarbeam
	dw Thunder
	dw Teleport
	dw BeatUp
	dw Fly
	dw DefenseCurl
	dw GigaHammer
	dw PoisonFangHit
	dw Venoshock
	dw FreezeHit ; for Blizzard, purposefully with different EFFECT_* constant
	dw Hail
	dw UTurn
	dw DracoMeteor
	dw CloseCombat
	dw ConditionalBoostHit ; EFFECT_ACROBATICS
	dw ConditionalBoostHit ; EFFECT_FACADE
	dw HexHit ; EFFECT_HEX (Infernal Parade shares this with a burn chance)
	dw ConditionalBoostHit ; EFFECT_AVALANCHE
	dw BulkUp
	dw CalmMind
	dw DragonDance
	dw HoneClaws
	dw ShellSmash
	dw SpeedUpHit
	dw FlareBlitz
	dw GyroBall
	dw KnockOff
	dw Psystrike
	dw Roost
	dw SkillSwap
	dw Trick
	dw ToxicSpikes
	dw TrickRoom
	dw DoBurn
	dw ConfuseHit ; EFFECT_HURRICANE
	dw FlameWheel ; EFFECT_SCALD (thaws the user)
	dw MortalSpin ; EFFECT_MORTAL_SPIN
	dw FirstImpression ; EFFECT_FIRST_IMPRESSION
	dw VoltTackle ; EFFECT_VOLT_TACKLE
	dw SacredSword ; EFFECT_SACRED_SWORD
	dw BrickBreak ; EFFECT_BRICK_BREAK
	dw ScaleShot ; EFFECT_SCALE_SHOT
	dw CloseCombat ; EFFECT_HEADLONG_RUSH (same self Def/SpDef drop)
	dw DireClaw ; EFFECT_DIRE_CLAW
	dw BarbBarrage ; EFFECT_BARB_BARRAGE
	dw ShellSideArm ; EFFECT_SHELL_SIDE_ARM
	dw GlaiveRush ; EFFECT_GLAIVE_RUSH
	dw EerieSpell ; EFFECT_EERIE_SPELL
	dw BanefulBunker ; EFFECT_BANEFUL_BUNKER
	dw BrickBreak ; EFFECT_RAGING_BULL (same screen-shattering hit)
	dw FickleBeam ; EFFECT_FICKLE_BEAM
	dw StoneAxe ; EFFECT_STEALTH_ROCK_HIT
	dw QuiverDance ; EFFECT_QUIVER_DANCE
	dw StealthRock ; EFFECT_STEALTH_ROCK
	dw Defog ; EFFECT_DEFOG
	dw NormalHit ; EFFECT_BODY_PRESS (stat swap in damagestats)
	dw WorkUp ; EFFECT_WORK_UP
	dw Superpower ; EFFECT_SUPERPOWER
	dw SpAtkUpHit ; EFFECT_SP_ATK_UP_HIT
	dw NormalHit ; EFFECT_FOUL_PLAY (stat swap in damagestats)
	dw RageFist ; EFFECT_RAGE_FIST
	dw HammerArm ; EFFECT_HAMMER_ARM
	dw CircleThrow ; EFFECT_CIRCLE_THROW
	dw FreezeHit ; EFFECT_FREEZE_DRY (type override in the matchup code)
	dw Bounce ; EFFECT_BOUNCE
	dw SpecialDefenseDown2Hit ; EFFECT_SP_DEF_DOWN_2_HIT

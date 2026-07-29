MoveDescriptions2:
; continuation of MoveDescriptions, from OVERHEAT onwards
; must live in the same bank as the text it points to
	dw OverheatDescription
	dw LeafStormDescription
	dw FakeOutDescription
	dw FlipTurnDescription
	dw IronDefenseDescription
	dw RockPolishDescription
	dw WoodHammerDescription
	dw HeadSmashDescription
	dw DrillRunDescription
	dw PsychoCutDescription
	dw SacredSwordDescription
	dw BrickBreakDescription
	dw HeatWaveDescription
	dw SnarlDescription
	dw NuzzleDescription
	dw BulletSeedDescription
	dw DualWingbeatDescription
	dw RockTombDescription
	dw LowSweepDescription
	dw MudShotDescription
	dw AirCutterDescription
	dw CrossPoisonDescription
	dw MagicalLeafDescription
	dw SignalBeamDescription
	dw ScaleShotDescription
	dw PhantomForceDescription
	dw HeadlongRushDescription
	dw ShadowBoneDescription
	dw DireClawDescription
	dw BarbBarrageDescription
	dw InfernalParadeDescription
	dw KowtowCleaveDescription
	dw ArmorCannonDescription
	dw ShellSideArmDescription
	dw GlaiveRushDescription
	dw DragonDartsDescription
	dw AppleAcidDescription
	dw GravAppleDescription
	dw PsyshieldDescription
	dw RagingFuryDescription
	dw StrangeSteamDescription
	dw EerieSpellDescription
	dw BanefulBunkerDescription
	dw RagingBullDescription
	dw FickleBeamDescription
	dw StoneAxeDescription
	dw QuiverDanceDescription
	dw StealthRockDescription
	dw DefogDescription
	dw BodyPressDescription
	dw WorkUpDescription
	dw SuperpowerDescription
	dw FieryDanceDescription
	dw FoulPlayDescription
	dw RageFistDescription
	dw CrushClawDescription
	dw ForcePalmDescription
	dw HammerArmDescription
	dw CircleThrowDescription
	dw FreezeDryDescription
	dw BounceDescription
	dw DragonTailDescription

OverheatDescription:
	db   "Sharply lowers"
	next "user's SPCL.ATK.@"

LeafStormDescription:
	db   "Sharply lowers"
	next "user's SPCL.ATK.@"

FakeOutDescription:
	db   "First turn only."
	next "Always flinches.@"

FlipTurnDescription:
	db   "Switches out after"
	next "making its attack.@"

IronDefenseDescription:
	db   "Sharply raises"
	next "user's DEFENSE.@"

RockPolishDescription:
	db   "Sharply raises"
	next "user's SPEED.@"

WoodHammerDescription:
	db   "A wooden slam that"
	next "hurts the user.@"

HeadSmashDescription:
	db   "A reckless charge"
	next "that hurts user.@"

DrillRunDescription:
	db   "A drilling charge."
	next "High critical hits@"

PsychoCutDescription:
	db   "Psychic blades."
	next "High critical hits@"

SacredSwordDescription:
	db   "A hallowed blade"
	next "of ancient power.@"

BrickBreakDescription:
	db   "A sharp chop with"
	next "a hardened hand.@"

HeatWaveDescription:
	db   "Hot breath that"
	next "may cause a burn.@"

SnarlDescription:
	db   "Lowers the foe's"
	next "SPCL.ATK.@"

NuzzleDescription:
	db   "A shocking nuzzle"
	next "that paralyzes.@"

BulletSeedDescription:
	db   "Fires seeds 2-5"
	next "times in a row.@"

DualWingbeatDescription:
	db   "Slams with wings"
	next "twice in a row.@"

RockTombDescription:
	db   "Boulders that"
	next "lower foe's SPEED.@"

LowSweepDescription:
	db   "A low kick that"
	next "cuts foe's SPEED.@"

MudShotDescription:
	db   "Hurls mud that"
	next "cuts foe's SPEED.@"

AirCutterDescription:
	db   "Razor wind with"
	next "high critical hits@"

CrossPoisonDescription:
	db   "A slash that may"
	next "poison the foe.@"

MagicalLeafDescription:
	db   "A magic leaf that"
	next "never misses.@"

SignalBeamDescription:
	db   "A strange beam"
	next "that may confuse.@"

ScaleShotDescription:
	db   "Fires scales 2-5"
	next "times in a row.@"

PhantomForceDescription:
	db   "Vanishes turn 1,"
	next "strikes on turn 2.@"

HeadlongRushDescription:
	db   "A reckless charge."
	next "Lowers user's DEF.@"

ShadowBoneDescription:
	db   "A haunted bone"
	next "may lower DEFENSE.@"

DireClawDescription:
	db   "Vicious claws that"
	next "often poison.@"

BarbBarrageDescription:
	db   "Toxic barbs that"
	next "often poison.@"

InfernalParadeDescription:
	db   "Double damage if"
	next "foe has a status.@"

KowtowCleaveDescription:
	db   "A grovelling slash"
	next "that never misses.@"

ArmorCannonDescription:
	db   "Fires own armor."
	next "Lowers user's DEF.@"

ShellSideArmDescription:
	db   "A shell blast that"
	next "may poison.@"

GlaiveRushDescription:
	db   "A reckless,"
	next "body-slamming dive@"

DragonDartsDescription:
	db   "Fires two dragon"
	next "darts in a row.@"

AppleAcidDescription:
	db   "Sour acid that"
	next "lowers SPCL.DEF.@"

GravAppleDescription:
	db   "Drops apples that"
	next "lower DEFENSE.@"

PsyshieldDescription:
	db   "A psychic bash"
	next "raises user's DEF.@"

RagingFuryDescription:
	db   "Rampages 2-3 turns"
	next "then confuses self@"

StrangeSteamDescription:
	db   "Strange steam that"
	next "may confuse.@"

EerieSpellDescription:
	db   "A creepy psychic"
	next "spell of power.@"

BanefulBunkerDescription:
	db   "Protects the user"
	next "from all attacks.@"

RagingBullDescription:
	db   "A furious charge"
	next "with the horns.@"

FickleBeamDescription:
	db   "A beam fired with"
	next "fickle enthusiasm.@"

StoneAxeDescription:
	db   "Scatters rocks"
	next "around the foe.@"

QuiverDanceDescription:
	db   "Raises SPCL.ATK,"
	next "SPCL.DEF and SPEED@"

StealthRockDescription:
	db   "Hurts foes when"
	next "they switch in.@"

DefogDescription:
	db   "Blows away hazards"
	next "and screens.@"

BodyPressDescription:
	db   "Attacks using the"
	next "user's DEFENSE.@"

WorkUpDescription:
	db   "Raises ATTACK and"
	next "SPCL.ATK.@"

SuperpowerDescription:
	db   "Lowers user's"
	next "ATTACK and DEFENSE@"

FieryDanceDescription:
	db   "A fiery dance that"
	next "may up SPCL.ATK.@"

FoulPlayDescription:
	db   "Attacks using the"
	next "foe's own ATTACK.@"

RageFistDescription:
	db   "Stronger the more"
	next "the user was hit.@"

CrushClawDescription:
	db   "Hard claws that"
	next "may lower DEFENSE.@"

ForcePalmDescription:
	db   "A shock wave that"
	next "may paralyze.@"

HammerArmDescription:
	db   "A heavy swing that"
	next "cuts user's SPEED.@"

CircleThrowDescription:
	db   "Throws the foe and"
	next "drags out another.@"

FreezeDryDescription:
	db   "Super effective"
	next "against WATER mon.@"

BounceDescription:
	db   "Springs up, then"
	next "lands on the foe.@"

DragonTailDescription:
	db   "Strikes and drags"
	next "out another foe.@"

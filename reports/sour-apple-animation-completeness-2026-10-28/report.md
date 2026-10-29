# Sour Apple animation completeness — October 28, 2026

**Follow-up completed:** Rapid Spin's overlap and the ten particle-capacity issues identified below have been fixed. Both ROMs build; all 22 focused native previews and all 442 move-execution checks pass. See [the fix and showcase notes](../../docs/animation-capacity-and-catalog.md). The original findings and capture data below document the pre-fix audit.

Compared every move against [PiaCarrot/mae-pokeorange, sour-apple](https://github.com/PiaCarrot/mae-pokeorange/tree/41a44630a3f712f3f45a157874361234e13e68ca), commit `41a44630a3f712f3f45a157874361234e13e68ca`. GitHub's current branch reference was checked and still points to that commit. SoupPotato/sourcrystal is not the reference for this report.

## Findings

- **Spore is present and actively selected.** The move table points to `BattleAnim_Spore_PC3` in `data/moves/animations3.asm:3560`. It creates a smoke puff, mushroom, four outward powder streams, background hue cycling and falling powder. Both attacking sides rendered these objects. The older `BattleAnim_Spore` label in `animations.asm` is unused by the move's pointer. The requested MAE branch's Spore is simpler: colored falling powder without a mushroom. Your mushroom animation resembles the separate Sour Crystal/Polished implementation.
- **All 360 shared moves have assigned, resolvable scripts.** There are 359 nonempty local move scripts plus Mirror Move's deliberate no-op: the copied move supplies its animation. MAE's Mirror Move slot instead points to `BattleAnim_0`, which falls through into Pound. This is a dispatch difference, not an unimplemented copied move.
- **Your game does not use every exact Sour Apple version.** The previous import audit classifies 166 shared scripts as matching, 37 as imported/adapted, and 157 as preserved alternatives. Those categories are provenance decisions, not proof that every preserved version is visually preferable. Every move is listed below, and the JSON/CSV inventory identifies source-only graphics, effects, palette and sound names in its reachable scripts.
- **105 source moves are absent from your move roster**, rather than missing an animation for an existing move. Of those, **103 have source animation effects**; Nature Power and Secret Power intentionally contain no separate animation. Examples with source animations include Aromatherapy, Charge Beam, Dark Void, Dragon Rush, Frenzy Plant, Hydro Cannon, Magma Storm, Seed Flare, Shadow Force, Silver Wind and Tailwind. The complete list is below.
- **Two source special-animation slots are absent:** `ANIM_SNATCHED_MOVE` and `ANIM_HELD_ITEM_TRIGGER`. Snatch is not a local move. Held item recovery already animates through `ItemRecoveryAnim` in `engine/battle/core.asm:4706`, which calls Recover. Thus the source's dedicated item-trigger presentation is missing, while item healing itself has an animation.
- **Rapid Spin has a confirmed graphics overlap.** Its initial WIND (21 tiles) plus HIT (35 tiles) upload occupies tiles 49–104. Its later two-row battler copy starts at tile 102 and overwrites three impact tiles. Actual VRAM checks reproduce this on both attacking sides. This is an existing rendering issue, not a missing Sour Apple move animation; the source script also uses the same load/copy pattern. No fix was applied during this audit.

## Notable exact-version differences

| Move | Current Crimson version | Source feature not used by that version |
| --- | --- | --- |
| Spore | Mushroom appears, shoots spores, then falling powder | Source uses only colored falling powder; its simpler presentation is replaced |
| Sonicboom | Traveling Japanese-style crescent slashes and repeated hits | Gray Gust-style vortex on target; its port exists as `BattleAnim_Sonicboom_SourApple`, but Sonicboom's pointer selects the Polished version |
| Hydro Pump | Polished multi-stream water sequence | Source's `START_WATER` / `WATER` / `END_WATER` background sequence |
| Seismic Toss | Globe lift/drop and horizontal impact shake | Source's shorter impact sequence and vertical screen shake |
| Outrage | Colored swirl, vortex and radial flames around the user | Source's darkened battler, repeated impacts and inverted flashes |
| Rock Smash | Shares the enhanced Brick Break animation | Source's dedicated rock fragments and Rock Smash objects |
| ExtremeSpeed | Polished rapid movement and impact sequence | Source's long slash graphics and cut sounds |
| Sacred Fire | Existing expanded/custom fire presentation | Source's ordinary fire palette and Sacred Fire/Fire Blast objects |
| Trick Room | Existing visuals with original repeated `SFX_UNKNOWN_66` | Source's Psybeam sound sequence; prior notes record this as a user-requested preservation |
| Beat Up / Moonlight / Spider Web / Weather Ball | Custom party sprites, rising moon, poison web, and corrected weather projectiles respectively | Source versions are replaced by the documented custom implementations |

These are alternatives, not automatically defects. The inventories below expose differences without automatically replacing customized animations.

## Verification and limits

The source inventory covers **465 source moves**, **442 local moves**, and every reachable helper, scoped label, conditional target and fallthrough in their scripts. There are **zero unresolved script targets**. The union contains 547 move names: 360 shared, 105 source-only and 82 local-only. All **23 source** and **27 local** special-animation entries were also inventoried.

Native previews exercised every shared move from both attacking sides: **720 captures**, with no script timeout. These use each move's default parameter (Selfdestruct uses parameter 1), not every charge/miss/weather/effect parameter combination. This is not a frame-by-frame comparison against a built MAE ROM. Static script and feature comparisons must not be mistaken for proof of pixel or sound equivalence.

The strict object checker initially flagged 11 moves. Ten use compatible replacement graphics through the engine's tile-offset-zero fallback: Aurora Beam, SolarBeam, Leech Life, Aqua Jet, Aqua Tail, Energy Ball, Power Gem, Rock Blast, Zen Headbutt and Bounce. Rechecking their actual replacement sheets cleared their tile uploads and frameset bounds. Rapid Spin retained the overlap failure described above. See `graphics-remap-validation.json`.

Particle-pool drops occurred in Waterfall (2), Spore (1), Stone Edge (1), Hail (20), Close Combat (15), Flare Blitz (3), Flash Cannon (2), Gunk Shot (8), Iron Head (1) and Overheat (15), per attacking-side preview. These are partial particle losses, not absent whole animations. Spore still visibly renders its mushroom, outward powder and falling powder. Hail/Close Combat/Overheat are the largest particle-loss candidates for a later cleanup.

The preview's strict restoration check also records four poison palette changes (Smog, Sludge, Poison Gas, Acid Armor); this engine explicitly resets those palettes at the next animation's entry. Teleport, Selfdestruct and Baton Pass intentionally leave a battler hidden, so their tilemap differences are not treated as missing-animation failures.

The old saved audit's dependency hashes are stale for `audio/sfx.asm`, `data/battle_anims/framesets.asm` and `data/moves/animations7.asm`. The fresh source comparison still reproduces the 166/37/157 command classifications. This report does not silently refresh the old manifest or treat its broad 'preserved' category as a visual approval.

No animation scripts, pointers, graphics or game mechanics were changed. Native preview ROM hash: `6a2c91554fd9`.

Reproduce the static inventory:

```sh
python3 tools/audit_sour_apple_completeness.py --upstream .tmpbuild/mae-sour-apple
```

Files: `all-moves.csv` is the sortable full inventory; `audit.json` contains reachable commands and feature differences; `native-captures.json` contains all 720 preview results. Source-only feature names are review clues: aliases, palette substitutions and different object implementations can produce comparable visuals.

## All 360 shared moves

The classification column reproduces the prior import decision. 'Updated' means the source script was ported with documented adaptations. 'Preserved' means an alternative remains selected. This table is an inventory, not a recommendation to overwrite every difference.

| Move | Classification | Active local entry | Source feature names absent from reachable local scripts |
| --- | --- | --- | --- |
| ABSORB | preserved | `BattleAnim_Absorb_PC3` | `PAL_BTLCUSTOM_GREEN` |
| ACID | preserved | `BattleAnim_Acid_PC3` | `PAL_BTLCUSTOM_YELLOW`, `SFX_BUBBLEBEAM` |
| ACID_ARMOR | preserved | `BattleAnim_AcidArmor` | — |
| AERIAL_ACE | preserved | `BattleAnim_AerialAce` | — |
| AEROBLAST | preserved | `BattleAnim_Aeroblast_PC3` | — |
| AGILITY | matching | `BattleAnim_Agility_PC3` | — |
| AIR_CUTTER | matching | `BattleAnim_AirCutter_CC` | — |
| AIR_SLASH | matching | `BattleAnim_AirSlash_PC3` | — |
| AMNESIA | matching | `BattleAnim_Amnesia_PC3` | — |
| ANCIENTPOWER | preserved | `BattleAnim_Ancientpower_PC3` | — |
| AQUA_JET | matching | `BattleAnim_AquaJet_PC3` | — |
| AQUA_TAIL | preserved | `BattleAnim_AquaTail` | `ANIM_GFX_HIT`, `SFX_BUBBLEBEAM` |
| ASTONISH | preserved | `BattleAnim_Astonish` | — |
| ATTRACT | matching | `BattleAnim_Attract_PC4` | — |
| AURA_SPHERE | matching | `BattleAnim_AuraSphere_PC3` | — |
| AURORA_BEAM | preserved | `BattleAnim_AuroraBeam_PC4` | `ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW`, `ANIM_GFX_BEAM_LIGHT` |
| AVALANCHE | matching | `BattleAnim_Avalanche_PC3` | — |
| BARRAGE | updated | `BattleAnim_Barrage` | — |
| BARRIER | preserved | `BattleAnim_Barrier_PC4` | — |
| BATON_PASS | preserved | `BattleAnim_BatonPass_PC4` | — |
| BEAT_UP | preserved | `BattleAnim_BeatUp` | `ANIM_OBJ_HIT_YFIX`, `ANIM_OBJ_PUNCH` |
| BELLY_DRUM | preserved | `BattleAnim_BellyDrum_PC3` | — |
| BIDE | matching | `BattleAnim_Bide` | — |
| BIND | matching | `BattleAnim_Bind` | — |
| BITE | preserved | `BattleAnim_Bite_PC3` | — |
| BLAZE_KICK | preserved | `BattleAnim_BlazeKick_Oct19` | — |
| BLIZZARD | preserved | `BattleAnim_Blizzard_PC3` | — |
| BODY_SLAM | preserved | `BattleAnim_BodySlam_PC3` | — |
| BONEMERANG | preserved | `BattleAnim_Bonemerang_PC4` | — |
| BONE_CLUB | matching | `BattleAnim_BoneClub` | — |
| BONE_RUSH | matching | `BattleAnim_BoneRush` | — |
| BOUNCE | preserved | `BattleAnim_Bounce_CC` | `ANIM_GFX_BLUR`, `ANIM_GFX_HIT`, `ANIM_OBJ_BLUR_VERTICAL_DOWN`, `ANIM_OBJ_BLUR_VERTICAL_UP` |
| BRAVE_BIRD | updated | `BattleAnim_BraveBird_SourApple` | — |
| BRICK_BREAK | preserved | `BattleAnim_BrickBreak_CC` | `ANIM_OBJ_HIT_YFIX` |
| BUBBLE | updated | `BattleAnim_Bubble` | — |
| BUBBLEBEAM | matching | `BattleAnim_BubbleBeam_PC3` | `SFX_BUBBLEBEAM` |
| BUG_BITE | matching | `BattleAnim_BugBite_PC3` | — |
| BUG_BUZZ | updated | `BattleAnim_BugBuzz_SourApple` | — |
| BULK_UP | matching | `BattleAnim_BulkUp` | — |
| BULLET_PUNCH | matching | `BattleAnim_BulletPunch_PC3` | — |
| BULLET_SEED | preserved | `BattleAnim_BulletSeed_CC` | — |
| CALM_MIND | matching | `BattleAnim_CalmMind` | — |
| CHARM | matching | `BattleAnim_Charm_PC3` | — |
| CLAMP | matching | `BattleAnim_Clamp` | — |
| CLOSE_COMBAT | matching | `BattleAnim_CloseCombat_PC3` | — |
| COMET_PUNCH | matching | `BattleAnim_CometPunch` | — |
| CONFUSE_RAY | matching | `BattleAnim_ConfuseRay_PC3` | — |
| CONFUSION | matching | `BattleAnim_Confusion` | — |
| CONSTRICT | matching | `BattleAnim_Constrict` | — |
| CONVERSION | matching | `BattleAnim_Conversion_PC3` | — |
| CONVERSION2 | matching | `BattleAnim_Conversion2` | — |
| COSMIC_POWER | preserved | `BattleAnim_CosmicPower_Oct19` | — |
| COTTON_SPORE | matching | `BattleAnim_CottonSpore` | — |
| COUNTER | preserved | `BattleAnim_Counter_PC3` | — |
| CRABHAMMER | matching | `BattleAnim_Crabhammer_PC3` | — |
| CROSS_CHOP | preserved | `BattleAnim_CrossChop_PC3` | — |
| CROSS_POISON | updated | `BattleAnim_CrossPoison_SourApple` | — |
| CRUNCH | preserved | `BattleAnim_Crunch_PC3` | — |
| CRUSH_CLAW | matching | `BattleAnim_CrushClaw_CC` | — |
| CURSE | preserved | `BattleAnim_Curse_PC3` | — |
| CUT | preserved | `BattleAnim_Cut_PC4` | — |
| DARK_PULSE | matching | `BattleAnim_DarkPulse_PC3` | — |
| DEFENSE_CURL | matching | `BattleAnim_DefenseCurl_PC3` | — |
| DEFOG | updated | `BattleAnim_Defog_SourApple` | — |
| DESTINY_BOND | preserved | `BattleAnim_DestinyBond_PC3` | — |
| DETECT | matching | `BattleAnim_Detect` | — |
| DIG | preserved | `BattleAnim_Dig_PC3` | — |
| DISABLE | preserved | `BattleAnim_Disable_PC3` | — |
| DISCHARGE | updated | `BattleAnim_Discharge_SourApple` | `ANIM_OBJ_THUNDERBOLT_CORE` |
| DIZZY_PUNCH | preserved | `BattleAnim_DizzyPunch_PC3` | — |
| DOOM_DESIRE | matching | `BattleAnim_DoomDesire_Oct19` | — |
| DOUBLESLAP | preserved | `BattleAnim_DoubleSlap_PC3` | `ANIM_OBJ_PALM_XFLIP`, `SFX_DOUBLESLAP` |
| DOUBLE_EDGE | preserved | `BattleAnim_DoubleEdge_PC3` | — |
| DOUBLE_KICK | preserved | `BattleAnim_DoubleKick_PC3` | — |
| DOUBLE_TEAM | matching | `BattleAnim_DoubleTeam` | — |
| DRACO_METEOR | preserved | `BattleAnim_DracoMeteor` | `ANIM_GFX_SMOKE_PUFF` |
| DRAGONBREATH | matching | `BattleAnim_Dragonbreath_PC4` | — |
| DRAGON_CLAW | matching | `BattleAnim_DragonClaw_PC3` | — |
| DRAGON_DANCE | updated | `BattleAnim_DragonDance` | — |
| DRAGON_PULSE | matching | `BattleAnim_DragonPulse` | — |
| DRAGON_RAGE | matching | `BattleAnim_DragonRage_PC4` | — |
| DRAIN_PUNCH | preserved | `BattleAnim_DrainPunch_PC3` | — |
| DREAM_EATER | preserved | `BattleAnim_DreamEater_PC3` | `PAL_BTLCUSTOM_RED` |
| DRILL_PECK | preserved | `BattleAnim_DrillPeck_PC3` | — |
| DYNAMICPUNCH | preserved | `BattleAnim_Dynamicpunch_PC4` | — |
| EARTHQUAKE | matching | `BattleAnim_Earthquake_PC4` | — |
| EARTH_POWER | preserved | `BattleAnim_EarthPower` | — |
| EGG_BOMB | updated | `BattleAnim_EggBomb` | — |
| EMBER | preserved | `BattleAnim_Ember_PC3` | — |
| ENCORE | matching | `BattleAnim_Encore_PC3` | — |
| ENDURE | matching | `BattleAnim_Endure_PC4` | — |
| ENERGY_BALL | matching | `BattleAnim_EnergyBall_PC3` | — |
| ERUPTION | preserved | `BattleAnim_Eruption_Oct19` | `ANIM_OBJ_ROCK_TOMB` |
| EXPLOSION | preserved | `BattleAnim_Explosion_PC3` | — |
| EXTRASENSORY | matching | `BattleAnim_Extrasensory` | — |
| EXTREMESPEED | preserved | `BattleAnim_Extremespeed_PC3` | `ANIM_GFX_CUT`, `ANIM_OBJ_CUT_LONG_DOWN_LEFT`, `SFX_CUT`, `SFX_MENU` |
| FACADE | matching | `BattleAnim_Facade` | — |
| FAINT_ATTACK | preserved | `BattleAnim_FeintAttack_PC3` | — |
| FAKE_OUT | matching | `BattleAnim_FakeOut_CC` | — |
| FALSE_SWIPE | preserved | `BattleAnim_FalseSwipe_PC3` | — |
| FIRE_BLAST | preserved | `BattleAnim_FireBlast_PC3` | — |
| FIRE_FANG | updated | `BattleAnim_FireFang_SourApple` | — |
| FIRE_PUNCH | preserved | `BattleAnim_FirePunch_PC4` | — |
| FIRE_SPIN | matching | `BattleAnim_FireSpin_PC3` | — |
| FISSURE | matching | `BattleAnim_Fissure` | — |
| FLAIL | matching | `BattleAnim_Flail` | — |
| FLAMETHROWER | preserved | `BattleAnim_Flamethrower_PC3` | — |
| FLAME_WHEEL | updated | `BattleAnim_FlameWheel` | — |
| FLARE_BLITZ | matching | `BattleAnim_FlareBlitz_PC3` | — |
| FLASH | preserved | `BattleAnim_Flash_PC3` | — |
| FLASH_CANNON | matching | `BattleAnim_FlashCannon` | — |
| FLY | preserved | `BattleAnim_Fly_PC3` | — |
| FOCUS_BLAST | matching | `BattleAnim_FocusBlast_PC3` | — |
| FOCUS_ENERGY | matching | `BattleAnim_FocusEnergy_PC3` | — |
| FORCE_PALM | matching | `BattleAnim_ForcePalm_CC` | — |
| FORESIGHT | preserved | `BattleAnim_Foresight_PC3` | — |
| FRUSTRATION | matching | `BattleAnim_Frustration` | — |
| FURY_ATTACK | matching | `BattleAnim_FuryAttack` | — |
| FURY_CUTTER | matching | `BattleAnim_FuryCutter` | — |
| FURY_SWIPES | matching | `BattleAnim_FurySwipes` | — |
| FUTURE_SIGHT | matching | `BattleAnim_FutureSight_PC3` | — |
| GIGA_DRAIN | preserved | `BattleAnim_GigaDrain_PC3` | `PAL_BTLCUSTOM_GREEN` |
| GIGA_IMPACT | matching | `BattleAnim_GigaImpact_PC3` | — |
| GLARE | preserved | `BattleAnim_Glare_PC4` | — |
| GRASS_KNOT | matching | `BattleAnim_GrassKnot_PO` | — |
| GROWL | preserved | `BattleAnim_Growl_PC4` | `ANIM_BG_BATTLEROBJ_1ROW`, `ANIM_BG_FADE_MON_TO_BLACK_REPEATING`, `ANIM_BG_SHOW_MON` |
| GROWTH | matching | `BattleAnim_Growth_PC3` | — |
| GUILLOTINE | matching | `BattleAnim_Guillotine` | — |
| GUNK_SHOT | matching | `BattleAnim_GunkShot_PC3` | `SFX_BUBBLEBEAM` |
| GUST | updated | `BattleAnim_Gust_SourApple` | — |
| GYRO_BALL | preserved | `BattleAnim_GyroBall` | — |
| HAIL | preserved | `BattleAnim_Hail_PC4` | — |
| HAMMER_ARM | matching | `BattleAnim_HammerArm_CC` | — |
| HARDEN | matching | `BattleAnim_Harden` | — |
| HAZE | preserved | `BattleAnim_Haze_PC4` | — |
| HEADBUTT | preserved | `BattleAnim_Headbutt_PC3` | — |
| HEAD_SMASH | updated | `BattleAnim_HeadSmash_SourApple` | — |
| HEAL_BELL | matching | `BattleAnim_HealBell_PC3` | — |
| HEAT_WAVE | matching | `BattleAnim_HeatWave_CC` | — |
| HIDDEN_POWER | preserved | `BattleAnim_HiddenPower_PC3` | — |
| HI_JUMP_KICK | preserved | `BattleAnim_HiJumpKick_PC3` | — |
| HORN_ATTACK | preserved | `BattleAnim_HornAttack_PC4` | — |
| HORN_DRILL | matching | `BattleAnim_HornDrill` | — |
| HYDRO_PUMP | preserved | `BattleAnim_HydroPump_PC3` | `ANIM_BG_END_WATER`, `ANIM_BG_START_WATER`, `ANIM_BG_WATER` |
| HYPER_BEAM | matching | `BattleAnim_HyperBeam_PC4` | — |
| HYPER_FANG | preserved | `BattleAnim_HyperFang_PC4` | — |
| HYPER_VOICE | preserved | `BattleAnim_HyperVoice_PC3` | `ANIM_OBJ_BIG_WAVE` |
| HYPNOSIS | matching | `BattleAnim_Hypnosis_PC4` | — |
| ICE_BEAM | preserved | `BattleAnim_IceBeam_PC3` | — |
| ICE_FANG | updated | `BattleAnim_IceFang_SourApple` | — |
| ICE_PUNCH | preserved | `BattleAnim_IcePunch_PC4` | — |
| ICE_SHARD | matching | `BattleAnim_IceShard_PC3` | — |
| ICICLE_SPEAR | matching | `BattleAnim_IcicleSpear` | — |
| ICY_WIND | preserved | `BattleAnim_IcyWind_PC3` | — |
| IRON_DEFENSE | matching | `BattleAnim_IronDefense_CC` | — |
| IRON_HEAD | preserved | `BattleAnim_IronHead` | `ANIM_BG_FADE_MON_TO_BLACK` |
| IRON_TAIL | preserved | `BattleAnim_IronTail_PC3` | `ANIM_BG_FADE_MON_TO_BLACK` |
| JUMP_KICK | matching | `BattleAnim_JumpKick` | — |
| KARATE_CHOP | preserved | `BattleAnim_KarateChop_PC3` | — |
| KINESIS | matching | `BattleAnim_Kinesis` | — |
| KNOCK_OFF | matching | `BattleAnim_KnockOff` | — |
| LAVA_PLUME | updated | `BattleAnim_LavaPlume_SourApple` | `ANIM_OBJ_RADIAL_FLAME`, `SFX_EMBER` |
| LEAF_BLADE | updated | `BattleAnim_LeafBlade` | — |
| LEAF_STORM | updated | `BattleAnim_LeafStorm_SourApple` | — |
| LEECH_LIFE | preserved | `BattleAnim_LeechLife_PC3` | `ANIM_GFX_HIT` |
| LEECH_SEED | matching | `BattleAnim_LeechSeed_PC3` | — |
| LEER | preserved | `BattleAnim_Leer_PC4` | — |
| LICK | preserved | `BattleAnim_Lick_PC4` | — |
| LIGHT_SCREEN | preserved | `BattleAnim_LightScreen_PC3` | — |
| LOCK_ON | matching | `BattleAnim_LockOn` | — |
| LOVELY_KISS | matching | `BattleAnim_LovelyKiss` | — |
| LOW_KICK | preserved | `BattleAnim_LowKick_PC3` | — |
| MACH_PUNCH | preserved | `BattleAnim_MachPunch_PC3` | — |
| MAGICAL_LEAF | preserved | `BattleAnim_MagicalLeaf_CC` | `ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW` |
| MAGNITUDE | preserved | `BattleAnim_Magnitude_PC3` | — |
| MEAN_LOOK | preserved | `BattleAnim_MeanLook_PC3` | `PAL_BTLCUSTOM_BLUE` |
| MEDITATE | matching | `BattleAnim_Meditate` | — |
| MEGAHORN | preserved | `BattleAnim_Megahorn_PC3` | — |
| MEGA_DRAIN | preserved | `BattleAnim_MegaDrain_PC3` | `ANIM_BG_BATTLEROBJ_1ROW`, `PAL_BTLCUSTOM_GREEN` |
| MEGA_KICK | matching | `BattleAnim_MegaKick` | — |
| MEGA_PUNCH | matching | `BattleAnim_MegaPunch` | — |
| METAL_CLAW | preserved | `BattleAnim_MetalClaw_PC4` | `ANIM_BG_FADE_MON_TO_BLACK` |
| METEOR_MASH | matching | `BattleAnim_MeteorMash_Oct19` | — |
| METRONOME | matching | `BattleAnim_Metronome_PC4` | — |
| MILK_DRINK | matching | `BattleAnim_MilkDrink` | — |
| MIMIC | matching | `BattleAnim_Mimic` | — |
| MIND_READER | matching | `BattleAnim_MindReader` | — |
| MINIMIZE | matching | `BattleAnim_Minimize_PC3` | — |
| MIRROR_COAT | preserved | `BattleAnim_MirrorCoat_PC3` | `SFX_SHINE` |
| MIRROR_MOVE | preserved | `BattleAnim_MirrorMove` | `ANIM_GFX_HIT`, `ANIM_OBJ_HIT_YFIX`, `ANIM_OBJ_PALM`, `SFX_POUND` |
| MIST | matching | `BattleAnim_Mist` | — |
| MOONLIGHT | preserved | `BattleAnim_Moonlight` | `ANIM_OBJ_MOONLIGHT` |
| MORNING_SUN | matching | `BattleAnim_MorningSun` | — |
| MUD_SHOT | matching | `BattleAnim_MudShot_CC` | — |
| MUD_SLAP | matching | `BattleAnim_MudSlap_PC4` | — |
| NASTY_PLOT | matching | `BattleAnim_NastyPlot` | — |
| NIGHTMARE | matching | `BattleAnim_Nightmare` | — |
| NIGHT_SHADE | preserved | `BattleAnim_NightShade_PC4` | — |
| NIGHT_SLASH | preserved | `BattleAnim_NightSlash` | `ANIM_OBJ_CUT_LEFT`, `ANIM_OBJ_CUT_RIGHT` |
| OCTAZOOKA | preserved | `BattleAnim_Octazooka_PC3` | — |
| OMINOUS_WIND | preserved | `BattleAnim_OminousWind_Oct19` | `ANIM_OBJ_MIST_BALL_BG` |
| OUTRAGE | preserved | `BattleAnim_Outrage_PC3` | `ANIM_BG_BATTLEROBJ_1ROW`, `ANIM_BG_FLASH_INVERTED`, `ANIM_BG_SHOW_MON`, `ANIM_GFX_HIT`, `ANIM_OBJ_HIT_BIG_YFIX`, `SFX_COMET_PUNCH`, `SFX_MEGA_PUNCH`, `SFX_MOVE_PUZZLE_PIECE` |
| OVERHEAT | preserved | `BattleAnim_Overheat_CC` | `ANIM_OBJ_RADIAL_FLAME` |
| PAIN_SPLIT | matching | `BattleAnim_PainSplit_PC3` | — |
| PAY_DAY | matching | `BattleAnim_PayDay_PC4` | — |
| PECK | preserved | `BattleAnim_Peck_PC4` | — |
| PERISH_SONG | matching | `BattleAnim_PerishSong_PC3` | — |
| PETAL_DANCE | preserved | `BattleAnim_PetalDance_PC3` | — |
| PIN_MISSILE | preserved | `BattleAnim_PinMissile_PC3` | — |
| POISONPOWDER | preserved | `BattleAnim_Poisonpowder_PC4` | — |
| POISON_FANG | updated | `BattleAnim_PoisonFang_SourApple` | `ANIM_OBJ_BITE` |
| POISON_GAS | preserved | `BattleAnim_PoisonGas` | — |
| POISON_JAB | updated | `BattleAnim_PoisonJab_SourApple` | — |
| POISON_STING | preserved | `BattleAnim_PoisonSting_PC4` | — |
| POISON_TAIL | matching | `BattleAnim_PoisonTail_Oct19` | — |
| POUND | matching | `BattleAnim_Pound` | — |
| POWDER_SNOW | updated | `BattleAnim_PowderSnow` | — |
| POWER_GEM | matching | `BattleAnim_PowerGem_PC3` | — |
| POWER_WHIP | matching | `BattleAnim_PowerWhip` | — |
| PRESENT | updated | `BattleAnim_Present` | — |
| PROTECT | matching | `BattleAnim_Protect_PC3` | — |
| PSYBEAM | matching | `BattleAnim_Psybeam_PC3` | — |
| PSYCHIC_M | matching | `BattleAnim_PsychicM_PC3` | — |
| PSYCHO_CUT | updated | `BattleAnim_PsychoCut_SourApple` | — |
| PSYCH_UP | matching | `BattleAnim_PsychUp` | — |
| PSYWAVE | matching | `BattleAnim_Psywave` | — |
| PURSUIT | preserved | `BattleAnim_Pursuit_PC3` | — |
| QUICK_ATTACK | preserved | `BattleAnim_QuickAttack_PC3` | — |
| RAGE | preserved | `BattleAnim_Rage_PC3` | — |
| RAIN_DANCE | preserved | `BattleAnim_RainDance_PC3` | `SFX_RAIN_DANCE` |
| RAPID_SPIN | preserved | `BattleAnim_RapidSpin_PC3` | — |
| RAZOR_LEAF | preserved | `BattleAnim_RazorLeaf_PC3` | `PAL_BTLCUSTOM_GREEN` |
| RAZOR_WIND | matching | `BattleAnim_RazorWind` | — |
| RECOVER | matching | `BattleAnim_Recover_PC4` | — |
| RECYCLE | matching | `BattleAnim_Recycle_Oct19` | — |
| REFLECT | preserved | `BattleAnim_Reflect_PC3` | `PAL_BTLCUSTOM_ICE` |
| REST | matching | `BattleAnim_Rest_PC4` | — |
| RETURN | preserved | `BattleAnim_Return_PC3` | — |
| REVERSAL | preserved | `BattleAnim_Reversal_PC3` | — |
| ROAR | matching | `BattleAnim_Roar_PC3` | — |
| ROCK_BLAST | matching | `BattleAnim_RockBlast` | — |
| ROCK_POLISH | updated | `BattleAnim_RockPolish_SourApple` | — |
| ROCK_SLIDE | preserved | `BattleAnim_RockSlide_PC3` | — |
| ROCK_SMASH | preserved | `BattleAnim_BrickBreak_PC3` | `ANIM_GFX_ROCKS`, `ANIM_OBJ_ROCK_SMASH`, `SFX_SPARK` |
| ROCK_THROW | preserved | `BattleAnim_RockThrow_PC3` | — |
| ROCK_TOMB | matching | `BattleAnim_RockTomb_CC` | — |
| ROLLING_KICK | matching | `BattleAnim_RollingKick` | — |
| ROLLOUT | preserved | `BattleAnim_Rollout_PC3` | — |
| ROOST | matching | `BattleAnim_Roost` | — |
| SACRED_FIRE | preserved | `BattleAnim_SacredFire_PC3` | `ANIM_OBJ_FIRE_BLAST`, `ANIM_OBJ_SACRED_FIRE`, `PAL_BTLCUSTOM_FIRE` |
| SAFEGUARD | matching | `BattleAnim_Safeguard_PC3` | — |
| SANDSTORM | preserved | `BattleAnim_Sandstorm_PC4` | — |
| SAND_ATTACK | matching | `BattleAnim_SandAttack` | — |
| SCARY_FACE | preserved | `BattleAnim_ScaryFace_PC4` | — |
| SCRATCH | preserved | `BattleAnim_Scratch_PC4` | — |
| SCREECH | matching | `BattleAnim_Screech_PC4` | — |
| SEED_BOMB | matching | `BattleAnim_SeedBomb` | — |
| SEISMIC_TOSS | preserved | `BattleAnim_SeismicToss_PC3` | `ANIM_BG_SHAKE_SCREEN_Y`, `ANIM_GFX_HIT`, `ANIM_OBJ_HIT_BIG_YFIX`, `SFX_MEGA_PUNCH`, `SFX_STRENGTH` |
| SELFDESTRUCT | updated | `BattleAnim_Selfdestruct` | — |
| SHADOW_BALL | updated | `BattleAnim_ShadowBall_SourApple` | — |
| SHADOW_CLAW | matching | `BattleAnim_ShadowClaw_PC3` | — |
| SHADOW_PUNCH | updated | `BattleAnim_ShadowPunch` | — |
| SHADOW_SNEAK | updated | `BattleAnim_ShadowSneak_SourApple` | `ANIM_GFX_ANGELS` |
| SHARPEN | matching | `BattleAnim_Sharpen` | — |
| SIGNAL_BEAM | matching | `BattleAnim_SignalBeam_CC` | — |
| SING | matching | `BattleAnim_Sing_PC3` | — |
| SKETCH | matching | `BattleAnim_Sketch_PC3` | — |
| SKILL_SWAP | matching | `BattleAnim_SkillSwap` | — |
| SKULL_BASH | matching | `BattleAnim_SkullBash` | — |
| SKY_ATTACK | matching | `BattleAnim_SkyAttack` | — |
| SKY_UPPERCUT | matching | `BattleAnim_SkyUppercut_Oct19` | — |
| SLACK_OFF | updated | `BattleAnim_SlackOff` | — |
| SLAM | matching | `BattleAnim_Slam` | — |
| SLASH | preserved | `BattleAnim_Slash_PC4` | — |
| SLEEP_POWDER | preserved | `BattleAnim_SleepPowder_PC3` | — |
| SLEEP_TALK | matching | `BattleAnim_SleepTalk_PC4` | — |
| SLUDGE | preserved | `BattleAnim_Sludge` | `PAL_BTLCUSTOM_PURPLE` |
| SLUDGE_BOMB | preserved | `BattleAnim_SludgeBomb_PC4` | — |
| SMOG | preserved | `BattleAnim_Smog` | — |
| SMOKESCREEN | preserved | `BattleAnim_Smokescreen_PC3` | — |
| SNORE | matching | `BattleAnim_Snore` | — |
| SOFTBOILED | matching | `BattleAnim_Softboiled` | — |
| SOLARBEAM | preserved | `BattleAnim_SolarBeam_PC3` | `ANIM_GFX_BEAM` |
| SONICBOOM | preserved | `BattleAnim_Sonicboom_PC3` | `ANIM_GFX_WIND`, `ANIM_OBJ_GUST`, `PAL_BTLCUSTOM_GRAY` |
| SPARK | preserved | `BattleAnim_Spark_PC3` | `ANIM_BG_BATTLEROBJ_2ROW`, `ANIM_OBJ_THUNDERBOLT_CORE`, `ANIM_OBJ_THUNDERSHOCK_SPARKS` |
| SPIDER_WEB | preserved | `BattleAnim_SpiderWeb` | — |
| SPIKES | matching | `BattleAnim_Spikes_PC3` | — |
| SPIKE_CANNON | updated | `BattleAnim_SpikeCannon` | — |
| SPITE | matching | `BattleAnim_Spite` | — |
| SPLASH | matching | `BattleAnim_Splash` | — |
| SPORE | preserved | `BattleAnim_Spore_PC3` | — |
| STEALTH_ROCK | updated | `BattleAnim_StealthRock_SourApple` | — |
| STEEL_WING | preserved | `BattleAnim_SteelWing_PC4` | `ANIM_BG_FADE_MON_TO_BLACK` |
| STOMP | preserved | `BattleAnim_Stomp_PC3` | — |
| STONE_EDGE | matching | `BattleAnim_StoneEdge_PC3` | — |
| STRENGTH | preserved | `BattleAnim_Strength_PC3` | — |
| STRING_SHOT | preserved | `BattleAnim_StringShot_PC3` | — |
| STRUGGLE | preserved | `BattleAnim_Struggle_PC4` | — |
| STUN_SPORE | preserved | `BattleAnim_StunSpore_PC4` | — |
| SUBMISSION | matching | `BattleAnim_Submission` | — |
| SUBSTITUTE | preserved | `BattleAnim_Substitute_PC3` | — |
| SUCKER_PUNCH | matching | `BattleAnim_SuckerPunch_PC3` | — |
| SUNNY_DAY | matching | `BattleAnim_SunnyDay_PC3` | — |
| SUPERPOWER | matching | `BattleAnim_Superpower_CC` | — |
| SUPERSONIC | matching | `BattleAnim_Supersonic_PC4` | — |
| SUPER_FANG | preserved | `BattleAnim_SuperFang_PC3` | — |
| SURF | preserved | `BattleAnim_Surf_PC3` | — |
| SWAGGER | matching | `BattleAnim_Swagger_PC3` | — |
| SWEET_KISS | matching | `BattleAnim_SweetKiss_PC3` | — |
| SWEET_SCENT | matching | `BattleAnim_SweetScent` | — |
| SWIFT | matching | `BattleAnim_Swift_PC3` | — |
| SWORDS_DANCE | matching | `BattleAnim_SwordsDance_PC3` | — |
| SYNTHESIS | matching | `BattleAnim_Synthesis` | — |
| TACKLE | updated | `BattleAnim_Tackle_SourApple` | — |
| TAIL_GLOW | matching | `BattleAnim_TailGlow_Oct19` | — |
| TAIL_WHIP | matching | `BattleAnim_TailWhip` | — |
| TAKE_DOWN | preserved | `BattleAnim_TakeDown_PC3` | — |
| TAUNT | matching | `BattleAnim_Taunt_PO` | — |
| TELEPORT | matching | `BattleAnim_Teleport_PC3` | — |
| THIEF | matching | `BattleAnim_Thief_PC3` | — |
| THRASH | preserved | `BattleAnim_Thrash_PC3` | — |
| THUNDER | preserved | `BattleAnim_Thunder_PC3` | `ANIM_OBJ_THUNDER_CENTER`, `ANIM_OBJ_THUNDER_LEFT`, `ANIM_OBJ_THUNDER_RIGHT` |
| THUNDERBOLT | preserved | `BattleAnim_Thunderbolt_PC3` | `ANIM_OBJ_THUNDERBOLT_CORE`, `ANIM_OBJ_THUNDERBOLT_SPARKS`, `SFX_THUNDERSHOCK` |
| THUNDERPUNCH | preserved | `BattleAnim_Thunderpunch_PC3` | `ANIM_OBJ_THUNDER_RIGHT` |
| THUNDERSHOCK | preserved | `BattleAnim_Thundershock_PC3` | `ANIM_OBJ_THUNDERSHOCK_CORE`, `ANIM_OBJ_THUNDERSHOCK_SPARKS` |
| THUNDER_FANG | updated | `BattleAnim_ThunderFang_SourApple` | — |
| THUNDER_WAVE | preserved | `BattleAnim_ThunderWave_PC3` | — |
| TORMENT | matching | `BattleAnim_Torment_PO` | — |
| TOXIC | preserved | `BattleAnim_Toxic_PC4` | `SFX_BUBBLEBEAM` |
| TOXIC_SPIKES | matching | `BattleAnim_ToxicSpikes` | — |
| TRANSFORM | matching | `BattleAnim_Transform_PC4` | — |
| TRICK | matching | `BattleAnim_Trick` | — |
| TRICK_ROOM | preserved | `BattleAnim_TrickRoom` | `SFX_PSYBEAM` |
| TRIPLE_KICK | matching | `BattleAnim_TripleKick` | — |
| TRI_ATTACK | preserved | `BattleAnim_TriAttack_PC3` | `ANIM_OBJ_THUNDER_RIGHT` |
| TWINEEDLE | matching | `BattleAnim_Twineedle` | `PAL_BTLCUSTOM_GRAY` |
| TWISTER | updated | `BattleAnim_Twister_SourApple` | — |
| U_TURN | preserved | `BattleAnim_UTurn_PC3` | `ANIM_GFX_BLUR` |
| VACUUM_WAVE | updated | `BattleAnim_VacuumWave_SourApple` | — |
| VICEGRIP | matching | `BattleAnim_Vicegrip` | — |
| VINE_WHIP | matching | `BattleAnim_VineWhip_PC3` | — |
| VITAL_THROW | matching | `BattleAnim_VitalThrow` | — |
| VOLT_TACKLE | updated | `BattleAnim_VoltTackle_SourApple` | `ANIM_OBJ_THUNDERBOLT_CORE` |
| WATERFALL | preserved | `BattleAnim_Waterfall_PC3` | `SFX_LICK` |
| WATER_GUN | preserved | `BattleAnim_WaterGun_PC3` | — |
| WATER_PULSE | preserved | `BattleAnim_WaterPulse` | `SFX_BUBBLEBEAM` |
| WATER_SPOUT | matching | `BattleAnim_WaterSpout_Oct19` | — |
| WEATHER_BALL | preserved | `BattleAnim_WeatherBall_PO` | `ANIM_BG_FLASH_WHITE` |
| WHIRLPOOL | preserved | `BattleAnim_Whirlpool_PC3` | — |
| WHIRLWIND | updated | `BattleAnim_Whirlwind_SourApple` | — |
| WILL_O_WISP | preserved | `BattleAnim_WillOWisp_PC3` | — |
| WING_ATTACK | preserved | `BattleAnim_WingAttack_PC3` | — |
| WISH | updated | `BattleAnim_Wish_SourApple` | — |
| WITHDRAW | matching | `BattleAnim_Withdraw` | — |
| WOOD_HAMMER | matching | `BattleAnim_WoodHammer_CC` | — |
| WRAP | preserved | `BattleAnim_Wrap_PC3` | — |
| X_SCISSOR | matching | `BattleAnim_XScissor_PC4` | — |
| YAWN | matching | `BattleAnim_Yawn_PO` | — |
| ZAP_CANNON | preserved | `BattleAnim_ZapCannon_PC3` | `ANIM_OBJ_THUNDERBOLT_CORE`, `ANIM_OBJ_THUNDERBOLT_SPARKS`, `SFX_THUNDERSHOCK` |
| ZEN_HEADBUTT | preserved | `BattleAnim_ZenHeadbutt_PC3` | — |

## All 105 source moves absent from the local move roster

These require adding the move itself if desired, not merely changing an existing animation pointer.

| Source move | Source animation | Has source effects |
| --- | --- | --- |
| ACUPRESSURE | `BattleAnim_Acupressure` | Yes |
| AQUA_RING | `BattleAnim_AquaRing` | Yes |
| ARM_THRUST | `BattleAnim_ArmThrust` | Yes |
| AROMATHERAPY | `BattleAnim_Aromatherapy` | Yes |
| ASSIST | `BattleAnim_Assist` | Yes |
| ASSURANCE | `BattleAnim_Assurance` | Yes |
| ATTACK_ORDER | `BattleAnim_AttackOrder` | Yes |
| BLAST_BURN | `BattleAnim_BlastBurn` | Yes |
| BLOCK | `BattleAnim_Block` | Yes |
| BRINE | `BattleAnim_Brine` | Yes |
| CAMOUFLAGE | `BattleAnim_Camouflage` | Yes |
| CAPTIVATE | `BattleAnim_Captivate` | Yes |
| CHARGE | `BattleAnim_Charge` | Yes |
| CHARGE_BEAM | `BattleAnim_ChargeBeam` | Yes |
| CHATTER | `BattleAnim_Chatter` | Yes |
| COPYCAT | `BattleAnim_Copycat` | Yes |
| COVET | `BattleAnim_Covet` | Yes |
| CRUSH_GRIP | `BattleAnim_CrushGrip` | Yes |
| DARK_VOID | `BattleAnim_DarkVoid` | Yes |
| DEFEND_ORDER | `BattleAnim_DefendOrder` | Yes |
| DIVE | `BattleAnim_Dive` | Yes |
| DOUBLE_HIT | `BattleAnim_DoubleHit` | Yes |
| DRAGON_RUSH | `BattleAnim_DragonRush` | Yes |
| EMBARGO | `BattleAnim_Embargo` | Yes |
| ENDEAVOR | `BattleAnim_Endeavor` | Yes |
| FAKE_TEARS | `BattleAnim_FakeTears` | Yes |
| FEATHER_DANCE | `BattleAnim_FeatherDance` | Yes |
| FEINT | `BattleAnim_Feint` | Yes |
| FLATTER | `BattleAnim_Flatter` | Yes |
| FLING | `BattleAnim_Fling` | Yes |
| FOCUS_PUNCH | `BattleAnim_FocusPunch` | Yes |
| FRENZY_PLANT | `BattleAnim_FrenzyPlant` | Yes |
| GASTRO_ACID | `BattleAnim_GastroAcid` | Yes |
| GRASSWHISTLE | `BattleAnim_GrassWhistle` | Yes |
| GRAVITY | `BattleAnim_Gravity` | Yes |
| GRUDGE | `BattleAnim_Grudge` | Yes |
| GUARD_SWAP | `BattleAnim_GuardSwap` | Yes |
| HEALING_WISH | `BattleAnim_HealingWish` | Yes |
| HEAL_BLOCK | `BattleAnim_HealBlock` | Yes |
| HEAL_ORDER | `BattleAnim_HealOrder` | Yes |
| HEART_SWAP | `BattleAnim_HeartSwap` | Yes |
| HOWL | `BattleAnim_Howl` | Yes |
| HYDRO_CANNON | `BattleAnim_HydroCannon` | Yes |
| ICE_BALL | `BattleAnim_IceBall` | Yes |
| IMPRISON | `BattleAnim_Imprison` | Yes |
| INGRAIN | `BattleAnim_Ingrain` | Yes |
| JUDGEMENT | `BattleAnim_Judgment` | Yes |
| LAST_RESORT | `BattleAnim_LastResort` | Yes |
| LUCKY_CHANT | `BattleAnim_LuckyChant` | Yes |
| LUNAR_DANCE | `BattleAnim_LunarDance` | Yes |
| LUSTER_PURGE | `BattleAnim_LusterPurge` | Yes |
| MAGIC_COAT | `BattleAnim_MagicCoat` | Yes |
| MAGMA_STORM | `BattleAnim_MagmaStorm` | Yes |
| MAGNET_BOMB | `BattleAnim_MagnetBomb` | Yes |
| MAGNET_RISE | `BattleAnim_MagnetRise` | Yes |
| MEMENTO | `BattleAnim_Memento` | Yes |
| METAL_BURST | `BattleAnim_MetalBurst` | Yes |
| METAL_SOUND | `BattleAnim_MetalSound` | Yes |
| ME_FIRST | `BattleAnim_MeFirst` | Yes |
| MIRACLE_EYE | `BattleAnim_MiracleEye` | Yes |
| MIRROR_SHOT | `BattleAnim_MirrorShot` | Yes |
| MIST_BALL | `BattleAnim_MistBall` | Yes |
| MUDDY_WATER | `BattleAnim_MuddyWater` | Yes |
| MUD_BOMB | `BattleAnim_MudBomb` | Yes |
| MUD_SPORT | `BattleAnim_MudSport` | Yes |
| NATURAL_GIFT | `BattleAnim_NaturalGift` | Yes |
| NATURE_POWER | `BattleAnim_NaturePower` | No; intentionally empty |
| NEEDLE_ARM | `BattleAnim_NeedleArm` | Yes |
| ODOR_SLEUTH | `BattleAnim_OdorSleuth` | Yes |
| PAYBACK | `BattleAnim_Payback` | Yes |
| PLUCK | `BattleAnim_Pluck` | Yes |
| POWER_SWAP | `BattleAnim_PowerSwap` | Yes |
| POWER_TRICK | `BattleAnim_PowerTrick` | Yes |
| PSYCHO_BOOST | `BattleAnim_PsychoBoost` | Yes |
| PSYCHO_SHIFT | `BattleAnim_PsychoShift` | Yes |
| PUNISHMENT | `BattleAnim_Punishment` | Yes |
| REFRESH | `BattleAnim_Refresh` | Yes |
| REVENGE | `BattleAnim_Revenge` | Yes |
| ROAR_OF_TIME | `BattleAnim_RoarOfTime` | Yes |
| ROCK_CLIMB | `BattleAnim_RockClimb` | Yes |
| ROCK_WRECKER | `BattleAnim_RockWrecker` | Yes |
| ROLE_PLAY | `BattleAnim_RolePlay` | Yes |
| SAND_TOMB | `BattleAnim_SandTomb` | Yes |
| SECRET_POWER | `BattleAnim_SecretPower` | No; intentionally empty |
| SEED_FLARE | `BattleAnim_SeedFlare` | Yes |
| SHADOW_FORCE | `BattleAnim_ShadowForce` | Yes |
| SHEER_COLD | `BattleAnim_SheerCold` | Yes |
| SHOCK_WAVE | `BattleAnim_ShockWave` | Yes |
| SILVER_WIND | `BattleAnim_SilverWind` | Yes |
| SMELLINGSALT | `BattleAnim_SmellingSalts` | Yes |
| SNATCH | `BattleAnim_Snatch` | Yes |
| SPACIAL_REND | `BattleAnim_SpacialRend` | Yes |
| SPIT_UP | `BattleAnim_SpitUp` | Yes |
| STOCKPILE | `BattleAnim_Stockpile` | Yes |
| SWALLOW | `BattleAnim_Swallow` | Yes |
| SWITCHEROO | `BattleAnim_Switcheroo` | Yes |
| TAILWIND | `BattleAnim_Tailwind` | Yes |
| TEETER_DANCE | `BattleAnim_TeeterDance` | Yes |
| TICKLE | `BattleAnim_Tickle` | Yes |
| TRUMP_CARD | `BattleAnim_TrumpCard` | Yes |
| UPROAR | `BattleAnim_Uproar` | Yes |
| WAKE_UP_SLAP | `BattleAnim_WakeUpSlap` | Yes |
| WATER_SPORT | `BattleAnim_WaterSport` | Yes |
| WORRY_SEED | `BattleAnim_WorrySeed` | Yes |
| WRING_OUT | `BattleAnim_WringOut` | Yes |

## All special-animation entries

| Animation | Local entry | Source entry |
| --- | --- | --- |
| ANIM_BRN | BattleAnim_Brn | BattleAnim_Brn |
| ANIM_CONFUSED | BattleAnim_Confused | BattleAnim_Confused |
| ANIM_ENEMY_DAMAGE | BattleAnim_EnemyDamage | BattleAnim_EnemyDamage |
| ANIM_ENEMY_STAT_DOWN | BattleAnim_EnemyStatDown | BattleAnim_EnemyStatDown |
| ANIM_FRZ | BattleAnim_Frz | BattleAnim_Frz |
| ANIM_HELD_ITEM_TRIGGER | Absent | BattleAnim_HeldItemTrigger |
| ANIM_HIT_CONFUSION | BattleAnim_HitConfusion | BattleAnim_HitConfusion |
| ANIM_INTRO_HAIL | BattleAnim_Hail | Absent |
| ANIM_INTRO_RAIN | BattleAnim_RainDance | Absent |
| ANIM_INTRO_SANDSTORM | BattleAnim_Sandstorm | Absent |
| ANIM_INTRO_SUN | BattleAnim_SunnyDay | Absent |
| ANIM_IN_HAIL | BattleAnim_InHail_PC4 | Absent |
| ANIM_IN_LOVE | BattleAnim_InLove | BattleAnim_InLove |
| ANIM_IN_NIGHTMARE | BattleAnim_InNightmare | BattleAnim_InNightmare |
| ANIM_IN_SANDSTORM | BattleAnim_InSandstorm_PC4 | Absent |
| ANIM_IN_WHIRLPOOL | BattleAnim_InWhirlpool | BattleAnim_InWhirlpool |
| ANIM_MISS | BattleAnim_Miss | BattleAnim_0 |
| ANIM_PAR | BattleAnim_Par | BattleAnim_Par |
| ANIM_PLAYER_DAMAGE | BattleAnim_PlayerDamage | BattleAnim_PlayerDamage |
| ANIM_PLAYER_STAT_DOWN | BattleAnim_PlayerStatDown | BattleAnim_PlayerStatDown |
| ANIM_PSN | BattleAnim_Psn | BattleAnim_Psn |
| ANIM_RETURN_MON | BattleAnim_ReturnMon | BattleAnim_ReturnMon |
| ANIM_SAP | BattleAnim_Sap_PC3 | BattleAnim_Sap |
| ANIM_SEND_OUT_MON | BattleAnim_SendOutMon | BattleAnim_SendOutMon |
| ANIM_SHAKE | BattleAnim_Shake | BattleAnim_Shake |
| ANIM_SLP | BattleAnim_Slp | BattleAnim_Slp |
| ANIM_SNATCHED_MOVE | Absent | BattleAnim_SnatchedMove |
| ANIM_THROW_POKE_BALL | BattleAnim_ThrowPokeBall | BattleAnim_ThrowPokeBall |
| ANIM_WOBBLE | BattleAnim_Wobble | BattleAnim_Wobble |

## All 82 local moves absent from Sour Apple

ACCELROCK, ACROBATICS, APPLE_ACID, ARMOR_CANNON, BANEFUL_BUNKER, BARB_BARRAGE, BITTER_BLADE, BLOOD_MOON, BODY_PRESS, BULLDOZE, CIRCLE_THROW, COTTON_GUARD, DAZZLING_GLEAM, DIRE_CLAW, DISARMING_VOICE, DRAGON_DARTS, DRAGON_HAMMER, DRAGON_TAIL, DRAINING_KISS, DRILL_RUN, DUALWINGBEAT, EERIE_SPELL, FAIRY_WIND, FICKLE_BEAM, FIERY_DANCE, FIRST_IMPRESSION, FLAME_CHARGE, FLIP_TURN, FOUL_PLAY, FREEZE_DRY, GIGA_HAMMER, GLAIVE_RUSH, GRAV_APPLE, HEADLONGRUSH, HEAT_CRASH, HEAVY_SLAM, HEX, HONE_CLAWS, HORN_LEECH, HURRICANE, ICICLE_CRASH, INCINERATE, INFERNAL_PARADE, INFESTATION, KOWTOW_CLEAVE, LIQUIDATION, LOW_SWEEP, LUMINA_CRASH, LUNGE, MOONBLAST, MORTAL_SPIN, NUZZLE, PETAL_BLIZZARD, PHANTOMFORCE, PIXIE_PUNCH, PLAY_ROUGH, PSYSHIELD, PSYSHOCK, PSYSTRIKE, QUIVER_DANCE, RAGE_FIST, RAGING_BULL, RAGING_FURY, SACRED_SWORD, SCALD, SCALE_SHOT, SHADOW_BONE, SHELLSIDEARM, SHELL_SMASH, SNARL, SOLAR_BLADE, SPIRIT_BREAK, STICKY_WEB, STONE_AXE, STRANGESTEAM, STRUGGLE_BUG, TRIPLE_AXEL, TROP_KICK, VENOSHOCK, VOLT_SWITCH, WILD_CHARGE, WORK_UP.


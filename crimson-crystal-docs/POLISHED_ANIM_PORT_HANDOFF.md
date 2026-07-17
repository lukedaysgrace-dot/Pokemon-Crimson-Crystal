# Polished Crystal Animation Port — Audit & Fix Handoff

Session date: 2026-07-16. Reference repo: `polishedcrystal-master` (mounted alongside this repo).

## Goal
Move animations must match Polished Crystal (PC) EXACTLY. A previous port copied PC's
anim data into Crimson Crystal (CC) but many moves rendered wrong.

## Tooling (reusable)
- `tools/anim_compare.py` — resolves every move's animation in BOTH repos down the full
  chain (script commands -> object rows -> framesets -> OAM sets -> OAM sprite data ->
  gfx png pixel hashes + tile counts) and reports semantic differences per move.
  Run: `python3 tools/anim_compare.py` from the folder CONTAINING both repos
  (edit ROOT/CC/PC constants at top). Writes `anim_report.txt`.
  Handles: CC's `_PC3/_PC4/_B` label suffixes, `dsprite` vs `dbsprite` arg order,
  flip-flag spelling, label fallthrough, `anim_call`/`anim_jump` sub pairing,
  PC's `if !DEF(FAITHFUL)` blocks, `const_next` gaps in move constants.
- `tools/func_compare2.py` — pairs engine functions via the object tables (authoritative
  CC-func <-> PC-func correspondence) and diffs normalized code. NOISY (fallthrough
  flattening explodes on some PC layouts); use its output only as a candidate list,
  then eyeball each pair directly.

## FIXED this session (all verified against PC data)

### Data layer (comparator now reports 0 real diffs across all 314 compared scripts)
1. `data/battle_anims/objects.asm` — 20 object rows corrected to PC values:
   palettes (ABSORB, SCREEN, FIRE_BLAST, SACRED_FIRE, POWDER, HORN, PAY_DAY, ANGER,
   AURA_SPHERE, SEISMIC_TOSS, HAIL, AVALANCHE_BIG), y-fix offsets (DISABLE, PARALYZED,
   THUNDER_WAVE, WATER_GUN, ICE_BEAM, SEISMIC_TOSS), framesets (RECOVER, HEART,
   SHADOW_BALL, HAIL, AVALANCHE_BIG), gfx (SHADOW_BALL egg->glow_shadow,
   AVALANCHE_BIG ice->rocks), func (SEISMIC_TOSS -> NULL).
2. `data/battle_anims/framesets.asm` — Frameset_14 duration 20->15 (Ice Beam);
   new `.SET_PC_HEART_SHORT` (hearts hold 60 frames then delete; Frameset_76 kept
   vanilla for ATTRACT which is what PC does); SET_PC_GYRO_BALL now uses two new
   OAM sets; removed a stray NUL byte after Dig's oamdelanim.
3. `data/battle_anims/oam.asm` — added `BATTLEANIMOAMSET_PC_GYRO_BALL_2/_3`
   (+ data blocks, copied from PC's OAMData_95/OAMData_b9).
4. `data/battle_anims/object_gfx.asm` — tile counts: focusblast 8->18, stars 8->5
   (wrong counts corrupt vtile allocation for everything loaded after them).
5. `gfx/battle_anims/angels.png`, `globe.png` — replaced with PC versions (CC still
   had vanilla art). NOTE: stale `angels.2bpp(.lz)` / `globe.2bpp(.lz)` intermediates
   exist in gfx/battle_anims and could not be deleted from the sandbox — if those two
   still look wrong after building, delete the four intermediates and rebuild.
6. Status/generic anims in `data/moves/animations.asm` now match PC exactly:
   Brn/Psn/Frz (added anim_setobjpal + PC coords), Par (bg effect alias, SFX_ZAP_CANNON,
   y=90, wait 32). New `BattleAnim_Sap_PC3` (animations3.asm), `BattleAnim_InHail_PC4`,
   `BattleAnim_InSandstorm_PC4` (animations4.asm) — negative-ID banim table repointed.
   (Scripts live next to their subs because anim_call cannot cross banks.)

### Engine layer — two real bugs found & fixed
7. **Frameset id truncation (the "Stone Edge shows cut-off boulders" bug).**
   `BATTLEANIMSTRUCT_FRAMESET_ID` and the object-table frameset field are ONE BYTE.
   CC had 278 framesets; the 22 at index >= $100 silently truncated (0x111 -> 0x11).
   Fix: swapped those 22 constants/table-rows with 22 orphaned low-index framesets
   (constants file + framesets.asm pointer table swapped consistently; verified
   order match + all object-referenced framesets now < 256).
   This was breaking: Stone Edge, Poison Jab, Dark Pulse (all 8 directions),
   Icicle Crash, Bullet Punch, Sucker Punch, Hydro Pump shot, Dig pile, Tri Attack
   triangles, Moonblast sparkles, Zen Headbutt star, Bug Buzz glow, Brick Break,
   Ice Shard, Mach Punch, Minimize, Acid droplets, Gyro Ball, hearts, mushrooms.
   **RULE FOR FUTURE PORTS: framesets referenced by objects MUST stay below index 256.**
8. **Stale anim_hiobj high byte.** `BattleBGEffect_BattlerObj_1Row/2Row` set
   `wBattleObjectTempID` without clearing `wBattleObjectTempIDHi`, so after any
   object id >= $100 spawned (anim_hiobj), the battler head/feet overlay spawned
   object id+$100 = garbage. Fixed in `_QueueBattleAnimation` (bg_effects.asm:543).
   Affected: Bug Buzz, Disarming Voice, Hydro Pump, Icy Wind, Petal Dance,
   Volt Switch, Wild Charge, Zen Headbutt (and Air Slash-adjacent flows).

### Verified-equal (no change needed)
- Anim command opcode enum matches the engine jumptable 1:1 (d0-ff). The
  battlergfx_1row/2row "cross" exists identically in PC — not a bug.
- BATTLEANIMFUNC_46/47/48/4A/4D/4E == PC Curse/PerishSong/RapidSpin/RainSandstorm/
  AncientPower/RockSmash (line-by-line). RadialMoveOut family + RadialInit/RadialStep,
  PowerGem, BubbleSplash also verified equal. ANIM_BG_06==CycleOBPalsGrayAndYellow and
  ANIM_BG_20==ShakeScreenY handler implementations verified equal (CC EQU aliases OK).

## SESSION 2 (2026-07-16, continuation) — remaining-work items 1 & 2 CLOSED

### Item 1 CLOSED: all 28 candidate BATTLEANIMFUNC pairs verified — 100% noise, ZERO ports needed.
Every pair compared side-by-side with helper chains chased
(04 MoveWaveToTarget, 08 SpinAround, 0B RazorLeaf, 0C Bubble, 0D Surf, 0E Sing,
11 Powder, 14 Recover, 16 Clamp_Encore, 17 Bite, 1B Kick, 1C Absorb, 1E MoveUp,
22 ConfuseRay, 24 Amnesia, 28 Paralyzed, 2B Horn, 2C Needle, 2E ThiefPayday,
30 Bonemerang, 31 Shiny, 35 PresentSmokescreen, 37 SpeedLine, 38 Sludge,
3A MetronomeSparkle, 3F Spikes, 45 HiddenPower, 4F Cotton).
All differences were mechanical PC refactors: jmp-vs-call+ret, rept blocks,
`cpl` vs `xor $ff`, tail merges into `dw DoNothing`/`dw FarDeinitBattleAnimation`
jumptable entries, and the known symbol translations
(VAR1/2/3==0F/10/11, StepToTarget==Functionce70a, StepCircle==Functionce6f1,
StepThrownToTarget==Functioncda8d, FIX_Y==STRUCT_02, OAMFLAGS==STRUCT_01).
**Surf note:** PC additionally sets/clears `rIE` B_IE_STAT — that is PC engine
infrastructure (PC's LCD handler needs explicit STAT gating; CC/vanilla keeps STAT
enabled and its LCD handler early-outs on hLCDCPointer==0). Correctly NOT ported.

### Item 2 CLOSED: appended BG effect handlers verified equal.
CycleBGPals_Inverted: identical (incl. .Pals data). ShakeMonY/ShakeMonX: equal;
CC's extra push/mask-bit0/pop around SetLCDStatCustoms2 is the documented
CheckBattleTurn workaround; PC's rIE gating again correctly omitted.
Helpers verified: SetLCDStatCustoms2, ClearLYOverrides identical;
GetNthDMGPal, ResetLCDStatCustom equal modulo translations;
FillLYOverridesBackup / DisplaceLYOverridesBackup are PC's versions plus CC's
documented empty-range/zero-displacement crash guards (safe supersets).
BattlerObj_1Row/2Row bodies equal modulo temp-var names
(wBattleObjectTemp* == wBattleAnimTemp0-3).
**One accepted difference:** PC's `BGEffect_CheckMonVisible` also checks
`SUBSTATUS_FAINTED` (a PC-only substatus bit that does not exist in CC/vanilla);
CC's `BGEffect_CheckFlyDigStatus` checks FLYING|UNDERGROUND only. Not portable,
engine-substrate difference, no visual impact in CC's flow.

## SESSION 3 (2026-07-16) — dynamic-frameset engine hook ported (Poison Jab mirrored needles / Bug Buzz missing waves)

User reported after rebuild: Poison Jab's needle particles render mirrored ("backwards")
and Bug Buzz shows only the green MID_GLOW_SHRINKING, no waves.

Root cause: PC's OAM composer has a `.SetDynamicTileData` step (PC core.asm) that CC
never ported. For framesets >= PC's `FIRST_DYNAMIC_FRAMESET` (BUG_BUZZ, POISON_JAB,
CUT_HORIZONTAL, SUCKER_PUNCH), `BATTLEANIMSTRUCT_VAR3` (== CC STRUCT_11; bits 0-2
direction octant, bit 3 priority) selects per-direction {x/y flip, tile delta} from an
8-entry table (GFX drawn in E +$0 / S +$4 / NE +$8 orientations). CC's producer
functions (RadialInit, RadialMoveIn, DarkPulse, NightSlash) already wrote STRUCT_11
("kept for parity") but nothing consumed it, so:
- Poison Jab / Dark Pulse / Sucker Punch needles all drew the unflipped E-orientation
  tiles regardless of octant (the reported mirroring);
- Bug Buzz's wave OAM sets (tile offsets $fc/$f8, authored assuming the NE +$8 delta)
  indexed backwards into midglowclear's tiles, so the waves never appeared.

Fix: ported `.SetDynamicTileData` + tile table verbatim into CC
`engine/battle_anims/data_readers.asm` (BattleAnimOAMUpdate), called after the
frame-flag XOR, before the OAM-set tile offset is applied. PC gates it with
`cp FIRST_DYNAMIC_FRAMESET`; CC's four equivalent framesets are scattered low-index
(PC_BUG_BUZZ, PC_POISON_JAB, PC_CUT_HORIZONTAL, PC_SUCKER_PUNCH), so the hook matches
them explicitly (FRAMESET_ID_HI must be 0). Tile-math verified: Bug Buzz base 9 +
delta 8 = 17 → BUG_BUZZ1 ($fc) tiles 13/14/16, BUG_BUZZ2 ($f8) tiles 9-15, all inside
the bugbuzz set; Poison Jab $0a + {0,4,8} + 0-3 = $0a-$15, exactly objects2's 22 tiles.
Also silently fixes Dark Pulse (all 8 octants), Night Slash's horizontal cut, and
Sucker Punch orientations. Not build-verified in sandbox (no rgbds) — run `make`.

## REMAINING WORK
1. ~~Vanilla motion functions~~ DONE (see above — no changes were needed).
2. ~~Appended BG effect handlers~~ DONE (see above — no changes were needed).
3. **Air Slash** — EXHAUSTIVELY AUDITED in session 2 after rebuild (user still saw
   "2 tiny crescents at the bottom"). Verified byte-identical to PC at EVERY level,
   including in the BUILT ROM via pokecrystal.sym + direct ROM byte reads:
   script bytes (7b:52aa: all 8 anim_hiobj spawns, coords, params), banim indexing
   (AIR_SLASH=276 -> row 277 ✓), object row $121 (21 ff 49 55 02 14 ✓),
   frameset $49 (3-byte entries, flip flags bits 6-7, delanim $fcff ✓),
   OAM sets 56/57/58 (shared OAMData_56, tile bases 0/2/4 ✓), whip.png (pixel-equal),
   func jumptable [$55]->RadialMoveOut_Slow ($64a4 ✓, code bytes disassembled ✓),
   InitBattleAnimation (id*6 with hi byte ✓), GetBattleAnimFrame flag extraction ✓,
   OAM composer flag math ✓, both BG effects ($1f shake, $07 cycle-mid ✓),
   anim loop cadence (1 DelayFrame/tick, same as PC) ✓, OAM window (c400-c4a0,
   aligned, capacity fine: max ~22 sprites concurrent) ✓, object slots (max 9/10) ✓,
   scanline limit not exceeded ✓. anim_hiobj path proven working (Stone Edge objs
   are $160/$161 and render correctly).
   A Python frame-by-frame simulation of the exact ROM data
   (tools note: outputs/airslash_sim.py from the session) shows what this code
   ACTUALLY produces: 8 crescents in 4 rapid pairs, each alive only ~13 frames,
   flickering between flipped/unflipped frames over the slash + screen shake, and
   ONLY the final pair getting clean screen time at the bottom after the slash ends —
   i.e. the reported symptom IS this animation rendering correctly; the effect is
   just subtle in real time. PENDING: user to frame-advance CC vs real Polished
   3.2.3 to confirm parity. If a flashier look is wanted, double Frameset_49
   durations (affects Razor Wind too, which shares OAM sets but not this frameset id).
4. Intentionally NOT changed: BattleAnim_StatUp/StatDown (user's own redesign,
   commit d8d1e55e) and the three negative-ID pointer-pairing artifacts in the
   comparator report (verified fine by direct label comparison).
5. Build verification could not run in the sandbox (no rgbds; network blocked).
   Run `make` on Windows. Only static/structural checks were done (all passed:
   table/constant counts aligned, all symbol references resolve, no stray bytes).
   No engine/data files were modified in session 2, so session-1's structural
   checks remain valid.

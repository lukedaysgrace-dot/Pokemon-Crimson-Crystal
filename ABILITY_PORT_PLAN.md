# Ability System Port: Polished Crystal → Supreme Silver

Status doc, updated 2026-07-01 (session 2). Phases 1-2 complete, Phase 3-4
substantially complete, Phase 5 not started. Everything below builds clean
with rgbds 0.5.2 (`make` produces pokecrystal.gbc).

## DONE

### Phase 1 — Foundation (complete)
- `constants/ability_constants.asm`: all 159 Polished abilities (NO_ABILITY..MEGA_SOL),
  NUM_ABILITIES = 159. Included from constants.asm.
- `data/abilities/names.asm`: all names, walker format ("---@", "Stench@", ...).
- `abilities_for MON, a1, a2, hidden` in all 401 `data/pokemon/base_stats/*.asm`,
  stored in the 4 former beta-pic padding bytes (BASE_DATA_SIZE unchanged, $20).
  Macro in data/pokemon/base_stats.asm. WRAM: wBaseAbility1/2, wBaseHiddenAbility.
- Personality byte: appended to box_struct (after Level) and battle_struct (after
  Level, mirroring the party layout so InitBattleMon's bulk copy stays aligned).
  ABILITY_MASK %01100000, ABILITY_1/ABILITY_2/HIDDEN_ABILITY. SAVE-BREAKING as agreed.
  WRAM overflow absorbed: wram.asm battle-tower pad (-21 bytes), wd019 pad (-18).
- `home/abilities.asm`: GetAbility (c=species, b=personality -> b=ability; falls
  back to slot 1 if the rolled slot is empty), GetRandomAbilitySlot,
  SetPlayerAbility/SetEnemyAbility.
- BATTLE_VARS_ABILITY / BATTLE_VARS_ABILITY_OPP + wPlayerAbility/wEnemyAbility
  (current effective ability; Trace overwrites the battle var).
- Personality rolled/copied at every creation point: GeneratePartyMonStats (both
  paths), LoadEnemyMon (wild roll w/ BattleRandom + trainer copy from OT party),
  InitEnemyMon (link), SendMonIntoBox, daycare egg creation. Catching preserves
  the wild mon's ability. Trainer mons roll 50/50 per battle load (see TODO).

### Phase 2 — Slideout banner + SFX (complete)
- SFX_ABILITYSLIDEOUT ported to vanilla audio macros (audio/sfx.asm,
  sfx_pointers.asm, constant $cf).
- `engine/battle/ability_gfx.asm`: fixed-width port of Polished's banner (SS has
  no VWF). 16x2-tile banner (SLIDEOUT_WIDTH=16 fits "Neutralizing Gas"), tiles in
  VRAM BANK 1 ids $c0-$df (enemy) / $e0-$ff (player) so they never conflict with
  scene tiles; attrmap cells get VRAM_BANK_1|PRIORITY. Enemy banner at (4,3),
  player at (0,8). Slide = 1 column/frame with STAT-safe hblank VRAM copies
  (SafeCopyVRAMToWRAM/SafeCopyWRAMToVRAM in that file); text carved out of the
  solid band per-char (PAL_BATTLE_BG_TEXT). wAbilityTiles (512B) lives in the
  wTempTileMap WRAM bank. PerformAbilityGFX / PerformAbilityReplacementGFX
  (Trace, SFX_SWEET_KISS) / DismissAbilityOverlays (restores tilemap from
  wTempTileMap + rebuilds attrs via GetSGBLayout SCGB_BATTLE_COLORS) /
  ResetAbilityTilemap.

### Phase 3 — Ability engine (core categories done)
`engine/battle/abilities_engine.asm` (own bank "Abilities Engine"):
- Framework: SwitchTurn, StackCallOpponentTurn, BattleJumptable, BattleRandomRange,
  BeginAbility/EndAbility (wInAbility, banner lifecycle), ShowAbilityActivation /
  ShowEnemyAbilityActivation / ShowPotentialAbilityActivation / ShowAbilityReplacement.
- Getters: GetTrueUserAbility/GetOpponentAbility (Neutralizing Gas suppression via
  ABILFLAG_NO_SUPPRESS), ignorable variants (Mold Breaker + ABILFLAG_IGNORABLE),
  GetAbilityFlags + full flags table (data/abilities/flags.asm, from Polished).
- Entry abilities: Trace (full, with banner replacement + re-run), Imposter,
  Intimidate (blocked-by-flag handling incl. resist text + Rattled proc; uses
  vanilla statdown machinery, respects Mist), Download, Frisk, Unnerve, Drizzle/
  Drought/Sand Stream/Snow Warning (5 turns; text only, no move anim yet),
  Cloud Nine, Pressure, Mold Breaker, Neutralizing Gas (notification), Screen Cleaner.
- Status-heal abilities (also run at entry): Limber, Immunity, Pastel Veil,
  Magma Armor, Water Veil, Insomnia, Vital Spirit, Own Tempo, Oblivious.
- Status PREVENTION helpers ready for hooking: AbilityPreventsSleep/Paralysis/
  Poison/Burn/Freeze/Confusion/Attraction (banner + carry) — NOT yet wired (below).
- End-of-turn: Speed Boost, Shed Skin (30%), Hydration, Rain Dish (1/16),
  Ice Body (1/16), Dry Skin (rain heal 1/8 / sun hurt 1/8), Solar Power, Bad Dreams.
- Post-battle: Pickup (10%, simple 10-item table in that file), Honey Gather
  (level-scaled, gives GOLD_BERRY — no honey item exists), Natural Cure. Runs
  silently (no banner) — see TODO.
- Stat helpers: StatUpAbility/AbilityRaiseStat/AbilityLowerOppStat wrap vanilla
  RaiseStat/BattleCommand_StatDown + StatUp/DownMessage (exported from
  effect_commands.asm).
- Ability battle text: data/text/ability_text.asm, included at the end of
  data/text/battle.asm (must stay in BANK(BattleText) for StdBattleTextbox).

### Phase 4 — Hooks (partially done)
- Switch-in: every `SpikesDamage` call/jp site in core.asm redirected to
  SpikesDamageAndEntryAbilities -> farcall RunEntryAbilities (10 sites; covers
  battle start, switches, baton pass).
- wInAbility zeroed at battle start (before InitBattleMon).
- End of turn: HandleBetweenTurnEffects .NoMoreFaintingConditions ->
  farcall RunEndTurnAbilitiesBoth + faint check.
- Post-battle: before GivePokerusAndConvertBerries in core.asm.

### Status prevention (DONE, session 2 continuation; Limber emulator-verified)
- All wired: Sleep (Insomnia/Vital Spirit), Paralysis (Limber), Poison
  (Immunity/Pastel Veil, primary + secondary), Burn (Water Veil, secondary),
  Freeze (Magma Armor, secondary), Confusion (Own Tempo, covers snore/swagger/
  confusehit paths), Attraction (Oblivious).
- Bank space freed by relocating BattleCommand_Paralyze's body into
  effect_commands_core.asm ("Battle Effect Overflow") with callfar conversions
  (jr->jp where reach broke) - the repo's established StartHail pattern.
  The ability hook lives inside the relocated body.
- Verified in-emulator: Thunder Wave vs wild Ditto -> banner "DITTO's Limber",
  "It didn't affect Enemy DITTO!", status stays clean.
- Ability descriptions data ported (data/abilities/descriptions.asm, own bank,
  AbilityDescriptions:: table) - ready for the Phase 5 stats screen UI.
- Dismissal garbage-flash fixed (push tiles before attr rebuild in
  DismissAbilityOverlays).

### Session 2c additions (all emulator-verified where noted)
- **Nullification/absorb abilities** (VERIFIED: Water Gun vs wild Vaporeon ->
  banner "VAPOREON's Water Absorb", zero damage): hook at the end of
  BattleCommand_Stab zeroes wTypeModifier and procs the absorb on the
  defender's side. Covers Volt Absorb, Lightning Rod (SpA+1), Motor Drive
  (Spe+1), Water Absorb, Dry Skin (heal 1/4), Flash Fire (immunity only, no
  boost yet), Sap Sipper (Atk+1), Levitate. Table: NullificationAbilities in
  abilities_engine.asm. LIMITATION: damaging moves only - status-move absorbs
  (e.g. Thunder Wave vs Volt Absorb) not covered; Flash Fire boost not
  implemented.
- **Moxie** on KO (build-verified): RunFaintAbilities hooked into
  FaintEnemyPokemon + FaintYourPokemon. Minor inaccuracy: can proc on
  residual-damage KOs, not just move KOs.
- **Stats screen ability display** (VERIFIED: green page shows
  "ABILITY <name>" between ITEM and MOVE; ability name prints before the MOVE
  label so 16-char names spill harmlessly underneath it). Helper:
  PlaceAbilityNameStats in engine/pokemon/abilities.asm. Descriptions data is
  ported but not yet shown anywhere (needs a page-4 or info box next session).

### Session 2d additions
- **Damage modifiers** (VERIFIED: Thick Fat halves Ice Punch damage, 14 -> 7):
  hook extends the existing post-Stab farcall (RunNullificationAbilities ->
  RunDamageModifiers), modifying wCurDamage after it is final.
  Attacker: Huge Power (x2 physical), Guts (x1.5 physical when statused),
  Technician (x1.5 for <=60 BP), Tinted Lens (x2 not-very-effective),
  Solar Power (x1.5 special in sun), Overgrow/Blaze/Torrent/Swarm (x1.5
  matching type at <=1/3 HP). Defender: Thick Fat (x0.5 fire/ice),
  Multiscale (x0.5 at full HP), Fur Coat (x0.5 physical), Marvel Scale
  (x0.75 physical when statused - approximates the 1.5x Def boost),
  Filter/Solid Rock (x0.75 super effective), Dry Skin (x1.25 fire taken).
  Damage fraction helpers at the bottom of abilities_engine.asm.
  NOTE: Hustle intentionally NOT implemented (its accuracy penalty needs the
  accuracy hook first; boost alone would be a pure buff).
- **Stat-drop protection** (build-verified): Clear Body/White Smoke (all
  stats), Hyper Cutter (Atk), Keen Eye (Acc), Big Pecks (Def) - hooked into
  BattleCommand_StatDown after the Mist check; shows the banner and fails the
  move. Also covers Intimidate automatically (it uses the same command).
- **Weather damage immunity** (build-verified): sandstorm - Sand Veil/Rush/
  Force, Overcoat, Magic Guard; hail - Ice Body, Snow Cloak, Slush Rush,
  Overcoat, Magic Guard. Hooked at .SandstormDamage/.HailDamage in
  HandleWeather (core.asm).

### Session 2e additions
- **Accuracy/evasion abilities** (validated: battles play normally, hits land):
  hook at .skip_brightpowder in BattleCommand_CheckHit modifies the final hit
  chance in b. No Guard (either side, always hit), Compound Eyes (+25%,
  approximates x1.3), Hustle (-25% physical; its x1.5 physical damage boost is
  now enabled too), Sand Veil/Snow Cloak (-25% in their weather, approximates
  x0.8), Tangled Feet (x0.5 while defender confused), Wonder Skin (status
  moves capped at 50%).
- **Weather speed abilities** (build-verified): Swift Swim/Chlorophyll/
  Sand Rush/Slush Rush double effective speed in their weather; Quick Feet
  x1.5 while statused. Implemented in CompareSpeedsWithAbilities, replacing
  the .speed_check CompareBytes in DetermineMoveOrder (net bank byte savings).
  Note: only affects turn ORDER, not Speed-based formulas.
- **Contact abilities: engine + data complete, HOOK DISABLED.**
  data/moves/contact_moves.asm (110-move bitfield by 16-bit move index,
  generated from the canonical contact list; SS custom moves default to
  non-contact). Engine: RunContactAbilitiesHook + CheckContactMove + Static/
  Flame Body/Poison Point/Effect Spore/Tangling Hair/Poison Touch in
  abilities_engine.asm. The hook (a wrapper around BattleCommand_ApplyDamage)
  is COMMENTED OUT in effect_commands.asm: with it enabled, instrumented runs
  showed the chain works up to the 30% roll, but the apply path appears to
  hang when the banner runs from inside ApplyDamage (probe reached the
  BeginAbility step; battles then stall). NEXT SESSION: move the hook to a
  text-safe point later in the move script (e.g. an endmove-adjacent command,
  like Polished's RunHitAbilities placement), or defer the banner/text to
  after the HP-bar animation completes. Everything else is plug-and-play:
  re-enable with the farcall noted in the wrapper comment.

### Session 2f tuning
- Trainer abilities are now DETERMINISTIC (verified: Falkner's Pidgey rolls
  Keen Eye consistently): derived from the trainer mon's fixed Attack DV low
  bit (slot 1/2) in GeneratePartyMonStats; GetAbility's empty-slot fallback
  keeps single-ability species on slot 1. Player mons still roll 50/50 at
  creation and keep it for life.
- Accuracy reductions (Hustle, Sand Veil, Snow Cloak) tightened from x0.75 to
  x0.8125 (canon x0.8).
- Marvel Scale tightened from x0.75 to x0.6875 damage (canon x2/3).

### Session 2g
- Stat-change ANIMATIONS wired into ability stat changes (verified via
  Intimidate at battle start: banner -> wobble anim -> fell text, no
  glitches): AbilityRaiseStat/AbilityLowerOppStat now farcall
  BattleCommand_StatUpAnim/StatDownAnim before the message. Covers
  Intimidate, Moxie, Speed Boost, Download, Rattled, Tangling Hair and the
  absorb stat boosts.

### Session 2h
- Ability names are now ALL CAPS everywhere (single table in
  data/abilities/names.asm drives the banner, stats screen and Trace text).
- Species audit: only mesmeria and orstryx lacked abilities; assigned
  flavor picks (mesmeria: SYNCHRONIZE/ICE_BODY/BAD_DREAMS; orstryx:
  PRESSURE/KEEN_EYE/MAGIC_BOUNCE) - marked "change freely" in their files.
  The 56 species with an empty slot 2 are canon single-regular-ability mons
  (GetAbility falls back to slot 1). data/pokemon/base_stats/rypherior.asm
  is an orphaned misspelled file, not in the build; the real rhyperior.asm
  is included and has correct abilities.

### Session 2i: "-ate" type-conversion abilities (verified)
- All four implemented: Galvanize (Normal->Electric), Pixilate (Normal->
  Fairy), Refrigerate (Normal->Ice), Aerilate (Normal->Flying), each with
  the +20% converted-move boost (implemented as x1.1875; only applies when
  the move's ORIGINAL type in the ROM data is Normal). Struggle exempt.
- REFRIGERATE and AERILATE added as new constants (appended after MEGA_SOL;
  names/descriptions/flags tables extended in order; NUM_ABILITIES now 161).
- Conversion hooks UpdateMoveData (after GetMoveData) and rewrites the move
  struct's type, so STAB/type chart/absorbs all see the new type. VERIFIED:
  Refrigerate Amaura's Tackle reads type ICE in the move struct in-battle.
- Amaura/Aurorus restored to canon REFRIGERATE (was the Ice Body sub).
  Sylveon has PIXILATE as hidden (unobtainable until ability items).
  Aerilate/Galvanize currently unassigned (canon users are megas/regional
  forms not in the dex) - available for customs.
- Normalize and Liquid Voice NOT implemented (no users in the dex; Liquid
  Voice also needs sound-move data).

### Session 2j: ABILITY CAP key item (verified)
- New key item ABILITY CAP (reuses the ITEM_87 slot; name/attributes/effect
  table updated; the one ITEM_87 reference in catch_rate_items.asm renamed).
- Key-item pocket, reusable, not usable in battle. Use -> pick a party mon ->
  its ability cycles slot 1 -> slot 2 -> hidden -> slot 1, skipping slots the
  species does not have; eggs and single-ability mons get "won't have any
  effect". Plays the FULL_HEAL jingle and prints the new ability name.
  VERIFIED in-emulator: Gyarados cycles INTIMIDATE -> MOXIE -> MOLD BREAKER
  (hidden!) -> INTIMIDATE with correct text. This makes HIDDEN ABILITIES
  obtainable for the first time.
- Mom gives it right after the POKEGEAR in PlayersHouse1F (script mirrors the
  existing receiveitem pattern; NOT emulator-tested - verify the scene once
  on a fresh save). Effect core: AbilityCapCore in abilities_engine.asm.

## HOW AN ABILITY IS DETERMINED (reference)
- Every mon has a Personality byte (party/box/battle structs); bits 5-6 hold
  the ability slot: ABILITY_1 (%001), ABILITY_2 (%010), HIDDEN (%011).
- The slot is set ONCE at creation and never re-rolled: wild mons roll 50/50
  between slots 1/2 in LoadEnemyMon (link-safe RNG); gift/egg/generated mons
  roll in GeneratePartyMonStats / daycare; trainer mons derive it from their
  fixed DVs; catching copies the wild mon's byte, so the ability you saw is
  the ability you get.
- The slot maps to a concrete ability through the species' abilities_for
  entry in data/pokemon/base_stats/*.asm (slot 2 = NO_ABILITY falls back to
  slot 1). Hidden abilities exist in data but nothing assigns the HIDDEN
  bits yet - reserved for future ability items.
- In battle, wPlayerAbility/wEnemyAbility hold the CURRENT effective ability
  (Trace overwrites them; personality stays untouched).
- The ability shows on the stats screen green page ("ABILITY" line between
  ITEM and MOVE).

## NOT DONE / NEXT SESSION

1. **Contact hook re-enable** (see above - engine/data done, placement issue).
2. **Old item 1: accuracy abilities - DONE (see session 2e).** (Compound Eyes, Hustle penalty + then its
   x1.5 physical boost, No Guard, Sand Veil/Snow Cloak evasion, Tangled Feet,
   Wonder Skin): hook the accuracy math in BattleCommand_CheckHit.
2. **Nullification for status moves + Flash Fire boost flag**
2. **Wind Rider, Damp, Soundproof/Bulletproof/Overcoat** (need move-class data).
3. **Damage/stat modifiers** (Huge Power, Guts, Hustle, Technician, Tinted Lens,
   Filter/Solid Rock, Multiscale, Thick Fat, Fur Coat, Adaptability, Iron Fist,
   Sharpness, Mega Launcher, Tough Claws, Reckless, Rivalry, Sniper, Super Luck,
   Blaze/Overgrow/Torrent/Swarm, Solar Power SpA, weather speed abilities,
   Quick Feet, Marvel Scale, sandstorm/hail immunities, Magic Guard, No Guard,
   Compound Eyes, Sand Veil/Snow Cloak, Tangled Feet, Hustle acc, Unaware,
   Keen Eye/Hyper Cutter/Big Pecks/Clear Body/White Smoke stat-drop protection):
   hooks in damage calc + accuracy + stat-down paths. Battle Core bank has only
   ~60 bytes free — keep hooks as farcall one-liners; giga_hammer_core.asm was
   already relocated out ("Battle Core Overflow" pattern).
4. **Contact abilities** (Static, Flame Body, Poison Point, Effect Spore,
   Cute Charm, Cursed Body, Tangling Hair, Perish Body, Aftermath, Poison Touch,
   Pickpocket): needs a contact-move flag/table (SS moves have no flags byte) +
   RunHitAbilities/RunContactAbilities hook after damage.
5. **Faint abilities** (Moxie, and Aftermath above): hook at faint resolution.
6. **Not ported**: Anticipation, Forewarn, Moody, Harvest, Quick Draw, Cud Chew,
   Neutralizing Gas deactivation on switch-out, Synchronize, Berserk,
   Weak Armor/Justified/Rattled on-hit (Rattled works via Intimidate only),
   Magic Bounce, Prankster, trapping abilities (Shadow Tag/Arena Trap/Magnet Pull),
   Run Away, Early Bird, Gluttony, Unburden, Analytic, Infiltrator, Stench,
   Serene Grace, Skill Link, Sheer Force, Parental Bond, Pixilate/Galvanize/
   Corrosion, Gorilla Tactics, Armor Tail, Regenerator, Suction Cups, Sticky Hold,
   Liquid Ooze, Shield Dust, Wonder Skin, Leaf Guard, Illuminate, Honey Gather
   in-battle, item-related abilities, MEGA_SOL.
7. **Phase 5 UI**: ability name+description on the stats screen. Names data is
   done; descriptions still need porting from Polished data/abilities/descriptions.asm.
8. **Weather ability anims**: banner + text only right now (no RAIN_DANCE anim).
9. **Trainer abilities are re-rolled 50/50 each battle** (Polished has fixed
   per-party data). Deterministic option: derive from trainer DVs.
10. **Post-battle Pickup/Honey banner + text** (currently silent).
11. **AI ability awareness**: not started.
12. **In-game testing**: NOTHING has been emulator-tested yet. Test checklist:
    banner GFX on both sides (incl. two banners at once via Trace), weather on
    switch-in, Intimidate + Rattled + Mist, Trace copy + re-run, status heal on
    entry, end-of-turn procs + faints from Solar Power/Bad Dreams, Pickup after
    battle, save/load with new struct (OLD SAVES ARE BROKEN — expected).

## Emulator-verified (PyBoy headless, wild Gyarados harness)
- Battle starts, plays, and ends without crashes.
- Wild ability roll works (Gyarados rolls Intimidate/Moxie 50/50; personality,
  base abilities, wPlayerAbility/wEnemyAbility all verified correct in memory).
- Intimidate end-to-end: banner slides out on the enemy side, "GYARADOS's /
  Intimidate" carved white-on-black, Attack fell (correct stat + message),
  banner dismissed, battle continues. Known cosmetic: 2-3 frame flicker at
  dismissal (attr rebuild lags the tilemap restore).

## Bugs found & fixed during verification (watch for these patterns!)
1. SpikesDamage wrapper recursion: blanket string-replace redirected the call
   inside the wrapper itself -> infinite recursion -> crash to GBC screen.
2. farcall clobbers `a` (macro loads bank into a): args to farcall'd routines
   must go in b/c/d/e. AbilityStatDown shim added in the effect bank for
   BattleCommand_StatDown (takes stat in a).
3. SafeCopyVRAMToWRAM had reversed src/dst registers (wrote garbage into VRAM).
4. rVBK must only be nonzero inside the di window of LCD-safe copies, or the
   vblank handler's BGMap update writes tiles into the attr map.
5. wStringBuffer1/2 are in WRAM BANK 1 in this repo (not WRAM0!). Any code
   running with rSVBK=2 must not read them; banner code copies names into
   wAbilityPkmn/wAbilityName (bank 2) via CopyStringToAbilityBank.
6. Wild mons never pass through SpikesDamage, so battle start needed an
   explicit enemy-side RunEntryAbilities hook (core.asm .not_linked_2).
7. wInAbility lives in a union byte (wBT_OTTempMon3SpclDef) - fine because BT
   temp data is dormant in battles and it's zeroed at battle start, but don't
   trust it before that init runs.

## Debug harness (rebuild for testing)
Patch NewGame in engine/menus/intro_menu.asm (after ResetWRAM) to give a mon
and callfar StartBattle with wTempWildMonSpecies/wTempEnemyMonSpecies set (see
session log). PyBoy headless drives it: title -> START -> A -> battle. Poll
wInAbility/wEnemyAbility via pokecrystal.sym addresses to time captures.

## Species ability data
- 278 species matched Polished's abilities_for exactly (incl. _plain forms).
- 123 assigned canonical abilities restricted to the 159-ability set.
  Substitutions (canonical ability missing from the set):
  Refrigerate->Ice Body (amaura, aurorus); Ripen->Harvest (applin, flapple,
  appletun); Supersweet Syrup->Harvest (dipplin, hydrapple); Stamina->Sturdy +
  Stalwart->Steadfast (archaludon); Heavy Metal dropped + Stalwart->Steadfast
  (duraludon); Thermal Exchange->Flash Fire (frigibax line); Klutz dropped
  (buneary, lopunny, golett, golurk); Battery->Static (charjabug);
  Mirror Armor->Magic Bounce (corviknight); Storm Drain->Water Absorb (lileep,
  cradily); Flare Boost->Guts (drifloon, drifblim); Minus dropped (electrike,
  manectric); Gale Wings->Wind Rider (fletchling line, talonflame); Telepathy
  dropped (ralts line); Emergency Exit->Anticipation (golisopod); Wimp Out->
  Run Away (wimpod); Supreme Overlord->Moxie (kingambit); Disguise->Multiscale
  (mimikyu); Simple dropped (numel); Strong Jaw->Tough Claws (tyrunt, tyrantrum).
- CUSTOM MONS NEEDING LUCAS'S DECISION: mesmeria (NO_ABILITY placeholder),
  orstryx (NO_ABILITY placeholder), teddiursabm/ursaringbm (given MINDS_EYE to
  match Bloodmoon Ursaluna; confirm).

## Build & sandbox workflow (IMPORTANT for next session)
- rgbds 0.5.2 built from source in the sandbox at ~/rgbds-0.5.2/bin (rebuild each
  session: apt-get download bison m4 + dpkg -x to /tmp/local, then
  `make -C rgbds-src` with BISON_PKGDATADIR/M4 env; github.com git clone works,
  release-asset downloads are blocked).
- Build OUT of the mount: rsync repo -> ~/ss, `make RGBDS=~/rgbds-0.5.2/bin/`
  in ≤40s chunks (make resumes). Background processes die between shell calls.
- **DO NOT edit repo files with the host-side file tools**: the sandbox mount
  serves stale content for files written from the host (truncated views), which
  then corrupts builds/rsync. Edit ONLY via bash (python/sed) inside the mount.
  If corruption happens: restore with `git show HEAD:path > path` (git checkout
  can't write its index lock on the mount).
- Bank pressure: "Battle Core" ~60 bytes free, "Effect Commands" ~12 bytes free.
  Use the existing overflow-bank patterns for anything bigger than a farcall.

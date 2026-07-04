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

### Session 2k: player-side banner corruption FIX (verified)
- BUG (found by Lucas in playtesting): a live banner on the PLAYER side
  (rows 8-9) gets partially reverted/garbled when anything redraws those
  rows - the stat wobble anim and HP-bar/HUD updates rewrite wTilemap while
  the cells' attrs still point at VRAM bank 1 (enemy banners at rows 3-4
  never collided, which is why emulator tests missed it).
- FIX: all ability flows with side effects now present the banner BRIEFLY
  and dismiss it BEFORE the effect: slide out -> ~24-frame hold -> dismiss
  -> then stat change/anim/HP effect/message. New helper
  ShowAbilityBannerBrief in abilities_engine.asm. Applied to: Intimidate,
  StatUpAbility (Moxie/Speed Boost/Download/Rattled/absorb boosts),
  nullification absorbs, Rain Dish/Ice Body/Dry Skin/Solar Power/Bad Dreams.
  Text-only flows (notifications, Trace, Frisk, status heals, prevention)
  keep the banner through their text - they never redraw those rows.
- VERIFIED player-side: Gyarados Intimidate at switch-in: band + INTIMIDATE
  carve + hold -> clean dismissal -> "Enemy PIKACHU's ATTACK fell!" on an
  uncorrupted screen.

### Session 3: full-audit fixes (NOT yet built or emulator-tested!)
Lucas reported: banner shows garbage + a flash when it appears; Water
Absorb lets the move hit AND heals the attacker. Root causes found and
fixed, plus an audit sweep:

1. **Banner garbage/flash on appear AND dismiss - FIXED (rewrite).**
   Cause: engagement wrote the attr map and tilemap via WaitBGMap2, which
   pushes them on DIFFERENT frames -> several frames where cells point at
   bank-1 tiles with the old ids (garbage band + flash). Dismissal had the
   mirror problem plus a GetSGBLayout palette reload (screen flash).
   ability_gfx.asm was also left mid-refactor (dead code, deleted helpers
   still called) - it would not even have built. Rewrote on the HEAD base:
   per-cell ATOMIC BGMap writes (tile id + attr inside one hblank,
   hBGMapMode=0 during the loops), attr backup at engage (wAbilityAttrBackup,
   now 2 sides x 32 bytes + wAbilityBackupPtr), dismissal restores scene
   tiles from wTempTileMap + exact attrs from the backup. No WaitBGMap2, no
   GetSGBLayout, no palette reload anywhere in the banner path. Engage is
   idempotent (skips if the side is already engaged, keeps backup intact).
2. **Water Absorb healing the attacker - FIXED.** Vanilla RestoreHP heals
   the side OPPOSITE hBattleTurn (see Leech Seed/Leftovers). All ability
   self-heals went through it un-swapped, so Water/Volt Absorb + Dry Skin
   absorb healed the ATTACKER, and Rain Dish/Ice Body/Dry Skin end-of-turn
   healed the OPPONENT. New AbilityRestoreUserHP wraps it in SwitchTurns.
3. **Absorb abilities let the move hit - FIXED.** The nullification hook
   runs at the END of Stab, after the type-chart multiplication, so zeroing
   wTypeModifier alone did NOT zero wCurDamage and did NOT set
   wAttackMissed -> applydamage still landed. Now zeroes wCurDamage and
   sets wAttackMissed=1 (after the absorb effect runs - the stat-up helpers
   clear it), exactly like a natural immunity; failuretext then prints
   "doesn't affect" and ends the script.
4. **Contact abilities RE-ENABLED** at a text-safe point: farcall
   RunContactAbilitiesHook at the top of BattleCommand_HeldFlinch (the
   kingsrock command - runs after applydamage/checkfaint in every damaging
   script). The dead ApplyDamage wrapper was removed (net +2 bytes in the
   Effect Commands bank). Added guard: no procs if the defender fainted
   (Poison Touch was able to poison a fainted mon's party struct).
   IF BATTLES STALL after contact hits, remove that one farcall line.
5. **Banner-corruption pattern sweep** (session-2k rule: dismiss before
   anything that redraws): converted Imposter (Transform), Static, Flame
   Body, Poison Point/Poison Touch, Effect Spore, Tangling Hair to
   ShowAbilityBannerBrief.
6. **Download double banner - FIXED** (it showed its own banner AND
   StatUpAbility's ShowPotentialAbilityActivation slid a second one).
7. **Bad Dreams text - FIXED**: printed with the victim as turn holder, so
   "<TARGET>" named the Bad Dreams user; now "<USER>".
8. **Guts vs burn - FIXED**: extra x2 when burned so the burn attack cut is
   cancelled (net x1.5, canon behavior).
Audited and found CORRECT: entry-table split, Trace flow, Intimidate +
Rattled + flags, Download stat compare, status heal/prevention hooks (all 7
sites), weather abilities, end-of-turn procs (except the heal direction
above), Moxie, damage modifiers incl. pinch-boost HP math, accuracy mods,
speed compare direction at the DetermineMoveOrder call site, weather
immunities, -ate conversion, Ability Cap, GetAbility fallback, flags table
(161 = NUM_ABILITIES), battle-var wiring, SetPlayer/EnemyAbility refresh
before entry hooks.

**SANDBOX NETWORK WAS BLOCKED this session (github/apt/pip all 403) - no
rgbds, no PyBoy. NOTHING here is built or emulator-tested.** Test checklist
for next session: `make`; enemy + player banner appear/dismiss (no garbage,
no flash); Water Gun vs Vaporeon both directions (no damage, VAPOREON
heals, "doesn't affect"); Rain Dish/Ice Body heal the holder; Thunder Punch
vs Static mon repeatedly (30% attacker paralysis, no stall at kingsrock);
Ditto Imposter; Download (one banner); burned Guts damage; Bad Dreams text.

### Session 4: 10 new abilities incl. Disguise + sprite swap (NOT built/tested — network blocked again)
Added on Lucas's request, mechanics confirmed against Bulbapedia:
DISGUISE, GALE_WINGS, MERCILESS, MIRROR_ARMOR, STORM_DRAIN, STAMINA,
STRONG_JAW, SUPREME_OVERLORD, THERMAL_EXCHANGE, TRIAGE (NUM_ABILITIES 171;
constants/names/flags/descriptions all extended in matching order).

- **Disguise (Sun/Moon rules: no HP loss on break)**: hooked in
  .CheckNullification (defender ability == DISGUISE + species == MIMIKYU +
  unbusted). Zeroes wCurDamage + wCriticalHit, neutralizes wTypeModifier
  (no effectiveness text), does NOT set wAttackMissed so secondary effects
  still apply (canon). Busted state: wDisguiseBusted (2 bytes after
  wEnemyAbility; bit per party slot per side; wild = bit 0; bit 7 of +0 is
  the Mirror Armor guard), cleared in DoBattle. Sprite swap: new pics
  MimikyuBrokenFront/Backpic (INCBIN in the Abilities Engine bank, from
  gfx/pokemon/mimikyu-broken/, same 5x5 dims + palette as normal);
  LoadBrokenDisguisePic decompresses to wDecompressScratch, pads 5x5->7x7
  (PadFrontpic layout replicated), Get2bpp to vTiles2 $00 (enemy, + 25 anim
  tiles to VRAM bank 1 at tile $31 mirroring GetAnimatedFrontpic) or
  vTiles2 $31 (player backpic, 6x6). hBGMapMode=0 during, =1 after;
  rSVBK saved/restored. ReapplyBrokenDisguise in RunEntryAbilities keeps
  the broken sprite on re-entry (entrance anim shows normal pic for a
  moment — known cosmetic wart). LIMITATIONS: confusion self-hits and
  Struggle bypass (no Stab); dropping a Substitute redraws the normal pic;
  contact abilities don't proc off a blocked hit (damage==0 early-out).
  TIMING FIX (Lucas feedback): the bust + banner/text/sprite swap are now
  DEFERRED - DisguiseBlock only zeroes the damage and sets bit 7 of
  wDisguiseBusted+1; DisguisePresentation (called at the top of
  RunContactAbilitiesHook, i.e. kingsrock, after the move anim + HP bar)
  marks the slot busted and does the reveal. Bonus corrections: no trigger
  through a Substitute, and a move that misses after damage calc no longer
  busts the disguise (stale pending flag is cleared at the next Stab).
- **Gale Wings (X/Y rules: +1 priority for ALL Flying moves, no HP check)**
  and **Triage (+3 for HP-restoring moves, TriageMoves table)**:
  CompareMovePriority body replaced with farcall AbilityCompareMovePriority;
  GetMovePriority_e shim added (farcall clobbers a; returns priority in e).
- **Merciless**: farcall AbilityCriticalMods at the top of
  BattleCommand_Critical — always crits poisoned/toxic'd targets; also adds
  Battle Armor/Shell Armor crit BLOCKING (previously unimplemented).
- **Mirror Armor**: reflect branch in AbilityProtectsStatDrop — banner,
  sets guard bit, StackCallOpponentTurn + AbilityLowerOppStat with the
  original wLoweredStat byte (keeps sharp-drop flag), original drop fails.
  Covers moves AND Intimidate. No ping-pong (guard bit); reflected drops
  respect the attacker's Clear Body/etc + Mist.
  FIX (Lucas feedback): ability-driven drops (AbilityLowerOppStat -> bit 6
  of wDisguiseBusted, checked/cleared in StatDown's .ComputerMiss) now skip
  the vanilla 25% computer-miss roll that randomly ate Mirror Armor
  reflections AND enemy Intimidate. Tiny known leak: if the drop exits
  before .ComputerMiss (Mist/protection/at-minimum), the bit stays set and
  the enemy's next move-based stat drop skips its 25% roll once.
  FIX (Lucas feedback): IntimidateResistedText + TraceActivationText were
  printing garbage - the banner GFX clobbers wStringBuffer1, so
  GetAbilityName is now called AFTER the banners, right before the
  textbox, in both flows.
- **Storm Drain**: NullificationAbilities entry (WATER -> AbsorbRaiseSpAtk),
  i.e. water immunity + SpAtk+1. Same status-move limitation as Water Absorb.
- **Stamina / Thermal Exchange**: RunContactAbilitiesHook restructured —
  after the sub/faint early-outs, defender on-hit abilities now run for ANY
  damaging move, then the contact-only chain. Stamina: Def+1 per hit.
  Thermal Exchange: Atk+1 on Fire hits (no damage reduction, canon), added
  to AbilityPreventsBurn and to the entry status-heal table (cures burn).
- **Strong Jaw**: x1.5 in RunDamageModifiers for BiteMoves (BITE, CRUNCH,
  HYPER_FANG, FIRE/ICE/THUNDER/POISON_FANG — full canon list present here).
- **Supreme Overlord**: +9.375% damage per fainted ally (canon 10%,
  additive), counted live via CountFaintedAllies (eggs excluded; wild
  enemies = 0). NOTE: bodies for these two live AFTER .dry_skin — putting
  them before .pinch_boost breaks jr ranges in the dispatch chain.
- **AbilityStatDown REGRESSION FIX**: session 3 farcalled it but the shim
  had been lost — it's now `ld a, b` falling into BattleCommand_StatDown.
  THE PREVIOUS TREE DID NOT LINK.
- Species updates: fletchling line hidden -> GALE_WINGS; mimikyu ->
  DISGUISE; corviknight hidden -> MIRROR_ARMOR; lileep/cradily hidden ->
  STORM_DRAIN; archaludon -> STAMINA/STURDY/STEADFAST; tyrunt/tyrantrum ->
  STRONG_JAW; kingambit slot 2 -> SUPREME_OVERLORD; frigibax line ->
  THERMAL_EXCHANGE. MERCILESS and TRIAGE have no users yet (no
  mareanie/toxapex/comfey in the dex) — free for customs.
- Bank budget: Effect Commands +8 bytes (crit hook + shim) — if it
  overflows, relocate BattleCommand_Critical + its two data INCLUDEs to
  the Battle Effect Overflow bank. Battle Core roughly net-neutral.

### Session 5: full static audit of sessions 3-4 (network blocked AGAIN — no
rgbds/wine/PyBoy; the repo's rgbds/ is Windows-only. NOTHING built/tested.)
Audited: abilities_engine.asm + ability_gfx.asm line by line; every hook
site in effect_commands/core; symbol cross-check of all refs in the ability
files (all resolve); table order constants==names==flags==descriptions
(171 each, tails match); all 439 base_stats abilities_for args valid; the
8 status-prevention hook sites present; BattleVarPairs has the ability
pair; the 3-arg coord macro form used by ability_gfx exists; farcall
preserves flags (ReturnFarCall pops to bc), so all the carry-returning
farcall hooks are sound.

**FIXED (3 bugs found):**
1. **Contact/Disguise hook was at kingsrock — wrong script coverage.**
   Secondary-effect scripts (PoisonHit, FlinchHit, ConfuseHit, BurnHit,
   AttackDownHit, DreamEater, TriAttack, ... ~20 scripts) contain stab but
   NO kingsrock. Consequences: no contact procs (Static etc.) off any such
   move, and FATAL for Disguise: DisguiseBlock zeroed the damage at stab
   but the deferred reveal (at kingsrock) never ran -> Mimikyu blocked
   Bite/Ember/etc. forever without ever busting. Hook MOVED to the top of
   BattleCommand_CheckFaint — checkfaint is in EVERY damaging script (the
   only stab-scripts without it are Toxic/DoParalyze, correctly skipped),
   still after applydamage/criticaltext/supereffectivetext (text-safe) and
   before faint processing. Net bank size ~0 (farcall moved, not added).
   Side effect: contact procs now fire per-hit inside MultiHit's loop.
2. **Trace banner remnants**: PerformAbilityReplacementGFX wiped row 1 in
   the WRAM buffer but only uploaded the tiles the NEW name carves — a
   shorter traced name left the old name's glyphs in VRAM on the flanks.
   Now uploads the whole wiped row before DrawRow.
3. **Bit-6 leak closed for real**: BattleCommand_StatDown's .CantLower/
   .Failed/.Mist exits now clear the ability-driven-drop flag (was the
   documented "tiny known leak" that skipped the enemy's next 25%
   computer-miss roll once).

Audited and found CORRECT (sessions 3-4 code): StackCallOpponentTurn stack
math; nullification found-path (damage+typemod zeroed, wAttackMissed set
after the absorb effect); AbilityRestoreUserHP SwitchTurn wrap; damage
fraction helpers (big-endian wCurDamage reads, $ffff caps, min-1 store);
pinch-boost HP*3 compare; Guts burn-cancel x2; priority compare direction
+ Gale Wings/Triage adjustments; crit-mod order (armor block beats
Merciless, canon); Mirror Armor reflect flow + anti-ping-pong guard;
Disguise block/defer/reapply + GetDisguiseFlag bit layout; broken-pic
loader bank discipline; contact-chain perspectives (Stamina/Thermal on-hit
before the contact gate; every prevention check targets the right mon);
banner atomic BGMap writes are timing-safe (VRAM stays writable through
mode 2, so worst-case ~100 dots fits the >=165-dot hblank+OAM window);
attr backup/restore pointer flow; CheckContactMove bitfield math;
GetAbility fallback + bank save/restore.

Known minor notes (NOT fixed, low priority): personality ability bits %00
resolve to the hidden slot (all current creation points roll, so
unreachable — but a future gift-mon path that forgets to roll would hand
out hidden abilities); Quick Feet stacks with rather than ignores the
paralysis speed cut; Moxie can proc on residual-damage KOs; battle-start
entry abilities run player-then-enemy instead of speed order; status-move
absorbs now DO fire through DoPoison/DoParalyze's stab (Thunder Wave vs
Volt Absorb heals + fails the move — arguably canon; gate
.CheckNullification on move category if unwanted).

**Session 5b — CRASH FIX (from Lucas's live test: Static reset the game).**
Root cause: `CallBattleCore` is NOT a home routine in this repo — it lives
in the Effect Commands bank ($13). Three files plain-called it from OTHER
banks, which jumps into garbage and hard-resets:
- abilities_engine ($76): StaticAbility + FlameBodyAbility (and Effect
  Spore's paralysis branch via Static's shared body). This was Lucas's
  crash. -> now `farcall ApplyPrzEffectOnSpeed` / `farcall
  ApplyBrnEffectOnAttack` (farcall = same rst FarCall mechanism, correct
  bank).
- effect_commands_core ("Battle Effect Overflow", $17): the relocated
  BattleCommand_Paralyze body called it TWICE on the success path — i.e.
  every move-inflicted paralysis that actually LANDED crashed the game
  since session 2b (the emulator test only covered the Limber-blocked
  path). -> farcall ApplyPrzEffectOnSpeed + farcall
  UseHeldStatusHealingItem + ret.
Swept every other plain call/jp in abilities_engine, ability_gfx and
effect_commands_core against the map's bank assignments: all remaining
targets are ROM0 (home) or same-bank. AbilityCapEffect and the stats
screen already farcall correctly. Poison Point/Poison Touch/Tangling
Hair/Stamina/Thermal Exchange never used CallBattleCore (no crash there).
TEST: Thunder Wave that LANDS (the old crash), then Static/Flame Body
procs, then Effect Spore all three outcomes.

**Session 5c — status anims for contact abilities (Lucas request; contact
abilities confirmed WORKING in his testing after 5b).** New
AbilityStatusAnim helper in abilities_engine (local equivalent of Effect
Commands' PlayOpponentBattleAnim, which is bank-unreachable): sets
wFXAnimID/wNumHits, SwitchTurn-wraps farcall PlayBattleAnim so the anim
plays on the statused mon. Wired vanilla-style (status -> anim -> HUD ->
text) into: Static (ANIM_PAR, also covers Effect Spore's paralysis
branch), Flame Body (ANIM_BRN), TryPoisonOpponentContact (ANIM_PSN — Poison
Point, Poison Touch, Effect Spore poison), Effect Spore sleep (ANIM_SLP).
Banner is always dismissed first (ShowAbilityBannerBrief), so no
player-side banner corruption. Tangling Hair already animates via the
stat-down machinery.

**Session 5 test checklist (everything from sessions 3-4 still untested,
plus):** Bite/Ember/Poison Sting vs Mimikyu -> disguise busts on the FIRST
secondary-effect hit (0 damage, sprite swap, texts; later hits damage
normally); Thunder Punch vs Static mon (30% proc, no stall at checkfaint);
Doubleslap vs Static (per-hit procs OK); Trace copying a SHORT ability
over a longer one -> no leftover letters on the banner row; enemy stat-
drop move after a Mist-blocked enemy Intimidate -> 25% computer-miss roll
still applies (leak regression test); Thunder Wave vs Volt Absorb mon ->
heal + move fails (see note above).

**Session 4 test checklist (nothing built - rgbds unavailable in sandbox):**
`make`; wild/trainer Mimikyu both sides: first damaging hit -> banner,
decoy text, sprite becomes broken (front AND back), busted text, 0 damage,
Nuzzle-style secondaries still land, second hit damages normally, switch
out/in keeps broken sprite; Talonflame Brave Bird outspeeds faster mon;
Comfey-less Triage via Ability Cap hack mon if desired; Growl vs
Corviknight -> attacker's Attack falls; Intimidate vs Corviknight;
Thunder Wave-less: Toxic + attack vs Merciless holder -> every hit crits;
Crunch from Tyrunt vs calc; Kingambit damage grows after allies faint;
Ember vs Frigibax -> Atk+1, no burn from Fire Punch burns; Tackle vs
Archaludon -> Def+1 each hit; Water Gun vs Cradily -> SpAtk+1 + immune.

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

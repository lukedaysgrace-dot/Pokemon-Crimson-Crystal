# Code audit — August 2026 (abilities, moves, and their interactions)

Scope agreed with Lucas: the ability engine, the move data/effect layer, how
moves and abilities interact, and "anything else dicey" (AI, held items, new
16-bit move plumbing, battle UI). The July 2026 audit covered table alignment
and sprite data; this one went after the battle *logic*. Five parallel audit
passes read every line of `abilities_engine.asm`, the move data tables, every
ability hook site in the battle engine, the trainer AI, and traced ten
move↔ability interaction families end-to-end. Every fix below was then
adversarially re-verified against the final diff, and the ROM builds clean
with upstream rgbds 0.5.2 at every checkpoint.

Baseline: commit `30c6333`. Final ROM: `8a7e62e461e4ba99313c0a69f43415dd`.

---

## Engine bugs found and fixed

### 1. Contact-move aftermath ran with the battle perspective inverted — **the big one**
`RunContactAbilitiesHook` used `StackCallOpponentTurn` to run the defender's
contact abilities, but that helper defers its "switch back" until the whole
routine returns — so on every contact hit, the Aftermath and Life Orb
resolution that followed ran from the *defender's* perspective. Consequences:
Aftermath never triggered on a contact KO (its primary function); an
attacker's Life Orb never recoiled after contact moves; and a *defender*
holding Life Orb lost 1/10 max HP every time it survived a contact hit.
Fixed with an explicit `SwitchTurn` pair. (`abilities_engine.asm`)

### 2. Gale Wings and the "-ate" abilities read garbage from ROM
Both computed the move's type as `Moves + (index-1)*9`, but the `Moves` table
is an *indirect* table with 7-byte entries — three independent addressing
errors, so both read a meaningless byte for every move. Gale Wings gave +1
priority to essentially random moves instead of Flying ones; Refrigerate/
Pixilate/Galvanize/Aerilate applied (or missed) their x1.1875 boost per-move
at random. Both now use the proper `GetMoveAttribute` accessor, and Hidden
Power (stored as Normal, live type from DVs) is explicitly excluded from the
-ate boost. (`abilities_engine.asm`)

### 3. Enemy Natural Cure / Regenerator never worked on normal AI switches
`AI_Switch` copies the battle mon's status/HP back over the party struct —
*after* the switch-out heal had already written the party struct, wiping it.
And the most common path (voluntary AI switches) had no hook at all. The hook
now lives inside `AI_Switch` after the copy (and after Pursuit, matching
canon order), covering AI switches, link switches, and `EnemyMonEntrance` in
one place; the old clobbered call was removed. (`ai/items.asm`, `core.asm`)

### 4. Roar/Whirlwind and enemy Baton Pass skipped entry abilities
Three switch-in sites still called plain `SpikesDamage`: a dragged-in
Intimidate/Drizzle/Trace mon activated nothing, a dragged-in mon kept its
suppressed-weather state stale (Roar out a Cloud Nine holder and weather
stayed dead for the rest of the battle), and an enemy Baton Pass recipient
ran no entry abilities while the player's did. All three now go through
`SpikesDamageAndEntryAbilities`. Turn-state at each site was verified against
the actual send-out helpers before redirecting. (`effect_commands.asm`,
`move_effects/baton_pass.asm`)

### 5. Ability-driven stat drops trusted a stale move-effect byte
Intimidate (and Weak Armor/Tangling Hair/Mirror Armor reflections) ran
`BattleCommand_StatDown` while the "current move effect" was whatever move
that side had loaded last. Three symptoms: Intimidate pierced Mist by
default; if the stale effect happened to be Superpower & co., Intimidate
bypassed Mist *and* Clear Body/Hyper Cutter/Contrary entirely; and
Defiant/Competitive silently failed to answer Intimidate whenever the enemy's
previous move was one of the seven self-drop effects. Fixed with a dedicated
`wAbilityStatDropFlag` WRAM byte held across the whole drop+message+reaction
sequence: the stat-down path now tests Mist directly and the Defiant reaction
ignores the stale exclusion list. (A first draft used a spare-looking bit of
`wDisguiseBusted+1`; the verification pass caught that bit 5 is live data —
the enemy 6th-slot busted-disguise marker — hence the dedicated byte.)

### 6. Shed Skin / Hydration left the Toxic counter armed
They cure with an `ALL_STATUS` mask, but the toxic-marker cleanup only fired
on an exact `1 << PSN` match — so a cured bad poison left `SUBSTATUS_TOXIC`
and the counter behind, and a later ordinary poison escalated like Toxic.
Now a bit test. (`abilities_engine.asm`)

### 7. Magic Bounce could "reflect" ability-inflicted statuses
The bounce path decides "is this a status move?" from a move-struct read that
is stale during contact procs — a Magic Bounce attacker contacting a Static/
Flame Body/Poison Point/Effect Spore holder could get the 30% proc "bounced"
onto the holder itself. The existing anti-rebounce guard bit is now held
around all ability-driven status procs (contact region, Synchronize, Poison
Puppeteer). (`abilities_engine.asm`)

### 8. Rest ignored Insomnia / Vital Spirit
Every opponent-targeted sleep site was gated; self-sleep was not. Rest now
fails ("But it failed!") for Insomnia/Vital Spirit users. (`effect_commands.asm`
+ small `UserCantRest` helper)

### 9. Baton Pass leaked new per-mon state
The Glaive Rush vulnerability window, the Rage Fist hit tally, and First
Impression's entry-freshness were not reset on pass — a passed-in mon took
doubled unmissable damage for a turn it never attacked in, inherited an
inflated Rage Fist count, and could never use First Impression on its entry
turn. `ResetBatonPassStatus` now mirrors the normal switch-in resets.

### 10. Own Tempo missing at two confusion sites
Rampage fatigue (Thrash/Petal Dance) and Berserk Gene confusion ignored Own
Tempo. Both gated now; Berserk Gene's Attack boost still applies. (The
Berserk Gene rework also *shrank* the tight Battle Core bank by ~7 bytes.)

### 11. Focus Sash printed a garbage item name
The sash is consumed before damage, and the shared "hung on with X!" text
re-read the (now empty) item slot afterward. The name is buffered before
consumption; Focus Band unchanged.

### 12. AI's Icy Wind logic ran a conversion backwards
`AI_Smart_SpeedDownHit` called `GetMoveIDFromIndex` (index→ID) where the
DIG/FLY sibling sites correctly call `GetMoveIndexFromID` (ID→index) — the
compare ran on a clobbered register pair, so the "encourage Icy Wind vs a
faster player" branch never fired, and each call allocated a junk entry in
the 16-bit move translation table. One-line fix. (`ai/scoring.asm`)

### 13. Cosmetic pair
Fickle Beam printed "going all out!" (and rolled its 30%) before the
accuracy check — now sequenced after `checkhit` with a miss guard. The
per-turn rain/sun animation kept replaying while Cloud Nine suppressed
weather — now uses the same raw compare as every gameplay check.

## Move data fixed (approved by Lucas)

- **Waterfall** was moved onto the flinch effect but with a 0% chance — the
  flinch could never happen. Now 20% (modern canon).
- **Sky Attack**'s script had flinch commands with a 0% chance. Now 30%.
- **Iron Head** flinch 20% → 30% (canon; neighboring rows were all correct).
- **Raging Fury** had its contact bit set; canon says no contact (it was
  getting Static/Rocky Helmet/Cute Charm procs it shouldn't). Bit cleared.

## Canon mechanics implemented (approved by Lucas)

- **Sap Sipper vs Grass status moves**: Sleep Powder, Spore, Cotton Spore and
  Leech Seed are now absorbed (+1 Atk) like Stun Spore already was, via the
  status-class block at checkhit. Mold Breaker still pierces.
- **Overcoat vs powder**: a new `PowderMoves` list (Poison Powder, Stun
  Spore, Sleep Powder, Spore, Cotton Spore) is blocked at checkhit, matching
  the Effect Spore proc immunity that already existed. (Grass-type powder
  immunity remains deliberately deferred, per the plan doc.)
- **Contrary self-drops**: Superpower/Close Combat/Hammer Arm/Draco Meteor/
  Overheat/Leaf Storm/Scale Shot/Headlong Rush/Shell Smash drops on a
  Contrary user now invert into raises, with the anti-recursion marker, and
  multi-stat moves invert each drop (verified through the deferred-message
  system). Nullified moves (e.g. Headlong Rush into Levitate) correctly
  don't proc it.
- **Substitute vs stat-drop reactions**: a sub now blocks a move's stat drop
  before the target's abilities can react — no more free Contrary raises or
  Clear Body/Mirror Armor banners behind a sub. Exception kept per canon:
  Magic Bounce still reflects status moves from behind its own Substitute.
  Intimidate & co. are likewise blocked outright by a sub.

## Trainer AI taught the new move effects (approved: "fuller teaching")

- Will-O-Wisp: added to the status-only list (dismissed vs statused targets
  and under Safeguard), Fire-type immunity check mirroring the Toxic pattern,
  and added to the AI_CAUTIOUS residual list.
- Redundancy: AI no longer re-picks Stealth Rock or Trick Room while active,
  or Toxic Spikes at two layers (it will still lay the legal second layer);
  Roost is treated as redundant at full HP.
- Baneful Bunker now gets AI_Smart_Protect's consecutive-use logic (verified
  it shares the Protect counter).
- Setup encouragement: Bulk Up, Calm Mind, Dragon Dance, Hone Claws, Shell
  Smash, Quiver Dance, Work Up and the new Defense Curl effect now get the
  vanilla turn-1 encourage / late-game discourage logic (score deltas
  byte-identical to vanilla's).

## Verified correct — no changes needed (highlights)

All 414 move rows/names/descriptions/animations aligned; effect dispatch
217/217 with all pointers landing on real scripts; new moves 352–414 match
modern canon data exactly; contact bitfield verified move-by-move (Raging
Fury was the sole error); priority tiers, crit list, Metronome exceptions,
Flail/Magnitude/Present tables all correct. The 16-bit move-ID mechanism was
audited at every one of its ~60 call sites (the Icy Wind site was the only
direction swap). Status-infliction ability gates were enumerated at every
site and are complete. The damage-modifier chain, Filter/Solid Rock tiers,
weather suppression, trapping, Toxic Debris, Disguise slot bits, Regenerator
HP math, and the farcall carry-return convention at every hook all check out.
Berserk Gene, Focus Band, Endure>Sturdy>Sash>Band ordering, and the held-item
consumable paths are clean.

## Known items deliberately left alone

- **Link battles**: end-of-turn abilities process player-first instead of
  following the link ordering convention (possible RNG desync in link play
  only). Lucas opted to skip — no link play.
- **HP bar pacing**: the "hp bar fix" commit animates one frame per HP point;
  a 300-HP hit takes several seconds. Intentional per the commit, but it
  scales badly with Lumi-sized HP — flagging as a tuning knob, not a bug.
- **Doc drift**: ABILITY_PORT_PLAN says "Sheer Force doesn't suppress King's
  Rock" but the code (correctly, canon) does suppress it — the doc is stale,
  not the code. `ability_testing_checklist.txt/csv` predate sessions 6–8 and
  list ~30 implemented abilities as "NOT IMPLEMENTED" — regenerate before
  using them for test planning.
- Everything on the plan doc's intentional-gaps list (X/Y Gale Wings, S/M
  Disguise, Speed Boost entry-turn proc, Electric-type paralysis, etc.) was
  treated as intended and left untouched.

## Verification performed

- Baseline build clean before changes; final build clean
  (`8a7e62e461e4ba99313c0a69f43415dd`), zero warnings.
- Adversarial verification pass over the complete diff traced every hunk in
  context: all stat-drop entry paths (move/self/ability-driven/reflected),
  the Superpower double-drop under Contrary through the deferred-message
  system, Mirror Armor nesting, contact-region guard-bit bracketing, register
  and flag liveness across every new farcall, turn-state at every redirected
  switch site, and the WRAM collision that forced the dedicated flag byte.
- Not verified: live gameplay. Quick emulator checks worth doing: a contact
  KO into Aftermath; Talonflame-line Gale Wings priority; enemy Starmie
  (Natural Cure) switching; Roar against an Intimidate team; a Contrary
  Superpower; Focus Sash text; an AI trainer with Stealth Rock + Will-O-Wisp.

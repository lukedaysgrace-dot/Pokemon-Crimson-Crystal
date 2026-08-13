# Ability-Aware AI Switching — 2026-08-13

Follow-up to `QOL_TIER0_IMPLEMENTATION_2026-08-13.md` ("AI switching is still
ability-blind"). The switch AI now factors abilities into its decisions for
the marquee trainer classes.

## Who got it

New attribute bit `SWITCH_ABILITIES` (bit 3 of the `TRNATTR_AI_ITEM_SWITCH`
word, `constants/trainer_data_constants.asm`), granted in
`data/trainers/attributes.asm` to **43 classes**: all 16 gym leaders
(Falkner–Clair, Brock–Blue), the Elite Four + Champion (Will, Koga, Bruno,
Karen, Champion, plus Agatha and Lorelei), both rival classes, all Rocket
executives (Executive M/F, Proton, Petrel, Ariana, Archer, PetrelDirector),
Cooltrainer M/F, and the unique characters (Pokémon Prof, Cal, Red, Red2,
Crystal, Crystal2, Green, Blue Cloak, Mysticalman). Everyone else keeps the
exact vanilla switch logic — verified bit-for-bit by regression tests.

## What it changes (engine/battle/ai/switch.asm)

For flagged classes only:

1. **Staying-in scoring** (`CheckPlayerMoveTypeMatchups`): a player move the
   active mon's own effective ability nullifies (Levitate vs Earthquake,
   Flash Fire vs Fire, the absorbs...) no longer counts as a reason to flee.
2. **"Can I even damage them?"** (`CheckEnemyMoveEffectiveness` + the enemy
   move matchup pass): enemy moves the *player's* ability absorbs are graded
   as useless. A leader whose only attacks feed your Volt Absorb now
   recognizes it and pivots out instead of pumping absorbed hits forever.
3. **Switch-in candidate selection** (`FindEnemyMonsImmuneToLastCounterMove`,
   `FindEnemyMonsThatResistPlayer`): bench mons whose ability blanks your
   last used move now count as immune/resistant candidates — abilities are
   read per bench mon from species + personality via `GetAbility`, so
   trainer ability slots from the new party format are respected.
4. All checks respect **Mold Breaker** (no ability credit when the attacker
   breaks the mold) and **Neutralizing Gas** (effective abilities are used
   throughout).

## Plumbing (the part worth knowing before you touch these banks)

- The **Effect Commands bank was 15 bytes from full** — the new logic could
  not fit. `engine/battle/ai/switch.asm` therefore **moved from the
  "Effect Commands" section to "Enemy Trainers"** (`main.asm`), which had
  ~8 KB free. All external entry points were already `callfar`, so only one
  dependency needed care: `CheckTypeMatchup` takes inputs in `a` AND `hl`
  (both clobbered by the farcall macro), so it gets a `CheckTypeMatchupFar::`
  entry (type in `b`) reached via the home `FarCall_de` trampoline. Effect
  Commands now has ~950 bytes of slack again.
- The ability logic itself lives in the Abilities Engine bank
  (`AISwitchAbilityAwareness`, `AI*NullifiesTypeFar`, plus the reusable
  `AbilityNullifiesType::` lookup over `NullificationAbilities`); switch.asm
  keeps thin register-shuffling wrappers.
- One bug caught and fixed during testing: the first placement of
  `CheckTypeMatchupFar` sat between `BattleCheckTypeMatchup`'s fallthrough
  and `CheckTypeMatchup`, corrupting the move type for every fallthrough
  caller (Conversion2's reroll loop hung forever). The harness's move sweep
  caught it; the entry now sits above `BattleCheckTypeMatchup` with an
  explicit `jp`.

## Verification

- Release + debug assemble clean; `make test` 230/230; `make test-all`
  **841/841** on the final code.
- Behavioral probes (run with `SWITCH_ABILITIES` temporarily on the tester's
  SCHOOLBOY shell, then reverted):
  - *Veto probe*: Raichu (Thunderbolt only) vs a Volt Absorb Lanturn — with
    the flag the AI switches to its Snorlax; without it, it stays and pumps
    absorbed Thunderbolts (vanilla).
  - *Candidate probe*: player spamming Earthquake — with the flag the AI
    brings in its bench Weezing (Levitate, not type-immune: Poison-type);
    without it, the immune-scan rejects Weezing and no switch happens.
- The tester shell has no `SWITCH_ABILITIES`, so all 230 existing YAML
  cases double as proof that unflagged classes are byte-identical vanilla.

## Files changed

| File | Change |
|---|---|
| `constants/trainer_data_constants.asm` | `SWITCH_ABILITIES(_F)` bit |
| `data/trainers/attributes.asm` | flag on the 43 elite/unique classes |
| `engine/battle/ai/switch.asm` | 6 ability hooks + wrappers + `AISwitch_CheckTypeMatchup` shim |
| `engine/battle/abilities_engine.asm` | `AbilityNullifiesType::` + 4 `AISwitch*Far` cores |
| `engine/battle/effect_commands.asm` | switch.asm include removed; `CheckTypeMatchupFar::` added |
| `main.asm` | switch.asm now included in the "Enemy Trainers" section |

## Notes / limits

- Bench-candidate ability credit covers full type nullification
  (`NullificationAbilities` pairs). Soundproof/Bulletproof move-list
  blockers and Air Balloon are not consulted for *bench* candidates (they
  are already handled for the active mon's move scoring via AI_Abilities).
- Battle Tower trainers inherit class 1 (Falkner) attributes, as they
  already did for switch styles — so tower AI is ability-aware too.
- If you later want a mid-tier class (e.g. Ace-equivalents) to get this,
  it's one `| SWITCH_ABILITIES` in `attributes.asm`.

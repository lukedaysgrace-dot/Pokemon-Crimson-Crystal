# Independent held-item review — November 1, 2026

Reviewed commit `5793acd46518da0c39812cddb3c32b3445b488d7` against its parent,
the native battle scripts, regression tests, and mechanics references.

## Verdict on the six reported bugs

All six reports identify real defects in the previous code. The fixes in
`5793acd4` address the reported cases:

| Report | Source finding |
| --- | --- |
| Power Herb | The previous `checkcharge` shortcut skipped `checkobedience` and `doturn`, including PP expenditure. Moving consumption to `charge` preserves those commands; the explicit Skull Bash raise preserves its charge effect. |
| Throat Spray | A failed secondary could set failure flags after damage had landed. Using the recorded hit distinguishes that from an unsuccessful sound move. |
| Metronome | The original counter used move identity without recording whether the preceding use succeeded. The new hit and lost-turn tracking fixes the reported resets. |
| Heavy-Duty Boots | The old early return bypassed Toxic Spikes absorption along with hazard damage. Grounded Poison types should still absorb them. |
| Safety Goggles | Effect Spore's immunity checks omitted the item. The new check uses the attacker's effective, Klutz-aware item. |
| Clear Amulet and stat-drop abilities | Miss/secondary-failure checks ran after protection, Contrary and reflection. Moving those checks earlier prevents reactions to nonexistent drops. This also corrects older shared ability behavior. |

The entry Intimidate test previously used an illegal Mew ability override.
The harness applies that override after entry, so replacing Mew with Gyarados
makes the test exercise actual entry Intimidate.

An independent run reproduced the reported **2,138 passed / 4 failed** result
for all 2,142 YAML cases. All 231 modern-item cases passed. The four failures
are `Entry item: player KLUTZ`, `player TRACE_KLUTZ`, `enemy KLUTZ`, and
`enemy TRACE_KLUTZ`. They also appear in the older local log
`.tmpbuild/mienfoo-validation/baseline-klutz.log`.

### Correction after investigating the four Klutz failures

These four failures were stale test fixtures, not a confirmed engine defect.
The earlier chat description calling them real, unfixed Klutz bugs was wrong.
Buneary's current ability slots are Scrappy, Cute Charm and Adaptability.
Requesting Klutz for it therefore installs a debug override only after entry:
the Berry was consumed with Scrappy active, and Trace correctly copied Scrappy.

Changed all four entry fixtures to Golett, whose second slot is Klutz. Added
explicit ability assertions and checks that Trace actually activated. Added
both-side controls showing the same species eats its Berry with Iron Fist,
and eats it when Neutralizing Gas suppresses Klutz. No production engine
change was needed to resolve these failures. AGENTS.md now records the entry
fixture requirement.

## Additional corrections from this review

1. **Metronome and charging:** the charging turn counts as a successful use,
   so the first release receives a 20% boost. The previous charged-move test
   incorrectly required equal damage to an unboosted control. Corrected the
   implementation and that test.
2. **Blunder Policy eligibility:** missed OHKO moves do not activate it.
   Neither do subsequent accuracy misses within Triple Kick/Triple Axel.
   Added guards, both-side OHKO/first-kick battle regressions, and 12 native
   accuracy checks covering every kick on both sides.
3. **Blunder Policy timing:** the miss message must precede activation.
   The later patch delayed it until after Jump Kick's crash. It now activates
   immediately after the miss message, before crash damage, while preserving
   the move's damage and failure state. Both-side controls verify unchanged
   crash HP loss and the actual textbox sequence.
4. **Blunder Policy and type immunity:** Dynamic Punch into Gengar could
   consume the item if its accuracy roll failed. The previous Tackle test
   did not exercise this. Added an earlier-failure guard and a final type
   immunity check, covering scripts that calculate type after accuracy.

The Spikes static audit also needed maintenance: its text search rejected
the Boots fix's `call nz, .Spikes` and matched a routine name inside a comment.
It now strips comments and accepts the conditional call while retaining the
required Spikes → faint check → later hazards ordering assertion.

Quick Powder's requested behavior for original Ditto after Transform remains
the project's custom rule. Clear Amulet still displays a message when it
blocks an actually rolled secondary drop, as acknowledged in the earlier report.

## Mechanics references

- [Pokémon Showdown item implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts): Metronome success/charge tracking, Throat Spray, Power Herb, Goggles and Clear Amulet.
- [Pokémon Showdown accuracy implementation](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts): miss message before Blunder Policy activation and the OHKO exception. Crash timing here follows this simulator reference; it was not tested on an official cartridge.
- [Pokémon Showdown move implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts): Poison absorption before the Boots exemption in Toxic Spikes.
- [Pokémon Showdown ability implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts): Effect Spore checks powder immunity.
- [Original Sword/Shield mechanics research](https://www.smogon.com/forums/threads/sword-shield-battle-mechanics-research.3655528/): Blunder Policy's OHKO exception and Throat Spray's successful-use requirement.

## Validation

- Both ROMs built with RGBDS 0.5.2, including successful symbol sorting.
- ROM0 has 99 free bytes (`$0063`) after these changes.
- All 12 native first/later-kick accuracy checks passed on the final ROM.
- Before correcting the entry fixtures, the full YAML suite had **2,154
  passed, 4 failed, 0 errors, 0 skips** across six isolated workers.
- All **247 modern-item cases passed**, including 16 added cases and the
  corrected charged-move expectation.
- Every static audit component listed in `make audit-static` passed after
  correcting the stale Spikes check. The initial aggregate command stopped
  at that check; its corrected move audit and all remaining components were
  subsequently run separately and passed.
- `git diff --check` passed.
- Corrected entry and ability-update timing suites: **74 passed, 0 failed**
  before adding the four new entry controls.
- Native item-update checks: **352 passed, 0 failures**, including 40
  item-order scenarios and 24 faint/suppression-update battles.
- After correcting the four entry fixtures and adding their controls, the
  final full YAML suite is **2,162 passed, 0 failures, 0 errors, 0 skips**
  across six isolated workers. Log: `.tmpbuild/klutz-entry-full.log`.

Final ROM SHA-256:

```text
release  728ea87522676bf4241707aceb53f020e98f8abdc7c7c76428d0b64dc90e41af
debug    328ee6bbb3bf465184683e598c5e288cf3a97dfe316c753bd4bb61a6b88aa098
```

Logs are under `.tmpbuild/` with the `codex-item-review-` prefix. The baseline
emulator cache was from a newer PyBoy, so the initial review used a separate
cache. No player save was used.

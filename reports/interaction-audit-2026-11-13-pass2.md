# Second interaction audit — November 13, 2026

This pass builds on `interaction-audit-2026-11-13.md` and preserves its fixes.
Status: complete for the bounded review below. All final checks passed.
The user requested a bounded pass with allowance left for a handoff. Usage
was checked through the account's five-hour limit tool; no reset was used.

## Five confirmed defects fixed

| Finding | Reproduction and correction |
| --- | --- |
| Magic Bounce omitted Spite | Native Spite reduced the bouncer's PP instead of reflecting. Added its effect to the reflection table, preserving native PP loss and Substitute bypass. |
| King's Shield incorrectly blocked status reflection | Taunt/Spite could reach a shielded bouncer without reflecting. The reflection gate now shares the existing King's Shield status exception; Protect still blocks these moves. |
| Stench depended on the move's unrelated secondary roll | A failed Ember burn suppressed a separately successful Stench flinch. Preserve the original secondary result while clearing it only for the independent flinch helper. |
| Throat Spray mishandled capped Special Attack | Successful sound use at +6 kept the item, including a Contrary holder that should drop to +5. Removed the cap veto and preserved move failure flags around the item boost. |
| Consecutive-use cooldown and Choice lock left no legal action | Choice-locked Giga Hammer/Doom Desire users could be trapped at the player menu or waste an enemy action. Both legal-move scans now include the cooldown and choose Struggle when necessary. Ordinary/Klutz users can choose another move; Struggle clears the cooldown for the next turn. |

The baseline is preserved in
`.tmpbuild/interaction-audit-2026-11-13-pass2/baseline/`.
Before the fixes, the reflection fixture had 7 failures among 11 cases;
the initial Stench reproduction had 2 failures among 7 cases; the initial
Spray reproduction had 4 failures among 6 cases. The native player scan had
8 failures among 59 checks, and the real menu showed both Choice/cooldown
dead ends. Each finding has focused controls and regression coverage.

## Validation and scope

- Release and debug ROMs build with RGBDS 0.5.2.
- Native selection/AI: 59 checks per ROM, zero failures.
- Native held-item behavior: 190 checks per ROM, zero failures.
- Real player Fight menu: 48 checks across 12 scenarios, zero failures.
- First- and second-pass battle regressions: 162 passed, zero failures,
  errors or skips (`regressions-final.log`).
- `make audit-static`: passed. Scoped whitespace checks passed; no graphics
  changed. ROM0 slack remains 97 bytes release / 91 bytes debug.

Fixtures `111`–`114` add 44 battle cases. Existing fixtures `107`–`110` are
rerun alongside them. Two newly written fixture assumptions were corrected:
Snore needs runtime move-ID conversion, and extended held items must be
compared through runtime records rather than their 16-bit constants. These
were test errors, not additional game defects.

Source reviews covered selection/PP restrictions, status/Substitute/reflection
scripts, ability suppression and cures, residuals, damage/contact/move-end
hooks, item consumption/history and stat-cap interactions. Existing custom
mechanics were preserved. Duplicate-slot Encore/Disable behavior was not
changed without a clear rule requiring it; the primary simulator also uses
a first matching move lookup. Legacy Ghost Curse/Substitute behavior remains.

This pass does not establish every possible state combination. The previous
32,788-case run was not repeated; validation concentrates on new outcomes,
their controls, previous audit regressions, both-ROM native routines and
the static target. Player saves were never opened.

Primary references: [move definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
[Stench](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
[Throat Spray](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts),
and [item use](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts).
Repository custom rules take precedence.

## ROM receipts

| ROM | SHA-256 |
| --- | --- |
| Release | `e5ec4558803da390f2e3b83b05ceb37346d8bdd377b61ab638d0b4b16a661df6` |
| Debug | `8136ead6fee76853f374ca721628a8efc75e360c28ac4adaf932677a88195189` |

Logs and menu captures are under
`.tmpbuild/interaction-audit-2026-11-13-pass2/`; the initial reflection and
Stench reproduction logs also live directly under `.tmpbuild/`.

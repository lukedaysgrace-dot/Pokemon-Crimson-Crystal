# Ability interaction follow-up — 2026-10-07

This follow-up covers the ability engine and its move, contact, faint,
switching, held-item, and entry hooks. It follows the earlier whole-engine
audit and the Cud Chew/Technician corrections in `80-ability-review-regressions.yaml`.
The new permanent regressions are in `81-ability-interactions-third-pass.yaml`.

## Corrections

| Area | Defect and resulting behavior |
| --- | --- |
| Pickpocket timing | Theft happened after each hit. It now waits for the completed move, so a Choice Band still affects every hit. An eligible Sheer Force move suppresses the reaction. Substitute hits do not trigger theft. |
| Move-end held items | Life Orb recoil now happens once after the completed move and Pickpocket's theft. The common move-end hook runs before U-turn/forced switching, including Parental Bond. |
| Forewarn | OHKO moves rank at 150, Counter/Mirror Coat at 120, and variable/fixed-damage moves at 80. Sonic Boom and Dragon Rage require an explicit effect check because their ROM power fields store their fixed damage. |
| Pending Trace | Trace keeps looking after encountering an untraceable ability and can copy a later traceable foe. No Ability stops the search. Suppression and the holder's HP are checked. |
| Anticipation | Hidden Power uses the foe's stored type, including the default Dark type, instead of the move table's Normal placeholder. Both battle sides are covered. |
| Defeated Sticky Hold | Sticky Hold on a fainted victim no longer blocks Thief, or Pickpocket when recoil defeated the attacker. A living holder still protects its item. |
| Thief/contact | Contact reactions occur before theft. A thief defeated by Iron Barbs cannot acquire the victim's item. The theft command still runs when its attack defeats the victim. |
| Knock Off/KO | The item-removal command still runs when Knock Off defeats the target. The existing fainted-Sticky-Hold exception is now reachable. |
| Supreme Overlord | Damage uses the faint-history snapshot taken on entry. Reviving an ally does not erase a recorded faint; a revived ally fainting again counts again. History caps at five. Ability copying and both sides are covered. |
| Rage Fist | Hit history belongs to a party member for the entire battle, through switching and revival. Baton Pass restores the incoming member's own history after its status reset and does not transfer the outgoing member's tally. |

Banked history helpers preserve the active WRAM bank and battle turn. History
is cleared at battle initialization. Move-end pending state is cleared after
use to prevent duplicate reactions after switching.

## Validation

Final validation is complete: **20,735 passed, zero failures, errors, or
skips**, across eight isolated emulator workers. No further confirmed defect
surfaced in the final source follow-up or the complete repaired-ROM pass.

Completed checks on the final debug ROM (`d34644f7985e7bfe46f195d2cfe0d12a`, MD5):

- All 52 new regression cases pass, with no errors or skips.
- Item/faint timing: 352 checks across 40 item scenarios and 24 native faint battles; no failures.
- Effect/critical probabilities: 44,032 outcomes across 172 groups; no failures.
- Link battle RNG: 16,384 synchronization checks across 32 seeds; no failures.
- Ten static audit scripts pass. The move and linked-resource audits were repeated after the last Baton Pass repair and pass.
- Release and debug builds pass. Release MD5: `b7d4b280b80374704a6f0f58fe867df5`.

The saved pre-history ROM reproduces the Rage Fist failures on switching,
enemy Baton Pass, and revival: three failures, with the three controls passing.
All six pass on the repaired ROM. The earlier saved pre-Supreme-history ROM
reproduces the loss of recorded faints after revival and repeated fainting.

Focused final-run log directory:
`.tmpbuild/battletest-d34644f7985e-1791390688244759921`.

Complete final-run log directory:
`.tmpbuild/battletest-d34644f7985e-1791390760290532814`.
Both ROM hashes were verified unchanged after the run. `git diff --check`
also passes. Changes remain uncommitted; unrelated trainer/map/graphics
work already present in the checkout was preserved.

Subsequent owner-requested cleanup removed temporary worker logs, downloaded
reference copies, saved pre-fix ROMs, diagnostic fixtures, screenshots, and
Python caches. The log paths above record where validation ran; those
temporary directories are no longer present. The reusable scripts and
regression cases remain, and the runner regenerates its cached fixtures.

Full-run command (from the repository's WSL environment):

```sh
.venv/bin/python -u tools/battletest/runner.py --jobs 8 --all-moves --all-effects --all-abilities --ability-matrix --reflection-matrix --class-matrix --textbox-matrix --swagger-matrix --outcome-matrix --item-matrix --reaction-matrix --complex-matrix --long-battles --interactions 1024
```

The final complete run contains 20,735 cases:

| Suite | Cases |
| --- | ---: |
| Permanent YAML regressions | 1,490 |
| All-move execution sweep | 421 |
| Generated effect semantics | 205 |
| Mixed interaction stress | 1,024 |
| Ability sweep | 853 |
| Ability/suppression/transfer matrix | 4,959 |
| Reflection matrix | 84 |
| Classified move matrix | 344 |
| Maximum-name textbox matrix | 763 |
| Swagger stage matrix | 117 |
| Move outcomes, held items, and incoming-hit reactions | 8,397 |
| Long battle sweep | 558 |
| Complex interactions | 1,520 |

Static inventory: 171 real abilities (172 including No Ability), 421 moves,
225 effect scripts, and 213 battle commands. Not every effect script has a
separate generated semantic case; all moves have an execution case.

There are 52 new permanent cases, with controls for damage comparisons and
opposite-side, suppression, Substitute, multi-hit, recoil, KO, switching,
revival, and ability-copying scenarios. Paused-turn WRAM fixtures model a
Revive restoring a benched member's HP; preceding faints and replacements
run through the native cartridge routines. They do not test the Revive menu.

## Reference and scope

Primary comparison sources are Pokémon Showdown's
[abilities](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
[moves](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
[items](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts),
[battle actions](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts),
and [Pokémon state](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts).

Crimson Crystal's documented custom mechanics, species typing, and existing
generation choices were preserved. This includes the current 250-power
Rage Fist cap imposed by its byte-sized power representation; current
Showdown allows 350. Forewarn's existing first-move/tie behavior and fallback
for an all-status moveset were also preserved. Neutralizing Gas exit ordering
and Conversion 2's Pressure exemption remain the project choices noted in
the previous audit.

Coverage is not every Cartesian combination of all abilities and moves.
Generated execution/invariant sweeps cover every implemented ability and
move; semantic assertions cover move effects, permanent cases, and focused
interaction matrices. A clean run means no further defect surfaced within
that coverage, not proof that every possible battle sequence is correct.

# Ability testing handoff — October 6, 2026

## Where we stopped

The fifth pass tested rare ability/item/weather/faint/replacement chains and
an eight-battle session using real battle menus and one persistent party.
The intentional Filter, older Gale Wings, and other custom balance rules
remain unchanged. This is substantial coverage, not proof that every possible
team, move order, item, and ability combination is bug-free.

The detailed earlier results are in `ability-interaction-audit-2026-10-06.md`.
The earlier four passes exercised 20,445 named battle cases, all 171 implemented
abilities, and all 421 moves, plus separate probability, visual, Tower, link-RNG,
and map allocation checks. Fifty new named cases bring cumulative coverage to
20,495. That total counts earlier runs; the entire generated suite was not
repeated after the latest fix.

## Latest fix and verification

- **Fixed:** a low-HP incoming Pokémon could retain its healing Berry until
  damage/end-of-turn processing, instead of activating it before the first move.
  `RunEntryAbilities` now checks the incoming holder's HP item after entry
  effects and Gas reactivation. Trace into Ripen or Klutz therefore takes effect
  before the item's healing/suppression check. The opponent waits for its own
  entry processing. Existing Berry Juice and Gluttony rules are preserved.
- **32 new lifecycle chains passed:** all four weather abilities, both sides,
  Explosion/Selfdestruct, Berry/Leftovers, Gas fainting, forced replacement,
  Trace copying the returning weather ability, and an Air Balloon replacement.
- **18 new pre-move entry cases passed:** exact Ripen healing, Klutz retention,
  Unnerve blocking, Gas suppression, Trace into Ripen/Gluttony/Klutz, and Berry
  Juice working through Unnerve. Tests run in both directions.
- **Eight consecutive native-menu battles passed all 179 checks:** no fixture
  reset between battles, no debug automatic moves or party restoration. Checks
  cover HP/PP/items, faint persistence, permanent ability/personality data,
  manual switching into Drizzle, text bounds and banner cleanup, eight map
  returns, healing once, and three exact Pokémon-data SRAM save/reloads.
- **All 1,254 permanent battle cases were verified on the final ROM.** The first
  regression run exposed 21 obsolete fixture assumptions. Retested files/cases
  pass: 110 cases in four affected files, four Unnerve cases, and all 44 complex
  chains. HP assertions now include entry healing; Unnerve fixtures use legal
  holders; multi-hit Berry fixtures start at 51% HP so attacks trigger consumption.
- Both ROM variants build. Static audits and `git diff --check` pass.
- **All 252 affected generated multi-hit Berry combinations passed** after
  their fixtures were moved to 51% HP. The other generated combinations were
  not repeated in this usage-limited pass.

The session stages encounters and invokes native map/healing/save routines.
It does **not** constitute a story playthrough, full save-menu/power-cycle test,
or navigation through multiple routes and buildings. Screenshots are under
`.venv/gameplay-session/`; selected battle-entry and overworld images were reviewed.

## What remains to check, in priority order

| Priority | Remaining work | What to verify |
| --- | --- | --- |
| 1 | Repeat the complete generated sweep against the final ROM | Latest entry timing can affect generated fixtures that formerly started below half HP. Permanent cases are verified; the earlier generated coverage is not a fresh complete rerun. Keep semantic expectations, and fix fixtures rather than weakening assertions. |
| 1 | HP-item updates after ability changes **during a turn** | Skill Swap, Role Play, Entrainment, Gastro Acid, Worry Seed, and Simple Beam interacting with Ripen/Klutz/Unnerve/Gas. Check the exact moment of activation before the next action, not only final turn state. The latest fix covers entry; it is not a general item-update event system. |
| 1 | A low-HP Pokémon already on the field when suppression ends | Gas/Unnerve switching out or fainting, including simultaneous KOs, a replacement with Trace, and berries on both sides. Assert item use order, correct heal amount, pending Gas cleanup, and whether a resumed ability/item affects the next attack. |
| 2 | Actual longer overworld gameplay, about 30–60 minutes | Walk between routes/buildings, fight several wild and trainer battles, enter/leave a cave, visit the Pokémon Center, use the bag, catch a Pokémon, gain levels/learn moves/evolve, deposit/withdraw a Pokémon, save through the menu, restart the emulator, and reload. Watch HP/PP/items/status, permanent abilities, sprites, text, music, and map transitions. Use a separate test save. |
| 2 | Native trainer and forced-switch UI chains | Several enemy reserves, both sides fainting, no usable reserves, shift/set options, replacement-selection cancellation, escape/capture endings, and subsequent battles. Automated chains already cover portions of this; extended normal UI flow is still useful. |
| 2 | More message sequences in normal gameplay | Long names plus repeated banners, item messages, weather, fainting, move learning/evolution, and trainer dialogue across map transitions. Earlier battle visual matrix covered all 20 frames, three speeds, and animations on/off; that does not cover every overworld message chain. |
| 3 | Complete two-player link battle | Existing checks verified synchronized link RNG in two emulators, not a real/emulated cable handshake or full battle. Check switching, ability changes, fainting, end-of-battle cleanup, and both players' displays. |
| 3 | Battle Tower frontend and rewards | Existing roster/battle wrapper tests pass. Level selection, registration, full streak/reward dialogue, exiting, and save/reload through the actual frontend remain to be checked. |
| 3 | Wider probability sampling | Exhaustive RNG-byte threshold checks pass. Hardware RNG distribution and long-run independence were not measured. |

These are remaining coverage gaps, not confirmed outstanding game bugs.
Avoid changing deliberate custom mechanics merely to match a newer generation.

## Resume commands

Run from the repository in WSL Ubuntu. RGBDS is at
`$HOME/opt/rgbds-0.5.2/bin/`; the emulator dependencies are in `.venv`.

```bash
make -j8 RGBDS=$HOME/opt/rgbds-0.5.2/bin/ debug all
make RGBDS=$HOME/opt/rgbds-0.5.2/bin/ audit-static
.venv/bin/python tools/battletest/runner.py
.venv/bin/python tools/battletest/runner.py -k 'Lifecycle chain:'
.venv/bin/python tools/battletest/runner.py -k 'Entry item:'
.venv/bin/python tools/battletest/gameplay_session_checks.py
```

`make test-session` groups the last three checks; ensure `python3` resolves to
the environment with PyBoy installed (activate `.venv` first).
`make test-complete` is the full, lengthy generated/emulator/visual suite.
Run it when there is enough time and usage available; it also includes the
new native session. `make test-complex` isolates the complex and visual checks.

## Evidence and workspace state

- Latest logs: `.venv/fifth-*.log`. Earlier failed pilot logs include session
  driver/input/sentinel problems and superseded fixture expectations; consult
  the final/retested logs rather than treating those pilots as current bugs.
- Entry checks: `fifth-entry-items-final.log`; session:
  `fifth-session-verified.log`; static audits: `fifth-static.log`.
- Regression evidence: `fifth-regression-0..3.log`, then
  `fifth-retimed-regressions.log`, `fifth-unnerve-retimed.log`, and
  `fifth-multihit-retimed.log` for corrected fixtures.
- Generated Berry evidence: `fifth-generated-berries.log` and
  `fifth-generated-berry-0..3.log` (63 passing cases per shard).
- Release SHA256: `7483a330de25cb30bbef4d633f070c9af7f5a86199c96ddbf16fcb60a2d016dd`.
- Debug SHA256: `1893b730f44ced14c96602fb79fdea7d531cb6a652f61939d40ff9dbb82d5645`.
- Work is uncommitted. Preserve the existing modified/untracked files from all
  five passes. Tests use private temporary SRAM; the user's save was not changed.

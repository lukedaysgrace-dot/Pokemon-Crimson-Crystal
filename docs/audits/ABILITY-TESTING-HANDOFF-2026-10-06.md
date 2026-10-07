# Ability testing handoff — October 6, 2026

> **Update 2026-10-07:** a second-pass code audit found and fixed 17 further
> ability bugs (Technician base power, absorb abilities through Protect/Fly,
> No Guard vs semi-invulnerability, Baton Pass switch-out abilities, copied
> abilities on Transform/Imposter, Substitute vs Sturdy/Focus Sash, AI
> targeting awareness, and data lists). See
> `ability-audit-second-pass-2026-10-07.md` and
> `tools/battletest/tests/78-ability-audit-2026-10-07.yaml`. A follow-up
> modernised Keen Eye / Mind's Eye, Sheer Force + Mortal Spin, Sap Sipper vs
> powders, Synchronize, Cud Chew and the Air Balloon message
> (`tests/79-ability-modern-followups-2026-10-07.yaml`).

## Historical state at commit bf178b7e

The sixth-pass continuation below describes current changes and verification.
The first five passes and their older ROM hashes are historical evidence.

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

## Fifth-pass fix and verification

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
| Done in pass 6 | Full final-ROM target | All 20,559 generated/permanent battle cases and every ancillary suite pass. Exact counts and logs are below. |
| Done in pass 6 | Implemented mid-turn ability changes and HP items | Skill Swap/Trace with Ripen/Klutz/Unnerve/Gas checked before the next action. Other listed ability-transfer moves are not implemented; see scope correction below. |
| Done in pass 6 | Existing low-HP holder when suppression ends | Gas/Unnerve switching and fainting, double-KO/Trace weather chains, both-item Speed/Trick Room order, exact healing, cleanup, and retail link-RNG consumption are checked below. |
| 2 | Actual longer overworld gameplay, about 30–60 minutes | Walk between routes/buildings, fight several wild and trainer battles, enter/leave a cave, visit the Pokémon Center, use the bag, catch a Pokémon, gain levels/learn moves/evolve, deposit/withdraw a Pokémon, save through the menu, restart the emulator, and reload. Watch HP/PP/items/status, permanent abilities, sprites, text, music, and map transitions. Use a separate test save. |
| 2 | Extend native trainer and forced-switch UI chains | Pass 6 covers two-mon enemy parties, both sides fainting, no reserves, Set/Shift acceptance/cancellation, and escape/capture endings. Larger parties, automatic phazing through the UI, and longer repeated trainer chains remain. |
| 2 | More message sequences in normal gameplay | Long names plus repeated banners, item messages, weather, fainting, move learning/evolution, and trainer dialogue across map transitions. Earlier battle visual matrix covered all 20 frames, three speeds, and animations on/off; that does not cover every overworld message chain. |
| 3 | Complete two-player link battle | Existing checks verified synchronized link RNG in two emulators, not a real/emulated cable handshake or full battle. Check switching, ability changes, fainting, end-of-battle cleanup, and both players' displays. |
| 3 | Battle Tower frontend and rewards | Existing roster/battle wrapper tests pass. Level selection, registration, full streak/reward dialogue, exiting, and save/reload through the actual frontend remain to be checked. |
| 3 | Wider probability sampling | Exhaustive RNG-byte threshold checks pass. Hardware RNG distribution and long-run independence were not measured. |

These are remaining coverage gaps, not confirmed outstanding game bugs.
Avoid changing deliberate custom mechanics merely to match a newer generation.

## Resume commands

Run from the repository in WSL Ubuntu. RGBDS is at
`$HOME/opt/rgbds-0.5.2/bin/`. Use `python3` with PyBoy/PyYAML/Pillow installed;
this checkout uses WSL system Python, and `.venv/` holds generated captures.

```bash
make -j8 RGBDS=$HOME/opt/rgbds-0.5.2/bin/ debug all
make RGBDS=$HOME/opt/rgbds-0.5.2/bin/ audit-static
python3 tools/battletest/runner.py
python3 tools/battletest/runner.py -k 'Lifecycle chain:'
python3 tools/battletest/runner.py -k 'Entry item:'
make BATTLE_TEST_JOBS=8 RGBDS=$HOME/opt/rgbds-0.5.2/bin/ test-complete
make RGBDS=$HOME/opt/rgbds-0.5.2/bin/ test-session
```

`make test-session` groups lifecycle/entry checks and the native session,
plus the sixth-pass item-order, trainer-menu, wild-menu, and Save/Continue checks.
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
- The first five passes were committed as `bf178b7e` (large ability audit).
  Sixth-pass changes are described below. Tests use private temporary SRAM;
  the user's save is not changed.

## Sixth pass: review corrections and handoff continuation

This section supersedes the fifth-pass workspace state and Protect claim.
The original pass results and hashes above are historical evidence.

- Protect blocks protectable status moves before Magic Bounce, with controls
  for both battle directions. Hazards, Mean Look, Roar, and Whirlwind retain
  their Protect bypass. The reflection matrix checks the corrected rule.
- Reflection is attempted only after the original action commands; later
  perspective changes while resolving self stat changes cannot trigger it.
  Obsolete per-status/stat-drop reflection handlers and hit-check shortcuts
  were removed. Damaging move commands skip the reflection far calls.
- Trace reruns only the copied entry ability. Its outer entry invocation
  performs Gas cleanup and item updates once. Skill Swap resolves both entry
  abilities, including Trace, before checking either holder's HP item.
- New action checkpoints inspect HP, items, abilities, and cleanup before
  the next native move begins. The 56 item-timing cases exercise Skill Swap,
  Trace, Ripen, Klutz, Gluttony, Unnerve, Gas, Berry, and Berry Juice.
- Those checkpoints confirmed a real bug: an existing low-HP holder waited
  until turn end to eat after Gas/Unnerve switched out. Entry, move completion,
  and faint updates now check eligible live holders in effective Speed order.
  The committed Gas-explosion marker remains active through hit-time berries.
  Empty item updates do not consume battle/link RNG values.
- Role Play, Entrainment, Gastro Acid, Worry Seed, Simple Beam, and contact
  ability-transfer mechanics are not implemented in this ROM. Their mention
  in the earlier priority list was broader than the current game's scope;
  animation artwork does not establish a usable move implementation.
- Reports now live in `docs/audits/`. `BATTLE_TEST_JOBS` can run the complete
  generated suite in isolated emulator workers while retaining every paired
  result control and its dependent cases in the same worker.

### Sixth-pass verification and evidence

- Both ROMs build; `make audit-static` and `git diff --check` pass.
- **258 focused battles pass**, including the 56 new action timing cases,
  reflection, transfers, lifecycle weather/Trace chains, and Gas-explosion timing.
- **40 item-update scenarios + 24 faint-update battles pass all 352 checks:**
  exact healing, Speed/Trick Room order, perspective restoration, retail link
  RNG, Ripen/Klutz, and suppression/item cleanup before the faint animation.
- **Six native trainer chains pass all 75 checks:** Set/Shift acceptance and
  cancellation, mandatory replacement, simultaneous KOs with delayed Trace,
  enemy reserves, no usable reserves, permanent ability data, and text bounds.
- **Three native wild endings pass all 21 checks:** escape, Arena Trap blocking
  Run, and Master Ball capture through the Bag. Capture checks species, HP/level,
  item consumption, party growth, and cleanup.
- **Native Save/fresh boot/Continue passes all 23 checks:** exact saved Pokemon
  data reloads, party HP/PP/items/permanent abilities persist, the saved map
  returns, and native walking works. Map entry changes only the expected
  roaming-map bookkeeping within the broader Pokemon-data region.
- **`make test-complete` passes:** all 20,559 generated/permanent battle cases,
  zero failures/errors/skips across eight workers; 44,032 probability outcomes;
  12 native UI scenarios/44 assertions; 120 visual scenarios/912 assertions;
  12 cove views/216 allocation checks; all 321 Tower roster builds/23,299 checks;
  eight Tower battles/104 checks; 16,384 link-RNG synchrony checks; and eight
  consecutive native battles/179 checks. Every ancillary suite has zero failures.

The new standalone scripts were added while the initial complete target was
running and are verified separately on the same ROM. Future complete/session
targets include them. Encounters/parties are staged, so longer story gameplay,
full cable battles, Tower frontend/rewards, and hardware RNG distribution
remain coverage gaps, not known bugs. The longer gameplay checklist above now
has dedicated capture, Bag, Save/reboot/Continue, and short walking coverage.

- Final logs: `.tmpbuild/ability-audit/{focused,static,complete,hp-item-update,trainer-ui,wild-ui,save-menu}.log`.
- Complete worker logs: `.tmpbuild/battletest-1a3316f34362-1791330588812600429/`.
- New captures: `.venv/{trainer-ui,wild-ui,save-menu}/`.
- Release SHA256: `f5476ee4ff8a76eb609c4286bc6afbfda04defedbc88d8fa5d5c6550122d1430`.
- Debug SHA256: `04a23c7a97e7d907a1c76555d9ac86aa3c4e94d565d32356091137111de8c254`.
- Sixth-pass changes are uncommitted; the user's cartridge save was not changed.

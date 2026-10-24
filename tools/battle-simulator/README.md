# Crimson Crystal Battle Laboratory

A balance analyzer built on **the existing real-ROM battle harness**. There is
no second implementation of Pokémon damage, abilities or move effects. An agent
can run a scenario, compare controlled build variants, search for good builds,
or run a whole-roster round robin without using the web interface.

The laboratory is separate from the ROM build system. It uses private emulator
copies and never loads or writes the player's save.

## Start here

Use the repository's existing WSL environment:

```sh
make -j4 debug
.venv/bin/python tools/battle-simulator/simulator.py doctor
.venv/bin/python tools/battle-simulator/simulator.py serve
```

Open **http://127.0.0.1:8765**. From Windows PowerShell you can also run
`tools/battle-simulator/start-lab.ps1`. Keep its terminal open while using the UI.

For a separate Python environment (Python 3.11 or 3.12 recommended):

```sh
python3 -m venv tools/battle-simulator/.venv
tools/battle-simulator/.venv/bin/python -m pip install -r tools/battle-simulator/requirements.txt
tools/battle-simulator/.venv/bin/python tools/battle-simulator/simulator.py serve
```

On native Windows, use `.venv/Scripts/python.exe` instead of `.venv/bin/python`.
Build the debug ROM using the project's existing supported toolchain first.
PyBoy is pinned to the version used by the existing harness. No npm install,
external Pokédex, hosted service, multiplayer account or Showdown server is needed.

## Agent workflow

For a thorough **no-held-items** audit, use the separate driver:

```sh
.venv/bin/python tools/battle-simulator/no_item_audit.py plan
.venv/bin/python tools/battle-simulator/no_item_audit.py all --jobs 8
```

It explicitly forbids items on either side and tests a common moveset portfolio
under every legal ability. Two distinct sets per ability advance to a separate
sixteen-opponent validation panel, with sides swapped. Each species' selected
build then enters a complete round robin against the other eligible species,
again with sides swapped. Setup/status openings consume real native turns.
The same exclusions apply: final-stage/single-stage forms only, no starter
families. This is a substantial multi-hour audit, with resumable checkpoints.

The active database is `/tmp/crimson-no-items-20261024.sqlite` in WSL;
progress and phase summaries are in `output/no-items-2026-10-24/`.
The final Markdown tier list and evidence exports go to
`reports/balance/2026-10-24-no-items/`. These are **internal development
artifacts**; do not add the laboratory, rankings, reports, or links to them to
the public website. Keep the earlier item-enabled audit as separate evidence.

For a reproducible non-starter roster search and provisional singles tier list:

```sh
.venv/bin/python tools/battle-simulator/roster_audit.py plan
.venv/bin/python tools/battle-simulator/roster_audit.py all --jobs 8
.venv/bin/python tools/battle-simulator/roster_report.py
# Challenge the initial outlier builds, update the report, and test S-tier peers.
.venv/bin/python tools/battle-simulator/refine_outliers.py
.venv/bin/python tools/battle-simulator/roster_report.py
.venv/bin/python tools/battle-simulator/elite_league.py --jobs 2
```

This tests all terminal species/forms except starter families, including all
their legal ability variants and six build styles. It screens candidates on
four common opponents and tests two distinct finalist movesets per species on
sixteen other opponents, with sides swapped. Reports, stronger/weaker build
comparisons, ability comparisons, and a searchable HTML tier list go to
`reports/balance/2026-10-23/`. These are measured 1v1 results under a heuristic
policy, not certified globally optimal builds or 6v6 viability rankings.

The dated audit's compact results are in
`reports/balance/2026-10-23/FINDINGS.md`. Its refinement pass challenges
sacrificial singles builds and records specialist opening sequences. Original
and corrective PP-exhaustion replays have separate provenance; native damage
and move effects remain in the ROM. The lab's persisted `lab-v2` transport
correctly selects native Struggle when all player PP is exhausted.

On WSL the active audit database defaults to
`/tmp/crimson-crystal-roster-20261023.sqlite`; `--db` overrides it. Keep a live
SQLite WAL database on one operating system. Do not open it concurrently from
Windows and WSL. The driver publishes a complete database snapshot under
`output/roster-2026-10-23/` after it finishes, alongside JSON progress. Matching
runs resume; changed source/ROM/lab versions require a fresh audit directory.

Run these from the repository root. Commands print machine-readable JSON;
batch progress goes to stderr. Output lives under this directory's ignored
`output/`, including SQLite, exports, replay logs and verification receipts.

```sh
# Check source/compiled-record agreement, including actual dex weights.
.venv/bin/python tools/battle-simulator/simulator.py doctor

# A specific interaction, with turn-level expected outcomes.
.venv/bin/python tools/battle-simulator/simulator.py scenario tools/battle-simulator/examples/levitate.json
.venv/bin/python tools/battle-simulator/simulator.py scenario tools/battle-simulator/examples/weights.json
.venv/bin/python tools/battle-simulator/simulator.py scenario tools/battle-simulator/examples/teams.json

# A small baseline and a controlled ability comparison.
.venv/bin/python tools/battle-simulator/simulator.py batch tools/battle-simulator/examples/starter-ranking.json --jobs 2
.venv/bin/python tools/battle-simulator/simulator.py batch tools/battle-simulator/examples/gengar-abilities.json --jobs 2

# Inspect saved results, replacing RUN_ID with the returned identifier.
.venv/bin/python tools/battle-simulator/simulator.py runs
.venv/bin/python tools/battle-simulator/simulator.py rank RUN_ID --group build
.venv/bin/python tools/battle-simulator/simulator.py export RUN_ID --format csv --out tools/battle-simulator/output/rankings.csv
.venv/bin/python tools/battle-simulator/simulator.py export RUN_ID --format json --out tools/battle-simulator/output/results.json
.venv/bin/python tools/battle-simulator/simulator.py compare-runs FIRST_RUN SECOND_RUN

# Bounded moveset/ability/item search with held-out opponents and seeds.
.venv/bin/python tools/battle-simulator/simulator.py optimize GENGAR --opponents MACHAMP SNORLAX ALAKAZAM TYRANITAR DRAGONITE BLISSEY --count 12 --repetitions 2 --jobs 2
```

Use `--db PATH` and `--rom PATH` **before** the subcommand for an alternate local
database or matching debug-ROM/symbol pair. Verification suites currently use
the default debug ROM. Failures are returned as nonzero exit codes by `scenario`
and `verify`; inspect batch status counts and records to distinguish failed
battles from successful ones.

## Scenarios

A player/enemy may be one build or an ordered list of up to six builds. Teams
fight in one continuing trainer battle, with the actual party, switching,
hazards, status and faint routines. They are not six independent duels.

```json
{
  "name": "Weight and ability interaction",
  "seed": 1729,
  "max_turns": 20,
  "player": {
    "species": "MACHAMP",
    "level": 100,
    "ability": "GUTS",
    "item": "LEFTOVERS",
    "moves": ["LOW_KICK", "EARTHQUAKE", "BULLET_PUNCH", "BULK_UP"]
  },
  "enemy": {
    "species": "SNORLAX",
    "ability": "IMMUNITY",
    "moves": ["DEFENSE_CURL", "BODY_SLAM", "REST", "CRUNCH"]
  },
  "policies": ["tactical", "tactical"],
  "scripts": {"player": [1, 4], "enemy": [1]},
  "assertions": [
    {"turn": 1, "path": "actions.0.damage_attempts.0.base_power", "op": "eq", "value": 120}
  ]
}
```

Scripts select moves by **slot 1–4**. A player action such as `"switch:6"`
uses the normal switch routine. Fainted or already-active targets are rejected;
native trapping can block the request. Actions after the script ends use the
selected policy. Enemy move scripts are supported; enemy voluntary switches use
the native trainer AI rather than a new switch implementation.

`weather` accepts `none`, `rain`, `sun`, `sandstorm` or `hail`; omission preserves
entry-ability weather. Builds also accept `dvs` (0–65535), `happiness` (0–255),
and the game's selectable `hidden_power_type`. Defaults are level 100, maximum
DVs, maximum happiness, zero stat experience, base move PP and no held item.
There are no invented natures or EV spreads. Optional `hp` (percentage),
`status_byte`, `stages` and `substatus` allow scenario setup; ranked build pools
reject these injected starting states. The initial checkpoint records the ROM's
derived stats and actual entry effects.

Assertions use `turn`, a dot-separated `path`, `op` (`eq`, `ne`, `lt`, `le`, `gt`,
`ge`, `contains`) and `value`. An assertion without `turn` inspects the final
result. Missing checkpoints fail explicitly. These structured checks never
evaluate code. An action log reports **calculated damage attempts**, not a
promise that the target lost that much HP; Protect, substitutes, immunities,
multi-hit effects and remaining HP can change the amount actually lost.

## Experiments and comparisons

A round robin config accepts `species: ["GENGAR", "MACHAMP", ...]`, or
`species: "fully-evolved"` for every terminal evolution in the current source.
These generate starting builds, not optimized builds. Supply `builds` for exact
builds or teams. All ranked builds must share combat level and team size.

`repetitions` counts **seed pairs per matchup**, so N builds require
`N * (N - 1) * repetitions` battles. Every matchup runs in both player/enemy
orientations under the same seed. `--plan-only` creates the jobs without running
them, so large plans can be inspected before spending CPU time.

For a controlled comparison use `mode: "cross-pool"` and `subject_count`.
The first `subject_count` builds are alternatives; the remaining builds are
opponents. Every alternative faces the same opponents, seeds and orientations.
Change just the ability, item or moveset to isolate that choice. The Gengar
example demonstrates this. Use `rank RUN_ID --group build` to keep variants
separate; grouping by species deliberately averages tested variants.

The optimizer proposes a bounded mixture of offensive, coverage, setup and
recovery builds across ability/item choices. It selects finalists using training
opponents, then evaluates those finalists on **disjoint opponents and fresh
seeds**. It reports the best observed candidates and uncertainty, not a proof
of global optimality. Use more opponents, seeds and multiple policy experiments
before deciding to rebalance the game. Full team composition optimization and
learned self-play are not implemented.

## Rankings

Overall score is `(wins + 0.5 * draws) / resolved battles`. Errors, assertion
failures, turn limits and pending work have separate counts and never become
wins/losses. A turn limit is unresolved, not a draw. Reports separate 1v1,
6v6 and other team sizes. Team rows identify the entire ordered team.

95% score bounds use Hoeffding's bound on bounded seed-pair mean scores;
side-swapped battles count as **one** sampling block. Bounds require two or more
blocks and assume independently sampled seed/opponent blocks. They are
deliberately wide for small samples, including a clean win streak. They describe
the tested experiment, not an unknown universal metagame.

`offense_per_turn` is the net fraction of the opposing initial team HP removed
per turn. `remaining_hp_fraction` is surviving normalized team HP.
`mean_winning_turns` describes winning tempo. Healing and sacrifices affect
these diagnostics; they are not independently verified offensive/defensive
tier systems. Base stat totals never determine overall score.

Tactical policy values typing, damage potential, priority, setup, status and
recovery. Aggressive and random policies provide alternative baselines.
**Rollout** evaluates candidate moves through two native ROM turns with an
independent sampled RNG state, then restores the real battle before acting;
it does not peek at the battle's actual future seed. Native enemy policy uses
the game's trainer AI. Heuristic policies remain fallible and are not optimal
adversarial play. In teams the enemy's voluntary switching and both sides'
forced replacement selection use the game's existing AI/debug selection paths.
Player voluntary switching is scriptable; the heuristic move policies do not
plan team switches. Side swaps reduce role bias, but do not remove policy bias.

## Pause, refresh and reproduce

```sh
.venv/bin/python tools/battle-simulator/simulator.py pause RUN_ID
.venv/bin/python tools/battle-simulator/simulator.py resume RUN_ID --jobs 4
.venv/bin/python tools/battle-simulator/simulator.py resume RUN_ID --retry-errors
```

Pause stops scheduling and lets in-flight battles finish. A committed result is
not rerun. An interrupted uncommitted battle is replayed from its deterministic
initial seed. Execution uses isolated emulator processes and bounds queued work
to the worker count. Full turn logs can consume substantial disk space for
million-battle plans; this release has no compressed/summary-only storage mode.

Data is re-extracted on each CLI invocation. The UI's refresh action re-extracts
the source and checks the compiled ROM. Rebuild with `make debug` after changing
the game. The checker compares all compiled species stats/types/ability slots,
move records and dex weight words and rejects newer assembly sources. Each run
also pins content hashes of source, harness, laboratory, ROM and symbols, plus
the Git commit when available. Changed versions require a new run; old results
remain inspectable. Data refresh does not edit any ROM source or invoke its build.

Move legality covers level-up moves up to the battle level, inherited
pre-evolution access, TM/HM and elemental tutors, utility tutors, Blackthorn's
egg and technical tutors, and donor-supported Sketch. Unproven event-only move
routes are conservatively excluded. Species are selectable at a standardized
combat level; this does not prove a particular wild encounter/evolution can be
obtained at that exact level. Below level 100, native team battles may award
experience between knockouts; this is recorded in checkpoints rather than
silently replacing the game's behavior.

## Verification and bug investigation

```sh
.venv/bin/python -W ignore::ResourceWarning -m unittest discover -s tools/battle-simulator/tests -v
.venv/bin/python tools/battle-simulator/tests/native_checks.py
.venv/bin/python tools/battle-simulator/tests/experiments_checks.py
.venv/bin/python tools/battle-simulator/tests/http_checks.py
.venv/bin/python tools/battle-simulator/simulator.py verify --suite smoke
.venv/bin/python tools/battle-simulator/simulator.py verify --suite weight
.venv/bin/python tools/battle-simulator/simulator.py verify --suite deep
```

The last three reuse existing semantic regression suites and save full receipts
with source/ROM hashes. Weight verification includes all-species native weight
and ratio/threshold checks, including Transform, Minimize and both battle sides.
Deep verification adds every move/effect/ability and mixed interaction cases;
it is substantially longer and is not automatically claimed to have passed.

Every scenario has a reproducible ID, seed, builds, metadata, actions and turn
observations. Errors retain native control-state diagnostics. HP invariants and
explicit assertions flag suspicious outcomes. To investigate a possible bug,
reduce the opponent pool to a reproducible scenario, add a paired control and
an expected-outcome assertion, then run the relevant existing harness cases.
**Executing the ROM reproduces bugs too; it is not itself proof of correctness.**

See [COMPATIBILITY.md](COMPATIBILITY.md) for current verification boundaries and
[IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) for the architecture decision.

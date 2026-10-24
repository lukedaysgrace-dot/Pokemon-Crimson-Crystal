# No-item roster audit — paused

Paused at Luke's request. **108,262 of 148,562 ranked battles are saved;
40,300 remain.** Screening and validation are complete. See
[RESUME.md](RESUME.md) for the complete handoff, test history, backup locations,
pinned versions and exact continuation steps. `pause-checkpoint.json` is the
authoritative stop receipt.

This is an internal development audit, separate from the public website and
the earlier item-enabled results. No tier list is final until all phases finish.

- 231 eligible final-stage/single-stage species and forms; starter families excluded.
- 664 legal species/ability combinations, all retained through validation.
- 6,621 build/strategy candidates, using shared moveset portfolios across abilities.
- Both players explicitly hold `NO_ITEM`; fresh native HP/status and no injected boosts.
- Screening: eight opponents, balanced player/enemy positions.
- Validation: two distinct movesets per ability where possible, sixteen different
  opponents, both orientations (32 games per candidate).
- Final league: one build per species selected before the league; every pair
  plays with sides swapped (53,130 battles; 460 games per species).
- All mechanics execute in the compiled game, including the revised weight moves.

The driver is `tools/battle-simulator/no_item_audit.py`. Its output directory
contains `plan.json`, `source.json`, `progress.json`, candidates and completed
phase summaries. The live SQLite database is in WSL at
`/tmp/crimson-no-items-20261024.sqlite`; do not open that live database from
Windows. The WSL log is `/tmp/crimson-no-items-all.log`.

The driver resumes matching runs after interruption:

```sh
.venv/bin/python tools/battle-simulator/no_item_resume.py all --jobs 8
```

The preliminary pilot and discarded drafts are separate databases, excluded
from ranked results. The fixed mirror schedule has a regression test. The
final policy accounts for empty-hand Acrobatics, No Guard, weather accuracy,
Sharpness, Technician's variable-power thresholds and awake Sleep Talk.
Thirty-one unit tests, ten native integration scenarios and 136 controlled
native mechanics probes passed before this run. Mechanics probes include
inert held-item controls, which are never included in ranked games.

The completed tier list will be `TIER-LIST.md` in this directory, with CSV/JSON
build comparisons, per-ability results and exact source/ROM receipts.

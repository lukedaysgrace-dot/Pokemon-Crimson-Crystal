# Audit completed October 27, 2026

All pending battles have finished. See [TIER-LIST.md](TIER-LIST.md), [FINDINGS.md](FINDINGS.md), and `completion-verification.json`. The instructions below are the historical pause handoff; do not launch another audit from them.

# Resume the no-item battle audit

Paused at Luke's request on October 24, 2026, at 21:23 UTC (4:23 p.m. Central).
Continue this audit when Luke asks. Do not restart completed testing or publish
an incomplete tier list. This is an internal development tool; keep it off the
public website.

## Exact checkpoint

| Phase | Completed | Planned | Status |
|---|---:|---:|---|
| Shared moveset screening | 52,968 | 52,968 | Complete |
| All-ability finalist validation | 42,464 | 42,464 | Complete |
| Full-roster league | 12,830 | 53,130 | Paused |
| Total ranked native battles | **108,262** | **148,562** | **40,300 remaining** |

The authoritative stop receipt is `pause-checkpoint.json`, including every run
ID and its saved/pending counts. SQLite `quick_check` returned `ok`; the WAL was
checkpointed and truncated successfully after all audit processes stopped.
At the recent rate, the remaining battles should take roughly two to three
hours, followed by report generation and verification. This is an estimate.

The complete saved battle records include both builds, scenario seeds, requested
actions, native turn snapshots, results and version metadata. Pending battles
retain their deterministic scenarios. Only unfinished work is scheduled on resume.

## Files and portable backup

Workspace: `C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal`.
WSL workspace: `/mnt/c/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal`.

- WSL database: `/tmp/crimson-no-items-20261024.sqlite`.
- Working output: `tools/battle-simulator/output/no-items-2026-10-24/`.
- Durable portable backup: `paused-checkpoint.zip` inside that output folder.
  It contains the closed database, completed phase data, candidates, plan,
  provenance, reports, test evidence, logs, source snapshot, debug ROM/symbols,
  and scripts needed to continue. `checkpoint-archive.json` records its SHA256,
  entry count, database SHA256 and successful CRC verification.
- Human-readable evidence and this document:
  `reports/balance/2026-10-24-no-items/`.
- Original audit log: `/tmp/crimson-no-items-all.log`.
- Pipeline logs: `/tmp/crimson-no-items-pipeline.log` and
  `/tmp/crimson-no-items-resume-pipeline.log`.
- The ZIP also retains these logs so they survive loss of `/tmp`.

The output folder is ignored by Git but remains a local project folder. Do not
delete it, clean ignored files, or rely on Git alone as the database backup.
Do not open a live WSL SQLite database from Windows: a previous, separate audit
encountered cross-OS WAL corruption. Query it from WSL. JSON reports are safe to
read from Windows; progress-file readers should allow delete sharing.

## Resume procedure

1. Inspect this document, `pause-checkpoint.json`, `checkpoint-archive.json`, and
   `source.json`. Confirm there is no existing audit/worker process before
   launching anything. The old PIDs are stopped and must not be reused blindly.
2. Use the existing WSL `.venv` (Python 3.12.3, PyBoy 2.7.0). Do not run native
   tests under Windows Python. Keep this audit's source, policy, data extraction,
   driver, ROM, symbols and Git commit unchanged. The audit rejects provenance
   mismatches. Do not reset unrelated later edits to force a match; inspect the
   archived source and resolve any mismatch explicitly.
3. The WSL database is already usable. If it is missing after shutdown, restore
   only the database from the verified ZIP while no audit is running:

   ```sh
   .venv/bin/python - <<'PY'
   from pathlib import Path
   import hashlib, json, shutil, zipfile
   out = Path('tools/battle-simulator/output/no-items-2026-10-24')
   receipt = json.loads((out/'checkpoint-archive.json').read_text())
   archive = out/'paused-checkpoint.zip'
   h = hashlib.sha256()
   with archive.open('rb') as f:
       for block in iter(lambda: f.read(1024*1024), b''):
           h.update(block)
   assert h.hexdigest() == receipt['archive_sha256']
   database = Path('/tmp/crimson-no-items-20261024.sqlite')
   assert not database.exists(), 'Inspect the existing database before replacing it'
   temporary = database.with_suffix('.restore')
   with zipfile.ZipFile(archive) as z, z.open('database/crimson-no-items-20261024.sqlite') as source, temporary.open('wb') as target:
       shutil.copyfileobj(source, target)
   h = hashlib.sha256()
   with temporary.open('rb') as f:
       for block in iter(lambda: f.read(1024*1024), b''):
           h.update(block)
   assert h.hexdigest() == receipt['database_sha256']
   temporary.replace(database)
   PY
   ```

4. From the WSL workspace, run exactly one pipeline:

   ```sh
   .venv/bin/python tools/battle-simulator/no_item_resume.py all --jobs 8 >> /tmp/crimson-no-items-all.log 2>&1 &&
   .venv/bin/python tools/battle-simulator/no_item_findings.py > /tmp/crimson-no-items-findings.log 2>&1 &&
   gzip -c /tmp/crimson-no-items-20261024.sqlite > tools/battle-simulator/output/no-items-2026-10-24/battles.sqlite.gz
   ```

   `no_item_resume.py` wraps the frozen driver with a bounded retry for transient
   Windows rename locks. It does not change policies, fixtures, hashes or results.
   Screening and validation JSON are reused, and completed league battles are
   skipped. Do not launch another copy if startup or provenance extraction is slow.
5. Monitor `progress.json` and the WSL log. League run ID:
   `da9956e2bfa0bffd1db5`. Stop and investigate actual errors instead of counting
   them as losses. Keep progress updates concise. Once all battles finish,
   `no_item_findings.py` automatically checks every saved action against the
   final policy before publishing the findings.

No need to rerun the already-passed preflight suites merely to resume an unchanged
run. Recheck versions, database health, saved coverage, and final outputs.

## Coverage and battle conditions

- 231 final-stage/single-stage species/forms, including legendaries. Starter
  families, basic stages and middle evolutions are excluded using this game's
  evolution graph. Normal Raichu evolves to Gorochu here and is excluded.
- All 664 legal species/ability combinations are represented.
- 6,621 shared build/strategy candidates; 272 distinct proposed moves.
- Identical moveset portfolios are tested under every legal ability per species.
- Screening: eight opponents, eight games per candidate, four orientations each.
  Opponents: Tyranitar, Gengar, Snorlax, Azumarill, Scizor, Alakazam, Quagsire,
  Dragonite.
- Validation: 1,327 finalists, 32 games each against 16 disjoint opponents in
  both orientations. Each ability gets two distinct movesets, except Ditto /
  Imposter, whose legal moveset permits only one. Opponents: Mewtwo, Articuno,
  Machamp, Skarmory, Alolan Ninetales, Blissey, Tentacruel, Lanturn, Parasect,
  Magcargo, Ledian, Delibird, Unown, Ceruledge, Heracross, Dragapult.
- Screening and validation coverage receipts passed: all species/abilities,
  all `NO_ITEM`, correct game counts, zero errors and zero unresolved results.
- Final league: one best validated build per species selected BEFORE the league;
  every unordered species pair plays twice with sides swapped. Each species
  receives 460 games against 230 opponents. Use only this league for tier scores.
- Enhanced rules, level 100, perfect DVs (65535), zero stat experience, base PP,
  fresh HP/status, no injected boosts or pre-damage, natural native entry/weather.
- Both sides explicitly use `NO_ITEM`. The native FALKNER trainer profile has no
  bag items; the policy requests moves only. Inert held-Potion mechanics controls
  are separate evidence and are NEVER included in ranked battles.
- Coverage includes physical/special/mixed attacks, recovery, status, priority,
  weight moves, recoil-free options, setup, RestTalk, Counter/Mirror Coat,
  ability-aware move families, and seeded alternatives. Setup takes real turns.
- Ceruledge: 11 identical portfolios per ability for Flash Fire, Weak Armor and
  Sharpness, then two distinct validation sets per ability. Do not assume an
  ability is universally best from one selected build.

All battle damage, abilities, effects and the revised weight calculations execute
inside the compiled ROM through PyBoy. The policy selects actions; it does not
replace native mechanics. This is automated 1v1 evidence, not perfect play or a
6v6 team tier list. Executing the ROM can reproduce bugs; it does not prove their
absence. Unresolved turn limits must remain visible and do not become free wins.

Tier thresholds: S 87.5%, A 75%, B 62.5%, C 50%, D 37.5%, E 25%, F below 25%.
Equal scores share rank; alphabetical tie order has no strength meaning.

## Tests and code work already completed

Final frozen preflight, before ranked testing:

- **31 unit tests passed** (`unit-checks.log`). Includes mirror schedule, no-item
  guards, shared ability portfolios and meaningful policy regressions.
- **10 native integration scenarios passed** (`native-checks.log`). Includes
  deterministic replay, Levitate, native Low Kick against Snorlax (120 power),
  PP exhaustion and Struggle on both sides, all player moves at zero PP,
  native rollout, six-member parties and switching to party slot six. Some
  bounded integration scenarios intentionally end at a turn limit; these are
  successful assertions, separate from ranked results.
- **136 extra native mechanics probes passed** (`sharpness-checks.log`):
  72 Ceruledge probes (12 seeds × two sides × three abilities) establish native
  Sharpness Bitter Blade damage around 1.5× (1.49718–1.50588); Flash Fire and Weak
  Armor controls match. Another 64 probes cover itemless Acrobatics (16),
  No Guard / Dynamic Punch (24), and Snow Warning / Blizzard (24).
  Raw records are `sharpness-native-checks.json` and `native-choice-checks.json`.
- **Doctor passed** (`doctor.json`): all 498 compiled species, all 442 moves and
  dex weights match source, with no newer unbuilt assembly.
- **2,832 saved battles / 11,336 action requests** already passed the initial
  decision consistency checkpoint, with no metadata or policy mismatches
  (`decision-consistency-checkpoint.json`). A complete paused-data check and
  complete final check are separately named receipts; do not call a partial
  receipt a full-run check.
- Earlier work on the same unchanged ROM passed 3,459 semantic regressions and
  5,698 weight checks. Those are prior-task evidence, not new suites rerun today.

Code changes retained in the workspace and source archive:

- `lab/data.py`: source-derived punch/slice/pulse/bite/sound/etc. traits, contact,
  Sheer Force eligibility, weather IDs and authoritative move legality.
- `lab/policy.py`: empty-hand Acrobatics, Sharpness and other native ability
  scoring hints; No Guard, Compound Eyes, Hustle and weather accuracy; native
  Technician thresholds for variable-power moves; happiness moves; Body Press /
  Foul Play / Psystrike targeting; recoil, Counter, sleep and status awareness.
- `lab/engine.py`: exposes native weather/happiness to action selection; the
  existing lab-v2 native PP exhaustion/Struggle handling remains in place.
- `no_item_audit.py`: deterministic three-phase scheduling, shared portfolios,
  per-ability finalists, resumable WSL database and internal report publishing.
- `no_item_checks.py`: controlled native mechanics evidence.
- `no_item_consistency.py`: reproducible action/metadata audit.
- `no_item_findings.py`: final findings, matchup matrix, moveset comparisons,
  Ceruledge evidence and full consistency check before final publication.
- `no_item_resume.py`: retry transient filesystem rename locks without modifying
  frozen battle code or driver.
- Regression tests and README internal-only workflow documentation are retained.

## Pinned versions: do not change during this run

| Component | SHA256 / version |
|---|---|
| ROM | `7abd0bd922776ec7aadd8706d1c378bf22583005b914b5b247cacceedcb66499` |
| Symbols | `e24e6697c943c319e5217bc0d968b55295ec4885f8e0905c66dffc3fe4ad587a` |
| Source | `b110f1eea98ae3b43431e470d77ef947678b8bc78b604cd38e7ab5e0df147050` |
| Extracted data | `9f619806b1c0edd4065a949ed2bb6e14667534f503bf795884e15145e9e624f8` |
| Laboratory | `5b218e566f01e57eb1baed9d03293439afd2362280776d717b39a0b0b1d7c5e7` |
| Audit driver | `6b6c191c0a1b1fc5e610fe689e48b837bdf0fad016b994bf686fb06e70d73823` |
| Git commit | `fa2da81183bb9f60176c9b4135a3777df5580697` |
| Runtime | WSL Linux, Python 3.12.3, PyBoy 2.7.0, lab-v2 transport |
| Audit seed | 20261024 |

`source.json` includes the full source file hash manifest, including uncommitted
changes. Commit identity alone is insufficient. Preserve the existing ROM and
symbols; do not rebuild while completing this pinned audit.

## Resolved interruptions and excluded data

- Earlier pilot and draft databases are separate and excluded from the final
  database. The mirror/subject-side schedule fix and the final policy changes
  were made before this frozen run. Archived drafts in the output directory
  must not be merged into final results.
- A duplicate process running the same frozen scenarios was stopped earlier.
  Initial saved-action consistency passed; final complete consistency must also
  pass. Do not launch duplicate pipelines again.
- A transient Windows file lock interrupted atomic replacement of
  `progress.json`. Committed SQLite results were retained. The wrapper retries
  the rename, and progress readers now permit delete sharing. No battle policy
  or frozen driver change was needed.
- The current pause is intentional. All main/pipeline/worker processes were
  stopped, SQLite recovered and checked, and the WAL checkpointed before backup.

## Work remaining before reporting completion

1. Finish 40,300 pending league battles using the unchanged run.
2. Verify 148,562 unique ranked results; 53,130 league games; 231 ranked species;
   460 games/species; 664 per-ability winners; 1,327 validated builds; 6,621
   screened builds. Audit `NO_ITEM` in initial builds AND native snapshots.
3. Require the full saved-action consistency check, matching source/data/lab/ROM
   hashes, and inspect any flagged results. Do not mislabel limits as game bugs.
4. Review `TIER-LIST.md`, `FINDINGS.md`, CSV/JSON rankings, matchup matrix,
   stronger/weaker moveset comparisons and all Ceruledge abilities. Confirm the
   final closed database archive is valid. Mark `RUNNING.md` completed only then.
5. Give Luke the actual no-item tier list and strongest/weakest findings with
   local report links, clearly described as measured automated 1v1 results.
   Keep all analysis off the public website. No commit, push or PR is requested.

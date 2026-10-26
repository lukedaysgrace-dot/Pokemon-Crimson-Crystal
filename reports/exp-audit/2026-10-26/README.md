# Crimson Crystal EXP audit

Read [EXP_BALANCE_REPORT.md](EXP_BALANCE_REPORT.md) first. This is a source inventory and reproducible scenario audit; the globally minimal mandatory path and every movement/puzzle shortcut are **not** formally proven. All assumptions and remaining limits are in the report. No game files, ROMs, saves or repository settings were changed.

**Lighthouse correction:** the original route assignment overlooked Jasmine blocking entry until the Cianwood medicine trip. Default progression now reserves all Lighthouse battles for after Chuck and before Jasmine. Returning with medicine before Chuck is a separate permitted alternative. Four-member Jasmine readiness is substantially healthier than originally reported; the recommendation to relocate Lighthouse trainers has been withdrawn. See [LIGHTHOUSE_CORRECTION.md](LIGHTHOUSE_CORRECTION.md).

## Main deliverables

| File | Purpose |
|---|---|
| `EXP_BALANCE_REPORT.md` | Complete narrative, mechanics, all primary milestones, five playstyle tables, answers to all fifteen questions |
| `PRIORITY_FIXES.md` | Ranked recommendations, measured effects and rejected/partial fixes |
| `BOSS_CATALOG.md`, `boss_teams.csv` | Exact selected teams, levels, items, abilities, custom stats, moves and script evidence |
| `ZONE_REVIEW.md`, `zone_exp_database.csv` | Every map, including zero-EXP and retired maps; lifetime stock and availability phase splits |
| `trainer_exp_database.csv` | All 1,822 Pokémon in all 595 trainer definitions, including alternates, repeatable and unused records |
| `campaign_events.csv`, `reference_coverage.csv` | Map-linked encounter identities and disposition of all 585 source references |
| `milestone_results.csv` | Combined requested results table; different playstyles remain separate rows |
| `team_progression.csv`, `individual_progression.csv` | Every modeled checkpoint and every member's actual EXP/level, two cohorts and eight participation policies |
| `progression_*.csv` | One convenience file per playstyle, with all six planned team sizes |
| `zone_progression.csv`, `battle_ledger.csv` | Within-segment changes and auditable one-time battle consumption |
| `grinding_estimates.csv` | Independent current-checkpoint KO estimates, both balanced training and the selected participation policy |
| `gym_order_progression.csv`, `gym_order_summary.csv` | 432 corridor-model schedules, four/six members and two distribution policies |
| `travel_exploration_sensitivity.csv`, `sensitivity_bands.csv` | 0/2/5 ordinary KOs per new map, twenty declared exploration seeds |
| `replacement_and_route_scenarios.csv`, `replacement_individual.csv` | Low/current-area replacements, early Cape/Eusine, direct Silver and Green-first alternatives |
| `growth_curve_sensitivity.csv` | Four active growth curves, separately controlled |
| `hypotheses.json`, `hypothetical_changes.csv` | Six overlays tested without changing the game |
| `hypothetical_grinding.csv` | Original/trial catch-up KO comparisons at targeted checkpoints, all six sizes and two participation policies |
| `01_*.png` through `08_*.png` and matching `.svg` | Eight visual charts, raster previews plus standalone vector exports |
| `simulator.py` | Interactive and command-line local simulator |

`wild_encounters.csv` records all grass/Surf times, probabilities, source lines and runtime Surf level ranges. `fishing_encounters.csv` includes exact byte-threshold probabilities, map groups and scaling rules. `tree_rock_encounters.csv`, `contest_encounters.csv`, `scripted_wild_instances.csv`, `static_encounters.csv`, `gift_pokemon.csv`, and `npc_trades.csv` retain the other acquisition/encounter sources. `repeatable_exp.csv` is deliberately separate from the unique battle economy.

`species.csv`, `evolutions_learnsets.csv`, `evolution_growth_continuity.csv` and `move_data.csv` contain this hack's data. `map_inventory.csv`, `map_progression.csv`, `map_edges.csv`, `access_conditions.csv`, `source_manifest.csv`, `coverage.json`, `catalog_coverage.json`, and `native_verification.json` provide provenance and coverage. The collision text/probe files are targeted diagnostics, **not** a full reachability engine. `extracted.json` is the simulator's normalized data snapshot.

## Reproduce

Use Python 3.10+ from this directory. Core extraction, simulation and report generation use the standard library. Chart generation additionally uses **ReportLab and Pillow**. Native checks use **WSL Python with PyBoy**, already available on the audit host, and the existing repository ROM/symbols; they never write a save.

```powershell
python -B extract.py
python -B catalog_details.py
python -B test_audit.py
python -B run_audit.py
python -B compare_grinding.py
python -B charts.py
python -B build_report.py
python -B verify_outputs.py
```

Run extraction again after changing trainer parties, level caps, growth data or encounters. Party and cap calculations then use the newly extracted data. Update the explicit cohort/route assumptions in `model.py` if recruitment or gates change. Fixed snapshot assertions in the regression suite intentionally flag intended cap/coverage changes for review; they are not a reason to retain obsolete values.

Native reproduction on this host:

```powershell
wsl -e python3 -B /mnt/c/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/reports/exp-audit/2026-10-26/native_verify.py
wsl -e python3 -B /mnt/c/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/tools/test_league_progression.py
```

The native routine checks use an in-memory cartridge with presentation disabled. They verify formulas, grants and event behavior, not a complete playable campaign. Do not replace the user's ROM/save to run this audit.

## Interactive simulator

```powershell
python -B simulator.py --interactive
python -B simulator.py --team-size 6 --playstyle typical --sharing equal_rotation --wild-kos 2
python -B simulator.py --team-size 4 --playstyle thorough --sharing exp_share --early-cape
python -B simulator.py --team-size 6 --playstyle typical --skip-e4-rematch
```

For a custom roster, pass `--team-json my_team.json --team-size N`. Each object has `species`, `level`, and `join_map`; optional `growth`, `traded`, and `lucky` override the corresponding assumptions. Species use repository constants, maps use script filenames without `.asm`. Growth overrides are for controlled experiments; ordinary species automatically use their extracted rate. The tool rejects Erratic/Fluctuating and other unsupported names. An EXP Share holder cannot simultaneously receive a Lucky Egg item bonus.

```json
[
  {"species":"CYNDAQUIL","level":5,"join_map":"CherrygroveCity"},
  {"species":"RATTATA","level":4,"join_map":"Route29"},
  {"species":"MAREEP","level":4,"join_map":"Route30"},
  {"species":"ZUBAT","level":10,"join_map":"UnionCave1F"}
]
```

`--order` accepts all sixteen case-sensitive gym names separated by commas. For example:

```powershell
python -B simulator.py --order 'Falkner,Bugsy,Whitney,Morty,Jasmine,Chuck,Pryce,Clair,Misty,Brock,Surge,Sabrina,Erika,Janine,Blaine,Blue'
```

Order validation enforces the **declared corridor graph**, not every route in the entire engine. Blue/Blaine remain last under the explicit badge gates. Shared approach trainers stay on their first travel leg, and a completed event is never awarded twice. The original game is not run or modified by the simulator.

`--proposal-json` takes one overlay object (not the whole named dictionary in `hypotheses.json`). Supported fields are `caps` keyed by badge-count string, `party_level_delta` keyed by party key, `trainer_level_delta` keyed by map for non-primary trainers, and `event_stage_overrides` keyed by event ID. Changes are applied in memory. Rerun the complete matrix before treating an overlay as a proposed implementation.

## Interpretation rules

- Results are **pre-boss**. The boss's own EXP is awarded afterwards.
- Team size means eventual size. New Pokémon join at their stated map/level; they bring their own EXP but catching grants no battle EXP.
- Party logs label the recruited species line; EXP is unchanged by evolution in this snapshot. The files do not assert an unevolved level-70 starter was used in combat.
- All five playstyles, eight participation policies, and both cohorts are distinct assumptions. The efficient playstyle tests lowest-level rotation; it is not a proof of globally optimal trainer deferral or rotation.
- `hard_cap` is the actual badge cap, 100 after badge 16. `target_level` is the boss ace after that point; these columns must not be conflated.
- Solo-equivalent trainer EXP is not actual party EXP. Splitting rounds the **base yield first**. EXP Share has two separate half-yield passes.
- `segment_*` starts after the preceding primary battle; that battle's reward is already reflected in the next starting state. A boss-only interval can therefore have zero fresh route EXP.
- Cap waste includes clipping and an unclaimable pass once, not one full loss per capped participant. A capped participant is excluded from the divisor when another can gain.
- The map-wide trainer total is lifetime stock. Read its `trainer_exp_by_visit_stage` and individual trainer requirements before assigning it to a gym.
- The completionist maximum is conditional on the itinerary and reviewed subzone model. It is not a mathematical maximum over all reachable script states.
- Ordinary trainers within a map generally follow source order, not an exact walking path. Reviewed story bosses and the two Radio Tower visits enforce their event sequence; residual within-map timing can affect cap waste.
- Grinding rows are independent counterfactuals from the carried, unground state. **Never sum their KO counts.** Being a little below a boss does not prove grinding is necessary to win.
- Exact travel distance, time-of-day itinerary, encounter avoidance, catch search, fainting and full combat outcomes were not measured. The report makes those limitations explicit.

The conclusions and proposed changes are research results for review, not gameplay edits or a claim of a fully validated balance patch.

`validation.json` records the final integrity checks, `unit_checks.log` contains the regression results, and `artifact_manifest.csv` fingerprints the deliverable files. The ZIP is a portable copy of this directory; retain its path under `reports/exp-audit/` inside the repository to rerun source-dependent tools.

After regenerating the data/reports, `python -B package_audit.py` reruns final verification and creates `crimson-crystal-exp-audit-2026-10-26.zip`. Extract its dated directory into the repository's `reports/exp-audit/` folder. No ROM or save is included.

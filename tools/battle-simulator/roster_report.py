"""Publish completed roster-audit evidence, tiers, builds, and ability contrasts."""
from collections import Counter, defaultdict
import csv
import html
import json
from pathlib import Path

from lab.data import ROOT, canonical, digest
from lab.store import Store
from roster_audit import OUT, TRAIN, VALIDATE, summarize

DEST = ROOT / "reports/balance/2026-10-23"


def tier(score):
    for name, minimum in (("S", .875), ("A", .75), ("B", .625), ("C", .5), ("D", .375), ("E", .25)):
        if score >= minimum:
            return name
    return "F"


def write_csv(name, rows):
    if not rows:
        return
    with (DEST / name).open("w", newline="", encoding="utf-8") as out:
        writer = csv.DictWriter(out, fieldnames=list(rows[0]))
        writer.writeheader()
        for row in rows:
            writer.writerow({k: canonical(v) if isinstance(v, (dict, list)) else v for k, v in row.items()})


def flat(row):
    b = row["build"]
    return {"species": b["species"], "ability": b["ability"], "item": b["item"], "moves": " / ".join(b["moves"]),
            "archetype": row.get("archetype", ""),
            "strategy": row.get("strategy", "tactical"),
            "score_lower": round(row["score_lower"], 4), "score_upper": round(row["score_upper"], 4),
            "wins": row["wins"], "losses": row["losses"], "draws": row["draws"], "unresolved": row["unresolved"],
            "errors": row["errors"], "games": row["games"], "opponents": row["opponents"],
            "mean_turns": round(row["mean_turns"], 2) if row["mean_turns"] is not None else None, "build_id": row["id"]}


def main():
    plan = json.loads((OUT / "plan.json").read_text())
    search = json.loads((OUT / "search.json").read_text())
    validation = json.loads((OUT / "validation.json").read_text())
    candidates = json.loads((OUT / "candidates.json").read_text())
    from pp_corrections import corrected_audit
    base_store = Store(OUT / "battles.sqlite")
    store, search, validation, corrections = corrected_audit(base_store, search, validation, candidates)
    from moveset_diversity import diversity_retests
    store, validation, diversity = diversity_retests(store, search, validation)
    refinement_path = OUT / "outlier-refinements.json"
    refinement = json.loads(refinement_path.read_text()) if refinement_path.exists() else None
    if refinement:
        original_receipt = store.run(validation["run"])["provenance"]
        if refinement["base_validation_run"] != validation["run"] or refinement["provenance"]["rom_sha256"] != original_receipt["rom_sha256"]:
            raise ValueError("outlier refinements do not match this game's audit")
        differences = {k for k in original_receipt["files"] if original_receipt["files"][k] != refinement["provenance"]["files"].get(k)}
        if differences - {"tools/battle-simulator/lab/engine.py"}:
            raise ValueError(f"refinements changed more than the verified PP transport: {differences}")
        from moveset_diversity import ExtendedStore
        store = ExtendedStore(store, validation["run"], refinement["rows"])
        subjects = validation["subjects"] + refinement["subjects"]
        validation = {**validation, "subjects": subjects, "rows": summarize(store, validation["run"], subjects)}
    archetypes = {digest(canonical([p["build"]]).encode())[:16]: p["archetype"] for p in candidates}
    for experiment in (search, validation):
        for row in experiment["rows"]:
            row["archetype"] = archetypes.get(row["id"], "")
            if refinement and row["id"] in refinement["strategies"]:
                row["archetype"] = "outlier-refinement"
                row["strategy"] = refinement["strategies"][row["id"]]
    move_sets = defaultdict(set)
    used_moves, used_items = set(), set()
    for candidate in candidates:
        b = candidate["build"]
        move_sets[b["species"]].add(tuple(sorted(b["moves"])))
        used_moves.update(b["moves"])
        used_items.add(b["item"])
    if refinement:
        for b in refinement["subjects"]:
            move_sets[b["species"]].add(tuple(sorted(b["moves"])))
            used_moves.update(b["moves"])
            used_items.add(b["item"])
    runs = [store.run(x["run"]) for x in (search, validation)]
    progress = [store.progress(x["run"]) for x in (search, validation)]
    if any(p["counts"].get("pending") for p in progress):
        raise ValueError("Cannot publish incomplete audit")
    if runs[0]["provenance"] != runs[1]["provenance"]:
        raise ValueError("Incompatible source/ROM fingerprints")
    best, alternatives = {}, defaultdict(list)
    for row in validation["rows"]:
        species = row["build"]["species"]
        best.setdefault(species, row)
        alternatives[species].append(row)
    if set(best) != set(plan["eligible"]):
        raise ValueError("Missing or extra eligible species")
    ranked = sorted(best.values(), key=lambda r: (-r["score_lower"], r["errors"], r["unresolved"], r["build"]["species"]))
    tiers = []
    previous, rank = None, None
    for i, row in enumerate(ranked, 1):
        if row["score_lower"] != previous:
            rank = i
            previous = row["score_lower"]
        tiers.append({"rank": rank, "tier": tier(row["score_lower"]), **flat(row)})
    ability_rows = {}
    for row in search["rows"]:
        ability_rows.setdefault((row["build"]["species"], row["build"]["ability"]), row)
    contrasts = []
    buckets = defaultdict(list)
    for row in search["rows"]:
        b = row["build"]
        buckets[(b["species"], b["item"], tuple(b["moves"]), b["happiness"])].append(row)
    for (species, item, moves, happiness), rows in buckets.items():
        for i, a in enumerate(rows):
            for b in rows[i+1:]:
                contrasts.append({"species": species, "item": item, "moves": " / ".join(moves),
                                  "ability_a": a["build"]["ability"], "ability_b": b["build"]["ability"],
                                  "score_a": a["score_lower"], "score_b": b["score_lower"],
                                  "difference": round(a["score_lower"]-b["score_lower"], 4), "games_each": a["games"]})
    comparisons = []
    for species, rows in alternatives.items():
        if len(rows) > 1:
            a, b = rows[0], rows[-1]
            comparisons.append({"species": species, "score_gap": round(a["score_lower"]-b["score_lower"], 4),
                                "better": flat(a), "weaker": flat(b),
                                "same_ability": a["build"]["ability"] == b["build"]["ability"],
                                "same_item": a["build"]["item"] == b["build"]["item"]})
    comparisons.sort(key=lambda r: (-r["score_gap"], r["species"]))
    findings, all_counts, weight_uses = [], Counter(), Counter()
    for experiment in (search, validation):
        for row in store.results(experiment["run"]):
            r = row["result"]
            all_counts[r["status"]] += 1
            if r["status"] != "completed" or r["failures"]:
                findings.append({"run": experiment["run"], "battle": row["id"], "scenario": row["spec"],
                                 "status": r["status"], "error": r.get("error"), "failures": r["failures"], "replay_id": r["replay_id"]})
            for state in r["log"]:
                for event in state.get("actions", []):
                    if event["move"] in {"LOW_KICK", "GRASS_KNOT", "HEAVY_SLAM", "HEAT_CRASH"}:
                        weight_uses[event["move"]] += 1
    store.close()
    receipt = {"date": "2026-10-23", "species": len(tiers), "ability_variants": plan["ability_variants"],
               "searched_builds": len(candidates), "validated_builds": len(validation["rows"]),
               "distinct_species_movesets": sum(map(len, move_sets.values())), "unique_moves": len(used_moves),
               "held_items_tested": sorted(used_items - {"NO_ITEM"}), "no_item_controls": "NO_ITEM" in used_items,
               "battle_counts": dict(all_counts), "total_battles": sum(all_counts.values()), "flagged_battles": len(findings),
               "weight_move_actions": dict(weight_uses), "training_run": search["run"], "validation_run": validation["run"],
               "source_sha256": runs[0]["provenance"]["source_sha256"], "rom_sha256": runs[0]["provenance"]["rom_sha256"],
               "driver_sha256": plan["driver_sha256"], "data_sha256": plan["data_sha256"], "runtime": runs[0]["provenance"]["runtime"],
               "training_opponents": TRAIN, "validation_opponents": VALIDATE, "excluded_terminal": plan["excluded_terminal"],
               "tier_thresholds": {"S": .875, "A": .75, "B": .625, "C": .5, "D": .375, "E": .25, "F": 0}}
    receipt["transport_corrections"] = {k: v for k, v in corrections.items() if k != "corrections"}
    receipt["analysis_scripts_sha256"] = {name: digest((ROOT / "tools/battle-simulator" / name).read_bytes())
        for name in ("roster_audit.py", "roster_report.py", "pp_corrections.py", "pp_transport_probe.py", "moveset_diversity.py")}
    receipt["moveset_diversity_retests"] = {"species": [b["species"] for b in diversity["subjects"]], "battles": len(diversity["rows"]),
                                            "transport_patch_sha256": diversity.get("transport_patch_sha256")}
    receipt["outlier_refinements"] = {k: v for k, v in refinement.items() if k not in {"rows", "subjects", "strategies"}} if refinement else None
    if refinement:
        receipt["outlier_refinements"].update({"builds": len(refinement["subjects"]), "battles": len(refinement["rows"])})
    receipt["unique_tested_builds"] = len({digest(canonical([p["build"]]).encode())[:16] for p in candidates}
                                         | (set(refinement["strategies"]) if refinement else set()))
    receipt["transport_corrections"]["completed_winner_changes"] = sum(x["original_status"] == "completed" and x["original_winner"] != x["result"]["winner"] for x in corrections["corrections"].values())
    receipt["transport_corrections"]["corrected_battles"] = len(corrections["corrections"])
    receipt["total_native_audit_executions"] = receipt["total_battles"] + len(corrections["corrections"]) + len(corrections["control_replays"])
    DEST.mkdir(parents=True, exist_ok=True)
    for name, value in (("receipt.json", receipt), ("tier-list.json", tiers), ("build-comparisons.json", comparisons),
                        ("validated-builds.json", validation), ("flagged-battles.json", findings), ("transport-corrections.json", corrections),
                        ("moveset-diversity-retests.json", diversity)):
        (DEST / name).write_text(json.dumps(value, indent=2), encoding="utf-8")
    if refinement:
        (DEST / "outlier-refinements.json").write_text(json.dumps(refinement, indent=2), encoding="utf-8")
    write_csv("tier-list.csv", tiers)
    write_csv("validated-builds.csv", [flat(r) for r in validation["rows"]])
    write_csv("searched-builds.csv", [flat(r) for r in search["rows"]])
    write_csv("ability-best-builds.csv", [flat(r) for r in ability_rows.values()])
    write_csv("controlled-ability-comparisons.csv", contrasts)
    for name in ("engine-pre-pp-fix.py", "engine-pp-candidate.py"):
        if (OUT / name).exists():
            (DEST / name).write_bytes((OUT / name).read_bytes())
    if not (DEST / "roster-audit-used.py").exists():
        (DEST / "roster-audit-used.py").write_bytes((ROOT / "tools/battle-simulator/roster_audit.py").read_bytes())
    lines = ["# Crimson Crystal: native-ROM singles tier list", "", 
             f"{len(tiers)} fully evolved or single-stage Pokémon/forms; {plan['ability_variants']} legal ability variants; "
             f"{receipt['unique_tested_builds']:,} distinct legal builds tested; {sum(all_counts.values()):,} ranked native-ROM scenarios. Starter families and their clones/regional forms are excluded. Legendaries are included.", "",
             f"The search contains {receipt['distinct_species_movesets']:,} distinct species/moveset combinations, "
             f"{len(used_moves)} different moves, {len(used_items - {'NO_ITEM'})} held items, and no-item controls.", "",
             "## Reading these results", "",
             "These are provisional **level-100 1v1 tiers under the laboratory tactical policy and any explicitly listed opening sequence**, with perfect DVs, zero stat experience, base PP, fresh HP, no initial status, and native entry weather. They measure the best tested build per species against a fixed panel, not an exhaustive optimum or a competitive 6v6 viability ranking.", "",
             "The search tries six styles per legal ability: coverage, Choice offense, setup/recovery, status/recovery, weight/special effects with Focus Sash, and alternative attacks without an item. Some styles converge for small movepools. Guts/Poison Heal and Marowak receive relevant item variants. Every move/item/ability is checked against the source. Each candidate faces the same four screening opponents and seeds, two on each battle side. Up to two build finalists per species advance. The finalists face sixteen different species, using their screening-selected builds, twice each with the sides swapped (32 battles per finalist). Those screening opponents do not appear on the validation panel.", "",
             f"A moveset-diversity check identified finalists whose lists differed only in move order. An additional genuinely different moveset was validated for {len(diversity['subjects'])} species "
             f"({', '.join(b['species'] for b in diversity['subjects'])}), using exactly the same 32 fixtures. Limited pools with no different tested moveset were retained transparently. These {len(diversity['rows'])} extra battles have a separate replay receipt.", "",
             (f"A targeted refinement pass tested {len(refinement['subjects'])} additional builds across {len(refinement['selected_species'])} outliers "
              f"({len(refinement['rows']):,} more battles). It challenged weak sets containing Explosion/Selfdestruct with non-sacrificial alternatives, checked Tyranitar variants, and tried specialist Smeargle sets. "
              "Smeargle's listed scripted openings use actual legal move choices before returning to tactical play; they do not inject boosts or sleep. All refinements reuse the identical opponent builds, sides, and seeds. This extra search effort is uneven and was chosen after inspecting the first results, so the final scores remain descriptive and selection-biased. "
              "The persisted PP guard is active; only that transport file differs from the broad pass, and the ROM bytes are identical. See `outlier-refinements.json`." if refinement else "No targeted outlier refinement pass is included in this report."), "",
             "The displayed build is the best tested finalist on this panel. Selecting it after validation introduces selection optimism; the score is descriptive, not an unbiased estimate of an unknown metagame win rate. No ability is certified best from four screening battles. Battle sides share a seed, so games are correlated. Tied scores share a rank; alphabetical order within ties has no strength meaning.", "",
             "Score = (wins + half of native draws) / all scheduled battles. Unresolved or failed battles give a lower/upper score range, never invented wins or losses. Tiers use fixed thresholds: S ≥87.5%, A ≥75%, B ≥62.5%, C ≥50%, D ≥37.5%, E ≥25%, F below25%. Adjacent tiers and near-ties need more seeds/opponents. The JSON validation evidence contains broad opponent-block reference bounds; the fixed panel was selected, not randomly sampled.", "",
             "Setup, stall, prediction, immunities and switching can be underplayed by the heuristic. Counter, multi-hit, fixed damage, Huge Power, type-conversion choices and sleep support receive explicit policy handling, while the ROM resolves their effects. Hazard setters, clerics, pivots, Baton Pass users, partner-dependent abilities and zero-to-hero switching strategies need team battles to judge their full value. An F here means weak in these duels, not useless in the game.", "",
             "## Tier roster", ""]
    for t in "SABCDEF":
        members = [r["species"] for r in tiers if r["tier"] == t]
        lines += [f"**{t} ({len(members)})**: " + ", ".join(members), ""]
    lines += ["## Strongest to weakest, with best tested builds", "", "| Rank | Tier | Pokémon/form | Score | W–L–D | Ability | Item | Strategy | Moves |", "|---:|:---:|---|---:|---:|---|---|---|---|"]
    for r in tiers:
        score = f"{r['score_lower']:.1%}" + (f"–{r['score_upper']:.1%}" if r["score_upper"] != r["score_lower"] else "")
        lines.append(f"| {r['rank']} | {r['tier']} | {r['species']} | {score} | {r['wins']}–{r['losses']}–{r['draws']} | {r['ability']} | {r['item']} | {r['strategy']} | {r['moves']} |")
    lines += ["", "## Moveset and build sensitivity", "", "These are paired panel comparisons for the two finalists. Where ability or item differs, the gap belongs to the whole build and cannot be attributed to moves alone.", ""]
    for c in comparisons[:15]:
        a, b = c["better"], c["weaker"]
        lines += [f"- **{c['species']}**: {a['score_lower']:.1%} vs {b['score_lower']:.1%} ({c['score_gap']:.1%} gap). "
                  f"Better: {a['ability']} / {a['item']} / {a['moves']}. Weaker: {b['ability']} / {b['item']} / {b['moves']}."]
    lines += ["", "## Replays, bugs, and weight coverage", "", f"Battle status counts: `{dict(all_counts)}`. Flagged battles: {len(findings)}. "
              "Flags include time limits, emulator/transport errors, HP invariants, and textbox overflows; they are review candidates, not automatically proven ROM bugs. Zero flags would not prove every mechanic bug-free.", "",
              f"The sweep exposed a debug-transport PP defect: auto-mode player selection could keep requesting a depleted move after every slot reached zero PP. "
              f"{len(corrections['corrections'])} affected recorded scenario(s) were replayed with a private guard that allocates and executes Struggle through native ROM code. "
              f"{len(corrections['control_replays'])} unaffected controls reproduced their complete turn logs exactly. Scores above use those explicit corrective replays; original database rows remain unchanged. "
              "The ROM bytes and choice policy are identical across these records; the transport guard has its own SHA-256 receipt. The original shortlist was retained, so this correction does not claim a fresh exhaustive build search. See `transport-corrections.json` and the preserved pre-fix/candidate engine sources.", "",
              f"Observed weight-move action counts: `{dict(weight_uses)}`. All four weight moves execute the game's live weight calculation; the simulator's earlier weight verification also checked all 498 species weights and 5,698 native power cases.", "",
              "Full native turn logs, requested/actual actions, RNG seeds and replay IDs are retained in `tools/battle-simulator/output/roster-2026-10-23/battles.sqlite`. `flagged-battles.json` contains exact scenarios for any flagged results. The database is local/ignored; these reports and build exports can be retained with the project.", "",
              "## Files and reproduction", "",
              "- `tier-list.csv` / `tier-list.json`: all eligible species and best tested builds.",
              "- `validated-builds.csv`: both finalists and their 32-game results.",
              "- `searched-builds.csv`: every tested legal build; four-game screening evidence only.",
              "- `ability-best-builds.csv`: best screening build for every species/ability variant.",
              "- `controlled-ability-comparisons.csv`: identical moves/items/happiness, different abilities, same opponents/seeds.",
              "- `build-comparisons.json`: stronger/weaker finalist pairs, with ability/item control flags.",
              "- `receipt.json`: run IDs, scope, hashes, runtime, excluded species and counts.", "",
              "Run from the repository root using the existing WSL environment:", "", "```sh", 
              ".venv/bin/python tools/battle-simulator/roster_audit.py plan",
              ".venv/bin/python tools/battle-simulator/roster_audit.py all --jobs 8",
              ".venv/bin/python tools/battle-simulator/roster_report.py", "```", "",
              "Matching runs resume from committed battles. If source, ROM or lab code changes, use a new audit directory/seed instead of mixing versions.", "",
              f"ROM SHA-256: `{receipt['rom_sha256']}`  ", f"Source receipt: `{receipt['source_sha256']}`", ""]
    (DEST / "TIER-LIST.md").write_text("\n".join(lines), encoding="utf-8")
    # Compact, searchable local companion to the full evidence exports.
    payload = json.dumps(tiers).replace("<", "\\u003c")
    page = """<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>Crimson Crystal — measured singles tiers</title><style>
body{font:15px system-ui;background:#11131b;color:#e9eaf0;margin:0;padding:32px}main{max-width:1500px;margin:auto}h1{font-size:32px;margin-bottom:8px}p{max-width:1000px;line-height:1.5;color:#b8bccb}input,select{font:inherit;padding:10px;background:#202431;color:white;border:1px solid #465065;border-radius:6px;margin:8px 12px 18px 0}input{width:360px;max-width:85%}table{width:100%;border-collapse:collapse;font-size:13px}td,th{text-align:left;padding:11px;border-bottom:1px solid #303544}th{position:sticky;top:0;background:#232836}td:last-child{min-width:300px}.tier{font-weight:800;font-size:17px}.S{color:#ff7794}.A{color:#ffbd78}.B{color:#e4d579}.C{color:#8cd4ad}.D{color:#87baff}.E{color:#bb9aff}.F{color:#b6bac5}a{color:#9cc6ff}#count{font-weight:bold}</style>
<main><h1>Crimson Crystal: singles power tiers</h1><p>Native ROM outcomes · level 100 · fully evolved and single-stage only · starter families excluded. Best tested finalist per Pokémon, following a search across legal abilities and six build styles. This fixed-panel 1v1 ranking is provisional; tied scores share a rank.</p>
<p><a href="TIER-LIST.md">Method and findings</a> · <a href="tier-list.csv">Full rankings CSV</a> · <a href="validated-builds.csv">All finalist builds</a> · <a href="ability-best-builds.csv">Ability variants</a> · <a href="receipt.json">Run receipt</a></p>
<input id="q" aria-label="Search Pokémon, ability, item or move" placeholder="Search Pokémon, ability, item or move"><select id="tier" aria-label="Filter tier"><option value="">All tiers</option><option>S</option><option>A</option><option>B</option><option>C</option><option>D</option><option>E</option><option>F</option></select><span id="count"></span>
<div style="overflow:auto"><table><thead><tr><th>Rank</th><th>Tier</th><th>Pokémon / form</th><th>Score</th><th>W–L–D</th><th>Ability</th><th>Item</th><th>Strategy</th><th>Moves</th></tr></thead><tbody id="rows"></tbody></table></div></main><script>
const data=PAYLOAD;
const normalize=s=>s.toLowerCase().replace(/[^a-z0-9]/g,'');
function render(){
const q=normalize(document.querySelector('#q').value),t=document.querySelector('#tier').value;
const rows=data.filter(r=>(!t||r.tier===t)&&normalize(JSON.stringify(r)).includes(q));
document.querySelector('#count').textContent=rows.length+' Pokémon';
document.querySelector('#rows').replaceChildren(...rows.map(r=>{
const tr=document.createElement('tr');
[r.rank,r.tier,r.species,(100*r.score_lower).toFixed(1)+'%'+(r.score_upper>r.score_lower?'–'+(100*r.score_upper).toFixed(1)+'%':''),r.wins+'–'+r.losses+'–'+r.draws,r.ability,r.item,r.strategy,r.moves].forEach((v,i)=>{
const td=document.createElement('td');td.textContent=v;if(i===1)td.className='tier '+r.tier;tr.append(td)});return tr}))}
document.querySelector('#q').addEventListener('input',render);
document.querySelector('#tier').addEventListener('change',render);
render();</script></html>""".replace("PAYLOAD", payload)
    (DEST / "tier-list.html").write_text(page, encoding="utf-8")
    print(json.dumps({"report": str(DEST / "TIER-LIST.md"), **receipt}, indent=2))


if __name__ == "__main__":
    main()

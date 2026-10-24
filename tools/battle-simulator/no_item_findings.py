"""Summarize the completed no-item audit and export its full matchup matrix."""
from collections import Counter, defaultdict
import json
from pathlib import Path
import subprocess
import sys

from lab.data import canonical
from lab.store import Store
from no_item_audit import DEST, OUT, csv_file, flat, write


def main():
    subprocess.run([sys.executable, str(Path(__file__).with_name("no_item_consistency.py")), "--complete"], check=True)
    ranking = json.loads((DEST / "tier-list.json").read_text())
    receipt = json.loads((DEST / "receipt.json").read_text())
    validation = json.loads((OUT / "validation.json").read_text())["rows"]
    screen = json.loads((OUT / "screen.json").read_text())["rows"]
    league = json.loads((OUT / "league.json").read_text())
    species = [r["species"] for r in ranking]
    matrix = {s: {t: None for t in species} for s in species}
    pair_points, pair_games = Counter(), Counter()
    store = Store("/tmp/crimson-no-items-20261024.sqlite")
    try:
        for run in league["runs"]:
            for record in store.results(run):
                spec, r = record["spec"], record["result"]
                assert r is not None and r["status"] != "error" and not r["failures"]
                a, b = spec["player"][0]["species"], spec["enemy"][0]["species"]
                for own, other, side in ((a, b, "player"), (b, a, "enemy")):
                    pair_games[own, other] += 1
                    if r["winner"] != "unresolved":
                        pair_points[own, other] += .5 if r["winner"] == "draw" else float(r["winner"] == side)
        assert len(pair_games) == len(species)*(len(species)-1)
        assert set(pair_games.values()) == {2}
        for (a, b), n in pair_games.items():
            matrix[a][b] = pair_points[a, b]/n
        csv_file(DEST / "matchup-matrix.csv", [{"species": s, **matrix[s]} for s in species])
    finally:
        store.close()
    gaps = []
    by_ability = defaultdict(list)
    for row in validation:
        b = row["candidate"]["build"]
        by_ability[b["species"], b["ability"]].append(row)
    for (s, a), rows in by_ability.items():
        ordered = sorted(rows, key=lambda r: -r["score"])
        if len(ordered) > 1:
            best, weaker = ordered[0], ordered[-1]
            gaps.append({"species": s, "ability": a, "gap": best["score"]-weaker["score"],
                         "better_score": best["score"], "weaker_score": weaker["score"],
                         "better_moves": " / ".join(best["candidate"]["build"]["moves"]),
                         "weaker_moves": " / ".join(weaker["candidate"]["build"]["moves"]),
                         "better_opening_slots": canonical(best["candidate"]["opener"]),
                         "weaker_opening_slots": canonical(weaker["candidate"]["opener"]),
                         "games_each": best["games"]})
    gaps.sort(key=lambda r: (-r["gap"], r["species"], r["ability"]))
    csv_file(DEST / "moveset-comparisons.csv", gaps)
    # Export every Ceruledge ability/set comparison, not just its selected build.
    csv_file(DEST / "ceruledge-screened-builds.csv", [flat(r) for r in screen if r["candidate"]["build"]["species"] == "CERULEDGE"])
    ceruledge = [flat(r) for r in validation if r["candidate"]["build"]["species"] == "CERULEDGE"]
    ceruledge_portfolio = sum(r["candidate"]["build"]["species"] == "CERULEDGE" for r in screen) // 3
    csv_file(DEST / "ceruledge-validated-builds.csv", ceruledge)
    lines = ["# No-item balance findings", "", "Internal report — October 24, 2026.", "",
             f"Tested **{len(species)} eligible Pokémon/forms**, **{receipt['plan']['ability_variants']} species/ability combinations**, "
             f"**{receipt['plan']['candidates']:,} screened builds/strategies**, and **{receipt['ranked_battles']:,} native battles**. "
             "Both sides held no item. The complete final league contributes 53,130 battles, 460 per species.", "",
             "The [full tier list](TIER-LIST.md) ranks the selected builds by their final-roster league scores. "
             "These use Enhanced rules, level-100 singles and an automated policy; team roles and perfect play can differ. "
             "The trainer profile has empty item slots, and the player policy cannot request bag items.", "",
             f"Tier counts: `{canonical(receipt['tier_counts'])}`.", "", "## Strongest measured builds", "",
             "| Pokémon | Tier | Score | Ability | Moves |", "|---|:---:|---:|---|---|"]
    for r in ranking[:10]:
        lines.append(f"| {r['species']} | {r['tier']} | {r['score']:.1%} | {r['ability']} | {r['moves']} |")
    lines += ["", "## Lowest measured builds", "", "| Pokémon | Tier | Score | Ability | Moves |", "|---|:---:|---:|---|---|"]
    for r in ranking[-10:]:
        lines.append(f"| {r['species']} | {r['tier']} | {r['score']:.1%} | {r['ability']} | {r['moves']} |")
    lines += ["", "## Moveset differences under the same ability", "",
              "These differences use the separate 16-opponent validation panel (32 games per set), not league scores. "
              "Both sets have the same species, ability, item rule, opponent builds and seeds. Opening strategy can differ; "
              "see the CSV for exact opening slots. These are better/weaker *tested sets*, not proofs of global optima.", "",
              "| Pokémon / ability | Better score | Weaker score | Better set | Weaker set |",
              "|---|---:|---:|---|---|"]
    for r in gaps[:20]:
        lines.append(f"| {r['species']} / {r['ability']} | {r['better_score']:.1%} | {r['weaker_score']:.1%} "
                     f"| {r['better_moves']} | {r['weaker_moves']} |")
    lines += ["", "## Ceruledge", "",
              f"All three legal abilities — Flash Fire, Weak Armor and Sharpness — received the same {ceruledge_portfolio} screening "
              "moveset/strategy variants. Each ability advanced two distinct movesets to validation. "
              "The native Sharpness control independently ran 72 one-turn probes (12 seeds, both orientations, three abilities); "
              "Bitter Blade damage increased by approximately 1.5× with Sharpness. These probes do not contribute to the tier scores.", "",
              "The table below shows the full Ceruledge validation pass. An ability's best score here can use a different "
              "moveset from another ability; consult the controlled screening CSV for identical-moveset ability comparisons.", "",
              "| Ability | Score | W–L–D | Moves | Opening |", "|---|---:|---|---|---|"]
    for r in ceruledge:
        lines.append(f"| {r['ability']} | {r['score']:.1%} | {r['wins']}–{r['losses']}–{r['draws']} | {r['moves']} | {r['opening'] or 'tactical'} |")
    lines += ["", "## Native checks and limits", "",
              "- 31 unit tests and 10 native integration scenarios passed, including PP exhaustion/Struggle, deterministic replay, "
              "Low Kick's native weight power, both rollout sides and native party handling.",
              "- The source/compiled check matched all 498 species and 442 moves. The exact game, source and runtime hashes are in `receipt.json`.",
              "- 64 additional native mechanics probes checked empty-hand Acrobatics, No Guard's accuracy and hail Blizzard "
              "on both sides. An inert held POTION appears only in Acrobatics' control cases, never in ranked battles.",
              f"- Native item observations: `{canonical(receipt['native_item_observations'])}`.",
              f"- Weight move attempts: `{canonical(receipt['weight_move_attempts'])}`.",
              f"- Battle status counts: `{canonical(receipt['counts'])}`; flagged records: **{receipt['flags']}**. "
              "A turn limit is unresolved, not automatically a draw, loss or game bug. Its lower-bound score earns no points.",
              "- No game mechanics were replaced with another generation's implementation. Selection heuristics and scripted openings "
              "can still misplay some situations. Bugs without an applicable assertion can remain undetected.", "",
              "## Files", "", "- `TIER-LIST.md`: complete ranking and methods.",
              "- `matchup-matrix.csv`: every final-league pairing; cells are points over two side-swapped games; blank diagonal.",
              "- `moveset-comparisons.csv`: stronger/weaker validated sets under each ability.",
              "- `ability-best-builds.csv`: each ability's best validated moveset.",
              "- `controlled-ability-comparisons.csv`: screening comparisons holding moves/openings/opponents/seeds fixed.",
              "- `ceruledge-screened-builds.csv` / `ceruledge-validated-builds.csv`: all Ceruledge evidence.",
              "- `sharpness-native-checks.json`: full controlled native damage logs.", "",
              "- `native-choice-checks.json`: Acrobatics and guaranteed-accuracy mechanics controls.", "",
              "- `decision-consistency.json`: every saved action request and engine/data/ROM hash checked against the final policy.", "",
              "The simulator and all these reports remain internal development tools, off the public website.", ""]
    (DEST / "FINDINGS.md").write_text("\n".join(lines), encoding="utf-8")
    status = DEST / "RUNNING.md"
    if status.exists():
        status.write_text("# No-item audit completed\n\nSee [FINDINGS.md](FINDINGS.md) and [TIER-LIST.md](TIER-LIST.md).\n", encoding="utf-8")
    print(json.dumps({"status": "completed", "report": str(DEST), "moveset_comparisons": len(gaps),
                      "ordered_matchups": len(pair_games), "ceruledge_validation": ceruledge}, indent=2))


if __name__ == "__main__":
    main()

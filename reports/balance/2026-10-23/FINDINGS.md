# What the native-ROM battle sweep found

Tested **231 fully evolved or single-stage Pokémon/forms**, **664 legal ability
variants**, **4,050 distinct builds**, and **1,351 distinct species/moveset
combinations**. Starter families, their clones, and regional starter forms are
excluded. Legendaries are included.

There are **33,052 ranked battle scenarios**: 33,048 screening/validation/refinement
scenarios and four direct S-tier matchups. Including 52 corrective replays and
six exact-match controls, the audit executed **33,110 native-ROM battles**.
The separate integration fixtures are not included in that count.

## Leading tested builds

| Tier | Pokémon | Ability / item | Moves | Common-panel result |
|---|---|---|---|---:|
| S | Articuno | Snow Warning / Choice Specs | Ice Beam, Blizzard, Hurricane, Air Slash | 28–4, 87.5% |
| S | Mewtwo | Pressure / Focus Sash | Low Kick, Grass Knot, Counter, Psystrike | 28–4, 87.5% |

Articuno won the direct follow-up **4–0** against that Mewtwo build. This is a
small matchup-specific result, not a universal guarantee against other Mewtwo
builds.

The measured **A tier** is Wobbuffet, Dragapult, Gardevoir, Heracross, Lickilicky,
Mimikyu, Lugia, Dusknoir, Gyarados, Tyranitar, and Zapdos. See the full list for
their actual abilities, items, moves, scores, and tied ranks.

The lowest tested scores were **Golem, Alolan Sandslash, and Victreebel at
18.75%**, followed by Cloyster, Ditto, Scrafty, and Tangrowth at 21.875%.
These are results for the best builds found in this bounded search under this
singles policy and opponent panel; they are not intrinsic species ratings.

## Movesets and items changed the answer

- **Tyranitar:** the first selected build scored 21.875%. Sand Stream + Focus
  Sash with **Counter / Stone Edge / Crunch / Iron Head** reached **75%**.
- **Smeargle:** the initial sacrificial builds scored 0%. An Own Tempo + Focus
  Sash set with **Counter / Mirror Coat / Night Shade / Seismic Toss** reached
  **50%**. Legal Spore/setup openings and Loaded Dice variants were also tested;
  the full exports retain their results.
- **Weezing:** testing alternatives without Explosion/Selfdestruct raised the
  best observed score from **12.5% to 43.75%**.
- **Lickilicky** reached **81.25%** in the additional build tests, entering A.

These improvements belong to the whole tested build. Where abilities or items
differ, the result cannot be attributed to moves alone. The controlled-ability
export separately holds moves, item, happiness, opponents, and seeds constant.

## Weight changes were exercised

The ranked scenarios recorded **3,382 Grass Knot**, **1,292 Low Kick**,
**589 Heavy Slam**, and **114 Heat Crash** action attempts. Their power, damage,
abilities, and other effects were resolved by the compiled game. Mewtwo's best
tested set contains both Low Kick and Grass Knot.

## A simulator defect was found and fixed

Debug-auto player selection could request a depleted move after all PP reached
zero instead of selecting Struggle. The audit identified **52 affected
scenarios**. Replaying them through the corrected native selection guard changed
the winner of **35 previously completed battles** and resolved one timed-out
battle. Six unaffected controls reproduced their full turn logs exactly.

The fix is persisted in the lab and passed **18 unit tests and 10 native
integration scenarios**. Original records and corrective replays are retained.
This was a debug-transport defect; it does not establish a ROM damage or ability
bug. Final ranking scenarios have no remaining errors, assertion failures, or
unresolved outcomes.

## Using these results

This is a provisional **level-100 1v1** ranking on a common panel. The normal
policy is tactical; explicitly recorded Smeargle opening sequences were also
tested. The best build was selected after observing panel results, so scores
are descriptive and optimistic. Close scores and ties need more seeds and
opponents. Team support, switching, weather partners, and 6v6 roles need their
own experiments.

- [Full tier list, builds, method, and limitations](TIER-LIST.md)
- [Searchable tier viewer](tier-list.html)
- [Rankings CSV](tier-list.csv)
- [All validated builds](validated-builds.csv)
- [All screened builds](searched-builds.csv)
- [Ability variants](ability-best-builds.csv)
- [Controlled ability comparisons](controlled-ability-comparisons.csv)
- [S-tier head-to-head results](ELITE-LEAGUE.md)
- [PP defect and correction](PP-TRANSPORT-FIX.md)
- [Persisted-fix verification receipt](PP-FIX-VERIFICATION.json)

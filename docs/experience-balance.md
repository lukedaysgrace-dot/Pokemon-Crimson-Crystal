# Experience and trainer Stat EXP balance

This audit preserves the Kanto access flags and the cap schedule. Kanto is Brock, Misty, Surge, then Erika/Janine/Sabrina in any order, Blaine (badge 15), Blue (badge 16).

## Assumptions and access

Party size is 2 for Falkner, 3 for Bugsy, 4 for Whitney/Morty, 5 for gym 5, and 6 from gym 6. Recruits join near the previous checkpoint. The projections rotate the lowest-EXP living member into battle. They cover all six Johto branch orders and all six central Kanto orders, both early and delayed Lighthouse clears, across Slow, Medium Slow, and Medium Fast growth, at full rewards and with a 20% reward haircut. They do not guarantee arbitrary teams, skipped routes, fainted recipients, or late low-level replacements.

Only first clears count. Twins share one defeated flag; only one starter variant counts. Phone rematches, Trainer House, lottery rewards, night-only officers, wild encounters, vitamins, trades, Lucky Egg, and Rare Candies contribute nothing to the mainline budget. Boss rewards do not fund preparation for that boss. Level caps discard surplus EXP rather than carrying it into the next checkpoint.

Route 45/46's optional downhill trainers do not fund Brock. Dragon's Den trainers are excluded from Brock's budget because they can be fought before the shrine actually awards Clair's badge (still cap 45). Union Cave B1F only supplies the two southern Pokemaniacs before Surf/Strength; northern hikers and B2F are optional. Route 34's Surf sisters are excluded before Morty. Lighthouse and Rocket Hideout parties use the actual open-tier overrides; west-route and Lighthouse flags are spent once. In the early-clear case, the Lighthouse is already exhausted before Chuck, so a later Jasmine only has her gym trainers left. The S.S. Aqua is unavailable until Surge and never funds Brock or Misty. Victory Road is unavailable until sixteen badges and never funds Blue.

Surge's budget uses Route 6 and his gym alone. Route 10 South, Route 11, Lavender's EXPN Card detour, and Snorlax are available alternatives, but do not have to be cleared before his gym.

The three central Kanto gyms are checked separately in all six orders. In particular, Sabrina can be challenged directly after Surge without first clearing Erika's or Janine's approach. Southern sea routes only fund Blaine after all three central badges. Route 21/1 and Viridian Gym fund Blue.

## Mainline projections

Ranges below combine all orders, growth rates and reward scenarios. These are source-driven projections, not an end-to-end emulator playthrough. The level-73 League row is a preparation target; the progression cap has ended at sixteen badges (maximum 100).

| Checkpoint | Party | Target | Projected levels | Hard trainer multiplier |
|---|---:|---:|---:|---:|
| Falkner | 2 | 10 | 10–10 | 2× |
| Bugsy | 3 | 16 | 15–16 | 3× |
| Whitney | 4 | 20 | 19–20 | 4× |
| Morty | 4 | 25 | 24–25 | 3× |
| Chuck (1) | 5 | 30 | 30–30 | 4× |
| Jasmine (1) | 5 | 30 | 30–30 | 4× |
| Pryce (1) | 5 | 30 | 30–30 | 4× |
| Jasmine (2) | 6 | 34 | 34–34 | 28× |
| Pryce (2) | 6 | 34 | 34–34 | 6× |
| Chuck (2) | 6 | 34 | 34–34 | 6× |
| Pryce (3) | 6 | 38 | 38–38 | 8× |
| Jasmine (3) | 6 | 38 | 38–38 | 32× |
| Chuck (3) | 6 | 38 | 38–38 | 8× |
| Clair | 6 | 45 | 45–45 | 3× |
| Brock | 6 | 50 | 50–50 | 5× |
| Misty | 6 | 54 | 54–54 | 3× |
| Surge | 6 | 58 | 57–58 | 16× |
| Erika | 6 | 62 | 62–62 | 3–20× |
| Sabrina | 6 | 62 | 61–62 | 3–20× |
| Janine | 6 | 62 | 62–62 | 3–20× |
| Blaine | 6 | 66 | 65–66 | 10× |
| Blue | 6 | 69 | 68–69 | 8× |
| League | 6 | 73 | 72–74 | 8× |

Jasmine's second/third-position gym has a local reward allowance because its three trainers may be the only unspent training left after an early Lighthouse clear. The rest of open Johto retains its 4×/6×/8× progression. Surplus EXP stops at the current cap; it does not carry into later badges.

## Trainer Stat EXP

Two restored Burned Tower trainers still had their old level-15–17 parties on the level-20–25 Ecruteak approach. Ned now uses levels 21/22/21, and Dick's Charmeleon is 23. Species, party sizes, and scripts are preserved; Dick's optional encounter is not needed for the EXP projection.

Player Stat EXP comes from the defeated species' base stats, not from the opponent's own training. EXP multipliers do not multiply Stat EXP. The engine uses ceil(sqrt(Stat EXP)), capped at 255, then divides by four; its contribution scales with level. All comparisons here use those training points, not a promise of an exact final-stat difference (the full formula rounds together).

The final policy replaces fixed training on important characters with party matching. At battle initialization, each of the five Stat EXP words uses the highest corresponding word among the player's non-Egg party, including fainted members. Leaders, rivals, Rocket admins, League members, rematches and superbosses get exactly two additional training points, saturating at 63. Kimono Girls, Eusine, Cal, Sprout Tower's Elder and the Karate King use that same small advantage. Levels, species, moves, DVs, access flags and the cap schedule never scale.

Both Cooltrainer classes and Duelist copy those five maximum words exactly, with no rounding or bonus. No party average or estimated campaign amount is used: a focused starter, vitamins, optional battles, Pokerus, and EXP Relay are reflected in the actual values. A low-training replacement or Egg cannot dilute the match. Changing the party changes the next battle's snapshot; later switches inside a battle do not rebuild the opposing party.

For every player word from 0 through 65,535, the major-character result is never lower than the player, and its training-point advantage is exactly min(2, 63 - player_points). At equal levels this adds at most two actual stat points, depending on formula rounding. Fully trained players are matched at the maximum. This guarantees parity against the most-trained party member in each stat; members with less training can still trail that benchmark. Different species, levels, DVs, abilities and items still affect battle strength separately.

Normal Mode retains zero trainer Stat EXP. Other ordinary classes remain zero; themed generics retain authored level-bounded amounts. Link and Battle Tower parties are not overwritten. Matching values are written before the ordinary stat calculation, so both initial stats and later recalculation/Transform paths see the same training words.

| Class | Hard Mode training policy |
|---|---|
| FALKNER | Party maximum + 2 training points |
| WHITNEY | Party maximum + 2 training points |
| BUGSY | Party maximum + 2 training points |
| MORTY | Party maximum + 2 training points |
| PRYCE | Party maximum + 2 training points |
| JASMINE | Party maximum + 2 training points |
| CHUCK | Party maximum + 2 training points |
| CLAIR | Party maximum + 2 training points |
| RIVAL1 | Party maximum + 2 training points |
| WILL | Party maximum + 2 training points |
| CAL | Party maximum + 2 training points |
| BRUNO | Party maximum + 2 training points |
| KAREN | Party maximum + 2 training points |
| KOGA | Party maximum + 2 training points |
| CHAMPION | Party maximum + 2 training points |
| BROCK | Party maximum + 2 training points |
| MISTY | Party maximum + 2 training points |
| LT_SURGE | Party maximum + 2 training points |
| ERIKA | Party maximum + 2 training points |
| JANINE | Party maximum + 2 training points |
| SABRINA | Party maximum + 2 training points |
| BLAINE | Party maximum + 2 training points |
| BLUE | Party maximum + 2 training points |
| RIVAL2 | Party maximum + 2 training points |
| RIVAL3 | Party maximum + 2 training points |
| CRYSTAL | Party maximum + 2 training points |
| CRYSTAL2 | Party maximum + 2 training points |
| CRYSTAL3 | Party maximum + 2 training points |
| PROTON | Party maximum + 2 training points |
| PETREL | Party maximum + 2 training points |
| ARIANA | Party maximum + 2 training points |
| ARCHER | Party maximum + 2 training points |
| PETREL_DIRECTOR | Party maximum + 2 training points |
| EXECUTIVEM | Party maximum + 2 training points |
| EXECUTIVEF | Party maximum + 2 training points |
| MYSTICALMAN | Party maximum + 2 training points |
| RED | Party maximum + 2 training points |
| AGATHA | Party maximum + 2 training points |
| LORELEI | Party maximum + 2 training points |
| RED2 | Party maximum + 2 training points |
| BLUE_CLOAK | Party maximum + 2 training points |
| GREEN | Party maximum + 2 training points |
| FALKNER_REMATCH | Party maximum + 2 training points |
| BUGSY_REMATCH | Party maximum + 2 training points |
| WHITNEY_REMATCH | Party maximum + 2 training points |
| MORTY_REMATCH | Party maximum + 2 training points |
| CHUCK_REMATCH | Party maximum + 2 training points |
| JASMINE_REMATCH | Party maximum + 2 training points |
| PRYCE_REMATCH | Party maximum + 2 training points |
| CLAIR_REMATCH | Party maximum + 2 training points |
| LORELEI_REMATCH | Party maximum + 2 training points |
| KOGA_REMATCH | Party maximum + 2 training points |
| BRUNO_REMATCH | Party maximum + 2 training points |
| KAREN_REMATCH | Party maximum + 2 training points |
| CHAMPION_REMATCH | Party maximum + 2 training points |
| ELDER | Party maximum + 2 training points |
| KIMONO_GIRL | Party maximum + 2 training points |
| KARATE_KING | Party maximum + 2 training points |
| COOLTRAINERM | Exact party match |
| COOLTRAINERF | Exact party match |
| DUELIST | Exact party match |

The earlier fixed Blaine value of 18,496 is no longer used. For example, a maximum player word of 10,000 (25 training points) produces 11,664 (27 points) for Blaine. A word of 25,000 (39 points) produces 26,896 (41 points). Thus he remains just above both a rotating team and a more heavily trained starter instead of assuming they have the same training.

The rotation-only estimates below remain useful context, but no longer determine boss fairness. They exclude optional encounters, wild training and vitamins, so they are not measured real-playthrough averages. A starter-focused distribution can exceed them substantially. Newly recruited team members start with zero training in the projection.

| Checkpoint | Player training points |
|---|---:|
| Falkner | 5–7 |
| Bugsy | 5–10 |
| Whitney | 4–11 |
| Morty | 7–13 |
| Chuck (1) | 9–14 |
| Jasmine (1) | 8–14 |
| Pryce (1) | 9–14 |
| Jasmine (2) | 3–15 |
| Pryce (2) | 9–15 |
| Chuck (2) | 6–15 |
| Pryce (3) | 11–16 |
| Jasmine (3) | 11–16 |
| Chuck (3) | 12–16 |
| Clair | 15–20 |
| Brock | 16–21 |
| Misty | 18–23 |
| Surge | 18–24 |
| Erika | 19–26 |
| Sabrina | 18–26 |
| Janine | 19–26 |
| Blaine | 20–26 |
| Blue | 21–27 |
| League | 21–28 |

## Optional areas and postgame

Optional trainers were inventoried but are extra headroom: Lake of Rage's Surf side, Shiver Isle, Surf-side Union Cave, Mount Mortar, Ruins of Alph, Silent Crypt, Wise Trio, the Fighting Dojo, the Riolu rescue, time-dependent officers and Jaime, S.S. Aqua sailing rosters, the Route 25 Crystal finale (requires Erika), and the Snorlax/Chantz challenge. None is required to make the mainline EXP screen pass.

After the first League, all eight Johto rematches unlock; all eight must be won before the League rematch and the Plateau Silver ambush. Rematches run approximately levels 75–87; Mt. Silver Red is 88–90. Green requires Red, Blue Cloak requires Red plus Green, and Pallet's Red requires Blue Cloak. Every one of these important characters uses the same party-maximum-plus-two rule; no large fixed endgame training bonus remains.

There is no progression cap after badge sixteen: 100 is the system maximum, not a requirement before the level-70s League or level-80s rematches. Forcing a full party to 100 there would erase the intended difficulty. Optional first clears and the party-level-scaled Trainer House provide postgame preparation. Hard Mode champions can now repeat the Trainer House immediately; its once-per-day restriction remains in Normal Mode and before the first League. This adds no flags and changes no Kanto access gates. The report below measures that repeatable fallback explicitly; it does not pretend unused optional trainers are guaranteed to remain. These are aggregate estimates; uneven recipients and rewards lost at target levels can require an extra battle.

| Six Slow-growth mons | Trainer House fallback battles (8×, no Egg/trade) |
|---|---:|
| 73 → 77 | 5 |
| 77 → 84 | 11 |
| 84 → 87 | 4 |
| 87 → 90 | 4 |
| 90 → 100 | 15 |

## Verification

Source screen: 36 badge-order combinations × 2 Lighthouse timings × 3 growth rates × 2 reward scenarios; 0 checkpoints more than one level below target.

The capped-participant Stat EXP duplication bug is fixed: stat awards divide among all living participants, while regular EXP only divides among participants still below cap. Previously, capped participants were omitted from both divisors but still awarded Stat EXP, so switching could multiply training. EXP Share's separate half-award passes retain the same rule and normal integer truncation.

Run `python3 tools/audit_exp_economy.py --check` to reproduce the projection, or add `--write` to refresh this report. `--inventory` lists placed and scripted rosters. ROM arithmetic and party-loading regression checks are in `tools/battletest/exp_economy_checks.py`.

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

In Hard Mode, the game selects the two highest Stat EXP values separately for each of the player's five training stats when the battle starts. Fainted party members count and Eggs are excluded. With one eligible Pokémon, its value supplies both inputs. With zero eligible Pokémon, both inputs are zero.

The game converts each of the two raw values to training points and averages the points, rounding down. Squaring four times that average creates the raw Stat EXP baseline. The class percentage is applied to the raw baseline and rounded down.

Regular classes use 25%, including the themed generic classes. The first Johto Gyms use 50%, Kanto Gyms use 65%, the first League uses 80%, and Gym and League rematches use 90%. Select special classes still add two training points to the average instead, up to 63 points.

Normal Mode gives zero trainer Stat EXP. Link and Battle Tower use their own party data. The opposing party receives its training values when it is built, so later switches keep those same values and recalculations and Transform can read them.

| Class | Hard Mode training policy |
|---|---|
| Regular classes | 25% of the raw baseline |
| FALKNER | 50% of the raw baseline |
| WHITNEY | 50% of the raw baseline |
| BUGSY | 50% of the raw baseline |
| MORTY | 50% of the raw baseline |
| PRYCE | 50% of the raw baseline |
| JASMINE | 50% of the raw baseline |
| CHUCK | 50% of the raw baseline |
| CLAIR | 50% of the raw baseline |
| BROCK | 65% of the raw baseline |
| MISTY | 65% of the raw baseline |
| LT_SURGE | 65% of the raw baseline |
| ERIKA | 65% of the raw baseline |
| JANINE | 65% of the raw baseline |
| SABRINA | 65% of the raw baseline |
| BLAINE | 65% of the raw baseline |
| BLUE | 65% of the raw baseline |
| LORELEI | 80% of the raw baseline |
| KOGA | 80% of the raw baseline |
| BRUNO | 80% of the raw baseline |
| KAREN | 80% of the raw baseline |
| CHAMPION | 80% of the raw baseline |
| FALKNER_REMATCH | 90% of the raw baseline |
| BUGSY_REMATCH | 90% of the raw baseline |
| WHITNEY_REMATCH | 90% of the raw baseline |
| MORTY_REMATCH | 90% of the raw baseline |
| CHUCK_REMATCH | 90% of the raw baseline |
| JASMINE_REMATCH | 90% of the raw baseline |
| PRYCE_REMATCH | 90% of the raw baseline |
| CLAIR_REMATCH | 90% of the raw baseline |
| LORELEI_REMATCH | 90% of the raw baseline |
| KOGA_REMATCH | 90% of the raw baseline |
| BRUNO_REMATCH | 90% of the raw baseline |
| KAREN_REMATCH | 90% of the raw baseline |
| CHAMPION_REMATCH | 90% of the raw baseline |
| GREEN | 100% of the raw baseline |
| RED | 100% of the raw baseline |
| RED2 | 100% of the raw baseline |
| BLUE_CLOAK | 100% of the raw baseline |
| COOLTRAINERM | 65% of the raw baseline |
| COOLTRAINERF | 65% of the raw baseline |
| DUELIST | 65% of the raw baseline |
| MYSTICALMAN | 65% of the raw baseline |
| CRYSTAL | 75% of the raw baseline |
| CRYSTAL2 | 75% of the raw baseline |
| RIVAL1 | 75% of the raw baseline |
| RIVAL2 | 75% of the raw baseline |
| CRYSTAL3 | 90% of the raw baseline |
| RIVAL3 | 90% of the raw baseline |
| HOSTESS | 75% of the raw baseline |
| PROTON | 50% of the raw baseline |
| PETREL | 50% of the raw baseline |
| PETREL_DIRECTOR | 50% of the raw baseline |
| ARIANA | 50% of the raw baseline |
| ARCHER | 75% of the raw baseline |
| SLOT_MANIAC | 50% of the raw baseline |
| ELDER | 50% of the raw baseline |
| KIMONO_GIRL | 50% of the raw baseline |
| KARATE_KING | 75% of the raw baseline |
| CAL | Top-two training point average + 2 |
| EXECUTIVEM | Top-two training point average + 2 |
| EXECUTIVEF | Top-two training point average + 2 |
| WILL | Top-two training point average + 2 |
| AGATHA | Top-two training point average + 2 |

For example, with top values of 10,000 and 2,500 in Attack, the player has 25 and 12 training points. Their average rounds down to 18, which gives a raw baseline of 5,184. Blaine gets 65% of that baseline, or 3,369 raw Attack Stat EXP.

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

After the first League, all eight Johto rematches unlock. All eight must be won before the League rematch and the Plateau Silver ambush. Rematches run approximately levels 75–87 and use 90% of the raw baseline, as does Silver's final fight. Mt. Silver Red is level 88–90. Green requires Red, Blue Cloak requires Red plus Green, and Pallet's Red requires Blue Cloak. Red, Green, and Blue Cloak each use 100% of the raw baseline.

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

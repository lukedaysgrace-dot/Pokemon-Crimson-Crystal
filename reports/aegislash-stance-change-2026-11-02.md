# Aegislash presentation and mechanics follow-up

King Shield now uses the exact same compiled animation pointer as Detect. Its
display name is `KING SHIELD`: `KING'S SHIELD` is 13 characters, while this game's
move-name field permits 12. The move's saved index and mechanics are unchanged.

Form changes use a short fade on Aegislash alone. All sprite tiles load while
the actor is fully hidden, then the new form fades in. The opponent and HUD stay
visible. Disabled animations, Substitute and Minimize use the instant path.
Native phase captures show the complete old sprite fading out and complete new
sprite fading in on both sides, without mixed rows from the two forms.

## Modern main-series behavior

- Damaging moves enter Blade before accuracy, immunity and protection checks.
  King Shield enters Shield even when its guard subsequently fails.
- Other status moves keep the current form. Sleep, flinching and full paralysis
  prevent the change when they prevent the move from executing.
- Struggle and called damaging moves, including Sleep Talk, now trigger the
  change even though their execution skips ordinary PP deduction.
- Transform copies the target's form and ability. The transformed flag prevents
  Stance Change from activating. This corrects the previous copy exclusion.
- Stance Change remains protected against Skill Swap and Neutralizing Gas.
- Shield's base stats remain HP/Atk/Def/Spe/SpA/SpD 60/50/140/60/50/140; Blade
  uses 60/140/50/60/140/50. These are the modern stats, paired with King Shield's
  modern one-stage contact Attack penalty.
- Each form recalculates its stats from this game's DVs/stat experience and
  reapplies the original stat stages and status penalties. Boosts remain on
  their own stats; they do not migrate between Attack and Defense. HP, status,
  ability, volatile effects and saved party records remain intact.

The behavior was checked against the primary simulator implementations of
[Stance Change](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
[King's Shield](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts)
and [Transform](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts).
The game's existing DV/stat-experience model and custom frostbite rule remain
in effect; this change does not replace the game's broader stat system.

## Verification

- Both release and debug ROMs built successfully with RGBDS 0.5.2.
- All 646 battle regressions passed, including every implemented move, the
  affected Illusion/weight/weather cases and the 35 focused roster battles.
- 532 exact native stat/continuity checks passed across both sides, unequal DVs,
  mixed boosts/drops, stage limits, level-100 stat caps, burn, paralysis and
  frostbite. Focus Energy and Mist also remain intact. Ordinary
  Shield/Blade controls use native Psych Up to apply the same stat stages and
  status penalties without running Stance Change. All five resulting stats,
  seven stages, maximum HP and status match through repeated swaps; hooks
  compare HP, status, stages, ability, volatile effects and party data across
  the recalculation itself.
- 596 native data/archive/name/animation checks passed in each ROM. These verify
  `KING SHIELD` through the real move-name routine and compare the compiled
  Detect/King Shield animation pointers directly.
- New recordings include native battle animations and game audio. Each side
  verifies Shield → Blade → Shield, a blocked contact hit and its Attack drop;
  both MP4 tracks decode successfully.
- Required static audits passed. Documentation regeneration finished with zero
  warnings and zero unparsed rows; the renamed move page is `king-shield.html`.

Recordings and transition phase sheets are under
`_artifacts/roster/stance-change-smooth/`. Reproduce with:

```
python3 tools/battletest/stance_change_checks.py
python3 tools/battletest/record_stance_change.py --out _artifacts/roster/stance-change-smooth
```

# Crimson Mienfoo/Mienshao customization

This follow-up replaces the initial family setup described in the October 31
implementation report. Internal species IDs, dex numbers and encounter locations
are unchanged.

| Setting | Mienfoo | Mienshao |
| --- | --- | --- |
| Crimson / Enhanced typing | Fighting/Fairy | Fighting/Fairy |
| Original typing | Fighting | Fighting |
| Ability slots | Serene Grace / Regenerator / Reckless | Serene Grace / Regenerator / Reckless |
| Enhanced Speed / Special Attack | 65 / 55 | **115 / 85** |
| Original Speed / Special Attack | 65 / 55 | **105 / 95** |

Both forms learn **Pixie Punch at 7, Play Rough at 32 and Spirit Break at 48**.
The shared progression supplies early physical Fairy STAB, then stronger attacks
suited to their martial/spiritual theme. **Force Palm remains level 25**.
**Iron Head and Zen Headbutt** are new machine options for both species;
**Rock Slide and Poison Jab** retain their existing Blackthorn tutor routes.

All other stats are unchanged, including Mienshao's 510 base-stat total. The
Original stats and typing options operate independently, so mixed rule selections
work correctly. Serene Grace replaces only Inner Focus; the other ability slots
are preserved. Shared move powers, categories, accuracy and effect probabilities
are unchanged. Serene Grace supplies its normal effect-chance multiplier.

The custom Fairy progression and coverage are recorded in
`tools/testdata/authored_move_restorations.json`; canonical historical move
evidence remains separate. The family receipt, historical access receipt,
attacking review, Pixie Punch distribution, native tests and generated guide
were updated together.

Validation uses both RGBDS 0.5.2 builds, all eight combinations of typing/stat/
ability rule flags in the native family check, reminder timing for all three
Fairy moves on both forms under both typing modes, full-roster machine/tutor
checks and paired effect rolls for Play Rough, Iron Head, Rock Slide, Poison Jab,
Zen Headbutt and Force Palm. Deterministic Zen Headbutt comparisons use roll 96
to avoid the animation's rejection-sampling loop with some fixed RNG values.

Results:

- Both release and debug ROMs build successfully.
- **304 native family checks per ROM pass** (608 total).
- **20 focused battle cases pass**, including ordinary-chance controls and
  Serene Grace comparisons for every requested added-effect attack.
- Full-roster compiled move-access checks: **10,601 pass**.
- Game-data checks: **45,743 pass**; ability text passes.
- Documentation: 500 species generated with zero warnings or unparsed rows;
  both family pages and their Original/Enhanced data verified.
- Historical reference, breeding, attacking-review and learnset-structure audits
  pass, including requested authored additions and preserved exclusions.

The broader baseline issues listed in the October 31 report are unchanged; this
follow-up does not change the affected Klutz/berry or Hydrapple animation code.
Current focused battle results are in `.tmpbuild/mienfoo-fairy-battles.log`;
build and documentation logs use the matching `.tmpbuild/mienfoo-fairy-` prefix.

# Roster replacements — November 2, 2026

All nine requested replacements are implemented, including the supplied battle
sprites and the menu icons added during the task. Families occupy the retired
families' regional Dex positions rather than being appended.

| Retired family | Replacement | Regional Dex |
| --- | --- | --- |
| Spoink / Grumpig | Hisuian Zorua / Hisuian Zoroark | 411–412 |
| Lotad / Lombre / Ludicolo | Seedot / Nuzleaf / Shiftry | 416–418 |
| Spheal / Sealeo / Walrein | Honedge / Doublade / Aegislash | 421–423 |
| Flittle / Espathra | Sableye | 496 |

The old assets are preserved under `no longer implemented/`, including sprite
folders, compiled graphics, menu art, source sheets, base data, Dex entries and
documentation exports. The original 252 moved files pass their SHA-256 manifest
checks. The retired Flittle/Espathra cry scripts are preserved separately there.

## Integrated data

- Base stats, Original/Enhanced rules, types, abilities, growth, gender, catch
  rates, experience, egg groups/cycles, dimensions, weights and Dex descriptions.
- Level-up moves, evolutions, egg moves, machine flags, reminder access and
  source-backed Blackthorn fallback lessons. Honedge's Destiny Bond and Sableye's
  Moonlight have fallback lessons because their breeding donors are absent.
- Normal/shiny battle palettes, front/back sprites, animation registries, cries,
  menu icons and overworld icon pointers. Three new back palettes were normalized
  to their front palettes without changing sprite geometry.
- Encounters, trainer teams and Tower teams. Aquatic encounters and water
  specialists retain suitable aquatic replacements; new land species receive
  legal movesets. Dialogue was not changed.
- Generated documentation: 499 visible Pokémon, 444 moves, zero generation
  warnings and zero unparsed rows.

Seedot, Nuzleaf and Shiftry have Prankster / Wind Rider / Technician. Zorua and
Zoroark are specifically the Hisuian Normal/Ghost forms and have Illusion in
every slot. Honedge and Doublade have No Guard.
Aegislash alone has Stance Change and learns King's Shield on evolution, with
level-1 reminder access as well. Sableye follows the Enhanced stat style and has
Magic Bounce / Keen Eye / Prankster.

## Stance Change and King's Shield

Aegislash enters in Shield, changes to Blade before damaging moves, and changes
back before King's Shield even when the guard attempt fails. Forms reset on
entry. Stats are recalculated using the original DVs/stat experience, preserving
stages and status penalties. Level-ups retain the correct active form; Transform
copies the current form and Stance Change, but cannot activate the ability while
transformed. The follow-up mechanics review is recorded in
`reports/aegislash-stance-change-2026-11-02.md`.

King's Shield uses the shared Protect failure counter and priority. It blocks
damaging moves, permits status moves through, and lowers contact attackers'
Attack one stage. The contact penalty works through the attacker's Substitute
and respects Contrary and stat-drop immunity.

There are 500 internal records and 499 visible Dex entries. The extra retired
slot supplies Aegislash Blade graphics/stats and is excluded from visible Dex
orders and wild encounters. Battle forms never replace the saved species.

## Existing saves

Only retired species slots were repurposed; unrelated species indexes, including
Mienfoo/Mienshao's 499/500 indexes, remain stable. Previously owned retired
Pokémon therefore become their replacements. Old Espathra indexes normalize to
Sableye when loading parties or decoding PC records. Party stats are recalculated
and HP is clamped while existing moves, items and nicknames are preserved.
The save layout remains version 5 with 63-byte seen/caught fields.

## Final validation

- Release and debug ROMs built successfully with RGBDS 0.5.2. A forced final
  rebuild ensured both contain the final register-preservation change.
- `make audit-static` passed: game data, ability text, moves, move expansion,
  learnsets, trainers, save layout, resources, icons and sprite checks.
- 596 native roster/archive/icon/save/evolution/name/animation checks passed in each ROM.
- 10,508 compiled reminder/tutor/machine/learnset checks passed in each ROM.
- 162 native Dex pointer/text/layout checks passed in each ROM, covering both
  pages for all nine additions, including stable names/categories/measurements
  when changing pages. Both rendered page sheets were visually inspected.
- All 646 battle cases passed: every implemented move plus the affected weather,
  residual-order, weight-move, Illusion, Hisuian immunities and stance/guard suites.
  The focused suite includes 35 cases, with Hisuian Ghost Curse under Illusion
  and the modern Stance Change trigger/Transform edge cases. An additional
  532 native checks verify exact stat/stage continuity through repeated swaps.
- Eight exact native front/back tile and palette comparisons passed against
  independent Shield/Blade controls. Preview: `_artifacts/roster/aegislash-forms.png`.
- The existing Phantump/Trevenant evolution checks passed (61 checks).
- The full breeding audit passed (1,914 family egg moves), and all ten active
  replacement sprite folders passed the front/back color audit.
- `git diff --check` passed.

The wider standalone audit sweep also identified unrelated existing limitations:
the frozen MAE animation dependency hashes already differ at the original Git
HEAD; the Sour Apple completeness audit's expected upstream checkout is absent;
and the full sprite color audit flags the unchanged Jirachi backsprite. Those
inputs were not altered to suppress these findings. The replacement sprite and
required static audits pass.

Future checks: `make test-roster` and
`python3 tools/battletest/roster_visual_checks.py`.

## Independent follow-up source verification

After the user clarified that the supplied Zorua family is Hisuian, both entries
were corrected throughout: Normal/Ghost typing, exact regional stats, biological
metadata, level schedules, egg moves, machines, utility and technical tutors,
Dex prose/category and documentation. Their sprites and icons were already the
Hisuian art. Internal constants and regional positions remain stable.

| Form | HP | Attack | Defense | Speed | Sp. Atk | Sp. Def | Weight |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Hisuian Zorua | 35 | 60 | 40 | 70 | 85 | 40 | 12.5 kg |
| Hisuian Zoroark | 55 | 100 | 60 | 110 | 125 | 60 | 73.0 kg |

An independent 142-check comparison used TeamLumi's separate `__3.0gamedata`
tables and exact PokeAPI form records rather than relying only on the existing
roster receipt. It checked Original/Enhanced stats, types, catch rates, base
experience, growth, gender, hatch cycles, egg groups, heights, weights and
supported level/egg/tutor routes. Exact source URLs and SHA-256 hashes are saved
in `reports/roster-source-verification-2026-11-02.json`.

The separate Lumi 3.0 tables retain some regular-form copies: Night Slash for
Hisuian Zoroark and Counter/Sucker Punch in Hisuian Zorua's egg list. Exact
regional-form compatibility takes precedence over those copies. Hisuian Zoroark
gets Shadow Claw on evolution and in the reminder; Nuzleaf likewise receives
Razor Leaf on evolution. The full historical audit independently verifies all
35,809 supported species/move pairs without changing unrelated expected pools.

Aegislash deliberately retains modern canonical 140 form stats together with
the modern one-stage King's Shield contact penalty. Lumi's separate 3.0 Shield
row retains legacy 150 defenses. Unsupported moves remain filtered consistently
with the rest of this game's roster.

The new native Dex layout test caught overlong category labels. Hisuian Zorua
and Zoroark now use `SPITEFUL`; Aegislash uses `ROYALSWORD`. Every description
line fits the existing 18-character layout. Grayscale native tile/font review
sheets are `_artifacts/roster/dex-page-1.png` and `dex-page-2.png`.

Final documentation regeneration completed with 499 Pokémon, 444 moves, 3,371
encounter slots and zero warnings/unparsed rows. Hisuian titles, typing, stats
and acquisition routes are reflected in the exported data and HTML pages.
The two Hisuian front/back palette pairs also pass without any new repairs.

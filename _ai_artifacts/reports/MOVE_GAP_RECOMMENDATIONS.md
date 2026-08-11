# Move Coverage Gaps — Recommended Additions (v2)

**Date:** 2026-07-29
**Supersedes:** v1 of this file, which was wrong — it recommended signature
moves belonging to Pokémon that aren't in this game, and prioritised buckets
that have no species needing them.

## Method

v1 counted *moves per type* and called anything low a gap. That's the wrong
denominator. This version counts **species in your roster whose SpA exceeds
their Atk by 6+** for each type, and compares that against the special moves
of that type actually in the game.

Every ported move below is a **TM, TR, or tutor move with wide canon
distribution**. No signature moves. Every one reuses an effect that already
exists in `constants/move_effect_constants.asm`.

---

## The real picture

| Type | Special-leaning species | Special moves | Ratio | Verdict |
|---|---|---|---|---|
| ELECTRIC | 20 | 5 | 4.0 | **Worst gap** |
| GHOST | 14 | 4 | 3.5 | **Critical** |
| POISON | 18 | 6 | 3.0 | Needs work |
| BUG | 10 | 4 | 2.5 | Needs work |
| ROCK | 11 | 2 | 5.5 | **Critical** |
| STEEL | 8 | 1 | 8.0 | **Worst ratio in game** |
| DARK | 7 | 2 | 3.5 | Moderate |
| FAIRY | 24 | 6 | 4.0 | Curve is complete — low priority |
| ICE | 15 | 6 | 2.5 | Curve is complete — fine |
| GROUND | **2** | 3 | 0.7 | **Fine — do not touch** |
| FIGHTING | **0** | 2 | 0.0 | **Fine — do not touch** |

### Corrections to v1

- **Fighting special was v1's priority #2. Your game has zero special-leaning
  Fighting species.** Focus Blast and Aura Sphere are already more than enough.
  Vacuum Wave and Secret Sword: cut.
- **Ground special:** only Ursaluna-BM and Ursaring-BM lean special, and both
  get Earth Power. Cut.
- **Psychic physical:** 4 species, 3 moves. Fine. Cut Psychic Fangs.
- **Fairy physical:** 9 species, 3 moves. Acceptable. Cut the 3 customs.
- **Cut as signature moves of absent Pokémon:** Doom Desire (Jirachi), Secret
  Sword (Keldeo), Make It Rain (Gholdengo), Sandsear Storm (Landorus),
  Ruination (Chi-Yu), Fiery Wrath (Yveltal), Malignant Chain (Pecharunt),
  Moongeist Beam (Lunala), Night Daze (Zoroark — not in your game), Bolt Beak
  (Dracovish), Zing Zap (Zeraora).

---

## Priority 1 — ELECTRIC (20 species, 5 moves)

Your worst gap by raw species count. Twenty special-leaning Electric mons share
Thunder / Zap Cannon / Thunderbolt / Volt Switch / Thundershock — and the only
option below 70 BP is Thundershock at 40. Early-game Mareep, Voltorb, Chinchou,
Joltik have nothing.

All four below are TM/tutor moves with near-universal Electric distribution.

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| CHARGE_BEAM | 50 | 90 | 10 | `EFFECT_SP_ATK_UP_HIT` (70%) | TM Gen 4–6, learned by nearly every Electric |
| ELECTROWEB | 55 | 95 | 15 | `EFFECT_SPEED_DOWN_HIT` (100%) | Tutor Gen 5–7 |
| PARABOLIC_CHARGE | 65 | 100 | 20 | `EFFECT_LEECH_HIT` | TM Gen 6–7 |
| DISCHARGE | 80 | 100 | 15 | `EFFECT_PARALYZE_HIT` (30%) | TM Gen 4–5, very wide |

Fixes: Magnezone, Magneton, Magnemite, Vikavolt, Ampharos, Jolteon, Raikou,
Zapdos, Galvantula, Electabuzz, Lanturn, both Electrodes, Mareep, Flaaffy,
Joltik, Chinchou, both Voltorbs, Alolan Raichu.

---

## Priority 2 — STEEL (8 species, **1** move)

Worst ratio in the game. Flash Cannon is the only special Steel move that
exists. Magnezone (SpA 130, +60 over Atk), Archaludon (125), Magneton (120),
Duraludon (120) are all hard special attackers with a single STAB option.

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| MIRROR_SHOT | 65 | 85 | 10 | `EFFECT_ACCURACY_DOWN_HIT` (30%) | Gen 4–5 level-up/TM — its canon distribution *is* the Magnemite and Klink lines |
| STEEL_BEAM | 140 | 95 | 5 | `EFFECT_RECOIL_HIT` | TM in SwSh, broad Steel distribution. Canon recoil is 1/2 max HP; 1/4-damage recoil is a fine approximation |

Mirror Shot is the important one — it's the low-tier option Steel completely
lacks, and it lands on exactly the species that need it.

---

## Priority 3 — ROCK (11 species, 2 moves)

Glimmora (SpA 130, +75 over Atk), Omastar (115), Magcargo (110), Glimmet (105)
are serious special attackers sharing Power Gem (80) and Ancient Power (60).

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| METEOR_BEAM | 120 | 90 | 10 | `EFFECT_SKULL_BASH` w/ SpA | TR in SwSh — Coalossal, Gigalith, Cradily, Omastar, Glimmora all get it |
| *(custom)* mid-tier Rock special ~70 BP | 70 | 100 | 15 | `EFFECT_NORMAL_HIT` | Canon has no non-signature option here |

Meteor Beam needs the one code change in this document: Skull Bash is
charge-turn + Def↑; Meteor Beam is charge-turn + SpA↑. One stat constant in the
effect script.

---

## Priority 4 — GHOST (14 species, 4 moves)

Chandelure (SpA 145), Cursola (145), Gengar (130), Hisuian Typhlosion (120),
Haunter (115), Froslass (110), Mismagius (105) — and the special ceiling is
Shadow Ball at 80. Note Infernal Parade is Hisuian Typhlosion's signature; you
have that species, so it's correctly placed and stays.

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| OMINOUS_WIND | 60 | 100 | 5 | `EFFECT_ALL_UP_HIT` (10%) | Gen 4–5 TM, wide Ghost distribution. Add to `WindMoves` |
| *(custom)* high-tier Ghost special ~110 BP | 110 | 100 | 5 | `EFFECT_NORMAL_HIT` or `EFFECT_SP_DEF_DOWN_HIT` | Every canon option above 80 is a legendary signature |

Ghost genuinely has no non-signature high-BP special move in canon — Shadow
Ball is the ceiling by design. A custom is the honest answer here.

---

## Priority 5 — POISON (18 species, 6 moves)

Curve has a hole between Sludge Bomb (90) and Venoshock/Sludge (65), and
nothing that pressures special walls.

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| SLUDGE_WAVE | 95 | 100 | 10 | `EFFECT_POISON_HIT` (10%) | TM Gen 5–7, wide |
| ACID_SPRAY | 40 | 100 | 20 | `EFFECT_SP_DEF_DOWN_HIT` | TM/tutor Gen 5+. Canon is SpD **-2**; needs a 2-stage variant or accept -1 |

---

## Priority 6 — BUG (10 species, 4 moves)

| Move | BP | Acc | PP | Effect to reuse | Canon availability |
|---|---|---|---|---|---|
| SILVER_WIND | 60 | 100 | 5 | `EFFECT_ALL_UP_HIT` (10%) | TM Gen 3–4, wide. Add to `WindMoves` |
| POLLEN_PUFF | 90 | 100 | 15 | `EFFECT_NORMAL_HIT` | TR SwSh — Butterfree, Beedrill, Ribombee. Add to `BallBombMoves` (Bulletproof) |

Serves Vikavolt (145), Volcarona (135), Flygon (130), Yanmega (116),
Butterfree (110), Venomoth (100).

---

## Priority 7 — DARK (7 species, 2 moves) — optional

Only Hydreigon (125) and Houndoom (110) are serious special Dark attackers, and
both get Dark Pulse. Canon has **no** non-signature Dark special move beyond
Dark Pulse and Snarl, both of which you already have. Either add a custom
~85 BP generic or leave this alone. Lowest priority in this document.

---

## Summary

| Type | Adds | Ported (non-signature) | Custom |
|---|---|---|---|
| Electric | 4 | 4 | 0 |
| Steel | 2 | 2 | 0 |
| Rock | 2 | 1 | 1 |
| Ghost | 2 | 1 | 1 |
| Poison | 2 | 2 | 0 |
| Bug | 2 | 2 | 0 |
| Dark | 0–1 | 0 | 0–1 |
| **Total** | **14–15** | **12** | **2–3** |

Down from v1's 24. Twelve are real TM/tutor ports with established
distribution, so learnsets write themselves. Two are customs filling holes
canon leaves open on purpose.

### Blocking caveat (unchanged from v1)

**60 moves already in the game have no learn source** — no level-up entry, no
egg move, no TM. Adding 15 more without a distribution pass makes it 75. The
TM/HM list is also still stock vanilla: 50 TMs, 7 HMs, 3 tutors, none of which
carry any of your ~150 added moves.

Recommend the distribution pass first, or assign learnsets in the same batch as
these additions.

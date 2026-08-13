# QoL Tier 0 Implementation — 2026-08-13

Implements items **1, 3, 4, 5** of Tier 0 and **#8 (reusable TMs)** from
`QOL_IDEAS_2026-08.md`. Base: `9238ce2` ("few sprite updates"). Everything below
assembles cleanly (release + debug) and passes the full battle harness:
**230/230 YAML cases and 841/841 in `make test-all`** (every move executed, every
effect scenario) on the modified ROM.

---

## #1 — Trainer Pokémon can now have a chosen ability

New party format bit: `TRAINERTYPE_ABILITY` (bit 2), with the convenience combo
`TRAINERTYPE_ITEM_MOVES_ABILITY`. The ability byte goes **after the item, before
the moves**:

```asm
	db "FALKNER@", TRAINERTYPE_ITEM_MOVES_ABILITY
	db 63
	dw SKARMORY
	db NO_ITEM
	db ABILITY_2          ; or ABILITY_1 / HIDDEN_ABILITY
	dw SPIKES, DRILL_PECK, MUD_SLAP, STEEL_WING
```

- `engine/battle/read_trainer_party.asm` parses the byte and writes it into the
  OT mon's personality (masked with `ABILITY_MASK`, other bits preserved), which
  `LoadEnemyMon` → `SetEnemyAbility` already reads.
- Fully opt-in: every existing `TRAINERTYPE_*` entry is byte-for-byte unchanged.
  No party data was converted — that's your call per trainer.
- `tools/audit_trainers.py` understands the new type: it validates the ability
  byte is one of the three constants and counts it in the record-length check.
  (Verified by temporarily converting FALKNER1 — audit and build both green —
  then reverting.)

## #3 — Type chart brought to Gen 6

Removed `GHOST → STEEL` and `DARK → STEEL` not-very-effective entries in
`data/types/type_matchups.asm` (absence = neutral). Matches the Fairy-era chart
you already use everywhere else.

## #4 — New AI layer: ability & held-item awareness (`AI_Abilities`)

New scoring layer at flag bit 10 (`AI_ABILITIES` in
`constants/trainer_data_constants.asm`, pointer slot in `engine/battle/ai/move.asm`).
Granted to **all 48 trainer classes that have `AI_SMART`** in
`data/trainers/attributes.asm` — route-trainer classes stay dumb. What it does:

- **Nullified damaging moves are dismissed** (+30 → the same 50+ threshold the
  universal KO layer already skips). It reuses `AIDamageCalc`, i.e. the real
  damage formula, so this covers Levitate, Flash Fire, Water/Volt Absorb, Dry
  Skin, Sap Sipper, Lightning Rod, Storm Drain, Motor Drive, Soundproof,
  Bulletproof, Wind Rider, **Air Balloon and Disguise** — and automatically
  respects Mold Breaker and Neutralizing Gas.
- **Damp**: self-KO moves are dismissed when the player's effective ability is
  Damp (skipped if the AI mon has Mold Breaker).
- **Choice lock**: while `wEnemyChoiceLockedMove` is set, every other move is
  dismissed so scoring agrees with the lock the engine already enforces.
- **Magic Bounce**: status moves aimed at the player (status ailments,
  stat drops, Leech Seed, Mean Look, Swagger — plus the three hazards) are
  discouraged (+10).
- **Substitute**: direct status/stat-drop moves are discouraged while the
  player is behind a sub (hazards intentionally still allowed).
- **Contact punishment**: contact moves get a mild +2 when the player has
  Rocky Helmet, Iron Barbs, Tangling Hair, Perish Body — or Static / Flame
  Body / Poison Point / Effect Spore / Cute Charm while the AI mon is
  status-free.

Supporting refactor: `CheckContactMove` in `engine/battle/abilities_engine.asm`
now wraps a new `CheckContactMoveID::` (move ID in `c`) so the AI can test
contact for moves that aren't currently executing. All 841 harness tests
(including every Rocky Helmet / contact-ability case) pass on the refactor.

## #5 — AI_Smart entries for the modern move effects (15 new)

Added to the `AI_Smart` dispatch table in `engine/battle/ai/scoring.asm`:

| Effect | Behavior |
|---|---|
| `EFFECT_SPIKES` / `EFFECT_TOXIC_SPIKES` / `EFFECT_STEALTH_ROCK` | Greatly encouraged on the AI's first two turns if the player has 2+ mons; **dismissed once already up** (T-Spikes: both layers) or vs the player's last mon |
| `EFFECT_DEFOG` | Encouraged when the AI's side has hazards or the player has screens; discouraged when it would only clear the AI's own hazards off the player's side |
| `EFFECT_U_TURN` (U-turn / Volt Switch / Flip Turn) | Encouraged below half HP when a teammate remains |
| `EFFECT_TRICK_ROOM` | Encouraged when slower; dismissed when faster or when it would toggle its own Trick Room off |
| `EFFECT_KNOCK_OFF` | Encouraged when the player holds an item |
| `EFFECT_FOUL_PLAY` | Encouraged when the player's Attack is boosted |
| `EFFECT_FREEZE_DRY` | Encouraged vs Water-types (AI_Types can't know the override) |
| `EFFECT_FAKE_OUT` | Encouraged turn 1, dismissed afterwards |
| `EFFECT_VENOSHOCK` / `EFFECT_HEX` | Encouraged when the player is poisoned / statused |
| `EFFECT_FACADE` | Encouraged while the AI mon is burned/poisoned/paralyzed |
| `EFFECT_CIRCLE_THROW` (+ Dragon Tail) | Encouraged when hazards are on the player's side |
| `EFFECT_ROOST` | Mapped to the existing `AI_Smart_Heal` logic |

Setup moves (Shell Smash, Nasty Plot via `SP_ATK_UP_2`, Calm Mind, DD, Quiver
Dance...) were already covered by `AI_Setup`'s `.SetupEffects` list, so they
were left alone.

New constant: `SCREENS_HAZARDS_MASK` in `constants/battle_constants.asm`.

## #8 — Reusable TMs

Removed the `call ConsumeTM` in `engine/items/tmhm.asm` (HMs were already
exempt). The `ConsumeTM` routine itself is kept (unreferenced) in case you ever
want a consumable item to use it. Buying/selling and the quantity display are
untouched — quantities just never go down from teaching.

## Bonus fix — clean builds were broken

`gfx/trainer_card/kanto_leaders.png` had 101 stray pixels at gray value 5
(vs. pure black), which makes `rgbgfx` fail with "Too many colors" on any
clean build (your local build only works because the old `.2bpp` is cached).
Snapped them to the 4-shade palette; the PNG is visually identical.

---

## Files changed

| File | Change |
|---|---|
| `constants/trainer_data_constants.asm` | `TRAINERTYPE_ABILITY(_F)`, `TRAINERTYPE_ITEM_MOVES_ABILITY`, `AI_ABILITIES` flag |
| `constants/battle_constants.asm` | `SCREENS_HAZARDS_MASK` |
| `engine/battle/read_trainer_party.asm` | Parse ability byte into OT personality |
| `data/trainers/parties.asm` | Header comment documents the new format (no data changed) |
| `data/trainers/attributes.asm` | `AI_ABILITIES` added to every `AI_SMART` class |
| `data/types/type_matchups.asm` | Ghost/Dark → Steel now neutral |
| `engine/battle/ai/move.asm` | `AI_Abilities` in `AIScoringPointers` slot 10 |
| `engine/battle/ai/scoring.asm` | `AI_Abilities` layer + 15 `AI_Smart` handlers + 2 effect lists |
| `engine/battle/abilities_engine.asm` | `CheckContactMoveID::` refactor |
| `engine/items/tmhm.asm` | TMs no longer consumed |
| `tools/audit_trainers.py` | Validates the new trainer type / ability byte |
| `gfx/trainer_card/kanto_leaders.png` | 4-color palette fix for clean builds |

## Verification

- Release + debug ROMs assemble with rgbds 0.5.2, zero warnings.
- `make test` → 230/230; `make test-all` → 841/841 (PyBoy + MBC30 patch).
- `tools/audit_trainers.py` and `tools/audit_game_data.py` report the exact
  same pre-existing findings before and after (no regressions; note the four
  Battle Tower SKARMORY stat errors and two rematch-tier level findings were
  already there).
- ROM boots to the title menu in the emulator.

## What's deliberately NOT done

- No trainer parties were given abilities yet — the format is ready; opt in
  per trainer (leaders / E4 / rivals) as you write teams.
- Wild hidden abilities (Tier 0 #2) untouched, as requested.
- AI switch logic (`switch.asm`) is still ability-blind; the new layer only
  covers move scoring. Worth a follow-up if leaders feel too passive about
  bad matchups.

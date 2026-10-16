# Luminescent 3.0 generators

Two scripts, same approach and shared download cache:

- `gen_learnsets.py` — rewrites level-up learnsets (see below).
- `gen_types.py` — copies Luminescent's **types** onto your Pokemon by
  rewriting the `db TYPE1, TYPE2 ; type` line in every
  `data/pokemon/base_stats/*.asm`. Species/forms in Luminescent use its
  PersonalTable typing; anything not in Luminescent falls back to PokeAPI;
  fakemon (Watu, Mesmeria) are left unchanged. Run it the same way:

  ```bash
  python3 tools/lumi_learnsets/gen_types.py --dry-run   # shows every X/Y -> X/Y change
  python3 tools/lumi_learnsets/gen_types.py             # apply
  ```

  The dry run prints every type change (`bulbasaur: GRASS/POISON -> ...`), so
  skim a few known Pokemon to confirm nothing looks shifted before applying.

---

# Luminescent 3.0 learnset generator

Rebuilds every level-up learnset in

    data/pokemon/evos_attacks_kanto.asm
    data/pokemon/evos_attacks_johto.asm
    data/pokemon/evos_attacks_clones.asm

to match **Pokemon Luminescent Platinum 3.0 (Re:Illuminated)**, using only the
moves that exist in this ROM. Evolutions are never touched — only the
`dbw level, MOVE` lines are replaced.

## How each Pokemon is handled

1. **In Luminescent** (all Gen 1–4 base forms + the regional forms Luminescent
   added) → uses Luminescent 3.0's exact learnset (`WazaOboeTable`).
2. **Not in Luminescent** (Gen 5–9 lines, evolved regional-only mons like
   Perrserker/Clodsire/Kleavor, etc.) → uses the canonical level-up learnset
   from the newest mainline game it appears in (via PokeAPI).
3. **Fakemon** (Watu, Mesmeria) → hand-authored learnsets that fit
   their types/stats (see `FAKEMON_OVERRIDES` in the script).

Moves that don't exist in `constants/move_constants.asm` are dropped
automatically. The Bloodmoon forms map to their real data
(`ursaluna-bloodmoon`; the custom Teddiursa/Ursaring Bloodmoon pre-evos reuse
the normal Teddiursa/Ursaring learnsets), and Dudunsparce uses its two-segment
form for the PokeAPI fallback.

## Running it

From the repo root, in WSL (needs internet on the first run):

```bash
# 1. Preview only — writes nothing, prints a full report:
python3 tools/lumi_learnsets/gen_learnsets.py --dry-run

# 2. Apply the changes:
python3 tools/lumi_learnsets/gen_learnsets.py

# Offline re-run (uses tools/lumi_learnsets/cache/):
python3 tools/lumi_learnsets/gen_learnsets.py --no-net

# Also add canonical level-up moves missing from Luminescent's data:
python3 tools/lumi_learnsets/gen_learnsets.py --canonical-union
```

`--canonical-union` keeps each Luminescent learnset as the base, then adds any
move from that Pokemon's newest canonical level-up learnset that is absent.
Supreme Silver's deliberate additions (including signature, legacy, and custom
move availability) are layered on last. Cached PokeAPI responses are ignored by
Git so the offline cache does not bloat the repository.

**Do a `--dry-run` first.** The summary at the end lists:

- how many mons came from Luminescent / PokeAPI / overrides,
- any mon **left unchanged** (no data found — e.g. an unspotted fakemon),
- any **moves dropped** because this ROM has no equivalent,
- any **mapped constant not found** in `move_constants.asm` (a mapping bug to fix),
- parse errors.

If the "left unchanged" or "constant not found" lists have surprises, tweak the
`SPECIAL_SLUG`, `FAKEMON_OVERRIDES`, or `MOVE_MAP` tables near the top of the
script and re-run.

It's a good idea to commit (or back up) the three `.asm` files before applying,
so you can `git diff` the result.

## After applying

Rebuild the ROM as usual (`make`). Nothing else references these files
differently, so no other changes are needed.

Breeding curation is applied after the source and project additions. The
checked-in `tools/testdata/breeding_moves.json` keeps modern natural level-up
overlaps, removes added egg-only copies with independent donor routes, and
retains fallback levels where this roster cannot supply a move by breeding.
Newly repaired fallback gaps are level 30 on the first stage. The egg tutor
remains available for the whole family. Regeneration preserves these decisions.

Validate donor chains, genders, egg groups, evolution carryover and compiled
inheritance behavior after changing the roster or moves:

```bash
python3 tools/audit_learnset_variety.py
make test-learnsets BATTLE_TEST_PYTHON=.venv/bin/python
```

The donor audit excludes the egg tutor as a source, includes real Sketch
bridges, and starts with natural moves before following breeding chains. This
prevents two egg lists from falsely proving each other's availability. The
receipt includes a donor proof for every removed level-up entry.

## Canonical coverage through Scarlet/Violet

`tools/testdata/canonical_learnsets.json` records the later full-roster audit,
including the nine clone mirrors and the normal-species proxies used by custom
Bloodmoon pre-evolutions. Its natural level placements are layered on after
breeding curation, so regeneration preserves them. Canonical egg additions live
in the root egg lists; current machines retain real compatibility flags.
The Goldenrod tutor retains its original five utility moves. Selected machine/tutor candidates
use explicitly custom thematic level placements, recorded with their reasons
in `changes.thematic_level_up`. Breeding-eligible moves remain in the canonical
family egg lists, with independent donor proofs and level-30 fallbacks where
the limited roster otherwise cannot supply a move. Existing authored removals
are respected; the user-approved Body Press overlap is recorded explicitly.

Historical compatibility alone does not imply a natural level-up move. All
remaining verified moves are taught by the existing purple Blackthorn tutor
in the Move Deleter's House, alongside its family egg moves, for ¥5,000.
`tools/restore_blackthorn_move_access.py` generates the species-specific
fallback table in `data/pokemon/technical_tutor.asm` without changing natural
or breeding placements. There are zero deferred implemented moves. The audit
enforces complete coverage and protects every previously expanded move pool
against accidental trimming. Regeneration preserves both sourced natural
placements and the selected thematic levels.

The canonical reference is Smogon's Pokémon Showdown data pinned to commit
`f7d73fdb20909885b70c4463f3878cf37875068d` (December 3, 2024), after the SV
DLC and before Legends: Z-A. Bulbapedia spot checks and exact source codes are
recorded in the receipt. The audit concerns individual historical move access,
not whether every four-move combination can transfer between official games.
Moves absent from the ROM and the six original custom species are recorded
separately rather than assigned fabricated canonical learnsets.

```bash
python3 tools/audit_canonical_learnsets.py  # complete offline receipt audit
python3 tools/audit_breeding_moves.py
make test-learnsets BATTLE_TEST_PYTHON=.venv/bin/python
```

For an independent source recheck, cache `data/learnsets.ts`, `data/pokedex.ts`
and `data/moves.ts` from the pinned Smogon commit in
`tools/lumi_learnsets/cache/smogon-sv/`, with the receipt's `source` object in
`source.json`, then run `python3 tools/audit_canonical_learnsets.py --reference`.
The downloads are ignored by Git; the checked-in receipt supports offline use.

## Data sources

Downloaded once into `cache/` from
`https://github.com/TeamLumi/luminescent-team` (`__gamedata/gamedata3.0/`):
`WazaOboeTable.json`, `moveEnum.json`, `PersonalTable.json`,
`english_ss_monsname.json`, `english_ss_zkn_form.json`. Canonical learnsets come
from `https://pokeapi.co`.

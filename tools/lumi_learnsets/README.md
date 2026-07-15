# Luminescent 3.0 generators

Two scripts, same approach and shared download cache:

- `gen_learnsets.py` — rewrites level-up learnsets (see below).
- `gen_types.py` — copies Luminescent's **types** onto your Pokemon by
  rewriting the `db TYPE1, TYPE2 ; type` line in every
  `data/pokemon/base_stats/*.asm`. Species/forms in Luminescent use its
  PersonalTable typing; anything not in Luminescent falls back to PokeAPI;
  fakemon (Watu, Orstryx, Mesmeria) are left unchanged. Run it the same way:

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
3. **Fakemon** (Watu, Orstryx, Mesmeria) → hand-authored learnsets that fit
   their types/stats (see `FAKEMON_OVERRIDES` in the script).

Moves that don't exist in `constants/move_constants.asm` are dropped
automatically. The Bloodmoon forms map to their real data
(`ursaluna-bloodmoon`; the custom Teddiursa/Ursaring Bloodmoon pre-evos reuse
the normal Teddiursa/Ursaring learnsets), and `Drunsparce` maps to Dudunsparce.

## Running it

From the repo root, in WSL (needs internet on the first run):

```bash
# 1. Preview only — writes nothing, prints a full report:
python3 tools/lumi_learnsets/gen_learnsets.py --dry-run

# 2. Apply the changes:
python3 tools/lumi_learnsets/gen_learnsets.py

# Offline re-run (uses tools/lumi_learnsets/cache/):
python3 tools/lumi_learnsets/gen_learnsets.py --no-net
```

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

## Data sources

Downloaded once into `cache/` from
`https://github.com/TeamLumi/luminescent-team` (`__gamedata/gamedata3.0/`):
`WazaOboeTable.json`, `moveEnum.json`, `PersonalTable.json`,
`english_ss_monsname.json`, `english_ss_zkn_form.json`. Canonical learnsets come
from `https://pokeapi.co`.

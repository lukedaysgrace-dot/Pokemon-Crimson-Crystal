# Crimson Crystal — Move Expansion Handoff

**Date:** 2026-07-27
**Purpose:** Everything needed to continue adding moves to Pokémon Crimson Crystal, including
a full inventory of moves portable from Johto Legends.

---

## 1. Project state (verified)

**Crimson Crystal** — `\\wsl.localhost\ubuntu\home\luke\romhacks\Pokemon-Crimson-Crystal`

| Fact | Value |
|---|---|
| Species | 501 (`NUM_POKEMON`), incl. Gen 4–9, regional forms, custom mons (Kotora/Raitora/Gorotora, Mesmeria, Watu) |
| Moves | ~370 defined in `constants/move_constants.asm` |
| Move cap | `$3fff` — no practical limit, tons of headroom |
| Phys/Special split | **Yes** — `CATEGORIZE_PHYSICAL / _SPECIAL / _STATUS` is the 4th arg of the `move` macro |
| Abilities | 156 (`NUM_ABILITIES`) incl. Sheer Force, Sharpness, Strong Jaw, Iron Fist, Mega Launcher, Triage, Supreme Overlord |
| Move effects | ~190 in `constants/move_effect_constants.asm` |

**Johto Legends (donor)** — `C:\Users\luked\Desktop\JohtoLegends-main`
Same pokecrystal base. ~437 moves. Its `data/moves/animations.asm` is ~6200 lines.

### The `move` macro (data/moves/moves.asm)

```
move: MACRO
    db \1 ; effect
    db \2 ; power
    db \3 ; type
    db \4 ; category (CATEGORIZE_*)
    db \5 percent ; accuracy
    db \6 ; pp
    db \7 percent ; effect chance
ENDM
```

---

## 2. KEY FINDING — graphics are already compatible

I diffed `gfx/battle_anims/` between both projects.

**Crimson Crystal is a strict superset of Johto Legends' animation graphics.** All 50 of JL's
PNGs exist in Crimson Crystal, which additionally has ~30 more (`aquajet`, `iciclecrash`,
`bugbuzz`, `petals`, `meteor`, `waterball`, `psystrike`, `hurricane`, `energyball`, `gyroball`,
`trickroom`, `uturn`, `voltswitch`, `bulkup`, `bigrings`, `bigwhip`, `smokepuff`, `stars`,
`hearts`, `tear`, `triangle`, `mushroom`, `objects2`, `beamaurora`, `beamsolar`, `hit2`,
`glow_shadow`, `midglowclear`, `rings`).

Only `pokeball_background.png` appears in JL and not in Crimson's `battle_anims` folder — it is
an intro/throw asset, irrelevant to move animations.

**Consequence: porting JL animations requires ZERO new artwork.**

### The only real friction

Anim scripts reference `ANIM_OBJ_*` and `ANIM_GFX_*` constants from
`constants/battle_anim_constants.asm`. **Those indices differ between the two hacks.** For each
ported script you must:

1. Copy the `BattleAnim_<Name>:` block from JL's `data/moves/animations.asm`.
2. For every `anim_obj ANIM_OBJ_X` / `anim_1gfx ANIM_GFX_Y` referenced, confirm the constant
   exists in Crimson's `battle_anim_constants.asm`.
3. If a constant is missing, add it **and** its corresponding entry in the anim object table
   (`data/moves/animation_objects.asm` or equivalent) + frameset/oam pointers. The underlying
   PNG is already present.
4. Watch for JL-only sound effects (`anim_sound ... SFX_*`) — swap to a Crimson equivalent if
   the SFX constant doesn't exist.

---

## 3. Files to touch for EVERY new move

- [ ] `constants/move_constants.asm` — add `const MOVE_NAME` before `NUM_ATTACKS`
- [ ] `data/moves/moves.asm` — add `move` entry **in the same order**
- [ ] `data/moves/names.asm` — add name **in the same order**
- [ ] `data/moves/descriptions.asm` — add description text + pointer
- [ ] `data/moves/animations.asm` (+ `animations2/3/4.asm`) — add anim script + pointer
- [ ] `constants/move_effect_constants.asm` — only if a **new** effect is needed
- [ ] `data/moves/effects_pointers.asm` + `data/moves/effects.asm` — only if new effect
- [ ] Flag tables as applicable: `contact_moves.asm`, `critical_hit_moves.asm`,
      `punching_moves.asm`, `sound_moves.asm`, `substitute_moves.asm`,
      `metronome_exception_moves.asm`, `data/abilities/sheer_force_moves.asm`
- [ ] AI tables: `data/battle/ai/useful_moves.asm`, `residual_moves.asm`, `encore_moves.asm`,
      `stall_moves.asm`, weather move lists
- [ ] Distribution: `data/pokemon/evos_attacks.asm` (level-up), `egg_moves*.asm`,
      `data/moves/tmhm_moves.asm` + TM item constants, move tutor lists

**Order matters.** The move constant index, `moves.asm` row, `names.asm` row, and description
pointer must all line up or everything shifts.

---

## 4. TIER 1 — one-line adds, reuse an effect you already have

No new engine code. Just macro entry + name + description + animation.

| Move | Type / Cat / Pwr / Acc / PP | Reuse effect | Anim in JL? | Targets in your dex |
|---|---|---|---|---|
| **Overheat** | Fire / Spc / 130 / 90 / 5 | `EFFECT_DRACO_METEOR` | ✗ (reskin Draco Meteor) | Chandelure, Camerupt, Salazzle, Magmortar, Centiskorch, Torkoal, Typhlosion |
| **Leaf Storm** | Grass / Spc / 130 / 90 / 5 | `EFFECT_DRACO_METEOR` | ✗ (reskin, or JL Frenzy Plant / Petal Blizzard) | Tangrowth, Ludicolo, Appletun, Cradily, Breloom, Leafeon |
| **Fake Out** | Normal / Phys / 40 / 100 / 10 | `EFFECT_FAKE_OUT` — **already defined and UNUSED** | ✓ `BattleAnim_FakeOut` (L4359) | Ambipom, Lopunny, Weavile, Persian, Scrafty |
| **Flip Turn** | Water / Phys / 60 / 100 / 20 | `EFFECT_U_TURN` | ✗ (reuse your `uturn.png` anim) | Milotic, Golisopod, Lanturn, Feebas |
| **Wood Hammer** | Grass / Phys / 120 / 100 / 15 | `EFFECT_RECOIL_HIT` | ✓ `BattleAnim_WoodHammer` (L4052) | Breloom, Tsareena, Ludicolo, Leafeon |
| **Head Smash** | Rock / Phys / 150 / 80 / 5 | `EFFECT_RECOIL_HIT` | ✓ `BattleAnim_HeadSmash` (L2476) | Rampardos (**Rock Head**), Archeops, Aggron |
| **Iron Defense** | Steel / Status / — / — / 15 | `EFFECT_DEFENSE_UP_2` | ✓ `BattleAnim_IronDefense` (L3098) | Corviknight, Aggron, Bastiodon, Archaludon, Excadrill |
| **Discharge** | Electric / Spc / 80 / 100 / 15 | `EFFECT_PARALYZE_HIT` (30%) | ✓ `BattleAnim_Discharge` (L1515) | Magnezone, Electivire, Vikavolt, Lanturn, Raichu-A |
| **Lava Plume** | Fire / Spc / 80 / 100 / 15 | `EFFECT_BURN_HIT` (30%) | ✓ `BattleAnim_LavaPlume` (L3599) | Torkoal, Camerupt, Magcargo |
| **Sludge Wave** | Poison / Spc / 95 / 100 / 10 | `EFFECT_POISON_HIT` (10%) | ✓ `BattleAnim_SludgeWave` (L3503) | Toxapex, Salazzle, Glimmora, Muk-A, Scolipede |
| **Drill Run** | Ground / Phys / 80 / 95 / 10 | plain + `critical_hit_moves` | ✓ `BattleAnim_DrillRun` (L2624) | Excadrill, Rhyperior, Sandslash, Golisopod |
| **Psycho Cut** | Psychic / Phys / 70 / 100 / 20 | plain + `critical_hit_moves` | ✓ `BattleAnim_PsychoCut` (L6150) | Gallade, Kirlia — also feeds **Sharpness** |
| **Sacred Sword** | Fighting / Phys / 90 / 100 / 15 | plain (ignore-boosts optional) | ✓ `BattleAnim_SacredSword` (L1837) | Gallade, Kleavor, Bisharp line |
| **Dual Wingbeat** | Flying / Phys / 40×2 / 90 / 10 | `EFFECT_DOUBLE_HIT` | ✓ `BattleAnim_DualWingbeat` (L3664) | Corviknight, Noivern, Talonflame |
| **Bullet Seed** | Grass / Phys / 25 / 100 / 30 | `EFFECT_MULTI_HIT` | ✓ `BattleAnim_BulletSeed` (L5954) | Breloom, Skill Link users |
| **Superpower** | Fighting / Phys / 120 / 100 / 5 | `EFFECT_CLOSE_COMBAT` (or Atk/Def-down) | ✓ `BattleAnim_Superpower` (L6018) | Conkeldurr, Ursaring, Haxorus, Golisopod |
| **Scale Shot** | Dragon / Phys / 25 / 90 / 20 | `EFFECT_MULTI_HIT` | ✗ | Baxcalibur, Haxorus, Flapple |

**Overheat and Leaf Storm are the highest-value items on this table.** `EFFECT_DRACO_METEOR`
already exists and works; its two siblings being absent is the most conspicuous gap in the game.

---

## 5. TIER 2 — new effect required, highest impact per unit of work

| Move | Why | Implementation note | Anim in JL? |
|---|---|---|---|
| **Stealth Rock** | **Biggest single gap.** Spikes + Toxic Spikes both exist, so the hazard framework is already built and tested. | Model on `EFFECT_SPIKES`; needs type-chart lookup for damage-on-switch | ✗ — use Spikes anim + `rocks.png` |
| **Defog** | You have 2 hazard layers + screens and NO way to clear them off your own side (Rapid Spin/Mortal Spin only clear yours). | New effect; clears hazards both sides + drops evasion | ✗ — reuse Gust/Whirlwind |
| **Aurora Veil** | You have Hail, Snow Warning, Slush Rush, Ice Body, Snow Cloak, Abomasnow, Ninetales-A, Froslass, Walrein, Cetitan. **The entire snow package currently has no payoff.** | Reuse the Reflect/Light Screen timer + `reflect.png` | ✗ — reuse Reflect anim |
| **Quiver Dance** | You have **zero** setup move that raises SpA *and* Speed. Volcarona, Venomoth, Butterfree have nothing to do. | New effect, or chain SpA+SpD+Spe up | ✓ `BattleAnim_QuiverDance` (L5007) |
| **Body Press** | Pairs with Iron Defense above. Single-handedly makes Aggron, Bastiodon, Toxapex, Corviknight, Cursola viable. | Damage calc substitutes Def for Atk | ✗ — reuse JL Superpower/Brick Break |
| **Freeze-Dry** | Ice move that hits Water super-effectively. | Type-effectiveness override | ✗ — JL `FREEZE_GLARE`, or your Ice Beam |
| **Foul Play** | Uses target's Attack stat. | Damage calc reads opponent Atk | ✗ — your Faint Attack, or JL Payback |
| **Sticky Web** | Galvantula, Ariados, Joltik. | Hazard framework again | ✗ — **reuse your Spider Web anim** |
| **Tailwind** | Talonflame, Corviknight, Togekiss, Noivern. | Side-wide speed timer | ✗ — reuse Gust/Agility |

---

## 6. TIER 3 — signature moves for species already in your dex

| Move | For | Anim in JL? |
|---|---|---|
| **Shadow Bone** | Marowak-Alolan | ✓ `BattleAnim_ShadowBone` (L3423) |
| **Dire Claw** | Sneasler | ✓ `BattleAnim_DireClaw` (L6125) |
| **Headlong Rush** | Ursaluna, Ursaluna-BM | ✓ `BattleAnim_HeadlongRush` (L2478) |
| **Psyshield Bash** | Wyrdeer | ✓ `BattleAnim_Psyshield` (L2312) |
| **Dragon Darts** | Dragapult | ✗ — JL `TWIN_BEAM` or `DUAL_CHOP` |
| **Glaive Rush** | Baxcalibur | ✗ |
| **Baneful Bunker** | Toxapex | ✗ — reuse Protect |
| **Rage Fist** | Annihilape | ✗ — JL `RAGING_FURY` |
| **Armor Cannon** | Armarouge | ✗ — JL `ROCK_WRECKER` / `INFERNO` |
| **Fiery Dance** | Volcarona | ✗ — JL `FIERY_WRATH` |
| **Kowtow Cleave** | Kingambit | ✗ |
| **Infernal Parade** | Typhlosion-Hisuian | ✗ |
| **Barb Barrage** | Overqwil | ✗ |
| **Stone Axe** | Kleavor | ✗ — JL `STONE_BASH` |
| **Apple Acid / Grav Apple / Fickle Beam** | **Dipplin, Appletun, Flapple, Hydrapple** — all four in your dex with nothing mechanically distinguishing them | ✗ |

Already covered, do not re-add: Ceruledge has **Bitter Blade**, Tinkaton has **Gigaton Hammer**
(`GIGA_HAMMER`), Golisopod has **First Impression**, Glimmora has **Mortal Spin**.

---

## 7. FULL Johto Legends port inventory

Every move in JL that Crimson Crystal does **not** have. All have working animations in JL and
all required PNGs already exist in your repo.

### 7a. Verified animation labels (I grepped these — confirmed present)

```
BattleAnim_BrickBreak      L910     BattleAnim_ShadowBone      L3423
BattleAnim_Nuzzle          L1505    BattleAnim_SludgeWave      L3503
BattleAnim_Discharge       L1515    BattleAnim_LavaPlume       L3599
BattleAnim_SacredSword     L1837    BattleAnim_WorkUp          L3647
BattleAnim_Snarl           L2187    BattleAnim_DualWingbeat    L3664
BattleAnim_Psyshield       L2312    BattleAnim_WoodHammer      L4052
BattleAnim_HeadSmash       L2476    BattleAnim_PhantomForce    L4111
BattleAnim_HiHorsepower    L2477    BattleAnim_FakeOut         L4359
BattleAnim_HeadlongRush    L2478    BattleAnim_QuiverDance     L5007
BattleAnim_DrillRun        L2624    BattleAnim_StrengthSap     L5349
BattleAnim_MeteorMash      L2790    BattleAnim_BulletSeed      L5954
BattleAnim_IronDefense     L3098    BattleAnim_Superpower      L6018
BattleAnim_RockPolish      L3099    BattleAnim_CrossPoison     L6089
BattleAnim_Coil            L3183    BattleAnim_DireClaw        L6125
                                    BattleAnim_PsychoCut       L6150
```

> Note: `PhantomForce` has branch labels (`BattleAnim_PhantomForceBranch`,
> `...Branch2` at L4118/L4122) — port all three together.

### 7b. Full list of JL moves missing from Crimson Crystal

Grouped by usefulness. Animation labels for these are in JL's `data/moves/animations.asm`;
locate each with `grep -n "^BattleAnim_" data/moves/animations.asm`.

**High priority — real competitive/utility value**

```
QUIVER_DANCE      IRON_DEFENSE      ROCK_POLISH       COIL
WORK_UP           HOWL              COSMIC_POWER      STRENGTH_SAP
AQUA_RING         SUPERPOWER        HAMMER_ARM        BRICK_BREAK
CLOSE_COMBAT*     DRILL_RUN         HIHORSEPOWER      MUD_SHOT
PSYCHO_CUT        SACRED_SWORD      METEOR_MASH       SMART_STRIKE
DISCHARGE         LAVA_PLUME        HEAT_WAVE         MUDDY_WATER
SLUDGE_WAVE       CROSS_POISON      ACID_SPRAY        CLEAR_SMOG
WOOD_HAMMER       HEAD_SMASH        WAVE_CRASH        FLARE_BLITZ*
BULLET_SEED       GRASS_KNOT        DUAL_WINGBEAT     FAKE_OUT
SNARL             PAYBACK           KNOCK_OFF*        PHANTOM_FORCE
DRAGON_TAIL       CIRCLE_THROW      CHARGE_BEAM       NUZZLE
ROCK_TOMB         SAND_TOMB         LOW_SWEEP         REVENGE
FORCE_PALM        SKY_UPPERCUT      CHIP_AWAY         BOUNCE
FEATHERDANCE      METAL_SOUND       FLATTER           PLAY_NICE
ODOR_SLEUTH       GRASSWHISTLE      DOUBLE_HIT_M      DUAL_CHOP
CRUSH_CLAW        BLAZE_KICK        POISON_TAIL       NEEDLE_ARM
AIR_CUTTER        SILVER_WIND       OMINOUS_WIND      SIGNAL_BEAM
MAGICAL_LEAF      ECHOED_VOICE      ROUND_M           BELCH
POWERUPPUNCH      FLAME_BURST       MUD_BOMB          MIRROR_SHOT
INFERNO           PETAL_BLIZZ       SHEER_COLD        DRAGON_RUSH
ROCK_WRECKER      PSYCHO_BOOST      FRENZY_PLANT      BLAST_BURN
HYDRO_CANNON
```
*\* already in Crimson — listed only because JL's version/anim may differ.*

**Signature / legendary moves**

```
SHADOW_BONE       DIRE_CLAW         HEADLONGRUSH      PSYSHIELD
FREEZE_GLARE      FIERY_WRATH       SHELLSIDEARM      EERIE_SPELL
METEOASSAULT      RAGING_BULL       RAGING_FURY       STRANGESTEAM
TWIN_BEAM
```

**JL-custom moves (verify you want them — non-canonical)**

```
DRACO_FANG        STEEL_SLICE       STONE_BASH        THUNDER_KICK
PINCIRFLURRY      JURASSICBEAM      SIGNAL_WAVE       CATASTROPHE
INFERNABLAST
```

---

## 8. Reskin map — for moves NOT in Johto Legends

Every one of these can reuse an animation **you already have**, so no new art is needed:

| New move | Reskin from |
|---|---|
| Overheat | your Draco Meteor anim |
| Leaf Storm | your Draco Meteor anim, recolored green (or JL Frenzy Plant / Petal Blizzard) |
| Flip Turn | your U-turn anim (`uturn.png`) |
| Sticky Web | your Spider Web anim (`web.png`) |
| Stealth Rock | your Spikes anim + `rocks.png` |
| Aurora Veil | your Reflect / Light Screen anim (`reflect.png`) |
| Defog / Tailwind | your Gust or Whirlwind anim (`wind.png`, `wind_bg.png`) |
| Body Press | JL Superpower or Brick Break |
| Freeze-Dry | JL Freeze Glare, or your Ice Beam |
| Foul Play | your Faint Attack, or JL Payback |
| Baneful Bunker | your Protect anim |
| Dragon Darts | JL Twin Beam or Dual Chop |
| Rage Fist | JL Raging Fury |
| Fiery Dance | JL Fiery Wrath |
| Armor Cannon | JL Rock Wrecker or Inferno |
| Stone Axe | JL Stone Bash |
| Scale Shot | your Rock Blast / Icicle Spear multi-hit anim |
| Kowtow Cleave | your Night Slash anim |
| Apple Acid | your Acid anim; Grav Apple → Seed Bomb |

---

## 9. Ability synergy notes

These abilities exist and are under-served by the current movepool:

- **Sharpness** (Kleavor) — slicing moves. You have Night Slash, Leaf Blade, X-Scissor,
  Air Slash, Bitter Blade. Adding **Psycho Cut**, **Sacred Sword**, **Stone Axe**,
  **Kowtow Cleave** materially widens this.
- **Reckless** — recoil moves. Adding **Wood Hammer** and **Head Smash** doubles the pool.
  (`data/battle/ai/reckless_moves.asm` needs updating.)
- **Rock Head** (Rampardos) — currently has no elite recoil move to abuse. **Head Smash** is
  the whole point of the ability.
- **Skill Link** — multi-hit moves. **Bullet Seed** and **Scale Shot** are the missing pieces.
- **Iron Fist** — punching pool is fine (Bullet Punch, Pixie Punch, Shadow Punch, Drain Punch).
- **Strong Jaw** — fang pool is fine. Optional: Psychic Fangs, Jaw Lock.
- **Toxic Debris** (Glimmora) — works, since Toxic Spikes exists.
- **Sheer Force** — remember to add new secondary-effect moves to
  `data/abilities/sheer_force_moves.asm`.

---

## 10. Known structural gaps (design decisions, not bugs)

- **No terrain moves at all** — Electric/Grassy/Psychic/Misty Terrain are all absent. This is a
  legitimate design choice. But it is the prerequisite if you ever want Rising Voltage,
  Expanding Force, Grassy Glide, or Terrain Pulse.
- **No Stealth Rock** despite having both Spikes and Toxic Spikes.
- **No Aurora Veil** despite a fully built-out snow/hail package.
- **No SpA+Speed setup move** (Quiver Dance).
- `EFFECT_FAKE_OUT` is defined in `move_effect_constants.asm` but **no move uses it.**
- `EFFECT_UNUSED_25`, `_2B`, `_4E`, `_6E`, `_82`, `_83` are free effect slots.

---

## 11. Suggested execution order

1. **Batch A — free wins (no new effects, JL anims):** Fake Out, Iron Defense, Discharge,
   Lava Plume, Sludge Wave, Drill Run, Psycho Cut, Sacred Sword, Dual Wingbeat, Wood Hammer,
   Head Smash, Bullet Seed, Superpower. Do the `ANIM_OBJ_*` remapping once and it gets easier
   for every subsequent port.
2. **Batch B — reskins, no new effects:** Overheat, Leaf Storm, Flip Turn, Scale Shot.
3. **Batch C — new effects, high impact:** Stealth Rock, Defog, Aurora Veil, Quiver Dance,
   Body Press.
4. **Batch D — remaining new effects:** Freeze-Dry, Foul Play, Sticky Web, Tailwind.
5. **Batch E — signatures:** JL-available ones first (Shadow Bone, Dire Claw, Headlong Rush,
   Psyshield Bash), then the Applin family moves.
6. **Distribution pass:** wire everything into level-up learnsets, egg moves, TMs, and tutors.
   Easy to forget — a move nothing learns is invisible.
7. **AI pass:** add new moves to `data/battle/ai/useful_moves.asm` and friends, or the AI will
   undervalue them.

---

## 12. Build check

After each batch, rebuild and confirm the constant/data alignment held:

```bash
make clean && make
```

Misalignment between `move_constants.asm`, `moves.asm`, `names.asm`, and the description
pointer table is the #1 failure mode. Symptom: moves show wrong names/descriptions in-game
rather than a build error — so **test in-game, not just at compile time.**

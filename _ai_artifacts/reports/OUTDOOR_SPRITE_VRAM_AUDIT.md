# Outdoor sprite VRAM audit — all 26 map groups

Follow-up to `CERULEAN_SPRITE_BUG_HANDOFF.md`, item 4 ("Other groups may be near
the same cliff"). This audits every entry in `data/maps/outdoor_sprites.asm`
against the real `ArrangeUsedSprites` packing rules.

**Headline: no group currently overflows. Two groups sat at exactly 0 tiles of
margin (the same state Cerulean was in before it broke), and three groups have
actively-walking town NPCs stranded in the font-shared bank.**

> **Status: Cinnabar (group 6) and Silver (group 19) are FIXED** in
> `data/maps/outdoor_sprites.asm` — both now at 104/128 with 24 tiles of
> headroom, matching post-fix Cerulean. Findings 3–7 below are still open.
> **Not yet rebuilt/tested** (data-only change; just run your normal `make`).

---

## Correction to the previous handoff

The handoff assumed **Suicune is a 12-tile type-0 sprite**. It isn't.
`SPRITE_SUICUNE` ($ab) is >= `SPRITE_POKEMON` ($8a), so `GetMonSprite` returns
`MON_ICON_SPRITE` (type 3) and `GetSpriteLength` returns **8 tiles**. Same for
`SUDOWOODO`, `ENTEI`, `MACHOP`, `PIDGEY`, `GYARADOS`, `PERSIAN`, `CLEFAIRY`,
`HO_OH`, `MILTANK`, `SLOWPOKE`, `SLOWBRO_NPC`, `AMPY_SICK`, and both
`DAY_CARE_MON` slots when occupied.

This doesn't change the Cerulean fix (still correct), but it changes the budget
math, so the numbers below supersede the "228 tiles / 19 animated sprites"
figure in the old sheet.

## The actual packing rules (verified against code)

Sprites are added as: **player first** (`GetPlayerSprite`, `wUsedSprites + 0`),
then the 23-entry group list (`AddOutdoorSprites`), deduped, `SPRITE_NONE`
skipped. Then `SortUsedSprites` bubble-sorts **ascending by type**, stable
within a type — so *list order is packing priority within each type*.

Sort order is therefore:

| Order | Type | Tiles | Bank-1 limit |
|---|---|---|---|
| 1 | `WALKING_SPRITE` (1) | 12 | 116 (`WEATHER_TILE - $80`) |
| 2 | `STANDING_SPRITE` (2) | 12 | 116 |
| 3 | `MON_ICON_SPRITE` (3) | 8 | 116 |
| 4 | `STILL_SPRITE` (4) | 4 | 128 |
| 5 | `BIG_SPRITE` (5) | 12 | 128 |

Bank 1 holds 116 tiles for animated sprites (types 1–3) and the full 128 for
static ones (types 4–5). Bank 0 holds 128 tiles for everything that overflows,
and its step/facing frames share VRAM with the overworld font. Anything that
fits neither bank keeps its type byte (1–5) and `GetUsedSprites` skips it — the
object then renders tiles 1–5, i.e. **the player's tiles**.

Consequence: **bank 1 fits the player + 8 more 12-tile animated sprites**
(9 × 12 = 108), then exactly one mon icon (108 + 8 = 116), then three still
sprites (116 → 128). Everything else goes to bank 0.

**No map in the repo uses `MAPCALLBACK_SPRITES`**, and outdoor maps do *not*
add their object-list sprites. So an outdoor map's sprite set is fully static:
player + group list. Nothing can push a group over at runtime except a variable
sprite resolving to a longer type, or a day-care slot being empty.

## What actually broke Cerulean (for the record)

Pre-fix Cerulean: A=19 animated 12-tile, M=2 mon icons, S=2 still, B=1 big.

- 9 animated → bank 1 (d = 108); 10 overflow → bank 0 = 120 tiles
- 1 mon icon → bank 1 (d = 116); 1 overflow → bank 0 = **128, exactly full**, `e = 0`
- 2 still → bank 1 (d = 124)
- `BIG_SNORLAX`: bank 1 needs 124 + 12 = 136 > 128 ✗; bank 0 hits the `e = 0`
  sentinel ✗ → **assignment failed → rendered as player tiles**

That matches the "unused filler; Big Snorlax did not fit this group's VRAM"
comment left in the fixed list. Post-fix Cerulean has **24 tiles of headroom**.

---

## Full results — bank 0 usage per group

`A` = 12-tile animated (walking + standing, incl. player) · `M` = 8-tile mon
icons · `S` = 4-tile still · `B` = 12-tile big.

| Group | Map group | A | M | S | B | Bank 0 used | Headroom |
|---|---|---|---|---|---|---|---|
| ~~Cinnabar~~ | 6 | ~~16~~ | 2 | 3 | 3 | ~~128 / 128~~ | ~~0~~ ⛔ |
| **Cinnabar** (fixed) | 6 | 14 | 2 | 3 | 3 | 104 / 128 | **24** ✅ |
| ~~Silver~~ | 19 | ~~16~~ | 2 | 3 | 3 | ~~128 / 128~~ | ~~0~~ ⛔ |
| **Silver** (fixed) | 19 | 14 | 2 | 3 | 3 | 104 / 128 | **24** ✅ |
| **Goldenrod** | 11 | 13–15 | 3–5 | 2 | 3 | 116–124 | **4–12** ⚠️ |
| Pallet | 13 | 15 | 2 | 4 | 3 | 120 | 8 ⚠️ |
| Pewter | 14 | 15 | 2 | 4 | 3 | 120 | 8 ⚠️ |
| Celadon | 21 | 15 | 2 | 4 | 3 | 120 | 8 ⚠️ |
| Saffron | 25 | 17 | 3 | 4 | 0 | 116 | 12 |
| Fuchsia | 17 | 14 | 3 | 4 | 3 | 116 | 12 |
| Azalea | 8 | 15 | 3 | 4 | 2 | 116 | 12 |
| Cianwood | 22 | 15 | 3 | 4 | 2 | 116 | 12 |
| Viridian | 23 | 14 | 2 | 5 | 3 | 112 | 16 |
| Indigo | 16 | 14 | 2 | 5 | 3 | 112 | 16 |
| New Bark | 24 | 14 | 2 | 5 | 3 | 112 | 16 |
| Blackthorn | 5 | 15 | 2 | 5 | 2 | 112 | 16 |
| Vermilion | 12 | 13 | 3 | 5 | 3 | 108 | 20 |
| Ecruteak | 4 | 13 | 3 | 5 | 3 | 108 | 20 |
| Cherrygrove | 26 | 14 | 3 | 5 | 2 | 108 | 20 |
| Olivine | 1 | 14 | 3 | 5 | 2 | 108 | 20 |
| Lake of Rage | 9 | 15 | 3 | 5 | 1 | 108 | 20 |
| Mahogany | 2 | 16 | 3 | 5 | 0 | 108 | 20 |
| Dungeons | 3 | 14 | 3 | 5 | 2 | 108 | 20 |
| Violet | 10 | 17 | 1 | 3 | 1 | 108 | 20 |
| **Cerulean** | 7 | 17 | 2 | 2 | 0 | 104 | **24** ✅ (fixed) |
| Fast Ship | 15 | 12 | 4 | 5 | 3 | 104 | 24 |
| Lavender | 18 | 12 | 3 | 5 | 3 | 96 | 32 |
| Cable Club | 20 | — | — | — | — | n/a | see note |

Goldenrod's range is because `DAY_CARE_MON_1` / `DAY_CARE_MON_2` cost **8 tiles
when a mon is deposited** but fall through `GetMonSprite.NoBreedmon` to
`SPRITE_GOLD` (**12 tiles, WALKING**) when the slot is empty. Empty day care =
worst case = 4 tiles of margin.

---

## Findings, ranked

### 1. Cinnabar group (map group 6) — zero margin ⛔ → FIXED ✅

Maps: Route 19, Route 20, Route 21, Cinnabar Island.

Bank 0 is packed to exactly 128/128, ending with `BIG_SNORLAX` at $F4 and the
`e = 0` "bank full" sentinel set. This is byte-for-byte the state Cerulean was
in. It doesn't fail *today* only because nothing comes after `BIG_SNORLAX` in
the sort order — add one sprite of any size to this group and it, or the big
sprite, renders as the player.

It also has by far the worst dead-weight ratio in the game. The four outdoor
maps in the group only ever use `SWIMMER_GIRL`, `SWIMMER_GUY`, `FISHER`,
`BLUE`, `BLUE_CLOAK`, `GREEN`. Unused by any outdoor map in the group:

- `NURSE`, `OLD_LINK_RECEPTIONIST` — indoor-only, exactly the Cerulean case (24 tiles)
- `BIG_LAPRAS`, `BIG_ONIX`, `BIG_SNORLAX` — 36 tiles, none appear on Routes 19/20/21 or Cinnabar Island
- `WILL`, `KAREN`, `TEACHER`, `YOUNGSTER`, `GRAMPS`, `BUG_CATCHER`, `COOLTRAINER_F`, `SUDOWOODO`

**Second problem, same group:** `SWIMMER_GIRL` and `SWIMMER_GUY` are dead last
in the list, so both land in bank 0 — and every swimmer on Routes 19/20/21 is
`SPRITEMOVEDATA_SPINRANDOM_FAST`, i.e. animating continuously. These are the
*only* NPCs on those maps and they're the ones fighting the font. Expect
Cerulean-style letter flicker on the Route 20 / Cinnabar Island map-name banner
and in textboxes.

**Fix applied** (data-only, same shape as the Cerulean fix): dropped `NURSE` +
`OLD_LINK_RECEPTIONIST` → 24 tiles freed, bank 0 now 104/128. Walkers reordered
so bank 1 holds player + `SWIMMER_GIRL`, `SWIMMER_GUY`, `FISHER`, `BLUE_CLOAK`,
`GREEN`, `BLUE`, `TEACHER`, `YOUNGSTER` — i.e. **every sprite these four maps
actually use is now in bank 1**. Bank 0 gets only `GRAMPS`, `BUG_CATCHER`,
`COOLTRAINER_F`, `WILL`, `KAREN`, none of which appear outdoors in this group.

Test: ride the Route 20 currents past the swimmers while the map-name banner is
up, surf Route 19/21 with a textbox open, and check Blue/Blue Cloak on Cinnabar
Island.

### 2. Silver group (map group 19) — zero margin ⛔ → FIXED ✅

Maps: Route 28, Silver Cave Outside.

Identical profile to Cinnabar: 128/128, ends on `BIG_SNORLAX`. Flicker risk is
low (the only outdoor objects are `AGATHA` and `LORELEI`, both
`SPRITEMOVEDATA_STANDING_DOWN`, and both sort into bank 1 anyway) — but the
overflow margin was zero, and this group carries `NURSE`,
`OLD_LINK_RECEPTIONIST`, `SUDOWOODO`, `BIG_LAPRAS`, `BIG_ONIX`, `BIG_SNORLAX`,
`MONSTER` for four maps that use two sprites.

**Fix applied:** dropped `NURSE` + `OLD_LINK_RECEPTIONIST` → 24 tiles freed,
bank 0 now 104/128. No reorder needed — `AGATHA` and `LORELEI` were already
first among the walkers, so they keep bank 1. Plenty of slack still available
here (the three `BIG_*` sprites and `MONSTER` look unused) if a future edit
needs it.

Test: walk into Silver Cave Outside and talk to Agatha/Lorelei; cross Route 28.

### 3. Goldenrod group (map group 11) — 4 tiles worst case ⚠️

Maps: Route 34, Goldenrod City.

Margin drops to 4 tiles when both day-care slots are empty (each empty slot
costs 12 tiles instead of 8). Still fits, but it's the tightest dynamic case in
the game and the only group whose budget *changes during play*. Worth 12 tiles
of slack so the day care can never matter — `SLOWPOKE` and one of the
`BIG_*` sprites are the obvious candidates to check against actual usage.

### 4. Saffron group (map group 25) — flicker, not overflow ⚠️

Margin is fine (12 tiles), but the walker ordering is backwards in the same way
Cerulean's was. Bank 1 gets `HIKER`, `BIRD_KEEPER_NEW`, `PICNICKER_NEW`,
`CAMPER_NEW`, `COOLTRAINER_M_NEW`, `COOLTRAINER_M`, `SUPER_NERD`,
`COOLTRAINER_F` — mostly route trainers that stand still until engaged. Bank 0
gets `FISHER`, `YOUNGSTER`, `LASS`, `POKEFAN_M`, `ROCKET`, `MISTY`.

Meanwhile Saffron City's actual constantly-stepping NPCs are:

- `LASS` — `WALK_LEFT_RIGHT` → **bank 0**
- `POKEFAN_M` — `WALK_LEFT_RIGHT` → **bank 0**
- `YOUNGSTER` ×2 — `WALK_UP_DOWN` and `WANDER` → **bank 0**
- `COOLTRAINER_M` / `COOLTRAINER_F` — `WALK_LEFT_RIGHT` → bank 1 ✅

Three of the four visibly-walking town NPCs are in the font-shared bank. Fix is
a pure reorder: promote `YOUNGSTER`, `LASS`, `POKEFAN_M` above the route
trainers.

### 5. Violet group (map group 10) — minor flicker ⚠️

Margin fine (20 tiles). Violet City's `LASS` is `SPRITEMOVEDATA_WANDER` and
sits in bank 0 (it's 10th in walking order); `FISHER` (`SPINRANDOM_SLOW`) is
also bank 0. `SUPER_NERD` (`WANDER`), `GRAMPS` (`WALK_LEFT_RIGHT`) and
`YOUNGSTER` are correctly in bank 1. Promoting `LASS` above `CRYSTAL` / `TWIN`
would close it out; low priority.

### 6. Pallet / Pewter / Celadon (groups 13, 14, 21) — 8 tiles ⚠️

Not broken and not currently at risk, but they're 8 tiles from the cliff and
all three carry `NURSE` + `OLD_LINK_RECEPTIONIST` (24 tiles of indoor-only
sprites). If you add any outdoor NPC to these groups, do the Cerulean removal
first.

### 7. Cable Club group (map group 20) — latent, unreachable

`CableClubGroupSprites` has only **11 entries**, but `AddOutdoorSprites` always
reads `MAX_OUTDOOR_SPRITES` (23). It would read 12 bytes past the end of the
list — and it's the last label in `outdoor_sprites.asm`, so those bytes are
whatever the assembler places next.

Harmless in practice: every map in group 20 (Pokécenter 2F, Trade Center,
Colosseum, Time Capsule, Mobile rooms) is indoor, so `CheckOutdoorMap` routes
them to `AddIndoorSprites` and `AddOutdoorSprites` never runs for this group.
Still worth padding to 23 with `SPRITE_NONE` so it can't bite later.

---

## Cheap standing rule for future edits

A group is safe if:

```
bank0 = 12*max(0, A-9) + 8*max(0, M-1) + 4*max(0, S-3) + 12*B   <=  128
```

...where `A` counts the player. Roughly: **17 animated 12-tile sprites is the
ceiling with no big sprites; 16 is the ceiling with three.** Adding a
`BIG_SPRITE` to a group with A >= 16 will break it.

And for flicker: **only the player + the first 8 `WALKING_SPRITE` entries in
list order get bank 1.** Order every group's list so the NPCs that visibly step
on screen come first.

## Nothing to do

Groups 2, 3, 4, 5, 9, 12, 15, 16, 17, 18, 22, 23, 24, 26 (Mahogany, Dungeons,
Ecruteak, Blackthorn, Lake of Rage, Vermilion, Fast Ship, Indigo, Fuchsia,
Lavender, Cianwood, Viridian, New Bark, Cherrygrove) all have >= 12 tiles of
headroom and no actively-walking town NPC stranded in bank 0.

## Files changed

- `data/maps/outdoor_sprites.asm` — `CinnabarGroupSprites` (removals +
  reorder), `SilverGroupSprites` (removals only). Both lists still exactly
  `MAX_OUTDOOR_SPRITES` (23) entries. Data-only; no code touched.

## Files inspected

- `data/maps/outdoor_sprites.asm` (all 26 groups)
- `data/sprites/sprites.asm` (per-sprite type + length)
- `constants/sprite_constants.asm`, `constants/sprite_data_constants.asm`
- `engine/overworld/overworld.asm` (`GetPlayerSprite`, `AddOutdoorSprites`,
  `LoadSpriteGFX`, `SortUsedSprites`, `ArrangeUsedSprites`, `GetSpriteLength`,
  `GetUsedSprites`, `GetMonSprite`, `ReloadBank0SpriteFacings`)
- `maps/Route19.asm`, `Route20.asm`, `Route21.asm`, `CinnabarIsland.asm`,
  `SilverCaveOutside.asm`, `SaffronCity.asm`, `VioletCity.asm` (movement types)

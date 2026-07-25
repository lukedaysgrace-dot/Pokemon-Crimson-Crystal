# Cerulean-area sprite corruption — diagnosis + fix applied + handoff

## Symptoms reported
1. NPCs around Cerulean / Route 9 sometimes render as the **player character**.
2. Walking NPCs **flicker with font letters** / distorted tiles while the player moves.
3. The "CERULEAN CITY" map-name banner shows **corrupted letters**.

## Root cause (confirmed in code)
All outdoor maps in map group 7 (Cerulean City, Routes 4/9/10N/24/25) load the
**entire** `CeruleanGroupSprites` list (23 entries) via `AddOutdoorSprites`
(`engine/overworld/overworld.asm:145`), regardless of which map you're on.

This hack's custom `ArrangeUsedSprites` (overworld.asm ~line 551) packs sprites
into two VRAM banks:

- **Bank 1**: animated sprites' first frames must end below `WEATHER_TILE - $80`
  = **116 tiles**. Player (12) + Suicune (12, type 0, always sorts first) + 7–8
  walkers fit here. Safe.
- **Bank 0**: 128 tiles, **but animated sprites' step/facing frames go at
  tile + $80, which is shared with the overworld font**
  (see `ReloadBank0SpriteFacings`, overworld.asm ~line 690: "Bank 0's second
  sprite table shares VRAM with the overworld font").
- Sprites that fit **neither** bank keep their type byte (1–5) as the tile id;
  the loader skips them and the on-map object renders tiles 1–5 = **the
  player's tiles** → symptom 1.

The group had **19 animated (12-tile) sprites = 228 first-frame tiles** against
116 + 128 = 244, i.e. bank 0 was packed to exactly 128/128. Any extra runtime
sprite (variable sprite, event NPC, bike sprite change, etc.) tipped entries
into "no bank" → player-tile fallback. Meanwhile every walker that landed in
bank 0 fights the font for VRAM → symptoms 2 and 3 (the map-name sign draws
with the overworld font exactly when you walk into town).

`SPRITE_NURSE` and `SPRITE_OLD_LINK_RECEPTIONIST` were in the outdoor group but
are only used by **indoor** maps — and indoor maps load their own sprites from
their object list (`AddIndoorSprites`). Pure waste: 24 tiles.

## Fix applied (data-only, `data/maps/outdoor_sprites.asm`)
- Removed `SPRITE_NURSE` + `SPRITE_OLD_LINK_RECEPTIONIST` → 24 tiles freed;
  bank 0 now has ~20 tiles headroom, so nothing should fail assignment
  (fixes symptom 1).
- Reordered walkers so the ones that actually step on screen get bank 1
  (bubble sort is stable within a type, so list order = packing priority):
  Cerulean City wanderers (COOLTRAINER_M, SUPER_NERD, FISHER, YOUNGSTER) and
  Route 9 trainers (PICNICKER_NEW, CAMPER_NEW, JUGGLER_NEW) first. This
  removes the letter-flicker for the maps where it was reported (fixes
  symptoms 2/3 on Cerulean City + Route 9).
- List stays at exactly 23 entries (`MAX_OUTDOOR_SPRITES`).

**Not yet rebuilt/tested** — rgbasm segfaults in my sandbox. Just run your
normal `make`; it's a data-only change. Test: enter Cerulean from Route 4 and
Route 9 with NPCs walking during the town sign, open a textbox while the
Super Nerd/Cooltrainer M wander, check the Route 4/25 Poké Ball items and
Route 9 trainers.

## Remaining risk / follow-ups for Opus 5 (if symptoms persist anywhere)
1. **Route 25 / Route 4 flicker**: their walkers (COSPLAYER, LASS,
   COOLTRAINER_M_NEW, MISTY, POKEFAN_M, BIRD_KEEPER_NEW, ROCKET) still live in
   bank 0. If they visibly step while a textbox/sign is up, they can flicker
   letters. Bank 1 only holds ~9 animated sprites, so this is a hard budget.
   Options, cheapest first:
   a. Audit those maps' `object_event` movement types — any NPC that never
      steps (STANDING_*, SPINRANDOM engaged rarely) is harmless in bank 0.
   b. Split the group's heaviest map out (e.g. give Route 25 its own
      MAPCALLBACK_SPRITES that swaps the list), or
   c. The real fix: make outdoor maps load only the sprites used by the
      current map + its connections (like `AddIndoorSprites` does), instead of
      the whole 23-entry group. Touch `AddOutdoorSprites`. Higher risk:
      connection scrolling relies on shared tiles across the group.
2. **Verify the exactly-full-bank sentinel**: `ArrangeUsedSprites` uses `e = 0`
   as "bank 0 exactly full"; the wrap logic (`jr nz, .next ; wrapped past $100`)
   is worth a unit look if failures still occur.
3. **If any NPC still turns into the player**, log `wUsedSprites` (32 pairs at
   that WRAM label) on the affected map: any entry whose second byte is 1–5
   after arrangement is a failed assignment — identify what pushed the count up
   (variable sprites / event flags on that map).
4. Other groups may be near the same cliff — same audit is cheap to repeat
   (KantoGroup lists with many `_NEW` walkers added).

## Files touched
- `data/maps/outdoor_sprites.asm` (CeruleanGroupSprites only)

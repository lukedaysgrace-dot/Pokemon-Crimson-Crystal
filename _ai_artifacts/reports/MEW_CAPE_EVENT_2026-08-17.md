# Route 25 cape: MEW event (replaces the post-Elite-Four CRYSTAL fight)

CRYSTAL's final battle no longer keys off `EVENT_BEAT_ELITE_FOUR`. It now keys
off `ENGINE_EARTHBADGE` (BLUE's GYM), which in GSC's ordering is *later* than
the Elite Four — so her level 66-70 cape team still lands at the right point.

## Beats

1. Beat BLUE. `specialphonecall SPECIALCALL_CRYSTAL_CAPE` fires; ELM rings as
   soon as the player is outdoors, saying CRYSTAL was looking for them and had
   found something on the CERULEAN coast.
2. Walk east past `x=44` on Route 25 (the only gap in the cliff line, so it
   can't be skipped). MEW fades in over the jetty, cries, drifts a lap, cries
   again, then wanders on `SPRITEMOVEDATA_WANDER` within a 3x3 box.
3. Step onto either end of the stone jetty. CRYSTAL appears at `48,7`, shocked,
   and challenges the player: winner earns the right to catch MEW.
4. Win → she stands aside and tells the player to go take it.
   Lose → the player whites out. MEW remains and the battle can be retried.
5. Talk to MEW → ordinary static-legendary encounter, level 60,
   `BATTLETYPE_FORCEITEM` (same as LUGIA / HO-OH / MEWTWO here).
   KO'ing it or running just leaves it drifting; only a capture removes it.
6. On capture, CRYSTAL says goodbye and walks off west. Cape is empty after.

## Event flags

| Flag | Meaning |
|---|---|
| `EVENT_ROUTE_25_MEW` | MEW's object visibility |
| `EVENT_ROUTE_25_MEW_APPEARED` | intro cutscene has played |
| `EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` | player won the battle (existing flag) |
| `EVENT_CRYSTAL_CAUGHT_MEW` | legacy loss flag; cleared on Route 25 to repair older saves |
| `EVENT_ROUTE_25_CAUGHT_MEW` | player caught MEW |
| `EVENT_ROUTE_25_CRYSTAL_LEFT` | CRYSTAL has walked off |

## Three things that are easy to get wrong here

- **Object event flags read as VISIBLE until set.** A fresh save would put MEW
  and CRYSTAL on the cape from the start, so `Route25_MapScripts.Objects`
  re-derives both objects' visibility from the event state on every map load
  rather than trusting the flags.
- **Losing whites the player out mid-script.** The battle does not change any
  progression flags before `startbattle`, so a loss leaves MEW available and
  the CRYSTAL fight retryable. The loss branch skips `EVENT_BEAT_CRYSTAL_*`;
  that flag is set only after a win and before `reloadmapafterbattle`, because
  the reload re-runs the visibility callback and would otherwise hide CRYSTAL
  before her victory line.
- **A wild battle reports `WIN` whether the mon was caught or KO'd.** New
  special `CheckCaughtMew` (`engine/events/specials.asm`) reads MEW's #DEX
  caught flag so "caught it" can be told apart from "KO'd it / ran".

## Sprite VRAM

`SPRITE_MEW` uses the existing `gfx/sprites/mew.png` (16x96, 4 greys, a normal
6-frame walker) at `PAL_OW_PINK`.

`MAX_OUTDOOR_SPRITES` is 23 and `CeruleanGroupSprites` was full, so
`SPRITE_SUICUNE` and `SPRITE_POKEDEX` were dropped — neither is used by any
outdoor map in the group (Routes 4 / 9 / 10 North / 24 / 25, Cerulean City).
`SPRITE_MEW` is listed first so its constantly-animating step frames land in
VRAM bank 1 instead of the font-shared bank 0.

Group goes from **116/128 bank 0 (12 free)** to **120/128 (8 free)** — same
margin as the Pallet / Pewter / Celadon groups.

## Checkers

- `_ai_artifacts/check_outdoor_vram.py` — re-implements `ArrangeUsedSprites`
  and reports bank 0 headroom for all 26 groups. Agrees with
  `reports/OUTDOOR_SPRITE_VRAM_AUDIT.md` on every group except Cerulean, where
  the audit predates `SPRITE_CRYSTAL` being added and is stale by one walker.
- `_ai_artifacts/check_mew_event.py` — 142 static checks: label resolution,
  constant existence, declared-vs-actual event counts, tile collision under
  every coord/object event, MEW's wander box, CRYSTAL's exit path, and text
  line widths (counting `#` as the 4-wide POKe glyph).

## WRAM bank 1 overflow (pre-existing, fixed here)

The first `make` after this change died with:

    pokecrystal.link(310): Sections would extend past the end of WRAMX ($e002 > $dfff)

That is **not** caused by this event. `wEventFlags` is `flag_array NUM_EVENTS`,
i.e. `(NUM_EVENTS + 7) / 8` bytes: 2066 events and 2071 events both round to 259
bytes, so the five new flags cost zero. Confirmed by assembling `wram.asm` with
every constant added here reverted — still 4098 bytes in a 4096-byte bank.
WRAMX 1 was already packed to exactly `$dfff` in the last shipped build
(`wGameDataEnd` = `$dfff`, zero slack), so whatever landed before this went in
pushed it 2 bytes over.

Fixed by reclaiming the 4 unused padding bytes between `wXYComparePointer` and
`wBattleScriptFlags`. Those sit **before** `wGameData`, so only pre-save scratch
moves: every offset inside `wGameData` and `wPokemonData` is byte-identical, and
existing `.sav` files still load. Bank 1 now sits at **4094/4096**.

(For future headroom: `NUM_EVENTS` is 2071, and `wEventFlags` grows another byte
at 2073. There are 2 bytes of slack, so the next two events are free; after that,
trim more of the padding before `wGameData` — `ds 2` at `wTimeCyclesSinceLastCall`
and `ds 3` / `ds 2` above `wMapStatusEnd` are all reclaimable the same way.)

## What was actually verified

rgbds isn't installed on the machine this was written from, so a full `make`
wasn't possible. Instead, rgbds 0.5.2 was run against the changed files in
isolation:

- `wram.asm` assembles, and all seven WRAMX banks fit (bank 1 at 4094/4096).
- `maps/Route25.asm`, `maps/ViridianGym.asm`, `data/maps/outdoor_sprites.asm`,
  `data/sprites/sprites.asm`, `data/sprites/sprite_mons.asm`,
  `engine/phone/scripts/elm.asm`, `data/phone/text/elm.asm`,
  `data/phone/special_calls.asm`, `engine/events/specials.asm` and
  `data/special_pointers.asm` all assemble against the real constants/macros.
- Linking that harness leaves 352 unresolved symbols; 351 are labels present in
  the last shipped `pokecrystal.sym` and 1 is `CheckCaughtMew`, added here. No
  typo'd label or constant.
- `rgbgfx` converts `gfx/sprites/mew.png` to 384 bytes = 24 tiles, the normal
  16x96 NPC sheet layout.

Not covered by any of the above: whether `MewSpriteGFX`'s 384 bytes still fit in
the ROM bank holding the "Sprites 4" section. If `rgblink` complains about ROMX
space, move that `INCBIN` to another sprite section.

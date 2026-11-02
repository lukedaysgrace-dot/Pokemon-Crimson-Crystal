# Illusion reveal animation

The copied sprite now distorts in place with Transform's growing wave and the
sound used by Dark Pulse (`SFX_SPITE`). At the picture-update cue the actual
Pokemon's sprite and palette replace the disguise. The wave then contracts
around the actual Pokemon. There is no palette flash or color inversion.

The actual picture is buffered before the wave starts, like Transform. This
keeps long graphics transfers out of WRAM1 while the LCD distortion reads
WRAM5. The real palette is reloaded at the same cue as the picture, without the
previous full palette reset. The opposite Pokemon's overlapping rows are
protected by the same object treatment as Transform.

The new animation ID is appended after the existing positive effect IDs.
Existing attacks, saves, and animation IDs are unchanged. Only Illusion's own
animation uses the two special Transform picture handlers. Attack animation
parameters and hit bookkeeping are saved/restored. Disabling battle scenes
skips the wobble and still reveals the real Pokemon and awards Speed once.

## Verification

- Both release and debug ROMs build with RGBDS 0.5.2.
- All 30 focused Illusion cases pass, including multi-hit moves, Substitute
  bypass, Gas suppression, switching and the animation-off fallback.
- Native graphics/audio observers verify, on both sides and across shiny,
  gender and Unown controls: 40 pre-cue wave samples with the disguise intact,
  a mid-wave swap, 33 settling-wave samples with the real palette, 33 distinct
  wave patterns, one Dark Pulse sound, and no leaked LCD override afterward.
- Recorded frames reject a palette other than the disguise's or the real
  Pokemon's during the transition. Exact final tiles/palettes still match
  ordinary Totodile controls. Captured growing/settling frames were visually
  inspected on both battle sides.
- The updated 72.55-second MP4 has native game audio and passes full decoding.
- The full existing battle suite, every move/effect/ability sweep, every move
  against Illusion and all 172 opposing abilities against a legal active
  disguise pass: **4,322 battles, no failures or errors**.
- Final `make audit-static`: **pass**, including move/animation pointers,
  game data, text, learnsets, trainers, save layout, linked resources and sprites.
- The animation audit now derives its pointer count from the declared positive
  effect IDs and recognizes banked ability scripts. Isolated checks confirm
  it accepts the current table and still rejects a removed pointer or script.

## Artifacts

- Updated video: `../_artifacts/illusion/illusion-warp-showcase.mp4`
- Timing, sound and ROM metadata: `../_artifacts/illusion/recording-warp.json`
- Growing/settling captures: `warp-before-0.png`, `warp-after-0.png`,
  `warp-before-1.png`, `warp-after-1.png` under `_artifacts/illusion/`.
- Debug ROM SHA-256: `f46973bfdcabef6f9a36e6b9e8a1d4055c5919031af81c030758367b144ebbda`

The initial ability implementation, broader interaction coverage and historical
audit limitations are documented in `illusion-2026-11-01.md`.

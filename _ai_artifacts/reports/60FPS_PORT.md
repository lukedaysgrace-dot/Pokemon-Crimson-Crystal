# 60fps Overworld Port (from Polished Crystal / luckytyphlosion)

Status: implemented 2026-07-03, session 3. **NOT yet built or emulator-tested**
(sandbox had no network for rgbds — run `make` and playtest).

## How it works
Vanilla runs the overworld loop once per 2 frames (30fps): each iteration
starts by setting `wOverworldDelay = 2` (decremented per vblank) and ends by
waiting out the remainder. Objects step in 2px units, so the screen scrolls
2px every other frame. The port runs the loop every frame and halves the
per-frame pixel deltas, doubling step counts — identical real-world speeds,
but the camera and sprites move 1px per frame: smooth 60fps.

## Changes
- `engine/overworld/events.asm`: `MaxOverworldDelay` 2 -> 1.
- `engine/overworld/map_objects.asm`:
  - `StepVectors`: slow 1px/32 (was 1px/16), normal 1px/16 (was 2px/8),
    fast 2px/8 (was 4px/4). Speed column halved to match.
  - `AddStepVector`: slow tier can't halve 1px, so slow steps apply their
    vector only on odd `OBJECT_STEP_DURATION` values (Polished's approach —
    their `GetStepVector` carry flag, done here as an inline check).
  - `UpdateJumpPosition`: extra `srl e` for slow-tier jumps (duration 32) so
    the 16-entry arc table is never overrun; other tiers self-scale (speed
    halved x duration doubled = same arc counter range).
  - Turn-in-place: durations 2+2 -> 4+4, initial `OBJECT_STEP_FRAME` 2 -> 4
    (same 8 real frames).
  - Spinning NPCs (`.MovementSpinRepeat`): wait $10 -> $20.
  - `RandomStepDuration_Slow/_Fast`: masks %01111111/%00011111 ->
    %11111110/%00111110 (NPC wander/pause timers doubled).
  - Teleport field-move: pure waits (`.InitSpin`, `.InitWait`,
    `.InitFinalSpin`) 16 -> 32; movement-coupled phases (`.InitSpinRise`,
    `.InitDescent`, Skyfall, GotBite) unchanged, matching Polished.
- `engine/overworld/map_object_action.asm` (anim divisors doubled so
  animations keep their real-time speed):
  - Walk (`SetFacingStepAction`) and Skyfall: counter mask %1111 -> %11111,
    shift /4 -> /8.
  - Bump: shift /8 -> /16 (keeps the slower wall-walk look).
  - Counterclockwise spin (warps): facing changes every 8 ticks (was 4).
  - Bounce %1000 -> %10000, slow bounce %01000000 -> %10000000,
    weird tree bits 2-3 -> 3-4, boulder dust `and 2` -> 4,
    grass shake `and 4` -> 8.

## Known behavior differences (accepted; same as Polished)
- `step_sleep N` in movement scripts and `showemote` durations now tick at
  60Hz, so scripted pauses are about half as long in real time. Polished
  ships this way. If a specific cutscene feels rushed, double its
  `step_sleep` values in that map script.
- Screen-shake/cmdqueue timers also tick at 60Hz (shorter earthquakes).
- Teleport rise/descent and skyfall move at 60Hz (slightly quicker, as in
  Polished).

## Risks / test checklist
- CPU headroom: everything must now fit in one frame. Vanilla generally
  does (the standalone pokecrystal-60fps hack works unmodified); a heavy
  frame just drops to 30 for that frame. Watch NPC-dense maps (Goldenrod)
  and map-connection edges while biking.
- Test: walking/biking/slow scripted walks (speed should FEEL identical,
  just smoother), ledge hops (normal + any slow/fast jump scripts), ice
  sliding, spin tiles, escalators, teleport/fly/dig animations, fishing,
  strength boulders into holes, wandering + spinning NPCs (rates should
  look unchanged), bumping into walls, grass rustle / boulder dust, big
  doll bounce in the player's room, whirlpool/waterfall, diagonal ledges.


---

## 2026-08-11 follow-up: it was still choppy next to Polished

The port above got the *motion math* right (1px/frame, doubled durations) but
missed the reason Polished can actually afford to run the loop every frame.

**Root cause: Polished runs the whole game in CGB double speed; we did not.**
Polished switches to double speed in `engine/init.asm`, with the LCD off, and
never leaves it. Vanilla pokecrystal calls `NormalSpeed` at init and only ever
uses double speed inside the (dead) mobile adapter code - and we inherited that.

Vanilla's overworld iteration was written against a two-frame budget
(~35,112 m-cycles at normal speed). Running it once per frame halves that to
~17,556 while the work per iteration is unchanged, and on busy maps it does not
fit. When it overruns, `DelayFrame` waits for the *next* vblank, so that single
step costs two frames: the camera moves 1px, stalls, moves 1px. That is the
judder. Polished never hits it because double speed hands the same loop
~35,112 cycles inside one frame - exactly the budget vanilla always had.

Double speed changes CPU clock only. The LCD still refreshes at ~59.73Hz and
every step, animation and timer is vblank-driven, so no movement speed changes.

### Changes
- `home/init.asm`: enter double speed right after the LCD is turned off during
  `Init` (switching with the LCD on collapses video and can hang hardware), and
  drop the later `call NormalSpeed`, which would have undone it.
- `home/vblank.asm`: at the top of `VBlank::`, before the handler clears it,
  check `wVBlankOccurred`. It is only set while something is parked in
  `DelayFrame`; if it is already clear, nobody was waiting, so the main loop
  overran its frame. Record that in `hVBlankLeaked`.
- `hram.asm`: `hVBlankLeaked` at $ff92 (was part of the `ds 2` gap after
  `hRTCSeconds`). Polished's equivalent is `hDelayFrameLY`.
- `home/delay.asm`: `DelayFrame` clears `hVBlankLeaked` on entry - we are about
  to wait, so the next vblank is not a leak.
- `engine/overworld/events.asm`: `NextOverworldFrame` consumes `hVBlankLeaked`.
  If a vblank already went by, the frame boundary has passed, so it skips the
  delay instead of burning a second frame. A heavy frame now costs one dropped
  frame instead of two, and never cascades. (Polished does the same thing.)
- `engine/overworld/weather.asm`: `_PollSoundKeepalive` derives music frames
  from the hardware timer, which is clocked off the CPU. At double speed
  rTAC_4096_HZ becomes 8192Hz, so the threshold is 137 ticks instead of 69;
  it now picks the value from `hCGB` + `rKEY1` bit 7. Without this the music
  played at double tempo during LCD-off tileset loads.

### Not changed, and why
- OAM DMA wait loop (`WriteOAMDMACodeToHRAM`): OAM DMA takes 160 m-cycles in
  both speed modes, so the 40-iteration wait is still correct. Polished uses
  the same count.
- Battle animations already branch on `rKEY1` bit 7 to pick vblank mode 1 vs 3
  (vanilla code) - it was written anticipating double speed.
- Audio tempo, RTC and game time are all vblank-driven, so unaffected.
- SGB border init is DMG-only; we only switch speed when `hCGB` is set.

### Known remaining risks
- `mobile/mobile_40.asm` and `mobile/mobile_46.asm` still `call NormalSpeed`
  when they finish. That code is Japanese mobile-adapter leftovers and should
  be unreachable, but if any of it ever runs the game silently drops back to
  normal speed and the judder returns.
- The RNG stream changes, because `hRandomAdd`/`hRandomSub` are seeded from
  `rDIV`, which now ticks twice as fast. Not a bug, but any seed-dependent
  behaviour you had memorised will differ.
- Link cable timing: the serial clock doubles with the CPU. Fine when both
  sides run this ROM (Polished ships this way), but it will not link against a
  normal-speed build.
- `_PollSoundKeepalive` must now be called at least every ~31ms during LCD-off
  work rather than ~60ms, since TIMA wraps twice as fast.

### What to playtest
Walking and biking on a dense map (Goldenrod) side by side with Polished -
that is where the old build juddered worst. Then: map connection edges while
biking, ledge hops, ice/spin tiles, surf, fishing, the teleport/fly/dig
animations, and a long tileset-loading transition with music playing (to
confirm the keepalive tempo fix).

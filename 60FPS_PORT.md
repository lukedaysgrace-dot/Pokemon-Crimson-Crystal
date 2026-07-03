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

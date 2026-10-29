# Creative move animations

The requested move set lives in `data/moves/animations8.asm`. Octazooka keeps
its existing shot in bank 3 and adds its target-only burnout finish there.

| Move | Sequence |
| --- | --- |
| Armor Cannon | Steel-tinted user draws in fire, fires a pulsing molten shell; blast with lava-hot armor shards and an upward flame fan |
| Apple Acid | Real apple lobbed in an arc, lime acid splash, two corrosive pulses on the target, acid drips |
| Fiery Dance | Flames spiral up around the dancer, unroll into a wavering ribbon and wrap the foe in a fire spin |
| Foul Play | User fades into a silhouette and sinks into a shadow that slides under the foe; triple rake, crossing slash, then the user rises back out of black |
| Gigaton Hammer | Steel sheen on the user; the 48px mallet eases in over the foe, winds up, slams, rebounds; dust and shards |
| Grav Apple | Gravity rings pull a 32px apple into a hover over the foe; it winds up and craters the ground |
| Heat Crash | Flames spiral up and the user launches out of sight; a comet streaks in and bursts with a hot-core blast and smoke |
| Infernal Parade | A ghost leads a wave of violet will-o'-wisps to the foe; they spin around it while it flickers dark |
| Infestation | Beetles fan out, orbit and close in while a web drops over the foe; three bites |
| Octazooka | Ink shot and darkening splash, then a gray ink stain with rising smoke that clears before the move ends |
| Quiver Dance | Pink wings, gold glimmers and blue sparkles (the three raised stats) drift up together |
| Solar Blade | Charge: sunlight orbs converge and the user glows once. Strike: the user flashes, two crossing lime slashes, impact and sun sparks |
| Tail Glow | A firefly glow swells at the tail, motes rise, the user brightens once; three Special Attack rises follow |

All graphics for a move are loaded before its first object, so no phase
rewrites tiles that are still on screen. Objects finish their own motion
instead of being cut off by `anim_clearobjs`, each move has at most one short
flash, and battler recolors are restored before the move ends.

New engine pieces (append-only ids):

- `BattleAnimFunction_HeavyDrop`: ease-in from above, hover, 4px wind-up lift,
  accelerating fall, 4px rebound and settle. Param bit 7 streaks straight in
  and bursts on impact (Heat Crash comet).
- `BattleAnimFunction_FlameTwirl` / `ANIM_OBJ_FLAME_TWIRL`: a flame circling the
  user's feet on a flat ellipse while climbing, gone after 48 frames.
- `ANIM_BG_FADE_MON_FROM_BLACK`: mirror of FADE_MON_TO_BLACK.
- `ANIM_BG_FADE_MON_GLOW`: one smooth brighten, hold and fade back. Like the
  other palette fades, the speed is the high nibble of the last argument.
- `PAL_BTLCUSTOM_BLAST`: explosion palette with a hot core instead of black.

The apple source and deterministic native-tile generator are documented in
`tools/testdata/creative_moves/README.md`. The steel mallet has a beveled
head, rivets and wrapped grip. New heavy-drop motion holds the apple,
hammer or comet overhead, then accelerates into the target on both battle
sides. Infestation has a separate orbit/contraction function.

Tail Glow records `$20 | SP_ATTACK` in `wLoweredStat`; the generic stat
animation honors this as three stages. Its move animation deliberately
does not duplicate the arrows. The showcase appends the same native
three-stage animation. Full battle checks independently assert three rise
sounds and +3 Special Attack on both sides, with Nasty Plot's two rises as
the control.

```sh
python3 tools/build_creative_move_assets.py
make -j6 all debug
python3 tools/battletest/creative_animation_checks.py --record
python3 tools/audit_mae_animations.py
```

Native checks cover both battle sides, Solar Blade's charge and strike,
requested sprite presence, falling motion, all object allocations, live
VRAM graphics, OAM tile bounds and final tilemap/palette/LCD restoration.
The recording includes all thirteen moves, both Solar Blade phases, both
battle sides and emulated audio. Outputs, contact sheets, checks and chapter
times are under `_artifacts/creative-moves/`. Tests use private emulator
fixtures and do not open player saves.

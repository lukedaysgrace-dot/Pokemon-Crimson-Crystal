# Creative move animations

The requested move set lives in `data/moves/animations8.asm`. Octazooka keeps
its existing shot in bank 3 and adds its target-only burnout finish there.

| Move | Sequence |
| --- | --- |
| Armor Cannon | Reactor sparks, molten shells, steel shrapnel and secondary detonations |
| Apple Acid | Red apple projectile, lime acid burst, splashes and corrosive drips |
| Fiery Dance | Turning flame ribbons, fiery rush and spreading fire fans |
| Foul Play | Read the opponent, vanish into a shadow, hooked arcs and reverse claw ambush |
| Gigaton Hammer | Metallic windup, suspended 48px steel mallet, accelerating slam, rubble and dust |
| Grav Apple | Psychic suspension, real 32px apple falling under acceleration, heavy impact and debris |
| Heat Crash | Fiery ascent, falling ember comet, blast and smoke |
| Infernal Parade | Moving ghost masks, rings of spectral fire and a charred target |
| Infestation | Animated beetles open into a ring, orbit and close in under a web |
| Octazooka | Ink shot, then Overheat's charred palette and rising smoke on the opponent |
| Quiver Dance | Paired expanding wings and a spiral in three stat colors |
| Solar Blade | Sunlight gathers into a green blade; the strike cuts through a leaf aftershock |
| Tail Glow | Growing golden tail light, halo and released sparks; three Special Attack rises follow |

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

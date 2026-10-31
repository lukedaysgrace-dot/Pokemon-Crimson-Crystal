# Twin Beam

Twin Beam is a Psychic special move with 45 base power **per hit**, 100%
accuracy and 10 PP. It hits exactly twice. Each landed hit independently has a
10% chance to lower the target's Special Defense by one stage. A drop from the
first hit affects the second hit's damage. Girafarig and Farigiraf learn it at
level 32.

The animation is ported from pkmncoraldev's Polished Coral,
[`BattleAnim_TwinBeam` in `data/moves/animations_2.asm`](https://github.com/pkmncoraldev/polishedcoral/blob/11124200aecb59e779f793ca4daaa5db34929627/data/moves/animations_2.asm#L728).
The port reuses the existing Leer beam objects, beam graphics, Psycho Boost
palette, palette cycling, screen shake and Leer sound. Its two original beam
phases play once each, at their corresponding damage hit.

The dedicated `EFFECT_SP_DEF_DOWN_DOUBLE_HIT` script rolls its secondary inside
the damage loop, before applying damage, so a hit that breaks Substitute cannot
also lower its holder's Special Defense. Failed/blocked stat drops cannot cancel
the second hit. Existing stat protection, Serene Grace, Sheer Force, Shield Dust,
multi-hit berry timing and Parental Bond exclusions apply.

Validation:

```sh
make -j4 pokecrystal.gbc pokecrystal_debug.gbc
.venv/bin/python tools/audit_moves.py
.venv/bin/python tools/battletest/runner.py --no-render tools/battletest/tests/96-twin-beam.yaml tools/battletest/tests/59-audit-moves-2026-10-01.yaml tools/battletest/tests/58-audit-abilities-2026-10-01.yaml
.venv/bin/python tools/battletest/twin_beam_checks.py
.venv/bin/python tools/battletest/record_twin_beam.py
```

The native checks exercise all four independent secondary outcomes on both
sides, both beam phases, damage recalculation between hits, all 256 secondary
RNG values under four ability configurations per side, and real graphics/palette
cleanup. Like Psychic, 10% uses the engine's 25/256 encoding.

The recording is written to `_artifacts/twin-beam/twin-beam-showcase.mp4`.
It shows complete turns from both sides with native game audio. Both optional
stat drops are deliberately selected for the demonstration; the ROM retains its
ordinary 10% chance on each hit.

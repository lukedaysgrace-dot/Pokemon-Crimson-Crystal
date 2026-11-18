# Build utilities

These programs compile graphics, compress assets, generate source tables, and
check save-layout compatibility for Crimson Crystal and its save editor.

Build both ROMs with RGBDS 0.5.2:

```sh
make -j8 pokecrystal.gbc pokecrystal_debug.gbc
```

The Python asset generator in `vs_intro/` requires Pillow. Other Python build
utilities use the standard library or the bundled PNG reader. The save editor
uses PyBoy and PyYAML for its native save verification.

After building the debug ROM, check battle type-icon transitions with PyBoy,
NumPy, and PyYAML:

```sh
python3 tools/battletest/type_icon_checks.py
python3 tools/battletest/type_icon_stress.py
```

The stress audit checks every move and ability on both sides, multi-turn and
identity changes, repeated menus, battle exits, and all ordered active type
pairs. It compares icon art, colors, screen pixels at stable checkpoints, and
HUD cleanup in both WRAM and VRAM. Renderer combinations are reported separately
from battles. Its `.venv/type-icon-stress/results.json` records the tested ROM's
SHA-256, planned coverage, completion, and per-case failures. Use `--groups` to
run selected groups or `--output` to choose a report directory.

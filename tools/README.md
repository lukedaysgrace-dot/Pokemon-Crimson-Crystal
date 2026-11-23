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

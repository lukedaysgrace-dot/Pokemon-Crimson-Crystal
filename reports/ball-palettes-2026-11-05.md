# Capture ball palette update

The 13 existing capture balls now use one full-palette table for battle throws,
send-outs and the INFO/MEMO summary displays. Coral's exact RGB5 pairs are used
except for the retained Crimson Master, Heavy and Safari colors and the authored
yellow-over-white Park Ball. Sprite art, item IDs and saved caught-ball fields
are unchanged. The source receipt and requested values are in
`tools/testdata/ball_palettes.json`.

Battle balls temporarily use OBJ palette 5; the existing cleanup calls restore
its normal green colors. Generic move palettes are unchanged. Both summary OBJ
slots read the same table directly.

Validation:

- RGBDS 0.5.2 release and debug builds passed. ROM0 retains 91/85 bytes free.
- `tools/battletest/ball_palette_checks.py`: 7,772 checks passed per ROM,
  including all 13 native throws and send-outs, hardware OAM/palette colors,
  blocked throws, animations-off throws, both send-out sides, palette cleanup
  and invalid-item fallback. Private emulator state only.
- `make test-summary-ui BATTLE_TEST_PYTHON=python3`: 2,616 checks passed per
  ROM, including every caught ball on INFO/MEMO, invalid caught-ball fallback,
  exact sprite uploads, page transitions, PC/party paths and data preservation.
- `make audit-static` passed dimensions, game data, ability text, moves, move
  expansion, learnset variety, trainers and saves, then failed its resource
  audit on 18 pre-existing Hippowdon animation errors. The checked-in
  `gfx/pokemon/hippowdon/frames.asm` is empty in HEAD and was not modified.
  The three subsequent icon/map-sprite/trainer-sprite audits passed separately.
- `git diff --check` passed.

The reusable combined target is `make test-ball-palettes`.
Finished sprite comparisons and native battle captures are under
`_artifacts/ball-palettes/`; native INFO/MEMO captures are under
`_artifacts/summary-review/release/` and `debug/`.

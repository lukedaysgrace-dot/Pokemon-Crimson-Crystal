# Recorded Pokémon cries

These samples replace borrowed cries for added official Pokémon and their forms.
Crystal's original 251 assignments, clone/custom species, and existing proper
Coral/Johto Legends adaptations are preserved. The two authored hippopotamus
adaptations are replaced with recordings; both Aegislash records share a sample,
as do Zangoose and its scarred form.

At the user's request, 43 regional/form-related assignments have been restored
to their exact pre-import cries, including Clodsire's Quagsire cry. The remaining
140 replacements are unchanged. Unused regional samples stay in the original
181-row sample table to keep every other sampled cry ID and asset stable.

Samples available in the local `polishedcoral/audio/ded/` archive are copied
verbatim and retain their 10485.76 Hz playback rate. Other recordings come from
the [PokéAPI cry archive](https://github.com/PokeAPI/cries), using form-specific
PokéAPI identifiers. New encodes use 16384 Hz, band-limited mono resampling, DC
removal, peak normalization with headroom, and deterministic half-LSB TPDF
dither. Neither pitch nor duration is intentionally changed. No denoising,
time stretching, or generated/synthesized substitutes are applied.

The format and Huffman decoder are adapted from
[Polished Coral](https://github.com/pkmncoraldev/polishedcoral)'s DED system
(`home/ded.asm`, `audio/ded.asm`, `dedenc.py`). The sample playback code is
copied into dedicated WRAM bank 4 so any ROM bank can supply its stream.
Playback uses CGB double speed and restores a normal-speed caller afterward.
The hardware wave channel has 4-bit levels; the entropy compression itself
does not lose any additional encoded sample information.

The timer consumes a 16-block ring buffer while the foreground advances the
normal picture animation script. Prepared 7x7 frames upload during VBlank, so
sampled cries and the moving entrance picture overlap just like synthesized
cries. Full-screen animation cleanup remains in the ordinary animation loop.

`tools/testdata/sampled_cries.json` records every replaced/protected assignment,
source URL, sample hash, source hash for new encodes, rate, and gain. Original
cry asset hashes protect the previous adaptations against accidental edits.

Regenerate with `python3 tools/generate_sampled_cries.py` (requires numpy,
scipy, soundfile, the local Coral checkout and an internet connection). Normal
ROM builds use these committed assets without requiring those dependencies.

Run `make test-sampled-cries` for exact native waveform-block, timer, duration,
state restoration, music/SFX, and preservation checks on both ROMs. Add
`--record` to `tools/battletest/sampled_cry_checks.py`, or run
`tools/battletest/record_sampled_cries.py` directly, for SameBoy WAVs, an ordered
compilation, and a searchable HTML listening page under
`_artifacts/sampled-cries/`. The isolated pinned SameBoy core builds in
`.tmpbuild` under Linux/WSL. PyBoy verifies decoding and cleanup but must not
be used for listening captures: its streamed-wave rendering introduces
additional distortion that is absent from the correctly rendered waveform.

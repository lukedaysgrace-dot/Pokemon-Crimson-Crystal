# Recorded cry replacements

Current user preference: 43 regional/form-related assignments have been
restored to their exact pre-import values, including Clodsire = Quagsire.
Hisuian Zorua/Zoroark and regional evolutions Cursola, Perrserker, Mr. Rime,
Sirfetch'd and Overqwil are included. The remaining 140 sampled assignments
and all sample assets are unchanged. Both ROMs rebuild and pass 1,491 updated
cry checks each. The original sample pointer order is retained for stability.

## Simultaneous picture animation

The sampled player now consumes a 16-block decoded ring from timer interrupts,
leaving foreground time for the normal picture animation script. Sampled
PokeAnim cry commands prepare their following Setup/Setup2 and advance the
same Play/Play2 stage while the cry plays. A short VBlank uploads only its
complete 7x7 picture snapshot, permitting timer preemption. Finish/Idle and
full-map DMA remain in the ordinary animation loop. The timer preserves all
interrupted registers, flags, WRAM mapping and ROM bank. No cry sample or
assignment changed for this timing fix.

Updated footage: `_artifacts/cry-animation-sync/battles/changed-cries-native-battles.mp4`.
All 11 examples with animated art show multiple visible poses and animation
script steps during the cry, with no ring underruns. Jirachi and Hippopotas
have only one supplied frame and remain static. Per-battle pose timestamps,
checks, entry images and the exact ROM hash are in the adjacent results file.

Final verification on both ROMs:

- 1,491 audio/preservation/stream checks per ROM, no failures.
- 1,101 exact native picture-tile checks per ROM.
- 40,064 release / 40,352 debug type-icon checks over live battle/UI frames.
- 405 native Pokédex UI checks per ROM.
- 2,616 native summary/PC checks per ROM.
- Independent SameBoy final-waveform correlation for Bagon, Dusknoir,
  Tinkaton and Honchkrow: 0.9575–0.9812 in the intended source band. Listening
  WAVs have no analysis filter or desktop audio replacement applied.
- Standard dual-ROM `make` verifies the final builds are up to date.
- ROM0 retains 109 release / 103 debug bytes of free space. The header
  reservation, fixed palette-bank constraints and saved layouts are intact.

The earlier `_artifacts/cry-battles/changed-cries-native-battles.mp4` shows 13 of these
remaining non-regional changes in actual battles, with native entrances,
picture animations, game music, cry audio and a combat turn. Individual clips,
screenshots, the ROM hash and per-battle checks are alongside it. Recording
uses a private SameBoy New Game and native debug requests; it does not call
the cry player directly or replace the recorded sound. It predates the timing
fix and is superseded by the `cry-animation-sync` footage above.

The original import details below describe the initial 183 replacements;
`restored_regionals` in the manifest records the later opt-outs.

Replaced 183 borrowed/authored-placeholder assignments with 181 distinct real
recordings. This includes the two hippopotamus adaptations, form-specific
regional cries, and shared samples for Aegislash/Blade and Zangoose/Scarred.
320 assignments remain protected, including Crystal's original 251, clones,
custom species, and existing proper Coral/Johto Legends ports.

20 additional samples are copied verbatim from the local Polished Coral DED
archive. The other 161 come from the public PokéAPI cry archive, with stable
form-specific IDs and source hashes recorded in
`tools/testdata/sampled_cries.json`.

New encodes use 16.384 kHz, band-limited resampling, mono downmix, DC removal,
peak normalization to 92% with headroom, and deterministic half-LSB TPDF
dither. Copied Coral samples retain their original 10.48576 kHz data and rate.
The Game Boy wave channel still has 4-bit amplitude resolution. DED's Huffman
compression does not further degrade the encoded samples. No pitch shifting,
time stretching or denoising is applied to the recordings.

Playback runs in dedicated WRAM4. The dispatcher moved out of ROM0, leaving
122 release / 116 debug bytes free. No save format or saved state layout is
changed. Playback restores timer, CPU speed, interrupt, ROM/WRAM bank and
sound state; the music wave channel is reloaded afterward. Normal gameplay
already runs at CGB double speed; normal-speed callers temporarily select
double speed during playback, then return to their original speed.

## Verification

- Both release and debug ROMs build with RGBDS 0.5.2.
- Each ROM passes 1,609 audio/preservation checks: all 183 replacement
  assignments, exact native decoded blocks against an independent decoder,
  complete duration, non-silent audio, linked protected headers, original
  cry asset hashes, timer/interrupt/WRAM cleanup, music/SFX recovery, and
  representative normal-speed callers.
- Full normal-speed release sweep: 1,601 checks, no failures.
- Native Pokédex UI: 405 checks per ROM, passed.
- Illusion and roster/Stance Change battle suites: 65 passed.
- `git diff --check` passes.
- General static audits pass through the resource audit. That audit reports
  22 pre-existing animation-frame errors: Hisuian Arcanine refers to frames
  7–10 but has six frame pointers, and Hippowdon's tracked frame table is
  empty. The same data exists in the starting Git revision; this cry change
  does not modify it. Remaining icon, map sprite and trainer sprite audits
  were run separately and passed.

PyBoy validates sample data and CPU playback behavior. Its final streamed-wave
audio rendering is unsuitable for listening: it swaps adjacent wave samples
and does not reset the wave sample cursor on retrigger. This produces strong
extra distortion despite correct decoded blocks. The initial listening files
were therefore misleading and have been replaced with independent SameBoy
captures of the unchanged ROM. This is not a physical-console listening test.

## Listening

`_artifacts/sampled-cries/listen.html` has individually labeled players,
search, and a Play all button. `listen-corrected.html` provides the same page
with a fresh URL. Every current file is captured from the release ROM through
SameBoy's band-limited CGB-E APU, with hardware-accurate highpass filtering
and no desktop noise removal/equalization. The folder also contains all 183 individual
WAVs, `all-replacement-cries.wav`, `listening-order.json`, and the detailed
release/debug test results. `sameboy-results.json` records final waveform
correlation against independently decoded samples and the exact emulator
revision/ROM hash. Recordings and fixtures do not touch player saves.
All 183 corrected captures pass the final audio comparison; minimum intended-
band waveform correlation is 0.9185. This comparison filters only analysis
copies, so normal DAC sampling images do not count against an ideal reference;
the listening WAVs remain the unprocessed SameBoy output.

Reproduce with:

```sh
make -j8 pokecrystal.gbc pokecrystal_debug.gbc
make test-sampled-cries
python3 tools/battletest/sampled_cry_checks.py --normal-speed
python3 tools/battletest/record_sampled_cries.py
```

Sources: [Polished Coral](https://github.com/pkmncoraldev/polishedcoral),
[PokéAPI cry archive](https://github.com/PokeAPI/cries).

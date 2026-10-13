# Hudson Hawk title music

The supplied `02._20Title_20Screen.wav` matches Hudson Hawk's Game Boy title
track. The port is registered as `MUSIC_HUDSON_HAWK_TITLE` (`$71`), with its
song header at `Music_HudsonHawkTitle`. It is available as a separate track.
The Crimson Crystal title screen uses its original `MUSIC_TITLE` song.

The original title track is credited to Keith Tinman by
[VGMRips](https://vgmrips.net/packs/company/epic-sony-records/published).
The matching sequence was recovered from
[kingshriek's Hudson Hawk GBS rip](https://snesmusic.org/hoot/kingshriek/).

## Files and playback

- `audio/music/hudsonhawktitle.asm`: four synchronized channels and reusable
  phrases, with a 2,688-frame loop (about 45 seconds).
- `audio/wave_samples.asm`: sample 10 holds the original bass waveform.
- `audio.asm`, `audio/music_pointers.asm`, and `constants/music_constants.asm`:
  register the new song and place it in its own ROM section.

To play this separate track, use the existing playback interface:

```asm
	ld de, MUSIC_HUDSON_HAWK_TITLE
	call PlayMusic
```

This is a sequence port, not embedded WAV playback. Existing `togglesfx`,
`sound`, and `noise` commands retain hardware pitches, duty changes, and
frame-level modulation. `tempo 256` and `notetype 1` give one engine frame
per duration unit. The software envelope levels are rendered into the
sequence, and repeated phrases share subroutines. Channel 3 uses wave
sample 10; the low intensity nibble selects that sample.

The port preserves the musical parts and timing, but the engine retriggers
notes at some pitch or volume changes, so phase and attack behavior can
differ from the original driver. The WAV's repeat and fade-out are replaced
by an indefinite synchronized loop.

The emulator audition is saved locally under
`_artifacts/hudson-hawk-title/hudson-hawk-title-preview.wav`; its validation
report is alongside it. These generated files are ignored by Git.

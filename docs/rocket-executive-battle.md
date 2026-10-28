# Rocket Executive battle music

`MUSIC_ROCKET_EXECUTIVE_BATTLE` (`$75`) is an original battle theme for the
four named Team Rocket admins: Proton, Petrel, Ariana, and Archer. Grunts,
the generic Executive classes, and Scientists keep `MUSIC_ROCKET_BATTLE`.
`PlayBattleMusic` (`engine/battle/start_battle.asm`) checks the admins
before the generic Rocket classes.

## Sound

The song is in E minor. The Phrygian F and tritone Bb add tension. It runs
at 149 BPM, using `tempo 256` and `notetype 6`, so one 16th note is six
frames.

| Bars | Section | Content |
| --- | --- | --- |
| 4 | Intro | Tritone hits, chromatic bass climbs, diminished cascade, dominant hits, tom fill |
| 8 | A | Pumping octave bass riff, tresillo stabs, and a creeping chromatic line |
| 8 | B | Main theme (Em C Am B, Em C F B) with ch1 parallel harmony |
| 8 | C | Descending gallop bass (E to B), sustained lead, and ch1 arpeggios |
| 8 | D | Half-time breakdown with E1/F1 chugs, tremolo, and a swelling build |
| 8 | B' | Theme reprise; ch1 doubles the lead an octave lower |

The intro plays once. The 40-bar section then loops (3,840 frames, about
64 seconds).

- Ch1: Harmony, octave doubling, arpeggios, and tremolo. It is panned left
  when the Stereo option is on.
- Ch2: Lead with vibrato.
- Ch3: Bass on wave sample 12. Strong 16ths play at full volume and weak
  16ths at half volume.
- Ch4: Drumkit 6.

## Files

- `audio/music/rocketexecutivebattle.asm`: song data. Each channel calls
  reusable phrases, and every bar is commented.
- `audio/drumkits.asm`: `Drumkit6` contains the kick, snare, ghost snare,
  closed/soft/open hats, crash, three 7-bit toms, a roll snare, and a clap.
- `audio/wave_samples.asm`: sample 12 is a 37.5% pulse with sloped edges. Its
  strong fundamental and clear second harmonic make low notes audible.
- `audio.asm`, `audio/music_pointers.asm`, and
  `constants/music_constants.asm`: register the song in its own ROM
  section.
- `engine/battle/start_battle.asm`: plays the song for the admins.
- `maps/PlayersHouse2F.asm`: adds "ROCKET EXECUTIVE" to the bedroom radio's
  Extra music menu.

The new drumkit and wave sample live in the "Audio" section with the sound
engine. The floating "Tileset Data 17" section moves to another bank to make
room.

## Verification

In an emulator trace, every note the engine parsed was compared with the
composed score over the intro and two full loops. All four channels matched
the expected timing and pitch, frame for frame. `PlayBattleMusic` selects
this song for PROTON, PETREL, ARIANA, and ARCHER. GRUNTM, GRUNTF,
EXECUTIVEM, EXECUTIVEF, and SCIENTIST still get `MUSIC_ROCKET_BATTLE`. The
bedroom radio entry plays the song.

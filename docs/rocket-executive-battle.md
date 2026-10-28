# Rocket Executive battle music

`MUSIC_ROCKET_EXECUTIVE_BATTLE` (`$75`) is an original battle theme for the
four named Team Rocket admins: Proton, Petrel, Ariana, and Archer. Grunts,
the generic Executive classes, and Scientists keep `MUSIC_ROCKET_BATTLE`.
`PlayBattleMusic` (`engine/battle/start_battle.asm`) checks the admins
before the generic Rocket classes.

## Sound

The song is in B minor. The Phrygian C and tritone F add tension. It runs
at 149 BPM, using `tempo 256` and `notetype 6`, so one 16th note is six
frames.

| Bars | Section | Content |
| --- | --- | --- |
| 4 | Intro | Tritone hits, chromatic bass climbs, diminished cascade, dominant hits, tom fill |
| 8 | A | Pumping octave bass riff, tresillo stabs, and a creeping chromatic line |
| 8 | B | Main theme (Bm G Em F#, Bm G C F#) with ch1 parallel harmony |
| 8 | C | Descending gallop bass (B to F#), sustained lead, and ch1 arpeggios |
| 8 | D | Half-time breakdown with B1/C2 chugs, tremolo, and a swelling build |
| 8 | B' | Theme reprise; ch1 doubles the lead an octave lower |

The intro plays once. The 40-bar section then loops (3,840 frames, about
64 seconds).

- Ch1: Harmony, octave doubling, arpeggios, and tremolo. It is panned left
  when the Stereo option is on.
- Ch2: Lead with vibrato.
- Ch3: Bass on the sawtooth wave (sample 11), the same bass waveform as
  `greenow.asm`. Every note plays at full volume and is clipped short,
  leaving 2 silent frames before the next note.
- Ch4: Drumkit 6. Its kick, snares, and off-beat "tss" are modeled on
  drumkit 3, the kit `greenow.asm` uses.

## Files

- `audio/music/rocketexecutivebattle.asm`: song data. Each channel calls
  reusable phrases, and every bar is commented.
- `audio/drumkits.asm`: `Drumkit6` contains a tonal 7-bit kick, snare, ghost
  snare, off-beat "tss", soft and open hats, crash, three 7-bit toms, a roll
  snare, and a clap. The kick, snares, and "tss" are louder takes on drumkit
  3's Kick1, Snare12–14, and Crash2.
- `audio.asm`, `audio/music_pointers.asm`, and
  `constants/music_constants.asm`: register the song in its own ROM
  section.
- `engine/battle/start_battle.asm`: plays the song for the admins.
- `maps/PlayersHouse2F.asm`: adds "ROCKET EXECUTIVE" to the bedroom radio's
  Extra music menu.

The new drumkit lives in the "Audio" section with the sound
engine. The floating "Tileset Data 17" section moves to another bank to make
room.

## Verification

In an emulator trace, every note the engine parsed was compared with the
composed score over the intro and two full loops. All four channels matched
the expected timing and pitch, frame for frame. `PlayBattleMusic` selects
this song for PROTON, PETREL, ARIANA, and ARCHER. GRUNTM, GRUNTF,
EXECUTIVEM, EXECUTIVEF, and SCIENTIST still get `MUSIC_ROCKET_BATTLE`. The
bedroom radio entry plays the song.

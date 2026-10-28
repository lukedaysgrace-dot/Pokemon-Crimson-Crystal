# Rocket Executive battle music

`MUSIC_ROCKET_EXECUTIVE_BATTLE` (`$75`) is an original battle theme for the
four named Team Rocket admins: Proton, Petrel, Ariana, and Archer. Grunts,
the generic Executive classes, and Scientists keep `MUSIC_ROCKET_BATTLE`.
`PlayBattleMusic` (`engine/battle/start_battle.asm`) checks the admins
before the generic Rocket classes.

## Sound

The song centers on A minor, sharing the grunt theme's A-A-C-B-flat hook,
A/G-sharp/E response, and moving root/fifth bass. B-flat, chromatic descents,
and diminished runs give the executive version a more threatening character.
The opening eight bars (intro plus the first four bars of A, about 11.25
seconds) retain the original arrangement. After that, a tritone answer and
borrowed F-minor and B-flat-minor colors darken the harmony without changing
the Rocket hook or drum groove. Section B adds a half-diminished D arpeggio
and a flat-ninth dominant answer. Section C drops its first four bass roots
an octave and adds tritone answers for a heavier, stalking half-time passage;
the high reprise carries those darker colors into the turnaround.
It runs at about 171 BPM: `tempo 224` and `notetype 6` give 84 sound updates
per 4/4 bar. The drums put the snare on beats 2 and 4, with syncopated kicks,
ghost notes, and short fills at phrase endings.

| Bars | Section | Content |
| --- | --- | --- |
| 4 | Intro | Tritone warning hits, descending chromatic run, Rocket hook, drum fill |
| 8 | A | Clipped grunt-derived call sign, low fifth stabs, gated bass groove |
| 8 | B | Larger boss melody over Am/B-flat/Am/E, F/Dm/B-flat/E; moving arpeggios |
| 8 | C | Four bars of half-time menace over A/G-sharp/G/F-sharp, then a four-bar build |
| 8 | D | Higher Rocket-hook reprise, independent counterline, diminished climb, chromatic turnaround |

The intro plays once. The 32-bar section then loops (2,688 sound updates,
about 45 seconds). The four-bar intro lasts 336 updates, about 5.6 seconds.

- Ch1: Clipped fifths, minor/diminished arpeggios, and an independent
  counterline. It is panned left when the Stereo option is on.
- Ch2: Lead with short envelopes, widening to a longer envelope and subtle
  vibrato for section B.
- Ch3: Bass on the sawtooth wave (sample 11), the same bass waveform as
  `greenow.asm`. Every note plays at full volume and is clipped short,
  leaving one `notetype 2` unit (1-2 sound updates) before the next note.
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

Run `python tools/record_rocket_executive.py` after building the release ROM.
The recorder starts a private sound-enabled emulator, plays the native song,
checks that all four channels remain active and synchronized over two loops,
and writes WAV, MP3, and a JSON verification receipt under
`_artifacts/rocket-executive/`. The MP3 contains the intro and two loops,
with a three-second fade at the end. The WAV preserves the raw recording.
An optional `--score` JSON argument also checks each interpreted note's pitch,
octave, length, and start time against a working score.

`PlayBattleMusic` selects this song for PROTON, PETREL, ARIANA, and ARCHER.
GRUNTM, GRUNTF, EXECUTIVEM, EXECUTIVEF, and SCIENTIST still get
`MUSIC_ROCKET_BATTLE`. The bedroom radio entry also plays the song.

#!/usr/bin/env python3
"""Convert Pokemon TCG (pret/poketcg) songs to this engine's music format.

The TCG engine updates its music on every fourth ~240.94 Hz timer interrupt
(about 60.24 Hz, close to this engine's once per frame) and supports nested
loops and calls, legato ties, note cutoffs with echo tails and per-tick noise
instruments.  This engine updates once per frame (~59.73 Hz) with one loop
counter and one call level per channel, so each channel is flattened to an
absolute timeline, rounded to frames (which keeps the channels in sync),
and re-emitted.  Usage:

    python3 tools/beast_triad/tcg_music.py <poketcg>/src/audio/music/dueltheme1.asm \
        Music_BeastTriadDuel audio/music/beasttriadduel.asm
    python3 tools/beast_triad/tcg_music.py --drumkit <poketcg>/src/audio/noise_instruments.asm
"""

from dataclasses import dataclass, replace
import re
import sys

TICK_HZ = 16384 / 68 / 4  # src/home/time.asm: sound runs on every 4th timer tick
FRAME_HZ = 4194304 / 70224
TICKS_TO_FRAMES = FRAME_HZ / TICK_HZ
PITCHES = {"C_": 1, "C#": 2, "D_": 3, "D#": 4, "E_": 5, "F_": 6, "F#": 7,
           "G_": 8, "G#": 9, "A_": 10, "A#": 11, "B_": 12}
PITCH_NAMES = {v: k for k, v in PITCHES.items()}
# TCG wave instrument 1 is already the game's wave 11; instrument 4 is wave 12.
WAVES = {1: 11, 4: 12}
DRUMKIT = 7
# TCG drums (by pitch) in the order of this game's kit, then a silent entry
# for rests. The audio bank is full, so the kit skips TCG's unused slots.
DRUMS = {1: 1, 3: 2, 5: 3, 7: 4, 9: 5, 12: 6}
MUTE_DRUM = 7

# Extent (peak to peak) and frames per half cycle for each TCG vibrato table
# (poketcg src/audio/vibrato_types.asm). Types 2 and 7 are a one-off wobble
# and a pitch bend, which this engine's vibrato can't follow.
VIBRATO = {0: (0, 0), 1: (4, 4), 2: (0, 0), 3: (2, 4), 4: (2, 6), 5: (12, 6),
           6: (15, 8), 7: (0, 0), 8: (8, 4), 9: (8, 6), 10: (2, 8)}

def noise_instruments(path):
    """poketcg src/audio/noise_instruments.asm: {drum pitch - 1: bytes}."""
    text = open(path, encoding="utf-8").read()
    order = re.findall(r"^\s*dw\s+\.(\w+)", text, re.M)
    blocks = {}
    for name, body in re.findall(r"^\.(\w+)\n((?:\s*db\s+.*\n?)+)", text, re.M):
        values = [int(v.strip()[1:], 16) for line in body.splitlines()
                  for v in line.split("db", 1)[1].split(",")]
        assert values[-1] == 0xff
        blocks[name] = values[:-1]
    return {i: blocks[name] for i, name in enumerate(order) if name != "unused"}


@dataclass(frozen=True)
class State:
    speed: int = 1
    octave: int = 3
    volume: int = 0xa0
    duty: int = 2
    cutoff: int = 0
    echo: int = 0x08
    vib_type: int = 0
    vib_delay: int = 0
    freq_offset: int = 0
    wave: int = 0


@dataclass
class Event:
    pitch: int          # 0 = rest
    octave: int
    ticks: int
    state: State
    tied: bool = False  # continues the previous note without retriggering
    volume: int = None  # override for echo tails


def parse(path):
    labels, code = {}, []
    for raw in open(path, encoding="utf-8"):
        line = raw.split(";")[0].rstrip()
        if not line.strip():
            continue
        if not line[0].isspace():
            labels[line.strip().rstrip(":")] = len(code)
            continue
        parts = line.strip().split(None, 1)
        args = [a.strip() for a in parts[1].split(",")] if len(parts) > 1 else []
        code.append((parts[0], args))
    return labels, code


def number(text):
    text = text.strip()
    if text in ("TRUE", "FALSE"):
        return int(text == "TRUE")
    return int(text, 0) if not text.startswith("$") else int(text[1:], 16)


def flatten(labels, code, start, channel):
    """Interpret one channel. Returns (events, loop_index or None)."""
    state = State(octave=4 if channel == 2 else 3, echo=0x40 if channel >= 2 else 0x08)
    events, stack, loop_index, pc = [], [], None, labels[start]
    tie = False
    steps = 0
    while True:
        steps += 1
        assert steps < 1_000_000, "runaway channel"
        cmd, args = code[pc]
        pc += 1
        if cmd in ("note", "bass", "snare1", "snare2", "snare3", "snare4", "snare5", "rest"):
            if cmd == "note":
                pitch, length = PITCHES[args[0]], number(args[1])
            elif cmd == "rest":
                pitch, length = 0, number(args[0])
            else:
                pitch = {"bass": 1, "snare1": 3, "snare2": 5, "snare3": 7,
                         "snare4": 9, "snare5": 12}[cmd]
                length = number(args[0])
            events.append(Event(pitch, state.octave, length * state.speed, state, tied=tie))
            tie = False
        elif cmd == "speed":
            state = replace(state, speed=number(args[0]))
        elif cmd == "octave":
            state = replace(state, octave=number(args[0]) - 1 + (channel == 2))
        elif cmd == "inc_octave":
            state = replace(state, octave=state.octave + 1)
        elif cmd == "dec_octave":
            state = replace(state, octave=state.octave - 1)
        elif cmd == "tie":
            tie = True
        elif cmd == "volume_envelope":
            hi, lo = number(args[0]), number(args[1])
            state = replace(state, volume=(hi << 4) | (8 | -lo if lo < 0 else lo))
        elif cmd == "duty":
            state = replace(state, duty=number(args[0]))
        elif cmd == "cutoff":
            state = replace(state, cutoff=number(args[0]))
        elif cmd == "echo":
            state = replace(state, echo=number(args[0]))
        elif cmd == "vibrato_type":
            state = replace(state, vib_type=number(args[0]))
        elif cmd == "vibrato_delay":
            state = replace(state, vib_delay=number(args[0]))
        elif cmd == "frequency_offset":
            state = replace(state, freq_offset=number(args[0]))
        elif cmd == "wave":
            state = replace(state, wave=number(args[0]))
        elif cmd == "stereo_panning":
            pass
        elif cmd == "MainLoop":
            loop_index = len(events)
        elif cmd == "EndMainLoop":
            return events, loop_index
        elif cmd == "music_end":
            return events, None
        elif cmd == "Loop":
            stack.append(["loop", pc, number(args[0])])
        elif cmd == "EndLoop":
            frame = stack[-1]
            assert frame[0] == "loop"
            frame[2] -= 1
            if frame[2]:
                pc = frame[1]
            else:
                stack.pop()
        elif cmd == "music_call":
            stack.append(["call", pc])
            pc = labels[args[0]]
        elif cmd == "music_ret":
            frame = stack.pop()
            assert frame[0] == "call"
            pc = frame[1]
        else:
            raise ValueError(f"unsupported TCG command {cmd} {args}")


def shape(events, channel):
    """Merge ties and split cutoffs. Returns items (pitch, octave, ticks, state, volume)."""
    out = []
    for i, ev in enumerate(events):
        following_tie = i + 1 < len(events) and events[i + 1].tied
        if ev.tied and out and out[-1][0] and out[-1][0] == ev.pitch and out[-1][1] == ev.octave and channel < 3:
            last = out[-1]
            out[-1] = (last[0], last[1], last[2] + ev.ticks, last[3], last[4])
            continue
        cut = ev.state.cutoff
        if channel < 3 and ev.pitch and 0 < cut < 8 and not following_tie:
            sound = (ev.ticks * cut) >> 3
            if 0 < sound < ev.ticks:
                out.append((ev.pitch, ev.octave, sound, ev.state, ev.state.volume))
                if channel == 2 or ev.state.echo >> 4:
                    out.append((ev.pitch, ev.octave, ev.ticks - sound, ev.state, ev.state.echo))
                else:
                    out.append((0, ev.octave, ev.ticks - sound, ev.state, None))
                continue
        out.append((ev.pitch, ev.octave, ev.ticks, ev.state, ev.state.volume))
    return out


def to_frames(items, start_tick=0):
    result, tick = [], start_tick
    for item in items:
        begin = round(tick * TICKS_TO_FRAMES)
        tick += item[2]
        frames = round(tick * TICKS_TO_FRAMES) - begin
        if not frames:
            continue
        if not item[0] and result and not result[-1][0]:
            last = result[-1]
            result[-1] = (0, last[1], last[2] + frames, last[3], last[4])
            continue
        result.append((item[0], item[1], frames, item[3], item[4]))
    return result, tick


def wave_volume(nr32):
    return (nr32 >> 5) & 3


class Emitter:
    def __init__(self, channel, label):
        self.channel = channel
        self.label = label
        self.lines = []
        self.speed = None
        self.intensity = None
        self.octave = None
        self.duty = None
        self.vibrato = None
        self.tone = None

    def emit(self, text):
        self.lines.append("\t" + text)

    def set_speed(self, speed, intensity):
        if self.channel == 3:
            self.emit(f"notetype {speed}")
        else:
            self.emit(f"notetype {speed}, ${intensity:02x}")
            self.intensity = intensity
        self.speed = speed

    def pick_speed(self, frames, is_note):
        if self.speed and frames % self.speed == 0 and (not is_note or frames // self.speed <= 16):
            return self.speed
        if not is_note:
            return 1
        for s in range((frames + 15) // 16, frames + 1):
            if frames % s == 0:
                return s
        return frames

    def item(self, pitch, octave, frames, state, volume):
        is_note = bool(pitch) or self.channel == 3
        if self.channel == 3:
            drum = DRUMS[pitch] if pitch else MUTE_DRUM
        intensity = None
        if self.channel < 2 and pitch:
            intensity = volume
        elif self.channel == 2 and pitch:
            intensity = (wave_volume(volume) << 4) | WAVES[state.wave]
        speed = self.pick_speed(frames, is_note)
        if speed != self.speed:
            self.set_speed(speed, intensity if intensity is not None else (self.intensity or 0))
        if intensity is not None and intensity != self.intensity:
            self.emit(f"intensity ${intensity:02x}")
            self.intensity = intensity
        if self.channel == 3:
            units = frames // speed
            assert units <= 16 and frames <= 255
            self.emit(f"drum_note {drum}, {units}")
            return
        if not pitch:
            # The engine keeps only the low byte of speed * length.
            units = frames // speed
            while units:
                take = min(16, units, 255 // speed)
                self.emit(f"rest {take}")
                units -= take
            return
        if self.channel < 2 and state.duty != self.duty:
            self.emit(f"dutycycle {state.duty}")
            self.duty = state.duty
        depth, rate = VIBRATO.get(state.vib_type, (0, 0)) if state.vib_delay else (0, 0)
        delay = max(1, round(state.vib_delay * TICKS_TO_FRAMES)) if depth else 0
        vib = (delay, depth, rate)
        if vib != self.vibrato:
            self.emit(f"vibrato {delay}, ${(depth << 4) | rate:02x}")
            self.vibrato = vib
        tone = state.freq_offset if state.freq_offset < 0x80 else -((state.freq_offset ^ 0xff))
        if tone != self.tone:
            self.emit(f"tone {tone & 0xffff}")
            self.tone = tone
        crystal_octave = max(1, min(8, octave + 1))
        if crystal_octave != self.octave:
            self.emit(f"octave {crystal_octave}")
            self.octave = crystal_octave
        units = frames // speed
        assert 1 <= units <= 16 and frames <= 255, (frames, speed)
        self.emit(f"note {PITCH_NAMES[pitch]}, {units}")


def convert(path, name):
    labels, code = parse(path)
    starts = [label for label in labels if re.search(r"_Ch[1-4]$", label)]
    channels = sorted(starts, key=lambda l: l[-1])
    out = [f"; Converted from pret/poketcg {path.split('/')[-1]} by tools/beast_triad/tcg_music.py.", "",
           f"{name}:"]
    out.append(f"\tmusicheader {len(channels)}, 1, {name}_Ch1")
    for i in range(2, len(channels) + 1):
        out.append(f"\tmusicheader 1, {i}, {name}_Ch{i}")
    out.append("")
    loop_ticks = set()
    for label in channels:
        channel = int(label[-1]) - 1
        events, loop_index = flatten(labels, code, label, channel)
        items = shape(events, channel)
        # Rebase the loop point on the shaped list.
        if loop_index is not None:
            loop_tick = sum(e.ticks for e in events[:loop_index])
            total_tick = sum(e.ticks for e in events)
            loop_ticks.add((loop_tick, total_tick))
            acc, split = 0, len(items)
            for j, it in enumerate(items):
                if acc >= loop_tick:
                    split = j
                    break
                acc += it[2]
            assert acc == loop_tick, "loop point inside a merged note"
            intro, _ = to_frames(items[:split])
            body, _ = to_frames(items[split:], loop_tick)
        else:
            intro, _ = to_frames(items)
            body = None
        em = Emitter(channel, f"{name}_Ch{channel + 1}")
        em.lines.append(f"{name}_Ch{channel + 1}:")
        if channel == 0:
            em.emit("tempo 256")
            em.emit("volume $77")
        if channel == 3:
            em.emit(f"togglenoise {DRUMKIT}")
        for it in intro:
            em.item(*it)
        if body is not None:
            em.lines.append(f"{name}_Ch{channel + 1}_loop:")
            # Commands at the loop head must not rely on state from the intro.
            em.speed = em.intensity = em.octave = em.duty = em.vibrato = em.tone = None
            for it in body:
                em.item(*it)
            em.emit(f"loopchannel 0, {name}_Ch{channel + 1}_loop")
        else:
            em.emit("endchannel")
        out += em.lines + [""]
    assert len(loop_ticks) <= 1, f"channels loop at different points: {loop_ticks}"
    return "\n".join(out)


def drumkit(path):
    """The TCG noise instruments as this engine's noise samples.

    TCG starts a hit with its envelope, then writes the next poly byte every
    tick without restarting, and silences the channel when the list ends.
    Here every sample entry restarts the envelope, so each run of one poly
    value becomes one entry, restarted at the volume the hit has decayed to.
    """
    NOISE = noise_instruments(path)
    assert sorted(i + 1 for i in NOISE) == sorted(DRUMS)
    names = {drum: f"TCGNoise{pitch}" for pitch, drum in DRUMS.items()}
    names[MUTE_DRUM] = "TCGNoiseMute"
    lines = ["BeastTriadTCGDrumkit:", "\tdw Drum00"] + [f"\tdw {names[i]}" for i in range(1, MUTE_DRUM + 1)] + [""]
    share_tail = True
    for index, data in sorted(NOISE.items()):
        nr41, nr42, nr44, polys = data[1], data[2], data[3], data[4:]
        volume, increase, period = nr42 >> 4, nr42 & 8, nr42 & 7
        ticks = len(polys)
        if nr44 & 0x40:
            ticks = min(ticks, round((64 - (nr41 & 0x3f)) / 256 * TICK_HZ))
        frames = max(1, round(ticks * TICKS_TO_FRAMES))
        timeline = [polys[min(int(f / TICKS_TO_FRAMES), len(polys) - 1)] for f in range(frames)]
        runs = []
        for poly in timeline:
            if runs and runs[-1][1] == poly:
                runs[-1][0] += 1
            else:
                runs.append([1, poly])
        # A sample lasts at least two frames: a one-frame run borrows a
        # frame from the next run.
        for k, run in enumerate(runs):
            if run[0] == 1 and k + 1 < len(runs):
                run[0] = 2
                runs[k + 1][0] -= 1
        runs = [run for run in runs if run[0] > 0]
        entries, start = [], 0
        for length, poly in runs:
            while length:
                take = min(17, length)
                if length - take == 1:
                    take -= 1
                take = max(2, take)
                vol = volume
                if period and not increase:
                    vol = max(0, volume - int(start / FRAME_HZ * 64 / period))
                if vol or increase:
                    entries.append((take, (vol << 4) | increase | period, poly))
                start += take
                length = max(0, length - take)
        lines.append(f"TCGNoise{index + 1}:")
        lines += [f"\tnoise C#, {take - 1}, ${env:02x}, ${poly:02x}" for take, env, poly in entries]
        if share_tail:
            # The audio bank is full: the first hit runs on into the
            # silence that the mute entry also uses.
            lines += ["TCGNoiseMute:", "\tnoise C#, 1, $00, $00"]
            share_tail = False
        else:
            lines.append("\tnoise C#, 1, $00, $00")
        lines.append("\tendchannel")
    return "\n".join(lines) + "\n"


def waves(poketcg_root):
    text = open(f"{poketcg_root}/src/audio/wave_instruments.asm", encoding="utf-8").read()
    return [line.strip() for line in text.splitlines() if line.strip().startswith("dn ")]


if __name__ == "__main__":
    if sys.argv[1] == "--drumkit":
        sys.stdout.write(drumkit(sys.argv[2]))
    else:
        open(sys.argv[3], "w", encoding="utf-8").write(convert(sys.argv[1], sys.argv[2]))

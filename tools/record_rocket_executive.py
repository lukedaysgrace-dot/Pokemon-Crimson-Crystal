#!/usr/bin/env python3
"""Record the native Rocket executive music and verify two synchronized loops.

Uses a private emulator cartridge and fresh game; never opens the user's save.
Requires the repository's PyBoy/numpy/imageio-ffmpeg environment and built ROM.
"""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import wave

import imageio_ffmpeg
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from symbols import _parse_constants

FPS = 4194304 / 70224
INTRO = 336
LOOP = 2688


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/rocket-executive')
    parser.add_argument('--score', type=Path, help='optional working score JSON for note-by-note checking')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    expected = {}
    if args.score:
        score = json.loads(args.score.read_text())
        pitches = {'C':1,'C#':2,'D':3,'D#':4,'E':5,'F':6,'F#':7,'G':8,'G#':9,'A':10,'A#':11,'B':12}
        for key, phrases in score.items():
            ch = int(key)
            events = phrases['Intro'] + sum((phrases[s] for s in ('A','B','C','D')), []) * 3
            ticks = 0
            expected[ch] = []
            for event in events:
                p = event['pitch']
                pitch = 0 if p in ('_', '__') else pitches[p if ch==4 else p[:-1]]
                octave = None if ch==4 or pitch==0 else 8-int(p[-1])
                expected[ch].append((ticks//256,pitch,octave,event['units'],event['notetype']))
                ticks += event['units'] * event['notetype'] * 224

    h = Harness(rom_path=ROOT/'pokecrystal.gbc', sound_emulated=True,
                emulator_kwargs={'sound_sample_rate':48000})
    pb, m = h.pb, h.battle.mem
    loops = {ch:[] for ch in range(1,5)}
    notes = {ch:[] for ch in range(1,5)}
    clock = [0]
    registered = []
    failures = []

    def register(name, fn):
        bank,address = h.sym[name]
        pb.hook_register(bank,address,fn,None)
        registered.append((bank,address))

    def update(_):
        clock[0] += 1

    def byte(_):
        ch = m.read('wCurChannel')+1
        if ch not in loops:
            return
        bank,address = h.sym[f'Music_RocketExecutiveBattle_Ch{ch}_Loop']
        ptr = m.read_bytes(f'wChannel{ch}MusicAddress',2)
        if (ptr[0] | ptr[1]<<8)==address and m.read(f'wChannel{ch}MusicBank')==bank:
            loops[ch].append(clock[0])

    def note(_):
        ch = m.read('wCurChannel')+1
        if ch not in notes:
            return
        value = m.read('wCurMusicByte')
        notes[ch].append((clock[0],value>>4,m.read(f'wChannel{ch}Octave'),
                          (value&15)+1,m.read(f'wChannel{ch}NoteLength')))

    try:
        print('Booting private, sound-enabled release ROM...',flush=True)
        new_game(h,0)
        m.write('wOptions',0x20)  # Native stereo option, including channel 1 pan.
        music = _parse_constants(ROOT/'constants/music_constants.asm')['MUSIC_ROCKET_EXECUTIVE_BATTLE']
        # Stop the map music before installing the score observer.
        begin_native_call(h,'PlayMusic')
        pb.register_file.D = pb.register_file.E = 0
        pb.tick(2,False,True)
        register('_UpdateSound',update)
        register('GetMusicByte',byte)
        register('ParseMusic.readnote',note)
        begin_native_call(h,'PlayMusic')
        pb.register_file.D, pb.register_file.E = music>>8,music&255
        audio=[]
        for frame in range(INTRO+2*LOOP+120):
            pb.tick(1,False,True)
            sound=pb.sound
            valid=np.frombuffer(sound.raw_buffer,dtype=np.int8,count=sound.raw_buffer_head)
            audio.append(valid.reshape(-1,2).astype(np.int16)*256)
            if frame and frame%1800==0:
                print(f'Recorded {frame/FPS:.0f} seconds...',flush=True)
        for ch,times in loops.items():
            if len(times)<3 or [times[i+1]-times[i] for i in range(2)] != [LOOP,LOOP]:
                failures.append(f'Channel {ch} loop drift: {times}')
            if not m.read(f'wChannel{ch}Flags1')&1:
                failures.append(f'Channel {ch} stopped')
        if len({tuple(t[:3]) for t in loops.values()})!=1:
            failures.append(f'Channels out of sync: {loops}')
        note_counts={}
        for ch,events in notes.items():
            note_counts[ch]=len(events)
            if ch not in expected:
                continue
            origin=events[0][0]
            for index,(actual,want) in enumerate(zip(events,expected[ch])):
                t,p,o,d,n=actual
                wt,wp,wo,wd,wn=want
                if (t-origin,p,d,n)!=(wt,wp,wd,wn) or (wo is not None and o!=wo):
                    failures.append(f'Channel {ch} note {index}: {actual} expected {want} (origin {origin})')
                    break
        samples=np.concatenate(audio)
        peak=int(np.max(np.abs(samples.astype(np.int32))))
        assert peak>0,'Silent recording'
        wav=args.output/'rocket-executive.wav'
        with wave.open(str(wav),'wb') as stream:
            stream.setnchannels(2)
            stream.setsampwidth(2)
            stream.setframerate(48000)
            stream.writeframes(samples.astype('<i2').tobytes())
        # Encode a complete intro and two loops with a short listening-preview fade.
        duration=(INTRO+2*LOOP)/FPS
        mp3=args.output/'rocket-executive.mp3'
        ffmpeg=imageio_ffmpeg.get_ffmpeg_exe()
        subprocess.run([ffmpeg,'-y','-v','error','-i',str(wav),'-t',str(duration),
            '-af',f'highpass=f=30,afade=t=out:st={duration-3}:d=3',
            '-codec:a','libmp3lame','-b:a','192k',
            '-metadata','title=Rocket Executive Battle - Sinister Command',
            '-metadata','album=Pokemon Crimson Crystal',str(mp3)],check=True)
        subprocess.run([ffmpeg,'-v','error','-i',str(mp3),'-f','null','-'],check=True)
        result=dict(loop_updates=loops,notes_checked=note_counts,score_checked=bool(expected),
                    peak=peak,duration_seconds=duration,failures=failures)
        (args.output/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
        print(json.dumps(result,indent=2),flush=True)
        print(f'MP3: {mp3}',flush=True)
        if failures:
            raise AssertionError('\n'.join(failures))
    finally:
        for bank,address in registered:
            pb.hook_deregister(bank,address)
        pb.stop(save=False)


if __name__=='__main__':
    main()

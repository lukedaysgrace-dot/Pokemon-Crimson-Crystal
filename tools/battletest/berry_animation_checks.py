#!/usr/bin/env python3
"""Record real ROM berry consumption, including rendered frames and game audio.

Fixtures use private emulator RAM; no player save is read or written.
"""
import argparse
import io
import json
from pathlib import Path
import subprocess
import sys
import wave

import numpy as np
from PIL import Image, ImageDraw
from runner import Harness
from symbols import ROOT, STATE_WAIT


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/held-items')
    parser.add_argument('--ffmpeg', type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    if args.ffmpeg is None:
        sys.path.insert(0, str(ROOT / '.tmpbuild/video-runtime'))
        import imageio_ffmpeg
        args.ffmpeg = Path(imageio_ffmpeg.get_ffmpeg_exe())
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate':48000})
    # Silent test fixtures store a disabled APU's sample clock. Bootstrap a
    # fresh sound-enabled fixture instead of importing that clock into a video.
    h.bootstrap()
    h.fixture = io.BytesIO()
    h.pb.save_state(h.fixture)
    pb, m = h.pb, h.battle.mem
    frames, audio, events, shots = [], [], [], []
    active = False
    bouncing = 0

    def berry_frame(_):
        nonlocal bouncing
        if active:
            bouncing += 1
            if bouncing in (2, 18, 40, 65, 90):
                shots.append((len(frames), pb.screen.image.copy().convert('RGB')))

    pb.hook_register(*h.sym['BattleAnimFunction_41'], berry_frame, None)
    def consumed(_):
        if active:
            events.append(dict(frame=len(frames), holder='player' if m.read('hBattleTurn') else 'enemy'))
    pb.hook_register(*h.sym['ItemRecoveryAnim'], consumed, None)

    def tick(n):
        for _ in range(n):
            pb.tick(1, True, True)
            frames.append(pb.screen.image.convert('RGB').tobytes())
            audio.append(pb.sound.ndarray.copy().astype(np.int16) * 128)

    results=[]
    try:
        for holder in ('player','enemy'):
            h.load_fixture()
            m.write('wOptions', 1) # fast text, battle animations on
            player=dict(species='PIKACHU',level=50,ability='NO_ABILITY',moves=['THUNDERSHOCK'])
            enemy=dict(species='SNORLAX',level=40,ability='NO_ABILITY',moves=['TACKLE'])
            recipient=player if holder=='player' else enemy
            recipient['item']='GOLD_BERRY'
            recipient['hp']=60 if holder=='player' else 51
            test=dict(player=player,enemy=enemy,rng='forced_high',turns=0)
            assert h.run_battle(test)==STATE_WAIT
            side=h.battle.player if holder=='player' else h.battle.enemy
            # Start just above the trigger; the normal opposing attack crosses it.
            hp=side.hp
            first=len(frames); before=len(events); bouncing=0
            active=True
            m.write('wDebugTurnTarget',1)
            m.write('wDebugControl',1)
            for frame in range(2400):
                if frame % 16 == 0:
                    pb.button('a',2)
                tick(1)
                if h.state()==STATE_WAIT and h.battle.turns_done==1:
                    break
            else:
                raise AssertionError('native battle turn timed out: '+str(h.control_state()))
            tick(90)
            active=False
            assert side.item=='NO_ITEM', (holder,side.item)
            assert len(events)>before and bouncing>=40, (holder,events,bouncing)
            pb.screen.image.resize((640,576),Image.Resampling.NEAREST).save(args.output/(holder+'-berry-after.png'))
            results.append(dict(holder=holder,frames=len(frames)-first,animation_frames=bouncing,
                                hp_before=hp,hp_after=side.hp,maxhp=side.maxhp))
    finally:
        pb.stop(save=False)
    silent=args.output/'berry-animation-silent.mp4'
    process=subprocess.Popen([str(args.ffmpeg),'-y','-v','error','-f','rawvideo',
        '-pixel_format','rgb24','-video_size','160x144','-framerate','60','-i','pipe:0',
        '-vf','scale=640:576:flags=neighbor','-an','-c:v','libx264','-crf','16',
        '-pix_fmt','yuv420p',str(silent)],stdin=subprocess.PIPE)
    for frame in frames: process.stdin.write(frame)
    process.stdin.close()
    assert process.wait()==0
    wav=args.output/'berry-animation-audio.wav'
    samples=np.concatenate(audio).astype('<i2')
    assert samples.size and np.any(samples), 'recording contains no game audio'
    with wave.open(str(wav),'wb') as stream:
        stream.setnchannels(2);stream.setsampwidth(2);stream.setframerate(48000)
        stream.writeframes(samples.tobytes())
    video=args.output/'berry-animation.mp4'
    subprocess.run([str(args.ffmpeg),'-y','-v','error','-i',str(silent),'-i',str(wav),
        '-c:v','copy','-c:a','aac','-movflags','+faststart','-shortest',str(video)],check=True)
    assert video.stat().st_size > 10000, 'encoded video is empty'
    sheet=Image.new('RGB',(5*320,2*310),'#eeeeee')
    draw=ImageDraw.Draw(sheet)
    for index,(frame,shot) in enumerate(shots[:10]):
        x=(index%5)*320;y=(index//5)*310
        sheet.paste(shot.resize((320,288),Image.Resampling.NEAREST),(x,y))
        draw.text((x+6,y+291),f'Frame {frame}',fill='#111111')
    sheet.save(args.output/'berry-animation-contact-sheet.png')
    (args.output/'berry-animation-results.json').write_text(json.dumps(dict(
        rom_hash=h.rom_key(),frames=len(frames),seconds=len(frames)/60,
        audio_samples=len(samples),audio_peak=int(np.abs(samples.astype(np.int32)).max()),
        events=events,results=results,video=str(video),video_bytes=video.stat().st_size),indent=2))
    print('BERRY ANIMATION: both native battlers consumed Gold Berry; berry sprites rendered with game audio')
    print('VIDEO', video)


if __name__=='__main__':
    main()

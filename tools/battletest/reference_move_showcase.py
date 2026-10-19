#!/usr/bin/env python3
"""Compare the supplied GBC clips with actual ROM footage of the three moves.

The reference files are private inputs, not website assets. Comparison footage
starts at the first visible effect, excluding reference menus/damage messages.
"""
import argparse
import hashlib
import io
import json
import subprocess
import wave
from pathlib import Path

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import capture, FPS
from october_animation_checks import AnimationAudit
from runner import Harness, ROOT
from symbols import STATE_WAIT

REFERENCES = {
    'VACUUM_WAVE': ('Vacuum Wave.webm', 171, 201),
    'DISCHARGE': ('Discharge.webm', 196, 320),
    'LAVA_PLUME': ('Lava Plume.webm', 231, 336),
}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--references', type=Path, default=Path('/mnt/c/Users/luked/Downloads'))
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    ff = imageio_ffmpeg.get_ffmpeg_exe()
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 22)
    title = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 32)
    encoder = subprocess.Popen([ff,'-y','-loglevel','error','-f','rawvideo',
        '-pixel_format','rgb24','-video_size','1280x720','-framerate',str(FPS/2),
        '-i','-','-an','-c:v','libx264','-preset','medium','-crf','17',
        '-pix_fmt','yuv420p',str(args.output/'comparison-silent.mp4')], stdin=subprocess.PIPE)
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate':48000})
    h.bootstrap()
    menu = io.BytesIO()
    h.pb.save_state(menu)
    sounds, report = [], {'moves':{}, 'rom_sha256':hashlib.sha256((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest()}
    try:
        for move,(file,first,last) in REFERENCES.items():
            source = args.references/file
            reader = imageio_ffmpeg.read_frames(str(source),pix_fmt='rgb24',output_params=['-vf','scale=160:144:flags=neighbor'])
            meta = next(reader)
            # Output scaling is fixed independently of the source's dimensions.
            reference = [np.frombuffer(raw,dtype=np.uint8).reshape(144,160,3).copy() for raw in reader]
            captures = []
            for side in (0,1):
                h.pb.stop(save=False)
                h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate':48000})
                menu.seek(0)
                h.pb.load_state(menu)
                h.battle.mem.write('wOptions',0x41)
                assert h.run_battle({'player':{'species':'SQUIRTLE','level':6,'ability':'NO_ABILITY','moves':['SPLASH']},
                    'enemy':{'species':'HOOTHOOT','level':2,'ability':'NO_ABILITY','moves':['SPLASH']},
                    'rng':'forced_high','turns':0}) == STATE_WAIT
                state = io.BytesIO()
                h.pb.save_state(state)
                audit = AnimationAudit(h,ROOT/'pokecrystal_debug.gbc')
                audit.current = f'{move}/{side}'
                frames,audio,check = capture(h,state,move,side,True,observer=audit.observe)
                audit.motion_checks(move,side)
                assert not audit.errors, audit.errors
                assert check['final_frame_changed_pixels']==0, check
                begin = min(p['samples'][0][0] for p in audit.spawns if p['samples'])
                check['first_effect_frame']=begin
                captures.append(check)
                timeline=Image.new('RGB',(1920,624),'#10131b')
                for cell,index in enumerate(np.linspace(begin,min(begin+last-first,len(frames)-1),12,dtype=int)):
                    x,y=cell%6*320,cell//6*312
                    timeline.paste(Image.fromarray(frames[index]).resize((320,288),Image.Resampling.NEAREST),(x,y+24))
                    ImageDraw.Draw(timeline).text((x+4,y+4),f'{move} / side {side} / frame {index-begin}',fill='white')
                timeline.save(args.output/f'{move.lower()}-{side}.png')
                if side: continue
                # Export each native player effect for direct frame inspection.
                for index,frame in enumerate(frames[begin:begin+last-first+12]):
                    Image.fromarray(frame).save(args.output/f'{move.lower()}-{index:03d}.png')
                start_audio=np.concatenate(audio)
                for speed in (1,0.5):
                    effect_count=max(last-first+1,len(frames)-begin-8)
                    count=round(effect_count/speed)+48
                    count+=count%2
                    for i in range(0,count,2):
                        phase=min(int(i*speed),effect_count-1)
                        left=reference[min(first+phase,last)]
                        right=frames[min(begin+phase,len(frames)-1)]
                        canvas=Image.new('RGB',(1280,720),'#10131b');draw=ImageDraw.Draw(canvas)
                        draw.text((640,3),move.replace('_',' ').title(),font=title,anchor='mt',fill='white')
                        draw.text((12,49),'YOUR REFERENCE',font=font,fill='#f3bd6b')
                        draw.text((652,49),'UPDATED ROM',font=font,fill='#81d3bb')
                        for x,frame in ((0,left),(640,right)):
                            canvas.paste(Image.fromarray(frame).resize((640,576),Image.Resampling.NEAREST),(x,88))
                        draw.text((20,681),f'{speed:g}x speed / Squirtle uses the move / audio from updated ROM',font=font,fill='white')
                        encoder.stdin.write(canvas.tobytes())
                    wanted=round(count/FPS*48000)
                    sample=start_audio[round(begin/FPS*48000):]
                    if speed==0.5: sample=np.repeat(sample,2,axis=0)
                    sample=np.pad(sample,((0,max(0,wanted-len(sample))),(0,0)))[:wanted]
                    sounds.append(sample)
            report['moves'][move]={'file':file,'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
                'reference_fps':meta['fps'],'reference_effect_frames':[first,last], 'captures':captures}
            print('Recorded',move,flush=True)
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        assert encoder.wait()==0
    pcm=np.concatenate(sounds)
    wav=args.output/'comparison-audio.wav'
    with wave.open(str(wav),'wb') as stream:
        stream.setnchannels(2);stream.setsampwidth(2);stream.setframerate(48000)
        stream.writeframes(pcm.astype('<i2').tobytes())
    final=args.output/'reference-comparison.mp4'
    subprocess.run([ff,'-y','-loglevel','error','-i',str(args.output/'comparison-silent.mp4'),
        '-i',str(wav),'-c:v','copy','-c:a','aac','-b:a','192k','-shortest','-movflags','+faststart',str(final)],check=True)
    (args.output/'reference-checks.json').write_text(json.dumps(report,indent=2)+'\n')
    print(final,flush=True)


if __name__=='__main__':
    main()

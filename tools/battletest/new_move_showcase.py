#!/usr/bin/env python3
"""Render all October move animations side by side with native game audio.

Calls the compiled ROM's animation routine in private emulator fixtures.
No real save is read or modified. Output includes MP4 chapters and capture QA.
"""
import argparse
import io
import json
from pathlib import Path
import subprocess
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from runner import Harness, ROOT
from mae_animation_checks import capture, FPS
from symbols import STATE_WAIT

CAST = {
    'PSYSHOCK': ('GARDEVOIR', 'GARDEVOIR'),
    'VACUUM_WAVE': ('LUCARIO', 'LUCARIO'),
    'DISCHARGE': ('AMPHAROS', 'AMPHAROS'),
    'LAVA_PLUME': ('TYPHLOSION', 'TYPHLOSION'),
    'METEOR_MASH': ('JIRACHI', 'JIRACHI'),
    'DRAGON_HAMMER': ('TYRANTRUM', 'TYRANTRUM'),
    'COTTON_GUARD': ('AMPHAROS', 'AMPHAROS'),
    'COSMIC_POWER': ('JIRACHI', 'JIRACHI'),
    'ERUPTION': ('TYPHLOSION', 'TYPHLOSION'),
    'WATER_SPOUT': ('BLASTOISE', 'BLASTOISE'),
    'DOOM_DESIRE': ('JIRACHI', 'JIRACHI'),
    'TAIL_GLOW': ('LANTURN', 'AMPHAROS'),
    'RECYCLE': ('PORYGON_Z', 'PORYGON_Z'),
    'PETAL_BLIZZARD': ('MEGANIUM', 'MEGANIUM'),
    'BLAZE_KICK': ('HITMONLEE', 'HITMONLEE'),
    'SKY_UPPERCUT': ('HITMONCHAN', 'HITMONCHAN'),
    'POISON_TAIL': ('SEVIPER', 'SEVIPER'),
    'OMINOUS_WIND': ('GENGAR', 'GENGAR'),
}
NOTES = {
    'PSYSHOCK': 'Special damage against physical Defense',
    'VACUUM_WAVE': 'Special Fighting attack with +1 priority',
    'DISCHARGE': '30% chance to paralyze',
    'LAVA_PLUME': '30% chance to burn',
    'METEOR_MASH': '100% accuracy / Punch / May raise Attack',
    'DRAGON_HAMMER': '120 base power / Lumi buff',
    'COTTON_GUARD': 'Raises Defense by three stages',
    'COSMIC_POWER': 'Raises Defense and Special Defense',
    'ERUPTION': 'Up to 150 power, scaled to current HP',
    'WATER_SPOUT': 'Up to 150 power, scaled to current HP',
    'DOOM_DESIRE': '160 power / Immediate hit / Cannot be used twice in a row',
    'TAIL_GLOW': 'Special Attack +3 / Lanturn and Ampharos',
    'RECYCLE': 'Recovers a consumed held item',
    'PETAL_BLIZZARD': 'Physical Grass attack / Wind move',
    'BLAZE_KICK': '90 power / 95% accuracy / High critical rate',
    'SKY_UPPERCUT': '100% accuracy / Punch / Hits Fly and Bounce',
    'POISON_TAIL': '90 power / High critical rate / May poison',
    'OMINOUS_WIND': 'Ghost wind / May raise all five combat stats',
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/new-move-showcase')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    receipt = json.loads((ROOT/'tools/testdata/move_expansion_20261019.json').read_text())
    rows = {}
    import re
    for line in (ROOT/'data/moves/moves.asm').read_text().splitlines():
        match = re.match(r'\s*move (.*?);(\w+)$', line)
        if match:
            rows[match[2]] = [v.strip() for v in match[1].split(',')]
    for move, actors in CAST.items():
        assert all(move in receipt['required'][actor] for actor in actors), (move, actors)

    fonts = Path('/usr/share/fonts/truetype/dejavu')
    regular = str(fonts/'DejaVuSans.ttf')
    bold = str(fonts/'DejaVuSans-Bold.ttf')
    title_font = ImageFont.truetype(bold, 36)
    label_font = ImageFont.truetype(bold, 17)
    detail_font = ImageFont.truetype(regular, 19)
    card_font = ImageFont.truetype(bold, 53)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    silent = args.output/'showcase-silent.mp4'
    final = args.output/'new-moves-showcase.mp4'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error',
        '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '1280x720',
        '-framerate', str(FPS/2), '-i', '-', '-an', '-c:v', 'libx264',
        '-preset', 'medium', '-crf', '17', '-pix_fmt', 'yuv420p', str(silent)],
        stdin=subprocess.PIPE)
    samples, captures, chapters = [], [], []
    video_frames = 0

    def write_frame(frame):
        nonlocal video_frames
        encoder.stdin.write(frame.tobytes())
        video_frames += 1

    def card():
        canvas = Image.new('RGB', (1280,720), '#10131b')
        draw = ImageDraw.Draw(canvas)
        draw.rectangle((48,80,1232,86), fill='#e34e6b')
        draw.text((640,208), 'CRIMSON CRYSTAL', font=card_font, anchor='mm', fill='white')
        draw.text((640,296), '18 new move animations', font=title_font, anchor='mm', fill='#ff8098')
        draw.text((640,389), 'Player and opponent views', font=detail_font, anchor='mm', fill='white')
        draw.text((640,427), 'Native ROM footage and game audio', font=detail_font, anchor='mm', fill='#c4c9d6')
        draw.text((640,610), 'Psyshock / Tail Glow / Doom Desire / and more', font=detail_font, anchor='mm', fill='#c4c9d6')
        return canvas

    intro_count=60
    intro=card()
    intro.save(args.output/'cover.png')
    for _ in range(intro_count): write_frame(intro)
    samples.append(np.zeros((round(intro_count/(FPS/2)*48000),2),dtype=np.int16))

    print('Booting native animation fixture with audio', flush=True)
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate':48000})
    h.bootstrap()
    menu = io.BytesIO()
    h.pb.save_state(menu)

    def fixture(player, enemy):
        nonlocal h
        # Isolate every view, including the emulator's decoded graphics caches.
        # Reuse the clean boot state with sound enabled to keep native audio.
        h.pb.stop(save=False)
        h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate':48000})
        menu.seek(0)
        h.pb.load_state(menu)
        h.battle.mem.write('wOptions', 0x41)
        mon=lambda c:{'species':c,'level':50,'ability':'NO_ABILITY','moves':['SPLASH']}
        assert h.run_battle({'player':mon(player),'enemy':mon(enemy),
            'rng':'forced_high','turns':0}) == STATE_WAIT
        result=io.BytesIO()
        h.pb.save_state(result)
        return result

    try:
        for index, move in enumerate(receipt['moves'],1):
            actors=CAST[move]
            print(f'Recording {index}/18 {move}: {actors}', flush=True)
            player_state = fixture(actors[0],'SNORLAX')
            left, audio, result_left = capture(h, player_state, move, 0, True)
            opponent_state = fixture('SNORLAX',actors[1])
            right, _, result_right = capture(h, opponent_state, move, 1, True)
            assert result_left['final_frame_changed_pixels'] == 0, (move, 'player screen did not recover')
            assert result_right['final_frame_changed_pixels'] == 0, (move, 'opponent screen did not recover')
            captures += [result_left,result_right]
            for side, sequence in enumerate((left,right)):
                timeline=Image.new('RGB',(1920,624),'#10131b')
                for cell, frame in enumerate(np.linspace(0,len(sequence)-1,12,dtype=int)):
                    x,y=cell%6*320,cell//6*312
                    timeline.paste(Image.fromarray(sequence[frame]).resize((320,288),Image.Resampling.NEAREST),(x,y+24))
                    ImageDraw.Draw(timeline).text((x+6,y+4),f'{move} / {side} / frame {frame}',fill='white')
                timeline.save(args.output/f'{move.lower()}-{side}.png')
            count=max(len(left),len(right))+48
            count += count % 2
            start=video_frames/(FPS/2)
            chapters.append({'move':move,'title':move.replace('_',' ').title(),
                'start':start,'seconds':count/FPS,'player':actors[0],'opponent':actors[1]})
            row=rows[move]
            stats=('Status' if row[3]=='CATEGORIZE_STATUS' else
                row[2].title()+' / '+row[3].removeprefix('CATEGORIZE_').title())
            power='--' if row[1]=='0' else row[1]
            accuracy='--' if row[3]=='CATEGORIZE_STATUS' else row[4]+'%'
            for frame_no in range(0,count,2):
                canvas=Image.new('RGB',(1280,720),'#10131b')
                draw=ImageDraw.Draw(canvas)
                draw.text((640,4), move.replace('_',' ').title(), font=title_font, anchor='mt', fill='white')
                draw.text((640,47), f'{stats}   |   Power {power}   |   Accuracy {accuracy}   |   PP {row[5]}',
                    font=detail_font,anchor='mt',fill='#d1d6e2')
                draw.text((16,68),'PLAYER / '+actors[0].replace('_',' '),font=label_font,fill='#ff8098')
                draw.text((656,68),'OPPONENT / '+actors[1].replace('_',' '),font=label_font,fill='#81c8ff')
                for x, sequence in ((0,left),(640,right)):
                    shot=Image.fromarray(sequence[min(frame_no,len(sequence)-1)])
                    canvas.paste(shot.resize((640,576),Image.Resampling.NEAREST),(x,88))
                draw.line((639,88,639,663),fill='#303a4d',width=2)
                draw.text((20,679), NOTES[move], font=detail_font, fill='white')
                draw.text((1258,679), f'{index:02d} / 18', font=detail_font, anchor='rt', fill='#ff8098')
                write_frame(canvas)
                if move=='DOOM_DESIRE' and frame_no==count//2//2*2:
                    canvas.save(args.output/'preview.png')
            sound=np.concatenate(audio)
            wanted=round(count/FPS*48000)
            sound=np.pad(sound,((0,max(0,wanted-len(sound))),(0,0)))[:wanted]
            # Gentle edge fades prevent clicks when cutting between native captures.
            edge=min(2400,len(sound)//2)
            envelope=np.linspace(0,1,edge)[:,None]
            sound[:edge]=(sound[:edge]*envelope).astype(np.int16)
            sound[-edge:]=(sound[-edge:]*envelope[::-1]).astype(np.int16)
            samples.append(sound)
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        status=encoder.wait()
        if status: raise RuntimeError('video encoder failed')

    audio=np.concatenate(samples)
    assert np.abs(audio.astype(np.int32)).max()>256, 'No native game audio captured'
    audiofile=args.output/'native-audio.wav'
    with wave.open(str(audiofile),'wb') as wav:
        wav.setnchannels(2);wav.setsampwidth(2);wav.setframerate(48000)
        wav.writeframes(audio.tobytes())
    metadata=args.output/'chapters.ffmetadata'
    lines=[';FFMETADATA1','title=Crimson Crystal - 18 New Move Animations',
        'comment=Native ROM animations. Left: player. Right: opponent. Audio: player capture.']
    for chapter in chapters:
        lines += ['[CHAPTER]','TIMEBASE=1/1000',
            'START='+str(round(chapter['start']*1000)),
            'END='+str(round((chapter['start']+chapter['seconds'])*1000)),
            'title='+chapter['title']]
    metadata.write_text('\n'.join(lines)+'\n')
    subprocess.run([ffmpeg,'-y','-loglevel','error','-i',str(silent),'-i',str(audiofile),
        '-i',str(metadata),'-map','0:v','-map','1:a','-map_metadata','2','-map_chapters','2',
        '-c:v','copy','-c:a','aac','-b:a','192k','-movflags','+faststart','-shortest',str(final)],check=True)
    report={'video':str(final),'moves':len(chapters),'native_previews':len(captures),
        'width':1280,'height':720,'fps':FPS/2,'seconds':video_frames/(FPS/2),
        'audio_rate':48000,'audio_peak':int(np.abs(audio.astype(np.int32)).max()),
        'chapters':chapters,'captures':captures}
    (args.output/'showcase.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({key:value for key,value in report.items() if key not in ('chapters','captures')}),flush=True)


if __name__=='__main__':
    main()


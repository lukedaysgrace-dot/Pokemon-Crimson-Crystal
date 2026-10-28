#!/usr/bin/env python3
"""Record selected current move animations from both sides with game audio."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import capture, stage, FPS
from runner import ROOT


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--moves', nargs='+', required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--name', default='move-animations')
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '1280x688', '-framerate', str(FPS/2),
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
        '-pix_fmt', 'yuv420p', str(out/'silent.mp4')], stdin=subprocess.PIPE)
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
    font = ImageFont.truetype(font_path, 23)
    small = ImageFont.truetype(font_path, 18)
    h, fixture = stage(ROOT/'pokecrystal_debug.gbc', audio=True)
    frames_written, sounds, chapters, checks = 0, [], [], []
    try:
        for move in args.moves:
            print('Recording', move, flush=True)
            left, audio, result = capture(h, fixture, move, 0, audio=True)
            right, _, other = capture(h, fixture, move, 1)
            checks.extend([result, other])
            chapters.append({'move': move, 'seconds': frames_written*2/FPS})
            count = max(len(left), len(right))+60
            count += count % 2
            for i in range(0, count, 2):
                img = Image.new('RGB', (1280, 688), '#101827')
                draw = ImageDraw.Draw(img)
                draw.text((20, 9), move.replace('_', ' ').title(), font=font, fill='white')
                for x, sequence, label in ((0, left, 'PLAYER USES THE MOVE'),
                                            (640, right, 'OPPONENT USES THE MOVE')):
                    draw.text((x+20, 44), label, font=small, fill='#7de1ba')
                    frame = Image.fromarray(sequence[min(i, len(sequence)-1)])
                    img.paste(frame.resize((640, 576), Image.Resampling.NEAREST), (x, 72))
                draw.text((20, 659), 'Native ROM animation • game audio • playback at game speed',
                          font=small, fill='#b8c3d5')
                encoder.stdin.write(img.tobytes())
                frames_written += 1
            samples = np.concatenate(audio)
            assert np.abs(samples.astype(np.int32)).max() > 0, ('silent move', move)
            target = round(count/FPS*48000)
            sounds.append(np.pad(samples[:target], ((0, max(0, target-len(samples))), (0, 0))))
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        assert encoder.wait() == 0
    with wave.open(str(out/'game-audio.wav'), 'wb') as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(48000)
        wav.writeframes(np.concatenate(sounds).astype('<i2').tobytes())
    final = out/(args.name+'.mp4')
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(out/'silent.mp4'),
        '-i', str(out/'game-audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
        '-shortest', '-movflags', '+faststart', str(final)], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(final), '-f', 'null', '-'], check=True)
    (out/'results.json').write_text(json.dumps({'chapters': chapters, 'checks': checks,
        'seconds': frames_written*2/FPS,
        'rom_hash': hashlib.md5((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest()[:12]}, indent=2)+'\n')
    print('PASS both-side cleanup, audible moves and full video/audio decoding', flush=True)
    print('VIDEO', final, flush=True)


if __name__ == '__main__':
    main()

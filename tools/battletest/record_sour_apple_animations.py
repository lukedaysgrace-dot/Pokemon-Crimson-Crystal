#!/usr/bin/env python3
"""Record every Sour Apple upgrade before/after, with audio and move chapters."""
import argparse
import sys, json, subprocess, wave, hashlib
from pathlib import Path
import numpy as np
import imageio_ffmpeg
root=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(root/'tools'),str(root/'tools/battletest')]
from audit_mae_animations import SOUR_APPLE
from mae_animation_checks import main
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--before-rom',type=Path,required=True)
parser.add_argument('--output',type=Path,default=root/'_artifacts/sour-apple-animation-update')
args=parser.parse_args()
out=args.output.resolve()
sys.argv=['mae_animation_checks.py','--record','--before-rom',str(args.before_rom.resolve()),
          '--output',str(out),'--update-label','SOUR APPLE','--moves',*sorted(SOUR_APPLE)]
main()
results=json.loads((out/'results.json').read_text())
meta=[';FFMETADATA1','title=Crimson Crystal - Sour Apple Animation Upgrades']
for i,c in enumerate(results['chapters']):
    end=results['chapters'][i+1]['seconds'] if i+1<len(results['chapters']) else results['video_seconds']
    title=c['move'].replace('_',' ').title()+' - '+('Player' if c['side']==0 else 'Opponent')
    meta += ['[CHAPTER]','TIMEBASE=1/1000',f'START={round(c["seconds"]*1000)}',f'END={round(end*1000)}',f'title={title}']
(out/'chapters.ffmetadata').write_text('\n'.join(meta)+'\n')
ffmpeg=imageio_ffmpeg.get_ffmpeg_exe()
target=out/'sour-apple-before-after.mp4'
subprocess.run([ffmpeg,'-y','-loglevel','error','-i',str(out/'all-changed-moves-before-after.mp4'),
    '-i',str(out/'chapters.ffmetadata'),'-map','0','-map_metadata','1','-map_chapters','1','-c','copy','-movflags','+faststart',str(target)],check=True)
subprocess.run([ffmpeg,'-v','error','-i',str(target),'-f','null','-'],check=True)
with wave.open(str(out/'comparison-audio.wav'),'rb') as wav:
    rate=wav.getframerate();samples=np.frombuffer(wav.readframes(wav.getnframes()),dtype='<i2').reshape(-1,2)
for i,c in enumerate(results['chapters']):
    end=results['chapters'][i+1]['seconds'] if i+1<len(results['chapters']) else results['video_seconds']
    assert np.max(np.abs(samples[round(c['seconds']*rate):round(end*rate)].astype(np.int32)))>0,('silent chapter',c)
assert len(results['chapters'])==2*len(SOUR_APPLE)
assert results['rom_hash']==hashlib.md5((root/'pokecrystal_debug.gbc').read_bytes()).hexdigest()[:12]
print('PASS video/audio decoding, audible chapters and final ROM hash',flush=True)
print('FINAL VIDEO',target,flush=True)

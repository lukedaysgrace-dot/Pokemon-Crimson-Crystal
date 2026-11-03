#!/usr/bin/env python3
"""Check both hippos' native normal/shiny graphics and render a battle sheet."""
from pathlib import Path
import re
import struct

from PIL import Image, ImageDraw

from runner import Harness, ROOT
from symbols import STATE_WAIT


def main():
    out = ROOT / '_artifacts/hippos'
    out.mkdir(parents=True, exist_ok=True)
    h = Harness(render=True)
    h.ensure_fixture()
    m = h.battle.mem
    shiny = False
    checks = 0
    screens = []

    def entry_flags(which):
        flags = 0x80 if shiny else 0x40
        m.write(('wPartyMon' if which == 0 else 'wOTPartyMon') + '1Unused', flags)
        if which == 1:
            m.write('wEnemyMonShinyGenderFlags', flags)

    h.pb.hook_register(*h.sym['InitPlayerIllusion'], lambda _: entry_flags(0), None)
    h.pb.hook_register(*h.sym['InitEnemyIllusion'], lambda _: entry_flags(1), None)
    try:
        for species in ('HIPPOPOTAS', 'HIPPOWDON'):
            folder = ROOT / 'gfx/pokemon' / species.lower()
            for shiny in (False, True):
                if shiny:
                    values = [tuple(map(int, row.split(','))) for row in
                              re.findall(r'^\s*RGB\s+([\d, ]+)', (folder / 'shiny.pal').read_text(), re.M)]
                    middle = b''.join(struct.pack('<H', r | g << 5 | b << 10) for r, g, b in values)
                else:
                    middle = (folder / 'front.gbcpal').read_bytes()[2:6]
                for side in (0, 1):
                    h.load_fixture()
                    m.write('wOptions', 0xc1)
                    holder = dict(species=species, level=50, ability='SAND_FORCE', moves=['BITE'])
                    other = dict(species='MEW', level=50, ability='NO_ABILITY', moves=['SPLASH'])
                    assert h.run_battle(dict(player=holder if side == 0 else other,
                                             enemy=other if side == 0 else holder,
                                             rng='forced_high', turns=0)) == STATE_WAIT
                    actual = m.read_bytes('wBGPals1', 4, side * 8 + 2)
                    assert actual == middle, (species, shiny, side, 'native palette', actual, middle)
                    checks += 1
                    address = 0x9310 if side == 0 else 0x9000
                    expected = (folder / ('back.2bpp' if side == 0 else 'front.2bpp')).read_bytes()
                    if side == 1:
                        # rgbgfx's front asset is column-major; native VRAM is row-major.
                        expected = b''.join(expected[(x*7+y)*16:(x*7+y+1)*16]
                                            for y in range(7) for x in range(7))
                    actual = bytes(h.pb.memory[0, address:address+len(expected)])
                    assert actual == expected, (species, shiny, side, 'native picture tiles')
                    checks += 1
                    h.tick(2)
                    label = f'{species.title()} {"shiny" if shiny else "normal"} {"back" if side == 0 else "front"}'
                    picture = h.pb.screen.image.convert('RGB').copy()
                    picture.save(out / (label.lower().replace(' ', '-') + '.png'))
                    screens.append((label, picture))
        canvas = Image.new('RGB', (640, 1240), '#16202d')
        draw = ImageDraw.Draw(canvas)
        for i, (label, picture) in enumerate(screens):
            x, y = (i % 2) * 320, (i // 2) * 310
            draw.text((x+8, y+5), label, fill='white')
            canvas.paste(picture.resize((320, 288), Image.Resampling.NEAREST), (x, y+22))
        canvas.save(out / 'battle-sprites.png')
        print(f'HIPPO PRESENTATION PASSED: {checks} exact native normal/shiny tile and palette checks', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Compare native Aegislash form tiles/palettes with independent form controls."""
from pathlib import Path

from PIL import Image, ImageDraw

from runner import Harness, ROOT, apply_wram_setup
from symbols import STATE_WAIT


def main():
    out = ROOT / '_artifacts/roster'
    out.mkdir(parents=True, exist_ok=True)
    h = Harness(render=True)
    h.ensure_fixture()
    m = h.battle.mem
    screens = []
    checks = 0

    def appearance(side):
        address, count = (0x9310, 36 * 16) if side == 0 else (0x9000, 49 * 16)
        return bytes(h.pb.memory[0, address:address+count]), m.read_bytes('wBGPals1', 8, side*8)

    def stage(spec):
        h.load_fixture()
        m.write('wOptions', 0xc1)  # animation-free controls use the static base frames
        assert h.run_battle(dict(spec, rng='forced_high', turns=0)) == STATE_WAIT

    def advance(turn):
        m.write('wDebugTurnTarget', turn)
        m.write('wDebugControl', 1)
        for frame in range(12000):
            if frame % 8 == 0:
                h.pb.button('a', 2)
            h.tick(1)
            if h.state() == STATE_WAIT and h.battle.turns_done == turn:
                return
        raise AssertionError('Native form transition timed out')

    def screen(label):
        h.tick(2)
        result = h.pb.screen.image.convert('RGB').copy()
        result.save(out / (label.replace(' ', '-').lower()+'.png'))
        screens.append((label, result))

    try:
        for side in (0, 1):
            controls = {}
            for species in ('AEGISLASH', 'AEGISLASH_BLADE'):
                holder = dict(species=species, level=50, ability='NO_ABILITY', moves=['SPLASH'])
                other = dict(species='MEW', level=100, moves=['SPLASH'])
                stage({'player': holder if side == 0 else other,
                       'enemy': other if side == 0 else holder})
                controls[species] = appearance(side)
            assert controls['AEGISLASH'] != controls['AEGISLASH_BLADE'], 'Form controls are indistinguishable'
            checks += 1
            holder = dict(species='AEGISLASH', level=50, ability='STANCE_CHANGE', moves=['IRON_HEAD', 'KINGS_SHIELD'])
            other = dict(species='MEW', level=100, moves=['SPLASH'])
            stage({'player': holder if side == 0 else other, 'enemy': other if side == 0 else holder,
                   'move_script': [1, 2] if side == 0 else []})
            assert appearance(side) == controls['AEGISLASH'], 'Wrong Shield appearance on entry'
            checks += 1
            advance(1)
            assert appearance(side) == controls['AEGISLASH_BLADE'], 'Wrong native Blade tiles or palette'
            checks += 1
            screen('Player Blade' if side == 0 else 'Enemy Blade')
            if side == 1:
                apply_wram_setup(h.battle, {'wEnemyMonMoves': {'move': 'KINGS_SHIELD'}})
            advance(2)
            assert appearance(side) == controls['AEGISLASH'], 'Wrong native Shield tiles or palette after guard'
            checks += 1
            screen('Player Shield' if side == 0 else 'Enemy Shield')

        canvas = Image.new('RGB', (640, 620), '#16202d')
        draw = ImageDraw.Draw(canvas)
        for i, (label, picture) in enumerate(screens):
            x, y = (i % 2)*320, (i // 2)*310
            draw.text((x+8, y+5), label, fill='white')
            canvas.paste(picture.resize((320, 288), Image.Resampling.NEAREST), (x, y+22))
        canvas.save(out / 'aegislash-forms.png')
        print(f'ROSTER VISUAL CHECKS PASSED: {checks} exact native front/back tile and palette comparisons', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()

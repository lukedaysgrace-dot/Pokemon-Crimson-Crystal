#!/usr/bin/env python3
"""Check complete battler palettes, stat colors, stage loops, and cleanup."""

import io
from pathlib import Path

from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from symbols import STATE_WAIT, _parse_constants


# Polished Crystal's custom stat palettes, in this game's stat-id order.
STAT_COLORS = [
    ('attack', [(31, 19, 8), (29, 9, 10), (21, 0, 7)]),
    ('defense', [(20, 28, 4), (3, 22, 4), (0, 16, 0)]),
    ('speed', [(19, 26, 28), (0, 19, 29), (9, 13, 30)]),
    ('sp-attack', [(31, 25, 28), (31, 16, 23), (27, 0, 22)]),
    ('sp-defense', [(31, 29, 0), (23, 22, 0), (16, 16, 0)]),
    ('accuracy', [(25, 20, 30), (18, 10, 26), (14, 6, 23)]),
    ('evasion', [(13, 29, 23), (3, 23, 16), (0, 18, 12)]),
]


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    h.battle.mem.write('wOptions', 0x41)
    state = h.run_battle({
        'player': {'species': 'MEW', 'level': 50, 'moves': ['SPLASH']},
        'enemy': {'species': 'SNORLAX', 'level': 50, 'moves': ['SPLASH']},
        'rng': 'forced_high', 'turns': 0,
    })
    assert state == STATE_WAIT
    fixture = io.BytesIO()
    h.pb.save_state(fixture)
    output = ROOT / '.tmpbuild/stat-animation-checks'
    output.mkdir(exist_ok=True)
    sfx = _parse_constants(ROOT / 'constants/sfx_constants.asm')
    active_sfx = []

    def sound_started(_):
        registers = h.pb.register_file
        sound = registers.D * 256 + registers.E
        if sound in (sfx['SFX_STAT_UP'], sfx['SFX_STAT_DOWN']):
            active_sfx.append(sound)

    bank, address = h.sym['PlayStereoSFX']
    h.pb.hook_register(bank, address, sound_started, None)

    def palette(buffer, slot):
        return h.battle.mem.read_bytes(buffer, 8, slot * 8)

    def mon_palettes():
        return [palette(buffer, slot) for buffer, slots in (
            ('wBGPals1', (0, 1, 6)), ('wOBPals1', (0, 1))) for slot in slots]

    # A tick can stop halfway through a WRAM copy; check completed updates.
    palette_updates = [
        ('CopyPals', 'ClearVBank1'),
        ('CopyAnimObjPal', 'PoisonPurplePalette'),
        ('SetBattleAnimPal', 'ReloadBattleAnimDefaultPals'),
        ('BGEffects_LoadBGPal0_OBPal1', 'BattleBGEffect_GetFirstDMGPal'),
    ]

    def copying_palette():
        pc = h.pb.register_file.PC
        bank = h.battle.mem.read('hROMBank') if pc >= 0x4000 else 0
        return any(bank == h.sym[start][0] and h.sym[start][1] <= pc < h.sym[end][1]
                   for start, end in palette_updates)

    passed = 0
    try:
        for side in (0, 1):
            for stat, (name, colors) in enumerate(STAT_COLORS):
                expected = b''.join((r | g << 5 | b << 10).to_bytes(2, 'little')
                                    for r, g, b in [(31, 31, 31)] + colors)
                for down in (False, True):
                    for stages in (1, 2):
                        fixture.seek(0)
                        h.pb.load_state(fixture)
                        m = h.battle.mem
                        label = f'{side}-{name}-{"down" if down else "up"}-{stages}'
                        before = mon_palettes()
                        m.write('hBattleTurn', side ^ int(down))
                        m.write('wLoweredStat', stat | (stages - 1) << 4)
                        active_sfx.clear()
                        begin_native_call(h, 'PlayStatDownAnim_Core' if down else 'PlayStatUpAnim_Core')
                        # Stop interrupts only after the animation has returned.
                        h.pb.memory[0xc0f0] = 0xf3
                        saw_color = saw_fade = False
                        captured = False
                        bg_slot, obj_slot = (1, 0) if side else (0, 1)
                        for frame in range(300):
                            h.tick(1)
                            base = palette('wBGPals1', bg_slot)
                            display = palette('wBGPals2', bg_slot)
                            if base == expected and not copying_palette():
                                saw_color = True
                                assert palette('wOBPals1', obj_slot) == base, label
                                assert palette('wOBPals2', obj_slot) == display, label
                                if not side:
                                    # The circled patch is BG palette 6, across row 9.
                                    assert palette('wBGPals1', 6) == base, label
                                    assert palette('wBGPals2', 6) == display, label
                                saw_fade |= display != base
                                if display != base and not captured:
                                    h.pb.screen.image.save(output / f'{label}.png')
                                    captured = True
                            if h.pb.register_file.PC in (0xc0f1, 0xc0f3):
                                break
                        else:
                            pc = h.pb.register_file.PC
                            bank = m.read('hROMBank') if pc >= 0x4000 else 0
                            raise AssertionError((label, 'animation did not return', h.sym.nearest(bank, pc), hex(h.pb.register_file.SP)))
                        assert saw_color and saw_fade, label + ': missing stat color/pulse'
                        expected_sfx = sfx['SFX_STAT_DOWN' if down else 'SFX_STAT_UP']
                        assert active_sfx == [expected_sfx] * stages, (label, active_sfx)
                        assert mon_palettes() == before, label + ': battler colors not restored'
                        passed += 1
            print(f'PASS stat animations on {"enemy" if side else "player"}: all seven colors, +/-1 and +/-2')
    finally:
        h.pb.stop(save=False)
    print(f'{passed} stat animation scenarios passed; complete sprite tint/fade, SFX loops, palette cleanup')


if __name__ == '__main__':
    main()

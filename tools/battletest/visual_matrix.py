#!/usr/bin/env python3
"""Native menu/text rendering at all 20 frames, three speeds, scenes on/off.

Capture live ability overlays and populated text, as well as the clean menu
afterward. Bounds checks observe actual glyph writes throughout each battle.
"""

import argparse
from pathlib import Path

from runner import Harness, AssertionContext
from ui_checks import start, choose, tile_text


CASES = [
    ('Bounce Swagger', 'NO_ABILITY', 'MAGIC_BOUNCE', 2,
     ['player.stat_levels[0] == 9', 'enemy.stat_levels[0] == 7', '(player.substatus[2] & 128) != 0']),
    ('Gas Swagger', 'NEUTRALIZING_GAS', 'MAGIC_BOUNCE', 2,
     ['enemy.stat_levels[0] == 9', 'player.stat_levels[0] == 7', '(enemy.substatus[2] & 128) != 0']),
    ('Mold Contrary', 'MOLD_BREAKER', 'CONTRARY', 2,
     ['enemy.stat_levels[0] == 9', '(enemy.substatus[2] & 128) != 0']),
    ('Swap Pressure', 'SYNCHRONIZE', 'PRESSURE', 3,
     ["player.ability == 'PRESSURE'", "enemy.ability == 'SYNCHRONIZE'", 'player.start_pp[2] - player.pp[2] == 2']),
    ('Contact Stamina', 'NO_ABILITY', 'STAMINA', 1,
     ['enemy.hp < enemy.start_hp', 'enemy.stat_levels[1] == 8']),
]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--shard', type=int, default=0)
    parser.add_argument('--shards', type=int, default=1)
    args = parser.parse_args()
    h = Harness()
    h.ensure_fixture()
    output = Path('.venv/visual-matrix')
    output.mkdir(parents=True, exist_ok=True)
    original_tick = h.tick
    active = None
    captured, ages = set(), {}
    images = passed = failed = assertions = 0
    banner_ready = False
    completed = []
    message_index = 0

    def text_finished(context):
        if active is not None and h.text_context:
            completed.append(h.text_context)
        h._end_text(context)

    bank, address = h.sym['PrintTextboxText.done']
    h.pb.hook_deregister(bank, address)
    h.pb.hook_register(bank, address, text_finished, None)

    def banner_drawn(_):
        nonlocal banner_ready
        if active is not None:
            banner_ready = True

    bank, address = h.sym['PerformAbilityGFX.DrawBannerText']
    # The RET immediately before DrawBannerText follows the completed upload.
    h.pb.hook_register(bank, address - 1, banner_drawn, None)

    def tick(frames=1):
        nonlocal images, banner_ready, message_index
        for _ in range(frames):
            original_tick(1)
            if active is None:
                continue
            if completed:
                # The text engine's own completion hook follows its BGMap
                # update. Capture its fully rendered message this frame.
                completed.clear()
                h.pb.screen.image.save(str(output / f'{active}-message-{message_index:02d}.png'))
                message_index += 1
                images += 1
            # Capture after VRAM has had time to display the populated tilemap.
            banner = h.battle.mem.read('wInAbility') and banner_ready
            context = h.text_context
            label = 'banner' if banner else 'text' if context else None
            if label is None or label in captured:
                continue
            ages[label] = ages.get(label, 0) + 1
            if ages[label] >= 24 and (label == 'banner' or 'WW' in tile_text(h)):
                h.pb.screen.image.save(str(output / f'{active}-{label}.png'))
                captured.add(label)
                images += 1

    h.tick = tick
    for frame in range(20):
        for speed in (1, 3, 5):
            for scene_off in (False, True):
                index = frame * 6 + (speed // 2) * 2 + int(scene_off)
                if index % args.shards != args.shard:
                    continue
                case, source, target, slot, expressions = CASES[index % len(CASES)]
                name = f'frame{frame:02d}-speed{speed}-scene{int(not scene_off)}-{case.replace(" ", "-")}'
                options = 0x40 | speed | (0x80 if scene_off else 0)
                setup = {'wBattleMonNick': [0x96] * 10 + [0x50],
                         'wEnemyMonNick': [0x96] * 10 + [0x50]}
                active = None
                banner_ready = False
                message_index = 0
                completed.clear()
                try:
                    snapshot = start(h, source, target, setup, options, frame)
                    captured.clear()
                    ages.clear()
                    active = name
                    choose(h, slot, snapshot['player']['pp'][slot - 1])
                    active = None
                    env = AssertionContext(h.battle, snapshot, {}).env()
                    checks = expressions + ['wram("hDebugActive") == 0', 'wram("wInAbility") == 0',
                                             '(wram("wDisguiseBusted", 1) & 64) == 0',
                                             f'wram("wTextboxFrame") == {frame}', f'wram("wOptions") == {options}']
                    assertions += len(checks)
                    errors = list(h.text_overflows) + [expr for expr in checks if not eval(expr, {'__builtins__': {}}, env)]
                    if 'text' not in captured:
                        errors.append('no live populated text captured')
                    h.pb.screen.image.save(str(output / f'{name}-menu.png'))
                    images += 1
                    if errors:
                        failed += 1
                        print(f'FAIL VISUAL {name}: {errors}', flush=True)
                    else:
                        passed += 1
                        print(f'PASS VISUAL {name}: {sorted(captured)}', flush=True)
                except Exception as error:
                    active = None
                    failed += 1
                    print(f'ERROR VISUAL {name}: {error}', flush=True)
    h.pb.stop(save=False)
    print(f'{passed} visual scenarios passed, {failed} failed; {assertions} assertions, {images} live/menu captures')
    return int(bool(failed))


if __name__ == '__main__':
    raise SystemExit(main())

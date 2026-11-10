#!/usr/bin/env python3
"""Capture unaccelerated native battle evidence for the November audit."""
import json
from pathlib import Path

from PIL import Image, ImageDraw
import yaml

from dynamic_type_matrix import generate_dynamic_type_tests
from priority_target_matrix import generate_priority_target_tests
from runner import (Harness, ROOT, FRAME_CEILING_BATTLE, AssertionContext,
                    snapshot_side, apply_wram_setup, capture_result)
from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR


def main():
    out = ROOT / '_artifacts/battle-audit-2026-11-10'
    out.mkdir(parents=True, exist_ok=True)
    hidden = yaml.safe_load((ROOT / 'tools/battletest/tests/98-hidden-power-interactions.yaml').read_text())
    called = yaml.safe_load((ROOT / 'tools/battletest/tests/99-called-move-priority.yaml').read_text())
    dynamic = generate_dynamic_type_tests()
    targets = generate_priority_target_tests()
    names = [
        ('Flying Hidden Power blocked', next(t for t in hidden if 'Queenly Majesty blocks' in t['name'])),
        ('Called priority stays blocked', next(t for t in called if "Prankster Sleep Talk's Tackle remains" in t['name'])),
        ('Called Peck stays normal priority', next(t for t in called if "Gale Wings doesn't" in t['name'])),
        ('Weather Ball remembered type', next(t for t in dynamic if t['name'] == 'Dynamic type: player Conversion2 versus sun Weather Ball seed 1')),
        ('Forewarn chooses Rock Slide', next(t for t in hidden if 'Forewarn ranks Hidden Power at 70, below' in t['name'])),
        ('Prankster Mimic meets Dark immunity', next(t for t in targets if t['name'] == 'Priority target: player PRANKSTER MIMIC versus Dark NO_ABILITY')),
    ]
    h = Harness(render=True)
    h.ensure_fixture()
    original_tick = h.tick
    original_end = h._end_text
    current = None
    pending = None
    pending_label = None
    captured = {}
    results = []

    def save(label):
        path = out / f'{current}-{label}.png'
        h.pb.screen.image.save(path)
        captured.setdefault(current, []).append(path)

    def end_text(context):
        nonlocal pending, pending_label
        label = h.text_context or ''
        original_end(context)
        if any(part in label for part in ('ForewarnAlert', 'TransformedType', 'DidntAffect', 'DoesntAffect', 'ButItFailed')):
            pending = 3
            pending_label = 'text'

    def action(_context):
        # These scripts have completed usedmovetext and WaitBGMap before
        # doturn. Observe the committed screen before the next command.
        if current is not None and not h.battle.mem.read('hBattleTurn'):
            move = h.battle.mem.move_index_of(h.battle.mem.read('wCurPlayerMove'))
            if move in (h.con.move_index('PECK'), h.con.move_index('MIMIC')):
                save('move')

    def banner(_context):
        if current is not None:
            save('ability')

    def tick(frames=1):
        nonlocal pending
        for _ in range(frames):
            original_tick(1)
            if pending is not None:
                pending -= 1
                if pending <= 0:
                    save(pending_label)
                    pending = None

    text_hook = h.sym['PrintTextboxText.done']
    h.pb.hook_deregister(*text_hook)
    h.pb.hook_register(*text_hook, end_text, None)
    banner_hook = h.sym['EndAbility']
    h.pb.hook_register(*banner_hook, banner, None)
    h.pb.hook_register(*h.sym['BattleCommand_DoTurn'], action, None)
    h.tick = tick
    try:
        for index, (title, test) in enumerate(names, 1):
            current = f'{index:02d}'
            pending = None
            h.load_fixture()
            assert h.run_battle(dict(test, turns=0)) == STATE_WAIT
            snapshot = dict(player=snapshot_side(h.battle.player), enemy=snapshot_side(h.battle.enemy))
            apply_wram_setup(h.battle, test.get('setup_wram'))
            turns = test.get('turns', 1)
            if turns:
                h.battle.mem.write('wDebugTurnTarget', turns)
                h.battle.mem.write('wDebugControl', 1)
                for _ in range(0, FRAME_CEILING_BATTLE, 4):
                    state = h.state()
                    if state in (STATE_DONE, STATE_ERROR) or (state == STATE_WAIT and h.battle.turns_done >= turns):
                        break
                    h.pb.button('a', 2)
                    h.tick(4)
                else:
                    raise RuntimeError(title + ' timed out')
            env = AssertionContext(h.battle, snapshot).env()
            for expression in test['assert']:
                assert eval(expression, {'__builtins__': {}}, env), (title, expression)
            save('final')
            results.append(dict(title=title, case=test['name'], result=capture_result(h.battle, snapshot),
                                textbox_order=list(h.battle.textbox_order),
                                files=[str(path.relative_to(out)) for path in captured[current]]))
        sheet = Image.new('RGB', (720, 972), '#18212d')
        draw = ImageDraw.Draw(sheet)
        for index, result in enumerate(results):
            prefix = f'{index + 1:02d}'
            choices = captured[prefix]
            selected = next((p for p in reversed(choices) if p.stem.endswith('text')),
                            next((p for p in reversed(choices) if p.stem.endswith('move')),
                                 next((p for p in reversed(choices) if p.stem.endswith('ability')), choices[-1])))
            x, y = (index % 2) * 360 + 20, (index // 2) * 324 + 12
            frame = Image.open(selected).convert('RGB').resize((320, 288), Image.Resampling.NEAREST)
            draw.text((x, y), result['title'], fill='white')
            sheet.paste(frame, (x, y + 20))
        sheet.save(out / 'native-battle-evidence.png')
        (out / 'results.json').write_text(json.dumps(dict(rom_sha256=h.rom_sha256, cases=results), indent=2))
        print(f'NATIVE BATTLE CAPTURES: {len(results)} unaccelerated battles passed; {out}')
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()

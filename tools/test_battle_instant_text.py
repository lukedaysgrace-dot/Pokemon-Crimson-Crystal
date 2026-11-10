#!/usr/bin/env python3
"""Compare native battle outcomes and rendered text with letter delays on/off."""
import sys
import json
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness, apply_wram_setup, snapshot_side, capture_result, FRAME_CEILING_BATTLE
from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR


def run(h, test):
    h.load_fixture()
    spec = dict(test, turns=0)
    state = h.run_battle(spec)
    assert state == STATE_WAIT, (test['name'], state)
    snapshot = dict(player=snapshot_side(h.battle.player), enemy=snapshot_side(h.battle.enemy))
    apply_wram_setup(h.battle, test.get('setup_wram'))
    turns = test.get('turns', 1)
    for turn in range(1, turns + 1):
        h.battle.mem.write('wDebugTurnTarget', turn)
        h.battle.mem.write('wDebugControl', 1)
        for _ in range(0, FRAME_CEILING_BATTLE, 4):
            state = h.state()
            if state in (STATE_DONE, STATE_ERROR) or (state == STATE_WAIT and h.battle.turns_done >= turn):
                break
            h.pb.button('a', 2)
            h.tick(4)
        else:
            raise RuntimeError(test['name'] + ' timed out')
        if state != STATE_WAIT:
            break
        apply_wram_setup(h.battle, (test.get('turn_setup_wram') or {}).get(turn))
    party_hp = [h.battle.mem.read_u16_be(f'wPartyMon{slot + 1}HP')
                for slot in range(h.battle.mem.read('wPartyCount'))]
    return (state, capture_result(h.battle, snapshot), list(h.battle.textbox_order), list(h.text_overflows), party_hp)


def main():
    cases = []
    for filename in ('00-smoke.yaml', '98-hidden-power-interactions.yaml', '95-moves-abilities-audit.yaml',
                     '99-called-move-priority.yaml'):
        cases += yaml.safe_load((ROOT / 'tools/battletest/tests' / filename).read_text())
    harnesses = [Harness(render=False), Harness(render=False, instant_text=True),
                 Harness(render=False, instant_text=True, short_delays=True)]
    try:
        for h in harnesses:
            h.ensure_fixture()
        for test in cases:
            ordinary = run(harnesses[0], test)
            for mode, h in enumerate(harnesses[1:], 1):
                accelerated = run(h, test)
                if ordinary != accelerated:
                    print(json.dumps({'case': test['name'], 'mode': mode,
                                      'ordinary': ordinary, 'accelerated': accelerated}, indent=2), flush=True)
                    raise AssertionError(test['name'])
        print(f'PRESENTATION MODES: {len(cases)} native battles have identical outcomes and rendered text commands '
              'with ordinary text, instant letters and shortened fixed pauses')
    finally:
        for h in harnesses:
            h.pb.stop(save=False)


if __name__ == '__main__':
    main()

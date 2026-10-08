#!/usr/bin/env python3
"""Native Safari fee/door/exit/Save/Continue checks with private fixtures.

Only initial party, money, location and end-of-session boundary counters are
staged. Buttons drive the actual movement, scripts, menus, save and reload.
No ROM routines are patched. This is not a natural campaign playthrough.
"""
import io
import json
import re
from pathlib import Path

from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from gameplay_rules_checks import new_game, save_continue
from overworld_controls import Controls
from ui_checks import tile_text
from symbols import ROOT

OUTPUT = ROOT / '.tmpbuild/overworld-audit/safari-ui'


def map_ids():
    result = {}
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s*map_const\s+(\w+)', line)
        if match:
            number += 1
            result[match.group(1)] = group, number
    return result


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness()
    new_game(h, 0)
    m, c = h.battle.mem, Controls(h)
    maps = map_ids()
    lobby, zone = maps['SAFARI_ZONE_LOBBY'], maps['SAFARI_ZONE']
    checks, failures = 0, []
    pending = [False]

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)
            print('FAIL:', message, flush=True)

    def capture(label):
        h.pb.screen.image.save(str(OUTPUT / (label + '.png')))
        print(json.dumps(dict(label=label, map=c.map_id(), position=c.position(),
                             money=list(m.read_bytes('wMoney', 3)), flags=m.read('wStatusFlags2'),
                             balls=m.read('wSafariBallsRemaining'),
                             steps=m.read_u16_be('wSafariStepsRemaining'),
                             text=tile_text(h))), flush=True)

    def dialogue(answers=()):
        answers = list(answers)
        for _ in range(1200):
            text = tile_text(h)
            if pending[0]:
                if 'YES' in text and 'NO' in text:
                    c.wait(30)
                    wanted = 1 if (answers.pop(0) if answers else False) else 2
                    if m.read('wMenuCursorY') != wanted:
                        c.press('down', hold=4, wait=20)
                    pending[0] = False
                    c.press('a', hold=4, wait=24)
                else:
                    c.wait(20)
            else:
                c.press('b', hold=4, wait=24)
            if m.read('wScriptMode') == 0 and m.read('wMapStatus') == 2 and not m.read('wBattleMode'):
                c.wait(60)
                if m.read('wScriptMode') == 0:
                    check(not answers, 'confirmation answers consumed')
                    return
        raise RuntimeError('Safari dialogue timeout: ' + tile_text(h))

    request, address = Request(h.battle), h.sym.addr('wDebugPlayer1')
    m.write('wPartyCount', 0)
    m.write('wMonType', 0)
    for slot, species in enumerate(('MEW', 'PIDGEOT')):
        m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species=species, level=35, moves=['SPLASH', 'TACKLE'])))
        call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
    for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wStatusFlags2'):
        m.write(name, 0)
    m.write_bytes('wMoney', [0, 1, 244])
    m.write('wDefaultSpawnpoint', 255)
    m.write('wMapGroup', lobby[0])
    m.write('wMapNumber', lobby[1])
    m.write('wXCoord', 9)
    m.write('wYCoord', 4)
    m.write('hMapEntryMethod', 0xF1)
    begin_native_call(h, 'OverworldLoop')
    c.wait(400)
    check(c.map_id() == lobby, 'lobby loaded')
    bank, addr = h.sym['YesNoBox']
    h.pb.hook_register(bank, addr, lambda _: pending.__setitem__(0, True), None)
    fixture = io.BytesIO()
    h.pb.save_state(fixture)

    def restore():
        fixture.seek(0)
        h.pb.load_state(fixture)
        pending[0] = False
        h.text_overflows.clear()

    def enter():
        c.press('up', hold=8, wait=60)
        dialogue([True])
        check(int.from_bytes(m.read_bytes('wMoney', 3), 'big') == 0, 'exact entry fee deducted')
        c.go([9, 1])
        c.press('up', hold=8, wait=240)
        check(c.map_id() == zone, 'north door enters Safari')
        check(m.read('wSafariBallsRemaining') == 30, 'entry provides 30 balls')
        check(m.read_u16_be('wSafariStepsRemaining') == 300, 'entry provides 300 steps')

    restore()
    c.press('up', hold=8, wait=60)
    dialogue([False])
    check(int.from_bytes(m.read_bytes('wMoney', 3), 'big') == 500, 'decline preserves money')
    check(c.map_id() == lobby and not m.read('wStatusFlags2') & 2, 'decline leaves Safari inactive')
    capture('declined')

    restore()
    m.write_bytes('wMoney', [0, 1, 243])
    c.press('up', hold=8, wait=60)
    dialogue([True])
    check(int.from_bytes(m.read_bytes('wMoney', 3), 'big') == 499, 'insufficient money preserved')
    check(c.map_id() == lobby and not m.read('wStatusFlags2') & 2, 'insufficient money leaves Safari inactive')
    capture('insufficient-money')

    restore()
    enter()
    capture('entered')
    expected_party = m.read_bytes('wPartyMons', 100)
    c.press('up', hold=8, wait=60)
    check(m.read_u16_be('wSafariStepsRemaining') == 299, 'walking decrements allowance')
    # Native menu save, fresh process-like emulator boot and Continue.
    h.pb.hook_deregister(bank, addr)
    save_continue(h, zone)
    m = h.battle.mem
    c = Controls(h)
    bank, addr = h.sym['YesNoBox']
    h.pb.hook_register(bank, addr, lambda _: pending.__setitem__(0, True), None)
    check(m.read('wSafariBallsRemaining') == 30 and m.read_u16_be('wSafariStepsRemaining') == 299, 'Continue does not refill balls or steps')
    check(m.read_bytes('wPartyMons', 100) == expected_party, 'Continue preserves party')
    capture('continued')
    continued = io.BytesIO()
    h.pb.save_state(continued)

    def restore_continued():
        continued.seek(0)
        h.pb.load_state(continued)
        pending[0] = False
        h.text_overflows.clear()

    # A normal door exit must return the unused allowance and allow departure.
    c.go([19, 35])
    if c.map_id() == zone:
        c.press('down', hold=16, wait=240)
    c.wait(240)
    check(c.map_id() == lobby, 'voluntary south-door exit reaches lobby')
    check(not m.read('wStatusFlags2') & 2 and m.read('wSafariBallsRemaining') == 0 and m.read_u16_be('wSafariStepsRemaining') == 0, 'voluntary exit clears Safari state')
    if c.map_id() == lobby:
        c.go([9, 17])
        if c.map_id() == lobby:
            c.press('down', hold=16, wait=240)
        c.wait(240)
    check(c.map_id() == maps['ROUTE_38'], 'lobby south door reaches Route 38')
    check(m.read_bytes('wPartyMons', 100) == expected_party, 'voluntary exit preserves party')
    capture('voluntary-exit')

    # Stage the exhausted-ball boundary without replacing the native step/script.
    restore_continued()
    m.write('wSafariBallsRemaining', 0)
    c.press('up', hold=8, wait=80)
    dialogue()
    check(c.map_id() == lobby, 'out of balls returns to gate')
    check(not m.read('wStatusFlags2') & 2 and m.read_u16_be('wSafariStepsRemaining') == 0, 'out of balls clears Safari state')
    check(m.read_bytes('wPartyMons', 100) == expected_party, 'out of balls preserves party')
    capture('out-of-balls')

    # Stage the last-step boundary; the next ordinary step must announce and warp.
    restore_continued()
    m.write_bytes('wSafariStepsRemaining', [0, 1])
    c.press('up', hold=8, wait=80)
    dialogue()
    check(c.map_id() == lobby, 'last step returns to gate')
    check(not m.read('wStatusFlags2') & 2 and m.read('wSafariBallsRemaining') == 0 and m.read_u16_be('wSafariStepsRemaining') == 0, 'timeout clears Safari state')
    capture('time-up')
    # Returning through the lobby must require payment again.
    c.press('up', hold=8, wait=60)
    dialogue()
    check(c.map_id() == lobby, 'return gate refuses unpaid re-entry')
    check(m.read_bytes('wPartyMons', 100) == expected_party, 'Safari exits preserve party')
    check(not h.text_overflows, 'Safari text stays inside textbox')
    capture('reentry-refused')
    h.pb.stop(save=False)
    (OUTPUT / 'results.json').write_text(json.dumps(dict(checks=checks, failures=failures), indent=2))
    print(f'SAFARI UI: {checks} checks; {len(failures)} failures', flush=True)
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())

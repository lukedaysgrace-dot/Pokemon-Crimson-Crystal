#!/usr/bin/env python3
"""Two release ROMs run cable reception, a trade, and a complete link battle.

Requires an isolated PyBoy >=2.8.1 at .tmpbuild/pyboy-link. Private save fixtures
are created with the debug party builder, then booted by unmodified release
ROMs. The cable is the emulator's shared-memory serial device. No link, RNG,
trade, or battle routine is stubbed. Button decisions observe native menus.
"""

import io
import json
import multiprocessing as mp
from pathlib import Path
import queue
import sys
import threading
import time
import traceback

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / '.tmpbuild/pyboy-link'))
from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from gameplay_rules_checks import new_game, hook
from overworld_controls import Controls
from symbols import _parse_constants
from ui_checks import tile_text
from pyboy.core.serial import probe_transport

OUTPUT = ROOT / '.tmpbuild/link-session'


def first_mon(h, slot=1):
    """Compare true indexes: each cartridge can allocate different byte IDs."""
    m = h.battle.mem
    prefix = f'wPartyMon{slot}'
    result = dict(species=m.species_index_of(m.read(prefix + 'Species')),
                  moves=[m.move_index_of(v) for v in m.read_bytes(prefix + 'Moves', 4)],
                  nickname=list(m.read_bytes('wPartyMonNicknames', 11, (slot - 1) * 11)),
                  ot=list(m.read_bytes('wPartyMonOT', 11, (slot - 1) * 11)))
    for field, size in (('Item', 1), ('ID', 2), ('Exp', 3), ('StatExp', 10),
                        ('DVs', 2), ('PP', 4), ('Level', 1), ('Personality', 2)):
        result[field] = list(m.read_bytes(prefix + field, size))
    return result


class CablePort:
    def __init__(self, slot, values, barrier, active=True):
        self.slot, self.values, self.barrier = slot, values, barrier
        self.active = active
        self.finishing = False
        self.failure = None

    def activate(self):
        self.barrier.wait(timeout=30)
        self.active = True

    def exchange(self, sb, sc):
        if not self.active:
            return 255, 0
        self.values[2 * self.slot] = sb
        self.values[2 * self.slot + 1] = sc
        self.values[4 + self.slot] = int(self.finishing)
        try:
            self.barrier.wait(timeout=30)
            peer = (self.values[2 * (1 - self.slot)], self.values[2 * (1 - self.slot) + 1])
            finished = bool(self.values[4] and self.values[5])
            self.barrier.wait(timeout=30)
        except threading.BrokenBarrierError:
            self.active = False
            self.failure = 'Cable peer stopped responding'
            return 255, 0
        if finished:
            self.active = False
        return peer

    def finish(self, h):
        self.finishing = True
        deadline = time.monotonic() + 60
        while self.active and time.monotonic() < deadline:
            h.tick(1)
        if self.active:
            raise RuntimeError('Peer failed to finish cable session')


def probe_worker(slot, values, barrier, sc, sb, events):
    events.put((slot, probe_transport(CablePort(slot, values, barrier), sc, sb)))


def validate_transport(context):
    checks = 0
    for controls, expected in (
        ((0x80, 0x80), ((0xa5, 0x80, 0), (0x3c, 0x80, 0))),
        ((0x81, 0x80), ((0x3c, 0, 1), (0xa5, 0, 1))),
        ((0x80, 0x81), ((0x3c, 0, 1), (0xa5, 0, 1))),
        ((0x81, 0), ((0xff, 0, 1), (0x3c, 0, 0))),
    ):
        values, barrier = context.Array('B', 6, lock=False), context.Barrier(2)
        events = context.Queue()
        processes = [context.Process(target=probe_worker, args=(slot, values, barrier, controls[slot],
                      (0xa5, 0x3c)[slot], events)) for slot in range(2)]
        for process in processes:
            process.start()
        actual = dict(events.get(timeout=35) for _ in range(2))
        for process in processes:
            process.join(timeout=1)
        for slot in range(2):
            checks += 1
            if actual[slot] != expected[slot]:
                raise RuntimeError(f'Serial transport controls {controls}: {actual} != {expected}')
    print(json.dumps(dict(kind='transport-validated', checks=checks, failures=0)), flush=True)
    return checks


def worker(number, mode, cable, events):
    h = None
    checks, failures = 0, []

    def report(kind, **data):
        events.put(dict(player=number, mode=mode, kind=kind, **data))

    def check(ok, description):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(description)
            report('FAIL', description=description)

    monitor_stop = threading.Event()
    phase = ['fixture']

    def monitor():
        while not monitor_stop.wait(30):
            if h is not None:
                try:
                    mem = h.battle.mem
                    report('watchdog', phase=phase[0], pc=h.pb.register_file.PC,
                           serial=mem.read('hSerialConnectionStatus'),
                           map=[mem.read('wMapGroup'), mem.read('wMapNumber')],
                           map_status=mem.read('wMapStatus'), script=mem.read('wScriptMode'),
                           position=[mem.read('wXCoord'), mem.read('wYCoord')],
                           cursor=mem.read('wMenuCursorY'), filter=mem.read('wMenuJoypadFilter'),
                           mon_type=mem.read('wMonType'),
                           sc=h.pb.memory[0xff02], sb=h.pb.memory[0xff01],
                           text=tile_text(h))
                except Exception:
                    pass
    threading.Thread(target=monitor, daemon=True).start()

    try:
        # Save fixture only. All subsequent execution is the release ROM.
        h = Harness(cartridge='native')
        new_game(h, 0)
        m = h.battle.mem
        m.write_bytes('wPlayerID', [0x71, number])
        m.write_bytes('wPlayerName', [0x80 + number, 0x50] + [0x50] * 6)
        address, request = h.sym.addr('wDebugPlayer1'), Request(h.battle)
        species = ('DRAGAPULT', 'WEEZING', 'PORYGON') if number == 0 else ('PORYGON_Z', 'SANDSLASH_ALOLAN', 'GENGAR')
        for slot, name in enumerate(species):
            moves = ['AERIAL_ACE', 'SKILL_SWAP', 'SPLASH'] if number == 0 else ['SPLASH', 'AERIAL_ACE']
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
                species=name, level=50, moves=moves, item='BERRY', dvs=0xfaaa)))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        # Fast deterministic winner; player two still takes ordinary turns.
        if mode == 'battle':
            m.write_bytes('wPartyMon1Attack', (900).to_bytes(2, 'big'))
        event = _parse_constants(ROOT / 'constants/event_flags.asm')['EVENT_GAVE_MYSTERY_EGG_TO_ELM']
        m.write('wEventFlags', m.read('wEventFlags', event // 8) | (1 << (event % 8)), event // 8)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 1)
        m.write('wMapGroup', 20)
        m.write('wMapNumber', 1)
        m.write('wXCoord', 5 if mode == 'trade' else 9)
        m.write('wYCoord', 3)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        for boot in range(4):
            h.tick(100)
            report('boot', frames=(boot + 1) * 100)
        call(h, 'AskOverwriteSaveFile')
        call(h, 'SaveGameData')
        original = m.read_bytes('wPartyMon1', h.sym.addr('wPartyMon2') - h.sym.addr('wPartyMon1'))
        original_name = m.read_bytes('wPartyMonNicknames', 11)
        original_ot = m.read_bytes('wPartyMonOT', 11)
        private = Path(h._rom_tempdir.name)
        h.pb.stop(save=True)
        ram = (private / 'pokecrystal_debug.gbc.ram').read_bytes()
        rtc = (private / 'pokecrystal_debug.gbc.rtc').read_bytes()
        report('fixture', species=species, first=list(original), nickname=list(original_name), ot=list(original_ot),
               mon=first_mon(h), party=[first_mon(h, slot) for slot in range(1, 4)])

        h = Harness(cartridge='native', rom_path=ROOT / 'pokecrystal.gbc', emulator_kwargs=dict(
            ram_file=io.BytesIO(ram), rtc_file=io.BytesIO(rtc),
            serial_shared_memory=cable, serial_interrupt_based=True))
        c, m = Controls(h), h.battle.mem
        h.tick(400)
        for _ in range(600):
            if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (20, 1, 2):
                h.tick(120)
                break
            h.press('start', hold=4, wait=16)
            h.press('a', hold=4, wait=20)
            if _ % 50 == 49:
                report('progress', phase='continue', text=tile_text(h))
        else:
            raise RuntimeError('Release Continue failed: ' + tile_text(h))
        check(m.read_bytes('wPartyMon1', len(original)) == original, 'release Continue preserves staged party')
        report('continue', map=c.map_id())
        phase[0] = 'reception'
        pending = [False]
        replacement = [False]
        cancel_menu = [False]
        console_closed = [False]
        traded = []
        hook(h, 'YesNoBox', lambda _: pending.__setitem__(0, True))
        hook(h, 'SaveAfterLinkTrade', lambda _: traded.append(True))
        hook(h, 'SelectBattleMon', lambda _: replacement.__setitem__(0, True))
        hook(h, 'Function28ade', lambda _: cancel_menu.__setitem__(0, True))
        hook(h, 'LinkTrade_PlayerPartyMenu', lambda _: cancel_menu.__setitem__(0, False))
        hook(h, 'LinkTrade_OTPartyMenu', lambda _: cancel_menu.__setitem__(0, False))
        hook(h, 'Script_newloadmap', lambda _: console_closed.__setitem__(0, True))
        # Receipt/result observation occurs before map reload clears WRAM.
        hook(h, 'Colosseum', lambda _: report('console', room='battle'))
        hook(h, 'TradeCenter', lambda _: report('console', room='trade'))
        received = False
        cable.activate()
        if number:
            # Offset the two consoles' DIV phases, as physical consoles are.
            c.wait(137)
        c.press('up', hold=4, wait=20)
        c.press('a', hold=4, wait=24)
        room = (20, 2 if mode == 'trade' else 3)
        for iteration in range(2500):
            if cable.failure:
                raise RuntimeError(cable.failure)
            text = tile_text(h)
            if pending[0] and 'YES' in text and 'NO' in text:
                c.wait(30)
                if m.read('wMenuCursorY') != 1:
                    c.press('up', hold=4, wait=20)
                pending[0] = False
                c.press('a', hold=4, wait=24)
            else:
                c.press('a', hold=4, wait=20)
            if c.map_id() == room and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                c.wait(120)
                received = True
                break
            if iteration % 10 == 9:
                report('progress', phase='reception', map=c.map_id(), text=text,
                       serial=m.read('hSerialConnectionStatus'))
        check(received, 'native cable handshake and room admission')
        if not received:
            raise RuntimeError('Cable reception timed out: ' + tile_text(h))
        report('admitted', map=c.map_id(), position=c.position(), serial=m.read('hSerialConnectionStatus'))
        console_closed[0] = False
        cancel_menu[0] = False
        phase[0] = 'console'
        h.pb.screen.image.save(str(OUTPUT / f'{mode}-{number}-room.png'))
        # Admission puts each player in their seat. Walk to the console.
        report('grid', rows=c.grid(), objects=c.objects())
        # Role 1 sees the friend on the left; role 2 sees them on the right.
        # The console itself is solid: interact from the unoccupied seat.
        seat = (6, 4) if m.read('hSerialConnectionStatus') == 1 else (3, 4)
        c.go(seat)
        c.press('left' if seat[0] == 6 else 'right', hold=4, wait=20)
        c.press('a', hold=4, wait=24)
        seen_battle = False
        phase[0] = 'session'
        for iteration in range(6000):
            if cable.failure:
                raise RuntimeError(cable.failure)
            text = tile_text(h)
            if replacement[0] and 'CANCEL' in text and 'Which' in text:
                c.wait(30)
                fit = next((slot for slot in range(1, 4)
                            if m.read_u16_be(f'wPartyMon{slot}HP')), None)
                if fit is not None and m.read('wMenuCursorY') != fit:
                    c.press('down', hold=4, wait=24)
                else:
                    replacement[0] = False
                    c.press('a', hold=4, wait=24)
            elif pending[0] and 'YES' in text and 'NO' in text:
                c.wait(30)
                if m.read('wMenuCursorY') != 1:
                    c.press('up', hold=4, wait=20)
                pending[0] = False
                c.press('a', hold=4, wait=24)
            elif mode == 'trade' and 'STATS' in text and 'TRADE' in text:
                # Move from STATS to TRADE in the actual horizontal submenu.
                c.press('right', hold=4, wait=20)
                c.press('a', hold=4, wait=24)
            else:
                c.press('a', hold=4, wait=20)
            if mode == 'trade' and traded:
                c.wait(240)
                report('received', first=list(m.read_bytes('wPartyMon1', len(original))),
                       nickname=list(m.read_bytes('wPartyMonNicknames', 11)),
                       ot=list(m.read_bytes('wPartyMonOT', 11)), mon=first_mon(h, 3),
                       party=[first_mon(h, slot) for slot in range(1, 4)])
                break
            if m.read('wBattleMode'):
                seen_battle = True
            if mode == 'battle' and seen_battle and not m.read('wBattleMode'):
                c.wait(120)
                report('result', result=m.read('wBattleResult'), link=m.read('wLinkMode'),
                       party=list(m.read_bytes('wPartyMon1', len(original))))
                break
            if iteration % 250 == 249:
                report('progress', phase='session', map=c.map_id(), text=text,
                       battle=m.read('wBattleMode'), serial=m.read('hSerialConnectionStatus'))
        else:
            raise RuntimeError(mode + ' session timed out: ' + tile_text(h))
        check(bool(traded) if mode == 'trade' else seen_battle, 'native session completed')
        check(not h.text_overflows, 'link dialogue and battle textbox bounds')
        h.pb.screen.image.save(str(OUTPUT / f'{mode}-{number}-finished.png'))

        phase[0] = 'leave-session'
        for _ in range(1000):
            if c.map_id() == room and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                break
            text = tile_text(h)
            if console_closed[0]:
                c.wait(120)
            elif pending[0] and 'YES' in text and 'NO' in text:
                c.wait(30)
                if m.read('wMenuCursorY') != 1:
                    c.press('up', hold=4, wait=20)
                pending[0] = False
                c.press('a', hold=4, wait=24)
            elif cancel_menu[0]:
                # This native menu requires both consoles to confirm CANCEL.
                c.wait(30)
                c.press('a', hold=12, wait=36)
            elif mode == 'trade' and not (m.read('wMenuJoypadFilter') & 2):
                # Party selection ignores B. Move UP to the cancellation row.
                c.press('up', hold=12, wait=36)
            else:
                c.press('b', hold=12, wait=36)
        else:
            raise RuntimeError('Failed to close cable console: ' + tile_text(h))
        report('console-closed', map=c.map_id(), position=c.position())
        c.go((4, 6))
        c.press('down', hold=12, wait=36)
        for _ in range(500):
            if c.map_id() == (20, 1) and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                break
            if c.map_id() == room and not m.read('wScriptMode'):
                # Carpet exits trigger when walking DOWN from the edge tile.
                c.press('down', hold=12, wait=36)
            else:
                c.press('a', hold=4, wait=20)
        else:
            raise RuntimeError('Cable room exit failed: ' + tile_text(h))
        check(not m.read('wLinkMode'), 'native room exit clears link mode')
        report('exited', map=c.map_id(), mon=first_mon(h))
        cable.finish(h)

        # Verify the game's own cable save on a fresh, disconnected console.
        phase[0] = 'reload'
        private_rom = Path(h._rom_tempdir.name) / 'pokecrystal.gbc'
        saved_mon = [first_mon(h, slot) for slot in range(1, 4)]
        h.pb.stop(save=True)
        from pyboy import PyBoy
        from state import Battle
        h.pb = PyBoy(str(private_rom), window='null', cgb=True, sound_emulated=False)
        h.pb.set_emulation_speed(0)
        h.pb.hook_register(0, 0x100, lambda _: None, None)
        h.battle = Battle(h.pb, h.sym, h.con)
        m = h.battle.mem
        h.tick(400)
        for _ in range(600):
            if c.map_id() == (20, 1) and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                break
            c.press('start', hold=4, wait=16)
            c.press('a', hold=4, wait=20)
        else:
            raise RuntimeError('Fresh cable-save Continue failed: ' + tile_text(h))
        check([first_mon(h, slot) for slot in range(1, 4)] == saved_mon,
              'fresh release Continue retains the cable-session party')
        check(m.read('wPartyCount') == 3 and not m.read('wLinkMode'), 'fresh Continue restores three mons outside link mode')
        report('reloaded', mon=first_mon(h))
        report('done', checks=checks, failures=failures)
    except Exception:
        if h is not None:
            h.pb.screen.image.save(str(OUTPUT / f'{mode}-{number}-error.png'))
        report('error', traceback=traceback.format_exc())
    finally:
        monitor_stop.set()
        if h is not None:
            h.pb.stop(save=False)


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    context = mp.get_context('fork')
    checks = validate_transport(context)
    results = []
    for mode in ('trade', 'battle'):
        values, barrier = context.Array('B', 6, lock=False), context.Barrier(2)
        events = context.Queue()
        processes = [context.Process(target=worker, args=(number, mode, CablePort(number, values, barrier, active=False), events)) for number in range(2)]
        for process in processes:
            process.start()
        deadline, completed = time.monotonic() + 900, set()
        mode_results = []
        try:
            while time.monotonic() < deadline and len(completed) < 2:
                try:
                    event = events.get(timeout=1)
                except queue.Empty:
                    continue
                print(json.dumps(event), flush=True)
                mode_results.append(event)
                if event['kind'] in ('done', 'error'):
                    completed.add(event['player'])
                    checks += event.get('checks', 0)
            if len(completed) != 2:
                mode_results.append(dict(kind='error', message='bounded session wall-clock limit'))
            results.extend(mode_results)
            records = {(e.get('player'), e['kind']): e for e in mode_results}
            for number in range(2):
                if mode == 'trade' and (number, 'received') in records:
                    actual = records[number, 'received']['mon']
                    expected = records[1 - number, 'fixture']['mon']
                    for field in expected:
                        checks += 1
                        if actual[field] != expected[field]:
                            error = dict(kind='FAIL', player=number, mode=mode,
                                         description='traded Pokemon field ' + field,
                                         actual=actual[field], expected=expected[field])
                            results.append(error)
                            print(json.dumps(error), flush=True)
                    checks += 1
                    if records[number, 'received']['party'][:2] != records[number, 'fixture']['party'][1:]:
                        results.append(dict(kind='FAIL', player=number, mode=mode,
                                            description='trade preserves the two untraded Pokemon'))
            if mode == 'battle' and all((n, 'result') in records for n in range(2)):
                checks += 1
                if [records[n, 'result']['result'] & 0x3f for n in range(2)] != [0, 1]:
                    results.append(dict(kind='FAIL', mode=mode, description='opposite win/loss results'))
        finally:
            for process in processes:
                process.join(timeout=1)
                if process.is_alive():
                    process.terminate()
                    process.join()
    failures = [e for e in results if e['kind'] in ('error', 'FAIL')]
    summary = dict(checks=checks, failures=failures,
                   scope='two release-ROM sessions using functional emulator cable transport')
    (OUTPUT / 'results.json').write_text(json.dumps(results, indent=2))
    (OUTPUT / 'summary.json').write_text(json.dumps(summary, indent=2))
    print(json.dumps(summary), flush=True)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())

#!/usr/bin/env python3
"""Exercise copy contracts, speed, and real-PPU VBlank contention in both ROMs.

All fixtures are private emulator memory. No player saves are loaded/written.
Legacy loops are installed in test RAM solely as a correctness/speed control.
"""
import itertools
import json
import re
from pathlib import Path

from pc_harness import Harness


def check_rom(rom):
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    pb, m = h.pyboy, h.mem
    pb.hook_register(0, 0x100, lambda _: None, None)
    h.boot()
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, f'{rom.name}: {message}'

    def put(name, data):
        bank, addr = h.sym[name]
        if isinstance(data, int):
            data = [data]
        if 0xd000 <= addr < 0xe000:
            m[bank, addr:addr + len(data)] = data
        else:
            m[addr:addr + len(data)] = data

    # The original routines, including the zero-count case, are the control.
    legacy = {
        'LegacyCopy': [0x04, 0x0c, 0x18, 0x03, 0x2a, 0x12, 0x13,
                       0x0d, 0x20, 0xfa, 0x05, 0x20, 0xf7, 0xc9],
        'LegacyFill': [0x04, 0x0c, 0x18, 0x01, 0x22,
                       0x0d, 0x20, 0xfc, 0x05, 0x20, 0xf9, 0xc9],
    }
    try:
        m[0xffff] = 0
        for i, (name, code) in enumerate(legacy.items()):
            address = 0xc600 + i * 0x40
            h.sym.by_name[name] = (0, address)
            h.wr(address, code)
        source = bytes((i * 37 + i // 7) & 255 for i in range(2048))
        h.wr(0xc800, source)
        lengths = list(range(513)) + [767, 768, 769, 1023, 1024, 1025, 2047]
        for size in lengths:
            for routine, control in [('CopyBytes', 'LegacyCopy'), ('ByteFill', 'LegacyFill')]:
                results = []
                for name in (control, routine):
                    h.wr(0xd000, bytes([0xa5]) * 0x1000)
                    args = dict(a=0x63, bc=size, f=0x10, de=0xd001 if routine == 'CopyBytes' else 0x1234,
                                hl=0xc800 if routine == 'CopyBytes' else 0xd001)
                    registers = h.call(name, **args)
                    results.append((registers, h.rd(0xd000, 0x1000)))
                expected, actual = results
                check(actual[1] == expected[1], f'{routine} memory/bounds, length {size}')
                check(all(actual[0][r] == expected[0][r] for r in ('a', 'bc', 'de', 'hl', 'z', 'c_flag')),
                      f'{routine} register contract, length {size}')
        # Forward overlap must retain the original copy semantics, not memmove.
        for delta in (-3, -1, 0, 1, 3):
            outcomes = []
            for routine in ('LegacyCopy', 'CopyBytes'):
                h.wr(0xd000, source)
                h.call(routine, bc=257, hl=0xd010, de=0xd010 + delta)
                outcomes.append(h.rd(0xd000, 2048))
            check(outcomes[0] == outcomes[1], f'forward overlap {delta}')
        # ROM0 helpers must not switch away from a banked source.
        for bank in (1, 0x7f, 0x80, 0xfe):
            h.set_rom_bank(bank)
            expected = bytes(m[bank, 0x40fd:0x4300])
            h.call('CopyBytes', bc=len(expected), hl=0x40fd, de=0xd000)
            check(h.rd(0xd000, len(expected)) == expected, f'banked source ${bank:02x}')
            check(h.rd(h.s('hROMBank')) == bank, f'bank ${bank:02x} preserved')

        # DIV is a hardware clock; reset at entry, sample on return. These large
        # blocks make its 256-T-cycle resolution sufficient to prove a gain.
        speed = {}
        for routine, control in [('CopyBytes', 'LegacyCopy'), ('ByteFill', 'LegacyFill')]:
            timings = []
            for name in (control, routine):
                _, address = h.sym[name]
                h.sym.by_name['TimedMemory'] = (0, 0xc700)
                h.wr(0xc700, [0xaf, 0xe0, 0x04, 0x3e, 0x63, 0xcd,
                             address & 255, address >> 8, 0xf0, 0x04, 0xea, 0xf0, 0xc6, 0xc9])
                h.call('TimedMemory', bc=1024, de=0xd000, hl=0xc800 if routine == 'CopyBytes' else 0xd000)
                timings.append(m[0xc6f0])
            check(timings[1] < timings[0] * .8, f'{routine} faster than legacy: {timings}')
            speed[routine] = dict(legacy_div_ticks=timings[0], optimized_div_ticks=timings[1])

        # Call the complete normal VBlank body on the next line 144, with the
        # actual PPU/DMA/palette hardware running and game sound code intact.
        target = h.s('VBlank0')
        h.sym.by_name['TestVBlank'] = (0, 0xc680)
        h.wr(0xc680, [0xf3, 0xf0, 0x44, 0xfe, 144, 0x30, 0xfa,
                      0xf0, 0x44, 0xfe, 144, 0x20, 0xfa,
                      0x3e, h.sym.bank('wScratchTileMap'), 0xe0, 0x70,
                      0xcd, target & 255, target >> 8, 0xc9])
        endpoints = []
        oam_pending = [False]
        def oam_done(_):
            if oam_pending[0]:
                endpoints.append(m[0xff44])
                oam_pending[0] = False
        # .bookkeeping shares the completion address; only count paths which
        # actually reached the OAM dispatcher, not a deferred stale interrupt.
        pb.hook_register(*h.sym['VBlank0.done'], lambda _: oam_pending.__setitem__(0, True), None)
        pb.hook_register(*h.sym['VBlank0.done_oam'], oam_done, None)
        writes = []
        binary = rom.read_bytes()
        # Hooks on row/next entries bracket bulk uploads. Byte comparisons below
        # also catch writes rejected by the PPU when VRAM is inaccessible.
        for name in ('UpdateBGMap.row', 'UpdateBGMapBuffer.next',
                     'Serve1bppRequest.next', '_Serve2bppRequest.next'):
            pb.hook_register(*h.sym[name], lambda _, name=name:
                             writes.append((name, m[0xff44], m[0xff41] & 3)), None)

        cases = 0
        for count, pals, mode, upload, dma in itertools.product((0, 2, 20), (0, 1), range(5), (0, 1, 2, 3), (0, 1, 2)):
            # DMA-only frames deliberately defer every other pending upload.
            for name, value in [('hVBlank', 0), ('hOAMUpdate', 0), ('hMapAnims', 0),
                                ('hBGMapUpdate', int(bool(count))), ('hBGMapTileCount', count),
                                ('hCGBPalUpdate', pals), ('hBGMapMode', mode), ('hBGMapThird', 0),
                                ('hDMATransfer', 0x23 if dma else 0),
                                ('hDMATransfer2', 0x23 if dma == 2 else 0),
                                ('wRequested1bpp', 8 if upload & 1 else 0),
                                ('wRequested2bpp', 8 if upload & 2 else 0)]:
                put(name, value)
            put('hBGMapAddress', [0, 0x98])
            put('wBGMapBufferPtrs', b''.join((0x9d00 + i * 2).to_bytes(2, 'little') for i in range(20)))
            put('wBGMapBuffer', bytes(range(40)))
            put('wBGMapPalBuffer', bytes([5]) * 40)
            put('wTileMap', bytes([0x42]) * 360)
            put('wAttrMap', bytes([3]) * 360)
            for kind in ('1', '2'):
                put(f'wRequested{kind}bppSource', [0, 0x20])
                put(f'wRequested{kind}bppDest', [0, 0x88 if kind == '1' else 0x89])
            put('wBGPals2', bytes([0x19, 0x32]) * 32)
            put('wOBPals2', bytes([0x21, 0x43]) * 32)
            put('wScratchTileMap', bytes([0x56]) * 576)
            put('wScratchAttrMap', bytes([2]) * 576)
            m[0xff4f] = 0
            for bank in (0, 1):
                m[bank, 0x8800:0x8980] = [0] * 384
                m[bank, 0x9800:0x9e00] = [0] * 1536
            m[0xff51], m[0xff52] = h.s('wScratchTileMap') >> 8, h.s('wScratchTileMap') & 0xf0
            m[0xff53], m[0xff54] = 0x18, 0
            endpoints.clear()
            writes.clear()
            h.call('TestVBlank')
            check(len(endpoints) == 1 and 144 <= endpoints[0] <= 153,
                  f'OAM finishes in VBlank: {(count,pals,mode,upload,dma)} {endpoints}')
            check(all(ly >= 144 and stat == 1 for _, ly, stat in writes),
                  f'graphics uploads stay in VBlank: {writes}')
            check(m[0xff4f] & 1 == 0, 'VRAM bank restored')
            if dma:
                check(m[h.s('hDMATransfer')] == 0 and m[h.s('hDMATransfer2')] == 0, 'DMA completed')
                check(bytes(m[0, 0x9800:0x9a40]) == bytes([0x56]) * 576, 'DMA tile pixels')
                if dma == 2:
                    check(bytes(m[1, 0x9800:0x9a40]) == bytes([2]) * 576, 'second DMA attrs')
                check(m[h.s('hCGBPalUpdate')] == pals, 'DMA defers palettes')
            else:
                check(m[h.s('hCGBPalUpdate')] == 0, 'palette queue served with scrolling')
                check(m[h.s('hBGMapUpdate')] == 0, 'scrolling queue served')
                if count:
                    check(bytes(m[0, 0x9d00:0x9d00 + count*2]) == bytes(range(count*2)), 'scroll tile pixels')
                    check(bytes(m[1, 0x9d00:0x9d00 + count*2]) == bytes([5]) * (count*2), 'scroll attributes')
            # All queues must drain even with continuous background refresh.
            for _ in range(4):
                h.call('TestVBlank')
            check(not any(m[h.s(n)] for n in ('hBGMapUpdate', 'hCGBPalUpdate',
                      'hDMATransfer', 'hDMATransfer2', 'wRequested1bpp', 'wRequested2bpp')), 'queues drain')
            for kind, address in ((1, 0x8800), (2, 0x8900)):
                if upload & kind:
                    raw = binary[0x2000:0x2080 if kind == 2 else 0x2040]
                    expected = raw if kind == 2 else bytes(x for value in raw for x in (value, value))
                    check(bytes(m[0, address:address+128]) == expected, 'uploaded font/sprite pixels')
            cases += 1

        # Every command in every compiled tileset animation, under both heavy
        # scrolling and palette traffic. Check real PPU time, including OAM.
        root = Path(__file__).resolve().parents[1]
        tables = re.findall(r'^\s*tileset (\w+)', (root/'data/tilesets.asm').read_text(), re.M)
        animation_cases = 0
        for table in tables:
            bank, address = h.sym[table + 'Anim']
            for frame in range(64):
                pointer = address + frame * 4 + 2
                command = m[bank, pointer] | m[bank, pointer + 1] << 8
                for count, pals, timer in itertools.product((0, 20), (0, 1), (0, 7)):
                    for name, value in [('hMapAnims', 1), ('hTileAnimFrame', frame),
                                        ('wTileAnimationTimer', timer), ('hBGMapMode', 4),
                                        ('hBGMapUpdate', int(bool(count))), ('hBGMapTileCount', count),
                                        ('hCGBPalUpdate', pals), ('hDMATransfer', 0), ('hDMATransfer2', 0),
                                        ('wRequested1bpp', 0), ('wRequested2bpp', 0)]:
                        put(name, value)
                    put('wTilesetAnim', list(address.to_bytes(2, 'little')))
                    endpoints.clear()
                    writes.clear()
                    h.call('TestVBlank')
                    check(len(endpoints) == 1 and 144 <= endpoints[0] <= 153,
                          f'{table}, frame {frame}, count {count}, pals {pals}, timer {timer}: OAM {endpoints}')
                    check(all(ly >= 144 and stat == 1 for _, ly, stat in writes), f'{table}: VRAM writes in VBlank')
                    animation_cases += 1
                if command == h.s('DoneTileAnimation'):
                    break
            else:
                raise AssertionError('unterminated tileset animation: ' + table)
        # A stale VBlank request after a DI screen transfer must defer graphics
        # without consuming the upload queues or starting OAM on a visible line.
        for line in (0, 1, 32, 127, 128, 143):
            h.wr(0xc680, [0xf3, 0xf0, 0x44, 0xfe, line, 0x20, 0xfa,
                          0xcd, target & 255, target >> 8, 0xc9])
            for name in ('hBGMapUpdate', 'hCGBPalUpdate', 'hDMATransfer', 'wRequested2bpp'):
                put(name, 1)
            endpoints.clear()
            h.call('TestVBlank')
            check(not endpoints, f'line {line}: stale interrupt defers OAM')
            check(all(m[h.s(n)] == 1 for n in ('hBGMapUpdate', 'hCGBPalUpdate',
                      'hDMATransfer', 'wRequested2bpp')), f'line {line}: queues remain pending')
        return dict(rom=rom.name, checks=checks, contention_cases=cases,
                    animation_cases=animation_cases, speed=speed)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    import sys
    root = Path(__file__).resolve().parents[1]
    roms = [Path(p) for p in sys.argv[1:]] or [root / 'pokecrystal.gbc', root / 'pokecrystal_debug.gbc']
    for rom in roms:
        print(json.dumps(check_rom(rom)), flush=True)

#!/usr/bin/env python3
"""Compile clock-driven serial transport in the isolated PyBoy 2.8.1 copy.

Upstream's shared-memory device completes external-clock transfers even when
neither console drives a clock, breaking Crystal's internal/external role
negotiation. This adapter shifts bits only when an enabled internal clock is
present. Two processes synchronize at each serial bit period, including idle
periods. Game ROMs and the installed emulator are never modified.
"""

from pathlib import Path
import re
from setuptools import setup, Extension
from Cython.Build import cythonize

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / '.tmpbuild/pyboy-link'
REPLACEMENT = '''class SerialSharedMemory(Serial):
    def __init__(self, cgb_mode, shared_memory, serial_interrupt_based):
        Serial.__init__(self, cgb_mode)
        self.shared_memory = shared_memory
        self.shared_slot = shared_memory.slot
        self.bits_transferred = 0
        self.interrupt_based = False
        self.clock_target = CYCLES_8192HZ
        self._cycles_to_interrupt = CYCLES_8192HZ

    def save_state(self, f):
        raise PyBoyInvalidOperationException("Save state is not supported with serial connection")

    def load_state(self, f, state_version):
        raise PyBoyInvalidOperationException("Load state is not supported with serial connection")

    def set_SB(self, value):
        self.SB = value

    def set_SC(self, value):
        self.SC = value | (0b01111100 if self.cgb_mode else 0b01111110)
        self.transfer_enabled = self.SC & 0x80
        self.internal_clock = self.SC & 1
        self.bits_transferred = 0

    @cython.locals(cycles=cython.ulonglong, interrupt=cython.bint)
    def tick(self, _cycles):
        cycles = _cycles - self.last_cycles
        if cycles == 0:
            return False
        self.last_cycles = _cycles
        self.clock += cycles
        interrupt = False
        while self.clock >= self.clock_target:
            with cython.gil:
                peer_sb, peer_sc = self.shared_memory.exchange(self.SB, self.SC)
                clock_driven = ((self.SC & 0x81) == 0x81 or (peer_sc & 0x81) == 0x81)
                if self.transfer_enabled and clock_driven:
                    bit = ((peer_sb >> 7) & 1) if peer_sc & 0x80 else 1
                    self.SB = ((self.SB << 1) & 0xff) | bit
                    self.bits_transferred += 1
                    if self.bits_transferred == 8:
                        self.SC &= 0x7f
                        self.transfer_enabled = False
                        interrupt = True
                # Synchronize more coarsely while both ports are idle. A
                # transfer restores the normal bit period on both peers.
                self.clock_target += CYCLES_8192HZ if clock_driven else 4096
        self._cycles_to_interrupt = self.clock_target - self.clock
        return interrupt

    def stop(self):
        pass


@cython.locals(serial=SerialSharedMemory)
def probe_transport(endpoint, sc, sb, ticks=8):
    serial = SerialSharedMemory(True, endpoint, False)
    serial.set_SB(sb)
    serial.set_SC(sc)
    interrupts = 0
    for step in range(1, ticks + 1):
        if serial.tick(step * CYCLES_8192HZ):
            interrupts += 1
    return int(serial.SB), int(serial.SC & 0x80), interrupts


'''


def main():
    path = OUTPUT / 'pyboy/core/serial.py'
    original = path.read_text()
    updated, count = re.subn(r'class SerialSharedMemory\(Serial\):.*?(?=class SerialSharedMemoryBuffer:)',
                             lambda _: REPLACEMENT, original, flags=re.S)
    if count != 1:
        raise RuntimeError('Unexpected PyBoy serial source: review before compiling')
    base, linked = updated.split('class SerialSharedMemory(Serial):', 1)
    if '@cython.locals(cycles=' not in base:
        base = base.replace('    def tick(self, _cycles):',
                            '    @cython.locals(cycles=cython.ulonglong, interrupt=cython.bint)\n'
                            '    def tick(self, _cycles):')
    updated = base + 'class SerialSharedMemory(Serial):' + linked
    path.write_text(updated)
    setup(name='private-pyboy-link', ext_modules=cythonize(
        [Extension('pyboy.core.serial', [str(path)])], include_path=[str(OUTPUT)],
        compiler_directives={'language_level': 3}, quiet=True),
        script_args=['build_ext', '--build-lib', str(OUTPUT), '--build-temp', str(OUTPUT / 'build')])


if __name__ == '__main__':
    main()

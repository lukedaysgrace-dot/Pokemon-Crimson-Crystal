#!/usr/bin/env python3
"""Compile an isolated PyBoy MBC30 adapter for clock-driven integration tests.

Requires Cython, setuptools, and a C compiler. The installed PyBoy and game
ROMs are untouched. The adapter extends ROM/SRAM bank widths and corrects
the old emulator's RTC register writes (sign and time-unit conversion).
The exported advance_clock accelerates the emulator RTC, never game WRAM.
"""

from pathlib import Path
import shutil

import pyboy
from setuptools import setup, Extension
from Cython.Build import cythonize


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / '.tmpbuild/pyboy-mbc30'


def main():
    source = Path(pyboy.__file__).parent
    target = OUTPUT / 'pyboy'
    if not target.exists():
        shutil.copytree(source, target)
    path = target / 'core/cartridge/mbc3.py'
    original = (source / 'core/cartridge/mbc3.py').read_text()
    if 'value &= 0b01111111' not in original or 'self.rambank_selected <= 0x03' not in original:
        raise RuntimeError('PyBoy MBC3 implementation changed; review adapter before rebuilding')
    updated = original.replace('value &= 0b01111111', 'value &= 0b11111111')
    updated = updated.replace('self.rambank_selected <= 0x03', 'self.rambank_selected <= 0x07')
    updated = updated.replace('import pyboy', 'import cython\nimport pyboy', 1)
    updated = updated.replace('class MBC3(BaseMBC):', '''_live_mbc = None


@cython.locals(mbc=MBC3)
def advance_clock(seconds):
    mbc = _live_mbc
    if mbc is None:
        raise RuntimeError("No active MBC30 cartridge")
    mbc.rtc.timezero -= seconds


class MBC3(BaseMBC):
    def __init__(self, *args):
        global _live_mbc
        BaseMBC.__init__(self, *args)
        _live_mbc = self
''')
    path.write_text(updated)
    rtc_path = target / 'core/cartridge/rtc.py'
    rtc_source = (source / 'core/cartridge/rtc.py').read_text()
    replacements = (
        ('self.timezero = self.timezero - (t % 60) - value',
         'self.timezero += (t % 60) - value'),
        ('self.timezero = self.timezero - (t // 60 % 60) - value',
         'self.timezero += ((t // 60 % 60) - value) * 60'),
        ('self.timezero = self.timezero - (t // 3600 % 24) - value',
         'self.timezero += ((t // 3600 % 24) - value) * 3600'),
        ('self.timezero = self.timezero - (t // 3600 // 24) - value',
         'self.timezero += ((t // 86400 % 256) - value) * 86400'),
        ('self.timezero = self.timezero - (t // 3600 // 24) - (day_high << 8)',
         'self.timezero += ((t // 86400 // 256 % 2) - day_high) * 256 * 86400'),
    )
    for old, new in replacements:
        if old not in rtc_source:
            raise RuntimeError('PyBoy RTC implementation changed; review adapter before rebuilding')
        rtc_source = rtc_source.replace(old, new)
    rtc_source = rtc_source.replace('import struct', 'import cython\nimport struct', 1)
    rtc_source += '''

@cython.locals(rtc=RTC, loaded=RTC)
def probe_register_writes():
    import io
    rtc = RTC(None)
    rtc.timezero = time.time() - (139 * 86400 + 12 * 3600 + 34 * 60 + 56)
    snapshots = []
    for register, value in ((8, 7), (9, 8), (10, 9), (11, 2), (12, 1)):
        rtc.latch_rtc()
        rtc.setregister(register, value)
        rtc.latch_rtc()
        snapshots.append((rtc.getregister(8), rtc.getregister(9), rtc.getregister(10),
                          rtc.getregister(11), rtc.getregister(12)))
    state = io.BytesIO()
    rtc.stop(state)
    state.seek(0)
    loaded = RTC(state)
    loaded.latch_rtc()
    snapshots.append((loaded.getregister(8), loaded.getregister(9), loaded.getregister(10),
                      loaded.getregister(11), loaded.getregister(12)))
    return snapshots
'''
    rtc_path.write_text(rtc_source)
    setup(name='private-pyboy-mbc30', ext_modules=cythonize(
        [Extension('pyboy.core.cartridge.mbc3', [str(path)]),
         Extension('pyboy.core.cartridge.rtc', [str(rtc_path)])], include_path=[str(OUTPUT)],
        compiler_directives={'language_level': 3, 'infer_types': True}, quiet=True),
        script_args=['build_ext', '--build-lib', str(OUTPUT), '--build-temp', str(OUTPUT / 'build')])
    print('Prepared isolated MBC30 adapter at ' + str(OUTPUT))


if __name__ == '__main__':
    main()

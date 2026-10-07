#!/usr/bin/env python3
"""Compile an isolated PyBoy MBC30 adapter for clock-driven integration tests.

Requires Cython, setuptools, and a C compiler. The installed PyBoy and game
ROMs are untouched. Only ROM-bank width and SRAM banks 4-7 differ from MBC3.
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
    setup(name='private-pyboy-mbc30', ext_modules=cythonize(
        [Extension('pyboy.core.cartridge.mbc3', [str(path)])], include_path=[str(OUTPUT)],
        compiler_directives={'language_level': 3}, quiet=True),
        script_args=['build_ext', '--build-lib', str(OUTPUT), '--build-temp', str(OUTPUT / 'build')])
    print('Prepared isolated MBC30 adapter at ' + str(OUTPUT))


if __name__ == '__main__':
    main()

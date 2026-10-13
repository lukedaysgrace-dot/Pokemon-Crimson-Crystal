#!/usr/bin/env python3
"""Check alias/bank boundary lookup semantics and constant counter parsing."""
from pathlib import Path
import re
from tempfile import TemporaryDirectory

from battletest.symbols import Constants, ROOT, Symbols, _parse_constants, _parse_trainer_classes


def main():
    with TemporaryDirectory() as directory:
        path = Path(directory) / 'fixture.sym'
        path.write_text('01:4000 first\n01:4000 alias\n01:4010 next\n02:4000 other\n')
        symbols = Symbols(path)
        for bank, addr, expected in (
                (1, 0x3fff, '01:3fff'), (1, 0x4000, 'first'),
                (1, 0x400f, 'first+0xf'), (1, 0x4010, 'next'),
                (1, 0x4011, 'next+0x1'), (2, 0x4000, 'other'),
                (3, 0x4000, '03:4000')):
            assert symbols.nearest(bank, addr) == expected
        path = Path(directory) / 'fixture.asm'
        path.write_text('\tconst_def -1\n\tconst NEGATIVE\n\tconst ZERO\n'
                        '\tconst_def $f0\n\tconst HEX\n\tconst_skip %10\n\tconst SKIPPED\n'
                        '\tconst_def 1 << 3\n\tconst SHIFTED\n'
                        'const_value = -$1b\n\tconst RESET\n')
        assert _parse_constants(path) == {
            'NEGATIVE': -1, 'ZERO': 0, 'HEX': 0xf0, 'SKIPPED': 0xf3,
            'SHIFTED': 8, 'RESET': -0x1b}
        path.write_text('\ttrainerclass TRAINER_NONE ; 00\n\tconst IGNORED_PARTY_ID\n'
                        '\ttrainerclass FIRST ; stale comment\n'
                        '\ttrainerclass SECOND\n')
        assert _parse_trainer_classes(path) == {'TRAINER_NONE': 0, 'FIRST': 1, 'SECOND': 2}
        classes = Constants().trainer_classes
        assert classes['SCIENTIST'] == 0x14
        assert classes['HEX_MANIAC'] == 0x4b
        assert classes['AROMA_LADY'] == len(classes) - 1
        assert len(classes) - 1 == len(re.findall(
            r'^\s*dba\s+', (ROOT / 'data/trainers/pic_pointers.asm').read_text(), re.M))
    print('BATTLE SYMBOLS: alias/bank boundaries and constant counter checks passed')


if __name__ == '__main__':
    main()

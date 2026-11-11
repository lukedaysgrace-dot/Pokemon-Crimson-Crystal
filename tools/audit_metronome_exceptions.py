#!/usr/bin/env python3
"""Static check: Metronome can never call a protection-class move.

Every move whose effect is a guard (Protect, Detect, King's Shield, Endure,
Baneful Bunker) must be listed in MetronomeExcepts. A guard added later with
an existing effect (as King's Shield was, on EFFECT_PROTECT) is otherwise
silently callable.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GUARD_EFFECTS = {'EFFECT_PROTECT', 'EFFECT_ENDURE', 'EFFECT_BANEFUL_BUNKER'}
ALWAYS = {'METRONOME', 'STRUGGLE', 'SKETCH', 'MIMIC', 'COUNTER', 'MIRROR_COAT',
          'DESTINY_BOND', 'SLEEP_TALK', 'THIEF'}


def main():
    moves = {}
    for line in (ROOT / 'data/moves/moves.asm').read_text(encoding='utf8').splitlines():
        match = re.match(r'\s*move (EFFECT_\w+),.*;\s*(\w+)\s*$', line)
        if match:
            moves[match.group(2)] = match.group(1)
    excepts = set(re.findall(r'^\s*dw (\w+)', (ROOT / 'data/moves/metronome_exception_moves.asm')
                             .read_text(encoding='utf8'), re.M))
    required = ALWAYS | {name for name, effect in moves.items() if effect in GUARD_EFFECTS}
    missing = sorted(required - excepts)
    unknown = sorted(name for name in excepts if name not in moves and name != 'STRUGGLE')
    for name in missing:
        print(f'FAIL Metronome can call {name} ({moves.get(name, "?")})')
    for name in unknown:
        print(f'FAIL MetronomeExcepts lists unknown move {name}')
    if missing or unknown:
        return 1
    print(f'METRONOME EXCEPTIONS: {len(required)} required exclusions present '
          f'({len(excepts)} listed)')
    return 0


if __name__ == '__main__':
    sys.exit(main())

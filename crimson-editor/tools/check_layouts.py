#!/usr/bin/env python3
"""Check release/debug saved symbols without comparing unrelated ROM labels."""
import re
import sys
from pathlib import Path

def symbols(path):
    return {m[3]: (int(m[1], 16), int(m[2], 16)) for m in re.finditer(r'^([\da-fA-F]{2}):([\da-fA-F]{4}) (\S+)$', Path(path).read_text(), re.M)}

a, b = map(symbols, sys.argv[1:3])
saved = {n: v for n, v in a.items() if n.startswith('s') and 0xa000 <= v[1] < 0xc000 or n.startswith('w') and a['wPlayerData'][1] <= v[1] <= a['wPokemonDataEnd'][1]}
diff = [n for n, v in saved.items() if b.get(n) != v]
if diff:
    raise SystemExit('Release/debug save symbols differ: ' + ', '.join(diff))
print(f'Release/debug save layouts agree ({len(saved)} symbols).')

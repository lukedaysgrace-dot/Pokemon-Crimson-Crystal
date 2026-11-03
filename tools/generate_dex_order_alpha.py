#!/usr/bin/env python3
"""Generate the visible alphabetical Dex order from actual display names."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def main():
    constants = (ROOT / 'constants/pokemon_constants.asm').read_text().split('NUM_POKEMON', 1)[0]
    order = re.findall(r'^\s*const\s+(\w+)', constants, re.M)
    text = (ROOT / 'data/pokemon/names.asm').read_text().split('PokemonNames::', 1)[1]
    names = [s.rstrip('@') for s in re.findall(r'^\s*db "([^"]+)"', text, re.M)]
    assert len(order) == len(names), 'Name/species table mismatch'
    display = dict(zip(order, names))
    visible = [s for s in order if s != 'AEGISLASH_BLADE']
    visible.sort(key=lambda s: (display[s].casefold(), order.index(s)))
    result = ('; Generated from PokemonNames by tools/generate_dex_order_alpha.py.\n'
              '; Battle-only Aegislash Blade shares its base form entry.\n'
              'AlphabeticalPokedexOrder:\n' + ''.join('\tdw ' + s + '\n' for s in visible))
    (ROOT / 'data/pokemon/dex_order_alpha.asm').write_text(result)
    print('Alphabetical Dex:', len(visible), 'visible entries')


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Export the ROM's shiny color replacements for the website's sprite PNGs."""

import argparse
import json
from pathlib import Path
import re
import struct
import subprocess
from tempfile import TemporaryDirectory


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'gfx/pokemon'
WEBSITE = ROOT / 'docs/assets/pokemon'


def sprite_key(name):
    return re.sub(r'[^a-z0-9]', '', name)


def shiny_colors(path):
    colors = re.findall(r'^\s*RGB\s+(\d+),\s*(\d+),\s*(\d+)', path.read_text(), re.M)
    if len(colors) != 2:
        raise ValueError(f'Expected two shiny colors in {path}')
    return [[(int(channel) * 255 + 15) // 31 for channel in color] for color in colors]


def replacements(rgbgfx, pic, palette_file, colors):
    # RGBDS assigns the two middle slots independently for each PNG, so the
    # front and back can have different source colors for the same game slot.
    subprocess.run([rgbgfx, '-p', str(palette_file), str(pic)], check=True)
    _, first, second, _ = struct.unpack('<4H', palette_file.read_bytes())
    return {first: colors[0], second: colors[1]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rgbgfx', default='rgbgfx', help='Path to RGBDS 0.5.2 rgbgfx')
    args = parser.parse_args()
    folders = {sprite_key(folder.name): folder for folder in SOURCE.iterdir() if folder.is_dir()}
    folders['butterfreefemale'] = SOURCE / 'butterfreef'
    palettes = {}
    with TemporaryDirectory() as scratch:
        palette_file = Path(scratch) / 'sprite.pal'
        for front in sorted(WEBSITE.glob('*.png')):
            if '.' in front.stem:
                continue
            slug = front.stem
            colors = shiny_colors(folders[sprite_key(slug)] / 'shiny.pal')
            sheet = front.with_suffix('.sheet.png')
            front_palette = replacements(
                args.rgbgfx, sheet if sheet.exists() else front, palette_file, colors
            )
            palettes[slug] = front_palette
            back = front.with_suffix('.back.png')
            if back.exists():
                back_palette = replacements(args.rgbgfx, back, palette_file, colors)
                if back_palette != front_palette:
                    palettes[back.stem] = back_palette

    lines = [
        f'  {json.dumps(key)}: {json.dumps(value, separators=(",", ":"))}'
        for key, value in palettes.items()
    ]
    (WEBSITE.parent / 'shiny-palettes.json').write_text(
        '{\n' + ',\n'.join(lines) + '\n}\n', encoding='utf-8', newline='\n'
    )


if __name__ == '__main__':
    main()

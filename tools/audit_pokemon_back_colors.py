#!/usr/bin/env python3
"""Check front/back PNG colors and RGBDS palette slots; --fix repairs mismatches.

Run with the project's rgbgfx 0.5.2 and Pillow. This audits every Pokémon
back.png (including unused artwork), all Unown letters, and the four players.
Finizen and Palafin keep their deliberately separate dorsal blue palettes.
"""

import argparse
from itertools import permutations
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
BLUE_EXCEPTIONS = {"finizen", "palafin"}
PLAYERS = {"gold_back": "gold", "indigo_back": "indigo",
           "lyra_back": "lyra", "mintb": "mint"}


def rgb15(rgb):
    return sum((c >> 3) << shift for c, shift in zip(rgb, (0, 5, 10)))


def distance(a, b):
    return sum((x - y) ** 2 for x, y in zip(a, b))


def pixels(im):
    rgba = im.convert("RGBA")
    return list(rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data")
                else rgba.getdata())


def source_palette(im, compiled):
    """Recover exact authored RGB values in rgbgfx's palette order."""
    if im.mode == "P":
        pal = im.getpalette()
        return [tuple(pal[i:i + 3]) for i in range(0, 12, 3)]
    opaque = sorted({p[:3] for p in pixels(im) if p[3]})
    result = []
    for i, value in enumerate(compiled):
        matches = [c for c in opaque if rgb15(c) == value]
        if matches:
            result.append(matches[0])
        else:
            # rgbgfx supplies unused slots, particularly in grayscale art.
            result.append(tuple(((value >> shift) & 31) * 255 // 31
                                for shift in (0, 5, 10)))
    return result


def canonical(pal):
    """Keep the two authored middle colors, with background 0 and outline 3."""
    darkest = min(range(4), key=lambda i: sum(pal[i]))
    lightest = max(range(4), key=lambda i: sum(pal[i]))
    middle = [pal[i] for i in range(4) if i not in (darkest, lightest)]
    return [pal[lightest], *middle, pal[darkest]]


def compile_sprite(path, compiler, tmp):
    pal, tiles = tmp / "palette.bin", tmp / "tiles.bin"
    result = subprocess.run([compiler, "-p", str(pal), "-o", str(tiles), str(path)],
                            capture_output=True, text=True)
    if result.returncode:
        raise ValueError(f"rgbgfx failed for {path}: {result.stderr.strip()}")
    return list(struct.unpack("<4H", pal.read_bytes()))


def plan_back(back, front_palette, back_palette, exception=False):
    original = pixels(back)
    opaque = {p[:3] for p in original if p[3]}
    darkest = min(opaque, key=sum)
    lightest = max(opaque, key=sum)
    middle = sorted(opaque - {darkest, lightest})
    if len(middle) > 2:
        raise ValueError("More than four opaque colors")
    target = canonical(back_palette) if exception else front_palette
    if exception:
        # Fix tiny RGB drift in colors shared by front and back. The extra
        # blues remain authored back colors rather than becoming pink/red.
        target = [next((f for f in front_palette if rgb15(f) == rgb15(c)), c)
                  for c in target]
    choices = permutations((1, 2), len(middle))
    assignment = min(choices, key=lambda slots: sum(
        distance(c, target[i]) for c, i in zip(middle, slots)))
    mapping = {lightest: 0, darkest: 3}
    mapping.update(zip(middle, assignment))
    indices = [mapping[p[:3]] if p[3] else 0 for p in original]
    desired = [(*target[i], p[3]) for i, p in zip(indices, original)]
    return target, indices, desired


def save_sprite(path, im, palette, indices, desired):
    if any(p[3] != 255 for p in pixels(im)):
        # Keep every original alpha value, including opaque white highlights.
        out = Image.new("RGBA", im.size)
        out.putdata(desired)
    else:
        out = Image.new("P", im.size)
        out.putpalette([c for color in palette for c in color] + [0] * 756)
        out.putdata(indices)
    out.save(path, "PNG", **({"bits": 2} if out.mode == "P" else {}))


def pairs():
    pokemon = [(p.with_name("front.png"), p)
               for p in sorted((ROOT / "gfx/pokemon").glob("*/back.png"))]
    players = [(ROOT / "gfx/player" / (f + ".png"),
                ROOT / "gfx/player" / (b + ".png"))
               for b, f in PLAYERS.items()]
    return pokemon + players


def palette_bytes(text):
    result = bytearray()
    for line in text.splitlines():
        line = line.split(";", 1)[0].strip()
        rgb = re.fullmatch(r"RGB\s+(\d+),\s*(\d+),\s*(\d+)", line)
        include = re.fullmatch(r'INCLUDE "([^"]+)"', line)
        binary = re.fullmatch(r'INCBIN "([^"]+)", middle_colors', line)
        if rgb:
            r, g, b = map(int, rgb.groups())
            result.extend(struct.pack("<H", r | g << 5 | b << 10))
        elif include:
            result.extend(palette_bytes((ROOT / include[1]).read_text()))
        elif binary:
            result.extend((ROOT / binary[1]).read_bytes()[2:6])
        elif line and not line.endswith(":"):
            raise ValueError(f"Unsupported palette directive: {line}")
    return bytes(result)


def audit_rom(path):
    """Prove normal/shiny tables and every live compressed back are in the ROM."""
    rom = path.read_bytes()
    symbols = {}
    for line in path.with_suffix(".sym").read_text().splitlines():
        match = re.fullmatch(r"([0-9a-fA-F]+):([0-9a-fA-F]+) (\S+)", line)
        if match:
            bank, address = int(match[1], 16), int(match[2], 16)
            symbols[match[3]] = bank * 0x4000 + address % 0x4000

    def check(label, expected):
        offset = symbols[label]
        if rom[offset:offset + len(expected)] != expected:
            raise ValueError(f"ROM data differs from source: {label}")

    text = (ROOT / "data/pokemon/palettes.asm").read_text()
    table = palette_bytes(text.split("PokemonPalettes:", 1)[1])
    check("PokemonPalettes", table)
    text = (ROOT / "data/pokemon/back_palettes.asm").read_text()
    for label, body in re.findall(r"^(\w+):\n(.*?)(?=^\w+:|\Z)", text,
                                  flags=re.M | re.S):
        check(label, palette_bytes(body))
    count = 0
    pics = (ROOT / "gfx/pics.asm").read_text()
    for label, name in re.findall(
            r'^(\w+):\s*INCBIN "(gfx/pokemon/[^" ]+/back\.2bpp\.lz)"',
            pics, flags=re.M):
        check(label, (ROOT / name).read_bytes())
        count += 1
    main = (ROOT / "main.asm").read_text()
    players = 0
    for label, name in re.findall(
            r'^(\w+):\s*INCBIN "(gfx/player/[^" ]+)"', main, flags=re.M):
        if "_back." in name or "/mintb." in name:
            check(label, (ROOT / name).read_bytes())
            players += 1
    if players != len(PLAYERS):
        raise ValueError(f"Expected four live player backsprites, found {players}")
    trainer_pals = (ROOT / "data/trainers/palettes.asm").read_text()
    for label in ("PlayerPalette", "IndigoPlayerPalette", "MintPlayerPalette"):
        match = re.search(r"^" + label + r":[^\n]*\n(.*?)(?=^\w+:|\Z)",
                          trainer_pals, flags=re.M | re.S)
        check(label, palette_bytes(match[1]))
    print(f"Verified {path.name}: {count} live Pokémon backsprites, {players} "
          "player backsprites, player palettes, and all "
          "normal/shiny palette records match the built source assets.")
    return count


def audit(compiler, fix=False):
    report = {"checked": 0, "mismatches": [], "fixed": [],
              "front_palette_repairs": [], "exceptions": sorted(BLUE_EXCEPTIONS)}
    with tempfile.TemporaryDirectory(prefix="backsprite-colors-") as folder:
        tmp = Path(folder)
        for front_path, back_path in pairs():
            if not front_path.exists():
                raise ValueError(f"Missing front sprite: {front_path}")
            report["checked"] += 1
            with Image.open(front_path) as front, Image.open(back_path) as back:
                fp = compile_sprite(front_path, compiler, tmp)
                bp = compile_sprite(back_path, compiler, tmp)
                raw_front = source_palette(front, fp)
                target_front = canonical(raw_front)
                if raw_front != target_front:
                    report["front_palette_repairs"].append(str(front_path.relative_to(ROOT)))
                    if fix:
                        lookup = {c: i for i, c in enumerate(target_front)}
                        original = pixels(front)
                        indices = [lookup[p[:3]] if p[3] else 0 for p in original]
                        save_sprite(front_path, front, target_front, indices, original)
                target, indices, desired = plan_back(
                    back, target_front, source_palette(back, bp),
                    back_path.parent.name in BLUE_EXCEPTIONS)
                # Check compiler slots too: three-color PNGs may otherwise
                # encode black as slot 2, and embedded palettes can be reversed.
                expected = [rgb15(c) for c in target]
                mismatch = pixels(back) != desired or bp != expected
                if mismatch:
                    name = str(back_path.relative_to(ROOT))
                    report["mismatches"].append(name)
                    if fix:
                        save_sprite(back_path, back, target, indices, desired)
                        actual = compile_sprite(back_path, compiler, tmp)
                        if actual != expected:
                            raise ValueError(f"Palette order did not survive conversion: {name}")
                        report["fixed"].append(name)
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    project_compiler = Path.home() / "opt/rgbds-0.5.2/bin/rgbgfx"
    parser.add_argument("--rgbgfx", default=str(project_compiler)
                        if project_compiler.exists() else shutil.which("rgbgfx"))
    parser.add_argument("--fix", action="store_true")
    parser.add_argument("--report", type=Path)
    parser.add_argument("--rom", type=Path, action="append", default=[],
                        help="Also verify built ROM sprite data and normal/shiny palettes")
    args = parser.parse_args()
    report = audit(args.rgbgfx, args.fix)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"Checked {report['checked']} front/back pairs; "
          f"{len(report['mismatches'])} back mismatches; "
          f"{len(report['front_palette_repairs'])} front palette repairs; "
          f"{len(report['fixed'])} backsprites fixed.")
    print("Preserved separate dorsal blue palettes: Finizen, Palafin.")
    if not args.fix and (report["mismatches"] or report["front_palette_repairs"]):
        for path in report["mismatches"] + report["front_palette_repairs"]:
            print("  " + path)
        raise SystemExit(1)
    for rom in args.rom:
        audit_rom(rom)


if __name__ == "__main__":
    main()

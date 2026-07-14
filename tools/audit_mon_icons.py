#!/usr/bin/env python3
"""Verify that every overworld icon pointer owns two complete 16x16 frames."""

from __future__ import annotations

import re
import struct
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
ICON_BYTES = 8 * 16  # eight 2bpp tiles: two four-tile 16x16 frames


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def number(token: str) -> int:
    token = token.strip()
    if token.startswith("$"):
        return int(token[1:], 16)
    return int(token, 0)


def png_2bpp_size(path: Path) -> int:
    """Return the uncompressed 2bpp size generated from a PNG's dimensions."""
    with path.open("rb") as stream:
        header = stream.read(24)
    if len(header) != 24 or header[:8] != b"\x89PNG\r\n\x1a\n" or header[12:16] != b"IHDR":
        raise ValueError(f"{path.relative_to(ROOT)} is not a valid PNG")
    width, height = struct.unpack(">II", header[16:24])
    pixels = width * height
    if pixels % 4:
        raise ValueError(f"{path.relative_to(ROOT)} cannot be represented as whole 2bpp bytes")
    return pixels // 4


def binary_size(path: Path) -> int:
    if path.is_file():
        return path.stat().st_size
    if path.suffix == ".2bpp":
        png = path.with_suffix(".png")
        if png.is_file():
            return png_2bpp_size(png)
    raise FileNotFoundError(path.relative_to(ROOT))


def icon_payload_sizes() -> tuple[dict[str, int], list[str]]:
    payloads: dict[str, int] = {}
    errors: list[str] = []
    current_label: str | None = None

    for line_number, raw_line in enumerate(read(ROOT / "gfx/icons.asm").splitlines(), 1):
        line = raw_line.split(";", 1)[0]
        if re.match(r"^\s*SECTION\b", line):
            current_label = None
            continue

        label = re.match(r"^([A-Za-z_]\w*):\s*(.*)$", line)
        if label:
            current_label = label.group(1)
            payloads[current_label] = 0
            line = label.group(2)

        if current_label is None:
            continue
        incbin = re.match(
            r'^\s*INCBIN\s+"([^"]+)"(?:\s*,\s*([^,]+?)(?:\s*,\s*(.+?))?)?\s*$',
            line,
        )
        if not incbin:
            continue

        source = ROOT / incbin.group(1)
        try:
            size = binary_size(source)
            offset = number(incbin.group(2)) if incbin.group(2) else 0
            length = number(incbin.group(3)) if incbin.group(3) else size - offset
        except (FileNotFoundError, ValueError) as error:
            errors.append(f"gfx/icons.asm:{line_number}: {error}")
            continue
        if not 0 <= offset <= size or not 0 <= length <= size - offset:
            errors.append(
                f"gfx/icons.asm:{line_number}: INCBIN slice {offset}+{length} exceeds {size} bytes"
            )
            continue
        payloads[current_label] += length

    return payloads, errors


def main() -> int:
    errors: list[str] = []
    pointers = re.findall(r"^\s*dba\s+(\w+)", read(ROOT / "data/icon_pointers.asm"), re.MULTILINE)
    species_header = read(ROOT / "constants/pokemon_constants.asm").split("NUM_POKEMON", 1)[0]
    species_count = len(re.findall(r"^\s*const\s+\w+", species_header, re.MULTILINE))
    if len(pointers) != species_count:
        errors.append(f"IconPointers has {len(pointers)} rows for {species_count} species")

    payloads, payload_errors = icon_payload_sizes()
    errors.extend(payload_errors)
    for index, label in enumerate(pointers, 1):
        if label not in payloads:
            errors.append(f"IconPointers row {index}: missing gfx label {label}")
            continue
        size = payloads[label]
        if size != ICON_BYTES:
            errors.append(
                f"IconPointers row {index} ({label}) owns {size} bytes; expected {ICON_BYTES}"
            )

    if errors:
        print("OVERWORLD ICON AUDIT FAILED")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "OVERWORLD ICON AUDIT PASSED: "
        f"{len(pointers)} pointers, {len(set(pointers))} unique payloads, {ICON_BYTES} bytes each"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())

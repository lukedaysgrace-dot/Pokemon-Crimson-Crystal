#!/usr/bin/env python3
"""Audit linked ROM capacity/header integrity plus audio and binary assets."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class Audit:
    def __init__(self) -> None:
        self.checks = 0
        self.errors: list[str] = []

    def check(self, condition: bool, message: str) -> None:
        self.checks += 1
        if not condition:
            self.errors.append(message)


def audit_rom(audit: Audit, stem: str) -> tuple[int, int]:
    rom_path = ROOT / f"{stem}.gbc"
    map_path = ROOT / f"{stem}.map"
    audit.check(rom_path.is_file(), f"missing linked ROM: {rom_path.name}")
    audit.check(map_path.is_file(), f"missing linker map: {map_path.name}")
    if not rom_path.is_file() or not map_path.is_file():
        return 0, 0

    rom = rom_path.read_bytes()
    size_codes = {0: 32 << 10, 1: 64 << 10, 2: 128 << 10, 3: 256 << 10,
                  4: 512 << 10, 5: 1 << 20, 6: 2 << 20, 7: 4 << 20,
                  8: 8 << 20}
    declared_size = size_codes.get(rom[0x148], 0)
    audit.check(declared_size == len(rom),
                f"{stem}: header declares {declared_size} bytes, file has {len(rom)}")
    audit.check(rom[0x143] in (0x80, 0xC0), f"{stem}: not marked GBC compatible")
    audit.check(rom[0x147] == 0x10,
                f"{stem}: expected MBC3+timer+RAM+battery ($10), got ${rom[0x147]:02x}")
    audit.check(rom[0x149] == 0x05,
                f"{stem}: expected 64 KiB/8-bank SRAM ($05), got ${rom[0x149]:02x}")

    header_sum = 0
    for value in rom[0x134:0x14D]:
        header_sum = (header_sum - value - 1) & 0xFF
    audit.check(header_sum == rom[0x14D], f"{stem}: invalid header checksum")
    global_sum = (sum(rom) - rom[0x14E] - rom[0x14F]) & 0xFFFF
    stored_sum = (rom[0x14E] << 8) | rom[0x14F]
    audit.check(global_sum == stored_sum, f"{stem}: invalid global checksum")

    map_text = map_path.read_text(encoding="utf-8", errors="replace")
    romx_banks = [int(x) for x in re.findall(r"^ROMX bank #(\d+):", map_text, re.M)]
    max_bank = max(romx_banks, default=0)
    audit.check(max_bank < len(rom) // 0x4000,
                f"{stem}: bank {max_bank} exceeds the declared ROM capacity")
    audit.check(max_bank <= 0xFF, f"{stem}: bank {max_bank} exceeds MBC30 selection")

    current_kind = None
    for line in map_text.splitlines():
        bank_match = re.match(r"^(ROM0|ROMX|VRAM|SRAM|WRAM0|WRAMX|HRAM) bank", line)
        if bank_match:
            current_kind = bank_match.group(1)
            continue
        match = re.match(r'^  SECTION: \$([0-9a-f]+)(?:-\$([0-9a-f]+))?', line, re.I)
        if not match or current_kind not in {"ROM0", "ROMX"}:
            continue
        start = int(match.group(1), 16)
        end = int(match.group(2) or match.group(1), 16)
        lo, hi = ((0, 0x3FFF) if current_kind == "ROM0" else (0x4000, 0x7FFF))
        audit.check(lo <= start <= end <= hi,
                    f"{stem}: {current_kind} section outside ${lo:04x}-${hi:04x}")

    slack = [int(x, 16) for x in re.findall(r"^    SLACK: \$([0-9a-f]+) bytes", map_text, re.I | re.M)]
    audit.check(bool(slack), f"{stem}: linker map contains no bank slack data")
    return max_bank, min(slack, default=0)


def constants(path: Path, prefix: str) -> list[str]:
    pattern = re.compile(rf"^\s*const ({prefix}[A-Z0-9_]+)")
    return [m.group(1) for line in path.read_text().splitlines() if (m := pattern.match(line))]


def pointers(path: Path) -> list[str]:
    return re.findall(r"^\s*dba\s+(\w+)", path.read_text(), re.M)


def audit_audio(audit: Audit) -> None:
    groups = [
        ("music", "MUSIC_", "Music_", ROOT / "constants/music_constants.asm",
         ROOT / "audio/music_pointers.asm"),
        ("sfx", "SFX_", "Sfx_", ROOT / "constants/sfx_constants.asm",
         ROOT / "audio/sfx_pointers.asm"),
        ("cries", "CRY_", "Cry_", ROOT / "constants/cry_constants.asm",
         ROOT / "audio/cry_pointers.asm"),
    ]
    all_audio = "\n".join(path.read_text(errors="replace") for path in (ROOT / "audio").rglob("*.asm"))
    labels = set(re.findall(r"^(\w[\w.]*)::?", all_audio, re.M))
    music_targets: list[str] = []
    for name, const_prefix, label_prefix, const_path, ptr_path in groups:
        consts = constants(const_path, const_prefix)
        ptrs = pointers(ptr_path)
        audit.check(len(consts) == len(ptrs),
                    f"{name}: {len(consts)} constants but {len(ptrs)} pointers")
        for target in ptrs:
            audit.check(target.startswith(label_prefix), f"{name}: unexpected pointer {target}")
            audit.check(target in labels, f"{name}: pointer target {target} has no label")
        if name == "music":
            music_targets = ptrs

    # Validate every song header's channel count, channel IDs, and targets.
    for song in music_targets:
        match = re.search(rf"^{re.escape(song)}:\s*\n((?:\s*(?:musicheader|channel_count|channel)\b[^\n]*\n)+)",
                          all_audio, re.M)
        audit.check(match is not None, f"music: {song} has no channel header")
        if not match:
            continue
        block = match.group(1)
        legacy = re.findall(r"^\s*musicheader\s+(\d+)\s*,\s*(\d+)\s*,\s*(\w+)", block, re.M)
        if legacy:
            expected = int(legacy[0][0])
            channels = [(int(channel), target) for _, channel, target in legacy]
        else:
            count_match = re.search(r"^\s*channel_count\s+(\d+)", block, re.M)
            channels = [(int(channel), target) for channel, target in
                        re.findall(r"^\s*channel\s+(\d+)\s*,\s*(\w+)", block, re.M)]
            expected = int(count_match.group(1)) if count_match else 0
        audit.check(1 <= expected <= 4, f"music: {song} has invalid channel count {expected}")
        audit.check(len(channels) == expected,
                    f"music: {song} declares {expected} channels but defines {len(channels)}")
        ids = [channel for channel, _ in channels]
        audit.check(len(ids) == len(set(ids)) and all(1 <= x <= 4 for x in ids),
                    f"music: {song} has duplicate/invalid channel IDs {ids}")
        for _, target in channels:
            audit.check(target in labels, f"music: {song} channel target {target} has no label")


def audit_binary_references(audit: Audit) -> int:
    references: set[str] = set()
    for source in ROOT.rglob("*.asm"):
        if any(part in {".git", ".tmpbuild", "_to_delete"} for part in source.parts):
            continue
        text = source.read_text(encoding="utf-8", errors="replace")
        references.update(re.findall(r'^\s*INCBIN\s+"([^"]+)"', text, re.M))
    literal = [ref for ref in references if "{" not in ref and "\\" not in ref]
    for ref in sorted(literal):
        audit.check((ROOT / ref).is_file(), f"missing INCBIN asset: {ref}")
    return len(literal)


def audit_pack_palettes(audit: Audit) -> None:
    """Keep the pack's gender branch and copy length aligned with its data."""
    layout = (ROOT / "engine/gfx/cgb_layouts.asm").read_text(encoding="utf-8")
    parts = layout.split("_CGB_PackPals:", 1)
    audit.check(len(parts) == 2, "missing _CGB_PackPals")
    block = parts[1].split("_CGB_Pokepic:", 1)[0] if len(parts) == 2 else ""
    audit.check(
        re.search(
            r"bit PLAYERGENDER_FEMALE_F, a\s+jr z, \.tutorial_male\s+"
            r"ld hl, \.LyraPackPals",
            block,
        )
        is not None,
        "female characters must select .LyraPackPals",
    )

    palette_rows = []
    for relative in ("gfx/pack/pack.pal", "gfx/pack/pack_f.pal"):
        rows = len(re.findall(r"^\s*RGB\b", (ROOT / relative).read_text(encoding="utf-8"), re.M))
        palette_rows.append(rows)
        audit.check(rows % 4 == 0, f"{relative}: RGB rows do not form complete palettes")
    audit.check(
        palette_rows == [24, 24],
        f"pack palette sources contain {palette_rows}; expected six four-color palettes each",
    )
    audit.check(
        "ld bc, 6 palettes" in block,
        "_CGB_PackPals must copy exactly the six palettes present in each source",
    )


def main() -> int:
    audit = Audit()
    release_bank, release_slack = audit_rom(audit, "pokecrystal")
    debug_bank, debug_slack = audit_rom(audit, "pokecrystal_debug")
    audit_audio(audit)
    audit_pack_palettes(audit)
    asset_count = audit_binary_references(audit)
    if audit.errors:
        print("RESOURCE AUDIT FAILED")
        for error in audit.errors:
            print(f"- {error}")
        print(f"{len(audit.errors)} error(s) across {audit.checks} checks")
        return 1
    print(
        "RESOURCE AUDIT PASSED: "
        f"release bank ${release_bank:02x} (tightest slack {release_slack} B), "
        f"debug bank ${debug_bank:02x} (tightest slack {debug_slack} B), "
        f"{asset_count} binary assets"
    )
    print(f"{audit.checks} linked-resource/audio checks")
    return 0


if __name__ == "__main__":
    sys.exit(main())

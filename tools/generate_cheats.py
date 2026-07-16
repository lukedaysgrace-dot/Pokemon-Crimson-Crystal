#!/usr/bin/env python3
"""Generate pokecrystal.cheats from pokecrystal.sym (BGB GameShark format)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SYM_PATH = ROOT / "pokecrystal.sym"
OUT_PATH = ROOT / "pokecrystal.cheats"

MASTER_BALL = 0x01
MAX_REPEL_STEPS = 0xFF
DEBUG_LEVEL100 = 1 << 2  # DEBUG_LEVEL100_F in wDebugFlags
ALWAYS_CATCH = 0x01  # nonzero in wAlwaysCatchCheat


def parse_sym(path: Path) -> dict[str, int]:
    symbols: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.match(r"^[0-9a-f]{2}:([0-9a-f]{4})\s+(\S+)", line)
        if match:
            addr = int(match.group(1), 16)
            name = match.group(2)
            symbols.setdefault(name, addr)
    return symbols


def wram_code(addr: int, value: int, persistent: bool = False) -> str:
    prefix = "91" if persistent else "01"
    return f"{prefix}{value:02X}{addr & 0xFF:02X}{(addr >> 8) & 0xFF:02X}"


def cheat_block(title: str, lines: list[str], enabled: bool = False) -> list[str]:
    out = ["!disabled" if not enabled else "!enabled", f"# {title}"]
    out.extend(lines)
    return out


def codes_for_range(start: int, end: int, value: int, persistent: bool = False) -> list[str]:
    return [wram_code(addr, value, persistent) for addr in range(start, end)]


def parse_rgbds_number(value: str) -> int:
    value = value.rstrip(",")
    return int(value[1:], 16) if value.startswith("$") else int(value, 0)


def parse_const_value(path: Path, name: str) -> int:
    const_value = 0
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";", 1)[0].strip()
        if not line:
            continue
        if line.startswith("const_def"):
            parts = line.split()
            const_value = parse_rgbds_number(parts[1]) if len(parts) > 1 else 0
            continue
        if line.startswith("const "):
            const_name = line.split()[1]
            if const_name == name:
                return const_value
            const_value += 1
            continue
        if line.startswith(f"{name} EQU const_value"):
            return const_value
    raise ValueError(f"constant not found: {name}")


def parse_equ_value(path: Path, name: str) -> int:
    pattern = re.compile(rf"^{re.escape(name)}\s+EQU\s+(\$[0-9a-fA-F]+|\d+)\b")
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";", 1)[0].strip()
        match = pattern.match(line)
        if match:
            return parse_rgbds_number(match.group(1))
    raise ValueError(f"constant not found: {name}")


def parse_tm_hm_layout(path: Path) -> tuple[int, int, int]:
    """Return (first HM offset, Fly offset, end offset) in wTMsHMs."""
    tms: list[str] = []
    hms: list[str] = []
    pattern = re.compile(r"^add_(tm|hm)\s+(\w+)")
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";", 1)[0].strip()
        match = pattern.match(line)
        if not match:
            continue
        kind, move = match.groups()
        (tms if kind == "tm" else hms).append(move)

    if not tms or not hms:
        raise ValueError("could not parse TM/HM layout")
    try:
        fly_offset = len(tms) + hms.index("FLY")
    except ValueError as error:
        raise ValueError("FLY not found in HM layout") from error
    return len(tms), fly_offset, len(tms) + len(hms)


def codes_for_flag_array(start: int, num_flags: int, persistent: bool = False) -> list[str]:
    num_bytes = (num_flags + 7) // 8
    lines = codes_for_range(start, start + num_bytes, 0xFF, persistent)
    remainder = num_flags % 8
    if remainder:
        lines[-1] = wram_code(start + num_bytes - 1, (1 << remainder) - 1, persistent)
    return lines


def main() -> int:
    sym_path = Path(sys.argv[1]) if len(sys.argv) > 1 else SYM_PATH
    out_path = Path(sys.argv[2]) if len(sys.argv) > 2 else OUT_PATH

    if not sym_path.is_file():
        print(f"error: missing symbol file: {sym_path}", file=sys.stderr)
        return 1

    sym = parse_sym(sym_path)

    def need(name: str) -> int:
        try:
            return sym[name]
        except KeyError:
            print(f"error: symbol not found: {name}", file=sys.stderr)
            raise SystemExit(1)

    w_tile_down = need("wTileDown")
    w_tile_up = need("wTileUp")
    w_tile_left = need("wTileLeft")
    w_tile_right = need("wTileRight")
    w_tile_permissions = need("wTilePermissions")
    w_repel_effect = need("wRepelEffect")
    w_johto_badges = need("wJohtoBadges")
    w_kanto_badges = need("wKantoBadges")
    w_tms_hms = need("wTMsHMs")
    w_pokegear_flags = need("wPokegearFlags")
    w_visited_spawns = need("wVisitedSpawns")
    w_debug_flags = need("wDebugFlags")
    w_num_balls = need("wNumBalls")
    w_balls = need("wBalls")
    w_num_items = need("wNumItems")
    w_items = need("wItems")

    item_constants = ROOT / "constants" / "item_constants.asm"
    wram_constants = ROOT / "constants" / "wram_constants.asm"
    hm_start_offset, fly_offset, tm_hm_end_offset = parse_tm_hm_layout(item_constants)
    fly_hm = w_tms_hms + fly_offset
    hm_start = w_tms_hms + hm_start_offset
    hm_end = w_tms_hms + tm_hm_end_offset
    num_johto_badges = parse_const_value(wram_constants, "NUM_JOHTO_BADGES")
    num_kanto_badges = parse_const_value(wram_constants, "NUM_KANTO_BADGES")
    map_card_bit = parse_const_value(wram_constants, "POKEGEAR_MAP_CARD_F")
    pokegear_obtained_bit = parse_equ_value(wram_constants, "POKEGEAR_OBTAINED_F")
    pokegear_map_and_on = (1 << map_card_bit) | (1 << pokegear_obtained_bit)
    num_spawns = parse_const_value(ROOT / "constants" / "map_data_constants.asm", "NUM_SPAWNS")
    visited_end = w_visited_spawns + (num_spawns + 7) // 8

    blocks: list[list[str]] = []

    blocks.append(
        cheat_block(
            "walk through walls",
            [
                wram_code(w_tile_down, 0x00, True),
                wram_code(w_tile_up, 0x00, True),
                wram_code(w_tile_left, 0x00, True),
                wram_code(w_tile_right, 0x00, True),
                wram_code(w_tile_permissions, 0x00, True),
            ],
        )
    )

    blocks.append(
        cheat_block(
            "no random encounters",
            [
                wram_code(w_repel_effect, MAX_REPEL_STEPS, True),
            ],
        )
    )

    blocks.append(
        cheat_block(
            "all badges (16)",
            codes_for_flag_array(w_johto_badges, num_johto_badges, True)
            + codes_for_flag_array(w_kanto_badges, num_kanto_badges, True),
        )
    )

    hm_lines = codes_for_range(hm_start, hm_end, 0x01, True)
    blocks.append(cheat_block("all hms", hm_lines))

    fly_lines = (
        codes_for_flag_array(w_johto_badges, num_johto_badges, True)
        + codes_for_flag_array(w_kanto_badges, num_kanto_badges, True)
        + [
            wram_code(fly_hm, 0x01, True),
            wram_code(w_pokegear_flags, pokegear_map_and_on, True),
        ]
    )
    fly_lines.extend(codes_for_range(w_visited_spawns, visited_end, 0xFF, True))
    blocks.append(cheat_block("fly anywhere (needs a flying party mon)", fly_lines))

    # After defeating a Pokémon, participants level up to 100 with full stats/moves.
    blocks.append(
        cheat_block(
            "level 100 after battle (participants)",
            [wram_code(w_debug_flags, DEBUG_LEVEL100, True)],
        )
    )

    w_always_catch = need("wAlwaysCatchCheat")
    blocks.append(
        cheat_block(
            "100% catch rate (any ball)",
            [wram_code(w_always_catch, ALWAYS_CATCH, True)],
        )
    )

    blocks.append(
        cheat_block(
            "master balls x99",
            [
                wram_code(w_num_balls, 0x01),
                wram_code(w_balls, MASTER_BALL),
                wram_code(w_balls + 1, 99),
            ],
        )
    )

    blocks.append(
        cheat_block(
            "johto badges only",
            [wram_code(w_johto_badges, 0xFF, True)],
        )
    )

    blocks.append(
        cheat_block(
            "restore kanto no badges",
            [wram_code(w_kanto_badges, 0x00)],
        )
    )

    starter_pack = [
        (0x0C, w_num_items),
        (0x01, w_items),
        (0x63, w_items + 1),
        (0x02, w_items + 2),
        (0x63, w_items + 3),
        (0x04, w_items + 4),
        (0x63, w_items + 5),
        (0x05, w_items + 6),
        (0x63, w_items + 7),
        (0x9D, w_items + 8),
        (0x63, w_items + 9),
        (0x9F, w_items + 10),
        (0x63, w_items + 11),
        (0xA0, w_items + 12),
        (0x63, w_items + 13),
        (0xA1, w_items + 14),
        (0x63, w_items + 15),
        (0xA4, w_items + 16),
        (0x63, w_items + 17),
        (0xA5, w_items + 18),
        (0x63, w_items + 19),
        (0xA6, w_items + 20),
        (0x63, w_items + 21),
        (0xB1, w_items + 22),
        (0x63, w_items + 23),
        (0xFF, w_items + 24),
    ]
    blocks.append(
        cheat_block(
            "useful items x99 (master ball, rare candy, etc.)",
            [wram_code(addr, value) for value, addr in starter_pack],
        )
    )

    lines: list[str] = [
        "# Auto-generated from pokecrystal.sym by tools/generate_cheats.py",
        "# Re-run after rebuilding the ROM if cheats stop working.",
        "",
    ]
    for block in blocks:
        lines.extend(block)
        lines.append("")

    out_path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
    print(f"Wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

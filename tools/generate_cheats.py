#!/usr/bin/env python3
"""Generate pokecrystal.cheats from pokecrystal.sym (BGB GameShark format)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SYM_PATH = ROOT / "pokecrystal.sym"
OUT_PATH = ROOT / "pokecrystal.cheats"

NUM_TMS = 50
NUM_HMS = 7
MASTER_BALL = 0x01
POKEGEAR_MAP_AND_ON = 0x81  # map card + pokegear obtained
MAX_REPEL_STEPS = 0xFF


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
    w_battle_level = need("wBattleMonLevel")
    w_num_balls = need("wNumBalls")
    w_balls = need("wBalls")
    w_num_items = need("wNumItems")
    w_items = need("wItems")
    party_levels = [
        need("wPartyMon1Level"),
        need("wPartyMon2Level"),
        need("wPartyMon3Level"),
        need("wPartyMon4Level"),
        need("wPartyMon5Level"),
        need("wPartyMon6Level"),
    ]

    fly_hm = w_tms_hms + NUM_TMS + 1  # HM02 FLY
    hm_end = w_tms_hms + NUM_TMS + NUM_HMS
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
            [
                wram_code(w_johto_badges, 0xFF, True),
                wram_code(w_kanto_badges, 0xFF, True),
            ],
        )
    )

    hm_lines: list[str] = []
    for addr in range(w_tms_hms, hm_end):
        hm_lines.append(wram_code(addr, 0x01, True))
    blocks.append(cheat_block("all hms", hm_lines))

    fly_lines = [
        wram_code(w_johto_badges, 0xFF, True),
        wram_code(w_kanto_badges, 0xFF, True),
        wram_code(fly_hm, 0x01, True),
        wram_code(w_pokegear_flags, POKEGEAR_MAP_AND_ON, True),
    ]
    fly_lines.extend(codes_for_range(w_visited_spawns, visited_end, 0xFF, True))
    blocks.append(cheat_block("fly anywhere (needs a flying party mon)", fly_lines))

    # Force your party (and active battle mon) to Lv100 — not the enemy.
    level_100_lines = [wram_code(addr, 100, True) for addr in party_levels]
    level_100_lines.append(wram_code(w_battle_level, 100, True))
    blocks.append(cheat_block("level 100 party", level_100_lines))

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

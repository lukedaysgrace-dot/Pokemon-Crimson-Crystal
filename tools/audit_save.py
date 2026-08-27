#!/usr/bin/env python3
"""Audit linked SRAM layout and save/backup implementation symmetry."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SRAM_START = 0xA000
SRAM_END = 0xC000


class Audit:
    def __init__(self) -> None:
        self.checks = 0
        self.errors: list[str] = []

    def expect(self, condition: bool, message: str) -> None:
        self.checks += 1
        if not condition:
            self.errors.append(message)

    def finish(self) -> int:
        if self.errors:
            print("SAVE AUDIT FAILED")
            for error in self.errors:
                print(f"- {error}")
            print(f"{len(self.errors)} error(s) across {self.checks} checks")
            return 1
        print(f"SAVE AUDIT PASSED: {self.checks} linked-layout and recovery checks")
        return 0


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_symbols(path: Path, audit: Audit) -> dict[str, tuple[int, int]]:
    audit.expect(path.is_file(), f"missing linked symbol file {path.name}; build the ROM first")
    if not path.is_file():
        return {}
    result = {}
    for line in read(path).splitlines():
        match = re.match(r"^([0-9a-fA-F]{2}):([0-9a-fA-F]{4})\s+(\S+)$", line)
        if match:
            result[match.group(3)] = (int(match.group(1), 16), int(match.group(2), 16))
    return result


def function_body(text: str, label: str) -> str:
    match = re.search(
        rf"^{re.escape(label)}:\s*\n(.*?)(?=^[A-Za-z_][A-Za-z0-9_.]*:\s*$|\Z)",
        text,
        re.MULTILINE | re.DOTALL,
    )
    return match.group(1) if match else ""


def calls(body: str) -> list[str]:
    return re.findall(r"^\s*(?:far)?call\s+([A-Za-z_][A-Za-z0-9_.]*)", body, re.MULTILINE)


def audit_layout(audit: Audit, symbols: dict[str, tuple[int, int]]) -> None:
    required = {
        "sBackupOptions",
        "sBackupCheckValue1",
        "sBackupSaveData",
        "sBackupGameData",
        "sBackupGameDataEnd",
        "sBackupPokemonIndexTable",
        "sBackupConversionTableChecksum",
        "sBackupSaveDataEnd",
        "sBackupChecksum",
        "sBackupCheckValue2",
        "sOptions",
        "sCheckValue1",
        "sSaveData",
        "sGameData",
        "sGameDataEnd",
        "sPokemonIndexTable",
        "sConversionTableChecksum",
        "sSaveDataEnd",
        "sChecksum",
        "sCheckValue2",
        "sSaveVersion",
        "sWritingBackup",
        "sNewBox1",
        "sNewBoxEnd",
        "sBackupNewBox1",
        "sBackupNewBoxEnd",
        "sBoxMons1A",
        "sBoxMons1B",
        "sBoxMons2A",
        "sBoxMons2B",
        "wPokemonIndexTable",
        "wPokemonIndexTableEnd",
        "wMoveIndexTable",
        "wMoveIndexTableEnd",
    }
    for name in sorted(required):
        audit.expect(name in symbols, f"linked symbol file is missing {name}")
    if not required <= symbols.keys():
        return

    def span(start: str, end: str) -> int:
        audit.expect(symbols[start][0] == symbols[end][0], f"{start} and {end} are in different banks")
        return symbols[end][1] - symbols[start][1]

    mirrored_spans = [
        ("sOptions", "sCheckValue1", "sBackupOptions", "sBackupCheckValue1", "options"),
        ("sGameData", "sGameDataEnd", "sBackupGameData", "sBackupGameDataEnd", "game data"),
        (
            "sPokemonIndexTable",
            "sConversionTableChecksum",
            "sBackupPokemonIndexTable",
            "sBackupConversionTableChecksum",
            "Pokémon index table",
        ),
        ("sSaveData", "sSaveDataEnd", "sBackupSaveData", "sBackupSaveDataEnd", "checksummed save data"),
        ("sSaveDataEnd", "sChecksum", "sBackupSaveDataEnd", "sBackupChecksum", "checksum padding"),
    ]
    for primary_start, primary_end, backup_start, backup_end, description in mirrored_spans:
        primary_size = span(primary_start, primary_end)
        backup_size = span(backup_start, backup_end)
        audit.expect(primary_size == backup_size, f"primary/backup {description} sizes differ")
        audit.expect(primary_size > 0, f"{description} has no storage")

    for prefix in ("s", "sBackup"):
        checksum = symbols[prefix + "Checksum"]
        check2 = symbols[prefix + "CheckValue2"]
        audit.expect(
            checksum[0] == check2[0] and check2[1] == checksum[1] + 2,
            f"{prefix}CheckValue2 does not immediately follow its 16-bit checksum",
        )

    # The storage system (docs/pc_storage_design.md) spans SRAM banks 2-6;
    # bank 7 keeps the Japanese-mobile compatibility labels. All eight banks
    # are advertised in the header (rgbfix -r 5).
    live_symbols = {name for name in required if name.startswith("s")}
    for name in sorted(live_symbols):
        bank, address = symbols[name]
        audit.expect(0 <= bank < 8, f"{name} uses unavailable SRAM bank {bank}")
        audit.expect(SRAM_START <= address < SRAM_END, f"{name} lies outside SRAM address space")

    # Box metadata: active and backup snapshots must be equal-sized and contiguous.
    active_size = span("sNewBox1", "sNewBoxEnd")
    backup_size = span("sBackupNewBox1", "sBackupNewBoxEnd")
    audit.expect(active_size == backup_size, "active/backup box metadata sizes differ")
    audit.expect(active_size % 33 == 0, "box metadata is not a whole number of 33-byte boxes")
    audit.expect(symbols["sNewBoxEnd"] == symbols["sBackupNewBox1"], "backup snapshot must directly follow the active metadata")
    # PokeDB sections: 57-byte records, whole banks never overrun.
    for pool in ("1", "2"):
        for section in ("A", "B"):
            start = symbols[f"sBoxMons{pool}{section}"]
            end = symbols[f"sBoxMons{pool}{section}End"]
            audit.expect(start[0] == end[0], f"PokeDB {pool}{section} crosses a bank")
            size = end[1] - start[1]
            audit.expect(size % 57 == 0 and size > 0, f"PokeDB {pool}{section} is not a whole number of 57-byte records")
            audit.expect(end[1] <= SRAM_END, f"PokeDB {pool}{section} extends past the end of its bank")
    audit.expect(span("sBoxMons1A", "sBoxMons1AEnd") == span("sBoxMons2A", "sBoxMons2AEnd"), "pool 1/2 section A sizes differ")
    audit.expect(span("sBoxMons1B", "sBoxMons1BEnd") == span("sBoxMons2B", "sBoxMons2BEnd"), "pool 1/2 section B sizes differ")

    pokemon_index_size = symbols["wPokemonIndexTableEnd"][1] - symbols["wPokemonIndexTable"][1]
    move_index_size = symbols["wMoveIndexTableEnd"][1] - symbols["wMoveIndexTable"][1]
    audit.expect(pokemon_index_size == 0x100, f"Pokémon index table is ${pokemon_index_size:x}, expected $100")
    audit.expect(move_index_size == 0x200, f"move index table is ${move_index_size:x}, expected $200")


def audit_source(audit: Audit) -> None:
    text = read(ROOT / "engine/menus/save.asm")
    sram = read(ROOT / "sram.asm")

    save_calls = calls(function_body(text, "SaveGameData"))
    expected_save_order = [
        "ValidateSave",
        "SaveOptions",
        "SavePlayerData",
        "SavePokemonData",
        "SaveIndexTables",
        "SetSavePhase",
        "SaveChecksum",
        "WriteBackupSave",
    ]
    positions = [save_calls.index(name) if name in save_calls else -1 for name in expected_save_order]
    audit.expect(-1 not in positions, "SaveGameData is missing a primary or backup save stage")
    audit.expect(positions == sorted(positions), "SaveGameData stages are not in safe primary-then-backup order")

    link_calls = calls(function_body(text, "SaveAfterLinkTrade"))
    for primary, backup in (
        ("SavePokemonData", "SaveBackupPokemonData"),
        ("SaveIndexTables", "SaveBackupIndexTables"),
        ("SaveChecksum", "SaveBackupChecksum"),
    ):
        audit.expect(primary in link_calls and backup in link_calls, f"link-trade save does not mirror {primary}")
        if primary in link_calls and backup in link_calls:
            audit.expect(link_calls.index(primary) < link_calls.index(backup), f"{backup} runs before {primary}")

    load_calls = calls(function_body(text, "TryLoadSaveFile"))
    for name in ("VerifyChecksum", "VerifyBackupChecksum", "LoadPlayerData", "LoadBackupPlayerData"):
        audit.expect(name in load_calls, f"TryLoadSaveFile is missing {name}")
    if all(name in load_calls for name in ("VerifyChecksum", "VerifyBackupChecksum")):
        audit.expect(
            load_calls.index("VerifyChecksum") < load_calls.index("VerifyBackupChecksum"),
            "backup checksum is tried before the primary checksum",
        )

    for routine, table, checksum_field, save_range in (
        ("SaveChecksum", "sMoveIndexTable", "sConversionTableChecksum", "sSaveData"),
        ("SaveBackupChecksum", "sBackupMoveIndexTable", "sBackupConversionTableChecksum", "sBackupSaveData"),
        ("VerifyChecksum", "sMoveIndexTable", "sConversionTableChecksum", "sSaveData"),
        (
            "VerifyBackupChecksum",
            "sBackupMoveIndexTable",
            "sBackupConversionTableChecksum",
            "sBackupSaveData",
        ),
    ):
        body = function_body(text, routine)
        audit.expect(bool(body), f"missing {routine}")
        audit.expect(table in body, f"{routine} does not cover the move conversion table")
        audit.expect(checksum_field in body, f"{routine} does not use {checksum_field}")
        audit.expect(save_range in body and save_range + "End" in body, f"{routine} does not cover the full save range")

    backup_calls = calls(function_body(text, "WriteBackupSave"))
    for name in ("SaveStorageSystem", "ValidateBackupSave", "SaveBackupOptions", "SaveBackupPlayerData",
                 "SaveBackupPokemonData", "SaveBackupIndexTables", "SaveBackupChecksum", "SetSavePhase"):
        audit.expect(name in backup_calls, f"WriteBackupSave is missing {name}")
    if "SaveStorageSystem" in backup_calls and "SaveBackupChecksum" in backup_calls:
        audit.expect(backup_calls.index("SaveStorageSystem") < backup_calls.index("SaveBackupChecksum"),
                     "storage snapshot must be committed before the backup checksum")
    audit.expect("WasMidSaveAborted" in load_calls and "LoadStorageSystem" in load_calls,
                 "TryLoadSaveFile must repair an interrupted backup write and load the storage snapshot")

    audit.expect(
        "sBackupSaveData::" in sram and "sSaveData::" in sram,
        "SRAM source is missing primary or backup save ranges",
    )


def audit_rom_header(audit: Audit) -> None:
    rom = ROOT / "pokecrystal.gbc"
    audit.expect(rom.is_file(), "missing pokecrystal.gbc; build the release ROM first")
    if not rom.is_file():
        return
    data = rom.read_bytes()
    audit.expect(len(data) > 0x149, "ROM is too short to contain a cartridge header")
    if len(data) > 0x149:
        audit.expect(data[0x149] == 0x05, f"ROM advertises RAM-size code ${data[0x149]:02x}, expected $05 (8 banks, 64 KiB)")


def main() -> int:
    audit = Audit()
    symbols = parse_symbols(ROOT / "pokecrystal.sym", audit)
    audit_layout(audit, symbols)
    audit_source(audit)
    audit_rom_header(audit)
    return audit.finish()


if __name__ == "__main__":
    sys.exit(main())

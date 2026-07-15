#!/usr/bin/env python3
"""Static integrity checks for moves, effects, learnsets, and egg moves."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class Audit:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.counts: dict[str, int] = {}

    def check(self, condition: bool, message: str) -> None:
        if not condition:
            self.errors.append(message)

    def count(self, name: str, value: int) -> None:
        self.counts[name] = value


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def number(token: str) -> int:
    token = token.strip()
    if token.startswith("$"):
        return int(token[1:], 16)
    return int(token, 0)


def parse_constants(relative: str, stop_at: str | None = None) -> tuple[list[str], dict[str, int]]:
    value = 0
    by_value: dict[int, str] = {}
    values: dict[str, int] = {}
    for raw in read(relative).splitlines():
        line = raw.split(";", 1)[0].strip()
        if stop_at and line.startswith(stop_at):
            break
        match = re.fullmatch(r"const_def(?:\s+([^,\s]+))?.*", line)
        if match:
            value = number(match.group(1)) if match.group(1) else 0
            continue
        match = re.fullmatch(r"const\s+([A-Z][A-Z0-9_]*)", line)
        if match:
            name = match.group(1)
            values[name] = value
            by_value[value] = name
            value += 1
    if not by_value:
        return [], values
    ordered = [by_value.get(index, f"<missing {index}>") for index in range(max(by_value) + 1)]
    return ordered, values


def global_blocks(text: str, suffix: str = "") -> dict[str, list[str]]:
    lines = text.splitlines()
    starts: list[tuple[int, str]] = []
    for index, line in enumerate(lines):
        match = re.fullmatch(r"([A-Za-z][A-Za-z0-9_]*):{1,2}", line)
        if match and (not suffix or match.group(1).endswith(suffix)):
            starts.append((index, match.group(1)))
    blocks: dict[str, list[str]] = {}
    all_global = [
        index
        for index, line in enumerate(lines)
        if re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*:{1,2}", line)
    ]
    for start, name in starts:
        end = next((index for index in all_global if index > start), len(lines))
        blocks[name] = lines[start + 1 : end]
    return blocks


def normalize(name: str) -> str:
    return re.sub(r"[^a-z0-9]", "", name.lower())


def eval_simple_expr(expression: str, constants: dict[str, int]) -> int:
    tokens = re.findall(r"[A-Z][A-Z0-9_]*|\$[0-9a-fA-F]+|\d+|[+-]", expression)
    if not tokens:
        raise ValueError(f"empty expression: {expression!r}")

    def term(token: str) -> int:
        if token in constants:
            return constants[token]
        return number(token)

    result = term(tokens[0])
    index = 1
    while index < len(tokens):
        operator, operand = tokens[index], term(tokens[index + 1])
        result = result + operand if operator == "+" else result - operand
        index += 2
    return result


def pointer_section(text: str, start_label: str, end_label: str) -> list[str]:
    lines = text.splitlines()
    start_name = start_label.rstrip(":")
    end_name = end_label.rstrip(":")
    start = next(index for index, line in enumerate(lines) if line.strip().rstrip(":") == start_name)
    end = next(
        index
        for index, line in enumerate(lines[start + 1 :], start + 1)
        if line.strip().rstrip(":") == end_name
    )
    return lines[start + 1 : end]


def expand_pointers(lines: list[str], constants: dict[str, int]) -> list[str]:
    result: list[str] = []
    index = 0
    while index < len(lines):
        code = lines[index].split(";", 1)[0].strip()
        repeat = re.fullmatch(r"rept\s+(.+)", code)
        if repeat:
            end = index + 1
            while end < len(lines) and lines[end].split(";", 1)[0].strip() != "endr":
                end += 1
            if end == len(lines):
                raise ValueError("unterminated rept in pointer table")
            inner = expand_pointers(lines[index + 1 : end], constants)
            result.extend(inner * eval_simple_expr(repeat.group(1), constants))
            index = end + 1
            continue
        pointer = re.fullmatch(r"dw\s+([A-Za-z][A-Za-z0-9_]*)", code)
        if pointer:
            result.append(pointer.group(1))
        index += 1
    return result


def audit_move_tables(audit: Audit) -> tuple[list[str], dict[str, int], dict[str, list[str]]]:
    ordered, move_ids = parse_constants("constants/move_constants.asm", "NUM_ATTACKS")
    moves = ordered[1:]
    audit.check(ordered and ordered[0] == "NO_MOVE", "move constant 0 must be NO_MOVE")
    audit.count("moves", len(moves))

    rows: list[tuple[str, list[str]]] = []
    for line_number, raw in enumerate(read("data/moves/moves.asm").splitlines(), 1):
        code, _, comment = raw.partition(";")
        match = re.match(r"\s*move\s+(.+?)\s*$", code)
        if not match:
            continue
        fields = [field.strip() for field in match.group(1).split(",")]
        label = comment.strip().split()[0] if comment.strip() else ""
        audit.check(len(fields) == 7, f"moves.asm:{line_number}: move row has {len(fields)} fields, expected 7")
        rows.append((label, fields))

    audit.check(len(rows) == len(moves), f"move rows: got {len(rows)}, expected {len(moves)}")
    for index, expected in enumerate(moves):
        if index >= len(rows):
            break
        label, fields = rows[index]
        audit.check(label == expected, f"move row {index + 1}: comment {label or '<missing>'}, expected {expected}")
        if len(fields) != 7:
            continue
        try:
            power, accuracy, pp, chance = map(number, (fields[1], fields[4], fields[5], fields[6]))
        except ValueError:
            audit.errors.append(f"move {expected}: non-numeric power/accuracy/PP/chance")
            continue
        audit.check(0 <= power <= 255, f"move {expected}: invalid power {power}")
        audit.check(0 <= accuracy <= 100, f"move {expected}: invalid accuracy {accuracy}")
        audit.check(1 <= pp <= 255, f"move {expected}: invalid PP {pp}")
        audit.check(0 <= chance <= 100, f"move {expected}: invalid effect chance {chance}")
        audit.check(
            fields[3] in {"CATEGORIZE_PHYSICAL", "CATEGORIZE_SPECIAL", "CATEGORIZE_STATUS"},
            f"move {expected}: invalid category {fields[3]}",
        )
        if fields[3] == "CATEGORIZE_STATUS":
            audit.check(power == 0, f"move {expected}: status move has nonzero power {power}")

    move_rows = {moves[index]: rows[index][1] for index in range(min(len(moves), len(rows)))}
    if "KNOCK_OFF" in move_rows and len(move_rows["KNOCK_OFF"]) == 7:
        audit.check(move_rows["KNOCK_OFF"][6] == "0", "KNOCK_OFF chance must be 0 (its item effect is primary, not Sheer Force eligible)")

    canonical_rows = {
        "FIRST_IMPRESSION": ["EFFECT_FIRST_IMPRESSION", "90", "BUG", "CATEGORIZE_PHYSICAL", "100", "10", "0"],
        "LIQUIDATION": ["EFFECT_DEFENSE_DOWN_HIT", "85", "WATER", "CATEGORIZE_PHYSICAL", "100", "10", "20"],
    }
    for move, expected in canonical_rows.items():
        if move in move_rows:
            audit.check(move_rows[move] == expected, f"move {move}: got {move_rows[move]}, expected {expected}")

    names = re.findall(r'^\s*db\s+"([^"]*)"', read("data/moves/names.asm"), re.MULTILINE)
    audit.check(len(names) == len(moves), f"move names: got {len(names)}, expected {len(moves)}")
    for index, name in enumerate(names):
        move = moves[index] if index < len(moves) else f"entry {index + 1}"
        audit.check(name.endswith("@"), f"move name {move}: missing @ terminator")
        visible = name[:-1] if name.endswith("@") else name
        audit.check(len(visible) <= 12, f"move name {move}: {len(visible)} characters exceeds 12")

    descriptions = read("data/moves/descriptions.asm")
    pointer_lines = pointer_section(descriptions, "MoveDescriptions1:", "InvalidMoveDescription:")
    description_pointers = [
        match.group(1)
        for raw in pointer_lines
        if (match := re.fullmatch(r"\s*dw\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?", raw))
    ]
    audit.check(
        len(description_pointers) == len(moves),
        f"move description pointers: got {len(description_pointers)}, expected {len(moves)}",
    )
    description_blocks = global_blocks(descriptions, "Description")
    for move, label in zip(moves, description_pointers):
        audit.check(label in description_blocks, f"move {move}: missing description label {label}")
        if label not in description_blocks:
            continue
        fragments: list[str] = []
        terminated = False
        for raw in description_blocks[label]:
            match = re.match(r'\s*(?:db|next)\s+"([^"]*)"', raw)
            if not match:
                continue
            fragment = match.group(1)
            fragments.append(fragment.replace("@", ""))
            if "@" in fragment:
                terminated = True
                break
        audit.check(terminated, f"move {move}: description {label} has no @ terminator")
        audit.check(len(fragments) <= 2, f"move {move}: description uses {len(fragments)} rows; UI supports 2")
        for row, fragment in enumerate(fragments, 1):
            audit.check(len(fragment) <= 18, f"move {move}: description row {row} is {len(fragment)} chars (max 18): {fragment!r}")

    return moves, move_ids, global_blocks(read("data/moves/effects.asm"))


def audit_contact(audit: Audit, move_ids: dict[str, int]) -> None:
    text = read("data/moves/contact_moves.asm")
    byte_values = [int(value, 16) for value in re.findall(r"\$([0-9a-fA-F]{2})", text)]
    num_moves = max(move_ids[name] for name in move_ids if name != "NO_MOVE")
    audit.check(len(byte_values) == num_moves // 8 + 1, f"contact table has {len(byte_values)} bytes, expected {num_moves // 8 + 1}")

    expected = {
        "POUND": True,
        "PAY_DAY": False,
        "BIDE": True,
        "CRABHAMMER": True,
        "SACRED_FIRE": False,
        "DRAGONBREATH": False,
        "GIGA_HAMMER": True,
        "DRAINING_KISS": True,
        "DARK_PULSE": False,
        "BITTER_BLADE": True,
        "ICE_SHARD": False,
        "INFESTATION": True,
        "ACCELROCK": True,
        "POISON_JAB": True,
        "LUNGE": True,
        "PIXIE_PUNCH": True,
        "MORTAL_SPIN": True,
        "FIRST_IMPRESSION": True,
        "LIQUIDATION": True,
    }
    for move, should_contact in expected.items():
        move_id = move_ids[move]
        actual = bool(byte_values[move_id // 8] & (1 << (move_id & 7))) if move_id // 8 < len(byte_values) else False
        audit.check(actual == should_contact, f"contact flag {move}: got {actual}, expected {should_contact}")


def audit_effects(audit: Audit, moves: list[str], scripts: dict[str, list[str]]) -> None:
    effect_order, effect_ids = parse_constants("constants/move_effect_constants.asm")
    pointer_text = read("data/moves/effects_pointers.asm")
    effect_pointers = [
        match.group(1)
        for raw in pointer_text.splitlines()
        if (match := re.fullmatch(r"\s*dw\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?", raw))
    ]
    audit.count("move effects", len(effect_order))
    audit.check(len(effect_pointers) == len(effect_order), f"effect pointers: got {len(effect_pointers)}, expected {len(effect_order)}")
    for index, label in enumerate(effect_pointers):
        effect = effect_order[index] if index < len(effect_order) else f"entry {index}"
        audit.check(label in scripts, f"effect {effect}: missing script {label}")

    move_rows = [
        [field.strip() for field in match.group(1).split(",")]
        for raw in read("data/moves/moves.asm").splitlines()
        if (match := re.match(r"\s*move\s+(.+?)(?:\s*;.*)?$", raw))
    ]
    for move, fields in zip(moves, move_rows):
        if fields:
            audit.check(fields[0] in effect_ids, f"move {move}: unknown effect {fields[0]}")

    for label, lines in scripts.items():
        commands = [
            raw.split(";", 1)[0].strip().split()[0]
            for raw in lines
            if raw.split(";", 1)[0].strip()
        ]
        audit.check(commands.count("effectchance") <= 1, f"effect script {label}: duplicate effectchance commands")

    ordering = {
        "DefenseUpHit": ("defenseup",),
        "AttackUpHit": ("attackup",),
        "AllUpHit": ("allstatsup",),
        "DracoMeteor": ("specialattackdown2",),
        "CloseCombat": ("defensedown", "specialdefensedown"),
        "SpeedUpHit": ("speedup",),
    }
    for label, stat_commands in ordering.items():
        commands = [raw.split(";", 1)[0].strip() for raw in scripts.get(label, [])]
        present = all(command in commands for command in stat_commands) and "checkfaint" in commands
        audit.check(present, f"effect script {label}: missing stat/checkfaint command")
        if present:
            stat_indices = [commands.index(command) for command in stat_commands]
            faint_index = commands.index("checkfaint")
            audit.check(
                all(index < faint_index for index in stat_indices),
                f"effect script {label}: self stat change is skipped on KO",
            )
            audit.check(
                "savemiss" in commands[:min(stat_indices)],
                f"effect script {label}: must save the genuine hit/miss state before its self stat change",
            )
            audit.check(
                "restoremiss" in commands[max(stat_indices):faint_index],
                f"effect script {label}: must restore the genuine hit/miss state before contact/faint hooks",
            )
            audit.check(
                "resetmiss" not in commands[min(stat_indices):faint_index],
                f"effect script {label}: resetmiss would turn a genuine miss into a hit before checkfaint",
            )

    command_source = read("engine/battle/effect_commands.asm")
    audit.check(
        re.search(
            r"BattleCommand_AllStatsUp:.*?ld a, \[wPreStatAttackMiss\]\s+and a\s+ret nz",
            command_source,
            re.DOTALL,
        )
        is not None,
        "AllStatsUp must not clear a genuine damaging-move miss and apply its boosts",
    )
    audit.check(
        re.search(
            r"BattleCommand_SaveMiss:.*?ld a, \[wAttackMissed\]\s+ld \[wPreStatAttackMiss\], a.*?"
            r"BattleCommand_RestoreMiss:.*?ld a, \[wPreStatAttackMiss\]\s+ld \[wAttackMissed\], a",
            command_source,
            re.DOTALL,
        )
        is not None,
        "missing save/restore commands for the pre-stat hit state",
    )

    uturn_commands = [raw.split(";", 1)[0].strip() for raw in scripts.get("UTurn", [])]
    audit.check("checkfaint" in uturn_commands and "uturn" in uturn_commands, "UTurn script is incomplete")

    checkfaint_source = command_source
    audit.check(
        re.search(
            r"\.no_dbond\s+ld a, BATTLE_VARS_MOVE_EFFECT\s+call GetBattleVar\s+cp EFFECT_U_TURN\s+jr z, \.u_turn_ko.*?\.u_turn_ko\s+.*?call BattleCommand_UTurn",
            checkfaint_source,
            re.DOTALL,
        )
        is not None,
        "CheckFaint must let U-turn/Volt Switch continue after a non-Destiny-Bond KO",
    )
    uturn_core = read("engine/battle/effect_commands_core.asm")
    audit.check(
        re.search(r"BattleUTurn_Core:.*?farcall UserHasFainted\s+ret z", uturn_core, re.DOTALL) is not None,
        "BattleUTurn_Core must not pivot a user fainted by a contact ability",
    )

    chance_source = read("engine/battle/abilities_engine.asm")
    chance_match = re.search(r"BattleCommand_EffectChance_Core:(.*?)(?=^[A-Za-z][A-Za-z0-9_]*::?$)", chance_source, re.MULTILINE | re.DOTALL)
    audit.check(chance_match is not None, "missing BattleCommand_EffectChance_Core")
    if chance_match:
        before_random = chance_match.group(1).split("call BattleRandom", 1)[0]
        guaranteed = re.search(r"cp\s+\$ff\s+ret z", before_random) or re.search(r"inc a\s+ret z", before_random)
        audit.check(bool(guaranteed), "100% secondary effects still have a 1/256 failure chance")


def audit_move_mechanics(audit: Audit) -> None:
    abilities = read("engine/battle/abilities_engine.asm")
    ability_blocks = global_blocks(abilities)

    sketch = read("engine/battle/move_effects/sketch.asm")
    transformed_check = sketch.split("; Get the user's moveset", 1)[0]
    audit.check(
        "ld a, BATTLE_VARS_SUBSTATUS5" in transformed_check
        and "ld a, BATTLE_VARS_SUBSTATUS5_OPP" not in transformed_check,
        "Sketch must test the user's transformed state before writing permanent party moves",
    )

    required_classes = {
        "PunchMoves": {"PIXIE_PUNCH"},
        "SliceMoves": {"BITTER_BLADE", "SOLAR_BLADE", "AERIAL_ACE"},
        "WindMoves": {"BLIZZARD", "AEROBLAST", "ICY_WIND", "FAIRY_WIND"},
        "TriageMoves": {"BITTER_BLADE", "ROOST"},
    }
    for label, required in required_classes.items():
        block = ability_blocks.get(label, [])
        entries = {
            match.group(1)
            for raw in block
            if (match := re.fullmatch(r"\s*dw\s+([A-Z][A-Z0-9_]*)\s*(?:;.*)?", raw))
        }
        audit.check(bool(block), f"missing ability move-class table {label}")
        for move in sorted(required):
            audit.check(move in entries, f"{label} is missing {move}")

    core = read("engine/battle/move_effects/new_move_cores.asm")
    audit.check(
        re.search(
            r"BattleConditionalBoost_Core:.*?cp EFFECT_KNOCK_OFF.*?farcall ItemIsMail.*?\.no_knock_off_item",
            core,
            re.DOTALL,
        )
        is not None,
        "Knock Off must not receive its item boost against unremovable mail",
    )
    audit.check(
        re.search(
            r"BattleGyroBall_Core:.*?ldh a, \[hMultiplicand \+ 2\]\s+inc a\s+jr z, \.max_power\s+cp 151",
            core,
            re.DOTALL,
        )
        is not None,
        "Gyro Ball must add 1 after division and cap its power at 150",
    )
    toxic_spikes = global_blocks(core).get("ToxicSpikesPoison")
    audit.check(toxic_spikes is not None, "missing ToxicSpikesPoison")
    if toxic_spikes:
        body = "\n".join(toxic_spikes)
        levitate = body.find("cp LEVITATE")
        absorption = body.find(".absorb")
        audit.check(
            0 <= levitate < absorption,
            "Toxic Spikes must check Levitate before Poison-type absorption",
        )

    # FarCall restores the caller's a register. Helpers whose result normally
    # lives in a therefore need a _b wrapper before being called cross-bank.
    unsafe_helpers = (
        "GetTrueUserAbility",
        "GetOpponentAbility",
        "GetOpponentIgnorableAbility",
        "GetPlayerAbilityEffective",
        "GetEnemyAbilityEffective",
        "GetAbilityFlags",
    )
    unsafe_pattern = re.compile(
        r"\b(?:farcall|callfar)\s+(?:" + "|".join(unsafe_helpers) + r")\b"
    )
    for path in sorted(ROOT.rglob("*.asm")):
        for line_number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if unsafe_pattern.search(raw.split(";", 1)[0]):
                audit.errors.append(
                    f"{path.relative_to(ROOT)}:{line_number}: unsafe FarCall to an a-return helper"
                )


def audit_animations(audit: Audit, moves: list[str]) -> None:
    text = read("data/moves/animations.asm")
    lines = text.splitlines()
    start = next(index for index, line in enumerate(lines) if line.strip() == "BattleAnimations::")
    end = next(index for index, line in enumerate(lines[start + 1 :], start + 1) if re.fullmatch(r"BattleAnim_[A-Za-z0-9_]+:", line))
    targets = [
        match.group(1)
        for raw in lines[start + 1 : end]
        if (match := re.match(r"\s*banim\s+([A-Za-z][A-Za-z0-9_]*)", raw))
    ]
    audit.check(len(targets) == len(moves) + 4, f"battle animation pointers: got {len(targets)}, expected {len(moves) + 4}")
    labels = set(re.findall(r"^(BattleAnim_[A-Za-z0-9_]+):", text + "\n" + read("data/moves/animations2.asm"), re.MULTILINE))
    for target in targets:
        audit.check(target in labels, f"battle animation pointer has no script: {target}")


def audit_tmhm(audit: Audit, move_ids: dict[str, int]) -> None:
    table = read("data/moves/tmhm_moves.asm")
    entries = [
        match.group(1)
        for raw in table.splitlines()
        if (match := re.fullmatch(r"\s*dw\s+([A-Z][A-Z0-9_]*|0)\s*(?:;.*)?", raw))
    ]
    audit.check(len(entries) == 61, f"TM/HM/tutor table has {len(entries)} entries, expected 50+7+3+terminator")
    audit.check(bool(entries) and entries[-1] == "0", "TM/HM/tutor table must end in dw 0")
    legal = set(entries[:-1])
    for move in legal:
        audit.check(move in move_ids, f"TM/HM/tutor table references unknown move {move}")
    for path in sorted((ROOT / "data/pokemon/base_stats").glob("*.asm")):
        for line_number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            match = re.match(r"\s*tmhm\s+(.+?)(?:\s*;.*)?$", raw)
            if not match:
                continue
            for move in (token.strip() for token in match.group(1).split(",")):
                audit.check(move in legal, f"{path.relative_to(ROOT)}:{line_number}: tmhm references non-TM/HM/tutor move {move}")


def audit_egg_moves(audit: Audit, move_ids: dict[str, int]) -> None:
    species_order, species_ids = parse_constants("constants/pokemon_constants.asm", "NUM_POKEMON")
    num_species = max(species_ids.values())
    kanto = read("data/pokemon/egg_moves_kanto.asm")
    johto = read("data/pokemon/egg_moves_johto.asm")
    first = expand_pointers(pointer_section(kanto, "EggMovePointers1::", "BulbasaurEggMoves:"), species_ids)
    second = expand_pointers(pointer_section(johto, "EggMovePointers2::", "ChikoritaEggMoves:"), species_ids)
    audit.count("egg pointers", len(first) + len(second))
    audit.check(len(first) == 151, f"EggMovePointers1 has {len(first)} expanded entries, expected 151")
    audit.check(len(second) == num_species - 151, f"EggMovePointers2 has {len(second)} expanded entries, expected {num_species - 151}")

    pointers = first + second
    for species_id, pointer in enumerate(pointers, 1):
        if pointer.startswith("NoEggMoves"):
            continue
        species = species_order[species_id] if species_id < len(species_order) else f"species{species_id}"
        pointer_species = re.sub(r"EggMoves\d?$", "", pointer)
        audit.check(
            normalize(pointer_species) == normalize(species),
            f"egg pointer species {species_id} {species}: points to {pointer}",
        )

    for relative, text in (("data/pokemon/egg_moves_kanto.asm", kanto), ("data/pokemon/egg_moves_johto.asm", johto)):
        all_blocks = global_blocks(text)
        blocks = {
            name: lines
            for name, lines in all_blocks.items()
            if re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*EggMoves\d?", name)
        }
        global_names = re.findall(r"^([A-Za-z][A-Za-z0-9_]*):", text, re.MULTILINE)
        for label, lines in blocks.items():
            entries: list[str] = []
            terminated = False
            for raw in lines:
                code = raw.split(";", 1)[0].strip()
                if code == "dw -1":
                    terminated = True
                    break
                match = re.fullmatch(r"dw\s+([A-Z][A-Z0-9_]*)", code)
                if match:
                    entries.append(match.group(1))
            # Dratini/Larvitar intentionally fall through into the shared
            # NoEggMoves label, whose first word is their terminator too.
            position = global_names.index(label)
            next_label = global_names[position + 1] if position + 1 < len(global_names) else ""
            shared_terminator = next_label.startswith("NoEggMoves") and any(
                raw.split(";", 1)[0].strip() == "dw -1" for raw in all_blocks.get(next_label, [])[:2]
            )
            audit.check(terminated or shared_terminator, f"{relative}:{label}: missing dw -1 terminator")
            for move in entries:
                audit.check(move in move_ids, f"{relative}:{label}: unknown egg move {move}")
            audit.check(len(entries) == len(set(entries)), f"{relative}:{label}: duplicate egg move")


def audit_learnsets(audit: Audit, move_ids: dict[str, int]) -> None:
    species_order, species_ids = parse_constants("constants/pokemon_constants.asm", "NUM_POKEMON")
    kanto = read("data/pokemon/evos_attacks_kanto.asm")
    johto = read("data/pokemon/evos_attacks_johto.asm")

    def pointer_block(text: str, label: str) -> list[str]:
        return [
            match.group(1)
            for raw in global_blocks(text).get(label, [])
            if (match := re.fullmatch(r"\s*dw\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?", raw))
        ]

    first = (
        pointer_block(kanto, "EvosAttacksPointers1")
        + pointer_block(kanto, "EvosAttacksPointers1C")
        + pointer_block(kanto, "EvosAttacksPointers1B")
    )
    second = (
        pointer_block(johto, "EvosAttacksPointers2")
        + pointer_block(johto, "EvosAttacksPointers2B")
    )
    pointers = first + second
    audit.check(len(first) == 151, f"Kanto evolution pointers: got {len(first)}, expected 151")
    audit.check(
        len(second) == max(species_ids.values()) - 151,
        f"later evolution pointers: got {len(second)}, expected {max(species_ids.values()) - 151}",
    )
    for species_id, pointer in enumerate(pointers, 1):
        species = species_order[species_id]
        pointer_species = re.sub(r"EvosAttacks$", "", pointer)
        audit.check(
            normalize(pointer_species) == normalize(species),
            f"evolution pointer species {species_id} {species}: points to {pointer}",
        )

    total_blocks = 0
    for relative in (
        "data/pokemon/evos_attacks_kanto.asm",
        "data/pokemon/evos_attacks_johto.asm",
        "data/pokemon/evos_attacks_clones.asm",
    ):
        text = read(relative)
        blocks = global_blocks(text, "EvosAttacks")
        total_blocks += len(blocks)
        for label, lines in blocks.items():
            zero_indices = [index for index, raw in enumerate(lines) if re.match(r"\s*db\s+0(?:\s*;.*)?$", raw)]
            audit.check(len(zero_indices) == 2, f"{relative}:{label}: expected evolution and learnset terminators, got {len(zero_indices)}")
            if not zero_indices:
                continue
            evolution_end = zero_indices[0]
            for raw in lines[:evolution_end]:
                code = raw.split(";", 1)[0].strip()
                if "EVOLVE_" not in code:
                    continue
                target = code.rsplit(",", 1)[-1].strip()
                audit.check(target in species_ids, f"{relative}:{label}: unknown evolution target {target}")

            learnset: list[tuple[int, str]] = []
            for raw in lines[evolution_end + 1 :]:
                match = re.match(r"\s*dbw\s+(\d+)\s*,\s*([A-Z][A-Z0-9_]*)", raw)
                if match:
                    learnset.append((int(match.group(1)), match.group(2)))
            for level, move in learnset:
                audit.check(1 <= level <= 100, f"{relative}:{label}: invalid level {level} for {move}")
                audit.check(move in move_ids, f"{relative}:{label}: unknown learnset move {move}")
            levels = [level for level, _ in learnset]
            audit.check(levels == sorted(levels), f"{relative}:{label}: learnset levels are not sorted")
            audit.check(len(learnset) == len(set(learnset)), f"{relative}:{label}: duplicate level/move row")
    audit.count("evolution/learnset blocks", total_blocks)


def audit_move_availability(audit: Audit, moves: list[str]) -> None:
    """Every usable move must be obtainable through level, egg, or machine data."""
    available: set[str] = set()
    for relative in (
        "data/pokemon/evos_attacks_kanto.asm",
        "data/pokemon/evos_attacks_johto.asm",
        "data/pokemon/evos_attacks_clones.asm",
    ):
        available.update(
            re.findall(r"^\s*dbw\s+\d+\s*,\s*([A-Z][A-Z0-9_]*)", read(relative), re.MULTILINE)
        )
    for relative in (
        "data/pokemon/egg_moves_kanto.asm",
        "data/pokemon/egg_moves_johto.asm",
        "data/moves/tmhm_moves.asm",
    ):
        available.update(
            re.findall(r"^\s*dw\s+([A-Z][A-Z0-9_]*)", read(relative), re.MULTILINE)
        )

    intentionally_unlearnable = {"STRUGGLE"}
    missing = sorted(set(moves) - available - intentionally_unlearnable)
    audit.check(not missing, "moves with no player learnset: " + ", ".join(missing))
    audit.count("player-available moves", len(set(moves) & available))


def main() -> int:
    audit = Audit()
    moves, move_ids, scripts = audit_move_tables(audit)
    audit_contact(audit, move_ids)
    audit_effects(audit, moves, scripts)
    audit_move_mechanics(audit)
    audit_animations(audit, moves)
    audit_tmhm(audit, move_ids)
    audit_egg_moves(audit, move_ids)
    audit_learnsets(audit, move_ids)
    audit_move_availability(audit, moves)

    if audit.errors:
        print(f"move audit failed with {len(audit.errors)} error(s):", file=sys.stderr)
        for error in audit.errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    details = ", ".join(f"{name}={value}" for name, value in audit.counts.items())
    print(f"move audit passed ({details})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

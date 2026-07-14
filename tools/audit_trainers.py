#!/usr/bin/env python3
"""Validate trainer rosters, references, class tables, and Battle Tower data."""

import math
import re
import sys
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
ERRORS = []

TRAINER_TYPES = {
	"TRAINERTYPE_NORMAL": (False, False),
	"TRAINERTYPE_MOVES": (False, True),
	"TRAINERTYPE_ITEM": (True, False),
	"TRAINERTYPE_ITEM_MOVES": (True, True),
}

JOHTO_LEADER_REMATCH_GROUPS = {
	"FalknerGroup",
	"WhitneyGroup",
	"BugsyGroup",
	"MortyGroup",
	"PryceGroup",
	"JasmineGroup",
	"ChuckGroup",
	"ClairGroup",
}


def fail(path, line, message):
	location = str(path.relative_to(ROOT))
	if line:
		location += f":{line}"
	ERRORS.append(f"{location}: {message}")


def source_lines(path):
	return path.read_text(encoding="utf-8", errors="replace").splitlines()


def without_comment(line):
	return line.split(";", 1)[0].strip()


def key(value):
	return re.sub(r"[^A-Z0-9]", "", value.upper())


def encoded_text_length(value):
	return len(re.sub(r"<[^>]+>", "x", value))


def args(value):
	return [part.strip() for part in value.split(",")]


def decimal(value):
	return int(value, 16) if value.startswith("$") else int(value)


def constant_list(relative_path, stop_symbol=None):
	result = []
	path = ROOT / relative_path
	for line in source_lines(path):
		if stop_symbol and re.match(rf"\s*{stop_symbol}\b", line):
			break
		match = re.match(r"\s*const\s+(\w+)", without_comment(line))
		if match:
			result.append(match.group(1))
	return result


def numeric_constant(relative_path, name):
	path = ROOT / relative_path
	for line in source_lines(path):
		match = re.match(rf"\s*{name}\s+EQU\s+(\d+)", without_comment(line))
		if match:
			return int(match.group(1))
	raise ValueError(f"could not find {name} in {relative_path}")


def parse_trainer_constants():
	path = ROOT / "constants/trainer_constants.asm"
	classes = []
	trainer_ids = {}
	raw_aliases = []
	current_class = None
	for line_number, line in enumerate(source_lines(path), 1):
		code = without_comment(line)
		match = re.match(r"trainerclass\s+(\w+)", code)
		if match:
			current_class = match.group(1)
			classes.append(current_class)
			trainer_ids[current_class] = []
			continue
		match = re.match(r"const\s+(\w+)", code)
		if match and current_class:
			trainer_ids[current_class].append(match.group(1))
			continue
		match = re.fullmatch(r"(\w+)\s+EQU\s+(\w+)", code)
		if match and current_class:
			raw_aliases.append((match.group(1), current_class, match.group(2), line_number))

	owners = {}
	for trainer_class, ids in trainer_ids.items():
		for trainer_id in ids:
			if trainer_id in owners:
				fail(path, 0, f"trainer ID {trainer_id} is declared more than once")
			owners[trainer_id] = trainer_class
	aliases = defaultdict(dict)
	for alias, trainer_class, target, line_number in raw_aliases:
		if target not in owners:
			continue
		aliases[trainer_class][alias] = target
		if alias in owners:
			fail(path, line_number, f"trainer alias {alias} collides with a trainer ID")
		owners[alias] = trainer_class

	if not classes or classes[0] != "TRAINER_NONE":
		fail(path, 0, "trainer class zero must be TRAINER_NONE")
	return classes, trainer_ids, aliases, owners


def parse_parties(species, moves, items):
	path = ROOT / "data/trainers/parties.asm"
	groups = {}
	current_group = None
	current_entry = None
	for line_number, line in enumerate(source_lines(path), 1):
		code = without_comment(line)
		match = re.fullmatch(r"(\w+Group):", code)
		if match:
			current_group = match.group(1)
			groups.setdefault(current_group, [])
			current_entry = None
			continue
		if code.startswith("next_list_item"):
			if current_group is None:
				fail(path, line_number, "trainer entry is outside a group")
				continue
			comment = line.split(";", 1)[1].strip() if ";" in line else ""
			declared = re.fullmatch(r"(\w+)\s+\((\d+)\)", comment)
			current_entry = {
				"group": current_group,
				"line": line_number,
				"declared_class": declared.group(1) if declared else None,
				"declared_number": int(declared.group(2)) if declared else None,
				"directives": [],
			}
			groups[current_group].append(current_entry)
			continue
		if code.startswith("end_list_items"):
			current_group = None
			current_entry = None
			continue
		if current_entry:
			match = re.match(r"(db|dw)\s+(.+)", code)
			if match:
				current_entry["directives"].append(
					(match.group(1), match.group(2).strip(), line_number)
				)

	for group_name, entries in groups.items():
		for number, entry in enumerate(entries, 1):
			if entry["declared_number"] != number:
				fail(path, entry["line"], f"{group_name} entry comment should be ({number})")
			parse_party_entry(path, entry, species, moves, items)
	return groups


def parse_party_entry(path, entry, species, moves, items):
	directives = entry["directives"]
	if not directives:
		fail(path, entry["line"], "empty trainer entry")
		return
	header_kind, header, header_line = directives[0]
	header_match = re.fullmatch(r'"(.*)",\s*(TRAINERTYPE_\w+)', header)
	if header_kind != "db" or not header_match:
		fail(path, header_line, "malformed trainer name/type header")
		return
	name, trainer_type = header_match.groups()
	if not name.endswith("@") or len(name[:-1]) > 10:
		fail(path, header_line, f"invalid trainer name {name!r}")
	if trainer_type not in TRAINER_TYPES:
		fail(path, header_line, f"unknown trainer type {trainer_type}")
		return
	has_item, has_moves = TRAINER_TYPES[trainer_type]
	index = 1
	mons = []
	terminated = False
	while index < len(directives):
		kind, value, line_number = directives[index]
		if kind == "db" and value in {"-1", "$ff"}:
			terminated = True
			index += 1
			break
		if kind != "db" or not re.fullmatch(r"\d+", value):
			fail(path, line_number, f"expected a decimal level, got {kind} {value}")
			break
		level = int(value)
		if not 1 <= level <= 100:
			fail(path, line_number, f"level {level} is outside 1..100")
		index += 1
		if index >= len(directives):
			fail(path, line_number, "party is truncated after its level")
			break
		kind, mon, mon_line = directives[index]
		if kind != "dw" or "," in mon:
			fail(path, mon_line, f"expected one 16-bit species, got {kind} {mon}")
			break
		if mon not in species:
			fail(path, mon_line, f"unknown species {mon}")
		index += 1
		item = "NO_ITEM"
		if has_item:
			if index >= len(directives):
				fail(path, line_number, "party is truncated before its held item")
				break
			kind, item, item_line = directives[index]
			if kind != "db" or "," in item or item not in items:
				fail(path, item_line, f"invalid held item {kind} {item}")
			index += 1
		party_moves = []
		if has_moves:
			if index >= len(directives):
				fail(path, line_number, "party is truncated before its custom moves")
				break
			kind, value, move_line = directives[index]
			party_moves = args(value)
			if kind != "dw" or len(party_moves) != 4:
				fail(path, move_line, "custom movesets must contain four 16-bit moves")
			else:
				seen_empty = False
				known_moves = []
				for move in party_moves:
					if move not in moves:
						fail(path, move_line, f"unknown move {move}")
					if move == "NO_MOVE":
						seen_empty = True
					elif seen_empty:
						fail(path, move_line, f"{move} follows NO_MOVE and would have zero PP")
					else:
						known_moves.append(move)
				if len(known_moves) != len(set(known_moves)):
					fail(path, move_line, "moveset contains a duplicate move")
			index += 1
		mons.append({"level": level, "species": mon, "item": item, "moves": party_moves})
	if not terminated:
		fail(path, entry["line"], "trainer party has no $ff terminator")
	if index != len(directives):
		fail(path, directives[index][2], "data follows the party terminator")
	if not 1 <= len(mons) <= 6:
		fail(path, entry["line"], f"party contains {len(mons)} Pokémon; expected 1..6")
	record_bytes = 1 + len(name) + 1 + 1
	for _mon in mons:
		record_bytes += 1 + 2 + int(has_item) + (8 if has_moves else 0)
	if record_bytes > 0xFF:
		fail(path, entry["line"], f"length-prefixed trainer record is {record_bytes} bytes")
	entry.update(name=name, trainer_type=trainer_type, mons=mons, record_bytes=record_bytes)


def validate_group_pointers(classes, trainer_ids, aliases, owners, groups):
	path = ROOT / "data/trainers/party_pointers.asm"
	pointers = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"\s*dba\s+(\w+)", without_comment(line))
		if match:
			pointers.append((match.group(1), line_number))
	actual_classes = classes[1:]
	if len(pointers) != len(actual_classes):
		fail(path, 0, f"found {len(pointers)} group pointers for {len(actual_classes)} classes")
	class_pointer = {}
	for trainer_class, (group_name, line_number) in zip(actual_classes, pointers):
		class_pointer[trainer_class] = group_name
		if group_name not in groups:
			fail(path, line_number, f"{trainer_class} points to missing {group_name}")
			continue
		entries = groups[group_name]
		if trainer_ids[trainer_class] and len(entries) != len(trainer_ids[trainer_class]):
			fail(
				path,
				line_number,
				f"{trainer_class} declares {len(trainer_ids[trainer_class])} IDs but {group_name} has {len(entries)} entries",
			)
		if not trainer_ids[trainer_class] and not aliases[trainer_class] and entries:
			fail(path, line_number, f"{trainer_class} has party data but no trainer IDs")
		if entries and not aliases[trainer_class]:
			declared = entries[0]["declared_class"]
			if declared != trainer_class:
				fail(path, line_number, f"{trainer_class} points to a group declared for {declared}")

	for trainer_class, class_aliases in aliases.items():
		if not class_aliases:
			continue
		if trainer_class not in class_pointer:
			continue
		target_classes = {owners[target] for target in class_aliases.values()}
		if len(target_classes) != 1:
			fail(path, 0, f"{trainer_class} aliases IDs from multiple classes")
			continue
		target_class = target_classes.pop()
		if class_pointer.get(trainer_class) != class_pointer.get(target_class):
			fail(path, 0, f"{trainer_class} aliases {target_class} IDs but not its party group")

	pointed = {group_name for group_name, _line in pointers}
	for group_name, entries in groups.items():
		if entries and group_name not in pointed:
			fail(path, 0, f"populated {group_name} is not in TrainerGroups")


def validate_rematch_tiers(groups):
	path = ROOT / "data/trainers/parties.asm"
	for group_name in JOHTO_LEADER_REMATCH_GROUPS:
		entries = groups.get(group_name, [])
		if len(entries) < 2:
			fail(path, 0, f"{group_name} has no rematch party")
			continue
		levels = [mon["level"] for mon in entries[1].get("mons", [])]
		if len(levels) != 5 or min(levels, default=0) < 53 or max(levels, default=0) != 55:
			fail(path, entries[1]["line"], f"endgame leader rematch tier is {levels}, expected five levels in 53..55")


def validate_script_references(classes, owners):
	actual_classes = set(classes[1:])
	reference_count = 0
	patterns = (
		re.compile(r"(?:trainer|generictrainer|loadtrainer|phone)\s+(\w+)\s*,\s*(\w+)"),
		re.compile(r"gettrainername\s+[^,]+,\s*(\w+)\s*,\s*(\w+)"),
		re.compile(r"db\s+(\w+)\s*,\s*(\w+)"),
	)
	for folder in (ROOT / "maps", ROOT / "engine", ROOT / "data"):
		for path in folder.rglob("*.asm"):
			for line_number, line in enumerate(source_lines(path), 1):
				code = without_comment(line)
				for pattern in patterns:
					match = pattern.match(code)
					if not match or match.group(1) not in actual_classes:
						continue
					trainer_class, trainer_id = match.groups()
					reference_count += 1
					owner = owners.get(trainer_id)
					if owner is None:
						fail(path, line_number, f"unknown {trainer_class} trainer ID {trainer_id}")
					elif owner != trainer_class:
						fail(path, line_number, f"{trainer_id} belongs to {owner}, not {trainer_class}")
					break
				match = re.match(r"gettrainerclassname\s+[^,]+,\s*(\w+)", code)
				if match and match.group(1) not in actual_classes:
					fail(path, line_number, f"unknown trainer class {match.group(1)}")
	return reference_count


def validate_parallel_tables(classes, items):
	actual = classes[1:]

	path = ROOT / "data/trainers/dvs.asm"
	dv_rows = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"\s*dn\s+([^;]+);\s*(\w+)", line)
		if match:
			dv_rows.append((args(match.group(1)), match.group(2), line_number))
	if len(dv_rows) != len(actual):
		fail(path, 0, f"found {len(dv_rows)} DV rows for {len(actual)} classes")
	for trainer_class, (values, comment, line_number) in zip(actual, dv_rows):
		if key(comment) != key(trainer_class):
			fail(path, line_number, f"DV row says {comment}; expected {trainer_class}")
		if len(values) != 4 or any(not 0 <= decimal(value) <= 15 for value in values):
			fail(path, line_number, f"invalid trainer DVs {values}")

	path = ROOT / "data/trainers/genders.asm"
	gender_rows = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"\s*db\s+(MALE|FEMALE)\s*;\s*(\w+)", line)
		if match:
			gender_rows.append((match.group(1), match.group(2), line_number))
	if len(gender_rows) != len(actual):
		fail(path, 0, f"found {len(gender_rows)} gender rows for {len(actual)} classes")
	for trainer_class, (_gender, comment, line_number) in zip(actual, gender_rows):
		if key(comment) != key(trainer_class):
			fail(path, line_number, f"gender row says {comment}; expected {trainer_class}")

	path = ROOT / "data/trainers/encounter_music.asm"
	music_rows = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"\s*db\s+MUSIC_\w+\s*;\s*(\w+)", line)
		if match:
			music_rows.append((match.group(1), line_number))
	if len(music_rows) != len(classes):
		fail(path, 0, f"found {len(music_rows)} music rows for {len(classes)} class indexes")
	for index, (comment, line_number) in enumerate(music_rows):
		expected = "NONE" if index == 0 else classes[index]
		if key(comment) != key(expected):
			fail(path, line_number, f"music row says {comment}; expected {expected}")

	path = ROOT / "data/trainers/class_names.asm"
	class_names = [
		(line_number, match.group(1))
		for line_number, line in enumerate(source_lines(path), 1)
		if (match := re.match(r'\s*db\s+"([^"]*)"', line))
	]
	if len(class_names) != len(actual):
		fail(path, 0, f"found {len(class_names)} names for {len(actual)} classes")
	for line_number, name in class_names:
		if not name.endswith("@") or encoded_text_length(name) > 13:
			fail(path, line_number, f"invalid trainer class name {name!r}")

	path = ROOT / "data/trainers/pic_pointers.asm"
	pics = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"\s*dba\s+(\w+)Pic", without_comment(line))
		if match:
			pics.append((match.group(1), line_number))
	if len(pics) != len(actual):
		fail(path, 0, f"found {len(pics)} pic pointers for {len(actual)} classes")
	for trainer_class, (pic, line_number) in zip(actual, pics):
		if key(pic) != key(trainer_class):
			fail(path, line_number, f"{pic}Pic is in {trainer_class}'s slot")

	path = ROOT / "data/trainers/sprites.asm"
	sprite_count = sum(bool(re.match(r"\s*db\s+SPRITE_", line)) for line in source_lines(path))
	if sprite_count != len(actual):
		fail(path, 0, f"found {sprite_count} sprites for {len(actual)} classes")

	path = ROOT / "data/trainers/palettes.asm"
	palettes = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r'INCBIN "gfx/trainers/([^/.]+)\.gbcpal"', line)
		if match:
			palettes.append((match.group(1), line_number))
	if len(palettes) != len(classes):
		fail(path, 0, f"found {len(palettes)} palettes for {len(classes)} class indexes")
	palette_aliases = {"TRAINER_NONE": "CAL", "POKEMON_PROF": "OAK"}
	for trainer_class, (palette, line_number) in zip(classes, palettes):
		expected = palette_aliases.get(trainer_class, trainer_class)
		if key(palette) != key(expected):
			fail(path, line_number, f"{palette} palette is in {trainer_class}'s slot")

	validate_attributes(classes, items)
	validate_personality_bit()


def validate_attributes(classes, items):
	path = ROOT / "data/trainers/attributes.asm"
	lines = source_lines(path)
	records = []
	for index, line in enumerate(lines):
		if not re.match(r"\s*db\s+[^;]+;\s*items\s*$", line):
			continue
		heading = None
		for previous in range(index - 1, -1, -1):
			if not lines[previous].strip():
				continue
			if lines[previous].lstrip().startswith(";"):
				heading = lines[previous].lstrip()[1:].strip()
			break
		code_rows = []
		for next_line in range(index, len(lines)):
			code = without_comment(lines[next_line])
			if code:
				code_rows.append((code, next_line + 1))
			if len(code_rows) == 4:
				break
		records.append((heading, code_rows, index + 1))
	actual = classes[1:]
	if len(records) != len(actual):
		fail(path, 0, f"found {len(records)} attribute records for {len(actual)} classes")
	for trainer_class, (heading, rows, line_number) in zip(actual, records):
		if key(heading or "") != key(trainer_class):
			fail(path, line_number, f"attribute record says {heading}; expected {trainer_class}")
		if len(rows) != 4:
			fail(path, line_number, "truncated seven-byte attribute record")
			continue
		item_match = re.fullmatch(r"db\s+(\w+)\s*,\s*(\w+)", rows[0][0])
		if not item_match or any(item not in items for item in item_match.groups()):
			fail(path, rows[0][1], f"invalid trainer-use items in {rows[0][0]}")
		if not re.fullmatch(r"db\s+\d+", rows[1][0]):
			fail(path, rows[1][1], "invalid base-money byte")
		if not rows[2][0].startswith("dw ") or not rows[3][0].startswith("dw "):
			fail(path, line_number, "attribute AI fields must be words")


def validate_personality_bit():
	path = ROOT / "engine/pokemon/move_mon.asm"
	matches = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.search(r"\bbit\s+(\d),\s*\[hl\].*Attack DV low bit", line)
		if match:
			matches.append((int(match.group(1)), line_number))
	if len(matches) != 1:
		fail(path, 0, f"found {len(matches)} trainer ability-slot DV tests; expected one")
	elif matches[0][0] != 4:
		fail(path, matches[0][1], "packed Attack DV low bit is bit 4, not bit 0")


def parse_move_pp(move_constants):
	path = ROOT / "data/moves/moves.asm"
	rows = []
	for line_number, line in enumerate(source_lines(path), 1):
		code = without_comment(line)
		if not code.startswith("move "):
			continue
		values = args(code[len("move "):])
		if len(values) != 7:
			fail(path, line_number, f"malformed move row {code}")
			continue
		rows.append((decimal(values[5]), line_number))
	if len(rows) != len(move_constants) - 1:
		fail(path, 0, f"found {len(rows)} move rows for {len(move_constants) - 1} real moves")
	result = {"NO_MOVE": 0, "0": 0}
	for move, (pp, _line_number) in zip(move_constants[1:], rows):
		result[move] = pp
	return result


def parse_base_stats(species):
	index_path = ROOT / "data/pokemon/base_stats.asm"
	includes = []
	for line in source_lines(index_path):
		match = re.match(r'INCLUDE "(data/pokemon/base_stats/[^"]+)"', line)
		if match:
			includes.append(match.group(1))
	if len(includes) != len(species):
		fail(index_path, 0, f"found {len(includes)} base-data includes for {len(species)} species")
	result = {}
	for mon, relative_path in zip(species, includes):
		path = ROOT / relative_path
		stats = None
		for line_number, line in enumerate(source_lines(path), 1):
			match = re.fullmatch(
				r"\s*db\s+" + r"\s*,\s*".join([r"(\d+)"] * 6) + r"\s*(?:;.*)?",
				line,
			)
			if match:
				stats = list(map(int, match.groups()))
				break
		if stats is None:
			fail(path, 0, f"could not parse {mon}'s six base stats")
		else:
			result[mon] = stats
	return result


def directive_size(kind, value):
	values = args(value)
	if kind == "db":
		match = re.fullmatch(r'"(.*)"', value)
		return len(match.group(1)) if match else len(values)
	if kind in {"dw", "bigdw"}:
		return 2 * len(values)
	if kind == "dt":
		return 3 * len(values)
	if kind == "dn":
		return (len(values) + 1) // 2
	raise ValueError(kind)


def validate_battle_tower(species, moves, items):
	path = ROOT / "data/battle_tower/parties.asm"
	base_stats = parse_base_stats(species)
	move_pp = parse_move_pp(list(moves))
	entries = []
	group = None
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"BattleTowerMons(\d+):", line)
		if match:
			group = int(match.group(1))
			continue
		match = re.fullmatch(r"\s*dw\s+([A-Z][A-Z0-9_]*)\s*(?:;.*)?", line)
		if match and match.group(1) in base_stats:
			entries.append({"group": group, "line": line_number, "directives": []})
		if entries:
			code = without_comment(line)
			directive = re.match(r"(db|dw|dt|bigdw|dn)\s+(.+)", code)
			if directive:
				entries[-1]["directives"].append(
					(directive.group(1), directive.group(2).strip(), line_number)
				)

	expected_per_group = numeric_constant(
		"constants/battle_tower_constants.asm", "BATTLETOWER_NUM_UNIQUE_MON"
	)
	by_group = defaultdict(list)
	for entry in entries:
		by_group[entry["group"]].append(entry)
	if sorted(by_group) != list(range(1, 11)):
		fail(path, 0, f"Battle Tower level groups are {sorted(by_group)}, expected 1..10")
	for group_number, group_entries in by_group.items():
		if len(group_entries) != expected_per_group:
			fail(path, 0, f"group {group_number} has {len(group_entries)} mons; expected {expected_per_group}")
	for entry in entries:
		validate_battle_tower_mon(path, entry, base_stats, move_pp, items)

	validate_battle_tower_trainers()
	return len(entries)


def validate_battle_tower_mon(path, entry, base_stats, move_pp, items):
	directives = entry["directives"]
	expected_kinds = (
		["dw", "db", "dw", "dw", "dt"]
		+ ["bigdw"] * 5
		+ ["dn", "db", "db", "db", "db", "db", "db"]
		+ ["bigdw"] * 7
		+ ["db"]
	)
	if [kind for kind, _value, _line in directives] != expected_kinds:
		fail(path, entry["line"], "Battle Tower mon fields do not match the party-struct layout")
		return
	record_size = sum(directive_size(kind, value) for kind, value, _line in directives)
	if record_size != 65:
		fail(path, entry["line"], f"Battle Tower source record is {record_size} bytes; expected 65")

	mon = directives[0][1]
	item = directives[1][1]
	party_moves = args(directives[2][1])
	if item not in items:
		fail(path, directives[1][2], f"unknown Battle Tower item {item}")
	if len(party_moves) != 4 or any(move not in move_pp for move in party_moves):
		fail(path, directives[2][2], f"invalid Battle Tower moveset {party_moves}")
		return
	seen_empty = False
	for move in party_moves:
		if move in {"0", "NO_MOVE"}:
			seen_empty = True
		elif seen_empty:
			fail(path, directives[2][2], f"{move} follows an empty Battle Tower move slot")
	if directives[3][1] != "0":
		fail(path, directives[3][2], "Battle Tower OT ID must be zero")
	stat_exp = [decimal(directives[index][1]) for index in range(5, 10)]
	dvs = [decimal(value) for value in args(directives[10][1])]
	pp = [decimal(value) for value in args(directives[11][1])]
	happiness = decimal(directives[12][1])
	caught_data = args(directives[13][1])
	level = decimal(directives[14][1])
	personality = directives[15][1]
	status = args(directives[16][1])
	stored_stats = [decimal(directives[index][1]) for index in range(17, 24)]
	nickname_match = re.fullmatch(r'"(.*)"', directives[24][1])

	if len(dvs) != 4 or any(not 0 <= value <= 15 for value in dvs):
		fail(path, directives[10][2], f"invalid Battle Tower DVs {dvs}")
		return
	if pp != [move_pp[move] for move in party_moves]:
		fail(path, directives[11][2], f"stored PP {pp} does not match {party_moves}")
	if not 0 <= happiness <= 255:
		fail(path, directives[12][2], f"invalid happiness {happiness}")
	if caught_data != ["0", "0", "0"]:
		fail(path, directives[13][2], f"invalid Pokerus/caught bytes {caught_data}")
	if level != entry["group"] * 10:
		fail(path, directives[14][2], f"level {level} is in Battle Tower group {entry['group']}")
	if decimal(directives[4][1]) != level ** 3:
		fail(path, directives[4][2], "Battle Tower experience must equal its level-cube convention")
	expected_personality = "ABILITY_2" if dvs[0] & 1 else "ABILITY_1"
	if personality != expected_personality:
		fail(path, directives[15][2], f"personality {personality} disagrees with Attack DV {dvs[0]}")
	if status != ["0", "0"]:
		fail(path, directives[16][2], f"invalid Battle Tower status bytes {status}")
	if not nickname_match or len(nickname_match.group(1)) != 11:
		fail(path, directives[24][2], "Battle Tower nickname must be exactly 11 bytes")

	calculated = calculate_battle_tower_stats(
		base_stats[mon], stat_exp, dvs, level
	)
	if stored_stats != calculated:
		fail(path, directives[17][2], f"stored stats {stored_stats} should be {calculated} for {mon}")


def calculate_battle_tower_stats(base, stat_exp, dvs, level):
	"""Match CalcMonStatC's Gen II integer arithmetic exactly."""
	# GetSquareRoot returns the first integer whose square is at least the input,
	# capped at 255. CalcMonStatC then divides that result by four.
	effort = []
	for value in stat_exp:
		root = math.isqrt(value)
		if root * root < value:
			root += 1
		effort.append(min(root, 255) // 4)
	hp_dv = (
		((dvs[0] & 1) << 3)
		| ((dvs[1] & 1) << 2)
		| ((dvs[2] & 1) << 1)
		| (dvs[3] & 1)
	)
	hp = ((2 * (base[0] + hp_dv) + effort[0]) * level) // 100 + level + 10
	calculated = [hp, hp]
	for base_stat, dv, exp in zip(
		base[1:],
		[dvs[0], dvs[1], dvs[2], dvs[3], dvs[3]],
		[effort[1], effort[2], effort[3], effort[4], effort[4]],
	):
		calculated.append(((2 * (base_stat + dv) + exp) * level) // 100 + 5)
	return calculated


def validate_battle_tower_trainers():
	trainer_classes, _ids, _aliases, _owners = parse_trainer_constants()
	valid_classes = set(trainer_classes[1:])
	path = ROOT / "data/battle_tower/classes.asm"
	rows = []
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r'\s*db\s+"([^"]*)"\s*,\s*(\w+)', line)
		if match:
			rows.append((match.group(1), match.group(2), line_number))
	expected = numeric_constant(
		"constants/battle_tower_constants.asm", "BATTLETOWER_NUM_UNIQUE_TRAINERS"
	)
	if len(rows) != expected:
		fail(path, 0, f"found {len(rows)} Battle Tower trainers; expected {expected}")
	for name, trainer_class, line_number in rows:
		if len(name) != 10:
			fail(path, line_number, f"Battle Tower trainer name {name!r} is not ten bytes")
		if trainer_class not in valid_classes:
			fail(path, line_number, f"unknown Battle Tower class {trainer_class}")

	path = ROOT / "data/battle_tower/unknown.asm"
	records = defaultdict(list)
	current = None
	for line_number, line in enumerate(source_lines(path), 1):
		match = re.match(r"BattleTowerTrainer(\d+)DataTable:", line)
		if match:
			current = int(match.group(1))
			continue
		if current is not None:
			match = re.match(r"\s*db\s+([^;]+)", line)
			if match:
				records[current].append((args(match.group(1)), line_number))
	if sorted(records) != list(range(1, expected + 1)):
		fail(path, 0, "Battle Tower trainer-data labels are not contiguous")
	for number, rows in records.items():
		byte_count = sum(len(values) for values, _line in rows)
		if byte_count != 0x24:
			fail(path, rows[0][1], f"trainer-data record {number} is {byte_count} bytes; expected 36")


def main():
	species_list = constant_list("constants/pokemon_constants.asm", "NUM_POKEMON")
	species = set(species_list)
	move_list = constant_list("constants/move_constants.asm", "NUM_ATTACKS")
	moves = set(move_list)
	items = set(constant_list("constants/item_constants.asm", "NUM_ITEMS"))
	classes, trainer_ids, aliases, owners = parse_trainer_constants()
	groups = parse_parties(species, moves, items)
	validate_group_pointers(classes, trainer_ids, aliases, owners, groups)
	validate_rematch_tiers(groups)
	references = validate_script_references(classes, owners)
	validate_parallel_tables(classes, items)
	battle_tower_mons = validate_battle_tower(species_list, move_list, items)

	party_count = sum(len(entries) for entries in groups.values())
	print(
		f"Audited {party_count} trainer parties, {references} trainer references, "
		f"{len(classes) - 1} class-table rows, and {battle_tower_mons} Battle Tower mons."
	)
	if ERRORS:
		for error in ERRORS:
			print(f"ERROR: {error}")
		return 1
	print("Trainer audit passed.")
	return 0


if __name__ == "__main__":
	sys.exit(main())

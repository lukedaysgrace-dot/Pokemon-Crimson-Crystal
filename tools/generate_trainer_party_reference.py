#!/usr/bin/env python3
"""Generate a readable, source-linked reference for every fixed trainer party."""

from __future__ import annotations

from collections import OrderedDict, defaultdict
from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "TRAINER_PARTIES.md"

sys.path.insert(0, str(ROOT / "tools"))
import audit_trainers as audit  # noqa: E402


SPECIAL_NAMES = {
	"FARFETCH_D": "Farfetch'd",
	"HO_OH": "Ho-Oh",
	"JANGMO_O": "Jangmo-o",
	"HAKAMO_O": "Hakamo-o",
	"KOMMO_O": "Kommo-o",
	"MR__MIME": "Mr. Mime",
	"MR__RIME": "Mr. Rime",
	"NIDORAN_F": "Nidoran♀",
	"NIDORAN_M": "Nidoran♂",
	"PORYGON_Z": "Porygon-Z",
	"SIRFETCH_D": "Sirfetch'd",
	"TYPE_NULL": "Type: Null",
}

CLASS_NAMES = {
	"BLACKBELT_T": "Blackbelt",
	"COOLTRAINERM": "Cooltrainer M",
	"COOLTRAINERF": "Cooltrainer F",
	"EXECUTIVEM": "Team Rocket Executive M",
	"EXECUTIVEF": "Team Rocket Executive F",
	"GRUNTM": "Team Rocket Grunt M",
	"GRUNTF": "Team Rocket Grunt F",
	"MYSTICALMAN": "Mystical Man",
	"POKEMANIAC": "Pokémaniac",
	"POKEFANM": "Pokéfan M",
	"POKEFANF": "Pokéfan F",
	"PSYCHIC_T": "Psychic",
	"RIVAL1": "Rival — Main Story",
	"RIVAL2": "Rival — Postgame",
	"SWIMMERM": "Swimmer M",
	"SWIMMERF": "Swimmer F",
}

ABILITY_SLOT_INDEX = {
	"ABILITY_1": 0,
	"ABILITY_2": 1,
	"HIDDEN_ABILITY": 2,
}


def read(relative_path: str) -> str:
	return (ROOT / relative_path).read_text(encoding="utf-8", errors="replace")


def titlecase(value: str) -> str:
	return re.sub(
		r"(^|[\s\-])([a-z])",
		lambda match: match.group(1) + match.group(2).upper(),
		value.lower(),
	)


def display_constant(value: str) -> str:
	value = value.strip().strip(',"').replace("@", "")
	if value in SPECIAL_NAMES:
		return SPECIAL_NAMES[value]
	return titlecase(value.replace("_", " "))


def display_class(value: str) -> str:
	return CLASS_NAMES.get(value, display_constant(value))


def display_trainer_name(value: str) -> str:
	return titlecase(value).replace("Lt.surge", "Lt. Surge")


def display_location(value: str) -> str:
	replacements = {
		"Brunos Room": "Bruno's Room",
		"Dragons Den": "Dragon's Den",
		"Karens Room": "Karen's Room",
		"Kogas Room": "Koga's Room",
		"Lances Room": "Lance's Room",
		"Wills Room": "Will's Room",
		"Lake Of Rage": "Lake of Rage",
		"Ruins Of Alph": "Ruins of Alph",
		"Pokecenter": "Pokémon Center",
		"Route 10South": "Route 10 South",
		"Mount Mortar 1FInside": "Mount Mortar 1F Interior",
		"Mount Mortar 2FInside": "Mount Mortar 2F Interior",
		"Captains Cabin": "Captain's Cabin",
	}
	result = value.replace("_", " / ")
	for old, new in replacements.items():
		result = result.replace(old, new)
	if result == "not placed on any map":
		return "Not placed on any map"
	return result


def db_strings(relative_path: str) -> list[str]:
	return [
		match.replace("@", "")
		for match in re.findall(r'\bdb\s+"([^"]*)"', read(relative_path))
	]


def species_names(species: list[str]) -> dict[str, str]:
	raw = read("data/pokemon/names.asm")
	raw = raw.split("PokemonNames::", 1)[1] if "PokemonNames::" in raw else raw
	names = [value.replace("@", "") for value in re.findall(r'\bdb\s+"([^"]*)"', raw)]
	result = {}
	for index, constant in enumerate(species):
		if constant in SPECIAL_NAMES:
			result[constant] = SPECIAL_NAMES[constant]
		elif index < len(names):
			result[constant] = titlecase(names[index])
		else:
			result[constant] = display_constant(constant)
	return result


def move_names(moves: list[str]) -> dict[str, str]:
	names = db_strings("data/moves/names.asm")
	result = {"NO_MOVE": "—"}
	for constant, name in zip(moves[1:], names):
		result[constant] = titlecase(name)
	return result


def item_names(items: list[str]) -> dict[str, str]:
	# ItemNames has no row for NO_ITEM (ID 0).
	names = db_strings("data/items/names.asm")
	result = {"NO_ITEM": "—"}
	for constant, name in zip(items[1:], names):
		result[constant] = titlecase(name)
	return result


def ability_names(abilities: list[str]) -> dict[str, str]:
	names = db_strings("data/abilities/names.asm")
	return {
		constant: titlecase(names[index]) if index < len(names) else display_constant(constant)
		for index, constant in enumerate(abilities)
	}


def ability_slots() -> dict[str, list[str]]:
	result = {}
	for path in (ROOT / "data/pokemon/base_stats").glob("*.asm"):
		match = re.search(
			r"\babilities_for\s+([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)\s*,\s*"
			r"([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)",
			path.read_text(encoding="utf-8", errors="replace"),
			re.IGNORECASE,
		)
		if match:
			result[match.group(1).upper()] = [value.upper() for value in match.groups()[1:]]
	return result


def trainer_default_ability_slots(classes: list[str]) -> dict[str, str]:
	rows = []
	for line in read("data/trainers/dvs.asm").splitlines():
		match = re.match(r"\s*dn\s+(\d+)\s*,", line)
		if match:
			rows.append(int(match.group(1)))
	return {
		trainer_class: "ABILITY_2" if attack_dv & 1 else "ABILITY_1"
		for trainer_class, attack_dv in zip(classes[1:], rows)
	}


def level_up_moves(valid_species: set[str]) -> dict[str, list[tuple[int, str]]]:
	lookup = {re.sub(r"[^a-z0-9]", "", value.lower()): value for value in valid_species}
	result: dict[str, list[tuple[int, str]]] = defaultdict(list)
	for path in sorted((ROOT / "data/pokemon").glob("evos_attacks*.asm")):
		current = None
		mode = "evolutions"
		for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
			line = raw_line.split(";", 1)[0].strip()
			label = re.match(r"^([A-Za-z0-9_]+):", line)
			if label:
				name = re.sub(
					r"(?:EvosAttacks|EvosAndAttacks|Attacks|Learnset)$",
					"",
					label.group(1),
					flags=re.IGNORECASE,
				)
				current = lookup.get(re.sub(r"[^a-z0-9]", "", name.lower()))
				mode = "evolutions"
				continue
			if not current:
				continue
			if re.match(r"db\s+0\b", line, re.IGNORECASE):
				if mode == "evolutions":
					mode = "moves"
				continue
			if mode == "moves":
				move = re.search(r"\bdbw?\s+(\d+)\s*,\s*([A-Z0-9_]+)", line, re.IGNORECASE)
				if move:
					result[current].append((int(move.group(1)), move.group(2).upper()))
	return result


def automatic_moves(learnset: list[tuple[int, str]], level: int) -> list[str]:
	known = []
	for learned_level, move in learnset:
		if learned_level > level:
			break
		if move in known:
			continue
		if len(known) == 4:
			known.pop(0)
		known.append(move)
	return known


def party_comments(groups: dict) -> None:
	lines = read("data/trainers/parties.asm").splitlines()
	pattern = re.compile(
		r"next_list_item\s*;\s*(\w+)\s+\((\d+)\)\s+(\w+)\s+-\s+(.+?)\s*$"
	)
	for entries in groups.values():
		for entry in entries:
			match = pattern.search(lines[entry["line"] - 1])
			if not match:
				raise ValueError(f"Could not parse trainer comment on line {entry['line']}")
			entry["trainer_id"] = match.group(3)
			entry["location"] = match.group(4)


def attach_map_references(
	groups: dict,
	trainer_ids: dict[str, list[str]],
	aliases: dict[str, dict[str, str]],
	owners: dict[str, str],
	class_pointers: dict[str, str],
) -> None:
	"""Attach the map scripts that actually select each fixed party."""
	alias_targets = {
		alias: target
		for class_aliases in aliases.values()
		for alias, target in class_aliases.items()
	}
	entry_by_key = {
		(group, index): entry
		for group, entries in groups.items()
		for index, entry in enumerate(entries)
	}
	for entry in entry_by_key.values():
		entry["map_references"] = []

	pattern = re.compile(
		r"^(?:trainer|generictrainer|loadtrainer)\s+(\w+)\s*,\s*(\w+)",
		re.IGNORECASE,
	)
	seen = defaultdict(set)
	for path in sorted((ROOT / "maps").glob("*.asm")):
		for line_number, raw_line in enumerate(
			path.read_text(encoding="utf-8", errors="replace").splitlines(), 1
		):
			line = raw_line.split(";", 1)[0].strip()
			match = pattern.match(line)
			if not match:
				continue
			trainer_class, trainer_id = (value.upper() for value in match.groups())
			group = class_pointers.get(trainer_class)
			target_id = alias_targets.get(trainer_id, trainer_id)
			owner = owners.get(target_id)
			if not group or not owner or target_id not in trainer_ids.get(owner, []):
				continue
			index = trainer_ids[owner].index(target_id)
			key = (group, index)
			entry = entry_by_key.get(key)
			if entry is None or path in seen[key]:
				continue
			seen[key].add(path)
			entry["map_references"].append(
				{"path": path.relative_to(ROOT).as_posix(), "line": line_number}
			)


def resolve_ability(
	species: str,
	slot: str,
	slots_by_species: dict[str, list[str]],
	names: dict[str, str],
) -> str:
	available = slots_by_species.get(species, [])
	index = ABILITY_SLOT_INDEX.get(slot, 0)
	constant = available[index] if index < len(available) else "NO_ABILITY"
	# GetAbility falls back to slot 1 whenever the selected slot is empty.
	if constant == "NO_ABILITY" and available:
		constant = available[0]
	return names.get(constant, display_constant(constant))


def party_type_label(trainer_type: str) -> str:
	features = []
	if "ITEM" in trainer_type:
		features.append("held items")
	if "MOVES" in trainer_type:
		features.append("custom moves")
	else:
		features.append("automatic level-up moves")
	if "ABILITY" in trainer_type:
		features.append("explicit abilities")
	else:
		features.append("class-default abilities")
	return ", ".join(features)


def markdown_escape(value: str) -> str:
	return value.replace("|", "\\|")


def source_link(line: int) -> str:
	return f"[parties.asm:L{line}](data/trainers/parties.asm#L{line})"


def render() -> str:
	audit.ERRORS.clear()
	species = audit.constant_list("constants/pokemon_constants.asm", "NUM_POKEMON")
	moves = audit.constant_list("constants/move_constants.asm", "NUM_ATTACKS")
	items = audit.constant_list("constants/item_constants.asm", "NUM_ITEMS")
	abilities = audit.constant_list("constants/ability_constants.asm", "NUM_ABILITIES")
	classes, trainer_ids, aliases, owners = audit.parse_trainer_constants()
	groups = audit.parse_parties(set(species), set(moves), set(items))
	class_pointers = audit.validate_group_pointers(classes, trainer_ids, aliases, owners, groups)
	if audit.ERRORS:
		raise ValueError("Trainer data did not validate:\n" + "\n".join(audit.ERRORS))
	party_comments(groups)
	attach_map_references(groups, trainer_ids, aliases, owners, class_pointers)

	mon_names = species_names(species)
	move_name = move_names(moves)
	item_name = item_names(items)
	ability_name = ability_names(abilities)
	slots_by_species = ability_slots()
	default_slots = trainer_default_ability_slots(classes)
	learnsets = level_up_moves(set(species))

	group_classes: dict[str, list[str]] = defaultdict(list)
	for trainer_class, group in class_pointers.items():
		group_classes[group].append(trainer_class)

	party_count = sum(len(entries) for entries in groups.values())
	mon_count = sum(len(entry["mons"]) for entries in groups.values() for entry in entries)
	nonempty_groups = [(group, entries) for group, entries in groups.items() if entries]

	out = [
		"# Crimson Crystal — Trainer Party Reference",
		"",
		(
			f"Generated from the current game source. **{party_count} fixed parties**, "
			f"**{mon_count} Pokémon**, and **{len(nonempty_groups)} party groups** are listed. "
			"Trainer classes stay together, and repeat fights/rematch tiers are grouped by trainer name."
		),
		"",
		"> [!IMPORTANT]",
		"> Edit `data/trainers/parties.asm`, not this generated file. Rebuild this reference with",
		"> `python tools/generate_trainer_party_reference.py`.",
		"",
		"> [!NOTE]",
		"> For parties labeled “automatic level-up moves,” the Moves column shows the exact set produced",
		"> by `FillMoves` at that level. Abilities are resolved to their actual names; “class default”",
		"> means the slot comes from that trainer class’s Attack DV. Battle Tower opponents are not",
		"> included because they draw generated teams from pools rather than owning fixed parties in",
		"> `data/trainers/parties.asm`.",
		"",
		"## Class index",
		"",
	]

	for group, entries in nonempty_groups:
		class_name = display_class(entries[0]["declared_class"])
		anchor = re.sub(r"[^a-z0-9 -]", "", class_name.lower()).replace(" ", "-")
		party_word = "party" if len(entries) == 1 else "parties"
		out.append(f"- [{class_name}](#{anchor}) — {len(entries)} {party_word}")

	for group, entries in nonempty_groups:
		declared_class = entries[0]["declared_class"]
		class_name = display_class(declared_class)
		anchor = re.sub(r"[^a-z0-9 -]", "", class_name.lower()).replace(" ", "-")
		battle_classes = group_classes.get(group, [declared_class])
		out.extend([
			"",
			f'<a id="{anchor}"></a>',
			"",
			f"## {class_name}",
			"",
			f"**Party group:** `{group}`  ",
			f"**Battle class IDs:** {', '.join(f'`{value}`' for value in battle_classes)}  ",
			f"**Parties:** {len(entries)}",
			"",
		])

		series: OrderedDict[str, list[dict]] = OrderedDict()
		for entry in entries:
			series_name = entry["name"].replace("@", "")
			if series_name == "?":
				series_name = class_name
			else:
				series_name = display_trainer_name(series_name)
			series.setdefault(series_name, []).append(entry)

		for trainer_name, variants in series.items():
			if len(variants) > 1:
				out.extend([f"### {trainer_name} — {len(variants)} battles", ""])
			for entry in variants:
				location = display_location(entry["location"])
				levels = [mon["level"] for mon in entry["mons"]]
				level_text = f"Lv. {levels[0]}" if len(set(levels)) == 1 else f"Lv. {min(levels)}–{max(levels)}"
				if len(variants) == 1:
					heading = f"### {trainer_name} — {location} (`{entry['trainer_id']}`)"
				else:
					heading = f"#### {entry['trainer_id']} — {location}"
				out.extend([
					heading,
					"",
					(
						f"**Party:** {len(entry['mons'])} Pokémon, {level_text}  "
						f"\n**Data:** {party_type_label(entry['trainer_type'])}  "
						f"\n**Source:** {source_link(entry['line'])}  "
					),
				])
				if entry["map_references"]:
					map_links = ", ".join(
						f"[{Path(reference['path']).name}:L{reference['line']}]"
						f"({reference['path']}#L{reference['line']})"
						for reference in entry["map_references"]
					)
					out.append(f"**Map battle script:** {map_links}")
				else:
					out.append("**Map battle script:** no direct reference found")
				out.extend([
					"",
					"| # | Pokémon | Level | Held item | Ability | Moves |",
					"|---:|---|---:|---|---|---|",
				])
				for number, mon in enumerate(entry["mons"], 1):
					species_constant = mon["species"]
					species_label = mon_names.get(species_constant, display_constant(species_constant))
					item_label = item_name.get(mon["item"], display_constant(mon["item"]))
					explicit_slot = mon["ability"]
					slot = explicit_slot or default_slots.get(declared_class, "ABILITY_1")
					ability_label = resolve_ability(
						species_constant, slot, slots_by_species, ability_name
					)
					slot_label = {
						"ABILITY_1": "slot 1",
						"ABILITY_2": "slot 2",
						"HIDDEN_ABILITY": "hidden",
					}.get(slot, slot)
					if not explicit_slot:
						slot_label += ", class default"
					party_moves = mon["moves"]
					if not party_moves:
						party_moves = automatic_moves(learnsets.get(species_constant, []), mon["level"])
					moves_label = ", ".join(
						markdown_escape(move_name.get(move, display_constant(move)))
						for move in party_moves
						if move != "NO_MOVE"
					) or "—"
					out.append(
						f"| {number} | **{markdown_escape(species_label)}** (`{species_constant}`) "
						f"| {mon['level']} | {markdown_escape(item_label)} | "
						f"{markdown_escape(ability_label)} *({slot_label})* | {moves_label} |"
					)
				out.append("")

	return "\n".join(out).rstrip() + "\n"


def main() -> int:
	output = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else OUTPUT
	output.write_text(render(), encoding="utf-8")
	print(f"Generated {output.relative_to(ROOT)}")
	return 0


if __name__ == "__main__":
	raise SystemExit(main())

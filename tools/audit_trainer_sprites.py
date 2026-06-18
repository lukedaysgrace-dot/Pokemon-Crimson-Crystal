#!/usr/bin/env python3
"""Audit trainer overworld sprites and outdoor sprite-group VRAM usage."""

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

ALLOWED_CLASS_SPRITES = {
	# Deliberate map-specific disguises and variable sprite replacements.
	("LASS", "SPRITE_FUCHSIA_GYM_1"),
	("LASS", "SPRITE_FUCHSIA_GYM_2"),
	("PICNICKER", "SPRITE_FUCHSIA_GYM_3"),
	("CAMPER", "SPRITE_FUCHSIA_GYM_4"),
	("SCHOOLBOY", "SPRITE_STANDING_YOUNGSTER"),
	("SWIMMERM", "SPRITE_OLIVINE_RIVAL"),
	("TWINS", "SPRITE_WEIRD_TREE"),
}


def trainer_sprite_expectations():
	classes = []
	for line in (ROOT / "constants/trainer_constants.asm").read_text().splitlines():
		match = re.search(r"\btrainerclass\s+(\w+)", line.split(";")[0])
		if match:
			classes.append(match.group(1))

	sprites = []
	for line in (ROOT / "data/trainers/sprites.asm").read_text().splitlines():
		match = re.match(r"\s*db\s+(SPRITE_\w+)", line.split(";")[0])
		if match:
			sprites.append(match.group(1))

	# TRAINER_NONE has no corresponding overworld sprite entry.
	return dict(zip(classes[1:], sprites))


def parse_map(path):
	lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
	script_classes = {}
	current_label = None

	for line in lines:
		label = re.match(r"^(\w+):", line)
		if label:
			current_label = label.group(1)
			continue
		trainer = re.search(
			r"\b(?:trainer|generictrainer|loadtrainer)\s+(\w+)\s*,", line
		)
		if trainer and current_label:
			script_classes.setdefault(current_label, trainer.group(1))

	objects = []
	for line_number, line in enumerate(lines, 1):
		if not line.lstrip().startswith("object_event"):
			continue
		parts = [part.strip() for part in line.split(",")]
		if len(parts) < 12:
			continue
		sprite = parts[2]
		script = parts[11]
		objects.append(
			{
				"line": line_number,
				"sprite": sprite,
				"script": script,
				"trainer_class": script_classes.get(script),
			}
		)
	return objects


def sprite_metadata():
	ids = {}
	current = 0
	for line in (ROOT / "constants/sprite_constants.asm").read_text().splitlines():
		line = line.split(";")[0].strip()
		match = re.match(r"const_def(?:\s+\$(\w+))?", line)
		if match:
			current = int(match.group(1), 16) if match.group(1) else 0
			continue
		match = re.match(r"(SPRITE_\w+)\s+EQU\s+const_value", line)
		if match:
			ids[match.group(1)] = current
			continue
		match = re.match(r"const\s+(SPRITE_\w+)", line)
		if match:
			ids[match.group(1)] = current
			current += 1

	types = {}
	index = 1
	for line in (ROOT / "data/sprites/sprites.asm").read_text().splitlines():
		match = re.search(r"overworld_sprite\s+\w+,\s+(\d+),\s+(\w+)", line)
		if not match:
			continue
		type_name = match.group(2)
		type_id = {
			"WALKING_SPRITE": 1,
			"STANDING_SPRITE": 2,
			"MON_ICON_SPRITE": 3,
			"STILL_SPRITE": 4,
			"BIG_SPRITE": 5,
		}[type_name]
		types[index] = (type_id, int(match.group(1)))
		index += 1
	return ids, types


def sprite_size(sprite, ids, types):
	if sprite == "SPRITE_WEIRD_TREE":
		return 3, 8
	sprite_id = ids.get(sprite)
	if sprite == "SPRITE_NONE" or sprite_id == 0:
		return None
	if sprite_id is None or sprite_id >= 0xF0:
		return 1, 12
	if sprite_id >= 0x80:
		return 3, 8
	return types.get(sprite_id, (1, 12))


def packed_sprite_tiles(sprites, ids, types):
	unique = []
	for sprite in ["SPRITE_CHRIS", *sprites]:
		if sprite not in unique and sprite != "SPRITE_NONE":
			unique.append(sprite)
	entries = sorted(
		(sprite_size(sprite, ids, types), sprite) for sprite in unique
		if sprite_size(sprite, ids, types) is not None
	)

	bank_start = 0
	next_tile = 0
	assignments = []
	for (type_id, size), sprite in entries:
		if bank_start == 0 and next_tile + size > 0x80:
			bank_start = 0x80
			next_tile = 0x80
		# ArrangeUsedSprites rejects a sprite ending exactly at tile $100.
		if bank_start == 0x80 and next_tile + size >= 0x100:
			return None, assignments, sprite
		assignments.append((sprite, next_tile, size, type_id))
		next_tile += size
	return next_tile, assignments, None


def outdoor_groups():
	map_groups = {}
	current_group = None
	for line in (ROOT / "data/maps/maps.asm").read_text().splitlines():
		label = re.match(r"MapGroup_(\w+):", line)
		if label:
			current_group = label.group(1)
			continue
		match = re.match(r"\s*map\s+(\w+),\s*\w+,\s*(\w+),", line)
		if match and current_group and match.group(2) in {"TOWN", "ROUTE"}:
			map_groups[match.group(1)] = current_group

	group_sprites = {}
	current_group = None
	for line in (ROOT / "data/maps/outdoor_sprites.asm").read_text().splitlines():
		label = re.match(r"(\w+)GroupSprites:", line)
		if label:
			current_group = label.group(1)
			group_sprites[current_group] = []
			continue
		match = re.match(r"\s*db\s+(SPRITE_\w+)", line.split(";")[0])
		if match and current_group:
			group_sprites[current_group].append(match.group(1))
	return map_groups, group_sprites


def main():
	expected = trainer_sprite_expectations()
	all_objects = {}
	mismatches = []
	for path in sorted((ROOT / "maps").glob("*.asm")):
		objects = parse_map(path)
		all_objects[path.stem] = objects
		for obj in objects:
			trainer_class = obj["trainer_class"]
			if not trainer_class or trainer_class not in expected:
				continue
			if (
				obj["sprite"] != expected[trainer_class]
				and (trainer_class, obj["sprite"]) not in ALLOWED_CLASS_SPRITES
			):
				mismatches.append((path, obj, expected[trainer_class]))

	print("=== TRAINER SPRITE MISMATCHES ===")
	for path, obj, wanted in mismatches:
		print(
			f"{path.relative_to(ROOT)}:{obj['line']}: {obj['trainer_class']} uses "
			f"{obj['sprite']}; expected {wanted} ({obj['script']})"
		)
	print(f"Total: {len(mismatches)}")

	ids, types = sprite_metadata()
	map_groups, groups = outdoor_groups()
	needed_by_group = {group: set() for group in groups}
	for map_name, group in map_groups.items():
		for obj in all_objects.get(map_name, []):
			if obj["sprite"].startswith("SPRITE_") and obj["sprite"] != "SPRITE_NONE":
				needed_by_group.setdefault(group, set()).add(obj["sprite"])

	print("\n=== OUTDOOR GROUP ISSUES ===")
	issue_count = 0
	for group, sprites in groups.items():
		missing = sorted(needed_by_group.get(group, set()) - set(sprites))
		end_tile, assignments, overflow = packed_sprite_tiles(sprites, ids, types)
		font_overlap = [
			sprite for sprite, tile, size, type_id in assignments
			if type_id <= 3 and tile < 0x100 and tile + size > 0xDC
		]
		if not missing and not overflow and not font_overlap:
			continue
		issue_count += 1
		if missing:
			print(f"{group}: missing {', '.join(missing)}")
		if overflow:
			used = max(tile + size for _, tile, size, _ in assignments)
			print(f"{group}: VRAM overflow while assigning {overflow} after tile {used}")
		if font_overlap:
			print(f"{group}: animated sprites overlap map-name font: {', '.join(font_overlap)}")
		extras = sorted(set(sprites) - needed_by_group.get(group, set()))
		print(f"{group}: unreferenced candidates: {', '.join(extras)}")
	print(f"Total: {issue_count}")

	print("\n=== OUTDOOR GROUP PACKING ===")
	for group, sprites in groups.items():
		end_tile, assignments, overflow = packed_sprite_tiles(sprites, ids, types)
		status = f"overflow at {overflow}" if overflow else f"ends at tile {end_tile}"
		print(f"{group:12} {status}")


if __name__ == "__main__":
	main()

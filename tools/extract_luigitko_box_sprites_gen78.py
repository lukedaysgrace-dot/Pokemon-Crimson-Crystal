from __future__ import annotations

import csv
import sys
from pathlib import Path

from PIL import Image, ImageChops


CELL_SIZE = 16
COLS = 18
OCCUPIED_THRESHOLD = 8

GEN7_SPECIES = [
    "rowlet",
    "dartrix",
    "decidueye",
    "litten",
    "torracat",
    "incineroar",
    "popplio",
    "brionne",
    "primarina",
    "pikipek",
    "trumbeak",
    "toucannon",
    "yungoos",
    "gumshoos",
    "grubbin",
    "charjabug",
    "vikavolt",
    "crabrawler",
    "crabominable",
    "oricorio",
    "cutiefly",
    "ribombee",
    "rockruff",
    "lycanroc",
    "wishiwashi",
    "mareanie",
    "toxapex",
    "mudbray",
    "mudsdale",
    "dewpider",
    "araquanid",
    "fomantis",
    "lurantis",
    "morelull",
    "shiinotic",
    "salandit",
    "salazzle",
    "stufful",
    "bewear",
    "bounsweet",
    "steenee",
    "tsareena",
    "comfey",
    "oranguru",
    "passimian",
    "wimpod",
    "golisopod",
    "sandygast",
    "palossand",
    "pyukumuku",
    "type_null",
    "silvally",
    "minior",
    "komala",
    "turtonator",
    "togedemaru",
    "mimikyu",
    "bruxish",
    "drampa",
    "dhelmise",
    "jangmo_o",
    "hakamo_o",
    "kommo_o",
    "tapu_koko",
    "tapu_lele",
    "tapu_bulu",
    "tapu_fini",
    "cosmog",
    "cosmoem",
    "solgaleo",
    "lunala",
    "nihilego",
    "buzzwole",
    "pheromosa",
    "xurkitree",
    "celesteela",
    "kartana",
    "guzzlord",
    "necrozma",
    "magearna",
    "marshadow",
    "poipole",
    "naganadel",
    "stakataka",
    "blacephalon",
    "zeraora",
    "meltan",
    "melmetal",
]

GEN8_SPECIES = [
    "grookey",
    "thwackey",
    "rillaboom",
    "scorbunny",
    "raboot",
    "cinderace",
    "sobble",
    "drizzile",
    "inteleon",
    "skwovet",
    "greedent",
    "rookidee",
    "corvisquire",
    "corviknight",
    "blipbug",
    "dottler",
    "orbeetle",
    "nickit",
    "thievul",
    "gossifleur",
    "eldegoss",
    "wooloo",
    "dubwool",
    "chewtle",
    "drednaw",
    "yamper",
    "boltund",
    "rolycoly",
    "carkol",
    "coalossal",
    "applin",
    "flapple",
    "appletun",
    "silicobra",
    "sandaconda",
    "cramorant",
    "arrokuda",
    "barraskewda",
    "toxel",
    "toxtricity",
    "sizzlipede",
    "centiskorch",
    "clobbopus",
    "grapploct",
    "sinistea",
    "polteageist",
    "hatenna",
    "hattrem",
    "hatterene",
    "impidimp",
    "morgrem",
    "grimmsnarl",
    "obstagoon",
    "perrserker",
    "cursola",
    "sirfetchd",
    "mr_rime",
    "runerigus",
    "milcery",
    "alcremie",
    "falinks",
    "pincurchin",
    "snom",
    "frosmoth",
    "stonjourner",
    "eiscue",
    "indeedee",
    "morpeko",
    "cufant",
    "copperajah",
    "dracozolt",
    "arctozolt",
    "dracovish",
    "arctovish",
    "duraludon",
    "dreepy",
    "drakloak",
    "dragapult",
    "zacian",
    "zamazenta",
    "eternatus",
    "kubfu",
    "urshifu",
    "zarude",
    "regieleki",
    "regidrago",
    "glastrier",
    "spectrier",
    "calyrex",
    "wyrdeer",
    "kleavor",
    "ursaluna",
    "basculegion",
    "sneasler",
    "overqwil",
    "enamorus",
]


def occupied_slots(frame: Image.Image) -> list[int]:
    slots: list[int] = []
    total = (frame.width // CELL_SIZE) * (frame.height // CELL_SIZE)
    for slot_index in range(total):
        row, col = divmod(slot_index, COLS)
        crop = frame.crop(
            (col * CELL_SIZE, row * CELL_SIZE, col * CELL_SIZE + CELL_SIZE, row * CELL_SIZE + CELL_SIZE)
        )
        count = sum(1 for p in crop.getdata() if p[3] and p[:3] != (0, 0, 0))
        if count > OCCUPIED_THRESHOLD:
            slots.append(slot_index)
    return slots


def crop_cell(image: Image.Image, slot_index: int) -> Image.Image:
    row, col = divmod(slot_index, COLS)
    left = col * CELL_SIZE
    top = row * CELL_SIZE
    return image.crop((left, top, left + CELL_SIZE, top + CELL_SIZE))


def export_sprite(frames: list[Image.Image], slot_index: int, out_path: Path) -> bool:
    top = crop_cell(frames[0], slot_index)
    bottom_src = crop_cell(frames[1], slot_index)
    stacked = Image.new("RGBA", (CELL_SIZE, CELL_SIZE * 2), (0, 0, 0, 0))
    stacked.paste(top, (0, 0))
    has_second_frame = ImageChops.difference(top, bottom_src).getbbox() is not None
    if has_second_frame:
        stacked.paste(bottom_src, (0, CELL_SIZE))
    stacked.save(out_path)
    return has_second_frame


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: extract_luigitko_box_sprites_gen78.py INPUT_GIF OUTPUT_DIR")
        return 1

    input_path = Path(sys.argv[1])
    output_dir = Path(sys.argv[2])
    output_dir.mkdir(parents=True, exist_ok=True)

    image = Image.open(input_path)
    if getattr(image, "n_frames", 1) < 2:
        raise ValueError("expected a 2-frame GIF")

    frames = []
    for frame_index in range(2):
        image.seek(frame_index)
        frames.append(image.convert("RGBA"))

    occupied = occupied_slots(frames[0])

    gen7_extra_count = 41
    gen8_extra_count = len(occupied) - len(GEN7_SPECIES) - gen7_extra_count - len(GEN8_SPECIES)
    if gen8_extra_count < 0:
        raise ValueError("sheet does not have enough occupied slots for configured counts")

    ordered_names = (
        GEN7_SPECIES
        + [f"gen7_extra_{i:02d}" for i in range(1, gen7_extra_count + 1)]
        + GEN8_SPECIES
        + [f"gen8_extra_{i:02d}" for i in range(1, gen8_extra_count + 1)]
    )

    if len(ordered_names) != len(occupied):
        raise ValueError("name count does not match occupied slot count")

    csv_rows: list[dict[str, str | int]] = []
    for seq_index, (species, slot_index) in enumerate(zip(ordered_names, occupied)):
        has_second = export_sprite(frames, slot_index, output_dir / f"{species}.png")
        csv_rows.append(
            {
                "sequence_index": seq_index,
                "sheet_slot": slot_index,
                "species": species,
                "has_second_frame": int(has_second),
            }
        )

    with (output_dir / "index.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle, fieldnames=["sequence_index", "sheet_slot", "species", "has_second_frame"]
        )
        writer.writeheader()
        writer.writerows(csv_rows)

    print(f"exported {len(csv_rows)} sprites to {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

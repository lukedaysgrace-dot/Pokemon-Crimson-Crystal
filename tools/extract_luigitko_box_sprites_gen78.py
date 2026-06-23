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

GEN7_EXTRA_FORMS = [
    "rattata_alolan",
    "raticate_alolan",
    "raichu_alolan",
    "sandshrew_alolan",
    "sandslash_alolan",
    "vulpix_alolan",
    "ninetales_alolan",
    "diglett_alolan",
    "dugtrio_alolan",
    "meowth_alolan",
    "persian_alolan",
    "geodude_alolan",
    "graveler_alolan",
    "golem_alolan",
    "grimer_alolan",
    "muk_alolan",
    "exeggutor_alolan",
    "marowak_alolan",
    "zygarde_cell",
    "zygarde_core",
    "zygarde_10_percent",
    "zygarde_complete",
    "lycanroc_midnight",
    "lycanroc_dusk",
    "pikachu_original_cap",
    "pikachu_hoenn_cap",
    "pikachu_sinnoh_cap",
    "pikachu_unova_cap",
    "pikachu_kalos_cap",
    "minior_red_core",
    "minior_orange_core",
    "minior_yellow_core",
    "minior_green_core",
    "minior_blue_core",
    "minior_indigo_core",
    "minior_violet_core",
    "wishiwashi_school",
    "oricorio_pom_pom",
    "oricorio_pau",
    "oricorio_sensu",
    "mimikyu_busted",
]

GEN8_EXTRA_FORMS = [
    "meowth_galarian",
    "ponyta_galarian",
    "rapidash_galarian",
    "slowpoke_galarian",
    "slowbro_galarian",
    "farfetchd_galarian",
    "weezing_galarian",
    "mr_mime_galarian",
    "articuno_galarian",
    "zapdos_galarian",
    "moltres_galarian",
    "slowking_galarian",
    "corsola_galarian",
    "zigzagoon_galarian",
    "linoone_galarian",
    "darumaka_galarian",
    "darmanitan_galarian",
    "darmanitan_galarian_zen",
    "yamask_galarian",
    "stunfisk_galarian",
    "venusaur_gmax",
    "charizard_gmax",
    "blastoise_gmax",
    "butterfree_gmax",
    "pikachu_gmax",
    "meowth_gmax",
    "machamp_gmax",
    "gengar_gmax",
    "kingler_gmax",
    "lapras_gmax",
    "eevee_gmax",
    "snorlax_gmax",
    "garbodor_gmax",
    "melmetal_gmax",
    "rillaboom_gmax",
    "cinderace_gmax",
    "inteleon_gmax",
    "corviknight_gmax",
    "orbeetle_gmax",
    "drednaw_gmax",
    "coalossal_gmax",
    "flapple_gmax",
    "appletun_gmax",
    "sandaconda_gmax",
    "toxtricity_gmax",
    "centiskorch_gmax",
    "hatterene_gmax",
    "grimmsnarl_gmax",
    "alcremie_gmax",
    "copperajah_gmax",
    "duraludon_gmax",
    "urshifu_gmax",
    "urshifu_rapid_strike_gmax",
    *[f"alcremie_variant_{i:02d}" for i in range(1, 33)],
    *[f"alcremie_sweet_{i:02d}" for i in range(1, 9)],
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

    ordered_names = (
        GEN7_SPECIES
        + GEN7_EXTRA_FORMS
        + GEN8_SPECIES
        + GEN8_EXTRA_FORMS
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

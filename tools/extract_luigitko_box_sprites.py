from __future__ import annotations

import csv
import sys
from pathlib import Path

from PIL import Image


CELL_SIZE = 16
COLS = 18
TOP_ROWS = 14
GEN3_START_ROW = 16

GEN1_2_SPECIES = [
    "bulbasaur",
    "ivysaur",
    "venusaur",
    "charmander",
    "charmeleon",
    "charizard",
    "squirtle",
    "wartortle",
    "blastoise",
    "caterpie",
    "metapod",
    "butterfree",
    "weedle",
    "kakuna",
    "beedrill",
    "pidgey",
    "pidgeotto",
    "pidgeot",
    "rattata",
    "raticate",
    "spearow",
    "fearow",
    "ekans",
    "arbok",
    "pikachu",
    "raichu",
    "sandshrew",
    "sandslash",
    "nidoran_f",
    "nidorina",
    "nidoqueen",
    "nidoran_m",
    "nidorino",
    "nidoking",
    "clefairy",
    "clefable",
    "vulpix",
    "ninetales",
    "jigglypuff",
    "wigglytuff",
    "zubat",
    "golbat",
    "oddish",
    "gloom",
    "vileplume",
    "paras",
    "parasect",
    "venonat",
    "venomoth",
    "diglett",
    "dugtrio",
    "meowth",
    "persian",
    "psyduck",
    "golduck",
    "mankey",
    "primeape",
    "growlithe",
    "arcanine",
    "poliwag",
    "poliwhirl",
    "poliwrath",
    "abra",
    "kadabra",
    "alakazam",
    "machop",
    "machoke",
    "machamp",
    "bellsprout",
    "weepinbell",
    "victreebel",
    "tentacool",
    "tentacruel",
    "geodude",
    "graveler",
    "golem",
    "ponyta",
    "rapidash",
    "slowpoke",
    "slowbro",
    "magnemite",
    "magneton",
    "farfetchd",
    "doduo",
    "dodrio",
    "seel",
    "dewgong",
    "grimer",
    "muk",
    "shellder",
    "cloyster",
    "gastly",
    "haunter",
    "gengar",
    "onix",
    "drowzee",
    "hypno",
    "krabby",
    "kingler",
    "voltorb",
    "electrode",
    "exeggcute",
    "exeggutor",
    "cubone",
    "marowak",
    "hitmonlee",
    "hitmonchan",
    "lickitung",
    "koffing",
    "weezing",
    "rhyhorn",
    "rhydon",
    "chansey",
    "tangela",
    "kangaskhan",
    "horsea",
    "seadra",
    "goldeen",
    "seaking",
    "staryu",
    "starmie",
    "mr_mime",
    "scyther",
    "jynx",
    "electabuzz",
    "magmar",
    "pinsir",
    "tauros",
    "magikarp",
    "gyarados",
    "lapras",
    "ditto",
    "eevee",
    "vaporeon",
    "jolteon",
    "flareon",
    "porygon",
    "omanyte",
    "omastar",
    "kabuto",
    "kabutops",
    "aerodactyl",
    "snorlax",
    "articuno",
    "zapdos",
    "moltres",
    "dratini",
    "dragonair",
    "dragonite",
    "mewtwo",
    "mew",
    "chikorita",
    "bayleef",
    "meganium",
    "cyndaquil",
    "quilava",
    "typhlosion",
    "totodile",
    "croconaw",
    "feraligatr",
    "sentret",
    "furret",
    "hoothoot",
    "noctowl",
    "ledyba",
    "ledian",
    "spinarak",
    "ariados",
    "crobat",
    "chinchou",
    "lanturn",
    "pichu",
    "cleffa",
    "igglybuff",
    "togepi",
    "togetic",
    "natu",
    "xatu",
    "mareep",
    "flaaffy",
    "ampharos",
    "bellossom",
    "marill",
    "azumarill",
    "sudowoodo",
    "politoed",
    "hoppip",
    "skiploom",
    "jumpluff",
    "aipom",
    "sunkern",
    "sunflora",
    "yanma",
    "wooper",
    "quagsire",
    "espeon",
    "umbreon",
    "murkrow",
    "slowking",
    "misdreavus",
    "unown",
    "wobbuffet",
    "girafarig",
    "pineco",
    "forretress",
    "dunsparce",
    "gligar",
    "steelix",
    "snubbull",
    "granbull",
    "qwilfish",
    "scizor",
    "shuckle",
    "heracross",
    "sneasel",
    "teddiursa",
    "ursaring",
    "slugma",
    "magcargo",
    "swinub",
    "piloswine",
    "corsola",
    "remoraid",
    "octillery",
    "delibird",
    "mantine",
    "skarmory",
    "houndour",
    "houndoom",
    "kingdra",
    "phanpy",
    "donphan",
    "porygon2",
    "stantler",
    "smeargle",
    "tyrogue",
    "hitmontop",
    "smoochum",
    "elekid",
    "magby",
    "miltank",
    "blissey",
    "raikou",
    "entei",
    "suicune",
    "larvitar",
    "pupitar",
    "tyranitar",
    "lugia",
    "ho_oh",
    "celebi",
]

GEN3_SPECIES = [
    "treecko",
    "grovyle",
    "sceptile",
    "torchic",
    "combusken",
    "blaziken",
    "mudkip",
    "marshtomp",
    "swampert",
    "poochyena",
    "mightyena",
    "zigzagoon",
    "linoone",
    "wurmple",
    "silcoon",
    "beautifly",
    "cascoon",
    "dustox",
    "lotad",
    "lombre",
    "ludicolo",
    "seedot",
    "nuzleaf",
    "shiftry",
    "taillow",
    "swellow",
    "wingull",
    "pelipper",
    "ralts",
    "kirlia",
    "gardevoir",
    "surskit",
    "masquerain",
    "shroomish",
    "breloom",
    "slakoth",
    "vigoroth",
    "slaking",
    "nincada",
    "ninjask",
    "shedinja",
    "whismur",
    "loudred",
    "exploud",
    "makuhita",
    "hariyama",
    "azurill",
    "nosepass",
    "skitty",
    "delcatty",
    "sableye",
    "mawile",
    "aron",
    "lairon",
    "aggron",
    "meditite",
    "medicham",
    "electrike",
    "manectric",
    "plusle",
    "minun",
    "volbeat",
    "illumise",
    "roselia",
    "gulpin",
    "swalot",
    "carvanha",
    "sharpedo",
    "wailmer",
    "wailord",
    "numel",
    "camerupt",
    "torkoal",
    "spoink",
    "grumpig",
    "spinda",
    "trapinch",
    "vibrava",
    "flygon",
    "cacnea",
    "cacturne",
    "swablu",
    "altaria",
    "zangoose",
    "seviper",
    "lunatone",
    "solrock",
    "barboach",
    "whiscash",
    "corphish",
    "crawdaunt",
    "baltoy",
    "claydol",
    "lileep",
    "cradily",
    "anorith",
    "armaldo",
    "feebas",
    "milotic",
    "castform",
    "kecleon",
    "shuppet",
    "banette",
    "duskull",
    "dusclops",
    "tropius",
    "chimecho",
    "absol",
    "wynaut",
    "snorunt",
    "glalie",
    "spheal",
    "sealeo",
    "walrein",
    "clamperl",
    "huntail",
    "gorebyss",
    "relicanth",
    "luvdisc",
    "bagon",
    "shelgon",
    "salamence",
    "beldum",
    "metang",
    "metagross",
    "regirock",
    "regice",
    "registeel",
    "latias",
    "latios",
    "kyogre",
    "groudon",
    "rayquaza",
    "jirachi",
    "deoxys",
]


def crop_cell(image: Image.Image, index: int) -> Image.Image:
    row, col = divmod(index, COLS)
    left = col * CELL_SIZE
    top = row * CELL_SIZE
    return image.crop((left, top, left + CELL_SIZE, top + CELL_SIZE))


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: extract_luigitko_box_sprites.py INPUT_GIF OUTPUT_DIR")
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
        frame = image.convert("RGBA").crop((0, 0, COLS * CELL_SIZE, TOP_ROWS * CELL_SIZE))
        frames.append(frame)

    csv_rows: list[dict[str, str | int]] = []
    for dex, species in enumerate(GEN1_2_SPECIES, start=1):
        slot_index = dex - 1
        if species == "unown":
            csv_rows.append(
                {
                    "dex": dex,
                    "species": species,
                    "slot_index": slot_index,
                    "exported": 0,
                }
            )
            continue

        top = crop_cell(frames[0], slot_index)
        bottom = crop_cell(frames[1], slot_index)
        stacked = Image.new("RGBA", (CELL_SIZE, CELL_SIZE * 2), (0, 0, 0, 0))
        stacked.paste(top, (0, 0))
        stacked.paste(bottom, (0, CELL_SIZE))
        stacked.save(output_dir / f"{species}.png")

        csv_rows.append(
            {
                "dex": dex,
                "species": species,
                "slot_index": slot_index,
                "exported": 1,
            }
        )

    gen3_dir = output_dir / "gen3"
    gen3_dir.mkdir(parents=True, exist_ok=True)
    gen3_csv_rows: list[dict[str, str | int]] = []
    gen3_start_slot = GEN3_START_ROW * COLS
    gen3_frames = []
    for frame_index in range(2):
        image.seek(frame_index)
        gen3_frames.append(image.convert("RGBA"))

    for offset, species in enumerate(GEN3_SPECIES):
        slot_index = gen3_start_slot + offset
        top = crop_cell(gen3_frames[0], slot_index)
        bottom = crop_cell(gen3_frames[1], slot_index)
        stacked = Image.new("RGBA", (CELL_SIZE, CELL_SIZE * 2), (0, 0, 0, 0))
        stacked.paste(top, (0, 0))
        stacked.paste(bottom, (0, CELL_SIZE))
        stacked.save(gen3_dir / f"{species}.png")
        gen3_csv_rows.append(
            {
                "national_dex": 252 + offset,
                "species": species,
                "slot_index": slot_index,
                "exported": 1,
            }
        )

    with (gen3_dir / "index.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["national_dex", "species", "slot_index", "exported"])
        writer.writeheader()
        writer.writerows(gen3_csv_rows)

    with (output_dir / "index.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["dex", "species", "slot_index", "exported"])
        writer.writeheader()
        writer.writerows(csv_rows)

    print(
        f"exported {sum(1 for row in csv_rows if row['exported'])} Gen 1/2 sprites "
        f"and {len(gen3_csv_rows)} Gen 3 sprites to {output_dir}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

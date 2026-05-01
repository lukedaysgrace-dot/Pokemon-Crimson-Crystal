#!/usr/bin/env python3
"""Fetch pokemondb.net data and write Crystal-style dex entry .asm files."""

from __future__ import annotations

import re
import sys
import time
import urllib.request
from pathlib import Path

_TOOLS_DIR = Path(__file__).resolve().parent
if str(_TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(_TOOLS_DIR))
from dex_brief_text import BRIEF_DEX

ROOT = Path(__file__).resolve().parents[1]
DEX_DIR = ROOT / "data" / "pokemon" / "dex_entries"

UA = {"User-Agent": "Mozilla/5.0 (compatible; DexGen/1.0; +https://github.com/)"}

MAX_LINE = 17
MON_NAME_CHARS = 10  # category label before @


def fetch_html(slug: str) -> str:
    req = urllib.request.Request(
        f"https://pokemondb.net/pokedex/{slug}",
        headers=UA,
    )
    with urllib.request.urlopen(req, timeout=25) as r:
        return r.read().decode("utf-8", errors="replace")


def parse_category(html: str) -> str:
    m = re.search(r"<th>Species</th>\s*<td>([^<]+)</td>", html)
    if not m:
        return "MYSTERY"
    raw = m.group(1).strip()
    raw = raw.replace("Pokémon", "Pokemon").replace("é", "e")
    raw = re.sub(r"\s+Pokemon\s*$", "", raw, flags=re.I).strip()
    cat = raw.upper()
    if cat.startswith("INTERTWIN"):
        return "INTERTWINE"
    if len(cat) <= MON_NAME_CHARS:
        return cat
    words = [w for w in cat.split() if w]
    if not words:
        return cat[:MON_NAME_CHARS]
    if len(words) == 1:
        w = words[0]
        if len(w) <= MON_NAME_CHARS:
            return w
        if w.endswith("ING") and len(w) - 3 <= MON_NAME_CHARS:
            return w[:-3]
        return w[:MON_NAME_CHARS]
    joined = f"{words[0]} {words[1]}"
    if len(joined) <= MON_NAME_CHARS:
        return joined
    return words[0][:MON_NAME_CHARS]


def parse_height_dw(html: str) -> int:
    m = re.search(r"<th>Height</th>\s*<td>([^<]+)</td>", html)
    if not m:
        return 100
    td = m.group(1)
    im = re.search(r"\((\d+)&#8242;(\d{2})&#8243;\)", td)
    if im:
        ft, inch = int(im.group(1)), int(im.group(2))
        return ft * 100 + inch
    # fallback plain apostrophe
    im2 = re.search(r"\((\d+)'(\d{2})\"\)", td.replace("′", "'").replace("″", '"'))
    if im2:
        return int(im2.group(1)) * 100 + int(im2.group(2))
    return 100


def parse_weight_dw(html: str) -> int:
    m = re.search(r"<th>Weight</th>\s*<td>([^<]+)</td>", html)
    if not m:
        return 1000
    td = m.group(1)
    lm = re.search(r"\(([\d.]+)\s*(?:&nbsp;)?lbs\)", td)
    if lm:
        lbs = float(lm.group(1))
        return int(round(lbs * 10))
    return 1000


def parse_sword_shield(html: str) -> tuple[str, str]:
    sword = ""
    m = re.search(
        r'<th><span class="igame sword">Sword</span></th>\s*'
        r'<td class="cell-med-text">([^<]+)</td>',
        html,
        re.I,
    )
    if m:
        sword = m.group(1).strip()
    shield = ""
    m = re.search(
        r'<th><span class="igame shield">Shield</span></th>\s*'
        r'<td class="cell-med-text">([^<]+)</td>',
        html,
        re.I,
    )
    if m:
        shield = m.group(1).strip()
    return sword, shield


def wrap_words(text: str, max_len: int) -> list[str]:
    text = re.sub(r"\s+", " ", text.strip())
    if not text:
        return []
    lines: list[str] = []
    while text:
        if len(text) <= max_len:
            lines.append(text)
            break
        # find break position
        chunk = text[: max_len + 1]
        if " " in chunk[:-1]:
            cut = chunk.rfind(" ", 0, max_len + 1)
            if cut == -1:
                cut = max_len
        else:
            cut = max_len
            if cut < len(text) and text[cut] != " ":
                # hyphenate long token
                lines.append(text[: cut - 1] + "-")
                text = text[cut - 1 :].lstrip()
                continue
        line = text[:cut].rstrip()
        text = text[cut:].lstrip()
        lines.append(line)
    return lines


def _wrap_line_endings_ok(lines: list[str]) -> bool:
    """Reject wraps that end a line on a comma or dangling fragment."""
    if not lines:
        return False
    last = lines[-1].rstrip()
    if last.endswith(","):
        return False
    low = last.lower()
    if re.search(
        r"(,\s*its|,\s*his|,\s*her|^\s*its\.?$|^\s*as\.?$|^\s*to\.?$|^\s*the\.?$|^\s*a\.?$)",
        low,
    ):
        return False
    # Copula + adverb with no complement (leftovers from aggressive fitting)
    if re.search(r"\b(is|are)\s+(constantly|always|often)\.$", low):
        return False
    if re.search(r"\b(constantly|always)\.$", low):
        return False
    return True


def polish_to_three_lines(text: str) -> str:
    """Trim trailing words until wrapped lines read like finished clauses."""
    text = re.sub(r"\s+", " ", text.strip())
    if not text:
        return "It lives in the wild."
    core = text.rstrip(".!?")
    words = core.split()
    while words:
        trial = " ".join(words)
        if trial[-1] not in ".!?":
            trial += "."
        wl = wrap_words(trial, MAX_LINE)
        if len(wl) <= 3 and _wrap_line_endings_ok(wl):
            return trial
        words.pop()
    return "It lives in the wild."


def fit_words_to_three_lines(sentence: str) -> str:
    """
    Take whole words from sentence until adding another word would
    exceed three 17-char display lines. Always ends with punctuation.
    """
    sentence = re.sub(r"\s+", " ", sentence.strip())
    if not sentence:
        return "It lives in the wild."
    words = sentence.split()
    acc: list[str] = []
    for w in words:
        trial = " ".join(acc + [w])
        if len(wrap_words(trial, MAX_LINE)) <= 3:
            acc.append(w)
        else:
            break
    if not acc:
        chunk = words[0][: MAX_LINE * 3].rsplit(" ", 1)[0]
        raw = (chunk if chunk else words[0][:42]) + "."
        return polish_to_three_lines(raw)
    out = " ".join(acc)
    if out[-1] not in ".!?":
        out += "."
    return polish_to_three_lines(out)


def repartition_three_lines(text: str) -> list[str]:
    """
    Split text into exactly three display lines (each <= MAX_LINE), using
    word boundaries only — never duplicate a line to pad.
    """
    text = re.sub(r"\s+", " ", text.strip())
    words = text.split()
    if not words:
        return ["It lives in", "grass or caves", "near trainers."]
    n = len(words)
    if n >= 3:
        candidates: list[tuple[int, int, int, int, str, str, str]] = []
        for i in range(1, n):
            for j in range(i + 1, n + 1):
                g1 = " ".join(words[:i])
                g2 = " ".join(words[i:j])
                g3 = " ".join(words[j:])
                if not g3:
                    continue
                if (
                    len(g1) <= MAX_LINE
                    and len(g2) <= MAX_LINE
                    and len(g3) <= MAX_LINE
                ):
                    if g1 == g2 or g2 == g3 or g1 == g3:
                        continue
                    lg1, lg2, lg3 = len(g1), len(g2), len(g3)
                    shortest = min(lg1, lg2, lg3)
                    balance = -(lg1 - lg2) ** 2 - (lg2 - lg3) ** 2 - (lg1 - lg3) ** 2
                    candidates.append((shortest, balance, i, j, g1, g2, g3))
        if candidates:
            candidates.sort(key=lambda t: (t[0], t[1]), reverse=True)
            _, _, _, _, g1, g2, g3 = candidates[0]
            return [g1, g2, g3]
        for i in range(1, n):
            for j in range(i + 1, n + 1):
                g1 = " ".join(words[:i])
                g2 = " ".join(words[i:j])
                g3 = " ".join(words[j:])
                if (
                    g3
                    and len(g1) <= MAX_LINE
                    and len(g2) <= MAX_LINE
                    and len(g3) <= MAX_LINE
                ):
                    return [g1, g2, g3]
    if n == 2:
        w0, w1 = words[0], words[1]
        if len(w0) <= MAX_LINE and len(w1) <= MAX_LINE:
            return [w0, w1, "Still hunting."]
        return [words[0][:MAX_LINE], words[1][:MAX_LINE], "Still hunting."]
    if n == 1:
        w = words[0]
        if len(w) <= MAX_LINE:
            return [w, "It still roams", "this wide land."]
        return [w[:MAX_LINE], w[MAX_LINE : MAX_LINE * 2][:MAX_LINE], "Wild still."]
    return ["It lives", "in this land", "without fear."]


def blurb_to_three_lines(blurb: str) -> list[str]:
    """
    Build one Pokédex page: prefer full sentences that fit in 3 lines;
    if the first sentence is too long, use greedy word fitting (never
    mid-comma fragments like 'something, its.').
    """
    blurb = re.sub(r"\s+", " ", blurb.strip())
    if not blurb:
        return ["It lives in", "the wild and", "avoids people."]

    sentences = [s.strip() for s in re.split(r"(?<=[.!?])\s+", blurb) if s.strip()]
    if not sentences:
        sentences = [blurb]

    acc_text = sentences[0]
    for extra in sentences[1:]:
        trial = (acc_text + " " + extra).strip()
        if len(wrap_words(trial, MAX_LINE)) <= 3:
            acc_text = trial
        else:
            break

    if len(wrap_words(acc_text, MAX_LINE)) > 3:
        acc_text = fit_words_to_three_lines(sentences[0])

    return repartition_three_lines(acc_text)


def build_six_lines(sword: str, shield: str) -> list[str]:
    """Page 1 = Sword blurb (3 lines), page 2 = Shield blurb (3 lines)."""
    if not sword:
        sword = shield or "It lives by instinct."
    if not shield:
        shield = sword
    p1 = blurb_to_three_lines(sword)
    p2 = blurb_to_three_lines(shield)
    out = p1[:3] + p2[:3]
    for i in range(6):
        if len(out[i]) > MAX_LINE:
            out[i] = out[i][: MAX_LINE - 1] + "-"
    return out


def asm_escape(s: str) -> str:
    s = (
        s.replace("\u2019", "'")
        .replace("\u2018", "'")
        .replace("\u201c", '"')
        .replace("\u201d", '"')
    )
    return s.replace('"', "'")


def format_asm(category: str, h: int, w: int, lines: list[str]) -> str:
    cat = category[:MON_NAME_CHARS] + "@"
    l0, l1, l2, l3, l4, l5 = (asm_escape(x) for x in lines)
    return (
        f'\tdb "{cat}" ; category name\n'
        f"\tdw {h}, {w} ; height, weight\n"
        f"\n"
        f'\tdb   "{l0}"\n'
        f'\tnext "{l1}"\n'
        f'\tnext "{l2}"\n'
        f"\n"
        f'\tpage "{l3}"\n'
        f'\tnext "{l4}"\n'
        f'\tnext "{l5}@"\n'
    )


# When pokemondb species names truncate poorly for MON_NAME (≤10).
CATEGORY_OVERRIDES: dict[str, str] = {
    "yanmega": "OGRE DARN",
}


# slug -> optional manual overrides when URL differs
SLUG_MAP = {
    "porygon_z": "porygon-z",
    "armarogue": "armarouge",
}

# Species with no pokemondb page — full manual asm body without fetch
MANUAL = {
    "mesmeria": (
        '\tdb "TRANCE@@@@" ; category name\n'
        "\tdw 411, 1146 ; height, weight\n"
        "\n"
        '\tdb   "Its icy stare"\n'
        '\tnext "can dull the"\n'
        '\tnext "will of foes."\n'
        "\n"
        '\tpage "Legends say it"\n'
        '\tnext "reflects moonlight"\n'
        '\tnext "into waking dreams.@"\n'
    ),
    "drunsparce": (
        '\tdb "LAND SNAKE@" ; category name\n'
        "\tdw 709, 5291 ; height, weight\n"
        "\n"
        '\tdb   "Its massive frame"\n'
        '\tnext "shakes the earth"\n'
        '\tnext "when it tunnels."\n'
        "\n"
        '\tpage "Older locals swear"\n'
        '\tnext "they feel tremors"\n'
        '\tnext "before it surfaces.@"\n'
    ),
}


def write_entry(base: str, slug: str | None = None) -> None:
    slug = slug or SLUG_MAP.get(base, base.replace("_", "-"))
    path = DEX_DIR / f"{base}.asm"
    if base in MANUAL:
        path.write_text(MANUAL[base] + "\n", encoding="utf-8")
        print(f"manual {base}")
        return
    html = fetch_html(slug)
    cat = parse_category(html)
    cat = CATEGORY_OVERRIDES.get(base, cat)
    hd = parse_height_dw(html)
    wd = parse_weight_dw(html)
    if base in BRIEF_DEX:
        sword, shield = BRIEF_DEX[base]
    else:
        sword, shield = parse_sword_shield(html)
    if not sword and not shield:
        # Scarlet/Violet only mons — try first Scarlet entry
        m = re.search(
            r'<span class="igame scarlet">Scarlet</span></th>\s*'
            r'<td class="cell-med-text">([^<]+)</td>',
            html,
        )
        if m:
            sword = m.group(1).strip()
        m2 = re.search(
            r'<span class="igame violet">Violet</span></th>\s*'
            r'<td class="cell-med-text">([^<]+)</td>',
            html,
        )
        if m2:
            shield = m2.group(1).strip()
    if not sword:
        sword = shield or "It battles fiercely."
    if not shield:
        shield = sword
    lines = build_six_lines(sword, shield)
    text = format_asm(cat, hd, wd, lines)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")
    print(f"ok {base} ({slug})")


ALL_BASES = [
    "gurdurr",
    "deino",
    "farigiraf",
    "golett",
    "tangrowth",
    "baxcalibur",
    "venipede",
    "porygon_z",
    "glaceon",
    "dusknoir",
    "arctibax",
    "gliscor",
    "volcarona",
    "leafeon",
    "frigibax",
    "salamence",
    "impidimp",
    "larvesta",
    "ralts",
    "electivire",
    "tinkatuff",
    "cradily",
    "ceruledge",
    "ursaluna",
    "annihilape",
    "dusclops",
    "grimmsnarl",
    "lickilicky",
    "yanmega",
    "armarogue",
    "sylveon",
    "weavile",
    "lileep",
    "dreepy",
    "duskull",
    "tinkaton",
    "timburr",
    "morgrem",
    "shelgon",
    "charcadet",
    "magmortar",
    "wyrdeer",
    "mamoswine",
    "mismagius",
    "golurk",
    "drakloak",
    "whirlipede",
    "kirlia",
    "hydreigon",
    "ambipom",
    "conkeldurr",
    "mesmeria",
    "drunsparce",
    "tinkatink",
    "bagon",
    "scolipede",
    "gardevoir",
    "armaldo",
    "zweilous",
    "dragapult",
    "magnezone",
    "rhyperior",
    "togekiss",
]


def main() -> None:
    delay = 0.35
    failures: list[str] = []
    for base in ALL_BASES:
        try:
            write_entry(base)
        except Exception as e:
            failures.append(f"{base}: {e}")
            print(f"FAIL {base}: {e}", file=sys.stderr)
        time.sleep(delay)
    if failures:
        print("\nFailures:", file=sys.stderr)
        for f in failures:
            print(f, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

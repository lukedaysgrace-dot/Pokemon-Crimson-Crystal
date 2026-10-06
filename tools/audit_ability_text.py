#!/usr/bin/env python3
"""Check ability banners/descriptions and expanded ability battle messages.

Unlike the literal-line audit, this follows adjacent text/text_ram fragments
and expands the longest enemy nickname and each dynamic name's actual table.
The emulator runner additionally checks the destination of rendered glyphs.
"""

import re

from audit_game_data import ROOT, encoded_length, parse_charmap


def main():
    tokens = parse_charmap()
    errors = []
    checked = 0

    def width(value):
        total = 0
        while value:
            token = next((token for token in tokens if value.startswith(token)), None)
            if token is None:
                raise ValueError(f"unknown text encoding in {value!r}")
            value = value[len(token):]
            total += {"@": 0, "<USER>": 16, "<TARGET>": 16,
                      "<PKMN>": 2, "<POKE>": 4, "#": 4,
                      "<……>": 2}.get(token, 1)
        return total

    maxima = {}
    for category, relative_path in (
            ("ability", "data/abilities/names.asm"),
            ("move", "data/moves/names.asm"),
            ("item", "data/items/names.asm")):
        names = re.findall(r'^\s*db "([^"\n]+)@"',
                           (ROOT / relative_path).read_text(encoding="utf-8"), re.MULTILINE)
        maxima[category] = max(width(name) for name in names)
        if category == "ability":
            for name in names:
                checked += 1
                if width(name) > 16:
                    errors.append(f"ability banner clips {name!r}")
    # Ten nickname glyphs plus the single-tile 's contraction fit the banner.
    assert 10 + encoded_length("'s", tokens) <= 16
    dynamic_categories = {"TraceActivationText": "ability",
                          "IntimidateResistedText": "ability",
                          "CursedBodyDisabledText": "move",
                          "ForewarnAlertText": "move"}
    for relative_path in ("data/text/ability_text.asm", "data/abilities/descriptions.asm"):
        label, current_width = "", 0
        for line_number, line in enumerate((ROOT / relative_path).read_text(encoding="utf-8").splitlines(), 1):
            match = re.match(r"^(\w+)::?", line)
            if match:
                label, current_width = match[1], 0
            match = re.match(r'^\s*(text|line|cont|para|next) "([^"]*)"', line)
            if match:
                checked += 1
                if match[1] != "text":
                    current_width = 0
                current_width += width(match[2])
            elif re.match(r"\s*text_ram\b", line):
                current_width += maxima[dynamic_categories.get(label, "item")]
            else:
                continue
            if current_width > 18:
                errors.append(f"{relative_path}:{line_number}: {label} reaches {current_width} cells")
    for error in errors:
        print(error)
    if not errors:
        print(f"ABILITY TEXT AUDIT PASSED: {checked} banner/text fragments; expanded messages fit 18 cells")
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())

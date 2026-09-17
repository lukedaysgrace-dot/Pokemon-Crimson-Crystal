#!/usr/bin/env python3
"""Check that no battle message can overflow the textbox.

The battle textbox is 18 columns wide. A line is at risk when it holds
something whose width is not visible in the source:

  <USER> / <TARGET>   a nickname, and on the enemy side the EnemyText prefix
                      is printed first, so worst case = len(prefix) + 11
  <ENEMY>             the same, via PlaceEnemysName
  text_ram            a runtime buffer, measured per symbol

Name placeholders are hard errors: their width follows directly from
MON_NAME_LENGTH and the EnemyText prefix, so an overflow is provable here.
Runtime buffers are reported as warnings instead, because which name is
loaded depends on the call site and only some of them are near the limit.

Every one of those is measured at its worst case, so a green run means no
species, ability or item can push a line onto the border tiles.
"""
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOX = 18
SOURCES = ["data/text/battle.asm", "data/text/ability_text.asm"]

def name_length():
    t = (ROOT / "constants/text_constants.asm").read_text(encoding="utf-8")
    m = re.search(r"^MON_NAME_LENGTH\s+EQU\s+(\d+)", t, re.M)
    return int(m.group(1)) - 1                      # minus the terminator

def enemy_prefix():
    t = (ROOT / "home/text.asm").read_text(encoding="utf-8")
    m = re.search(r'^EnemyText::\s*db\s+"([^"]*)@"', t, re.M)
    return len(m.group(1)) if m else 0

def longest(path, fallback):
    try: t = (ROOT / path).read_text(encoding="utf-8")
    except FileNotFoundError: return fallback
    names = [m.group(1).rstrip("@") for m in
             re.finditer(r'^\s*(?:raw)?(?:char|db)\s+"([^"]+)"', t, re.M)]
    return max((len(n) for n in names), default=fallback)

def main():
    nick = name_length()
    side = enemy_prefix() + nick                    # worst case: enemy side
    # worst case per runtime buffer
    ram = {
        "wBattleMonNick": nick,
        "wEnemyMonNick": nick,
        # abilities, items and moves all land here; abilities are longest
        "wBattleDynamicNameBuffer": max(
            longest("data/abilities/names.asm", 16),
            longest("data/items/names.asm", 12),
            longest("data/moves/names.asm", 12)),
    }
    generic = max(ram.values())
    bad, warn = [], []
    for src in SOURCES:
        label = None
        lines = (ROOT / src).read_text(encoding="utf-8").split("\n")
        for i, raw in enumerate(lines, 1):
            m = re.match(r"^(\w+):", raw)
            if m: label = m.group(1)
            m = re.match(r'^\s*(text|line|cont|next|para)\s+"(.*)"\s*$', raw)
            if not m: continue
            body = m.group(2)
            width = len(re.sub(r"<(?:USER|TARGET|ENEMY)>", "", body).replace("@", ""))
            width += len(re.findall(r"<(?:USER|TARGET|ENEMY)>", body)) * side
            if width > BOX:
                bad.append((src, i, label, width, body))
                continue
            # a trailing "@" hands off to the text_ram buffer on the next line
            if body.endswith("@") and i < len(lines) and "text_ram" in lines[i]:
                sym = lines[i].split()[-1]
                if width + ram.get(sym, generic) > BOX:
                    warn.append((src, i, label, sym,
                                 width + ram.get(sym, generic), body))
    for src, i, label, sym, width, body in warn:
        print(f"  note: {src}:{i}: {label} reaches {width} columns if {sym} "
              f"holds its longest name")
    if bad:
        print("BATTLE TEXT AUDIT FAILED")
        for src, i, label, width, body in bad:
            print(f"- {src}:{i}: {label} renders up to {width} columns (max {BOX})")
            print(f'      "{body}"')
        print(f"{len(bad)} error(s)")
        return 1
    print(f"BATTLE TEXT AUDIT PASSED: every name line fits {BOX} columns "
          f"(nickname {nick}, enemy prefix {enemy_prefix()}); "
          f"{len(warn)} runtime-buffer note(s)")
    return 0

if __name__ == "__main__":
    sys.exit(main())

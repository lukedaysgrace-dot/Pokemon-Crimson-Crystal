#!/usr/bin/env bash
set -euo pipefail
editor_root=$(cd "$(dirname "$0")/.." && pwd)
crimson_root=${1:-"$editor_root/.."}
bash "$editor_root/tools/toolchain/install-rgbds.sh"
make -C "$crimson_root" RGBDS="$editor_root/.toolchain/rgbds/bin/" -j2 pokecrystal.gbc debug
python3 "$crimson_root/tools/audit_save.py"

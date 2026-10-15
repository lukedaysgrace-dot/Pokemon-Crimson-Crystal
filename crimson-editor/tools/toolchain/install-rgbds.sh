#!/usr/bin/env bash
set -euo pipefail
editor_root=$(cd "$(dirname "$0")/../.." && pwd)
prefix="$editor_root/.toolchain/rgbds"
if [[ -x "$prefix/bin/rgbasm" ]] && "$prefix/bin/rgbasm" --version | grep -q 'v0.5.2'; then exit 0; fi
mkdir -p "$editor_root/.toolchain"
if [[ ! -d "$editor_root/.toolchain/rgbds-src/.git" ]]; then
  git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds.git "$editor_root/.toolchain/rgbds-src"
fi
make -C "$editor_root/.toolchain/rgbds-src" -j2
make -C "$editor_root/.toolchain/rgbds-src" install PREFIX="$prefix"

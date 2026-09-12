#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed base-devel cmake
}

check() {
  command -v make >/dev/null 2>&1 &&
    command -v gcc >/dev/null 2>&1 &&
    command -v cmake >/dev/null 2>&1
}

provision "$@"

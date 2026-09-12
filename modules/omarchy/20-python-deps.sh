#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  openssl
  zlib
  bzip2
  readline
  sqlite
  tk
  gdbm
  xz
  libffi
  libxml2
  libxslt
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"
}

check() {
  pacman -Q "${packages[@]}" >/dev/null 2>&1
}

provision "$@"

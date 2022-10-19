#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

declare -A packages
packages=(
  ["zoxide"]="zoxide"
)

run() {
  for pkg in "${packages[@]}"; do
    cargo install "$pkg" --locked
  done
}

check() {
  for exe in "${!packages[@]}"; do
    [ -x "$HOME/.cargo/bin/$exe" ] || return 1
  done
}

provision "$@"

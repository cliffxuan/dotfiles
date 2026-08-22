#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

declare -A packages
packages=(
  ["bt"]="github.com/cliffxuan/bt"
)

run() {
  for pkg in "${packages[@]}"; do
    go install "$pkg@latest"
  done
  if command -v mise >/dev/null 2>&1; then
    mise reshim
  fi
}

check() {
  for exe in "${!packages[@]}"; do
    command -v "$exe" >/dev/null 2>&1 || return 1
  done
}

provision "$@"

#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

declare -A packages
packages=(
  ["prettier"]="prettier"
  ["bun"]="bun"
  ["tsc"]="typescript"
  ["eslint"]="eslint"
)
LOCAL=$HOME/.local

run() {
  for pkg in "${packages[@]}"; do
    npm install -g "$pkg"
  done
}

check() {
  for exe in "${!packages[@]}"; do
    [ -x "$LOCAL/bin/$exe" ] || return 1
  done
}

provision "$@"

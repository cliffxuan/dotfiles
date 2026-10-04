#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

# CLI tools installed as isolated apps via uv tool
# map executable -> package name
declare -A tools
tools=(
  ["http"]="httpie"
  ["pynvim-python"]="pynvim"
  ["ruff"]="ruff"
)

run() {
  for exe in "${!tools[@]}"; do
    local pkg="${tools[$exe]}"
    uv tool install --force "$pkg"
  done
}

check() {
  command -v uv >/dev/null 2>&1 || return 1
  for exe in "${!tools[@]}"; do
    command -v "$exe" >/dev/null 2>&1 || [ -x "$HOME/.local/bin/$exe" ] || return 1
  done
}

provision "$@"

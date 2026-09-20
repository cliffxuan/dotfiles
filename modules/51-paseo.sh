#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install npm:@getpaseo/cli
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install npm:@getpaseo/cli
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v paseo >/dev/null 2>&1 && [ ! -x "$HOME/.local/share/mise/installs/npm-getpaseo-cli/latest/node_modules/.bin/paseo" ]; then
    echo "paseo binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.zfunc"
  ln -sf "$BASE_DIR/completions/_paseo" "$HOME/.zfunc/_paseo"
}

check() {
  (command -v paseo >/dev/null 2>&1 || { command -v mise >/dev/null 2>&1 && mise which paseo >/dev/null 2>&1; }) &&
    [ -s "$HOME/.zfunc/_paseo" ]
}

provision "$@"

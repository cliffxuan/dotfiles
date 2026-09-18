#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install grok
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install grok
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v grok >/dev/null 2>&1 && [ ! -x "$HOME/.local/share/mise/installs/grok/latest/grok" ]; then
    echo "grok binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.zfunc"
  ln -sf "$BASE_DIR/completions/_grok" "$HOME/.zfunc/_grok"
}

check() {
  command -v grok >/dev/null 2>&1 &&
    [ -s "$HOME/.zfunc/_grok" ]
}

provision "$@"

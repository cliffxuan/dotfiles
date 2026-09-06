#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  if ! command -v "mise" >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
    curl https://mise.run | sh
  fi

  # Ensure ~/.config/mise/config.toml is linked/available before running install
  mkdir -p "$HOME/.config/mise"
  ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  export PATH="$HOME/.local/bin:$PATH"
  local mise_bin
  mise_bin="$(command -v mise 2>/dev/null || echo "$HOME/.local/bin/mise")"
  "$mise_bin" install --yes
}

check() {
  local mise_bin
  mise_bin="$(command -v mise 2>/dev/null || echo "$HOME/.local/bin/mise")"
  [ -x "$mise_bin" ] &&
    [ -e "$HOME/.config/mise/config.toml" ] &&
    [ "$("$mise_bin" ls --missing --json 2>/dev/null)" = "{}" ]
}

provision "$@"

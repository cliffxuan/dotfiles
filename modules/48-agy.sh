#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install antigravity-cli
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install antigravity-cli
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v agy >/dev/null 2>&1 && [ ! -x "$HOME/.local/share/mise/installs/antigravity-cli/latest/agy" ]; then
    echo "agy binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.zfunc"
  ln -sf "$BASE_DIR/completions/_agy" "$HOME/.zfunc/_agy"
  ln -sf "$BASE_DIR/completions/_agy" "$HOME/.zfunc/_antigravity"

  mkdir -p "$HOME/.zinit/completions"
  ln -sf "$HOME/.zfunc/_agy" "$HOME/.zinit/completions/_agy"
  ln -sf "$HOME/.zfunc/_agy" "$HOME/.zinit/completions/_antigravity"
}

check() {
  command -v agy >/dev/null 2>&1 &&
    [ -s "$HOME/.zfunc/_agy" ] &&
    [ -e "$HOME/.zinit/completions/_agy" ] &&
    [ -s "$HOME/.zfunc/_antigravity" ] &&
    [ -e "$HOME/.zinit/completions/_antigravity" ]
}

provision "$@"

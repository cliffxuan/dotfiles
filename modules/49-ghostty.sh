#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  if [ -L "$HOME/.config/ghostty" ]; then
    rm -f "$HOME/.config/ghostty"
  fi
  mkdir -p "$HOME/.config/ghostty"
  ln -sf "$CONFIG_DIR/ghostty/config" "$HOME/.config/ghostty/config"

  if [[ "$OSTYPE" == darwin* ]] && [ -f "$CONFIG_DIR/ghostty/mac.conf" ]; then
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    ln -sf "$CONFIG_DIR/ghostty/mac.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/mac.conf"
  fi
}

check() {
  [ -L "$HOME/.config/ghostty/config" ] || return 1

  if [[ "$OSTYPE" == darwin* ]] && [ -f "$CONFIG_DIR/ghostty/mac.conf" ]; then
    [ -L "$HOME/Library/Application Support/com.mitchellh.ghostty/mac.conf" ] || return 1
  fi

  return 0
}

provision "$@"

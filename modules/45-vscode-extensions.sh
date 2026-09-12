#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

settings=(
  settings.json
  keybindings.json
  snippets
)

get_os # set $OS
if [[ $OS =~ Darwin ]]; then
  config_dir="$HOME/Library/Application Support/Code/User/"
else
  config_dir="$HOME/.config/Code/User/"
fi

run() {
  mkdir -p "$config_dir"
  if [ -f "$CONFIG_DIR/vscode/extensions" ]; then
    while IFS= read -r extension; do
      [ -n "$extension" ] && code --install-extension "$extension"
    done <"$CONFIG_DIR/vscode/extensions"
  fi
  for item in "${settings[@]}"; do
    ln -sf "$CONFIG_DIR/vscode/$item" "$config_dir/$item"
  done
}

check() {
  if ! command -v code >/dev/null 2>&1; then
    return 0
  fi
  [ -d "$config_dir" ] || return 1
  for item in "${settings[@]}"; do
    [ -e "$config_dir/$item" ] || return 1
  done
}

provision "$@"

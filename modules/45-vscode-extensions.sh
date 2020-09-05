#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

settings=(
  settings.json
  keybindings.json
)

get_os  # set $OS
if [[ $OS =~ Darwin ]]; then
  config_dir="$HOME/Library/Application Support/Code/User/"
else
  config_dir="$HOME/.config/Code/User/"
fi

run() {
  while IFS= read -r extension; do
    code --install-extension "$extension"
  done < "$CONFIG_DIR/vscode/extensions"
  for file in "${settings[@]}"
  do
    ln -sf "$CONFIG_DIR/vscode/$file" "$config_dir"
  done
}

check() {
  if command -v code; then
    run
  fi
}

provision "$@"

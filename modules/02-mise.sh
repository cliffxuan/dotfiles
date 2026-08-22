#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  curl https://mise.run | sh
  
  # Ensure ~/.config/mise/config.toml is linked/available before running install
  mkdir -p "$HOME/.config/mise"
  ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  export PATH="$HOME/.local/bin:$PATH"
  "$HOME/.local/bin/mise" install --yes
}

check() {
  command -v "mise" >/dev/null 2>&1 || [ -x "$HOME/.local/bin/mise" ]
}

provision "$@"

#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config"
  ln -sfn "$CONFIG_DIR/lf" "$HOME/.config/lf"
}

check() {
  [[ -d $HOME/.config/lf ]]
}

provision "$@"

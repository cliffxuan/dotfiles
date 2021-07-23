#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  ln -sf "$CONFIG_DIR/lf" "$HOME/.config"
}

check() {
  [[ -d $HOME/.config/lf ]]
}

provision "$@"

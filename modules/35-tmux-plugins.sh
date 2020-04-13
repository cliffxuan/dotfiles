#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"

run() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]
  then
    echo "clone tmux plugin manager"
    mkdir -p "$HOME"/.tmux/plugins
    cd "$HOME"/.tmux/plugins || exit 1
    git clone https://github.com/tmux-plugins/tpm
    "$HOME"/.tmux/plugins/tpm/bin/install_plugins
  fi
}

check() {
  run
}


provision "installed ok!"

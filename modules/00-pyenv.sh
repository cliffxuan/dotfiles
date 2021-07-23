#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
PYENV_ROOT="$HOME/.pyenv"


run() {
  git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
  sudo "$PYENV_ROOT/plugins/python-build/install.sh"
}

check() {
  command -v "python-build"  > /dev/null 2>&1
}


provision "$@"

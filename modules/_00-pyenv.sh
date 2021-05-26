#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
PYENV_ROOT="$HOME/.pyenv"


run() {
  git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
  git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git \
    "$PYENV_ROOT/plugins/pyenv-virtualenvwrapper"
}

check() {
  command -v "$PYENV_ROOT/bin/pyenv"  > /dev/null 2>&1
}


provision "$@"

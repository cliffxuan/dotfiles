#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
pyenv="$HOME/.pyenv/bin/pyenv"
version="3.9.1"


run() {
  if ! $pyenv versions | grep -q "$version"; then
    PYTHON_CONFIGURE_OPTS="--enable-shared" $pyenv install "$version"
  fi
  $pyenv global "$version"
}


check() {
  $pyenv global | grep -q "$version"
}


provision "$@"

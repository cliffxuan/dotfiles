#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  for file in "$CONFIG_DIR"/virtualenvwrapper/*
  do
    ln -sf "$file" "$HOME/.virtualenvs/"
  done
}

check() {
  run
}

provision "$@"

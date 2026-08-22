#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

# CLI tools installed as isolated apps via uv tool
tools="httpie pynvim"

# Linters/formatters — ruff replaces flake8, black, autoflake
# pyright is installed via npm (see 70-npm-packages.sh)

run() {
  for tool in $tools
  do
    uv tool install "$tool"
  done
  uv tool install ruff
}

check() {
  command -v ruff > /dev/null 2>&1
}

provision "$@"

#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
version=${PYTHON_VERSION:-3.14}

run() {
  uv python install --default "$version"
}

check() {
  uv python find "$version" >/dev/null 2>&1 && [[ "$("$HOME/.local/bin/python" --version 2>&1)" =~ Python\ $version ]]
}

provision "$@"

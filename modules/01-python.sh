#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
version=${PYTHON_VERSION:-3.14}


run() {
  uv python install "$version"
}

check() {
  uv python find "$version" > /dev/null 2>&1
}


provision "$@"

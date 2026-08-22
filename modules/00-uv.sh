#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"


run() {
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

check() {
  command -v "uv" > /dev/null 2>&1
}


provision "$@"

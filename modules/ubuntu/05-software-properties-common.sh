#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo apt-get install -y software-properties-common
}

check() {
  hash add-apt-repository 2>/dev/null || return 1
}

provision "$@"

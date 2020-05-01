#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  pip3 install -U pip
}

check() {
  run 2>&1 | grep -q "Requirement already up-to-date"
}

provision "$@"

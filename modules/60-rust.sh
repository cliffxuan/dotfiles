#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  curl https://sh.rustup.rs -sSf | sh -s -- -y
}

check() {
  "$HOME/.cargo/bin/rustc"
}

provision "$@"

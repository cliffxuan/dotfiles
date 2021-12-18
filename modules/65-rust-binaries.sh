#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"


run() {
  cargo install cargo-edit
}

check() {
  "$HOME/.cargo/bin/cargo add"
}

provision "$@"

#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  rustup component add rust-analyzer --toolchain stable
  ln -s "$(rustup which --toolchain stable rust-analyzer)" ~/.local/bin/
}

check() {
  [[ -x ~/.local/bin/rust-analyzer ]]
}

provision "$@"

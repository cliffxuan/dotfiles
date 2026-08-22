#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  rustup component add rust-analyzer --toolchain stable
  local ra_path
  ra_path=$(rustup which --toolchain stable rust-analyzer 2>/dev/null)
  if [ -n "$ra_path" ]; then
    ln -sf "$ra_path" "$HOME/.local/bin/rust-analyzer"
  fi
}

check() {
  command -v rust-analyzer >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/rust-analyzer" ]]
}

provision "$@"

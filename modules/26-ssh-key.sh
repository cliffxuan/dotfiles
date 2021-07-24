#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"
KEY="$BASE_DIR/keys/id_rsa.pub"

run() {
  cat "$KEY" >> "$HOME/.ssh/authorized_keys"
}

check() {
  grep -q "$(cat "$KEY")" ~/.ssh/authorized_keys
}


provision "$@"

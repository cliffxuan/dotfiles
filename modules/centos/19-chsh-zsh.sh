#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  if ! grep -q "/usr/local/bin/zsh" /etc/shells 2>&1 ; then
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
  fi
  sudo chsh -s "/usr/local/bin/zsh" "$USER"
}


check() {
  grep -qE "$USER.*/usr/local/bin/zsh" /etc/passwd 2>/dev/null
}


provision "$@"

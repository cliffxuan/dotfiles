#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"

run() {
  mkdir -p "$HOME/.zinit"
  if [ -d "$HOME/.zinit/bin" ]; then
    echo "zinit already exists"
  else
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
  fi
  if ! grep -qE "^$(whoami):.*zsh" /etc/passwd 2>/dev/null; then
    if command -v zsh >/dev/null 2>&1 && sudo chsh -s "$(command -v zsh)" "$(whoami)"; then
      echo "changed default shell to zsh"
    else
      echo "unable to change default shell to zsh"
    fi
  fi
  if command -v zsh >/dev/null 2>&1 && [ -f "$HOME/.zshrc" ]; then
    zsh -c "source $HOME/.zshrc"
  fi
}

check() {
  [ -d "$HOME/.zinit/bin" ] &&
    command -v zsh >/dev/null 2>&1 &&
    grep -qE "^$(whoami):.*zsh" /etc/passwd 2>/dev/null
}

provision "$@"

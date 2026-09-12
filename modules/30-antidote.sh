#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"

run() {
  if [ -d "$HOME/.antidote" ]; then
    echo "antidote already exists"
  else
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
  fi

  if ! grep -qE "^$(whoami):.*zsh" /etc/passwd 2>/dev/null; then
    if command -v zsh >/dev/null 2>&1 && sudo chsh -s "$(command -v zsh)" "$(whoami)"; then
      echo "changed default shell to zsh"
    else
      echo "unable to change default shell to zsh"
    fi
  fi

  # Compile plugins if antidote and plugins list are present
  if command -v zsh >/dev/null 2>&1 && [ -f "$HOME/.zsh_plugins.txt" ]; then
    zsh -c 'source "$HOME/.antidote/antidote.zsh" && antidote bundle < "$HOME/.zsh_plugins.txt" > "$HOME/.zsh_plugins.zsh" && zcompile "$HOME/.zsh_plugins.zsh"'
  fi
}

check() {
  [ -d "$HOME/.antidote" ] &&
    [ -f "$HOME/.antidote/antidote.zsh" ] &&
    command -v zsh >/dev/null 2>&1 &&
    grep -qE "^$(whoami):.*zsh" /etc/passwd 2>/dev/null
}

provision "$@"

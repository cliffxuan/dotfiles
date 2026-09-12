#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=utils.sh
source "$BASE_DIR/utils.sh"

is_default_shell_zsh() {
  local user_shell=""
  if command -v dscl >/dev/null 2>&1; then
    user_shell=$(dscl . -read "/Users/$(whoami)" UserShell 2>/dev/null | awk '{print $2}')
  elif command -v getent >/dev/null 2>&1; then
    user_shell=$(getent passwd "$(whoami)" 2>/dev/null | cut -d: -f7)
  elif [ -f /etc/passwd ]; then
    user_shell=$(grep -E "^$(whoami):" /etc/passwd 2>/dev/null | cut -d: -f7)
  fi

  if [ -z "$user_shell" ]; then
    user_shell="$SHELL"
  fi

  [[ "$user_shell" =~ zsh$ ]]
}

run() {
  if [ -d "$HOME/.antidote" ]; then
    echo "antidote already exists"
  else
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
  fi

  if ! is_default_shell_zsh; then
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
    is_default_shell_zsh
}

provision "$@"
